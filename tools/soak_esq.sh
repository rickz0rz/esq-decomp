#!/bin/bash
# Run a candidate ESQ for minutes rather than seconds, capturing the emulator
# window as it goes, so faults past the boot path have a chance to show.
#
#   tools/soak_esq.sh <binary> <label> [total_seconds] [interval_seconds]
#
# probe_esq.sh answers one question -- did it reach serial init -- and answers it
# in 45 seconds. That proves the binary BOOTS. It says nothing about the screens
# ESQ draws afterwards, which is where most restored code actually runs.
#
# No input automation is needed: ESQ is a broadcast program and cycles its own
# displays unattended. So a long run with periodic capture exercises the grid,
# the banners, the IFF brush loads and the clock redraw for free.
#
# THIS SCRIPT CAPTURES THE FS-UAE WINDOW BY ID, not a rectangle of the screen.
# The earlier version cropped a hardcoded rectangle out of a full-screen grab.
# That silently scored the WRONG PIXELS three times in one day: once the editor
# window, once the desktop wallpaper. The window had moved to another macOS
# Space, where a full-screen grab cannot see it at all, and the freeze check then
# reported a healthy build as frozen and a static desktop as alive. A window-id
# capture finds the window wherever it is, on any Space, at any position.
#
# It also FAILS LOUDLY now. The old version printed "DISPLAY FROZEN" and exited
# 0, so nothing could act on it. Exit codes:
#   0  the display kept changing
#   1  the display froze, or ESQ never reached serial init
#   2  bad arguments, or the emulator window never appeared
#
# WHAT THIS STILL DOES NOT REACH: anything behind a keypress -- the ED editor,
# the ESC menu, the diagnostics screens. Driving those needs synthetic keyboard
# input, and macOS refuses it: `osascript ... keystroke` returns "osascript is
# not allowed to send keystrokes (1002)" without an Accessibility grant for the
# terminal. Screen Recording was granted for the capture; Accessibility is a
# separate permission and has not been. Until it is, the menu paths are covered
# by byte comparison only.
set -uo pipefail

BIN="${1:?usage: soak_esq.sh <binary> <label> [total] [interval]}"
LABEL="${2:?}"
TOTAL="${3:-240}"
STEP="${4:-30}"

PREVUE="$HOME/Downloads/Prevue"
SHOTS="${SHOTS:-/tmp/esqsoak}"
CONFIG="${CONFIG:-$HOME/Documents/FS-UAE/Configurations/Prevue-HDD.fs-uae}"
LOG="/tmp/soak_$LABEL.log"
# FS-UAE writes its real log here, not to stdout, and only flushes it on exit.
UAELOG="$HOME/Documents/FS-UAE/Cache/Logs/fs-uae.log.txt"
# Needs pyobjc-framework-Quartz. The system python does not have it:
#   /tmp/.capvenv/bin/pip install pyobjc-framework-Quartz Pillow
CAPPY="${CAPPY:-/tmp/.capvenv/bin/python}"

mkdir -p "$SHOTS"
[ -f "$BIN" ] || { echo "no such binary: $BIN"; exit 2; }
[ -x "$CAPPY" ] || { echo "no python with Quartz at $CAPPY -- see the header"; exit 2; }
rm -f "$SHOTS/${LABEL}_"*.png "$LOG"

cp -f "$BIN" "$PREVUE/ESQ" && chmod +x "$PREVUE/ESQ"
echo "== soak $LABEL: $(basename "$BIN") ($(stat -f%z "$BIN") bytes), ${TOTAL}s every ${STEP}s"

pkill -f 'fs-uae' 2>/dev/null; sleep 1
rm -f "$UAELOG"
fs-uae "$CONFIG" >/dev/null 2>&1 &
UAE=$!

# The emulator's own window, not the frontmost one. Width filters out the
# zero-sized helper window fs-uae also registers.
find_window() {
    "$CAPPY" - <<'PY'
import Quartz
opts = Quartz.kCGWindowListOptionAll | Quartz.kCGWindowListExcludeDesktopElements
for w in Quartz.CGWindowListCopyWindowInfo(opts, Quartz.kCGNullWindowID):
    if (w.get('kCGWindowOwnerName') or '') == 'fs-uae':
        if (w.get('kCGWindowBounds') or {}).get('Width', 0) > 100:
            print(w.get('kCGWindowNumber')); break
PY
}

