#!/bin/bash
# Bisect a set of NEWLY-ADDED C replacements against a known-good baseline.
#
#   tools/bisect_added.sh <baseline-list> <added-list> [label]
#
# Both arguments are lists of manifest keys (the `c/foo.c` column). The baseline
# is a set already proven to boot; the added list is what has not been run yet.
# Everything in the baseline stays in every build, so a FAIL is always caused by
# something in the added set -- which keeps the search space at the size of the
# increment rather than the size of the manifest.
#
# Unattended: tools/probe_esq.sh is the oracle, so this needs no human between
# steps. Each iteration is a full build plus a ~45s emulator run.
#
# Prints the first culprit it isolates, then CONFIRMS it with a solo build --
# baseline plus that one entry. A bisect over a set with two independent faults
# will otherwise name an innocent entry, which has happened here before.
set -uo pipefail
BASE="${1:?usage: bisect_added.sh <baseline-list> <added-list> [label]}"
ADDED="${2:?}"
TAG="${3:-bisect}"
MANIFEST=src/c/replacements-all.txt
WORK=build/bisect_added.txt
SCO="NOSTKCHK DATA=FAR CODE=FAR CODENAME=S_0 DATANAME=S_1 IDLEN=128"

build_and_probe() {   # $1 = file of manifest keys to include ; $2 = label
    grep '^#' "$MANIFEST" > "$WORK"
    grep -Ff "$1" "$MANIFEST" >> "$WORK"
    local want; want=$(grep -c . "$1")
    local got;  got=$(grep -vc '^#' "$WORK")
    if [ "$want" != "$got" ]; then
        echo "  ABORT: asked for $want entries, manifest matched $got" >&2
        return 2
    fi
    SCOPTS="$SCO" C_REPLACEMENTS="$WORK" ./build-split.sh >"build/$2.log" 2>&1
    if [ "$(grep -c 'FAILED (cc)' "build/$2.log")" != "0" ] \
       || grep -q 'undefined symbol' "build/$2.log"; then
        echo "  ABORT: build not clean; see build/$2.log" >&2
        return 2
    fi
    tools/probe_esq.sh build/ESQ "$2" 45 >/dev/null 2>&1
}

lo=0
hi=$(grep -c . "$ADDED")
echo "bisecting $hi added entries over a $(grep -c . "$BASE")-entry baseline"

while [ $((hi - lo)) -gt 1 ]; do
    mid=$(( lo + (hi - lo) / 2 ))
    cat "$BASE" > /tmp/ba_try.txt
    head -n "$mid" "$ADDED" >> /tmp/ba_try.txt
    if build_and_probe /tmp/ba_try.txt "${TAG}_$mid"; then
        echo "  first $mid added: PASS"
        lo=$mid
    else
        echo "  first $mid added: FAIL"
        hi=$mid
    fi
done

culprit=$(sed -n "${hi}p" "$ADDED")
echo
echo "CULPRIT (by bisect): $culprit"

# A bisect assumes ONE fault. Confirm against the baseline alone, which is what
# caught a false positive the last time this was done by hand.
cat "$BASE" > /tmp/ba_solo.txt
echo "$culprit" >> /tmp/ba_solo.txt
if build_and_probe /tmp/ba_solo.txt "${TAG}_solo"; then
    echo "SOLO: PASS -- the bisect named an innocent entry; more than one fault present"
else
    echo "SOLO: FAIL -- confirmed, $culprit breaks on its own"
fi
