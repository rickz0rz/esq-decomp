#!/usr/bin/env python3
"""Report restoration progress by BYTES, and pick the next targets.

    python3 tools/coverage.py            # progress summary
    python3 tools/coverage.py --targets  # + the next targets, largest first

Function count flatters progress: small leaf routines are easy and numerous, so
a high count can sit on a tiny fraction of the program. Bytes are what actually
gets reconstructed, so that is what this reports.

Targets are ranked by how likely they are to become byte-exact once the original
compiler is identified, not just by size. The key split is how a function's calls
were encoded in the original (see docs/compiler-version.md):

  cross-unit   every call is 4EBA, JSR (d16,PC) -- the encoding the original used
               for a callee in another translation unit.
  intra-unit   contains a BSR.W (6100) to a nearby callee, which means that callee
               shared a .c file with it.

The names describe the ORIGINAL, not our chances. This docstring used to claim
cross-unit was "pre-positioned to match", reasoning that a one-function-per-file
restoration emits only cross-unit calls. The reasoning is fine; the premise is
not. SAS/C 6.51 emits BSR.W for EVERY call regardless of the callee, so our
output lines up with the 6100 bucket, not the 4EBA one:

    intra-unit  11 exact / 57 behavioural    16%
    no-calls    11 exact / 109 behavioural    9%
    cross-unit   0 exact / 144 behavioural    0%   <-- capped by the call opcode

--targets therefore ranks intra-unit and no-calls, and withholds cross-unit
behind --cross-unit. See AGENTS.md, "Progress is measured in BYTES".
"""
import os, re, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(ROOT, 'tools'))
import candidates as C
from screen_candidates import blockers

# Shapes a C replacement cannot express at all (AGENTS.md, "Six shapes a C
# replacement cannot express"). Screened out of the target list entirely.
BLOCKERS_HARD = {'register-args', 'live-register-on-entry', 'interior-label',
                 'rotate-instruction', 'tail-jump', 'predecrement-store',
                 'falls-through'}


