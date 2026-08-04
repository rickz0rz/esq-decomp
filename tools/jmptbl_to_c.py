#!/usr/bin/env python3
"""Translate a jump-table module into C forwarding functions.

    python3 tools/jmptbl_to_c.py modules/groups/a/l/xjump.s
    python3 tools/jmptbl_to_c.py modules/groups/a/l/xjump.s --write

A jump table is a run of two-instruction thunks:

    _GROUP_AZ_JMPTBL_ESQ_ColdReboot:
        JMP     _ESQ_ColdReboot

They exist because the original's translation units could not reach each other
directly. In C each becomes a function that calls the target and returns its
result.

**THE SIGNATURE MUST BE FORWARDED, NOT DROPPED.** Writing the thunk `void f(void)`
compiles, links, and silently passes NO ARGUMENTS to a callee that expects them.
That is a whole bug class in this project's history. So the generator reads the
target's RESTORED C DEFINITION and copies its parameter list verbatim; a target
with no C restoration, or a variadic one, is refused rather than guessed at.

SASC-MISMATCH: tail-jump. The original is `JMP target`, four or six bytes, which
leaves the caller's return address for the target to return through. SAS/C emits
a call and a return. Same arguments, same result, two extra bytes and one extra
frame for the duration of the call.
"""
import glob
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def c_definitions():
    """name -> (return type, parameter list) from every restoration."""
    out = {}
    for c in sorted(glob.glob(os.path.join(ROOT, 'src', 'c', '*.c'))):
        if c.endswith('_merged.c'):
            continue
        for m in re.finditer(
                r'^([A-Za-z_][\w \t\*]*?)\b([A-Za-z_]\w*)\s*\(([^;{]*?)\)\s*\{',
                open(c).read(), re.M):
            name = m.group(2)
            if name in ('if', 'for', 'while', 'switch', 'return'):
                continue
            out.setdefault(name, (m.group(1).strip(), m.group(3).strip()))
    return out


def thunks(path):
    t = open(os.path.join(ROOT, 'src', path)).read()
    # A thunk is a label whose first INSTRUCTION transfers control and does not
    # return. Two spellings occur and they are the same shape: `JMP target` and
    # `BRA.W target`. Comment and blank lines may sit between the two, so they
    # are skipped rather than treated as a body.
    pairs = re.findall(
        r'^([A-Za-z_][\w]*):[ \t]*\n(?:[ \t]*(?:;.*)?\n)*'
        r'[ \t]*(?:JMP|BRA(?:\.W)?)\s+([A-Za-z_][\w]*)', t, re.M)
    labs = re.findall(r'^([A-Za-z_][\w]*):', t, re.M)
    if not pairs:
        sys.exit('jmptbl_to_c: %s holds no JMP thunks' % path)
    if len(pairs) != len(labs):
        sys.exit('jmptbl_to_c: %s holds %d labels but only %d are thunks -- it is '
                 'not a pure jump table' % (path, len(labs), len(pairs)))
    return pairs


def vform_name(name):
    """WDISP_SPrintf -> WDISP_VSPrintf: insert a V after the module prefix."""
    if '_' in name:
        head, rest = name.split('_', 1)
        return '%s_V%s' % (head, rest)
    return 'V' + name


def params_and_args(plist):
    """('long a, char *b', 'a, b') from a definition's parameter list."""
    plist = plist.strip()
    if plist in ('', 'void'):
        return 'void', ''
    if '...' in plist:
        raise ValueError('variadic')
    names = []
    for p in plist.split(','):
        p = p.strip()
        m = re.search(r'([A-Za-z_]\w*)\s*(\[\s*\])?$', p)
        if not m:
            raise ValueError('cannot name parameter %r' % p)
        names.append(m.group(1))
    return plist, ', '.join(names)


