# Decomp Scaffold

This directory provides an opt-in workflow for replacing assembly modules incrementally while preserving the canonical `src/Prevue.asm` build as the baseline reference.

## Goals
- Keep `./build.sh` and `./test-hash.sh` unchanged and authoritative.
- Allow module-by-module replacement experiments in a separate build output.
- Make hash divergence explicit while conversions are in progress.

## Files
- `src/decomp/replacements.map`: module substitution map.
- `src/decomp/replacements/`: replacement module copies and edits.
- `src/decomp/TARGETS.md`: active decomp target registry and rationale.
- `src/decomp/scripts/gen_hybrid_root.sh`: generates `build/decomp/Prevue_hybrid.asm` from `src/Prevue.asm` + replacement map.
- `src/decomp/scripts/new_module_replacement.sh`: bootstraps a replacement module by copying original source and registering it.
- `src/decomp/scripts/compare_memory_allocate_trial.sh`: compiles `Target 002` C trial and diffs generated asm vs original function slice.
- `src/decomp/scripts/compare_memory_allocate_trial_gcc.sh`: GCC-specific compare lane for `Target 002` allocate function.
- `src/decomp/scripts/compare_memory_deallocate_trial.sh`: compiles `Target 002` deallocate C trial and diffs generated asm vs original function slice.
- `src/decomp/scripts/compare_memory_deallocate_trial_gcc.sh`: GCC-specific compare lane for `Target 002` deallocate function.
- `src/decomp/scripts/compare_clock_convert_trial.sh`: compiles `Target 003` clock-convert wrapper trial and diffs generated asm vs original function slice.
- `src/decomp/scripts/compare_clock_convert_trial_gcc.sh`: GCC-specific compare lane for `Target 003` (GAS output normalization included).
- `src/decomp/scripts/compare_string_toupper_trial_gcc.sh`: GCC-specific compare lane for `Target 004` (`STRING_ToUpperChar`).
- `src/decomp/scripts/compare_mem_move_trial_gcc.sh`: GCC-specific compare lane for `Target 005` (`MEM_Move`).
- `src/decomp/scripts/compare_format_u32_decimal_trial_gcc.sh`: GCC-specific compare lane for `Target 006` (`FORMAT_U32ToDecimalString`).
- `src/decomp/scripts/compare_list_init_header_trial_gcc.sh`: GCC-specific compare lane for `Target 007` (`LIST_InitHeader`).
- `src/decomp/scripts/compare_dos_read_by_index_trial_gcc.sh`: GCC-specific compare lane for `Target 008` (`DOS_ReadByIndex`).
- `src/decomp/scripts/compare_dos_seek_by_index_trial_gcc.sh`: GCC-specific compare lane for `Target 009` (`DOS_SeekByIndex`).
- `src/decomp/scripts/compare_dos_write_by_index_trial_gcc.sh`: GCC-specific compare lane for `Target 041` (`DOS_WriteByIndex`).
- `src/decomp/scripts/compare_handle_get_entry_by_index_trial_gcc.sh`: GCC-specific compare lane for `Target 036` (`HANDLE_GetEntryByIndex`).
- `src/decomp/scripts/compare_handle_close_by_index_trial_gcc.sh`: GCC-specific compare lane for `Target 067` (`HANDLE_CloseByIndex`).
- `src/decomp/scripts/compare_handle_open_with_mode_trial_gcc.sh`: GCC-specific compare lane for `Target 068` (`HANDLE_OpenWithMode`).
- `src/decomp/scripts/compare_string_find_substring_trial_gcc.sh`: GCC-specific compare lane for `Target 069` (`STRING_FindSubstring`).
- `src/decomp/scripts/compare_signal_poll_and_dispatch_trial_gcc.sh`: GCC-specific compare lane for `Target 070` (`SIGNAL_PollAndDispatch`).
- `src/decomp/scripts/compare_parse_read_signed_long_skip_class3_trial_gcc.sh`: GCC-specific compare lane for `Target 071` (`PARSE_ReadSignedLongSkipClass3`).
- `src/decomp/scripts/compare_parse_read_signed_long_skip_class3_alt_trial_gcc.sh`: GCC-specific compare lane for `Target 072` (`PARSE_ReadSignedLongSkipClass3_Alt`).
- `src/decomp/scripts/compare_memlist_free_all_trial_gcc.sh`: GCC-specific compare lane for `Target 073` (`MEMLIST_FreeAll`).
- `src/decomp/scripts/compare_memlist_alloc_tracked_trial_gcc.sh`: GCC-specific compare lane for `Target 076` (`MEMLIST_AllocTracked`).
- `src/decomp/scripts/compare_format_raw_dofmt_with_scratch_buffer_trial_gcc.sh`: GCC-specific compare lane for `Target 077` (`FORMAT_RawDoFmtWithScratchBuffer`).
- `src/decomp/scripts/compare_esq_main_entry_noop_hook_trial_gcc.sh`: GCC-specific compare lane for `Target 078` (`ESQ_MainEntryNoOpHook`).
- `src/decomp/scripts/compare_esq_main_exit_noop_hook_trial_gcc.sh`: GCC-specific compare lane for `Target 079` (`ESQ_MainExitNoOpHook`).
- `src/decomp/scripts/compare_dos_open_file_with_mode_trial_gcc.sh`: GCC-specific compare lane for `Target 080` (`DOS_OpenFileWithMode`).
- `src/decomp/scripts/compare_graphics_alloc_raster_trial_gcc.sh`: GCC-specific compare lane for `Target 081` (`GRAPHICS_AllocRaster`).
- `src/decomp/scripts/compare_graphics_free_raster_trial_gcc.sh`: GCC-specific compare lane for `Target 082` (`GRAPHICS_FreeRaster`).
- `src/decomp/scripts/compare_dos_movep_word_read_callback_trial_gcc.sh`: GCC-specific compare lane for `Target 083` (`DOS_MovepWordReadCallback`).
- `src/decomp/scripts/compare_unknown32_jmptbl_esq_return_with_stack_code_trial_gcc.sh`: GCC-specific compare lane for `Target 074` (`UNKNOWN32_JMPTBL_ESQ_ReturnWithStackCode`).
- `src/decomp/scripts/compare_handle_close_all_and_return_with_code_trial_gcc.sh`: GCC-specific compare lane for `Target 075` (`HANDLE_CloseAllAndReturnWithCode`).
- `src/decomp/scripts/compare_dos_close_with_signal_check_trial_gcc.sh`: GCC-specific compare lane for `Target 037` (`DOS_CloseWithSignalCheck`).
- `src/decomp/scripts/compare_iostdreq_free_trial_gcc.sh`: GCC-specific compare lane for `Target 038` (`IOSTDREQ_Free`).
- `src/decomp/scripts/compare_iostdreq_cleanup_signal_and_msgport_trial_gcc.sh`: GCC-specific compare lane for `Target 039` (`IOSTDREQ_CleanupSignalAndMsgport`).
- `src/decomp/scripts/compare_math_mulu32_trial_gcc.sh`: GCC-specific compare lane for `Target 040` (`MATH_Mulu32`).
- `src/decomp/scripts/compare_math_divs32_trial_gcc.sh`: GCC-specific compare lane for `Target 043` (`MATH_DivS32`).
- `src/decomp/scripts/compare_allocate_alloc_and_initialize_iostdreq_trial_gcc.sh`: GCC-specific compare lane for `Target 042` (`ALLOCATE_AllocAndInitializeIOStdReq`).
- `src/decomp/scripts/compare_signal_create_msgport_with_signal_trial_gcc.sh`: GCC-specific compare lane for `Target 046` (`SIGNAL_CreateMsgPortWithSignal`).
- `src/decomp/scripts/compare_dos_delay_trial_gcc.sh`: GCC-specific compare lane for `Target 047` (`DOS_Delay`).
- `src/decomp/scripts/compare_battclock_get_seconds_trial_gcc.sh`: GCC-specific compare lane for `Target 048` (`BATTCLOCK_GetSecondsFromBatteryBackedClock`).
- `src/decomp/scripts/compare_battclock_write_seconds_trial_gcc.sh`: GCC-specific compare lane for `Target 049` (`BATTCLOCK_WriteSecondsToBatteryBackedClock`).
- `src/decomp/scripts/compare_dos_system_taglist_trial_gcc.sh`: GCC-specific compare lane for `Target 050` (`DOS_SystemTagList`).
- `src/decomp/scripts/compare_exec_call_vector_48_trial_gcc.sh`: GCC-specific compare lane for `Target 051` (`EXEC_CallVector_48`).
- `src/decomp/scripts/compare_parallel_check_ready_stub_trial_gcc.sh`: GCC-specific compare lane for `Target 052` (`PARALLEL_CheckReadyStub`).
- `src/decomp/scripts/compare_unknown2a_stub0_trial_gcc.sh`: GCC-specific compare lane for `Target 053` (`UNKNOWN2A_Stub0`).
- `src/decomp/scripts/compare_parallel_check_ready_trial_gcc.sh`: GCC-specific compare lane for `Target 054` (`PARALLEL_CheckReady`).
- `src/decomp/scripts/compare_parallel_write_char_d0_trial_gcc.sh`: GCC-specific compare lane for `Target 055` (`PARALLEL_WriteCharD0`).
- `src/decomp/scripts/compare_clock_seconds_from_epoch_trial_gcc.sh`: GCC-specific compare lane for `Target 056` (`CLOCK_SecondsFromEpoch`).
- `src/decomp/scripts/compare_clock_check_date_or_seconds_from_epoch_trial_gcc.sh`: GCC-specific compare lane for `Target 057` (`CLOCK_CheckDateOrSecondsFromEpoch`).
- `src/decomp/scripts/compare_parallel_wait_ready_trial_gcc.sh`: GCC-specific compare lane for `Target 058` (`PARALLEL_WaitReady`).
- `src/decomp/scripts/compare_parallel_write_string_loop_trial_gcc.sh`: GCC-specific compare lane for `Target 059` (`PARALLEL_WriteStringLoop`).
- `src/decomp/scripts/compare_parallel_raw_dofmt_common_trial_gcc.sh`: GCC-specific compare lane for `Target 063` (`PARALLEL_RawDoFmtCommon`).
- `src/decomp/scripts/compare_parallel_raw_dofmt_trial_gcc.sh`: GCC-specific compare lane for `Target 060` (`PARALLEL_RawDoFmt`).
- `src/decomp/scripts/compare_parallel_write_char_hw_trial_gcc.sh`: GCC-specific compare lane for `Target 061` (`PARALLEL_WriteCharHw`).
- `src/decomp/scripts/compare_parallel_raw_dofmt_stack_args_trial_gcc.sh`: GCC-specific compare lane for `Target 062` (`PARALLEL_RawDoFmtStackArgs`).
- `src/decomp/scripts/compare_dos_open_new_file_if_missing_trial_gcc.sh`: GCC-specific compare lane for `Target 044` (`DOS_OpenNewFileIfMissing`).
- `src/decomp/scripts/compare_dos_open_with_error_state_trial_gcc.sh`: GCC-specific compare lane for `Target 066` (`DOS_OpenWithErrorState`).
- `src/decomp/scripts/compare_dos_delete_and_recreate_file_trial_gcc.sh`: GCC-specific compare lane for `Target 045` (`DOS_DeleteAndRecreateFile`).
- `src/decomp/scripts/compare_dos_read_with_error_state_trial_gcc.sh`: GCC-specific compare lane for `Target 033` (`DOS_ReadWithErrorState`).
- `src/decomp/scripts/compare_dos_seek_with_error_state_trial_gcc.sh`: GCC-specific compare lane for `Target 034` (`DOS_SeekWithErrorState`).
- `src/decomp/scripts/compare_dos_write_with_error_state_trial_gcc.sh`: GCC-specific compare lane for `Target 032` (`DOS_WriteWithErrorState`).
- `src/decomp/scripts/compare_string_append_at_null_trial_gcc.sh`: GCC-specific compare lane for `Target 010` (`STRING_AppendAtNull`).
- `src/decomp/scripts/compare_string_append_n_trial_gcc.sh`: GCC-specific compare lane for `Target 011` (`STRING_AppendN`).
- `src/decomp/scripts/compare_string_copy_pad_nul_trial_gcc.sh`: GCC-specific compare lane for `Target 012` (`STRING_CopyPadNul`).
- `src/decomp/scripts/compare_string_compare_n_trial_gcc.sh`: GCC-specific compare lane for `Target 013` (`STRING_CompareN`).
- `src/decomp/scripts/compare_string_compare_nocase_trial_gcc.sh`: GCC-specific compare lane for `Target 014` (`STRING_CompareNoCase`).
- `src/decomp/scripts/compare_string_compare_nocase_n_trial_gcc.sh`: GCC-specific compare lane for `Target 015` (`STRING_CompareNoCaseN`).
- `src/decomp/scripts/compare_string_toupper_inplace_trial_gcc.sh`: GCC-specific compare lane for `Target 016` (`STRING_ToUpperInPlace`).
- `src/decomp/scripts/compare_str_find_char_trial_gcc.sh`: GCC-specific compare lane for `Target 017` (`STR_FindChar`).
- `src/decomp/scripts/compare_str_find_char_ptr_trial_gcc.sh`: GCC-specific compare lane for `Target 018` (`STR_FindCharPtr`).
- `src/decomp/scripts/compare_str_find_any_char_in_set_trial_gcc.sh`: GCC-specific compare lane for `Target 019` (`STR_FindAnyCharInSet`).
- `src/decomp/scripts/compare_str_find_any_char_ptr_trial_gcc.sh`: GCC-specific compare lane for `Target 020` (`STR_FindAnyCharPtr`).
- `src/decomp/scripts/compare_str_skip_class3_chars_trial_gcc.sh`: GCC-specific compare lane for `Target 021` (`STR_SkipClass3Chars`).
- `src/decomp/scripts/compare_str_copy_until_any_delim_n_trial_gcc.sh`: GCC-specific compare lane for `Target 030` (`STR_CopyUntilAnyDelimN`).
- `src/decomp/scripts/compare_stream_read_line_with_limit_trial_gcc.sh`: GCC-specific compare lane for `Target 031` (`STREAM_ReadLineWithLimit`).
- `src/decomp/scripts/compare_exec_call_vector_348_trial_gcc.sh`: GCC-specific compare lane for `Target 035` (`EXEC_CallVector_348`).
- `src/decomp/scripts/compare_format_callback_write_char_trial_gcc.sh`: GCC-specific compare lane for `Target 022` (`FORMAT_CallbackWriteChar`).
- `src/decomp/scripts/compare_format_to_callback_buffer_trial_gcc.sh`: GCC-specific compare lane for `Target 023` (`FORMAT_FormatToCallbackBuffer`).
- `src/decomp/scripts/compare_format_u32_octal_trial_gcc.sh`: GCC-specific compare lane for `Target 024` (`FORMAT_U32ToOctalString`).
- `src/decomp/scripts/compare_format_u32_hex_trial_gcc.sh`: GCC-specific compare lane for `Target 025` (`FORMAT_U32ToHexString`).
- `src/decomp/scripts/compare_printf_putc_to_buffer_trial_gcc.sh`: GCC-specific compare lane for `Target 026` (`UNKNOWN10_PrintfPutcToBuffer`).
- `src/decomp/scripts/compare_wdisp_sprintf_trial_gcc.sh`: GCC-specific compare lane for `Target 027` (`WDISP_SPrintf`).
- `src/decomp/scripts/compare_parse_read_signed_long_nobranch_trial_gcc.sh`: GCC-specific compare lane for `Target 028` (`PARSE_ReadSignedLong_NoBranch`).
- `src/decomp/scripts/compare_parse_read_signed_long_trial_gcc.sh`: GCC-specific compare lane for `Target 029` (`PARSE_ReadSignedLong`).
- `src/decomp/scripts/compare_struct_free_with_size_field_trial_gcc.sh`: GCC-specific compare lane for `Target 064` (`STRUCT_FreeWithSizeField`).
- `src/decomp/scripts/compare_struct_alloc_with_owner_trial_gcc.sh`: GCC-specific compare lane for `Target 065` (`STRUCT_AllocWithOwner`).
- `src/decomp/scripts/semantic_filter_memory.awk`: semantic post-filter for memory allocate/deallocate GCC compare lanes.
- `src/decomp/scripts/semantic_filter_toupper.awk`: semantic post-filter for `STRING_ToUpperChar` compare lane.
- `src/decomp/scripts/semantic_filter_memmove.awk`: semantic post-filter for `MEM_Move` compare lane.
- `src/decomp/scripts/semantic_filter_u32dec.awk`: semantic post-filter for `FORMAT_U32ToDecimalString` compare lane.
- `src/decomp/scripts/semantic_filter_list_init.awk`: semantic post-filter for `LIST_InitHeader` compare lane.
- `src/decomp/scripts/semantic_filter_dos_read_idx.awk`: semantic post-filter for `DOS_ReadByIndex` compare lane.
- `src/decomp/scripts/semantic_filter_dos_seek_idx.awk`: semantic post-filter for `DOS_SeekByIndex` compare lane.
- `src/decomp/scripts/semantic_filter_dos_write_by_index.awk`: semantic post-filter for `DOS_WriteByIndex` compare lane.
- `src/decomp/scripts/semantic_filter_handle_get_entry_by_index.awk`: semantic post-filter for `HANDLE_GetEntryByIndex` compare lane.
- `src/decomp/scripts/semantic_filter_handle_close_by_index.awk`: semantic post-filter for `HANDLE_CloseByIndex` compare lane.
- `src/decomp/scripts/semantic_filter_handle_open_with_mode.awk`: semantic post-filter for `HANDLE_OpenWithMode` compare lane.
- `src/decomp/scripts/semantic_filter_string_find_substring.awk`: semantic post-filter for `STRING_FindSubstring` compare lane.
- `src/decomp/scripts/semantic_filter_signal_poll_and_dispatch.awk`: semantic post-filter for `SIGNAL_PollAndDispatch` compare lane.
- `src/decomp/scripts/semantic_filter_parse_read_signed_long_skip_class3.awk`: semantic post-filter for `PARSE_ReadSignedLongSkipClass3` compare lane.
- `src/decomp/scripts/semantic_filter_parse_read_signed_long_skip_class3_alt.awk`: semantic post-filter for `PARSE_ReadSignedLongSkipClass3_Alt` compare lane.
- `src/decomp/scripts/semantic_filter_memlist_free_all.awk`: semantic post-filter for `MEMLIST_FreeAll` compare lane.
- `src/decomp/scripts/semantic_filter_memlist_alloc_tracked.awk`: semantic post-filter for `MEMLIST_AllocTracked` compare lane.
- `src/decomp/scripts/semantic_filter_format_raw_dofmt_with_scratch_buffer.awk`: semantic post-filter for `FORMAT_RawDoFmtWithScratchBuffer` compare lane.
- `src/decomp/scripts/semantic_filter_esq_main_entry_noop_hook.awk`: semantic post-filter for `ESQ_MainEntryNoOpHook` compare lane.
- `src/decomp/scripts/semantic_filter_esq_main_exit_noop_hook.awk`: semantic post-filter for `ESQ_MainExitNoOpHook` compare lane.
- `src/decomp/scripts/semantic_filter_dos_open_file_with_mode.awk`: semantic post-filter for `DOS_OpenFileWithMode` compare lane.
- `src/decomp/scripts/semantic_filter_graphics_alloc_raster.awk`: semantic post-filter for `GRAPHICS_AllocRaster` compare lane.
- `src/decomp/scripts/semantic_filter_graphics_free_raster.awk`: semantic post-filter for `GRAPHICS_FreeRaster` compare lane.
- `src/decomp/scripts/semantic_filter_dos_movep_word_read_callback.awk`: semantic post-filter for `DOS_MovepWordReadCallback` compare lane.
- `src/decomp/scripts/semantic_filter_unknown32_jmptbl_esq_return_with_stack_code.awk`: semantic post-filter for `UNKNOWN32_JMPTBL_ESQ_ReturnWithStackCode` compare lane.
- `src/decomp/scripts/semantic_filter_handle_close_all_and_return_with_code.awk`: semantic post-filter for `HANDLE_CloseAllAndReturnWithCode` compare lane.
- `src/decomp/scripts/semantic_filter_dos_close_with_signal_check.awk`: semantic post-filter for `DOS_CloseWithSignalCheck` compare lane.
- `src/decomp/scripts/semantic_filter_iostdreq_free.awk`: semantic post-filter for `IOSTDREQ_Free` compare lane.
- `src/decomp/scripts/semantic_filter_iostdreq_cleanup_signal_and_msgport.awk`: semantic post-filter for `IOSTDREQ_CleanupSignalAndMsgport` compare lane.
- `src/decomp/scripts/semantic_filter_math_mulu32.awk`: semantic post-filter for `MATH_Mulu32` compare lane.
- `src/decomp/scripts/semantic_filter_math_divs32.awk`: semantic post-filter for `MATH_DivS32` compare lane.
- `src/decomp/scripts/semantic_filter_allocate_alloc_and_initialize_iostdreq.awk`: semantic post-filter for `ALLOCATE_AllocAndInitializeIOStdReq` compare lane.
- `src/decomp/scripts/semantic_filter_signal_create_msgport_with_signal.awk`: semantic post-filter for `SIGNAL_CreateMsgPortWithSignal` compare lane.
- `src/decomp/scripts/semantic_filter_dos_delay.awk`: semantic post-filter for `DOS_Delay` compare lane.
- `src/decomp/scripts/semantic_filter_battclock_get_seconds.awk`: semantic post-filter for `BATTCLOCK_GetSecondsFromBatteryBackedClock` compare lane.
- `src/decomp/scripts/semantic_filter_battclock_write_seconds.awk`: semantic post-filter for `BATTCLOCK_WriteSecondsToBatteryBackedClock` compare lane.
- `src/decomp/scripts/semantic_filter_dos_system_taglist.awk`: semantic post-filter for `DOS_SystemTagList` compare lane.
- `src/decomp/scripts/semantic_filter_exec_call_vector_48.awk`: semantic post-filter for `EXEC_CallVector_48` compare lane.
- `src/decomp/scripts/semantic_filter_parallel_check_ready_stub.awk`: semantic post-filter for `PARALLEL_CheckReadyStub` compare lane.
- `src/decomp/scripts/semantic_filter_unknown2a_stub0.awk`: semantic post-filter for `UNKNOWN2A_Stub0` compare lane.
- `src/decomp/scripts/semantic_filter_parallel_check_ready.awk`: semantic post-filter for `PARALLEL_CheckReady` compare lane.
- `src/decomp/scripts/semantic_filter_parallel_write_char_d0.awk`: semantic post-filter for `PARALLEL_WriteCharD0` compare lane.
- `src/decomp/scripts/semantic_filter_clock_seconds_from_epoch.awk`: semantic post-filter for `CLOCK_SecondsFromEpoch` compare lane.
- `src/decomp/scripts/semantic_filter_clock_check_date_or_seconds_from_epoch.awk`: semantic post-filter for `CLOCK_CheckDateOrSecondsFromEpoch` compare lane.
- `src/decomp/scripts/semantic_filter_parallel_wait_ready.awk`: semantic post-filter for `PARALLEL_WaitReady` compare lane.
- `src/decomp/scripts/semantic_filter_parallel_write_string_loop.awk`: semantic post-filter for `PARALLEL_WriteStringLoop` compare lane.
- `src/decomp/scripts/semantic_filter_parallel_raw_dofmt_common.awk`: semantic post-filter for `PARALLEL_RawDoFmtCommon` compare lane.
- `src/decomp/scripts/semantic_filter_parallel_raw_dofmt.awk`: semantic post-filter for `PARALLEL_RawDoFmt` compare lane.
- `src/decomp/scripts/semantic_filter_parallel_write_char_hw.awk`: semantic post-filter for `PARALLEL_WriteCharHw` compare lane.
- `src/decomp/scripts/semantic_filter_parallel_raw_dofmt_stack_args.awk`: semantic post-filter for `PARALLEL_RawDoFmtStackArgs` compare lane.
- `src/decomp/scripts/semantic_filter_dos_open_new_file_if_missing.awk`: semantic post-filter for `DOS_OpenNewFileIfMissing` compare lane.
- `src/decomp/scripts/semantic_filter_dos_open_with_error_state.awk`: semantic post-filter for `DOS_OpenWithErrorState` compare lane.
- `src/decomp/scripts/semantic_filter_dos_delete_and_recreate_file.awk`: semantic post-filter for `DOS_DeleteAndRecreateFile` compare lane.
- `src/decomp/scripts/semantic_filter_dos_read_with_error_state.awk`: semantic post-filter for `DOS_ReadWithErrorState` compare lane.
- `src/decomp/scripts/semantic_filter_dos_seek_with_error_state.awk`: semantic post-filter for `DOS_SeekWithErrorState` compare lane.
- `src/decomp/scripts/semantic_filter_dos_write_with_error_state.awk`: semantic post-filter for `DOS_WriteWithErrorState` compare lane.
- `src/decomp/scripts/semantic_filter_str_append.awk`: semantic post-filter for `STRING_AppendAtNull` compare lane.
- `src/decomp/scripts/semantic_filter_str_append_n.awk`: semantic post-filter for `STRING_AppendN` compare lane.
- `src/decomp/scripts/semantic_filter_str_copy_pad.awk`: semantic post-filter for `STRING_CopyPadNul` compare lane.
- `src/decomp/scripts/semantic_filter_str_compare_n.awk`: semantic post-filter for `STRING_CompareN` compare lane.
- `src/decomp/scripts/semantic_filter_str_compare_nocase.awk`: semantic post-filter for `STRING_CompareNoCase` compare lane.
- `src/decomp/scripts/semantic_filter_str_compare_nocase_n.awk`: semantic post-filter for `STRING_CompareNoCaseN` compare lane.
- `src/decomp/scripts/semantic_filter_str_toupper_inplace.awk`: semantic post-filter for `STRING_ToUpperInPlace` compare lane.
- `src/decomp/scripts/semantic_filter_str_find_char.awk`: semantic post-filter for `STR_FindChar` compare lane.
- `src/decomp/scripts/semantic_filter_str_find_char_ptr.awk`: semantic post-filter for `STR_FindCharPtr` compare lane.
- `src/decomp/scripts/semantic_filter_str_find_any_char_in_set.awk`: semantic post-filter for `STR_FindAnyCharInSet` compare lane.
- `src/decomp/scripts/semantic_filter_str_skip_class3_chars.awk`: semantic post-filter for `STR_SkipClass3Chars` compare lane.
- `src/decomp/scripts/semantic_filter_str_copy_until_any_delim_n.awk`: semantic post-filter for `STR_CopyUntilAnyDelimN` compare lane.
- `src/decomp/scripts/semantic_filter_stream_read_line_with_limit.awk`: semantic post-filter for `STREAM_ReadLineWithLimit` compare lane.
- `src/decomp/scripts/semantic_filter_exec_call_vector_348.awk`: semantic post-filter for `EXEC_CallVector_348` compare lane.
- `src/decomp/scripts/semantic_filter_format_callback_write_char.awk`: semantic post-filter for `FORMAT_CallbackWriteChar` compare lane.
- `src/decomp/scripts/semantic_filter_format_to_callback_buffer.awk`: semantic post-filter for `FORMAT_FormatToCallbackBuffer` compare lane.
- `src/decomp/scripts/semantic_filter_u32oct.awk`: semantic post-filter for `FORMAT_U32ToOctalString` compare lane.
- `src/decomp/scripts/semantic_filter_u32hex.awk`: semantic post-filter for `FORMAT_U32ToHexString` compare lane.
- `src/decomp/scripts/semantic_filter_printf_putc_to_buffer.awk`: semantic post-filter for `UNKNOWN10_PrintfPutcToBuffer` compare lane.
- `src/decomp/scripts/semantic_filter_wdisp_sprintf.awk`: semantic post-filter for `WDISP_SPrintf` compare lane.
- `src/decomp/scripts/semantic_filter_parse_signed_long_nobranch.awk`: semantic post-filter for `PARSE_ReadSignedLong_NoBranch` compare lane.
- `src/decomp/scripts/semantic_filter_struct_free_with_size_field.awk`: semantic post-filter for `STRUCT_FreeWithSizeField` compare lane.
- `src/decomp/scripts/semantic_filter_struct_alloc_with_owner.awk`: semantic post-filter for `STRUCT_AllocWithOwner` compare lane.
- `src/decomp/scripts/promote_memory_target_gcc.sh`: promotion gate for Target 002 GCC lanes (semantic + normalized allowlist + build/hash gates).
- `src/decomp/scripts/promote_clock_target_gcc.sh`: promotion gate for Target 003 GCC lane (canonicalized normalized compare + build/hash gates).
- `src/decomp/scripts/promote_string_toupper_target_gcc.sh`: promotion gate for Target 004 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_mem_move_target_gcc.sh`: promotion gate for Target 005 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_format_u32_decimal_target_gcc.sh`: promotion gate for Target 006 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_list_init_header_target_gcc.sh`: promotion gate for Target 007 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_dos_read_by_index_target_gcc.sh`: promotion gate for Target 008 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_dos_seek_by_index_target_gcc.sh`: promotion gate for Target 009 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_dos_write_by_index_target_gcc.sh`: promotion gate for Target 041 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_handle_get_entry_by_index_target_gcc.sh`: promotion gate for Target 036 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_handle_close_by_index_target_gcc.sh`: promotion gate for Target 067 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_handle_open_with_mode_target_gcc.sh`: promotion gate for Target 068 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_string_find_substring_target_gcc.sh`: promotion gate for Target 069 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_signal_poll_and_dispatch_target_gcc.sh`: promotion gate for Target 070 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parse_read_signed_long_skip_class3_target_gcc.sh`: promotion gate for Target 071 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parse_read_signed_long_skip_class3_alt_target_gcc.sh`: promotion gate for Target 072 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_memlist_free_all_target_gcc.sh`: promotion gate for Target 073 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_memlist_alloc_tracked_target_gcc.sh`: promotion gate for Target 076 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_format_raw_dofmt_with_scratch_buffer_target_gcc.sh`: promotion gate for Target 077 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_main_entry_noop_hook_target_gcc.sh`: promotion gate for Target 078 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_main_exit_noop_hook_target_gcc.sh`: promotion gate for Target 079 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_dos_open_file_with_mode_target_gcc.sh`: promotion gate for Target 080 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_graphics_alloc_raster_target_gcc.sh`: promotion gate for Target 081 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_graphics_free_raster_target_gcc.sh`: promotion gate for Target 082 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_dos_movep_word_read_callback_target_gcc.sh`: promotion gate for Target 083 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_unknown32_jmptbl_esq_return_with_stack_code_target_gcc.sh`: promotion gate for Target 074 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_handle_close_all_and_return_with_code_target_gcc.sh`: promotion gate for Target 075 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_dos_close_with_signal_check_target_gcc.sh`: promotion gate for Target 037 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_iostdreq_free_target_gcc.sh`: promotion gate for Target 038 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_iostdreq_cleanup_signal_and_msgport_target_gcc.sh`: promotion gate for Target 039 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_math_mulu32_target_gcc.sh`: promotion gate for Target 040 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_math_divs32_target_gcc.sh`: promotion gate for Target 043 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_allocate_alloc_and_initialize_iostdreq_target_gcc.sh`: promotion gate for Target 042 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_signal_create_msgport_with_signal_target_gcc.sh`: promotion gate for Target 046 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_dos_delay_target_gcc.sh`: promotion gate for Target 047 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_battclock_get_seconds_target_gcc.sh`: promotion gate for Target 048 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_battclock_write_seconds_target_gcc.sh`: promotion gate for Target 049 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_dos_system_taglist_target_gcc.sh`: promotion gate for Target 050 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_exec_call_vector_48_target_gcc.sh`: promotion gate for Target 051 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parallel_check_ready_stub_target_gcc.sh`: promotion gate for Target 052 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_unknown2a_stub0_target_gcc.sh`: promotion gate for Target 053 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parallel_check_ready_target_gcc.sh`: promotion gate for Target 054 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parallel_write_char_d0_target_gcc.sh`: promotion gate for Target 055 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_clock_seconds_from_epoch_target_gcc.sh`: promotion gate for Target 056 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_clock_check_date_or_seconds_from_epoch_target_gcc.sh`: promotion gate for Target 057 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parallel_wait_ready_target_gcc.sh`: promotion gate for Target 058 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parallel_write_string_loop_target_gcc.sh`: promotion gate for Target 059 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parallel_raw_dofmt_common_target_gcc.sh`: promotion gate for Target 063 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parallel_raw_dofmt_target_gcc.sh`: promotion gate for Target 060 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parallel_write_char_hw_target_gcc.sh`: promotion gate for Target 061 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parallel_raw_dofmt_stack_args_target_gcc.sh`: promotion gate for Target 062 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_dos_open_new_file_if_missing_target_gcc.sh`: promotion gate for Target 044 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_dos_open_with_error_state_target_gcc.sh`: promotion gate for Target 066 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_dos_delete_and_recreate_file_target_gcc.sh`: promotion gate for Target 045 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_dos_read_with_error_state_target_gcc.sh`: promotion gate for Target 033 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_dos_seek_with_error_state_target_gcc.sh`: promotion gate for Target 034 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_dos_write_with_error_state_target_gcc.sh`: promotion gate for Target 032 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_string_append_at_null_target_gcc.sh`: promotion gate for Target 010 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_string_append_n_target_gcc.sh`: promotion gate for Target 011 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_string_copy_pad_nul_target_gcc.sh`: promotion gate for Target 012 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_string_compare_n_target_gcc.sh`: promotion gate for Target 013 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_string_compare_nocase_target_gcc.sh`: promotion gate for Target 014 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_string_compare_nocase_n_target_gcc.sh`: promotion gate for Target 015 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_string_toupper_inplace_target_gcc.sh`: promotion gate for Target 016 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_str_find_char_target_gcc.sh`: promotion gate for Target 017 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_str_find_char_ptr_target_gcc.sh`: promotion gate for Target 018 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_str_find_any_char_in_set_target_gcc.sh`: promotion gate for Target 019 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_str_find_any_char_ptr_target_gcc.sh`: promotion gate for Target 020 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_str_skip_class3_chars_target_gcc.sh`: promotion gate for Target 021 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_str_copy_until_any_delim_n_target_gcc.sh`: promotion gate for Target 030 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_stream_read_line_with_limit_target_gcc.sh`: promotion gate for Target 031 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_exec_call_vector_348_target_gcc.sh`: promotion gate for Target 035 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_format_callback_write_char_target_gcc.sh`: promotion gate for Target 022 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_format_to_callback_buffer_target_gcc.sh`: promotion gate for Target 023 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_format_u32_octal_target_gcc.sh`: promotion gate for Target 024 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_format_u32_hex_target_gcc.sh`: promotion gate for Target 025 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_printf_putc_to_buffer_target_gcc.sh`: promotion gate for Target 026 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_wdisp_sprintf_target_gcc.sh`: promotion gate for Target 027 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parse_read_signed_long_nobranch_target_gcc.sh`: promotion gate for Target 028 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parse_read_signed_long_target_gcc.sh`: promotion gate for Target 029 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_struct_free_with_size_field_target_gcc.sh`: promotion gate for Target 064 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_struct_alloc_with_owner_target_gcc.sh`: promotion gate for Target 065 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/run_all_promotions.sh`: runs all current GCC promotion gates in sequence (stop on first failure).
  - Post-step: runs `src/decomp/scripts/full_compile_all_c_trial.sh` by default (`RUN_FULL_C_TRIAL=1`) as a non-blocking full-C compile lane.
  - Set `STRICT_FULL_C_TRIAL=1` to make full-C trial failure gate the run.
