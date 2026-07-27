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
# Unattended: an emulator harness is the oracle, so this needs no human between
# steps. ORACLE selects which one -- probe_esq.sh (does it boot) by default, or
# keydrive_esq.sh (does it survive the ESC menu), which is what caught a fault
# that boots and soaks perfectly and only dies on a keypress:
#
#   ORACLE=tools/keydrive_esq.sh tools/bisect_added.sh /dev/null all.txt esc
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
ORACLE="${ORACLE:-tools/probe_esq.sh}"
SCO="NOSTKCHK DATA=FAR CODE=FAR CODENAME=S_0 DATANAME=S_1 IDLEN=128"

build_and_probe() {   # $1 = file of manifest keys to include ; $2 = label
    grep '^#' "$MANIFEST" > "$WORK"
    grep -Ff "$1" "$MANIFEST" >> "$WORK"
    local want; want=$(grep -c . "$1" || true)
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
    "$ORACLE" build/ESQ "$2" >/dev/null 2>&1
}

lo=0
hi=$(grep -c . "$ADDED")
echo "bisecting $hi added entries over a $(grep -c . "$BASE" 2>/dev/null || echo 0)-entry baseline, oracle=$ORACLE"

while [ $((hi - lo)) -gt 1 ]; do
    mid=$(( lo + (hi - lo) / 2 ))
    [ -s "$BASE" ] && cat "$BASE" > /tmp/ba_try.txt || : > /tmp/ba_try.txt
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
[ -s "$BASE" ] && cat "$BASE" > /tmp/ba_solo.txt || : > /tmp/ba_solo.txt
echo "$culprit" >> /tmp/ba_solo.txt
if build_and_probe /tmp/ba_solo.txt "${TAG}_solo"; then
    echo "SOLO: PASS -- baseline plus this entry alone is healthy."
    if [ -s "$BASE" ]; then
        echo "  With a real baseline that means the bisect named an innocent entry"
        echo "  and more than one fault is present."
    else
        echo "  BUT the baseline was EMPTY, so this test is weak: one replacement on"
        echo "  its own may never be reached the way it is in a full build. Confirm"
        echo "  instead by REMOVING the entry from the full manifest and re-testing;"
        echo "  if that still fails, the entry is not the (only) cause."
    fi
else
    echo "SOLO: FAIL -- confirmed, $culprit breaks on its own"
fi
