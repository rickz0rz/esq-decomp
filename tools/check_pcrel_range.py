#!/usr/bin/env python3
"""Detect SILENTLY TRUNCATED 16-bit PC-relative calls in a linked binary.

    python3 tools/check_pcrel_range.py <binary> <vlink -M map>

THIS IS THE CHECK THAT WOULD HAVE FOUND THE ESC-MENU GURU ON DAY ONE.

vlink range-checks SOME 16-bit PC-relative references and refuses to link them --
that is `Error 28: ... doesn't fit into 16 bits`, which this project hit while
padding. But when the reference needs no runtime relocation, because both ends
land in the same output section, vlink resolves it internally and **writes a
truncated displacement without complaint**. The result is a `JSR (d16,PC)` that
jumps exactly 65536 bytes short of its target, into whatever code happens to be
there.

Nothing else in the toolchain can see it:

  - the CODE size is unchanged, so `hunkcmp` reports nothing unusual
  - the relocation COUNT is unchanged, because a same-section PC-relative
    reference emits no reloc either way
  - `cmatch`/`cdiff` compare a function's own bytes, not where its calls land
  - both byte gates stay green; `a6_audit` and `verify_restorations` pass
  - and it only appears once the image grows enough to push a caller/callee pair
    past +/-32767, so it looks like a mysterious layout-sensitive runtime fault

That is exactly what it looked like: a wild jump whose landing address moved with
image layout, not attributable to any single restoration, that went away when
enough restorations were removed.

HOW THE DETECTION WORKS

For every `JSR (d16,PC)` (4EBA) and `BSR.W` (6100) in the code hunk, compute the
target. A correct call targets a function, so the target should be a symbol in
the map. If it is NOT a symbol but `target +/- 65536` IS, the displacement wrapped:
the true distance exceeded the 16-bit signed range and the low 16 bits were kept.
Two further conditions keep it honest, both learned by testing it against the
byte-exact PURE-ASSEMBLY build, which is known to WORK and must therefore report
clean:

  - the required displacement must genuinely be outside -32768..32767, and
  - the ENCODED displacement must be large in magnitude (>32000).

The second is what removes the false positives. A genuine wrap has an encoded
value just inside the limit, because the true distance was just outside it; a
legitimate short branch to a local label that merely happens to sit 64KB from
some symbol has a small displacement. Without this the pure build reported a
+112-byte forward branch as broken.

Exits nonzero if any wrapped call is found. Wire it into every build.
"""
import importlib.util
import os
import re
import struct
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

CALLS = {b'\x4e\xba': 'JSR (d16,PC)', b'\x61\x00': 'BSR.W'}


def load_code(path):
    spec = importlib.util.spec_from_file_location(
        'vr', os.path.join(ROOT, 'tools', 'verify_restorations.py'))
    vr = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(vr)
    return vr.load_hunks(path)[0]['img']


def code_symbols(mappath):
    """{address: name} for the code section only.

    The map lists DATA symbols too, under `Symbols of S_1:`. Mixing them in makes
    a DATA offset look like a code address and produces nonsense -- that mistake
    cost a whole wrong conclusion during this investigation, so the split is not
    optional.
    """
    lines = open(mappath, errors='replace').read().split('\n')
    try:
        i0 = next(i for i, l in enumerate(lines) if l.startswith('Symbols of S_0'))
    except StopIteration:
        sys.exit(f'{mappath}: no "Symbols of S_0" section -- is this a vlink -M map?')
    try:
        i1 = next(i for i, l in enumerate(lines) if l.startswith('Symbols of S_1'))
    except StopIteration:
        i1 = len(lines)
    out = {}
    for l in lines[i0:i1]:
        m = re.match(r'\s+0x([0-9a-f]{8})\s+(\S+?):', l)
        if m:
            out[int(m.group(1), 16)] = m.group(2)
    return out


def main():
    if len(sys.argv) < 3:
        sys.exit('usage: check_pcrel_range.py <binary> <vlink -M map>')
    code = load_code(sys.argv[1])
    sym = code_symbols(sys.argv[2])
    if not sym:
        sys.exit('no code symbols in the map -- link with -M and without -s')

    bad, total = [], 0
    for i in range(0, len(code) - 3, 2):
        op = code[i:i + 2]
        if op not in CALLS:
            continue
        total += 1
        d = struct.unpack('>h', code[i + 2:i + 4])[0]
        target = i + 2 + d
        if target in sym:
            continue
        for wrap in (0x10000, -0x10000):
            real = target + wrap
            if real not in sym:
                continue
            needed = real - (i + 2)
            if -32768 <= needed <= 32767:
                continue            # would have fit; not a wrap
            if abs(d) <= 32000:
                continue            # small displacement: a local label, not a wrap
            if not ((needed > 32767 and d < 0) or (needed < -32768 and d > 0)):
                continue            # encoded value is not the wrapped form
            bad.append((i, CALLS[op], d, target, real, sym[real], needed))
            break

    if bad:
        print('*** SILENTLY TRUNCATED 16-bit PC-RELATIVE CALL(S) ***')
        print('These jump 65536 bytes away from their target, into arbitrary code.')
        print('vlink wrote a wrapped displacement instead of failing the link.\n')
        for i, op, d, t, real, nm, needed in bad:
            print(f'  code+0x{i:06x}  {op}  encoded d={d:+7d} -> +0x{t:06x}')
            print(f'      intended {nm} @ +0x{real:06x}, which needs d={needed:+7d} '
                  f'({needed - 32767:+d} past the limit)')
        print(f'\n{len(bad)} of {total} PC-relative calls are broken.')
        print('FIX: reduce the distance between caller and callee -- drop or reorder')
        print('restorations until this reports clean. See AGENTS.md.')
        return 1

    print(f'check_pcrel_range: clean ({total} PC-relative calls, 0 truncated)')
    return 0


if __name__ == '__main__':
    sys.exit(main())
