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

# This manifest is built with ESQ_FARCALLS=1 -- the header written below says so,
# and without it the link fails. So the generator assumes the flag by default.
# Set ESQ_FARCALLS=0 to regenerate the smaller manifest that links without it.
FARCALLS = os.environ.get('ESQ_FARCALLS', '1') != '0'


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


BRANCH = (r'B(?:RA|EQ|NE|CC|CS|GE|LT|GT|LE|MI|PL|HI|LS|VC|VS)'
          r'(?:\.[SWLswl])?\s+%s\s*$')


def reference_index():
    """Every non-XDEF source line that names an identifier, keyed by identifier.

    Built once. Asking the question per candidate re-walked 950 files 600 times.
    """
    idx = {}
    for dp, _, fs in os.walk(os.path.join(ROOT, 'src')):
        for f in fs:
            if not f.endswith('.s'):
                continue
            p = os.path.join(dp, f)
            for raw in open(p):
                ln = raw.split(';')[0].rstrip()
                s = ln.strip()
                if not s or s.endswith(':'):
                    continue
                if s.split()[0].upper() == 'XDEF':
                    continue
                for tok in set(re.findall(r'[A-Za-z_][\w]*', ln)):
                    idx.setdefault(tok, []).append((p, s))
    return idx


def other_real_functions(path, keep, idx):
    """Labels in `path`, besides `keep`, that are GENUINE functions.

    An empty result means the module holds one routine and may be replaced.

    A label reached only by a branch inside its own module is not a function. It
    is a branch target inside a larger routine, so a C restoration of that
    routine covers it and the label may go away with the module.

    A label that ANY `BSR`/`JSR` names is a function, whoever calls it -- that is
    the test that separates modules/groups/a/g/diskio1.s, where none of the 25
    extra labels is ever called, from modules/groups/a/w/ladfunc_p1_p0.s, where
    BOTH labels are. The first is one routine; the second is two, and replacing
    it with a single C file would delete a live function. A label whose ADDRESS
    is taken counts as a function too, so the test demands a branch mnemonic
    rather than merely excluding BSR and JSR.

    `keep` is the label the C file provides, which is allowed to be anything.
    """
    labs = re.findall(r'^([A-Za-z_][\w]*):', open(path).read(), re.M)
    bare_labs = [x.lstrip('_') for x in labs]

    others = []
    for l in labs:
        if l.lstrip('_') == keep:
            continue
        # A `<name>_Return` epilogue is not a function, whether it is branched
        # to or merely fallen into.
        if l.endswith('_Return') and l[:-7].lstrip('_') in bare_labs:
            continue
        others.append(l)
    if not others:
        return set()

    ok = set()
    for l in others:
        hits = idx.get(l, [])
        # NO references at all does NOT mean "interior". A dead function is
        # named by nothing either, and treating the two alike claimed
        # modules/groups/a/g/diskio1_p1.s for TWO C files at once -- it holds two
        # dead dumpers, and the second is reachable only by being the module's
        # second entry point. Only a label that something actually BRANCHES to,
        # from inside this module, is an interior target.
        if hits and all(p == path and re.match(BRANCH % re.escape(l), ln)
                        for p, ln in hits):
            ok.add(l)
    return set(others) - ok


def externally_referenced():
    """Labels that some OTHER file names. Keyed by module path.

    A C file replaces a WHOLE module, so what decides whether it may is not how
    many labels the module carries but how many of them anything outside needs.
    The `_Return` carve-out below is one instance of that: an epilogue label is
    XDEF'd, is never referenced from outside, and is not a function.

    Interior branch targets are the same case at larger scale.
    modules/groups/a/g/diskio1.s carries 25 of them for ONE routine, and counting
    them made a finished restoration unlinkable.

    Both sides strip one leading underscore. Keying the two halves differently is
    what made the first data-adjacency audit report zero overruns, so the bare
    name is used throughout here.
    """
    defs, refs = {}, {}
    for base in ('modules', 'data'):
        for dp, _, fs in os.walk(os.path.join(ROOT, 'src', base)):
            for f in fs:
                if not f.endswith('.s'):
                    continue
                p = os.path.join(dp, f)
                t = open(p).read()
                for l in re.findall(r'^([A-Za-z_][\w]*):', t, re.M):
                    defs.setdefault(l.lstrip('_'), p)
                bare = '\n'.join(x.split(';')[0] for x in t.split('\n'))
                for tok in set(re.findall(r'[A-Za-z_][\w]*', bare)):
                    refs.setdefault(tok.lstrip('_'), set()).add(p)

    out = {}
    for sym, home_p in defs.items():
        if any(u != home_p for u in refs.get(sym, ())):
            out.setdefault(home_p, set()).add(sym)
    return out


