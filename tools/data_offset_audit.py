#!/usr/bin/env python3
"""Compare a converted DATA module's C symbol offsets against the assembly.

    python3 tools/data_offset_audit.py [manifest]

WHY THE EXISTING CHECKS CANNOT SEE THIS. `data_to_c.py` cross-checks its own
arithmetic against vasm, so it knows the module is 144 bytes. That is the sum of
the spans it PARSED, not what the compiler EMITS. SAS/C gives a struct holding a
`long` an alignment of 2, so a 41-byte struct is written as 42, and every symbol
after it in the module moves by one byte while the parser total still says 144.

Both byte gates ignore a C build. `data_shape_audit.py` asks whether a symbol IS
the data or POINTS AT it. `extern_width_audit.py` compares declared widths. None
of them reads where a symbol LANDS.

`data/textdisp_p2.s` is the case that produced this tool:
`_TEXTDISP_FormatEntryFallbackTable` is two pointers, eight longs and a trailing
`DC.B 0`. The C put `_TEXTDISP_CenterAlignToken` at 112 where the assembly has
it at 111, and the DATA hunk grew 4 bytes.

The audit assembles each converted data module on its own, reads the label
offsets out of the object, compiles the C file, reads its symbol offsets, and
reports every symbol whose offset disagrees. It exits nonzero on any hit.
"""
import os
import re
import struct
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
BUILD = os.path.join(ROOT, 'build', 'offsetaudit')
VASM = os.environ.get('VASM_BIN',
                      os.path.expanduser('~/Downloads/vbcc_installer/vasm/vasmm68k_mot'))


def hunk_symbols(path):
    """{name: offset} for every symbol the object DEFINES, plus total data size."""
    d = open(path, 'rb').read()
    i, n, defs, size = 0, len(d), {}, 0
    while i + 4 <= n:
        w = struct.unpack('>I', d[i:i + 4])[0]
        t = w & 0x3FFFFFFF
        i += 4
        if t in (0x3E7, 0x3E8):
            ln = struct.unpack('>I', d[i:i + 4])[0]
            i += 4 + ln * 4
        elif t in (0x3E9, 0x3EA):
            ln = struct.unpack('>I', d[i:i + 4])[0]
            i += 4
            size += ln * 4
            i += ln * 4
        elif t == 0x3EB:
            i += 4
        elif t in (0x3EC, 0x3ED, 0x3EE, 0x3F7):
            while i + 4 <= n:
                c = struct.unpack('>I', d[i:i + 4])[0]
                i += 4
                if c == 0:
                    break
                i += 4 + c * 4
        elif t == 0x3F1:
            ln = struct.unpack('>I', d[i:i + 4])[0]
            i += 4 + ln * 4
        elif t == 0x3F0:
            while i + 4 <= n:
                w2 = struct.unpack('>I', d[i:i + 4])[0]
                i += 4
                if w2 == 0:
                    break
                nm = d[i:i + (w2 & 0xFFFFFF) * 4].rstrip(b'\0').decode('latin1')
                i += (w2 & 0xFFFFFF) * 4
                defs.setdefault(nm, struct.unpack('>I', d[i:i + 4])[0])
                i += 4
        elif t == 0x3EF:
            while i + 4 <= n:
                w2 = struct.unpack('>I', d[i:i + 4])[0]
                i += 4
                if w2 == 0:
                    break
                k, ln = w2 >> 24, w2 & 0xFFFFFF
                nm = d[i:i + ln * 4].rstrip(b'\0').decode('latin1')
                i += ln * 4
                if k in (0, 1, 2, 3):
                    v = struct.unpack('>I', d[i:i + 4])[0]
                    i += 4
                    if k in (0, 1):
                        defs[nm] = v
                elif k == 130:
                    i += 4
                    c = struct.unpack('>I', d[i:i + 4])[0]
                    i += 4 + c * 4
                else:
                    c = struct.unpack('>I', d[i:i + 4])[0]
                    i += 4 + c * 4
        elif t == 0x3F2:
            pass
        else:
            break
    return defs, size


