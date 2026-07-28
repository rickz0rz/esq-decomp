#!/usr/bin/env python3
"""Generate src/c/replacements-all.txt -- the maximum-C manifest.

    python3 tools/gen_all_manifest.py

Lists every restoration that can be linked. The subtlety, and the reason this is
a script rather than a one-liner, is that NOT EVERY RESTORATION IS SAFE TO LINK
even when it compiles and byte-compares well.

Two kinds of blocker exist and they are not the same thing:

  BYTE blockers -- A5-frame, cross-unit-call, predecrement-store. The original
      cannot be reproduced byte-for-byte by SAS/C 6.51. The restoration is still
      semantically correct and links fine. These do NOT exclude.

  ABI blockers -- register-args, live-register-on-entry, interior-label. The
      original is ENTERED with a convention C cannot implement: arguments in
      registers that it also preserves, a live register on entry, or a label
      reached by fall-through. A C function with a stack frame and a normal
      prologue is not merely a different encoding of these, it is wrong. These
      DO exclude.

Plus a third category the blockers cannot see, because it is about how a function
is INSTALLED rather than how it is written: interrupt vectors and library
patches. Both are called by the OS with a register convention (A1 = is_Data for
an interrupt server, library arguments in registers for a SetFunction patch), and
neither passes anything on the stack. Restoring one as ordinary C gives a
function that reads its arguments from a stack frame that does not contain them.

That last category is what hung the machine on the first whole-program C run:
ESQ_HandleSerialRbfInterrupt was restored as
`void f(volatile short *custom, unsigned char *ring)` and installed as the RBF
interrupt vector, so it dereferenced two garbage pointers in interrupt context.

Excluded functions stay in assembly. They are not deleted or wrong as analysis --
their headers and byte comparisons remain valid -- they simply must not be linked.
"""
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(ROOT, 'tools'))
import coverage

ABI_BLOCKERS = {'register-args', 'live-register-on-entry', 'interior-label'}


def register_entry_abi():
    """Functions the OS enters with a register convention.

    Detected structurally: an interrupt server's code pointer is stored to
    is_Code at offset 18 of the Interrupt struct, and a SetFunction patch is
    passed in D0 having been loaded into A2. Both are reached by `LEA sym(PC),An`
    in the installing module.
    """
    found = set()
    for dp, _, fs in os.walk(os.path.join(ROOT, 'src', 'modules')):
        for f in fs:
            if not f.endswith('.s'):
                continue
            t = open(os.path.join(dp, f)).read()
            installs_int = 'MOVE.L  A0,18(A1)' in t
            installs_fn = '_LVOSetFunction' in t
            if not (installs_int or installs_fn):
                continue
            for m in re.finditer(r'LEA\s+(\S+)\(PC\),A[02]', t):
                found.add(m.group(1).lstrip('_').replace('ESQFUNC_JMPTBL_', ''))
    return found


def short_branch_targets():
    """Symbols reached by an 8-bit branch from a DIFFERENT module.

    Extraction can move a callee out of its caller's unit. A `BSR.S` has only an
    8-bit displacement, so once they are in separate units the link fails with
    "doesn't fit into 8 bits". Replacing such a function with C keeps it in its
    own unit, so it stays unreachable -- it must be left in assembly, where
    gen_units.py can coalesce it back beside its caller.
    """
    defs, refs = {}, {}
    root = os.path.join(ROOT, 'src', 'modules')
    for dp, _, fs in os.walk(root):
        for f in fs:
            if not f.endswith('.s'):
                continue
            p = os.path.join(dp, f)
            t = open(p).read()
            for l in re.findall(r'^([A-Za-z_][\w]*):', t, re.M):
                defs[l] = p
            bare = '\n'.join(x.split(';')[0] for x in t.split('\n'))
            for m in re.finditer(r'\bB(?:SR|RA|EQ|NE|CC|CS|GE|LT|GT|LE|MI|PL|HI|LS)\.S\s+([A-Za-z_][\w]*)', bare):
                refs.setdefault(m.group(1), set()).add(p)
    out = set()
    for sym, users in refs.items():
        if sym in defs and any(u != defs[sym] for u in users):
            out.add(sym.lstrip('_'))
    return out


