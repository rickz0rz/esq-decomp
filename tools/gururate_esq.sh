#!/bin/bash
# Measure how OFTEN an intermittent guru fires, instead of just whether it can.
#
#   tools/gururate_esq.sh <binary> <label> [runs] [boot_wait]
#
# WHY THIS EXISTS
#
# keydrive_esq.sh answers "can this build guru?" and exits on the first one,
# which is the right shape for condemning a build. It cannot answer "how many
# clean trials does it take before CLEAN means anything?", and every negative
# result in the ESC-menu-guru hunt depends on that number.
#
# The load-bearing example: the conclusion "it is NOT one file" rests on the
# 144-entry set guruing while NEITHER of its 72-entry halves did. Those two
# halves were acquitted on 3 clean trials each. If the fault fires with
# probability p per trial, a 3-trial acquittal is wrong with probability
# (1-p)^3 -- which is 34% at p=0.3, and 12.5% at p=0.5. Two halves, so the
# chance that at least one was falsely acquitted is up to ~57%. That is not a
# safe basis for ruling out a single bad restoration.
#
# So: run N INDEPENDENT trials, never exit early, and report the rate. Then
# (1-p)^n gives the trials needed for a trustworthy acquittal.
#
# It deliberately shells out to keydrive_esq.sh with TRIALS=1 rather than
# reimplementing the boot/key/capture/detect sequence, because that sequence has
# already cost two false conclusions to get right (see the header comments in
# keydrive_esq.sh and guru_detect.py). One trial per invocation, exit code is
# the verdict: 0 clean, 1 guru, 2 harness failure.
#
# HARNESS FAILURES ARE NOT CLEAN RUNS. A trial that never reached the menu --
# boot too slow on a busy host -- produces a screen that is black but not red,
# which the detector correctly calls "not a guru". Counting that as clean
# DEFLATES the rate and would make this tool lie in the same direction as the
# bug it exists to catch. Such trials are counted separately and the shots are
# kept so `Read`ing one can confirm the machine actually got into the menu.
set -uo pipefail

BIN="${1:?usage: gururate_esq.sh <binary> <label> [runs] [boot_wait]}"
LABEL="${2:?}"
RUNS="${3:-12}"
BOOT="${4:-50}"
HERE="$(cd "$(dirname "$0")" && pwd)"

[ -f "$BIN" ] || { echo "no such binary: $BIN"; exit 2; }

guru=0; clean=0; broke=0
echo "== gururate $LABEL: $(basename "$BIN") ($(stat -f%z "$BIN") bytes), $RUNS trial(s), boot ${BOOT}s"
for i in $(seq 1 "$RUNS"); do
    TRIALS=1 SHOTS="/tmp/esqrate_$LABEL/$i" \
        "$HERE/keydrive_esq.sh" "$BIN" "${LABEL}r$i" "$BOOT" >/tmp/gururate_$LABEL.$i.log 2>&1
    rc=$?
    case $rc in
        0) clean=$((clean+1)); v=clean ;;
        1) guru=$((guru+1));   v=GURU  ;;
        *) broke=$((broke+1)); v="harness-fail(rc=$rc)" ;;
    esac
    printf '  trial %2d/%s: %-22s  running: %d guru / %d clean / %d broken\n' \
        "$i" "$RUNS" "$v" "$guru" "$clean" "$broke"
done

usable=$((guru+clean))
echo
echo "== $LABEL: $guru guru, $clean clean, $broke harness-fail  ($usable usable trials)"
if [ "$usable" -gt 0 ]; then
    awk -v g="$guru" -v u="$usable" 'BEGIN{
        p = g/u;
        printf("   fire rate p = %.3f\n", p);
        if (p <= 0) { print "   no gurus seen -- this says nothing unless p is known from a positive control"; exit }
        if (p >= 1) { print "   fires every trial -- 1 clean trial would already acquit"; exit }
        printf("   trials for a 95%% trustworthy CLEAN: %d   (99%%: %d)\n",
               int(log(0.05)/log(1-p))+1, int(log(0.01)/log(1-p))+1);
    }'
fi
echo "   shots: /tmp/esqrate_$LABEL/<trial>/   logs: /tmp/gururate_$LABEL.<trial>.log"
