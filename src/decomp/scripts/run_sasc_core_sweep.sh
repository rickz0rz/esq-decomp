#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

STRICT=0
if [ "${1:-}" = "--strict" ]; then
    STRICT=1
fi

SCRIPTS=(
    "src/decomp/scripts/compare_sasc_mem_move_trial.sh"
    "src/decomp/scripts/compare_sasc_list_init_header_trial.sh"
    "src/decomp/scripts/compare_sasc_dos_read_by_index_trial.sh"
    "src/decomp/scripts/compare_sasc_dos_seek_by_index_trial.sh"
    "src/decomp/scripts/compare_sasc_dos_write_by_index_trial.sh"
    "src/decomp/scripts/compare_sasc_string_append_at_null_trial.sh"
    "src/decomp/scripts/compare_sasc_string_append_n_trial.sh"
    "src/decomp/scripts/compare_sasc_string_copy_pad_nul_trial.sh"
    "src/decomp/scripts/compare_sasc_string_compare_n_trial.sh"
    "src/decomp/scripts/compare_sasc_string_compare_nocase_trial.sh"
    "src/decomp/scripts/compare_sasc_string_compare_nocase_n_trial.sh"
    "src/decomp/scripts/compare_sasc_string_toupper_inplace_trial.sh"
    "src/decomp/scripts/compare_sasc_string_find_substring_trial.sh"
    "src/decomp/scripts/compare_sasc_str_find_char_trial.sh"
    "src/decomp/scripts/compare_sasc_str_find_char_ptr_trial.sh"
    "src/decomp/scripts/compare_sasc_str_find_any_char_in_set_trial.sh"
    "src/decomp/scripts/compare_sasc_str_find_any_char_ptr_trial.sh"
    "src/decomp/scripts/compare_sasc_str_skip_class3_chars_trial.sh"
    "src/decomp/scripts/compare_sasc_str_copy_until_any_delim_n_trial.sh"
    "src/decomp/scripts/compare_sasc_format_u32_to_decimal_string_trial.sh"
    "src/decomp/scripts/compare_sasc_disptext_build_line_with_width_trial.sh"
    "src/decomp/scripts/compare_sasc_disptext_layout_source_to_lines_trial.sh"
    "src/decomp/scripts/compare_sasc_disptext_layout_and_append_to_buffer_trial.sh"
    "src/decomp/scripts/compare_sasc_disptext_render_current_line_trial.sh"
)

OUT_DIR="build/decomp/sasc_trial"
mkdir -p "$OUT_DIR"

failed=0
echo "SAS/C core sweep (strict=${STRICT})"

for script in "${SCRIPTS[@]}"; do
    if [ ! -x "$script" ]; then
        echo "skip (missing/not executable): $script"
        continue
    fi

    echo "run: $script"
    bash "$script" >/tmp/run_sasc_core_sweep.log 2>&1 || {
        echo "error: compare script failed: $script"
        cat /tmp/run_sasc_core_sweep.log
        failed=1
        continue
    }

    base="$(basename "$script" .sh)"
    base="${base#compare_sasc_}"
    base="${base%_trial}"
    diff_file="${OUT_DIR}/${base}.semantic.diff"

    if [ ! -f "$diff_file" ]; then
        echo "warn: semantic diff not found for $script (expected $diff_file)"
        failed=1
        continue
    fi

    size="$(wc -c <"$diff_file" | tr -d ' ')"
    echo "  semantic: ${diff_file} (${size} bytes)"
    if [ "$size" -ne 0 ]; then
        failed=1
    fi
done

if [ "$failed" -ne 0 ]; then
    echo "SAS/C core sweep: semantic mismatches present"
    if [ "$STRICT" -eq 1 ]; then
        exit 1
    fi
else
    echo "SAS/C core sweep: all semantic diffs are zero"
fi
