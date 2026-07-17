#!/usr/bin/env python3
"""
gen_leaf_diff.py -- generate differential-harness sources for the leaf-scalar
audit batch (from classify_functions.py --list).

For each function it writes into src/decomp/sas_c/_audit/<entry>/ :
  slice.s    original ASM slice, wrapped: XDEF _ENTRY, dot-locals renamed
  driver.c   extern __stdargs decl + baked-in fuzz-input table, prints hex
  impl.c     canonical restored .c with __stdargs injected on the entry def
and appends the entry to _audit/manifest.tsv for run_leaf_audit.sh.

Generation only (no vamos). See run_leaf_audit.sh for build+run+diff.
"""
import os
import re
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
SASC = os.path.join(ROOT, "src", "decomp", "sas_c")
AUDIT = os.path.join(SASC, "_audit")

# deterministic edge-case value pool (32-bit); harness feeds identical values
# to both sides so any output diff is a genuine behavioral divergence.
POOL = [
    0x00000000, 0x00000001, 0x00000002, 0x0000000a, 0x0000001f, 0x00000020,
    0x0000002f, 0x00000039, 0x00000041, 0x00000060, 0x00000061, 0x0000007a,
    0x0000007f, 0x00000080, 0x000000ff, 0x00000100, 0x00007fff, 0x00008000,
    0x0000ffff, 0x11223344, 0x7fffffff, 0x80000000, 0xdeadbeef, 0xffffffff,
]


def slice_original(orig_path, entry):
    with open(orig_path, encoding="utf-8", errors="replace") as fh:
        lines = fh.read().splitlines()
    out, started = [], False
    entry_rx = re.compile(r'^_?' + re.escape(entry) + r':?$')
    for s in lines:
        if not started:
            if entry_rx.match(s.strip()):
                started = True
                continue
        else:
            if re.match(r'^;!=+', s):
                break
            out.append(s)
    return out


# Short alias used for the linked symbol on ALL sides. SAS/C truncates
# identifiers to ~31 significant chars, so long real names (e.g. the 36-char
# _ESQIFF2_ValidateFieldIndexAndLength) mis-resolve and the call jumps to
# garbage. Since the harness owns both sides, rename to a short unique symbol.
ALIAS = "TESTFN"


def wrap_slice(body, entry):
    """Rename dot-local labels to safe globals-of-file and wrap with XDEF,
    exporting the short ALIAS symbol instead of the (possibly too-long) name."""
    # collect dot-local label names defined in the body
    locals_ = set(re.findall(r'^\s*\.([A-Za-z_]\w*)\s*:', "\n".join(body),
                             re.MULTILINE))
    text = "\n".join(body)
    for name in sorted(locals_, key=len, reverse=True):
        text = re.sub(r'\.' + re.escape(name) + r'\b', 'L_' + name, text)
    out = []
    out.append("    SECTION text,CODE")
    out.append(f"    XDEF    _{ALIAS}")
    out.append(f"_{ALIAS}:")
    out.extend(text.splitlines())
    out.append("    END")
    out.append("")
    return "\n".join(out)


def inject_stdargs(csrc, entry):
    """Rename the entry to the short ALIAS and insert __stdargs before its
    definition so the C-side callee uses stack ABI + a short symbol."""
    csrc = re.sub(r'\b' + re.escape(entry) + r'\b', ALIAS, csrc)
    rx = re.compile(r'([A-Za-z_][\w ]*?\s+)(' + re.escape(ALIAS) + r'\s*\()')
    def repl(m):
        head = m.group(1)
        if "__stdargs" in head:
            return m.group(0)
        return head + "__stdargs " + m.group(2)
    new, n = rx.subn(repl, csrc, count=1)
    return new if n else csrc


# bounded scalar pool used when a pointer arg is present: keeps indices/lengths
# inside the 64-byte differential buffer so neither side reads out of bounds.
SAFE_POOL = [0, 1, 2, 3, 4, 7, 8, 15, 16, 17, 24, 31, 32, 33, 40, 47, 48, 63]


def split_param(p):
    """(cast_type, name, is_pointer) from a C parameter declaration."""
    p = p.strip()
    m = re.match(r'^(.*?)([A-Za-z_]\w*)\s*$', p)
    if not m:
        return p, None, ("*" in p)
    type_part = m.group(1).strip()
    is_ptr = "*" in type_part
    type_part = re.sub(r'\b(const|register)\b', "", type_part).strip()
    return type_part, m.group(2), is_ptr


