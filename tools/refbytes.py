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


def listing():
    if not os.path.exists(LST):
        os.makedirs(os.path.dirname(LST), exist_ok=True)
        subprocess.run([VASM, '-I', SRC, '-Fhunkexe', '-nosym', '-L', LST,
                        '-o', os.devnull, os.path.join(SRC, 'Prevue.asm')],
                       check=True, capture_output=True, text=True)
    return LST


def extract(label):
    cur, rows, grabbing, srcfile = None, [], False, None
    for line in open(listing(), errors='replace'):
        m = re.match(r'^Source: "(.+)"', line)
        if m:
            cur = m.group(1)
            if grabbing:
                break                      # function cannot span source files
            continue
        # the listing emits exactly one space after "<lineno>:" before the source
        # text, so consume it -- otherwise a column-0 label looks indented
        m = re.match(r'^(?:\d+:([0-9A-F]{8})\s+([0-9A-F]*))?\s*\t\s*(\d+): ?(.*)', line)
        if not m:
            continue
        addr, enc, lineno, text = m.group(1), m.group(2) or '', int(m.group(3)), m.group(4)
        code = text.split(';')[0]
        at_label = re.match(r'^([A-Za-z_][A-Za-z0-9_]*):', code)
        if at_label and at_label.group(1) == label:
            grabbing, srcfile = True, cur
            rows.append((addr, enc, lineno, text)); continue
        if grabbing:
            if at_label:                   # next top-level label ends the function
                break
            rows.append((addr, enc, lineno, text))
    if not grabbing:
        sys.exit(f'refbytes: label not found: {label}')
    while rows and not rows[-1][1]:
        rows.pop()
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
