#!/usr/bin/env python3
"""Translate a DATA module from assembly into C.

    python3 tools/data_to_c.py data/cleanup.s            # print the C
    python3 tools/data_to_c.py data/cleanup.s --write    # write src/c/data_cleanup.c

The output is byte-exact by construction: every symbol is emitted with an
EXPLICIT size equal to the span from its label to the next one, so the module
occupies the same bytes in the same order.

Three things make this harder than it looks, and all three are enforced here
rather than left to the reader.

**`NStr` ends in `CNOP 0,2`.** An odd-length string gets a pad byte. SAS/C 6.51
does NOT word-align consecutive char arrays, so the padding has to go into the
declared size or it is lost -- `data/flib.s` compiled 6 bytes short that way.

**A module must be a multiple of 4 bytes.** A hunk object is longword-sized, so
any other length gains padding, the DATA hunk GROWS, and every symbol after it
moves. That froze the display when `data/flib.s` was tried. The tool reports the
size and refuses to mark a module convertible unless it is 0 mod 4.

**A `DC.L <label>` is a RELOCATION, not a number.** It has to stay a pointer in
C or the linker cannot patch it. Spans that mix pointers and constants are
emitted as an array of `long` with casts.

Anything the parser does not recognise is an ERROR, never a guess. A silently
wrong data module is far worse than one that is left in assembly.
"""
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

def load_equates():
    """Every `NAME = value` in the shared headers.

    These were hardcoded once and TWO of the five were wrong -- TextAlignLeft is
    25, not 11. A byte-exact generator that invents byte values is worse than no
    generator, so they are read from the source they are defined in.
    """
    eq = {}
    for f in sorted(os.listdir(os.path.join(ROOT, 'src'))):
        if not f.endswith('.s'):
            continue
        for line in open(os.path.join(ROOT, 'src', f)):
            line = line.split(';')[0]
            m = re.match(r'^\s*([A-Za-z_][\w]*)\s*(?:=|EQU)\s*(\$?-?[0-9A-Fa-f]+)\s*$',
                         line)
            if m:
                v = m.group(2)
                try:
                    eq[m.group(1)] = int(v[1:], 16) if v.startswith('$') else int(v)
                except ValueError:
                    pass
    return eq


EQU = load_equates()


class Unsupported(Exception):
    pass


def _split_operands(s):
    """Split a DC operand list on commas that are not inside a string."""
    out, cur, q = [], '', None
    for ch in s:
        if q:
            cur += ch
            if ch == q:
                q = None
        elif ch in '"\'':
            q = ch
            cur += ch
        elif ch == ',':
            out.append(cur.strip())
            cur = ''
        else:
            cur += ch
    if cur.strip():
        out.append(cur.strip())
    return out


def _value(tok):
    """A DC operand as an int, or a symbol name for a relocation."""
    tok = tok.strip()
    if tok.startswith('$'):
        return int(tok[1:], 16)
    if tok.startswith('%'):
        return int(tok[1:], 2)
    if re.fullmatch(r'-?\d+', tok):
        return int(tok)
    if tok in EQU:
        return EQU[tok]
    if re.fullmatch(r"'.'", tok):
        return ord(tok[1])
    if re.fullmatch(r'[A-Za-z_][\w]*', tok):
        return tok                      # a symbol: relocation
    raise Unsupported('operand %r' % tok)


