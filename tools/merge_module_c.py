#!/usr/bin/env python3
"""Build one C file per assembly module out of the per-function C restorations.

    python3 tools/merge_module_c.py                 # report what can be merged
    python3 tools/merge_module_c.py --write         # write the merged files
    python3 tools/merge_module_c.py --verify        # compile each candidate too
    python3 tools/merge_module_c.py --write --verify --add

A C replacement substitutes for a WHOLE module, so a module holding several
functions cannot be replaced until every one of them is written. That rule is
why dozens of finished restorations never reached a manifest: the C existed, the
module simply had a neighbour.

Splitting the module is one answer and `tools/split_module.py` does it, but it
cannot cut a module whose label is not at a `;!======` separator, and about 66
are like that. Merging is the other answer and needs no assembly change at all.

The merged file INCLUDES each restoration rather than copying it, so the
per-function files stay the single source of truth. `cmatch.sh`,
`mismatches.py --recheck` and every header stay pointed at the real file.

Include order follows the ORDER OF THE LABELS IN THE MODULE, so the compiled
functions land in the same sequence as the assembly they replace. That keeps the
link layout close to the original, which matters because
tools/check_pcrel_range.py measures distances between callers and callees.

WHAT STOPS A MERGE. Two files that define the same `static` helper, or the same
macro with different bodies, collide when compiled as one unit. The report names
those and skips them rather than writing a file that will not build.
"""
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
C_DIR = os.path.join(ROOT, 'src/c')
MANIFEST = os.path.join(C_DIR, 'replacements-all.txt')

LABEL = re.compile(r'^(_?[A-Za-z][\w]*):', re.M)
STATIC = re.compile(r'^\s*static\s+[\w \t*]+?([A-Za-z_]\w*)\s*\(', re.M)
DEFINE = re.compile(r'^\s*#define\s+([A-Za-z_]\w*)\s+(.*)$', re.M)


def restores_map():
    """Map restored label -> the C file that restores it."""
    out = {}
    for fn in sorted(os.listdir(C_DIR)):
        if not fn.endswith('.c'):
            continue
        # A generated unit is not a source of truth, and reading it as one makes
        # the tool INCLUDE A FILE INTO ITSELF. Once a `_merged.c` exists on disk
        # its own RESTORES: line claims every label it covers, so the next run
        # resolves those labels to the merged unit and emits
        # `#include "newgrid_p4_merged.c"` inside newgrid_p4_merged.c. That
        # duplicates every declaration in it, and --verify reports the collision
        # as though the restorations clashed with each other.
        if fn.endswith('_merged.c'):
            continue
        head = open(os.path.join(C_DIR, fn), errors='replace').read(4000)
        # A RESTORES: list can run over several lines, and a continuation is a
        # comment line holding names and nothing else:
        #
        #   /* RESTORES: ESQPROTO_VerifyChecksumAndParseRecord,
        #    *           ESQPROTO_VerifyChecksumAndParseList,
        #
        # Reading only the first line saw one label of four. That was invisible
        # while `/submodules/` was skipped outright, because the two files with
        # long lists both live there. A continuation stops at the first line
        # that is not a bare comma-separated name list -- MODULE:, STATUS: and
        # ordinary prose all end it.
        m = re.search(r'RESTORES:\s*(.+)', head)
        if not m:
            continue
        names = m.group(1).strip()
        rest = head[m.end():].split('\n')
        for line in rest[1:] if names.endswith(',') else []:
            body = line.strip().lstrip('*').strip()
            if not re.match(r'^[A-Za-z_]\w*(\s*,\s*[A-Za-z_]\w*)*,?$', body):
                break
            names += ' ' + body
            if not body.endswith(','):
                break
        for name in re.split(r'[,\s]+', names):
            name = name.strip().lstrip('_')
            if name and re.match(r'^[A-Za-z_]\w*$', name):
                out.setdefault(name, fn)
    return out


def module_list():
    txt = open(os.path.join(ROOT, 'src/Prevue.asm')).read()
    return [i for i in re.findall(r'^\s*include\s+"([^"]+)"', txt, re.M)
            if i.startswith('modules/')]


