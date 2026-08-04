#!/bin/bash
# Drive a build over the RBF SERIAL line, and capture what it writes to disk.
#
#   tools/serial_esq.sh <binary> <label> [secs]
#
# WHY THIS EXISTS
#
# fileio_esq.sh captures the drive side but found nothing, however it was
# driven, and the reason is structural rather than a missing keystroke. ESQ is a
# BROADCAST RECEIVER. Every file write is gated behind a pending flag that only
# the listing data path sets, and that path is fed by the serial line:
#
#     DISKIO2_FlushDataFilesIfNeeded
#         -> if (CTASKS_PrimaryOiWritePendingFlag) COI_WriteOiDataFile(...)
#
#     DISKIO_SaveConfigToFileHandle
#         <- ESQPARS_ConsumeRbfByteAndDispatchCommand   (the 'f' command)
#
# So no key sequence can reach the write path. This sends the bytes that can,
# and it is the only harness that exercises the SAS/C stdio layer at all.
#
# HOW THE LINE IS CARRIED
#
# The fs-uae config already holds `serial_port = tcp://127.0.0.1:1234`, so no
# pty is needed. tools/rbf.py opens that port, waits for ESQ to come up, and
# sends the frames. It tries to LISTEN first and falls back to connecting,
# because which side listens is not documented the same way in every version.
#
# WHAT IT SENDS
#
#   1. 'A' with the box's selection code, which opens the command table
#   2. 'f' with the current config.dat, which calls DISKIO_SaveConfigToFileHandle
#
# The selection code is the argument the emulated drive launches ESQ with, in
# S/uv-startup. Read that file rather than trusting the default; a wrong address
# is silently ignored by the dispatcher and the run then looks like a program
# that wrote nothing.
#
# IT SENDS THE CONFIG BACK VERBATIM, ON PURPOSE. The 'f' command parses the
# record and applies it live before writing, so a mutated record would change
# how the box behaves. Sending the current bytes exercises the whole write path
# and leaves the machine in the state it was already in.
#
# THAT IS WHY THE SNAPSHOT CARRIES THE MODIFICATION TIME AS WELL AS THE HASH. A
# file rewritten with identical content is still a write, and a hash-only
# snapshot reports it as nothing happening. This is not theoretical: config.dat
# comes back BYTE-IDENTICAL, so mtime is the only thing that sees the one write
# that proves the 'f' command ran.
#
# MEASURED, WITH A CONTROL (2026-08-04, ESQ.known-good-36cf56ed):
#
#   selection code   files written
#   GA24005 (right)  18      config.dat, oinfo.dat, qtable.ini, local.ads,
#                            nxtday.dat, dst.dat, curday.dat.*, dbg.log, fonts
#   ZZ99999 (wrong)   0
#
# Same binary, same shutdown, same timing, same link. Only the address differs,
# so the writes belong to the frames and not to the run.
#
# RUN THE WRONG-ADDRESS CONTROL BEFORE BELIEVING ANY RESULT HERE:
#
#   SELECT=ZZ99999 tools/serial_esq.sh <binary> control 190
#
# The first apparently-successful run changed TWO things at once -- the frames
# landed and the shutdown moved from SIGKILL to SIGTERM -- and a clean shutdown
# can flush writes on its own. Without the control that run would have been
# reported as a success on the strength of a confound.
#
# THE DRIVE IS RESTORED FROM A BACKUP HELD OUTSIDE IT, from a trap, so it
# happens even when the run fails.
set -uo pipefail

BIN="${1:?usage: serial_esq.sh <binary> <label> [secs]}"
LABEL="${2:?usage: serial_esq.sh <binary> <label> [secs]}"
SECS="${3:-180}"

PREVUE="$HOME/Downloads/Prevue"
CONFIG="${CONFIG:-$HOME/Documents/FS-UAE/Configurations/Prevue-HDD.fs-uae}"
OUT="/tmp/esqio_$LABEL"
BACKUP="/tmp/esqserial_backup_$$"
UAELOG="$HOME/Documents/FS-UAE/Cache/Logs/fs-uae.log.txt"
REPO="$(cd "$(dirname "$0")/.." && pwd)"

# The address ESQ answers to. Read it from the drive's own launch line rather
# than hardcoding it, so this cannot drift from the machine under test.
SELECT="${SELECT:-$(sed -n 's/^ *esq  *\([A-Za-z0-9]*\).*/\1/p' \
    "$PREVUE/S/uv-startup" 2>/dev/null | head -1)}"
SELECT="${SELECT:-GA24005}"

DELAY="${DELAY:-95}"     # seconds after the link is up before the first byte
HOLD="${HOLD:-30}"       # seconds to hold the line open after the last frame

# Hash AND mtime. A rewrite with identical content is still a write.
snapshot () {
    find "$PREVUE" -type f ! -name '*.uaem' ! -name 'ESQ' ! -name 'ESQ.*' \
        ! -name 'ESQ-*' -exec stat -f '%m %z %N' {} \; 2>/dev/null | sort -k3
}

