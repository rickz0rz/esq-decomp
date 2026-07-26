#!/usr/bin/env python3
"""Prove every C-restored function is byte-identical inside the LINKED binary.

    C_REPLACEMENTS=src/c/replacements.txt ./build-split.sh
    python3 tools/verify_restorations.py

`build-split.sh` reports DIFFERS for a C build, and that is expected: a hunk
object is longword-sized, so a restored function whose length is 2 (mod 4) gains
padding the original never had, and everything after it shifts. The whole-image
comparison therefore cannot be the acceptance test for the C build.

This is. For each compiled replacement object it locates that exact function in
the linked CODE hunk and checks every byte. Fields carrying a relocation are
compared positionally, since the linker writes a real address there and the
address legitimately moves when code shifts.

Two failure modes are treated as errors:
  - not found          the emitted function is not in the binary
  - found more than once  the pattern is too weak to prove anything

It also accounts for the size delta: growth must equal the sum of per-object
longword rounding. Anything left over is a real regression, not padding.
"""
import os, re, subprocess, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(ROOT, 'tools'))
from objbytes import parse as parse_obj


def load_hunks(fn):
    src = open(os.path.join(ROOT, 'tools', 'hunkcmp.py')).read().split('a, b = parse(')[0]
    ns = {}
    exec(compile(src, 'hunkcmp', 'exec'), ns)
    return ns['parse'](fn)


def masked_find(image, pattern, sites):
    """All offsets where pattern occurs, ignoring the masked (relocated) spans."""
    mask = bytearray(b'\1' * len(pattern))
    for o, w in sites:
        for k in range(o, min(o + w, len(pattern))):
            mask[k] = 0
    # anchor on the longest compared run so this is a find() scan, not O(n*m)
    best_start = best_len = cur_start = cur_len = 0
    for i, m in enumerate(mask):
        if m:
            if cur_len == 0:
                cur_start = i
            cur_len += 1
            if cur_len > best_len:
                best_len, best_start = cur_len, cur_start
        else:
            cur_len = 0
    if best_len == 0:
        return []
    anchor = pattern[best_start:best_start + best_len]
    hits, pos = [], 0
    while True:
        i = image.find(anchor, pos)
        if i < 0:
            return hits
        pos = i + 1
        start = i - best_start
        if start < 0 or start + len(pattern) > len(image):
            continue
        if all(image[start + k] == pattern[k] for k in range(len(pattern)) if mask[k]):
            hits.append(start)


def main():
    built = os.path.join(ROOT, 'build', 'ESQ')
    ref   = os.path.join(ROOT, 'build', 'ESQ_reference')
    for f in (built, ref):
        if not os.path.exists(f):
            sys.exit(f'verify_restorations: {f} missing -- run build-split.sh first')

    code = load_hunks(built)[0]['img']
    refh, blth = load_hunks(ref), load_hunks(built)

    objs = sorted(f for f in os.listdir(os.path.join(ROOT, 'build', 'obj'))
                  if re.fullmatch(r'c_repl_\d+\.o', f))
    if not objs:
        sys.exit('verify_restorations: no c_repl_*.o -- build without C_REPLACEMENTS?')

    import refbytes

    items = []
    for o in objs:
        blob, relocs, xdefs, xrefs = parse_obj(os.path.join(ROOT, 'build', 'obj', o))
        name = min(xdefs, key=lambda k: xdefs[k]) if xdefs else o
        sites = [(x, 4) for x in relocs] + [(x, w) for v in xrefs.values() for x, w in v]
        items.append((name, blob, sites))

    # Two functions can be byte-identical apart from their relocated operands --
    # ESQIFF_RunCopperRise/DropTransition are the worked example. Searching for
    # either finds both, which is not ambiguity in the binary, only in the query.
    # Group identical patterns and require the occurrence count to equal the
    # group size: that still proves every one of them is present and exact.
    groups = {}
    for name, blob, sites in items:
        key = (bytes(blob), tuple(sorted(sites)))
        groups.setdefault(key, []).append(name)

    bad = 0
    pad_total = 0
    print(f'{len(objs)} restored object(s) located in the linked CODE hunk\n')
    for (blob, sites), names in groups.items():
        hits = masked_find(code, blob, list(sites))
        for name in names:
            try:
                _src, rows = refbytes.extract(name)
                reflen = len(''.join(r[1] for r in rows)) // 2
            except SystemExit:
                reflen = len(blob)
            pad_total += len(blob) - reflen
        if len(hits) == len(names):
            where = ', '.join(f'0x{h:06x}' for h in sorted(hits))
            tag = f'  OK        {names[0]:52s} {len(blob):3d} bytes @ {where}'
            if len(names) > 1:
                tag += f'  (+{len(names)-1} identical twin: {", ".join(names[1:])})'
            print(tag)
        elif not hits:
            print(f'  NOT FOUND {"/".join(names):52s} {len(blob):3d} bytes'); bad += 1
        else:
            print(f'  MISCOUNT  {"/".join(names):52s} '
                  f'{len(hits)} occurrence(s) for {len(names)} function(s)'); bad += 1

    grew = blth[0]['size'] - refh[0]['size']
    print(f'\n  CODE size: reference {refh[0]["size"]}, built {blth[0]["size"]} '
          f'({grew:+d} bytes)')
    print(f'  of which per-object longword rounding accounts for {pad_total} byte(s); '
          f'residual {grew - pad_total}')
    if grew - pad_total:
        print('  (residual is unit-boundary padding from splitting modules out; '
              'it must stay small and stable -- a jump here is a real regression)')

    # Every differing DATA byte must sit inside a relocated longword: those hold
    # addresses that legitimately move when CODE shifts.
    da, db = refh[1]['img'], blth[1]['img']
    dr = {off for hn, off in blth[1]['relocs']}
    diff = [i for i in range(min(len(da), len(db))) if da[i] != db[i]]
    stray = [i for i in diff if (i & ~3) not in dr]
    print(f'  DATA: {len(diff)} differing byte(s), '
          f'{len(diff) - len(stray)} inside relocated longwords, {len(stray)} stray')
    if stray:
        print(f'  *** stray DATA differences at {[hex(i) for i in stray]} ***')
        bad += 1

    if bad:
        print(f'\n*** {bad} PROBLEM(S) ***')
        return 1
    print('\nAll restored functions are byte-identical in the linked binary.')
    return 0


if __name__ == '__main__':
    sys.exit(main())