def manifest_modules():
    """Modules already replaced, and which of those use a merged unit.

    A module whose manifest entry names a `_merged.c` must still be REGENERATED,
    or a stale manifest points at a file that is not there. That is not
    hypothetical: deleting the generated files to re-run the tool left eleven
    entries dangling, and the build stopped at the first of them.
    """
    done, merged = set(), set()
    for line in open(MANIFEST):
        parts = line.split('#')[0].split()
        if len(parts) >= 2:
            done.add(parts[0])
            if parts[1].endswith('_merged.c'):
                merged.add(parts[0])
    return done, merged


def labels_of(mod):
    body = open(os.path.join(ROOT, 'src', mod), errors='replace').read()
    return [l.lstrip('_') for l in LABEL.findall(body)
            if not l.endswith('_Return')]


TERMINAL = ('RTS', 'RTE', 'RTR', 'JMP', 'BRA')


def function_body(text, label):
    """The braced body of `label`'s definition in `text`, or None.

    Matched by brace counting from the definition's opening brace, so a nested
    block or a string holding a brace cannot end it early.
    """
    m = re.search(r'^[A-Za-z_].*\b' + re.escape(label) + r'\s*\([^;{]*\)\s*\{',
                  text, re.M | re.S)
    if not m:
        return None
    depth, i = 0, m.end() - 1
    while i < len(text):
        if text[i] == '{':
            depth += 1
        elif text[i] == '}':
            depth -= 1
            if depth == 0:
                return text[m.end():i]
        i += 1
    return None


def bridged(mod, prev_label, name, restores):
    """True when the C restoration of `prev_label` ENDS BY CALLING `name`.

    A fall-through blocks a merge because the earlier restoration stops where
    the assembly does not, so the later block's work would silently never run.
    Writing the call at the end of the earlier function restores exactly that
    ordering: the fall-through becomes a call, which costs the call itself and
    one stack frame for its duration, and nothing else changes.

    So the block is not "a fall-through cannot be merged" but "a fall-through
    must be BRIDGED before it is merged", and this is the machine check for it.
    Requiring the call to be the LAST statement is the part that matters -- a
    call anywhere in the body would satisfy a looser test while running the
    later block at the wrong point.

    _ED1_EnterEscMenu is the worked example, and the whole reason the check
    exists. It ends at the copper rise and the assembly runs straight into
    _ED1_EnterEscMenu_AfterVersionText, which resets the filter cursor.
    """
    # falls_through() reads labels straight out of the assembly, so they keep
    # the leading underscore that restores_map() strips.
    prev_label = prev_label.lstrip('_')
    name = name.lstrip('_')
    f = restores.get(prev_label)
    if not f:
        return False
    text = open(os.path.join(C_DIR, f), errors='replace').read()
    body = function_body(text, prev_label)
    if body is None:
        return False
    body = re.sub(r'/\*.*?\*/', '', body, flags=re.S)
    stmts = [s.strip() for s in body.split(';') if s.strip()]
    if not stmts:
        return False
    return re.match(r'^' + re.escape(name) + r'\s*\(', stmts[-1]) is not None