def survey():
    table = C.parse_listing()
    done = {}
    cdir = os.path.join(ROOT, 'src', 'c')
    for f in sorted(os.listdir(cdir)):
        if not f.endswith('.c'):
            continue
        txt = open(os.path.join(cdir, f)).read()
        m = re.search(r'RESTORES:\s*(\S+)', txt)
        s = re.search(r'STATUS:\s*(\S+)', txt)
        if m:
            done[m.group(1).lstrip('_')] = (s.group(1).lower() if s else 'unknown')

    fns = []
    for label, (srcf, hexb, lines) in table.items():
        if not hexb or label.endswith('_Return'):
            continue
        if not srcf.startswith('modules/groups') or 'JMPTBL' in label:
            continue
        body = '\n'.join(lines[1:])
        if 'RTS' not in body and 'JMP' not in body:
            continue
        # Keep the REAL label. Stripping the underscore was only ever meant to
        # match src/c RESTORES entries, but the target list is also fed straight
        # to refbytes.py and tools/cdiff.sh, which need the label as it appears in
        # the assembly. Track both.
        name = label
        done_key = label.lstrip('_')
        blob = bytes.fromhex(hexb)
        # An "interior label": reached by branch or fall-through from inside a
        # larger routine, so it uses the ENCLOSING function's A5 frame and has no
        # prologue of its own. DISKIO1_DumpDefaultCoiInfoBlock is the worked
        # example -- it opens with MOVEQ and then reads -14(A5). These are not
        # functions and cannot be restored as C; a C function would build its own
        # frame and the A5 references would address nothing.
        if '(A5)' in body and 'LINK.W  A5' not in body:
            fns.append({'name': name, 'src': srcf, 'size': len(blob),
                        'kind': 'interior', 'status': done.get(done_key),
                        'blockers': ['interior-label']})
            continue
        # BSR.S counts too: a two-byte branch can only reach a nearby callee, so
        # it is just as much an intra-unit call as BSR.W. Matching only BSR.W
        # mis-filed ESQDISP_QueueHighlightDrawMessage as cross-unit.
        # A predecrement store (`MOVE.x src,-(An)`) is how the original fills a
        # buffer back-to-front. SAS/C never emits -(An) for a store, so any
        # function doing this repeatedly cannot be matched -- see
        # esq_format_time_stamp.c. Excludes stack pushes onto A7, which are
        # ordinary argument passing and reproduce fine.
        pre = len(re.findall(r',-\(A[0-6]\)', body))
        if pre >= 3:
            fns.append({'name': name, 'src': srcf, 'size': len(blob),
                        'kind': 'predecrement', 'status': done.get(done_key),
                        'blockers': ['predecrement-store']})
            continue
        # A register-argument helper: the entry MOVEM preserves D0/D1/A0/A1, which
        # are scratch in every C calling convention -- no compiler saves the
        # registers its arguments arrive in. These are hand-written assembly called
        # from assembly, and SAS/C cannot express them even with __asm register
        # parameters, because __asm still copies the arguments into its OWN
        # callee-saved registers rather than working in place. Verified against
        # ESQSHARED4_CopyBannerRowsWithByteOffset and its two siblings.
        m = re.search(r'^\s*MOVEM\.L\s+(\S+),-\(A7\)', body, re.M)
        if m and re.search(r'\b(D0|D1|A0|A1)\b', m.group(1).replace('-', ' ').replace('/', ' ')):
            fns.append({'name': name, 'src': srcf, 'size': len(blob),
                        'kind': 'register-args', 'status': done.get(done_key),
                        'blockers': ['register-args']})
            continue
        # An interior label in the ADDRESS-register sense: the body uses an address
        # register as a live input before ever loading it, so it is entered with
        # that register already set by whoever branched here. The (A5) check above
        # catches the frame-pointer form; this catches the rest.
        # ESQSHARED4_SetBannerCopperColorAndThreshold opens `MOVE.B D0,(A4)`.
        first = next((l for l in lines[1:] if l.strip() and not l.strip().startswith(';')), '')
        m2 = re.search(r'\((A[0-4])\)', first)
        if m2 and not re.search(r'(LEA|MOVEA\.L)\s+\S+,' + m2.group(1), body[:body.index(first)] or ' '):
            fns.append({'name': name, 'src': srcf, 'size': len(blob),
                        'kind': 'interior', 'status': done.get(done_key),
                        'blockers': ['live-register-on-entry']})
            continue
        # A rotate. C has no rotate operator and SAS/C emits none, so a function
        # containing ROL/ROR/ROXL/ROXR was written by hand. Narrow by measurement:
        # exactly two functions program-wide contain one, and the other is
        # MATH_DivU32, which is SAS/C library code.
        if re.search(r'\b(ROL|ROR|ROXL|ROXR)\b', body):
            fns.append({'name': name, 'src': srcf, 'size': len(blob),
                        'kind': 'no-calls', 'status': done.get(done_key),
                        'blockers': ['rotate-instruction']})
            continue
        # A tail JMP. Transferring to a library vector or another routine instead
        # of returning is not expressible in C -- SAS/C emits JSR then RTS, which
        # is a different instruction and a different stack. ESQ_ColdReboot ends
        # `JMP _LVOColdReboot(A6)` and also BRANCHES into a sibling function.
        last = [l for l in lines[1:] if l.strip() and not l.strip().startswith(';')]
        if last and re.search(r'\bJMP\b', last[-1]) and 'JMPTBL' not in name:
            fns.append({'name': name, 'src': srcf, 'size': len(blob),
                        'kind': 'no-calls', 'status': done.get(done_key),
                        'blockers': ['tail-jump']})
            continue
        # A body that does not END in RTS is not a function: it falls through to
        # whatever follows. The interior-label screen above only catches the ones
        # that use the enclosing frame via (A5), so a frameless fall-through block
        # slips past it and shows up as a small, tempting, completely unrestorable
        # target -- DISKIO1_AppendTimeSlotMaskValueTerminator ends `ADDQ.W #4,A7`
        # and its sibling ends `MOVEQ #1,D4`. A C function would add a prologue
        # and an RTS the original does not have, changing control flow, so these
        # can never be replaced no matter what the compiler does.
        #
        # RTE/RTR count too (interrupt and status-restoring returns). A trailing
        # JMP is already handled above as tail-jump.
        #
        # Test the WHOLE body, not just the final line: an extract can run a few
        # bytes past the RTS into inter-function padding, and a function whose
        # epilogue is branched to from inside ends at a `_Return` label. Both make
        # a last-line test report a real function as falling through. Having no
        # return instruction at all is unambiguous.
        if not re.search(r'\b(RTS|RTE|RTR)\b', body):
            fns.append({'name': name, 'src': srcf, 'size': len(blob),
                        'kind': 'no-calls', 'status': done.get(done_key),
                        'blockers': ['falls-through']})
            continue
        # ...but ONE predecrement store is already enough to stop a byte-exact
        # match, so it has to be a blocker even below the threshold that says
        # "this whole function was hand-written". Without this, functions with one
        # or two of them appear on the unblocked list and get picked up as
        # reachable targets -- ESQ_AdjustBracketedHourInString (two) cost real
        # time that way. Kind stays the call encoding; blockers say what stops it.
        extra = ['predecrement-store'] if pre else []
        if re.search(r'\bBSR\.[WS]\b', body):
            kind = 'intra-unit'
        elif b'\x4e\xba' in blob:
            kind = 'cross-unit'
        else:
            kind = 'no-calls'
        fns.append({'name': name, 'src': srcf, 'size': len(blob), 'kind': kind,
                    'status': done.get(done_key), 'blockers': blockers(hexb) + extra})
    return fns


