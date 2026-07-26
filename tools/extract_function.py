#!/usr/bin/env python3
"""Split one function out of a multi-function assembly module.

    python3 tools/extract_function.py <FunctionLabel>

C replacement is per-module, so a function living inside a larger `.s` must get
its own module first. This carves out the function together with its comment
header, writes it to `<module>_<slug>.s`, leaves the remainder in place (as one
or two files), and rewires `src/Prevue.asm` so the include order -- and
therefore the layout -- is unchanged.

The top-of-file XDEF block is redistributed so each part exports only what it
defines; an XDEF for a symbol that ended up in another file is an error.

Nothing here changes emitted bytes, so `./test-hash.sh` must still pass
afterwards. It is checked automatically unless --no-verify is given.
"""
import os, re, subprocess, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SEP  = lambda s: s.startswith(';---')


def find_module(label):
    for dirpath, _, files in os.walk(os.path.join(ROOT, 'src', 'modules')):
        for fn in files:
            if not fn.endswith('.s'):
                continue
            p = os.path.join(dirpath, fn)
            if any(re.match(rf'^{re.escape(label)}:', l) for l in open(p)):
                return p
    sys.exit(f'extract_function: no module defines {label}')


def carve(body, label):
    """Return (start, end) covering the function and its comment header."""
    li = next(i for i, l in enumerate(body) if l.startswith(label + ':'))
    start = li
    # walk back over the header block attached to this function
    j = li - 1
    while j >= 0 and (SEP(body[j]) or body[j].lstrip().startswith(';') or not body[j].strip()):
        if SEP(body[j]) and any(body[k].startswith('; FUNC:') for k in range(j + 1, min(j + 4, len(body)))):
            start = j
            break
        j -= 1
    end = len(body)
    for i in range(li + 1, len(body)):
        if re.match(r'^[A-Za-z_][A-Za-z0-9_]*:', body[i]):
            end = i
            for k in range(i - 1, li, -1):
                if SEP(body[k]):
                    end = k
                elif body[k].strip() and not body[k].lstrip().startswith(';'):
                    break
            break
    return start, end


def main():
    args = [a for a in sys.argv[1:] if not a.startswith('--')]
    if len(args) != 1:
        sys.exit(__doc__)
    label = args[0]
    src = find_module(label)
    rel = os.path.relpath(src, os.path.join(ROOT, 'src'))

    lines = open(src).read().split('\n')
    xdefs = [l for l in lines if l.startswith('    XDEF')]
    body  = [l for l in lines if not l.startswith('    XDEF')]
    start, end = carve(body, label)
    parts = [('a', body[:start]), ('m', body[start:end]), ('b', body[end:])]

    def defined(chunk):
        return {m.group(1) for m in (re.match(r'^([A-Za-z_][A-Za-z0-9_]*):', l) for l in chunk) if m}
    dmap = {tag: defined(chunk) for tag, chunk in parts}
    allsyms = set().union(*dmap.values())
    orphan = [x for x in xdefs if x.split()[1] not in allsyms]
    if orphan:
        sys.exit(f'extract_function: XDEF with no definition in any part: {orphan}')

    slug = re.sub(r'[^a-z0-9]+', '', label.lower().lstrip('_'))
    base = rel[:-2]
    # The remainder file must not collide with one produced by an earlier split
    # of the same module: overwriting it silently loses that module's tail and
    # leaves Prevue.asm including the same path twice.
    tail = f'{base}b.s'
    n = 2
    while os.path.exists(os.path.join(ROOT, 'src', tail)) and tail != rel:
        tail = f'{base}b{n}.s'
        n += 1
    names = {'a': rel, 'm': f'{base}_{slug}.s', 'b': tail}

    written = []
    for tag, chunk in parts:
        while chunk and not chunk[-1].strip():
            chunk.pop()
        path = os.path.join(ROOT, 'src', names[tag])
        if not chunk and tag != 'm':
            # An empty part contributes nothing. Delete any file sitting at that
            # path instead of leaving it: a stale orphan is still on disk, still
            # defines the labels it used to, and the next extraction's
            # find_module() will happily pick it over the live module.
            if tag == 'a' and os.path.exists(path):
                os.remove(path)
            continue
        xd = [x for x in xdefs if x.split()[1] in dmap[tag]]
        open(path, 'w').write('\n'.join(xd + [''] + chunk) + '\n')
        written.append((names[tag], len(xd), len(chunk)))

    order = [names[t] for t, c in parts if c or t == 'm']
    p = os.path.join(ROOT, 'src', 'Prevue.asm')
    s = open(p).read()
    old = f'    include "{rel}"\n'
    if s.count(old) != 1:
        sys.exit(f'extract_function: expected exactly one include of {rel}')
    open(p, 'w').write(s.replace(old, ''.join(f'    include "{n}"\n' for n in order)))

    for n, nx, nl in written:
        print(f'  {n:58s} {nx:3d} XDEF, {nl:5d} lines')
    print(f'  extracted {label} -> src/{names["m"]}')

    # orphan guard: a module file that Prevue.asm does not include is invisible
    # to the build but still visible to find_module(), which is exactly how a
    # partially-applied extraction corrupts the next one.
    root_txt = open(p).read()
    orphans = []
    for dirpath, _, fs in os.walk(os.path.join(ROOT, 'src', 'modules')):
        for fn in fs:
            if not fn.endswith('.s'):
                continue
            rp = os.path.relpath(os.path.join(dirpath, fn), os.path.join(ROOT, 'src'))
            if f'include "{rp}"' not in root_txt:
                orphans.append(rp)
    if orphans:
        print('  *** ORPHANED MODULE FILES (not included by Prevue.asm) ***')
        for o in orphans:
            print(f'      {o}')
        sys.exit(1)

    if '--no-verify' not in sys.argv:
        r = subprocess.run([os.path.join(ROOT, 'test-hash.sh')],
                           capture_output=True, text=True, cwd=ROOT)
        if r.returncode == 0:
            print('  hash unchanged')
        else:
            print('  *** BUILD BROKEN OR HASH CHANGED ***')
            print(r.stdout[-600:]); sys.exit(1)


if __name__ == '__main__':
    main()