TERMINAL = ('RTS', 'RTE', 'RTR', 'JMP', 'BRA')


def fallen_into():
    """Modules whose PREDECESSOR in link order runs straight into them.

    This is the hazard that the externally_referenced() relaxation opens up. A
    module entered by fall-through is named by nothing, so that function reports
    no outside user and is right to -- yet the module still must not be replaced.
    The C function would open a prologue the original has not got, and the
    predecessor's last instruction would run into it.

    Read together the two rules say: replace a module only when every way into it
    is a reference to the one symbol the C file defines.
    """
    order = []
    for line in open(os.path.join(ROOT, 'src', 'Prevue.asm')):
        m = re.match(r'\s*include\s+"([^"]+)"', line)
        if m and m.group(1).startswith('modules/'):
            order.append(m.group(1))

    out = set()
    for prev, cur in zip(order, order[1:]):
        p = os.path.join(ROOT, 'src', prev)
        if not os.path.exists(p):
            continue
        last = None
        for ln in open(p):
            ln = ln.split(';')[0].strip()
            if not ln or ln.endswith(':'):
                continue
            if ln.split()[0].upper() in ('XDEF', 'XREF', 'SECTION', 'INCLUDE'):
                continue
            last = ln
        if last and not last.split()[0].upper().startswith(TERMINAL):
            out.add(os.path.join(ROOT, 'src', cur))
    return out


