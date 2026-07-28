#!/bin/bash
# Build a C manifest and report whether it takes an F-line trap on the ESC menu.
#
#   tools/btrap_test.sh <label> [exclude.c ...]
#
# Builds src/c/replacements-all.txt MINUS the named C files, links, opens the ESC
# menu, activates item 2, and greps the emulator log.
#
# WHY A LOG ORACLE, AND WHY THIS ONE IS TRUSTWORTHY
#
# guru_detect.py reads pixels because the older fault had no log signature. This
# one does: `B-Trap FFF8 at 002248F6` -- the CPU executing the word FFF8 as an
# instruction. Measured: present in the 305-entry build's log, and ZERO times
# across all six known-good reference logs.
#
# AGENTS.md rightly warns that a log oracle already lied once, when
# `Illegal instruction: 4e7b at 00F80B4C` was counted -- but that is Kickstart's
# own boot instruction and appears 1 or 2 times depending on when the run is
# killed. `B-Trap` is not that: it is absent from clean runs entirely, and the
# address and opcode are stable across trials. Run --verify to re-establish that
# on the current machine before trusting a bisect built on it.
#
# THIS IS A DIFFERENT FAULT FROM THE ONE IN AGENTS.md. The 289-entry build gurus
# with 8100000F and NO B-Trap; the 305-entry build gurus with 8000000B and a
# B-Trap. Do not conflate them -- an 8100000F run is "clean" as far as this tool
# is concerned, which is correct, because this tool exists to find the regression
# introduced on top of it.
#
# Exit 1 = B-Trap (the regression is present), 0 = no B-Trap, 2 = link failed.
# A LINK FAILURE IS NOT A CLEAN RESULT and must not be read as one: it says
# nothing about the fault. Expect it as the manifest grows -- see AGENTS.md on
# Error 28 and the 16-bit branch ceiling.
set -uo pipefail

LABEL="${1:?usage: btrap_test.sh <label> [exclude.c ...]}"
shift
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PREVUE="$HOME/Downloads/Prevue"
CONFIG="${FSUAE_CONFIG:-$HOME/Documents/FS-UAE/Configurations/Prevue-HDD.fs-uae}"
UAELOG="$HOME/Documents/FS-UAE/Cache/Logs/fs-uae.log.txt"
MAN="/tmp/btrap_manifest_$LABEL.txt"
BOOT="${BOOT:-50}"

cd "$ROOT"
# Build the exclusion list as a REAL FILE and VERIFY every name was found.
#
# This validation exists because of a caller bug that produced a silently wrong
# experiment: the harness was invoked from zsh as `btrap_test.sh lbl $LIST`, and
# ZSH DOES NOT WORD-SPLIT UNQUOTED EXPANSIONS -- all 16 names arrived as one
# argument. The old awk filter took `$1` of that, excluded exactly the first
# name, and cheerfully reported a 16-file control that had excluded one file.
# Pass an array (`"${LIST[@]}"`) or one name per argument. Now a name that is
# not in the manifest, or a kept-count that does not match, is a hard error.
EX="/tmp/btrap_exclude_$LABEL.txt"
: > "$EX"
for f in "$@"; do printf '%s\n' "$f" >> "$EX"; done
python3 - "$EX" src/c/replacements-all.txt "$MAN" <<'PYEOF'
import sys
ex = {l.strip() for l in open(sys.argv[1]) if l.strip()}
out, dropped = [], set()
for line in open(sys.argv[2]):
    if not line.strip() or line.startswith('#'):
        continue
    parts = line.split()
    if len(parts) > 1 and parts[1] in ex:
        dropped.add(parts[1]); continue
    out.append(line)
open(sys.argv[3], 'w').writelines(out)
missing = ex - dropped
if missing:
    sys.exit('EXCLUSION NOT FOUND IN MANIFEST: ' + ' '.join(sorted(missing)))
PYEOF
[ $? -eq 0 ] || { echo "   manifest construction failed"; exit 2; }
kept=$(grep -c . "$MAN")
want=$(( $(grep -vc '^#\|^$' src/c/replacements-all.txt) - $# ))
[ "$kept" = "$want" ] || { echo "   MANIFEST WRONG: kept=$kept want=$want"; exit 2; }
echo "== btrap_test $LABEL: $kept entries (excluded: ${*:-none})"

rm -f build/ESQ
if ! SCOPTS="NOSTKCHK DATA=FAR CODE=FAR CODENAME=S_0 DATANAME=S_1 IDLEN=128" \
     C_REPLACEMENTS="$MAN" ./build-split.sh >/tmp/btrap_build_$LABEL.log 2>&1; then
    if ! [ -s build/ESQ ]; then
        echo "   LINK FAILED -- inconclusive, says nothing about the fault"
        grep -m3 "Error" /tmp/btrap_build_$LABEL.log | sed 's/^/     /'
        exit 2
    fi
fi
[ -s build/ESQ ] || { echo "   NO BINARY -- inconclusive"; exit 2; }
echo "   built $(stat -f%z build/ESQ) bytes"

cp -f build/ESQ "$PREVUE/ESQ"; chmod +x "$PREVUE/ESQ"
pkill -f fs-uae 2>/dev/null; sleep 1; rm -f "$UAELOG"
fs-uae "$CONFIG" >/dev/null 2>&1 &
sleep "$BOOT"
osascript -e 'tell application "System Events" to set frontmost of process "fs-uae" to true' >/dev/null 2>&1
sleep 2
osascript -e 'tell application "System Events" to key code 53' >/dev/null 2>&1; sleep 4
osascript -e 'tell application "System Events" to key code 49' >/dev/null 2>&1; sleep 2
osascript -e 'tell application "System Events" to key code 36' >/dev/null 2>&1; sleep 6

# BOTH signals. The log only shows the F-line variant; the SAME underlying fault
# also appears as 8100000F with no log line at all, and a build that swapped one
# for the other would look "fixed" to a B-Trap-only oracle. So capture the screen
# too and report them separately.
SH="/tmp/btrap_shots_$LABEL"; rm -rf "$SH"; mkdir -p "$SH"
b=$(osascript -e 'tell application "System Events" to tell process "fs-uae" to get {position, size} of window 1' 2>/dev/null | tr -d ' ')
r=$(echo "$b" | awk -F, 'NF==4{print $1","$2","$3","$4}')
[ -n "$r" ] && screencapture -x -R "$r" "$SH/s_3_activated.png" 2>/dev/null

pkill -f fs-uae 2>/dev/null; sleep 2
cp "$UAELOG" "/tmp/btrap_$LABEL.log" 2>/dev/null

n=$(grep -c "B-Trap" "/tmp/btrap_$LABEL.log" 2>/dev/null); n=${n:-0}
if /tmp/.capvenv/bin/python "$(dirname "$0")/guru_detect.py" "$SH" s >/dev/null 2>&1; then
    pix=clean
else
    pix=GURU
fi
if [ "$n" -gt 0 ]; then
    echo "   VERDICT: B-TRAP x$n / screen=$pix   $(grep -m1 'B-Trap' /tmp/btrap_$LABEL.log)"
    exit 1
fi
echo "   VERDICT: no B-Trap / screen=$pix"
[ "$pix" = clean ] || exit 3      # gurued by the other code -- NOT a clean build
exit 0
