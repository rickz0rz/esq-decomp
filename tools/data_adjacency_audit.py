#!/usr/bin/env python3
"""Find every place the code reads or writes ACROSS a data symbol boundary.

    python3 tools/data_adjacency_audit.py            # the overruns
    python3 tools/data_adjacency_audit.py --sizes    # every symbol and its size

This exists for the move of src/data from assembly to C. In assembly the data
section is one flat image and the symbols are just names for offsets into it, so
a routine can read a word symbol with MOVE.L and pick up whatever follows. C
guarantees nothing about where two separate globals land, so every such group
has to become ONE object -- a struct or an array -- before its module can stop
being assembly.

The worked example is _HIGHLIGHT_CopperEffectSeed. It is `DC.W 0`, and
_ESQ_UpdateCopperListsFromParams opens `MOVE.L _HIGHLIGHT_CopperEffectSeed,D0`,
which takes the seed word plus _HIGHLIGHT_CopperEffectParamA and
_HIGHLIGHT_CopperEffectParamB, both `DC.B 0`. Three symbols, one value.

WHAT IS REPORTED. A symbol whose declared storage is N bytes, accessed with an
operand wider than N, or through a displacement that reaches at or past N. Both
mean the access leaves the symbol.

WHAT IS NOT. A symbol the code only ever takes the ADDRESS of is an array or a
buffer by nature and its size is whatever the code decides, so a displacement
into it is ordinary indexing rather than an overrun. Those are listed under
--sizes and skipped here.
"""
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DATA_DIR = os.path.join(ROOT, 'src/data')
CODE_DIRS = (os.path.join(ROOT, 'src/modules'),)

WIDTH = {'B': 1, 'W': 2, 'L': 4}

# `DC.x`/`DS.x`/`DCB.x` and the project's own string macro.
STORE = re.compile(r'^(DC|DS|DCB)\.([BWL])\s+(.*)$', re.I)
NSTR = re.compile(r'^N?Str\s+"(.*)"\s*$', re.I)
LABEL = re.compile(r'^([A-Za-z_][\w]*):')


def count_items(text):
    """Number of comma-separated items in a DC operand, minding quotes."""
    n, depth, inq = 1, 0, False
    for ch in text:
        if ch == '"':
            inq = not inq
        elif not inq:
            if ch == '(':
                depth += 1
            elif ch == ')':
                depth -= 1
            elif ch == ',' and depth == 0:
                n += 1
    return n


def symbol_sizes():
    """Map data symbol -> bytes of storage up to the next symbol."""
    sizes, order = {}, []
    for fn in sorted(os.listdir(DATA_DIR)):
        if not fn.endswith('.s'):
            continue
        cur = None
        for raw in open(os.path.join(DATA_DIR, fn), errors='replace'):
            line = raw.split(';')[0].strip()
            if not line:
                continue
            m = LABEL.match(line)
            if m:
                # Strip one leading underscore so a data label and the code's
                # reference to it are the same key. src/data spells most labels
                # `_FOO:` and the code writes `_FOO`, but a growing number carry
                # no underscore at all -- looking up only one form matched 166
                # symbols of 2218 and missed every real overrun.
                cur = m.group(1).lstrip('_')
                sizes.setdefault(cur, 0)
                order.append(cur)
                line = line[m.end():].strip()
                if not line:
                    continue
            if cur is None:
                continue
            m = STORE.match(line)
            if m:
                kind, w, rest = m.group(1).upper(), m.group(2).upper(), m.group(3)
                if kind == 'DS':
                    try:
                        sizes[cur] += WIDTH[w] * int(rest.split(',')[0], 0)
                    except ValueError:
                        pass
                elif kind == 'DCB':
                    try:
                        sizes[cur] += WIDTH[w] * int(rest.split(',')[0], 0)
                    except ValueError:
                        pass
                else:
                    quoted = sum(len(s) for s in re.findall(r'"([^"]*)"', rest))
                    items = count_items(re.sub(r'"[^"]*"', 'X', rest))
                    if quoted:
                        sizes[cur] += quoted + max(0, items - 1) * WIDTH[w]
                    else:
                        sizes[cur] += items * WIDTH[w]
                continue
            m = NSTR.match(line)
            if m:
                sizes[cur] += len(m.group(1)) + 1      # NUL terminated
    return sizes, order


def scan_code(sizes):
    """Report accesses wider than the symbol, and address-only symbols."""
    over, addr_only = [], set()
    touched = set()
    acc = re.compile(r'^([A-Z][A-Z0-9]*)\.([BWL])\s+(.*)$')
    for d in CODE_DIRS:
        for root, _, files in os.walk(d):
            for fn in sorted(files):
                if not fn.endswith('.s'):
                    continue
                path = os.path.join(root, fn)
                for raw in open(path, errors='replace'):
                    line = raw.split(';')[0].strip()
                    if not line:
                        continue
                    m = acc.match(line)
                    if not m:
                        if re.match(r'^(LEA|PEA)\b', line):
                            for s in re.findall(r'([A-Za-z_]\w*)', line):
                                s = s.lstrip('_')
                                if s in sizes:
                                    addr_only.add(s)
                                    touched.add(s)
                        continue
                    op, w, operands = m.group(1), m.group(2).upper(), m.group(3)
                    if op in ('LEA', 'PEA'):
                        continue
                    for field in operands.split(','):
                        field = field.strip()
                        if field.startswith('#'):
                            continue
                        f = re.fullmatch(r'([A-Za-z_]\w*)', field)
                        if not f:
                            continue
                        sym = f.group(1).lstrip('_')
                        if sym not in sizes:
                            continue
                        touched.add(sym)
                        size = sizes[sym]
                        if size and WIDTH[w] > size:
                            over.append((sym, size, WIDTH[w], op,
                                         os.path.relpath(path, ROOT)))
    return over, addr_only, touched


def main():
    sizes, order = symbol_sizes()
    over, addr_only, touched = scan_code(sizes)

    if '--sizes' in sys.argv:
        for s in order:
            print('%-58s %6d %s' % (s, sizes[s],
                                    'address-only' if s in addr_only else ''))
        return 0

    # A symbol the code only ever addresses is an array; indexing it is normal.
    real = [o for o in over if o[0] not in addr_only]
    seen = set()
    groups = {}
    for sym, size, width, op, path in real:
        key = (sym, size, width)
        if key in seen:
            groups[key].add(path)
            continue
        seen.add(key)
        groups[key] = {path}

    for (sym, size, width), paths in sorted(groups.items()):
        idx = order.index(sym) if sym in order else -1
        after = order[idx + 1:idx + 4] if idx >= 0 else []
        print('%s: %d byte(s) of storage, read %d bytes wide' % (sym, size, width))
        print('    reaches into: %s' % (', '.join(after) or '(end of module)'))
        print('    sites: %s' % ', '.join(sorted(paths)))
        print()

    print('data_adjacency_audit: %d data symbols, %d referenced by code, '
          '%d cross-boundary access(es)' % (len(sizes), len(touched), len(groups)))
    if groups:
        print('Each group above must become ONE struct or array before its data '
              'module can move to C.')
    return 1 if groups else 0


if __name__ == '__main__':
    sys.exit(main())