def falls_through(mod, restores=None):
    """Name the first label whose block runs into the next one.

    THIS IS THE CHECK THAT MAKES MERGING SAFE, and it is not optional. When one
    block falls into the next, the two labels are ONE routine with a second
    entry point, and the earlier restoration stops where the assembly does not.
    _ED1_EnterEscMenu is the worked example: it ends at the copper rise, and the
    assembly then runs straight into _ED1_EnterEscMenu_AfterVersionText, which
    resets the filter cursor. Merged as two independent C functions, that reset
    would simply never happen -- on the ESC-menu path, silently.

    A block that ends in RTS, RTE, RTR, JMP or BRA hands control on by itself
    and is safe.

    AN ALIAS IS NOT A FALL-THROUGH, and the difference is exact. Two labels with
    NO INSTRUCTION BETWEEN THEM name the same address:

        COI_SelectAnimFieldPointer:
        _COI_GetAnimFieldPointerByMode:
            LINK.W  A5,#-20

    Nothing runs between them, so nothing can be lost by restoring them as two C
    functions -- one forwards to the other and both names reach the same code.
    The test is `last_op is None`, which means no instruction was seen since the
    previous label. A genuine fall-through always has at least one.
    """
    body = open(os.path.join(ROOT, 'src', mod), errors='replace').read()
    lines = body.split('\n')
    last_op = None
    prev_label = None
    for line in lines:
        text = line.split(';')[0].rstrip()
        if not text.strip():
            continue
        m = LABEL.match(text)
        if m:
            name = m.group(1)
            if (prev_label is not None and not name.startswith('.')
                    and not name.endswith('_Return')
                    and last_op is not None
                    and last_op not in TERMINAL
                    and not bridged(mod, prev_label, name, restores or {})):
                return '%s falls through into %s' % (prev_label, name)
            if not name.startswith('.') and not name.endswith('_Return'):
                prev_label = name
                last_op = None
            continue
        if text.startswith(('\t', ' ')):
            op = text.strip().split(None, 1)[0].upper().split('.')[0]
            if op in ('XDEF', 'XREF', 'INCLUDE', 'IF', 'ENDIF', 'ALIGN_WORD'):
                continue
            # DATA IS NOT AN INSTRUCTION, and counting it as one manufactures a
            # fall-through that cannot happen. A CODE module may hold constants
            # after a function's RTS -- the original addresses them PC-relative,
            # which is how it keeps a string out of the DATA section -- and they
            # sit under local labels, so the scan walks straight past the labels
            # and lands on the DC or NStr.
            #
            # modules/submodules/unknown29.s is the case: SAS/C's _main ends in
            # RTS, then "con.10/10/320/80/" and "*" under .loc and .loc_1, then
            # the jump-table thunk. The scan saw NSTR as the last operation
            # before the thunk's label and reported a fall-through into it.
            # Control cannot reach the thunk that way; the RTS ended the block.
            #
            # Leaving `last_op` alone is what makes the directive transparent.
            # A block whose last INSTRUCTION is non-terminal is still flagged,
            # data or no data, which is the case the check is for.
            if op in ('DC', 'DS', 'DCB', 'NSTR', 'STR', 'CNOP', 'EVEN',
                      'EQU', 'SET', 'RS', 'ALIGN'):
                continue
            last_op = op
    return None


TAG = re.compile(r'^\s*(?:typedef\s+)?(struct|union|enum)\s+([A-Za-z_]\w*)\s*\{',
                 re.M)
EXTERN = re.compile(r'^\s*extern\s+(.+?)\b([A-Za-z_]\w*)\s*(\[[^\]]*\])?\s*[;(]',
                    re.M)


GUARD = re.compile(
    r'#ifndef\s+(\w+)\s*\n\s*#define\s+\1\s*\n(.*?)\n\s*#endif', re.S)


def strip_guards(body):
    """Drop `#ifndef X / #define X / ... / #endif` regions.

    A struct wrapped in its own include guard is safe to see twice -- the second
    copy compiles to nothing -- so it must not count as a clash. Without this the
    tool kept reporting the very duplicates that had just been fixed.
    """
    return GUARD.sub('', body)


def collides(files):
    """Name a clash that would stop the merged unit compiling.

    Four kinds, all seen for real when this tool was first run over the tree:
    a `static` helper with the same name in two files, a `#define` with two
    bodies, the same struct TAG defined twice (SAS/C says `item already
    declared`), and one symbol declared `extern` with two different types
    (`conflict with previous declaration`). The last two are the common ones,
    because two restorations that touch the same table each carry their own copy
    of its struct.
    """
    statics, defines, tags, externs = {}, {}, {}, {}
    for fn in files:
        body = open(os.path.join(C_DIR, fn), errors='replace').read()
        for name in STATIC.findall(body):
            if name in statics and statics[name] != fn:
                return 'static %s in %s and %s' % (name, statics[name], fn)
            statics[name] = fn
        for name, val in DEFINE.findall(body):
            val = val.strip()
            if name in defines and defines[name][1] != val:
                return ('#define %s differs between %s and %s'
                        % (name, defines[name][0], fn))
            defines[name] = (fn, val)
        for kind, name in TAG.findall(strip_guards(body)):
            if name in tags and tags[name] != fn:
                return ('%s %s defined in %s and %s'
                        % (kind, name, tags[name], fn))
            tags[name] = fn
        for typ, name, arr in EXTERN.findall(body):
            decl = ' '.join((typ + ' ' + (arr or '')).split())
            if name in externs and externs[name][1] != decl:
                return ('extern %s declared as "%s" in %s and "%s" in %s'
                        % (name, externs[name][1], externs[name][0], decl, fn))
            externs[name] = (fn, decl)
    return None


VAMOS = os.path.expanduser('~/Downloads/vamos/bin/activate')
SCOPTS = 'NOSTKCHK DATA=FAR CODENAME=S_0 DATANAME=S_1 IDLEN=128'