def asm_symbols(module):
    """Assemble one data module alone and read its label offsets."""
    os.makedirs(BUILD, exist_ok=True)
    src = os.path.join(BUILD, 'm.s')
    obj = os.path.join(BUILD, 'm.o')
    body = open(os.path.join(ROOT, 'src', module)).read()
    with open(src, 'w') as f:
        # Both build variants are gated on these, and a module that mentions one
        # will not assemble without it. The value does not matter here: the audit
        # compares the C against the assembly built the SAME way, and the default
        # build is what every other tool measures.
        f.write('includeCustomAriAssembly = 0\n')
        f.write('fixEscMenuExitDisplayMode = 0\n')
        f.write('    SECTION S_1,DATA,CHIP\n')
        for h in ('lvo-offsets.s', 'hardware-addresses.s', 'structs.s', 'macros.s',
                  'string-macros.s', 'text-formatting.s', 'exec-constants.s',
                  'data-offsets.s', 'data-lengths.s'):
            p = os.path.join(ROOT, 'src', h)
            if os.path.exists(p):
                f.write('    include "%s"\n' % p)
        f.write(body)
    r = subprocess.run([VASM, '-Fhunk', '-quiet', '-o', obj, src],
                       capture_output=True, text=True)
    if r.returncode != 0:
        return None, r.stderr.strip().split('\n')[-1]
    defs, _ = hunk_symbols(obj)
    return defs, None


def is_filename_string(sym, literals):
    """True when `sym` names a source-file-name string that src/c now inlines.

    Four naming shapes occur and every name-shaped pattern missed one:
    Global_STR_BRUSH_C_1, Global_STR_ESQDISP_C (no index), Global_ESQPARS2_C_1
    (no STR_ infix) and TLIBA1_STR_TLIBA1_DOT_C. So the rule is driven by the
    CONTENT: some literal "<stem>.c" must exist in src/c, the symbol name must
    contain that stem, and the name must end in the _C the convention uses.

    tools/data_to_c.py applies the same rule when deciding not to emit one, so
    the generator and this audit cannot disagree about which symbols are
    deliberately absent.
    """
    name = sym.lstrip('_').upper()
    if not (name.endswith('_C') or re.search(r'_C_\d+$', name)):
        return False
    return any(lit[:-2] in name for lit in literals)


def omitted_symbols():
    """Data symbols a C module deliberately does NOT define.

    A source-file-name string such as "BRUSH.c" is the __FILE__ argument the
    original passed to MEMORY_AllocateMemory. Those are written as literals at
    the call sites now, so the data module no longer defines them and the
    module's remaining symbols legitimately sit at lower offsets.

    WITHOUT THIS THE AUDIT SILENTLY STOPS CHECKING. Its match rule required the
    compiled object to define EVERY symbol the assembly module has; when one is
    missing it skipped the module and still counted it as checked. Removing
    these strings blinded it on 38 of 50 modules while it printed
    "offsets agree".
    """
    out = set()
    cdir = os.path.join(ROOT, 'src', 'c')
    for fn in os.listdir(cdir):
        if not fn.endswith('.c'):
            continue
        txt = open(os.path.join(cdir, fn), errors='replace').read()
        for m in re.finditer(r'"([A-Za-z0-9_]+\.c)"', txt):
            out.add(m.group(1))
    return out


