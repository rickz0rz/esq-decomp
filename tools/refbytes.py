#!/usr/bin/env python3
"""Extract the reference bytes of a named function from the monolithic build.

    python3 tools/refbytes.py BRUSH_PlaneMaskForIndex

Assembles src/Prevue.asm with a listing, then slices out every byte emitted
between the requested label and the next column-0 label in the same file. That
byte string is what a C reimplementation must reproduce exactly.

Relocated fields are reported too: a long that carries a relocation holds a
link-time address, so compare those positionally rather than by value.
"""
import os, re, subprocess, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC  = os.path.join(ROOT, 'src')
VASM = os.environ.get('VASM_BIN', os.path.expanduser('~/Downloads/vasm/vasmm68k_mot'))
LST  = os.path.join(ROOT, 'build', 'Prevue.lst')


def stale():
    """True if the cached listing is missing or older than any source file.

    Without this the cache silently answers from a pre-edit view of the program:
    after a function is extracted or a symbol renamed, lookups fail or return the
    wrong bytes, and a byte-exact restoration gets reported as a regression.
    """
    if not os.path.exists(LST):
        return True
    lst = os.path.getmtime(LST)
    for dirpath, _, files in os.walk(SRC):
        for fn in files:
            if fn.endswith(('.s', '.asm', '.i')) and os.path.getmtime(os.path.join(dirpath, fn)) > lst:
                return True
    return False


def listing():
    if stale():
        os.makedirs(os.path.dirname(LST), exist_ok=True)
        subprocess.run([VASM, '-I', SRC, '-Fhunkexe', '-nosym', '-L', LST,
                        '-o', os.devnull, os.path.join(SRC, 'Prevue.asm')],
                       check=True, capture_output=True, text=True)
    return LST


# Three listing line shapes can carry bytes. Missing any of them silently
# truncates the reference, which is worse than failing outright -- the caller
# then diffs C against an incomplete original and concludes it cannot match.
#
#   normal        '00:00007202 2207      \t   418:     MOVE.L D7,D1'
#   macro         '00:000071FE 2E2F0014  \t     1M     MOVE.L 20(A7),D7'
#   continuation  '00:000001A2 617279'    (spillover of a long DC.B, no source)
#
# Macro expansions mark the line-number column with 'M' instead of ':', and
# continuation lines have no source column at all. Handling only the first shape
# dropped 6261 of 72530 code-emitting lines.
#
# The listing emits exactly one space after the marker before the source text,
# so consume it -- otherwise a column-0 label looks indented.
FULL = re.compile(r'^(?:(\d+):([0-9A-F]{8})\s+([0-9A-F]*))?\s*\t\s*(\d+)[:M] ?(.*)$')
CONT = re.compile(r'^(\d+):([0-9A-F]{8})\s+([0-9A-F]+)\s*$')


def parse_line(line):
    """-> (sec, addr, enc, text) for a byte- or source-bearing line, else None.

    sec/addr are None on a line that carries source text but emits nothing.
    """
    m = FULL.match(line.rstrip('\n'))
    if m:
        return m.group(1), m.group(2), m.group(3) or '', m.group(5)
    m = CONT.match(line.rstrip())
    if m:
        return m.group(1), m.group(2), m.group(3), ''
    return None


def check_contiguous(rows, label):
    """Every emitted byte must be accounted for, with no address gaps.

    A gap means some line shape is being dropped. Failing loudly here is the
    whole point: a truncated reference is indistinguishable from a real
    mismatch, and this project has already lost time to exactly that.
    """
    prev = None
    for addr, enc, _lineno, _text in rows:
        if not enc or not addr:
            continue
        a = int(addr, 16)
        if prev is not None and a != prev:
            sys.exit(f'refbytes: {label}: {a - prev} byte(s) unaccounted for at '
                     f'0x{a:08X} (expected 0x{prev:08X}). The listing contains a '
                     f'line shape this parser does not understand; fix it rather '
                     f'than trusting the truncated result.')
        prev = a + len(enc) // 2


def extract(label):
    cur, rows, grabbing, srcfile = None, [], False, None
    for line in open(listing(), errors='replace'):
        m = re.match(r'^Source: "(.+)"', line)
        if m:
            cur = m.group(1)
            if grabbing:
                break                      # function cannot span source files
            continue
        p = parse_line(line)
        if not p:
            continue
        _sec, addr, enc, text = p
        lineno = 0
        code = text.split(';')[0]
        at_label = re.match(r'^([A-Za-z_][A-Za-z0-9_]*):', code)
        if at_label and at_label.group(1) in (label, '_' + label):
            grabbing, srcfile = True, cur
            rows.append((addr, enc, lineno, text)); continue
        if grabbing:
            if at_label:                   # next top-level label ends the function
                break
            rows.append((addr, enc, lineno, text))
    if not grabbing:
        sys.exit(f'refbytes: label not found: {label} (also tried _{label})')
    while rows and not rows[-1][1]:
        rows.pop()
    check_contiguous(rows, label)
    return srcfile, rows


def main():
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    label = sys.argv[1]
    srcfile, rows = extract(label)
    blob = ''.join(r[1] for r in rows)
    start = next((r[0] for r in rows if r[0]), None)
    print(f'{label}   [{srcfile}]')
    print(f'section offset 0x{start}   {len(blob)//2} bytes\n')
    for addr, enc, lineno, text in rows:
        if enc:
            print(f'  {addr or "":8s} {enc:<20s} {text.rstrip()}')
    print(f'\nbytes: {blob.lower()}')


if __name__ == '__main__':
    main()
