#!/bin/bash
# Compile a C file and report only the regions that differ from the original.
#
#   tools/cdiff.sh <file.c> <FunctionLabel> [sc options]
#
# cmatch.sh prints both byte strings in full, which is unreadable past a hundred
# bytes or so. This prints the size delta and one line per differing region, with
# relocated fields excluded (the linker fills those in, so they can only be
# compared positionally and always "differ" in an object file).
#
# Region count is the number worth watching: a handful of regions means a few
# idiom substitutions, while dozens means the code generator laid the function
# out differently and the sizes matching would be a coincidence.
set -uo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$(mktemp)"; trap 'rm -f "$OUT"' EXIT
"$ROOT/tools/cmatch.sh" "$@" >"$OUT" 2>&1
head -1 "$OUT"
python3 - "$OUT" <<'PY'
import re, sys
t = open(sys.argv[1]).read()
mr = re.search(r'^  ref ([0-9a-f]+)', t, re.M)
mg = re.search(r'^  got ([0-9a-f]+)', t, re.M)
if not (mr and mg):
    sys.exit(0)                                    # MATCH, or a compile failure
a = bytearray.fromhex(mr.group(1)); b = bytearray.fromhex(mg.group(1))
sites = [(int(o, 16), int(w)) for o, w in re.findall(r'0x([0-9a-f]+)/(\d)', t)]
n = min(len(a), len(b))
mask = bytearray(b'\1' * max(len(a), len(b)))
for o, w in sites:
    for k in range(o, min(o + w, len(mask))):
        mask[k] = 0
runs, i = [], 0
while i < n:
    if mask[i] and a[i] != b[i]:
        j = i
        while j < n and (not mask[j] or a[j] != b[j]):
            j += 1
        runs.append((i, j)); i = j
    else:
        i += 1
print(f'  ref {len(a)}  got {len(b)}  ({len(b)-len(a):+d})   {len(runs)} differing region(s)')
for i, j in runs[:24]:
    print(f'   @0x{i:03x}  ref {a[i:j].hex():<30s} got {b[i:j].hex()}')
if len(runs) > 24:
    print(f'   ... {len(runs)-24} more')
PY
