#!/usr/bin/env python3
"""Delete every jump-table thunk from src/c and call the real targets directly.

    python3 tools/remove_jmptbl.py              # report
    python3 tools/remove_jmptbl.py --write      # apply

WHY THIS IS SAFE NOW AND WAS NOT BEFORE

A jump table entry is one `JMP target`. The tables exist because the ORIGINAL's
translation units could not reach each other with a 16-bit PC-relative call.
Compiled C has no such limit, so a thunk is a slower, uglier way to write the
call. `tools/detunk_c.py` already redirected 2,882 call sites for that reason.

What it could NOT do is delete the thunks, because assembly modules still
called them. NO ASSEMBLY IS LEFT in the maximum-C build, so nothing outside
src/c can name one. This tool finishes the job.

THE THUNK NAME IS NOT THE TARGET. Twenty-two disagree, because the target was
renamed and the thunk kept the old name -- ED1_JMPTBL_LADFUNC_MergeHighLowNibbles
calls LADFUNC_SetPackedPenLowNibble, and PARSEINI_JMPTBL_..._FromTagTableFromTagTable
calls ..._FromTagTable. So the map comes from the ASSEMBLY's own `JMP target`,
the same source detunk_c.py uses, and never from the name.

The six variadic thunks are handled by that too: the assembly jumps to the
variadic function, while the C body calls its v-form sibling. Reading the body
would rewrite a caller to WDISP_VSPrintf, which takes an argument POINTER and
would receive an argument LIST.

WHAT IT REFUSES TO DO

- A thunk whose address is taken anywhere. A pointer table holding a thunk
  needs a real symbol, exactly like the requester strings in
  data_debug_abort_strings.c. There are none today; the check stays because a
  future table would be silent otherwise.
- A thunk with no target in the assembly and none derivable from its body.

Both abort the run rather than skipping the entry, because a partial rewrite
leaves a call to a function that is about to be deleted.
"""
import os, re, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CDIR = os.path.join(ROOT, 'src', 'c')
sys.path.insert(0, os.path.join(ROOT, 'tools'))
from detunk_c import forwarders, norm, sub_code_only, code_mask

THUNK = re.compile(r'\b([A-Za-z_][\w]*_JMPTBL_[\w]+)\b')


def is_thunk(name):
    """Global_JMPTBL_* IS NOT A THUNK. AGENTS.md says so and the address-of
    guard proved why it matters: Global_JMPTBL_DAYS_OF_WEEK and its five
    siblings are DATA TABLES OF POINTERS, so their address is taken by every
    reader, and every one of those reads looked like a table holding a thunk."""
    return not norm(name).startswith('Global_JMPTBL_')

# Definition of a thunk: a return type, the name, a parameter list, a body.
DEFN = re.compile(
    r'\n(?:[A-Za-z_][\w]*[\s\*]+)+?([A-Za-z_][\w]*_JMPTBL_[\w]+)\s*'
    r'\(([^;{]*?)\)\s*\{', re.S)


def call_return_forwarders():
    """{thunk: target} for the BSR/JSR + RTS spelling of a forwarder.

    detunk_c.py's forwarders() matches a TAIL JUMP -- `JMP target` or
    `BRA.W target`. One thunk in the program is spelled as a CALL AND RETURN
    instead:

        PARALLEL_JMPTBL_RawDoFmt:
            BSR.S   PARALLEL_RawDoFmt
            RTS

    That forwards exactly the same way and costs one extra frame, which is what
    a C thunk compiles to anyway. Reading only the tail-jump form left this one
    with no target and aborted the run.
    """
    out = {}
    for root, _, files in os.walk(os.path.join(ROOT, 'src', 'modules')):
        for f in files:
            if not f.endswith('.s'):
                continue
            lines = open(os.path.join(root, f), errors='replace').read().split('\n')
            for i, ln in enumerate(lines):
                m = re.match(r'^([A-Za-z_][\w]*):\s*$', ln)
                if not m or 'JMPTBL' not in m.group(1):
                    continue
                if norm(m.group(1)).startswith('Global_JMPTBL_'):
                    continue
                rest = [x.strip() for x in lines[i + 1:i + 6]
                        if x.strip() and not x.strip().startswith(';')]
                if len(rest) < 2:
                    continue
                c = re.match(r'(?:BSR|JSR)(?:\.[SWL])?\s+([A-Za-z_][\w]*)\s*$',
                             rest[0], re.I)
                if c and re.match(r'^RTS\b', rest[1], re.I):
                    out[norm(m.group(1))] = c.group(1)
    return out


def strip_comments(src):
    """Comments blanked to spaces. OFFSETS ARE PRESERVED, which matters because
    find_defs() returns slice indices used to delete from the real source."""
    mask = code_mask(src)
    return ''.join(c if mask[i] else ' ' for i, c in enumerate(src))


def find_defs(src):
    """[(name, start, end)] for each thunk definition, brace-matched."""
    out = []
    masked = strip_comments(src)
    for m in DEFN.finditer(masked):
        i = masked.index('{', m.end() - 1)
        depth = 0
        for j in range(i, len(masked)):
            if masked[j] == '{':
                depth += 1
            elif masked[j] == '}':
                depth -= 1
                if depth == 0:
                    out.append((m.group(1), m.start() + 1, j + 1))
                    break
    return out


