#!/usr/bin/env python3
"""Replace jump-table thunk calls in src/c with direct calls to the real target.

    python3 tools/detunk_c.py            # report what would change
    python3 tools/detunk_c.py --write    # apply it

WHY THIS IS SAFE, AND WHY IT IS NOT A FIDELITY LOSS

A jump table entry is a single `JMP target`. The tables exist because the
ORIGINAL's translation units could not reach each other with a 16-bit
PC-relative call. A C restoration has no such constraint, and the emitted bytes
are IDENTICAL either way, because the call target is a RELOCATION -- `cmatch`
masks it and so does the linker's own comparison. Measured on
`brush_load_brush_asset.c`: 1336 bytes and the same divergence point whether it
calls `GROUP_AG_JMPTBL_MEMORY_AllocateMemory` or `MEMORY_AllocateMemory`, and
the two emitted byte strings compare equal.

So no restoration's STATUS changes, no byte gate moves, and the program loses
one `JMP` per call at run time.

TWO THINGS THIS MUST NOT TOUCH

  - `Global_JMPTBL_*` is NOT a thunk. `Global_JMPTBL_DAYS_OF_WEEK`,
    `..._MONTHS`, `..._HALF_HOURS_12_HR_FMT` and their siblings are DATA TABLES
    of pointers. Rewriting one would name a function that does not exist.
    They are excluded by name and by the requirement below.
  - A label is only rewritten when the assembly shows it is a ONE-INSTRUCTION
    forwarder. Anything else keeps its thunk.

RANGE. The maximum-C build compiles with `CODE=FAR`, so every call is
`JSR abs.L` and has unlimited range. The byte-exact manifest does NOT use
`CODE=FAR` and would emit a 16-bit `BSR.W` -- but no file in
`src/c/replacements.txt` calls a thunk at all, so that lane is unaffected.
`tools/check_pcrel_range.py` still guards it either way.
"""
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
# words that follow a thunk's JMP and are really alignment, not code
PAD = ('MOVEQ #97,D0', 'ORI.B #0,D0', 'RTS')


def norm(s):
    return s.lstrip('_')


def code_mask(src):
    """[bool] per character: True where the character is CODE.

    THE REWRITE MUST NOT TOUCH COMMENTS. A restoration header routinely names
    the thunk it replaces, and the assembly module it lives in, as DOCUMENTATION
    -- "`_GROUP_AC_JMPTBL_ESQDISP_DrawStatusBanner` in modules/groups/a/c/xjump.s
    jumps to it". Renaming that text makes the header describe a symbol the
    assembly does not have. A first version of this tool rewrote comments too and
    silently corrupted several headers.
    """
    mask = [True] * len(src)
    i, n = 0, len(src)
    while i < n:
        c = src[i]
        if c == '/' and i + 1 < n and src[i + 1] == '*':
            j = src.find('*/', i + 2)
            j = n if j < 0 else j + 2
            for k in range(i, j):
                mask[k] = False
            i = j
        elif c == '/' and i + 1 < n and src[i + 1] == '/':
            j = src.find('\n', i)
            j = n if j < 0 else j
            for k in range(i, j):
                mask[k] = False
            i = j
        elif c in '"\'':
            q, j = c, i + 1
            while j < n and src[j] != q:
                if src[j] == '\\':
                    j += 1
                j += 1
            j = min(j + 1, n)
            for k in range(i, j):
                mask[k] = False
            i = j
        else:
            i += 1
    return mask


def sub_code_only(src, name, newname):
    """Replace whole-word `name` with `newname`, but only outside comments."""
    mask = code_mask(src)
    out = []
    last = 0
    hits = 0
    for m in re.finditer(r'\b%s\b' % re.escape(name), src):
        if not mask[m.start()]:
            continue
        out.append(src[last:m.start()])
        out.append(newname)
        last = m.end()
        hits += 1
    out.append(src[last:])
    return ''.join(out), hits


