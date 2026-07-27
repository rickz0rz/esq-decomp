#!/bin/bash
# Drive ESQ's keyboard-reachable screens and report whether it survived them.
#
#   tools/keydrive_esq.sh <binary> <label> [boot_wait]      TRIALS=n to override
#
# soak_esq.sh exercises everything ESQ does on its own -- the grid, the banners,
# the clock. It cannot reach anything behind a keypress: the ED editor, the ESC
# menu, the diagnostics screens. That is where a large share of restored code
# lives, and it is where the maximum-C build turned out to be broken.
#
# The keys come from the restored dispatcher, not from guessing:
# ED_GetEscMenuActionCode switches on 3 (Ctrl-C), 13 (Return), 27 (ESC) and 155
# (CSI, i.e. the arrows), so ESC / arrow / Return is the menu's real vocabulary.
#
# Needs Accessibility permission for the terminal, separately from the Screen
# Recording grant the capture needs. Without it every keystroke fails with
# "osascript is not allowed to send keystrokes" (error 1002) and the run is
# silently a no-op -- so the grant is CHECKED rather than assumed.
#
# VERDICT: look at the SCREEN, and use TWO features.
#
#   Counting `Illegal instruction: 4e7b at 00F80B4C` in the FS-UAE log does NOT
#   work. That is Kickstart's own boot instruction and whether it appears once or
#   twice depends on where the run is when it is killed; the same binary gave 1
#   then 2 back to back.
#
#   Red alone does NOT work either. ESQ's TV logo is dark red and pushed a
#   perfectly healthy guide screen to 0.0036, over a red-only threshold of 0.003,
#   which produced a false "this build gurus" result.
#
#   A Guru is red text on an otherwise BLACK screen, and the pair separates
#   cleanly with room to spare:
#
#     guru     red 0.0094-0.031   black 0.956-0.979
#     healthy  red <=0.0036       black 0.44-0.64
#
# TRIALS matters as much as the detector, because THIS FAULT IS INTERMITTENT:
# the same 147-entry binary came up clean on one run and gurued on the next. A
# single trial is evidence of a guru but never evidence of its absence. So a
# guru on ANY trial condemns the build and only an all-clean sweep acquits it.
set -uo pipefail

BIN="${1:?usage: keydrive_esq.sh <binary> <label> [boot_wait]}"
LABEL="${2:?}"
BOOT="${3:-50}"
TRIALS="${TRIALS:-3}"
PREVUE="$HOME/Downloads/Prevue"
SHOTS="${SHOTS:-/tmp/esqkeys}"
CONFIG="$HOME/Documents/FS-UAE/Configurations/Prevue-HDD.fs-uae"
UAELOG="$HOME/Documents/FS-UAE/Cache/Logs/fs-uae.log.txt"
LOG="/tmp/keydrive_$LABEL.log"
PYBIN=/tmp/.capvenv/bin/python
DETECT="$(dirname "$0")/guru_detect.py"

mkdir -p "$SHOTS"
[ -f "$BIN" ] || { echo "no such binary: $BIN"; exit 2; }
[ -x "$PYBIN" ] || { echo "NO DETECTOR: need pillow in /tmp/.capvenv"; exit 2; }

if ! osascript -e 'tell application "System Events" to keystroke ""' >/dev/null 2>&1; then
    echo "ABORT: no Accessibility grant -- keystrokes would silently do nothing"; exit 2
fi

cp -f "$BIN" "$PREVUE/ESQ" && chmod +x "$PREVUE/ESQ"
echo "== keydrive $LABEL: $(basename "$BIN") ($(stat -f%z "$BIN") bytes), up to $TRIALS trial(s)"

# Capture by the window's ACTUAL bounds. A fixed pixel crop silently drifts when
# the window opens somewhere else, and a black rectangle looks exactly like a
# crashed machine.
shot() {   # $1 = step name, $2 = trial
    local b r
    b=$(osascript -e 'tell application "System Events" to tell process "fs-uae" to get {position, size} of window 1' 2>/dev/null | tr -d ' ')
    r=$(echo "$b" | awk -F, 'NF==4{print $1","$2","$3","$4}')
    [ -n "$r" ] && screencapture -x -R "$r" "$SHOTS/${LABEL}t$2_$1.png" 2>/dev/null
}

key() { osascript -e "tell application \"System Events\" to key code $1" >/dev/null 2>&1; }

trial() {   # $1 = trial number; 0 = clean, 1 = guru
    rm -f "$SHOTS/${LABEL}t$1_"*.png
    pkill -f fs-uae 2>/dev/null; sleep 1; rm -f "$UAELOG"
    fs-uae "$CONFIG" >/dev/null 2>&1 &
    sleep "$BOOT"
    osascript -e 'tell application "System Events" to set frontmost of process "fs-uae" to true' >/dev/null 2>&1
    sleep 2

    shot 0_boot   "$1"
    key 53;  sleep 4; shot 1_esc    "$1"    # ESC    -> open the menu
    key 125; sleep 2; shot 2_down   "$1"    # Down   -> move the selection
    key 36;  sleep 4; shot 3_return "$1"    # Return -> activate it
    key 53;  sleep 3; shot 4_back   "$1"    # ESC    -> back out

    pkill -f fs-uae 2>/dev/null; sleep 2
    cp "$UAELOG" "$LOG" 2>/dev/null
    "$PYBIN" "$DETECT" "$SHOTS" "${LABEL}t$1"
}

for t in $(seq 1 "$TRIALS"); do
    if ! trial "$t"; then
        echo "  GURU on trial $t of $TRIALS"
        exit 1
    fi
    echo "  trial $t: clean"
done
echo "  clean on all $TRIALS trials"