def main():
    manifest = sys.argv[1] if len(sys.argv) > 1 else \
        os.path.join(ROOT, 'src', 'c', 'replacements-all.txt')
    rows = []
    for line in open(manifest):
        line = line.split('#')[0].strip()
        if not line:
            continue
        p = line.split()
        if len(p) >= 2 and p[0].startswith('data/'):
            rows.append((p[0], p[1]))
    if not rows:
        print('data_offset_audit: no data modules in %s' % manifest)
        return 0

    # Only objects the CURRENT link used. build/obj is never cleaned, so it holds
    # objects from every earlier build -- matching against those reported four
    # modules as shifted by thousands of bytes when nothing was wrong with them.
    objdir = os.path.join(ROOT, 'build', 'obj')
    objlist = os.path.join(ROOT, 'build', 'objlist')
    if os.path.exists(objlist):
        candidates = [l.strip() for l in open(objlist) if l.strip()]
    elif os.path.isdir(objdir):
        candidates = [os.path.join(objdir, f) for f in os.listdir(objdir)
                      if f.endswith('.o')]
    else:
        candidates = []
    cobjs = {}
    for p in candidates:
        try:
            defs, size = hunk_symbols(p)
        except Exception:
            continue
        if defs:
            cobjs[os.path.basename(p)] = (defs, size)

    bad = 0
    unchecked = 0
    omit_syms = set()          # filled per module, below
    literals = {s.upper() for s in omitted_symbols()}
    for module, cfile in rows:
        a, err = asm_symbols(module)
        if a is None:
            print('%-28s  could not assemble: %s' % (module, err))
            bad += 1
            continue
        # Find the compiled object that defines the same symbol set.
        want = set(a)
        hit = None
        for f, (defs, size) in cobjs.items():
            if want and want <= set(defs):
                hit = (f, defs, size)
                break
        if hit is None:
            # Retry allowing DELIBERATELY OMITTED symbols to be absent. A
            # source-file-name string such as "BRUSH.c" is the __FILE__ argument
            # the original passed to MEMORY_AllocateMemory; those are literals
            # at the call sites now, so the data module no longer defines them.
            # Anything ELSE missing is a real fault and still fails the match.
            for f, (defs, size) in cobjs.items():
                missing = set(a) - set(defs)
                if not missing or missing == set(a):
                    continue
                if not all(is_filename_string(s, literals) for s in missing):
                    continue
                if set(a) - missing <= set(defs):
                    hit = (f, defs, size)
                    omit_syms = missing
                    break
        if hit is None:
            print('%-28s  NOT CHECKED: no object defines its symbols' % module)
            unchecked += 1
            continue
        f, defs, size = hit
        # A replaced module can sit at a nonzero offset inside a coalesced
        # object, so only the offsets RELATIVE to the module's first symbol
        # carry meaning. Anchor both sides on that symbol.
        # Anchor on the first symbol the OBJECT actually defines: a replaced
        # module can sit at a nonzero offset inside a coalesced object, and the
        # module's first symbol may itself be one of the omitted strings.
        order = sorted(a, key=lambda k: a[k])
        present = [s for s in order if s in defs]
        if not present:
            print('%-28s  NOT CHECKED: object defines none of its symbols' % module)
            unchecked += 1
            continue
        first = present[0]
        abase, cbase = a[first], defs[first]

        # Size of each omitted symbol, from the gap to the next assembly label.
        span = {}
        for i, s in enumerate(order):
            span[s] = (a[order[i + 1]] - a[s]) if i + 1 < len(order) else 0

        diffs = []
        for s in present:
            drop = sum(span[o] for o in order
                       if o in omit_syms and abase <= a[o] < a[s])
            if (defs[s] - cbase) != (a[s] - abase - drop):
                diffs.append((s, a[s] - abase - drop, defs[s] - cbase))
        if diffs:
            bad += 1
            print('%s  (%s)' % (module, f))
            for s, ao, co in diffs:
                print('    %-46s asm=%-6d c=%-6d %+d' % (s, ao, co, co - ao))
    if unchecked:
        print('data_offset_audit: %d module(s) NOT CHECKED' % unchecked)
        return 1
    if bad:
        print('data_offset_audit: %d module(s) with a layout disagreement' % bad)
        return 1
    print('data_offset_audit: %d data module(s) checked, offsets agree' % len(rows))
    return 0


if __name__ == '__main__':
    sys.exit(main())
