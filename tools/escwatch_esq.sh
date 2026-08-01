#!/bin/bash
# Open the ESC menu, close it, then WATCH the display recover (or not).
#
#   tools/escwatch_esq.sh <binary> <label> [open_wait] [shots] [gap]
#
# WHY THIS EXISTS
#
# keyprobe_esq.sh shoots once per key. That answers "what did the key do" and
# cannot answer "did the screen come back", which is the question the ESC-close
# artifact actually raises. A single shot 20s after the close cannot tell a
# permanent fault from a redraw that is still in progress -- and the two demand
# opposite conclusions.
#
# So this boots once, presses ESC twice, and then shoots on a timer with no
# further input, reporting the grey share of every frame. A falling series means
# the guide is repainting. A flat series means it is not.
#
# Grey is the discriminator because the ESC menu paints a large light-grey
# background that never appears on a healthy grid. See tools/menuresidue.py.
set -uo pipefail

BIN="${1:?usage: escwatch_esq.sh <binary> <label> [open_wait] [shots] [gap]}"
LABEL="${2:?}"
OPENW="${3:-10}"
SHOTS_N="${4:-12}"
GAP="${5:-10}"

BOOT="${BOOT:-95}"
PREVUE="$HOME/Downloads/Prevue"
SHOTS="${SHOTS:-/tmp/escwatch_$LABEL}"
CONFIG="${FSUAE_CONFIG:-$HOME/Documents/FS-UAE/Configurations/Prevue-HDD.fs-uae}"
PYBIN=/tmp/.capvenv/bin/python

[ -f "$BIN" ] || { echo "no such binary: $BIN"; exit 2; }
osascript -e 'tell application "System Events" to keystroke ""' >/dev/null 2>&1 \
    || { echo "ABORT: no Accessibility grant"; exit 2; }

rm -rf "$SHOTS"; mkdir -p "$SHOTS"
cp -f "$BIN" "$PREVUE/ESQ" && chmod +x "$PREVUE/ESQ"
echo "== escwatch $LABEL: $(basename "$BIN") ($(stat -f%z "$BIN") bytes)"

WID=""
find_window() {
    "$PYBIN" -c 'import Quartz
opts = Quartz.kCGWindowListOptionAll | Quartz.kCGWindowListExcludeDesktopElements
best, area = None, 0
for w in Quartz.CGWindowListCopyWindowInfo(opts, Quartz.kCGNullWindowID):
    if (w.get("kCGWindowOwnerName") or "") == "fs-uae":
        b = w.get("kCGWindowBounds") or {}
        a = b.get("Width", 0) * b.get("Height", 0)
        if a > area:
            best, area = w.get("kCGWindowNumber"), a
if best is not None and area > 200000:
    print(best)'
}
shot() {
    if [ -z "$WID" ]; then
        for _ in $(seq 1 20); do
            WID="$(find_window)"; [ -n "$WID" ] && break; sleep 1
        done
    fi
    [ -n "$WID" ] || { echo "  ERROR: fs-uae window never appeared"; return; }
    screencapture -x -o -l "$WID" "$SHOTS/$1.png" 2>/dev/null
}
esc() { osascript -e 'tell application "System Events" to key code 53' >/dev/null 2>&1; }

pkill -f fs-uae 2>/dev/null; sleep 1
fs-uae "$CONFIG" >/dev/null 2>&1 &
sleep "$BOOT"
osascript -e 'tell application "System Events" to set frontmost of process "fs-uae" to true' >/dev/null 2>&1
sleep 2
shot "00_boot"

esc; sleep "$OPENW"; shot "01_menuopen"
esc                                   # close; from here on, NO further input
for i in $(seq 1 "$SHOTS_N"); do
    sleep "$GAP"
    shot "$(printf 't%03d' $((i * GAP)))"
done

pkill -f fs-uae 2>/dev/null; sleep 2

"$PYBIN" - "$SHOTS" <<'PY'
import sys, glob, os
from PIL import Image
d = sys.argv[1]
bad = 0
shots = sorted(glob.glob(os.path.join(d, '*.png')))
print(f"{'shot':16s} {'grey':>7s} {'yellow':>7s} {'red':>7s}")
for p in shots:
    im = Image.open(p).convert('RGB'); im.thumbnail((480, 480))
    px = list(im.getdata()); n = len(px)
    grey = sum(1 for r, g, b in px
               if 180 < r < 235 and abs(r-g) < 14 and abs(g-b) < 14 and abs(r-b) < 14)/n
    yel = sum(1 for r, g, b in px if r > 150 and g > 130 and b < 100)/n
    red = sum(1 for r, g, b in px if r > 110 and g < 70 and b < 70)/n
    name = os.path.basename(p)[:-4]
    if name.startswith('t') and grey >= 0.05:
        bad += 1
    print(f"{name:16s} {grey:7.4f} {yel:7.4f} {red:7.4f}")
if len(shots) < 3:
    print("\nFAIL: fewer than 3 frames captured -- the capture failed, not the program")
    sys.exit(2)
if bad:
    print(f"\nFAIL: the ESC menu background survives the close in {bad} frame(s).")
    print("Check fixEscMenuExitDisplayMode in src/Prevue.asm.")
    sys.exit(1)
print("\nPASS: no menu background after the close")
PY
rc=$?
echo "shots: $SHOTS/"
exit $rc
