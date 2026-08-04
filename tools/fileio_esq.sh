#!/bin/bash
# Capture everything a build writes to the emulated drive, then put the drive
# back exactly as it was.
#
#   tools/fileio_esq.sh <binary> <label> [secs] [key:wait ...]
#
# WHY THIS EXISTS
#
# soak_esq.sh, keyprobe_esq.sh and menusweep_esq.sh all judge a build by what is
# ON SCREEN. Nothing judged what it wrote to DISK, and a plain 90-second soak
# turns out to touch NO FILE AT ALL -- measured, not assumed. So the whole
# SAS/C stdio layer (STREAM_BufferedPutcOrFlush, STREAM_BufferedGetc,
# STREAM_BufferedWriteString) had no coverage of any kind, which is exactly the
# gap that makes restoring it risky: a byte comparison checks a function's own
# bytes, and every screen harness is blind to a corrupted file.
#
# This captures the drive side. Run it on two builds and compare with
# tools/fileiodiff.py.
#
# WHAT IT DOES
#
#   1. hashes every data file on the emulated drive
#   2. copies them to a backup OUTSIDE the drive, so the emulator cannot see it
#   3. boots the binary for `secs`
#   4. hashes again, and copies every created or modified file to the output
#   5. RESTORES the drive from the backup, always, even if the run fails
#
# The drive is `hard_drive_1` in the fs-uae config -- a HOST DIRECTORY, so a
# file ESQ writes appears directly under $PREVUE. That is what makes this
# possible without pulling apart a disk image.
#
# ESQ's own binaries are excluded from the snapshot: the harnesses copy the
# candidate over $PREVUE/ESQ, so it always "changes" and would drown the diff.
#
# A KEY SEQUENCE IS USUALLY REQUIRED, and that is the whole point. ESQ writes
# nothing on its own, so the write path has to be reached through the editor and
# the menu. Pass the same `key:wait` pairs keyprobe_esq.sh takes:
#
#   BOOT=95 tools/fileio_esq.sh build/ESQ cand 150 53:5 19:3 36:6 36:4 53:6 53:10
#
# Sending keys needs the Accessibility grant, exactly as keyprobe does, and the
# script checks for it rather than failing silently.
#
# SET BOOT=95, OR THE KEYS ARRIVE BEFORE ESQ IS UP. This is the first thing to
# suspect when a capture comes back empty. A key sent to the boot loader goes
# nowhere, the run completes, and the result reads exactly like a program that
# wrote nothing. keyprobe_esq.sh needs the same value for the same reason.
#
# WHERE ESQ'S WRITES GO: THE SAME DIRECTORY THIS WATCHES.
#
# ESQ's data paths all start `df0:` -- "df0:config.dat", "df0:err.log",
# "DF0:LocAvail.dat". That is NOT the floppy drive. The emulated drive's own
# S/Startup-Sequence reassigns it before ESQ starts:
#
#     assign df0: dismount
#     assign df0: dh1:
#
# `dh1:` is hard_drive_1 in the fs-uae config, which is $HOME/Downloads/Prevue.
# So `df0:config.dat` resolves into the directory snapshotted here, and the
# BLANK.ADF floppy only exists to let the boot finish.
#
# THAT ASSIGN IS NOT IN THIS REPOSITORY. It lives in the emulated drive's
# startup script, so grepping src/ for `dh2:` finds no data paths at all and the
# floppy reading looks right. An earlier version of this header drew exactly that
# wrong conclusion. Read the drive's S/Startup-Sequence before deciding where a
# path resolves.
#
# WHY IT STILL CAPTURES NOTHING: NO SERIAL FEED.
#
# Measured 2026-08-04 on ESQ.known-good-36cf56ed, 150 seconds, six menu keys at
# BOOT=95: no file on the drive changed at all. That was confirmed WITHOUT this
# harness, by mtime, including the .uaem metadata the snapshot excludes and the
# restore never touches.
#
# Every data write is gated behind a pending flag that the LISTING DATA path
# sets. DISKIO2_FlushDataFilesIfNeeded writes only when
# CTASKS_PrimaryOiWritePendingFlag or its secondary is set; those are set by
# CLEANUP_ParseAlignedListingBlock and DISKIO2_LoadCurDayDataFile; and
# DISKIO_SaveConfigToFileHandle is called from
# ESQPARS_ConsumeRbfByteAndDispatchCommand, the RBF SERIAL command interpreter.
#
# ESQ is a broadcast receiver. With no head end feeding it listings nothing is
# ever marked dirty, so nothing is written, and NO keyboard sequence can reach
# the write path. Coverage needs the serial port driven with RBF commands
# (`serial_port` in the fs-uae config; ESQ opens it at baud 2400). That is a new
# harness, not a longer key sequence.
set -uo pipefail

BIN="${1:?usage: fileio_esq.sh <binary> <label> [secs]}"
LABEL="${2:?usage: fileio_esq.sh <binary> <label> [secs]}"
SECS="${3:-90}"
shift 3 2>/dev/null || shift $#
KEYS=("$@")

