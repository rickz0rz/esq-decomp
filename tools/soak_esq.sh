#!/bin/bash
# Run a candidate ESQ for minutes rather than seconds, capturing the screen as
# it goes, so faults past the boot path have a chance to show.
#
#   tools/soak_esq.sh <binary> <label> [total_seconds] [interval_seconds]
#
# probe_esq.sh answers one question -- did it reach serial init -- and answers it
# in 45 seconds. That proves the binary BOOTS. It says nothing about the screens
# ESQ draws afterwards, which is where most restored code actually runs.
#
# No input automation is needed: ESQ is a broadcast program and cycles its own
# displays unattended. So a long run with periodic capture exercises the grid,
# the banners and the clock redraw for free.
#
# Each shot is cropped to the emulator window, because the rest of the desktop
# changes constantly and would swamp any comparison. CROP is a sips geometry
# (height width offsetY offsetX) in PIXELS on a 5120x2880 retina capture; it
# depends on where FS-UAE opens, which the config fixes, so it is stable -- but
# check one shot by eye before trusting a run on a different display.
set -uo pipefail

BIN="${1:?usage: soak_esq.sh <binary> <label> [total] [interval]}"
LABEL="${2:?}"
TOTAL="${3:-240}"
STEP="${4:-30}"
CROP="${CROP:-1180 1920 780 1600}"

PREVUE="$HOME/Downloads/Prevue"
SHOTS="${SHOTS:-/tmp/esqsoak}"
CONFIG="$HOME/Documents/FS-UAE/Configurations/Prevue-HDD.fs-uae"
LOG="/tmp/soak_$LABEL.log"

mkdir -p "$SHOTS"
[ -f "$BIN" ] || { echo "no such binary: $BIN"; exit 2; }
rm -f "$SHOTS/${LABEL}_"*.png "$LOG"

cp -f "$BIN" "$PREVUE/ESQ" && chmod +x "$PREVUE/ESQ"
echo "== soak $LABEL: $(basename "$BIN") ($(stat -f%z "$BIN") bytes), ${TOTAL}s every ${STEP}s"

pkill -f 'fs-uae' 2>/dev/null; sleep 1
fs-uae "$CONFIG" >"$LOG" 2>&1 &
UAE=$!

t=0
while [ "$t" -lt "$TOTAL" ]; do
    sleep "$STEP"
    t=$((t + STEP))
    raw="$SHOTS/${LABEL}_${t}_raw.png"
    screencapture -x "$raw" 2>/dev/null || continue
    # shellcheck disable=SC2086
    sips -c $CROP "$raw" --out "$SHOTS/${LABEL}_$(printf '%03d' $t).png" >/dev/null 2>&1
    rm -f "$raw"
done

kill -9 $UAE 2>/dev/null; pkill -f 'fs-uae' 2>/dev/null
wait $UAE 2>/dev/null

echo "  shots: $(ls "$SHOTS/${LABEL}_"*.png 2>/dev/null | wc -l | tr -d ' ')"

# ESQ redraws a running clock every second, so NO two shots of a live machine
# are ever identical. Consecutive identical frames therefore mean the display
# stopped updating -- a hang, which the boot probe cannot see because the machine
# is still nominally "up". This is the whole point of soaking.
python3 - "$SHOTS" "$LABEL" <<'PY'
import hashlib, os, sys
d, lab = sys.argv[1], sys.argv[2]
fs = sorted(f for f in os.listdir(d) if f.startswith(lab + '_') and f.endswith('.png'))
hs = [hashlib.sha256(open(os.path.join(d, f), 'rb').read()).hexdigest() for f in fs]
run = best = 1
for i in range(1, len(hs)):
    run = run + 1 if hs[i] == hs[i-1] else 1
    best = max(best, run)
print(f'  distinct frames: {len(set(hs))}/{len(hs)}')
print(f'  longest identical run: {best}' + ('   <-- DISPLAY FROZEN' if best > 1 else ''))
PY
echo "  serial events: $(grep -c 'SERIAL:' "$LOG")"
# Kickstart's own boot path executes an illegal instruction, so a nonzero count
# is normal -- the known-good binary shows exactly one. What matters is a run
# showing MORE of them than the reference does.
echo "  illegal/exception lines: $(grep -icE 'illegal|exception|guru' "$LOG")"
echo "  log lines: $(wc -l < "$LOG" | tr -d ' ')"
