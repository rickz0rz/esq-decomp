#!/bin/bash
set -euo pipefail

if [ "$#" -ne 3 ]; then
    echo "usage: $0 <root-asm> <replacement-map> <output-asm>" >&2
    exit 1
fi

ROOT_ASM="$1"
REPLACEMENT_MAP="$2"
OUTPUT_ASM="$3"

if [ ! -f "$ROOT_ASM" ]; then
    echo "error: root asm not found: $ROOT_ASM" >&2
    exit 1
fi

if [ ! -f "$REPLACEMENT_MAP" ]; then
    echo "error: replacement map not found: $REPLACEMENT_MAP" >&2
    exit 1
fi

mkdir -p "$(dirname "$OUTPUT_ASM")"

awk '
FNR == NR {
    line = $0
    sub(/[[:space:]]*;.*/, "", line)
    if (line ~ /^[[:space:]]*$/ || line ~ /^[[:space:]]*#/) {
        next
    }
    split(line, f, /[[:space:]]+/)
    if (length(f[1]) && length(f[2])) {
        repl[f[1]] = f[2]
    }
    next
}
{
    if ($0 ~ /^[[:space:]]*include[[:space:]]+"/) {
        old = $0
        sub(/^[[:space:]]*include[[:space:]]+"/, "", old)
        sub(/".*$/, "", old)
        if (old in repl) {
            prefix = $0
            sub(/include[[:space:]]+".*$/, "", prefix)
            print prefix "include \"" repl[old] "\"    ; decomp replacement for " old
            next
        }
    }
    print $0
}
' "$REPLACEMENT_MAP" "$ROOT_ASM" > "$OUTPUT_ASM"

echo "generated $OUTPUT_ASM"
