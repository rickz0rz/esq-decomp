#!/usr/bin/env python3
"""Inventory and re-check the C restorations and their codegen divergences.

    python3 tools/mismatches.py             # list what is recorded
    python3 tools/mismatches.py --recheck   # recompile each and report the truth

The point of --recheck is the day you obtain a different SAS/C version: point
the toolchain at it and run this. Anything that flips from DIFFER to MATCH is a
divergence that version does not have, which both fixes the restoration and
pins the compiler.

    SCOPTS_BASE="NOSTKCHK DATA=FAR" python3 tools/mismatches.py --recheck

A full recheck of all 90 restorations takes about 16 seconds, so it is cheap to
run often. --only exact|behavioural|library restricts the run; `--only exact` is
the regression gate.

Recheck runs SERIALLY on purpose. Concurrent vamos instances fail immediately
(every worker reported a compile failure at --jobs 8 while the same files pass
one at a time), and the run is fast enough that there is nothing to gain. --jobs
exists only to make that explicit; leave it at 1.

Each file in src/c/ carries a header block:

    RESTORES: <asm label the C replaces>
    MODULE:   <module path it substitutes for, or a note>
    STATUS:   exact | behavioural | library
    OPTIONS:  extra sc options this file needs (optional, e.g. SHORTINT)

and zero or more:

    SASC-MISMATCH: <slug>
      ref/got/summary/tried/scope/retest ...

STATUS meanings:
  exact       - byte-identical to the original; safe for a faithful build
  behavioural - same semantics, different bytes; fine for canaries, not faithful
  library     - the original is SAS/C library code; link it from sc.lib instead
                of decompiling. Never expected to match.
"""
import os, re, subprocess, sys
from concurrent.futures import ThreadPoolExecutor

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CDIR = os.path.join(ROOT, 'src', 'c')


KEYS = ('ref', 'got', 'summary', 'tried', 'scope', 'retest')


def parse(path):
    txt = open(path).read()
    head = txt.split('*/')[0] if '*/' in txt else txt
    # strip the comment furniture so '/*', ' *' and bare indentation all parse
    lines = [re.sub(r'^\s*(?:/\*+|\*+/?)?\s?', '', l).rstrip() for l in head.split('\n')]

    def field(name):
        for l in lines:
            m = re.match(rf'{name}:\s*(.+)$', l)
            if m:
                return m.group(1).strip()
        return None

    mismatches = []
    for i, l in enumerate(lines):
        m = re.match(r'SASC-MISMATCH:\s*(\S+)', l)
        if not m:
            continue
        entry = {'slug': m.group(1), 'summary': ''}
        key = None
        for l2 in lines[i + 1:]:
            if re.match(r'SASC-MISMATCH:', l2):
                break
            km = re.match(rf'\s*({"|".join(KEYS)}):\s*(.*)$', l2)
            if km:
                key = km.group(1)
                if key == 'summary':
                    entry['summary'] = km.group(2).strip()
            elif key == 'summary' and l2.strip():
                entry['summary'] += ' ' + l2.strip()   # continuation line
            elif not l2.strip():
                key = None
        mismatches.append(entry)

    return {'file': os.path.relpath(path, ROOT),
            'restores': field('RESTORES'), 'module': field('MODULE'),
            'status': (field('STATUS') or 'unknown').lower(),
            'options': field('OPTIONS') or '',
            'mismatches': mismatches}


def recheck(e):
    if not e['restores']:
        return 'NO-LABEL'
    cmd = [os.path.join(ROOT, 'tools', 'cmatch.sh'),
           os.path.join(ROOT, e['file']), e['restores']]
    cmd += e['options'].split()          # per-file sc options, e.g. SHORTINT
    r = subprocess.run(cmd, capture_output=True, text=True, cwd=ROOT)
    first = (r.stdout or r.stderr).strip().split('\n')[0]
    return 'MATCH' if r.returncode == 0 else ('FAIL' if r.returncode == 2 else 'DIFFER') , first


def prewarm():
    """Build the listing once, single-threaded.

    refbytes.py regenerates build/Prevue.lst when sources are newer. Letting
    parallel workers discover that simultaneously would have them all shell out
    to vasm at once and race on the same output file.
    """
    subprocess.run(['python3', os.path.join(ROOT, 'tools', 'refbytes.py'), '__prewarm__'],
                   capture_output=True, text=True, cwd=ROOT)


def main():
    do = '--recheck' in sys.argv
    jobs = int(sys.argv[sys.argv.index('--jobs') + 1]) if '--jobs' in sys.argv else 1
    only = sys.argv[sys.argv.index('--only') + 1] if '--only' in sys.argv else None
    files = sorted(f for f in os.listdir(CDIR) if f.endswith('.c')) if os.path.isdir(CDIR) else []
    if not files:
        sys.exit('no C restorations in src/c/')
    entries = [parse(os.path.join(CDIR, f)) for f in files]
    if only:
        entries = [e for e in entries if e['status'] == only]

    print(f'{len(entries)} C restoration(s)' + (f' with status {only}' if only else ' in src/c/') + '\n')
    exit_bad = 0
    results = {}
    if do:
        prewarm()
        with ThreadPoolExecutor(max_workers=jobs) as pool:
            for e, r in zip(entries, pool.map(recheck, entries)):
                results[e['file']] = r
    flips = []
    for e in entries:
        line = f"  {e['file']:44s} {e['status']:12s} restores {e['restores']}"
        if do:
            verdict, detail = results[e['file']]
            flip = ''
            if verdict == 'MATCH' and e['status'] != 'exact':
                flip = '   <-- NOW MATCHES: update STATUS to `exact`'
                flips.append(e)
            if verdict == 'DIFFER' and e['status'] == 'exact':
                flip = '   <-- REGRESSED: was recorded as exact'
                exit_bad = 1
            line += f'\n      recheck: {verdict}{flip}'
        print(line)
        for mm in e['mismatches']:
            print(f"      mismatch [{mm['slug']}]")
            if mm['summary']:
                words = mm['summary'].split()
                line2 = ''
                for w in words:
                    if len(line2) + len(w) > 74:
                        print(f'        {line2}'); line2 = w
                    else:
                        line2 = (line2 + ' ' + w).strip()
                if line2:
                    print(f'        {line2}')
    counts = {}
    for e in entries:
        counts[e['status']] = counts.get(e['status'], 0) + 1
    print('\nby status: ' + ', '.join(f'{k}={v}' for k, v in sorted(counts.items())))
    print(f'recorded divergences: {sum(len(e["mismatches"]) for e in entries)}')
    if do and flips:
        print(f'\n*** {len(flips)} restoration(s) NEWLY MATCH under this compiler ***')
        for e in flips:
            print(f'    {e["file"]}   {e["restores"]}')
        print('    -> set STATUS: exact, extract the function, and wire it into'
              '\n       src/c/replacements.txt so it reaches the binary.')
    elif do:
        print('\nno status changes')
    if not do:
        print('\nrun with --recheck to recompile and verify these against the current compiler')
    sys.exit(exit_bad)


if __name__ == '__main__':
    main()
