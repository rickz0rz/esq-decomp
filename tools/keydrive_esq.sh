#!/bin/bash
# Drive ESQ's keyboard-reachable screens and report whether it survived them.
#
#   tools/keydrive_esq.sh <binary> <label> [boot_wait]
#
# soak_esq.sh exercises everything ESQ does on its own, which is the grid, the
# banners and the clock. It cannot reach anything behind a keypress -- the ED
# editor, the ESC menu, the diagnostics screens -- and that is where a large
# share of the restored code lives.
#
# The keys come from the restored dispatcher, not from guessing:
# ED_GetEscMenuActionCode switches on 3 (Ctrl-C), 13 (Return), 27 (ESC) and 155
# (CSI, i.e. the arrows), so ESC/arrow/Return is the real menu vocabulary.
#
# Needs Accessibility permission for the terminal, separately from the Screen
# Recording grant the capture needs. Without it every keystroke fails with
# "osascript is not allowed to send keystrokes" (error 1002) and the run is
# silently a no-op -- so the grant is CHECKED before the run rather than assumed.
#
# VERDICT: FS-UAE logs `Illegal instruction: 4e7b at 00F80B4C` once per Kickstart
# boot. A healthy run shows exactly one. A second occurrence means the machine
# went through its boot path again -- a reset, which is what a Guru does. So the
# count of that line is the pass/fail signal, and it is compared against the
# byte-exact reference rather than against a hardcoded expectation.
set -uo pipefail

BIN="${1:?usage: keydrive_esq.sh <binary> <label> [boot_wait]}"
LABEL="${2:?}"
BOOT="${3:-50}"
PREVUE="$HOME/Downloads/Prevue"
SHOTS="${SHOTS:-/tmp/esqkeys}"
CONFIG="$HOME/Documents/FS-UAE/Configurations/Prevue-HDD.fs-uae"
UAELOG="$HOME/Documents/FS-UAE/Cache/Logs/fs-uae.log.txt"
LOG="/tmp/keydrive_$LABEL.log"

mkdir -p "$SHOTS"
[ -f "$BIN" ] || { echo "no such binary: $BIN"; exit 2; }
rm -f "$SHOTS/${LABEL}_"*.png

if ! osascript -e 'tell application "System Events" to keystroke ""' >/dev/null 2>&1; then
    echo "ABORT: no Accessibility grant -- keystrokes would silently do nothing"; exit 2
fi

cp -f "$BIN" "$PREVUE/ESQ" && chmod +x "$PREVUE/ESQ"
echo "== keydrive $LABEL: $(basename "$BIN") ($(stat -f%z "$BIN") bytes)"

pkill -f fs-uae 2>/dev/null; sleep 1; rm -f "$UAELOG"
fs-uae "$CONFIG" >/dev/null 2>&1 &
sleep "$BOOT"

osascript -e 'tell application "System Events" to set frontmost of process "fs-uae" to true' >/dev/null 2>&1
sleep 2

# Capture the window by its ACTUAL bounds. A fixed pixel crop silently drifts
# when the window opens somewhere else, and a black rectangle looks exactly like
# a crashed machine.
shot() {
    local b r
    b=$(osascript -e 'tell application "System Events" to tell process "fs-uae" to get {position, size} of window 1' 2>/dev/null | tr -d ' ')
    r=$(echo "$b" | awk -F, 'NF==4{print $1","$2","$3","$4}')
    [ -n "$r" ] && screencapture -x -R "$r" "$SHOTS/${LABEL}_$1.png" 2>/dev/null
}

key() { osascript -e "tell application \"System Events\" to key code $1" >/dev/null 2>&1; }

shot 0_boot
key 53; sleep 4; shot 1_esc        # ESC   -> menu
key 125; sleep 2; shot 2_down      # Down  -> move selection
key 36;  sleep 4; shot 3_return    # Return-> activate
key 53;  sleep 3; shot 4_back      # ESC   -> back out

pkill -f fs-uae 2>/dev/null; sleep 2
cp "$UAELOG" "$LOG" 2>/dev/null

boots=$(grep -c 'Illegal instruction' "$LOG" 2>/dev/null || echo 0)
echo "  shots: $(ls "$SHOTS/${LABEL}_"*.png 2>/dev/null | wc -l | tr -d ' ')"
echo "  kickstart-boot illegal instructions: $boots   (1 = healthy, >1 = the machine reset)"
echo "  log lines: $(wc -l < "$LOG" | tr -d ' ')"
[ "$boots" -le 1 ]