def gen_driver(entry, ret, params):
    entry = ALIAS  # driver calls the short alias symbol
    parsed = [split_param(p) for p in params]
    ptypes = [t for (t, _n, _ip) in parsed]
    is_ptr = [ip for (_t, _n, ip) in parsed]
    k = len(parsed)
    has_ptr = any(is_ptr)

    # scalar fuzz pool: bounded when a buffer pointer is in play.
    pool = SAFE_POOL if has_ptr else POOL
    n = min(24, max(12, len(pool)))
    tuples = [[pool[(i * (a + 1)) % len(pool)] for a in range(k)] for i in range(n)]

    lines = []
    lines.append("#include <exec/types.h>")
    lines.append("#include <stdio.h>")
    decl_params = ", ".join(ptypes) if ptypes else "void"
    lines.append(f"extern {ret} __stdargs {entry}({decl_params});")
    lines.append("int main(void) {")
    # scalar arg tables (pointer slots reuse the same table as a per-iter seed)
    for a in range(k):
        vals = ", ".join(f"0x{t[a]:08x}UL" for t in tuples)
        lines.append(f"    static ULONG a{a}[] = {{ {vals} }};")
    for a in range(k):
        if is_ptr[a]:
            lines.append(f"    static UBYTE buf{a}[64];")
    lines.append(f"    int i, j, n = {len(tuples)};")
    lines.append("    for (i = 0; i < n; i++) {")
    # C89 (SAS/C): ALL declarations at the top of the block, before statements.
    lines.append(f"        {ret if ret.lower()!='void' else 'ULONG'} r;")
    for a in range(k):
        if is_ptr[a]:
            lines.append(f"        ULONG d{a} = 0;")
    # seed each pointer buffer deterministically: nonzero bytes 0..38, NUL at 39,
    # zero padding after -> string scanners stop in-bounds; content varies per i.
    for a in range(k):
        if is_ptr[a]:
            lines.append(f"        for (j = 0; j < 64; j++) buf{a}[j] = 0;")
            lines.append(f"        for (j = 0; j < 39; j++) "
                         f"buf{a}[j] = (UBYTE)(a{a}[i] + j * 37 + 1);")
    callargs = []
    for a in range(k):
        if is_ptr[a]:
            callargs.append(f"({ptypes[a]})buf{a}")
        else:
            callargs.append(f"({ptypes[a]})a{a}[i]")
    lines.append(f"        r = {entry}({', '.join(callargs)});")
    # digest each buffer after the call to catch in-place writes
    for a in range(k):
        if is_ptr[a]:
            lines.append(f"        for (j = 0; j < 48; j++) "
                         f"d{a} = d{a} * 33 + buf{a}[j];")
    # print: each arg (scalar value or buffer digest), then return
    fmt_cols = []
    arg_exprs = []
    for a in range(k):
        fmt_cols.append("%08lx")
        if is_ptr[a]:
            arg_exprs.append(f"(ULONG)d{a}")
        else:
            arg_exprs.append(f"(ULONG)a{a}[i]")
    printf_fmt = " ".join(fmt_cols) + " -> %08lx\\n"
    printf_args = ", ".join(arg_exprs) + ", (ULONG)r"
    lines.append(f'        printf("{printf_fmt}", {printf_args});')
    lines.append("    }")
    lines.append("    return 0;")
    lines.append("}")
    lines.append("")
    return "\n".join(lines)


def main():
    listing = sys.stdin.read().strip().splitlines()
    os.makedirs(AUDIT, exist_ok=True)
    manifest = []
    for row in listing:
        parts = row.split("\t")
        if len(parts) < 5:
            continue
        entry, src, asm, ret, params_s = parts[:5]
        params = [p for p in params_s.split("|") if p]
        orig_path = os.path.join(ROOT, asm)
        csrc_path = os.path.join(SASC, src)
        if not (os.path.exists(orig_path) and os.path.exists(csrc_path)):
            continue
        body = slice_original(orig_path, entry)
        if not body:
            continue
        d = os.path.join(AUDIT, entry)
        os.makedirs(d, exist_ok=True)
        with open(os.path.join(d, "slice.s"), "w") as fh:
            fh.write(wrap_slice(body, entry))
        with open(csrc_path, encoding="utf-8", errors="replace") as fh:
            csrc = fh.read()
        with open(os.path.join(d, "impl.c"), "w") as fh:
            fh.write(inject_stdargs(csrc, entry))
        with open(os.path.join(d, "driver.c"), "w") as fh:
            fh.write(gen_driver(entry, ret, params))
        manifest.append(entry)
    with open(os.path.join(AUDIT, "manifest.tsv"), "w") as fh:
        fh.write("\n".join(manifest) + "\n")
    print(f"generated harness sources for {len(manifest)} functions -> {AUDIT}")


if __name__ == "__main__":
    main()
