#!/bin/bash
# Boot a candidate ESQ binary in FS-UAE, screenshot the result, shut it down.
#
#   tools/run_fsuae.sh <binary> <label> [seconds]
#
# The maximum-C build cannot be judged by either gate -- behavioural restorations
# differ from the original by construction -- so running it is the only oracle,
# and that used to mean asking a human for every probe. This makes a probe cost
# nothing but wall-clock.
#
# ~/Downloads/Prevue is mounted as hard_drive_1 by the Prevue-HDD config and the
# Amiga side launches "ESQ" by name, so the candidate has to be copied over that
# path. ESQ.known-good-36cf56ed is the pristine byte-exact build to restore from.
set -uo pipefail

BIN="${1:?usage: run_fsuae.sh <binary> <label> [seconds]}"
LABEL="${2:?}"
WAIT="${3:-35}"
PREVUE="$HOME/Downloads/Prevue"
SHOTS="${SHOTS:-/tmp/esqshots}"
CONFIG="$HOME/Documents/FS-UAE/Configurations/Prevue-HDD.fs-uae"

mkdir -p "$SHOTS"
[ -f "$BIN" ] || { echo "no such binary: $BIN"; exit 2; }

cp -f "$BIN" "$PREVUE/ESQ" && chmod +x "$PREVUE/ESQ"
echo "== $LABEL: $(basename "$BIN") ($(stat -f%z "$BIN") bytes) -> Prevue/ESQ"

pkill -f 'fs-uae' 2>/dev/null; sleep 1
fs-uae "$CONFIG" >"$SHOTS/$LABEL.fsuae.log" 2>&1 &
UAE=$!
sleep "$WAIT"

screencapture -x "$SHOTS/$LABEL.png" 2>/dev/null || echo "  (screencapture failed)"
kill -9 $UAE 2>/dev/null; pkill -f 'fs-uae' 2>/dev/null
wait $UAE 2>/dev/null

if [ -f "$SHOTS/$LABEL.png" ]; then
    echo "  shot: $SHOTS/$LABEL.png ($(stat -f%z "$SHOTS/$LABEL.png") bytes)"
fi
