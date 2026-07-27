#!/bin/bash
# Boot a candidate ESQ under FS-UAE and decide PASS/FAIL without a screenshot.
#
#   tools/probe_esq.sh <binary> <label> [seconds_per_attempt]
#
# Oracle: a healthy run reaches ESQ's own serial setup, which FS-UAE logs as
#   SERIAL: period=1488, baud=2400, ... PC=26ad22
# A failing run never gets there; Kickstart re-executes its boot-time illegal
# instruction instead, which looks like the machine resetting rather than
# freezing. Validated against two builds the user ground-truthed by hand.
#
# WHY IT SLEEPS INSTEAD OF POLLING: FS-UAE buffers its log and only flushes on
# exit -- measured, the file sits at exactly 45056 bytes for the whole run and
# gains the marker only after the process is killed. So the marker cannot be
# watched for; the run has to be given time and then stopped.
#
# WHY IT RETRIES: with a 45s budget this probe reported a single FAIL for a
# binary that passes reliably, because the run had not reached serial init yet
# on a host busy with a compile. One false FAIL sent an entire bisect after an
# innocent restoration. A PASS is trustworthy on its own -- the marker cannot
# appear by accident -- but a FAIL is only believed after a second attempt, so
# the expensive retry happens only on the path that was going to cost far more
# in wasted analysis anyway.
set -uo pipefail
BIN="${1:?usage: probe_esq.sh <binary> <label> [seconds]}"
LABEL="${2:?}"
WAIT="${3:-60}"
UAELOG="$HOME/Documents/FS-UAE/Cache/Logs/fs-uae.log.txt"
CFG="$HOME/Documents/FS-UAE/Configurations/Prevue-HDD.fs-uae"

[ -f "$BIN" ] || { echo "FAIL  $LABEL  (no such binary: $BIN)"; exit 2; }
cp -f "$BIN" "$HOME/Downloads/Prevue/ESQ"; chmod +x "$HOME/Downloads/Prevue/ESQ"

attempt() {
    pkill -f fs-uae 2>/dev/null; sleep 1; rm -f "$UAELOG"
    fs-uae "$CFG" >/dev/null 2>&1 &
    sleep "$WAIT"
    pkill -f fs-uae 2>/dev/null; sleep 1
    cp "$UAELOG" "/tmp/probe_$LABEL.log" 2>/dev/null
    grep -q "baud=2400" "/tmp/probe_$LABEL.log" 2>/dev/null
}

if attempt; then
    echo "PASS  $LABEL"; exit 0
fi
echo "  ($LABEL: no marker on attempt 1; retrying before calling it a failure)" >&2
if attempt; then
    echo "PASS  $LABEL  (on retry)"; exit 0
fi
echo "FAIL  $LABEL  (two attempts, ${WAIT}s each)"; exit 1