WID=""
for _ in $(seq 1 30); do
    WID="$(find_window)"
    [ -n "$WID" ] && break
    sleep 1
done
if [ -z "$WID" ]; then
    echo "  ERROR: the fs-uae window never appeared -- nothing was captured"
    kill -9 $UAE 2>/dev/null; pkill -f 'fs-uae' 2>/dev/null
    exit 2
fi
echo "  emulator window id $WID"

t=0
while [ "$t" -lt "$TOTAL" ]; do
    sleep "$STEP"
    t=$((t + STEP))
    screencapture -x -o -l "$WID" "$SHOTS/${LABEL}_$(printf '%03d' $t).png" 2>/dev/null
done

kill -9 $UAE 2>/dev/null; pkill -f 'fs-uae' 2>/dev/null
wait $UAE 2>/dev/null
sleep 1
cp "$UAELOG" "$LOG" 2>/dev/null

echo "  shots: $(ls "$SHOTS/${LABEL}_"*.png 2>/dev/null | wc -l | tr -d ' ')"

# ESQ redraws a running clock every second, so NO two shots of a live machine
# are ever identical. Consecutive identical frames therefore mean the display
# stopped updating -- a hang, which the boot probe cannot see because the machine
# is still nominally "up". This is the whole point of soaking.
#
# The frames are also checked for Amiga content. A window capture cannot pick up
# the wrong window, but it CAN pick up a window that is not drawing, and a run of
# identical blank frames should read as a broken capture rather than as a hang.
"$CAPPY" - "$SHOTS" "$LABEL" <<'PY'
import hashlib, os, sys
from PIL import Image
d, lab = sys.argv[1], sys.argv[2]
fs = sorted(f for f in os.listdir(d) if f.startswith(lab + '_') and f.endswith('.png'))
hs = [hashlib.sha256(open(os.path.join(d, f), 'rb').read()).hexdigest() for f in fs]
run = best = 1
for i in range(1, len(hs)):
    run = run + 1 if hs[i] == hs[i-1] else 1
    best = max(best, run)
print(f'  distinct frames: {len(set(hs))}/{len(hs)}')
print(f'  longest identical run: {best}' + ('   <-- DISPLAY FROZEN' if best > 1 else ''))

# ESQ paints saturated blue panels and a red banner over black. A frame with
# almost no color is a window that is up but not drawing.
colored = 0
for f in fs:
    im = Image.open(os.path.join(d, f)).convert('RGB').resize((160, 100))
    raw = im.tobytes()
    px = [raw[i:i+3] for i in range(0, len(raw), 3)]
    if sum(1 for p in px if max(p) - min(p) > 40) > len(px) * 0.02:
        colored += 1
print(f'  frames with Amiga content: {colored}/{len(fs)}')
PY

echo "  serial events: $(grep -c 'SERIAL:' "$LOG")"
echo "  illegal/exception lines: $(grep -ci 'illegal\|exception' "$LOG")"
echo "  log lines: $(wc -l < "$LOG" | tr -d ' ')"

# The verdict, so callers do not have to parse the text above.
frozen=$("$CAPPY" - "$SHOTS" "$LABEL" <<'PY'
import hashlib, os, sys
d, lab = sys.argv[1], sys.argv[2]
fs = sorted(f for f in os.listdir(d) if f.startswith(lab + '_') and f.endswith('.png'))
hs = [hashlib.sha256(open(os.path.join(d, f), 'rb').read()).hexdigest() for f in fs]
print(1 if any(hs[i] == hs[i-1] for i in range(1, len(hs))) or len(hs) < 2 else 0)
PY
)
if [ "$frozen" = "1" ]; then
    echo "SOAK: FAIL  $LABEL  (display frozen)"
    exit 1
fi
if [ "$(grep -c 'SERIAL:' "$LOG")" = "0" ]; then
    echo "SOAK: FAIL  $LABEL  (never reached serial init)"
    exit 1
fi
echo "SOAK: PASS  $LABEL"
exit 0
