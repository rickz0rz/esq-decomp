#!/bin/bash
# Drive a build with a REAL LISTINGS LOAD and check the listings arrived.
#
#   tools/listings_esq.sh <binary> <label> [secs]
#
# WHY THIS EXISTS, AND WHY serial_esq.sh WAS NOT ENOUGH
#
# serial_esq.sh sends two frames: 'A' (select) and 'f' (config). It proved the
# stdio and config write path and it NEVER SENT A LISTINGS RECORD. So a build
# could pass it with the whole listings path broken, and one did -- the
# maximum-C build of 2026-08-04 wrote 18 files identical to the control under
# serial_esq.sh while receiving no listings at all.
#
# This harness drives PrevueCommander instead, which sends the real thing: a
# channel line-up pulled from a Channels DVR server, program records, local ads
# and a title. It is the only harness here that exercises the listings path.
#
# THE PERSISTENCE TRAP, WHICH WILL GIVE YOU A FALSE PASS
#
# ESQ SAVES LISTINGS TO THE DRIVE. Once any build has completed a load,
# curday.dat holds the data and EVERY LATER BOOT SHOWS LISTINGS WITHOUT
# RECEIVING ANY -- including a build that cannot receive them at all. Run the
# assembly build once and every maximum-C run after it looks fine.
#
# So this harness RESETS THE LISTINGS STATE BEFORE EVERY RUN, from a baseline
# held outside the drive, and reports curday.dat's size before and after. The
# test is whether the file GREW, not whether listings are on screen.
#
#   baseline curday.dat   ~42 bytes    config header, no channel records
#   a real load           ~20-40 KB    header plus the channel and program data
#
# BASELINE=<file> overrides the empty curday.dat used for the reset. The default
# is tools/fixtures/curday.dat.empty, which is the 42-byte header-only file.
#
# WHAT A PASS LOOKS LIKE
#
#   curday.dat  42 -> 23739 bytes      listings arrived and were stored
#
# WHAT A FAIL LOOKS LIKE
#
#   curday.dat  42 -> 42 bytes         nothing arrived, or nothing parsed
#
# Exits 2 when PrevueCommander never ran, 3 when ESQ never reached its serial
# setup, and 1 when the listings did not arrive. Those are different failures
# and collapsing them sends you after the wrong thing.
set -uo pipefail

BIN="${1:?usage: listings_esq.sh <binary> <label> [secs]}"
LABEL="${2:?usage: listings_esq.sh <binary> <label> [secs]}"
SECS="${3:-200}"

PREVUE="$HOME/Downloads/Prevue"
CONFIG="${CONFIG:-$HOME/Documents/FS-UAE/Configurations/Prevue-HDD.fs-uae}"
UAELOG="$HOME/Documents/FS-UAE/Cache/Logs/fs-uae.log.txt"
REPO="$(cd "$(dirname "$0")/.." && pwd)"
OUT="/tmp/esqlist_$LABEL"
BACKUP="/tmp/esqlist_backup_$$"

COMMANDER="${COMMANDER:-$HOME/Downloads/Git/github.com/rickz0rz/prevuecommander/PrevueCommander/bin/Debug/net9.0/PrevueCommander}"
PLAYBOOK="${PLAYBOOK:-$(dirname "$COMMANDER")/playbook.yaml}"
BASELINE="${BASELINE:-$REPO/tools/fixtures/curday.dat.empty}"

DELAY="${DELAY:-95}"     # seconds to let ESQ boot before the first byte
HOLD="${HOLD:-35}"       # seconds to hold after PrevueCommander finishes

restore () {
    if [ -d "$BACKUP" ]; then
        ( cd "$BACKUP" && find . -type f | while IFS= read -r f; do
              cp -p "$f" "$PREVUE/${f#./}" 2>/dev/null
          done )
        rm -rf "$BACKUP"
    fi
    [ -n "${CMDR_PID:-}" ] && kill "$CMDR_PID" 2>/dev/null
    pkill -f 'fs-uae' 2>/dev/null
    return 0
}
trap restore EXIT

rm -rf "$OUT"; mkdir -p "$OUT/files"

echo "== listings $LABEL: $(basename "$BIN") ($(stat -f%z "$BIN" 2>/dev/null) bytes), ${SECS}s"

[ -x "$COMMANDER" ] || { echo "  ERROR: no PrevueCommander at $COMMANDER"; exit 2; }
[ -f "$PLAYBOOK" ]  || { echo "  ERROR: no playbook at $PLAYBOOK"; exit 2; }
[ -f "$BASELINE" ]  || { echo "  ERROR: no baseline at $BASELINE"; exit 2; }

