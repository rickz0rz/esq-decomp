#!/bin/bash
# Boot a candidate ESQ under FS-UAE and decide PASS/FAIL without a screenshot.
#
#   tools/probe_esq.sh <binary> <label> [seconds]
#
# Oracle: a healthy run reaches ESQ's own serial setup, which FS-UAE logs as
#   SERIAL: period=1488, baud=2400, ... PC=26ad22
# A failing run never gets there; Kickstart re-executes its boot-time illegal
# instruction instead, which looks like the machine resetting rather than
# freezing. Validated against two builds the user ground-truthed by hand.
set -uo pipefail
BIN="${1:?}"; LABEL="${2:?}"; WAIT="${3:-40}"
UAELOG="$HOME/Documents/FS-UAE/Cache/Logs/fs-uae.log.txt"
CFG="$HOME/Documents/FS-UAE/Configurations/Prevue-HDD.fs-uae"
cp -f "$BIN" "$HOME/Downloads/Prevue/ESQ"; chmod +x "$HOME/Downloads/Prevue/ESQ"
pkill -f fs-uae 2>/dev/null; sleep 1; rm -f "$UAELOG"
fs-uae "$CFG" >/dev/null 2>&1 &
sleep "$WAIT"
pkill -f fs-uae 2>/dev/null; sleep 1
cp "$UAELOG" "/tmp/probe_$LABEL.log" 2>/dev/null
if grep -q "baud=2400" "/tmp/probe_$LABEL.log" 2>/dev/null; then
    echo "PASS  $LABEL"; exit 0
else
    echo "FAIL  $LABEL"; exit 1
fi
