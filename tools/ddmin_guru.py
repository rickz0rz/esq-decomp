#!/usr/bin/env python3
"""Delta-debug the maximum-C guru down to a minimal failing set of restorations.

    python3 tools/ddmin_guru.py <list-of-manifest-keys> [--trials N] [--tag T]

A plain bisect cannot narrow this fault. Keeping the first 144 of 289 still
gurus, but NEITHER 72-entry half of that 144 gurus on its own -- so no single
entry is responsible and every 2-way split dead-ends. That is precisely the case
ddmin exists for: when no subset reproduces, it tests the COMPLEMENTS, and when
those also fail it refines the granularity instead of giving up.

The algorithm (Zeller's ddmin), specialised to "the set gurus":

    n = 2
    loop:
      split S into n roughly equal chunks
      if some chunk gurus            -> S = that chunk;      n = 2
      elif some complement gurus     -> S = that complement;  n = max(n-1, 2)
      elif n < |S|                   -> n = min(2n, |S|)
      else                           -> S is 1-minimal; stop

TWO PROPERTIES OF THIS FAULT SHAPE THE COST, and they work in our favour:

  A guru is definitive on the first trial, but "clean" is not -- the fault is
  intermittent, and the same 147-entry binary was clean on one run and gurued on
  the next. keydrive_esq.sh exits on the first guru, so a FAILING test costs one
  emulator run and a CLEAN one costs `trials`. The expensive verdict is the one
  that has to be trustworthy, which is the right way round.

  Complements are large and large builds fire reliably. ddmin tests complements
  as soon as the chunks come back clean, so it spends most of its budget in the
  regime where the oracle is dependable.

Progress is written to build/ddmin_state.json after every test, so a run that is
interrupted (or a machine that reboots) can be resumed by hand from the log
rather than repeating hours of emulator time.
"""
import argparse
import json
import os
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MANIFEST = os.path.join(ROOT, 'src/c/replacements-all.txt')
STATE = os.path.join(ROOT, 'build/ddmin_state.json')
SCO = 'NOSTKCHK DATA=FAR CODE=FAR CODENAME=S_0 DATANAME=S_1 IDLEN=128'

cache = {}


def gurus(keys, tag, trials):
    """True if a build of exactly `keys` shows a Guru."""
    sig = tuple(sorted(keys))
    if sig in cache:
        return cache[sig]

    work = os.path.join(ROOT, 'build', f'dd_{tag}.txt')
    head = [l for l in open(MANIFEST) if l.startswith('#')]
    rows = [l for l in open(MANIFEST)
            if not l.startswith('#') and l.strip() and l.split()[1] in set(keys)]
    if len(rows) != len(keys):
        sys.exit(f'{tag}: asked for {len(keys)} entries, manifest matched {len(rows)}')
    open(work, 'w').write(''.join(head + rows))

    env = dict(os.environ, SCOPTS=SCO, C_REPLACEMENTS=work)
    log = os.path.join(ROOT, 'build', f'dd_{tag}.log')
    with open(log, 'w') as fh:
        subprocess.run(['./build-split.sh'], cwd=ROOT, env=env, stdout=fh, stderr=fh)
    text = open(log).read()
    if 'FAILED (cc)' in text or 'undefined symbol' in text or 'LINK FAILED' in text:
        # A build that does not link tells us nothing about the fault. Treat it
        # as clean so ddmin keeps searching elsewhere, and say so loudly -- the
        # 16-bit BSR.W range in the hand-written assembly makes this real.
        print(f'    {tag}: BUILD FAILED ({len(keys)} entries) -- treated as clean', flush=True)
        cache[sig] = False
        return False

    env2 = dict(os.environ, TRIALS=str(trials))
    r = subprocess.run([os.path.join(ROOT, 'tools/keydrive_esq.sh'),
                        os.path.join(ROOT, 'build/ESQ'), f'dd{tag}', '50'],
                       cwd=ROOT, env=env2, capture_output=True, text=True)
    bad = (r.returncode == 1)
    print(f'    {tag}: {len(keys):4d} entries -> {"GURU" if bad else "clean"}', flush=True)
    cache[sig] = bad
    return bad


def chunks(lst, n):
    k, out, i = len(lst) // n, [], 0
    for j in range(n):
        take = k if j < n - 1 else len(lst) - i
        out.append(lst[i:i + take])
        i += take
    return [c for c in out if c]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('listfile')
    ap.add_argument('--trials', type=int, default=2)
    ap.add_argument('--tag', default='dd')
    a = ap.parse_args()

    S = [l.strip() for l in open(a.listfile) if l.strip()]
    print(f'ddmin over {len(S)} entries, trials={a.trials}', flush=True)
    if not gurus(S, f'{a.tag}_full', a.trials):
        sys.exit('the full set does not guru -- nothing to minimise')

    n, step = 2, 0
    while len(S) > 1:
        cs = chunks(S, n)
        step += 1
        hit = None
        for i, c in enumerate(cs):                       # any chunk on its own?
            if gurus(c, f'{a.tag}{step}c{i}', a.trials):
                hit = c
                break
        if hit is not None:
            S, n = hit, 2
            print(f'  step {step}: a chunk reproduces -> {len(S)} entries', flush=True)
        else:
            comp = None
            for i, c in enumerate(cs):                   # any complement?
                rest = [x for x in S if x not in set(c)]
                if rest and gurus(rest, f'{a.tag}{step}k{i}', a.trials):
                    comp = rest
                    break
            if comp is not None:
                S, n = comp, max(n - 1, 2)
                print(f'  step {step}: a complement reproduces -> {len(S)} entries', flush=True)
            elif n < len(S):
                n = min(2 * n, len(S))
                print(f'  step {step}: no luck, granularity -> {n}', flush=True)
            else:
                break
        json.dump({'set': S, 'n': n}, open(STATE, 'w'), indent=1)

    print(f'\nMINIMAL FAILING SET ({len(S)}):')
    for x in S:
        print(f'  {x}')


if __name__ == '__main__':
    main()
