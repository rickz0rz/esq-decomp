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
    "src/decomp/scripts/compare_sasc_dos_read_with_error_state_trial.sh"
    "src/decomp/scripts/compare_sasc_dos_write_with_error_state_trial.sh"
    "src/decomp/scripts/compare_sasc_dos_seek_with_error_state_trial.sh"
    "src/decomp/scripts/compare_sasc_dos_open_with_error_state_trial.sh"
    "src/decomp/scripts/compare_sasc_dos_open_new_file_if_missing_trial.sh"
    "src/decomp/scripts/compare_sasc_dos_delete_and_recreate_file_trial.sh"
    "src/decomp/scripts/compare_sasc_iostdreq_free_trial.sh"
    "src/decomp/scripts/compare_sasc_iostdreq_cleanup_signal_and_msgport_trial.sh"
    "src/decomp/scripts/compare_sasc_handle_get_entry_by_index_trial.sh"
    "src/decomp/scripts/compare_sasc_handle_close_by_index_trial.sh"
    "src/decomp/scripts/compare_sasc_memlist_free_all_trial.sh"
    "src/decomp/scripts/compare_sasc_memlist_alloc_tracked_trial.sh"
    "src/decomp/scripts/compare_sasc_alloc_alloc_from_free_list_trial.sh"
    "src/decomp/scripts/compare_sasc_alloc_insert_free_block_trial.sh"
    "src/decomp/scripts/compare_sasc_allocate_alloc_and_initialize_iostdreq_trial.sh"
    "src/decomp/scripts/compare_sasc_datetime_isleapyear_trial.sh"
    "src/decomp/scripts/compare_sasc_datetime_adjust_month_index_trial.sh"
    "src/decomp/scripts/compare_sasc_datetime_normalize_month_range_trial.sh"
    "src/decomp/scripts/compare_sasc_battclock_get_seconds_trial.sh"
    "src/decomp/scripts/compare_sasc_battclock_write_seconds_trial.sh"
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
    "src/decomp/scripts/compare_sasc_esq_test_bit1_based_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_set_bit1_based_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_noop_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_noop_006a_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_noop_0074_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_shutdown_and_return_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_return_with_stack_code_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_main_entry_noop_hook_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_main_exit_noop_hook_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_wildcard_match_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_generate_xor_checksum_byte_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_write_dec_fixed_width_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_find_substring_case_fold_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_packbits_decode_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_get_half_hour_slot_index_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_clamp_banner_char_range_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_reverse_bits_in6_bytes_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_dec_color_step_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_bump_color_toward_targets_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_set_copper_effect_params_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_set_copper_effect_default_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_set_copper_effect_all_on_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_set_copper_effect_custom_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_set_copper_effect_off_disable_highlight_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_set_copper_effect_on_enable_highlight_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_update_copper_lists_from_params_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_move_copper_entry_toward_start_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_move_copper_entry_toward_end_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_dec_copper_lists_primary_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_inc_copper_lists_towards_targets_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_seed_minute_event_thresholds_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_tick_global_counters_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_calc_day_of_year_from_month_day_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_update_month_day_from_day_of_year_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_format_time_stamp_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_tick_clock_and_flag_events_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_adjust_bracketed_hour_in_string_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_store_ctrl_sample_entry_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_poll_ctrl_input_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_read_serial_rbf_byte_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_handle_serial_rbf_interrupt_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_capture_ctrl_bit3_stream_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_capture_ctrl_bit4_stream_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_capture_ctrl_bit4_stream_buffer_byte_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_advance_banner_char_index_return_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_terminate_after_second_quote_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_check_available_fast_memory_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_check_compatible_video_chip_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_check_topaz_font_guard_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_format_disk_error_message_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_init_audio1_dma_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_invoke_gcommand_init_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_cold_reboot_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_supervisor_cold_reboot_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_cold_reboot_via_supervisor_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_cold_reboot_pair_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_try_rom_write_test_trial.sh"
    "src/decomp/scripts/compare_sasc_esq_parse_command_line_and_run_trial.sh"
    "src/decomp/scripts/compare_sasc_clock_check_date_or_seconds_from_epoch_trial.sh"
    "src/decomp/scripts/compare_sasc_clock_seconds_from_epoch_trial.sh"
    "src/decomp/scripts/compare_sasc_parallel_check_ready_stub_trial.sh"
    "src/decomp/scripts/compare_sasc_parallel_check_ready_trial.sh"
    "src/decomp/scripts/compare_sasc_parallel_wait_ready_trial.sh"
    "src/decomp/scripts/compare_sasc_parallel_write_char_d0_trial.sh"
    "src/decomp/scripts/compare_sasc_parallel_writestringloop_trial.sh"
    "src/decomp/scripts/compare_sasc_parallel_rawdofmtstackargs_trial.sh"
    "src/decomp/scripts/compare_sasc_parallel_rawdofmtcommon_trial.sh"
    "src/decomp/scripts/compare_sasc_parallel_writecharhw_trial.sh"
    "src/decomp/scripts/compare_sasc_parallel_rawdofmt_trial.sh"
    "src/decomp/scripts/compare_sasc_battclock_get_seconds_from_battery_backed_clock_trial.sh"
    "src/decomp/scripts/compare_sasc_battclock_write_seconds_to_battery_backed_clock_trial.sh"
    "src/decomp/scripts/compare_sasc_dos_delay_trial.sh"
    "src/decomp/scripts/compare_sasc_dos_system_tag_list_trial.sh"
    "src/decomp/scripts/compare_sasc_exec_call_vector_48_trial.sh"
    "src/decomp/scripts/compare_sasc_group_main_b_jmptbl_dos_delay_trial.sh"
    "src/decomp/scripts/compare_sasc_group_at_jmptbl_dos_system_taglist_trial.sh"
    "src/decomp/scripts/compare_sasc_group_av_jmptbl_exec_call_vector_48_trial.sh"
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
    if [ ! -f "$script" ]; then
        echo "skip (missing): $script"
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
