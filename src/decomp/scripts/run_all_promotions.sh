#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SCRIPTS=(
    "src/decomp/scripts/promote_memory_target_gcc.sh"
    "src/decomp/scripts/promote_clock_target_gcc.sh"
    "src/decomp/scripts/promote_string_toupper_target_gcc.sh"
    "src/decomp/scripts/promote_mem_move_target_gcc.sh"
    "src/decomp/scripts/promote_format_u32_decimal_target_gcc.sh"
)

echo "running all promotion gates (${#SCRIPTS[@]} total)"

for script in "${SCRIPTS[@]}"; do
    echo
    echo "==> ${script}"
    bash "$script"
done

echo
echo "all promotion gates passed"