- `src/decomp/scripts/full_compile_all_c_trial.sh`: compiles all `*_gcc.c` replacements in one sweep, attempts relocatable combine, and writes export inventory under `build/decomp/full_c_trial/`.
- `decomp-build.sh`: builds the hybrid output to `build/ESQ_decomp` and reports hash status.

## Workflow
1. Bootstrap a replacement module:
```bash
src/decomp/scripts/new_module_replacement.sh modules/groups/a/a/bitmap.s
```
2. Edit the replacement file under `src/decomp/replacements/...`.
3. Build hybrid output:
```bash
./decomp-build.sh
```
4. Compare hash result to the local baseline (same toolchain/pipeline) and inspect behavior.

`decomp-build.sh` also prints the canonical `test-hash.sh` reference hash for context.

## Notes On C Conversion
The replacement mechanism is module-level today. That keeps the pipeline simple and deterministic while we prove out equivalent output patterns.

When you start converting blocks to C:
- Keep symbol names and calling convention exact.
- Disable optimizer features that perturb control flow until needed.
- Use generated assembly from C as an intermediate artifact, then compare against original assembly block-by-block.

A practical next step is to add one small module replacement where behavior is trivial and validate map/layout stability before deeper conversions.

## Current Snapshot
- Promoted GCC targets: `001` (`xjump`), `002` (`memory`), `003` (`clock wrapper`), `004` (`STRING_ToUpperChar`), `005` (`MEM_Move`), `006` (`FORMAT_U32ToDecimalString`), `007` (`LIST_InitHeader`), `008` (`DOS_ReadByIndex`), `009` (`DOS_SeekByIndex`), `010` (`STRING_AppendAtNull`), `011` (`STRING_AppendN`), `012` (`STRING_CopyPadNul`), `013` (`STRING_CompareN`), `014` (`STRING_CompareNoCase`), `015` (`STRING_CompareNoCaseN`), `016` (`STRING_ToUpperInPlace`), `017` (`STR_FindChar`), `018` (`STR_FindCharPtr`), `019` (`STR_FindAnyCharInSet`), `020` (`STR_FindAnyCharPtr`), `021` (`STR_SkipClass3Chars`), `022` (`FORMAT_CallbackWriteChar`), `023` (`FORMAT_FormatToCallbackBuffer`), `024` (`FORMAT_U32ToOctalString`), `025` (`FORMAT_U32ToHexString`), `026` (`UNKNOWN10_PrintfPutcToBuffer`), `027` (`WDISP_SPrintf`), `028` (`PARSE_ReadSignedLong_NoBranch`), `029` (`PARSE_ReadSignedLong`), `030` (`STR_CopyUntilAnyDelimN`), `031` (`STREAM_ReadLineWithLimit`), `032` (`DOS_WriteWithErrorState`), `033` (`DOS_ReadWithErrorState`), `034` (`DOS_SeekWithErrorState`), `035` (`EXEC_CallVector_348`), `036` (`HANDLE_GetEntryByIndex`), `037` (`DOS_CloseWithSignalCheck`), `038` (`IOSTDREQ_Free`), `039` (`IOSTDREQ_CleanupSignalAndMsgport`), `040` (`MATH_Mulu32`), `041` (`DOS_WriteByIndex`), `042` (`ALLOCATE_AllocAndInitializeIOStdReq`), `043` (`MATH_DivS32`), `044` (`DOS_OpenNewFileIfMissing`), `045` (`DOS_DeleteAndRecreateFile`), `046` (`SIGNAL_CreateMsgPortWithSignal`), `047` (`DOS_Delay`), `048` (`BATTCLOCK_GetSecondsFromBatteryBackedClock`), `049` (`BATTCLOCK_WriteSecondsToBatteryBackedClock`), `050` (`DOS_SystemTagList`), `051` (`EXEC_CallVector_48`), `052` (`PARALLEL_CheckReadyStub`), `053` (`UNKNOWN2A_Stub0`), `054` (`PARALLEL_CheckReady`), `055` (`PARALLEL_WriteCharD0`), `056` (`CLOCK_SecondsFromEpoch`), `057` (`CLOCK_CheckDateOrSecondsFromEpoch`), `058` (`PARALLEL_WaitReady`), `059` (`PARALLEL_WriteStringLoop`), `060` (`PARALLEL_RawDoFmt`), `061` (`PARALLEL_WriteCharHw`), `062` (`PARALLEL_RawDoFmtStackArgs`), `063` (`PARALLEL_RawDoFmtCommon`), `064` (`STRUCT_FreeWithSizeField`), `065` (`STRUCT_AllocWithOwner`), `066` (`DOS_OpenWithErrorState`), `067` (`HANDLE_CloseByIndex`), `068` (`HANDLE_OpenWithMode`), `069` (`STRING_FindSubstring`), `070` (`SIGNAL_PollAndDispatch`), `071` (`PARSE_ReadSignedLongSkipClass3`), `072` (`PARSE_ReadSignedLongSkipClass3_Alt`), `073` (`MEMLIST_FreeAll`), `074` (`UNKNOWN32_JMPTBL_ESQ_ReturnWithStackCode`), `075` (`HANDLE_CloseAllAndReturnWithCode`), `076` (`MEMLIST_AllocTracked`), `077` (`FORMAT_RawDoFmtWithScratchBuffer`), `078` (`ESQ_MainEntryNoOpHook`), `079` (`ESQ_MainExitNoOpHook`), `080` (`DOS_OpenFileWithMode`), `081` (`GRAPHICS_AllocRaster`).
- Canonical build/hash status remains unchanged (`./test-hash.sh` should still match `6bd4760d...e7c2fa2`).
- Current approach is still hybrid: promote small equivalence-proven functions first, then expand to module-level GCC replacement.