def forwarders():
    """{normalised thunk name: real target} for one-instruction forwarders."""
    out = {}
    for root, _, files in os.walk(os.path.join(ROOT, 'src/modules')):
        for f in files:
            if not f.endswith('.s'):
                continue
            lines = open(os.path.join(root, f), errors='replace').read().split('\n')
            for i, ln in enumerate(lines):
                m = re.match(r'^([A-Za-z_][\w]*):\s*$', ln)
                if not m or 'JMPTBL' not in m.group(1):
                    continue
                lab = m.group(1)
                if norm(lab).startswith('Global_JMPTBL_'):
                    continue                    # a data table, not a thunk
                j = i + 1
                while j < len(lines) and (not lines[j].strip()
                                          or lines[j].strip().startswith(';')):
                    j += 1
                nxt = lines[j].strip() if j < len(lines) else ''
                t = re.match(r'(?:JMP|BRA(?:\.W)?)\s+([A-Za-z_][\w]*)', nxt, re.I)
                if not t:
                    continue
                k = j + 1
                while k < len(lines) and (not lines[k].strip()
                                          or lines[k].strip().startswith(';')):
                    k += 1
                tail = ' '.join((lines[k].strip() if k < len(lines) else '').split())
                ended = (not tail or re.match(r'^[A-Za-z_.][\w.]*:', tail)
                         or tail.startswith(('XDEF', 'XREF'))
                         or any(' '.join(p.split()) == tail for p in PAD))
                if ended:
                    out[norm(lab)] = t.group(1)
    return out


def main():
    write = '--write' in sys.argv
    fwd = forwarders()
    cdir = os.path.join(ROOT, 'src/c')
    total = files_hit = 0
    renamed_to = {}

    for fn in sorted(os.listdir(cdir)):
        if not fn.endswith('.c') or fn.startswith('jmptbl_'):
            continue
        path = os.path.join(cdir, fn)
        src = open(path, errors='replace').read()
        orig = src
        n = 0

        # A FILE THAT *DEFINES* A THUNK MUST KEEP ITS NAME. Some restorations
        # implement a jump-table entry as a C forwarding function -- the
        # `RESTORES:` line names it. Renaming the definition to its own target
        # produces a duplicate symbol and a function that calls itself.
        # `lib_handle_close_all_and_return_with_code.c` is the case that caught
        # this: it defines UNKNOWN32_JMPTBL_ESQ_ReturnWithStackCode, and the
        # rewrite turned it into a recursive ESQ_ReturnWithStackCode.
        defined = set()
        head = src.split('*/', 1)[0]
        m = re.search(r'RESTORES:\s*(.+)', head)
        if m:
            for tok in re.findall(r'[A-Za-z_][\w]*JMPTBL_[\w]+', m.group(1)):
                defined.add(norm(tok))
        # A DEFINITION, not a declaration. `extern` is the discriminator: a
        # multi-line extern prototype also has no semicolon on its first line,
        # and treating those as definitions suppressed 890 legitimate rewrites.
        for line in src.split('\n'):
            if re.match(r'\s*extern\b', line):
                continue
            m2 = re.match(r'\s*(?:[A-Za-z_][\w]*[\s\*]+)+'
                          r'([A-Za-z_][\w]*JMPTBL_[\w]+)\s*\(', line)
            if m2:
                defined.add(norm(m2.group(1)))
        for name in sorted(set(re.findall(r'\b[A-Za-z_][\w]*JMPTBL_[\w]+', src)),
                           key=len, reverse=True):
            key = norm(name)
            if key not in fwd or key in defined:
                continue
            target = fwd[key]
            # the C side never carries the SAS/C underscore in source text
            newname = norm(target)
            src, hits = sub_code_only(src, name, newname)
            if not hits:
                continue
            n += hits
            renamed_to[name] = newname

        if n:
            # a file may now declare the same extern twice
            seen = set()
            out = []
            for line in src.split('\n'):
                d = re.match(r'\s*extern\s+.*\b(\w+)\s*\(', line)
                key = (d.group(1), line.strip()) if d else None
                if key and key in seen:
                    continue
                if key:
                    seen.add(key)
                out.append(line)
            src = '\n'.join(out)

        if src != orig:
            total += n
            files_hit += 1
            if write:
                open(path, 'w').write(src)

    print(f'thunks with a known target: {len(fwd)}')
    print(f'files changed: {files_hit}   call sites rewritten: {total}   '
          f'({"WRITTEN" if write else "dry run"})')
    return 0


if __name__ == '__main__':
    sys.exit(main())