def main():
    fns = survey()
    tot_n, tot_b = len(fns), sum(f['size'] for f in fns)
    dn = [f for f in fns if f['status']]
    ex = [f for f in fns if f['status'] == 'exact']
    print(f'  application functions   {tot_n:5d}   {tot_b:7d} bytes')
    print(f'  restored                {len(dn):5d}   {sum(f["size"] for f in dn):7d} bytes'
          f'   ({100*sum(f["size"] for f in dn)/tot_b:.1f}% by byte, '
          f'{100*len(dn)/tot_n:.0f}% by count)')
    print(f'  of those, exact         {len(ex):5d}   {sum(f["size"] for f in ex):7d} bytes')
    print()
    print('  remaining, by call encoding in the original:')
    for kind in ('cross-unit', 'intra-unit', 'no-calls', 'interior', 'predecrement'):
        g = [f for f in fns if f['kind'] == kind and not f['status']]
        print(f'    {kind:12s} {len(g):5d}   {sum(f["size"] for f in g):7d} bytes')

    if '--targets' in sys.argv:
        n = int(sys.argv[sys.argv.index('--targets') + 1]) if len(sys.argv) > sys.argv.index('--targets') + 1 and sys.argv[sys.argv.index('--targets') + 1].isdigit() else 25
        # Rank by the buckets that actually produce exact restorations. This used
        # to print cross-unit ('4EBA') on the theory that our one-function-per-file
        # output was pre-positioned to match it. It is not: SAS/C 6.51 emits BSR.W
        # for EVERY call, so cross-unit is the one bucket our output can never
        # match -- 0 exact out of 144 attempts, against 11 of 68 for intra-unit.
        # See AGENTS.md, "Progress is measured in BYTES".
        for kind in ('intra-unit', 'no-calls'):
            g = sorted((f for f in fns
                        if f['kind'] == kind and not f['status']
                        and not (set(f['blockers']) & BLOCKERS_HARD)),
                       key=lambda f: -f['size'])
            print(f'\n  next {n} unblocked {kind} targets (largest first):')
            for f in g[:n]:
                bl = ','.join(f['blockers']) or '-'
                print(f'    {f["size"]:5d}  {f["name"]:54s} {bl:24s} {f["src"]}')
        blocked = [f for f in fns if f['kind'] == 'cross-unit' and not f['status']]
        print(f'\n  (cross-unit withheld: {len(blocked)} functions / '
              f'{sum(f["size"] for f in blocked)} bytes, capped at behavioural '
              f'under 6.51 by the call opcode alone -- pass --cross-unit to list them)')
        if '--cross-unit' in sys.argv:
            for f in sorted(blocked, key=lambda f: -f['size'])[:n]:
                bl = ','.join(f['blockers']) or '-'
                print(f'    {f["size"]:5d}  {f["name"]:54s} {bl:24s} {f["src"]}')


if __name__ == '__main__':
    main()