Promotion gate commands:
```bash
bash src/decomp/scripts/promote_memory_target_gcc.sh
bash src/decomp/scripts/promote_clock_target_gcc.sh
bash src/decomp/scripts/promote_string_toupper_target_gcc.sh
bash src/decomp/scripts/promote_mem_move_target_gcc.sh
bash src/decomp/scripts/promote_format_u32_decimal_target_gcc.sh
bash src/decomp/scripts/promote_list_init_header_target_gcc.sh
bash src/decomp/scripts/promote_dos_read_by_index_target_gcc.sh
bash src/decomp/scripts/promote_dos_seek_by_index_target_gcc.sh
bash src/decomp/scripts/promote_dos_write_by_index_target_gcc.sh
bash src/decomp/scripts/promote_handle_get_entry_by_index_target_gcc.sh
bash src/decomp/scripts/promote_handle_close_by_index_target_gcc.sh
bash src/decomp/scripts/promote_handle_open_with_mode_target_gcc.sh
bash src/decomp/scripts/promote_string_find_substring_target_gcc.sh
bash src/decomp/scripts/promote_signal_poll_and_dispatch_target_gcc.sh
bash src/decomp/scripts/promote_parse_read_signed_long_skip_class3_target_gcc.sh
bash src/decomp/scripts/promote_parse_read_signed_long_skip_class3_alt_target_gcc.sh
bash src/decomp/scripts/promote_memlist_free_all_target_gcc.sh
bash src/decomp/scripts/promote_memlist_alloc_tracked_target_gcc.sh
bash src/decomp/scripts/promote_format_raw_dofmt_with_scratch_buffer_target_gcc.sh
bash src/decomp/scripts/promote_esq_main_entry_noop_hook_target_gcc.sh
bash src/decomp/scripts/promote_esq_main_exit_noop_hook_target_gcc.sh
bash src/decomp/scripts/promote_dos_open_file_with_mode_target_gcc.sh
bash src/decomp/scripts/promote_graphics_alloc_raster_target_gcc.sh
bash src/decomp/scripts/promote_graphics_free_raster_target_gcc.sh
bash src/decomp/scripts/promote_dos_movep_word_read_callback_target_gcc.sh
bash src/decomp/scripts/promote_unknown32_jmptbl_esq_return_with_stack_code_target_gcc.sh
bash src/decomp/scripts/promote_handle_close_all_and_return_with_code_target_gcc.sh
bash src/decomp/scripts/promote_dos_close_with_signal_check_target_gcc.sh
bash src/decomp/scripts/promote_iostdreq_free_target_gcc.sh
bash src/decomp/scripts/promote_iostdreq_cleanup_signal_and_msgport_target_gcc.sh
bash src/decomp/scripts/promote_math_mulu32_target_gcc.sh
bash src/decomp/scripts/promote_math_divs32_target_gcc.sh
bash src/decomp/scripts/promote_allocate_alloc_and_initialize_iostdreq_target_gcc.sh
bash src/decomp/scripts/promote_signal_create_msgport_with_signal_target_gcc.sh
bash src/decomp/scripts/promote_dos_delay_target_gcc.sh
bash src/decomp/scripts/promote_battclock_get_seconds_target_gcc.sh
bash src/decomp/scripts/promote_battclock_write_seconds_target_gcc.sh
bash src/decomp/scripts/promote_dos_system_taglist_target_gcc.sh
bash src/decomp/scripts/promote_exec_call_vector_48_target_gcc.sh
bash src/decomp/scripts/promote_parallel_check_ready_stub_target_gcc.sh
bash src/decomp/scripts/promote_unknown2a_stub0_target_gcc.sh
bash src/decomp/scripts/promote_parallel_check_ready_target_gcc.sh
bash src/decomp/scripts/promote_parallel_write_char_d0_target_gcc.sh
bash src/decomp/scripts/promote_clock_seconds_from_epoch_target_gcc.sh
bash src/decomp/scripts/promote_clock_check_date_or_seconds_from_epoch_target_gcc.sh
bash src/decomp/scripts/promote_parallel_wait_ready_target_gcc.sh
bash src/decomp/scripts/promote_parallel_write_string_loop_target_gcc.sh
bash src/decomp/scripts/promote_parallel_raw_dofmt_common_target_gcc.sh
bash src/decomp/scripts/promote_parallel_raw_dofmt_target_gcc.sh
bash src/decomp/scripts/promote_parallel_write_char_hw_target_gcc.sh
bash src/decomp/scripts/promote_parallel_raw_dofmt_stack_args_target_gcc.sh
bash src/decomp/scripts/promote_dos_open_new_file_if_missing_target_gcc.sh
bash src/decomp/scripts/promote_dos_open_with_error_state_target_gcc.sh
bash src/decomp/scripts/promote_dos_delete_and_recreate_file_target_gcc.sh
bash src/decomp/scripts/promote_dos_read_with_error_state_target_gcc.sh
bash src/decomp/scripts/promote_dos_seek_with_error_state_target_gcc.sh
bash src/decomp/scripts/promote_dos_write_with_error_state_target_gcc.sh
bash src/decomp/scripts/promote_string_append_at_null_target_gcc.sh
bash src/decomp/scripts/promote_string_append_n_target_gcc.sh
bash src/decomp/scripts/promote_string_copy_pad_nul_target_gcc.sh
bash src/decomp/scripts/promote_string_compare_n_target_gcc.sh
bash src/decomp/scripts/promote_string_compare_nocase_target_gcc.sh
bash src/decomp/scripts/promote_string_compare_nocase_n_target_gcc.sh
bash src/decomp/scripts/promote_string_toupper_inplace_target_gcc.sh
bash src/decomp/scripts/promote_str_find_char_target_gcc.sh
bash src/decomp/scripts/promote_str_find_char_ptr_target_gcc.sh
bash src/decomp/scripts/promote_str_find_any_char_in_set_target_gcc.sh
bash src/decomp/scripts/promote_str_find_any_char_ptr_target_gcc.sh
bash src/decomp/scripts/promote_str_skip_class3_chars_target_gcc.sh
bash src/decomp/scripts/promote_str_copy_until_any_delim_n_target_gcc.sh
bash src/decomp/scripts/promote_stream_read_line_with_limit_target_gcc.sh
bash src/decomp/scripts/promote_exec_call_vector_348_target_gcc.sh
bash src/decomp/scripts/promote_format_callback_write_char_target_gcc.sh
bash src/decomp/scripts/promote_format_to_callback_buffer_target_gcc.sh
bash src/decomp/scripts/promote_format_u32_octal_target_gcc.sh
bash src/decomp/scripts/promote_format_u32_hex_target_gcc.sh
bash src/decomp/scripts/promote_printf_putc_to_buffer_target_gcc.sh
bash src/decomp/scripts/promote_wdisp_sprintf_target_gcc.sh
bash src/decomp/scripts/promote_parse_read_signed_long_nobranch_target_gcc.sh
bash src/decomp/scripts/promote_parse_read_signed_long_target_gcc.sh
bash src/decomp/scripts/promote_struct_free_with_size_field_target_gcc.sh
bash src/decomp/scripts/promote_struct_alloc_with_owner_target_gcc.sh
```

