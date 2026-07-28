#!/bin/bash
# Activate EVERY item on ESQ's ESC menu, one boot per item, and report verdicts.
#
#   tools/menusweep_esq.sh <binary> <label> [items] [reps]
#
# WHY THIS EXISTS, and why the old harness could not do it
#
# keydrive_esq.sh sends ESC / Down / Return. Reading its captures showed the DOWN
# ARROW DOES NOTHING -- FS-UAE consumes the cursor keys as emulated joystick
# input before the Amiga keyboard sees them, so the selection never moved and
# every trial ever run activated menu item 1 (Edit Ads) and only item 1.
#
# The menu's own instructions say "Push any key to select", and that is literal:
# an ORDINARY key advances the selection by one. Measured on the byte-exact
# reference -- ESC then Tab/space/'n' left "Diagnostic Mode" (item 4) highlighted.
# So item k is reached with k-1 ordinary keys, and no arrow keys are involved.
#
# That matters because the five unreached items are where the restored ED_* code
# lives: Edit Attributes, Change Scroll Speed, Diagnostic Mode, Special Functions,
# Versions Screen. ED_HandleSpecialFunctionsMenu, ED2_HandleDiagnosticsMenuActions
# and ED_HandleEditAttributesMenu are all in the maximum-C manifest and all sat
# behind a keypress no harness ever delivered.
#
# One boot per item, because activating an item navigates into a sub-screen where
# the key vocabulary changes and ESC returns to the guide rather than the menu.
# Sharing a boot across items would silently drift out of sync.
#
# A GURU ON ANY REP CONDEMNS THAT ITEM; clean is only ever provisional, because
# this fault is intermittent. Use `reps` > 1 for a real acquittal and see
# gururate_esq.sh for how many reps that actually takes.
set -uo pipefail

BIN="${1:?usage: menusweep_esq.sh <binary> <label> [items] [reps]}"
LABEL="${2:?}"
ITEMS="${3:-1 2 3 4 5 6}"
REPS="${4:-1}"
BOOT="${BOOT:-50}"
PREVUE="$HOME/Downloads/Prevue"
CONFIG="${FSUAE_CONFIG:-$HOME/Documents/FS-UAE/Configurations/Prevue-HDD.fs-uae}"
UAELOG="$HOME/Documents/FS-UAE/Cache/Logs/fs-uae.log.txt"
PYBIN=/tmp/.capvenv/bin/python
DETECT="$(dirname "$0")/guru_detect.py"

NAMES=(- "EditAds" "EditAttributes" "ChangeScrollSpeed" "DiagnosticMode" "SpecialFunctions" "VersionsScreen")
KEY_ORDINARY=49      # space -- any ordinary key advances the selection
KEY_ESC=53
KEY_RETURN=36

[ -f "$BIN" ] || { echo "no such binary: $BIN"; exit 2; }
osascript -e 'tell application "System Events" to keystroke ""' >/dev/null 2>&1 \
    || { echo "ABORT: no Accessibility grant"; exit 2; }

echo "== menusweep $LABEL: $(basename "$BIN") ($(stat -f%z "$BIN") bytes), reps=$REPS"

shot() {
    local b r
    b=$(osascript -e 'tell application "System Events" to tell process "fs-uae" to get {position, size} of window 1' 2>/dev/null | tr -d ' ')
    r=$(echo "$b" | awk -F, 'NF==4{print $1","$2","$3","$4}')
    [ -n "$r" ] && screencapture -x -R "$r" "$1" 2>/dev/null
}
key() { osascript -e "tell application \"System Events\" to key code $1" >/dev/null 2>&1; }

gurus=""; cleans=""
for item in $ITEMS; do
  for rep in $(seq 1 "$REPS"); do
    d="/tmp/esqmenu_$LABEL/${item}_${NAMES[$item]}_r$rep"
    rm -rf "$d"; mkdir -p "$d"
    cp -f "$BIN" "$PREVUE/ESQ" && chmod +x "$PREVUE/ESQ"

    pkill -f fs-uae 2>/dev/null; sleep 1; rm -f "$UAELOG"
    fs-uae "$CONFIG" >/dev/null 2>&1 &
    sleep "$BOOT"
    osascript -e 'tell application "System Events" to set frontmost of process "fs-uae" to true' >/dev/null 2>&1
    sleep 2
    # guru_detect globs "<label>_[0-9]*.png", so the shots need that shape.
    shot "$d/s_0_boot.png"

    key $KEY_ESC; sleep 4; shot "$d/s_1_menu.png"
    n=$((item-1))
    while [ "$n" -gt 0 ]; do key $KEY_ORDINARY; sleep 1; n=$((n-1)); done
    shot "$d/s_2_selected.png"
    key $KEY_RETURN; sleep 6; shot "$d/s_3_activated.png"
    key $KEY_ESC;    sleep 3; shot "$d/s_4_back.png"

    pkill -f fs-uae 2>/dev/null; sleep 2
    cp "$UAELOG" "$d/fs-uae.log" 2>/dev/null

    if "$PYBIN" "$DETECT" "$d" s >/dev/null 2>&1; then
        v=clean; cleans="$cleans ${item}:${NAMES[$item]}"
    else
        v=GURU;  gurus="$gurus ${item}:${NAMES[$item]}"
    fi
    printf '  item %s %-18s rep %s: %s\n' "$item" "${NAMES[$item]}" "$rep" "$v"
  done
done

echo
echo "== $LABEL gurus:$([ -n "$gurus" ] && echo "$gurus" || echo ' none')"
echo "   shots: /tmp/esqmenu_$LABEL/"
