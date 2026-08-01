#!/bin/bash
# Boot ESQ once and send an ARBITRARY key sequence, shooting after each key.
#
#   tools/keyprobe_esq.sh <binary> <label> <key:wait> [<key:wait> ...]
#
#   tools/keyprobe_esq.sh ~/Downloads/Prevue/ESQ probe 53:4 125:2 125:2 36:4
#     ^ ESC, Down, Down, Return         (macOS key codes, seconds to wait)
#
# WHY THIS EXISTS
#
# keydrive_esq.sh sends ONE fixed sequence (ESC / Down / Return / ESC). That was
# enough to find the ESC-menu guru but not to characterise it, and reading its
# screenshots showed something the fixed sequence hid: THE DOWN ARROW DOES
# NOTHING. The `2_down` capture is identical to the menu as first opened, with
# "Edit Ads" still highlighted, so every "menu activation" trial ever run has
# activated menu item 1 and only item 1.
#
# The likely cause is the emulator, not the program: Prevue-HDD.fs-uae declares a
# joystick port, and FS-UAE can consume the cursor keys as emulated joystick
# input before the Amiga keyboard ever sees them. Hence FSUAE_CONFIG here, so a
# diagnostic run can use a machine with that turned off without editing the
# user's own configuration.
#
# Whatever the cause, five of the six ESC-menu items -- Edit Attributes, Change
# Scroll Speed, Diagnostic Mode, Special Functions, Versions Screen -- have never
# been reached by any harness, and a large share of the restored ED_* code lives
# behind them.
#
# This does NOT judge the result: it captures and reports scores, and leaves the
# verdict to guru_detect.py or to `Read`ing the PNGs. Use it to work out what a
# key sequence actually does, then encode the useful sequence in a real harness.
set -uo pipefail

BIN="${1:?usage: keyprobe_esq.sh <binary> <label> <key:wait>...}"
LABEL="${2:?}"
shift 2
[ $# -gt 0 ] || { echo "give at least one <keycode>:<wait>"; exit 2; }

BOOT="${BOOT:-50}"
PREVUE="$HOME/Downloads/Prevue"
SHOTS="${SHOTS:-/tmp/esqprobe_$LABEL}"
CONFIG="${FSUAE_CONFIG:-$HOME/Documents/FS-UAE/Configurations/Prevue-HDD.fs-uae}"
UAELOG="$HOME/Documents/FS-UAE/Cache/Logs/fs-uae.log.txt"
PYBIN=/tmp/.capvenv/bin/python
DETECT="$(dirname "$0")/guru_detect.py"

[ -f "$BIN" ] || { echo "no such binary: $BIN"; exit 2; }
osascript -e 'tell application "System Events" to keystroke ""' >/dev/null 2>&1 \
    || { echo "ABORT: no Accessibility grant"; exit 2; }

rm -rf "$SHOTS"; mkdir -p "$SHOTS"
cp -f "$BIN" "$PREVUE/ESQ" && chmod +x "$PREVUE/ESQ"
echo "== keyprobe $LABEL: $(basename "$BIN") ($(stat -f%z "$BIN") bytes)"
echo "   config: $(basename "$CONFIG")   keys: $*"

# Capture BY WINDOW ID, not by rectangle. A rectangle cropped out of a
# full-screen grab scored the wrong pixels three times in one day (see the
# soak_esq.sh header) and captures NOTHING when fs-uae sits on another macOS
# Space. soak_esq.sh was fixed for this on 2026-07-30; keyprobe was not, and
# silently produced ZERO shots ever since -- an empty report that reads as
# "the key changed nothing" rather than "the capture failed". That made the
# ESC-menu regression test this file exists for a no-op.
WID=""
find_window() {
    # Pick the LARGEST fs-uae window, not the first one wider than 100.
    # fs-uae registers a 1000x1000 all-black helper window that passes a
    # width filter and captures as solid black -- which reads as "the screen
    # never changed" rather than "the wrong window was grabbed".
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
    [ -n "$WID" ] || { echo "  ERROR: fs-uae window never appeared -- nothing captured"; return; }
    screencapture -x -o -l "$WID" "$SHOTS/$1.png" 2>/dev/null
}

pkill -f fs-uae 2>/dev/null; sleep 1; rm -f "$UAELOG"
fs-uae "$CONFIG" >/dev/null 2>&1 &
sleep "$BOOT"
osascript -e 'tell application "System Events" to set frontmost of process "fs-uae" to true' >/dev/null 2>&1
sleep 2
shot "00_boot"

i=0
for spec in "$@"; do
    i=$((i+1))
    code="${spec%%:*}"; wait="${spec##*:}"
    osascript -e "tell application \"System Events\" to key code $code" >/dev/null 2>&1
    sleep "$wait"
    shot "$(printf '%02d_key%s' "$i" "$code")"
done

pkill -f fs-uae 2>/dev/null; sleep 2
cp "$UAELOG" "/tmp/keyprobe_$LABEL.log" 2>/dev/null

# Report per-shot scores so an unchanged screen is visible as an unchanged score,
# and flag any shot the guru detector would condemn.
"$PYBIN" - "$SHOTS" <<'PY'
import sys, glob, os, hashlib
from PIL import Image
d = sys.argv[1]
print(f"{'shot':22s} {'red':>7s} {'black':>7s} {'sha(px)':>10s}  verdict")
for p in sorted(glob.glob(os.path.join(d, '*.png'))):
    im = Image.open(p).convert('RGB'); im.thumbnail((400, 400))
    raw = im.tobytes()
    px = [(raw[i], raw[i+1], raw[i+2]) for i in range(0, len(raw), 3)]
    n = len(px)
    red = sum(1 for r, g, b in px if r > 110 and g < 70 and b < 70)/n
    blk = sum(1 for r, g, b in px if r < 40 and g < 40 and b < 40)/n
    v = 'GURU' if (red > 0.005 and blk > 0.90) else ''
    print(f"{os.path.basename(p):22s} {red:7.4f} {blk:7.4f} {hashlib.sha1(raw).hexdigest()[:10]:>10s}  {v}")
print("\nidentical sha(px) between consecutive shots = the key changed NOTHING")
PY
echo "shots: $SHOTS/"
