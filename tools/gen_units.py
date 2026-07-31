#!/usr/bin/env python3
"""Generate separately-assemblable link units from the monolithic include list.

src/Prevue.asm is the canonical statement of *what* is in the program and in
*what order*. This script turns it into:

  build/units/prelude.i   shared equates/macros, included by every unit
  build/units/<name>.asm  one translation unit per group of source modules
  build/units/ORDER       the link order (must be fed to the linker verbatim)

Why units are sometimes larger than one source module
-----------------------------------------------------
AmigaDOS hunk objects store section sizes in *longwords*, so every object is
rounded up to a 4-byte boundary. A module whose size is 2 (mod 4) would gain 2
bytes of padding, shifting everything after it. So consecutive modules are
coalesced until the running total lands on a 4-byte boundary. Source files stay
one-module-per-file; only the assembly grouping is coarser.

Module sizes are measured, not guessed: a marked copy of Prevue.asm emits the
section offset at each include boundary via PRINTV.
"""
import os, re, shutil, subprocess, sys

ROOT     = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC      = os.path.join(ROOT, 'src')
OUT      = os.path.join(ROOT, 'build', 'units')
FAR      = os.path.join(OUT, 'far')
VASM     = os.environ.get('VASM_BIN', os.path.expanduser('~/Downloads/vasm/vasmm68k_mot'))
CODE_SEC = 'SECTION S_0,CODE'
DATA_SEC = 'SECTION S_1,DATA,CHIP'

# ESQ_FARCALLS=1 widens every cross-module 16-bit branch to an absolute one.
# See far_rewrite() for why, and why it must stay off for the byte-exact gates.
FARCALLS = os.environ.get('ESQ_FARCALLS') == '1'

# A bare symbol only. A local label ('.lab') cannot be stretched, because it and
# its branch are always in the same module; and the one expression target in the
# program is a self-relative jump-table dispatch inside a single function, which
# must keep its PC-relative form. Both are excluded by requiring [A-Za-z_] first.
# Any branch to a GLOBAL symbol, at either width. `.S` is included because a
# short branch can cross a module boundary too -- `BSR.S _P_TYPE_CloneEntry`
# reaches the next module only while it stays adjacent, and Error 28 said
# "doesn't fit into 8 bits" the moment it did not. Unconditional ones become
# absolute; conditional ones have no absolute form, so they can only widen to
# .W, which check_pcrel_range still watches.
_BRANCH_RE = re.compile(
    r'^(\s+)(B[A-Z]{1,3})\.([WS])(\s+)([A-Za-z_][A-Za-z0-9_]*)(\s*(?:;.*)?)$')
_ABSOLUTE  = {'BSR': 'JSR', 'BRA': 'JMP'}

# The larger half of the problem, and the one that is easy to miss: `sym(PC)` is
# 16-bit PC-relative too. 3069 sites -- 3047 JSR, 18 LEA, 4 PEA -- and they are
# the original's cross-unit call encoding (4EBA), so they are spread across the
# whole program by construction. Dropping `(PC)` leaves an absolute operand with
# the same target and the same meaning, 2 bytes longer. The trailing group keeps
# a destination register, as in `LEA sym(PC),A0`.
_PCREL_RE = re.compile(
    r'^(\s+)(JSR|JMP|LEA|PEA)(\s+)([A-Za-z_][A-Za-z0-9_]*)\(PC\)(.*)$')

# Widening a branch makes its module 2 bytes longer, which can push an 8-bit
# branch elsewhere in that module (+/-127) out of reach -- measured: two modules
# failed with "branch destination out of range" before this existed. Only a
# module we already grew is at risk, and a 16-bit displacement spans any module
# in the program, so promoting its short LOCAL branches is both sufficient and
# incapable of cascading. The target may be a local label OR a global one: an
# exported `_Return` label is branched to at short range from inside its own
# function (`BEQ.S DISPLIB_ApplyInlineAlignmentPadding_Return`), and an earlier
# local-only pattern here missed exactly those and failed to assemble. Promoting
# them is still safe, because a target reachable in +/-127 bytes is by definition
# in the same module, hence the same unit, hence trivially inside .W range.
_SHORT_RE = re.compile(
    r'^(\s+)(B[A-Z]{1,3})\.S(\s+)(\.?[A-Za-z_][A-Za-z0-9_]*)(\s*(?:;.*)?)$')