restore () {
    if [ -d "$BACKUP" ]; then
        ( cd "$BACKUP" && find . -type f | while IFS= read -r f; do
              cp -p "$f" "$PREVUE/${f#./}" 2>/dev/null
          done )
        while IFS= read -r f; do
            [ -n "$f" ] && [ -f "$f" ] && rm -f "$f"
        done < "$OUT/.created" 2>/dev/null
        rm -rf "$BACKUP"
    fi
    [ -n "${RBF_PID:-}" ] && kill "$RBF_PID" 2>/dev/null
    pkill -f 'fs-uae' 2>/dev/null
    return 0
}
trap restore EXIT

rm -rf "$OUT"; mkdir -p "$OUT"
: > "$OUT/.created"

echo "== serial $LABEL: $(basename "$BIN") ($(stat -f%z "$BIN" 2>/dev/null) bytes), ${SECS}s"
echo "  selection code: $SELECT"

mkdir -p "$BACKUP"
( cd "$PREVUE" && find . -type f ! -name '*.uaem' ! -name 'ESQ' ! -name 'ESQ.*' \
    ! -name 'ESQ-*' | while IFS= read -r f; do
         mkdir -p "$BACKUP/$(dirname "$f")"; cp -p "$f" "$BACKUP/$f"
      done )

snapshot > "$OUT/.before"
echo "  drive snapshot: $(wc -l < "$OUT/.before" | tr -d ' ') data file(s)"

cp "$BIN" "$PREVUE/ESQ" || { echo "  ERROR: cannot stage the binary"; exit 1; }

# START THE EMULATOR FIRST. FS-UAE is the side that LISTENS on the serial port,
# so binding it here would stop the emulator opening its own serial device. Its
# log said exactly that:
#
#     TCP: bind() failed, 127.0.0.1:1234: 48      (EADDRINUSE)
#     SERIAL: Could not open device tcp://127.0.0.1:1234
#
# The machine then boots normally with no serial port at all, which reads as a
# program that ignored every frame.
pkill -f 'fs-uae' 2>/dev/null; sleep 1

# Delete the emulator log first, exactly as probe_esq.sh does. FS-UAE buffers it
# and the file sits at 45056 bytes for the whole run, so a leftover log from an
# earlier run reads as this run's output and is full of startup text. That is
# what made a first attempt at this diagnosis report no serial activity.
rm -f "$UAELOG"

fs-uae "$CONFIG" >/dev/null 2>&1 &
UAE=$!

# -u, or python buffers the log and the run shows no progress at all until it
# ends. A harness whose progress is invisible cannot be diagnosed while it runs.
python3 -u "$REPO/tools/rbf.py" --serve --select "$SELECT" \
    --config "$PREVUE/config.dat" --delay "$DELAY" --hold "$HOLD" \
    > "$OUT/rbf.log" 2>&1 &
RBF_PID=$!

sleep "$SECS"

# SIGTERM, not SIGKILL. FS-UAE flushes its log on a clean exit and loses the
# tail on a kill -9, so the serial marker below is only there if it is asked for
# politely.
pkill -f 'fs-uae' 2>/dev/null
wait "$RBF_PID" 2>/dev/null
RBF_PID=
sleep 3
cp "$UAELOG" "$OUT/fs-uae.log" 2>/dev/null

snapshot > "$OUT/.after"
comm -13 "$OUT/.before" "$OUT/.after" | sed 's/^[0-9]*  *[0-9]*  *//' > "$OUT/.changed"
CHANGED=$(wc -l < "$OUT/.changed" | tr -d ' ')

cut -d' ' -f3- "$OUT/.before" > "$OUT/.beforenames"
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

echo "  --- head end ---"
sed 's/^/  /' "$OUT/rbf.log"

# A run that never opened the line proves nothing, and must not read as a pass.
if ! grep -q 'sent select' "$OUT/rbf.log"; then
    echo "  NO FRAME WAS SENT. This run proves nothing about the write path."
    echo "  Check that serial_port is set in $CONFIG."
    exit 2
fi

# Did ESQ reach its own serial setup? This is probe_esq.sh's oracle, and here it
# separates "the program never came up" from "the program rejected the frames".
if grep -q 'baud=2400' "$OUT/fs-uae.log" 2>/dev/null; then
    echo "  ESQ opened the serial port at 2400 baud, so it was up and reading"
else
    echo "  NO baud=2400 MARKER. ESQ never reached its serial setup, so the"
    echo "  frames had nobody to read them. That is a boot result, not a"
    echo "  protocol result -- do not tune the frames until this line changes."
    exit 3
fi

echo "  files created or modified: $CHANGED"
while IFS= read -r f; do
    [ -z "$f" ] && continue
    printf '    %8s  %s\n' "$(stat -f%z "$f" 2>/dev/null)" "${f#"$PREVUE"/}"
done < "$OUT/.changed"
echo "  captured in: $OUT/files"

[ "$CHANGED" -gt 0 ] || { echo "  (nothing written -- the frames went out, so"; \
                          echo "   the dispatcher rejected them or the address"; \
                          echo "   did not match)"; exit 1; }
exit 0