One-command promotion recheck:
```bash
bash src/decomp/scripts/run_all_promotions.sh
```

Full C compile trial only:
```bash
bash src/decomp/scripts/full_compile_all_c_trial.sh
```

Known good GCC profiles by target:
- Target 002: `-O1 -m68000 -ffreestanding -fno-builtin -fno-inline -fno-omit-frame-pointer`
- Target 003: `-O0 -m68000 -ffreestanding -fno-builtin -fno-inline -fomit-frame-pointer`
- Targets 004/005/006/007/008/009/010/011/012/013/014/015/016/017/018/019/020/021/022/023/024/025/026/027/028/029/030/031/032/033/034/035/036/037/038/039/040/041/042/043/044/045/046/047/048/049/050/051/052/053/054/055/056/057/058/059/060/061/062/063/064/065/066/067/068/069/070/071/072/073/074/075/076/077/078/079/080/081/082/083: `-O1 -m68000 -ffreestanding -fno-builtin -fno-inline -fomit-frame-pointer`

## Toolchain Notes
- GCC lanes default to `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc` but honor `CROSS_CC` overrides.
- GCC compare scripts support per-run `GCC_CFLAGS=...` tuning.
- vbcc compare scripts are retained for historical/reference work (`compare_memory_*_trial.sh`, `compare_clock_convert_trial.sh`).
- Current target-by-target status and preferred profiles are tracked in `src/decomp/TARGETS.md`.
