#!/bin/bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"
OUT_DIR="build/decomp/c_trial_gcc"
LOG_DIR="${OUT_DIR}/promotion_logs"
COMPARE_SCRIPT="src/decomp/scripts/compare_script_read_handshake_bit5_mask_trial_gcc.sh"
ORIG_SEM="${OUT_DIR}/script_read_handshake_bit5_mask.original_slice.semantic.txt"
GEN_SEM="${OUT_DIR}/script_read_handshake_bit5_mask.generated_slice.semantic.txt"
mkdir -p "$LOG_DIR"
bash "$COMPARE_SCRIPT" >"${LOG_DIR}/script_read_handshake_bit5_mask.compare.log" 2>&1
if ! cmp -s "$ORIG_SEM" "$GEN_SEM"; then diff -u "$ORIG_SEM" "$GEN_SEM" || true; exit 1; fi
bash ./decomp-build.sh >"${LOG_DIR}/decomp-build_script_read_handshake_bit5_mask.log" 2>&1
bash ./test-hash.sh >"${LOG_DIR}/test-hash_script_read_handshake_bit5_mask.log" 2>&1
echo "promotion gate passed"
