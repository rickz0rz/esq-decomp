#!/usr/bin/env python3
"""List restoration candidates with their reference bytes, in one listing pass.

    python3 tools/candidates.py [--max-instr N] [--min-instr N] [--limit N]

Finds leaf functions in src/modules/groups (application code, not the SAS/C
library routines under submodules/) that make no calls and use no stack frame,
then prints each one's source and its exact reference bytes.

Doing this in a single pass matters: refbytes.py rebuilds an 8.9 MB listing per
invocation, so asking it for fifty functions one at a time is fifty rebuilds.
"""
import os, re, subprocess, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC  = os.path.join(ROOT, 'src')
VASM = os.environ.get('VASM_BIN', os.path.expanduser('~/Downloads/vasm/vasmm68k_mot'))
LST  = os.path.join(ROOT, 'build', 'Prevue.lst')


def build_listing():
    src_newest = 0
    for dp, _, fs in os.walk(SRC):
        for f in fs:
            if f.endswith(('.s', '.asm', '.i')):
                src_newest = max(src_newest, os.path.getmtime(os.path.join(dp, f)))
    if not os.path.exists(LST) or os.path.getmtime(LST) < src_newest:
        os.makedirs(os.path.dirname(LST), exist_ok=True)
        subprocess.run([VASM, '-I', SRC, '-Fhunkexe', '-nosym', '-L', LST,
                        '-o', os.devnull, os.path.join(SRC, 'Prevue.asm')],
                       check=True, capture_output=True, text=True)
    return LST


def parse_listing():
    """{label: (srcfile, hexbytes, [source lines])} for every column-0 label."""
    out, cur, label = {}, None, None
    for line in open(build_listing(), errors='replace'):
        m = re.match(r'^Source: "(.+)"', line)
        if m:
            cur, label = m.group(1), None
            continue
        m = re.match(r'^(?:(\d+):([0-9A-F]{8})\s+([0-9A-F]*))?\s*\t\s*(\d+): ?(.*)', line)
        if not m or cur is None:
            continue
        sec, enc, text = m.group(1), m.group(3) or '', m.group(5)
        code = text.split(';')[0]
        lm = re.match(r'^([A-Za-z_][A-Za-z0-9_]*):', code)
        if lm:
            label = lm.group(1)
            out.setdefault(label, [cur, '', []])
        if label is None:
            continue
        if sec == '00' and enc:
            out[label][1] += enc
        if code.strip():
            out[label][2].append(code.rstrip())
    return out


def main():
    def arg(name, default):
        return int(sys.argv[sys.argv.index(name) + 1]) if name in sys.argv else default
    lo, hi, limit = arg('--min-instr', 3), arg('--max-instr', 18), arg('--limit', 60)

    done = set()
    cdir = os.path.join(SRC, 'c')
    if os.path.isdir(cdir):
        for f in os.listdir(cdir):
            if f.endswith('.c'):
                m = re.search(r'RESTORES:\s*(\S+)', open(os.path.join(cdir, f)).read())
                if m:
                    done.add(m.group(1).lstrip('_'))

    table = parse_listing()
    picked = 0
    for label, (srcf, hexb, lines) in table.items():
        if not srcf.startswith('modules/groups') or not hexb:
            continue
        if label.lstrip('_') in done or label.endswith('_Return'):
            continue
        body = [l for l in lines[1:] if l.strip()]
        if not (lo <= len(body) <= hi):
            continue
        txt = '\n'.join(body)
        if '--allow-calls' not in sys.argv and (
                re.search(r'\b(JSR|BSR\.[WS]|JMP|BRA\.W)\s+[A-Za-z_]', txt)):
            continue
        if '--allow-link' not in sys.argv and 'LINK.W' in txt:
            continue
        if 'RTS' not in txt:
            continue
        print(f'=== {label}  [{srcf}]  {len(hexb)//2} bytes')
        for l in body:
            print('    ' + l.strip())
        print(f'    BYTES: {hexb.lower()}')
        print()
        picked += 1
        if picked >= limit:
            break
    print(f'{picked} candidates')


if __name__ == '__main__':
    main()
