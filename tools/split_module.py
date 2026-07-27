#!/usr/bin/env python3
"""Extract one or more functions from a shared .s module into their own modules.

    python3 tools/split_module.py <module-rel-path> <Label> [<Label> ...]
    python3 tools/split_module.py --check           # report what is splittable

`src/c/replacements.txt` substitutes a C object for a whole MODULE, so a function
that shares a .s file with others cannot be swapped in until it has a file of its
own. That is the only thing standing between the 297 written-but-unlinked
restorations and a binary. Doing it by hand is four fiddly steps and it was going
to be done 297 times.

What it does, per AGENTS.md "Extracting one function into its own module":

  1. cuts the module at the `;!======` separators bounding each requested label
  2. writes <base>.s, <base>_<label>.s and <base>_pN.s for the pieces
  3. DISTRIBUTES the top-of-file XDEF block so each piece exports only what it
     defines -- the step that is easy to forget and that build-split.sh only
     catches once a C replacement actually pulls the middle piece out
  4. renames the label to its SAS/C name (`_Foo`) throughout src/, so assembly
     refers to the C function by the name `sc` will emit
  5. rewrites the include list in src/Prevue.asm, preserving order

Splitting is byte-neutral: content and order are unchanged, so BOTH GATES MUST
STAY GREEN across it. That is the whole safety argument for doing this in bulk --
run ./test-hash.sh and ./build-split.sh after every batch. A split that changes
the hash is a bug in this tool, not an acceptable cost.
"""
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SEP = ';!======'


def label_of(text):
    return set(re.findall(r'^([A-Za-z_][\w]*):', text, re.M))


def chunk(lines):
    """Split a module's lines on the ;!====== separators, keeping each separator
    with the chunk it terminates -- the shape the hand-made splits already use."""
    out, cur = [], []
    for ln in lines:
        cur.append(ln)
        if ln.strip() == SEP:
            out.append(cur)
            cur = []
    if cur:
        out.append(cur)
    return out


def split(module, labels):
    path = os.path.join(ROOT, 'src', module)
    src = open(path).read()
    lines = src.split('\n')

    # the XDEF block is the run of XDEF lines at the top
    head_end = 0
    for i, ln in enumerate(lines):
        if ln.strip().startswith('XDEF'):
            head_end = i + 1
        elif ln.strip():
            break
    xdefs = [l for l in lines[:head_end] if l.strip().startswith('XDEF')]
    body = lines[head_end:]

    chunks = chunk(body)
    want = {l: None for l in labels}
    for ci, c in enumerate(chunks):
        for l in labels:
            if any(re.match(r'^' + re.escape(l) + r':', x) for x in c):
                if want[l] is not None:
                    sys.exit(f'{module}: {l} appears in more than one chunk')
                want[l] = ci
    missing = [l for l, v in want.items() if v is None]
    if missing:
        sys.exit(f'{module}: label(s) not found as a chunk start: {missing}')

    base = module[:-2]                       # strip .s
    pieces = []                              # (relpath, lines)
    cut = sorted(want.values())
    prev, part = 0, 0
    for ci in cut:
        if ci > prev:
            name = f'{base}.s' if prev == 0 else f'{base}_p{part}.s'
            part += 1
            pieces.append((name, [x for c in chunks[prev:ci] for x in c]))
        lbl = next(l for l, v in want.items() if v == ci)
        pieces.append((f'{base}_{lbl.lstrip("_").lower()}.s', chunks[ci]))
        prev = ci + 1
    if prev < len(chunks):
        name = f'{base}.s' if prev == 0 else f'{base}_p{part}.s'
        pieces.append((name, [x for c in chunks[prev:] for x in c]))
    if not any(p[0] == f'{base}.s' for p in pieces):
        pieces.insert(0, (f'{base}.s', []))   # module began with a target label

    # distribute the exports: each piece keeps only the XDEFs it defines, and the
    # extracted functions gain an XDEF under their new SAS/C name
    assigned = set()
    out = []
    for name, plines in pieces:
        defined = label_of('\n'.join(plines))
        mine = [x for x in xdefs if x.split()[1] in defined]
        assigned.update(x.split()[1] for x in mine)
        is_fn = any(name.endswith(f'_{l.lstrip("_").lower()}.s') for l in labels)
        if is_fn:
            lbl = next(l for l in labels
                       if name.endswith(f'_{l.lstrip("_").lower()}.s'))
            mine = [f'    XDEF    _{lbl.lstrip("_")}']
        out.append((name, mine, plines))
    orphan = [x.split()[1] for x in xdefs if x.split()[1] not in assigned]
    if orphan:
        # an XDEF whose definition we could not locate: keep it on the first piece
        # rather than dropping it, and say so.
        print(f'  note: {module}: XDEF with no visible definition kept on head: {orphan}')
        out[0] = (out[0][0], out[0][1] + [x for x in xdefs if x.split()[1] in orphan],
                  out[0][2])

    for name, mine, plines in out:
        text = ('\n'.join(mine) + '\n\n' if mine else '') + '\n'.join(plines)
        open(os.path.join(ROOT, 'src', name), 'w').write(text)

    # rewrite Prevue.asm: one include per piece, in order, replacing the original
    pv = os.path.join(ROOT, 'src', 'Prevue.asm')
    text = open(pv).read()
    old = f'    include "{module}"\n'
    if old not in text:
        sys.exit(f'{module}: not included by Prevue.asm')
    new = ''.join(f'    include "{n}"\n' for n, _, _ in out)
    open(pv, 'w').write(text.replace(old, new))

    # rename each extracted label to the name SAS/C will emit
    for l in labels:
        if l.startswith('_'):
            continue
        for dirpath, _, files in os.walk(os.path.join(ROOT, 'src')):
            for f in files:
                if not f.endswith(('.s', '.asm')):
                    continue
                p = os.path.join(dirpath, f)
                t = open(p).read()
                n = re.sub(r'(?<![\w])' + re.escape(l) + r'(?![\w])', '_' + l, t)
                if n != t:
                    open(p, 'w').write(n)

    return [n for n, _, _ in out]


def main():
    if len(sys.argv) < 3:
        sys.exit(__doc__)
    module, labels = sys.argv[1], sys.argv[2:]
    made = split(module, labels)
    print(f'{module} -> {len(made)} piece(s)')
    for m in made:
        print(f'    {m}')


if __name__ == '__main__':
    main()