def main():
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    path = sys.argv[1]
    defs = c_definitions()
    pairs = thunks(path)

    body, protos, skipped = [], [], []
    variadic_used = {}
    for label, target in pairs:
        key = target.lstrip('_')
        if key not in defs:
            skipped.append((label, target, 'target has no C restoration'))
            continue
        ret, plist = defs[key]
        ret = ret.strip()

        if '...' in plist:
            # A VARIADIC TARGET NEEDS A V-FORM, and C gives no other way. There
            # is no syntax for "pass on the arguments I was given", so a thunk in
            # front of a variadic function can only be written if the work is
            # also reachable through an entry that takes an ARGUMENT POINTER.
            # By convention that sibling is the target with a V after the module
            # prefix: WDISP_SPrintf -> WDISP_VSPrintf.
            #
            # This is sound on this toolchain because SAS/C's va_list on the
            # 68000 IS that pointer -- `va_start(ap, fmt)` compiles to
            # `LEA d16(A7),An`, which is what the original's `PEA 16(A5)`
            # computes. No argument is copied and the callee sees the same block.
            vname = vform_name(key)
            if vname not in defs:
                skipped.append((label, target,
                                'variadic, and no v-form %s() to forward through'
                                % vname))
                continue
            vret, vplist = defs[vname]
            named = plist.split('...')[0].rstrip().rstrip(',')
            try:
                nnames = params_and_args(named)[1]
            except ValueError as e:
                skipped.append((label, target, str(e)))
                continue
            last = nnames.split(',')[-1].strip()
            decl = named + ', ...'
            protos.append('extern %s %s(%s);' % (vret.strip(), vname, vplist.strip()))
            call = '%s(%s, (void *)ap);' % (vname, nnames)
            inner = ('    va_list ap;\n'
                     '%s'
                     '\n'
                     '    va_start(ap, %s);\n'
                     '%s'
                     '    va_end(ap);\n'
                     % ('' if ret == 'void' else '    %s n;\n' % ret,
                        last,
                        ('    %s\n' % call) if ret == 'void'
                        else '    n = %s\n' % call))
            if ret != 'void':
                inner += '\n    return n;\n'
            body.append('%s %s(%s)\n{\n%s}\n' % (ret, label.lstrip('_'), decl, inner))
            variadic_used[True] = True
            continue

        try:
            decl, args = params_and_args(plist)
        except ValueError as e:
            skipped.append((label, target, str(e)))
            continue
        call = '%s(%s);' % (key, args)
        stmt = ('    %s\n' % call) if ret == 'void' else ('    return %s\n' % call)
        protos.append('extern %s %s(%s);' % (ret, key, decl))
        body.append('%s %s(%s)\n{\n%s}\n' % (ret, label.lstrip('_'), decl, stmt))

    if skipped:
        for l, t, why in skipped:
            sys.stderr.write('  SKIP %s -> %s: %s\n' % (l, t, why))
        sys.exit('jmptbl_to_c: %s: %d of %d thunks cannot be forwarded. A jump '
                 'table must be converted WHOLE -- a C file replaces the whole '
                 'module.' % (path, len(skipped), len(pairs)))

    # The basename alone is NOT unique: there are 25 modules called xjump.s, one
    # per group, and using it wrote all of them over the same file.
    name = re.sub(r'^modules/(groups/)?', '', path)[:-2].replace('/', '_')
    head = [
        '/* RESTORES: (jump table -- %d forwarding thunks)' % len(pairs),
        ' * MODULE:   %s' % path,
        ' * STATUS:   behavioural',
        ' *',
        ' * Generated by tools/jmptbl_to_c.py, then read.',
        ' *',
        ' * Each function here replaces a two-instruction `JMP` thunk. The parameter',
        ' * lists are copied from the targets\' own restorations, so the arguments are',
        ' * FORWARDED. A thunk written `void f(void)` would compile, link, and pass',
        ' * nothing to a callee that expects arguments.',
        ' *',
        ' * SASC-MISMATCH: tail-jump',
        ' *   ref:     JMP target          the caller\'s return address is reused',
        ' *   got:     BSR.W target / RTS  a call and a return',
        ' *   summary: SAS/C emits no tail jump for a call in return position, so each',
        ' *            thunk costs two bytes and one extra frame for the duration of',
        ' *            the call. Same arguments, same result.',
        ' *   scope:   every jump table in the program.',
        ' *   retest:  a compiler that turns a call in return position into a jump.',
        ' */',
        '',
    ]
    # A parameter list copied from a target's restoration can name an Amiga
    # typedef, and without the header SAS/C reports "comma expected" on the
    # parameter rather than an unknown type. BPTR and BSTR come from the DOS
    # headers; everything else comes from <exec/types.h>, which esq-dos.h also
    # includes. The thunks call no OS function, so the volatile base that
    # esq-dos.h declares emits nothing.
    sig = '\n'.join(protos + body)
    if re.search(r'\b(BPTR|BSTR)\b', sig):
        head += ['#include "esq-dos.h"', '']
    elif re.search(r'\b(APTR|BOOL|ULONG|UWORD|UBYTE|LONG|WORD|BYTE|STRPTR)\b', sig):
        head += ['#include <exec/types.h>', '']
    # A variadic forwarder needs va_list, va_start and va_end.
    if variadic_used:
        head += ['#include <stdarg.h>', '']
    text = '\n'.join(head + protos + [''] + body)
    if '--write' in sys.argv:
        dst = os.path.join(ROOT, 'src', 'c', 'jmptbl_%s.c' % name)
        open(dst, 'w').write(text)
        sys.stderr.write('wrote %s (%d thunks)\n' % (dst, len(pairs)))
    else:
        print(text)


if __name__ == '__main__':
    main()