def main():
    fns = {f['name'].lstrip('_'): f for f in coverage.survey()}
    ext_refs = externally_referenced()
    fell_in = fallen_into()
    ref_idx = reference_index()
    reg_abi = register_entry_abi()
    short_br = short_branch_targets()

    home = {}
    for dp, _, fs in os.walk(os.path.join(ROOT, 'src', 'modules')):
        for f in fs:
            if not f.endswith('.s'):
                continue
            p = os.path.join(dp, f)
            labs = re.findall(r'^([A-Za-z_][\w]*):', open(p).read(), re.M)
            # A `<name>_Return` label is NOT a second function. It is the
            # epilogue of <name>, given its own label because the body branches
            # to it, and a C restoration of <name> carries that epilogue itself.
            # Counting it made the module look like it held two functions, and
            # the `n != 1` test below then refused to link the restoration --
            # silently, since the file compiles and compares fine. SIXTEEN
            # restorations were dropped that way on the day this was found.
            fnlabs = [l for l in labs
                      if not (l.endswith('_Return') and l[:-7].lstrip('_') in
                              [x.lstrip('_') for x in labs])]
            for l in labs:
                home[l] = (os.path.relpath(p, os.path.join(ROOT, 'src')),
                           len(fnlabs), p)

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
        text = open(os.path.join(cdir, f)).read()
        m = re.search(r'RESTORES:\s*(\S+)', text)
        if not m:
            continue
        # A restoration that FAULTS AT RUNTIME says so in its own header, and
        # that keeps it out of every generated manifest. No blocker can predict
        # this: the file compiles, compares sanely, links, and passes a6_audit,
        # and the only thing that knows better is the emulator.
        # The marker must OPEN a header line. Searching for it anywhere matched
        # prose that merely names it -- esq_capture_ctrl_bit3_stream.c explains
        # why a DIFFERENT file carries one, and was itself dropped for saying so.
        # A restoration was then hand-appended to the manifest to put it back,
        # which is how a generated file grew entries the generator would delete.
        dnl = re.search(r'^\s*\*\s*DO-NOT-LINK:\s*(.+)', text, re.M)
        if dnl:
            skipped.append((f, 'DO-NOT-LINK: ' + dnl.group(1).strip()))
            continue
        lab = m.group(1)
        bare = lab.lstrip('_')
        cand = next((c for c in (lab, '_' + lab, bare) if c in home), None)
        if not cand:
            continue
        mod, n, abspath = home[cand]
        if n != 1:
            # The label count alone is the wrong question -- see
            # externally_referenced(). What matters is whether anything OUTSIDE
            # the module needs a symbol other than the one this C file provides.
            # If not, the extra labels are interior branch targets and the C
            # function covers them.
            outside = ext_refs.get(abspath, set()) - {bare}
            real = other_real_functions(abspath, bare, ref_idx)
            if outside or real:
                why = sorted(outside | {r.lstrip('_') for r in real})
                skipped.append((f, 'module holds %d labels, %d of them functions: %s'
                                % (n, len(why), ','.join(why[:3]))))
                continue
            if abspath in fell_in:
                skipped.append((f, 'module holds %d labels and is entered by '
                                   'fall-through from its predecessor' % n))
                continue
        blockers = set(fns.get(bare, {}).get('blockers', []))
        if blockers & ABI_BLOCKERS:
            skipped.append((f, 'ABI: ' + ','.join(sorted(blockers & ABI_BLOCKERS))))
            continue
        if bare in reg_abi:
            skipped.append((f, 'entered by the OS with a register convention'))
            continue
        # This manifest mandates ESQ_FARCALLS=1, which rewrites every `BSR.S sym`
        # to a global into an absolute `JSR sym`. That is exactly the reference
        # this exclusion was protecting, so the callee no longer has to stay
        # beside its caller. Keep the detector: it still describes the pure
        # build, and it is the reason the flag is mandatory here.
        if bare in short_br and not FARCALLS:
            skipped.append((f, 'reached by an 8-bit BSR.S from another module'))
            continue
        rows.append((mod, 'c/' + f, opts.get('c/' + f, '')))

    # Deliberate overrides. A skip rule here is a heuristic, and a restoration
    # that was READ and found linkable anyway must be able to say so somewhere
    # the generator will not delete. Before this file existed the only way was to
    # append to the generated manifest by hand, and the next regeneration threw
    # the entry away without a word.
    extra = os.path.join(ROOT, 'src/c/replacements-extra.txt')
    have = {c for _, c, _ in rows}
    n_extra = 0
    if os.path.exists(extra):
        for line in open(extra):
            if not line.strip() or line.startswith('#'):
                continue
            parts = line.split()
            if len(parts) >= 2 and parts[1] not in have:
                rows.append((parts[0], parts[1], ' '.join(parts[2:])))
                have.add(parts[1])
                n_extra += 1

    out = os.path.join(ROOT, 'src/c/replacements-all.txt')
    with open(out, 'w') as fh:
        fh.write('# MAXIMUM-C manifest -- every restoration that is SAFE to link.\n'
                 '# Generated by tools/gen_all_manifest.py; do not hand-edit.\n'
                 '#\n'
                 '# NOT byte-exact by design: behavioural restorations differ from the\n'
                 '# original by construction, so build-split.sh reports DIFFERS. The\n'
                 '# byte-exact deliverable is src/c/replacements.txt.\n'
                 '#\n'
                 '# Build with BOTH flags -- see AGENTS.md. CODE=FAR fixes the call\n'
                 '# encoding on the C side. ESQ_FARCALLS=1 widens the ASSEMBLY 16-bit\n'
                 '# PC-relative references, which is what used to cap this manifest.\n'
                 '# Without ESQ_FARCALLS=1 the link fails with Error 28, and the message\n'
                 '# blames an assembly unit rather than any restoration.\n'
                 '#\n'
                 '#   ESQ_FARCALLS=1 \\\n'
                 '#     SCOPTS="NOSTKCHK DATA=FAR CODE=FAR CODENAME=S_0 DATANAME=S_1 IDLEN=128" \\\n'
                 '#     C_REPLACEMENTS=src/c/replacements-all.txt ./build-split.sh\n'
                 '#\n'
                 '# Verified 2026-07-30 at 391 entries: check_pcrel_range clean at 204\n'
                 '# calls, a6_audit 0 of 391, soak 10 of 10 distinct frames,\n'
                 '# menusweep clean on all six ESC-menu items, and framecolor.py\n'
                 '# shows every colour bin overlapping the known-good build.\n')
        for mod, c, o in rows:
            fh.write(f'{mod:70s} {c}' + (f'  {o}' if o else '') + '\n')

    print(f'manifest: {len(rows)} entries')
    excl = [s for s in skipped if not s[1].startswith('module holds')]
    print(f'excluded as unsafe to link: {len(excl)}')
    for f, why in sorted(excl, key=lambda x: x[1]):
        print(f'    {why:46s} {f}')


if __name__ == '__main__':
    main()