PREVUE="$HOME/Downloads/Prevue"
CONFIG="${CONFIG:-$HOME/Documents/FS-UAE/Configurations/Prevue-HDD.fs-uae}"
OUT="/tmp/esqio_$LABEL"
BACKUP="/tmp/esqio_backup_$$"

# Data files only. ESQ* is the binary under test and its siblings; .uaem files
# are the emulator's own metadata and change on every access.
snapshot () {
    find "$PREVUE" -type f ! -name '*.uaem' ! -name 'ESQ' ! -name 'ESQ.*' \
        ! -name 'ESQ-*' -exec shasum {} \; 2>/dev/null | sort -k2
}

restore () {
    if [ -d "$BACKUP" ]; then
        # Copy back, then remove anything the run CREATED that was not there
        # before. Nothing is deleted that the user had.
        ( cd "$BACKUP" && find . -type f -exec cp -p {} "$PREVUE"/{} \; ) 2>/dev/null
        while IFS= read -r f; do
            [ -n "$f" ] && [ -f "$f" ] && rm -f "$f"
        done < "$OUT/.created" 2>/dev/null
        rm -rf "$BACKUP"
    fi
}
trap restore EXIT

rm -rf "$OUT"; mkdir -p "$OUT"
: > "$OUT/.created"

echo "== fileio $LABEL: $(basename "$BIN") ($(stat -f%z "$BIN" 2>/dev/null) bytes), ${SECS}s"

mkdir -p "$BACKUP"
( cd "$PREVUE" && find . -type f ! -name '*.uaem' ! -name 'ESQ' ! -name 'ESQ.*' \
    ! -name 'ESQ-*' -exec cp -p --parents {} "$BACKUP"/ \; ) 2>/dev/null \
  || ( cd "$PREVUE" && find . -type f ! -name '*.uaem' ! -name 'ESQ' ! -name 'ESQ.*' \
        ! -name 'ESQ-*' | while IFS= read -r f; do
             mkdir -p "$BACKUP/$(dirname "$f")"; cp -p "$f" "$BACKUP/$f"
           done )

snapshot > "$OUT/.before"
BEFORE_N=$(wc -l < "$OUT/.before" | tr -d ' ')
echo "  drive snapshot: $BEFORE_N data file(s)"

cp "$BIN" "$PREVUE/ESQ" || { echo "  ERROR: cannot stage the binary"; exit 1; }

if [ ${#KEYS[@]} -gt 0 ]; then
    osascript -e 'tell application "System Events" to keystroke ""' >/dev/null 2>&1 \
        || { echo "  ABORT: no Accessibility grant, so no key would reach the"; \
             echo "         emulator and the run would prove nothing"; exit 2; }
fi

pkill -f 'fs-uae' 2>/dev/null; sleep 1
fs-uae "$CONFIG" >/dev/null 2>&1 &
UAE=$!

# 95, not 50: a key sent before ESQ is up reaches the boot loader and is lost,
# and the run then reads as a program that wrote nothing. See the header.
BOOT="${BOOT:-95}"
if [ ${#KEYS[@]} -gt 0 ]; then
    sleep "$BOOT"
    osascript -e 'tell application "System Events" to set frontmost of process "fs-uae" to true' >/dev/null 2>&1
    sleep 1
    for kw in "${KEYS[@]}"; do
        code="${kw%%:*}"; wait="${kw##*:}"
        osascript -e "tell application \"System Events\" to key code $code" >/dev/null 2>&1
        echo "    key $code"
        sleep "$wait"
    done
    REMAIN=$(( SECS - BOOT ))
    [ "$REMAIN" -gt 0 ] && sleep "$REMAIN"
else
    sleep "$SECS"
fi

kill -9 $UAE 2>/dev/null; pkill -f 'fs-uae' 2>/dev/null
sleep 2

snapshot > "$OUT/.after"

# A line present in .after but not .before is created-or-modified.
comm -13 "$OUT/.before" "$OUT/.after" | sed 's/^[0-9a-f]*  *//' > "$OUT/.changed"
CHANGED=$(wc -l < "$OUT/.changed" | tr -d ' ')

# Which of those did not exist at all before?
cut -d' ' -f3- "$OUT/.before" 2>/dev/null | sed 's/^ *//' > "$OUT/.beforenames"
while IFS= read -r f; do
    [ -z "$f" ] && continue
    grep -qxF "$f" "$OUT/.beforenames" || echo "$f" >> "$OUT/.created"
done < "$OUT/.changed"

mkdir -p "$OUT/files"
while IFS= read -r f; do
    [ -z "$f" ] && continue
    rel="${f#"$PREVUE"/}"
    mkdir -p "$OUT/files/$(dirname "$rel")"
    cp -p "$f" "$OUT/files/$rel" 2>/dev/null
done < "$OUT/.changed"

echo "  files created or modified: $CHANGED"
if [ "$CHANGED" -gt 0 ]; then
    while IFS= read -r f; do
        [ -z "$f" ] && continue
        printf '    %8s  %s\n' "$(stat -f%z "$f" 2>/dev/null)" "${f#"$PREVUE"/}"
    done < "$OUT/.changed"
else
    echo "    (none -- this build wrote nothing to the drive)"
fi
echo "  captured in: $OUT/files"
exit 0
