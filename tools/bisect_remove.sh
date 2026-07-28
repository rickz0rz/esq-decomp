#!/bin/bash
# Narrow an INTERMITTENT fault by removing entries, not by adding them.
#
#   tools/bisect_remove.sh <full-list> [label]        ORACLE=... TRIALS=...
#
# bisect_added.sh builds prefixes: it starts small and grows. That is the wrong
# shape for the maximum-C guru, because the fault's probability rises with the
# number of replacements -- the full 289 gurus on essentially every trial, while
# a 147-entry subset came up clean on one run and gurued on the next. A prefix
# bisect therefore spends most of its budget in exactly the regime where a
# "clean" verdict cannot be trusted, and a single false clean sends it down the
# wrong half for good.
#
# This keeps the set large instead. Each step removes a HALF and asks whether the
# remainder still gurus:
#
#   still gurus  -> the cause is inside what was kept; recurse there
#   now clean    -> the cause was in what was removed; put it back, drop the other
#
# The verdict it relies on -- "still gurus" -- is the reliable one, because the
# builds stay big. A "clean" reading is only accepted after TRIALS trials, and
# TRIALS defaults to 3 in keydrive_esq.sh for that reason.
#
# This is delta debugging with one assumption: a single entry is responsible. If
# both halves come back clean the cause needs more than one entry, and the script
# says so rather than picking a boundary and pretending.
set -uo pipefail

FULL="${1:?usage: bisect_remove.sh <full-list> [label]}"
TAG="${2:-rm}"
MANIFEST=src/c/replacements-all.txt
ORACLE="${ORACLE:-tools/keydrive_esq.sh}"
SCO="NOSTKCHK DATA=FAR CODE=FAR CODENAME=S_0 DATANAME=S_1 IDLEN=128"

# 0 = the build gurued (the fault is present), 1 = clean
gurus() {   # $1 = file of manifest keys, $2 = label
    local work="build/${TAG}_$2.txt"
    grep '^#' "$MANIFEST" > "$work"
    grep -Ff "$1" "$MANIFEST" >> "$work"
    local want got
    want=$(grep -c . "$1" || true)
    got=$(grep -vc '^#' "$work")
    if [ "$want" != "$got" ]; then
        echo "  ABORT: asked for $want entries, manifest matched $got" >&2
        return 2
    fi
    SCOPTS="$SCO" C_REPLACEMENTS="$work" ./build-split.sh >"build/${TAG}_$2.log" 2>&1
    if [ "$(grep -c 'FAILED (cc)' "build/${TAG}_$2.log")" != "0" ] \
       || grep -q 'undefined symbol' "build/${TAG}_$2.log"; then
        echo "  ABORT: build not clean; see build/${TAG}_$2.log" >&2
        return 2
    fi
    "$ORACLE" build/ESQ "${TAG}$2" >/dev/null 2>&1 && return 1 || return 0
}

cp "$FULL" /tmp/br_set.txt
n=$(grep -c . /tmp/br_set.txt)
echo "narrowing $n entries by removal, oracle=$ORACLE"

step=0
while [ "$n" -gt 1 ]; do
    step=$((step + 1))
    half=$(( n / 2 ))
    head -n "$half" /tmp/br_set.txt > /tmp/br_a.txt
    tail -n +"$((half + 1))" /tmp/br_set.txt > /tmp/br_b.txt

    if gurus /tmp/br_a.txt "${step}a"; then
        echo "  step $step: keeping first $half of $n -- STILL GURUS"
        cp /tmp/br_a.txt /tmp/br_set.txt
    elif gurus /tmp/br_b.txt "${step}b"; then
        echo "  step $step: keeping last $((n - half)) of $n -- STILL GURUS"
        cp /tmp/br_b.txt /tmp/br_set.txt
    else
        echo
        echo "NEITHER HALF gurus on its own at $n entries."
        echo "The cause is not a single entry: it needs a combination, or it is"
        echo "sensitive to something the split changes (layout, image size)."
        echo "Remaining set left in /tmp/br_set.txt"
        exit 2
    fi
    n=$(grep -c . /tmp/br_set.txt)
done

echo
echo "NARROWED TO: $(cat /tmp/br_set.txt)"