def parse(path):
    """-> list of (label|None, items) where items are ('b',int) ('w',int)
    ('l',int|sym) ('s',bytes) ('pad',n)."""
    spans = []
    cur = None
    off = 0

    def emit(kind, val, size):
        nonlocal off
        cur[1].append((kind, val))
        off += size

    for raw in open(os.path.join(ROOT, 'src', path)):
        line = raw.split(';')[0].rstrip()
        if not line.strip():
            continue
        m = re.match(r'^([A-Za-z_][\w]*):\s*$', line)
        if m:
            cur = (m.group(1), [])
            spans.append(cur)
            continue
        body = line.strip()
        op = body.split(None, 1)
        mnem = op[0].upper()
        rest = op[1] if len(op) > 1 else ''

        # `assert` is a build-time consistency check against data-lengths.s and
        # emits no bytes. A local `NAME = value` is an assembler equate, also no
        # bytes -- but it may be USED below, so record it.
        if mnem == 'ASSERT':
            continue
        m = re.match(r'^([A-Za-z_][\w]*)\s*(?:=|EQU)\s*(\S+)\s*$', body)
        if m and cur is not None or (m and cur is None):
            try:
                v = m.group(2)
                EQU[m.group(1)] = int(v[1:], 16) if v.startswith('$') else int(v)
                continue
            except ValueError:
                pass
        if mnem in ('XDEF', 'XREF', 'SECTION', 'INCLUDE', 'IFND', 'ENDC', 'IFD',
                    'END', 'ALIGN_WORD'):
            if mnem == 'ALIGN_WORD':
                if off % 2:
                    emit('pad', 1, 1)
            continue
        if cur is None:
            raise Unsupported('data before the first label: %r' % body)

        if mnem.startswith('NSTR') or mnem == 'STR':
            # Str is `DC.B \1` + CNOP; NStr/NStr2/NStr3 append a NUL first.
            n = 1 if mnem in ('NSTR', 'STR') else int(mnem[4:])
            parts = _split_operands(rest)
            if len(parts) != n:
                raise Unsupported('%s with %d operands' % (mnem, len(parts)))
            text = b''
            for p in parts:
                if p.startswith('"') and p.endswith('"'):
                    text += p[1:-1].encode('latin-1')
                else:
                    v = _value(p)          # a byte value, e.g. TextLineFeed
                    if not isinstance(v, int):
                        raise Unsupported('%s operand %r' % (mnem, p))
                    text += bytes([v & 0xff])
            if mnem != 'STR':
                text += b'\0'
            emit('s', text, len(text))
            if off % 2:                                  # the CNOP 0,2
                emit('pad', 1, 1)
            continue

        if mnem in ('DC.B', 'DC.W', 'DC.L'):
            width = {'DC.B': 1, 'DC.W': 2, 'DC.L': 4}[mnem]
            for tok in _split_operands(rest):
                if tok.startswith('"') and tok.endswith('"'):
                    if width != 1:
                        raise Unsupported('string in %s' % mnem)
                    for ch in tok[1:-1].encode('latin-1'):
                        emit('b', ch, 1)
                    continue
                v = _value(tok)
                emit({1: 'b', 2: 'w', 4: 'l'}[width], v, width)
            continue

        if mnem in ('DS.B', 'DS.W', 'DS.L'):
            width = {'DS.B': 1, 'DS.W': 2, 'DS.L': 4}[mnem]
            n = _value(rest)
            if not isinstance(n, int):
                raise Unsupported('%s %r' % (mnem, rest))
            for _ in range(n * width):
                emit('b', 0, 1)
            continue

        if mnem == 'CNOP':
            a, b = [int(x.strip()) for x in rest.split(',')]
            while off % b != a:
                emit('pad', 1, 1)
            continue

        raise Unsupported('directive %r' % body)

    return spans, off


def span_bytes(items):
    n = 0
    for kind, val in items:
        n += {'b': 1, 'w': 2, 'l': 4, 'pad': 1}[kind] if kind != 's' else len(val)
    return n


