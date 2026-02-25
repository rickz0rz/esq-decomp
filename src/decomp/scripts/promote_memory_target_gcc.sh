#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

CROSS_CC_BIN="${CROSS_CC:-/opt/amiga/bin/m68k-amigaos-gcc}"
GCC_CFLAGS_VALUE="${GCC_CFLAGS:--O1 -m68000 -ffreestanding -fno-builtin -fno-inline -fno-omit-frame-pointer}"
OUT_DIR="build/decomp/c_trial_gcc"
LOG_DIR="${OUT_DIR}/promotion_logs"

ALLOC_COMPARE_SCRIPT="src/decomp/scripts/compare_memory_allocate_trial_gcc.sh"
DEALLOC_COMPARE_SCRIPT="src/decomp/scripts/compare_memory_deallocate_trial_gcc.sh"

ALLOC_ORIG_NORM="${OUT_DIR}/memory_allocate.original_slice.norm.s"
ALLOC_GEN_NORM="${OUT_DIR}/memory_allocate.generated_slice.norm.s"
ALLOC_ORIG_SEM="${OUT_DIR}/memory_allocate.original_slice.semantic.txt"
ALLOC_GEN_SEM="${OUT_DIR}/memory_allocate.generated_slice.semantic.txt"
ALLOC_DIFF="${LOG_DIR}/memory_allocate.norm.diff"

DEALLOC_ORIG_NORM="${OUT_DIR}/memory_deallocate.original_slice.norm.s"
DEALLOC_GEN_NORM="${OUT_DIR}/memory_deallocate.generated_slice.norm.s"
DEALLOC_ORIG_SEM="${OUT_DIR}/memory_deallocate.original_slice.semantic.txt"
DEALLOC_GEN_SEM="${OUT_DIR}/memory_deallocate.generated_slice.semantic.txt"
DEALLOC_DIFF="${LOG_DIR}/memory_deallocate.norm.diff"

mkdir -p "$LOG_DIR"

run_compare() {
    local name="$1"
    local script="$2"
    local log_file="${LOG_DIR}/${name}.compare.log"

    CROSS_CC="$CROSS_CC_BIN" GCC_CFLAGS="$GCC_CFLAGS_VALUE" bash "$script" >"$log_file" 2>&1
    echo "compare ok: ${name} (log: ${log_file})"
}

check_semantic_equal() {
    local name="$1"
    local orig="$2"
    local gen="$3"

    if ! cmp -s "$orig" "$gen"; then
        echo "semantic mismatch: ${name}" >&2
        diff -u "$orig" "$gen" || true
        return 1
    fi
    echo "semantic ok: ${name}"
}

check_normalized_allowlist() {
    local name="$1"
    local orig="$2"
    local gen="$3"
    local diff_file="$4"
    local unexpected=0
    local line payload

    diff -u "$orig" "$gen" >"$diff_file" || true

    if [ ! -s "$diff_file" ]; then
        echo "normalized ok (identical): ${name}"
        return 0
    fi

    shopt -s nocasematch
    while IFS= read -r line; do
        case "$line" in
            ---*|+++*|@@*|"")
                continue
                ;;
            +*|-*)
                payload="${line:1}"
                payload="$(echo "$payload" | sed -E 's/^[[:space:]]+//; s/[[:space:]]+/ /g; s/[[:space:]]+$//')"
                if [ -z "$payload" ]; then
                    continue
                fi
                case "$payload" in
                    LINK.W*|UNLK*|MOVEM.L*|RTS|NOP|JRA*|JEQ*|BEQ*|TST.L*|.L*:|.RETURN:)
                        continue
                        ;;
                    MOVE.L*,-\(SP\)|MOVE.L\ \(SP\)+,*|MOVE.L*,D0|MOVE.L*,D1|MOVE.L*,D2|MOVE.L*,D6|MOVE.L*,D7|MOVE.L*,A1|MOVE.L*,A3|MOVE.L*,A6)
                        continue
                        ;;
                    MOVEA.L*|MOVEA*.L*)
                        continue
                        ;;
                    JSR\ LVOALLOCMEM\(A6\)|JSR\ LVOFREEMEM\(A6\))
                        continue
                        ;;
                    ADD.L*,GLOBAL_MEM_BYTES_ALLOCATED|ADD.L*,_GLOBAL_MEM_BYTES_ALLOCATED|SUB.L*,GLOBAL_MEM_BYTES_ALLOCATED|SUB.L*,_GLOBAL_MEM_BYTES_ALLOCATED)
                        continue
                        ;;
                    ADDQ.L\ #1,GLOBAL_MEM_ALLOC_COUNT|ADDQ.L\ #1,_GLOBAL_MEM_ALLOC_COUNT|ADDQ.L\ #1,GLOBAL_MEM_DEALLOC_COUNT|ADDQ.L\ #1,_GLOBAL_MEM_DEALLOC_COUNT)
                        continue
                        ;;
                    *)
                        echo "unexpected normalized diff (${name}): ${line}" >&2
                        unexpected=1
                        ;;
                esac
                ;;
            *)
                ;;
        esac
    done <"$diff_file"
    shopt -u nocasematch

    if [ "$unexpected" -ne 0 ]; then
        echo "normalized allowlist failed: ${name} (diff: ${diff_file})" >&2
        return 1
    fi

    echo "normalized allowlist ok: ${name} (diff: ${diff_file})"
}

echo "promotion gate: gcc memory targets"
echo "compiler: ${CROSS_CC_BIN}"
echo "gcc flags: ${GCC_CFLAGS_VALUE}"

run_compare "memory_allocate" "$ALLOC_COMPARE_SCRIPT"
run_compare "memory_deallocate" "$DEALLOC_COMPARE_SCRIPT"

check_semantic_equal "memory_allocate" "$ALLOC_ORIG_SEM" "$ALLOC_GEN_SEM"
check_semantic_equal "memory_deallocate" "$DEALLOC_ORIG_SEM" "$DEALLOC_GEN_SEM"

check_normalized_allowlist "memory_allocate" "$ALLOC_ORIG_NORM" "$ALLOC_GEN_NORM" "$ALLOC_DIFF"
check_normalized_allowlist "memory_deallocate" "$DEALLOC_ORIG_NORM" "$DEALLOC_GEN_NORM" "$DEALLOC_DIFF"

echo "running hybrid build gate"
bash ./decomp-build.sh >"${LOG_DIR}/decomp-build.log" 2>&1
echo "decomp-build ok (log: ${LOG_DIR}/decomp-build.log)"

echo "running canonical hash gate"
bash ./test-hash.sh >"${LOG_DIR}/test-hash.log" 2>&1
echo "test-hash ok (log: ${LOG_DIR}/test-hash.log)"

echo "promotion gate passed"