def main():
    fns = {f['name'].lstrip('_'): f for f in coverage.survey()}
    reg_abi = register_entry_abi()
    short_br = short_branch_targets()

    home = {}
    for dp, _, fs in os.walk(os.path.join(ROOT, 'src', 'modules')):
        for f in fs:
            if not f.endswith('.s'):
                continue
            p = os.path.join(dp, f)
            labs = re.findall(r'^([A-Za-z_][\w]*):', open(p).read(), re.M)
            for l in labs:
                home[l] = (os.path.relpath(p, os.path.join(ROOT, 'src')), len(labs))

    # Per-file sc options come from TWO places. replacements.txt carries them for
    # byte-exact restorations, but a BEHAVIOURAL file cannot have an entry there
    # -- that manifest is the byte-exact gate -- so a behavioural restoration that
    # needs SHORTINT had no way to say so and was silently compiled without it.
    # Two files hit that (esqiff_set_apen_to_brightest_palette_index at 192 bytes
    # instead of 172, textdisp_find_entry_match_index at 748 instead of 732);
    # both still built and ran, just less faithfully. src/c/scopts.txt fixes it.
    opts = {}
    for src in ('src/c/replacements.txt', 'src/c/scopts.txt'):
        path = os.path.join(ROOT, src)
        if not os.path.exists(path):
            continue
        for line in open(path):
            if line.strip() and not line.startswith('#'):
                parts = line.split()
                if src.endswith('scopts.txt'):
                    if len(parts) > 1:
                        opts[parts[0]] = ' '.join(parts[1:])
                elif len(parts) > 2:
                    opts[parts[1]] = ' '.join(parts[2:])

    rows, skipped = [], []
    cdir = os.path.join(ROOT, 'src', 'c')
    for f in sorted(os.listdir(cdir)):
        if not f.endswith('.c'):
            continue
        m = re.search(r'RESTORES:\s*(\S+)', open(os.path.join(cdir, f)).read())
        if not m:
            continue
        lab = m.group(1)
        bare = lab.lstrip('_')
        cand = next((c for c in (lab, '_' + lab, bare) if c in home), None)
        if not cand:
            continue
        mod, n = home[cand]
        if n != 1:
            skipped.append((f, 'module holds %d labels' % n))
            continue
        blockers = set(fns.get(bare, {}).get('blockers', []))
        if blockers & ABI_BLOCKERS:
            skipped.append((f, 'ABI: ' + ','.join(sorted(blockers & ABI_BLOCKERS))))
            continue
        if bare in reg_abi:
            skipped.append((f, 'entered by the OS with a register convention'))
            continue
        if bare in short_br:
            skipped.append((f, 'reached by an 8-bit BSR.S from another module'))
            continue
        rows.append((mod, 'c/' + f, opts.get('c/' + f, '')))

    out = os.path.join(ROOT, 'src/c/replacements-all.txt')
    with open(out, 'w') as fh:
        fh.write('# MAXIMUM-C manifest -- every restoration that is SAFE to link.\n'
                 '# Generated by tools/gen_all_manifest.py; do not hand-edit.\n'
                 '#\n'
                 '# NOT byte-exact by design: behavioural restorations differ from the\n'
                 '# original by construction, so build-split.sh reports DIFFERS. The\n'
                 '# byte-exact deliverable is src/c/replacements.txt.\n'
                 '#\n'
                 '# Build with (CODE=FAR is mandatory -- see AGENTS.md):\n'
                 '#   SCOPTS="NOSTKCHK DATA=FAR CODE=FAR CODENAME=S_0 DATANAME=S_1 IDLEN=128" \\\n'
                 '#     C_REPLACEMENTS=src/c/replacements-all.txt ./build-split.sh\n')
        for mod, c, o in rows:
            fh.write(f'{mod:70s} {c}' + (f'  {o}' if o else '') + '\n')

    print(f'manifest: {len(rows)} entries')
    excl = [s for s in skipped if not s[1].startswith('module holds')]
    print(f'excluded as unsafe to link: {len(excl)}')
    for f, why in sorted(excl, key=lambda x: x[1]):
        print(f'    {why:46s} {f}')


if __name__ == '__main__':
    main()
