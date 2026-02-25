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
- `src/decomp/scripts/compare_dos_close_with_signal_check_trial_gcc.sh`: GCC-specific compare lane for `Target 037` (`DOS_CloseWithSignalCheck`).
- `src/decomp/scripts/compare_iostdreq_free_trial_gcc.sh`: GCC-specific compare lane for `Target 038` (`IOSTDREQ_Free`).
- `src/decomp/scripts/compare_iostdreq_cleanup_signal_and_msgport_trial_gcc.sh`: GCC-specific compare lane for `Target 039` (`IOSTDREQ_CleanupSignalAndMsgport`).
- `src/decomp/scripts/compare_math_mulu32_trial_gcc.sh`: GCC-specific compare lane for `Target 040` (`MATH_Mulu32`).
- `src/decomp/scripts/compare_math_divs32_trial_gcc.sh`: GCC-specific compare lane for `Target 043` (`MATH_DivS32`).
- `src/decomp/scripts/compare_allocate_alloc_and_initialize_iostdreq_trial_gcc.sh`: GCC-specific compare lane for `Target 042` (`ALLOCATE_AllocAndInitializeIOStdReq`).
- `src/decomp/scripts/compare_dos_open_new_file_if_missing_trial_gcc.sh`: GCC-specific compare lane for `Target 044` (`DOS_OpenNewFileIfMissing`).
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
- `src/decomp/scripts/semantic_filter_memory.awk`: semantic post-filter for memory allocate/deallocate GCC compare lanes.
- `src/decomp/scripts/semantic_filter_toupper.awk`: semantic post-filter for `STRING_ToUpperChar` compare lane.
- `src/decomp/scripts/semantic_filter_memmove.awk`: semantic post-filter for `MEM_Move` compare lane.
- `src/decomp/scripts/semantic_filter_u32dec.awk`: semantic post-filter for `FORMAT_U32ToDecimalString` compare lane.
- `src/decomp/scripts/semantic_filter_list_init.awk`: semantic post-filter for `LIST_InitHeader` compare lane.
- `src/decomp/scripts/semantic_filter_dos_read_idx.awk`: semantic post-filter for `DOS_ReadByIndex` compare lane.
- `src/decomp/scripts/semantic_filter_dos_seek_idx.awk`: semantic post-filter for `DOS_SeekByIndex` compare lane.
- `src/decomp/scripts/semantic_filter_dos_write_by_index.awk`: semantic post-filter for `DOS_WriteByIndex` compare lane.
- `src/decomp/scripts/semantic_filter_handle_get_entry_by_index.awk`: semantic post-filter for `HANDLE_GetEntryByIndex` compare lane.
- `src/decomp/scripts/semantic_filter_dos_close_with_signal_check.awk`: semantic post-filter for `DOS_CloseWithSignalCheck` compare lane.
- `src/decomp/scripts/semantic_filter_iostdreq_free.awk`: semantic post-filter for `IOSTDREQ_Free` compare lane.
- `src/decomp/scripts/semantic_filter_iostdreq_cleanup_signal_and_msgport.awk`: semantic post-filter for `IOSTDREQ_CleanupSignalAndMsgport` compare lane.
- `src/decomp/scripts/semantic_filter_math_mulu32.awk`: semantic post-filter for `MATH_Mulu32` compare lane.
- `src/decomp/scripts/semantic_filter_math_divs32.awk`: semantic post-filter for `MATH_DivS32` compare lane.
- `src/decomp/scripts/semantic_filter_allocate_alloc_and_initialize_iostdreq.awk`: semantic post-filter for `ALLOCATE_AllocAndInitializeIOStdReq` compare lane.
- `src/decomp/scripts/semantic_filter_dos_open_new_file_if_missing.awk`: semantic post-filter for `DOS_OpenNewFileIfMissing` compare lane.
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
- `src/decomp/scripts/promote_dos_close_with_signal_check_target_gcc.sh`: promotion gate for Target 037 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_iostdreq_free_target_gcc.sh`: promotion gate for Target 038 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_iostdreq_cleanup_signal_and_msgport_target_gcc.sh`: promotion gate for Target 039 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_math_mulu32_target_gcc.sh`: promotion gate for Target 040 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_math_divs32_target_gcc.sh`: promotion gate for Target 043 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_allocate_alloc_and_initialize_iostdreq_target_gcc.sh`: promotion gate for Target 042 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_dos_open_new_file_if_missing_target_gcc.sh`: promotion gate for Target 044 GCC lane (semantic + build/hash gates).
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
- `src/decomp/scripts/run_all_promotions.sh`: runs all current GCC promotion gates in sequence (stop on first failure).
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
- Promoted GCC targets: `001` (`xjump`), `002` (`memory`), `003` (`clock wrapper`), `004` (`STRING_ToUpperChar`), `005` (`MEM_Move`), `006` (`FORMAT_U32ToDecimalString`), `007` (`LIST_InitHeader`), `008` (`DOS_ReadByIndex`), `009` (`DOS_SeekByIndex`), `010` (`STRING_AppendAtNull`), `011` (`STRING_AppendN`), `012` (`STRING_CopyPadNul`), `013` (`STRING_CompareN`), `014` (`STRING_CompareNoCase`), `015` (`STRING_CompareNoCaseN`), `016` (`STRING_ToUpperInPlace`), `017` (`STR_FindChar`), `018` (`STR_FindCharPtr`), `019` (`STR_FindAnyCharInSet`), `020` (`STR_FindAnyCharPtr`), `021` (`STR_SkipClass3Chars`), `022` (`FORMAT_CallbackWriteChar`), `023` (`FORMAT_FormatToCallbackBuffer`), `024` (`FORMAT_U32ToOctalString`), `025` (`FORMAT_U32ToHexString`), `026` (`UNKNOWN10_PrintfPutcToBuffer`), `027` (`WDISP_SPrintf`), `028` (`PARSE_ReadSignedLong_NoBranch`), `029` (`PARSE_ReadSignedLong`), `030` (`STR_CopyUntilAnyDelimN`), `031` (`STREAM_ReadLineWithLimit`), `032` (`DOS_WriteWithErrorState`), `033` (`DOS_ReadWithErrorState`), `034` (`DOS_SeekWithErrorState`), `035` (`EXEC_CallVector_348`), `036` (`HANDLE_GetEntryByIndex`), `037` (`DOS_CloseWithSignalCheck`), `038` (`IOSTDREQ_Free`), `039` (`IOSTDREQ_CleanupSignalAndMsgport`), `040` (`MATH_Mulu32`), `041` (`DOS_WriteByIndex`), `042` (`ALLOCATE_AllocAndInitializeIOStdReq`), `043` (`MATH_DivS32`), `044` (`DOS_OpenNewFileIfMissing`), `045` (`DOS_DeleteAndRecreateFile`).
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
bash src/decomp/scripts/promote_dos_close_with_signal_check_target_gcc.sh
bash src/decomp/scripts/promote_iostdreq_free_target_gcc.sh
bash src/decomp/scripts/promote_iostdreq_cleanup_signal_and_msgport_target_gcc.sh
bash src/decomp/scripts/promote_math_mulu32_target_gcc.sh
bash src/decomp/scripts/promote_math_divs32_target_gcc.sh
bash src/decomp/scripts/promote_allocate_alloc_and_initialize_iostdreq_target_gcc.sh
bash src/decomp/scripts/promote_dos_open_new_file_if_missing_target_gcc.sh
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
```

One-command promotion recheck:
```bash
bash src/decomp/scripts/run_all_promotions.sh
```

Known good GCC profiles by target:
- Target 002: `-O1 -m68000 -ffreestanding -fno-builtin -fno-inline -fno-omit-frame-pointer`
- Target 003: `-O0 -m68000 -ffreestanding -fno-builtin -fno-inline -fomit-frame-pointer`
- Targets 004/005/006/007/008/009/010/011/012/013/014/015/016/017/018/019/020/021/022/023/024/025/026/027/028/029/030/031/032/033/034/035/036/037/038/039/040/041/042/043/044/045: `-O1 -m68000 -ffreestanding -fno-builtin -fno-inline -fomit-frame-pointer`

## Toolchain Notes
- GCC lanes default to `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc` but honor `CROSS_CC` overrides.
- GCC compare scripts support per-run `GCC_CFLAGS=...` tuning.
- vbcc compare scripts are retained for historical/reference work (`compare_memory_*_trial.sh`, `compare_clock_convert_trial.sh`).
- Current target-by-target status and preferred profiles are tracked in `src/decomp/TARGETS.md`.