def compile_check(item):
    """Actually compile the merged unit and report the first error.

    The static checks below catch what can be found by reading, and they miss a
    real class: file A forward-declares a function that file B DEFINES, with a
    different parameter list. Separately compiled that is invisible, because the
    linker does not check types. Merged into one unit SAS/C says `conflict with
    previous declaration` and stops. Two of the first thirteen candidates failed
    that way, so the compiler is the only trustworthy gate.
    """
    import shutil
    import subprocess
    import tempfile
    mod, labels, files = item
    work = tempfile.mkdtemp(prefix='mergechk.')
    try:
        base = os.path.basename(mod)[:-2] + '_merged.c'
        text = ''.join('#include "%s"\n' % f for f in files)
        open(os.path.join(work, 'u.c'), 'w').write(text)
        for fn in os.listdir(C_DIR):
            if fn.endswith(('.c', '.h')):
                shutil.copy(os.path.join(C_DIR, fn), work)
        cmd = ('. %s 2>/dev/null; vamos --volume work:%s sc:c/sc %s '
               'OBJNAME=work:u.o work:u.c' % (VAMOS, work, SCOPTS))
        out = subprocess.run(['bash', '-c', cmd], capture_output=True,
                             text=True).stdout
        if os.path.exists(os.path.join(work, 'u.o')):
            return None
        for line in out.split('\n'):
            if 'Error' in line:
                return 'does not compile merged: ' + line.strip()
        return 'does not compile merged'
    finally:
        shutil.rmtree(work, ignore_errors=True)


def main():
    write = '--write' in sys.argv
    add = '--add' in sys.argv
    verify = '--verify' in sys.argv
    restores = restores_map()
    done, already_merged = manifest_modules()

    ready, blocked = [], []
    for mod in module_list():
        # `/submodules/` used to be skipped outright, on the assumption that
        # everything there is SAS/C runtime that must never be decompiled. That
        # is no longer true and the exclusion was doing no work anyway: the
        # `all(l in restores)` test below already refuses a module whose labels
        # are not every one restored, which is the real gate. Lifting it is what
        # let modules/submodules/unknown.s -- the RBF protocol, and the largest
        # single item of assembly left -- become one unit.
        if mod in done and mod not in already_merged:
            continue
        labels = labels_of(mod)
        if len(labels) < 2:
            continue
        if not all(l in restores for l in labels):
            continue
        files = []
        for l in labels:                    # module order, not alphabetical
            f = restores[l]
            if f not in files:
                files.append(f)
        why = falls_through(mod, restores) or collides(files)
        if why:
            blocked.append((mod, why))
            continue
        ready.append((mod, labels, files))

    if verify:
        kept = []
        for item in ready:
            why = compile_check(item)
            if why:
                blocked.append((item[0], why))
            else:
                kept.append(item)
        ready = kept

    new_lines = []
    for mod, labels, files in ready:
        base = os.path.basename(mod)[:-2] + '_merged.c'
        path = os.path.join(C_DIR, base)
        text = (
            '/* MERGED MODULE: %s\n'
            ' *\n'
            ' * A C replacement substitutes for a WHOLE module, so every label in this\n'
            ' * one has to be present before any of it can be linked. Each restoration\n'
            ' * below is finished and lives in its own file; this unit only puts them in\n'
            ' * the module\'s own order. Generated by tools/merge_module_c.py -- edit the\n'
            ' * included files, never this one.\n'
            ' *\n'
            ' * RESTORES: %s\n'
            ' */\n' % (mod, ', '.join(labels)))
        text += ''.join('#include "%s"\n' % f for f in files)
        if write:
            open(path, 'w').write(text)
        if mod not in already_merged:
            new_lines.append('%-70s c/%s' % (mod, base))
        print('%s  <- %s' % (base, ', '.join(files)))

    for mod, why in blocked:
        print('SKIP %s: %s' % (mod, why))

    print('\nmerge_module_c: %d module(s) ready, %d blocked (fall-through or '
          'a name clash)' % (len(ready), len(blocked)))
    if add and new_lines:
        with open(MANIFEST, 'a') as fh:
            fh.write('\n'.join(new_lines) + '\n')
        print('appended %d entries to %s' % (len(new_lines), MANIFEST))
    elif new_lines and not write:
        print('(dry run -- pass --write to create the files, --add to list them)')
    return 0


if __name__ == '__main__':
    sys.exit(main())
