#!/bin/bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
    echo "usage: $0 <module-include-path>" >&2
    echo "example: $0 modules/groups/a/a/bitmap.s" >&2
    exit 1
fi

MODULE_PATH="$1"
SRC_FILE="src/${MODULE_PATH}"
REPL_FILE="src/decomp/replacements/${MODULE_PATH}"
MAP_FILE="src/decomp/replacements.map"
MAP_ENTRY="${MODULE_PATH} decomp/replacements/${MODULE_PATH}"

if [ ! -f "$SRC_FILE" ]; then
    echo "error: source module not found: $SRC_FILE" >&2
    exit 1
fi

mkdir -p "$(dirname "$REPL_FILE")"

if [ ! -f "$REPL_FILE" ]; then
    cp "$SRC_FILE" "$REPL_FILE"
    echo "created replacement copy: $REPL_FILE"
else
    echo "replacement already exists: $REPL_FILE"
fi

if ! rg -q "^${MODULE_PATH}[[:space:]]+decomp/replacements/${MODULE_PATH}$" "$MAP_FILE"; then
    echo "$MAP_ENTRY" >> "$MAP_FILE"
    echo "registered replacement map entry"
else
    echo "replacement map entry already present"
fi

echo "next: run ./decomp-build.sh"
