#!/usr/bin/env python3
"""Bisect the maximum-C manifest to find a restoration that breaks at runtime.

    python3 tools/bisect_maxc.py init          # start: order candidates, write state
    python3 tools/bisect_maxc.py hang          # the last binary HUNG  -> fault is in it
    python3 tools/bisect_maxc.py ok            # the last binary RAN   -> fault is in the rest
    python3 tools/bisect_maxc.py status

Each step prints the manifest to build next. Runtime is the only oracle -- no
gate can judge a maximum-C build, because behavioural restorations differ from
the original by construction -- and every probe costs a human a VM run, so the
candidate order matters:

  candidates are sorted by DISTANCE FROM ESQ_MainInitAndRun, shallowest first.

With a load-time failure the earliest-executing restoration is the likeliest
culprit, and if there turn out to be several faults this ordering finds the one
that fires first, which is the one worth fixing first anyway.

State lives in build/bisect.json so a session can be interrupted and resumed.
"""
import json
import os
import re
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
STATE = os.path.join(ROOT, 'build', 'bisect.json')
MANIFEST = os.path.join(ROOT, 'src/c/replacements-all.txt')


def depth_order():
    """Manifest lines ordered by call distance from the program entry."""
    calls, defs = {}, {}
    for dp, _, fs in os.walk(os.path.join(ROOT, 'src', 'modules')):
        for f in fs:
            if not f.endswith('.s'):
                continue
            p = os.path.join(dp, f)
            t = open(p).read()
            bare = '\n'.join(x.split(';')[0] for x in t.split('\n'))
            for l in re.findall(r'^([A-Za-z_][\w]*):', t, re.M):
                defs[l] = p
            cur = None
            for line in bare.split('\n'):
                m = re.match(r'^([A-Za-z_][\w]*):', line)
                if m:
                    cur = m.group(1)
                    calls.setdefault(cur, set())
                elif cur:
                    for t2 in re.findall(r'\b(?:JSR|BSR\.[WS]|JMP)\s+([A-Za-z_][\w]*)', line):
                        calls[cur].add(t2)

    def resolve(t):
        for c in (t, t.lstrip('_'), t.replace('_JMPTBL_', '_')):
            if c in defs:
                return c.lstrip('_')
        return None

    depth, seen, frontier = {}, {'ESQ_MainInitAndRun'}, ['ESQ_MainInitAndRun']
    d = 0
    while frontier:
        d += 1
        nxt = []
        for n in frontier:
            for t in set(calls.get(n, set())) | set(calls.get('_' + n, set())):
                r = resolve(t)
                if r and r not in seen:
                    seen.add(r)
                    depth[r] = d
                    nxt.append(r)
        frontier = nxt

    rows = [l for l in open(MANIFEST) if l.strip() and not l.startswith('#')]
    def key(line):
        c = line.split()[1]
        m = re.search(r'RESTORES:\s*(\S+)', open(os.path.join(ROOT, 'src', c)).read())
        n = m.group(1).lstrip('_') if m else ''
        return (depth.get(n, 99), c)
    return sorted(rows, key=key)


def load():
    return json.load(open(STATE))


def save(s):
    os.makedirs(os.path.dirname(STATE), exist_ok=True)
    json.dump(s, open(STATE, 'w'), indent=1)


def emit(s):
    """Write the next candidate manifest and say what to build."""
    lo, hi = s['lo'], s['hi']
    cand = s['order'][lo:hi]
    if len(cand) <= 1:
        print(f"\n*** ISOLATED: {cand[0].split()[1] if cand else '(none)'} ***")
        return
    mid = lo + (hi - lo) // 2
    s['probe'] = [lo, mid]
    save(s)
    hdr = [l for l in open(MANIFEST) if l.startswith('#')]
    out = os.path.join(ROOT, 'build', 'bisect_manifest.txt')
    open(out, 'w').write(''.join(hdr + s['order'][lo:mid]))
    print(f'candidates: {hi-lo}   probing first {mid-lo} of them')
    print(f'manifest written: {out}')
    print('build with:')
    print('  SCOPTS="NOSTKCHK DATA=FAR CODE=FAR CODENAME=S_0 DATANAME=S_1 IDLEN=128" \\')
    print(f'    C_REPLACEMENTS=build/bisect_manifest.txt ./build-split.sh')


def main():
    cmd = sys.argv[1] if len(sys.argv) > 1 else 'status'
    if cmd == 'init':
        order = depth_order()
        s = {'order': order, 'lo': 0, 'hi': len(order), 'probe': None}
        save(s)
        print(f'{len(order)} candidates, ordered by init depth')
        emit(s)
        return
    s = load()
    if cmd == 'hang':
        s['hi'] = s['probe'][1]          # fault is inside the probed subset
    elif cmd == 'ok':
        s['lo'] = s['probe'][1]          # fault is in the remainder
    elif cmd != 'status':
        sys.exit(__doc__)
    save(s)
    print(f"remaining candidates: {s['hi'] - s['lo']}")
    emit(s)


if __name__ == '__main__':
    main()
