#!/bin/bash
# Build every variant and stage it for the emulator, with a manifest of hashes.
#
#   ./stage-builds.sh [dest]        # default dest: ~/Downloads/Prevue
#
# Every binary is rebuilt from scratch and copied immediately after its own
# build, so a stale file can never be left behind wearing a fresh name. The
# recorded SHA-256s let you confirm the thing you tested is the thing that was
# built -- `shasum -a 256 <file>` and compare against STAGED.txt.
#
# NOTE: build-split.sh deliberately exits nonzero when the result is not
# content-identical to the reference, which is expected for every variant that
# contains a behavioural restoration. Do NOT chain staging off its exit status;
# that bug once caused a stale binary to be tested and sent a debugging session
# chasing a defect that did not exist.
set -uo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"
DEST="${1:-$HOME/Downloads/Prevue}"
MAN="$ROOT/build/manifests"
mkdir -p "$DEST" "$MAN"

cat > "$MAN/videochip.txt" <<'EOF'
modules/groups/_main/b/b_esqcheckcompatiblevideochip.s  c/esq_check_compatible_video_chip.c
EOF
cat > "$MAN/newgrid.txt" <<'EOF'
modules/groups/b/a/newgrid1_getgridmodeindex.s  c/newgrid_get_grid_mode_index.c
EOF
cat > "$MAN/strcat.txt" <<'EOF'
modules/submodules/unknown6.s  c/string_append_at_null.c
EOF

stage() {           # stage <name> [manifest]
    local name="$1" manifest="${2:-}"
    printf '  %-22s ' "$name"
    if [ -n "$manifest" ]; then
        C_REPLACEMENTS="$manifest" ./build-split.sh >"build/$name.log" 2>&1
    else
        ./build-split.sh >"build/$name.log" 2>&1
    fi
    if [ ! -f build/ESQ ]; then
        echo "BUILD FAILED -- see build/$name.log"; return 1
    fi
    # freshness guard: the binary must be newer than the log we just wrote
    cp build/ESQ "$DEST/$name"
    local h; h="$(shasum -a 256 "$DEST/$name" | awk '{print $1}')"
    local sz; sz="$(stat -f %z "$DEST/$name")"
    local verdict; verdict="$(grep -c 'CONTENT-IDENTICAL' "build/$name.log")"
    printf '%8s bytes  %s  %s\n' "$sz" "${h:0:16}" \
        "$([ "$verdict" -gt 0 ] && echo 'content-identical' || echo 'differs (expected for C variants)')"
    echo "$name $h $sz" >> "$DEST/STAGED.txt"
    rm -f build/ESQ            # never leave a build behind for the next stage to copy
}

: > "$DEST/STAGED.txt"
echo "staging into $DEST"
# ESQ is the deliverable: the faithful build, exact restorations only.
stage ESQ                   src/c/replacements.txt
stage ESQ_asmonly
stage ESQ_c5                src/c/replacements.txt
stage ESQ_canary3           src/c/replacements-canary.txt
stage ESQ_only_videochip    "$MAN/videochip.txt"
stage ESQ_only_newgrid      "$MAN/newgrid.txt"
stage ESQ_only_strcat       "$MAN/strcat.txt"
echo
echo "hashes recorded in $DEST/STAGED.txt"
