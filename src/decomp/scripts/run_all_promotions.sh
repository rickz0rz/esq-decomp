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
    "src/decomp/scripts/promote_list_init_header_target_gcc.sh"
    "src/decomp/scripts/promote_dos_read_by_index_target_gcc.sh"
    "src/decomp/scripts/promote_dos_seek_by_index_target_gcc.sh"
    "src/decomp/scripts/promote_dos_write_by_index_target_gcc.sh"
    "src/decomp/scripts/promote_handle_get_entry_by_index_target_gcc.sh"
    "src/decomp/scripts/promote_dos_close_with_signal_check_target_gcc.sh"
    "src/decomp/scripts/promote_iostdreq_free_target_gcc.sh"
    "src/decomp/scripts/promote_iostdreq_cleanup_signal_and_msgport_target_gcc.sh"
    "src/decomp/scripts/promote_math_mulu32_target_gcc.sh"
    "src/decomp/scripts/promote_math_divs32_target_gcc.sh"
    "src/decomp/scripts/promote_allocate_alloc_and_initialize_iostdreq_target_gcc.sh"
    "src/decomp/scripts/promote_dos_read_with_error_state_target_gcc.sh"
    "src/decomp/scripts/promote_dos_seek_with_error_state_target_gcc.sh"
    "src/decomp/scripts/promote_dos_write_with_error_state_target_gcc.sh"
    "src/decomp/scripts/promote_string_append_at_null_target_gcc.sh"
    "src/decomp/scripts/promote_string_append_n_target_gcc.sh"
    "src/decomp/scripts/promote_string_copy_pad_nul_target_gcc.sh"
    "src/decomp/scripts/promote_string_compare_n_target_gcc.sh"
    "src/decomp/scripts/promote_string_compare_nocase_target_gcc.sh"
    "src/decomp/scripts/promote_string_compare_nocase_n_target_gcc.sh"
    "src/decomp/scripts/promote_string_toupper_inplace_target_gcc.sh"
    "src/decomp/scripts/promote_str_find_char_target_gcc.sh"
    "src/decomp/scripts/promote_str_find_char_ptr_target_gcc.sh"
    "src/decomp/scripts/promote_str_find_any_char_in_set_target_gcc.sh"
    "src/decomp/scripts/promote_str_find_any_char_ptr_target_gcc.sh"
    "src/decomp/scripts/promote_str_skip_class3_chars_target_gcc.sh"
    "src/decomp/scripts/promote_str_copy_until_any_delim_n_target_gcc.sh"
    "src/decomp/scripts/promote_stream_read_line_with_limit_target_gcc.sh"
    "src/decomp/scripts/promote_exec_call_vector_348_target_gcc.sh"
    "src/decomp/scripts/promote_format_callback_write_char_target_gcc.sh"
    "src/decomp/scripts/promote_format_to_callback_buffer_target_gcc.sh"
    "src/decomp/scripts/promote_format_u32_octal_target_gcc.sh"
    "src/decomp/scripts/promote_format_u32_hex_target_gcc.sh"
    "src/decomp/scripts/promote_printf_putc_to_buffer_target_gcc.sh"
    "src/decomp/scripts/promote_wdisp_sprintf_target_gcc.sh"
    "src/decomp/scripts/promote_parse_read_signed_long_nobranch_target_gcc.sh"
    "src/decomp/scripts/promote_parse_read_signed_long_target_gcc.sh"
)

echo "running all promotion gates (${#SCRIPTS[@]} total)"

for script in "${SCRIPTS[@]}"; do
    echo
    echo "==> ${script}"
    bash "$script"
done

echo
echo "all promotion gates passed"
