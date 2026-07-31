#!/usr/bin/env python3
"""Compare the (d16,An) DISPLACEMENTS a restoration emits against the original's.

A wrong struct layout is invisible to every other check: `cdiff` masks relocated
fields, both byte gates ignore C, and a `behavioural` file is never compared at
all. But a struct shift shows up directly as register-relative displacements the
original never uses -- brush_select_brush_slot.c padded for a 32-byte BitMap when
it is 40, and every field below it moved by 8, which is what this finds.

    /tmp/.capvenv/bin/python tools/offset_audit.py [file.c ...]

With no arguments it audits every entry in src/c/replacements-all.txt.
Exits nonzero if any file emits a displacement set the original does not have.
"""
import os, re, subprocess, sys, collections
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
try:
    from capstone import Cs, CS_ARCH_M68K, CS_MODE_M68K_000
except ImportError:
    sys.exit('needs capstone: /tmp/.capvenv/bin/pip install capstone')
MD = Cs(CS_ARCH_M68K, CS_MODE_M68K_000)

def disps(hexstr):
    """Multiset of (d16,An) displacements, An != a7 (a7 is stack, not a struct)."""
    out = collections.Counter()
    try:
        code = bytes.fromhex(hexstr)
    except ValueError:
        return out
    for ins in MD.disasm(code, 0):
        for m in re.finditer(r'(-?(?:0x)?[0-9a-fA-F]+)\((a[0-6])\)', ins.op_str):
            v = m.group(1)
            try:
                out[int(v, 16) if v.startswith('0x') or v.startswith('-0x') else int(v)] += 1
            except ValueError:
                pass
    return out

def run(cfile, label, opts):
    o = subprocess.run([os.path.join(ROOT, 'tools/cmatch.sh'), cfile, label] + opts,
                       capture_output=True, text=True, cwd=ROOT).stdout
    ref = re.search(r'^  ref ([0-9a-f]+)', o, re.M)
    got = re.search(r'^  got ([0-9a-f]+)', o, re.M)
    if 'MATCH' in o.split('\n')[0]:
        return None                      # byte-identical: offsets provably fine
    return (ref.group(1) if ref else None, got.group(1) if got else None)

def main():
    ents = []
    if len(sys.argv) > 1:
        for f in sys.argv[1:]:
            ents.append((f, []))
    else:
        for line in open(os.path.join(ROOT, 'src/c/replacements-all.txt')):
            s = line.split()
            if line.strip() and not line.startswith('#') and len(s) > 1:
                ents.append(('src/' + s[1], s[2:]))
    bad = 0
    for cfile, opts in ents:
        path = os.path.join(ROOT, cfile)
        if not os.path.exists(path):
            continue
        t = open(path, errors='replace').read(3000)
        m = re.search(r'RESTORES:\s*(\S+)', t)
        if not m:
            continue
        r = run(cfile, m.group(1), opts)
        if r is None:
            continue
        ref_hex, got_hex = r
        if not ref_hex or not got_hex:
            continue
        dr, dg = disps(ref_hex), disps(got_hex)
        extra = sorted(d for d in dg if d not in dr and d > 8)
        missing = sorted(d for d in dr if d not in dg and d > 8)
        if extra and missing:
            bad += 1
            print('%s' % os.path.basename(cfile))
            print('    original uses displacements the C never emits: %s' % missing[:10])
            print('    C emits displacements the original never has:  %s' % extra[:10])
            shifts = collections.Counter(e - mm for e in extra for mm in missing)
            top, n = shifts.most_common(1)[0]
            if n >= 2 and top:
                print('    ==> looks like a CONSTANT SHIFT of %+d bytes (%d field pairs)' % (top, n))
    print('\noffset_audit: %d file(s) with a suspicious displacement set' % bad)
    return 1 if bad else 0

if __name__ == '__main__':
    sys.exit(main())