def read_root():
    """Split Prevue.asm into (prelude lines, ordered module include paths)."""
    prelude, incs = [], []
    for line in open(os.path.join(SRC, 'Prevue.asm')).read().split('\n'):
        m = re.match(r'\s*include\s+"((?:modules|data)/[^"]+)"', line)
        if m:
            incs.append(m.group(1)); continue
        if re.match(r'\s*(SECTION|PRINTV|PRINTT)\s', line) or re.match(r'\s*END\s*$', line):
            continue
        prelude.append(line)
    return prelude, incs


def measure(incs):
    """Return each module's exact byte size by assembling a PRINTV-marked root."""
    lines = open(os.path.join(SRC, 'Prevue.asm')).read().split('\n')
    out = []
    for line in lines:
        if re.match(r'\s*include\s+"(?:modules|data)/[^"]+"', line):
            out.append('    PRINTT "@MARK"\n    PRINTV *')
        if re.match(r'\s*END\s*$', line):
            out.append('    PRINTT "@MARK"\n    PRINTV *')
        out.append(line)
    marked = os.path.join(OUT, 'Prevue_marked.asm')
    open(marked, 'w').write('\n'.join(out))
    # FAR first, so a widened module shadows its original -- otherwise the sizes
    # driving the longword coalescing below would be the un-widened ones.
    r = subprocess.run([VASM, '-I', FAR, '-I', SRC, '-Fhunkexe', '-nosym',
                        '-o', os.devnull, marked],
                       capture_output=True, text=True)
    secs = dict(re.findall(r'^(S_\d)\(\w+\):\s+(\d+) bytes', r.stdout, re.M))
    if not secs:
        sys.exit(f'gen_units: could not measure sections\n{r.stdout}\n{r.stderr}')
    code_end, data_end = int(secs['S_0']), int(secs['S_1'])

    offs, it = [], iter(r.stdout.split('\n'))
    for line in it:
        if line.strip() == '@MARK':
            offs.append(int(next(it).split()[0].lstrip('$'), 16))
    ncode = sum(1 for p in incs if p.startswith('modules/'))
    sizes = []
    for i in range(len(incs)):
        if   i == ncode - 1:     sizes.append(code_end - offs[i])
        elif i == len(incs) - 1: sizes.append(data_end - offs[i])
        else:                    sizes.append(offs[i + 1] - offs[i])
    assert sum(sizes[:ncode]) == code_end,  'code size reconstruction failed'
    assert sum(sizes[ncode:]) == data_end,  'data size reconstruction failed'
    return sizes, ncode


def far_rewrite(incs):
    """Widen cross-module 16-bit branches to absolute ones, for C builds only.

    `BSR.W sym` and `BRA.W sym` are 16-bit PC-relative: the target must sit
    within +/-32767 of the branch. That holds in the pure-assembly program, but
    a C replacement is larger than the assembly it displaces, so inserting
    enough of them stretches a caller away from its callee until the
    displacement no longer fits. vlink reports some of these (Error 28) and
    SILENTLY WRAPS others -- see tools/check_pcrel_range.py -- and either way the
    limit, not the restoration, is what caps how much C the program can hold.

    `JSR sym` / `JMP sym` have the same effect with no range limit: vasm emits a
    6-byte absolute whenever the target is external to the unit, and keeps the
    short form when it is local (where the distance is bounded anyway). The cost
    is 2 bytes and one relocation per widened site.

    This runs ONLY under ESQ_FARCALLS=1, and it rewrites COPIES under
    build/units/far/ rather than the checked-in sources. build-split.sh puts
    that directory first on the include path, so a rewritten module shadows the
    original and everything else still resolves from src/. The default build
    never sets the flag, so `test-hash.sh` and the byte-exact split gate see the
    original encodings and stay meaningful.

    Do NOT enable it for src/c/replacements.txt: verify_restorations.py checks
    that the image grew by exactly the sum of per-object rounding, and widened
    branches add bytes that accounting does not know about.
    """
    shutil.rmtree(FAR, ignore_errors=True)     # never let a stale tree shadow a pure build
    os.makedirs(FAR, exist_ok=True)
    if not FARCALLS:
        return 0, 0, 0
    files = sites = shorts = 0
    for path in incs:
        lines = open(os.path.join(SRC, path)).read().split('\n')
        hits = 0
        for i, line in enumerate(lines):
            m = _BRANCH_RE.match(line)
            if m:
                pre, mnem, size, gap, sym, tail = m.groups()
                if mnem in _ABSOLUTE:           # BSR/BRA -> JSR/JMP, no range limit at all
                    lines[i] = pre + _ABSOLUTE[mnem] + gap + sym + tail
                elif size == 'S':               # Bcc has no absolute form; .W is the widest
                    lines[i] = pre + mnem + '.W' + gap + sym + tail
                else:
                    continue                    # already .W: nothing to widen, do not count
                hits += 1
                continue
            m = _PCREL_RE.match(line)
            if m:
                lines[i] = (m.group(1) + m.group(2) + m.group(3)
                            + m.group(4) + m.group(5))
                hits += 1
        if not hits:
            continue                            # unchanged modules keep resolving from src/
        for i, line in enumerate(lines):        # this module grew, so its own shorts are at risk
            m = _SHORT_RE.match(line)
            if m:
                lines[i] = (m.group(1) + m.group(2) + '.W'
                            + m.group(3) + m.group(4) + m.group(5))
                shorts += 1
        dst = os.path.join(FAR, path)
        os.makedirs(os.path.dirname(dst), exist_ok=True)
        open(dst, 'w').write('\n'.join(lines))
        files += 1; sites += hits
    return files, sites, shorts


