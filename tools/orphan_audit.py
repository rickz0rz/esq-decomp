#!/usr/bin/env python3
"""Find files in src/c that NO manifest reaches.

    python3 tools/orphan_audit.py           # report
    python3 tools/orphan_audit.py --quiet   # exit code only

A file is REACHED if any `replacements*.txt` names it, or a reached file
`#include`s it. The include step matters: merge_module_c.py writes units that
`#include` the per-function restorations, so a file can be linked without ever
appearing in a manifest.

WHY THIS EXISTS

A stale file in src/c is not inert. `mismatches.py` reads every header, so a
restoration nothing links still reports a status and still claims a label.
Three merged units were orphaned the moment a module stopped needing a merge --
`gen_all_manifest.py` simply stopped emitting the row, with no error -- and
`esqiff_run_copper_open_transition.c` restored a symbol that does not exist
anywhere in the program.

NOT EVERY ORPHAN IS DEAD. Some are deliberate records and the tool lists them
separately rather than reporting them:

  DO-NOT-LINK:   a restoration proven to break the build, kept for its analysis
  referenced:    prose in another file points at it for the reasoning

Judge the rest. A merged unit with no row is almost always stale; a restoration
whose symbol is absent from build/ESQ.map is dead.
"""
import os, re, sys, glob

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CDIR = os.path.join(ROOT, 'src', 'c')


def manifest_files():
    out = set()
    for p in glob.glob(os.path.join(CDIR, 'replacements*.txt')):
        for line in open(p, errors='replace'):
            parts = line.split('#')[0].split()
            if len(parts) >= 2 and parts[1] != '-':
                out.add(os.path.basename(parts[1]))
    return out


def includes(fn):
    try:
        t = open(os.path.join(CDIR, fn), errors='replace').read()
    except OSError:
        return set()
    return set(re.findall(r'#include\s+"([^"/]+)"', t))


def main():
    quiet = '--quiet' in sys.argv
    on_disk = {os.path.basename(p) for p in glob.glob(os.path.join(CDIR, '*.c'))}
    on_disk |= {os.path.basename(p) for p in glob.glob(os.path.join(CDIR, '*.h'))}

    reached, frontier = set(), manifest_files()
    while frontier:
        f = frontier.pop()
        if f in reached:
            continue
        reached.add(f)
        frontier |= includes(f) - reached

    orphans = sorted(on_disk - reached)

    # Prose in any tracked file that names an orphan keeps it: 13 pad_*.c files
    # point at padding_removed.c for the shared reasoning.
    prose = ''
    for p in glob.glob(os.path.join(CDIR, '*.c')) + glob.glob(os.path.join(CDIR, '*.txt')):
        if os.path.basename(p) in orphans:
            continue
        prose += open(p, errors='replace').read()

    kept, review = [], []
    for f in orphans:
        txt = open(os.path.join(CDIR, f), errors='replace').read()
        if re.search(r'^\s*\*?\s*DO-NOT-LINK:', txt, re.M):
            kept.append((f, 'DO-NOT-LINK'))
        elif f in prose:
            kept.append((f, 'referenced by other files'))
        else:
            review.append(f)

    if not quiet:
        print('src/c files:        %d' % len(on_disk))
        print('reached by a manifest: %d' % len(reached & on_disk))
        print('\ndeliberate orphans (%d):' % len(kept))
        for f, why in kept:
            print('   %-44s %s' % (f, why))
        print('\nORPHANS TO REVIEW (%d):' % len(review))
        for f in review:
            print('   %s' % f)
        if not review:
            print('   none')
    return 1 if review else 0


if __name__ == '__main__':
    sys.exit(main())