# Back the drive up from OUTSIDE it, so the restore happens even on a failure.
mkdir -p "$BACKUP"
( cd "$PREVUE" && find . -type f ! -name 'ESQ' ! -name 'ESQ.*' ! -name 'ESQ-*' \
    | while IFS= read -r f; do
         mkdir -p "$BACKUP/$(dirname "$f")"; cp -p "$f" "$BACKUP/$f"
      done )

# THE ANTI-TRAP RESET. Without this the run proves nothing: a previous load's
# data is still on the drive and every build reads it back.
cp "$BASELINE" "$PREVUE/curday.dat"
: > "$PREVUE/nxtday.dat"
BEFORE=$(stat -f%z "$PREVUE/curday.dat")
echo "  listings state reset: curday.dat = $BEFORE bytes"

cp "$BIN" "$PREVUE/ESQ" || { echo "  ERROR: cannot stage the binary"; exit 1; }

# START THE EMULATOR FIRST -- it LISTENS on 127.0.0.1:1234 and PrevueCommander
# connects. Binding the port here would leave the machine with no serial device
# at all, which reads as a program that ignored every frame. And delete the log
# first: FS-UAE buffers it and a stale one reads as this run's output.
pkill -f 'fs-uae' 2>/dev/null; sleep 1
rm -f "$UAELOG"
fs-uae "$CONFIG" >/dev/null 2>&1 &

echo "  booting for ${DELAY}s before sending..."
sleep "$DELAY"

echo "  running PrevueCommander..."
( "$COMMANDER" "$PLAYBOOK" ) > "$OUT/commander.log" 2>&1 &
CMDR_PID=$!
wait "$CMDR_PID" 2>/dev/null
CMDR_RC=$?
CMDR_PID=
echo "  PrevueCommander exited rc=$CMDR_RC"

sleep "$HOLD"

# Grab the screen before shutting down, so a visual check is possible too.
WID=$(/tmp/.capvenv/bin/python - <<'PY' 2>/dev/null
import Quartz
for w in Quartz.CGWindowListCopyWindowInfo(
        Quartz.kCGWindowListOptionOnScreenOnly, Quartz.kCGNullWindowID):
    if 'FS-UAE' in (w.get('kCGWindowOwnerName') or ''):
        print(w['kCGWindowNumber']); break
PY
)
[ -n "$WID" ] && screencapture -x -o -l "$WID" "$OUT/screen.png" 2>/dev/null

# SIGTERM, not SIGKILL: FS-UAE flushes its log only on a clean exit, so the
# serial marker is lost to a kill -9.
pkill -f 'fs-uae' 2>/dev/null
sleep 4
cp "$UAELOG" "$OUT/fs-uae.log" 2>/dev/null

AFTER=$(stat -f%z "$PREVUE/curday.dat" 2>/dev/null || echo 0)
for f in curday.dat nxtday.dat oinfo.dat local.ads config.dat; do
    cp -p "$PREVUE/$f" "$OUT/files/$f" 2>/dev/null
done

echo
echo "  curday.dat  $BEFORE -> $AFTER bytes"
for f in nxtday.dat oinfo.dat local.ads; do
    echo "  $(printf '%-12s' "$f") $(stat -f%z "$PREVUE/$f" 2>/dev/null || echo 0) bytes"
done
echo "  captured in: $OUT"

if ! grep -qi 'sent\|connect\|command' "$OUT/commander.log" 2>/dev/null; then
    echo "  PREVUECOMMANDER PRODUCED NO OUTPUT. This run proves nothing."
    exit 2
fi
if ! grep -q 'baud=2400' "$OUT/fs-uae.log" 2>/dev/null; then
    echo "  ESQ NEVER REACHED ITS SERIAL SETUP. Different failure -- check the boot."
    exit 3
fi

# The test is GROWTH PAST THE BASELINE, not an absolute size. How big a load is
# depends on the playbook -- maximumNumberOfChannels: 5 gives about 1 KB, not
# the 23 KB an earlier full load produced -- so a fixed threshold reports a
# healthy control as a failure. It did exactly that on the first run here.
TITLES=$(strings "$PREVUE/curday.dat" 2>/dev/null | wc -l | tr -d ' ')
echo "  strings in curday.dat: $TITLES"
if [ "$AFTER" -gt "$BEFORE" ]; then
    echo "LISTINGS: PASS  $LABEL  (curday.dat $BEFORE -> $AFTER bytes)"
    exit 0
fi
echo "LISTINGS: FAIL  $LABEL  (curday.dat still $AFTER bytes -- nothing stored)"
exit 1