def replacements():
    """Optional map of {module path: C file} from $C_REPLACEMENTS.

    Left unset for the default build, which stays pure assembly so the
    byte-exact gates remain meaningful.
    """
    manifest = os.environ.get('C_REPLACEMENTS')
    if not manifest:
        return {}
    out = {}
    for line in open(os.path.join(ROOT, manifest)):
        parts = line.split('#')[0].split()
        if len(parts) >= 2:
            # module -> (cfile, extra sc options). Options are per-file because
            # SAS/C reads a per-directory SCOPTIONS, so the original translation
            # units did not necessarily share settings -- e.g. SHORTINT is
            # required by ED_IsConfirmKey but breaks LADFUNC_GetPackedPenHighNibble.
            out[parts[0]] = (parts[1], ' '.join(parts[2:]))
    return out


def coalesce(pairs, repl):
    """Group consecutive modules until each group is a whole number of longwords.

    A replaced module becomes its own entry ('C', <cfile>) at exactly the
    position its assembly occupied, so link order -- and therefore layout -- is
    preserved. The unit is closed before and after it regardless of alignment;
    a C object is independently longword-sized, and any 2-byte pad lands
    between functions where it is never executed.
    """
    units, cur, acc = [], [], 0
    for path, size in pairs:
        if path in repl:
            if cur:
                units.append(cur); cur, acc = [], 0
            units.append(('C',) + repl[path])
            continue
        cur.append(path); acc += size
        if acc % 4 == 0:
            units.append(cur); cur, acc = [], 0
    if cur:
        units.append(cur)          # trailing group: section total is 4-aligned anyway
    return units


def main():
    os.makedirs(OUT, exist_ok=True)
    prelude, incs = read_root()
    open(os.path.join(OUT, 'prelude.i'), 'w').write('\n'.join(prelude) + '\n')
    far_files, far_sites, far_shorts = far_rewrite(incs)    # must precede measure(): it changes sizes
    sizes, ncode = measure(incs)

    repl = replacements()
    groups = [('c', coalesce(list(zip(incs[:ncode], sizes[:ncode])), repl), CODE_SEC),
              ('d', coalesce(list(zip(incs[ncode:], sizes[ncode:])), repl), DATA_SEC)]
    order = []
    for tag, units, section in groups:
        for u in units:
            if isinstance(u, tuple) and u[0] == 'C':
                order.append('C:' + u[1] + ('|' + u[2] if u[2] else ''))
                continue
            name = tag + '_' + u[0].replace('/', '_')[:-2]
            if len(u) > 1:
                name += f'__plus{len(u) - 1}'
            body = '\n'.join(f'\tinclude "{p}"' for p in u)
            open(os.path.join(OUT, name + '.asm'), 'w').write(
                f'\tinclude "prelude.i"\n\t{section}\n{body}\n')
            order.append(name)
    open(os.path.join(OUT, 'ORDER'), 'w').write('\n'.join(order) + '\n')

    asm = sum(1 for o in order if not o.startswith('C:'))
    print(f'{len(incs)} source modules -> {len(order)} link units ({asm} assembled)'
          + (f', {len(repl)} replaced by C' if repl else ''))
    if far_sites:
        print(f'    FARCALLS: {far_sites} cross-module branches widened to '
              f'absolute in {far_files} modules, '
              f'{far_shorts} short local branches promoted to .W')
    for m, (c, o) in repl.items():
        print(f'    C: {c}  replaces  {m}' + (f'   [+{o}]' if o else ''))


if __name__ == '__main__':
    main()
