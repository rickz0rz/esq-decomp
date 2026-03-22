#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SCRIPTS=(
    src/decomp/scripts/compare_sasc_memory_allocate_trial.sh
    src/decomp/scripts/compare_sasc_memory_deallocate_trial.sh
    src/decomp/scripts/compare_sasc_string_n_trial.sh
    src/decomp/scripts/compare_sasc_string_nocase_trial.sh
    src/decomp/scripts/compare_sasc_string_nocase_n_trial.sh
    src/decomp/scripts/compare_sasc_format_u32_decimal_trial.sh
    src/decomp/scripts/compare_sasc_format_u32_hex_trial.sh
    src/decomp/scripts/compare_sasc_format_u32_octal_trial.sh
    src/decomp/scripts/compare_sasc_battclock_get_seconds_from_battery_backed_clock_trial.sh
    src/decomp/scripts/compare_sasc_battclock_write_seconds_to_battery_backed_clock_trial.sh
    src/decomp/scripts/compare_sasc_dos_system_tag_list_trial.sh
    src/decomp/scripts/compare_sasc_parallel_check_ready_trial.sh
    src/decomp/scripts/compare_sasc_parallel_check_ready_stub_trial.sh
    src/decomp/scripts/compare_sasc_parallel_wait_ready_trial.sh
    src/decomp/scripts/compare_sasc_parallel_write_char_d0_trial.sh
    src/decomp/scripts/compare_sasc_parallel_write_string_loop_trial.sh
    src/decomp/scripts/compare_sasc_parallel_raw_dofmt_stack_args_trial.sh
    src/decomp/scripts/compare_sasc_parallel_raw_dofmt_common_trial.sh
    src/decomp/scripts/compare_sasc_parallel_write_char_hw_trial.sh
    src/decomp/scripts/compare_sasc_parallel_raw_dofmt_trial.sh
    src/decomp/scripts/compare_sasc_parse_readsignedlong_parse_done_trial.sh
    src/decomp/scripts/compare_sasc_parse_readsignedlong_parse_loop_entry_trial.sh
    src/decomp/scripts/compare_sasc_parse_readsignedlong_parse_loop_trial.sh
    src/decomp/scripts/compare_sasc_parse_readsignedlong_store_result_trial.sh
)

if [ "$#" -gt 0 ]; then
    SCRIPTS=("$@")
fi

echo "SAS/C helper alias sweep"

failures=0
for script in "${SCRIPTS[@]}"; do
    echo "run: $script"

    output="$(bash "$script")"
    printf '%s\n' "$output"

    semantic_paths="$(printf '%s\n' "$output" | sed -n 's/^wrote: \(.*\.semantic\.diff\)$/\1/p')"
    if [ -z "$semantic_paths" ]; then
        echo "  error: no semantic diff path reported"
        failures=1
        continue
    fi

    while IFS= read -r semantic_path; do
        if [ ! -f "$semantic_path" ]; then
            echo "  missing: $semantic_path"
            failures=1
            continue
        fi

        size=$(wc -c <"$semantic_path")
        echo "  semantic: $semantic_path (${size} bytes)"
        if [ "$size" -ne 0 ]; then
            failures=1
        fi
    done <<<"$semantic_paths"
done

if [ "$failures" -ne 0 ]; then
    echo "helper alias sweep failed"
    exit 1
fi

echo "helper alias sweep passed"
