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
import os, re, subprocess, sys

ROOT     = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC      = os.path.join(ROOT, 'src')
OUT      = os.path.join(ROOT, 'build', 'units')
VASM     = os.environ.get('VASM_BIN', os.path.expanduser('~/Downloads/vasm/vasmm68k_mot'))
CODE_SEC = 'SECTION S_0,CODE'
DATA_SEC = 'SECTION S_1,DATA,CHIP'


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
    r = subprocess.run([VASM, '-I', SRC, '-Fhunkexe', '-nosym', '-o', os.devnull, marked],
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


def coalesce(pairs):
    """Group consecutive modules until each group is a whole number of longwords."""
    units, cur, acc = [], [], 0
    for path, size in pairs:
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
    sizes, ncode = measure(incs)

    groups = [('c', coalesce(list(zip(incs[:ncode], sizes[:ncode]))), CODE_SEC),
              ('d', coalesce(list(zip(incs[ncode:], sizes[ncode:]))), DATA_SEC)]
    order = []
    for tag, units, section in groups:
        for u in units:
            name = tag + '_' + u[0].replace('/', '_')[:-2]
            if len(u) > 1:
                name += f'__plus{len(u) - 1}'
            body = '\n'.join(f'\tinclude "{p}"' for p in u)
            open(os.path.join(OUT, name + '.asm'), 'w').write(
                f'\tinclude "prelude.i"\n\t{section}\n{body}\n')
            order.append(name)
    open(os.path.join(OUT, 'ORDER'), 'w').write('\n'.join(order) + '\n')

    ncu = len(groups[0][1]); ndu = len(groups[1][1])
    print(f'{len(incs)} source modules -> {len(order)} link units '
          f'({ncu} code, {ndu} data); {sum(1 for t,us,_ in groups for u in us if len(u)==1)} are single-module')


if __name__ == '__main__':
    main()