def to_c(path, spans, total):
    name = os.path.basename(path)[:-2]
    out = []
    out.append('/* RESTORES: (data module -- no function)')
    out.append(' * MODULE:   %s' % path)
    out.append(' * STATUS:   behavioural')
    out.append(' *')
    out.append(' * Generated by tools/data_to_c.py, then read. %d bytes.' % total)
    out.append(' *')
    out.append(' * Every array carries an EXPLICIT size: the span from its label to the next')
    out.append(' * one, padding included. `NStr` ends in `CNOP 0,2` and SAS/C 6.51 does not')
    out.append(' * word-align consecutive char arrays, so the padding has to be declared or it')
    out.append(' * is lost. See src/c/data_displib.c for the whole story, and AGENTS.md for the')
    out.append(' * rule that a data module must be a multiple of 4 bytes.')
    out.append(' */')
    out.append('')

    referenced = set()
    for _, items in spans:
        for k, v in items:
            if k == 'l' and isinstance(v, str):
                referenced.add(v)

    # A forward declaration must name the SAME TYPE the definition will use.
    # Emitting `extern unsigned char X[]` above `char X[36] = "..."` is
    # "Error 72: conflict with previous declaration", and it took out every
    # string in data/ctasks.s that a pointer table happens to reference. So the
    # declarations are decided here, in one pass, before anything is written.
    decl = {}
    for label, items in spans:
        kinds = {k for k, _ in items}
        if kinds <= {'s', 'pad'} and sum(1 for k, _ in items if k == 's') == 1:
            text = next(v for k, v in items if k == 's')
            body = text[:-1] if text.endswith(b'\0') else text
            decl[label] = 'char' if all(32 <= b < 127 for b in body) else 'unsigned char'
        elif len(items) == 1 and items[0][0] in ('b', 'w', 'l') \
                and isinstance(items[0][1], int):
            decl[label] = {'b': 'unsigned char', 'w': 'short', 'l': 'long'}[items[0][0]]
        elif 'l' in kinds and any(isinstance(v, str) for k, v in items if k == 'l'):
            decl[label] = 'long'
        else:
            decl[label] = 'unsigned char'

    local = [l for l, _ in spans if l in referenced]
    if local:
        out.append('/* Forward declarations for the pointer tables below. The type has to')
        out.append(' * match the definition exactly or 6.51 rejects the pair. */')
        for l in local:
            ty = decl[l]
            arr = '' if ty in ('short', 'long') and \
                  len([1 for lb, it in spans if lb == l and len(it) == 1]) else '[]'
            out.append('extern %s %s%s;' % (ty, l.lstrip('_'), arr))
        out.append('')

    for label, items in spans:
        n = span_bytes(items)
        cname = label.lstrip('_')
        kinds = {k for k, _ in items}
        # a single NStr (optionally padded) -> a readable string
        if kinds <= {'s', 'pad'} and sum(1 for k, _ in items if k == 's') == 1:
            text = next(v for k, v in items if k == 's')
            if text.endswith(b'\0'):
                text = text[:-1]
            if all(32 <= b < 127 for b in text):
                lit = text.decode('latin-1').replace('\\', '\\\\').replace('"', '\\"')
                out.append('char %s[%d] = "%s";' % (cname, n, lit))
                continue
        # a lone scalar keeps its width, so the C reads like the assembly and
        # so a reader is not left decoding four hex bytes to find a flag
        if len(items) == 1 and items[0][0] in ('b', 'w', 'l') \
                and isinstance(items[0][1], int):
            ctype = {'b': 'unsigned char', 'w': 'short', 'l': 'long'}[items[0][0]]
            v = items[0][1]
            if items[0][0] == 'w' and v > 0x7fff:
                v -= 0x10000
            out.append('%s %s = %d;' % (ctype, cname, v))
            continue
        # a relocation beside NARROWER data -> an anonymous struct, one field per
        # item at its own width. This is the AmigaOS TextAttr shape: a STRPTR, a
        # UWORD and two UBYTEs. An array of long cannot express it and a byte
        # array would lose the relocation, so the linker could not patch the
        # pointer and the font name would be a wild address.
        if 'l' in kinds and any(isinstance(v, str) for k, v in items if k == 'l') \
                and kinds - {'l'}:
            fields, vals, o = [], [], 0
            for k, v in items:
                ctype, w = {'b': ('unsigned char', 1), 'w': ('unsigned short', 2),
                            'l': ('long', 4), 'pad': ('unsigned char', 1)}[k]
                if k == 'l' and isinstance(v, str):
                    ctype = 'char *'
                    vals.append(v.lstrip('_'))
                elif k == 'pad':
                    vals.append('0')
                else:
                    vals.append(str(v))
                fields.append('    %s f%d;' % (ctype, o))
                o += w
            out.append('struct %s_t {' % cname)
            out.extend(fields)
            out.append('} %s = { %s };' % (cname, ', '.join(vals)))
            continue
        # a pure pointer/long table -> an array of long with casts
        if 'l' in kinds and any(isinstance(v, str) for k, v in items if k == 'l'):
            vals = []
            for _, v in items:
                vals.append('(long)%s' % v.lstrip('_') if isinstance(v, str)
                            else '0x%08xL' % (v & 0xffffffff))
            out.append('long %s[%d] = {' % (cname, n // 4))
            for i in range(0, len(vals), 4):
                out.append('    ' + ', '.join(vals[i:i + 4]) + ',')
            out[-1] = out[-1].rstrip(',')
            out.append('};')
            continue
        # otherwise: raw bytes, which is byte-exact whatever the span holds
        by = bytearray()
        for k, v in items:
            if k == 's':
                by += v
            elif k == 'pad':
                by += b'\0'
            elif k == 'b':
                by.append(v & 0xff)
            elif k == 'w':
                by += bytes([(v >> 8) & 0xff, v & 0xff])
            elif k == 'l':
                by += bytes([(v >> 24) & 0xff, (v >> 16) & 0xff,
                             (v >> 8) & 0xff, v & 0xff])
        out.append('unsigned char %s[%d] = {' % (cname, n))
        for i in range(0, len(by), 12):
            out.append('    ' + ', '.join('0x%02x' % b for b in by[i:i + 12]) + ',')
        out[-1] = out[-1].rstrip(',')
        out.append('};')
    out.append('')
    return '\n'.join(out)


def layout_check(path):
    """Is replacing `path` layout-neutral? -> (ok, size, start_offset)

    The size rule alone is NOT enough, and believing it cost a frozen display.
    `gen_units.coalesce()` groups consecutive data modules until the running
    total is a whole number of longwords, and it FORCE-CLOSES the current group
    in front of a replaced module. If that group was mid-longword, the assembly
    unit it closes gets padded and everything after it moves.

    So a module is layout-neutral only when the group boundary was already there:
    its START OFFSET must be 4-aligned as well as its own size.

    Validated by simulating the whole data group and comparing against real
    builds: the pure build is 55,820 bytes and the simulator says 55,820; a
    13-module set that included four offset-unaligned modules measured 55,832 and
    the simulator says 55,832.
    """
    sys.path.insert(0, os.path.join(ROOT, 'tools'))
    old_env = os.environ.copy()
    os.environ.pop('C_REPLACEMENTS', None)
    os.environ.pop('ESQ_FARCALLS', None)
    try:
        import gen_units as gu
        prelude, incs = gu.read_root()
        os.makedirs(gu.OUT, exist_ok=True)
        gu.far_rewrite(incs)
        sizes, ncode = gu.measure(incs)
        off = 0
        for p, s in zip(incs[ncode:], sizes[ncode:]):
            if p == path:
                return (off % 4 == 0 and s % 4 == 0), s, off
            off += s
        return False, None, None
    finally:
        os.environ.clear()
        os.environ.update(old_env)


def vasm_size(path):
    """What the ASSEMBLER says the module occupies.

    The parser's own arithmetic is not evidence. Cross-checking it against vasm
    caught three modules it measured wrong -- ladfunc and ed2 by 2, diskio2 by 4
    -- and a generator that is 2 bytes out produces a data module that links,
    runs for a while and then does something inexplicable. `--write` refuses
    unless the two agree.
    """
    sys.path.insert(0, os.path.join(ROOT, 'tools'))
    env = dict(os.environ)
    env.pop('C_REPLACEMENTS', None)
    env.pop('ESQ_FARCALLS', None)
    old_env = os.environ.copy()
    os.environ.clear(); os.environ.update(env)
    try:
        import gen_units as gu
        prelude, incs = gu.read_root()
        os.makedirs(gu.OUT, exist_ok=True)
        gu.far_rewrite(incs)
        sizes, ncode = gu.measure(incs)
        return dict(zip(incs, sizes)).get(path)
    finally:
        os.environ.clear(); os.environ.update(old_env)


def main():
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    path = sys.argv[1]
    try:
        spans, total = parse(path)
    except Unsupported as e:
        sys.exit('data_to_c: %s: UNSUPPORTED: %s' % (path, e))
    try:
        c = to_c(path, spans, total)
    except Unsupported as e:
        sys.exit('data_to_c: %s: UNSUPPORTED: %s' % (path, e))
    status = 'CONVERTIBLE' if total % 4 == 0 else 'BLOCKED (not a multiple of 4)'
    sys.stderr.write('%s: %d bytes, %d symbols -- %s\n'
                     % (path, total, len(spans), status))
    if '--write' in sys.argv:
        real = vasm_size(path)
        if real != total:
            sys.exit('data_to_c: %s: REFUSING -- parser says %d bytes, vasm says '
                     '%s. Fix the parser before writing anything.'
                     % (path, total, real))
        ok, sz, off = layout_check(path)
        if not ok:
            sys.exit('data_to_c: %s: REFUSING -- not layout-neutral. size=%s '
                     '(%s mod 4), start offset=%s (%s mod 4). BOTH must be 0: a '
                     'replaced module force-closes the assembly group in front '
                     'of it, so an unaligned start pads that group and moves '
                     'every symbol after it. See AGENTS.md.'
                     % (path, sz, sz % 4, off, off % 4))
        dst = os.path.join(ROOT, 'src', 'c',
                           'data_' + os.path.basename(path)[:-2] + '.c')
        open(dst, 'w').write(c)
        sys.stderr.write('wrote %s\n' % dst)
    else:
        print(c)


if __name__ == '__main__':
    main()
