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
               for a callee in another translation unit. Our restorations are one
               function per file, so every call we emit is cross-unit too. These
               are pre-positioned to match and are the highest-value targets.
  intra-unit   contains a BSR.W to a nearby callee, which means that callee shared
               a .c file with it. Matching those needs the original source grouping
               reconstructed, which is a separate and much larger problem.
"""
import os, re, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(ROOT, 'tools'))
import candidates as C
from screen_candidates import blockers


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
        name = label.lstrip('_')
        blob = bytes.fromhex(hexb)
        if re.search(r'\bBSR\.W\b', body):
            kind = 'intra-unit'
        elif b'\x4e\xba' in blob:
            kind = 'cross-unit'
        else:
            kind = 'no-calls'
        fns.append({'name': name, 'src': srcf, 'size': len(blob), 'kind': kind,
                    'status': done.get(name), 'blockers': blockers(hexb)})
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
    for kind in ('cross-unit', 'intra-unit', 'no-calls'):
        g = [f for f in fns if f['kind'] == kind and not f['status']]
        print(f'    {kind:12s} {len(g):5d}   {sum(f["size"] for f in g):7d} bytes')

    if '--targets' in sys.argv:
        n = int(sys.argv[sys.argv.index('--targets') + 1]) if len(sys.argv) > sys.argv.index('--targets') + 1 and sys.argv[sys.argv.index('--targets') + 1].isdigit() else 25
        print(f'\n  next {n} targets (cross-unit, largest first):')
        g = sorted((f for f in fns if f['kind'] == 'cross-unit' and not f['status']),
                   key=lambda f: -f['size'])
        for f in g[:n]:
            bl = ','.join(f['blockers']) or '-'
            print(f'    {f["size"]:5d}  {f["name"]:54s} {bl:24s} {f["src"]}')


if __name__ == '__main__':
    main()