def main():
    write = '--write' in sys.argv
    fwd = forwarders()
    fwd.update(call_return_forwarders())

    # --- inventory -----------------------------------------------------
    defs = {}                       # thunk -> (file, start, end)
    for fn in sorted(os.listdir(CDIR)):
        if not fn.endswith('.c'):
            continue
        src = open(os.path.join(CDIR, fn), errors='replace').read()
        for name, s, e in find_defs(src):
            if is_thunk(name):
                defs[name] = (fn, s, e)

    missing = [n for n in defs if norm(n) not in fwd]
    if missing:
        print('NO ASSEMBLY TARGET for %d thunk(s):' % len(missing))
        for n in sorted(missing)[:20]:
            print('   %s' % n)
        print('\nRefusing. The map must come from the assembly, not the name.')
        return 1

    # --- the address-of guard ------------------------------------------
    taken = []
    for fn in sorted(os.listdir(CDIR)):
        if not (fn.endswith('.c') or fn.endswith('.h')):
            continue
        src = strip_comments(open(os.path.join(CDIR, fn), errors='replace').read())
        for m in THUNK.finditer(src):
            if not is_thunk(m.group(1)):
                continue
            if src[m.end():m.end() + 40].lstrip()[:1] != '(':
                taken.append((fn, m.group(1)))
    if taken:
        print('THUNK ADDRESS TAKEN in %d place(s) -- a table may hold it:' % len(taken))
        for f, n in taken[:20]:
            print('   %s: %s' % (f, n))
        print('\nRefusing. Deleting these would break the link.')
        return 1

    print('thunk definitions:  %d in %d file(s)'
          % (len(defs), len(set(v[0] for v in defs.values()))))
    print('assembly targets:   %d' % len(fwd))

    # --- rewrite call sites, then delete definitions --------------------
    changed = calls = deleted = emptied = 0
    for fn in sorted(os.listdir(CDIR)):
        if not fn.endswith('.c'):
            continue
        path = os.path.join(CDIR, fn)
        src = open(path, errors='replace').read()
        orig = src

        # Delete this file's own definitions FIRST, back to front, so the
        # rewrite below cannot turn a definition into a call to itself.
        mine = sorted([d for d in find_defs(src) if is_thunk(d[0])],
                      key=lambda t: t[1], reverse=True)
        for name, s, e in mine:
            src = src[:s] + src[e:]
            deleted += 1

        # Every surviving mention is a call or a declaration. Both become the
        # target, which is what detunk_c.py does for the files it accepts.
        for name in sorted(set(THUNK.findall(strip_comments(src))),
                           key=len, reverse=True):
            key = norm(name)
            if not is_thunk(name) or key not in fwd:
                continue
            src, hits = sub_code_only(src, name, norm(fwd[key]))
            calls += hits

        if src == orig:
            continue

        # de-duplicate externs the rewrite may have collided
        seen, out = set(), []
        for line in src.split('\n'):
            d = re.match(r'\s*extern\s+.*?\b(\w+)\s*\(', line)
            if d and line.rstrip().endswith(';'):
                if d.group(1) in seen:
                    continue
                seen.add(d.group(1))
            out.append(line)
        src = '\n'.join(out)

        # collapse runs of blank lines left by the deletions
        src = re.sub(r'\n{3,}', '\n\n', src)

        # A file that held NOTHING BUT THUNKS is now nothing but extern
        # declarations of their targets. Replace it with a deliberately empty
        # translation unit, the same treatment pad_*.c and
        # strings_now_local_*.c get.
        #
        # THE FILE MUST STAY AND SO MUST ITS MANIFEST ROW. gen_units.py links
        # the assembly module wherever a manifest row is absent, so deleting
        # either would put the jump table back and reintroduce assembly.
        body = strip_comments(src)
        body = re.sub(r'(?m)^\s*extern\b[^;]*;', '', body, flags=re.S)
        body = re.sub(r'(?m)^\s*#.*$', '', body)
        if not body.strip():
            mod = re.search(r'MODULE:\s*(\S+)', src)
            src = ('/* RESTORES: (nothing -- this module was a jump table)\n'
                   ' * MODULE:   %s\n'
                   ' * STATUS:   behavioural\n'
                   ' *\n'
                   ' * DELIBERATELY EMPTY. Every thunk this module held is gone.\n'
                   ' *\n'
                   ' * A jump table entry was one `JMP target`. The tables existed because\n'
                   ' * the ORIGINAL\'s translation units could not reach each other with a\n'
                   ' * 16-bit PC-relative call. Compiled C has no such limit, so every\n'
                   ' * caller now calls the target directly and the thunk is dead weight --\n'
                   ' * one extra call and one extra frame per invocation.\n'
                   ' *\n'
                   ' * THIS FILE AND ITS MANIFEST ROW MUST STAY. gen_units.py links the\n'
                   ' * assembly module wherever a row is absent, so deleting either would\n'
                   ' * put the jump table back and reintroduce assembly.\n'
                   ' *\n'
                   ' * Removed by tools/remove_jmptbl.py.\n'
                   ' */\n' % (mod.group(1) if mod else '(unknown)'))
            emptied += 1

        changed += 1
        if write:
            open(path, 'w').write(src)

    print('\nfiles changed:      %d' % changed)
    print('definitions removed:%d' % deleted)
    print('references rewritten:%d' % calls)
    print('files left with no code: %d' % emptied)
    print('\n(dry run -- pass --write to apply)' if not write else '\nwritten.')
    return 0


if __name__ == '__main__':
    sys.exit(main())
