# Decomp Scaffold

This directory provides an opt-in workflow for replacing assembly modules incrementally while preserving the canonical `src/Prevue.asm` build as the baseline reference.

## Goals
- Keep `./build.sh` and `./test-hash.sh` unchanged and authoritative.
- Allow module-by-module replacement experiments in a separate build output.
- Make hash divergence explicit while conversions are in progress.

## Execution Cadence
- Prioritize non-`*JMPTBL*` exports for primary decomp progress; these carry actual behavior.
- Treat `*JMPTBL*` exports as parallel/backfill work items (useful for coverage, lower reverse-engineering value).
- For each target change, run only its local compare/promote gate first.
- Run `src/decomp/scripts/run_all_promotions.sh` periodically as a regression sweep (not required after every single target).

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
- `src/decomp/scripts/compare_esq_invoke_gcommand_init_trial_gcc.sh`: GCC-specific compare lane for `Target 707` (`ESQ_InvokeGcommandInit`).
- `src/decomp/scripts/compare_esq_try_rom_write_test_trial_gcc.sh`: GCC-specific compare lane for `Target 708` (`ESQ_TryRomWriteTest`).
- `src/decomp/scripts/compare_esq_supervisor_cold_reboot_trial_gcc.sh`: GCC-specific compare lane for `Target 709` (`ESQ_SupervisorColdReboot`).
- `src/decomp/scripts/compare_esq_init_audio1_dma_trial_gcc.sh`: GCC-specific compare lane for `Target 712` (`ESQ_InitAudio1Dma`).
- `src/decomp/scripts/compare_esq_read_serial_rbf_byte_trial_gcc.sh`: GCC-specific compare lane for `Target 713` (`ESQ_ReadSerialRbfByte`).
- `src/decomp/scripts/compare_esq_handle_serial_rbf_interrupt_trial_gcc.sh`: GCC-specific compare lane for `Target 714` (`ESQ_HandleSerialRbfInterrupt`).
- `src/decomp/scripts/compare_esq_capture_ctrl_bit4_stream_buffer_byte_trial_gcc.sh`: GCC-specific compare lane for `Target 715` (`ESQ_CaptureCtrlBit4StreamBufferByte`).
- `src/decomp/scripts/compare_esq_check_topaz_font_guard_trial_gcc.sh`: GCC-specific compare lane for `Target 756` (`ESQ_CheckTopazFontGuard`).
- `src/decomp/scripts/compare_esq_poll_ctrl_input_trial_gcc.sh`: GCC-specific compare lane for `Target 716` (`ESQ_PollCtrlInput`).
- `src/decomp/scripts/compare_esq_set_copper_effect_default_trial_gcc.sh`: GCC-specific compare lane for `Target 717` (`ESQ_SetCopperEffect_Default`).
- `src/decomp/scripts/compare_esq_set_copper_effect_all_on_trial_gcc.sh`: GCC-specific compare lane for `Target 718` (`ESQ_SetCopperEffect_AllOn`).
- `src/decomp/scripts/compare_esq_set_copper_effect_custom_trial_gcc.sh`: GCC-specific compare lane for `Target 719` (`ESQ_SetCopperEffect_Custom`).
- `src/decomp/scripts/compare_esq_set_copper_effect_off_disable_highlight_trial_gcc.sh`: GCC-specific compare lane for `Target 720` (`ESQ_SetCopperEffect_OffDisableHighlight`).
- `src/decomp/scripts/compare_esq_set_copper_effect_on_enable_highlight_trial_gcc.sh`: GCC-specific compare lane for `Target 721` (`ESQ_SetCopperEffect_OnEnableHighlight`).
- `src/decomp/scripts/compare_esq_set_copper_effect_params_trial_gcc.sh`: GCC-specific compare lane for `Target 725` (`ESQ_SetCopperEffectParams`).
- `src/decomp/scripts/compare_esq_update_copper_lists_from_params_trial_gcc.sh`: GCC-specific compare lane for `Target 730` (`ESQ_UpdateCopperListsFromParams`).
- `src/decomp/scripts/compare_esq_dec_color_step_trial_gcc.sh`: GCC-specific compare lane for `Target 726` (`ESQ_DecColorStep`).
- `src/decomp/scripts/compare_esq_bump_color_toward_targets_trial_gcc.sh`: GCC-specific compare lane for `Target 727` (`ESQ_BumpColorTowardTargets`).
- `src/decomp/scripts/compare_esq_move_copper_entry_toward_start_trial_gcc.sh`: GCC-specific compare lane for `Target 728` (`ESQ_MoveCopperEntryTowardStart`).
- `src/decomp/scripts/compare_esq_move_copper_entry_toward_end_trial_gcc.sh`: GCC-specific compare lane for `Target 729` (`ESQ_MoveCopperEntryTowardEnd`).
- `src/decomp/scripts/compare_esq_generate_xor_checksum_byte_trial_gcc.sh`: GCC-specific compare lane for `Target 731` (`ESQ_GenerateXorChecksumByte`).
- `src/decomp/scripts/compare_esq_terminate_after_second_quote_trial_gcc.sh`: GCC-specific compare lane for `Target 732` (`ESQ_TerminateAfterSecondQuote`).
- `src/decomp/scripts/compare_esq_test_bit1_based_trial_gcc.sh`: GCC-specific compare lane for `Target 733` (`ESQ_TestBit1Based`).
- `src/decomp/scripts/compare_esq_set_bit1_based_trial_gcc.sh`: GCC-specific compare lane for `Target 734` (`ESQ_SetBit1Based`).
- `src/decomp/scripts/compare_esq_reverse_bits_in6_bytes_trial_gcc.sh`: GCC-specific compare lane for `Target 735` (`ESQ_ReverseBitsIn6Bytes`).
- `src/decomp/scripts/compare_esq_get_half_hour_slot_index_trial_gcc.sh`: GCC-specific compare lane for `Target 736` (`ESQ_GetHalfHourSlotIndex`).
- `src/decomp/scripts/compare_esq_clamp_banner_char_range_trial_gcc.sh`: GCC-specific compare lane for `Target 737` (`ESQ_ClampBannerCharRange`).
- `src/decomp/scripts/compare_esq_store_ctrl_sample_entry_trial_gcc.sh`: GCC-specific compare lane for `Target 738` (`ESQ_StoreCtrlSampleEntry`).
- `src/decomp/scripts/compare_esq_format_time_stamp_trial_gcc.sh`: GCC-specific compare lane for `Target 739` (`ESQ_FormatTimeStamp`).
- `src/decomp/scripts/compare_esq_calc_day_of_year_from_month_day_trial_gcc.sh`: GCC-specific compare lane for `Target 740` (`ESQ_CalcDayOfYearFromMonthDay`).
- `src/decomp/scripts/compare_esq_update_month_day_from_day_of_year_trial_gcc.sh`: GCC-specific compare lane for `Target 741` (`ESQ_UpdateMonthDayFromDayOfYear`).
- `src/decomp/scripts/compare_esq_write_dec_fixed_width_trial_gcc.sh`: GCC-specific compare lane for `Target 742` (`ESQ_WriteDecFixedWidth`).
- `src/decomp/scripts/compare_esq_pack_bits_decode_trial_gcc.sh`: GCC-specific compare lane for `Target 743` (`ESQ_PackBitsDecode`).
- `src/decomp/scripts/compare_esq_seed_minute_event_thresholds_trial_gcc.sh`: GCC-specific compare lane for `Target 744` (`ESQ_SeedMinuteEventThresholds`).
- `src/decomp/scripts/compare_esq_adjust_bracketed_hour_in_string_trial_gcc.sh`: GCC-specific compare lane for `Target 745` (`ESQ_AdjustBracketedHourInString`).
- `src/decomp/scripts/compare_esq_wildcard_match_trial_gcc.sh`: GCC-specific compare lane for `Target 746` (`ESQ_WildcardMatch`).
- `src/decomp/scripts/compare_esq_find_substring_case_fold_trial_gcc.sh`: GCC-specific compare lane for `Target 747` (`ESQ_FindSubstringCaseFold`).
- `src/decomp/scripts/compare_esq_dec_copper_lists_primary_trial_gcc.sh`: GCC-specific compare lane for `Target 748` (`ESQ_DecCopperListsPrimary`).
- `src/decomp/scripts/compare_esq_inc_copper_lists_towards_targets_trial_gcc.sh`: GCC-specific compare lane for `Target 749` (`ESQ_IncCopperListsTowardsTargets`).
- `src/decomp/scripts/compare_esq_tick_clock_and_flag_events_trial_gcc.sh`: GCC-specific compare lane for `Target 750` (`ESQ_TickClockAndFlagEvents`).
- `src/decomp/scripts/compare_esq_cold_reboot_trial_gcc.sh`: GCC-specific compare lane for `Target 751` (`ESQ_ColdReboot`, `ESQ_ColdRebootViaSupervisor`).
- `src/decomp/scripts/compare_esq_tick_global_counters_trial_gcc.sh`: GCC-specific compare lane for `Target 752` (`ESQ_TickGlobalCounters`).
- `src/decomp/scripts/compare_esq_advance_banner_char_index_return_trial_gcc.sh`: GCC-specific compare lane for `Target 753` (`ESQ_AdvanceBannerCharIndex_Return`).
- `src/decomp/scripts/compare_esq_capture_ctrl_bit3_stream_trial_gcc.sh`: GCC-specific compare lane for `Target 754` (`ESQ_CaptureCtrlBit3Stream`).
- `src/decomp/scripts/compare_esq_capture_ctrl_bit4_stream_trial_gcc.sh`: GCC-specific compare lane for `Target 755` (`ESQ_CaptureCtrlBit4Stream`).
- `src/decomp/scripts/compare_esq_noop_trial_gcc.sh`: GCC-specific compare lane for `Target 722` (`ESQ_NoOp`).
- `src/decomp/scripts/compare_esq_noop_006a_trial_gcc.sh`: GCC-specific compare lane for `Target 723` (`ESQ_NoOp_006A`).
- `src/decomp/scripts/compare_esq_noop_0074_trial_gcc.sh`: GCC-specific compare lane for `Target 724` (`ESQ_NoOp_0074`).
- `src/decomp/scripts/compare_get_bit_3_of_ciab_pra_into_d1_trial_gcc.sh`: GCC-specific compare lane for `Target 710` (`GET_BIT_3_OF_CIAB_PRA_INTO_D1`).
- `src/decomp/scripts/compare_get_bit_4_of_ciab_pra_into_d1_trial_gcc.sh`: GCC-specific compare lane for `Target 711` (`GET_BIT_4_OF_CIAB_PRA_INTO_D1`).
- `src/decomp/scripts/compare_esq_main_exit_noop_hook_trial_gcc.sh`: GCC-specific compare lane for `Target 079` (`ESQ_MainExitNoOpHook`).
- `src/decomp/scripts/compare_dos_open_file_with_mode_trial_gcc.sh`: GCC-specific compare lane for `Target 080` (`DOS_OpenFileWithMode`).
- `src/decomp/scripts/compare_graphics_alloc_raster_trial_gcc.sh`: GCC-specific compare lane for `Target 081` (`GRAPHICS_AllocRaster`).
- `src/decomp/scripts/compare_graphics_free_raster_trial_gcc.sh`: GCC-specific compare lane for `Target 082` (`GRAPHICS_FreeRaster`).
- `src/decomp/scripts/compare_dos_movep_word_read_callback_trial_gcc.sh`: GCC-specific compare lane for `Target 083` (`DOS_MovepWordReadCallback`).
- `src/decomp/scripts/compare_unknown_parse_list_and_update_entries_trial_gcc.sh`: GCC-specific compare lane for `Target 084` (`UNKNOWN_ParseListAndUpdateEntries`).
- `src/decomp/scripts/compare_esqproto_copy_label_to_global_trial_gcc.sh`: GCC-specific compare lane for `Target 590` (`ESQPROTO_CopyLabelToGlobal`).
- `src/decomp/scripts/compare_esqproto_parse_digit_label_and_display_trial_gcc.sh`: GCC-specific compare lane for `Target 591` (`ESQPROTO_ParseDigitLabelAndDisplay`).
- `src/decomp/scripts/compare_unknown_parse_record_and_update_display_trial_gcc.sh`: GCC-specific compare lane for `Target 592` (`UNKNOWN_ParseRecordAndUpdateDisplay`).
- `src/decomp/scripts/compare_esqproto_verify_checksum_and_parse_record_trial_gcc.sh`: GCC-specific compare lane for `Target 593` (`ESQPROTO_VerifyChecksumAndParseRecord`).
- `src/decomp/scripts/compare_esqproto_verify_checksum_and_parse_list_trial_gcc.sh`: GCC-specific compare lane for `Target 594` (`ESQPROTO_VerifyChecksumAndParseList`).
- `src/decomp/scripts/compare_unknown36_finalize_request_trial_gcc.sh`: GCC-specific compare lane for `Target 595` (`UNKNOWN36_FinalizeRequest`).
- `src/decomp/scripts/compare_unknown36_show_abort_requester_trial_gcc.sh`: GCC-specific compare lane for `Target 596` (`UNKNOWN36_ShowAbortRequester`).
- `src/decomp/scripts/compare_handle_open_from_mode_string_trial_gcc.sh`: GCC-specific compare lane for `Target 597` (`HANDLE_OpenFromModeString`).
- `src/decomp/scripts/compare_wdisp_format_with_callback_trial_gcc.sh`: GCC-specific compare lane for `Target 598` (`WDISP_FormatWithCallback`).
- `src/decomp/scripts/compare_handle_open_entry_with_flags_trial_gcc.sh`: GCC-specific compare lane for `Target 599` (`HANDLE_OpenEntryWithFlags`).
- `src/decomp/scripts/compare_buffer_ensure_allocated_trial_gcc.sh`: GCC-specific compare lane for `Target 600` (`BUFFER_EnsureAllocated`).
- `src/decomp/scripts/compare_buffer_flush_all_and_close_with_code_trial_gcc.sh`: GCC-specific compare lane for `Target 601` (`BUFFER_FlushAllAndCloseWithCode`).
- `src/decomp/scripts/compare_graphics_bltbitmaprastport_trial_gcc.sh`: GCC-specific compare lane for `Target 602` (`GRAPHICS_BltBitMapRastPort`).
- `src/decomp/scripts/compare_math_divu32_trial_gcc.sh`: GCC-specific compare lane for `Target 603` (`MATH_DivU32`).
- `src/decomp/scripts/compare_brush_planemaskforindex_trial_gcc.sh`: GCC-specific compare lane for `Target 604` (`BRUSH_PlaneMaskForIndex`).
- `src/decomp/scripts/compare_brush_append_brush_node_trial_gcc.sh`: GCC-specific compare lane for `Target 690` (`BRUSH_AppendBrushNode`).
- `src/decomp/scripts/compare_brush_pop_brush_head_trial_gcc.sh`: GCC-specific compare lane for `Target 691` (`BRUSH_PopBrushHead`).
- `src/decomp/scripts/compare_brush_find_type3_brush_trial_gcc.sh`: GCC-specific compare lane for `Target 692` (`BRUSH_FindType3Brush`).
- `src/decomp/scripts/compare_brush_find_brush_by_predicate_trial_gcc.sh`: GCC-specific compare lane for `Target 693` (`BRUSH_FindBrushByPredicate`).
- `src/decomp/scripts/compare_brush_free_brush_list_return_trial_gcc.sh`: GCC-specific compare lane for `Target 694` (`BRUSH_FreeBrushList_Return`).
- `src/decomp/scripts/compare_brush_select_brush_slot_return_trial_gcc.sh`: GCC-specific compare lane for `Target 695` (`BRUSH_SelectBrushSlot_Return`).
- `src/decomp/scripts/compare_brush_alloc_brush_node_trial_gcc.sh`: GCC-specific compare lane for `Target 696` (`BRUSH_AllocBrushNode`).
- `src/decomp/scripts/compare_brush_free_brush_list_trial_gcc.sh`: GCC-specific compare lane for `Target 697` (`BRUSH_FreeBrushList`).
- `src/decomp/scripts/compare_brush_normalize_brush_names_trial_gcc.sh`: GCC-specific compare lane for `Target 698` (`BRUSH_NormalizeBrushNames`).
- `src/decomp/scripts/compare_brush_select_brush_by_label_trial_gcc.sh`: GCC-specific compare lane for `Target 699` (`BRUSH_SelectBrushByLabel`).
- `src/decomp/scripts/compare_brush_free_brush_resources_trial_gcc.sh`: GCC-specific compare lane for `Target 700` (`BRUSH_FreeBrushResources`).
- `src/decomp/scripts/compare_brush_populate_brush_list_trial_gcc.sh`: GCC-specific compare lane for `Target 701` (`BRUSH_PopulateBrushList`).
- `src/decomp/scripts/compare_brush_stream_font_chunk_trial_gcc.sh`: GCC-specific compare lane for `Target 702` (`BRUSH_StreamFontChunk`).
- `src/decomp/scripts/compare_brush_load_color_text_font_trial_gcc.sh`: GCC-specific compare lane for `Target 703` (`BRUSH_LoadColorTextFont`).
- `src/decomp/scripts/compare_brush_clone_brush_record_trial_gcc.sh`: GCC-specific compare lane for `Target 704` (`BRUSH_CloneBrushRecord`).
- `src/decomp/scripts/compare_brush_select_brush_slot_trial_gcc.sh`: GCC-specific compare lane for `Target 705` (`BRUSH_SelectBrushSlot`).
- `src/decomp/scripts/compare_brush_load_brush_asset_trial_gcc.sh`: GCC-specific compare lane for `Target 706` (`BRUSH_LoadBrushAsset`).
- `src/decomp/scripts/compare_datetime_isleapyear_trial_gcc.sh`: GCC-specific compare lane for `Target 605` (`DATETIME_IsLeapYear`).
- `src/decomp/scripts/compare_datetime_adjust_month_index_trial_gcc.sh`: GCC-specific compare lane for `Target 606` (`DATETIME_AdjustMonthIndex`).
- `src/decomp/scripts/compare_datetime_normalize_month_range_trial_gcc.sh`: GCC-specific compare lane for `Target 607` (`DATETIME_NormalizeMonthRange`).
- `src/decomp/scripts/compare_dst_normalize_day_of_year_trial_gcc.sh`: GCC-specific compare lane for `Target 608` (`DST_NormalizeDayOfYear`).
- `src/decomp/scripts/compare_dst_write_rtc_from_globals_trial_gcc.sh`: GCC-specific compare lane for `Target 609` (`DST_WriteRtcFromGlobals`).
- `src/decomp/scripts/compare_dst_tick_banner_counters_trial_gcc.sh`: GCC-specific compare lane for `Target 610` (`DST_TickBannerCounters`).
- `src/decomp/scripts/compare_dst_build_banner_time_word_trial_gcc.sh`: GCC-specific compare lane for `Target 611` (`DST_BuildBannerTimeWord`).
- `src/decomp/scripts/compare_dst_compute_banner_index_trial_gcc.sh`: GCC-specific compare lane for `Target 612` (`DST_ComputeBannerIndex`).
- `src/decomp/scripts/compare_dst_add_time_offset_trial_gcc.sh`: GCC-specific compare lane for `Target 613` (`DST_AddTimeOffset`).
- `src/decomp/scripts/compare_dst_free_banner_struct_trial_gcc.sh`: GCC-specific compare lane for `Target 614` (`DST_FreeBannerStruct`).
- `src/decomp/scripts/compare_dst_free_banner_pair_trial_gcc.sh`: GCC-specific compare lane for `Target 615` (`DST_FreeBannerPair`).
- `src/decomp/scripts/compare_dst_allocate_banner_struct_trial_gcc.sh`: GCC-specific compare lane for `Target 616` (`DST_AllocateBannerStruct`).
- `src/decomp/scripts/compare_dst_rebuild_banner_pair_trial_gcc.sh`: GCC-specific compare lane for `Target 617` (`DST_RebuildBannerPair`).
- `src/decomp/scripts/compare_dst_load_banner_pair_from_files_trial_gcc.sh`: GCC-specific compare lane for `Target 618` (`DST_LoadBannerPairFromFiles`).
- `src/decomp/scripts/compare_dst_handle_banner_command32_33_trial_gcc.sh`: GCC-specific compare lane for `Target 619` (`DST_HandleBannerCommand32_33`).
- `src/decomp/scripts/compare_dst_format_banner_datetime_trial_gcc.sh`: GCC-specific compare lane for `Target 620` (`DST_FormatBannerDateTime`).
- `src/decomp/scripts/compare_dst_refresh_banner_buffer_trial_gcc.sh`: GCC-specific compare lane for `Target 621` (`DST_RefreshBannerBuffer`).
- `src/decomp/scripts/compare_dst_update_banner_queue_trial_gcc.sh`: GCC-specific compare lane for `Target 622` (`DST_UpdateBannerQueue`).
- `src/decomp/scripts/compare_dst_build_banner_time_entry_trial_gcc.sh`: GCC-specific compare lane for `Target 623` (`DST_BuildBannerTimeEntry`).
- `src/decomp/scripts/compare_esq_parse_command_line_and_run_trial_gcc.sh`: GCC-specific compare lane for `Target 085` (`ESQ_ParseCommandLineAndRun`).
- `src/decomp/scripts/compare_stream_buffered_write_string_trial_gcc.sh`: GCC-specific compare lane for `Target 086` (`STREAM_BufferedWriteString`).
- `src/decomp/scripts/compare_unknown29_jmptbl_esq_main_init_and_run_trial_gcc.sh`: GCC-specific compare lane for `Target 087` (`UNKNOWN29_JMPTBL_ESQ_MainInitAndRun`).
- `src/decomp/scripts/compare_unknown_jmptbl_esqiff2_read_serial_record_into_buffer_trial_gcc.sh`: GCC-specific compare lane for `Target 317` (`UNKNOWN_JMPTBL_ESQIFF2_ReadSerialRecordIntoBuffer`).
- `src/decomp/scripts/compare_unknown_jmptbl_displib_display_text_at_position_trial_gcc.sh`: GCC-specific compare lane for `Target 318` (`UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition`).
- `src/decomp/scripts/compare_unknown_jmptbl_esq_wildcard_match_trial_gcc.sh`: GCC-specific compare lane for `Target 319` (`UNKNOWN_JMPTBL_ESQ_WildcardMatch`).
- `src/decomp/scripts/compare_unknown_jmptbl_dst_normalize_day_of_year_trial_gcc.sh`: GCC-specific compare lane for `Target 320` (`UNKNOWN_JMPTBL_DST_NormalizeDayOfYear`).
- `src/decomp/scripts/compare_unknown_jmptbl_esq_generate_xor_checksum_byte_trial_gcc.sh`: GCC-specific compare lane for `Target 321` (`UNKNOWN_JMPTBL_ESQ_GenerateXorChecksumByte`).
- `src/decomp/scripts/compare_esqproto_jmptbl_esqpars_replace_owned_string_trial_gcc.sh`: GCC-specific compare lane for `Target 322` (`ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString`).
- `src/decomp/scripts/compare_esqshared_jmptbl_dst_build_banner_time_word_trial_gcc.sh`: GCC-specific compare lane for `Target 323` (`ESQSHARED_JMPTBL_DST_BuildBannerTimeWord`).
- `src/decomp/scripts/compare_esqshared_jmptbl_esq_reverse_bits_in6_bytes_trial_gcc.sh`: GCC-specific compare lane for `Target 324` (`ESQSHARED_JMPTBL_ESQ_ReverseBitsIn6Bytes`).
- `src/decomp/scripts/compare_esqshared_jmptbl_esq_set_bit1_based_trial_gcc.sh`: GCC-specific compare lane for `Target 325` (`ESQSHARED_JMPTBL_ESQ_SetBit1Based`).
- `src/decomp/scripts/compare_esqshared_jmptbl_esq_adjust_bracketed_hour_in_string_trial_gcc.sh`: GCC-specific compare lane for `Target 326` (`ESQSHARED_JMPTBL_ESQ_AdjustBracketedHourInString`).
- `src/decomp/scripts/compare_esqshared_jmptbl_coi_ensure_anim_object_allocated_trial_gcc.sh`: GCC-specific compare lane for `Target 327` (`ESQSHARED_JMPTBL_COI_EnsureAnimObjectAllocated`).
- `src/decomp/scripts/compare_esqshared_jmptbl_esq_wildcard_match_trial_gcc.sh`: GCC-specific compare lane for `Target 328` (`ESQSHARED_JMPTBL_ESQ_WildcardMatch`).
- `src/decomp/scripts/compare_esqshared_jmptbl_str_skip_class3_chars_trial_gcc.sh`: GCC-specific compare lane for `Target 329` (`ESQSHARED_JMPTBL_STR_SkipClass3Chars`).
- `src/decomp/scripts/compare_esqshared_jmptbl_esq_test_bit1_based_trial_gcc.sh`: GCC-specific compare lane for `Target 330` (`ESQSHARED_JMPTBL_ESQ_TestBit1Based`).
- `src/decomp/scripts/compare_esqpars_jmptbl_diskio2_flushdatafilesifneeded_trial_gcc.sh`: GCC-specific compare lane for `Target 331` (`ESQPARS_JMPTBL_DISKIO2_FlushDataFilesIfNeeded`).
- `src/decomp/scripts/compare_esqpars_jmptbl_newgrid_rebuildindexcache_trial_gcc.sh`: GCC-specific compare lane for `Target 332` (`ESQPARS_JMPTBL_NEWGRID_RebuildIndexCache`).
- `src/decomp/scripts/compare_esqpars_jmptbl_datetime_savepairtofile_trial_gcc.sh`: GCC-specific compare lane for `Target 333` (`ESQPARS_JMPTBL_DATETIME_SavePairToFile`).
- `src/decomp/scripts/compare_esqpars_jmptbl_esqproto_verifychecksumandparselist_trial_gcc.sh`: GCC-specific compare lane for `Target 334` (`ESQPARS_JMPTBL_ESQPROTO_VerifyChecksumAndParseList`).
- `src/decomp/scripts/compare_esqpars_jmptbl_p_type_parseandstoretyperecord_trial_gcc.sh`: GCC-specific compare lane for `Target 335` (`ESQPARS_JMPTBL_P_TYPE_ParseAndStoreTypeRecord`).
- `src/decomp/scripts/compare_esqpars_jmptbl_esqproto_copylabeltoglobal_trial_gcc.sh`: GCC-specific compare lane for `Target 336` (`ESQPARS_JMPTBL_ESQPROTO_CopyLabelToGlobal`).
- `src/decomp/scripts/compare_esqpars_jmptbl_dst_handlebannercommand32_33_trial_gcc.sh`: GCC-specific compare lane for `Target 337` (`ESQPARS_JMPTBL_DST_HandleBannerCommand32_33`).
- `src/decomp/scripts/compare_esqpars_jmptbl_esq_seedminuteeventthresholds_trial_gcc.sh`: GCC-specific compare lane for `Target 338` (`ESQPARS_JMPTBL_ESQ_SeedMinuteEventThresholds`).
- `src/decomp/scripts/compare_esqpars_jmptbl_parseini_handlefontcommand_trial_gcc.sh`: GCC-specific compare lane for `Target 339` (`ESQPARS_JMPTBL_PARSEINI_HandleFontCommand`).
- `src/decomp/scripts/compare_esqpars_jmptbl_textdisp_applysourceconfigallentries_trial_gcc.sh`: GCC-specific compare lane for `Target 340` (`ESQPARS_JMPTBL_TEXTDISP_ApplySourceConfigAllEntries`).
- `src/decomp/scripts/compare_esqpars_jmptbl_brush_planemaskforindex_trial_gcc.sh`: GCC-specific compare lane for `Target 341` (`ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex`).
- `src/decomp/scripts/compare_esqpars_jmptbl_script_resetctrlcontextandclearstatusline_trial_gcc.sh`: GCC-specific compare lane for `Target 342` (`ESQPARS_JMPTBL_SCRIPT_ResetCtrlContextAndClearStatusLine`).
- `src/decomp/scripts/compare_esqpars_jmptbl_parseini_writertcfromglobals_trial_gcc.sh`: GCC-specific compare lane for `Target 343` (`ESQPARS_JMPTBL_PARSEINI_WriteRtcFromGlobals`).
- `src/decomp/scripts/compare_esqpars_jmptbl_locavail_saveavailabilitydatafile_trial_gcc.sh`: GCC-specific compare lane for `Target 344` (`ESQPARS_JMPTBL_LOCAVAIL_SaveAvailabilityDataFile`).
- `src/decomp/scripts/compare_esqpars_jmptbl_displib_displaytextatposition_trial_gcc.sh`: GCC-specific compare lane for `Target 345` (`ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition`).
- `src/decomp/scripts/compare_esqpars_jmptbl_ladfunc_savetextadstofile_trial_gcc.sh`: GCC-specific compare lane for `Target 346` (`ESQPARS_JMPTBL_LADFUNC_SaveTextAdsToFile`).
- `src/decomp/scripts/compare_esqpars_jmptbl_parse_readsignedlongskipclass3_alt_trial_gcc.sh`: GCC-specific compare lane for `Target 347` (`ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt`).
- `src/decomp/scripts/compare_esqpars_jmptbl_diskio2_handleinteractivefiletransfer_trial_gcc.sh`: GCC-specific compare lane for `Target 348` (`ESQPARS_JMPTBL_DISKIO2_HandleInteractiveFileTransfer`).
- `src/decomp/scripts/compare_esqpars_jmptbl_p_type_writepromoiddatafile_trial_gcc.sh`: GCC-specific compare lane for `Target 349` (`ESQPARS_JMPTBL_P_TYPE_WritePromoIdDataFile`).
- `src/decomp/scripts/compare_esqpars_jmptbl_coi_freeentryresources_trial_gcc.sh`: GCC-specific compare lane for `Target 350` (`ESQPARS_JMPTBL_COI_FreeEntryResources`).
- `src/decomp/scripts/compare_esqpars_jmptbl_dst_updatebannerqueue_trial_gcc.sh`: GCC-specific compare lane for `Target 351` (`ESQPARS_JMPTBL_DST_UpdateBannerQueue`).
- `src/decomp/scripts/compare_esqpars_jmptbl_esqproto_verifychecksumandparserecord_trial_gcc.sh`: GCC-specific compare lane for `Target 352` (`ESQPARS_JMPTBL_ESQPROTO_VerifyChecksumAndParseRecord`).
- `src/decomp/scripts/compare_esqpars_jmptbl_esqproto_parsedigitlabelanddisplay_trial_gcc.sh`: GCC-specific compare lane for `Target 353` (`ESQPARS_JMPTBL_ESQPROTO_ParseDigitLabelAndDisplay`).
- `src/decomp/scripts/compare_esqpars_jmptbl_diskio_parseconfigbuffer_trial_gcc.sh`: GCC-specific compare lane for `Target 354` (`ESQPARS_JMPTBL_DISKIO_ParseConfigBuffer`).
- `src/decomp/scripts/compare_esqpars_jmptbl_cleanup_parsealignedlistingblock_trial_gcc.sh`: GCC-specific compare lane for `Target 355` (`ESQPARS_JMPTBL_CLEANUP_ParseAlignedListingBlock`).
- `src/decomp/scripts/compare_esqpars_jmptbl_script_readserialrbfbyte_trial_gcc.sh`: GCC-specific compare lane for `Target 356` (`ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte`).
- `src/decomp/scripts/compare_esqpars_jmptbl_esq_generatexorchecksumbyte_trial_gcc.sh`: GCC-specific compare lane for `Target 357` (`ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte`).
- `src/decomp/scripts/compare_esqpars_jmptbl_dst_refreshbannerbuffer_trial_gcc.sh`: GCC-specific compare lane for `Target 358` (`ESQPARS_JMPTBL_DST_RefreshBannerBuffer`).
- `src/decomp/scripts/compare_esqpars_jmptbl_diskio_saveconfigtofilehandle_trial_gcc.sh`: GCC-specific compare lane for `Target 359` (`ESQPARS_JMPTBL_DISKIO_SaveConfigToFileHandle`).
- `src/decomp/scripts/compare_ed1_jmptbl_newgrid_drawtopborderline_trial_gcc.sh`: GCC-specific compare lane for `Target 360` (`ED1_JMPTBL_NEWGRID_DrawTopBorderLine`).
- `src/decomp/scripts/compare_ed1_jmptbl_locavail_resetfiltercursorstate_trial_gcc.sh`: GCC-specific compare lane for `Target 361` (`ED1_JMPTBL_LOCAVAIL_ResetFilterCursorState`).
- `src/decomp/scripts/compare_ed1_jmptbl_gcommand_resethighlightmessages_trial_gcc.sh`: GCC-specific compare lane for `Target 362` (`ED1_JMPTBL_GCOMMAND_ResetHighlightMessages`).
- `src/decomp/scripts/compare_ed1_jmptbl_ladfunc_mergehighlownibbles_trial_gcc.sh`: GCC-specific compare lane for `Target 363` (`ED1_JMPTBL_LADFUNC_MergeHighLowNibbles`).
- `src/decomp/scripts/compare_ed1_jmptbl_ladfunc_savetextadstofile_trial_gcc.sh`: GCC-specific compare lane for `Target 364` (`ED1_JMPTBL_LADFUNC_SaveTextAdsToFile`).
- `src/decomp/scripts/compare_ed1_jmptbl_esq_coldreboot_trial_gcc.sh`: GCC-specific compare lane for `Target 365` (`ED1_JMPTBL_ESQ_ColdReboot`).
- `src/decomp/scripts/compare_ed1_jmptbl_esqshared4_loaddefaultpalettetocopper_noop_trial_gcc.sh`: GCC-specific compare lane for `Target 366` (`ED1_JMPTBL_ESQSHARED4_LoadDefaultPaletteToCopper_NoOp`).
- `src/decomp/scripts/compare_ed1_jmptbl_gcommand_seedbannerdefaults_trial_gcc.sh`: GCC-specific compare lane for `Target 367` (`ED1_JMPTBL_GCOMMAND_SeedBannerDefaults`).
- `src/decomp/scripts/compare_ed1_jmptbl_mem_move_trial_gcc.sh`: GCC-specific compare lane for `Target 368` (`ED1_JMPTBL_MEM_Move`).
- `src/decomp/scripts/compare_ed1_jmptbl_gcommand_seedbannerfromprefs_trial_gcc.sh`: GCC-specific compare lane for `Target 369` (`ED1_JMPTBL_GCOMMAND_SeedBannerFromPrefs`).
- `src/decomp/scripts/compare_ed1_jmptbl_cleanup_drawdatetimebannerrow_trial_gcc.sh`: GCC-specific compare lane for `Target 370` (`ED1_JMPTBL_CLEANUP_DrawDateTimeBannerRow`).
- `src/decomp/scripts/compare_ed1_jmptbl_ladfunc_packnibblestobyte_trial_gcc.sh`: GCC-specific compare lane for `Target 371` (`ED1_JMPTBL_LADFUNC_PackNibblesToByte`).
- `src/decomp/scripts/compare_esqfunc_jmptbl_textdisp_setrastformode_trial_gcc.sh`: GCC-specific compare lane for `Target 372` (`ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode`).
- `src/decomp/scripts/compare_esqfunc_jmptbl_p_type_promotesecondarylist_trial_gcc.sh`: GCC-specific compare lane for `Target 373` (`ESQFUNC_JMPTBL_P_TYPE_PromoteSecondaryList`).
- `src/decomp/scripts/compare_esqfunc_jmptbl_diskio_probedrivesandassignpaths_trial_gcc.sh`: GCC-specific compare lane for `Target 374` (`ESQFUNC_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths`).
- `src/decomp/scripts/compare_esqfunc_jmptbl_parseini_updatectrlhdeltamax_trial_gcc.sh`: GCC-specific compare lane for `Target 375` (`ESQFUNC_JMPTBL_PARSEINI_UpdateCtrlHDeltaMax`).
- `src/decomp/scripts/compare_esqfunc_jmptbl_esq_clampbannercharrange_trial_gcc.sh`: GCC-specific compare lane for `Target 376` (`ESQFUNC_JMPTBL_ESQ_ClampBannerCharRange`).
- `src/decomp/scripts/compare_esqfunc_jmptbl_script_readciabbit3flag_trial_gcc.sh`: GCC-specific compare lane for `Target 377` (`ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit3Flag`).
- `src/decomp/scripts/compare_esqfunc_jmptbl_tliba3_drawcenteredwrappedtextlines_trial_gcc.sh`: GCC-specific compare lane for `Target 378` (`ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines`).
- `src/decomp/scripts/compare_esqfunc_jmptbl_script_getctrllineflag_trial_gcc.sh`: GCC-specific compare lane for `Target 379` (`ESQFUNC_JMPTBL_SCRIPT_GetCtrlLineFlag`).
- `src/decomp/scripts/compare_esqfunc_jmptbl_locavail_syncsecondaryfilterforcurrentgroup_trial_gcc.sh`: GCC-specific compare lane for `Target 380` (`ESQFUNC_JMPTBL_LOCAVAIL_SyncSecondaryFilterForCurrentGroup`).
- `src/decomp/scripts/compare_esqfunc_jmptbl_textdisp_resetselectionandrefresh_trial_gcc.sh`: GCC-specific compare lane for `Target 381` (`ESQFUNC_JMPTBL_TEXTDISP_ResetSelectionAndRefresh`).
- `src/decomp/scripts/compare_esqfunc_jmptbl_parseini_monitorclockchange_trial_gcc.sh`: GCC-specific compare lane for `Target 382` (`ESQFUNC_JMPTBL_PARSEINI_MonitorClockChange`).
- `src/decomp/scripts/compare_esqfunc_jmptbl_ladfunc_parsehexdigit_trial_gcc.sh`: GCC-specific compare lane for `Target 383` (`ESQFUNC_JMPTBL_LADFUNC_ParseHexDigit`).
- `src/decomp/scripts/compare_esqfunc_jmptbl_cleanup_processalerts_trial_gcc.sh`: GCC-specific compare lane for `Target 384` (`ESQFUNC_JMPTBL_CLEANUP_ProcessAlerts`).
- `src/decomp/scripts/compare_esqfunc_jmptbl_esq_gethalfhourslotindex_trial_gcc.sh`: GCC-specific compare lane for `Target 385` (`ESQFUNC_JMPTBL_ESQ_GetHalfHourSlotIndex`).
- `src/decomp/scripts/compare_esqfunc_jmptbl_cleanup_drawclockbanner_trial_gcc.sh`: GCC-specific compare lane for `Target 386` (`ESQFUNC_JMPTBL_CLEANUP_DrawClockBanner`).
- `src/decomp/scripts/compare_esqfunc_jmptbl_parseini_computehtcmaxvalues_trial_gcc.sh`: GCC-specific compare lane for `Target 387` (`ESQFUNC_JMPTBL_PARSEINI_ComputeHTCMaxValues`).
- `src/decomp/scripts/compare_esqfunc_jmptbl_ladfunc_updatehighlightstate_trial_gcc.sh`: GCC-specific compare lane for `Target 388` (`ESQFUNC_JMPTBL_LADFUNC_UpdateHighlightState`).
- `src/decomp/scripts/compare_esqfunc_jmptbl_p_type_ensuresecondarylist_trial_gcc.sh`: GCC-specific compare lane for `Target 389` (`ESQFUNC_JMPTBL_P_TYPE_EnsureSecondaryList`).
- `src/decomp/scripts/compare_esqfunc_jmptbl_script_readciabbit5mask_trial_gcc.sh`: GCC-specific compare lane for `Target 390` (`ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit5Mask`).
- `src/decomp/scripts/compare_esqfunc_jmptbl_parseini_normalizeclockdata_trial_gcc.sh`: GCC-specific compare lane for `Target 391` (`ESQFUNC_JMPTBL_PARSEINI_NormalizeClockData`).
- `src/decomp/scripts/compare_esqfunc_jmptbl_esq_tickglobalcounters_trial_gcc.sh`: GCC-specific compare lane for `Target 392` (`ESQFUNC_JMPTBL_ESQ_TickGlobalCounters`).
- `src/decomp/scripts/compare_esqfunc_jmptbl_script_handleserialctrlcmd_trial_gcc.sh`: GCC-specific compare lane for `Target 393` (`ESQFUNC_JMPTBL_SCRIPT_HandleSerialCtrlCmd`).
- `src/decomp/scripts/compare_esqfunc_jmptbl_esq_handleserialrbfinterrupt_trial_gcc.sh`: GCC-specific compare lane for `Target 394` (`ESQFUNC_JMPTBL_ESQ_HandleSerialRbfInterrupt`).
- `src/decomp/scripts/compare_esqfunc_jmptbl_textdisp_tickdisplaystate_trial_gcc.sh`: GCC-specific compare lane for `Target 395` (`ESQFUNC_JMPTBL_TEXTDISP_TickDisplayState`).
- `src/decomp/scripts/compare_esqfunc_jmptbl_esq_pollctrlinput_trial_gcc.sh`: GCC-specific compare lane for `Target 396` (`ESQFUNC_JMPTBL_ESQ_PollCtrlInput`).
- `src/decomp/scripts/compare_esqfunc_jmptbl_locavail_rebuildfilterstatefromcurrentgroup_trial_gcc.sh`: GCC-specific compare lane for `Target 397` (`ESQFUNC_JMPTBL_LOCAVAIL_RebuildFilterStateFromCurrentGroup`).
- `src/decomp/scripts/compare_esqfunc_jmptbl_string_copypadnul_trial_gcc.sh`: GCC-specific compare lane for `Target 398` (`ESQFUNC_JMPTBL_STRING_CopyPadNul`).
- `src/decomp/scripts/compare_esqdisp_jmptbl_newgrid_processgridmessages_trial_gcc.sh`: GCC-specific compare lane for `Target 399` (`ESQDISP_JMPTBL_NEWGRID_ProcessGridMessages`).
- `src/decomp/scripts/compare_esqdisp_jmptbl_graphics_allocraster_trial_gcc.sh`: GCC-specific compare lane for `Target 400` (`ESQDISP_JMPTBL_GRAPHICS_AllocRaster`).
- `src/decomp/scripts/compare_group_ag_jmptbl_memory_deallocate_memory_trial_gcc.sh`: GCC-specific compare lane for `Target 096` (`GROUP_AG_JMPTBL_MEMORY_DeallocateMemory`).
- `src/decomp/scripts/compare_group_ag_jmptbl_memory_allocate_memory_trial_gcc.sh`: GCC-specific compare lane for `Target 097` (`GROUP_AG_JMPTBL_MEMORY_AllocateMemory`).
- `src/decomp/scripts/compare_group_ag_jmptbl_struct_alloc_with_owner_trial_gcc.sh`: GCC-specific compare lane for `Target 098` (`GROUP_AG_JMPTBL_STRUCT_AllocWithOwner`).
- `src/decomp/scripts/compare_group_ag_jmptbl_struct_free_with_size_field_trial_gcc.sh`: GCC-specific compare lane for `Target 099` (`GROUP_AG_JMPTBL_STRUCT_FreeWithSizeField`).
- `src/decomp/scripts/compare_group_ag_jmptbl_math_divs32_trial_gcc.sh`: GCC-specific compare lane for `Target 100` (`GROUP_AG_JMPTBL_MATH_DivS32`).
- `src/decomp/scripts/compare_group_ag_jmptbl_math_mulu32_trial_gcc.sh`: GCC-specific compare lane for `Target 101` (`GROUP_AG_JMPTBL_MATH_Mulu32`).
- `src/decomp/scripts/compare_group_ag_jmptbl_dos_open_file_with_mode_trial_gcc.sh`: GCC-specific compare lane for `Target 102` (`GROUP_AG_JMPTBL_DOS_OpenFileWithMode`).
- `src/decomp/scripts/compare_group_ag_jmptbl_string_copy_pad_nul_trial_gcc.sh`: GCC-specific compare lane for `Target 103` (`GROUP_AG_JMPTBL_STRING_CopyPadNul`).
- `src/decomp/scripts/compare_group_ag_jmptbl_parse_read_signed_long_skip_class3_alt_trial_gcc.sh`: GCC-specific compare lane for `Target 107` (`GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt`).
- `src/decomp/scripts/compare_group_ag_jmptbl_signal_create_msgport_with_signal_trial_gcc.sh`: GCC-specific compare lane for `Target 281` (`GROUP_AG_JMPTBL_SIGNAL_CreateMsgPortWithSignal`).
- `src/decomp/scripts/compare_group_ag_jmptbl_textdisp_reset_selection_and_refresh_trial_gcc.sh`: GCC-specific compare lane for `Target 282` (`GROUP_AG_JMPTBL_TEXTDISP_ResetSelectionAndRefresh`).
- `src/decomp/scripts/compare_group_ag_jmptbl_iostdreq_cleanup_signal_and_msgport_trial_gcc.sh`: GCC-specific compare lane for `Target 283` (`GROUP_AG_JMPTBL_IOSTDREQ_CleanupSignalAndMsgport`).
- `src/decomp/scripts/compare_group_ag_jmptbl_esqfunc_service_ui_tick_if_running_trial_gcc.sh`: GCC-specific compare lane for `Target 284` (`GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning`).
- `src/decomp/scripts/compare_group_ag_jmptbl_script_begin_banner_char_transition_trial_gcc.sh`: GCC-specific compare lane for `Target 285` (`GROUP_AG_JMPTBL_SCRIPT_BeginBannerCharTransition`).
- `src/decomp/scripts/compare_group_ag_jmptbl_ladfunc2_emit_escaped_string_to_scratch_trial_gcc.sh`: GCC-specific compare lane for `Target 286` (`GROUP_AG_JMPTBL_LADFUNC2_EmitEscapedStringToScratch`).
- `src/decomp/scripts/compare_group_ag_jmptbl_script_check_path_exists_trial_gcc.sh`: GCC-specific compare lane for `Target 287` (`GROUP_AG_JMPTBL_SCRIPT_CheckPathExists`).
- `src/decomp/scripts/compare_group_ag_jmptbl_esqfunc_update_refresh_mode_state_trial_gcc.sh`: GCC-specific compare lane for `Target 288` (`GROUP_AG_JMPTBL_ESQFUNC_UpdateRefreshModeState`).
- `src/decomp/scripts/compare_group_am_jmptbl_signal_create_msgport_with_signal_trial_gcc.sh`: GCC-specific compare lane for `Target 104` (`GROUP_AM_JMPTBL_SIGNAL_CreateMsgPortWithSignal`).
- `src/decomp/scripts/compare_group_am_jmptbl_struct_alloc_with_owner_trial_gcc.sh`: GCC-specific compare lane for `Target 105` (`GROUP_AM_JMPTBL_STRUCT_AllocWithOwner`).
- `src/decomp/scripts/compare_group_am_jmptbl_list_init_header_trial_gcc.sh`: GCC-specific compare lane for `Target 106` (`GROUP_AM_JMPTBL_LIST_InitHeader`).
- `src/decomp/scripts/compare_group_am_jmptbl_ladfunc_clear_banner_rect_entries_trial_gcc.sh`: GCC-specific compare lane for `Target 289` (`GROUP_AM_JMPTBL_LADFUNC_ClearBannerRectEntries`).
- `src/decomp/scripts/compare_group_am_jmptbl_parseini_update_clock_from_rtc_trial_gcc.sh`: GCC-specific compare lane for `Target 290` (`GROUP_AM_JMPTBL_PARSEINI_UpdateClockFromRtc`).
- `src/decomp/scripts/compare_group_am_jmptbl_script_init_ctrl_context_trial_gcc.sh`: GCC-specific compare lane for `Target 291` (`GROUP_AM_JMPTBL_SCRIPT_InitCtrlContext`).
- `src/decomp/scripts/compare_group_am_jmptbl_diskio2_parse_ini_file_from_disk_trial_gcc.sh`: GCC-specific compare lane for `Target 292` (`GROUP_AM_JMPTBL_DISKIO2_ParseIniFileFromDisk`).
- `src/decomp/scripts/compare_group_am_jmptbl_esq_check_topaz_font_guard_trial_gcc.sh`: GCC-specific compare lane for `Target 293` (`GROUP_AM_JMPTBL_ESQ_CheckTopazFontGuard`).
- `src/decomp/scripts/compare_group_am_jmptbl_p_type_reset_lists_and_load_promo_ids_trial_gcc.sh`: GCC-specific compare lane for `Target 294` (`GROUP_AM_JMPTBL_P_TYPE_ResetListsAndLoadPromoIds`).
- `src/decomp/scripts/compare_group_am_jmptbl_ladfunc_load_text_ads_from_file_trial_gcc.sh`: GCC-specific compare lane for `Target 295` (`GROUP_AM_JMPTBL_LADFUNC_LoadTextAdsFromFile`).
- `src/decomp/scripts/compare_group_am_jmptbl_diskio_load_config_from_disk_trial_gcc.sh`: GCC-specific compare lane for `Target 296` (`GROUP_AM_JMPTBL_DISKIO_LoadConfigFromDisk`).
- `src/decomp/scripts/compare_group_am_jmptbl_textdisp_load_source_config_trial_gcc.sh`: GCC-specific compare lane for `Target 297` (`GROUP_AM_JMPTBL_TEXTDISP_LoadSourceConfig`).
- `src/decomp/scripts/compare_group_am_jmptbl_kybd_initialize_input_devices_trial_gcc.sh`: GCC-specific compare lane for `Target 298` (`GROUP_AM_JMPTBL_KYBD_InitializeInputDevices`).
- `src/decomp/scripts/compare_group_am_jmptbl_esq_check_compatible_video_chip_trial_gcc.sh`: GCC-specific compare lane for `Target 299` (`GROUP_AM_JMPTBL_ESQ_CheckCompatibleVideoChip`).
- `src/decomp/scripts/compare_group_am_jmptbl_esq_check_available_fast_memory_trial_gcc.sh`: GCC-specific compare lane for `Target 300` (`GROUP_AM_JMPTBL_ESQ_CheckAvailableFastMemory`).
- `src/decomp/scripts/compare_group_am_jmptbl_gcommand_reset_banner_fade_state_trial_gcc.sh`: GCC-specific compare lane for `Target 301` (`GROUP_AM_JMPTBL_GCOMMAND_ResetBannerFadeState`).
- `src/decomp/scripts/compare_group_am_jmptbl_tliba3_init_pattern_table_trial_gcc.sh`: GCC-specific compare lane for `Target 302` (`GROUP_AM_JMPTBL_TLIBA3_InitPatternTable`).
- `src/decomp/scripts/compare_group_am_jmptbl_esq_format_disk_error_message_trial_gcc.sh`: GCC-specific compare lane for `Target 303` (`GROUP_AM_JMPTBL_ESQ_FormatDiskErrorMessage`).
- `src/decomp/scripts/compare_group_am_jmptbl_script_prime_banner_transition_from_hex_code_trial_gcc.sh`: GCC-specific compare lane for `Target 304` (`GROUP_AM_JMPTBL_SCRIPT_PrimeBannerTransitionFromHexCode`).
- `src/decomp/scripts/compare_group_am_jmptbl_locavail_reset_filter_state_struct_trial_gcc.sh`: GCC-specific compare lane for `Target 305` (`GROUP_AM_JMPTBL_LOCAVAIL_ResetFilterStateStruct`).
- `src/decomp/scripts/compare_group_am_jmptbl_esq_init_audio1_dma_trial_gcc.sh`: GCC-specific compare lane for `Target 306` (`GROUP_AM_JMPTBL_ESQ_InitAudio1Dma`).
- `src/decomp/scripts/compare_group_am_jmptbl_esq_set_copper_effect_on_enable_highlight_trial_gcc.sh`: GCC-specific compare lane for `Target 307` (`GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight`).
- `src/decomp/scripts/compare_group_am_jmptbl_locavail_load_availability_data_file_trial_gcc.sh`: GCC-specific compare lane for `Target 308` (`GROUP_AM_JMPTBL_LOCAVAIL_LoadAvailabilityDataFile`).
- `src/decomp/scripts/compare_group_am_jmptbl_gcommand_init_preset_defaults_trial_gcc.sh`: GCC-specific compare lane for `Target 309` (`GROUP_AM_JMPTBL_GCOMMAND_InitPresetDefaults`).
- `src/decomp/scripts/compare_group_am_jmptbl_override_intuition_funcs_trial_gcc.sh`: GCC-specific compare lane for `Target 310` (`GROUP_AM_JMPTBL_OVERRIDE_INTUITION_FUNCS`).
- `src/decomp/scripts/compare_group_am_jmptbl_buffer_flush_all_and_close_with_code_trial_gcc.sh`: GCC-specific compare lane for `Target 311` (`GROUP_AM_JMPTBL_BUFFER_FlushAllAndCloseWithCode`).
- `src/decomp/scripts/compare_group_am_jmptbl_flib2_reset_and_load_listing_templates_trial_gcc.sh`: GCC-specific compare lane for `Target 312` (`GROUP_AM_JMPTBL_FLIB2_ResetAndLoadListingTemplates`).
- `src/decomp/scripts/compare_group_am_jmptbl_wdisp_s_printf_trial_gcc.sh`: GCC-specific compare lane for `Target 313` (`GROUP_AM_JMPTBL_WDISP_SPrintf`).
- `src/decomp/scripts/compare_group_am_jmptbl_esq_set_copper_effect_off_disable_highlight_trial_gcc.sh`: GCC-specific compare lane for `Target 314` (`GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight`).
- `src/decomp/scripts/compare_group_am_jmptbl_cleanup_shutdown_system_trial_gcc.sh`: GCC-specific compare lane for `Target 315` (`GROUP_AM_JMPTBL_CLEANUP_ShutdownSystem`).
- `src/decomp/scripts/compare_group_am_jmptbl_ladfunc_alloc_banner_rect_entries_trial_gcc.sh`: GCC-specific compare lane for `Target 316` (`GROUP_AM_JMPTBL_LADFUNC_AllocBannerRectEntries`).
- `src/decomp/scripts/compare_esqiff_jmptbl_string_compare_nocase_trial_gcc.sh`: GCC-specific compare lane for `Target 108` (`ESQIFF_JMPTBL_STRING_CompareNoCase`).
- `src/decomp/scripts/compare_esqiff_jmptbl_string_compare_n_trial_gcc.sh`: GCC-specific compare lane for `Target 109` (`ESQIFF_JMPTBL_STRING_CompareN`).
- `src/decomp/scripts/compare_esqiff_jmptbl_string_compare_nocase_n_trial_gcc.sh`: GCC-specific compare lane for `Target 110` (`ESQIFF_JMPTBL_STRING_CompareNoCaseN`).
- `src/decomp/scripts/compare_esqiff_jmptbl_math_divs32_trial_gcc.sh`: GCC-specific compare lane for `Target 111` (`ESQIFF_JMPTBL_MATH_DivS32`).
- `src/decomp/scripts/compare_esqiff_jmptbl_esq_noop_trial_gcc.sh`: GCC-specific compare lane for `Target 112` (`ESQIFF_JMPTBL_ESQ_NoOp`).
- `src/decomp/scripts/compare_esqiff_jmptbl_memory_deallocate_memory_trial_gcc.sh`: GCC-specific compare lane for `Target 113` (`ESQIFF_JMPTBL_MEMORY_DeallocateMemory`).
- `src/decomp/scripts/compare_esqiff_jmptbl_esq_noop_006a_trial_gcc.sh`: GCC-specific compare lane for `Target 114` (`ESQIFF_JMPTBL_ESQ_NoOp_006A`).
- `src/decomp/scripts/compare_esqiff_jmptbl_esq_noop_0074_trial_gcc.sh`: GCC-specific compare lane for `Target 115` (`ESQIFF_JMPTBL_ESQ_NoOp_0074`).
- `src/decomp/scripts/compare_esqiff_jmptbl_memory_allocate_memory_trial_gcc.sh`: GCC-specific compare lane for `Target 116` (`ESQIFF_JMPTBL_MEMORY_AllocateMemory`).
- `src/decomp/scripts/compare_esqiff_jmptbl_dos_open_file_with_mode_trial_gcc.sh`: GCC-specific compare lane for `Target 117` (`ESQIFF_JMPTBL_DOS_OpenFileWithMode`).
- `src/decomp/scripts/compare_esqiff_jmptbl_math_mulu32_trial_gcc.sh`: GCC-specific compare lane for `Target 118` (`ESQIFF_JMPTBL_MATH_Mulu32`).
- `src/decomp/scripts/compare_esqiff_jmptbl_diskio_reset_ctrl_input_state_if_idle_trial_gcc.sh`: GCC-specific compare lane for `Target 119` (`ESQIFF_JMPTBL_DISKIO_ResetCtrlInputStateIfIdle`).
- `src/decomp/scripts/compare_esqiff_jmptbl_diskio_get_filesize_from_handle_trial_gcc.sh`: GCC-specific compare lane for `Target 120` (`ESQIFF_JMPTBL_DISKIO_GetFilesizeFromHandle`).
- `src/decomp/scripts/compare_esqiff_jmptbl_diskio_force_ui_refresh_if_idle_trial_gcc.sh`: GCC-specific compare lane for `Target 121` (`ESQIFF_JMPTBL_DISKIO_ForceUiRefreshIfIdle`).
- `src/decomp/scripts/compare_esqiff_jmptbl_esq_inc_copper_lists_towards_targets_trial_gcc.sh`: GCC-specific compare lane for `Target 122` (`ESQIFF_JMPTBL_ESQ_IncCopperListsTowardsTargets`).
- `src/decomp/scripts/compare_esqiff_jmptbl_esq_dec_copper_lists_primary_trial_gcc.sh`: GCC-specific compare lane for `Target 123` (`ESQIFF_JMPTBL_ESQ_DecCopperListsPrimary`).
- `src/decomp/scripts/compare_esqiff_jmptbl_ctasks_start_iff_task_process_trial_gcc.sh`: GCC-specific compare lane for `Target 124` (`ESQIFF_JMPTBL_CTASKS_StartIffTaskProcess`).
- `src/decomp/scripts/compare_esqiff_jmptbl_script_assert_ctrl_line_if_enabled_trial_gcc.sh`: GCC-specific compare lane for `Target 125` (`ESQIFF_JMPTBL_SCRIPT_AssertCtrlLineIfEnabled`).
- `src/decomp/scripts/compare_esqiff_jmptbl_esq_move_copper_entry_toward_start_trial_gcc.sh`: GCC-specific compare lane for `Target 126` (`ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart`).
- `src/decomp/scripts/compare_esqiff_jmptbl_esq_move_copper_entry_toward_end_trial_gcc.sh`: GCC-specific compare lane for `Target 127` (`ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd`).
- `src/decomp/scripts/compare_esqiff_jmptbl_brush_clone_brush_record_trial_gcc.sh`: GCC-specific compare lane for `Target 128` (`ESQIFF_JMPTBL_BRUSH_CloneBrushRecord`).
- `src/decomp/scripts/compare_esqiff_jmptbl_brush_find_type3_brush_trial_gcc.sh`: GCC-specific compare lane for `Target 129` (`ESQIFF_JMPTBL_BRUSH_FindType3Brush`).
- `src/decomp/scripts/compare_esqiff_jmptbl_brush_pop_brush_head_trial_gcc.sh`: GCC-specific compare lane for `Target 130` (`ESQIFF_JMPTBL_BRUSH_PopBrushHead`).
- `src/decomp/scripts/compare_esqiff_jmptbl_brush_alloc_brush_node_trial_gcc.sh`: GCC-specific compare lane for `Target 131` (`ESQIFF_JMPTBL_BRUSH_AllocBrushNode`).
- `src/decomp/scripts/compare_esqiff_jmptbl_brush_find_brush_by_predicate_trial_gcc.sh`: GCC-specific compare lane for `Target 132` (`ESQIFF_JMPTBL_BRUSH_FindBrushByPredicate`).
- `src/decomp/scripts/compare_esqiff_jmptbl_brush_free_brush_list_trial_gcc.sh`: GCC-specific compare lane for `Target 133` (`ESQIFF_JMPTBL_BRUSH_FreeBrushList`).
- `src/decomp/scripts/compare_esqiff_jmptbl_brush_select_brush_by_label_trial_gcc.sh`: GCC-specific compare lane for `Target 134` (`ESQIFF_JMPTBL_BRUSH_SelectBrushByLabel`).
- `src/decomp/scripts/compare_esqiff_jmptbl_textdisp_find_entry_index_by_wildcard_trial_gcc.sh`: GCC-specific compare lane for `Target 135` (`ESQIFF_JMPTBL_TEXTDISP_FindEntryIndexByWildcard`).
- `src/decomp/scripts/compare_esqiff_jmptbl_textdisp_draw_channel_banner_trial_gcc.sh`: GCC-specific compare lane for `Target 136` (`ESQIFF_JMPTBL_TEXTDISP_DrawChannelBanner`).
- `src/decomp/scripts/compare_esqiff_jmptbl_newgrid_validate_selection_code_trial_gcc.sh`: GCC-specific compare lane for `Target 137` (`ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode`).
- `src/decomp/scripts/compare_esqiff_jmptbl_brush_populate_brush_list_trial_gcc.sh`: GCC-specific compare lane for `Target 138` (`ESQIFF_JMPTBL_BRUSH_PopulateBrushList`).
- `src/decomp/scripts/compare_esqiff_jmptbl_script_begin_banner_char_transition_trial_gcc.sh`: GCC-specific compare lane for `Target 139` (`ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition`).
- `src/decomp/scripts/compare_esqiff_jmptbl_tliba3_build_display_context_for_view_mode_trial_gcc.sh`: GCC-specific compare lane for `Target 140` (`ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode`).
- `src/decomp/scripts/compare_esqiff_jmptbl_brush_select_brush_slot_trial_gcc.sh`: GCC-specific compare lane for `Target 141` (`ESQIFF_JMPTBL_BRUSH_SelectBrushSlot`).
- `src/decomp/scripts/compare_group_aw_jmptbl_tliba3_build_display_context_for_view_mode_trial_gcc.sh`: GCC-specific compare lane for `Target 142` (`GROUP_AW_JMPTBL_TLIBA3_BuildDisplayContextForViewMode`).
- `src/decomp/scripts/compare_group_ad_jmptbl_tliba3_build_display_context_for_view_mode_trial_gcc.sh`: GCC-specific compare lane for `Target 143` (`GROUP_AD_JMPTBL_TLIBA3_BuildDisplayContextForViewMode`).
- `src/decomp/scripts/compare_group_aw_jmptbl_mem_move_trial_gcc.sh`: GCC-specific compare lane for `Target 144` (`GROUP_AW_JMPTBL_MEM_Move`).
- `src/decomp/scripts/compare_group_aw_jmptbl_string_copy_pad_nul_trial_gcc.sh`: GCC-specific compare lane for `Target 145` (`GROUP_AW_JMPTBL_STRING_CopyPadNul`).
- `src/decomp/scripts/compare_group_aw_jmptbl_displib_apply_inline_alignment_padding_trial_gcc.sh`: GCC-specific compare lane for `Target 183` (`GROUP_AW_JMPTBL_DISPLIB_ApplyInlineAlignmentPadding`).
- `src/decomp/scripts/compare_group_aw_jmptbl_esqiff_run_copper_rise_transition_trial_gcc.sh`: GCC-specific compare lane for `Target 184` (`GROUP_AW_JMPTBL_ESQIFF_RunCopperRiseTransition`).
- `src/decomp/scripts/compare_group_aw_jmptbl_esqiff_run_copper_drop_transition_trial_gcc.sh`: GCC-specific compare lane for `Target 185` (`GROUP_AW_JMPTBL_ESQIFF_RunCopperDropTransition`).
- `src/decomp/scripts/compare_group_aw_jmptbl_displib_display_text_at_position_trial_gcc.sh`: GCC-specific compare lane for `Target 186` (`GROUP_AW_JMPTBL_DISPLIB_DisplayTextAtPosition`).
- `src/decomp/scripts/compare_group_aw_jmptbl_wdisp_sprintf_trial_gcc.sh`: GCC-specific compare lane for `Target 187` (`GROUP_AW_JMPTBL_WDISP_SPrintf`).
- `src/decomp/scripts/compare_group_aw_jmptbl_esq_set_copper_effect_off_disable_highlight_trial_gcc.sh`: GCC-specific compare lane for `Target 188` (`GROUP_AW_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight`).
- `src/decomp/scripts/compare_group_as_jmptbl_str_find_char_ptr_trial_gcc.sh`: GCC-specific compare lane for `Target 189` (`GROUP_AS_JMPTBL_STR_FindCharPtr`).
- `src/decomp/scripts/compare_group_as_jmptbl_esq_find_substring_case_fold_trial_gcc.sh`: GCC-specific compare lane for `Target 190` (`GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold`).
- `src/decomp/scripts/compare_group_at_jmptbl_ed1_wait_for_flag_and_clear_bit0_trial_gcc.sh`: GCC-specific compare lane for `Target 191` (`GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit0`).
- `src/decomp/scripts/compare_group_at_jmptbl_dos_system_taglist_trial_gcc.sh`: GCC-specific compare lane for `Target 192` (`GROUP_AT_JMPTBL_DOS_SystemTagList`).
- `src/decomp/scripts/compare_group_at_jmptbl_ed1_wait_for_flag_and_clear_bit1_trial_gcc.sh`: GCC-specific compare lane for `Target 193` (`GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit1`).
- `src/decomp/scripts/compare_group_au_jmptbl_brush_append_brush_node_trial_gcc.sh`: GCC-specific compare lane for `Target 194` (`GROUP_AU_JMPTBL_BRUSH_AppendBrushNode`).
- `src/decomp/scripts/compare_group_au_jmptbl_brush_populate_brush_list_trial_gcc.sh`: GCC-specific compare lane for `Target 195` (`GROUP_AU_JMPTBL_BRUSH_PopulateBrushList`).
- `src/decomp/scripts/compare_group_ax_jmptbl_format_raw_dofmt_with_scratch_buffer_trial_gcc.sh`: GCC-specific compare lane for `Target 196` (`GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer`).
- `src/decomp/scripts/compare_group_az_jmptbl_esq_cold_reboot_trial_gcc.sh`: GCC-specific compare lane for `Target 197` (`GROUP_AZ_JMPTBL_ESQ_ColdReboot`).
- `src/decomp/scripts/compare_group_aa_jmptbl_gcommand_find_path_separator_trial_gcc.sh`: GCC-specific compare lane for `Target 198` (`GROUP_AA_JMPTBL_GCOMMAND_FindPathSeparator`).
- `src/decomp/scripts/compare_group_aa_jmptbl_graphics_alloc_raster_trial_gcc.sh`: GCC-specific compare lane for `Target 199` (`GROUP_AA_JMPTBL_GRAPHICS_AllocRaster`).
- `src/decomp/scripts/compare_group_af_jmptbl_gcommand_save_brush_result_trial_gcc.sh`: GCC-specific compare lane for `Target 200` (`GROUP_AF_JMPTBL_GCOMMAND_SaveBrushResult`).
- `src/decomp/scripts/compare_group_ai_jmptbl_newgrid_set_selection_markers_trial_gcc.sh`: GCC-specific compare lane for `Target 201` (`GROUP_AI_JMPTBL_NEWGRID_SetSelectionMarkers`).
- `src/decomp/scripts/compare_group_ai_jmptbl_str_find_char_ptr_trial_gcc.sh`: GCC-specific compare lane for `Target 202` (`GROUP_AI_JMPTBL_STR_FindCharPtr`).
- `src/decomp/scripts/compare_group_ai_jmptbl_tliba1_draw_text_with_inset_segments_trial_gcc.sh`: GCC-specific compare lane for `Target 203` (`GROUP_AI_JMPTBL_TLIBA1_DrawTextWithInsetSegments`).
- `src/decomp/scripts/compare_group_ai_jmptbl_format_format_to_buffer2_trial_gcc.sh`: GCC-specific compare lane for `Target 204` (`GROUP_AI_JMPTBL_FORMAT_FormatToBuffer2`).
- `src/decomp/scripts/compare_group_ai_jmptbl_str_skip_class3_chars_trial_gcc.sh`: GCC-specific compare lane for `Target 205` (`GROUP_AI_JMPTBL_STR_SkipClass3Chars`).
- `src/decomp/scripts/compare_group_ai_jmptbl_string_append_at_null_trial_gcc.sh`: GCC-specific compare lane for `Target 206` (`GROUP_AI_JMPTBL_STRING_AppendAtNull`).
- `src/decomp/scripts/compare_group_ai_jmptbl_str_copy_until_any_delim_n_trial_gcc.sh`: GCC-specific compare lane for `Target 207` (`GROUP_AI_JMPTBL_STR_CopyUntilAnyDelimN`).
- `src/decomp/scripts/compare_group_ab_jmptbl_esqpars_remove_group_entry_and_release_strings_trial_gcc.sh`: GCC-specific compare lane for `Target 208` (`GROUP_AB_JMPTBL_ESQPARS_RemoveGroupEntryAndReleaseStrings`).
- `src/decomp/scripts/compare_group_ab_jmptbl_esqfunc_free_line_text_buffers_trial_gcc.sh`: GCC-specific compare lane for `Target 209` (`GROUP_AB_JMPTBL_ESQFUNC_FreeLineTextBuffers`).
- `src/decomp/scripts/compare_group_ab_jmptbl_esqiff_deallocate_ads_and_logo_lst_data_trial_gcc.sh`: GCC-specific compare lane for `Target 210` (`GROUP_AB_JMPTBL_ESQIFF_DeallocateAdsAndLogoLstData`).
- `src/decomp/scripts/compare_group_ab_jmptbl_ladfunc_free_banner_rect_entries_trial_gcc.sh`: GCC-specific compare lane for `Target 211` (`GROUP_AB_JMPTBL_LADFUNC_FreeBannerRectEntries`).
- `src/decomp/scripts/compare_group_ab_jmptbl_unknown2_a_stub0_trial_gcc.sh`: GCC-specific compare lane for `Target 212` (`GROUP_AB_JMPTBL_UNKNOWN2A_Stub0`).
- `src/decomp/scripts/compare_group_ab_jmptbl_newgrid_shutdown_grid_resources_trial_gcc.sh`: GCC-specific compare lane for `Target 213` (`GROUP_AB_JMPTBL_NEWGRID_ShutdownGridResources`).
- `src/decomp/scripts/compare_group_ab_jmptbl_locavail_free_resource_chain_trial_gcc.sh`: GCC-specific compare lane for `Target 214` (`GROUP_AB_JMPTBL_LOCAVAIL_FreeResourceChain`).
- `src/decomp/scripts/compare_group_ab_jmptbl_graphics_free_raster_trial_gcc.sh`: GCC-specific compare lane for `Target 215` (`GROUP_AB_JMPTBL_GRAPHICS_FreeRaster`).
- `src/decomp/scripts/compare_group_ab_jmptbl_iostdreq_free_trial_gcc.sh`: GCC-specific compare lane for `Target 216` (`GROUP_AB_JMPTBL_IOSTDREQ_Free`).
- `src/decomp/scripts/compare_group_ab_jmptbl_esqiff2_clear_line_head_tail_by_mode_trial_gcc.sh`: GCC-specific compare lane for `Target 217` (`GROUP_AB_JMPTBL_ESQIFF2_ClearLineHeadTailByMode`).
- `src/decomp/scripts/compare_group_ac_jmptbl_parseini_update_clock_from_rtc_trial_gcc.sh`: GCC-specific compare lane for `Target 218` (`GROUP_AC_JMPTBL_PARSEINI_UpdateClockFromRtc`).
- `src/decomp/scripts/compare_group_ac_jmptbl_esqfunc_draw_diagnostics_screen_trial_gcc.sh`: GCC-specific compare lane for `Target 219` (`GROUP_AC_JMPTBL_ESQFUNC_DrawDiagnosticsScreen`).
- `src/decomp/scripts/compare_group_ac_jmptbl_esqfunc_draw_memory_status_screen_trial_gcc.sh`: GCC-specific compare lane for `Target 220` (`GROUP_AC_JMPTBL_ESQFUNC_DrawMemoryStatusScreen`).
- `src/decomp/scripts/compare_group_ac_jmptbl_script_update_ctrl_state_machine_trial_gcc.sh`: GCC-specific compare lane for `Target 221` (`GROUP_AC_JMPTBL_SCRIPT_UpdateCtrlStateMachine`).
- `src/decomp/scripts/compare_group_ac_jmptbl_gcommand_update_banner_bounds_trial_gcc.sh`: GCC-specific compare lane for `Target 222` (`GROUP_AC_JMPTBL_GCOMMAND_UpdateBannerBounds`).
- `src/decomp/scripts/compare_group_ac_jmptbl_script_update_ctrl_line_timeout_trial_gcc.sh`: GCC-specific compare lane for `Target 223` (`GROUP_AC_JMPTBL_SCRIPT_UpdateCtrlLineTimeout`).
- `src/decomp/scripts/compare_group_ac_jmptbl_script_clear_ctrl_line_if_enabled_trial_gcc.sh`: GCC-specific compare lane for `Target 224` (`GROUP_AC_JMPTBL_SCRIPT_ClearCtrlLineIfEnabled`).
- `src/decomp/scripts/compare_group_ac_jmptbl_esqfunc_free_extra_title_text_pointers_trial_gcc.sh`: GCC-specific compare lane for `Target 225` (`GROUP_AC_JMPTBL_ESQFUNC_FreeExtraTitleTextPointers`).
- `src/decomp/scripts/compare_group_ac_jmptbl_esqdisp_draw_status_banner_trial_gcc.sh`: GCC-specific compare lane for `Target 226` (`GROUP_AC_JMPTBL_ESQDISP_DrawStatusBanner`).
- `src/decomp/scripts/compare_group_ac_jmptbl_dst_update_banner_queue_trial_gcc.sh`: GCC-specific compare lane for `Target 227` (`GROUP_AC_JMPTBL_DST_UpdateBannerQueue`).
- `src/decomp/scripts/compare_group_ac_jmptbl_dst_refresh_banner_buffer_trial_gcc.sh`: GCC-specific compare lane for `Target 228` (`GROUP_AC_JMPTBL_DST_RefreshBannerBuffer`).
- `src/decomp/scripts/compare_group_ac_jmptbl_esqfunc_draw_esc_menu_version_trial_gcc.sh`: GCC-specific compare lane for `Target 229` (`GROUP_AC_JMPTBL_ESQFUNC_DrawEscMenuVersion`).
- `src/decomp/scripts/compare_group_ac_jmptbl_parseini_adjust_hours_to24_hr_format_trial_gcc.sh`: GCC-specific compare lane for `Target 230` (`GROUP_AC_JMPTBL_PARSEINI_AdjustHoursTo24HrFormat`).
- `src/decomp/scripts/compare_group_ae_jmptbl_tliba_find_first_wildcard_match_index_trial_gcc.sh`: GCC-specific compare lane for `Target 231` (`GROUP_AE_JMPTBL_TLIBA_FindFirstWildcardMatchIndex`).
- `src/decomp/scripts/compare_group_ae_jmptbl_script_build_token_index_map_trial_gcc.sh`: GCC-specific compare lane for `Target 232` (`GROUP_AE_JMPTBL_SCRIPT_BuildTokenIndexMap`).
- `src/decomp/scripts/compare_group_ae_jmptbl_esqdisp_get_entry_aux_pointer_by_mode_trial_gcc.sh`: GCC-specific compare lane for `Target 233` (`GROUP_AE_JMPTBL_ESQDISP_GetEntryAuxPointerByMode`).
- `src/decomp/scripts/compare_group_ae_jmptbl_esqdisp_get_entry_pointer_by_mode_trial_gcc.sh`: GCC-specific compare lane for `Target 234` (`GROUP_AE_JMPTBL_ESQDISP_GetEntryPointerByMode`).
- `src/decomp/scripts/compare_group_ae_jmptbl_ladfunc_parse_hex_digit_trial_gcc.sh`: GCC-specific compare lane for `Target 235` (`GROUP_AE_JMPTBL_LADFUNC_ParseHexDigit`).
- `src/decomp/scripts/compare_group_ae_jmptbl_script_deallocate_buffer_array_trial_gcc.sh`: GCC-specific compare lane for `Target 236` (`GROUP_AE_JMPTBL_SCRIPT_DeallocateBufferArray`).
- `src/decomp/scripts/compare_group_ae_jmptbl_wdisp_s_printf_trial_gcc.sh`: GCC-specific compare lane for `Target 237` (`GROUP_AE_JMPTBL_WDISP_SPrintf`).
- `src/decomp/scripts/compare_group_ae_jmptbl_script_allocate_buffer_array_trial_gcc.sh`: GCC-specific compare lane for `Target 238` (`GROUP_AE_JMPTBL_SCRIPT_AllocateBufferArray`).
- `src/decomp/scripts/compare_group_ae_jmptbl_textdisp_compute_time_offset_trial_gcc.sh`: GCC-specific compare lane for `Target 239` (`GROUP_AE_JMPTBL_TEXTDISP_ComputeTimeOffset`).
- `src/decomp/scripts/compare_group_ae_jmptbl_esqpars_replace_owned_string_trial_gcc.sh`: GCC-specific compare lane for `Target 240` (`GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString`).
- `src/decomp/scripts/compare_group_ah_jmptbl_esqiff2_apply_incoming_status_packet_trial_gcc.sh`: GCC-specific compare lane for `Target 241` (`GROUP_AH_JMPTBL_ESQIFF2_ApplyIncomingStatusPacket`).
- `src/decomp/scripts/compare_group_ah_jmptbl_newgrid_rebuild_index_cache_trial_gcc.sh`: GCC-specific compare lane for `Target 242` (`GROUP_AH_JMPTBL_NEWGRID_RebuildIndexCache`).
- `src/decomp/scripts/compare_group_ah_jmptbl_esqshared_apply_program_title_text_filters_trial_gcc.sh`: GCC-specific compare lane for `Target 243` (`GROUP_AH_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters`).
- `src/decomp/scripts/compare_group_ah_jmptbl_esqdisp_update_status_mask_and_refresh_trial_gcc.sh`: GCC-specific compare lane for `Target 244` (`GROUP_AH_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh`).
- `src/decomp/scripts/compare_group_ah_jmptbl_esqshared_init_entry_defaults_trial_gcc.sh`: GCC-specific compare lane for `Target 245` (`GROUP_AH_JMPTBL_ESQSHARED_InitEntryDefaults`).
- `src/decomp/scripts/compare_group_ah_jmptbl_gcommand_load_ppv_template_trial_gcc.sh`: GCC-specific compare lane for `Target 246` (`GROUP_AH_JMPTBL_GCOMMAND_LoadPPVTemplate`).
- `src/decomp/scripts/compare_group_ah_jmptbl_locavail_save_availability_data_file_trial_gcc.sh`: GCC-specific compare lane for `Target 247` (`GROUP_AH_JMPTBL_LOCAVAIL_SaveAvailabilityDataFile`).
- `src/decomp/scripts/compare_group_ah_jmptbl_gcommand_load_command_file_trial_gcc.sh`: GCC-specific compare lane for `Target 248` (`GROUP_AH_JMPTBL_GCOMMAND_LoadCommandFile`).
- `src/decomp/scripts/compare_group_ah_jmptbl_esq_wildcard_match_trial_gcc.sh`: GCC-specific compare lane for `Target 249` (`GROUP_AH_JMPTBL_ESQ_WildcardMatch`).
- `src/decomp/scripts/compare_group_ah_jmptbl_p_type_write_promo_id_data_file_trial_gcc.sh`: GCC-specific compare lane for `Target 250` (`GROUP_AH_JMPTBL_P_TYPE_WritePromoIdDataFile`).
- `src/decomp/scripts/compare_group_ah_jmptbl_esqfunc_wait_for_clock_change_and_service_ui_trial_gcc.sh`: GCC-specific compare lane for `Target 251` (`GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi`).
- `src/decomp/scripts/compare_group_ah_jmptbl_esq_test_bit1_based_trial_gcc.sh`: GCC-specific compare lane for `Target 252` (`GROUP_AH_JMPTBL_ESQ_TestBit1Based`).
- `src/decomp/scripts/compare_group_ah_jmptbl_esqiff2_show_attention_overlay_trial_gcc.sh`: GCC-specific compare lane for `Target 253` (`GROUP_AH_JMPTBL_ESQIFF2_ShowAttentionOverlay`).
- `src/decomp/scripts/compare_group_ah_jmptbl_str_find_any_char_ptr_trial_gcc.sh`: GCC-specific compare lane for `Target 254` (`GROUP_AH_JMPTBL_STR_FindAnyCharPtr`).
- `src/decomp/scripts/compare_group_ah_jmptbl_gcommand_load_mplex_file_trial_gcc.sh`: GCC-specific compare lane for `Target 255` (`GROUP_AH_JMPTBL_GCOMMAND_LoadMplexFile`).
- `src/decomp/scripts/compare_group_ah_jmptbl_script_read_serial_rbf_byte_trial_gcc.sh`: GCC-specific compare lane for `Target 256` (`GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte`).
- `src/decomp/scripts/compare_group_ah_jmptbl_esqpars_clear_alias_string_pointers_trial_gcc.sh`: GCC-specific compare lane for `Target 257` (`GROUP_AH_JMPTBL_ESQPARS_ClearAliasStringPointers`).
- `src/decomp/scripts/compare_group_ah_jmptbl_parse_read_signed_long_skip_class3_trial_gcc.sh`: GCC-specific compare lane for `Target 258` (`GROUP_AH_JMPTBL_PARSE_ReadSignedLongSkipClass3`).
- `src/decomp/scripts/compare_group_aj_jmptbl_string_find_substring_trial_gcc.sh`: GCC-specific compare lane for `Target 259` (`GROUP_AJ_JMPTBL_STRING_FindSubstring`).
- `src/decomp/scripts/compare_group_aj_jmptbl_format_raw_dofmt_with_scratch_buffer_trial_gcc.sh`: GCC-specific compare lane for `Target 260` (`GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer`).
- `src/decomp/scripts/compare_group_aj_jmptbl_math_div_u32_trial_gcc.sh`: GCC-specific compare lane for `Target 261` (`GROUP_AJ_JMPTBL_MATH_DivU32`).
- `src/decomp/scripts/compare_group_aj_jmptbl_parseini_write_rtc_from_globals_trial_gcc.sh`: GCC-specific compare lane for `Target 262` (`GROUP_AJ_JMPTBL_PARSEINI_WriteRtcFromGlobals`).
- `src/decomp/scripts/compare_group_aj_jmptbl_math_mulu32_trial_gcc.sh`: GCC-specific compare lane for `Target 263` (`GROUP_AJ_JMPTBL_MATH_Mulu32`).
- `src/decomp/scripts/compare_group_ak_jmptbl_script_update_serial_shadow_from_ctrl_byte_trial_gcc.sh`: GCC-specific compare lane for `Target 264` (`GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte`).
- `src/decomp/scripts/compare_group_ak_jmptbl_tliba3_select_next_view_mode_trial_gcc.sh`: GCC-specific compare lane for `Target 265` (`GROUP_AK_JMPTBL_TLIBA3_SelectNextViewMode`).
- `src/decomp/scripts/compare_group_ak_jmptbl_parseini_parse_ini_buffer_and_dispatch_trial_gcc.sh`: GCC-specific compare lane for `Target 266` (`GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch`).
- `src/decomp/scripts/compare_group_ak_jmptbl_textdisp_format_entry_time_for_index_trial_gcc.sh`: GCC-specific compare lane for `Target 267` (`GROUP_AK_JMPTBL_TEXTDISP_FormatEntryTimeForIndex`).
- `src/decomp/scripts/compare_group_ak_jmptbl_gcommand_get_banner_char_trial_gcc.sh`: GCC-specific compare lane for `Target 268` (`GROUP_AK_JMPTBL_GCOMMAND_GetBannerChar`).
- `src/decomp/scripts/compare_group_ak_jmptbl_esqpars_apply_rtc_bytes_and_persist_trial_gcc.sh`: GCC-specific compare lane for `Target 269` (`GROUP_AK_JMPTBL_ESQPARS_ApplyRtcBytesAndPersist`).
- `src/decomp/scripts/compare_group_ak_jmptbl_parseini_write_error_log_entry_trial_gcc.sh`: GCC-specific compare lane for `Target 270` (`GROUP_AK_JMPTBL_PARSEINI_WriteErrorLogEntry`).
- `src/decomp/scripts/compare_group_ak_jmptbl_parseini_scan_logo_directory_trial_gcc.sh`: GCC-specific compare lane for `Target 271` (`GROUP_AK_JMPTBL_PARSEINI_ScanLogoDirectory`).
- `src/decomp/scripts/compare_group_ak_jmptbl_script_deassert_ctrl_line_now_trial_gcc.sh`: GCC-specific compare lane for `Target 272` (`GROUP_AK_JMPTBL_SCRIPT_DeassertCtrlLineNow`).
- `src/decomp/scripts/compare_group_ak_jmptbl_esq_set_copper_effect_default_trial_gcc.sh`: GCC-specific compare lane for `Target 273` (`GROUP_AK_JMPTBL_ESQ_SetCopperEffect_Default`).
- `src/decomp/scripts/compare_group_ak_jmptbl_esq_set_copper_effect_custom_trial_gcc.sh`: GCC-specific compare lane for `Target 274` (`GROUP_AK_JMPTBL_ESQ_SetCopperEffect_Custom`).
- `src/decomp/scripts/compare_group_ak_jmptbl_cleanup_render_aligned_status_screen_trial_gcc.sh`: GCC-specific compare lane for `Target 275` (`GROUP_AK_JMPTBL_CLEANUP_RenderAlignedStatusScreen`).
- `src/decomp/scripts/compare_group_ak_jmptbl_esq_set_copper_effect_all_on_trial_gcc.sh`: GCC-specific compare lane for `Target 401` (`GROUP_AK_JMPTBL_ESQ_SetCopperEffect_AllOn`).
- `src/decomp/scripts/compare_group_ak_jmptbl_script_assert_ctrl_line_now_trial_gcc.sh`: GCC-specific compare lane for `Target 402` (`GROUP_AK_JMPTBL_SCRIPT_AssertCtrlLineNow`).
- `src/decomp/scripts/compare_group_ak_jmptbl_tliba3_draw_view_mode_guides_trial_gcc.sh`: GCC-specific compare lane for `Target 403` (`GROUP_AK_JMPTBL_TLIBA3_DrawViewModeGuides`).
- `src/decomp/scripts/compare_group_ak_jmptbl_gcommand_copy_gfx_to_work_if_available_trial_gcc.sh`: GCC-specific compare lane for `Target 404` (`GROUP_AK_JMPTBL_GCOMMAND_CopyGfxToWorkIfAvailable`).
- `src/decomp/scripts/compare_newgrid2_jmptbl_bevel_draw_bevel_frame_with_top_right_trial_gcc.sh`: GCC-specific compare lane for `Target 405` (`NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight`).
- `src/decomp/scripts/compare_newgrid2_jmptbl_bevel_draw_vertical_bevel_trial_gcc.sh`: GCC-specific compare lane for `Target 406` (`NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevel`).
- `src/decomp/scripts/compare_newgrid2_jmptbl_bevel_draw_bevel_frame_with_top_trial_gcc.sh`: GCC-specific compare lane for `Target 407` (`NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTop`).
- `src/decomp/scripts/compare_newgrid2_jmptbl_bevel_draw_beveled_frame_trial_gcc.sh`: GCC-specific compare lane for `Target 408` (`NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame`).
- `src/decomp/scripts/compare_newgrid2_jmptbl_bevel_draw_vertical_bevel_pair_trial_gcc.sh`: GCC-specific compare lane for `Target 409` (`NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevelPair`).
- `src/decomp/scripts/compare_newgrid2_jmptbl_bevel_draw_horizontal_bevel_trial_gcc.sh`: GCC-specific compare lane for `Target 410` (`NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel`).
- `src/decomp/scripts/compare_newgrid2_jmptbl_coi_select_anim_field_pointer_trial_gcc.sh`: GCC-specific compare lane for `Target 411` (`NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer`).
- `src/decomp/scripts/compare_newgrid2_jmptbl_disptext_set_current_line_index_trial_gcc.sh`: GCC-specific compare lane for `Target 412` (`NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex`).
- `src/decomp/scripts/compare_newgrid2_jmptbl_disptext_layout_and_append_to_buffer_trial_gcc.sh`: GCC-specific compare lane for `Target 413` (`NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer`).
- `src/decomp/scripts/compare_newgrid2_jmptbl_disptext_get_total_line_count_trial_gcc.sh`: GCC-specific compare lane for `Target 414` (`NEWGRID2_JMPTBL_DISPTEXT_GetTotalLineCount`).
- `src/decomp/scripts/compare_newgrid2_jmptbl_tliba_find_first_wildcard_match_index_trial_gcc.sh`: GCC-specific compare lane for `Target 415` (`NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex`).
- `src/decomp/scripts/compare_newgrid2_jmptbl_disptext_build_layout_for_source_trial_gcc.sh`: GCC-specific compare lane for `Target 416` (`NEWGRID2_JMPTBL_DISPTEXT_BuildLayoutForSource`).
- `src/decomp/scripts/compare_newgrid2_jmptbl_esqdisp_get_entry_aux_pointer_by_mode_trial_gcc.sh`: GCC-specific compare lane for `Target 417` (`NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode`).
- `src/decomp/scripts/compare_newgrid2_jmptbl_disptext_layout_source_to_lines_trial_gcc.sh`: GCC-specific compare lane for `Target 418` (`NEWGRID2_JMPTBL_DISPTEXT_LayoutSourceToLines`).
- `src/decomp/scripts/compare_newgrid2_jmptbl_cleanup_update_entry_flag_bytes_trial_gcc.sh`: GCC-specific compare lane for `Target 419` (`NEWGRID2_JMPTBL_CLEANUP_UpdateEntryFlagBytes`).
- `src/decomp/scripts/compare_newgrid2_jmptbl_coi_render_clock_format_entry_variant_trial_gcc.sh`: GCC-specific compare lane for `Target 420` (`NEWGRID2_JMPTBL_COI_RenderClockFormatEntryVariant`).
- `src/decomp/scripts/compare_newgrid2_jmptbl_esqdisp_test_entry_bits0_and2_trial_gcc.sh`: GCC-specific compare lane for `Target 421` (`NEWGRID2_JMPTBL_ESQDISP_TestEntryBits0And2`).
- `src/decomp/scripts/compare_newgrid2_jmptbl_disptext_compute_visible_line_count_trial_gcc.sh`: GCC-specific compare lane for `Target 422` (`NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount`).
- `src/decomp/scripts/compare_newgrid2_jmptbl_esqdisp_get_entry_pointer_by_mode_trial_gcc.sh`: GCC-specific compare lane for `Target 423` (`NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode`).
- `src/decomp/scripts/compare_newgrid2_jmptbl_disptext_render_current_line_trial_gcc.sh`: GCC-specific compare lane for `Target 424` (`NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine`).
- `src/decomp/scripts/compare_newgrid2_jmptbl_coi_process_entry_selection_state_trial_gcc.sh`: GCC-specific compare lane for `Target 425` (`NEWGRID2_JMPTBL_COI_ProcessEntrySelectionState`).
- `src/decomp/scripts/compare_newgrid2_jmptbl_cleanup_format_clock_format_entry_trial_gcc.sh`: GCC-specific compare lane for `Target 426` (`NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry`).
- `src/decomp/scripts/compare_newgrid2_jmptbl_esq_get_half_hour_slot_index_trial_gcc.sh`: GCC-specific compare lane for `Target 427` (`NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex`).
- `src/decomp/scripts/compare_newgrid2_jmptbl_str_skip_class3_chars_trial_gcc.sh`: GCC-specific compare lane for `Target 428` (`NEWGRID2_JMPTBL_STR_SkipClass3Chars`).
- `src/decomp/scripts/compare_newgrid2_jmptbl_string_append_n_trial_gcc.sh`: GCC-specific compare lane for `Target 429` (`NEWGRID2_JMPTBL_STRING_AppendN`).
- `src/decomp/scripts/compare_newgrid2_jmptbl_esqdisp_compute_schedule_offset_for_row_trial_gcc.sh`: GCC-specific compare lane for `Target 430` (`NEWGRID2_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow`).
- `src/decomp/scripts/compare_newgrid2_jmptbl_parse_read_signed_long_skip_class3_alt_trial_gcc.sh`: GCC-specific compare lane for `Target 431` (`NEWGRID2_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt`).
- `src/decomp/scripts/compare_newgrid2_jmptbl_cleanup_test_entry_flag_y_and_bit1_trial_gcc.sh`: GCC-specific compare lane for `Target 432` (`NEWGRID2_JMPTBL_CLEANUP_TestEntryFlagYAndBit1`).
- `src/decomp/scripts/compare_newgrid2_jmptbl_disptext_is_current_line_last_trial_gcc.sh`: GCC-specific compare lane for `Target 433` (`NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast`).
- `src/decomp/scripts/compare_newgrid2_jmptbl_disptext_is_last_line_selected_trial_gcc.sh`: GCC-specific compare lane for `Target 434` (`NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected`).
- `src/decomp/scripts/compare_newgrid2_jmptbl_displib_find_previous_valid_entry_index_trial_gcc.sh`: GCC-specific compare lane for `Target 435` (`NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex`).
- `src/decomp/scripts/compare_newgrid2_jmptbl_disptext_compute_marker_widths_trial_gcc.sh`: GCC-specific compare lane for `Target 436` (`NEWGRID2_JMPTBL_DISPTEXT_ComputeMarkerWidths`).
- `src/decomp/scripts/compare_newgrid2_jmptbl_esq_test_bit1_based_trial_gcc.sh`: GCC-specific compare lane for `Target 437` (`NEWGRID2_JMPTBL_ESQ_TestBit1Based`).
- `src/decomp/scripts/compare_newgrid2_jmptbl_disptext_measure_current_line_length_trial_gcc.sh`: GCC-specific compare lane for `Target 438` (`NEWGRID2_JMPTBL_DISPTEXT_MeasureCurrentLineLength`).
- `src/decomp/scripts/compare_newgrid2_jmptbl_disptext_set_layout_params_trial_gcc.sh`: GCC-specific compare lane for `Target 439` (`NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams`).
- `src/decomp/scripts/compare_newgrid2_jmptbl_disptext_has_multiple_lines_trial_gcc.sh`: GCC-specific compare lane for `Target 440` (`NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines`).
- `src/decomp/scripts/compare_newgrid2_jmptbl_bevel_draw_horizontal_bevel_trial_gcc.sh`: GCC-specific compare lane for `Target 441` (`NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel`).
- `src/decomp/scripts/compare_group_av_jmptbl_allocate_alloc_and_initialize_iostdreq_trial_gcc.sh`: GCC-specific compare lane for `Target 276` (`GROUP_AV_JMPTBL_ALLOCATE_AllocAndInitializeIOStdReq`).
- `src/decomp/scripts/compare_group_av_jmptbl_signal_create_msgport_with_signal_trial_gcc.sh`: GCC-specific compare lane for `Target 277` (`GROUP_AV_JMPTBL_SIGNAL_CreateMsgPortWithSignal`).
- `src/decomp/scripts/compare_group_av_jmptbl_diskio_probe_drives_and_assign_paths_trial_gcc.sh`: GCC-specific compare lane for `Target 278` (`GROUP_AV_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths`).
- `src/decomp/scripts/compare_group_av_jmptbl_esq_invoke_gcommand_init_trial_gcc.sh`: GCC-specific compare lane for `Target 279` (`GROUP_AV_JMPTBL_ESQ_InvokeGcommandInit`).
- `src/decomp/scripts/compare_group_av_jmptbl_exec_call_vector_48_trial_gcc.sh`: GCC-specific compare lane for `Target 280` (`GROUP_AV_JMPTBL_EXEC_CallVector_48`).
- `src/decomp/scripts/compare_group_ad_jmptbl_textdisp_draw_channel_banner_trial_gcc.sh`: GCC-specific compare lane for `Target 146` (`GROUP_AD_JMPTBL_TEXTDISP_DrawChannelBanner`).
- `src/decomp/scripts/compare_group_ad_jmptbl_textdisp_format_entry_time_trial_gcc.sh`: GCC-specific compare lane for `Target 147` (`GROUP_AD_JMPTBL_TEXTDISP_FormatEntryTime`).
- `src/decomp/scripts/compare_group_ad_jmptbl_tliba3_get_view_mode_height_trial_gcc.sh`: GCC-specific compare lane for `Target 148` (`GROUP_AD_JMPTBL_TLIBA3_GetViewModeHeight`).
- `src/decomp/scripts/compare_group_ad_jmptbl_tliba3_get_view_mode_rast_port_trial_gcc.sh`: GCC-specific compare lane for `Target 149` (`GROUP_AD_JMPTBL_TLIBA3_GetViewModeRastPort`).
- `src/decomp/scripts/compare_tliba3_jmptbl_gcommand_applyhighlightflag_trial_gcc.sh`: GCC-specific compare lane for `Target 442` (`TLIBA3_JMPTBL_GCOMMAND_ApplyHighlightFlag`).
- `src/decomp/scripts/compare_tliba2_jmptbl_dst_addtimeoffset_trial_gcc.sh`: GCC-specific compare lane for `Target 443` (`TLIBA2_JMPTBL_DST_AddTimeOffset`).
- `src/decomp/scripts/compare_tliba2_jmptbl_esq_testbit1based_trial_gcc.sh`: GCC-specific compare lane for `Target 444` (`TLIBA2_JMPTBL_ESQ_TestBit1Based`).
- `src/decomp/scripts/compare_tliba1_jmptbl_coi_getanimfieldpointerbymode_trial_gcc.sh`: GCC-specific compare lane for `Target 445` (`TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode`).
- `src/decomp/scripts/compare_tliba1_jmptbl_esqdisp_getentryauxpointerbymode_trial_gcc.sh`: GCC-specific compare lane for `Target 446` (`TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode`).
- `src/decomp/scripts/compare_tliba1_jmptbl_ladfunc_extractlownibble_trial_gcc.sh`: GCC-specific compare lane for `Target 447` (`TLIBA1_JMPTBL_LADFUNC_ExtractLowNibble`).
- `src/decomp/scripts/compare_tliba1_jmptbl_esqdisp_getentrypointerbymode_trial_gcc.sh`: GCC-specific compare lane for `Target 448` (`TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode`).
- `src/decomp/scripts/compare_tliba1_jmptbl_coi_testentrywithintimewindow_trial_gcc.sh`: GCC-specific compare lane for `Target 449` (`TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow`).
- `src/decomp/scripts/compare_tliba1_jmptbl_cleanup_formatclockformatentry_trial_gcc.sh`: GCC-specific compare lane for `Target 450` (`TLIBA1_JMPTBL_CLEANUP_FormatClockFormatEntry`).
- `src/decomp/scripts/compare_tliba1_jmptbl_esqdisp_computescheduleoffsetforrow_trial_gcc.sh`: GCC-specific compare lane for `Target 451` (`TLIBA1_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow`).
- `src/decomp/scripts/compare_tliba1_jmptbl_esq_findsubstringcasefold_trial_gcc.sh`: GCC-specific compare lane for `Target 452` (`TLIBA1_JMPTBL_ESQ_FindSubstringCaseFold`).
- `src/decomp/scripts/compare_tliba1_jmptbl_displib_findpreviousvalidentryindex_trial_gcc.sh`: GCC-specific compare lane for `Target 453` (`TLIBA1_JMPTBL_DISPLIB_FindPreviousValidEntryIndex`).
- `src/decomp/scripts/compare_tliba1_jmptbl_ladfunc_extracthighnibble_trial_gcc.sh`: GCC-specific compare lane for `Target 454` (`TLIBA1_JMPTBL_LADFUNC_ExtractHighNibble`).
- `src/decomp/scripts/compare_parseini2_jmptbl_battclock_getsecondsfrombatterybackedclock_trial_gcc.sh`: GCC-specific compare lane for `Target 455` (`PARSEINI2_JMPTBL_BATTCLOCK_GetSecondsFromBatteryBackedClock`).
- `src/decomp/scripts/compare_parseini2_jmptbl_battclock_writesecondstobatterybackedclock_trial_gcc.sh`: GCC-specific compare lane for `Target 456` (`PARSEINI2_JMPTBL_BATTCLOCK_WriteSecondsToBatteryBackedClock`).
- `src/decomp/scripts/compare_parseini2_jmptbl_datetime_isleapyear_trial_gcc.sh`: GCC-specific compare lane for `Target 457` (`PARSEINI2_JMPTBL_DATETIME_IsLeapYear`).
- `src/decomp/scripts/compare_parseini2_jmptbl_clock_secondsfromepoch_trial_gcc.sh`: GCC-specific compare lane for `Target 458` (`PARSEINI2_JMPTBL_CLOCK_SecondsFromEpoch`).
- `src/decomp/scripts/compare_parseini2_jmptbl_clock_checkdateorsecondsfromepoch_trial_gcc.sh`: GCC-specific compare lane for `Target 459` (`PARSEINI2_JMPTBL_CLOCK_CheckDateOrSecondsFromEpoch`).
- `src/decomp/scripts/compare_parseini2_jmptbl_clock_convertamigasecondstoclockdata_trial_gcc.sh`: GCC-specific compare lane for `Target 460` (`PARSEINI2_JMPTBL_CLOCK_ConvertAmigaSecondsToClockData`).
- `src/decomp/scripts/compare_parseini2_jmptbl_esq_calcdayofyearfrommonthday_trial_gcc.sh`: GCC-specific compare lane for `Target 461` (`PARSEINI2_JMPTBL_ESQ_CalcDayOfYearFromMonthDay`).
- `src/decomp/scripts/compare_script2_jmptbl_esq_capturectrlbit4streambufferbyte_trial_gcc.sh`: GCC-specific compare lane for `Target 462` (`SCRIPT2_JMPTBL_ESQ_CaptureCtrlBit4StreamBufferByte`).
- `src/decomp/scripts/compare_script2_jmptbl_esq_readserialrbfbyte_trial_gcc.sh`: GCC-specific compare lane for `Target 463` (`SCRIPT2_JMPTBL_ESQ_ReadSerialRbfByte`).
- `src/decomp/scripts/compare_p_type_jmptbl_string_findsubstring_trial_gcc.sh`: GCC-specific compare lane for `Target 464` (`P_TYPE_JMPTBL_STRING_FindSubstring`).
- `src/decomp/scripts/compare_textdisp2_jmptbl_locavail_getfilterwindowhalfspan_trial_gcc.sh`: GCC-specific compare lane for `Target 465` (`TEXTDISP2_JMPTBL_LOCAVAIL_GetFilterWindowHalfSpan`).
- `src/decomp/scripts/compare_textdisp2_jmptbl_ladfunc_drawentrypreview_trial_gcc.sh`: GCC-specific compare lane for `Target 466` (`TEXTDISP2_JMPTBL_LADFUNC_DrawEntryPreview`).
- `src/decomp/scripts/compare_textdisp2_jmptbl_esqiff_runpendingcopperanimations_trial_gcc.sh`: GCC-specific compare lane for `Target 467` (`TEXTDISP2_JMPTBL_ESQIFF_RunPendingCopperAnimations`).
- `src/decomp/scripts/compare_textdisp2_jmptbl_esqiff_playnextexternalassetframe_trial_gcc.sh`: GCC-specific compare lane for `Target 468` (`TEXTDISP2_JMPTBL_ESQIFF_PlayNextExternalAssetFrame`).
- `src/decomp/scripts/compare_script_jmptbl_memory_deallocatememory_trial_gcc.sh`: GCC-specific compare lane for `Target 469` (`SCRIPT_JMPTBL_MEMORY_DeallocateMemory`).
- `src/decomp/scripts/compare_script_jmptbl_diskio_writebufferedbytes_trial_gcc.sh`: GCC-specific compare lane for `Target 470` (`SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes`).
- `src/decomp/scripts/compare_script_jmptbl_diskio_closebufferedfileandflush_trial_gcc.sh`: GCC-specific compare lane for `Target 471` (`SCRIPT_JMPTBL_DISKIO_CloseBufferedFileAndFlush`).
- `src/decomp/scripts/compare_script_jmptbl_memory_allocatememory_trial_gcc.sh`: GCC-specific compare lane for `Target 472` (`SCRIPT_JMPTBL_MEMORY_AllocateMemory`).
- `src/decomp/scripts/compare_script_jmptbl_diskio_openfilewithbuffer_trial_gcc.sh`: GCC-specific compare lane for `Target 473` (`SCRIPT_JMPTBL_DISKIO_OpenFileWithBuffer`).
- `src/decomp/scripts/compare_wdisp_jmptbl_esqiff_restorebasepalettetriples_trial_gcc.sh`: GCC-specific compare lane for `Target 474` (`WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples`).
- `src/decomp/scripts/compare_wdisp_jmptbl_esqfunc_trimtexttopixelwidthwordboundary_trial_gcc.sh`: GCC-specific compare lane for `Target 475` (`WDISP_JMPTBL_ESQFUNC_TrimTextToPixelWidthWordBoundary`).
- `src/decomp/scripts/compare_wdisp_jmptbl_gcommand_expandpresetblock_trial_gcc.sh`: GCC-specific compare lane for `Target 476` (`WDISP_JMPTBL_GCOMMAND_ExpandPresetBlock`).
- `src/decomp/scripts/compare_wdisp_jmptbl_esqiff_queueiffbrushload_trial_gcc.sh`: GCC-specific compare lane for `Target 477` (`WDISP_JMPTBL_ESQIFF_QueueIffBrushLoad`).
- `src/decomp/scripts/compare_wdisp_jmptbl_esqiff_runcopperdroptransition_trial_gcc.sh`: GCC-specific compare lane for `Target 478` (`WDISP_JMPTBL_ESQIFF_RunCopperDropTransition`).
- `src/decomp/scripts/compare_wdisp_jmptbl_brush_findbrushbypredicate_trial_gcc.sh`: GCC-specific compare lane for `Target 479` (`WDISP_JMPTBL_BRUSH_FindBrushByPredicate`).
- `src/decomp/scripts/compare_wdisp_jmptbl_brush_freebrushlist_trial_gcc.sh`: GCC-specific compare lane for `Target 480` (`WDISP_JMPTBL_BRUSH_FreeBrushList`).
- `src/decomp/scripts/compare_wdisp_jmptbl_brush_planemaskforindex_trial_gcc.sh`: GCC-specific compare lane for `Target 481` (`WDISP_JMPTBL_BRUSH_PlaneMaskForIndex`).
- `src/decomp/scripts/compare_wdisp_jmptbl_esq_setcoppereffect_onenablehighlight_trial_gcc.sh`: GCC-specific compare lane for `Target 482` (`WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight`).
- `src/decomp/scripts/compare_wdisp_jmptbl_esqiff_renderweatherstatusbrushslice_trial_gcc.sh`: GCC-specific compare lane for `Target 483` (`WDISP_JMPTBL_ESQIFF_RenderWeatherStatusBrushSlice`).
- `src/decomp/scripts/compare_wdisp_jmptbl_brush_selectbrushslot_trial_gcc.sh`: GCC-specific compare lane for `Target 484` (`WDISP_JMPTBL_BRUSH_SelectBrushSlot`).
- `src/decomp/scripts/compare_wdisp_jmptbl_newgrid_drawwrappedtext_trial_gcc.sh`: GCC-specific compare lane for `Target 485` (`WDISP_JMPTBL_NEWGRID_DrawWrappedText`).
- `src/decomp/scripts/compare_wdisp_jmptbl_newgrid_resetrowtable_trial_gcc.sh`: GCC-specific compare lane for `Target 486` (`WDISP_JMPTBL_NEWGRID_ResetRowTable`).
- `src/decomp/scripts/compare_newgrid_jmptbl_math_divs32_trial_gcc.sh`: GCC-specific compare lane for `Target 487` (`NEWGRID_JMPTBL_MATH_DivS32`).
- `src/decomp/scripts/compare_newgrid_jmptbl_datetime_secondstostruct_trial_gcc.sh`: GCC-specific compare lane for `Target 488` (`NEWGRID_JMPTBL_DATETIME_SecondsToStruct`).
- `src/decomp/scripts/compare_newgrid_jmptbl_generate_grid_date_string_trial_gcc.sh`: GCC-specific compare lane for `Target 489` (`NEWGRID_JMPTBL_GENERATE_GRID_DATE_STRING`).
- `src/decomp/scripts/compare_newgrid_jmptbl_memory_deallocatememory_trial_gcc.sh`: GCC-specific compare lane for `Target 490` (`NEWGRID_JMPTBL_MEMORY_DeallocateMemory`).
- `src/decomp/scripts/compare_newgrid_jmptbl_cleanup_drawclockformatlist_trial_gcc.sh`: GCC-specific compare lane for `Target 491` (`NEWGRID_JMPTBL_CLEANUP_DrawClockFormatList`).
- `src/decomp/scripts/compare_newgrid_jmptbl_disptext_freebuffers_trial_gcc.sh`: GCC-specific compare lane for `Target 492` (`NEWGRID_JMPTBL_DISPTEXT_FreeBuffers`).
- `src/decomp/scripts/compare_newgrid_jmptbl_cleanup_drawclockbanner_trial_gcc.sh`: GCC-specific compare lane for `Target 493` (`NEWGRID_JMPTBL_CLEANUP_DrawClockBanner`).
- `src/decomp/scripts/compare_newgrid_jmptbl_memory_allocatememory_trial_gcc.sh`: GCC-specific compare lane for `Target 494` (`NEWGRID_JMPTBL_MEMORY_AllocateMemory`).
- `src/decomp/scripts/compare_newgrid_jmptbl_disptext_initbuffers_trial_gcc.sh`: GCC-specific compare lane for `Target 495` (`NEWGRID_JMPTBL_DISPTEXT_InitBuffers`).
- `src/decomp/scripts/compare_newgrid_jmptbl_cleanup_drawclockformatframe_trial_gcc.sh`: GCC-specific compare lane for `Target 496` (`NEWGRID_JMPTBL_CLEANUP_DrawClockFormatFrame`).
- `src/decomp/scripts/compare_newgrid_jmptbl_datetime_normalizestructtoseconds_trial_gcc.sh`: GCC-specific compare lane for `Target 497` (`NEWGRID_JMPTBL_DATETIME_NormalizeStructToSeconds`).
- `src/decomp/scripts/compare_newgrid_jmptbl_str_copyuntilanydelimn_trial_gcc.sh`: GCC-specific compare lane for `Target 498` (`NEWGRID_JMPTBL_STR_CopyUntilAnyDelimN`).
- `src/decomp/scripts/compare_newgrid_jmptbl_wdisp_updateselectionpreviewpanel_trial_gcc.sh`: GCC-specific compare lane for `Target 499` (`NEWGRID_JMPTBL_WDISP_UpdateSelectionPreviewPanel`).
- `src/decomp/scripts/compare_newgrid_jmptbl_math_mulu32_trial_gcc.sh`: GCC-specific compare lane for `Target 500` (`NEWGRID_JMPTBL_MATH_Mulu32`).
- `src/decomp/scripts/compare_parseini_jmptbl_brush_allocbrushnode_trial_gcc.sh`: GCC-specific compare lane for `Target 501` (`PARSEINI_JMPTBL_BRUSH_AllocBrushNode`).
- `src/decomp/scripts/compare_parseini_jmptbl_brush_freebrushlist_trial_gcc.sh`: GCC-specific compare lane for `Target 502` (`PARSEINI_JMPTBL_BRUSH_FreeBrushList`).
- `src/decomp/scripts/compare_parseini_jmptbl_brush_freebrushresources_trial_gcc.sh`: GCC-specific compare lane for `Target 503` (`PARSEINI_JMPTBL_BRUSH_FreeBrushResources`).
- `src/decomp/scripts/compare_parseini_jmptbl_esqfunc_rebuildpwbrushlistfromtagtablefromtagtable_trial_gcc.sh`: GCC-specific compare lane for `Target 504` (`PARSEINI_JMPTBL_ESQFUNC_RebuildPwBrushListFromTagTableFromTagTable`).
- `src/decomp/scripts/compare_parseini_jmptbl_gcommand_findpathseparator_trial_gcc.sh`: GCC-specific compare lane for `Target 505` (`PARSEINI_JMPTBL_GCOMMAND_FindPathSeparator`).
- `src/decomp/scripts/compare_parseini_jmptbl_diskio_consumelinefromworkbuffer_trial_gcc.sh`: GCC-specific compare lane for `Target 506` (`PARSEINI_JMPTBL_DISKIO_ConsumeLineFromWorkBuffer`).
- `src/decomp/scripts/compare_parseini_jmptbl_diskio2_parseinifilefromdisk_trial_gcc.sh`: GCC-specific compare lane for `Target 507` (`PARSEINI_JMPTBL_DISKIO2_ParseIniFileFromDisk`).
- `src/decomp/scripts/compare_parseini_jmptbl_diskio_loadfiletoworkbuffer_trial_gcc.sh`: GCC-specific compare lane for `Target 508` (`PARSEINI_JMPTBL_DISKIO_LoadFileToWorkBuffer`).
- `src/decomp/scripts/compare_parseini_jmptbl_ed1_drawdiagnosticsscreen_trial_gcc.sh`: GCC-specific compare lane for `Target 509` (`PARSEINI_JMPTBL_ED1_DrawDiagnosticsScreen`).
- `src/decomp/scripts/compare_parseini_jmptbl_ed1_enterescmenu_trial_gcc.sh`: GCC-specific compare lane for `Target 510` (`PARSEINI_JMPTBL_ED1_EnterEscMenu`).
- `src/decomp/scripts/compare_parseini_jmptbl_ed1_exitescmenu_trial_gcc.sh`: GCC-specific compare lane for `Target 511` (`PARSEINI_JMPTBL_ED1_ExitEscMenu`).
- `src/decomp/scripts/compare_parseini_jmptbl_ed1_waitforflagandclearbit0_trial_gcc.sh`: GCC-specific compare lane for `Target 512` (`PARSEINI_JMPTBL_ED1_WaitForFlagAndClearBit0`).
- `src/decomp/scripts/compare_parseini_jmptbl_ed1_waitforflagandclearbit1_trial_gcc.sh`: GCC-specific compare lane for `Target 513` (`PARSEINI_JMPTBL_ED1_WaitForFlagAndClearBit1`).
- `src/decomp/scripts/compare_parseini_jmptbl_esqfunc_drawescmenuversion_trial_gcc.sh`: GCC-specific compare lane for `Target 514` (`PARSEINI_JMPTBL_ESQFUNC_DrawEscMenuVersion`).
- `src/decomp/scripts/compare_parseini_jmptbl_esqiff_queueiffbrushload_trial_gcc.sh`: GCC-specific compare lane for `Target 515` (`PARSEINI_JMPTBL_ESQIFF_QueueIffBrushLoad`).
- `src/decomp/scripts/compare_parseini_jmptbl_esqiff_handlebrushinireloadhotkey_trial_gcc.sh`: GCC-specific compare lane for `Target 516` (`PARSEINI_JMPTBL_ESQIFF_HandleBrushIniReloadHotkey`).
- `src/decomp/scripts/compare_parseini_jmptbl_esqpars_replaceownedstring_trial_gcc.sh`: GCC-specific compare lane for `Target 517` (`PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString`).
- `src/decomp/scripts/compare_parseini_jmptbl_gcommand_initpresettablefrompalette_trial_gcc.sh`: GCC-specific compare lane for `Target 518` (`PARSEINI_JMPTBL_GCOMMAND_InitPresetTableFromPalette`).
- `src/decomp/scripts/compare_parseini_jmptbl_gcommand_validatepresettable_trial_gcc.sh`: GCC-specific compare lane for `Target 519` (`PARSEINI_JMPTBL_GCOMMAND_ValidatePresetTable`).
- `src/decomp/scripts/compare_parseini_jmptbl_handle_openwithmode_trial_gcc.sh`: GCC-specific compare lane for `Target 520` (`PARSEINI_JMPTBL_HANDLE_OpenWithMode`).
- `src/decomp/scripts/compare_parseini_jmptbl_stream_readlinewithlimit_trial_gcc.sh`: GCC-specific compare lane for `Target 521` (`PARSEINI_JMPTBL_STREAM_ReadLineWithLimit`).
- `src/decomp/scripts/compare_parseini_jmptbl_string_appendatnull_trial_gcc.sh`: GCC-specific compare lane for `Target 522` (`PARSEINI_JMPTBL_STRING_AppendAtNull`).
- `src/decomp/scripts/compare_parseini_jmptbl_string_comparenocase_trial_gcc.sh`: GCC-specific compare lane for `Target 523` (`PARSEINI_JMPTBL_STRING_CompareNoCase`).
- `src/decomp/scripts/compare_parseini_jmptbl_string_comparenocasen_trial_gcc.sh`: GCC-specific compare lane for `Target 524` (`PARSEINI_JMPTBL_STRING_CompareNoCaseN`).
- `src/decomp/scripts/compare_parseini_jmptbl_str_findanycharptr_trial_gcc.sh`: GCC-specific compare lane for `Target 525` (`PARSEINI_JMPTBL_STR_FindAnyCharPtr`).
- `src/decomp/scripts/compare_parseini_jmptbl_str_findcharptr_trial_gcc.sh`: GCC-specific compare lane for `Target 526` (`PARSEINI_JMPTBL_STR_FindCharPtr`).
- `src/decomp/scripts/compare_parseini_jmptbl_unknown36_finalizerequest_trial_gcc.sh`: GCC-specific compare lane for `Target 527` (`PARSEINI_JMPTBL_UNKNOWN36_FinalizeRequest`).
- `src/decomp/scripts/compare_parseini_jmptbl_wdisp_sprintf_trial_gcc.sh`: GCC-specific compare lane for `Target 528` (`PARSEINI_JMPTBL_WDISP_SPrintf`).
- `src/decomp/scripts/compare_script3_jmptbl_cleanup_renderalignedstatusscreen_trial_gcc.sh`: GCC-specific compare lane for `Target 529` (`SCRIPT3_JMPTBL_CLEANUP_RenderAlignedStatusScreen`).
- `src/decomp/scripts/compare_script3_jmptbl_locavail_computefilteroffsetforentry_trial_gcc.sh`: GCC-specific compare lane for `Target 530` (`SCRIPT3_JMPTBL_LOCAVAIL_ComputeFilterOffsetForEntry`).
- `src/decomp/scripts/compare_script3_jmptbl_math_mulu32_trial_gcc.sh`: GCC-specific compare lane for `Target 531` (`SCRIPT3_JMPTBL_MATH_Mulu32`).
- `src/decomp/scripts/compare_script3_jmptbl_math_divs32_trial_gcc.sh`: GCC-specific compare lane for `Target 532` (`SCRIPT3_JMPTBL_MATH_DivS32`).
- `src/decomp/scripts/compare_script3_jmptbl_locavail_setfiltermodeandresetstate_trial_gcc.sh`: GCC-specific compare lane for `Target 533` (`SCRIPT3_JMPTBL_LOCAVAIL_SetFilterModeAndResetState`).
- `src/decomp/scripts/compare_script3_jmptbl_string_copypadnul_trial_gcc.sh`: GCC-specific compare lane for `Target 534` (`SCRIPT3_JMPTBL_STRING_CopyPadNul`).
- `src/decomp/scripts/compare_script3_jmptbl_string_comparen_trial_gcc.sh`: GCC-specific compare lane for `Target 535` (`SCRIPT3_JMPTBL_STRING_CompareN`).
- `src/decomp/scripts/compare_script3_jmptbl_esqdisp_updatestatusmaskandrefresh_trial_gcc.sh`: GCC-specific compare lane for `Target 536` (`SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh`).
- `src/decomp/scripts/compare_script3_jmptbl_gcommand_getbannerchar_trial_gcc.sh`: GCC-specific compare lane for `Target 537` (`SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar`).
- `src/decomp/scripts/compare_script3_jmptbl_ladfunc_parsehexdigit_trial_gcc.sh`: GCC-specific compare lane for `Target 538` (`SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit`).
- `src/decomp/scripts/compare_script3_jmptbl_esqpars_applyrtcbytesandpersist_trial_gcc.sh`: GCC-specific compare lane for `Target 539` (`SCRIPT3_JMPTBL_ESQPARS_ApplyRtcBytesAndPersist`).
- `src/decomp/scripts/compare_script3_jmptbl_parse_readsignedlongskipclass3_alt_trial_gcc.sh`: GCC-specific compare lane for `Target 540` (`SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt`).
- `src/decomp/scripts/compare_script3_jmptbl_gcommand_adjustbannercopperoffset_trial_gcc.sh`: GCC-specific compare lane for `Target 541` (`SCRIPT3_JMPTBL_GCOMMAND_AdjustBannerCopperOffset`).
- `src/decomp/scripts/compare_script3_jmptbl_esq_setcoppereffect_custom_trial_gcc.sh`: GCC-specific compare lane for `Target 542` (`SCRIPT3_JMPTBL_ESQ_SetCopperEffect_Custom`).
- `src/decomp/scripts/compare_script3_jmptbl_esqshared_applyprogramtitletextfilters_trial_gcc.sh`: GCC-specific compare lane for `Target 543` (`SCRIPT3_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters`).
- `src/decomp/scripts/compare_script3_jmptbl_locavail_updatefilterstatemachine_trial_gcc.sh`: GCC-specific compare lane for `Target 544` (`SCRIPT3_JMPTBL_LOCAVAIL_UpdateFilterStateMachine`).
- `src/decomp/scripts/compare_parseini_compute_htc_max_values_trial_gcc.sh`: GCC-specific compare lane for `Target 545` (`PARSEINI_ComputeHTCMaxValues`).
- `src/decomp/scripts/compare_parseini_update_ctrl_h_delta_max_trial_gcc.sh`: GCC-specific compare lane for `Target 546` (`PARSEINI_UpdateCtrlHDeltaMax`).
- `src/decomp/scripts/compare_parseini_check_ctrl_h_change_trial_gcc.sh`: GCC-specific compare lane for `Target 547` (`PARSEINI_CheckCtrlHChange`).
- `src/decomp/scripts/compare_parseini_monitor_clock_change_trial_gcc.sh`: GCC-specific compare lane for `Target 548` (`PARSEINI_MonitorClockChange`).
- `src/decomp/scripts/compare_parseini_write_error_log_entry_trial_gcc.sh`: GCC-specific compare lane for `Target 549` (`PARSEINI_WriteErrorLogEntry`).
- `src/decomp/scripts/compare_parseini_test_memory_and_open_topaz_font_trial_gcc.sh`: GCC-specific compare lane for `Target 550` (`PARSEINI_TestMemoryAndOpenTopazFont`).
- `src/decomp/scripts/compare_parseini_parse_hex_value_from_string_trial_gcc.sh`: GCC-specific compare lane for `Target 551` (`PARSEINI_ParseHexValueFromString`).
- `src/decomp/scripts/compare_parseini_parse_range_key_value_trial_gcc.sh`: GCC-specific compare lane for `Target 552` (`PARSEINI_ParseRangeKeyValue`).
- `src/decomp/scripts/compare_parseini_load_weather_message_strings_trial_gcc.sh`: GCC-specific compare lane for `Target 553` (`PARSEINI_LoadWeatherMessageStrings`).
- `src/decomp/scripts/compare_parseini_load_weather_strings_trial_gcc.sh`: GCC-specific compare lane for `Target 554` (`PARSEINI_LoadWeatherStrings`).
- `src/decomp/scripts/compare_parseini_parse_color_table_trial_gcc.sh`: GCC-specific compare lane for `Target 555` (`PARSEINI_ParseColorTable`).
- `src/decomp/scripts/compare_parseini_handle_font_command_trial_gcc.sh`: GCC-specific compare lane for `Target 556` (`PARSEINI_HandleFontCommand`).
- `src/decomp/scripts/compare_parseini_process_weather_blocks_trial_gcc.sh`: GCC-specific compare lane for `Target 557` (`PARSEINI_ProcessWeatherBlocks`).
- `src/decomp/scripts/compare_parseini_scan_logo_directory_trial_gcc.sh`: GCC-specific compare lane for `Target 558` (`PARSEINI_ScanLogoDirectory`).
- `src/decomp/scripts/compare_parseini_parse_ini_buffer_and_dispatch_trial_gcc.sh`: GCC-specific compare lane for `Target 559` (`PARSEINI_ParseIniBufferAndDispatch`).
- `src/decomp/scripts/compare_parseini_adjust_hours_to24_hr_format_trial_gcc.sh`: GCC-specific compare lane for `Target 560` (`PARSEINI_AdjustHoursTo24HrFormat`).
- `src/decomp/scripts/compare_parseini_normalize_clock_data_trial_gcc.sh`: GCC-specific compare lane for `Target 561` (`PARSEINI_NormalizeClockData`).
- `src/decomp/scripts/compare_parseini_write_rtc_from_globals_trial_gcc.sh`: GCC-specific compare lane for `Target 562` (`PARSEINI_WriteRtcFromGlobals`).
- `src/decomp/scripts/compare_parseini_update_clock_from_rtc_trial_gcc.sh`: GCC-specific compare lane for `Target 563` (`PARSEINI_UpdateClockFromRtc`).
- `src/decomp/scripts/compare_script_reset_banner_char_defaults_trial_gcc.sh`: GCC-specific compare lane for `Target 564` (`SCRIPT_ResetBannerCharDefaults`).
- `src/decomp/scripts/compare_script_get_banner_char_or_fallback_trial_gcc.sh`: GCC-specific compare lane for `Target 565` (`SCRIPT_GetBannerCharOrFallback`).
- `src/decomp/scripts/compare_script_draw_inset_text_with_frame_trial_gcc.sh`: GCC-specific compare lane for `Target 566` (`SCRIPT_DrawInsetTextWithFrame`).
- `src/decomp/scripts/compare_script_setup_highlight_effect_trial_gcc.sh`: GCC-specific compare lane for `Target 567` (`SCRIPT_SetupHighlightEffect`).
- `src/decomp/scripts/compare_bevel_draw_bevel_frame_with_top_trial_gcc.sh`: GCC-specific compare lane for `Target 684` (`BEVEL_DrawBevelFrameWithTop`).
- `src/decomp/scripts/compare_bevel_draw_beveled_frame_trial_gcc.sh`: GCC-specific compare lane for `Target 685` (`BEVEL_DrawBeveledFrame`).
- `src/decomp/scripts/compare_bevel_draw_bevel_frame_with_top_right_trial_gcc.sh`: GCC-specific compare lane for `Target 686` (`BEVEL_DrawBevelFrameWithTopRight`).
- `src/decomp/scripts/compare_bevel_draw_vertical_bevel_trial_gcc.sh`: GCC-specific compare lane for `Target 687` (`BEVEL_DrawVerticalBevel`).
- `src/decomp/scripts/compare_bevel_draw_vertical_bevel_pair_trial_gcc.sh`: GCC-specific compare lane for `Target 688` (`BEVEL_DrawVerticalBevelPair`).
- `src/decomp/scripts/compare_bevel_draw_horizontal_bevel_trial_gcc.sh`: GCC-specific compare lane for `Target 689` (`BEVEL_DrawHorizontalBevel`).
- `src/decomp/scripts/compare_script_check_path_exists_trial_gcc.sh`: GCC-specific compare lane for `Target 568` (`SCRIPT_CheckPathExists`).
- `src/decomp/scripts/compare_script_update_banner_char_transition_trial_gcc.sh`: GCC-specific compare lane for `Target 569` (`SCRIPT_UpdateBannerCharTransition`).
- `src/decomp/scripts/compare_script_prime_banner_transition_from_hex_code_trial_gcc.sh`: GCC-specific compare lane for `Target 570` (`SCRIPT_PrimeBannerTransitionFromHexCode`).
- `src/decomp/scripts/compare_script_init_ctrl_context_trial_gcc.sh`: GCC-specific compare lane for `Target 571` (`SCRIPT_InitCtrlContext`).
- `src/decomp/scripts/compare_script_set_ctrl_context_mode_trial_gcc.sh`: GCC-specific compare lane for `Target 572` (`SCRIPT_SetCtrlContextMode`).
- `src/decomp/scripts/compare_script_reset_ctrl_context_and_clear_status_line_trial_gcc.sh`: GCC-specific compare lane for `Target 573` (`SCRIPT_ResetCtrlContextAndClearStatusLine`).
- `src/decomp/scripts/compare_script_load_ctrl_context_snapshot_trial_gcc.sh`: GCC-specific compare lane for `Target 574` (`SCRIPT_LoadCtrlContextSnapshot`).
- `src/decomp/scripts/compare_script_save_ctrl_context_snapshot_trial_gcc.sh`: GCC-specific compare lane for `Target 575` (`SCRIPT_SaveCtrlContextSnapshot`).
- `src/decomp/scripts/compare_script_reset_ctrl_context_trial_gcc.sh`: GCC-specific compare lane for `Target 576` (`SCRIPT_ResetCtrlContext`).
- `src/decomp/scripts/compare_script_clear_search_texts_and_channels_trial_gcc.sh`: GCC-specific compare lane for `Target 577` (`SCRIPT_ClearSearchTextsAndChannels`).
- `src/decomp/scripts/compare_script_update_runtime_mode_for_playback_cursor_trial_gcc.sh`: GCC-specific compare lane for `Target 578` (`SCRIPT_UpdateRuntimeModeForPlaybackCursor`).
- `src/decomp/scripts/compare_script_select_playback_cursor_from_search_text_trial_gcc.sh`: GCC-specific compare lane for `Target 579` (`SCRIPT_SelectPlaybackCursorFromSearchText`).
- `src/decomp/scripts/compare_generate_grid_date_string_trial_gcc.sh`: GCC-specific compare lane for `Target 580` (`GENERATE_GRID_DATE_STRING`).
- `src/decomp/scripts/compare_script_apply_pending_banner_target_trial_gcc.sh`: GCC-specific compare lane for `Target 581` (`SCRIPT_ApplyPendingBannerTarget`).
- `src/decomp/scripts/compare_script_split_and_normalize_search_buffer_trial_gcc.sh`: GCC-specific compare lane for `Target 582` (`SCRIPT_SplitAndNormalizeSearchBuffer`).
- `src/decomp/scripts/compare_script_dispatch_playback_cursor_command_trial_gcc.sh`: GCC-specific compare lane for `Target 583` (`SCRIPT_DispatchPlaybackCursorCommand`).
- `src/decomp/scripts/compare_script_process_ctrl_context_playback_tick_trial_gcc.sh`: GCC-specific compare lane for `Target 584` (`SCRIPT_ProcessCtrlContextPlaybackTick`).
- `src/decomp/scripts/compare_script_handle_brush_command_trial_gcc.sh`: GCC-specific compare lane for `Target 585` (`SCRIPT_HandleBrushCommand`).
- `src/decomp/scripts/compare_esq_return_with_stack_code_trial_gcc.sh`: GCC-specific compare lane for `Target 586` (`ESQ_ReturnWithStackCode`).
- `src/decomp/scripts/compare_esq_shutdown_and_return_trial_gcc.sh`: GCC-specific compare lane for `Target 587` (`ESQ_ShutdownAndReturn`).
- `src/decomp/scripts/compare_esq_check_available_fast_memory_trial_gcc.sh`: GCC-specific compare lane for `Target 624` (`ESQ_CheckAvailableFastMemory`).
- `src/decomp/scripts/compare_esq_check_compatible_video_chip_trial_gcc.sh`: GCC-specific compare lane for `Target 625` (`ESQ_CheckCompatibleVideoChip`).
- `src/decomp/scripts/compare_esq_format_disk_error_message_trial_gcc.sh`: GCC-specific compare lane for `Target 626` (`ESQ_FormatDiskErrorMessage`).
- `src/decomp/scripts/compare_tliba2_find_last_char_in_string_trial_gcc.sh`: GCC-specific compare lane for `Target 627` (`TLIBA2_FindLastCharInString`).
- `src/decomp/scripts/compare_tliba2_resolve_entry_window_with_default_range_trial_gcc.sh`: GCC-specific compare lane for `Target 628` (`TLIBA2_ResolveEntryWindowWithDefaultRange`).
- `src/decomp/scripts/compare_tliba_find_first_wildcard_match_index_trial_gcc.sh`: GCC-specific compare lane for `Target 629` (`TLIBA_FindFirstWildcardMatchIndex`).
- `src/decomp/scripts/compare_tliba2_parse_entry_time_window_trial_gcc.sh`: GCC-specific compare lane for `Target 630` (`TLIBA2_ParseEntryTimeWindow`).
- `src/decomp/scripts/compare_tliba2_compute_broadcast_time_window_trial_gcc.sh`: GCC-specific compare lane for `Target 631` (`TLIBA2_ComputeBroadcastTimeWindow`).
- `src/decomp/scripts/compare_tliba2_resolve_entry_window_and_slot_count_trial_gcc.sh`: GCC-specific compare lane for `Target 632` (`TLIBA2_ResolveEntryWindowAndSlotCount`).
- `src/decomp/scripts/compare_tliba1_parse_style_code_char_trial_gcc.sh`: GCC-specific compare lane for `Target 633` (`TLIBA1_ParseStyleCodeChar`).
- `src/decomp/scripts/compare_tliba1_format_clock_format_entry_trial_gcc.sh`: GCC-specific compare lane for `Target 634` (`TLIBA1_FormatClockFormatEntry`).
- `src/decomp/scripts/compare_tliba1_draw_inline_styled_text_trial_gcc.sh`: GCC-specific compare lane for `Target 635` (`TLIBA1_DrawInlineStyledText`).
- `src/decomp/scripts/compare_tliba1_draw_formatted_text_block_trial_gcc.sh`: GCC-specific compare lane for `Target 636` (`TLIBA1_DrawFormattedTextBlock`).
- `src/decomp/scripts/compare_newgrid_draw_grid_top_bars_trial_gcc.sh`: GCC-specific compare lane for `Target 637` (`NEWGRID_DrawGridTopBars`).
- `src/decomp/scripts/compare_newgrid_draw_top_border_line_trial_gcc.sh`: GCC-specific compare lane for `Target 638` (`NEWGRID_DrawTopBorderLine`).
- `src/decomp/scripts/compare_newgrid_shutdown_grid_resources_trial_gcc.sh`: GCC-specific compare lane for `Target 639` (`NEWGRID_ShutdownGridResources`).
- `src/decomp/scripts/compare_newgrid_clear_highlight_area_trial_gcc.sh`: GCC-specific compare lane for `Target 640` (`NEWGRID_ClearHighlightArea`).
- `src/decomp/scripts/compare_newgrid_is_grid_ready_for_input_trial_gcc.sh`: GCC-specific compare lane for `Target 641` (`NEWGRID_IsGridReadyForInput`).
- `src/decomp/scripts/compare_newgrid_fill_grid_rects_trial_gcc.sh`: GCC-specific compare lane for `Target 642` (`NEWGRID_FillGridRects`).
- `src/decomp/scripts/compare_newgrid_draw_grid_frame_trial_gcc.sh`: GCC-specific compare lane for `Target 643` (`NEWGRID_DrawGridFrame`).
- `src/decomp/scripts/compare_newgrid_should_open_editor_trial_gcc.sh`: GCC-specific compare lane for `Target 644` (`NEWGRID_ShouldOpenEditor`).
- `src/decomp/scripts/compare_newgrid_compute_day_slot_from_clock_trial_gcc.sh`: GCC-specific compare lane for `Target 645` (`NEWGRID_ComputeDaySlotFromClock`).
- `src/decomp/scripts/compare_newgrid_compute_day_slot_from_clock_with_offset_trial_gcc.sh`: GCC-specific compare lane for `Target 646` (`NEWGRID_ComputeDaySlotFromClockWithOffset`).
- `src/decomp/scripts/compare_newgrid_adjust_clock_string_by_slot_trial_gcc.sh`: GCC-specific compare lane for `Target 647` (`NEWGRID_AdjustClockStringBySlot`).
- `src/decomp/scripts/compare_newgrid_adjust_clock_string_by_slot_with_offset_trial_gcc.sh`: GCC-specific compare lane for `Target 648` (`NEWGRID_AdjustClockStringBySlotWithOffset`).
- `src/decomp/scripts/compare_newgrid_draw_awaiting_listings_message_trial_gcc.sh`: GCC-specific compare lane for `Target 649` (`NEWGRID_DrawAwaitingListingsMessage`).
- `src/decomp/scripts/compare_newgrid_draw_date_banner_trial_gcc.sh`: GCC-specific compare lane for `Target 650` (`NEWGRID_DrawDateBanner`).
- `src/decomp/scripts/compare_newgrid_draw_clock_format_header_trial_gcc.sh`: GCC-specific compare lane for `Target 651` (`NEWGRID_DrawClockFormatHeader`).
- `src/decomp/scripts/compare_newgrid_map_selection_to_mode_trial_gcc.sh`: GCC-specific compare lane for `Target 652` (`NEWGRID_MapSelectionToMode`).
- `src/decomp/scripts/compare_newgrid_init_grid_resources_trial_gcc.sh`: GCC-specific compare lane for `Target 653` (`NEWGRID_InitGridResources`).
- `src/decomp/scripts/compare_newgrid_select_next_mode_trial_gcc.sh`: GCC-specific compare lane for `Target 654` (`NEWGRID_SelectNextMode`).
- `src/decomp/scripts/compare_newgrid_draw_wrapped_text_trial_gcc.sh`: GCC-specific compare lane for `Target 655` (`NEWGRID_DrawWrappedText`).
- `src/decomp/scripts/compare_p_type_allocate_entry_trial_gcc.sh`: GCC-specific compare lane for `Target 656` (`P_TYPE_AllocateEntry`).
- `src/decomp/scripts/compare_p_type_free_entry_trial_gcc.sh`: GCC-specific compare lane for `Target 657` (`P_TYPE_FreeEntry`).
- `src/decomp/scripts/compare_p_type_reset_lists_and_load_promo_ids_trial_gcc.sh`: GCC-specific compare lane for `Target 658` (`P_TYPE_ResetListsAndLoadPromoIds`).
- `src/decomp/scripts/compare_p_type_get_subtype_if_type20_trial_gcc.sh`: GCC-specific compare lane for `Target 659` (`P_TYPE_GetSubtypeIfType20`).
- `src/decomp/scripts/compare_p_type_promote_secondary_list_trial_gcc.sh`: GCC-specific compare lane for `Target 660` (`P_TYPE_PromoteSecondaryList`).
- `src/decomp/scripts/compare_p_type_ensure_secondary_list_trial_gcc.sh`: GCC-specific compare lane for `Target 661` (`P_TYPE_EnsureSecondaryList`).
- `src/decomp/scripts/compare_p_type_consume_primary_type_if_present_trial_gcc.sh`: GCC-specific compare lane for `Target 662` (`P_TYPE_ConsumePrimaryTypeIfPresent`).
- `src/decomp/scripts/compare_p_type_clone_entry_trial_gcc.sh`: GCC-specific compare lane for `Target 663` (`P_TYPE_CloneEntry`).
- `src/decomp/scripts/compare_p_type_parse_and_store_type_record_trial_gcc.sh`: GCC-specific compare lane for `Target 664` (`P_TYPE_ParseAndStoreTypeRecord`).
- `src/decomp/scripts/compare_p_type_write_promo_id_data_file_trial_gcc.sh`: GCC-specific compare lane for `Target 665` (`P_TYPE_WritePromoIdDataFile`).
- `src/decomp/scripts/compare_p_type_load_promo_id_data_file_trial_gcc.sh`: GCC-specific compare lane for `Target 666` (`P_TYPE_LoadPromoIdDataFile`).
- `src/decomp/scripts/compare_script_allocate_buffer_array_trial_gcc.sh`: GCC-specific compare lane for `Target 667` (`SCRIPT_AllocateBufferArray`).
- `src/decomp/scripts/compare_script_deallocate_buffer_array_trial_gcc.sh`: GCC-specific compare lane for `Target 668` (`SCRIPT_DeallocateBufferArray`).
- `src/decomp/scripts/compare_script_build_token_index_map_trial_gcc.sh`: GCC-specific compare lane for `Target 669` (`SCRIPT_BuildTokenIndexMap`).
- `src/decomp/scripts/compare_script_get_ctrl_line_flag_trial_gcc.sh`: GCC-specific compare lane for `Target 670` (`SCRIPT_GetCtrlLineFlag`).
- `src/decomp/scripts/compare_script_write_ctrl_shadow_to_serdat_trial_gcc.sh`: GCC-specific compare lane for `Target 671` (`SCRIPT_WriteCtrlShadowToSerdat`).
- `src/decomp/scripts/compare_script_assert_ctrl_line_trial_gcc.sh`: GCC-specific compare lane for `Target 672` (`SCRIPT_AssertCtrlLine`).
- `src/decomp/scripts/compare_script_deassert_ctrl_line_trial_gcc.sh`: GCC-specific compare lane for `Target 673` (`SCRIPT_DeassertCtrlLine`).
- `src/decomp/scripts/compare_script_assert_ctrl_line_if_enabled_trial_gcc.sh`: GCC-specific compare lane for `Target 674` (`SCRIPT_AssertCtrlLineIfEnabled`).
- `src/decomp/scripts/compare_script_clear_ctrl_line_if_enabled_trial_gcc.sh`: GCC-specific compare lane for `Target 675` (`SCRIPT_ClearCtrlLineIfEnabled`).
- `src/decomp/scripts/compare_script_assert_ctrl_line_now_trial_gcc.sh`: GCC-specific compare lane for `Target 676` (`SCRIPT_AssertCtrlLineNow`).
- `src/decomp/scripts/compare_script_deassert_ctrl_line_now_trial_gcc.sh`: GCC-specific compare lane for `Target 677` (`SCRIPT_DeassertCtrlLineNow`).
- `src/decomp/scripts/compare_script_read_handshake_bit3_flag_trial_gcc.sh`: GCC-specific compare lane for `Target 678` (`SCRIPT_ReadHandshakeBit3Flag`).
- `src/decomp/scripts/compare_script_read_handshake_bit5_mask_trial_gcc.sh`: GCC-specific compare lane for `Target 679` (`SCRIPT_ReadHandshakeBit5Mask`).
- `src/decomp/scripts/compare_script_poll_handshake_and_apply_timeout_trial_gcc.sh`: GCC-specific compare lane for `Target 680` (`SCRIPT_PollHandshakeAndApplyTimeout`).
- `src/decomp/scripts/compare_script_read_next_rbf_byte_trial_gcc.sh`: GCC-specific compare lane for `Target 681` (`SCRIPT_ReadNextRbfByte`).
- `src/decomp/scripts/compare_script_esq_capture_ctrl_bit4_stream_buffer_byte_trial_gcc.sh`: GCC-specific compare lane for `Target 682` (`SCRIPT_ESQ_CaptureCtrlBit4StreamBufferByte`).
- `src/decomp/scripts/compare_script_update_serial_shadow_from_ctrl_byte_trial_gcc.sh`: GCC-specific compare lane for `Target 683` (`SCRIPT_UpdateSerialShadowFromCtrlByte`).
- `src/decomp/scripts/compare_alloc_alloc_from_free_list_trial_gcc.sh`: GCC-specific compare lane for `Target 588` (`ALLOC_AllocFromFreeList`).
- `src/decomp/scripts/compare_alloc_insert_free_block_trial_gcc.sh`: GCC-specific compare lane for `Target 589` (`ALLOC_InsertFreeBlock`).
- `src/decomp/scripts/compare_group_ad_jmptbl_datetime_normalize_month_range_trial_gcc.sh`: GCC-specific compare lane for `Target 150` (`GROUP_AD_JMPTBL_DATETIME_NormalizeMonthRange`).
- `src/decomp/scripts/compare_group_ad_jmptbl_datetime_adjust_month_index_trial_gcc.sh`: GCC-specific compare lane for `Target 151` (`GROUP_AD_JMPTBL_DATETIME_AdjustMonthIndex`).
- `src/decomp/scripts/compare_group_ad_jmptbl_script_update_serial_shadow_from_ctrl_byte_trial_gcc.sh`: GCC-specific compare lane for `Target 152` (`GROUP_AD_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte`).
- `src/decomp/scripts/compare_group_ad_jmptbl_esqiff_run_copper_rise_transition_trial_gcc.sh`: GCC-specific compare lane for `Target 153` (`GROUP_AD_JMPTBL_ESQIFF_RunCopperRiseTransition`).
- `src/decomp/scripts/compare_group_ad_jmptbl_textdisp_build_entry_short_name_trial_gcc.sh`: GCC-specific compare lane for `Target 154` (`GROUP_AD_JMPTBL_TEXTDISP_BuildEntryShortName`).
- `src/decomp/scripts/compare_group_ad_jmptbl_graphics_blt_bit_map_rast_port_trial_gcc.sh`: GCC-specific compare lane for `Target 155` (`GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort`).
- `src/decomp/scripts/compare_group_ad_jmptbl_esqiff_run_copper_drop_transition_trial_gcc.sh`: GCC-specific compare lane for `Target 156` (`GROUP_AD_JMPTBL_ESQIFF_RunCopperDropTransition`).
- `src/decomp/scripts/compare_group_ad_jmptbl_tliba1_build_clock_format_entry_if_visible_trial_gcc.sh`: GCC-specific compare lane for `Target 157` (`GROUP_AD_JMPTBL_TLIBA1_BuildClockFormatEntryIfVisible`).
- `src/decomp/scripts/compare_group_ad_jmptbl_textdisp_build_channel_label_trial_gcc.sh`: GCC-specific compare lane for `Target 158` (`GROUP_AD_JMPTBL_TEXTDISP_BuildChannelLabel`).
- `src/decomp/scripts/compare_group_ad_jmptbl_textdisp_draw_inset_rect_frame_trial_gcc.sh`: GCC-specific compare lane for `Target 159` (`GROUP_AD_JMPTBL_TEXTDISP_DrawInsetRectFrame`).
- `src/decomp/scripts/compare_group_ad_jmptbl_textdisp_trim_text_to_pixel_width_trial_gcc.sh`: GCC-specific compare lane for `Target 160` (`GROUP_AD_JMPTBL_TEXTDISP_TrimTextToPixelWidth`).
- `src/decomp/scripts/compare_group_ad_jmptbl_esqfunc_select_and_apply_brush_for_current_entry_trial_gcc.sh`: GCC-specific compare lane for `Target 161` (`GROUP_AD_JMPTBL_ESQFUNC_SelectAndApplyBrushForCurrentEntry`).
- `src/decomp/scripts/compare_group_ad_jmptbl_dst_compute_banner_index_trial_gcc.sh`: GCC-specific compare lane for `Target 162` (`GROUP_AD_JMPTBL_DST_ComputeBannerIndex`).
- `src/decomp/scripts/compare_group_main_a_jmptbl_esq_main_exit_noop_hook_trial_gcc.sh`: GCC-specific compare lane for `Target 163` (`GROUP_MAIN_A_JMPTBL_ESQ_MainExitNoOpHook`).
- `src/decomp/scripts/compare_group_main_a_jmptbl_esq_main_entry_noop_hook_trial_gcc.sh`: GCC-specific compare lane for `Target 164` (`GROUP_MAIN_A_JMPTBL_ESQ_MainEntryNoOpHook`).
- `src/decomp/scripts/compare_group_main_a_jmptbl_memlist_free_all_trial_gcc.sh`: GCC-specific compare lane for `Target 165` (`GROUP_MAIN_A_JMPTBL_MEMLIST_FreeAll`).
- `src/decomp/scripts/compare_group_main_a_jmptbl_esq_parse_command_line_and_run_trial_gcc.sh`: GCC-specific compare lane for `Target 166` (`GROUP_MAIN_A_JMPTBL_ESQ_ParseCommandLineAndRun`).
- `src/decomp/scripts/compare_group_al_jmptbl_ladfunc_pack_nibbles_to_byte_trial_gcc.sh`: GCC-specific compare lane for `Target 167` (`GROUP_AL_JMPTBL_LADFUNC_PackNibblesToByte`).
- `src/decomp/scripts/compare_group_al_jmptbl_ladfunc_extract_low_nibble_trial_gcc.sh`: GCC-specific compare lane for `Target 168` (`GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble`).
- `src/decomp/scripts/compare_group_al_jmptbl_ladfunc_update_entry_buffers_for_ad_index_trial_gcc.sh`: GCC-specific compare lane for `Target 169` (`GROUP_AL_JMPTBL_LADFUNC_UpdateEntryBuffersForAdIndex`).
- `src/decomp/scripts/compare_group_al_jmptbl_esq_write_dec_fixed_width_trial_gcc.sh`: GCC-specific compare lane for `Target 170` (`GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth`).
- `src/decomp/scripts/compare_group_al_jmptbl_ladfunc_build_entry_buffers_or_default_trial_gcc.sh`: GCC-specific compare lane for `Target 171` (`GROUP_AL_JMPTBL_LADFUNC_BuildEntryBuffersOrDefault`).
- `src/decomp/scripts/compare_group_al_jmptbl_ladfunc_extract_high_nibble_trial_gcc.sh`: GCC-specific compare lane for `Target 172` (`GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble`).
- `src/decomp/scripts/compare_group_ay_jmptbl_diskio_consume_cstring_from_work_buffer_trial_gcc.sh`: GCC-specific compare lane for `Target 173` (`GROUP_AY_JMPTBL_DISKIO_ConsumeCStringFromWorkBuffer`).
- `src/decomp/scripts/compare_group_ay_jmptbl_diskio_parse_long_from_work_buffer_trial_gcc.sh`: GCC-specific compare lane for `Target 174` (`GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer`).
- `src/decomp/scripts/compare_group_ay_jmptbl_diskio_write_decimal_field_trial_gcc.sh`: GCC-specific compare lane for `Target 175` (`GROUP_AY_JMPTBL_DISKIO_WriteDecimalField`).
- `src/decomp/scripts/compare_group_ay_jmptbl_diskio_write_buffered_bytes_trial_gcc.sh`: GCC-specific compare lane for `Target 176` (`GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes`).
- `src/decomp/scripts/compare_group_ay_jmptbl_diskio_close_buffered_file_and_flush_trial_gcc.sh`: GCC-specific compare lane for `Target 177` (`GROUP_AY_JMPTBL_DISKIO_CloseBufferedFileAndFlush`).
- `src/decomp/scripts/compare_group_ay_jmptbl_string_compare_nocase_n_trial_gcc.sh`: GCC-specific compare lane for `Target 178` (`GROUP_AY_JMPTBL_STRING_CompareNoCaseN`).
- `src/decomp/scripts/compare_group_ay_jmptbl_math_mulu32_trial_gcc.sh`: GCC-specific compare lane for `Target 179` (`GROUP_AY_JMPTBL_MATH_Mulu32`).
- `src/decomp/scripts/compare_group_ay_jmptbl_diskio_load_file_to_work_buffer_trial_gcc.sh`: GCC-specific compare lane for `Target 180` (`GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer`).
- `src/decomp/scripts/compare_group_ay_jmptbl_script_read_ciab_bit5_mask_trial_gcc.sh`: GCC-specific compare lane for `Target 181` (`GROUP_AY_JMPTBL_SCRIPT_ReadCiaBBit5Mask`).
- `src/decomp/scripts/compare_group_ay_jmptbl_diskio_open_file_with_buffer_trial_gcc.sh`: GCC-specific compare lane for `Target 182` (`GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer`).
- `src/decomp/scripts/compare_group_aa_jmptbl_string_compare_nocase_trial_gcc.sh`: GCC-specific compare lane for `Target 095` (`GROUP_AA_JMPTBL_STRING_CompareNoCase`).
- `src/decomp/scripts/compare_group_aa_jmptbl_string_compare_n_trial_gcc.sh`: GCC-specific compare lane for `Target 094` (`GROUP_AA_JMPTBL_STRING_CompareN`).
- `src/decomp/scripts/compare_group_ar_jmptbl_parseini_write_error_log_entry_trial_gcc.sh`: GCC-specific compare lane for `Target 092` (`GROUP_AR_JMPTBL_PARSEINI_WriteErrorLogEntry`).
- `src/decomp/scripts/compare_group_ar_jmptbl_string_append_at_null_trial_gcc.sh`: GCC-specific compare lane for `Target 093` (`GROUP_AR_JMPTBL_STRING_AppendAtNull`).
- `src/decomp/scripts/compare_group_main_b_jmptbl_dos_delay_trial_gcc.sh`: GCC-specific compare lane for `Target 090` (`GROUP_MAIN_B_JMPTBL_DOS_Delay`).
- `src/decomp/scripts/compare_group_main_b_jmptbl_stream_buffered_write_string_trial_gcc.sh`: GCC-specific compare lane for `Target 088` (`GROUP_MAIN_B_JMPTBL_STREAM_BufferedWriteString`).
- `src/decomp/scripts/compare_group_main_b_jmptbl_math_mulu32_trial_gcc.sh`: GCC-specific compare lane for `Target 089` (`GROUP_MAIN_B_JMPTBL_MATH_Mulu32`).
- `src/decomp/scripts/compare_group_main_b_jmptbl_buffer_flush_all_and_close_with_code_trial_gcc.sh`: GCC-specific compare lane for `Target 091` (`GROUP_MAIN_B_JMPTBL_BUFFER_FlushAllAndCloseWithCode`).
- `src/decomp/scripts/compare_unknown32_jmptbl_esq_return_with_stack_code_trial_gcc.sh`: GCC-specific compare lane for `Target 074` (`UNKNOWN32_JMPTBL_ESQ_ReturnWithStackCode`).
- `src/decomp/scripts/compare_handle_close_all_and_return_with_code_trial_gcc.sh`: GCC-specific compare lane for `Target 075` (`HANDLE_CloseAllAndReturnWithCode`).
- `src/decomp/scripts/compare_dos_close_with_signal_check_trial_gcc.sh`: GCC-specific compare lane for `Target 037` (`DOS_CloseWithSignalCheck`).
- `src/decomp/scripts/compare_iostdreq_free_trial_gcc.sh`: GCC-specific compare lane for `Target 038` (`IOSTDREQ_Free`).
- `src/decomp/scripts/compare_iostdreq_cleanup_signal_and_msgport_trial_gcc.sh`: GCC-specific compare lane for `Target 039` (`IOSTDREQ_CleanupSignalAndMsgport`).
- `src/decomp/scripts/compare_cleanup_clear_vertb_interrupt_server_trial_gcc.sh`: GCC-specific compare lane for `Target 757` (`CLEANUP_ClearVertbInterruptServer`).
- `src/decomp/scripts/compare_cleanup_clear_aud1_interrupt_vector_trial_gcc.sh`: GCC-specific compare lane for `Target 758` (`CLEANUP_ClearAud1InterruptVector`).
- `src/decomp/scripts/compare_cleanup_clear_rbf_interrupt_and_serial_trial_gcc.sh`: GCC-specific compare lane for `Target 759` (`CLEANUP_ClearRbfInterruptAndSerial`).
- `src/decomp/scripts/compare_cleanup_shutdown_input_devices_trial_gcc.sh`: GCC-specific compare lane for `Target 760` (`CLEANUP_ShutdownInputDevices`).
- `src/decomp/scripts/compare_cleanup_shutdown_system_trial_gcc.sh`: GCC-specific compare lane for `Target 761` (`CLEANUP_ShutdownSystem`).
- `src/decomp/scripts/compare_cleanup_release_display_resources_trial_gcc.sh`: GCC-specific compare lane for `Target 762` (`CLEANUP_ReleaseDisplayResources`).
- `src/decomp/scripts/compare_cleanup_draw_banner_spacer_segment_trial_gcc.sh`: GCC-specific compare lane for `Target 763` (`CLEANUP_DrawBannerSpacerSegment`).
- `src/decomp/scripts/compare_cleanup_draw_time_banner_segment_trial_gcc.sh`: GCC-specific compare lane for `Target 764` (`CLEANUP_DrawTimeBannerSegment`).
- `src/decomp/scripts/compare_cleanup_draw_date_banner_segment_trial_gcc.sh`: GCC-specific compare lane for `Target 765` (`CLEANUP_DrawDateBannerSegment`).
- `src/decomp/scripts/compare_cleanup_draw_datetime_banner_row_trial_gcc.sh`: GCC-specific compare lane for `Target 766` (`CLEANUP_DrawDateTimeBannerRow`).
- `src/decomp/scripts/compare_render_short_month_short_day_of_week_day_trial_gcc.sh`: GCC-specific compare lane for `Target 767` (`RENDER_SHORT_MONTH_SHORT_DAY_OF_WEEK_DAY`).
- `src/decomp/scripts/compare_cleanup_draw_grid_time_banner_trial_gcc.sh`: GCC-specific compare lane for `Target 768` (`CLEANUP_DrawGridTimeBanner`).
- `src/decomp/scripts/compare_cleanup_format_clock_format_entry_trial_gcc.sh`: GCC-specific compare lane for `Target 769` (`CLEANUP_FormatClockFormatEntry`).
- `src/decomp/scripts/compare_cleanup_draw_clock_format_frame_trial_gcc.sh`: GCC-specific compare lane for `Target 770` (`CLEANUP_DrawClockFormatFrame`).
- `src/decomp/scripts/compare_cleanup_draw_clock_banner_trial_gcc.sh`: GCC-specific compare lane for `Target 771` (`CLEANUP_DrawClockBanner`).
- `src/decomp/scripts/compare_cleanup_draw_clock_format_list_trial_gcc.sh`: GCC-specific compare lane for `Target 772` (`CLEANUP_DrawClockFormatList`).
- `src/decomp/scripts/compare_cleanup_process_alerts_trial_gcc.sh`: GCC-specific compare lane for `Target 773` (`CLEANUP_ProcessAlerts`).
- `src/decomp/scripts/compare_cleanup_test_entry_flag_y_and_bit1_trial_gcc.sh`: GCC-specific compare lane for `Target 774` (`CLEANUP_TestEntryFlagYAndBit1`).
- `src/decomp/scripts/compare_cleanup_update_entry_flag_bytes_trial_gcc.sh`: GCC-specific compare lane for `Target 775` (`CLEANUP_UpdateEntryFlagBytes`).
- `src/decomp/scripts/compare_cleanup_draw_inset_rect_frame_trial_gcc.sh`: GCC-specific compare lane for `Target 776` (`CLEANUP_DrawInsetRectFrame`).
- `src/decomp/scripts/compare_cleanup_format_entry_string_tokens_trial_gcc.sh`: GCC-specific compare lane for `Target 777` (`CLEANUP_FormatEntryStringTokens`).
- `src/decomp/scripts/compare_cleanup_build_aligned_status_line_trial_gcc.sh`: GCC-specific compare lane for `Target 778` (`CLEANUP_BuildAlignedStatusLine`).
- `src/decomp/scripts/compare_cleanup_parse_aligned_listing_block_trial_gcc.sh`: GCC-specific compare lane for `Target 779` (`CLEANUP_ParseAlignedListingBlock`).
- `src/decomp/scripts/compare_cleanup_build_and_render_aligned_status_banner_trial_gcc.sh`: GCC-specific compare lane for `Target 780` (`CLEANUP_BuildAndRenderAlignedStatusBanner`).
- `src/decomp/scripts/compare_textdisp_find_control_token_trial_gcc.sh`: GCC-specific compare lane for `Target 781` (`TEXTDISP_FindControlToken`).
- `src/decomp/scripts/compare_textdisp_find_alias_index_by_name_trial_gcc.sh`: GCC-specific compare lane for `Target 782` (`TEXTDISP_FindAliasIndexByName`).
- `src/decomp/scripts/compare_textdisp_find_quoted_span_trial_gcc.sh`: GCC-specific compare lane for `Target 783` (`TEXTDISP_FindQuotedSpan`).
- `src/decomp/scripts/compare_textdisp_format_entry_time_for_index_trial_gcc.sh`: GCC-specific compare lane for `Target 784` (`TEXTDISP_FormatEntryTimeForIndex`).
- `src/decomp/scripts/compare_textdisp_compute_time_offset_trial_gcc.sh`: GCC-specific compare lane for `Target 785` (`TEXTDISP_ComputeTimeOffset`).
- `src/decomp/scripts/compare_textdisp_draw_inset_rect_frame_trial_gcc.sh`: GCC-specific compare lane for `Target 786` (`TEXTDISP_DrawInsetRectFrame`).
- `src/decomp/scripts/compare_textdisp_build_entry_short_name_trial_gcc.sh`: GCC-specific compare lane for `Target 787` (`TEXTDISP_BuildEntryShortName`).
- `src/decomp/scripts/compare_textdisp_build_channel_label_trial_gcc.sh`: GCC-specific compare lane for `Target 788` (`TEXTDISP_BuildChannelLabel`).
- `src/decomp/scripts/compare_textdisp_draw_channel_banner_trial_gcc.sh`: GCC-specific compare lane for `Target 789` (`TEXTDISP_DrawChannelBanner`).
- `src/decomp/scripts/compare_textdisp_format_entry_time_trial_gcc.sh`: GCC-specific compare lane for `Target 790` (`TEXTDISP_FormatEntryTime`).
- `src/decomp/scripts/compare_textdisp_update_channel_range_flags_trial_gcc.sh`: GCC-specific compare lane for `Target 791` (`TEXTDISP_UpdateChannelRangeFlags`).
- `src/decomp/scripts/compare_textdisp_select_group_and_entry_trial_gcc.sh`: GCC-specific compare lane for `Target 792` (`TEXTDISP_SelectGroupAndEntry`).
- `src/decomp/scripts/compare_textdisp_build_match_index_list_trial_gcc.sh`: GCC-specific compare lane for `Target 793` (`TEXTDISP_BuildMatchIndexList`).
- `src/decomp/scripts/compare_textdisp_find_entry_match_index_trial_gcc.sh`: GCC-specific compare lane for `Target 794` (`TEXTDISP_FindEntryMatchIndex`).
- `src/decomp/scripts/compare_textdisp_select_best_match_from_list_trial_gcc.sh`: GCC-specific compare lane for `Target 795` (`TEXTDISP_SelectBestMatchFromList`).
- `src/decomp/scripts/compare_coi_free_entry_resources_return_trial_gcc.sh`: GCC-specific compare lane for `Target 796` (`COI_FreeEntryResources_Return`).
- `src/decomp/scripts/compare_coi_clear_anim_object_strings_return_trial_gcc.sh`: GCC-specific compare lane for `Target 797` (`COI_ClearAnimObjectStrings_Return`).
- `src/decomp/scripts/compare_coi_free_sub_entry_table_entries_return_trial_gcc.sh`: GCC-specific compare lane for `Target 798` (`COI_FreeSubEntryTableEntries_Return`).
- `src/decomp/scripts/compare_coi_get_anim_field_pointer_by_mode_return_trial_gcc.sh`: GCC-specific compare lane for `Target 799` (`COI_GetAnimFieldPointerByMode_Return`).
- `src/decomp/scripts/compare_coi_test_entry_within_time_window_return_trial_gcc.sh`: GCC-specific compare lane for `Target 800` (`COI_TestEntryWithinTimeWindow_Return`).
- `src/decomp/scripts/compare_coi_append_anim_field_with_trailing_space_return_trial_gcc.sh`: GCC-specific compare lane for `Target 801` (`COI_AppendAnimFieldWithTrailingSpace_Return`).
- `src/decomp/scripts/compare_coi_compute_entry_time_delta_minutes_return_trial_gcc.sh`: GCC-specific compare lane for `Target 802` (`COI_ComputeEntryTimeDeltaMinutes_Return`).
- `src/decomp/scripts/compare_coi_format_entry_display_text_return_trial_gcc.sh`: GCC-specific compare lane for `Target 803` (`COI_FormatEntryDisplayText_Return`).
- `src/decomp/scripts/compare_coi_count_escape14_before_null_trial_gcc.sh`: GCC-specific compare lane for `Target 804` (`COI_CountEscape14BeforeNull`).
- `src/decomp/scripts/compare_coi_ensure_anim_object_allocated_trial_gcc.sh`: GCC-specific compare lane for `Target 805` (`COI_EnsureAnimObjectAllocated`).
- `src/decomp/scripts/compare_coi_select_anim_field_pointer_trial_gcc.sh`: GCC-specific compare lane for `Target 806` (`COI_SelectAnimFieldPointer`).
- `src/decomp/scripts/compare_coi_render_clock_format_entry_variant_trial_gcc.sh`: GCC-specific compare lane for `Target 807` (`COI_RenderClockFormatEntryVariant`).
- `src/decomp/scripts/compare_coi_process_entry_selection_state_trial_gcc.sh`: GCC-specific compare lane for `Target 808` (`COI_ProcessEntrySelectionState`).
- `src/decomp/scripts/compare_coi_compute_entry_time_delta_minutes_trial_gcc.sh`: GCC-specific compare lane for `Target 809` (`COI_ComputeEntryTimeDeltaMinutes` entry body).
- `src/decomp/scripts/compare_coi_free_entry_resources_trial_gcc.sh`: GCC-specific compare lane for `Target 810` (`COI_FreeEntryResources` entry body).
- `src/decomp/scripts/compare_coi_clear_anim_object_strings_trial_gcc.sh`: GCC-specific compare lane for `Target 811` (`COI_ClearAnimObjectStrings` entry body).
- `src/decomp/scripts/compare_coi_free_sub_entry_table_entries_trial_gcc.sh`: GCC-specific compare lane for `Target 812` (`COI_FreeSubEntryTableEntries` entry body).
- `src/decomp/scripts/compare_coi_get_anim_field_pointer_by_mode_trial_gcc.sh`: GCC-specific compare lane for `Target 813` (`COI_GetAnimFieldPointerByMode` entry body).
- `src/decomp/scripts/compare_coi_test_entry_within_time_window_trial_gcc.sh`: GCC-specific compare lane for `Target 814` (`COI_TestEntryWithinTimeWindow` entry body).
- `src/decomp/scripts/compare_coi_format_entry_display_text_trial_gcc.sh`: GCC-specific compare lane for `Target 815` (`COI_FormatEntryDisplayText` entry body).
- `src/decomp/scripts/compare_coi_alloc_sub_entry_table_trial_gcc.sh`: GCC-specific compare lane for `Target 816` (`COI_AllocSubEntryTable` entry body).
- `src/decomp/scripts/compare_coi_load_oi_data_file_trial_gcc.sh`: GCC-specific compare lane for `Target 817` (`COI_LoadOiDataFile` entry body).
- `src/decomp/scripts/compare_coi_write_oi_data_file_trial_gcc.sh`: GCC-specific compare lane for `Target 818` (`COI_WriteOiDataFile` entry body).
- `src/decomp/scripts/compare_ctasks_close_task_teardown_trial_gcc.sh`: GCC-specific compare lane for `Target 819` (`CTASKS_CloseTaskTeardown`).
- `src/decomp/scripts/compare_ctasks_start_close_task_process_trial_gcc.sh`: GCC-specific compare lane for `Target 820` (`CTASKS_StartCloseTaskProcess`).
- `src/decomp/scripts/compare_ctasks_iff_task_cleanup_trial_gcc.sh`: GCC-specific compare lane for `Target 821` (`CTASKS_IFFTaskCleanup`).
- `src/decomp/scripts/compare_ctasks_start_iff_task_process_trial_gcc.sh`: GCC-specific compare lane for `Target 822` (`CTASKS_StartIffTaskProcess`).
- `src/decomp/scripts/compare_disptext_has_multiple_lines_trial_gcc.sh`: GCC-specific compare lane for `Target 823` (`DISPTEXT_HasMultipleLines`).
- `src/decomp/scripts/compare_disptext_is_current_line_last_trial_gcc.sh`: GCC-specific compare lane for `Target 824` (`DISPTEXT_IsCurrentLineLast`).
- `src/decomp/scripts/compare_disptext_get_total_line_count_trial_gcc.sh`: GCC-specific compare lane for `Target 825` (`DISPTEXT_GetTotalLineCount`).
- `src/decomp/scripts/compare_disptext_is_last_line_selected_trial_gcc.sh`: GCC-specific compare lane for `Target 826` (`DISPTEXT_IsLastLineSelected`).
- `src/decomp/scripts/compare_disptext_set_current_line_index_trial_gcc.sh`: GCC-specific compare lane for `Target 827` (`DISPTEXT_SetCurrentLineIndex`).
- `src/decomp/scripts/compare_disptext_measure_current_line_length_trial_gcc.sh`: GCC-specific compare lane for `Target 828` (`DISPTEXT_MeasureCurrentLineLength`).
- `src/decomp/scripts/compare_disptext_compute_visible_line_count_trial_gcc.sh`: GCC-specific compare lane for `Target 829` (`DISPTEXT_ComputeVisibleLineCount`).
- `src/decomp/scripts/compare_disptext_init_buffers_trial_gcc.sh`: GCC-specific compare lane for `Target 830` (`DISPTEXT_InitBuffers`).
- `src/decomp/scripts/compare_disptext_free_buffers_trial_gcc.sh`: GCC-specific compare lane for `Target 831` (`DISPTEXT_FreeBuffers`).
- `src/decomp/scripts/compare_disptext_finalize_line_table_trial_gcc.sh`: GCC-specific compare lane for `Target 832` (`DISPTEXT_FinalizeLineTable`).
- `src/decomp/scripts/compare_disptext_set_layout_params_trial_gcc.sh`: GCC-specific compare lane for `Target 833` (`DISPTEXT_SetLayoutParams`).
- `src/decomp/scripts/compare_disptext_compute_marker_widths_trial_gcc.sh`: GCC-specific compare lane for `Target 834` (`DISPTEXT_ComputeMarkerWidths`).
- `src/decomp/scripts/compare_disptext_build_line_with_width_trial_gcc.sh`: GCC-specific compare lane for `Target 835` (`DISPTEXT_BuildLineWithWidth`).
- `src/decomp/scripts/compare_disptext_build_line_pointer_table_trial_gcc.sh`: GCC-specific compare lane for `Target 836` (`DISPTEXT_BuildLinePointerTable`).
- `src/decomp/scripts/compare_disptext_append_to_buffer_trial_gcc.sh`: GCC-specific compare lane for `Target 837` (`DISPTEXT_AppendToBuffer`).
- `src/decomp/scripts/compare_disptext_build_layout_for_source_trial_gcc.sh`: GCC-specific compare lane for `Target 838` (`DISPTEXT_BuildLayoutForSource`).
- `src/decomp/scripts/compare_disptext_layout_source_to_lines_trial_gcc.sh`: GCC-specific compare lane for `Target 839` (`DISPTEXT_LayoutSourceToLines`).
- `src/decomp/scripts/compare_disptext_layout_and_append_to_buffer_trial_gcc.sh`: GCC-specific compare lane for `Target 840` (`DISPTEXT_LayoutAndAppendToBuffer`).
- `src/decomp/scripts/compare_disptext_render_current_line_trial_gcc.sh`: GCC-specific compare lane for `Target 841` (`DISPTEXT_RenderCurrentLine`).
- `src/decomp/scripts/compare_displib_find_previous_valid_entry_index_trial_gcc.sh`: GCC-specific compare lane for `Target 842` (`DISPLIB_FindPreviousValidEntryIndex`).
- `src/decomp/scripts/compare_esqdisp_test_entry_bits0_and2_trial_gcc.sh`: GCC-specific compare lane for `Target 843` (`ESQDISP_TestEntryBits0And2`).
- `src/decomp/scripts/compare_esqdisp_get_entry_pointer_by_mode_trial_gcc.sh`: GCC-specific compare lane for `Target 844` (`ESQDISP_GetEntryPointerByMode`).
- `src/decomp/scripts/compare_esqdisp_get_entry_aux_pointer_by_mode_trial_gcc.sh`: GCC-specific compare lane for `Target 845` (`ESQDISP_GetEntryAuxPointerByMode`).
- `src/decomp/scripts/compare_esqdisp_compute_schedule_offset_for_row_trial_gcc.sh`: GCC-specific compare lane for `Target 846` (`ESQDISP_ComputeScheduleOffsetForRow`).
- `src/decomp/scripts/compare_esqdisp_test_entry_grid_eligibility_trial_gcc.sh`: GCC-specific compare lane for `Target 847` (`ESQDISP_TestEntryGridEligibility`).
- `src/decomp/scripts/compare_esqdisp_test_word_is_zero_booleanize_trial_gcc.sh`: GCC-specific compare lane for `Target 848` (`ESQDISP_TestWordIsZeroBooleanize`).
- `src/decomp/scripts/compare_esqdisp_process_grid_messages_if_idle_trial_gcc.sh`: GCC-specific compare lane for `Target 849` (`ESQDISP_ProcessGridMessagesIfIdle`).
- `src/decomp/scripts/compare_esqdisp_refresh_status_indicators_from_current_mask_trial_gcc.sh`: GCC-specific compare lane for `Target 850` (`ESQDISP_RefreshStatusIndicatorsFromCurrentMask`).
- `src/decomp/scripts/compare_esqdisp_init_highlight_message_pattern_trial_gcc.sh`: GCC-specific compare lane for `Target 851` (`ESQDISP_InitHighlightMessagePattern`).
- `src/decomp/scripts/compare_esqdisp_update_status_mask_and_refresh_trial_gcc.sh`: GCC-specific compare lane for `Target 852` (`ESQDISP_UpdateStatusMaskAndRefresh`).
- `src/decomp/scripts/compare_esqdisp_allocate_highlight_bitmaps_trial_gcc.sh`: GCC-specific compare lane for `Target 853` (`ESQDISP_AllocateHighlightBitmaps`).
- `src/decomp/scripts/compare_esqdisp_apply_status_mask_to_indicators_trial_gcc.sh`: GCC-specific compare lane for `Target 854` (`ESQDISP_ApplyStatusMaskToIndicators`).
- `src/decomp/scripts/compare_esqdisp_set_status_indicator_color_slot_trial_gcc.sh`: GCC-specific compare lane for `Target 855` (`ESQDISP_SetStatusIndicatorColorSlot`).
- `src/decomp/scripts/compare_esqdisp_queue_highlight_draw_message_trial_gcc.sh`: GCC-specific compare lane for `Target 856` (`ESQDISP_QueueHighlightDrawMessage`).
- `src/decomp/scripts/compare_esqdisp_fill_program_info_header_fields_trial_gcc.sh`: GCC-specific compare lane for `Target 857` (`ESQDISP_FillProgramInfoHeaderFields`).
- `src/decomp/scripts/compare_esqdisp_poll_input_mode_and_refresh_selection_trial_gcc.sh`: GCC-specific compare lane for `Target 858` (`ESQDISP_PollInputModeAndRefreshSelection`).
- `src/decomp/scripts/compare_esqdisp_normalize_clock_and_redraw_banner_trial_gcc.sh`: GCC-specific compare lane for `Target 859` (`ESQDISP_NormalizeClockAndRedrawBanner`).
- `src/decomp/scripts/compare_esqdisp_mirror_primary_entries_to_secondary_if_empty_trial_gcc.sh`: GCC-specific compare lane for `Target 860` (`ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty`).
- `src/decomp/scripts/compare_esqdisp_promote_secondary_line_head_tail_if_marked_trial_gcc.sh`: GCC-specific compare lane for `Target 861` (`ESQDISP_PromoteSecondaryLineHeadTailIfMarked`).
- `src/decomp/scripts/compare_esqdisp_promote_secondary_group_to_primary_trial_gcc.sh`: GCC-specific compare lane for `Target 862` (`ESQDISP_PromoteSecondaryGroupToPrimary`).
- `src/decomp/scripts/compare_esqdisp_propagate_primary_title_metadata_to_secondary_trial_gcc.sh`: GCC-specific compare lane for `Target 863` (`ESQDISP_PropagatePrimaryTitleMetadataToSecondary`).
- `src/decomp/scripts/compare_esqdisp_draw_status_banner_impl_trial_gcc.sh`: GCC-specific compare lane for `Target 864` (`ESQDISP_DrawStatusBanner_Impl`).
- `src/decomp/scripts/compare_esqdisp_parse_program_info_command_record_trial_gcc.sh`: GCC-specific compare lane for `Target 865` (`ESQDISP_ParseProgramInfoCommandRecord`).
- `src/decomp/scripts/compare_esqdisp_draw_status_banner_trial_gcc.sh`: GCC-specific compare lane for `Target 866` (`ESQDISP_DrawStatusBanner`).
- `src/decomp/scripts/compare_esqdisp_jmptbl_newgrid_and_graphics_alloc_raster_trial_gcc.sh`: GCC-specific compare lane for `Target 867` (`ESQDISP_JMPTBL_NEWGRID_ProcessGridMessages` + `ESQDISP_JMPTBL_GRAPHICS_AllocRaster`).
- `src/decomp/scripts/compare_flib_append_clock_stamped_log_entry_trial_gcc.sh`: GCC-specific compare lane for `Target 868` (`FLIB_AppendClockStampedLogEntry`).
- `src/decomp/scripts/compare_displib_normalize_value_by_step_trial_gcc.sh`: GCC-specific compare lane for `Target 869` (`DISPLIB_NormalizeValueByStep`).
- `src/decomp/scripts/compare_displib_reset_line_tables_trial_gcc.sh`: GCC-specific compare lane for `Target 870` (`DISPLIB_ResetLineTables`).
- `src/decomp/scripts/compare_displib_reset_text_buffer_and_line_tables_trial_gcc.sh`: GCC-specific compare lane for `Target 871` (`DISPLIB_ResetTextBufferAndLineTables`).
- `src/decomp/scripts/compare_displib_commit_current_line_pen_and_advance_trial_gcc.sh`: GCC-specific compare lane for `Target 872` (`DISPLIB_CommitCurrentLinePenAndAdvance`).
- `src/decomp/scripts/compare_displib_display_text_at_position_trial_gcc.sh`: GCC-specific compare lane for `Target 873` (`DISPLIB_DisplayTextAtPosition`).
- `src/decomp/scripts/compare_displib_apply_inline_alignment_padding_trial_gcc.sh`: GCC-specific compare lane for `Target 874` (`DISPLIB_ApplyInlineAlignmentPadding`).
- `src/decomp/scripts/compare_esqfunc_jmptbl_esq_handle_serial_rbf_interrupt_trial_gcc.sh`: GCC-specific compare lane for `Target 875` (`ESQFUNC_JMPTBL_ESQ_HandleSerialRbfInterrupt`).
- `src/decomp/scripts/compare_esqfunc_jmptbl_esq_tick_global_counters_trial_gcc.sh`: GCC-specific compare lane for `Target 876` (`ESQFUNC_JMPTBL_ESQ_TickGlobalCounters`).
- `src/decomp/scripts/compare_esqfunc_jmptbl_esq_poll_ctrl_input_trial_gcc.sh`: GCC-specific compare lane for `Target 877` (`ESQFUNC_JMPTBL_ESQ_PollCtrlInput`).
- `src/decomp/scripts/compare_esqfunc_jmptbl_script_handle_serial_ctrl_cmd_trial_gcc.sh`: GCC-specific compare lane for `Target 878` (`ESQFUNC_JMPTBL_SCRIPT_HandleSerialCtrlCmd`).
- `src/decomp/scripts/compare_esqfunc_jmptbl_textdisp_tick_display_state_trial_gcc.sh`: GCC-specific compare lane for `Target 879` (`ESQFUNC_JMPTBL_TEXTDISP_TickDisplayState`).
- `src/decomp/scripts/compare_esqfunc_allocate_line_text_buffers_trial_gcc.sh`: GCC-specific compare lane for `Target 880` (`ESQFUNC_AllocateLineTextBuffers`).
- `src/decomp/scripts/compare_esqfunc_free_line_text_buffers_trial_gcc.sh`: GCC-specific compare lane for `Target 881` (`ESQFUNC_FreeLineTextBuffers`).
- `src/decomp/scripts/compare_esqfunc_update_disk_warning_and_refresh_tick_trial_gcc.sh`: GCC-specific compare lane for `Target 882` (`ESQFUNC_UpdateDiskWarningAndRefreshTick`).
- `src/decomp/scripts/compare_esqfunc_wait_for_clock_change_and_service_ui_trial_gcc.sh`: GCC-specific compare lane for `Target 883` (`ESQFUNC_WaitForClockChangeAndServiceUi`).
- `src/decomp/scripts/compare_esqfunc_commit_secondary_state_and_persist_trial_gcc.sh`: GCC-specific compare lane for `Target 884` (`ESQFUNC_CommitSecondaryStateAndPersist`).
- `src/decomp/scripts/compare_esqfunc_process_ui_frame_tick_trial_gcc.sh`: GCC-specific compare lane for `Target 885` (`ESQFUNC_ProcessUiFrameTick`).
- `src/decomp/scripts/compare_esqfunc_service_ui_tick_if_running_trial_gcc.sh`: GCC-specific compare lane for `Target 886` (`ESQFUNC_ServiceUiTickIfRunning`).
- `src/decomp/scripts/compare_esqfunc_free_extra_title_text_pointers_trial_gcc.sh`: GCC-specific compare lane for `Target 887` (`ESQFUNC_FreeExtraTitleTextPointers`).
- `src/decomp/scripts/compare_esqfunc_update_refresh_mode_state_trial_gcc.sh`: GCC-specific compare lane for `Target 888` (`ESQFUNC_UpdateRefreshModeState`).
- `src/decomp/scripts/compare_esqfunc_draw_esc_menu_version_trial_gcc.sh`: GCC-specific compare lane for `Target 889` (`ESQFUNC_DrawEscMenuVersion`).
- `src/decomp/scripts/compare_esqfunc_trim_text_to_pixel_width_word_boundary_trial_gcc.sh`: GCC-specific compare lane for `Target 890` (`ESQFUNC_TrimTextToPixelWidthWordBoundary`).
- `src/decomp/scripts/compare_esqfunc_rebuild_pw_brush_list_from_tag_table_trial_gcc.sh`: GCC-specific compare lane for `Target 891` (`ESQFUNC_RebuildPwBrushListFromTagTable`).
- `src/decomp/scripts/compare_esqfunc_select_and_apply_brush_for_current_entry_trial_gcc.sh`: GCC-specific compare lane for `Target 892` (`ESQFUNC_SelectAndApplyBrushForCurrentEntry`).
- `src/decomp/scripts/compare_esqfunc_draw_memory_status_screen_trial_gcc.sh`: GCC-specific compare lane for `Target 893` (`ESQFUNC_DrawMemoryStatusScreen`).
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
- `src/decomp/scripts/semantic_filter_esq_invoke_gcommand_init.awk`: semantic post-filter for `ESQ_InvokeGcommandInit` compare lane.
- `src/decomp/scripts/semantic_filter_esq_try_rom_write_test.awk`: semantic post-filter for `ESQ_TryRomWriteTest` compare lane.
- `src/decomp/scripts/semantic_filter_esq_supervisor_cold_reboot.awk`: semantic post-filter for `ESQ_SupervisorColdReboot` compare lane.
- `src/decomp/scripts/semantic_filter_esq_init_audio1_dma.awk`: semantic post-filter for `ESQ_InitAudio1Dma` compare lane.
- `src/decomp/scripts/semantic_filter_esq_read_serial_rbf_byte.awk`: semantic post-filter for `ESQ_ReadSerialRbfByte` compare lane.
- `src/decomp/scripts/semantic_filter_esq_handle_serial_rbf_interrupt.awk`: semantic post-filter for `ESQ_HandleSerialRbfInterrupt` compare lane.
- `src/decomp/scripts/semantic_filter_esq_capture_ctrl_bit4_stream_buffer_byte.awk`: semantic post-filter for `ESQ_CaptureCtrlBit4StreamBufferByte` compare lane.
- `src/decomp/scripts/semantic_filter_esq_check_topaz_font_guard.awk`: semantic post-filter for `ESQ_CheckTopazFontGuard` compare lane.
- `src/decomp/scripts/semantic_filter_esq_poll_ctrl_input.awk`: semantic post-filter for `ESQ_PollCtrlInput` compare lane.
- `src/decomp/scripts/semantic_filter_esq_set_copper_effect_default.awk`: semantic post-filter for `ESQ_SetCopperEffect_Default` compare lane.
- `src/decomp/scripts/semantic_filter_esq_set_copper_effect_all_on.awk`: semantic post-filter for `ESQ_SetCopperEffect_AllOn` compare lane.
- `src/decomp/scripts/semantic_filter_esq_set_copper_effect_custom.awk`: semantic post-filter for `ESQ_SetCopperEffect_Custom` compare lane.
- `src/decomp/scripts/semantic_filter_esq_set_copper_effect_off_disable_highlight.awk`: semantic post-filter for `ESQ_SetCopperEffect_OffDisableHighlight` compare lane.
- `src/decomp/scripts/semantic_filter_esq_set_copper_effect_on_enable_highlight.awk`: semantic post-filter for `ESQ_SetCopperEffect_OnEnableHighlight` compare lane.
- `src/decomp/scripts/semantic_filter_esq_set_copper_effect_params.awk`: semantic post-filter for `ESQ_SetCopperEffectParams` compare lane.
- `src/decomp/scripts/semantic_filter_esq_update_copper_lists_from_params.awk`: semantic post-filter for `ESQ_UpdateCopperListsFromParams` compare lane.
- `src/decomp/scripts/semantic_filter_esq_dec_color_step.awk`: semantic post-filter for `ESQ_DecColorStep` compare lane.
- `src/decomp/scripts/semantic_filter_esq_bump_color_toward_targets.awk`: semantic post-filter for `ESQ_BumpColorTowardTargets` compare lane.
- `src/decomp/scripts/semantic_filter_esq_move_copper_entry_toward_start.awk`: semantic post-filter for `ESQ_MoveCopperEntryTowardStart` compare lane.
- `src/decomp/scripts/semantic_filter_esq_move_copper_entry_toward_end.awk`: semantic post-filter for `ESQ_MoveCopperEntryTowardEnd` compare lane.
- `src/decomp/scripts/semantic_filter_esq_generate_xor_checksum_byte.awk`: semantic post-filter for `ESQ_GenerateXorChecksumByte` compare lane.
- `src/decomp/scripts/semantic_filter_esq_terminate_after_second_quote.awk`: semantic post-filter for `ESQ_TerminateAfterSecondQuote` compare lane.
- `src/decomp/scripts/semantic_filter_esq_test_bit1_based.awk`: semantic post-filter for `ESQ_TestBit1Based` compare lane.
- `src/decomp/scripts/semantic_filter_esq_set_bit1_based.awk`: semantic post-filter for `ESQ_SetBit1Based` compare lane.
- `src/decomp/scripts/semantic_filter_esq_reverse_bits_in6_bytes.awk`: semantic post-filter for `ESQ_ReverseBitsIn6Bytes` compare lane.
- `src/decomp/scripts/semantic_filter_esq_get_half_hour_slot_index.awk`: semantic post-filter for `ESQ_GetHalfHourSlotIndex` compare lane.
- `src/decomp/scripts/semantic_filter_esq_clamp_banner_char_range.awk`: semantic post-filter for `ESQ_ClampBannerCharRange` compare lane.
- `src/decomp/scripts/semantic_filter_esq_store_ctrl_sample_entry.awk`: semantic post-filter for `ESQ_StoreCtrlSampleEntry` compare lane.
- `src/decomp/scripts/semantic_filter_esq_format_time_stamp.awk`: semantic post-filter for `ESQ_FormatTimeStamp` compare lane.
- `src/decomp/scripts/semantic_filter_esq_calc_day_of_year_from_month_day.awk`: semantic post-filter for `ESQ_CalcDayOfYearFromMonthDay` compare lane.
- `src/decomp/scripts/semantic_filter_esq_update_month_day_from_day_of_year.awk`: semantic post-filter for `ESQ_UpdateMonthDayFromDayOfYear` compare lane.
- `src/decomp/scripts/semantic_filter_esq_write_dec_fixed_width.awk`: semantic post-filter for `ESQ_WriteDecFixedWidth` compare lane.
- `src/decomp/scripts/semantic_filter_esq_pack_bits_decode.awk`: semantic post-filter for `ESQ_PackBitsDecode` compare lane.
- `src/decomp/scripts/semantic_filter_esq_seed_minute_event_thresholds.awk`: semantic post-filter for `ESQ_SeedMinuteEventThresholds` compare lane.
- `src/decomp/scripts/semantic_filter_esq_adjust_bracketed_hour_in_string.awk`: semantic post-filter for `ESQ_AdjustBracketedHourInString` compare lane.
- `src/decomp/scripts/semantic_filter_esq_wildcard_match.awk`: semantic post-filter for `ESQ_WildcardMatch` compare lane.
- `src/decomp/scripts/semantic_filter_esq_find_substring_case_fold.awk`: semantic post-filter for `ESQ_FindSubstringCaseFold` compare lane.
- `src/decomp/scripts/semantic_filter_esq_dec_copper_lists_primary.awk`: semantic post-filter for `ESQ_DecCopperListsPrimary` compare lane.
- `src/decomp/scripts/semantic_filter_esq_inc_copper_lists_towards_targets.awk`: semantic post-filter for `ESQ_IncCopperListsTowardsTargets` compare lane.
- `src/decomp/scripts/semantic_filter_esq_tick_clock_and_flag_events.awk`: semantic post-filter for `ESQ_TickClockAndFlagEvents` compare lane.
- `src/decomp/scripts/semantic_filter_esq_cold_reboot.awk`: semantic post-filter for `ESQ_ColdReboot`/`ESQ_ColdRebootViaSupervisor` compare lane.
- `src/decomp/scripts/semantic_filter_esq_tick_global_counters.awk`: semantic post-filter for `ESQ_TickGlobalCounters` compare lane.
- `src/decomp/scripts/semantic_filter_esq_advance_banner_char_index_return.awk`: semantic post-filter for `ESQ_AdvanceBannerCharIndex_Return` compare lane.
- `src/decomp/scripts/semantic_filter_esq_capture_ctrl_bit3_stream.awk`: semantic post-filter for `ESQ_CaptureCtrlBit3Stream` compare lane.
- `src/decomp/scripts/semantic_filter_esq_capture_ctrl_bit4_stream.awk`: semantic post-filter for `ESQ_CaptureCtrlBit4Stream` compare lane.
- `src/decomp/scripts/semantic_filter_esq_noop.awk`: semantic post-filter for `ESQ_NoOp` compare lane.
- `src/decomp/scripts/semantic_filter_esq_noop_006a.awk`: semantic post-filter for `ESQ_NoOp_006A` compare lane.
- `src/decomp/scripts/semantic_filter_esq_noop_0074.awk`: semantic post-filter for `ESQ_NoOp_0074` compare lane.
- `src/decomp/scripts/semantic_filter_get_bit_3_of_ciab_pra_into_d1.awk`: semantic post-filter for `GET_BIT_3_OF_CIAB_PRA_INTO_D1` compare lane.
- `src/decomp/scripts/semantic_filter_get_bit_4_of_ciab_pra_into_d1.awk`: semantic post-filter for `GET_BIT_4_OF_CIAB_PRA_INTO_D1` compare lane.
- `src/decomp/scripts/semantic_filter_esq_main_exit_noop_hook.awk`: semantic post-filter for `ESQ_MainExitNoOpHook` compare lane.
- `src/decomp/scripts/semantic_filter_dos_open_file_with_mode.awk`: semantic post-filter for `DOS_OpenFileWithMode` compare lane.
- `src/decomp/scripts/semantic_filter_graphics_alloc_raster.awk`: semantic post-filter for `GRAPHICS_AllocRaster` compare lane.
- `src/decomp/scripts/semantic_filter_graphics_free_raster.awk`: semantic post-filter for `GRAPHICS_FreeRaster` compare lane.
- `src/decomp/scripts/semantic_filter_dos_movep_word_read_callback.awk`: semantic post-filter for `DOS_MovepWordReadCallback` compare lane.
- `src/decomp/scripts/semantic_filter_unknown_parse_list_and_update_entries.awk`: semantic post-filter for `UNKNOWN_ParseListAndUpdateEntries` compare lane.
- `src/decomp/scripts/semantic_filter_esqproto_copy_label_to_global.awk`: semantic post-filter for `ESQPROTO_CopyLabelToGlobal` compare lane.
- `src/decomp/scripts/semantic_filter_esqproto_parse_digit_label_and_display.awk`: semantic post-filter for `ESQPROTO_ParseDigitLabelAndDisplay` compare lane.
- `src/decomp/scripts/semantic_filter_unknown_parse_record_and_update_display.awk`: semantic post-filter for `UNKNOWN_ParseRecordAndUpdateDisplay` compare lane.
- `src/decomp/scripts/semantic_filter_esqproto_verify_checksum_and_parse_record.awk`: semantic post-filter for `ESQPROTO_VerifyChecksumAndParseRecord` compare lane.
- `src/decomp/scripts/semantic_filter_esqproto_verify_checksum_and_parse_list.awk`: semantic post-filter for `ESQPROTO_VerifyChecksumAndParseList` compare lane.
- `src/decomp/scripts/semantic_filter_unknown36_finalize_request.awk`: semantic post-filter for `UNKNOWN36_FinalizeRequest` compare lane.
- `src/decomp/scripts/semantic_filter_unknown36_show_abort_requester.awk`: semantic post-filter for `UNKNOWN36_ShowAbortRequester` compare lane.
- `src/decomp/scripts/semantic_filter_handle_open_from_mode_string.awk`: semantic post-filter for `HANDLE_OpenFromModeString` compare lane.
- `src/decomp/scripts/semantic_filter_wdisp_format_with_callback.awk`: semantic post-filter for `WDISP_FormatWithCallback` compare lane.
- `src/decomp/scripts/semantic_filter_handle_open_entry_with_flags.awk`: semantic post-filter for `HANDLE_OpenEntryWithFlags` compare lane.
- `src/decomp/scripts/semantic_filter_buffer_ensure_allocated.awk`: semantic post-filter for `BUFFER_EnsureAllocated` compare lane.
- `src/decomp/scripts/semantic_filter_buffer_flush_all_and_close_with_code.awk`: semantic post-filter for `BUFFER_FlushAllAndCloseWithCode` compare lane.
- `src/decomp/scripts/semantic_filter_graphics_bltbitmaprastport.awk`: semantic post-filter for `GRAPHICS_BltBitMapRastPort` compare lane.
- `src/decomp/scripts/semantic_filter_math_divu32.awk`: semantic post-filter for `MATH_DivU32` compare lane.
- `src/decomp/scripts/semantic_filter_brush_planemaskforindex.awk`: semantic post-filter for `BRUSH_PlaneMaskForIndex` compare lane.
- `src/decomp/scripts/semantic_filter_brush_alloc_brush_node.awk`: semantic post-filter for `BRUSH_AllocBrushNode` compare lane.
- `src/decomp/scripts/semantic_filter_brush_free_brush_list.awk`: semantic post-filter for `BRUSH_FreeBrushList` compare lane.
- `src/decomp/scripts/semantic_filter_brush_normalize_brush_names.awk`: semantic post-filter for `BRUSH_NormalizeBrushNames` compare lane.
- `src/decomp/scripts/semantic_filter_brush_select_brush_by_label.awk`: semantic post-filter for `BRUSH_SelectBrushByLabel` compare lane.
- `src/decomp/scripts/semantic_filter_brush_free_brush_resources.awk`: semantic post-filter for `BRUSH_FreeBrushResources` compare lane.
- `src/decomp/scripts/semantic_filter_brush_populate_brush_list.awk`: semantic post-filter for `BRUSH_PopulateBrushList` compare lane.
- `src/decomp/scripts/semantic_filter_brush_stream_font_chunk.awk`: semantic post-filter for `BRUSH_StreamFontChunk` compare lane.
- `src/decomp/scripts/semantic_filter_brush_load_color_text_font.awk`: semantic post-filter for `BRUSH_LoadColorTextFont` compare lane.
- `src/decomp/scripts/semantic_filter_brush_clone_brush_record.awk`: semantic post-filter for `BRUSH_CloneBrushRecord` compare lane.
- `src/decomp/scripts/semantic_filter_brush_select_brush_slot.awk`: semantic post-filter for `BRUSH_SelectBrushSlot` compare lane.
- `src/decomp/scripts/semantic_filter_brush_load_brush_asset.awk`: semantic post-filter for `BRUSH_LoadBrushAsset` compare lane.
- `src/decomp/scripts/semantic_filter_datetime_isleapyear.awk`: semantic post-filter for `DATETIME_IsLeapYear` compare lane.
- `src/decomp/scripts/semantic_filter_datetime_adjust_month_index.awk`: semantic post-filter for `DATETIME_AdjustMonthIndex` compare lane.
- `src/decomp/scripts/semantic_filter_datetime_normalize_month_range.awk`: semantic post-filter for `DATETIME_NormalizeMonthRange` compare lane.
- `src/decomp/scripts/semantic_filter_dst_normalize_day_of_year.awk`: semantic post-filter for `DST_NormalizeDayOfYear` compare lane.
- `src/decomp/scripts/semantic_filter_dst_write_rtc_from_globals.awk`: semantic post-filter for `DST_WriteRtcFromGlobals` compare lane.
- `src/decomp/scripts/semantic_filter_dst_tick_banner_counters.awk`: semantic post-filter for `DST_TickBannerCounters` compare lane.
- `src/decomp/scripts/semantic_filter_dst_build_banner_time_word.awk`: semantic post-filter for `DST_BuildBannerTimeWord` compare lane.
- `src/decomp/scripts/semantic_filter_dst_compute_banner_index.awk`: semantic post-filter for `DST_ComputeBannerIndex` compare lane.
- `src/decomp/scripts/semantic_filter_dst_add_time_offset.awk`: semantic post-filter for `DST_AddTimeOffset` compare lane.
- `src/decomp/scripts/semantic_filter_dst_free_banner_struct.awk`: semantic post-filter for `DST_FreeBannerStruct` compare lane.
- `src/decomp/scripts/semantic_filter_dst_free_banner_pair.awk`: semantic post-filter for `DST_FreeBannerPair` compare lane.
- `src/decomp/scripts/semantic_filter_dst_allocate_banner_struct.awk`: semantic post-filter for `DST_AllocateBannerStruct` compare lane.
- `src/decomp/scripts/semantic_filter_dst_rebuild_banner_pair.awk`: semantic post-filter for `DST_RebuildBannerPair` compare lane.
- `src/decomp/scripts/semantic_filter_dst_load_banner_pair_from_files.awk`: semantic post-filter for `DST_LoadBannerPairFromFiles` compare lane.
- `src/decomp/scripts/semantic_filter_dst_handle_banner_command32_33.awk`: semantic post-filter for `DST_HandleBannerCommand32_33` compare lane.
- `src/decomp/scripts/semantic_filter_dst_format_banner_datetime.awk`: semantic post-filter for `DST_FormatBannerDateTime` compare lane.
- `src/decomp/scripts/semantic_filter_dst_refresh_banner_buffer.awk`: semantic post-filter for `DST_RefreshBannerBuffer` compare lane.
- `src/decomp/scripts/semantic_filter_dst_update_banner_queue.awk`: semantic post-filter for `DST_UpdateBannerQueue` compare lane.
- `src/decomp/scripts/semantic_filter_dst_build_banner_time_entry.awk`: semantic post-filter for `DST_BuildBannerTimeEntry` compare lane.
- `src/decomp/scripts/semantic_filter_esq_parse_command_line_and_run.awk`: semantic post-filter for `ESQ_ParseCommandLineAndRun` compare lane.
- `src/decomp/scripts/semantic_filter_stream_buffered_write_string.awk`: semantic post-filter for `STREAM_BufferedWriteString` compare lane.
- `src/decomp/scripts/semantic_filter_unknown29_jmptbl_esq_main_init_and_run.awk`: semantic post-filter for `UNKNOWN29_JMPTBL_ESQ_MainInitAndRun` compare lane.
- `src/decomp/scripts/semantic_filter_unknown_jmptbl_esqiff2_read_serial_record_into_buffer.awk`: semantic post-filter for `UNKNOWN_JMPTBL_ESQIFF2_ReadSerialRecordIntoBuffer` compare lane.
- `src/decomp/scripts/semantic_filter_unknown_jmptbl_displib_display_text_at_position.awk`: semantic post-filter for `UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition` compare lane.
- `src/decomp/scripts/semantic_filter_unknown_jmptbl_esq_wildcard_match.awk`: semantic post-filter for `UNKNOWN_JMPTBL_ESQ_WildcardMatch` compare lane.
- `src/decomp/scripts/semantic_filter_unknown_jmptbl_dst_normalize_day_of_year.awk`: semantic post-filter for `UNKNOWN_JMPTBL_DST_NormalizeDayOfYear` compare lane.
- `src/decomp/scripts/semantic_filter_unknown_jmptbl_esq_generate_xor_checksum_byte.awk`: semantic post-filter for `UNKNOWN_JMPTBL_ESQ_GenerateXorChecksumByte` compare lane.
- `src/decomp/scripts/semantic_filter_esqproto_jmptbl_esqpars_replace_owned_string.awk`: semantic post-filter for `ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString` compare lane.
- `src/decomp/scripts/semantic_filter_esqshared_jmptbl_dst_build_banner_time_word.awk`: semantic post-filter for `ESQSHARED_JMPTBL_DST_BuildBannerTimeWord` compare lane.
- `src/decomp/scripts/semantic_filter_esqshared_jmptbl_esq_reverse_bits_in6_bytes.awk`: semantic post-filter for `ESQSHARED_JMPTBL_ESQ_ReverseBitsIn6Bytes` compare lane.
- `src/decomp/scripts/semantic_filter_esqshared_jmptbl_esq_set_bit1_based.awk`: semantic post-filter for `ESQSHARED_JMPTBL_ESQ_SetBit1Based` compare lane.
- `src/decomp/scripts/semantic_filter_esqshared_jmptbl_esq_adjust_bracketed_hour_in_string.awk`: semantic post-filter for `ESQSHARED_JMPTBL_ESQ_AdjustBracketedHourInString` compare lane.
- `src/decomp/scripts/semantic_filter_esqshared_jmptbl_coi_ensure_anim_object_allocated.awk`: semantic post-filter for `ESQSHARED_JMPTBL_COI_EnsureAnimObjectAllocated` compare lane.
- `src/decomp/scripts/semantic_filter_esqshared_jmptbl_esq_wildcard_match.awk`: semantic post-filter for `ESQSHARED_JMPTBL_ESQ_WildcardMatch` compare lane.
- `src/decomp/scripts/semantic_filter_esqshared_jmptbl_str_skip_class3_chars.awk`: semantic post-filter for `ESQSHARED_JMPTBL_STR_SkipClass3Chars` compare lane.
- `src/decomp/scripts/semantic_filter_esqshared_jmptbl_esq_test_bit1_based.awk`: semantic post-filter for `ESQSHARED_JMPTBL_ESQ_TestBit1Based` compare lane.
- `src/decomp/scripts/semantic_filter_esqpars_jmptbl_diskio2_flushdatafilesifneeded.awk`: semantic post-filter for `ESQPARS_JMPTBL_DISKIO2_FlushDataFilesIfNeeded` compare lane.
- `src/decomp/scripts/semantic_filter_esqpars_jmptbl_newgrid_rebuildindexcache.awk`: semantic post-filter for `ESQPARS_JMPTBL_NEWGRID_RebuildIndexCache` compare lane.
- `src/decomp/scripts/semantic_filter_esqpars_jmptbl_datetime_savepairtofile.awk`: semantic post-filter for `ESQPARS_JMPTBL_DATETIME_SavePairToFile` compare lane.
- `src/decomp/scripts/semantic_filter_esqpars_jmptbl_esqproto_verifychecksumandparselist.awk`: semantic post-filter for `ESQPARS_JMPTBL_ESQPROTO_VerifyChecksumAndParseList` compare lane.
- `src/decomp/scripts/semantic_filter_esqpars_jmptbl_p_type_parseandstoretyperecord.awk`: semantic post-filter for `ESQPARS_JMPTBL_P_TYPE_ParseAndStoreTypeRecord` compare lane.
- `src/decomp/scripts/semantic_filter_esqpars_jmptbl_esqproto_copylabeltoglobal.awk`: semantic post-filter for `ESQPARS_JMPTBL_ESQPROTO_CopyLabelToGlobal` compare lane.
- `src/decomp/scripts/semantic_filter_esqpars_jmptbl_dst_handlebannercommand32_33.awk`: semantic post-filter for `ESQPARS_JMPTBL_DST_HandleBannerCommand32_33` compare lane.
- `src/decomp/scripts/semantic_filter_esqpars_jmptbl_esq_seedminuteeventthresholds.awk`: semantic post-filter for `ESQPARS_JMPTBL_ESQ_SeedMinuteEventThresholds` compare lane.
- `src/decomp/scripts/semantic_filter_esqpars_jmptbl_parseini_handlefontcommand.awk`: semantic post-filter for `ESQPARS_JMPTBL_PARSEINI_HandleFontCommand` compare lane.
- `src/decomp/scripts/semantic_filter_esqpars_jmptbl_textdisp_applysourceconfigallentries.awk`: semantic post-filter for `ESQPARS_JMPTBL_TEXTDISP_ApplySourceConfigAllEntries` compare lane.
- `src/decomp/scripts/semantic_filter_esqpars_jmptbl_brush_planemaskforindex.awk`: semantic post-filter for `ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex` compare lane.
- `src/decomp/scripts/semantic_filter_esqpars_jmptbl_script_resetctrlcontextandclearstatusline.awk`: semantic post-filter for `ESQPARS_JMPTBL_SCRIPT_ResetCtrlContextAndClearStatusLine` compare lane.
- `src/decomp/scripts/semantic_filter_esqpars_jmptbl_parseini_writertcfromglobals.awk`: semantic post-filter for `ESQPARS_JMPTBL_PARSEINI_WriteRtcFromGlobals` compare lane.
- `src/decomp/scripts/semantic_filter_esqpars_jmptbl_locavail_saveavailabilitydatafile.awk`: semantic post-filter for `ESQPARS_JMPTBL_LOCAVAIL_SaveAvailabilityDataFile` compare lane.
- `src/decomp/scripts/semantic_filter_esqpars_jmptbl_displib_displaytextatposition.awk`: semantic post-filter for `ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition` compare lane.
- `src/decomp/scripts/semantic_filter_esqpars_jmptbl_ladfunc_savetextadstofile.awk`: semantic post-filter for `ESQPARS_JMPTBL_LADFUNC_SaveTextAdsToFile` compare lane.
- `src/decomp/scripts/semantic_filter_esqpars_jmptbl_parse_readsignedlongskipclass3_alt.awk`: semantic post-filter for `ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt` compare lane.
- `src/decomp/scripts/semantic_filter_esqpars_jmptbl_diskio2_handleinteractivefiletransfer.awk`: semantic post-filter for `ESQPARS_JMPTBL_DISKIO2_HandleInteractiveFileTransfer` compare lane.
- `src/decomp/scripts/semantic_filter_esqpars_jmptbl_p_type_writepromoiddatafile.awk`: semantic post-filter for `ESQPARS_JMPTBL_P_TYPE_WritePromoIdDataFile` compare lane.
- `src/decomp/scripts/semantic_filter_esqpars_jmptbl_coi_freeentryresources.awk`: semantic post-filter for `ESQPARS_JMPTBL_COI_FreeEntryResources` compare lane.
- `src/decomp/scripts/semantic_filter_esqpars_jmptbl_dst_updatebannerqueue.awk`: semantic post-filter for `ESQPARS_JMPTBL_DST_UpdateBannerQueue` compare lane.
- `src/decomp/scripts/semantic_filter_esqpars_jmptbl_esqproto_verifychecksumandparserecord.awk`: semantic post-filter for `ESQPARS_JMPTBL_ESQPROTO_VerifyChecksumAndParseRecord` compare lane.
- `src/decomp/scripts/semantic_filter_esqpars_jmptbl_esqproto_parsedigitlabelanddisplay.awk`: semantic post-filter for `ESQPARS_JMPTBL_ESQPROTO_ParseDigitLabelAndDisplay` compare lane.
- `src/decomp/scripts/semantic_filter_esqpars_jmptbl_diskio_parseconfigbuffer.awk`: semantic post-filter for `ESQPARS_JMPTBL_DISKIO_ParseConfigBuffer` compare lane.
- `src/decomp/scripts/semantic_filter_esqpars_jmptbl_cleanup_parsealignedlistingblock.awk`: semantic post-filter for `ESQPARS_JMPTBL_CLEANUP_ParseAlignedListingBlock` compare lane.
- `src/decomp/scripts/semantic_filter_esqpars_jmptbl_script_readserialrbfbyte.awk`: semantic post-filter for `ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte` compare lane.
- `src/decomp/scripts/semantic_filter_esqpars_jmptbl_esq_generatexorchecksumbyte.awk`: semantic post-filter for `ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte` compare lane.
- `src/decomp/scripts/semantic_filter_esqpars_jmptbl_dst_refreshbannerbuffer.awk`: semantic post-filter for `ESQPARS_JMPTBL_DST_RefreshBannerBuffer` compare lane.
- `src/decomp/scripts/semantic_filter_esqpars_jmptbl_diskio_saveconfigtofilehandle.awk`: semantic post-filter for `ESQPARS_JMPTBL_DISKIO_SaveConfigToFileHandle` compare lane.
- `src/decomp/scripts/semantic_filter_ed1_jmptbl_newgrid_drawtopborderline.awk`: semantic post-filter for `ED1_JMPTBL_NEWGRID_DrawTopBorderLine` compare lane.
- `src/decomp/scripts/semantic_filter_ed1_jmptbl_locavail_resetfiltercursorstate.awk`: semantic post-filter for `ED1_JMPTBL_LOCAVAIL_ResetFilterCursorState` compare lane.
- `src/decomp/scripts/semantic_filter_ed1_jmptbl_gcommand_resethighlightmessages.awk`: semantic post-filter for `ED1_JMPTBL_GCOMMAND_ResetHighlightMessages` compare lane.
- `src/decomp/scripts/semantic_filter_ed1_jmptbl_ladfunc_mergehighlownibbles.awk`: semantic post-filter for `ED1_JMPTBL_LADFUNC_MergeHighLowNibbles` compare lane.
- `src/decomp/scripts/semantic_filter_ed1_jmptbl_ladfunc_savetextadstofile.awk`: semantic post-filter for `ED1_JMPTBL_LADFUNC_SaveTextAdsToFile` compare lane.
- `src/decomp/scripts/semantic_filter_ed1_jmptbl_esq_coldreboot.awk`: semantic post-filter for `ED1_JMPTBL_ESQ_ColdReboot` compare lane.
- `src/decomp/scripts/semantic_filter_ed1_jmptbl_esqshared4_loaddefaultpalettetocopper_noop.awk`: semantic post-filter for `ED1_JMPTBL_ESQSHARED4_LoadDefaultPaletteToCopper_NoOp` compare lane.
- `src/decomp/scripts/semantic_filter_ed1_jmptbl_gcommand_seedbannerdefaults.awk`: semantic post-filter for `ED1_JMPTBL_GCOMMAND_SeedBannerDefaults` compare lane.
- `src/decomp/scripts/semantic_filter_ed1_jmptbl_mem_move.awk`: semantic post-filter for `ED1_JMPTBL_MEM_Move` compare lane.
- `src/decomp/scripts/semantic_filter_ed1_jmptbl_gcommand_seedbannerfromprefs.awk`: semantic post-filter for `ED1_JMPTBL_GCOMMAND_SeedBannerFromPrefs` compare lane.
- `src/decomp/scripts/semantic_filter_ed1_jmptbl_cleanup_drawdatetimebannerrow.awk`: semantic post-filter for `ED1_JMPTBL_CLEANUP_DrawDateTimeBannerRow` compare lane.
- `src/decomp/scripts/semantic_filter_ed1_jmptbl_ladfunc_packnibblestobyte.awk`: semantic post-filter for `ED1_JMPTBL_LADFUNC_PackNibblesToByte` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_textdisp_setrastformode.awk`: semantic post-filter for `ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_p_type_promotesecondarylist.awk`: semantic post-filter for `ESQFUNC_JMPTBL_P_TYPE_PromoteSecondaryList` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_diskio_probedrivesandassignpaths.awk`: semantic post-filter for `ESQFUNC_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_parseini_updatectrlhdeltamax.awk`: semantic post-filter for `ESQFUNC_JMPTBL_PARSEINI_UpdateCtrlHDeltaMax` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_esq_clampbannercharrange.awk`: semantic post-filter for `ESQFUNC_JMPTBL_ESQ_ClampBannerCharRange` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_script_readciabbit3flag.awk`: semantic post-filter for `ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit3Flag` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_tliba3_drawcenteredwrappedtextlines.awk`: semantic post-filter for `ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_script_getctrllineflag.awk`: semantic post-filter for `ESQFUNC_JMPTBL_SCRIPT_GetCtrlLineFlag` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_locavail_syncsecondaryfilterforcurrentgroup.awk`: semantic post-filter for `ESQFUNC_JMPTBL_LOCAVAIL_SyncSecondaryFilterForCurrentGroup` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_textdisp_resetselectionandrefresh.awk`: semantic post-filter for `ESQFUNC_JMPTBL_TEXTDISP_ResetSelectionAndRefresh` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_parseini_monitorclockchange.awk`: semantic post-filter for `ESQFUNC_JMPTBL_PARSEINI_MonitorClockChange` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_ladfunc_parsehexdigit.awk`: semantic post-filter for `ESQFUNC_JMPTBL_LADFUNC_ParseHexDigit` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_cleanup_processalerts.awk`: semantic post-filter for `ESQFUNC_JMPTBL_CLEANUP_ProcessAlerts` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_esq_gethalfhourslotindex.awk`: semantic post-filter for `ESQFUNC_JMPTBL_ESQ_GetHalfHourSlotIndex` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_cleanup_drawclockbanner.awk`: semantic post-filter for `ESQFUNC_JMPTBL_CLEANUP_DrawClockBanner` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_parseini_computehtcmaxvalues.awk`: semantic post-filter for `ESQFUNC_JMPTBL_PARSEINI_ComputeHTCMaxValues` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_ladfunc_updatehighlightstate.awk`: semantic post-filter for `ESQFUNC_JMPTBL_LADFUNC_UpdateHighlightState` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_p_type_ensuresecondarylist.awk`: semantic post-filter for `ESQFUNC_JMPTBL_P_TYPE_EnsureSecondaryList` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_script_readciabbit5mask.awk`: semantic post-filter for `ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit5Mask` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_parseini_normalizeclockdata.awk`: semantic post-filter for `ESQFUNC_JMPTBL_PARSEINI_NormalizeClockData` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_esq_tickglobalcounters.awk`: semantic post-filter for `ESQFUNC_JMPTBL_ESQ_TickGlobalCounters` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_script_handleserialctrlcmd.awk`: semantic post-filter for `ESQFUNC_JMPTBL_SCRIPT_HandleSerialCtrlCmd` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_esq_handleserialrbfinterrupt.awk`: semantic post-filter for `ESQFUNC_JMPTBL_ESQ_HandleSerialRbfInterrupt` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_textdisp_tickdisplaystate.awk`: semantic post-filter for `ESQFUNC_JMPTBL_TEXTDISP_TickDisplayState` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_esq_pollctrlinput.awk`: semantic post-filter for `ESQFUNC_JMPTBL_ESQ_PollCtrlInput` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_locavail_rebuildfilterstatefromcurrentgroup.awk`: semantic post-filter for `ESQFUNC_JMPTBL_LOCAVAIL_RebuildFilterStateFromCurrentGroup` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_string_copypadnul.awk`: semantic post-filter for `ESQFUNC_JMPTBL_STRING_CopyPadNul` compare lane.
- `src/decomp/scripts/semantic_filter_esqdisp_jmptbl_newgrid_processgridmessages.awk`: semantic post-filter for `ESQDISP_JMPTBL_NEWGRID_ProcessGridMessages` compare lane.
- `src/decomp/scripts/semantic_filter_esqdisp_jmptbl_graphics_allocraster.awk`: semantic post-filter for `ESQDISP_JMPTBL_GRAPHICS_AllocRaster` compare lane.
- `src/decomp/scripts/semantic_filter_group_ag_jmptbl_memory_deallocate_memory.awk`: semantic post-filter for `GROUP_AG_JMPTBL_MEMORY_DeallocateMemory` compare lane.
- `src/decomp/scripts/semantic_filter_group_ag_jmptbl_memory_allocate_memory.awk`: semantic post-filter for `GROUP_AG_JMPTBL_MEMORY_AllocateMemory` compare lane.
- `src/decomp/scripts/semantic_filter_group_ag_jmptbl_struct_alloc_with_owner.awk`: semantic post-filter for `GROUP_AG_JMPTBL_STRUCT_AllocWithOwner` compare lane.
- `src/decomp/scripts/semantic_filter_group_ag_jmptbl_struct_free_with_size_field.awk`: semantic post-filter for `GROUP_AG_JMPTBL_STRUCT_FreeWithSizeField` compare lane.
- `src/decomp/scripts/semantic_filter_group_ag_jmptbl_math_divs32.awk`: semantic post-filter for `GROUP_AG_JMPTBL_MATH_DivS32` compare lane.
- `src/decomp/scripts/semantic_filter_group_ag_jmptbl_math_mulu32.awk`: semantic post-filter for `GROUP_AG_JMPTBL_MATH_Mulu32` compare lane.
- `src/decomp/scripts/semantic_filter_group_ag_jmptbl_dos_open_file_with_mode.awk`: semantic post-filter for `GROUP_AG_JMPTBL_DOS_OpenFileWithMode` compare lane.
- `src/decomp/scripts/semantic_filter_group_ag_jmptbl_string_copy_pad_nul.awk`: semantic post-filter for `GROUP_AG_JMPTBL_STRING_CopyPadNul` compare lane.
- `src/decomp/scripts/semantic_filter_group_ag_jmptbl_parse_read_signed_long_skip_class3_alt.awk`: semantic post-filter for `GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt` compare lane.
- `src/decomp/scripts/semantic_filter_group_ag_jmptbl_signal_create_msgport_with_signal.awk`: semantic post-filter for `GROUP_AG_JMPTBL_SIGNAL_CreateMsgPortWithSignal` compare lane.
- `src/decomp/scripts/semantic_filter_group_ag_jmptbl_textdisp_reset_selection_and_refresh.awk`: semantic post-filter for `GROUP_AG_JMPTBL_TEXTDISP_ResetSelectionAndRefresh` compare lane.
- `src/decomp/scripts/semantic_filter_group_ag_jmptbl_iostdreq_cleanup_signal_and_msgport.awk`: semantic post-filter for `GROUP_AG_JMPTBL_IOSTDREQ_CleanupSignalAndMsgport` compare lane.
- `src/decomp/scripts/semantic_filter_group_ag_jmptbl_esqfunc_service_ui_tick_if_running.awk`: semantic post-filter for `GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning` compare lane.
- `src/decomp/scripts/semantic_filter_group_ag_jmptbl_script_begin_banner_char_transition.awk`: semantic post-filter for `GROUP_AG_JMPTBL_SCRIPT_BeginBannerCharTransition` compare lane.
- `src/decomp/scripts/semantic_filter_group_ag_jmptbl_ladfunc2_emit_escaped_string_to_scratch.awk`: semantic post-filter for `GROUP_AG_JMPTBL_LADFUNC2_EmitEscapedStringToScratch` compare lane.
- `src/decomp/scripts/semantic_filter_group_ag_jmptbl_script_check_path_exists.awk`: semantic post-filter for `GROUP_AG_JMPTBL_SCRIPT_CheckPathExists` compare lane.
- `src/decomp/scripts/semantic_filter_group_ag_jmptbl_esqfunc_update_refresh_mode_state.awk`: semantic post-filter for `GROUP_AG_JMPTBL_ESQFUNC_UpdateRefreshModeState` compare lane.
- `src/decomp/scripts/semantic_filter_group_am_jmptbl_signal_create_msgport_with_signal.awk`: semantic post-filter for `GROUP_AM_JMPTBL_SIGNAL_CreateMsgPortWithSignal` compare lane.
- `src/decomp/scripts/semantic_filter_group_am_jmptbl_struct_alloc_with_owner.awk`: semantic post-filter for `GROUP_AM_JMPTBL_STRUCT_AllocWithOwner` compare lane.
- `src/decomp/scripts/semantic_filter_group_am_jmptbl_list_init_header.awk`: semantic post-filter for `GROUP_AM_JMPTBL_LIST_InitHeader` compare lane.
- `src/decomp/scripts/semantic_filter_group_am_jmptbl_ladfunc_clear_banner_rect_entries.awk`: semantic post-filter for `GROUP_AM_JMPTBL_LADFUNC_ClearBannerRectEntries` compare lane.
- `src/decomp/scripts/semantic_filter_group_am_jmptbl_parseini_update_clock_from_rtc.awk`: semantic post-filter for `GROUP_AM_JMPTBL_PARSEINI_UpdateClockFromRtc` compare lane.
- `src/decomp/scripts/semantic_filter_group_am_jmptbl_script_init_ctrl_context.awk`: semantic post-filter for `GROUP_AM_JMPTBL_SCRIPT_InitCtrlContext` compare lane.
- `src/decomp/scripts/semantic_filter_group_am_jmptbl_diskio2_parse_ini_file_from_disk.awk`: semantic post-filter for `GROUP_AM_JMPTBL_DISKIO2_ParseIniFileFromDisk` compare lane.
- `src/decomp/scripts/semantic_filter_group_am_jmptbl_esq_check_topaz_font_guard.awk`: semantic post-filter for `GROUP_AM_JMPTBL_ESQ_CheckTopazFontGuard` compare lane.
- `src/decomp/scripts/semantic_filter_group_am_jmptbl_p_type_reset_lists_and_load_promo_ids.awk`: semantic post-filter for `GROUP_AM_JMPTBL_P_TYPE_ResetListsAndLoadPromoIds` compare lane.
- `src/decomp/scripts/semantic_filter_group_am_jmptbl_ladfunc_load_text_ads_from_file.awk`: semantic post-filter for `GROUP_AM_JMPTBL_LADFUNC_LoadTextAdsFromFile` compare lane.
- `src/decomp/scripts/semantic_filter_group_am_jmptbl_diskio_load_config_from_disk.awk`: semantic post-filter for `GROUP_AM_JMPTBL_DISKIO_LoadConfigFromDisk` compare lane.
- `src/decomp/scripts/semantic_filter_group_am_jmptbl_textdisp_load_source_config.awk`: semantic post-filter for `GROUP_AM_JMPTBL_TEXTDISP_LoadSourceConfig` compare lane.
- `src/decomp/scripts/semantic_filter_group_am_jmptbl_kybd_initialize_input_devices.awk`: semantic post-filter for `GROUP_AM_JMPTBL_KYBD_InitializeInputDevices` compare lane.
- `src/decomp/scripts/semantic_filter_group_am_jmptbl_esq_check_compatible_video_chip.awk`: semantic post-filter for `GROUP_AM_JMPTBL_ESQ_CheckCompatibleVideoChip` compare lane.
- `src/decomp/scripts/semantic_filter_group_am_jmptbl_esq_check_available_fast_memory.awk`: semantic post-filter for `GROUP_AM_JMPTBL_ESQ_CheckAvailableFastMemory` compare lane.
- `src/decomp/scripts/semantic_filter_group_am_jmptbl_gcommand_reset_banner_fade_state.awk`: semantic post-filter for `GROUP_AM_JMPTBL_GCOMMAND_ResetBannerFadeState` compare lane.
- `src/decomp/scripts/semantic_filter_group_am_jmptbl_tliba3_init_pattern_table.awk`: semantic post-filter for `GROUP_AM_JMPTBL_TLIBA3_InitPatternTable` compare lane.
- `src/decomp/scripts/semantic_filter_group_am_jmptbl_esq_format_disk_error_message.awk`: semantic post-filter for `GROUP_AM_JMPTBL_ESQ_FormatDiskErrorMessage` compare lane.
- `src/decomp/scripts/semantic_filter_group_am_jmptbl_script_prime_banner_transition_from_hex_code.awk`: semantic post-filter for `GROUP_AM_JMPTBL_SCRIPT_PrimeBannerTransitionFromHexCode` compare lane.
- `src/decomp/scripts/semantic_filter_group_am_jmptbl_locavail_reset_filter_state_struct.awk`: semantic post-filter for `GROUP_AM_JMPTBL_LOCAVAIL_ResetFilterStateStruct` compare lane.
- `src/decomp/scripts/semantic_filter_group_am_jmptbl_esq_init_audio1_dma.awk`: semantic post-filter for `GROUP_AM_JMPTBL_ESQ_InitAudio1Dma` compare lane.
- `src/decomp/scripts/semantic_filter_group_am_jmptbl_esq_set_copper_effect_on_enable_highlight.awk`: semantic post-filter for `GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight` compare lane.
- `src/decomp/scripts/semantic_filter_group_am_jmptbl_locavail_load_availability_data_file.awk`: semantic post-filter for `GROUP_AM_JMPTBL_LOCAVAIL_LoadAvailabilityDataFile` compare lane.
- `src/decomp/scripts/semantic_filter_group_am_jmptbl_gcommand_init_preset_defaults.awk`: semantic post-filter for `GROUP_AM_JMPTBL_GCOMMAND_InitPresetDefaults` compare lane.
- `src/decomp/scripts/semantic_filter_group_am_jmptbl_override_intuition_funcs.awk`: semantic post-filter for `GROUP_AM_JMPTBL_OVERRIDE_INTUITION_FUNCS` compare lane.
- `src/decomp/scripts/semantic_filter_group_am_jmptbl_buffer_flush_all_and_close_with_code.awk`: semantic post-filter for `GROUP_AM_JMPTBL_BUFFER_FlushAllAndCloseWithCode` compare lane.
- `src/decomp/scripts/semantic_filter_group_am_jmptbl_flib2_reset_and_load_listing_templates.awk`: semantic post-filter for `GROUP_AM_JMPTBL_FLIB2_ResetAndLoadListingTemplates` compare lane.
- `src/decomp/scripts/semantic_filter_group_am_jmptbl_wdisp_s_printf.awk`: semantic post-filter for `GROUP_AM_JMPTBL_WDISP_SPrintf` compare lane.
- `src/decomp/scripts/semantic_filter_group_am_jmptbl_esq_set_copper_effect_off_disable_highlight.awk`: semantic post-filter for `GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight` compare lane.
- `src/decomp/scripts/semantic_filter_group_am_jmptbl_cleanup_shutdown_system.awk`: semantic post-filter for `GROUP_AM_JMPTBL_CLEANUP_ShutdownSystem` compare lane.
- `src/decomp/scripts/semantic_filter_group_am_jmptbl_ladfunc_alloc_banner_rect_entries.awk`: semantic post-filter for `GROUP_AM_JMPTBL_LADFUNC_AllocBannerRectEntries` compare lane.
- `src/decomp/scripts/semantic_filter_esqiff_jmptbl_string_compare_nocase.awk`: semantic post-filter for `ESQIFF_JMPTBL_STRING_CompareNoCase` compare lane.
- `src/decomp/scripts/semantic_filter_esqiff_jmptbl_string_compare_n.awk`: semantic post-filter for `ESQIFF_JMPTBL_STRING_CompareN` compare lane.
- `src/decomp/scripts/semantic_filter_esqiff_jmptbl_string_compare_nocase_n.awk`: semantic post-filter for `ESQIFF_JMPTBL_STRING_CompareNoCaseN` compare lane.
- `src/decomp/scripts/semantic_filter_esqiff_jmptbl_math_divs32.awk`: semantic post-filter for `ESQIFF_JMPTBL_MATH_DivS32` compare lane.
- `src/decomp/scripts/semantic_filter_esqiff_jmptbl_esq_noop.awk`: semantic post-filter for `ESQIFF_JMPTBL_ESQ_NoOp` compare lane.
- `src/decomp/scripts/semantic_filter_esqiff_jmptbl_memory_deallocate_memory.awk`: semantic post-filter for `ESQIFF_JMPTBL_MEMORY_DeallocateMemory` compare lane.
- `src/decomp/scripts/semantic_filter_esqiff_jmptbl_esq_noop_006a.awk`: semantic post-filter for `ESQIFF_JMPTBL_ESQ_NoOp_006A` compare lane.
- `src/decomp/scripts/semantic_filter_esqiff_jmptbl_esq_noop_0074.awk`: semantic post-filter for `ESQIFF_JMPTBL_ESQ_NoOp_0074` compare lane.
- `src/decomp/scripts/semantic_filter_esqiff_jmptbl_memory_allocate_memory.awk`: semantic post-filter for `ESQIFF_JMPTBL_MEMORY_AllocateMemory` compare lane.
- `src/decomp/scripts/semantic_filter_esqiff_jmptbl_dos_open_file_with_mode.awk`: semantic post-filter for `ESQIFF_JMPTBL_DOS_OpenFileWithMode` compare lane.
- `src/decomp/scripts/semantic_filter_esqiff_jmptbl_math_mulu32.awk`: semantic post-filter for `ESQIFF_JMPTBL_MATH_Mulu32` compare lane.
- `src/decomp/scripts/semantic_filter_esqiff_jmptbl_diskio_reset_ctrl_input_state_if_idle.awk`: semantic post-filter for `ESQIFF_JMPTBL_DISKIO_ResetCtrlInputStateIfIdle` compare lane.
- `src/decomp/scripts/semantic_filter_esqiff_jmptbl_diskio_get_filesize_from_handle.awk`: semantic post-filter for `ESQIFF_JMPTBL_DISKIO_GetFilesizeFromHandle` compare lane.
- `src/decomp/scripts/semantic_filter_esqiff_jmptbl_diskio_force_ui_refresh_if_idle.awk`: semantic post-filter for `ESQIFF_JMPTBL_DISKIO_ForceUiRefreshIfIdle` compare lane.
- `src/decomp/scripts/semantic_filter_esqiff_jmptbl_esq_inc_copper_lists_towards_targets.awk`: semantic post-filter for `ESQIFF_JMPTBL_ESQ_IncCopperListsTowardsTargets` compare lane.
- `src/decomp/scripts/semantic_filter_esqiff_jmptbl_esq_dec_copper_lists_primary.awk`: semantic post-filter for `ESQIFF_JMPTBL_ESQ_DecCopperListsPrimary` compare lane.
- `src/decomp/scripts/semantic_filter_esqiff_jmptbl_ctasks_start_iff_task_process.awk`: semantic post-filter for `ESQIFF_JMPTBL_CTASKS_StartIffTaskProcess` compare lane.
- `src/decomp/scripts/semantic_filter_esqiff_jmptbl_script_assert_ctrl_line_if_enabled.awk`: semantic post-filter for `ESQIFF_JMPTBL_SCRIPT_AssertCtrlLineIfEnabled` compare lane.
- `src/decomp/scripts/semantic_filter_esqiff_jmptbl_esq_move_copper_entry_toward_start.awk`: semantic post-filter for `ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart` compare lane.
- `src/decomp/scripts/semantic_filter_esqiff_jmptbl_esq_move_copper_entry_toward_end.awk`: semantic post-filter for `ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd` compare lane.
- `src/decomp/scripts/semantic_filter_esqiff_jmptbl_brush_clone_brush_record.awk`: semantic post-filter for `ESQIFF_JMPTBL_BRUSH_CloneBrushRecord` compare lane.
- `src/decomp/scripts/semantic_filter_esqiff_jmptbl_brush_find_type3_brush.awk`: semantic post-filter for `ESQIFF_JMPTBL_BRUSH_FindType3Brush` compare lane.
- `src/decomp/scripts/semantic_filter_esqiff_jmptbl_brush_pop_brush_head.awk`: semantic post-filter for `ESQIFF_JMPTBL_BRUSH_PopBrushHead` compare lane.
- `src/decomp/scripts/semantic_filter_esqiff_jmptbl_brush_alloc_brush_node.awk`: semantic post-filter for `ESQIFF_JMPTBL_BRUSH_AllocBrushNode` compare lane.
- `src/decomp/scripts/semantic_filter_esqiff_jmptbl_brush_find_brush_by_predicate.awk`: semantic post-filter for `ESQIFF_JMPTBL_BRUSH_FindBrushByPredicate` compare lane.
- `src/decomp/scripts/semantic_filter_esqiff_jmptbl_brush_free_brush_list.awk`: semantic post-filter for `ESQIFF_JMPTBL_BRUSH_FreeBrushList` compare lane.
- `src/decomp/scripts/semantic_filter_esqiff_jmptbl_brush_select_brush_by_label.awk`: semantic post-filter for `ESQIFF_JMPTBL_BRUSH_SelectBrushByLabel` compare lane.
- `src/decomp/scripts/semantic_filter_esqiff_jmptbl_textdisp_find_entry_index_by_wildcard.awk`: semantic post-filter for `ESQIFF_JMPTBL_TEXTDISP_FindEntryIndexByWildcard` compare lane.
- `src/decomp/scripts/semantic_filter_esqiff_jmptbl_textdisp_draw_channel_banner.awk`: semantic post-filter for `ESQIFF_JMPTBL_TEXTDISP_DrawChannelBanner` compare lane.
- `src/decomp/scripts/semantic_filter_esqiff_jmptbl_newgrid_validate_selection_code.awk`: semantic post-filter for `ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode` compare lane.
- `src/decomp/scripts/semantic_filter_esqiff_jmptbl_brush_populate_brush_list.awk`: semantic post-filter for `ESQIFF_JMPTBL_BRUSH_PopulateBrushList` compare lane.
- `src/decomp/scripts/semantic_filter_esqiff_jmptbl_script_begin_banner_char_transition.awk`: semantic post-filter for `ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition` compare lane.
- `src/decomp/scripts/semantic_filter_esqiff_jmptbl_tliba3_build_display_context_for_view_mode.awk`: semantic post-filter for `ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode` compare lane.
- `src/decomp/scripts/semantic_filter_esqiff_jmptbl_brush_select_brush_slot.awk`: semantic post-filter for `ESQIFF_JMPTBL_BRUSH_SelectBrushSlot` compare lane.
- `src/decomp/scripts/semantic_filter_group_aw_jmptbl_tliba3_build_display_context_for_view_mode.awk`: semantic post-filter for `GROUP_AW_JMPTBL_TLIBA3_BuildDisplayContextForViewMode` compare lane.
- `src/decomp/scripts/semantic_filter_group_aw_jmptbl_displib_apply_inline_alignment_padding.awk`: semantic post-filter for `GROUP_AW_JMPTBL_DISPLIB_ApplyInlineAlignmentPadding` compare lane.
- `src/decomp/scripts/semantic_filter_group_aw_jmptbl_esqiff_run_copper_rise_transition.awk`: semantic post-filter for `GROUP_AW_JMPTBL_ESQIFF_RunCopperRiseTransition` compare lane.
- `src/decomp/scripts/semantic_filter_group_aw_jmptbl_esqiff_run_copper_drop_transition.awk`: semantic post-filter for `GROUP_AW_JMPTBL_ESQIFF_RunCopperDropTransition` compare lane.
- `src/decomp/scripts/semantic_filter_group_aw_jmptbl_displib_display_text_at_position.awk`: semantic post-filter for `GROUP_AW_JMPTBL_DISPLIB_DisplayTextAtPosition` compare lane.
- `src/decomp/scripts/semantic_filter_group_ad_jmptbl_tliba3_build_display_context_for_view_mode.awk`: semantic post-filter for `GROUP_AD_JMPTBL_TLIBA3_BuildDisplayContextForViewMode` compare lane.
- `src/decomp/scripts/semantic_filter_group_aw_jmptbl_mem_move.awk`: semantic post-filter for `GROUP_AW_JMPTBL_MEM_Move` compare lane.
- `src/decomp/scripts/semantic_filter_group_aw_jmptbl_wdisp_sprintf.awk`: semantic post-filter for `GROUP_AW_JMPTBL_WDISP_SPrintf` compare lane.
- `src/decomp/scripts/semantic_filter_group_aw_jmptbl_esq_set_copper_effect_off_disable_highlight.awk`: semantic post-filter for `GROUP_AW_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight` compare lane.
- `src/decomp/scripts/semantic_filter_group_aw_jmptbl_string_copy_pad_nul.awk`: semantic post-filter for `GROUP_AW_JMPTBL_STRING_CopyPadNul` compare lane.
- `src/decomp/scripts/semantic_filter_group_as_jmptbl_str_find_char_ptr.awk`: semantic post-filter for `GROUP_AS_JMPTBL_STR_FindCharPtr` compare lane.
- `src/decomp/scripts/semantic_filter_group_as_jmptbl_esq_find_substring_case_fold.awk`: semantic post-filter for `GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold` compare lane.
- `src/decomp/scripts/semantic_filter_group_at_jmptbl_ed1_wait_for_flag_and_clear_bit0.awk`: semantic post-filter for `GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit0` compare lane.
- `src/decomp/scripts/semantic_filter_group_at_jmptbl_dos_system_taglist.awk`: semantic post-filter for `GROUP_AT_JMPTBL_DOS_SystemTagList` compare lane.
- `src/decomp/scripts/semantic_filter_group_at_jmptbl_ed1_wait_for_flag_and_clear_bit1.awk`: semantic post-filter for `GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit1` compare lane.
- `src/decomp/scripts/semantic_filter_group_au_jmptbl_brush_append_brush_node.awk`: semantic post-filter for `GROUP_AU_JMPTBL_BRUSH_AppendBrushNode` compare lane.
- `src/decomp/scripts/semantic_filter_group_au_jmptbl_brush_populate_brush_list.awk`: semantic post-filter for `GROUP_AU_JMPTBL_BRUSH_PopulateBrushList` compare lane.
- `src/decomp/scripts/semantic_filter_group_ax_jmptbl_format_raw_dofmt_with_scratch_buffer.awk`: semantic post-filter for `GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer` compare lane.
- `src/decomp/scripts/semantic_filter_group_az_jmptbl_esq_cold_reboot.awk`: semantic post-filter for `GROUP_AZ_JMPTBL_ESQ_ColdReboot` compare lane.
- `src/decomp/scripts/semantic_filter_group_aa_jmptbl_gcommand_find_path_separator.awk`: semantic post-filter for `GROUP_AA_JMPTBL_GCOMMAND_FindPathSeparator` compare lane.
- `src/decomp/scripts/semantic_filter_group_aa_jmptbl_graphics_alloc_raster.awk`: semantic post-filter for `GROUP_AA_JMPTBL_GRAPHICS_AllocRaster` compare lane.
- `src/decomp/scripts/semantic_filter_group_af_jmptbl_gcommand_save_brush_result.awk`: semantic post-filter for `GROUP_AF_JMPTBL_GCOMMAND_SaveBrushResult` compare lane.
- `src/decomp/scripts/semantic_filter_group_ai_jmptbl_newgrid_set_selection_markers.awk`: semantic post-filter for `GROUP_AI_JMPTBL_NEWGRID_SetSelectionMarkers` compare lane.
- `src/decomp/scripts/semantic_filter_group_ai_jmptbl_str_find_char_ptr.awk`: semantic post-filter for `GROUP_AI_JMPTBL_STR_FindCharPtr` compare lane.
- `src/decomp/scripts/semantic_filter_group_ai_jmptbl_tliba1_draw_text_with_inset_segments.awk`: semantic post-filter for `GROUP_AI_JMPTBL_TLIBA1_DrawTextWithInsetSegments` compare lane.
- `src/decomp/scripts/semantic_filter_group_ai_jmptbl_format_format_to_buffer2.awk`: semantic post-filter for `GROUP_AI_JMPTBL_FORMAT_FormatToBuffer2` compare lane.
- `src/decomp/scripts/semantic_filter_group_ai_jmptbl_str_skip_class3_chars.awk`: semantic post-filter for `GROUP_AI_JMPTBL_STR_SkipClass3Chars` compare lane.
- `src/decomp/scripts/semantic_filter_group_ai_jmptbl_string_append_at_null.awk`: semantic post-filter for `GROUP_AI_JMPTBL_STRING_AppendAtNull` compare lane.
- `src/decomp/scripts/semantic_filter_group_ai_jmptbl_str_copy_until_any_delim_n.awk`: semantic post-filter for `GROUP_AI_JMPTBL_STR_CopyUntilAnyDelimN` compare lane.
- `src/decomp/scripts/semantic_filter_group_ab_jmptbl_esqpars_remove_group_entry_and_release_strings.awk`: semantic post-filter for `GROUP_AB_JMPTBL_ESQPARS_RemoveGroupEntryAndReleaseStrings` compare lane.
- `src/decomp/scripts/semantic_filter_group_ab_jmptbl_esqfunc_free_line_text_buffers.awk`: semantic post-filter for `GROUP_AB_JMPTBL_ESQFUNC_FreeLineTextBuffers` compare lane.
- `src/decomp/scripts/semantic_filter_group_ab_jmptbl_esqiff_deallocate_ads_and_logo_lst_data.awk`: semantic post-filter for `GROUP_AB_JMPTBL_ESQIFF_DeallocateAdsAndLogoLstData` compare lane.
- `src/decomp/scripts/semantic_filter_group_ab_jmptbl_ladfunc_free_banner_rect_entries.awk`: semantic post-filter for `GROUP_AB_JMPTBL_LADFUNC_FreeBannerRectEntries` compare lane.
- `src/decomp/scripts/semantic_filter_group_ab_jmptbl_unknown2_a_stub0.awk`: semantic post-filter for `GROUP_AB_JMPTBL_UNKNOWN2A_Stub0` compare lane.
- `src/decomp/scripts/semantic_filter_group_ab_jmptbl_newgrid_shutdown_grid_resources.awk`: semantic post-filter for `GROUP_AB_JMPTBL_NEWGRID_ShutdownGridResources` compare lane.
- `src/decomp/scripts/semantic_filter_group_ab_jmptbl_locavail_free_resource_chain.awk`: semantic post-filter for `GROUP_AB_JMPTBL_LOCAVAIL_FreeResourceChain` compare lane.
- `src/decomp/scripts/semantic_filter_group_ab_jmptbl_graphics_free_raster.awk`: semantic post-filter for `GROUP_AB_JMPTBL_GRAPHICS_FreeRaster` compare lane.
- `src/decomp/scripts/semantic_filter_group_ab_jmptbl_iostdreq_free.awk`: semantic post-filter for `GROUP_AB_JMPTBL_IOSTDREQ_Free` compare lane.
- `src/decomp/scripts/semantic_filter_group_ab_jmptbl_esqiff2_clear_line_head_tail_by_mode.awk`: semantic post-filter for `GROUP_AB_JMPTBL_ESQIFF2_ClearLineHeadTailByMode` compare lane.
- `src/decomp/scripts/semantic_filter_group_ac_jmptbl_parseini_update_clock_from_rtc.awk`: semantic post-filter for `GROUP_AC_JMPTBL_PARSEINI_UpdateClockFromRtc` compare lane.
- `src/decomp/scripts/semantic_filter_group_ac_jmptbl_esqfunc_draw_diagnostics_screen.awk`: semantic post-filter for `GROUP_AC_JMPTBL_ESQFUNC_DrawDiagnosticsScreen` compare lane.
- `src/decomp/scripts/semantic_filter_group_ac_jmptbl_esqfunc_draw_memory_status_screen.awk`: semantic post-filter for `GROUP_AC_JMPTBL_ESQFUNC_DrawMemoryStatusScreen` compare lane.
- `src/decomp/scripts/semantic_filter_group_ac_jmptbl_script_update_ctrl_state_machine.awk`: semantic post-filter for `GROUP_AC_JMPTBL_SCRIPT_UpdateCtrlStateMachine` compare lane.
- `src/decomp/scripts/semantic_filter_group_ac_jmptbl_gcommand_update_banner_bounds.awk`: semantic post-filter for `GROUP_AC_JMPTBL_GCOMMAND_UpdateBannerBounds` compare lane.
- `src/decomp/scripts/semantic_filter_group_ac_jmptbl_script_update_ctrl_line_timeout.awk`: semantic post-filter for `GROUP_AC_JMPTBL_SCRIPT_UpdateCtrlLineTimeout` compare lane.
- `src/decomp/scripts/semantic_filter_group_ac_jmptbl_script_clear_ctrl_line_if_enabled.awk`: semantic post-filter for `GROUP_AC_JMPTBL_SCRIPT_ClearCtrlLineIfEnabled` compare lane.
- `src/decomp/scripts/semantic_filter_group_ac_jmptbl_esqfunc_free_extra_title_text_pointers.awk`: semantic post-filter for `GROUP_AC_JMPTBL_ESQFUNC_FreeExtraTitleTextPointers` compare lane.
- `src/decomp/scripts/semantic_filter_group_ac_jmptbl_esqdisp_draw_status_banner.awk`: semantic post-filter for `GROUP_AC_JMPTBL_ESQDISP_DrawStatusBanner` compare lane.
- `src/decomp/scripts/semantic_filter_group_ac_jmptbl_dst_update_banner_queue.awk`: semantic post-filter for `GROUP_AC_JMPTBL_DST_UpdateBannerQueue` compare lane.
- `src/decomp/scripts/semantic_filter_group_ac_jmptbl_dst_refresh_banner_buffer.awk`: semantic post-filter for `GROUP_AC_JMPTBL_DST_RefreshBannerBuffer` compare lane.
- `src/decomp/scripts/semantic_filter_group_ac_jmptbl_esqfunc_draw_esc_menu_version.awk`: semantic post-filter for `GROUP_AC_JMPTBL_ESQFUNC_DrawEscMenuVersion` compare lane.
- `src/decomp/scripts/semantic_filter_group_ac_jmptbl_parseini_adjust_hours_to24_hr_format.awk`: semantic post-filter for `GROUP_AC_JMPTBL_PARSEINI_AdjustHoursTo24HrFormat` compare lane.
- `src/decomp/scripts/semantic_filter_group_ae_jmptbl_tliba_find_first_wildcard_match_index.awk`: semantic post-filter for `GROUP_AE_JMPTBL_TLIBA_FindFirstWildcardMatchIndex` compare lane.
- `src/decomp/scripts/semantic_filter_group_ae_jmptbl_script_build_token_index_map.awk`: semantic post-filter for `GROUP_AE_JMPTBL_SCRIPT_BuildTokenIndexMap` compare lane.
- `src/decomp/scripts/semantic_filter_group_ae_jmptbl_esqdisp_get_entry_aux_pointer_by_mode.awk`: semantic post-filter for `GROUP_AE_JMPTBL_ESQDISP_GetEntryAuxPointerByMode` compare lane.
- `src/decomp/scripts/semantic_filter_group_ae_jmptbl_esqdisp_get_entry_pointer_by_mode.awk`: semantic post-filter for `GROUP_AE_JMPTBL_ESQDISP_GetEntryPointerByMode` compare lane.
- `src/decomp/scripts/semantic_filter_group_ae_jmptbl_ladfunc_parse_hex_digit.awk`: semantic post-filter for `GROUP_AE_JMPTBL_LADFUNC_ParseHexDigit` compare lane.
- `src/decomp/scripts/semantic_filter_group_ae_jmptbl_script_deallocate_buffer_array.awk`: semantic post-filter for `GROUP_AE_JMPTBL_SCRIPT_DeallocateBufferArray` compare lane.
- `src/decomp/scripts/semantic_filter_group_ae_jmptbl_wdisp_s_printf.awk`: semantic post-filter for `GROUP_AE_JMPTBL_WDISP_SPrintf` compare lane.
- `src/decomp/scripts/semantic_filter_group_ae_jmptbl_script_allocate_buffer_array.awk`: semantic post-filter for `GROUP_AE_JMPTBL_SCRIPT_AllocateBufferArray` compare lane.
- `src/decomp/scripts/semantic_filter_group_ae_jmptbl_textdisp_compute_time_offset.awk`: semantic post-filter for `GROUP_AE_JMPTBL_TEXTDISP_ComputeTimeOffset` compare lane.
- `src/decomp/scripts/semantic_filter_group_ae_jmptbl_esqpars_replace_owned_string.awk`: semantic post-filter for `GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString` compare lane.
- `src/decomp/scripts/semantic_filter_group_ah_jmptbl_esqiff2_apply_incoming_status_packet.awk`: semantic post-filter for `GROUP_AH_JMPTBL_ESQIFF2_ApplyIncomingStatusPacket` compare lane.
- `src/decomp/scripts/semantic_filter_group_ah_jmptbl_newgrid_rebuild_index_cache.awk`: semantic post-filter for `GROUP_AH_JMPTBL_NEWGRID_RebuildIndexCache` compare lane.
- `src/decomp/scripts/semantic_filter_group_ah_jmptbl_esqshared_apply_program_title_text_filters.awk`: semantic post-filter for `GROUP_AH_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters` compare lane.
- `src/decomp/scripts/semantic_filter_group_ah_jmptbl_esqdisp_update_status_mask_and_refresh.awk`: semantic post-filter for `GROUP_AH_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh` compare lane.
- `src/decomp/scripts/semantic_filter_group_ah_jmptbl_esqshared_init_entry_defaults.awk`: semantic post-filter for `GROUP_AH_JMPTBL_ESQSHARED_InitEntryDefaults` compare lane.
- `src/decomp/scripts/semantic_filter_group_ah_jmptbl_gcommand_load_ppv_template.awk`: semantic post-filter for `GROUP_AH_JMPTBL_GCOMMAND_LoadPPVTemplate` compare lane.
- `src/decomp/scripts/semantic_filter_group_ah_jmptbl_locavail_save_availability_data_file.awk`: semantic post-filter for `GROUP_AH_JMPTBL_LOCAVAIL_SaveAvailabilityDataFile` compare lane.
- `src/decomp/scripts/semantic_filter_group_ah_jmptbl_gcommand_load_command_file.awk`: semantic post-filter for `GROUP_AH_JMPTBL_GCOMMAND_LoadCommandFile` compare lane.
- `src/decomp/scripts/semantic_filter_group_ah_jmptbl_esq_wildcard_match.awk`: semantic post-filter for `GROUP_AH_JMPTBL_ESQ_WildcardMatch` compare lane.
- `src/decomp/scripts/semantic_filter_group_ah_jmptbl_p_type_write_promo_id_data_file.awk`: semantic post-filter for `GROUP_AH_JMPTBL_P_TYPE_WritePromoIdDataFile` compare lane.
- `src/decomp/scripts/semantic_filter_group_ah_jmptbl_esqfunc_wait_for_clock_change_and_service_ui.awk`: semantic post-filter for `GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi` compare lane.
- `src/decomp/scripts/semantic_filter_group_ah_jmptbl_esq_test_bit1_based.awk`: semantic post-filter for `GROUP_AH_JMPTBL_ESQ_TestBit1Based` compare lane.
- `src/decomp/scripts/semantic_filter_group_ah_jmptbl_esqiff2_show_attention_overlay.awk`: semantic post-filter for `GROUP_AH_JMPTBL_ESQIFF2_ShowAttentionOverlay` compare lane.
- `src/decomp/scripts/semantic_filter_group_ah_jmptbl_str_find_any_char_ptr.awk`: semantic post-filter for `GROUP_AH_JMPTBL_STR_FindAnyCharPtr` compare lane.
- `src/decomp/scripts/semantic_filter_group_ah_jmptbl_gcommand_load_mplex_file.awk`: semantic post-filter for `GROUP_AH_JMPTBL_GCOMMAND_LoadMplexFile` compare lane.
- `src/decomp/scripts/semantic_filter_group_ah_jmptbl_script_read_serial_rbf_byte.awk`: semantic post-filter for `GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte` compare lane.
- `src/decomp/scripts/semantic_filter_group_ah_jmptbl_esqpars_clear_alias_string_pointers.awk`: semantic post-filter for `GROUP_AH_JMPTBL_ESQPARS_ClearAliasStringPointers` compare lane.
- `src/decomp/scripts/semantic_filter_group_ah_jmptbl_parse_read_signed_long_skip_class3.awk`: semantic post-filter for `GROUP_AH_JMPTBL_PARSE_ReadSignedLongSkipClass3` compare lane.
- `src/decomp/scripts/semantic_filter_group_aj_jmptbl_string_find_substring.awk`: semantic post-filter for `GROUP_AJ_JMPTBL_STRING_FindSubstring` compare lane.
- `src/decomp/scripts/semantic_filter_group_aj_jmptbl_format_raw_dofmt_with_scratch_buffer.awk`: semantic post-filter for `GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer` compare lane.
- `src/decomp/scripts/semantic_filter_group_aj_jmptbl_math_div_u32.awk`: semantic post-filter for `GROUP_AJ_JMPTBL_MATH_DivU32` compare lane.
- `src/decomp/scripts/semantic_filter_group_aj_jmptbl_parseini_write_rtc_from_globals.awk`: semantic post-filter for `GROUP_AJ_JMPTBL_PARSEINI_WriteRtcFromGlobals` compare lane.
- `src/decomp/scripts/semantic_filter_group_aj_jmptbl_math_mulu32.awk`: semantic post-filter for `GROUP_AJ_JMPTBL_MATH_Mulu32` compare lane.
- `src/decomp/scripts/semantic_filter_group_ak_jmptbl_script_update_serial_shadow_from_ctrl_byte.awk`: semantic post-filter for `GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte` compare lane.
- `src/decomp/scripts/semantic_filter_group_ak_jmptbl_tliba3_select_next_view_mode.awk`: semantic post-filter for `GROUP_AK_JMPTBL_TLIBA3_SelectNextViewMode` compare lane.
- `src/decomp/scripts/semantic_filter_group_ak_jmptbl_parseini_parse_ini_buffer_and_dispatch.awk`: semantic post-filter for `GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch` compare lane.
- `src/decomp/scripts/semantic_filter_group_ak_jmptbl_textdisp_format_entry_time_for_index.awk`: semantic post-filter for `GROUP_AK_JMPTBL_TEXTDISP_FormatEntryTimeForIndex` compare lane.
- `src/decomp/scripts/semantic_filter_group_ak_jmptbl_gcommand_get_banner_char.awk`: semantic post-filter for `GROUP_AK_JMPTBL_GCOMMAND_GetBannerChar` compare lane.
- `src/decomp/scripts/semantic_filter_group_ak_jmptbl_esqpars_apply_rtc_bytes_and_persist.awk`: semantic post-filter for `GROUP_AK_JMPTBL_ESQPARS_ApplyRtcBytesAndPersist` compare lane.
- `src/decomp/scripts/semantic_filter_group_ak_jmptbl_parseini_write_error_log_entry.awk`: semantic post-filter for `GROUP_AK_JMPTBL_PARSEINI_WriteErrorLogEntry` compare lane.
- `src/decomp/scripts/semantic_filter_group_ak_jmptbl_parseini_scan_logo_directory.awk`: semantic post-filter for `GROUP_AK_JMPTBL_PARSEINI_ScanLogoDirectory` compare lane.
- `src/decomp/scripts/semantic_filter_group_ak_jmptbl_script_deassert_ctrl_line_now.awk`: semantic post-filter for `GROUP_AK_JMPTBL_SCRIPT_DeassertCtrlLineNow` compare lane.
- `src/decomp/scripts/semantic_filter_group_ak_jmptbl_esq_set_copper_effect_default.awk`: semantic post-filter for `GROUP_AK_JMPTBL_ESQ_SetCopperEffect_Default` compare lane.
- `src/decomp/scripts/semantic_filter_group_ak_jmptbl_esq_set_copper_effect_custom.awk`: semantic post-filter for `GROUP_AK_JMPTBL_ESQ_SetCopperEffect_Custom` compare lane.
- `src/decomp/scripts/semantic_filter_group_ak_jmptbl_cleanup_render_aligned_status_screen.awk`: semantic post-filter for `GROUP_AK_JMPTBL_CLEANUP_RenderAlignedStatusScreen` compare lane.
- `src/decomp/scripts/semantic_filter_group_ak_jmptbl_esq_set_copper_effect_all_on.awk`: semantic post-filter for `GROUP_AK_JMPTBL_ESQ_SetCopperEffect_AllOn` compare lane.
- `src/decomp/scripts/semantic_filter_group_ak_jmptbl_script_assert_ctrl_line_now.awk`: semantic post-filter for `GROUP_AK_JMPTBL_SCRIPT_AssertCtrlLineNow` compare lane.
- `src/decomp/scripts/semantic_filter_group_ak_jmptbl_tliba3_draw_view_mode_guides.awk`: semantic post-filter for `GROUP_AK_JMPTBL_TLIBA3_DrawViewModeGuides` compare lane.
- `src/decomp/scripts/semantic_filter_group_ak_jmptbl_gcommand_copy_gfx_to_work_if_available.awk`: semantic post-filter for `GROUP_AK_JMPTBL_GCOMMAND_CopyGfxToWorkIfAvailable` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_bevel_draw_bevel_frame_with_top_right.awk`: semantic post-filter for `NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_bevel_draw_vertical_bevel.awk`: semantic post-filter for `NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevel` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_bevel_draw_bevel_frame_with_top.awk`: semantic post-filter for `NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTop` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_bevel_draw_beveled_frame.awk`: semantic post-filter for `NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_bevel_draw_vertical_bevel_pair.awk`: semantic post-filter for `NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevelPair` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_bevel_draw_horizontal_bevel.awk`: semantic post-filter for `NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_coi_select_anim_field_pointer.awk`: semantic post-filter for `NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_disptext_set_current_line_index.awk`: semantic post-filter for `NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_disptext_layout_and_append_to_buffer.awk`: semantic post-filter for `NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_disptext_get_total_line_count.awk`: semantic post-filter for `NEWGRID2_JMPTBL_DISPTEXT_GetTotalLineCount` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_tliba_find_first_wildcard_match_index.awk`: semantic post-filter for `NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_disptext_build_layout_for_source.awk`: semantic post-filter for `NEWGRID2_JMPTBL_DISPTEXT_BuildLayoutForSource` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_esqdisp_get_entry_aux_pointer_by_mode.awk`: semantic post-filter for `NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_disptext_layout_source_to_lines.awk`: semantic post-filter for `NEWGRID2_JMPTBL_DISPTEXT_LayoutSourceToLines` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_cleanup_update_entry_flag_bytes.awk`: semantic post-filter for `NEWGRID2_JMPTBL_CLEANUP_UpdateEntryFlagBytes` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_coi_render_clock_format_entry_variant.awk`: semantic post-filter for `NEWGRID2_JMPTBL_COI_RenderClockFormatEntryVariant` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_esqdisp_test_entry_bits0_and2.awk`: semantic post-filter for `NEWGRID2_JMPTBL_ESQDISP_TestEntryBits0And2` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_disptext_compute_visible_line_count.awk`: semantic post-filter for `NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_esqdisp_get_entry_pointer_by_mode.awk`: semantic post-filter for `NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_disptext_render_current_line.awk`: semantic post-filter for `NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_coi_process_entry_selection_state.awk`: semantic post-filter for `NEWGRID2_JMPTBL_COI_ProcessEntrySelectionState` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_cleanup_format_clock_format_entry.awk`: semantic post-filter for `NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_esq_get_half_hour_slot_index.awk`: semantic post-filter for `NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_str_skip_class3_chars.awk`: semantic post-filter for `NEWGRID2_JMPTBL_STR_SkipClass3Chars` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_string_append_n.awk`: semantic post-filter for `NEWGRID2_JMPTBL_STRING_AppendN` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_esqdisp_compute_schedule_offset_for_row.awk`: semantic post-filter for `NEWGRID2_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_parse_read_signed_long_skip_class3_alt.awk`: semantic post-filter for `NEWGRID2_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_cleanup_test_entry_flag_y_and_bit1.awk`: semantic post-filter for `NEWGRID2_JMPTBL_CLEANUP_TestEntryFlagYAndBit1` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_disptext_is_current_line_last.awk`: semantic post-filter for `NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_disptext_is_last_line_selected.awk`: semantic post-filter for `NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_displib_find_previous_valid_entry_index.awk`: semantic post-filter for `NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_disptext_compute_marker_widths.awk`: semantic post-filter for `NEWGRID2_JMPTBL_DISPTEXT_ComputeMarkerWidths` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_esq_test_bit1_based.awk`: semantic post-filter for `NEWGRID2_JMPTBL_ESQ_TestBit1Based` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_disptext_measure_current_line_length.awk`: semantic post-filter for `NEWGRID2_JMPTBL_DISPTEXT_MeasureCurrentLineLength` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_disptext_set_layout_params.awk`: semantic post-filter for `NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_disptext_has_multiple_lines.awk`: semantic post-filter for `NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_bevel_draw_horizontal_bevel.awk`: semantic post-filter for `NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel` compare lane.
- `src/decomp/scripts/semantic_filter_group_av_jmptbl_allocate_alloc_and_initialize_iostdreq.awk`: semantic post-filter for `GROUP_AV_JMPTBL_ALLOCATE_AllocAndInitializeIOStdReq` compare lane.
- `src/decomp/scripts/semantic_filter_group_av_jmptbl_signal_create_msgport_with_signal.awk`: semantic post-filter for `GROUP_AV_JMPTBL_SIGNAL_CreateMsgPortWithSignal` compare lane.
- `src/decomp/scripts/semantic_filter_group_av_jmptbl_diskio_probe_drives_and_assign_paths.awk`: semantic post-filter for `GROUP_AV_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths` compare lane.
- `src/decomp/scripts/semantic_filter_group_av_jmptbl_esq_invoke_gcommand_init.awk`: semantic post-filter for `GROUP_AV_JMPTBL_ESQ_InvokeGcommandInit` compare lane.
- `src/decomp/scripts/semantic_filter_group_av_jmptbl_exec_call_vector_48.awk`: semantic post-filter for `GROUP_AV_JMPTBL_EXEC_CallVector_48` compare lane.
- `src/decomp/scripts/semantic_filter_group_ad_jmptbl_textdisp_draw_channel_banner.awk`: semantic post-filter for `GROUP_AD_JMPTBL_TEXTDISP_DrawChannelBanner` compare lane.
- `src/decomp/scripts/semantic_filter_group_ad_jmptbl_textdisp_format_entry_time.awk`: semantic post-filter for `GROUP_AD_JMPTBL_TEXTDISP_FormatEntryTime` compare lane.
- `src/decomp/scripts/semantic_filter_group_ad_jmptbl_tliba3_get_view_mode_height.awk`: semantic post-filter for `GROUP_AD_JMPTBL_TLIBA3_GetViewModeHeight` compare lane.
- `src/decomp/scripts/semantic_filter_group_ad_jmptbl_tliba3_get_view_mode_rast_port.awk`: semantic post-filter for `GROUP_AD_JMPTBL_TLIBA3_GetViewModeRastPort` compare lane.
- `src/decomp/scripts/semantic_filter_tliba3_jmptbl_gcommand_applyhighlightflag.awk`: semantic post-filter for `TLIBA3_JMPTBL_GCOMMAND_ApplyHighlightFlag` compare lane.
- `src/decomp/scripts/semantic_filter_tliba2_jmptbl_dst_addtimeoffset.awk`: semantic post-filter for `TLIBA2_JMPTBL_DST_AddTimeOffset` compare lane.
- `src/decomp/scripts/semantic_filter_tliba2_jmptbl_esq_testbit1based.awk`: semantic post-filter for `TLIBA2_JMPTBL_ESQ_TestBit1Based` compare lane.
- `src/decomp/scripts/semantic_filter_tliba1_jmptbl_coi_getanimfieldpointerbymode.awk`: semantic post-filter for `TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode` compare lane.
- `src/decomp/scripts/semantic_filter_tliba1_jmptbl_esqdisp_getentryauxpointerbymode.awk`: semantic post-filter for `TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode` compare lane.
- `src/decomp/scripts/semantic_filter_tliba1_jmptbl_ladfunc_extractlownibble.awk`: semantic post-filter for `TLIBA1_JMPTBL_LADFUNC_ExtractLowNibble` compare lane.
- `src/decomp/scripts/semantic_filter_tliba1_jmptbl_esqdisp_getentrypointerbymode.awk`: semantic post-filter for `TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode` compare lane.
- `src/decomp/scripts/semantic_filter_tliba1_jmptbl_coi_testentrywithintimewindow.awk`: semantic post-filter for `TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow` compare lane.
- `src/decomp/scripts/semantic_filter_tliba1_jmptbl_cleanup_formatclockformatentry.awk`: semantic post-filter for `TLIBA1_JMPTBL_CLEANUP_FormatClockFormatEntry` compare lane.
- `src/decomp/scripts/semantic_filter_tliba1_jmptbl_esqdisp_computescheduleoffsetforrow.awk`: semantic post-filter for `TLIBA1_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow` compare lane.
- `src/decomp/scripts/semantic_filter_tliba1_jmptbl_esq_findsubstringcasefold.awk`: semantic post-filter for `TLIBA1_JMPTBL_ESQ_FindSubstringCaseFold` compare lane.
- `src/decomp/scripts/semantic_filter_tliba1_jmptbl_displib_findpreviousvalidentryindex.awk`: semantic post-filter for `TLIBA1_JMPTBL_DISPLIB_FindPreviousValidEntryIndex` compare lane.
- `src/decomp/scripts/semantic_filter_tliba1_jmptbl_ladfunc_extracthighnibble.awk`: semantic post-filter for `TLIBA1_JMPTBL_LADFUNC_ExtractHighNibble` compare lane.
- `src/decomp/scripts/semantic_filter_parseini2_jmptbl_battclock_getsecondsfrombatterybackedclock.awk`: semantic post-filter for `PARSEINI2_JMPTBL_BATTCLOCK_GetSecondsFromBatteryBackedClock` compare lane.
- `src/decomp/scripts/semantic_filter_parseini2_jmptbl_battclock_writesecondstobatterybackedclock.awk`: semantic post-filter for `PARSEINI2_JMPTBL_BATTCLOCK_WriteSecondsToBatteryBackedClock` compare lane.
- `src/decomp/scripts/semantic_filter_parseini2_jmptbl_datetime_isleapyear.awk`: semantic post-filter for `PARSEINI2_JMPTBL_DATETIME_IsLeapYear` compare lane.
- `src/decomp/scripts/semantic_filter_parseini2_jmptbl_clock_secondsfromepoch.awk`: semantic post-filter for `PARSEINI2_JMPTBL_CLOCK_SecondsFromEpoch` compare lane.
- `src/decomp/scripts/semantic_filter_parseini2_jmptbl_clock_checkdateorsecondsfromepoch.awk`: semantic post-filter for `PARSEINI2_JMPTBL_CLOCK_CheckDateOrSecondsFromEpoch` compare lane.
- `src/decomp/scripts/semantic_filter_parseini2_jmptbl_clock_convertamigasecondstoclockdata.awk`: semantic post-filter for `PARSEINI2_JMPTBL_CLOCK_ConvertAmigaSecondsToClockData` compare lane.
- `src/decomp/scripts/semantic_filter_parseini2_jmptbl_esq_calcdayofyearfrommonthday.awk`: semantic post-filter for `PARSEINI2_JMPTBL_ESQ_CalcDayOfYearFromMonthDay` compare lane.
- `src/decomp/scripts/semantic_filter_script2_jmptbl_esq_capturectrlbit4streambufferbyte.awk`: semantic post-filter for `SCRIPT2_JMPTBL_ESQ_CaptureCtrlBit4StreamBufferByte` compare lane.
- `src/decomp/scripts/semantic_filter_script2_jmptbl_esq_readserialrbfbyte.awk`: semantic post-filter for `SCRIPT2_JMPTBL_ESQ_ReadSerialRbfByte` compare lane.
- `src/decomp/scripts/semantic_filter_p_type_jmptbl_string_findsubstring.awk`: semantic post-filter for `P_TYPE_JMPTBL_STRING_FindSubstring` compare lane.
- `src/decomp/scripts/semantic_filter_textdisp2_jmptbl_locavail_getfilterwindowhalfspan.awk`: semantic post-filter for `TEXTDISP2_JMPTBL_LOCAVAIL_GetFilterWindowHalfSpan` compare lane.
- `src/decomp/scripts/semantic_filter_textdisp2_jmptbl_ladfunc_drawentrypreview.awk`: semantic post-filter for `TEXTDISP2_JMPTBL_LADFUNC_DrawEntryPreview` compare lane.
- `src/decomp/scripts/semantic_filter_textdisp2_jmptbl_esqiff_runpendingcopperanimations.awk`: semantic post-filter for `TEXTDISP2_JMPTBL_ESQIFF_RunPendingCopperAnimations` compare lane.
- `src/decomp/scripts/semantic_filter_textdisp2_jmptbl_esqiff_playnextexternalassetframe.awk`: semantic post-filter for `TEXTDISP2_JMPTBL_ESQIFF_PlayNextExternalAssetFrame` compare lane.
- `src/decomp/scripts/semantic_filter_script_jmptbl_memory_deallocatememory.awk`: semantic post-filter for `SCRIPT_JMPTBL_MEMORY_DeallocateMemory` compare lane.
- `src/decomp/scripts/semantic_filter_script_jmptbl_diskio_writebufferedbytes.awk`: semantic post-filter for `SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes` compare lane.
- `src/decomp/scripts/semantic_filter_script_jmptbl_diskio_closebufferedfileandflush.awk`: semantic post-filter for `SCRIPT_JMPTBL_DISKIO_CloseBufferedFileAndFlush` compare lane.
- `src/decomp/scripts/semantic_filter_script_jmptbl_memory_allocatememory.awk`: semantic post-filter for `SCRIPT_JMPTBL_MEMORY_AllocateMemory` compare lane.
- `src/decomp/scripts/semantic_filter_script_jmptbl_diskio_openfilewithbuffer.awk`: semantic post-filter for `SCRIPT_JMPTBL_DISKIO_OpenFileWithBuffer` compare lane.
- `src/decomp/scripts/semantic_filter_wdisp_jmptbl_esqiff_restorebasepalettetriples.awk`: semantic post-filter for `WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples` compare lane.
- `src/decomp/scripts/semantic_filter_wdisp_jmptbl_esqfunc_trimtexttopixelwidthwordboundary.awk`: semantic post-filter for `WDISP_JMPTBL_ESQFUNC_TrimTextToPixelWidthWordBoundary` compare lane.
- `src/decomp/scripts/semantic_filter_wdisp_jmptbl_gcommand_expandpresetblock.awk`: semantic post-filter for `WDISP_JMPTBL_GCOMMAND_ExpandPresetBlock` compare lane.
- `src/decomp/scripts/semantic_filter_wdisp_jmptbl_esqiff_queueiffbrushload.awk`: semantic post-filter for `WDISP_JMPTBL_ESQIFF_QueueIffBrushLoad` compare lane.
- `src/decomp/scripts/semantic_filter_wdisp_jmptbl_esqiff_runcopperdroptransition.awk`: semantic post-filter for `WDISP_JMPTBL_ESQIFF_RunCopperDropTransition` compare lane.
- `src/decomp/scripts/semantic_filter_wdisp_jmptbl_brush_findbrushbypredicate.awk`: semantic post-filter for `WDISP_JMPTBL_BRUSH_FindBrushByPredicate` compare lane.
- `src/decomp/scripts/semantic_filter_wdisp_jmptbl_brush_freebrushlist.awk`: semantic post-filter for `WDISP_JMPTBL_BRUSH_FreeBrushList` compare lane.
- `src/decomp/scripts/semantic_filter_wdisp_jmptbl_brush_planemaskforindex.awk`: semantic post-filter for `WDISP_JMPTBL_BRUSH_PlaneMaskForIndex` compare lane.
- `src/decomp/scripts/semantic_filter_wdisp_jmptbl_esq_setcoppereffect_onenablehighlight.awk`: semantic post-filter for `WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight` compare lane.
- `src/decomp/scripts/semantic_filter_wdisp_jmptbl_esqiff_renderweatherstatusbrushslice.awk`: semantic post-filter for `WDISP_JMPTBL_ESQIFF_RenderWeatherStatusBrushSlice` compare lane.
- `src/decomp/scripts/semantic_filter_wdisp_jmptbl_brush_selectbrushslot.awk`: semantic post-filter for `WDISP_JMPTBL_BRUSH_SelectBrushSlot` compare lane.
- `src/decomp/scripts/semantic_filter_wdisp_jmptbl_newgrid_drawwrappedtext.awk`: semantic post-filter for `WDISP_JMPTBL_NEWGRID_DrawWrappedText` compare lane.
- `src/decomp/scripts/semantic_filter_wdisp_jmptbl_newgrid_resetrowtable.awk`: semantic post-filter for `WDISP_JMPTBL_NEWGRID_ResetRowTable` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid_jmptbl_math_divs32.awk`: semantic post-filter for `NEWGRID_JMPTBL_MATH_DivS32` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid_jmptbl_datetime_secondstostruct.awk`: semantic post-filter for `NEWGRID_JMPTBL_DATETIME_SecondsToStruct` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid_jmptbl_generate_grid_date_string.awk`: semantic post-filter for `NEWGRID_JMPTBL_GENERATE_GRID_DATE_STRING` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid_jmptbl_memory_deallocatememory.awk`: semantic post-filter for `NEWGRID_JMPTBL_MEMORY_DeallocateMemory` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid_jmptbl_cleanup_drawclockformatlist.awk`: semantic post-filter for `NEWGRID_JMPTBL_CLEANUP_DrawClockFormatList` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid_jmptbl_disptext_freebuffers.awk`: semantic post-filter for `NEWGRID_JMPTBL_DISPTEXT_FreeBuffers` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid_jmptbl_cleanup_drawclockbanner.awk`: semantic post-filter for `NEWGRID_JMPTBL_CLEANUP_DrawClockBanner` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid_jmptbl_memory_allocatememory.awk`: semantic post-filter for `NEWGRID_JMPTBL_MEMORY_AllocateMemory` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid_jmptbl_disptext_initbuffers.awk`: semantic post-filter for `NEWGRID_JMPTBL_DISPTEXT_InitBuffers` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid_jmptbl_cleanup_drawclockformatframe.awk`: semantic post-filter for `NEWGRID_JMPTBL_CLEANUP_DrawClockFormatFrame` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid_jmptbl_datetime_normalizestructtoseconds.awk`: semantic post-filter for `NEWGRID_JMPTBL_DATETIME_NormalizeStructToSeconds` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid_jmptbl_str_copyuntilanydelimn.awk`: semantic post-filter for `NEWGRID_JMPTBL_STR_CopyUntilAnyDelimN` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid_jmptbl_wdisp_updateselectionpreviewpanel.awk`: semantic post-filter for `NEWGRID_JMPTBL_WDISP_UpdateSelectionPreviewPanel` compare lane.
- `src/decomp/scripts/semantic_filter_newgrid_jmptbl_math_mulu32.awk`: semantic post-filter for `NEWGRID_JMPTBL_MATH_Mulu32` compare lane.
- `src/decomp/scripts/semantic_filter_parseini_jmptbl_brush_allocbrushnode.awk`: semantic post-filter for `PARSEINI_JMPTBL_BRUSH_AllocBrushNode` compare lane.
- `src/decomp/scripts/semantic_filter_parseini_jmptbl_brush_freebrushlist.awk`: semantic post-filter for `PARSEINI_JMPTBL_BRUSH_FreeBrushList` compare lane.
- `src/decomp/scripts/semantic_filter_parseini_jmptbl_brush_freebrushresources.awk`: semantic post-filter for `PARSEINI_JMPTBL_BRUSH_FreeBrushResources` compare lane.
- `src/decomp/scripts/semantic_filter_parseini_jmptbl_esqfunc_rebuildpwbrushlistfromtagtablefromtagtable.awk`: semantic post-filter for `PARSEINI_JMPTBL_ESQFUNC_RebuildPwBrushListFromTagTableFromTagTable` compare lane.
- `src/decomp/scripts/semantic_filter_parseini_jmptbl_gcommand_findpathseparator.awk`: semantic post-filter for `PARSEINI_JMPTBL_GCOMMAND_FindPathSeparator` compare lane.
- `src/decomp/scripts/semantic_filter_parseini_jmptbl_diskio_consumelinefromworkbuffer.awk`: semantic post-filter for `PARSEINI_JMPTBL_DISKIO_ConsumeLineFromWorkBuffer` compare lane.
- `src/decomp/scripts/semantic_filter_parseini_jmptbl_diskio2_parseinifilefromdisk.awk`: semantic post-filter for `PARSEINI_JMPTBL_DISKIO2_ParseIniFileFromDisk` compare lane.
- `src/decomp/scripts/semantic_filter_parseini_jmptbl_diskio_loadfiletoworkbuffer.awk`: semantic post-filter for `PARSEINI_JMPTBL_DISKIO_LoadFileToWorkBuffer` compare lane.
- `src/decomp/scripts/semantic_filter_parseini_jmptbl_ed1_drawdiagnosticsscreen.awk`: semantic post-filter for `PARSEINI_JMPTBL_ED1_DrawDiagnosticsScreen` compare lane.
- `src/decomp/scripts/semantic_filter_parseini_jmptbl_ed1_enterescmenu.awk`: semantic post-filter for `PARSEINI_JMPTBL_ED1_EnterEscMenu` compare lane.
- `src/decomp/scripts/semantic_filter_parseini_jmptbl_ed1_exitescmenu.awk`: semantic post-filter for `PARSEINI_JMPTBL_ED1_ExitEscMenu` compare lane.
- `src/decomp/scripts/semantic_filter_parseini_jmptbl_ed1_waitforflagandclearbit0.awk`: semantic post-filter for `PARSEINI_JMPTBL_ED1_WaitForFlagAndClearBit0` compare lane.
- `src/decomp/scripts/semantic_filter_parseini_jmptbl_ed1_waitforflagandclearbit1.awk`: semantic post-filter for `PARSEINI_JMPTBL_ED1_WaitForFlagAndClearBit1` compare lane.
- `src/decomp/scripts/semantic_filter_parseini_jmptbl_esqfunc_drawescmenuversion.awk`: semantic post-filter for `PARSEINI_JMPTBL_ESQFUNC_DrawEscMenuVersion` compare lane.
- `src/decomp/scripts/semantic_filter_parseini_jmptbl_esqiff_queueiffbrushload.awk`: semantic post-filter for `PARSEINI_JMPTBL_ESQIFF_QueueIffBrushLoad` compare lane.
- `src/decomp/scripts/semantic_filter_parseini_jmptbl_esqiff_handlebrushinireloadhotkey.awk`: semantic post-filter for `PARSEINI_JMPTBL_ESQIFF_HandleBrushIniReloadHotkey` compare lane.
- `src/decomp/scripts/semantic_filter_parseini_jmptbl_esqpars_replaceownedstring.awk`: semantic post-filter for `PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString` compare lane.
- `src/decomp/scripts/semantic_filter_parseini_jmptbl_gcommand_initpresettablefrompalette.awk`: semantic post-filter for `PARSEINI_JMPTBL_GCOMMAND_InitPresetTableFromPalette` compare lane.
- `src/decomp/scripts/semantic_filter_parseini_jmptbl_gcommand_validatepresettable.awk`: semantic post-filter for `PARSEINI_JMPTBL_GCOMMAND_ValidatePresetTable` compare lane.
- `src/decomp/scripts/semantic_filter_parseini_jmptbl_handle_openwithmode.awk`: semantic post-filter for `PARSEINI_JMPTBL_HANDLE_OpenWithMode` compare lane.
- `src/decomp/scripts/semantic_filter_parseini_jmptbl_stream_readlinewithlimit.awk`: semantic post-filter for `PARSEINI_JMPTBL_STREAM_ReadLineWithLimit` compare lane.
- `src/decomp/scripts/semantic_filter_parseini_jmptbl_string_appendatnull.awk`: semantic post-filter for `PARSEINI_JMPTBL_STRING_AppendAtNull` compare lane.
- `src/decomp/scripts/semantic_filter_parseini_jmptbl_string_comparenocase.awk`: semantic post-filter for `PARSEINI_JMPTBL_STRING_CompareNoCase` compare lane.
- `src/decomp/scripts/semantic_filter_parseini_jmptbl_string_comparenocasen.awk`: semantic post-filter for `PARSEINI_JMPTBL_STRING_CompareNoCaseN` compare lane.
- `src/decomp/scripts/semantic_filter_parseini_jmptbl_str_findanycharptr.awk`: semantic post-filter for `PARSEINI_JMPTBL_STR_FindAnyCharPtr` compare lane.
- `src/decomp/scripts/semantic_filter_parseini_jmptbl_str_findcharptr.awk`: semantic post-filter for `PARSEINI_JMPTBL_STR_FindCharPtr` compare lane.
- `src/decomp/scripts/semantic_filter_parseini_jmptbl_unknown36_finalizerequest.awk`: semantic post-filter for `PARSEINI_JMPTBL_UNKNOWN36_FinalizeRequest` compare lane.
- `src/decomp/scripts/semantic_filter_parseini_jmptbl_wdisp_sprintf.awk`: semantic post-filter for `PARSEINI_JMPTBL_WDISP_SPrintf` compare lane.
- `src/decomp/scripts/semantic_filter_script3_jmptbl_cleanup_renderalignedstatusscreen.awk`: semantic post-filter for `SCRIPT3_JMPTBL_CLEANUP_RenderAlignedStatusScreen` compare lane.
- `src/decomp/scripts/semantic_filter_script3_jmptbl_locavail_computefilteroffsetforentry.awk`: semantic post-filter for `SCRIPT3_JMPTBL_LOCAVAIL_ComputeFilterOffsetForEntry` compare lane.
- `src/decomp/scripts/semantic_filter_script3_jmptbl_math_mulu32.awk`: semantic post-filter for `SCRIPT3_JMPTBL_MATH_Mulu32` compare lane.
- `src/decomp/scripts/semantic_filter_script3_jmptbl_math_divs32.awk`: semantic post-filter for `SCRIPT3_JMPTBL_MATH_DivS32` compare lane.
- `src/decomp/scripts/semantic_filter_script3_jmptbl_locavail_setfiltermodeandresetstate.awk`: semantic post-filter for `SCRIPT3_JMPTBL_LOCAVAIL_SetFilterModeAndResetState` compare lane.
- `src/decomp/scripts/semantic_filter_script3_jmptbl_string_copypadnul.awk`: semantic post-filter for `SCRIPT3_JMPTBL_STRING_CopyPadNul` compare lane.
- `src/decomp/scripts/semantic_filter_script3_jmptbl_string_comparen.awk`: semantic post-filter for `SCRIPT3_JMPTBL_STRING_CompareN` compare lane.
- `src/decomp/scripts/semantic_filter_script3_jmptbl_esqdisp_updatestatusmaskandrefresh.awk`: semantic post-filter for `SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh` compare lane.
- `src/decomp/scripts/semantic_filter_script3_jmptbl_gcommand_getbannerchar.awk`: semantic post-filter for `SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar` compare lane.
- `src/decomp/scripts/semantic_filter_script3_jmptbl_ladfunc_parsehexdigit.awk`: semantic post-filter for `SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit` compare lane.
- `src/decomp/scripts/semantic_filter_script3_jmptbl_esqpars_applyrtcbytesandpersist.awk`: semantic post-filter for `SCRIPT3_JMPTBL_ESQPARS_ApplyRtcBytesAndPersist` compare lane.
- `src/decomp/scripts/semantic_filter_script3_jmptbl_parse_readsignedlongskipclass3_alt.awk`: semantic post-filter for `SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt` compare lane.
- `src/decomp/scripts/semantic_filter_script3_jmptbl_gcommand_adjustbannercopperoffset.awk`: semantic post-filter for `SCRIPT3_JMPTBL_GCOMMAND_AdjustBannerCopperOffset` compare lane.
- `src/decomp/scripts/semantic_filter_script3_jmptbl_esq_setcoppereffect_custom.awk`: semantic post-filter for `SCRIPT3_JMPTBL_ESQ_SetCopperEffect_Custom` compare lane.
- `src/decomp/scripts/semantic_filter_script3_jmptbl_esqshared_applyprogramtitletextfilters.awk`: semantic post-filter for `SCRIPT3_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters` compare lane.
- `src/decomp/scripts/semantic_filter_script3_jmptbl_locavail_updatefilterstatemachine.awk`: semantic post-filter for `SCRIPT3_JMPTBL_LOCAVAIL_UpdateFilterStateMachine` compare lane.
- `src/decomp/scripts/semantic_filter_parseini_compute_htc_max_values.awk`: semantic post-filter for `PARSEINI_ComputeHTCMaxValues` compare lane.
- `src/decomp/scripts/semantic_filter_parseini_update_ctrl_h_delta_max.awk`: semantic post-filter for `PARSEINI_UpdateCtrlHDeltaMax` compare lane.
- `src/decomp/scripts/semantic_filter_parseini_check_ctrl_h_change.awk`: semantic post-filter for `PARSEINI_CheckCtrlHChange` compare lane.
- `src/decomp/scripts/semantic_filter_parseini_monitor_clock_change.awk`: semantic post-filter for `PARSEINI_MonitorClockChange` compare lane.
- `src/decomp/scripts/semantic_filter_parseini_write_error_log_entry.awk`: semantic post-filter for `PARSEINI_WriteErrorLogEntry` compare lane.
- `src/decomp/scripts/semantic_filter_parseini_test_memory_and_open_topaz_font.awk`: semantic post-filter for `PARSEINI_TestMemoryAndOpenTopazFont` compare lane.
- `src/decomp/scripts/semantic_filter_parseini_parse_hex_value_from_string.awk`: semantic post-filter for `PARSEINI_ParseHexValueFromString` compare lane.
- `src/decomp/scripts/semantic_filter_parseini_parse_range_key_value.awk`: semantic post-filter for `PARSEINI_ParseRangeKeyValue` compare lane.
- `src/decomp/scripts/semantic_filter_parseini_load_weather_message_strings.awk`: semantic post-filter for `PARSEINI_LoadWeatherMessageStrings` compare lane.
- `src/decomp/scripts/semantic_filter_parseini_load_weather_strings.awk`: semantic post-filter for `PARSEINI_LoadWeatherStrings` compare lane.
- `src/decomp/scripts/semantic_filter_parseini_parse_color_table.awk`: semantic post-filter for `PARSEINI_ParseColorTable` compare lane.
- `src/decomp/scripts/semantic_filter_group_ad_jmptbl_datetime_normalize_month_range.awk`: semantic post-filter for `GROUP_AD_JMPTBL_DATETIME_NormalizeMonthRange` compare lane.
- `src/decomp/scripts/semantic_filter_group_ad_jmptbl_datetime_adjust_month_index.awk`: semantic post-filter for `GROUP_AD_JMPTBL_DATETIME_AdjustMonthIndex` compare lane.
- `src/decomp/scripts/semantic_filter_group_ad_jmptbl_script_update_serial_shadow_from_ctrl_byte.awk`: semantic post-filter for `GROUP_AD_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte` compare lane.
- `src/decomp/scripts/semantic_filter_group_ad_jmptbl_esqiff_run_copper_rise_transition.awk`: semantic post-filter for `GROUP_AD_JMPTBL_ESQIFF_RunCopperRiseTransition` compare lane.
- `src/decomp/scripts/semantic_filter_group_ad_jmptbl_textdisp_build_entry_short_name.awk`: semantic post-filter for `GROUP_AD_JMPTBL_TEXTDISP_BuildEntryShortName` compare lane.
- `src/decomp/scripts/semantic_filter_group_ad_jmptbl_graphics_blt_bit_map_rast_port.awk`: semantic post-filter for `GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort` compare lane.
- `src/decomp/scripts/semantic_filter_group_ad_jmptbl_esqiff_run_copper_drop_transition.awk`: semantic post-filter for `GROUP_AD_JMPTBL_ESQIFF_RunCopperDropTransition` compare lane.
- `src/decomp/scripts/semantic_filter_group_ad_jmptbl_tliba1_build_clock_format_entry_if_visible.awk`: semantic post-filter for `GROUP_AD_JMPTBL_TLIBA1_BuildClockFormatEntryIfVisible` compare lane.
- `src/decomp/scripts/semantic_filter_group_ad_jmptbl_textdisp_build_channel_label.awk`: semantic post-filter for `GROUP_AD_JMPTBL_TEXTDISP_BuildChannelLabel` compare lane.
- `src/decomp/scripts/semantic_filter_group_ad_jmptbl_textdisp_draw_inset_rect_frame.awk`: semantic post-filter for `GROUP_AD_JMPTBL_TEXTDISP_DrawInsetRectFrame` compare lane.
- `src/decomp/scripts/semantic_filter_group_ad_jmptbl_textdisp_trim_text_to_pixel_width.awk`: semantic post-filter for `GROUP_AD_JMPTBL_TEXTDISP_TrimTextToPixelWidth` compare lane.
- `src/decomp/scripts/semantic_filter_group_ad_jmptbl_esqfunc_select_and_apply_brush_for_current_entry.awk`: semantic post-filter for `GROUP_AD_JMPTBL_ESQFUNC_SelectAndApplyBrushForCurrentEntry` compare lane.
- `src/decomp/scripts/semantic_filter_group_ad_jmptbl_dst_compute_banner_index.awk`: semantic post-filter for `GROUP_AD_JMPTBL_DST_ComputeBannerIndex` compare lane.
- `src/decomp/scripts/semantic_filter_group_main_a_jmptbl_esq_main_exit_noop_hook.awk`: semantic post-filter for `GROUP_MAIN_A_JMPTBL_ESQ_MainExitNoOpHook` compare lane.
- `src/decomp/scripts/semantic_filter_group_main_a_jmptbl_esq_main_entry_noop_hook.awk`: semantic post-filter for `GROUP_MAIN_A_JMPTBL_ESQ_MainEntryNoOpHook` compare lane.
- `src/decomp/scripts/semantic_filter_group_main_a_jmptbl_memlist_free_all.awk`: semantic post-filter for `GROUP_MAIN_A_JMPTBL_MEMLIST_FreeAll` compare lane.
- `src/decomp/scripts/semantic_filter_group_main_a_jmptbl_esq_parse_command_line_and_run.awk`: semantic post-filter for `GROUP_MAIN_A_JMPTBL_ESQ_ParseCommandLineAndRun` compare lane.
- `src/decomp/scripts/semantic_filter_group_al_jmptbl_ladfunc_pack_nibbles_to_byte.awk`: semantic post-filter for `GROUP_AL_JMPTBL_LADFUNC_PackNibblesToByte` compare lane.
- `src/decomp/scripts/semantic_filter_group_al_jmptbl_ladfunc_extract_low_nibble.awk`: semantic post-filter for `GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble` compare lane.
- `src/decomp/scripts/semantic_filter_group_al_jmptbl_ladfunc_update_entry_buffers_for_ad_index.awk`: semantic post-filter for `GROUP_AL_JMPTBL_LADFUNC_UpdateEntryBuffersForAdIndex` compare lane.
- `src/decomp/scripts/semantic_filter_group_al_jmptbl_esq_write_dec_fixed_width.awk`: semantic post-filter for `GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth` compare lane.
- `src/decomp/scripts/semantic_filter_group_al_jmptbl_ladfunc_build_entry_buffers_or_default.awk`: semantic post-filter for `GROUP_AL_JMPTBL_LADFUNC_BuildEntryBuffersOrDefault` compare lane.
- `src/decomp/scripts/semantic_filter_group_al_jmptbl_ladfunc_extract_high_nibble.awk`: semantic post-filter for `GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble` compare lane.
- `src/decomp/scripts/semantic_filter_group_ay_jmptbl_diskio_consume_cstring_from_work_buffer.awk`: semantic post-filter for `GROUP_AY_JMPTBL_DISKIO_ConsumeCStringFromWorkBuffer` compare lane.
- `src/decomp/scripts/semantic_filter_group_ay_jmptbl_diskio_parse_long_from_work_buffer.awk`: semantic post-filter for `GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer` compare lane.
- `src/decomp/scripts/semantic_filter_group_ay_jmptbl_diskio_write_decimal_field.awk`: semantic post-filter for `GROUP_AY_JMPTBL_DISKIO_WriteDecimalField` compare lane.
- `src/decomp/scripts/semantic_filter_group_ay_jmptbl_diskio_write_buffered_bytes.awk`: semantic post-filter for `GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes` compare lane.
- `src/decomp/scripts/semantic_filter_group_ay_jmptbl_diskio_close_buffered_file_and_flush.awk`: semantic post-filter for `GROUP_AY_JMPTBL_DISKIO_CloseBufferedFileAndFlush` compare lane.
- `src/decomp/scripts/semantic_filter_group_ay_jmptbl_string_compare_nocase_n.awk`: semantic post-filter for `GROUP_AY_JMPTBL_STRING_CompareNoCaseN` compare lane.
- `src/decomp/scripts/semantic_filter_group_ay_jmptbl_math_mulu32.awk`: semantic post-filter for `GROUP_AY_JMPTBL_MATH_Mulu32` compare lane.
- `src/decomp/scripts/semantic_filter_group_ay_jmptbl_diskio_load_file_to_work_buffer.awk`: semantic post-filter for `GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer` compare lane.
- `src/decomp/scripts/semantic_filter_group_ay_jmptbl_script_read_ciab_bit5_mask.awk`: semantic post-filter for `GROUP_AY_JMPTBL_SCRIPT_ReadCiaBBit5Mask` compare lane.
- `src/decomp/scripts/semantic_filter_group_ay_jmptbl_diskio_open_file_with_buffer.awk`: semantic post-filter for `GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer` compare lane.
- `src/decomp/scripts/semantic_filter_group_aa_jmptbl_string_compare_nocase.awk`: semantic post-filter for `GROUP_AA_JMPTBL_STRING_CompareNoCase` compare lane.
- `src/decomp/scripts/semantic_filter_group_aa_jmptbl_string_compare_n.awk`: semantic post-filter for `GROUP_AA_JMPTBL_STRING_CompareN` compare lane.
- `src/decomp/scripts/semantic_filter_group_ar_jmptbl_parseini_write_error_log_entry.awk`: semantic post-filter for `GROUP_AR_JMPTBL_PARSEINI_WriteErrorLogEntry` compare lane.
- `src/decomp/scripts/semantic_filter_group_ar_jmptbl_string_append_at_null.awk`: semantic post-filter for `GROUP_AR_JMPTBL_STRING_AppendAtNull` compare lane.
- `src/decomp/scripts/semantic_filter_group_main_b_jmptbl_dos_delay.awk`: semantic post-filter for `GROUP_MAIN_B_JMPTBL_DOS_Delay` compare lane.
- `src/decomp/scripts/semantic_filter_group_main_b_jmptbl_stream_buffered_write_string.awk`: semantic post-filter for `GROUP_MAIN_B_JMPTBL_STREAM_BufferedWriteString` compare lane.
- `src/decomp/scripts/semantic_filter_group_main_b_jmptbl_math_mulu32.awk`: semantic post-filter for `GROUP_MAIN_B_JMPTBL_MATH_Mulu32` compare lane.
- `src/decomp/scripts/semantic_filter_group_main_b_jmptbl_buffer_flush_all_and_close_with_code.awk`: semantic post-filter for `GROUP_MAIN_B_JMPTBL_BUFFER_FlushAllAndCloseWithCode` compare lane.
- `src/decomp/scripts/semantic_filter_unknown32_jmptbl_esq_return_with_stack_code.awk`: semantic post-filter for `UNKNOWN32_JMPTBL_ESQ_ReturnWithStackCode` compare lane.
- `src/decomp/scripts/semantic_filter_esq_check_available_fast_memory.awk`: semantic post-filter for `ESQ_CheckAvailableFastMemory` compare lane.
- `src/decomp/scripts/semantic_filter_esq_check_compatible_video_chip.awk`: semantic post-filter for `ESQ_CheckCompatibleVideoChip` compare lane.
- `src/decomp/scripts/semantic_filter_esq_format_disk_error_message.awk`: semantic post-filter for `ESQ_FormatDiskErrorMessage` compare lane.
- `src/decomp/scripts/semantic_filter_tliba2_find_last_char_in_string.awk`: semantic post-filter for `TLIBA2_FindLastCharInString` compare lane.
- `src/decomp/scripts/semantic_filter_tliba2_resolve_entry_window_with_default_range.awk`: semantic post-filter for `TLIBA2_ResolveEntryWindowWithDefaultRange` compare lane.
- `src/decomp/scripts/semantic_filter_tliba_find_first_wildcard_match_index.awk`: semantic post-filter for `TLIBA_FindFirstWildcardMatchIndex` compare lane.
- `src/decomp/scripts/semantic_filter_handle_close_all_and_return_with_code.awk`: semantic post-filter for `HANDLE_CloseAllAndReturnWithCode` compare lane.
- `src/decomp/scripts/semantic_filter_dos_close_with_signal_check.awk`: semantic post-filter for `DOS_CloseWithSignalCheck` compare lane.
- `src/decomp/scripts/semantic_filter_iostdreq_free.awk`: semantic post-filter for `IOSTDREQ_Free` compare lane.
- `src/decomp/scripts/semantic_filter_iostdreq_cleanup_signal_and_msgport.awk`: semantic post-filter for `IOSTDREQ_CleanupSignalAndMsgport` compare lane.
- `src/decomp/scripts/semantic_filter_cleanup_clear_vertb_interrupt_server.awk`: semantic post-filter for `CLEANUP_ClearVertbInterruptServer` compare lane.
- `src/decomp/scripts/semantic_filter_cleanup_clear_aud1_interrupt_vector.awk`: semantic post-filter for `CLEANUP_ClearAud1InterruptVector` compare lane.
- `src/decomp/scripts/semantic_filter_cleanup_clear_rbf_interrupt_and_serial.awk`: semantic post-filter for `CLEANUP_ClearRbfInterruptAndSerial` compare lane.
- `src/decomp/scripts/semantic_filter_cleanup_shutdown_input_devices.awk`: semantic post-filter for `CLEANUP_ShutdownInputDevices` compare lane.
- `src/decomp/scripts/semantic_filter_cleanup_shutdown_system.awk`: semantic post-filter for `CLEANUP_ShutdownSystem` compare lane.
- `src/decomp/scripts/semantic_filter_cleanup_release_display_resources.awk`: semantic post-filter for `CLEANUP_ReleaseDisplayResources` compare lane.
- `src/decomp/scripts/semantic_filter_cleanup_draw_banner_spacer_segment.awk`: semantic post-filter for `CLEANUP_DrawBannerSpacerSegment` compare lane.
- `src/decomp/scripts/semantic_filter_cleanup_draw_time_banner_segment.awk`: semantic post-filter for `CLEANUP_DrawTimeBannerSegment` compare lane.
- `src/decomp/scripts/semantic_filter_cleanup_draw_date_banner_segment.awk`: semantic post-filter for `CLEANUP_DrawDateBannerSegment` compare lane.
- `src/decomp/scripts/semantic_filter_cleanup_draw_datetime_banner_row.awk`: semantic post-filter for `CLEANUP_DrawDateTimeBannerRow` compare lane.
- `src/decomp/scripts/semantic_filter_render_short_month_short_day_of_week_day.awk`: semantic post-filter for `RENDER_SHORT_MONTH_SHORT_DAY_OF_WEEK_DAY` compare lane.
- `src/decomp/scripts/semantic_filter_cleanup_draw_grid_time_banner.awk`: semantic post-filter for `CLEANUP_DrawGridTimeBanner` compare lane.
- `src/decomp/scripts/semantic_filter_cleanup_format_clock_format_entry.awk`: semantic post-filter for `CLEANUP_FormatClockFormatEntry` compare lane.
- `src/decomp/scripts/semantic_filter_cleanup_draw_clock_format_frame.awk`: semantic post-filter for `CLEANUP_DrawClockFormatFrame` compare lane.
- `src/decomp/scripts/semantic_filter_cleanup_draw_clock_banner.awk`: semantic post-filter for `CLEANUP_DrawClockBanner` compare lane.
- `src/decomp/scripts/semantic_filter_cleanup_draw_clock_format_list.awk`: semantic post-filter for `CLEANUP_DrawClockFormatList` compare lane.
- `src/decomp/scripts/semantic_filter_cleanup_process_alerts.awk`: semantic post-filter for `CLEANUP_ProcessAlerts` compare lane.
- `src/decomp/scripts/semantic_filter_cleanup_test_entry_flag_y_and_bit1.awk`: semantic post-filter for `CLEANUP_TestEntryFlagYAndBit1` compare lane.
- `src/decomp/scripts/semantic_filter_cleanup_update_entry_flag_bytes.awk`: semantic post-filter for `CLEANUP_UpdateEntryFlagBytes` compare lane.
- `src/decomp/scripts/semantic_filter_cleanup_draw_inset_rect_frame.awk`: semantic post-filter for `CLEANUP_DrawInsetRectFrame` compare lane.
- `src/decomp/scripts/semantic_filter_cleanup_format_entry_string_tokens.awk`: semantic post-filter for `CLEANUP_FormatEntryStringTokens` compare lane.
- `src/decomp/scripts/semantic_filter_cleanup_build_aligned_status_line.awk`: semantic post-filter for `CLEANUP_BuildAlignedStatusLine` compare lane.
- `src/decomp/scripts/semantic_filter_cleanup_parse_aligned_listing_block.awk`: semantic post-filter for `CLEANUP_ParseAlignedListingBlock` compare lane.
- `src/decomp/scripts/semantic_filter_cleanup_build_and_render_aligned_status_banner.awk`: semantic post-filter for `CLEANUP_BuildAndRenderAlignedStatusBanner` compare lane.
- `src/decomp/scripts/semantic_filter_textdisp_find_control_token.awk`: semantic post-filter for `TEXTDISP_FindControlToken` compare lane.
- `src/decomp/scripts/semantic_filter_textdisp_find_alias_index_by_name.awk`: semantic post-filter for `TEXTDISP_FindAliasIndexByName` compare lane.
- `src/decomp/scripts/semantic_filter_textdisp_find_quoted_span.awk`: semantic post-filter for `TEXTDISP_FindQuotedSpan` compare lane.
- `src/decomp/scripts/semantic_filter_textdisp_format_entry_time_for_index.awk`: semantic post-filter for `TEXTDISP_FormatEntryTimeForIndex` compare lane.
- `src/decomp/scripts/semantic_filter_textdisp_compute_time_offset.awk`: semantic post-filter for `TEXTDISP_ComputeTimeOffset` compare lane.
- `src/decomp/scripts/semantic_filter_textdisp_draw_inset_rect_frame.awk`: semantic post-filter for `TEXTDISP_DrawInsetRectFrame` compare lane.
- `src/decomp/scripts/semantic_filter_textdisp_build_entry_short_name.awk`: semantic post-filter for `TEXTDISP_BuildEntryShortName` compare lane.
- `src/decomp/scripts/semantic_filter_textdisp_build_channel_label.awk`: semantic post-filter for `TEXTDISP_BuildChannelLabel` compare lane.
- `src/decomp/scripts/semantic_filter_textdisp_draw_channel_banner.awk`: semantic post-filter for `TEXTDISP_DrawChannelBanner` compare lane.
- `src/decomp/scripts/semantic_filter_textdisp_format_entry_time.awk`: semantic post-filter for `TEXTDISP_FormatEntryTime` compare lane.
- `src/decomp/scripts/semantic_filter_textdisp_update_channel_range_flags.awk`: semantic post-filter for `TEXTDISP_UpdateChannelRangeFlags` compare lane.
- `src/decomp/scripts/semantic_filter_textdisp_select_group_and_entry.awk`: semantic post-filter for `TEXTDISP_SelectGroupAndEntry` compare lane.
- `src/decomp/scripts/semantic_filter_textdisp_build_match_index_list.awk`: semantic post-filter for `TEXTDISP_BuildMatchIndexList` compare lane.
- `src/decomp/scripts/semantic_filter_textdisp_find_entry_match_index.awk`: semantic post-filter for `TEXTDISP_FindEntryMatchIndex` compare lane.
- `src/decomp/scripts/semantic_filter_textdisp_select_best_match_from_list.awk`: semantic post-filter for `TEXTDISP_SelectBestMatchFromList` compare lane.
- `src/decomp/scripts/semantic_filter_coi_free_entry_resources_return.awk`: semantic post-filter for `COI_FreeEntryResources_Return` compare lane.
- `src/decomp/scripts/semantic_filter_coi_clear_anim_object_strings_return.awk`: semantic post-filter for `COI_ClearAnimObjectStrings_Return` compare lane.
- `src/decomp/scripts/semantic_filter_coi_free_sub_entry_table_entries_return.awk`: semantic post-filter for `COI_FreeSubEntryTableEntries_Return` compare lane.
- `src/decomp/scripts/semantic_filter_coi_get_anim_field_pointer_by_mode_return.awk`: semantic post-filter for `COI_GetAnimFieldPointerByMode_Return` compare lane.
- `src/decomp/scripts/semantic_filter_coi_test_entry_within_time_window_return.awk`: semantic post-filter for `COI_TestEntryWithinTimeWindow_Return` compare lane.
- `src/decomp/scripts/semantic_filter_coi_append_anim_field_with_trailing_space_return.awk`: semantic post-filter for `COI_AppendAnimFieldWithTrailingSpace_Return` compare lane.
- `src/decomp/scripts/semantic_filter_coi_compute_entry_time_delta_minutes_return.awk`: semantic post-filter for `COI_ComputeEntryTimeDeltaMinutes_Return` compare lane.
- `src/decomp/scripts/semantic_filter_coi_format_entry_display_text_return.awk`: semantic post-filter for `COI_FormatEntryDisplayText_Return` compare lane.
- `src/decomp/scripts/semantic_filter_coi_count_escape14_before_null.awk`: semantic post-filter for `COI_CountEscape14BeforeNull` compare lane.
- `src/decomp/scripts/semantic_filter_coi_ensure_anim_object_allocated.awk`: semantic post-filter for `COI_EnsureAnimObjectAllocated` compare lane.
- `src/decomp/scripts/semantic_filter_coi_select_anim_field_pointer.awk`: semantic post-filter for `COI_SelectAnimFieldPointer` compare lane.
- `src/decomp/scripts/semantic_filter_coi_render_clock_format_entry_variant.awk`: semantic post-filter for `COI_RenderClockFormatEntryVariant` compare lane.
- `src/decomp/scripts/semantic_filter_coi_process_entry_selection_state.awk`: semantic post-filter for `COI_ProcessEntrySelectionState` compare lane.
- `src/decomp/scripts/semantic_filter_coi_compute_entry_time_delta_minutes.awk`: semantic post-filter for `COI_ComputeEntryTimeDeltaMinutes` compare lane.
- `src/decomp/scripts/semantic_filter_coi_free_entry_resources.awk`: semantic post-filter for `COI_FreeEntryResources` compare lane.
- `src/decomp/scripts/semantic_filter_coi_clear_anim_object_strings.awk`: semantic post-filter for `COI_ClearAnimObjectStrings` compare lane.
- `src/decomp/scripts/semantic_filter_coi_free_sub_entry_table_entries.awk`: semantic post-filter for `COI_FreeSubEntryTableEntries` compare lane.
- `src/decomp/scripts/semantic_filter_coi_get_anim_field_pointer_by_mode.awk`: semantic post-filter for `COI_GetAnimFieldPointerByMode` compare lane.
- `src/decomp/scripts/semantic_filter_coi_test_entry_within_time_window.awk`: semantic post-filter for `COI_TestEntryWithinTimeWindow` compare lane.
- `src/decomp/scripts/semantic_filter_coi_format_entry_display_text.awk`: semantic post-filter for `COI_FormatEntryDisplayText` compare lane.
- `src/decomp/scripts/semantic_filter_coi_alloc_sub_entry_table.awk`: semantic post-filter for `COI_AllocSubEntryTable` compare lane.
- `src/decomp/scripts/semantic_filter_coi_load_oi_data_file.awk`: semantic post-filter for `COI_LoadOiDataFile` compare lane.
- `src/decomp/scripts/semantic_filter_coi_write_oi_data_file.awk`: semantic post-filter for `COI_WriteOiDataFile` compare lane.
- `src/decomp/scripts/semantic_filter_ctasks_close_task_teardown.awk`: semantic post-filter for `CTASKS_CloseTaskTeardown` compare lane.
- `src/decomp/scripts/semantic_filter_ctasks_start_close_task_process.awk`: semantic post-filter for `CTASKS_StartCloseTaskProcess` compare lane.
- `src/decomp/scripts/semantic_filter_ctasks_iff_task_cleanup.awk`: semantic post-filter for `CTASKS_IFFTaskCleanup` compare lane.
- `src/decomp/scripts/semantic_filter_ctasks_start_iff_task_process.awk`: semantic post-filter for `CTASKS_StartIffTaskProcess` compare lane.
- `src/decomp/scripts/semantic_filter_disptext_has_multiple_lines.awk`: semantic post-filter for `DISPTEXT_HasMultipleLines` compare lane.
- `src/decomp/scripts/semantic_filter_disptext_is_current_line_last.awk`: semantic post-filter for `DISPTEXT_IsCurrentLineLast` compare lane.
- `src/decomp/scripts/semantic_filter_disptext_get_total_line_count.awk`: semantic post-filter for `DISPTEXT_GetTotalLineCount` compare lane.
- `src/decomp/scripts/semantic_filter_disptext_is_last_line_selected.awk`: semantic post-filter for `DISPTEXT_IsLastLineSelected` compare lane.
- `src/decomp/scripts/semantic_filter_disptext_set_current_line_index.awk`: semantic post-filter for `DISPTEXT_SetCurrentLineIndex` compare lane.
- `src/decomp/scripts/semantic_filter_disptext_measure_current_line_length.awk`: semantic post-filter for `DISPTEXT_MeasureCurrentLineLength` compare lane.
- `src/decomp/scripts/semantic_filter_disptext_compute_visible_line_count.awk`: semantic post-filter for `DISPTEXT_ComputeVisibleLineCount` compare lane.
- `src/decomp/scripts/semantic_filter_disptext_init_buffers.awk`: semantic post-filter for `DISPTEXT_InitBuffers` compare lane.
- `src/decomp/scripts/semantic_filter_disptext_free_buffers.awk`: semantic post-filter for `DISPTEXT_FreeBuffers` compare lane.
- `src/decomp/scripts/semantic_filter_disptext_finalize_line_table.awk`: semantic post-filter for `DISPTEXT_FinalizeLineTable` compare lane.
- `src/decomp/scripts/semantic_filter_disptext_set_layout_params.awk`: semantic post-filter for `DISPTEXT_SetLayoutParams` compare lane.
- `src/decomp/scripts/semantic_filter_disptext_compute_marker_widths.awk`: semantic post-filter for `DISPTEXT_ComputeMarkerWidths` compare lane.
- `src/decomp/scripts/semantic_filter_disptext_build_line_with_width.awk`: semantic post-filter for `DISPTEXT_BuildLineWithWidth` compare lane.
- `src/decomp/scripts/semantic_filter_disptext_build_line_pointer_table.awk`: semantic post-filter for `DISPTEXT_BuildLinePointerTable` compare lane.
- `src/decomp/scripts/semantic_filter_disptext_append_to_buffer.awk`: semantic post-filter for `DISPTEXT_AppendToBuffer` compare lane.
- `src/decomp/scripts/semantic_filter_disptext_build_layout_for_source.awk`: semantic post-filter for `DISPTEXT_BuildLayoutForSource` compare lane.
- `src/decomp/scripts/semantic_filter_disptext_layout_source_to_lines.awk`: semantic post-filter for `DISPTEXT_LayoutSourceToLines` compare lane.
- `src/decomp/scripts/semantic_filter_disptext_layout_and_append_to_buffer.awk`: semantic post-filter for `DISPTEXT_LayoutAndAppendToBuffer` compare lane.
- `src/decomp/scripts/semantic_filter_disptext_render_current_line.awk`: semantic post-filter for `DISPTEXT_RenderCurrentLine` compare lane.
- `src/decomp/scripts/semantic_filter_displib_find_previous_valid_entry_index.awk`: semantic post-filter for `DISPLIB_FindPreviousValidEntryIndex` compare lane.
- `src/decomp/scripts/semantic_filter_esqdisp_test_entry_bits0_and2.awk`: semantic post-filter for `ESQDISP_TestEntryBits0And2` compare lane.
- `src/decomp/scripts/semantic_filter_esqdisp_get_entry_pointer_by_mode.awk`: semantic post-filter for `ESQDISP_GetEntryPointerByMode` compare lane.
- `src/decomp/scripts/semantic_filter_esqdisp_get_entry_aux_pointer_by_mode.awk`: semantic post-filter for `ESQDISP_GetEntryAuxPointerByMode` compare lane.
- `src/decomp/scripts/semantic_filter_esqdisp_compute_schedule_offset_for_row.awk`: semantic post-filter for `ESQDISP_ComputeScheduleOffsetForRow` compare lane.
- `src/decomp/scripts/semantic_filter_esqdisp_test_entry_grid_eligibility.awk`: semantic post-filter for `ESQDISP_TestEntryGridEligibility` compare lane.
- `src/decomp/scripts/semantic_filter_esqdisp_test_word_is_zero_booleanize.awk`: semantic post-filter for `ESQDISP_TestWordIsZeroBooleanize` compare lane.
- `src/decomp/scripts/semantic_filter_esqdisp_process_grid_messages_if_idle.awk`: semantic post-filter for `ESQDISP_ProcessGridMessagesIfIdle` compare lane.
- `src/decomp/scripts/semantic_filter_esqdisp_refresh_status_indicators_from_current_mask.awk`: semantic post-filter for `ESQDISP_RefreshStatusIndicatorsFromCurrentMask` compare lane.
- `src/decomp/scripts/semantic_filter_esqdisp_init_highlight_message_pattern.awk`: semantic post-filter for `ESQDISP_InitHighlightMessagePattern` compare lane.
- `src/decomp/scripts/semantic_filter_esqdisp_update_status_mask_and_refresh.awk`: semantic post-filter for `ESQDISP_UpdateStatusMaskAndRefresh` compare lane.
- `src/decomp/scripts/semantic_filter_esqdisp_allocate_highlight_bitmaps.awk`: semantic post-filter for `ESQDISP_AllocateHighlightBitmaps` compare lane.
- `src/decomp/scripts/semantic_filter_esqdisp_apply_status_mask_to_indicators.awk`: semantic post-filter for `ESQDISP_ApplyStatusMaskToIndicators` compare lane.
- `src/decomp/scripts/semantic_filter_esqdisp_set_status_indicator_color_slot.awk`: semantic post-filter for `ESQDISP_SetStatusIndicatorColorSlot` compare lane.
- `src/decomp/scripts/semantic_filter_esqdisp_queue_highlight_draw_message.awk`: semantic post-filter for `ESQDISP_QueueHighlightDrawMessage` compare lane.
- `src/decomp/scripts/semantic_filter_esqdisp_fill_program_info_header_fields.awk`: semantic post-filter for `ESQDISP_FillProgramInfoHeaderFields` compare lane.
- `src/decomp/scripts/semantic_filter_esqdisp_poll_input_mode_and_refresh_selection.awk`: semantic post-filter for `ESQDISP_PollInputModeAndRefreshSelection` compare lane.
- `src/decomp/scripts/semantic_filter_esqdisp_normalize_clock_and_redraw_banner.awk`: semantic post-filter for `ESQDISP_NormalizeClockAndRedrawBanner` compare lane.
- `src/decomp/scripts/semantic_filter_esqdisp_mirror_primary_entries_to_secondary_if_empty.awk`: semantic post-filter for `ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty` compare lane.
- `src/decomp/scripts/semantic_filter_esqdisp_promote_secondary_line_head_tail_if_marked.awk`: semantic post-filter for `ESQDISP_PromoteSecondaryLineHeadTailIfMarked` compare lane.
- `src/decomp/scripts/semantic_filter_esqdisp_promote_secondary_group_to_primary.awk`: semantic post-filter for `ESQDISP_PromoteSecondaryGroupToPrimary` compare lane.
- `src/decomp/scripts/semantic_filter_esqdisp_propagate_primary_title_metadata_to_secondary.awk`: semantic post-filter for `ESQDISP_PropagatePrimaryTitleMetadataToSecondary` compare lane.
- `src/decomp/scripts/semantic_filter_esqdisp_draw_status_banner_impl.awk`: semantic post-filter for `ESQDISP_DrawStatusBanner_Impl` compare lane.
- `src/decomp/scripts/semantic_filter_esqdisp_parse_program_info_command_record.awk`: semantic post-filter for `ESQDISP_ParseProgramInfoCommandRecord` compare lane.
- `src/decomp/scripts/semantic_filter_esqdisp_draw_status_banner.awk`: semantic post-filter for `ESQDISP_DrawStatusBanner` compare lane.
- `src/decomp/scripts/semantic_filter_esqdisp_jmptbl_newgrid_and_graphics_alloc_raster.awk`: semantic post-filter for `ESQDISP_JMPTBL_NEWGRID_ProcessGridMessages` + `ESQDISP_JMPTBL_GRAPHICS_AllocRaster` compare lane.
- `src/decomp/scripts/semantic_filter_flib_append_clock_stamped_log_entry.awk`: semantic post-filter for `FLIB_AppendClockStampedLogEntry` compare lane.
- `src/decomp/scripts/semantic_filter_displib_normalize_value_by_step.awk`: semantic post-filter for `DISPLIB_NormalizeValueByStep` compare lane.
- `src/decomp/scripts/semantic_filter_displib_reset_line_tables.awk`: semantic post-filter for `DISPLIB_ResetLineTables` compare lane.
- `src/decomp/scripts/semantic_filter_displib_reset_text_buffer_and_line_tables.awk`: semantic post-filter for `DISPLIB_ResetTextBufferAndLineTables` compare lane.
- `src/decomp/scripts/semantic_filter_displib_commit_current_line_pen_and_advance.awk`: semantic post-filter for `DISPLIB_CommitCurrentLinePenAndAdvance` compare lane.
- `src/decomp/scripts/semantic_filter_displib_display_text_at_position.awk`: semantic post-filter for `DISPLIB_DisplayTextAtPosition` compare lane.
- `src/decomp/scripts/semantic_filter_displib_apply_inline_alignment_padding.awk`: semantic post-filter for `DISPLIB_ApplyInlineAlignmentPadding` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_esq_handle_serial_rbf_interrupt.awk`: semantic post-filter for `ESQFUNC_JMPTBL_ESQ_HandleSerialRbfInterrupt` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_esq_tick_global_counters.awk`: semantic post-filter for `ESQFUNC_JMPTBL_ESQ_TickGlobalCounters` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_esq_poll_ctrl_input.awk`: semantic post-filter for `ESQFUNC_JMPTBL_ESQ_PollCtrlInput` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_script_handle_serial_ctrl_cmd.awk`: semantic post-filter for `ESQFUNC_JMPTBL_SCRIPT_HandleSerialCtrlCmd` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_textdisp_tick_display_state.awk`: semantic post-filter for `ESQFUNC_JMPTBL_TEXTDISP_TickDisplayState` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_allocate_line_text_buffers.awk`: semantic post-filter for `ESQFUNC_AllocateLineTextBuffers` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_free_line_text_buffers.awk`: semantic post-filter for `ESQFUNC_FreeLineTextBuffers` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_update_disk_warning_and_refresh_tick.awk`: semantic post-filter for `ESQFUNC_UpdateDiskWarningAndRefreshTick` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_wait_for_clock_change_and_service_ui.awk`: semantic post-filter for `ESQFUNC_WaitForClockChangeAndServiceUi` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_commit_secondary_state_and_persist.awk`: semantic post-filter for `ESQFUNC_CommitSecondaryStateAndPersist` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_process_ui_frame_tick.awk`: semantic post-filter for `ESQFUNC_ProcessUiFrameTick` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_service_ui_tick_if_running.awk`: semantic post-filter for `ESQFUNC_ServiceUiTickIfRunning` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_free_extra_title_text_pointers.awk`: semantic post-filter for `ESQFUNC_FreeExtraTitleTextPointers` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_update_refresh_mode_state.awk`: semantic post-filter for `ESQFUNC_UpdateRefreshModeState` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_draw_esc_menu_version.awk`: semantic post-filter for `ESQFUNC_DrawEscMenuVersion` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_trim_text_to_pixel_width_word_boundary.awk`: semantic post-filter for `ESQFUNC_TrimTextToPixelWidthWordBoundary` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_rebuild_pw_brush_list_from_tag_table.awk`: semantic post-filter for `ESQFUNC_RebuildPwBrushListFromTagTable` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_select_and_apply_brush_for_current_entry.awk`: semantic post-filter for `ESQFUNC_SelectAndApplyBrushForCurrentEntry` compare lane.
- `src/decomp/scripts/semantic_filter_esqfunc_draw_memory_status_screen.awk`: semantic post-filter for `ESQFUNC_DrawMemoryStatusScreen` compare lane.
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
- `src/decomp/scripts/promote_esq_invoke_gcommand_init_target_gcc.sh`: promotion gate for Target 707 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_try_rom_write_test_target_gcc.sh`: promotion gate for Target 708 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_supervisor_cold_reboot_target_gcc.sh`: promotion gate for Target 709 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_init_audio1_dma_target_gcc.sh`: promotion gate for Target 712 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_read_serial_rbf_byte_target_gcc.sh`: promotion gate for Target 713 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_handle_serial_rbf_interrupt_target_gcc.sh`: promotion gate for Target 714 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_capture_ctrl_bit4_stream_buffer_byte_target_gcc.sh`: promotion gate for Target 715 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_check_topaz_font_guard_target_gcc.sh`: promotion gate for Target 756 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_poll_ctrl_input_target_gcc.sh`: promotion gate for Target 716 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_set_copper_effect_default_target_gcc.sh`: promotion gate for Target 717 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_set_copper_effect_all_on_target_gcc.sh`: promotion gate for Target 718 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_set_copper_effect_custom_target_gcc.sh`: promotion gate for Target 719 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_set_copper_effect_off_disable_highlight_target_gcc.sh`: promotion gate for Target 720 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_set_copper_effect_on_enable_highlight_target_gcc.sh`: promotion gate for Target 721 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_set_copper_effect_params_target_gcc.sh`: promotion gate for Target 725 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_update_copper_lists_from_params_target_gcc.sh`: promotion gate for Target 730 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_dec_color_step_target_gcc.sh`: promotion gate for Target 726 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_bump_color_toward_targets_target_gcc.sh`: promotion gate for Target 727 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_move_copper_entry_toward_start_target_gcc.sh`: promotion gate for Target 728 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_move_copper_entry_toward_end_target_gcc.sh`: promotion gate for Target 729 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_generate_xor_checksum_byte_target_gcc.sh`: promotion gate for Target 731 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_terminate_after_second_quote_target_gcc.sh`: promotion gate for Target 732 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_test_bit1_based_target_gcc.sh`: promotion gate for Target 733 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_set_bit1_based_target_gcc.sh`: promotion gate for Target 734 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_reverse_bits_in6_bytes_target_gcc.sh`: promotion gate for Target 735 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_get_half_hour_slot_index_target_gcc.sh`: promotion gate for Target 736 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_clamp_banner_char_range_target_gcc.sh`: promotion gate for Target 737 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_store_ctrl_sample_entry_target_gcc.sh`: promotion gate for Target 738 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_format_time_stamp_target_gcc.sh`: promotion gate for Target 739 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_calc_day_of_year_from_month_day_target_gcc.sh`: promotion gate for Target 740 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_update_month_day_from_day_of_year_target_gcc.sh`: promotion gate for Target 741 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_write_dec_fixed_width_target_gcc.sh`: promotion gate for Target 742 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_pack_bits_decode_target_gcc.sh`: promotion gate for Target 743 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_seed_minute_event_thresholds_target_gcc.sh`: promotion gate for Target 744 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_adjust_bracketed_hour_in_string_target_gcc.sh`: promotion gate for Target 745 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_wildcard_match_target_gcc.sh`: promotion gate for Target 746 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_find_substring_case_fold_target_gcc.sh`: promotion gate for Target 747 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_dec_copper_lists_primary_target_gcc.sh`: promotion gate for Target 748 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_inc_copper_lists_towards_targets_target_gcc.sh`: promotion gate for Target 749 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_tick_clock_and_flag_events_target_gcc.sh`: promotion gate for Target 750 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_cold_reboot_target_gcc.sh`: promotion gate for Target 751 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_tick_global_counters_target_gcc.sh`: promotion gate for Target 752 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_advance_banner_char_index_return_target_gcc.sh`: promotion gate for Target 753 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_capture_ctrl_bit3_stream_target_gcc.sh`: promotion gate for Target 754 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_capture_ctrl_bit4_stream_target_gcc.sh`: promotion gate for Target 755 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_noop_target_gcc.sh`: promotion gate for Target 722 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_noop_006a_target_gcc.sh`: promotion gate for Target 723 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_noop_0074_target_gcc.sh`: promotion gate for Target 724 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_get_bit_3_of_ciab_pra_into_d1_target_gcc.sh`: promotion gate for Target 710 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_get_bit_4_of_ciab_pra_into_d1_target_gcc.sh`: promotion gate for Target 711 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_main_exit_noop_hook_target_gcc.sh`: promotion gate for Target 079 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_dos_open_file_with_mode_target_gcc.sh`: promotion gate for Target 080 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_graphics_alloc_raster_target_gcc.sh`: promotion gate for Target 081 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_graphics_free_raster_target_gcc.sh`: promotion gate for Target 082 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_dos_movep_word_read_callback_target_gcc.sh`: promotion gate for Target 083 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_unknown_parse_list_and_update_entries_target_gcc.sh`: promotion gate for Target 084 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqproto_copy_label_to_global_target_gcc.sh`: promotion gate for Target 590 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqproto_parse_digit_label_and_display_target_gcc.sh`: promotion gate for Target 591 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_unknown_parse_record_and_update_display_target_gcc.sh`: promotion gate for Target 592 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqproto_verify_checksum_and_parse_record_target_gcc.sh`: promotion gate for Target 593 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqproto_verify_checksum_and_parse_list_target_gcc.sh`: promotion gate for Target 594 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_unknown36_finalize_request_target_gcc.sh`: promotion gate for Target 595 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_unknown36_show_abort_requester_target_gcc.sh`: promotion gate for Target 596 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_handle_open_from_mode_string_target_gcc.sh`: promotion gate for Target 597 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_wdisp_format_with_callback_target_gcc.sh`: promotion gate for Target 598 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_handle_open_entry_with_flags_target_gcc.sh`: promotion gate for Target 599 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_buffer_ensure_allocated_target_gcc.sh`: promotion gate for Target 600 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_buffer_flush_all_and_close_with_code_target_gcc.sh`: promotion gate for Target 601 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_graphics_bltbitmaprastport_target_gcc.sh`: promotion gate for Target 602 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_math_divu32_target_gcc.sh`: promotion gate for Target 603 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_brush_planemaskforindex_target_gcc.sh`: promotion gate for Target 604 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_brush_append_brush_node_target_gcc.sh`: promotion gate for Target 690 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_brush_pop_brush_head_target_gcc.sh`: promotion gate for Target 691 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_brush_find_type3_brush_target_gcc.sh`: promotion gate for Target 692 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_brush_find_brush_by_predicate_target_gcc.sh`: promotion gate for Target 693 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_brush_free_brush_list_return_target_gcc.sh`: promotion gate for Target 694 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_brush_select_brush_slot_return_target_gcc.sh`: promotion gate for Target 695 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_brush_alloc_brush_node_target_gcc.sh`: promotion gate for Target 696 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_brush_free_brush_list_target_gcc.sh`: promotion gate for Target 697 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_brush_normalize_brush_names_target_gcc.sh`: promotion gate for Target 698 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_brush_select_brush_by_label_target_gcc.sh`: promotion gate for Target 699 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_brush_free_brush_resources_target_gcc.sh`: promotion gate for Target 700 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_brush_populate_brush_list_target_gcc.sh`: promotion gate for Target 701 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_brush_stream_font_chunk_target_gcc.sh`: promotion gate for Target 702 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_brush_load_color_text_font_target_gcc.sh`: promotion gate for Target 703 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_brush_clone_brush_record_target_gcc.sh`: promotion gate for Target 704 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_brush_select_brush_slot_target_gcc.sh`: promotion gate for Target 705 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_brush_load_brush_asset_target_gcc.sh`: promotion gate for Target 706 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_datetime_isleapyear_target_gcc.sh`: promotion gate for Target 605 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_datetime_adjust_month_index_target_gcc.sh`: promotion gate for Target 606 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_datetime_normalize_month_range_target_gcc.sh`: promotion gate for Target 607 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_dst_normalize_day_of_year_target_gcc.sh`: promotion gate for Target 608 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_dst_write_rtc_from_globals_target_gcc.sh`: promotion gate for Target 609 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_dst_tick_banner_counters_target_gcc.sh`: promotion gate for Target 610 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_dst_build_banner_time_word_target_gcc.sh`: promotion gate for Target 611 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_dst_compute_banner_index_target_gcc.sh`: promotion gate for Target 612 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_dst_add_time_offset_target_gcc.sh`: promotion gate for Target 613 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_dst_free_banner_struct_target_gcc.sh`: promotion gate for Target 614 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_dst_free_banner_pair_target_gcc.sh`: promotion gate for Target 615 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_dst_allocate_banner_struct_target_gcc.sh`: promotion gate for Target 616 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_dst_rebuild_banner_pair_target_gcc.sh`: promotion gate for Target 617 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_dst_load_banner_pair_from_files_target_gcc.sh`: promotion gate for Target 618 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_dst_handle_banner_command32_33_target_gcc.sh`: promotion gate for Target 619 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_dst_format_banner_datetime_target_gcc.sh`: promotion gate for Target 620 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_dst_refresh_banner_buffer_target_gcc.sh`: promotion gate for Target 621 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_dst_update_banner_queue_target_gcc.sh`: promotion gate for Target 622 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_dst_build_banner_time_entry_target_gcc.sh`: promotion gate for Target 623 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_parse_command_line_and_run_target_gcc.sh`: promotion gate for Target 085 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_stream_buffered_write_string_target_gcc.sh`: promotion gate for Target 086 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_unknown29_jmptbl_esq_main_init_and_run_target_gcc.sh`: promotion gate for Target 087 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_unknown_jmptbl_esqiff2_read_serial_record_into_buffer_target_gcc.sh`: promotion gate for Target 317 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_unknown_jmptbl_displib_display_text_at_position_target_gcc.sh`: promotion gate for Target 318 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_unknown_jmptbl_esq_wildcard_match_target_gcc.sh`: promotion gate for Target 319 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_unknown_jmptbl_dst_normalize_day_of_year_target_gcc.sh`: promotion gate for Target 320 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_unknown_jmptbl_esq_generate_xor_checksum_byte_target_gcc.sh`: promotion gate for Target 321 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqproto_jmptbl_esqpars_replace_owned_string_target_gcc.sh`: promotion gate for Target 322 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqshared_jmptbl_dst_build_banner_time_word_target_gcc.sh`: promotion gate for Target 323 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqshared_jmptbl_esq_reverse_bits_in6_bytes_target_gcc.sh`: promotion gate for Target 324 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqshared_jmptbl_esq_set_bit1_based_target_gcc.sh`: promotion gate for Target 325 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqshared_jmptbl_esq_adjust_bracketed_hour_in_string_target_gcc.sh`: promotion gate for Target 326 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqshared_jmptbl_coi_ensure_anim_object_allocated_target_gcc.sh`: promotion gate for Target 327 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqshared_jmptbl_esq_wildcard_match_target_gcc.sh`: promotion gate for Target 328 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqshared_jmptbl_str_skip_class3_chars_target_gcc.sh`: promotion gate for Target 329 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqshared_jmptbl_esq_test_bit1_based_target_gcc.sh`: promotion gate for Target 330 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqpars_jmptbl_diskio2_flushdatafilesifneeded_target_gcc.sh`: promotion gate for Target 331 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqpars_jmptbl_newgrid_rebuildindexcache_target_gcc.sh`: promotion gate for Target 332 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqpars_jmptbl_datetime_savepairtofile_target_gcc.sh`: promotion gate for Target 333 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqpars_jmptbl_esqproto_verifychecksumandparselist_target_gcc.sh`: promotion gate for Target 334 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqpars_jmptbl_p_type_parseandstoretyperecord_target_gcc.sh`: promotion gate for Target 335 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqpars_jmptbl_esqproto_copylabeltoglobal_target_gcc.sh`: promotion gate for Target 336 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqpars_jmptbl_dst_handlebannercommand32_33_target_gcc.sh`: promotion gate for Target 337 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqpars_jmptbl_esq_seedminuteeventthresholds_target_gcc.sh`: promotion gate for Target 338 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqpars_jmptbl_parseini_handlefontcommand_target_gcc.sh`: promotion gate for Target 339 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqpars_jmptbl_textdisp_applysourceconfigallentries_target_gcc.sh`: promotion gate for Target 340 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqpars_jmptbl_brush_planemaskforindex_target_gcc.sh`: promotion gate for Target 341 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqpars_jmptbl_script_resetctrlcontextandclearstatusline_target_gcc.sh`: promotion gate for Target 342 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqpars_jmptbl_parseini_writertcfromglobals_target_gcc.sh`: promotion gate for Target 343 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqpars_jmptbl_locavail_saveavailabilitydatafile_target_gcc.sh`: promotion gate for Target 344 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqpars_jmptbl_displib_displaytextatposition_target_gcc.sh`: promotion gate for Target 345 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqpars_jmptbl_ladfunc_savetextadstofile_target_gcc.sh`: promotion gate for Target 346 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqpars_jmptbl_parse_readsignedlongskipclass3_alt_target_gcc.sh`: promotion gate for Target 347 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqpars_jmptbl_diskio2_handleinteractivefiletransfer_target_gcc.sh`: promotion gate for Target 348 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqpars_jmptbl_p_type_writepromoiddatafile_target_gcc.sh`: promotion gate for Target 349 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqpars_jmptbl_coi_freeentryresources_target_gcc.sh`: promotion gate for Target 350 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqpars_jmptbl_dst_updatebannerqueue_target_gcc.sh`: promotion gate for Target 351 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqpars_jmptbl_esqproto_verifychecksumandparserecord_target_gcc.sh`: promotion gate for Target 352 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqpars_jmptbl_esqproto_parsedigitlabelanddisplay_target_gcc.sh`: promotion gate for Target 353 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqpars_jmptbl_diskio_parseconfigbuffer_target_gcc.sh`: promotion gate for Target 354 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqpars_jmptbl_cleanup_parsealignedlistingblock_target_gcc.sh`: promotion gate for Target 355 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqpars_jmptbl_script_readserialrbfbyte_target_gcc.sh`: promotion gate for Target 356 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqpars_jmptbl_esq_generatexorchecksumbyte_target_gcc.sh`: promotion gate for Target 357 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqpars_jmptbl_dst_refreshbannerbuffer_target_gcc.sh`: promotion gate for Target 358 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqpars_jmptbl_diskio_saveconfigtofilehandle_target_gcc.sh`: promotion gate for Target 359 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_ed1_jmptbl_newgrid_drawtopborderline_target_gcc.sh`: promotion gate for Target 360 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_ed1_jmptbl_locavail_resetfiltercursorstate_target_gcc.sh`: promotion gate for Target 361 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_ed1_jmptbl_gcommand_resethighlightmessages_target_gcc.sh`: promotion gate for Target 362 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_ed1_jmptbl_ladfunc_mergehighlownibbles_target_gcc.sh`: promotion gate for Target 363 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_ed1_jmptbl_ladfunc_savetextadstofile_target_gcc.sh`: promotion gate for Target 364 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_ed1_jmptbl_esq_coldreboot_target_gcc.sh`: promotion gate for Target 365 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_ed1_jmptbl_esqshared4_loaddefaultpalettetocopper_noop_target_gcc.sh`: promotion gate for Target 366 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_ed1_jmptbl_gcommand_seedbannerdefaults_target_gcc.sh`: promotion gate for Target 367 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_ed1_jmptbl_mem_move_target_gcc.sh`: promotion gate for Target 368 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_ed1_jmptbl_gcommand_seedbannerfromprefs_target_gcc.sh`: promotion gate for Target 369 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_ed1_jmptbl_cleanup_drawdatetimebannerrow_target_gcc.sh`: promotion gate for Target 370 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_ed1_jmptbl_ladfunc_packnibblestobyte_target_gcc.sh`: promotion gate for Target 371 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_jmptbl_textdisp_setrastformode_target_gcc.sh`: promotion gate for Target 372 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_jmptbl_p_type_promotesecondarylist_target_gcc.sh`: promotion gate for Target 373 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_jmptbl_diskio_probedrivesandassignpaths_target_gcc.sh`: promotion gate for Target 374 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_jmptbl_parseini_updatectrlhdeltamax_target_gcc.sh`: promotion gate for Target 375 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_jmptbl_esq_clampbannercharrange_target_gcc.sh`: promotion gate for Target 376 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_jmptbl_script_readciabbit3flag_target_gcc.sh`: promotion gate for Target 377 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_jmptbl_tliba3_drawcenteredwrappedtextlines_target_gcc.sh`: promotion gate for Target 378 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_jmptbl_script_getctrllineflag_target_gcc.sh`: promotion gate for Target 379 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_jmptbl_locavail_syncsecondaryfilterforcurrentgroup_target_gcc.sh`: promotion gate for Target 380 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_jmptbl_textdisp_resetselectionandrefresh_target_gcc.sh`: promotion gate for Target 381 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_jmptbl_parseini_monitorclockchange_target_gcc.sh`: promotion gate for Target 382 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_jmptbl_ladfunc_parsehexdigit_target_gcc.sh`: promotion gate for Target 383 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_jmptbl_cleanup_processalerts_target_gcc.sh`: promotion gate for Target 384 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_jmptbl_esq_gethalfhourslotindex_target_gcc.sh`: promotion gate for Target 385 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_jmptbl_cleanup_drawclockbanner_target_gcc.sh`: promotion gate for Target 386 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_jmptbl_parseini_computehtcmaxvalues_target_gcc.sh`: promotion gate for Target 387 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_jmptbl_ladfunc_updatehighlightstate_target_gcc.sh`: promotion gate for Target 388 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_jmptbl_p_type_ensuresecondarylist_target_gcc.sh`: promotion gate for Target 389 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_jmptbl_script_readciabbit5mask_target_gcc.sh`: promotion gate for Target 390 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_jmptbl_parseini_normalizeclockdata_target_gcc.sh`: promotion gate for Target 391 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_jmptbl_esq_tickglobalcounters_target_gcc.sh`: promotion gate for Target 392 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_jmptbl_script_handleserialctrlcmd_target_gcc.sh`: promotion gate for Target 393 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_jmptbl_esq_handleserialrbfinterrupt_target_gcc.sh`: promotion gate for Target 394 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_jmptbl_textdisp_tickdisplaystate_target_gcc.sh`: promotion gate for Target 395 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_jmptbl_esq_pollctrlinput_target_gcc.sh`: promotion gate for Target 396 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_jmptbl_locavail_rebuildfilterstatefromcurrentgroup_target_gcc.sh`: promotion gate for Target 397 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_jmptbl_string_copypadnul_target_gcc.sh`: promotion gate for Target 398 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqdisp_jmptbl_newgrid_processgridmessages_target_gcc.sh`: promotion gate for Target 399 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqdisp_jmptbl_graphics_allocraster_target_gcc.sh`: promotion gate for Target 400 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ag_jmptbl_memory_deallocate_memory_target_gcc.sh`: promotion gate for Target 096 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ag_jmptbl_memory_allocate_memory_target_gcc.sh`: promotion gate for Target 097 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ag_jmptbl_struct_alloc_with_owner_target_gcc.sh`: promotion gate for Target 098 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ag_jmptbl_struct_free_with_size_field_target_gcc.sh`: promotion gate for Target 099 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ag_jmptbl_math_divs32_target_gcc.sh`: promotion gate for Target 100 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ag_jmptbl_math_mulu32_target_gcc.sh`: promotion gate for Target 101 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ag_jmptbl_dos_open_file_with_mode_target_gcc.sh`: promotion gate for Target 102 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ag_jmptbl_string_copy_pad_nul_target_gcc.sh`: promotion gate for Target 103 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ag_jmptbl_parse_read_signed_long_skip_class3_alt_target_gcc.sh`: promotion gate for Target 107 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ag_jmptbl_signal_create_msgport_with_signal_target_gcc.sh`: promotion gate for Target 281 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ag_jmptbl_textdisp_reset_selection_and_refresh_target_gcc.sh`: promotion gate for Target 282 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ag_jmptbl_iostdreq_cleanup_signal_and_msgport_target_gcc.sh`: promotion gate for Target 283 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ag_jmptbl_esqfunc_service_ui_tick_if_running_target_gcc.sh`: promotion gate for Target 284 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ag_jmptbl_script_begin_banner_char_transition_target_gcc.sh`: promotion gate for Target 285 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ag_jmptbl_ladfunc2_emit_escaped_string_to_scratch_target_gcc.sh`: promotion gate for Target 286 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ag_jmptbl_script_check_path_exists_target_gcc.sh`: promotion gate for Target 287 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ag_jmptbl_esqfunc_update_refresh_mode_state_target_gcc.sh`: promotion gate for Target 288 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_am_jmptbl_signal_create_msgport_with_signal_target_gcc.sh`: promotion gate for Target 104 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_am_jmptbl_struct_alloc_with_owner_target_gcc.sh`: promotion gate for Target 105 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_am_jmptbl_list_init_header_target_gcc.sh`: promotion gate for Target 106 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_am_jmptbl_ladfunc_clear_banner_rect_entries_target_gcc.sh`: promotion gate for Target 289 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_am_jmptbl_parseini_update_clock_from_rtc_target_gcc.sh`: promotion gate for Target 290 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_am_jmptbl_script_init_ctrl_context_target_gcc.sh`: promotion gate for Target 291 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_am_jmptbl_diskio2_parse_ini_file_from_disk_target_gcc.sh`: promotion gate for Target 292 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_am_jmptbl_esq_check_topaz_font_guard_target_gcc.sh`: promotion gate for Target 293 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_am_jmptbl_p_type_reset_lists_and_load_promo_ids_target_gcc.sh`: promotion gate for Target 294 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_am_jmptbl_ladfunc_load_text_ads_from_file_target_gcc.sh`: promotion gate for Target 295 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_am_jmptbl_diskio_load_config_from_disk_target_gcc.sh`: promotion gate for Target 296 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_am_jmptbl_textdisp_load_source_config_target_gcc.sh`: promotion gate for Target 297 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_am_jmptbl_kybd_initialize_input_devices_target_gcc.sh`: promotion gate for Target 298 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_am_jmptbl_esq_check_compatible_video_chip_target_gcc.sh`: promotion gate for Target 299 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_am_jmptbl_esq_check_available_fast_memory_target_gcc.sh`: promotion gate for Target 300 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_am_jmptbl_gcommand_reset_banner_fade_state_target_gcc.sh`: promotion gate for Target 301 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_am_jmptbl_tliba3_init_pattern_table_target_gcc.sh`: promotion gate for Target 302 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_am_jmptbl_esq_format_disk_error_message_target_gcc.sh`: promotion gate for Target 303 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_am_jmptbl_script_prime_banner_transition_from_hex_code_target_gcc.sh`: promotion gate for Target 304 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_am_jmptbl_locavail_reset_filter_state_struct_target_gcc.sh`: promotion gate for Target 305 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_am_jmptbl_esq_init_audio1_dma_target_gcc.sh`: promotion gate for Target 306 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_am_jmptbl_esq_set_copper_effect_on_enable_highlight_target_gcc.sh`: promotion gate for Target 307 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_am_jmptbl_locavail_load_availability_data_file_target_gcc.sh`: promotion gate for Target 308 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_am_jmptbl_gcommand_init_preset_defaults_target_gcc.sh`: promotion gate for Target 309 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_am_jmptbl_override_intuition_funcs_target_gcc.sh`: promotion gate for Target 310 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_am_jmptbl_buffer_flush_all_and_close_with_code_target_gcc.sh`: promotion gate for Target 311 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_am_jmptbl_flib2_reset_and_load_listing_templates_target_gcc.sh`: promotion gate for Target 312 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_am_jmptbl_wdisp_s_printf_target_gcc.sh`: promotion gate for Target 313 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_am_jmptbl_esq_set_copper_effect_off_disable_highlight_target_gcc.sh`: promotion gate for Target 314 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_am_jmptbl_cleanup_shutdown_system_target_gcc.sh`: promotion gate for Target 315 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_am_jmptbl_ladfunc_alloc_banner_rect_entries_target_gcc.sh`: promotion gate for Target 316 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqiff_jmptbl_string_compare_nocase_target_gcc.sh`: promotion gate for Target 108 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqiff_jmptbl_string_compare_n_target_gcc.sh`: promotion gate for Target 109 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqiff_jmptbl_string_compare_nocase_n_target_gcc.sh`: promotion gate for Target 110 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqiff_jmptbl_math_divs32_target_gcc.sh`: promotion gate for Target 111 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqiff_jmptbl_esq_noop_target_gcc.sh`: promotion gate for Target 112 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqiff_jmptbl_memory_deallocate_memory_target_gcc.sh`: promotion gate for Target 113 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqiff_jmptbl_esq_noop_006a_target_gcc.sh`: promotion gate for Target 114 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqiff_jmptbl_esq_noop_0074_target_gcc.sh`: promotion gate for Target 115 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqiff_jmptbl_memory_allocate_memory_target_gcc.sh`: promotion gate for Target 116 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqiff_jmptbl_dos_open_file_with_mode_target_gcc.sh`: promotion gate for Target 117 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqiff_jmptbl_math_mulu32_target_gcc.sh`: promotion gate for Target 118 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqiff_jmptbl_diskio_reset_ctrl_input_state_if_idle_target_gcc.sh`: promotion gate for Target 119 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqiff_jmptbl_diskio_get_filesize_from_handle_target_gcc.sh`: promotion gate for Target 120 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqiff_jmptbl_diskio_force_ui_refresh_if_idle_target_gcc.sh`: promotion gate for Target 121 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqiff_jmptbl_esq_inc_copper_lists_towards_targets_target_gcc.sh`: promotion gate for Target 122 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqiff_jmptbl_esq_dec_copper_lists_primary_target_gcc.sh`: promotion gate for Target 123 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqiff_jmptbl_ctasks_start_iff_task_process_target_gcc.sh`: promotion gate for Target 124 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqiff_jmptbl_script_assert_ctrl_line_if_enabled_target_gcc.sh`: promotion gate for Target 125 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqiff_jmptbl_esq_move_copper_entry_toward_start_target_gcc.sh`: promotion gate for Target 126 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqiff_jmptbl_esq_move_copper_entry_toward_end_target_gcc.sh`: promotion gate for Target 127 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqiff_jmptbl_brush_clone_brush_record_target_gcc.sh`: promotion gate for Target 128 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqiff_jmptbl_brush_find_type3_brush_target_gcc.sh`: promotion gate for Target 129 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqiff_jmptbl_brush_pop_brush_head_target_gcc.sh`: promotion gate for Target 130 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqiff_jmptbl_brush_alloc_brush_node_target_gcc.sh`: promotion gate for Target 131 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqiff_jmptbl_brush_find_brush_by_predicate_target_gcc.sh`: promotion gate for Target 132 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqiff_jmptbl_brush_free_brush_list_target_gcc.sh`: promotion gate for Target 133 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqiff_jmptbl_brush_select_brush_by_label_target_gcc.sh`: promotion gate for Target 134 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqiff_jmptbl_textdisp_find_entry_index_by_wildcard_target_gcc.sh`: promotion gate for Target 135 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqiff_jmptbl_textdisp_draw_channel_banner_target_gcc.sh`: promotion gate for Target 136 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqiff_jmptbl_newgrid_validate_selection_code_target_gcc.sh`: promotion gate for Target 137 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqiff_jmptbl_brush_populate_brush_list_target_gcc.sh`: promotion gate for Target 138 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqiff_jmptbl_script_begin_banner_char_transition_target_gcc.sh`: promotion gate for Target 139 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqiff_jmptbl_tliba3_build_display_context_for_view_mode_target_gcc.sh`: promotion gate for Target 140 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqiff_jmptbl_brush_select_brush_slot_target_gcc.sh`: promotion gate for Target 141 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_aw_jmptbl_tliba3_build_display_context_for_view_mode_target_gcc.sh`: promotion gate for Target 142 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_aw_jmptbl_displib_apply_inline_alignment_padding_target_gcc.sh`: promotion gate for Target 183 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_aw_jmptbl_esqiff_run_copper_rise_transition_target_gcc.sh`: promotion gate for Target 184 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_aw_jmptbl_esqiff_run_copper_drop_transition_target_gcc.sh`: promotion gate for Target 185 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_aw_jmptbl_displib_display_text_at_position_target_gcc.sh`: promotion gate for Target 186 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ad_jmptbl_tliba3_build_display_context_for_view_mode_target_gcc.sh`: promotion gate for Target 143 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_aw_jmptbl_mem_move_target_gcc.sh`: promotion gate for Target 144 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_aw_jmptbl_wdisp_sprintf_target_gcc.sh`: promotion gate for Target 187 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_aw_jmptbl_esq_set_copper_effect_off_disable_highlight_target_gcc.sh`: promotion gate for Target 188 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_aw_jmptbl_string_copy_pad_nul_target_gcc.sh`: promotion gate for Target 145 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_as_jmptbl_str_find_char_ptr_target_gcc.sh`: promotion gate for Target 189 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_as_jmptbl_esq_find_substring_case_fold_target_gcc.sh`: promotion gate for Target 190 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_at_jmptbl_ed1_wait_for_flag_and_clear_bit0_target_gcc.sh`: promotion gate for Target 191 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_at_jmptbl_dos_system_taglist_target_gcc.sh`: promotion gate for Target 192 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_at_jmptbl_ed1_wait_for_flag_and_clear_bit1_target_gcc.sh`: promotion gate for Target 193 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_au_jmptbl_brush_append_brush_node_target_gcc.sh`: promotion gate for Target 194 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_au_jmptbl_brush_populate_brush_list_target_gcc.sh`: promotion gate for Target 195 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ax_jmptbl_format_raw_dofmt_with_scratch_buffer_target_gcc.sh`: promotion gate for Target 196 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_az_jmptbl_esq_cold_reboot_target_gcc.sh`: promotion gate for Target 197 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_aa_jmptbl_gcommand_find_path_separator_target_gcc.sh`: promotion gate for Target 198 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_aa_jmptbl_graphics_alloc_raster_target_gcc.sh`: promotion gate for Target 199 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_af_jmptbl_gcommand_save_brush_result_target_gcc.sh`: promotion gate for Target 200 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ai_jmptbl_newgrid_set_selection_markers_target_gcc.sh`: promotion gate for Target 201 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ai_jmptbl_str_find_char_ptr_target_gcc.sh`: promotion gate for Target 202 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ai_jmptbl_tliba1_draw_text_with_inset_segments_target_gcc.sh`: promotion gate for Target 203 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ai_jmptbl_format_format_to_buffer2_target_gcc.sh`: promotion gate for Target 204 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ai_jmptbl_str_skip_class3_chars_target_gcc.sh`: promotion gate for Target 205 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ai_jmptbl_string_append_at_null_target_gcc.sh`: promotion gate for Target 206 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ai_jmptbl_str_copy_until_any_delim_n_target_gcc.sh`: promotion gate for Target 207 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ab_jmptbl_esqpars_remove_group_entry_and_release_strings_target_gcc.sh`: promotion gate for Target 208 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ab_jmptbl_esqfunc_free_line_text_buffers_target_gcc.sh`: promotion gate for Target 209 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ab_jmptbl_esqiff_deallocate_ads_and_logo_lst_data_target_gcc.sh`: promotion gate for Target 210 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ab_jmptbl_ladfunc_free_banner_rect_entries_target_gcc.sh`: promotion gate for Target 211 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ab_jmptbl_unknown2_a_stub0_target_gcc.sh`: promotion gate for Target 212 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ab_jmptbl_newgrid_shutdown_grid_resources_target_gcc.sh`: promotion gate for Target 213 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ab_jmptbl_locavail_free_resource_chain_target_gcc.sh`: promotion gate for Target 214 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ab_jmptbl_graphics_free_raster_target_gcc.sh`: promotion gate for Target 215 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ab_jmptbl_iostdreq_free_target_gcc.sh`: promotion gate for Target 216 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ab_jmptbl_esqiff2_clear_line_head_tail_by_mode_target_gcc.sh`: promotion gate for Target 217 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ac_jmptbl_parseini_update_clock_from_rtc_target_gcc.sh`: promotion gate for Target 218 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ac_jmptbl_esqfunc_draw_diagnostics_screen_target_gcc.sh`: promotion gate for Target 219 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ac_jmptbl_esqfunc_draw_memory_status_screen_target_gcc.sh`: promotion gate for Target 220 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ac_jmptbl_script_update_ctrl_state_machine_target_gcc.sh`: promotion gate for Target 221 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ac_jmptbl_gcommand_update_banner_bounds_target_gcc.sh`: promotion gate for Target 222 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ac_jmptbl_script_update_ctrl_line_timeout_target_gcc.sh`: promotion gate for Target 223 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ac_jmptbl_script_clear_ctrl_line_if_enabled_target_gcc.sh`: promotion gate for Target 224 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ac_jmptbl_esqfunc_free_extra_title_text_pointers_target_gcc.sh`: promotion gate for Target 225 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ac_jmptbl_esqdisp_draw_status_banner_target_gcc.sh`: promotion gate for Target 226 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ac_jmptbl_dst_update_banner_queue_target_gcc.sh`: promotion gate for Target 227 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ac_jmptbl_dst_refresh_banner_buffer_target_gcc.sh`: promotion gate for Target 228 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ac_jmptbl_esqfunc_draw_esc_menu_version_target_gcc.sh`: promotion gate for Target 229 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ac_jmptbl_parseini_adjust_hours_to24_hr_format_target_gcc.sh`: promotion gate for Target 230 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ae_jmptbl_tliba_find_first_wildcard_match_index_target_gcc.sh`: promotion gate for Target 231 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ae_jmptbl_script_build_token_index_map_target_gcc.sh`: promotion gate for Target 232 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ae_jmptbl_esqdisp_get_entry_aux_pointer_by_mode_target_gcc.sh`: promotion gate for Target 233 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ae_jmptbl_esqdisp_get_entry_pointer_by_mode_target_gcc.sh`: promotion gate for Target 234 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ae_jmptbl_ladfunc_parse_hex_digit_target_gcc.sh`: promotion gate for Target 235 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ae_jmptbl_script_deallocate_buffer_array_target_gcc.sh`: promotion gate for Target 236 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ae_jmptbl_wdisp_s_printf_target_gcc.sh`: promotion gate for Target 237 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ae_jmptbl_script_allocate_buffer_array_target_gcc.sh`: promotion gate for Target 238 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ae_jmptbl_textdisp_compute_time_offset_target_gcc.sh`: promotion gate for Target 239 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ae_jmptbl_esqpars_replace_owned_string_target_gcc.sh`: promotion gate for Target 240 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ah_jmptbl_esqiff2_apply_incoming_status_packet_target_gcc.sh`: promotion gate for Target 241 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ah_jmptbl_newgrid_rebuild_index_cache_target_gcc.sh`: promotion gate for Target 242 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ah_jmptbl_esqshared_apply_program_title_text_filters_target_gcc.sh`: promotion gate for Target 243 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ah_jmptbl_esqdisp_update_status_mask_and_refresh_target_gcc.sh`: promotion gate for Target 244 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ah_jmptbl_esqshared_init_entry_defaults_target_gcc.sh`: promotion gate for Target 245 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ah_jmptbl_gcommand_load_ppv_template_target_gcc.sh`: promotion gate for Target 246 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ah_jmptbl_locavail_save_availability_data_file_target_gcc.sh`: promotion gate for Target 247 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ah_jmptbl_gcommand_load_command_file_target_gcc.sh`: promotion gate for Target 248 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ah_jmptbl_esq_wildcard_match_target_gcc.sh`: promotion gate for Target 249 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ah_jmptbl_p_type_write_promo_id_data_file_target_gcc.sh`: promotion gate for Target 250 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ah_jmptbl_esqfunc_wait_for_clock_change_and_service_ui_target_gcc.sh`: promotion gate for Target 251 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ah_jmptbl_esq_test_bit1_based_target_gcc.sh`: promotion gate for Target 252 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ah_jmptbl_esqiff2_show_attention_overlay_target_gcc.sh`: promotion gate for Target 253 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ah_jmptbl_str_find_any_char_ptr_target_gcc.sh`: promotion gate for Target 254 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ah_jmptbl_gcommand_load_mplex_file_target_gcc.sh`: promotion gate for Target 255 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ah_jmptbl_script_read_serial_rbf_byte_target_gcc.sh`: promotion gate for Target 256 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ah_jmptbl_esqpars_clear_alias_string_pointers_target_gcc.sh`: promotion gate for Target 257 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ah_jmptbl_parse_read_signed_long_skip_class3_target_gcc.sh`: promotion gate for Target 258 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_aj_jmptbl_string_find_substring_target_gcc.sh`: promotion gate for Target 259 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_aj_jmptbl_format_raw_dofmt_with_scratch_buffer_target_gcc.sh`: promotion gate for Target 260 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_aj_jmptbl_math_div_u32_target_gcc.sh`: promotion gate for Target 261 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_aj_jmptbl_parseini_write_rtc_from_globals_target_gcc.sh`: promotion gate for Target 262 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_aj_jmptbl_math_mulu32_target_gcc.sh`: promotion gate for Target 263 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ak_jmptbl_script_update_serial_shadow_from_ctrl_byte_target_gcc.sh`: promotion gate for Target 264 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ak_jmptbl_tliba3_select_next_view_mode_target_gcc.sh`: promotion gate for Target 265 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ak_jmptbl_parseini_parse_ini_buffer_and_dispatch_target_gcc.sh`: promotion gate for Target 266 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ak_jmptbl_textdisp_format_entry_time_for_index_target_gcc.sh`: promotion gate for Target 267 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ak_jmptbl_gcommand_get_banner_char_target_gcc.sh`: promotion gate for Target 268 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ak_jmptbl_esqpars_apply_rtc_bytes_and_persist_target_gcc.sh`: promotion gate for Target 269 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ak_jmptbl_parseini_write_error_log_entry_target_gcc.sh`: promotion gate for Target 270 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ak_jmptbl_parseini_scan_logo_directory_target_gcc.sh`: promotion gate for Target 271 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ak_jmptbl_script_deassert_ctrl_line_now_target_gcc.sh`: promotion gate for Target 272 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ak_jmptbl_esq_set_copper_effect_default_target_gcc.sh`: promotion gate for Target 273 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ak_jmptbl_esq_set_copper_effect_custom_target_gcc.sh`: promotion gate for Target 274 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ak_jmptbl_cleanup_render_aligned_status_screen_target_gcc.sh`: promotion gate for Target 275 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ak_jmptbl_esq_set_copper_effect_all_on_target_gcc.sh`: promotion gate for Target 401 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ak_jmptbl_script_assert_ctrl_line_now_target_gcc.sh`: promotion gate for Target 402 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ak_jmptbl_tliba3_draw_view_mode_guides_target_gcc.sh`: promotion gate for Target 403 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ak_jmptbl_gcommand_copy_gfx_to_work_if_available_target_gcc.sh`: promotion gate for Target 404 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid2_jmptbl_bevel_draw_bevel_frame_with_top_right_target_gcc.sh`: promotion gate for Target 405 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid2_jmptbl_bevel_draw_vertical_bevel_target_gcc.sh`: promotion gate for Target 406 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid2_jmptbl_bevel_draw_bevel_frame_with_top_target_gcc.sh`: promotion gate for Target 407 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid2_jmptbl_bevel_draw_beveled_frame_target_gcc.sh`: promotion gate for Target 408 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid2_jmptbl_bevel_draw_vertical_bevel_pair_target_gcc.sh`: promotion gate for Target 409 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid2_jmptbl_bevel_draw_horizontal_bevel_target_gcc.sh`: promotion gate for Target 410 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid2_jmptbl_coi_select_anim_field_pointer_target_gcc.sh`: promotion gate for Target 411 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid2_jmptbl_disptext_set_current_line_index_target_gcc.sh`: promotion gate for Target 412 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid2_jmptbl_disptext_layout_and_append_to_buffer_target_gcc.sh`: promotion gate for Target 413 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid2_jmptbl_disptext_get_total_line_count_target_gcc.sh`: promotion gate for Target 414 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid2_jmptbl_tliba_find_first_wildcard_match_index_target_gcc.sh`: promotion gate for Target 415 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid2_jmptbl_disptext_build_layout_for_source_target_gcc.sh`: promotion gate for Target 416 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid2_jmptbl_esqdisp_get_entry_aux_pointer_by_mode_target_gcc.sh`: promotion gate for Target 417 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid2_jmptbl_disptext_layout_source_to_lines_target_gcc.sh`: promotion gate for Target 418 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid2_jmptbl_cleanup_update_entry_flag_bytes_target_gcc.sh`: promotion gate for Target 419 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid2_jmptbl_coi_render_clock_format_entry_variant_target_gcc.sh`: promotion gate for Target 420 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid2_jmptbl_esqdisp_test_entry_bits0_and2_target_gcc.sh`: promotion gate for Target 421 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid2_jmptbl_disptext_compute_visible_line_count_target_gcc.sh`: promotion gate for Target 422 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid2_jmptbl_esqdisp_get_entry_pointer_by_mode_target_gcc.sh`: promotion gate for Target 423 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid2_jmptbl_disptext_render_current_line_target_gcc.sh`: promotion gate for Target 424 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid2_jmptbl_coi_process_entry_selection_state_target_gcc.sh`: promotion gate for Target 425 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid2_jmptbl_cleanup_format_clock_format_entry_target_gcc.sh`: promotion gate for Target 426 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid2_jmptbl_esq_get_half_hour_slot_index_target_gcc.sh`: promotion gate for Target 427 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid2_jmptbl_str_skip_class3_chars_target_gcc.sh`: promotion gate for Target 428 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid2_jmptbl_string_append_n_target_gcc.sh`: promotion gate for Target 429 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid2_jmptbl_esqdisp_compute_schedule_offset_for_row_target_gcc.sh`: promotion gate for Target 430 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid2_jmptbl_parse_read_signed_long_skip_class3_alt_target_gcc.sh`: promotion gate for Target 431 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid2_jmptbl_cleanup_test_entry_flag_y_and_bit1_target_gcc.sh`: promotion gate for Target 432 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid2_jmptbl_disptext_is_current_line_last_target_gcc.sh`: promotion gate for Target 433 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid2_jmptbl_disptext_is_last_line_selected_target_gcc.sh`: promotion gate for Target 434 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid2_jmptbl_displib_find_previous_valid_entry_index_target_gcc.sh`: promotion gate for Target 435 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid2_jmptbl_disptext_compute_marker_widths_target_gcc.sh`: promotion gate for Target 436 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid2_jmptbl_esq_test_bit1_based_target_gcc.sh`: promotion gate for Target 437 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid2_jmptbl_disptext_measure_current_line_length_target_gcc.sh`: promotion gate for Target 438 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid2_jmptbl_disptext_set_layout_params_target_gcc.sh`: promotion gate for Target 439 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid2_jmptbl_disptext_has_multiple_lines_target_gcc.sh`: promotion gate for Target 440 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid2_jmptbl_bevel_draw_horizontal_bevel_target_gcc.sh`: promotion gate for Target 441 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_av_jmptbl_allocate_alloc_and_initialize_iostdreq_target_gcc.sh`: promotion gate for Target 276 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_av_jmptbl_signal_create_msgport_with_signal_target_gcc.sh`: promotion gate for Target 277 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_av_jmptbl_diskio_probe_drives_and_assign_paths_target_gcc.sh`: promotion gate for Target 278 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_av_jmptbl_esq_invoke_gcommand_init_target_gcc.sh`: promotion gate for Target 279 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_av_jmptbl_exec_call_vector_48_target_gcc.sh`: promotion gate for Target 280 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ad_jmptbl_textdisp_draw_channel_banner_target_gcc.sh`: promotion gate for Target 146 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ad_jmptbl_textdisp_format_entry_time_target_gcc.sh`: promotion gate for Target 147 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ad_jmptbl_tliba3_get_view_mode_height_target_gcc.sh`: promotion gate for Target 148 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ad_jmptbl_tliba3_get_view_mode_rast_port_target_gcc.sh`: promotion gate for Target 149 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_tliba3_jmptbl_gcommand_applyhighlightflag_target_gcc.sh`: promotion gate for Target 442 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_tliba2_jmptbl_dst_addtimeoffset_target_gcc.sh`: promotion gate for Target 443 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_tliba2_jmptbl_esq_testbit1based_target_gcc.sh`: promotion gate for Target 444 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_tliba1_jmptbl_coi_getanimfieldpointerbymode_target_gcc.sh`: promotion gate for Target 445 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_tliba1_jmptbl_esqdisp_getentryauxpointerbymode_target_gcc.sh`: promotion gate for Target 446 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_tliba1_jmptbl_ladfunc_extractlownibble_target_gcc.sh`: promotion gate for Target 447 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_tliba1_jmptbl_esqdisp_getentrypointerbymode_target_gcc.sh`: promotion gate for Target 448 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_tliba1_jmptbl_coi_testentrywithintimewindow_target_gcc.sh`: promotion gate for Target 449 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_tliba1_jmptbl_cleanup_formatclockformatentry_target_gcc.sh`: promotion gate for Target 450 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_tliba1_jmptbl_esqdisp_computescheduleoffsetforrow_target_gcc.sh`: promotion gate for Target 451 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_tliba1_jmptbl_esq_findsubstringcasefold_target_gcc.sh`: promotion gate for Target 452 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_tliba1_jmptbl_displib_findpreviousvalidentryindex_target_gcc.sh`: promotion gate for Target 453 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_tliba1_jmptbl_ladfunc_extracthighnibble_target_gcc.sh`: promotion gate for Target 454 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini2_jmptbl_battclock_getsecondsfrombatterybackedclock_target_gcc.sh`: promotion gate for Target 455 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini2_jmptbl_battclock_writesecondstobatterybackedclock_target_gcc.sh`: promotion gate for Target 456 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini2_jmptbl_datetime_isleapyear_target_gcc.sh`: promotion gate for Target 457 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini2_jmptbl_clock_secondsfromepoch_target_gcc.sh`: promotion gate for Target 458 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini2_jmptbl_clock_checkdateorsecondsfromepoch_target_gcc.sh`: promotion gate for Target 459 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini2_jmptbl_clock_convertamigasecondstoclockdata_target_gcc.sh`: promotion gate for Target 460 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini2_jmptbl_esq_calcdayofyearfrommonthday_target_gcc.sh`: promotion gate for Target 461 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script2_jmptbl_esq_capturectrlbit4streambufferbyte_target_gcc.sh`: promotion gate for Target 462 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script2_jmptbl_esq_readserialrbfbyte_target_gcc.sh`: promotion gate for Target 463 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_p_type_jmptbl_string_findsubstring_target_gcc.sh`: promotion gate for Target 464 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_textdisp2_jmptbl_locavail_getfilterwindowhalfspan_target_gcc.sh`: promotion gate for Target 465 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_textdisp2_jmptbl_ladfunc_drawentrypreview_target_gcc.sh`: promotion gate for Target 466 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_textdisp2_jmptbl_esqiff_runpendingcopperanimations_target_gcc.sh`: promotion gate for Target 467 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_textdisp2_jmptbl_esqiff_playnextexternalassetframe_target_gcc.sh`: promotion gate for Target 468 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_jmptbl_memory_deallocatememory_target_gcc.sh`: promotion gate for Target 469 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_jmptbl_diskio_writebufferedbytes_target_gcc.sh`: promotion gate for Target 470 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_jmptbl_diskio_closebufferedfileandflush_target_gcc.sh`: promotion gate for Target 471 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_jmptbl_memory_allocatememory_target_gcc.sh`: promotion gate for Target 472 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_jmptbl_diskio_openfilewithbuffer_target_gcc.sh`: promotion gate for Target 473 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_wdisp_jmptbl_esqiff_restorebasepalettetriples_target_gcc.sh`: promotion gate for Target 474 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_wdisp_jmptbl_esqfunc_trimtexttopixelwidthwordboundary_target_gcc.sh`: promotion gate for Target 475 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_wdisp_jmptbl_gcommand_expandpresetblock_target_gcc.sh`: promotion gate for Target 476 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_wdisp_jmptbl_esqiff_queueiffbrushload_target_gcc.sh`: promotion gate for Target 477 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_wdisp_jmptbl_esqiff_runcopperdroptransition_target_gcc.sh`: promotion gate for Target 478 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_wdisp_jmptbl_brush_findbrushbypredicate_target_gcc.sh`: promotion gate for Target 479 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_wdisp_jmptbl_brush_freebrushlist_target_gcc.sh`: promotion gate for Target 480 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_wdisp_jmptbl_brush_planemaskforindex_target_gcc.sh`: promotion gate for Target 481 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_wdisp_jmptbl_esq_setcoppereffect_onenablehighlight_target_gcc.sh`: promotion gate for Target 482 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_wdisp_jmptbl_esqiff_renderweatherstatusbrushslice_target_gcc.sh`: promotion gate for Target 483 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_wdisp_jmptbl_brush_selectbrushslot_target_gcc.sh`: promotion gate for Target 484 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_wdisp_jmptbl_newgrid_drawwrappedtext_target_gcc.sh`: promotion gate for Target 485 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_wdisp_jmptbl_newgrid_resetrowtable_target_gcc.sh`: promotion gate for Target 486 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid_jmptbl_math_divs32_target_gcc.sh`: promotion gate for Target 487 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid_jmptbl_datetime_secondstostruct_target_gcc.sh`: promotion gate for Target 488 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid_jmptbl_generate_grid_date_string_target_gcc.sh`: promotion gate for Target 489 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid_jmptbl_memory_deallocatememory_target_gcc.sh`: promotion gate for Target 490 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid_jmptbl_cleanup_drawclockformatlist_target_gcc.sh`: promotion gate for Target 491 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid_jmptbl_disptext_freebuffers_target_gcc.sh`: promotion gate for Target 492 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid_jmptbl_cleanup_drawclockbanner_target_gcc.sh`: promotion gate for Target 493 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid_jmptbl_memory_allocatememory_target_gcc.sh`: promotion gate for Target 494 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid_jmptbl_disptext_initbuffers_target_gcc.sh`: promotion gate for Target 495 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid_jmptbl_cleanup_drawclockformatframe_target_gcc.sh`: promotion gate for Target 496 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid_jmptbl_datetime_normalizestructtoseconds_target_gcc.sh`: promotion gate for Target 497 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid_jmptbl_str_copyuntilanydelimn_target_gcc.sh`: promotion gate for Target 498 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid_jmptbl_wdisp_updateselectionpreviewpanel_target_gcc.sh`: promotion gate for Target 499 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid_jmptbl_math_mulu32_target_gcc.sh`: promotion gate for Target 500 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_jmptbl_brush_allocbrushnode_target_gcc.sh`: promotion gate for Target 501 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_jmptbl_brush_freebrushlist_target_gcc.sh`: promotion gate for Target 502 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_jmptbl_brush_freebrushresources_target_gcc.sh`: promotion gate for Target 503 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_jmptbl_esqfunc_rebuildpwbrushlistfromtagtablefromtagtable_target_gcc.sh`: promotion gate for Target 504 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_jmptbl_gcommand_findpathseparator_target_gcc.sh`: promotion gate for Target 505 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_jmptbl_diskio_consumelinefromworkbuffer_target_gcc.sh`: promotion gate for Target 506 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_jmptbl_diskio2_parseinifilefromdisk_target_gcc.sh`: promotion gate for Target 507 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_jmptbl_diskio_loadfiletoworkbuffer_target_gcc.sh`: promotion gate for Target 508 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_jmptbl_ed1_drawdiagnosticsscreen_target_gcc.sh`: promotion gate for Target 509 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_jmptbl_ed1_enterescmenu_target_gcc.sh`: promotion gate for Target 510 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_jmptbl_ed1_exitescmenu_target_gcc.sh`: promotion gate for Target 511 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_jmptbl_ed1_waitforflagandclearbit0_target_gcc.sh`: promotion gate for Target 512 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_jmptbl_ed1_waitforflagandclearbit1_target_gcc.sh`: promotion gate for Target 513 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_jmptbl_esqfunc_drawescmenuversion_target_gcc.sh`: promotion gate for Target 514 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_jmptbl_esqiff_queueiffbrushload_target_gcc.sh`: promotion gate for Target 515 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_jmptbl_esqiff_handlebrushinireloadhotkey_target_gcc.sh`: promotion gate for Target 516 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_jmptbl_esqpars_replaceownedstring_target_gcc.sh`: promotion gate for Target 517 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_jmptbl_gcommand_initpresettablefrompalette_target_gcc.sh`: promotion gate for Target 518 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_jmptbl_gcommand_validatepresettable_target_gcc.sh`: promotion gate for Target 519 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_jmptbl_handle_openwithmode_target_gcc.sh`: promotion gate for Target 520 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_jmptbl_stream_readlinewithlimit_target_gcc.sh`: promotion gate for Target 521 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_jmptbl_string_appendatnull_target_gcc.sh`: promotion gate for Target 522 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_jmptbl_string_comparenocase_target_gcc.sh`: promotion gate for Target 523 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_jmptbl_string_comparenocasen_target_gcc.sh`: promotion gate for Target 524 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_jmptbl_str_findanycharptr_target_gcc.sh`: promotion gate for Target 525 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_jmptbl_str_findcharptr_target_gcc.sh`: promotion gate for Target 526 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_jmptbl_unknown36_finalizerequest_target_gcc.sh`: promotion gate for Target 527 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_jmptbl_wdisp_sprintf_target_gcc.sh`: promotion gate for Target 528 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script3_jmptbl_cleanup_renderalignedstatusscreen_target_gcc.sh`: promotion gate for Target 529 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script3_jmptbl_locavail_computefilteroffsetforentry_target_gcc.sh`: promotion gate for Target 530 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script3_jmptbl_math_mulu32_target_gcc.sh`: promotion gate for Target 531 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script3_jmptbl_math_divs32_target_gcc.sh`: promotion gate for Target 532 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script3_jmptbl_locavail_setfiltermodeandresetstate_target_gcc.sh`: promotion gate for Target 533 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script3_jmptbl_string_copypadnul_target_gcc.sh`: promotion gate for Target 534 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script3_jmptbl_string_comparen_target_gcc.sh`: promotion gate for Target 535 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script3_jmptbl_esqdisp_updatestatusmaskandrefresh_target_gcc.sh`: promotion gate for Target 536 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script3_jmptbl_gcommand_getbannerchar_target_gcc.sh`: promotion gate for Target 537 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script3_jmptbl_ladfunc_parsehexdigit_target_gcc.sh`: promotion gate for Target 538 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script3_jmptbl_esqpars_applyrtcbytesandpersist_target_gcc.sh`: promotion gate for Target 539 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script3_jmptbl_parse_readsignedlongskipclass3_alt_target_gcc.sh`: promotion gate for Target 540 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script3_jmptbl_gcommand_adjustbannercopperoffset_target_gcc.sh`: promotion gate for Target 541 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script3_jmptbl_esq_setcoppereffect_custom_target_gcc.sh`: promotion gate for Target 542 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script3_jmptbl_esqshared_applyprogramtitletextfilters_target_gcc.sh`: promotion gate for Target 543 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script3_jmptbl_locavail_updatefilterstatemachine_target_gcc.sh`: promotion gate for Target 544 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_compute_htc_max_values_target_gcc.sh`: promotion gate for Target 545 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_update_ctrl_h_delta_max_target_gcc.sh`: promotion gate for Target 546 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_check_ctrl_h_change_target_gcc.sh`: promotion gate for Target 547 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_monitor_clock_change_target_gcc.sh`: promotion gate for Target 548 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_write_error_log_entry_target_gcc.sh`: promotion gate for Target 549 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_test_memory_and_open_topaz_font_target_gcc.sh`: promotion gate for Target 550 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_parse_hex_value_from_string_target_gcc.sh`: promotion gate for Target 551 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_parse_range_key_value_target_gcc.sh`: promotion gate for Target 552 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_load_weather_message_strings_target_gcc.sh`: promotion gate for Target 553 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_load_weather_strings_target_gcc.sh`: promotion gate for Target 554 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_parse_color_table_target_gcc.sh`: promotion gate for Target 555 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_handle_font_command_target_gcc.sh`: promotion gate for Target 556 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_process_weather_blocks_target_gcc.sh`: promotion gate for Target 557 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_scan_logo_directory_target_gcc.sh`: promotion gate for Target 558 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_parse_ini_buffer_and_dispatch_target_gcc.sh`: promotion gate for Target 559 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_adjust_hours_to24_hr_format_target_gcc.sh`: promotion gate for Target 560 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_normalize_clock_data_target_gcc.sh`: promotion gate for Target 561 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_write_rtc_from_globals_target_gcc.sh`: promotion gate for Target 562 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_parseini_update_clock_from_rtc_target_gcc.sh`: promotion gate for Target 563 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_reset_banner_char_defaults_target_gcc.sh`: promotion gate for Target 564 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_get_banner_char_or_fallback_target_gcc.sh`: promotion gate for Target 565 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_draw_inset_text_with_frame_target_gcc.sh`: promotion gate for Target 566 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_setup_highlight_effect_target_gcc.sh`: promotion gate for Target 567 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_bevel_draw_bevel_frame_with_top_target_gcc.sh`: promotion gate for Target 684 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_bevel_draw_beveled_frame_target_gcc.sh`: promotion gate for Target 685 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_bevel_draw_bevel_frame_with_top_right_target_gcc.sh`: promotion gate for Target 686 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_bevel_draw_vertical_bevel_target_gcc.sh`: promotion gate for Target 687 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_bevel_draw_vertical_bevel_pair_target_gcc.sh`: promotion gate for Target 688 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_bevel_draw_horizontal_bevel_target_gcc.sh`: promotion gate for Target 689 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_check_path_exists_target_gcc.sh`: promotion gate for Target 568 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_update_banner_char_transition_target_gcc.sh`: promotion gate for Target 569 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_prime_banner_transition_from_hex_code_target_gcc.sh`: promotion gate for Target 570 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_init_ctrl_context_target_gcc.sh`: promotion gate for Target 571 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_set_ctrl_context_mode_target_gcc.sh`: promotion gate for Target 572 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_reset_ctrl_context_and_clear_status_line_target_gcc.sh`: promotion gate for Target 573 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_load_ctrl_context_snapshot_target_gcc.sh`: promotion gate for Target 574 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_save_ctrl_context_snapshot_target_gcc.sh`: promotion gate for Target 575 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_reset_ctrl_context_target_gcc.sh`: promotion gate for Target 576 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_clear_search_texts_and_channels_target_gcc.sh`: promotion gate for Target 577 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_update_runtime_mode_for_playback_cursor_target_gcc.sh`: promotion gate for Target 578 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_select_playback_cursor_from_search_text_target_gcc.sh`: promotion gate for Target 579 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_generate_grid_date_string_target_gcc.sh`: promotion gate for Target 580 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_apply_pending_banner_target_target_gcc.sh`: promotion gate for Target 581 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_split_and_normalize_search_buffer_target_gcc.sh`: promotion gate for Target 582 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_dispatch_playback_cursor_command_target_gcc.sh`: promotion gate for Target 583 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_process_ctrl_context_playback_tick_target_gcc.sh`: promotion gate for Target 584 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_handle_brush_command_target_gcc.sh`: promotion gate for Target 585 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_return_with_stack_code_target_gcc.sh`: promotion gate for Target 586 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_shutdown_and_return_target_gcc.sh`: promotion gate for Target 587 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_check_available_fast_memory_target_gcc.sh`: promotion gate for Target 624 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_check_compatible_video_chip_target_gcc.sh`: promotion gate for Target 625 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_format_disk_error_message_target_gcc.sh`: promotion gate for Target 626 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_tliba2_find_last_char_in_string_target_gcc.sh`: promotion gate for Target 627 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_tliba2_resolve_entry_window_with_default_range_target_gcc.sh`: promotion gate for Target 628 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_tliba_find_first_wildcard_match_index_target_gcc.sh`: promotion gate for Target 629 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_tliba2_parse_entry_time_window_target_gcc.sh`: promotion gate for Target 630 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_tliba2_compute_broadcast_time_window_target_gcc.sh`: promotion gate for Target 631 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_tliba2_resolve_entry_window_and_slot_count_target_gcc.sh`: promotion gate for Target 632 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_tliba1_parse_style_code_char_target_gcc.sh`: promotion gate for Target 633 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_tliba1_format_clock_format_entry_target_gcc.sh`: promotion gate for Target 634 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_tliba1_draw_inline_styled_text_target_gcc.sh`: promotion gate for Target 635 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_tliba1_draw_formatted_text_block_target_gcc.sh`: promotion gate for Target 636 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid_draw_grid_top_bars_target_gcc.sh`: promotion gate for Target 637 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid_draw_top_border_line_target_gcc.sh`: promotion gate for Target 638 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid_shutdown_grid_resources_target_gcc.sh`: promotion gate for Target 639 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid_clear_highlight_area_target_gcc.sh`: promotion gate for Target 640 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid_is_grid_ready_for_input_target_gcc.sh`: promotion gate for Target 641 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid_fill_grid_rects_target_gcc.sh`: promotion gate for Target 642 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid_draw_grid_frame_target_gcc.sh`: promotion gate for Target 643 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid_should_open_editor_target_gcc.sh`: promotion gate for Target 644 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid_compute_day_slot_from_clock_target_gcc.sh`: promotion gate for Target 645 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid_compute_day_slot_from_clock_with_offset_target_gcc.sh`: promotion gate for Target 646 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid_adjust_clock_string_by_slot_target_gcc.sh`: promotion gate for Target 647 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid_adjust_clock_string_by_slot_with_offset_target_gcc.sh`: promotion gate for Target 648 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid_draw_awaiting_listings_message_target_gcc.sh`: promotion gate for Target 649 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid_draw_date_banner_target_gcc.sh`: promotion gate for Target 650 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid_draw_clock_format_header_target_gcc.sh`: promotion gate for Target 651 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid_map_selection_to_mode_target_gcc.sh`: promotion gate for Target 652 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid_init_grid_resources_target_gcc.sh`: promotion gate for Target 653 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid_select_next_mode_target_gcc.sh`: promotion gate for Target 654 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_newgrid_draw_wrapped_text_target_gcc.sh`: promotion gate for Target 655 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_p_type_allocate_entry_target_gcc.sh`: promotion gate for Target 656 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_p_type_free_entry_target_gcc.sh`: promotion gate for Target 657 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_p_type_reset_lists_and_load_promo_ids_target_gcc.sh`: promotion gate for Target 658 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_p_type_get_subtype_if_type20_target_gcc.sh`: promotion gate for Target 659 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_p_type_promote_secondary_list_target_gcc.sh`: promotion gate for Target 660 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_p_type_ensure_secondary_list_target_gcc.sh`: promotion gate for Target 661 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_p_type_consume_primary_type_if_present_target_gcc.sh`: promotion gate for Target 662 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_p_type_clone_entry_target_gcc.sh`: promotion gate for Target 663 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_p_type_parse_and_store_type_record_target_gcc.sh`: promotion gate for Target 664 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_p_type_write_promo_id_data_file_target_gcc.sh`: promotion gate for Target 665 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_p_type_load_promo_id_data_file_target_gcc.sh`: promotion gate for Target 666 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_allocate_buffer_array_target_gcc.sh`: promotion gate for Target 667 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_deallocate_buffer_array_target_gcc.sh`: promotion gate for Target 668 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_build_token_index_map_target_gcc.sh`: promotion gate for Target 669 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_get_ctrl_line_flag_target_gcc.sh`: promotion gate for Target 670 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_write_ctrl_shadow_to_serdat_target_gcc.sh`: promotion gate for Target 671 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_assert_ctrl_line_target_gcc.sh`: promotion gate for Target 672 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_deassert_ctrl_line_target_gcc.sh`: promotion gate for Target 673 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_assert_ctrl_line_if_enabled_target_gcc.sh`: promotion gate for Target 674 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_clear_ctrl_line_if_enabled_target_gcc.sh`: promotion gate for Target 675 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_assert_ctrl_line_now_target_gcc.sh`: promotion gate for Target 676 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_deassert_ctrl_line_now_target_gcc.sh`: promotion gate for Target 677 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_read_handshake_bit3_flag_target_gcc.sh`: promotion gate for Target 678 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_read_handshake_bit5_mask_target_gcc.sh`: promotion gate for Target 679 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_poll_handshake_and_apply_timeout_target_gcc.sh`: promotion gate for Target 680 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_read_next_rbf_byte_target_gcc.sh`: promotion gate for Target 681 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_esq_capture_ctrl_bit4_stream_buffer_byte_target_gcc.sh`: promotion gate for Target 682 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_script_update_serial_shadow_from_ctrl_byte_target_gcc.sh`: promotion gate for Target 683 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_alloc_alloc_from_free_list_target_gcc.sh`: promotion gate for Target 588 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_alloc_insert_free_block_target_gcc.sh`: promotion gate for Target 589 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ad_jmptbl_datetime_normalize_month_range_target_gcc.sh`: promotion gate for Target 150 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ad_jmptbl_datetime_adjust_month_index_target_gcc.sh`: promotion gate for Target 151 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ad_jmptbl_script_update_serial_shadow_from_ctrl_byte_target_gcc.sh`: promotion gate for Target 152 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ad_jmptbl_esqiff_run_copper_rise_transition_target_gcc.sh`: promotion gate for Target 153 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ad_jmptbl_textdisp_build_entry_short_name_target_gcc.sh`: promotion gate for Target 154 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ad_jmptbl_graphics_blt_bit_map_rast_port_target_gcc.sh`: promotion gate for Target 155 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ad_jmptbl_esqiff_run_copper_drop_transition_target_gcc.sh`: promotion gate for Target 156 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ad_jmptbl_tliba1_build_clock_format_entry_if_visible_target_gcc.sh`: promotion gate for Target 157 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ad_jmptbl_textdisp_build_channel_label_target_gcc.sh`: promotion gate for Target 158 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ad_jmptbl_textdisp_draw_inset_rect_frame_target_gcc.sh`: promotion gate for Target 159 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ad_jmptbl_textdisp_trim_text_to_pixel_width_target_gcc.sh`: promotion gate for Target 160 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ad_jmptbl_esqfunc_select_and_apply_brush_for_current_entry_target_gcc.sh`: promotion gate for Target 161 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ad_jmptbl_dst_compute_banner_index_target_gcc.sh`: promotion gate for Target 162 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_main_a_jmptbl_esq_main_exit_noop_hook_target_gcc.sh`: promotion gate for Target 163 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_main_a_jmptbl_esq_main_entry_noop_hook_target_gcc.sh`: promotion gate for Target 164 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_main_a_jmptbl_memlist_free_all_target_gcc.sh`: promotion gate for Target 165 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_main_a_jmptbl_esq_parse_command_line_and_run_target_gcc.sh`: promotion gate for Target 166 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_al_jmptbl_ladfunc_pack_nibbles_to_byte_target_gcc.sh`: promotion gate for Target 167 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_al_jmptbl_ladfunc_extract_low_nibble_target_gcc.sh`: promotion gate for Target 168 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_al_jmptbl_ladfunc_update_entry_buffers_for_ad_index_target_gcc.sh`: promotion gate for Target 169 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_al_jmptbl_esq_write_dec_fixed_width_target_gcc.sh`: promotion gate for Target 170 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_al_jmptbl_ladfunc_build_entry_buffers_or_default_target_gcc.sh`: promotion gate for Target 171 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_al_jmptbl_ladfunc_extract_high_nibble_target_gcc.sh`: promotion gate for Target 172 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ay_jmptbl_diskio_consume_cstring_from_work_buffer_target_gcc.sh`: promotion gate for Target 173 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ay_jmptbl_diskio_parse_long_from_work_buffer_target_gcc.sh`: promotion gate for Target 174 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ay_jmptbl_diskio_write_decimal_field_target_gcc.sh`: promotion gate for Target 175 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ay_jmptbl_diskio_write_buffered_bytes_target_gcc.sh`: promotion gate for Target 176 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ay_jmptbl_diskio_close_buffered_file_and_flush_target_gcc.sh`: promotion gate for Target 177 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ay_jmptbl_string_compare_nocase_n_target_gcc.sh`: promotion gate for Target 178 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ay_jmptbl_math_mulu32_target_gcc.sh`: promotion gate for Target 179 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ay_jmptbl_diskio_load_file_to_work_buffer_target_gcc.sh`: promotion gate for Target 180 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ay_jmptbl_script_read_ciab_bit5_mask_target_gcc.sh`: promotion gate for Target 181 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ay_jmptbl_diskio_open_file_with_buffer_target_gcc.sh`: promotion gate for Target 182 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_aa_jmptbl_string_compare_nocase_target_gcc.sh`: promotion gate for Target 095 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_aa_jmptbl_string_compare_n_target_gcc.sh`: promotion gate for Target 094 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ar_jmptbl_parseini_write_error_log_entry_target_gcc.sh`: promotion gate for Target 092 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ar_jmptbl_string_append_at_null_target_gcc.sh`: promotion gate for Target 093 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_main_b_jmptbl_dos_delay_target_gcc.sh`: promotion gate for Target 090 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_main_b_jmptbl_stream_buffered_write_string_target_gcc.sh`: promotion gate for Target 088 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_main_b_jmptbl_math_mulu32_target_gcc.sh`: promotion gate for Target 089 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_main_b_jmptbl_buffer_flush_all_and_close_with_code_target_gcc.sh`: promotion gate for Target 091 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_unknown32_jmptbl_esq_return_with_stack_code_target_gcc.sh`: promotion gate for Target 074 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_handle_close_all_and_return_with_code_target_gcc.sh`: promotion gate for Target 075 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_dos_close_with_signal_check_target_gcc.sh`: promotion gate for Target 037 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_iostdreq_free_target_gcc.sh`: promotion gate for Target 038 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_iostdreq_cleanup_signal_and_msgport_target_gcc.sh`: promotion gate for Target 039 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_cleanup_clear_vertb_interrupt_server_target_gcc.sh`: promotion gate for Target 757 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_cleanup_clear_aud1_interrupt_vector_target_gcc.sh`: promotion gate for Target 758 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_cleanup_clear_rbf_interrupt_and_serial_target_gcc.sh`: promotion gate for Target 759 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_cleanup_shutdown_input_devices_target_gcc.sh`: promotion gate for Target 760 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_cleanup_shutdown_system_target_gcc.sh`: promotion gate for Target 761 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_cleanup_release_display_resources_target_gcc.sh`: promotion gate for Target 762 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_cleanup_draw_banner_spacer_segment_target_gcc.sh`: promotion gate for Target 763 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_cleanup_draw_time_banner_segment_target_gcc.sh`: promotion gate for Target 764 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_cleanup_draw_date_banner_segment_target_gcc.sh`: promotion gate for Target 765 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_cleanup_draw_datetime_banner_row_target_gcc.sh`: promotion gate for Target 766 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_render_short_month_short_day_of_week_day_target_gcc.sh`: promotion gate for Target 767 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_cleanup_draw_grid_time_banner_target_gcc.sh`: promotion gate for Target 768 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_cleanup_format_clock_format_entry_target_gcc.sh`: promotion gate for Target 769 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_cleanup_draw_clock_format_frame_target_gcc.sh`: promotion gate for Target 770 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_cleanup_draw_clock_banner_target_gcc.sh`: promotion gate for Target 771 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_cleanup_draw_clock_format_list_target_gcc.sh`: promotion gate for Target 772 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_cleanup_process_alerts_target_gcc.sh`: promotion gate for Target 773 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_cleanup_test_entry_flag_y_and_bit1_target_gcc.sh`: promotion gate for Target 774 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_cleanup_update_entry_flag_bytes_target_gcc.sh`: promotion gate for Target 775 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_cleanup_draw_inset_rect_frame_target_gcc.sh`: promotion gate for Target 776 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_cleanup_format_entry_string_tokens_target_gcc.sh`: promotion gate for Target 777 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_cleanup_build_aligned_status_line_target_gcc.sh`: promotion gate for Target 778 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_cleanup_parse_aligned_listing_block_target_gcc.sh`: promotion gate for Target 779 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_cleanup_build_and_render_aligned_status_banner_target_gcc.sh`: promotion gate for Target 780 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_textdisp_find_control_token_target_gcc.sh`: promotion gate for Target 781 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_textdisp_find_alias_index_by_name_target_gcc.sh`: promotion gate for Target 782 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_textdisp_find_quoted_span_target_gcc.sh`: promotion gate for Target 783 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_textdisp_format_entry_time_for_index_target_gcc.sh`: promotion gate for Target 784 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_textdisp_compute_time_offset_target_gcc.sh`: promotion gate for Target 785 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_textdisp_draw_inset_rect_frame_target_gcc.sh`: promotion gate for Target 786 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_textdisp_build_entry_short_name_target_gcc.sh`: promotion gate for Target 787 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_textdisp_build_channel_label_target_gcc.sh`: promotion gate for Target 788 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_textdisp_draw_channel_banner_target_gcc.sh`: promotion gate for Target 789 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_textdisp_format_entry_time_target_gcc.sh`: promotion gate for Target 790 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_textdisp_update_channel_range_flags_target_gcc.sh`: promotion gate for Target 791 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_textdisp_select_group_and_entry_target_gcc.sh`: promotion gate for Target 792 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_textdisp_build_match_index_list_target_gcc.sh`: promotion gate for Target 793 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_textdisp_find_entry_match_index_target_gcc.sh`: promotion gate for Target 794 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_textdisp_select_best_match_from_list_target_gcc.sh`: promotion gate for Target 795 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_coi_free_entry_resources_return_target_gcc.sh`: promotion gate for Target 796 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_coi_clear_anim_object_strings_return_target_gcc.sh`: promotion gate for Target 797 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_coi_free_sub_entry_table_entries_return_target_gcc.sh`: promotion gate for Target 798 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_coi_get_anim_field_pointer_by_mode_return_target_gcc.sh`: promotion gate for Target 799 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_coi_test_entry_within_time_window_return_target_gcc.sh`: promotion gate for Target 800 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_coi_append_anim_field_with_trailing_space_return_target_gcc.sh`: promotion gate for Target 801 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_coi_compute_entry_time_delta_minutes_return_target_gcc.sh`: promotion gate for Target 802 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_coi_format_entry_display_text_return_target_gcc.sh`: promotion gate for Target 803 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_coi_count_escape14_before_null_target_gcc.sh`: promotion gate for Target 804 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_coi_ensure_anim_object_allocated_target_gcc.sh`: promotion gate for Target 805 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_coi_select_anim_field_pointer_target_gcc.sh`: promotion gate for Target 806 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_coi_render_clock_format_entry_variant_target_gcc.sh`: promotion gate for Target 807 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_coi_process_entry_selection_state_target_gcc.sh`: promotion gate for Target 808 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_coi_compute_entry_time_delta_minutes_target_gcc.sh`: promotion gate for Target 809 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_coi_free_entry_resources_target_gcc.sh`: promotion gate for Target 810 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_coi_clear_anim_object_strings_target_gcc.sh`: promotion gate for Target 811 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_coi_free_sub_entry_table_entries_target_gcc.sh`: promotion gate for Target 812 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_coi_get_anim_field_pointer_by_mode_target_gcc.sh`: promotion gate for Target 813 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_coi_test_entry_within_time_window_target_gcc.sh`: promotion gate for Target 814 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_coi_format_entry_display_text_target_gcc.sh`: promotion gate for Target 815 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_coi_alloc_sub_entry_table_target_gcc.sh`: promotion gate for Target 816 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_coi_load_oi_data_file_target_gcc.sh`: promotion gate for Target 817 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_coi_write_oi_data_file_target_gcc.sh`: promotion gate for Target 818 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_ctasks_close_task_teardown_target_gcc.sh`: promotion gate for Target 819 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_ctasks_start_close_task_process_target_gcc.sh`: promotion gate for Target 820 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_ctasks_iff_task_cleanup_target_gcc.sh`: promotion gate for Target 821 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_ctasks_start_iff_task_process_target_gcc.sh`: promotion gate for Target 822 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_disptext_has_multiple_lines_target_gcc.sh`: promotion gate for Target 823 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_disptext_is_current_line_last_target_gcc.sh`: promotion gate for Target 824 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_disptext_get_total_line_count_target_gcc.sh`: promotion gate for Target 825 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_disptext_is_last_line_selected_target_gcc.sh`: promotion gate for Target 826 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_disptext_set_current_line_index_target_gcc.sh`: promotion gate for Target 827 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_disptext_measure_current_line_length_target_gcc.sh`: promotion gate for Target 828 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_disptext_compute_visible_line_count_target_gcc.sh`: promotion gate for Target 829 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_disptext_init_buffers_target_gcc.sh`: promotion gate for Target 830 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_disptext_free_buffers_target_gcc.sh`: promotion gate for Target 831 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_disptext_finalize_line_table_target_gcc.sh`: promotion gate for Target 832 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_disptext_set_layout_params_target_gcc.sh`: promotion gate for Target 833 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_disptext_compute_marker_widths_target_gcc.sh`: promotion gate for Target 834 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_disptext_build_line_with_width_target_gcc.sh`: promotion gate for Target 835 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_disptext_build_line_pointer_table_target_gcc.sh`: promotion gate for Target 836 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_disptext_append_to_buffer_target_gcc.sh`: promotion gate for Target 837 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_disptext_build_layout_for_source_target_gcc.sh`: promotion gate for Target 838 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_disptext_layout_source_to_lines_target_gcc.sh`: promotion gate for Target 839 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_disptext_layout_and_append_to_buffer_target_gcc.sh`: promotion gate for Target 840 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_disptext_render_current_line_target_gcc.sh`: promotion gate for Target 841 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_displib_find_previous_valid_entry_index_target_gcc.sh`: promotion gate for Target 842 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqdisp_test_entry_bits0_and2_target_gcc.sh`: promotion gate for Target 843 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqdisp_get_entry_pointer_by_mode_target_gcc.sh`: promotion gate for Target 844 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqdisp_get_entry_aux_pointer_by_mode_target_gcc.sh`: promotion gate for Target 845 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqdisp_compute_schedule_offset_for_row_target_gcc.sh`: promotion gate for Target 846 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqdisp_test_entry_grid_eligibility_target_gcc.sh`: promotion gate for Target 847 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqdisp_test_word_is_zero_booleanize_target_gcc.sh`: promotion gate for Target 848 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqdisp_process_grid_messages_if_idle_target_gcc.sh`: promotion gate for Target 849 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqdisp_refresh_status_indicators_from_current_mask_target_gcc.sh`: promotion gate for Target 850 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqdisp_init_highlight_message_pattern_target_gcc.sh`: promotion gate for Target 851 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqdisp_update_status_mask_and_refresh_target_gcc.sh`: promotion gate for Target 852 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqdisp_allocate_highlight_bitmaps_target_gcc.sh`: promotion gate for Target 853 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqdisp_apply_status_mask_to_indicators_target_gcc.sh`: promotion gate for Target 854 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqdisp_set_status_indicator_color_slot_target_gcc.sh`: promotion gate for Target 855 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqdisp_queue_highlight_draw_message_target_gcc.sh`: promotion gate for Target 856 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqdisp_fill_program_info_header_fields_target_gcc.sh`: promotion gate for Target 857 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqdisp_poll_input_mode_and_refresh_selection_target_gcc.sh`: promotion gate for Target 858 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqdisp_normalize_clock_and_redraw_banner_target_gcc.sh`: promotion gate for Target 859 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqdisp_mirror_primary_entries_to_secondary_if_empty_target_gcc.sh`: promotion gate for Target 860 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqdisp_promote_secondary_line_head_tail_if_marked_target_gcc.sh`: promotion gate for Target 861 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqdisp_promote_secondary_group_to_primary_target_gcc.sh`: promotion gate for Target 862 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqdisp_propagate_primary_title_metadata_to_secondary_target_gcc.sh`: promotion gate for Target 863 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqdisp_draw_status_banner_impl_target_gcc.sh`: promotion gate for Target 864 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqdisp_parse_program_info_command_record_target_gcc.sh`: promotion gate for Target 865 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqdisp_draw_status_banner_target_gcc.sh`: promotion gate for Target 866 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqdisp_jmptbl_newgrid_and_graphics_alloc_raster_target_gcc.sh`: promotion gate for Target 867 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_flib_append_clock_stamped_log_entry_target_gcc.sh`: promotion gate for Target 868 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_displib_normalize_value_by_step_target_gcc.sh`: promotion gate for Target 869 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_displib_reset_line_tables_target_gcc.sh`: promotion gate for Target 870 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_displib_reset_text_buffer_and_line_tables_target_gcc.sh`: promotion gate for Target 871 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_displib_commit_current_line_pen_and_advance_target_gcc.sh`: promotion gate for Target 872 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_displib_display_text_at_position_target_gcc.sh`: promotion gate for Target 873 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_displib_apply_inline_alignment_padding_target_gcc.sh`: promotion gate for Target 874 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_jmptbl_esq_handle_serial_rbf_interrupt_target_gcc.sh`: promotion gate for Target 875 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_jmptbl_esq_tick_global_counters_target_gcc.sh`: promotion gate for Target 876 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_jmptbl_esq_poll_ctrl_input_target_gcc.sh`: promotion gate for Target 877 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_jmptbl_script_handle_serial_ctrl_cmd_target_gcc.sh`: promotion gate for Target 878 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_jmptbl_textdisp_tick_display_state_target_gcc.sh`: promotion gate for Target 879 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_allocate_line_text_buffers_target_gcc.sh`: promotion gate for Target 880 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_free_line_text_buffers_target_gcc.sh`: promotion gate for Target 881 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_update_disk_warning_and_refresh_tick_target_gcc.sh`: promotion gate for Target 882 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_wait_for_clock_change_and_service_ui_target_gcc.sh`: promotion gate for Target 883 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_commit_secondary_state_and_persist_target_gcc.sh`: promotion gate for Target 884 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_process_ui_frame_tick_target_gcc.sh`: promotion gate for Target 885 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_service_ui_tick_if_running_target_gcc.sh`: promotion gate for Target 886 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_free_extra_title_text_pointers_target_gcc.sh`: promotion gate for Target 887 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_update_refresh_mode_state_target_gcc.sh`: promotion gate for Target 888 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_draw_esc_menu_version_target_gcc.sh`: promotion gate for Target 889 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_trim_text_to_pixel_width_word_boundary_target_gcc.sh`: promotion gate for Target 890 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_rebuild_pw_brush_list_from_tag_table_target_gcc.sh`: promotion gate for Target 891 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_select_and_apply_brush_for_current_entry_target_gcc.sh`: promotion gate for Target 892 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esqfunc_draw_memory_status_screen_target_gcc.sh`: promotion gate for Target 893 GCC lane (semantic + build/hash gates).
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
- Promoted GCC targets: `001` (`xjump`), `002` (`memory`), `003` (`clock wrapper`), `004` (`STRING_ToUpperChar`), `005` (`MEM_Move`), `006` (`FORMAT_U32ToDecimalString`), `007` (`LIST_InitHeader`), `008` (`DOS_ReadByIndex`), `009` (`DOS_SeekByIndex`), `010` (`STRING_AppendAtNull`), `011` (`STRING_AppendN`), `012` (`STRING_CopyPadNul`), `013` (`STRING_CompareN`), `014` (`STRING_CompareNoCase`), `015` (`STRING_CompareNoCaseN`), `016` (`STRING_ToUpperInPlace`), `017` (`STR_FindChar`), `018` (`STR_FindCharPtr`), `019` (`STR_FindAnyCharInSet`), `020` (`STR_FindAnyCharPtr`), `021` (`STR_SkipClass3Chars`), `022` (`FORMAT_CallbackWriteChar`), `023` (`FORMAT_FormatToCallbackBuffer`), `024` (`FORMAT_U32ToOctalString`), `025` (`FORMAT_U32ToHexString`), `026` (`UNKNOWN10_PrintfPutcToBuffer`), `027` (`WDISP_SPrintf`), `028` (`PARSE_ReadSignedLong_NoBranch`), `029` (`PARSE_ReadSignedLong`), `030` (`STR_CopyUntilAnyDelimN`), `031` (`STREAM_ReadLineWithLimit`), `032` (`DOS_WriteWithErrorState`), `033` (`DOS_ReadWithErrorState`), `034` (`DOS_SeekWithErrorState`), `035` (`EXEC_CallVector_348`), `036` (`HANDLE_GetEntryByIndex`), `037` (`DOS_CloseWithSignalCheck`), `038` (`IOSTDREQ_Free`), `039` (`IOSTDREQ_CleanupSignalAndMsgport`), `040` (`MATH_Mulu32`), `041` (`DOS_WriteByIndex`), `042` (`ALLOCATE_AllocAndInitializeIOStdReq`), `043` (`MATH_DivS32`), `044` (`DOS_OpenNewFileIfMissing`), `045` (`DOS_DeleteAndRecreateFile`), `046` (`SIGNAL_CreateMsgPortWithSignal`), `047` (`DOS_Delay`), `048` (`BATTCLOCK_GetSecondsFromBatteryBackedClock`), `049` (`BATTCLOCK_WriteSecondsToBatteryBackedClock`), `050` (`DOS_SystemTagList`), `051` (`EXEC_CallVector_48`), `052` (`PARALLEL_CheckReadyStub`), `053` (`UNKNOWN2A_Stub0`), `054` (`PARALLEL_CheckReady`), `055` (`PARALLEL_WriteCharD0`), `056` (`CLOCK_SecondsFromEpoch`), `057` (`CLOCK_CheckDateOrSecondsFromEpoch`), `058` (`PARALLEL_WaitReady`), `059` (`PARALLEL_WriteStringLoop`), `060` (`PARALLEL_RawDoFmt`), `061` (`PARALLEL_WriteCharHw`), `062` (`PARALLEL_RawDoFmtStackArgs`), `063` (`PARALLEL_RawDoFmtCommon`), `064` (`STRUCT_FreeWithSizeField`), `065` (`STRUCT_AllocWithOwner`), `066` (`DOS_OpenWithErrorState`), `067` (`HANDLE_CloseByIndex`), `068` (`HANDLE_OpenWithMode`), `069` (`STRING_FindSubstring`), `070` (`SIGNAL_PollAndDispatch`), `071` (`PARSE_ReadSignedLongSkipClass3`), `072` (`PARSE_ReadSignedLongSkipClass3_Alt`), `073` (`MEMLIST_FreeAll`), `074` (`UNKNOWN32_JMPTBL_ESQ_ReturnWithStackCode`), `075` (`HANDLE_CloseAllAndReturnWithCode`), `076` (`MEMLIST_AllocTracked`), `077` (`FORMAT_RawDoFmtWithScratchBuffer`), `078` (`ESQ_MainEntryNoOpHook`), `079` (`ESQ_MainExitNoOpHook`), `080` (`DOS_OpenFileWithMode`), `081` (`GRAPHICS_AllocRaster`), `082` (`GRAPHICS_FreeRaster`), `083` (`DOS_MovepWordReadCallback`), `084` (`UNKNOWN_ParseListAndUpdateEntries`).
- Additional promoted GCC targets: `085` (`ESQ_ParseCommandLineAndRun`), `086` (`STREAM_BufferedWriteString`), `087` (`UNKNOWN29_JMPTBL_ESQ_MainInitAndRun`), `088` (`GROUP_MAIN_B_JMPTBL_STREAM_BufferedWriteString`), `089` (`GROUP_MAIN_B_JMPTBL_MATH_Mulu32`), `090` (`GROUP_MAIN_B_JMPTBL_DOS_Delay`), `091` (`GROUP_MAIN_B_JMPTBL_BUFFER_FlushAllAndCloseWithCode`), `092` (`GROUP_AR_JMPTBL_PARSEINI_WriteErrorLogEntry`), `093` (`GROUP_AR_JMPTBL_STRING_AppendAtNull`), `094` (`GROUP_AA_JMPTBL_STRING_CompareN`), `095` (`GROUP_AA_JMPTBL_STRING_CompareNoCase`), `096` (`GROUP_AG_JMPTBL_MEMORY_DeallocateMemory`), `097` (`GROUP_AG_JMPTBL_MEMORY_AllocateMemory`), `098` (`GROUP_AG_JMPTBL_STRUCT_AllocWithOwner`), `099` (`GROUP_AG_JMPTBL_STRUCT_FreeWithSizeField`), `100` (`GROUP_AG_JMPTBL_MATH_DivS32`), `101` (`GROUP_AG_JMPTBL_MATH_Mulu32`), `102` (`GROUP_AG_JMPTBL_DOS_OpenFileWithMode`), `103` (`GROUP_AG_JMPTBL_STRING_CopyPadNul`), `104` (`GROUP_AM_JMPTBL_SIGNAL_CreateMsgPortWithSignal`), `105` (`GROUP_AM_JMPTBL_STRUCT_AllocWithOwner`), `106` (`GROUP_AM_JMPTBL_LIST_InitHeader`), `107` (`GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt`), `108` (`ESQIFF_JMPTBL_STRING_CompareNoCase`), `109` (`ESQIFF_JMPTBL_STRING_CompareN`), `110` (`ESQIFF_JMPTBL_STRING_CompareNoCaseN`), `111` (`ESQIFF_JMPTBL_MATH_DivS32`), `112` (`ESQIFF_JMPTBL_ESQ_NoOp`), `113` (`ESQIFF_JMPTBL_MEMORY_DeallocateMemory`), `114` (`ESQIFF_JMPTBL_ESQ_NoOp_006A`), `115` (`ESQIFF_JMPTBL_ESQ_NoOp_0074`), `116` (`ESQIFF_JMPTBL_MEMORY_AllocateMemory`), `117` (`ESQIFF_JMPTBL_DOS_OpenFileWithMode`), `118` (`ESQIFF_JMPTBL_MATH_Mulu32`), `119` (`ESQIFF_JMPTBL_DISKIO_ResetCtrlInputStateIfIdle`), `120` (`ESQIFF_JMPTBL_DISKIO_GetFilesizeFromHandle`), `121` (`ESQIFF_JMPTBL_DISKIO_ForceUiRefreshIfIdle`), `122` (`ESQIFF_JMPTBL_ESQ_IncCopperListsTowardsTargets`), `123` (`ESQIFF_JMPTBL_ESQ_DecCopperListsPrimary`), `124` (`ESQIFF_JMPTBL_CTASKS_StartIffTaskProcess`), `125` (`ESQIFF_JMPTBL_SCRIPT_AssertCtrlLineIfEnabled`), `126` (`ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart`), `127` (`ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd`), `128` (`ESQIFF_JMPTBL_BRUSH_CloneBrushRecord`), `129` (`ESQIFF_JMPTBL_BRUSH_FindType3Brush`), `130` (`ESQIFF_JMPTBL_BRUSH_PopBrushHead`), `131` (`ESQIFF_JMPTBL_BRUSH_AllocBrushNode`), `132` (`ESQIFF_JMPTBL_BRUSH_FindBrushByPredicate`), `133` (`ESQIFF_JMPTBL_BRUSH_FreeBrushList`), `134` (`ESQIFF_JMPTBL_BRUSH_SelectBrushByLabel`), `135` (`ESQIFF_JMPTBL_TEXTDISP_FindEntryIndexByWildcard`), `136` (`ESQIFF_JMPTBL_TEXTDISP_DrawChannelBanner`), `137` (`ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode`), `138` (`ESQIFF_JMPTBL_BRUSH_PopulateBrushList`), `139` (`ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition`), `140` (`ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode`), `141` (`ESQIFF_JMPTBL_BRUSH_SelectBrushSlot`), `142` (`GROUP_AW_JMPTBL_TLIBA3_BuildDisplayContextForViewMode`), `143` (`GROUP_AD_JMPTBL_TLIBA3_BuildDisplayContextForViewMode`), `144` (`GROUP_AW_JMPTBL_MEM_Move`), `145` (`GROUP_AW_JMPTBL_STRING_CopyPadNul`), `146` (`GROUP_AD_JMPTBL_TEXTDISP_DrawChannelBanner`), `147` (`GROUP_AD_JMPTBL_TEXTDISP_FormatEntryTime`).
- Newly promoted GCC targets: `148` (`GROUP_AD_JMPTBL_TLIBA3_GetViewModeHeight`), `149` (`GROUP_AD_JMPTBL_TLIBA3_GetViewModeRastPort`), `150` (`GROUP_AD_JMPTBL_DATETIME_NormalizeMonthRange`), `151` (`GROUP_AD_JMPTBL_DATETIME_AdjustMonthIndex`), `152` (`GROUP_AD_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte`), `153` (`GROUP_AD_JMPTBL_ESQIFF_RunCopperRiseTransition`), `154` (`GROUP_AD_JMPTBL_TEXTDISP_BuildEntryShortName`), `155` (`GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort`), `156` (`GROUP_AD_JMPTBL_ESQIFF_RunCopperDropTransition`), `157` (`GROUP_AD_JMPTBL_TLIBA1_BuildClockFormatEntryIfVisible`), `158` (`GROUP_AD_JMPTBL_TEXTDISP_BuildChannelLabel`), `159` (`GROUP_AD_JMPTBL_TEXTDISP_DrawInsetRectFrame`), `160` (`GROUP_AD_JMPTBL_TEXTDISP_TrimTextToPixelWidth`), `161` (`GROUP_AD_JMPTBL_ESQFUNC_SelectAndApplyBrushForCurrentEntry`), `162` (`GROUP_AD_JMPTBL_DST_ComputeBannerIndex`), `163` (`GROUP_MAIN_A_JMPTBL_ESQ_MainExitNoOpHook`), `164` (`GROUP_MAIN_A_JMPTBL_ESQ_MainEntryNoOpHook`), `165` (`GROUP_MAIN_A_JMPTBL_MEMLIST_FreeAll`), `166` (`GROUP_MAIN_A_JMPTBL_ESQ_ParseCommandLineAndRun`), `167` (`GROUP_AL_JMPTBL_LADFUNC_PackNibblesToByte`), `168` (`GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble`), `169` (`GROUP_AL_JMPTBL_LADFUNC_UpdateEntryBuffersForAdIndex`), `170` (`GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth`), `171` (`GROUP_AL_JMPTBL_LADFUNC_BuildEntryBuffersOrDefault`), `172` (`GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble`), `173` (`GROUP_AY_JMPTBL_DISKIO_ConsumeCStringFromWorkBuffer`), `174` (`GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer`), `175` (`GROUP_AY_JMPTBL_DISKIO_WriteDecimalField`), `176` (`GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes`), `177` (`GROUP_AY_JMPTBL_DISKIO_CloseBufferedFileAndFlush`), `178` (`GROUP_AY_JMPTBL_STRING_CompareNoCaseN`), `179` (`GROUP_AY_JMPTBL_MATH_Mulu32`), `180` (`GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer`), `181` (`GROUP_AY_JMPTBL_SCRIPT_ReadCiaBBit5Mask`), `182` (`GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer`), `183` (`GROUP_AW_JMPTBL_DISPLIB_ApplyInlineAlignmentPadding`), `184` (`GROUP_AW_JMPTBL_ESQIFF_RunCopperRiseTransition`), `185` (`GROUP_AW_JMPTBL_ESQIFF_RunCopperDropTransition`), `186` (`GROUP_AW_JMPTBL_DISPLIB_DisplayTextAtPosition`), `187` (`GROUP_AW_JMPTBL_WDISP_SPrintf`), `188` (`GROUP_AW_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight`), `189` (`GROUP_AS_JMPTBL_STR_FindCharPtr`), `190` (`GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold`), `191` (`GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit0`), `192` (`GROUP_AT_JMPTBL_DOS_SystemTagList`), `193` (`GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit1`), `194` (`GROUP_AU_JMPTBL_BRUSH_AppendBrushNode`), `195` (`GROUP_AU_JMPTBL_BRUSH_PopulateBrushList`), `196` (`GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer`), `197` (`GROUP_AZ_JMPTBL_ESQ_ColdReboot`).
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
bash src/decomp/scripts/promote_esq_invoke_gcommand_init_target_gcc.sh
bash src/decomp/scripts/promote_esq_try_rom_write_test_target_gcc.sh
bash src/decomp/scripts/promote_esq_supervisor_cold_reboot_target_gcc.sh
bash src/decomp/scripts/promote_esq_init_audio1_dma_target_gcc.sh
bash src/decomp/scripts/promote_esq_read_serial_rbf_byte_target_gcc.sh
bash src/decomp/scripts/promote_esq_handle_serial_rbf_interrupt_target_gcc.sh
bash src/decomp/scripts/promote_esq_capture_ctrl_bit4_stream_buffer_byte_target_gcc.sh
bash src/decomp/scripts/promote_esq_poll_ctrl_input_target_gcc.sh
bash src/decomp/scripts/promote_esq_set_copper_effect_default_target_gcc.sh
bash src/decomp/scripts/promote_esq_set_copper_effect_all_on_target_gcc.sh
bash src/decomp/scripts/promote_esq_set_copper_effect_custom_target_gcc.sh
bash src/decomp/scripts/promote_esq_set_copper_effect_off_disable_highlight_target_gcc.sh
bash src/decomp/scripts/promote_esq_set_copper_effect_on_enable_highlight_target_gcc.sh
bash src/decomp/scripts/promote_esq_set_copper_effect_params_target_gcc.sh
bash src/decomp/scripts/promote_esq_update_copper_lists_from_params_target_gcc.sh
bash src/decomp/scripts/promote_esq_dec_color_step_target_gcc.sh
bash src/decomp/scripts/promote_esq_bump_color_toward_targets_target_gcc.sh
bash src/decomp/scripts/promote_esq_move_copper_entry_toward_start_target_gcc.sh
bash src/decomp/scripts/promote_esq_move_copper_entry_toward_end_target_gcc.sh
bash src/decomp/scripts/promote_esq_generate_xor_checksum_byte_target_gcc.sh
bash src/decomp/scripts/promote_esq_terminate_after_second_quote_target_gcc.sh
bash src/decomp/scripts/promote_esq_test_bit1_based_target_gcc.sh
bash src/decomp/scripts/promote_esq_set_bit1_based_target_gcc.sh
bash src/decomp/scripts/promote_esq_reverse_bits_in6_bytes_target_gcc.sh
bash src/decomp/scripts/promote_esq_get_half_hour_slot_index_target_gcc.sh
bash src/decomp/scripts/promote_esq_clamp_banner_char_range_target_gcc.sh
bash src/decomp/scripts/promote_esq_store_ctrl_sample_entry_target_gcc.sh
bash src/decomp/scripts/promote_esq_format_time_stamp_target_gcc.sh
bash src/decomp/scripts/promote_esq_calc_day_of_year_from_month_day_target_gcc.sh
bash src/decomp/scripts/promote_esq_update_month_day_from_day_of_year_target_gcc.sh
bash src/decomp/scripts/promote_esq_noop_target_gcc.sh
bash src/decomp/scripts/promote_esq_noop_006a_target_gcc.sh
bash src/decomp/scripts/promote_esq_noop_0074_target_gcc.sh
bash src/decomp/scripts/promote_get_bit_3_of_ciab_pra_into_d1_target_gcc.sh
bash src/decomp/scripts/promote_get_bit_4_of_ciab_pra_into_d1_target_gcc.sh
bash src/decomp/scripts/promote_esq_main_exit_noop_hook_target_gcc.sh
bash src/decomp/scripts/promote_dos_open_file_with_mode_target_gcc.sh
bash src/decomp/scripts/promote_graphics_alloc_raster_target_gcc.sh
bash src/decomp/scripts/promote_graphics_free_raster_target_gcc.sh
bash src/decomp/scripts/promote_dos_movep_word_read_callback_target_gcc.sh
bash src/decomp/scripts/promote_unknown_parse_list_and_update_entries_target_gcc.sh
bash src/decomp/scripts/promote_esqproto_copy_label_to_global_target_gcc.sh
bash src/decomp/scripts/promote_esqproto_parse_digit_label_and_display_target_gcc.sh
bash src/decomp/scripts/promote_unknown_parse_record_and_update_display_target_gcc.sh
bash src/decomp/scripts/promote_esqproto_verify_checksum_and_parse_record_target_gcc.sh
bash src/decomp/scripts/promote_esqproto_verify_checksum_and_parse_list_target_gcc.sh
bash src/decomp/scripts/promote_unknown36_finalize_request_target_gcc.sh
bash src/decomp/scripts/promote_unknown36_show_abort_requester_target_gcc.sh
bash src/decomp/scripts/promote_handle_open_from_mode_string_target_gcc.sh
bash src/decomp/scripts/promote_wdisp_format_with_callback_target_gcc.sh
bash src/decomp/scripts/promote_handle_open_entry_with_flags_target_gcc.sh
bash src/decomp/scripts/promote_buffer_ensure_allocated_target_gcc.sh
bash src/decomp/scripts/promote_buffer_flush_all_and_close_with_code_target_gcc.sh
bash src/decomp/scripts/promote_graphics_bltbitmaprastport_target_gcc.sh
bash src/decomp/scripts/promote_math_divu32_target_gcc.sh
bash src/decomp/scripts/promote_brush_planemaskforindex_target_gcc.sh
bash src/decomp/scripts/promote_brush_append_brush_node_target_gcc.sh
bash src/decomp/scripts/promote_brush_pop_brush_head_target_gcc.sh
bash src/decomp/scripts/promote_brush_find_type3_brush_target_gcc.sh
bash src/decomp/scripts/promote_brush_find_brush_by_predicate_target_gcc.sh
bash src/decomp/scripts/promote_brush_free_brush_list_return_target_gcc.sh
bash src/decomp/scripts/promote_brush_select_brush_slot_return_target_gcc.sh
bash src/decomp/scripts/promote_brush_alloc_brush_node_target_gcc.sh
bash src/decomp/scripts/promote_brush_free_brush_list_target_gcc.sh
bash src/decomp/scripts/promote_brush_normalize_brush_names_target_gcc.sh
bash src/decomp/scripts/promote_brush_select_brush_by_label_target_gcc.sh
bash src/decomp/scripts/promote_brush_free_brush_resources_target_gcc.sh
bash src/decomp/scripts/promote_brush_populate_brush_list_target_gcc.sh
bash src/decomp/scripts/promote_brush_stream_font_chunk_target_gcc.sh
bash src/decomp/scripts/promote_brush_load_color_text_font_target_gcc.sh
bash src/decomp/scripts/promote_brush_clone_brush_record_target_gcc.sh
bash src/decomp/scripts/promote_brush_select_brush_slot_target_gcc.sh
bash src/decomp/scripts/promote_brush_load_brush_asset_target_gcc.sh
bash src/decomp/scripts/promote_datetime_isleapyear_target_gcc.sh
bash src/decomp/scripts/promote_datetime_adjust_month_index_target_gcc.sh
bash src/decomp/scripts/promote_datetime_normalize_month_range_target_gcc.sh
bash src/decomp/scripts/promote_dst_normalize_day_of_year_target_gcc.sh
bash src/decomp/scripts/promote_dst_write_rtc_from_globals_target_gcc.sh
bash src/decomp/scripts/promote_dst_tick_banner_counters_target_gcc.sh
bash src/decomp/scripts/promote_dst_build_banner_time_word_target_gcc.sh
bash src/decomp/scripts/promote_dst_compute_banner_index_target_gcc.sh
bash src/decomp/scripts/promote_dst_add_time_offset_target_gcc.sh
bash src/decomp/scripts/promote_dst_free_banner_struct_target_gcc.sh
bash src/decomp/scripts/promote_dst_free_banner_pair_target_gcc.sh
bash src/decomp/scripts/promote_dst_allocate_banner_struct_target_gcc.sh
bash src/decomp/scripts/promote_dst_rebuild_banner_pair_target_gcc.sh
bash src/decomp/scripts/promote_dst_load_banner_pair_from_files_target_gcc.sh
bash src/decomp/scripts/promote_dst_handle_banner_command32_33_target_gcc.sh
bash src/decomp/scripts/promote_dst_format_banner_datetime_target_gcc.sh
bash src/decomp/scripts/promote_dst_refresh_banner_buffer_target_gcc.sh
bash src/decomp/scripts/promote_dst_update_banner_queue_target_gcc.sh
bash src/decomp/scripts/promote_dst_build_banner_time_entry_target_gcc.sh
bash src/decomp/scripts/promote_esq_parse_command_line_and_run_target_gcc.sh
bash src/decomp/scripts/promote_stream_buffered_write_string_target_gcc.sh
bash src/decomp/scripts/promote_unknown29_jmptbl_esq_main_init_and_run_target_gcc.sh
bash src/decomp/scripts/promote_unknown_jmptbl_esqiff2_read_serial_record_into_buffer_target_gcc.sh
bash src/decomp/scripts/promote_unknown_jmptbl_displib_display_text_at_position_target_gcc.sh
bash src/decomp/scripts/promote_unknown_jmptbl_esq_wildcard_match_target_gcc.sh
bash src/decomp/scripts/promote_unknown_jmptbl_dst_normalize_day_of_year_target_gcc.sh
bash src/decomp/scripts/promote_unknown_jmptbl_esq_generate_xor_checksum_byte_target_gcc.sh
bash src/decomp/scripts/promote_esqproto_jmptbl_esqpars_replace_owned_string_target_gcc.sh
bash src/decomp/scripts/promote_esqshared_jmptbl_dst_build_banner_time_word_target_gcc.sh
bash src/decomp/scripts/promote_esqshared_jmptbl_esq_reverse_bits_in6_bytes_target_gcc.sh
bash src/decomp/scripts/promote_esqshared_jmptbl_esq_set_bit1_based_target_gcc.sh
bash src/decomp/scripts/promote_esqshared_jmptbl_esq_adjust_bracketed_hour_in_string_target_gcc.sh
bash src/decomp/scripts/promote_esqshared_jmptbl_coi_ensure_anim_object_allocated_target_gcc.sh
bash src/decomp/scripts/promote_esqshared_jmptbl_esq_wildcard_match_target_gcc.sh
bash src/decomp/scripts/promote_esqshared_jmptbl_str_skip_class3_chars_target_gcc.sh
bash src/decomp/scripts/promote_esqshared_jmptbl_esq_test_bit1_based_target_gcc.sh
bash src/decomp/scripts/promote_esqpars_jmptbl_diskio2_flushdatafilesifneeded_target_gcc.sh
bash src/decomp/scripts/promote_esqpars_jmptbl_newgrid_rebuildindexcache_target_gcc.sh
bash src/decomp/scripts/promote_esqpars_jmptbl_datetime_savepairtofile_target_gcc.sh
bash src/decomp/scripts/promote_esqpars_jmptbl_esqproto_verifychecksumandparselist_target_gcc.sh
bash src/decomp/scripts/promote_esqpars_jmptbl_p_type_parseandstoretyperecord_target_gcc.sh
bash src/decomp/scripts/promote_esqpars_jmptbl_esqproto_copylabeltoglobal_target_gcc.sh
bash src/decomp/scripts/promote_esqpars_jmptbl_dst_handlebannercommand32_33_target_gcc.sh
bash src/decomp/scripts/promote_esqpars_jmptbl_esq_seedminuteeventthresholds_target_gcc.sh
bash src/decomp/scripts/promote_esqpars_jmptbl_parseini_handlefontcommand_target_gcc.sh
bash src/decomp/scripts/promote_esqpars_jmptbl_textdisp_applysourceconfigallentries_target_gcc.sh
bash src/decomp/scripts/promote_esqpars_jmptbl_brush_planemaskforindex_target_gcc.sh
bash src/decomp/scripts/promote_esqpars_jmptbl_script_resetctrlcontextandclearstatusline_target_gcc.sh
bash src/decomp/scripts/promote_esqpars_jmptbl_parseini_writertcfromglobals_target_gcc.sh
bash src/decomp/scripts/promote_esqpars_jmptbl_locavail_saveavailabilitydatafile_target_gcc.sh
bash src/decomp/scripts/promote_esqpars_jmptbl_displib_displaytextatposition_target_gcc.sh
bash src/decomp/scripts/promote_esqpars_jmptbl_ladfunc_savetextadstofile_target_gcc.sh
bash src/decomp/scripts/promote_esqpars_jmptbl_parse_readsignedlongskipclass3_alt_target_gcc.sh
bash src/decomp/scripts/promote_esqpars_jmptbl_diskio2_handleinteractivefiletransfer_target_gcc.sh
bash src/decomp/scripts/promote_esqpars_jmptbl_p_type_writepromoiddatafile_target_gcc.sh
bash src/decomp/scripts/promote_esqpars_jmptbl_coi_freeentryresources_target_gcc.sh
bash src/decomp/scripts/promote_esqpars_jmptbl_dst_updatebannerqueue_target_gcc.sh
bash src/decomp/scripts/promote_esqpars_jmptbl_esqproto_verifychecksumandparserecord_target_gcc.sh
bash src/decomp/scripts/promote_esqpars_jmptbl_esqproto_parsedigitlabelanddisplay_target_gcc.sh
bash src/decomp/scripts/promote_esqpars_jmptbl_diskio_parseconfigbuffer_target_gcc.sh
bash src/decomp/scripts/promote_esqpars_jmptbl_cleanup_parsealignedlistingblock_target_gcc.sh
bash src/decomp/scripts/promote_esqpars_jmptbl_script_readserialrbfbyte_target_gcc.sh
bash src/decomp/scripts/promote_esqpars_jmptbl_esq_generatexorchecksumbyte_target_gcc.sh
bash src/decomp/scripts/promote_esqpars_jmptbl_dst_refreshbannerbuffer_target_gcc.sh
bash src/decomp/scripts/promote_esqpars_jmptbl_diskio_saveconfigtofilehandle_target_gcc.sh
bash src/decomp/scripts/promote_ed1_jmptbl_newgrid_drawtopborderline_target_gcc.sh
bash src/decomp/scripts/promote_ed1_jmptbl_locavail_resetfiltercursorstate_target_gcc.sh
bash src/decomp/scripts/promote_ed1_jmptbl_gcommand_resethighlightmessages_target_gcc.sh
bash src/decomp/scripts/promote_ed1_jmptbl_ladfunc_mergehighlownibbles_target_gcc.sh
bash src/decomp/scripts/promote_ed1_jmptbl_ladfunc_savetextadstofile_target_gcc.sh
bash src/decomp/scripts/promote_ed1_jmptbl_esq_coldreboot_target_gcc.sh
bash src/decomp/scripts/promote_ed1_jmptbl_esqshared4_loaddefaultpalettetocopper_noop_target_gcc.sh
bash src/decomp/scripts/promote_ed1_jmptbl_gcommand_seedbannerdefaults_target_gcc.sh
bash src/decomp/scripts/promote_ed1_jmptbl_mem_move_target_gcc.sh
bash src/decomp/scripts/promote_ed1_jmptbl_gcommand_seedbannerfromprefs_target_gcc.sh
bash src/decomp/scripts/promote_ed1_jmptbl_cleanup_drawdatetimebannerrow_target_gcc.sh
bash src/decomp/scripts/promote_ed1_jmptbl_ladfunc_packnibblestobyte_target_gcc.sh
bash src/decomp/scripts/promote_esqfunc_jmptbl_textdisp_setrastformode_target_gcc.sh
bash src/decomp/scripts/promote_esqfunc_jmptbl_p_type_promotesecondarylist_target_gcc.sh
bash src/decomp/scripts/promote_esqfunc_jmptbl_diskio_probedrivesandassignpaths_target_gcc.sh
bash src/decomp/scripts/promote_esqfunc_jmptbl_parseini_updatectrlhdeltamax_target_gcc.sh
bash src/decomp/scripts/promote_esqfunc_jmptbl_esq_clampbannercharrange_target_gcc.sh
bash src/decomp/scripts/promote_esqfunc_jmptbl_script_readciabbit3flag_target_gcc.sh
bash src/decomp/scripts/promote_esqfunc_jmptbl_tliba3_drawcenteredwrappedtextlines_target_gcc.sh
bash src/decomp/scripts/promote_esqfunc_jmptbl_script_getctrllineflag_target_gcc.sh
bash src/decomp/scripts/promote_esqfunc_jmptbl_locavail_syncsecondaryfilterforcurrentgroup_target_gcc.sh
bash src/decomp/scripts/promote_esqfunc_jmptbl_textdisp_resetselectionandrefresh_target_gcc.sh
bash src/decomp/scripts/promote_esqfunc_jmptbl_parseini_monitorclockchange_target_gcc.sh
bash src/decomp/scripts/promote_esqfunc_jmptbl_ladfunc_parsehexdigit_target_gcc.sh
bash src/decomp/scripts/promote_esqfunc_jmptbl_cleanup_processalerts_target_gcc.sh
bash src/decomp/scripts/promote_esqfunc_jmptbl_esq_gethalfhourslotindex_target_gcc.sh
bash src/decomp/scripts/promote_esqfunc_jmptbl_cleanup_drawclockbanner_target_gcc.sh
bash src/decomp/scripts/promote_esqfunc_jmptbl_parseini_computehtcmaxvalues_target_gcc.sh
bash src/decomp/scripts/promote_esqfunc_jmptbl_ladfunc_updatehighlightstate_target_gcc.sh
bash src/decomp/scripts/promote_esqfunc_jmptbl_p_type_ensuresecondarylist_target_gcc.sh
bash src/decomp/scripts/promote_esqfunc_jmptbl_script_readciabbit5mask_target_gcc.sh
bash src/decomp/scripts/promote_esqfunc_jmptbl_parseini_normalizeclockdata_target_gcc.sh
bash src/decomp/scripts/promote_esqfunc_jmptbl_esq_tickglobalcounters_target_gcc.sh
bash src/decomp/scripts/promote_esqfunc_jmptbl_script_handleserialctrlcmd_target_gcc.sh
bash src/decomp/scripts/promote_esqfunc_jmptbl_esq_handleserialrbfinterrupt_target_gcc.sh
bash src/decomp/scripts/promote_esqfunc_jmptbl_textdisp_tickdisplaystate_target_gcc.sh
bash src/decomp/scripts/promote_esqfunc_jmptbl_esq_pollctrlinput_target_gcc.sh
bash src/decomp/scripts/promote_esqfunc_jmptbl_locavail_rebuildfilterstatefromcurrentgroup_target_gcc.sh
bash src/decomp/scripts/promote_esqfunc_jmptbl_string_copypadnul_target_gcc.sh
bash src/decomp/scripts/promote_esqdisp_jmptbl_newgrid_processgridmessages_target_gcc.sh
bash src/decomp/scripts/promote_esqdisp_jmptbl_graphics_allocraster_target_gcc.sh
bash src/decomp/scripts/promote_group_ag_jmptbl_memory_deallocate_memory_target_gcc.sh
bash src/decomp/scripts/promote_group_ag_jmptbl_memory_allocate_memory_target_gcc.sh
bash src/decomp/scripts/promote_group_ag_jmptbl_struct_alloc_with_owner_target_gcc.sh
bash src/decomp/scripts/promote_group_ag_jmptbl_struct_free_with_size_field_target_gcc.sh
bash src/decomp/scripts/promote_group_ag_jmptbl_math_divs32_target_gcc.sh
bash src/decomp/scripts/promote_group_ag_jmptbl_math_mulu32_target_gcc.sh
bash src/decomp/scripts/promote_group_ag_jmptbl_dos_open_file_with_mode_target_gcc.sh
bash src/decomp/scripts/promote_group_ag_jmptbl_string_copy_pad_nul_target_gcc.sh
bash src/decomp/scripts/promote_group_ag_jmptbl_parse_read_signed_long_skip_class3_alt_target_gcc.sh
bash src/decomp/scripts/promote_group_ag_jmptbl_signal_create_msgport_with_signal_target_gcc.sh
bash src/decomp/scripts/promote_group_ag_jmptbl_textdisp_reset_selection_and_refresh_target_gcc.sh
bash src/decomp/scripts/promote_group_ag_jmptbl_iostdreq_cleanup_signal_and_msgport_target_gcc.sh
bash src/decomp/scripts/promote_group_ag_jmptbl_esqfunc_service_ui_tick_if_running_target_gcc.sh
bash src/decomp/scripts/promote_group_ag_jmptbl_script_begin_banner_char_transition_target_gcc.sh
bash src/decomp/scripts/promote_group_ag_jmptbl_ladfunc2_emit_escaped_string_to_scratch_target_gcc.sh
bash src/decomp/scripts/promote_group_ag_jmptbl_script_check_path_exists_target_gcc.sh
bash src/decomp/scripts/promote_group_ag_jmptbl_esqfunc_update_refresh_mode_state_target_gcc.sh
bash src/decomp/scripts/promote_group_am_jmptbl_signal_create_msgport_with_signal_target_gcc.sh
bash src/decomp/scripts/promote_group_am_jmptbl_struct_alloc_with_owner_target_gcc.sh
bash src/decomp/scripts/promote_group_am_jmptbl_list_init_header_target_gcc.sh
bash src/decomp/scripts/promote_group_am_jmptbl_ladfunc_clear_banner_rect_entries_target_gcc.sh
bash src/decomp/scripts/promote_group_am_jmptbl_parseini_update_clock_from_rtc_target_gcc.sh
bash src/decomp/scripts/promote_group_am_jmptbl_script_init_ctrl_context_target_gcc.sh
bash src/decomp/scripts/promote_group_am_jmptbl_diskio2_parse_ini_file_from_disk_target_gcc.sh
bash src/decomp/scripts/promote_group_am_jmptbl_esq_check_topaz_font_guard_target_gcc.sh
bash src/decomp/scripts/promote_group_am_jmptbl_p_type_reset_lists_and_load_promo_ids_target_gcc.sh
bash src/decomp/scripts/promote_group_am_jmptbl_ladfunc_load_text_ads_from_file_target_gcc.sh
bash src/decomp/scripts/promote_group_am_jmptbl_diskio_load_config_from_disk_target_gcc.sh
bash src/decomp/scripts/promote_group_am_jmptbl_textdisp_load_source_config_target_gcc.sh
bash src/decomp/scripts/promote_group_am_jmptbl_kybd_initialize_input_devices_target_gcc.sh
bash src/decomp/scripts/promote_group_am_jmptbl_esq_check_compatible_video_chip_target_gcc.sh
bash src/decomp/scripts/promote_group_am_jmptbl_esq_check_available_fast_memory_target_gcc.sh
bash src/decomp/scripts/promote_group_am_jmptbl_gcommand_reset_banner_fade_state_target_gcc.sh
bash src/decomp/scripts/promote_group_am_jmptbl_tliba3_init_pattern_table_target_gcc.sh
bash src/decomp/scripts/promote_group_am_jmptbl_esq_format_disk_error_message_target_gcc.sh
bash src/decomp/scripts/promote_group_am_jmptbl_script_prime_banner_transition_from_hex_code_target_gcc.sh
bash src/decomp/scripts/promote_group_am_jmptbl_locavail_reset_filter_state_struct_target_gcc.sh
bash src/decomp/scripts/promote_group_am_jmptbl_esq_init_audio1_dma_target_gcc.sh
bash src/decomp/scripts/promote_group_am_jmptbl_esq_set_copper_effect_on_enable_highlight_target_gcc.sh
bash src/decomp/scripts/promote_group_am_jmptbl_locavail_load_availability_data_file_target_gcc.sh
bash src/decomp/scripts/promote_group_am_jmptbl_gcommand_init_preset_defaults_target_gcc.sh
bash src/decomp/scripts/promote_group_am_jmptbl_override_intuition_funcs_target_gcc.sh
bash src/decomp/scripts/promote_group_am_jmptbl_buffer_flush_all_and_close_with_code_target_gcc.sh
bash src/decomp/scripts/promote_group_am_jmptbl_flib2_reset_and_load_listing_templates_target_gcc.sh
bash src/decomp/scripts/promote_group_am_jmptbl_wdisp_s_printf_target_gcc.sh
bash src/decomp/scripts/promote_group_am_jmptbl_esq_set_copper_effect_off_disable_highlight_target_gcc.sh
bash src/decomp/scripts/promote_group_am_jmptbl_cleanup_shutdown_system_target_gcc.sh
bash src/decomp/scripts/promote_group_am_jmptbl_ladfunc_alloc_banner_rect_entries_target_gcc.sh
bash src/decomp/scripts/promote_esqiff_jmptbl_string_compare_nocase_target_gcc.sh
bash src/decomp/scripts/promote_esqiff_jmptbl_string_compare_n_target_gcc.sh
bash src/decomp/scripts/promote_esqiff_jmptbl_string_compare_nocase_n_target_gcc.sh
bash src/decomp/scripts/promote_esqiff_jmptbl_math_divs32_target_gcc.sh
bash src/decomp/scripts/promote_esqiff_jmptbl_esq_noop_target_gcc.sh
bash src/decomp/scripts/promote_esqiff_jmptbl_memory_deallocate_memory_target_gcc.sh
bash src/decomp/scripts/promote_esqiff_jmptbl_esq_noop_006a_target_gcc.sh
bash src/decomp/scripts/promote_esqiff_jmptbl_esq_noop_0074_target_gcc.sh
bash src/decomp/scripts/promote_esqiff_jmptbl_memory_allocate_memory_target_gcc.sh
bash src/decomp/scripts/promote_esqiff_jmptbl_dos_open_file_with_mode_target_gcc.sh
bash src/decomp/scripts/promote_esqiff_jmptbl_math_mulu32_target_gcc.sh
bash src/decomp/scripts/promote_esqiff_jmptbl_diskio_reset_ctrl_input_state_if_idle_target_gcc.sh
bash src/decomp/scripts/promote_esqiff_jmptbl_diskio_get_filesize_from_handle_target_gcc.sh
bash src/decomp/scripts/promote_esqiff_jmptbl_diskio_force_ui_refresh_if_idle_target_gcc.sh
bash src/decomp/scripts/promote_esqiff_jmptbl_esq_inc_copper_lists_towards_targets_target_gcc.sh
bash src/decomp/scripts/promote_esqiff_jmptbl_esq_dec_copper_lists_primary_target_gcc.sh
bash src/decomp/scripts/promote_esqiff_jmptbl_ctasks_start_iff_task_process_target_gcc.sh
bash src/decomp/scripts/promote_esqiff_jmptbl_script_assert_ctrl_line_if_enabled_target_gcc.sh
bash src/decomp/scripts/promote_esqiff_jmptbl_esq_move_copper_entry_toward_start_target_gcc.sh
bash src/decomp/scripts/promote_esqiff_jmptbl_esq_move_copper_entry_toward_end_target_gcc.sh
bash src/decomp/scripts/promote_esqiff_jmptbl_brush_clone_brush_record_target_gcc.sh
bash src/decomp/scripts/promote_esqiff_jmptbl_brush_find_type3_brush_target_gcc.sh
bash src/decomp/scripts/promote_esqiff_jmptbl_brush_pop_brush_head_target_gcc.sh
bash src/decomp/scripts/promote_esqiff_jmptbl_brush_alloc_brush_node_target_gcc.sh
bash src/decomp/scripts/promote_esqiff_jmptbl_brush_find_brush_by_predicate_target_gcc.sh
bash src/decomp/scripts/promote_esqiff_jmptbl_brush_free_brush_list_target_gcc.sh
bash src/decomp/scripts/promote_esqiff_jmptbl_brush_select_brush_by_label_target_gcc.sh
bash src/decomp/scripts/promote_esqiff_jmptbl_textdisp_find_entry_index_by_wildcard_target_gcc.sh
bash src/decomp/scripts/promote_esqiff_jmptbl_textdisp_draw_channel_banner_target_gcc.sh
bash src/decomp/scripts/promote_esqiff_jmptbl_newgrid_validate_selection_code_target_gcc.sh
bash src/decomp/scripts/promote_esqiff_jmptbl_brush_populate_brush_list_target_gcc.sh
bash src/decomp/scripts/promote_esqiff_jmptbl_script_begin_banner_char_transition_target_gcc.sh
bash src/decomp/scripts/promote_esqiff_jmptbl_tliba3_build_display_context_for_view_mode_target_gcc.sh
bash src/decomp/scripts/promote_esqiff_jmptbl_brush_select_brush_slot_target_gcc.sh
bash src/decomp/scripts/promote_group_aw_jmptbl_tliba3_build_display_context_for_view_mode_target_gcc.sh
bash src/decomp/scripts/promote_group_aw_jmptbl_displib_apply_inline_alignment_padding_target_gcc.sh
bash src/decomp/scripts/promote_group_aw_jmptbl_esqiff_run_copper_rise_transition_target_gcc.sh
bash src/decomp/scripts/promote_group_aw_jmptbl_esqiff_run_copper_drop_transition_target_gcc.sh
bash src/decomp/scripts/promote_group_aw_jmptbl_displib_display_text_at_position_target_gcc.sh
bash src/decomp/scripts/promote_group_ad_jmptbl_tliba3_build_display_context_for_view_mode_target_gcc.sh
bash src/decomp/scripts/promote_group_aw_jmptbl_mem_move_target_gcc.sh
bash src/decomp/scripts/promote_group_aw_jmptbl_wdisp_sprintf_target_gcc.sh
bash src/decomp/scripts/promote_group_aw_jmptbl_esq_set_copper_effect_off_disable_highlight_target_gcc.sh
bash src/decomp/scripts/promote_group_aw_jmptbl_string_copy_pad_nul_target_gcc.sh
bash src/decomp/scripts/promote_group_as_jmptbl_str_find_char_ptr_target_gcc.sh
bash src/decomp/scripts/promote_group_as_jmptbl_esq_find_substring_case_fold_target_gcc.sh
bash src/decomp/scripts/promote_group_at_jmptbl_ed1_wait_for_flag_and_clear_bit0_target_gcc.sh
bash src/decomp/scripts/promote_group_at_jmptbl_dos_system_taglist_target_gcc.sh
bash src/decomp/scripts/promote_group_at_jmptbl_ed1_wait_for_flag_and_clear_bit1_target_gcc.sh
bash src/decomp/scripts/promote_group_au_jmptbl_brush_append_brush_node_target_gcc.sh
bash src/decomp/scripts/promote_group_au_jmptbl_brush_populate_brush_list_target_gcc.sh
bash src/decomp/scripts/promote_group_ax_jmptbl_format_raw_dofmt_with_scratch_buffer_target_gcc.sh
bash src/decomp/scripts/promote_group_az_jmptbl_esq_cold_reboot_target_gcc.sh
bash src/decomp/scripts/promote_group_aa_jmptbl_gcommand_find_path_separator_target_gcc.sh
bash src/decomp/scripts/promote_group_aa_jmptbl_graphics_alloc_raster_target_gcc.sh
bash src/decomp/scripts/promote_group_af_jmptbl_gcommand_save_brush_result_target_gcc.sh
bash src/decomp/scripts/promote_group_ai_jmptbl_newgrid_set_selection_markers_target_gcc.sh
bash src/decomp/scripts/promote_group_ai_jmptbl_str_find_char_ptr_target_gcc.sh
bash src/decomp/scripts/promote_group_ai_jmptbl_tliba1_draw_text_with_inset_segments_target_gcc.sh
bash src/decomp/scripts/promote_group_ai_jmptbl_format_format_to_buffer2_target_gcc.sh
bash src/decomp/scripts/promote_group_ai_jmptbl_str_skip_class3_chars_target_gcc.sh
bash src/decomp/scripts/promote_group_ai_jmptbl_string_append_at_null_target_gcc.sh
bash src/decomp/scripts/promote_group_ai_jmptbl_str_copy_until_any_delim_n_target_gcc.sh
bash src/decomp/scripts/promote_group_ab_jmptbl_esqpars_remove_group_entry_and_release_strings_target_gcc.sh
bash src/decomp/scripts/promote_group_ab_jmptbl_esqfunc_free_line_text_buffers_target_gcc.sh
bash src/decomp/scripts/promote_group_ab_jmptbl_esqiff_deallocate_ads_and_logo_lst_data_target_gcc.sh
bash src/decomp/scripts/promote_group_ab_jmptbl_ladfunc_free_banner_rect_entries_target_gcc.sh
bash src/decomp/scripts/promote_group_ab_jmptbl_unknown2_a_stub0_target_gcc.sh
bash src/decomp/scripts/promote_group_ab_jmptbl_newgrid_shutdown_grid_resources_target_gcc.sh
bash src/decomp/scripts/promote_group_ab_jmptbl_locavail_free_resource_chain_target_gcc.sh
bash src/decomp/scripts/promote_group_ab_jmptbl_graphics_free_raster_target_gcc.sh
bash src/decomp/scripts/promote_group_ab_jmptbl_iostdreq_free_target_gcc.sh
bash src/decomp/scripts/promote_group_ab_jmptbl_esqiff2_clear_line_head_tail_by_mode_target_gcc.sh
bash src/decomp/scripts/promote_group_ac_jmptbl_parseini_update_clock_from_rtc_target_gcc.sh
bash src/decomp/scripts/promote_group_ac_jmptbl_esqfunc_draw_diagnostics_screen_target_gcc.sh
bash src/decomp/scripts/promote_group_ac_jmptbl_esqfunc_draw_memory_status_screen_target_gcc.sh
bash src/decomp/scripts/promote_group_ac_jmptbl_script_update_ctrl_state_machine_target_gcc.sh
bash src/decomp/scripts/promote_group_ac_jmptbl_gcommand_update_banner_bounds_target_gcc.sh
bash src/decomp/scripts/promote_group_ac_jmptbl_script_update_ctrl_line_timeout_target_gcc.sh
bash src/decomp/scripts/promote_group_ac_jmptbl_script_clear_ctrl_line_if_enabled_target_gcc.sh
bash src/decomp/scripts/promote_group_ac_jmptbl_esqfunc_free_extra_title_text_pointers_target_gcc.sh
bash src/decomp/scripts/promote_group_ac_jmptbl_esqdisp_draw_status_banner_target_gcc.sh
bash src/decomp/scripts/promote_group_ac_jmptbl_dst_update_banner_queue_target_gcc.sh
bash src/decomp/scripts/promote_group_ac_jmptbl_dst_refresh_banner_buffer_target_gcc.sh
bash src/decomp/scripts/promote_group_ac_jmptbl_esqfunc_draw_esc_menu_version_target_gcc.sh
bash src/decomp/scripts/promote_group_ac_jmptbl_parseini_adjust_hours_to24_hr_format_target_gcc.sh
bash src/decomp/scripts/promote_group_ae_jmptbl_tliba_find_first_wildcard_match_index_target_gcc.sh
bash src/decomp/scripts/promote_group_ae_jmptbl_script_build_token_index_map_target_gcc.sh
bash src/decomp/scripts/promote_group_ae_jmptbl_esqdisp_get_entry_aux_pointer_by_mode_target_gcc.sh
bash src/decomp/scripts/promote_group_ae_jmptbl_esqdisp_get_entry_pointer_by_mode_target_gcc.sh
bash src/decomp/scripts/promote_group_ae_jmptbl_ladfunc_parse_hex_digit_target_gcc.sh
bash src/decomp/scripts/promote_group_ae_jmptbl_script_deallocate_buffer_array_target_gcc.sh
bash src/decomp/scripts/promote_group_ae_jmptbl_wdisp_s_printf_target_gcc.sh
bash src/decomp/scripts/promote_group_ae_jmptbl_script_allocate_buffer_array_target_gcc.sh
bash src/decomp/scripts/promote_group_ae_jmptbl_textdisp_compute_time_offset_target_gcc.sh
bash src/decomp/scripts/promote_group_ae_jmptbl_esqpars_replace_owned_string_target_gcc.sh
bash src/decomp/scripts/promote_group_ah_jmptbl_esqiff2_apply_incoming_status_packet_target_gcc.sh
bash src/decomp/scripts/promote_group_ah_jmptbl_newgrid_rebuild_index_cache_target_gcc.sh
bash src/decomp/scripts/promote_group_ah_jmptbl_esqshared_apply_program_title_text_filters_target_gcc.sh
bash src/decomp/scripts/promote_group_ah_jmptbl_esqdisp_update_status_mask_and_refresh_target_gcc.sh
bash src/decomp/scripts/promote_group_ah_jmptbl_esqshared_init_entry_defaults_target_gcc.sh
bash src/decomp/scripts/promote_group_ah_jmptbl_gcommand_load_ppv_template_target_gcc.sh
bash src/decomp/scripts/promote_group_ah_jmptbl_locavail_save_availability_data_file_target_gcc.sh
bash src/decomp/scripts/promote_group_ah_jmptbl_gcommand_load_command_file_target_gcc.sh
bash src/decomp/scripts/promote_group_ah_jmptbl_esq_wildcard_match_target_gcc.sh
bash src/decomp/scripts/promote_group_ah_jmptbl_p_type_write_promo_id_data_file_target_gcc.sh
bash src/decomp/scripts/promote_group_ah_jmptbl_esqfunc_wait_for_clock_change_and_service_ui_target_gcc.sh
bash src/decomp/scripts/promote_group_ah_jmptbl_esq_test_bit1_based_target_gcc.sh
bash src/decomp/scripts/promote_group_ah_jmptbl_esqiff2_show_attention_overlay_target_gcc.sh
bash src/decomp/scripts/promote_group_ah_jmptbl_str_find_any_char_ptr_target_gcc.sh
bash src/decomp/scripts/promote_group_ah_jmptbl_gcommand_load_mplex_file_target_gcc.sh
bash src/decomp/scripts/promote_group_ah_jmptbl_script_read_serial_rbf_byte_target_gcc.sh
bash src/decomp/scripts/promote_group_ah_jmptbl_esqpars_clear_alias_string_pointers_target_gcc.sh
bash src/decomp/scripts/promote_group_ah_jmptbl_parse_read_signed_long_skip_class3_target_gcc.sh
bash src/decomp/scripts/promote_group_aj_jmptbl_string_find_substring_target_gcc.sh
bash src/decomp/scripts/promote_group_aj_jmptbl_format_raw_dofmt_with_scratch_buffer_target_gcc.sh
bash src/decomp/scripts/promote_group_aj_jmptbl_math_div_u32_target_gcc.sh
bash src/decomp/scripts/promote_group_aj_jmptbl_parseini_write_rtc_from_globals_target_gcc.sh
bash src/decomp/scripts/promote_group_aj_jmptbl_math_mulu32_target_gcc.sh
bash src/decomp/scripts/promote_group_ak_jmptbl_script_update_serial_shadow_from_ctrl_byte_target_gcc.sh
bash src/decomp/scripts/promote_group_ak_jmptbl_tliba3_select_next_view_mode_target_gcc.sh
bash src/decomp/scripts/promote_group_ak_jmptbl_parseini_parse_ini_buffer_and_dispatch_target_gcc.sh
bash src/decomp/scripts/promote_group_ak_jmptbl_textdisp_format_entry_time_for_index_target_gcc.sh
bash src/decomp/scripts/promote_group_ak_jmptbl_gcommand_get_banner_char_target_gcc.sh
bash src/decomp/scripts/promote_group_ak_jmptbl_esqpars_apply_rtc_bytes_and_persist_target_gcc.sh
bash src/decomp/scripts/promote_group_ak_jmptbl_parseini_write_error_log_entry_target_gcc.sh
bash src/decomp/scripts/promote_group_ak_jmptbl_parseini_scan_logo_directory_target_gcc.sh
bash src/decomp/scripts/promote_group_ak_jmptbl_script_deassert_ctrl_line_now_target_gcc.sh
bash src/decomp/scripts/promote_group_ak_jmptbl_esq_set_copper_effect_default_target_gcc.sh
bash src/decomp/scripts/promote_group_ak_jmptbl_esq_set_copper_effect_custom_target_gcc.sh
bash src/decomp/scripts/promote_group_ak_jmptbl_cleanup_render_aligned_status_screen_target_gcc.sh
bash src/decomp/scripts/promote_group_ak_jmptbl_esq_set_copper_effect_all_on_target_gcc.sh
bash src/decomp/scripts/promote_group_ak_jmptbl_script_assert_ctrl_line_now_target_gcc.sh
bash src/decomp/scripts/promote_group_ak_jmptbl_tliba3_draw_view_mode_guides_target_gcc.sh
bash src/decomp/scripts/promote_group_ak_jmptbl_gcommand_copy_gfx_to_work_if_available_target_gcc.sh
bash src/decomp/scripts/promote_newgrid2_jmptbl_bevel_draw_bevel_frame_with_top_right_target_gcc.sh
bash src/decomp/scripts/promote_newgrid2_jmptbl_bevel_draw_vertical_bevel_target_gcc.sh
bash src/decomp/scripts/promote_newgrid2_jmptbl_bevel_draw_bevel_frame_with_top_target_gcc.sh
bash src/decomp/scripts/promote_newgrid2_jmptbl_bevel_draw_beveled_frame_target_gcc.sh
bash src/decomp/scripts/promote_newgrid2_jmptbl_bevel_draw_vertical_bevel_pair_target_gcc.sh
bash src/decomp/scripts/promote_newgrid2_jmptbl_bevel_draw_horizontal_bevel_target_gcc.sh
bash src/decomp/scripts/promote_newgrid2_jmptbl_coi_select_anim_field_pointer_target_gcc.sh
bash src/decomp/scripts/promote_newgrid2_jmptbl_disptext_set_current_line_index_target_gcc.sh
bash src/decomp/scripts/promote_newgrid2_jmptbl_disptext_layout_and_append_to_buffer_target_gcc.sh
bash src/decomp/scripts/promote_newgrid2_jmptbl_disptext_get_total_line_count_target_gcc.sh
bash src/decomp/scripts/promote_newgrid2_jmptbl_tliba_find_first_wildcard_match_index_target_gcc.sh
bash src/decomp/scripts/promote_newgrid2_jmptbl_disptext_build_layout_for_source_target_gcc.sh
bash src/decomp/scripts/promote_newgrid2_jmptbl_esqdisp_get_entry_aux_pointer_by_mode_target_gcc.sh
bash src/decomp/scripts/promote_newgrid2_jmptbl_disptext_layout_source_to_lines_target_gcc.sh
bash src/decomp/scripts/promote_newgrid2_jmptbl_cleanup_update_entry_flag_bytes_target_gcc.sh
bash src/decomp/scripts/promote_newgrid2_jmptbl_coi_render_clock_format_entry_variant_target_gcc.sh
bash src/decomp/scripts/promote_newgrid2_jmptbl_esqdisp_test_entry_bits0_and2_target_gcc.sh
bash src/decomp/scripts/promote_newgrid2_jmptbl_disptext_compute_visible_line_count_target_gcc.sh
bash src/decomp/scripts/promote_newgrid2_jmptbl_esqdisp_get_entry_pointer_by_mode_target_gcc.sh
bash src/decomp/scripts/promote_newgrid2_jmptbl_disptext_render_current_line_target_gcc.sh
bash src/decomp/scripts/promote_newgrid2_jmptbl_coi_process_entry_selection_state_target_gcc.sh
bash src/decomp/scripts/promote_newgrid2_jmptbl_cleanup_format_clock_format_entry_target_gcc.sh
bash src/decomp/scripts/promote_newgrid2_jmptbl_esq_get_half_hour_slot_index_target_gcc.sh
bash src/decomp/scripts/promote_newgrid2_jmptbl_str_skip_class3_chars_target_gcc.sh
bash src/decomp/scripts/promote_newgrid2_jmptbl_string_append_n_target_gcc.sh
bash src/decomp/scripts/promote_newgrid2_jmptbl_esqdisp_compute_schedule_offset_for_row_target_gcc.sh
bash src/decomp/scripts/promote_newgrid2_jmptbl_parse_read_signed_long_skip_class3_alt_target_gcc.sh
bash src/decomp/scripts/promote_newgrid2_jmptbl_cleanup_test_entry_flag_y_and_bit1_target_gcc.sh
bash src/decomp/scripts/promote_newgrid2_jmptbl_disptext_is_current_line_last_target_gcc.sh
bash src/decomp/scripts/promote_newgrid2_jmptbl_disptext_is_last_line_selected_target_gcc.sh
bash src/decomp/scripts/promote_newgrid2_jmptbl_displib_find_previous_valid_entry_index_target_gcc.sh
bash src/decomp/scripts/promote_newgrid2_jmptbl_disptext_compute_marker_widths_target_gcc.sh
bash src/decomp/scripts/promote_newgrid2_jmptbl_esq_test_bit1_based_target_gcc.sh
bash src/decomp/scripts/promote_newgrid2_jmptbl_disptext_measure_current_line_length_target_gcc.sh
bash src/decomp/scripts/promote_newgrid2_jmptbl_disptext_set_layout_params_target_gcc.sh
bash src/decomp/scripts/promote_newgrid2_jmptbl_disptext_has_multiple_lines_target_gcc.sh
bash src/decomp/scripts/promote_newgrid2_jmptbl_bevel_draw_horizontal_bevel_target_gcc.sh
bash src/decomp/scripts/promote_group_av_jmptbl_allocate_alloc_and_initialize_iostdreq_target_gcc.sh
bash src/decomp/scripts/promote_group_av_jmptbl_signal_create_msgport_with_signal_target_gcc.sh
bash src/decomp/scripts/promote_group_av_jmptbl_diskio_probe_drives_and_assign_paths_target_gcc.sh
bash src/decomp/scripts/promote_group_av_jmptbl_esq_invoke_gcommand_init_target_gcc.sh
bash src/decomp/scripts/promote_group_av_jmptbl_exec_call_vector_48_target_gcc.sh
bash src/decomp/scripts/promote_group_ad_jmptbl_textdisp_draw_channel_banner_target_gcc.sh
bash src/decomp/scripts/promote_group_ad_jmptbl_textdisp_format_entry_time_target_gcc.sh
bash src/decomp/scripts/promote_group_ad_jmptbl_tliba3_get_view_mode_height_target_gcc.sh
bash src/decomp/scripts/promote_group_ad_jmptbl_tliba3_get_view_mode_rast_port_target_gcc.sh
bash src/decomp/scripts/promote_tliba3_jmptbl_gcommand_applyhighlightflag_target_gcc.sh
bash src/decomp/scripts/promote_tliba2_jmptbl_dst_addtimeoffset_target_gcc.sh
bash src/decomp/scripts/promote_tliba2_jmptbl_esq_testbit1based_target_gcc.sh
bash src/decomp/scripts/promote_tliba1_jmptbl_coi_getanimfieldpointerbymode_target_gcc.sh
bash src/decomp/scripts/promote_tliba1_jmptbl_esqdisp_getentryauxpointerbymode_target_gcc.sh
bash src/decomp/scripts/promote_tliba1_jmptbl_ladfunc_extractlownibble_target_gcc.sh
bash src/decomp/scripts/promote_tliba1_jmptbl_esqdisp_getentrypointerbymode_target_gcc.sh
bash src/decomp/scripts/promote_tliba1_jmptbl_coi_testentrywithintimewindow_target_gcc.sh
bash src/decomp/scripts/promote_tliba1_jmptbl_cleanup_formatclockformatentry_target_gcc.sh
bash src/decomp/scripts/promote_tliba1_jmptbl_esqdisp_computescheduleoffsetforrow_target_gcc.sh
bash src/decomp/scripts/promote_tliba1_jmptbl_esq_findsubstringcasefold_target_gcc.sh
bash src/decomp/scripts/promote_tliba1_jmptbl_displib_findpreviousvalidentryindex_target_gcc.sh
bash src/decomp/scripts/promote_tliba1_jmptbl_ladfunc_extracthighnibble_target_gcc.sh
bash src/decomp/scripts/promote_parseini2_jmptbl_battclock_getsecondsfrombatterybackedclock_target_gcc.sh
bash src/decomp/scripts/promote_parseini2_jmptbl_battclock_writesecondstobatterybackedclock_target_gcc.sh
bash src/decomp/scripts/promote_parseini2_jmptbl_datetime_isleapyear_target_gcc.sh
bash src/decomp/scripts/promote_parseini2_jmptbl_clock_secondsfromepoch_target_gcc.sh
bash src/decomp/scripts/promote_parseini2_jmptbl_clock_checkdateorsecondsfromepoch_target_gcc.sh
bash src/decomp/scripts/promote_parseini2_jmptbl_clock_convertamigasecondstoclockdata_target_gcc.sh
bash src/decomp/scripts/promote_parseini2_jmptbl_esq_calcdayofyearfrommonthday_target_gcc.sh
bash src/decomp/scripts/promote_script2_jmptbl_esq_capturectrlbit4streambufferbyte_target_gcc.sh
bash src/decomp/scripts/promote_script2_jmptbl_esq_readserialrbfbyte_target_gcc.sh
bash src/decomp/scripts/promote_p_type_jmptbl_string_findsubstring_target_gcc.sh
bash src/decomp/scripts/promote_textdisp2_jmptbl_locavail_getfilterwindowhalfspan_target_gcc.sh
bash src/decomp/scripts/promote_textdisp2_jmptbl_ladfunc_drawentrypreview_target_gcc.sh
bash src/decomp/scripts/promote_textdisp2_jmptbl_esqiff_runpendingcopperanimations_target_gcc.sh
bash src/decomp/scripts/promote_textdisp2_jmptbl_esqiff_playnextexternalassetframe_target_gcc.sh
bash src/decomp/scripts/promote_script_jmptbl_memory_deallocatememory_target_gcc.sh
bash src/decomp/scripts/promote_script_jmptbl_diskio_writebufferedbytes_target_gcc.sh
bash src/decomp/scripts/promote_script_jmptbl_diskio_closebufferedfileandflush_target_gcc.sh
bash src/decomp/scripts/promote_script_jmptbl_memory_allocatememory_target_gcc.sh
bash src/decomp/scripts/promote_script_jmptbl_diskio_openfilewithbuffer_target_gcc.sh
bash src/decomp/scripts/promote_wdisp_jmptbl_esqiff_restorebasepalettetriples_target_gcc.sh
bash src/decomp/scripts/promote_wdisp_jmptbl_esqfunc_trimtexttopixelwidthwordboundary_target_gcc.sh
bash src/decomp/scripts/promote_wdisp_jmptbl_gcommand_expandpresetblock_target_gcc.sh
bash src/decomp/scripts/promote_wdisp_jmptbl_esqiff_queueiffbrushload_target_gcc.sh
bash src/decomp/scripts/promote_wdisp_jmptbl_esqiff_runcopperdroptransition_target_gcc.sh
bash src/decomp/scripts/promote_wdisp_jmptbl_brush_findbrushbypredicate_target_gcc.sh
bash src/decomp/scripts/promote_wdisp_jmptbl_brush_freebrushlist_target_gcc.sh
bash src/decomp/scripts/promote_wdisp_jmptbl_brush_planemaskforindex_target_gcc.sh
bash src/decomp/scripts/promote_wdisp_jmptbl_esq_setcoppereffect_onenablehighlight_target_gcc.sh
bash src/decomp/scripts/promote_wdisp_jmptbl_esqiff_renderweatherstatusbrushslice_target_gcc.sh
bash src/decomp/scripts/promote_wdisp_jmptbl_brush_selectbrushslot_target_gcc.sh
bash src/decomp/scripts/promote_wdisp_jmptbl_newgrid_drawwrappedtext_target_gcc.sh
bash src/decomp/scripts/promote_wdisp_jmptbl_newgrid_resetrowtable_target_gcc.sh
bash src/decomp/scripts/promote_newgrid_jmptbl_math_divs32_target_gcc.sh
bash src/decomp/scripts/promote_newgrid_jmptbl_datetime_secondstostruct_target_gcc.sh
bash src/decomp/scripts/promote_newgrid_jmptbl_generate_grid_date_string_target_gcc.sh
bash src/decomp/scripts/promote_newgrid_jmptbl_memory_deallocatememory_target_gcc.sh
bash src/decomp/scripts/promote_newgrid_jmptbl_cleanup_drawclockformatlist_target_gcc.sh
bash src/decomp/scripts/promote_newgrid_jmptbl_disptext_freebuffers_target_gcc.sh
bash src/decomp/scripts/promote_newgrid_jmptbl_cleanup_drawclockbanner_target_gcc.sh
bash src/decomp/scripts/promote_newgrid_jmptbl_memory_allocatememory_target_gcc.sh
bash src/decomp/scripts/promote_newgrid_jmptbl_disptext_initbuffers_target_gcc.sh
bash src/decomp/scripts/promote_newgrid_jmptbl_cleanup_drawclockformatframe_target_gcc.sh
bash src/decomp/scripts/promote_newgrid_jmptbl_datetime_normalizestructtoseconds_target_gcc.sh
bash src/decomp/scripts/promote_newgrid_jmptbl_str_copyuntilanydelimn_target_gcc.sh
bash src/decomp/scripts/promote_newgrid_jmptbl_wdisp_updateselectionpreviewpanel_target_gcc.sh
bash src/decomp/scripts/promote_newgrid_jmptbl_math_mulu32_target_gcc.sh
bash src/decomp/scripts/promote_parseini_jmptbl_brush_allocbrushnode_target_gcc.sh
bash src/decomp/scripts/promote_parseini_jmptbl_brush_freebrushlist_target_gcc.sh
bash src/decomp/scripts/promote_parseini_jmptbl_brush_freebrushresources_target_gcc.sh
bash src/decomp/scripts/promote_parseini_jmptbl_esqfunc_rebuildpwbrushlistfromtagtablefromtagtable_target_gcc.sh
bash src/decomp/scripts/promote_parseini_jmptbl_gcommand_findpathseparator_target_gcc.sh
bash src/decomp/scripts/promote_parseini_jmptbl_diskio_consumelinefromworkbuffer_target_gcc.sh
bash src/decomp/scripts/promote_parseini_jmptbl_diskio2_parseinifilefromdisk_target_gcc.sh
bash src/decomp/scripts/promote_parseini_jmptbl_diskio_loadfiletoworkbuffer_target_gcc.sh
bash src/decomp/scripts/promote_parseini_jmptbl_ed1_drawdiagnosticsscreen_target_gcc.sh
bash src/decomp/scripts/promote_parseini_jmptbl_ed1_enterescmenu_target_gcc.sh
bash src/decomp/scripts/promote_parseini_jmptbl_ed1_exitescmenu_target_gcc.sh
bash src/decomp/scripts/promote_parseini_jmptbl_ed1_waitforflagandclearbit0_target_gcc.sh
bash src/decomp/scripts/promote_parseini_jmptbl_ed1_waitforflagandclearbit1_target_gcc.sh
bash src/decomp/scripts/promote_parseini_jmptbl_esqfunc_drawescmenuversion_target_gcc.sh
bash src/decomp/scripts/promote_parseini_jmptbl_esqiff_queueiffbrushload_target_gcc.sh
bash src/decomp/scripts/promote_parseini_jmptbl_esqiff_handlebrushinireloadhotkey_target_gcc.sh
bash src/decomp/scripts/promote_parseini_jmptbl_esqpars_replaceownedstring_target_gcc.sh
bash src/decomp/scripts/promote_parseini_jmptbl_gcommand_initpresettablefrompalette_target_gcc.sh
bash src/decomp/scripts/promote_parseini_jmptbl_gcommand_validatepresettable_target_gcc.sh
bash src/decomp/scripts/promote_parseini_jmptbl_handle_openwithmode_target_gcc.sh
bash src/decomp/scripts/promote_parseini_jmptbl_stream_readlinewithlimit_target_gcc.sh
bash src/decomp/scripts/promote_parseini_jmptbl_string_appendatnull_target_gcc.sh
bash src/decomp/scripts/promote_parseini_jmptbl_string_comparenocase_target_gcc.sh
bash src/decomp/scripts/promote_parseini_jmptbl_string_comparenocasen_target_gcc.sh
bash src/decomp/scripts/promote_parseini_jmptbl_str_findanycharptr_target_gcc.sh
bash src/decomp/scripts/promote_parseini_jmptbl_str_findcharptr_target_gcc.sh
bash src/decomp/scripts/promote_parseini_jmptbl_unknown36_finalizerequest_target_gcc.sh
bash src/decomp/scripts/promote_parseini_jmptbl_wdisp_sprintf_target_gcc.sh
bash src/decomp/scripts/promote_script3_jmptbl_cleanup_renderalignedstatusscreen_target_gcc.sh
bash src/decomp/scripts/promote_script3_jmptbl_locavail_computefilteroffsetforentry_target_gcc.sh
bash src/decomp/scripts/promote_script3_jmptbl_math_mulu32_target_gcc.sh
bash src/decomp/scripts/promote_script3_jmptbl_math_divs32_target_gcc.sh
bash src/decomp/scripts/promote_script3_jmptbl_locavail_setfiltermodeandresetstate_target_gcc.sh
bash src/decomp/scripts/promote_script3_jmptbl_string_copypadnul_target_gcc.sh
bash src/decomp/scripts/promote_script3_jmptbl_string_comparen_target_gcc.sh
bash src/decomp/scripts/promote_script3_jmptbl_esqdisp_updatestatusmaskandrefresh_target_gcc.sh
bash src/decomp/scripts/promote_script3_jmptbl_gcommand_getbannerchar_target_gcc.sh
bash src/decomp/scripts/promote_script3_jmptbl_ladfunc_parsehexdigit_target_gcc.sh
bash src/decomp/scripts/promote_script3_jmptbl_esqpars_applyrtcbytesandpersist_target_gcc.sh
bash src/decomp/scripts/promote_script3_jmptbl_parse_readsignedlongskipclass3_alt_target_gcc.sh
bash src/decomp/scripts/promote_script3_jmptbl_gcommand_adjustbannercopperoffset_target_gcc.sh
bash src/decomp/scripts/promote_script3_jmptbl_esq_setcoppereffect_custom_target_gcc.sh
bash src/decomp/scripts/promote_script3_jmptbl_esqshared_applyprogramtitletextfilters_target_gcc.sh
bash src/decomp/scripts/promote_script3_jmptbl_locavail_updatefilterstatemachine_target_gcc.sh
bash src/decomp/scripts/promote_parseini_compute_htc_max_values_target_gcc.sh
bash src/decomp/scripts/promote_parseini_update_ctrl_h_delta_max_target_gcc.sh
bash src/decomp/scripts/promote_parseini_check_ctrl_h_change_target_gcc.sh
bash src/decomp/scripts/promote_parseini_monitor_clock_change_target_gcc.sh
bash src/decomp/scripts/promote_parseini_write_error_log_entry_target_gcc.sh
bash src/decomp/scripts/promote_parseini_test_memory_and_open_topaz_font_target_gcc.sh
bash src/decomp/scripts/promote_parseini_parse_hex_value_from_string_target_gcc.sh
bash src/decomp/scripts/promote_parseini_parse_range_key_value_target_gcc.sh
bash src/decomp/scripts/promote_parseini_load_weather_message_strings_target_gcc.sh
bash src/decomp/scripts/promote_parseini_load_weather_strings_target_gcc.sh
bash src/decomp/scripts/promote_parseini_parse_color_table_target_gcc.sh
bash src/decomp/scripts/promote_parseini_handle_font_command_target_gcc.sh
bash src/decomp/scripts/promote_parseini_process_weather_blocks_target_gcc.sh
bash src/decomp/scripts/promote_parseini_scan_logo_directory_target_gcc.sh
bash src/decomp/scripts/promote_parseini_parse_ini_buffer_and_dispatch_target_gcc.sh
bash src/decomp/scripts/promote_parseini_adjust_hours_to24_hr_format_target_gcc.sh
bash src/decomp/scripts/promote_parseini_normalize_clock_data_target_gcc.sh
bash src/decomp/scripts/promote_parseini_write_rtc_from_globals_target_gcc.sh
bash src/decomp/scripts/promote_parseini_update_clock_from_rtc_target_gcc.sh
bash src/decomp/scripts/promote_script_reset_banner_char_defaults_target_gcc.sh
bash src/decomp/scripts/promote_script_get_banner_char_or_fallback_target_gcc.sh
bash src/decomp/scripts/promote_script_draw_inset_text_with_frame_target_gcc.sh
bash src/decomp/scripts/promote_script_setup_highlight_effect_target_gcc.sh
bash src/decomp/scripts/promote_bevel_draw_bevel_frame_with_top_target_gcc.sh
bash src/decomp/scripts/promote_bevel_draw_beveled_frame_target_gcc.sh
bash src/decomp/scripts/promote_bevel_draw_bevel_frame_with_top_right_target_gcc.sh
bash src/decomp/scripts/promote_bevel_draw_vertical_bevel_target_gcc.sh
bash src/decomp/scripts/promote_bevel_draw_vertical_bevel_pair_target_gcc.sh
bash src/decomp/scripts/promote_bevel_draw_horizontal_bevel_target_gcc.sh
bash src/decomp/scripts/promote_script_check_path_exists_target_gcc.sh
bash src/decomp/scripts/promote_script_update_banner_char_transition_target_gcc.sh
bash src/decomp/scripts/promote_script_prime_banner_transition_from_hex_code_target_gcc.sh
bash src/decomp/scripts/promote_script_init_ctrl_context_target_gcc.sh
bash src/decomp/scripts/promote_script_set_ctrl_context_mode_target_gcc.sh
bash src/decomp/scripts/promote_script_reset_ctrl_context_and_clear_status_line_target_gcc.sh
bash src/decomp/scripts/promote_script_load_ctrl_context_snapshot_target_gcc.sh
bash src/decomp/scripts/promote_script_save_ctrl_context_snapshot_target_gcc.sh
bash src/decomp/scripts/promote_script_reset_ctrl_context_target_gcc.sh
bash src/decomp/scripts/promote_script_clear_search_texts_and_channels_target_gcc.sh
bash src/decomp/scripts/promote_script_update_runtime_mode_for_playback_cursor_target_gcc.sh
bash src/decomp/scripts/promote_script_select_playback_cursor_from_search_text_target_gcc.sh
bash src/decomp/scripts/promote_generate_grid_date_string_target_gcc.sh
bash src/decomp/scripts/promote_script_apply_pending_banner_target_target_gcc.sh
bash src/decomp/scripts/promote_script_split_and_normalize_search_buffer_target_gcc.sh
bash src/decomp/scripts/promote_script_dispatch_playback_cursor_command_target_gcc.sh
bash src/decomp/scripts/promote_script_process_ctrl_context_playback_tick_target_gcc.sh
bash src/decomp/scripts/promote_script_handle_brush_command_target_gcc.sh
bash src/decomp/scripts/promote_esq_return_with_stack_code_target_gcc.sh
bash src/decomp/scripts/promote_esq_shutdown_and_return_target_gcc.sh
bash src/decomp/scripts/promote_esq_check_available_fast_memory_target_gcc.sh
bash src/decomp/scripts/promote_esq_check_compatible_video_chip_target_gcc.sh
bash src/decomp/scripts/promote_esq_format_disk_error_message_target_gcc.sh
bash src/decomp/scripts/promote_tliba2_find_last_char_in_string_target_gcc.sh
bash src/decomp/scripts/promote_tliba2_resolve_entry_window_with_default_range_target_gcc.sh
bash src/decomp/scripts/promote_tliba_find_first_wildcard_match_index_target_gcc.sh
bash src/decomp/scripts/promote_alloc_alloc_from_free_list_target_gcc.sh
bash src/decomp/scripts/promote_alloc_insert_free_block_target_gcc.sh
bash src/decomp/scripts/promote_group_ad_jmptbl_datetime_normalize_month_range_target_gcc.sh
bash src/decomp/scripts/promote_group_ad_jmptbl_datetime_adjust_month_index_target_gcc.sh
bash src/decomp/scripts/promote_group_ad_jmptbl_script_update_serial_shadow_from_ctrl_byte_target_gcc.sh
bash src/decomp/scripts/promote_group_ad_jmptbl_esqiff_run_copper_rise_transition_target_gcc.sh
bash src/decomp/scripts/promote_group_ad_jmptbl_textdisp_build_entry_short_name_target_gcc.sh
bash src/decomp/scripts/promote_group_ad_jmptbl_graphics_blt_bit_map_rast_port_target_gcc.sh
bash src/decomp/scripts/promote_group_ad_jmptbl_esqiff_run_copper_drop_transition_target_gcc.sh
bash src/decomp/scripts/promote_group_ad_jmptbl_tliba1_build_clock_format_entry_if_visible_target_gcc.sh
bash src/decomp/scripts/promote_group_ad_jmptbl_textdisp_build_channel_label_target_gcc.sh
bash src/decomp/scripts/promote_group_ad_jmptbl_textdisp_draw_inset_rect_frame_target_gcc.sh
bash src/decomp/scripts/promote_group_ad_jmptbl_textdisp_trim_text_to_pixel_width_target_gcc.sh
bash src/decomp/scripts/promote_group_ad_jmptbl_esqfunc_select_and_apply_brush_for_current_entry_target_gcc.sh
bash src/decomp/scripts/promote_group_ad_jmptbl_dst_compute_banner_index_target_gcc.sh
bash src/decomp/scripts/promote_group_main_a_jmptbl_esq_main_exit_noop_hook_target_gcc.sh
bash src/decomp/scripts/promote_group_main_a_jmptbl_esq_main_entry_noop_hook_target_gcc.sh
bash src/decomp/scripts/promote_group_main_a_jmptbl_memlist_free_all_target_gcc.sh
bash src/decomp/scripts/promote_group_main_a_jmptbl_esq_parse_command_line_and_run_target_gcc.sh
bash src/decomp/scripts/promote_group_al_jmptbl_ladfunc_pack_nibbles_to_byte_target_gcc.sh
bash src/decomp/scripts/promote_group_al_jmptbl_ladfunc_extract_low_nibble_target_gcc.sh
bash src/decomp/scripts/promote_group_al_jmptbl_ladfunc_update_entry_buffers_for_ad_index_target_gcc.sh
bash src/decomp/scripts/promote_group_al_jmptbl_esq_write_dec_fixed_width_target_gcc.sh
bash src/decomp/scripts/promote_group_al_jmptbl_ladfunc_build_entry_buffers_or_default_target_gcc.sh
bash src/decomp/scripts/promote_group_al_jmptbl_ladfunc_extract_high_nibble_target_gcc.sh
bash src/decomp/scripts/promote_group_ay_jmptbl_diskio_consume_cstring_from_work_buffer_target_gcc.sh
bash src/decomp/scripts/promote_group_ay_jmptbl_diskio_parse_long_from_work_buffer_target_gcc.sh
bash src/decomp/scripts/promote_group_ay_jmptbl_diskio_write_decimal_field_target_gcc.sh
bash src/decomp/scripts/promote_group_ay_jmptbl_diskio_write_buffered_bytes_target_gcc.sh
bash src/decomp/scripts/promote_group_ay_jmptbl_diskio_close_buffered_file_and_flush_target_gcc.sh
bash src/decomp/scripts/promote_group_ay_jmptbl_string_compare_nocase_n_target_gcc.sh
bash src/decomp/scripts/promote_group_ay_jmptbl_math_mulu32_target_gcc.sh
bash src/decomp/scripts/promote_group_ay_jmptbl_diskio_load_file_to_work_buffer_target_gcc.sh
bash src/decomp/scripts/promote_group_ay_jmptbl_script_read_ciab_bit5_mask_target_gcc.sh
bash src/decomp/scripts/promote_group_ay_jmptbl_diskio_open_file_with_buffer_target_gcc.sh
bash src/decomp/scripts/promote_group_aa_jmptbl_string_compare_nocase_target_gcc.sh
bash src/decomp/scripts/promote_group_aa_jmptbl_string_compare_n_target_gcc.sh
bash src/decomp/scripts/promote_group_ar_jmptbl_parseini_write_error_log_entry_target_gcc.sh
bash src/decomp/scripts/promote_group_ar_jmptbl_string_append_at_null_target_gcc.sh
bash src/decomp/scripts/promote_group_main_b_jmptbl_dos_delay_target_gcc.sh
bash src/decomp/scripts/promote_group_main_b_jmptbl_stream_buffered_write_string_target_gcc.sh
bash src/decomp/scripts/promote_group_main_b_jmptbl_math_mulu32_target_gcc.sh
bash src/decomp/scripts/promote_group_main_b_jmptbl_buffer_flush_all_and_close_with_code_target_gcc.sh
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
- Targets 004/005/006/007/008/009/010/011/012/013/014/015/016/017/018/019/020/021/022/023/024/025/026/027/028/029/030/031/032/033/034/035/036/037/038/039/040/041/042/043/044/045/046/047/048/049/050/051/052/053/054/055/056/057/058/059/060/061/062/063/064/065/066/067/068/069/070/071/072/073/074/075/076/077/078/079/080/081/082/083/084/085/086/087/088/089/090/091/092/093/094/095/096/097/098/099/100/101/102/103/104/105/106/107/108/109/110/111/112/113/114/115/116/117/118/119/120/121/122/123/124/125/126/127/128/129/130/131/132/133/134/135/136/137/138/139/140/141/142/143/144/145/146/147: `-O1 -m68000 -ffreestanding -fno-builtin -fno-inline -fomit-frame-pointer`
- Targets 148/149/150/151/152/153/154/155/156/157/158/159/160/161/162/163/164/165/166/167/168/169/170/171/172/173/174/175/176/177/178/179/180/181/182/183/184/185/186/187/188/189/190/191/192/193/194/195/196/197/198/199/200/201/202/203/204/205/206/207/208/209/210/211/212/213/214/215/216/217/218/219/220/221/222/223/224/225/226/227/228/229/230/231/232/233/234/235/236/237/238/239/240/241/242/243/244/245/246/247/248/249/250/251/252/253/254/255/256/257/258/259/260/261/262/263/264/265/266/267/268/269/270/271/272/273/274/275/276/277/278/279/280/281/282/283/284/285/286/287/288/289/290/291/292/293/294/295/296/297/298/299/300/301/302/303/304/305/306/307/308/309/310/311/312/313/314/315/316/317/318/319/320/321/322/323/324/325/326/327/328/329/330/331/332/333/334/335/336/337/338/339/340/341/342/343/344/345/346/347/348/349/350/351/352/353/354/355/356/357/358/359/360/361/362/363/364/365/366/367/368/369/370/371/372/373/374/375/376/377/378/379/380/381/382/383/384/385/386/387/388/389/390/391/392/393/394/395/396/397/398: `-O1 -m68000 -ffreestanding -fno-builtin -fno-inline -fomit-frame-pointer`

Recent promoted targets:
- Target 894 (`ESQFUNC_DrawDiagnosticsScreen`):
- compare: `src/decomp/scripts/compare_esqfunc_draw_diagnostics_screen_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqfunc_draw_diagnostics_screen.awk`
- promote: `src/decomp/scripts/promote_esqfunc_draw_diagnostics_screen_target_gcc.sh`
- Target 895 (`ESQIFF_RunCopperRiseTransition`):
- compare: `src/decomp/scripts/compare_esqiff_run_copper_rise_transition_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff_run_copper_rise_transition.awk`
- promote: `src/decomp/scripts/promote_esqiff_run_copper_rise_transition_target_gcc.sh`
- Target 896 (`ESQIFF_RunCopperDropTransition`):
- compare: `src/decomp/scripts/compare_esqiff_run_copper_drop_transition_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff_run_copper_drop_transition.awk`
- promote: `src/decomp/scripts/promote_esqiff_run_copper_drop_transition_target_gcc.sh`
- Target 897 (`ESQIFF_RunPendingCopperAnimations`):
- compare: `src/decomp/scripts/compare_esqiff_run_pending_copper_animations_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff_run_pending_copper_animations.awk`
- promote: `src/decomp/scripts/promote_esqiff_run_pending_copper_animations_target_gcc.sh`
- Target 898 (`ESQIFF_RestoreBasePaletteTriples`):
- compare: `src/decomp/scripts/compare_esqiff_restore_base_palette_triples_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff_restore_base_palette_triples.awk`
- promote: `src/decomp/scripts/promote_esqiff_restore_base_palette_triples_target_gcc.sh`
- Target 899 (`ESQIFF_ServicePendingCopperPaletteMoves`):
- compare: `src/decomp/scripts/compare_esqiff_service_pending_copper_palette_moves_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff_service_pending_copper_palette_moves.awk`
- promote: `src/decomp/scripts/promote_esqiff_service_pending_copper_palette_moves_target_gcc.sh`
- Target 900 (`ESQIFF_SetApenToBrightestPaletteIndex`):
- compare: `src/decomp/scripts/compare_esqiff_set_apen_to_brightest_palette_index_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff_set_apen_to_brightest_palette_index.awk`
- promote: `src/decomp/scripts/promote_esqiff_set_apen_to_brightest_palette_index_target_gcc.sh`
- Target 901 (`ESQIFF_HandleBrushIniReloadHotkey`):
- compare: `src/decomp/scripts/compare_esqiff_handle_brush_ini_reload_hotkey_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff_handle_brush_ini_reload_hotkey.awk`
- promote: `src/decomp/scripts/promote_esqiff_handle_brush_ini_reload_hotkey_target_gcc.sh`
- Target 902 (`ESQIFF_DeallocateAdsAndLogoLstData`):
- compare: `src/decomp/scripts/compare_esqiff_deallocate_ads_and_logo_lst_data_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff_deallocate_ads_and_logo_lst_data.awk`
- promote: `src/decomp/scripts/promote_esqiff_deallocate_ads_and_logo_lst_data_target_gcc.sh`
- Target 903 (`ESQIFF_QueueIffBrushLoad`):
- compare: `src/decomp/scripts/compare_esqiff_queue_iff_brush_load_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff_queue_iff_brush_load.awk`
- promote: `src/decomp/scripts/promote_esqiff_queue_iff_brush_load_target_gcc.sh`
- Target 904 (`ESQIFF_ReadNextExternalAssetPathEntry`):
- compare: `src/decomp/scripts/compare_esqiff_read_next_external_asset_path_entry_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff_read_next_external_asset_path_entry.awk`
- promote: `src/decomp/scripts/promote_esqiff_read_next_external_asset_path_entry_target_gcc.sh`
- Target 905 (`ESQIFF_ReloadExternalAssetCatalogBuffers`):
- compare: `src/decomp/scripts/compare_esqiff_reload_external_asset_catalog_buffers_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff_reload_external_asset_catalog_buffers.awk`
- promote: `src/decomp/scripts/promote_esqiff_reload_external_asset_catalog_buffers_target_gcc.sh`
- Target 906 (`ESQIFF_RenderWeatherStatusBrushSlice`):
- compare: `src/decomp/scripts/compare_esqiff_render_weather_status_brush_slice_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff_render_weather_status_brush_slice.awk`
- promote: `src/decomp/scripts/promote_esqiff_render_weather_status_brush_slice_target_gcc.sh`
- Target 907 (`ESQIFF_DrawWeatherStatusOverlayIntoBrush`):
- compare: `src/decomp/scripts/compare_esqiff_draw_weather_status_overlay_into_brush_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff_draw_weather_status_overlay_into_brush.awk`
- promote: `src/decomp/scripts/promote_esqiff_draw_weather_status_overlay_into_brush_target_gcc.sh`
- Target 908 (`ESQIFF_QueueNextExternalAssetIffJob`):
- compare: `src/decomp/scripts/compare_esqiff_queue_next_external_asset_iff_job_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff_queue_next_external_asset_iff_job.awk`
- promote: `src/decomp/scripts/promote_esqiff_queue_next_external_asset_iff_job_target_gcc.sh`
- Target 909 (`ESQIFF_ServiceExternalAssetSourceState`):
- compare: `src/decomp/scripts/compare_esqiff_service_external_asset_source_state_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff_service_external_asset_source_state.awk`
- promote: `src/decomp/scripts/promote_esqiff_service_external_asset_source_state_target_gcc.sh`
- Target 910 (`ESQIFF_PlayNextExternalAssetFrame_Return`):
- compare: `src/decomp/scripts/compare_esqiff_play_next_external_asset_frame_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff_play_next_external_asset_frame_return.awk`
- promote: `src/decomp/scripts/promote_esqiff_play_next_external_asset_frame_return_target_gcc.sh`
- Target 911 (`ESQIFF_ShowExternalAssetWithCopperFx_Return`):
- compare: `src/decomp/scripts/compare_esqiff_show_external_asset_with_copper_fx_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff_show_external_asset_with_copper_fx_return.awk`
- promote: `src/decomp/scripts/promote_esqiff_show_external_asset_with_copper_fx_return_target_gcc.sh`
- Target 912 (`ESQIFF_PlayNextExternalAssetFrame`):
- compare: `src/decomp/scripts/compare_esqiff_play_next_external_asset_frame_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff_play_next_external_asset_frame.awk`
- promote: `src/decomp/scripts/promote_esqiff_play_next_external_asset_frame_target_gcc.sh`
- Target 913 (`ESQIFF_ShowExternalAssetWithCopperFx`):
- compare: `src/decomp/scripts/compare_esqiff_show_external_asset_with_copper_fx_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff_show_external_asset_with_copper_fx.awk`
- promote: `src/decomp/scripts/promote_esqiff_show_external_asset_with_copper_fx_target_gcc.sh`
- Target 914 (`ESQIFF2_ValidateAsciiNumericByte`):
- compare: `src/decomp/scripts/compare_esqiff2_validate_ascii_numeric_byte_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff2_validate_ascii_numeric_byte.awk`
- promote: `src/decomp/scripts/promote_esqiff2_validate_ascii_numeric_byte_target_gcc.sh`
- Target 915 (`ESQIFF2_ApplyIncomingStatusPacket_Return`):
- compare: `src/decomp/scripts/compare_esqiff2_apply_incoming_status_packet_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff2_apply_incoming_status_packet_return.awk`
- promote: `src/decomp/scripts/promote_esqiff2_apply_incoming_status_packet_return_target_gcc.sh`
- Target 916 (`ESQIFF2_ReadSerialBytesToBuffer_Return`):
- compare: `src/decomp/scripts/compare_esqiff2_read_serial_bytes_to_buffer_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff2_read_serial_bytes_to_buffer_return.awk`
- promote: `src/decomp/scripts/promote_esqiff2_read_serial_bytes_to_buffer_return_target_gcc.sh`
- Target 917 (`ESQIFF2_ReadSerialBytesWithXor_Return`):
- compare: `src/decomp/scripts/compare_esqiff2_read_serial_bytes_with_xor_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff2_read_serial_bytes_with_xor_return.awk`
- promote: `src/decomp/scripts/promote_esqiff2_read_serial_bytes_with_xor_return_target_gcc.sh`
- Target 918 (`ESQIFF2_ValidateFieldIndexAndLength_Return`):
- compare: `src/decomp/scripts/compare_esqiff2_validate_field_index_and_length_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff2_validate_field_index_and_length_return.awk`
- promote: `src/decomp/scripts/promote_esqiff2_validate_field_index_and_length_return_target_gcc.sh`
- Target 919 (`ESQIFF2_PadEntriesToMaxTitleWidth_Return`):
- compare: `src/decomp/scripts/compare_esqiff2_pad_entries_to_max_title_width_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff2_pad_entries_to_max_title_width_return.awk`
- promote: `src/decomp/scripts/promote_esqiff2_pad_entries_to_max_title_width_return_target_gcc.sh`
- Target 920 (`ESQIFF2_ParseLineHeadTailRecord_Return`):
- compare: `src/decomp/scripts/compare_esqiff2_parse_line_head_tail_record_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff2_parse_line_head_tail_record_return.awk`
- promote: `src/decomp/scripts/promote_esqiff2_parse_line_head_tail_record_return_target_gcc.sh`
- Target 921 (`ESQIFF2_ParseGroupRecordAndRefresh_Return`):
- compare: `src/decomp/scripts/compare_esqiff2_parse_group_record_and_refresh_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff2_parse_group_record_and_refresh_return.awk`
- promote: `src/decomp/scripts/promote_esqiff2_parse_group_record_and_refresh_return_target_gcc.sh`
- Target 922 (`ESQIFF2_ReadSerialRecordIntoBuffer_Return`):
- compare: `src/decomp/scripts/compare_esqiff2_read_serial_record_into_buffer_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff2_read_serial_record_into_buffer_return.awk`
- promote: `src/decomp/scripts/promote_esqiff2_read_serial_record_into_buffer_return_target_gcc.sh`
- Target 923 (`ESQIFF2_ReadSerialSizedTextRecord_Return`):
- compare: `src/decomp/scripts/compare_esqiff2_read_serial_sized_text_record_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff2_read_serial_sized_text_record_return.awk`
- promote: `src/decomp/scripts/promote_esqiff2_read_serial_sized_text_record_return_target_gcc.sh`
- Target 924 (`ESQIFF2_ShowVersionMismatchOverlay_Return`):
- compare: `src/decomp/scripts/compare_esqiff2_show_version_mismatch_overlay_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff2_show_version_mismatch_overlay_return.awk`
- promote: `src/decomp/scripts/promote_esqiff2_show_version_mismatch_overlay_return_target_gcc.sh`
- Target 925 (`ESQIFF2_ShowAttentionOverlay_Return`):
- compare: `src/decomp/scripts/compare_esqiff2_show_attention_overlay_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff2_show_attention_overlay_return.awk`
- promote: `src/decomp/scripts/promote_esqiff2_show_attention_overlay_return_target_gcc.sh`
- Target 926 (`ESQIFF2_ClearPrimaryEntryFlags34To39_Return`):
- compare: `src/decomp/scripts/compare_esqiff2_clear_primary_entry_flags34_to39_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff2_clear_primary_entry_flags34_to39_return.awk`
- promote: `src/decomp/scripts/promote_esqiff2_clear_primary_entry_flags34_to39_return_target_gcc.sh`
- Target 927 (`ESQIFF2_ClearPrimaryEntryFlags34To39`):
- compare: `src/decomp/scripts/compare_esqiff2_clear_primary_entry_flags34_to39_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff2_clear_primary_entry_flags34_to39.awk`
- promote: `src/decomp/scripts/promote_esqiff2_clear_primary_entry_flags34_to39_target_gcc.sh`
- Target 928 (`ESQIFF2_ReadRbfBytesToBuffer`):
- compare: `src/decomp/scripts/compare_esqiff2_read_rbf_bytes_to_buffer_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff2_read_rbf_bytes_to_buffer.awk`
- promote: `src/decomp/scripts/promote_esqiff2_read_rbf_bytes_to_buffer_target_gcc.sh`
- Target 929 (`ESQIFF2_ReadRbfBytesWithXor`):
- compare: `src/decomp/scripts/compare_esqiff2_read_rbf_bytes_with_xor_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff2_read_rbf_bytes_with_xor.awk`
- promote: `src/decomp/scripts/promote_esqiff2_read_rbf_bytes_with_xor_target_gcc.sh`
- Target 930 (`ESQIFF2_ValidateFieldIndexAndLength`):
- compare: `src/decomp/scripts/compare_esqiff2_validate_field_index_and_length_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff2_validate_field_index_and_length.awk`
- promote: `src/decomp/scripts/promote_esqiff2_validate_field_index_and_length_target_gcc.sh`
- Target 931 (`ESQIFF2_ClearLineHeadTailByMode`):
- compare: `src/decomp/scripts/compare_esqiff2_clear_line_head_tail_by_mode_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff2_clear_line_head_tail_by_mode.awk`
- promote: `src/decomp/scripts/promote_esqiff2_clear_line_head_tail_by_mode_target_gcc.sh`
- Target 932 (`ESQIFF2_ApplyIncomingStatusPacket`):
- compare: `src/decomp/scripts/compare_esqiff2_apply_incoming_status_packet_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff2_apply_incoming_status_packet.awk`
- promote: `src/decomp/scripts/promote_esqiff2_apply_incoming_status_packet_target_gcc.sh`
- Target 933 (`ESQIFF2_PadEntriesToMaxTitleWidth`):
- compare: `src/decomp/scripts/compare_esqiff2_pad_entries_to_max_title_width_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff2_pad_entries_to_max_title_width.awk`
- promote: `src/decomp/scripts/promote_esqiff2_pad_entries_to_max_title_width_target_gcc.sh`
- Target 934 (`ESQIFF2_ReadSerialSizedTextRecord`):
- compare: `src/decomp/scripts/compare_esqiff2_read_serial_sized_text_record_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff2_read_serial_sized_text_record.awk`
- promote: `src/decomp/scripts/promote_esqiff2_read_serial_sized_text_record_target_gcc.sh`
- Target 935 (`ESQIFF2_ReadSerialRecordIntoBuffer`):
- compare: `src/decomp/scripts/compare_esqiff2_read_serial_record_into_buffer_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff2_read_serial_record_into_buffer.awk`
- promote: `src/decomp/scripts/promote_esqiff2_read_serial_record_into_buffer_target_gcc.sh`
- Target 936 (`ESQIFF2_ParseLineHeadTailRecord`):
- compare: `src/decomp/scripts/compare_esqiff2_parse_line_head_tail_record_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff2_parse_line_head_tail_record.awk`
- promote: `src/decomp/scripts/promote_esqiff2_parse_line_head_tail_record_target_gcc.sh`
- Target 937 (`ESQIFF2_ParseGroupRecordAndRefresh`):
- compare: `src/decomp/scripts/compare_esqiff2_parse_group_record_and_refresh_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff2_parse_group_record_and_refresh.awk`
- promote: `src/decomp/scripts/promote_esqiff2_parse_group_record_and_refresh_target_gcc.sh`
- Target 938 (`ESQIFF2_ShowVersionMismatchOverlay`):
- compare: `src/decomp/scripts/compare_esqiff2_show_version_mismatch_overlay_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff2_show_version_mismatch_overlay.awk`
- promote: `src/decomp/scripts/promote_esqiff2_show_version_mismatch_overlay_target_gcc.sh`
- Target 939 (`ESQIFF2_ShowAttentionOverlay`):
- compare: `src/decomp/scripts/compare_esqiff2_show_attention_overlay_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqiff2_show_attention_overlay.awk`
- promote: `src/decomp/scripts/promote_esqiff2_show_attention_overlay_target_gcc.sh`
- Target 940 (`PARSE_ReadSignedLong_ParseLoopEntry`):
- compare: `src/decomp/scripts/compare_parse_readsignedlong_parse_loop_entry_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_parse_readsignedlong_parse_loop_entry.awk`
- promote: `src/decomp/scripts/promote_parse_readsignedlong_parse_loop_entry_target_gcc.sh`
- Target 941 (`PARSE_ReadSignedLong_NegateValue`):
- compare: `src/decomp/scripts/compare_parse_readsignedlong_negate_value_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_parse_readsignedlong_negate_value.awk`
- promote: `src/decomp/scripts/promote_parse_readsignedlong_negate_value_target_gcc.sh`
- Target 942 (`PARSE_ReadSignedLong_ParseDone`):
- compare: `src/decomp/scripts/compare_parse_readsignedlong_parse_done_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_parse_readsignedlong_parse_done.awk`
- promote: `src/decomp/scripts/promote_parse_readsignedlong_parse_done_target_gcc.sh`
- Target 943 (`PARSE_ReadSignedLong_StoreResult`):
- compare: `src/decomp/scripts/compare_parse_readsignedlong_store_result_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_parse_readsignedlong_store_result.awk`
- promote: `src/decomp/scripts/promote_parse_readsignedlong_store_result_target_gcc.sh`
- Target 944 (`DISKIO1_AdvanceTimeSlotBitIndex`):
- compare: `src/decomp/scripts/compare_diskio1_advance_time_slot_bit_index_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_diskio1_advance_time_slot_bit_index.awk`
- promote: `src/decomp/scripts/promote_diskio1_advance_time_slot_bit_index_target_gcc.sh`
- Target 945 (`DISKIO1_AdvanceBlackoutBitIndex`):
- compare: `src/decomp/scripts/compare_diskio1_advance_blackout_bit_index_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_diskio1_advance_blackout_bit_index.awk`
- promote: `src/decomp/scripts/promote_diskio1_advance_blackout_bit_index_target_gcc.sh`
- Target 946 (`DISKIO1_AppendTimeSlotMaskValueTerminator`):
- compare: `src/decomp/scripts/compare_diskio1_append_time_slot_mask_value_terminator_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_diskio1_append_time_slot_mask_value_terminator.awk`
- promote: `src/decomp/scripts/promote_diskio1_append_time_slot_mask_value_terminator_target_gcc.sh`
- Target 947 (`DISKIO1_AppendBlackoutMaskValueTerminator`):
- compare: `src/decomp/scripts/compare_diskio1_append_blackout_mask_value_terminator_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_diskio1_append_blackout_mask_value_terminator.awk`
- promote: `src/decomp/scripts/promote_diskio1_append_blackout_mask_value_terminator_target_gcc.sh`
- Target 948 (`DISKIO1_AppendTimeSlotMaskValueHeader`):
- compare: `src/decomp/scripts/compare_diskio1_append_time_slot_mask_value_header_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_diskio1_append_time_slot_mask_value_header.awk`
- promote: `src/decomp/scripts/promote_diskio1_append_time_slot_mask_value_header_target_gcc.sh`
- Target 949 (`DISKIO1_AppendBlackoutMaskValueHeader`):
- compare: `src/decomp/scripts/compare_diskio1_append_blackout_mask_value_header_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_diskio1_append_blackout_mask_value_header.awk`
- promote: `src/decomp/scripts/promote_diskio1_append_blackout_mask_value_header_target_gcc.sh`
- Target 950 (`DISKIO1_AccumulateTimeSlotMaskSum`):
- compare: `src/decomp/scripts/compare_diskio1_accumulate_time_slot_mask_sum_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_diskio1_accumulate_time_slot_mask_sum.awk`
- promote: `src/decomp/scripts/promote_diskio1_accumulate_time_slot_mask_sum_target_gcc.sh`
- Target 951 (`DISKIO1_AccumulateBlackoutMaskSum`):
- compare: `src/decomp/scripts/compare_diskio1_accumulate_blackout_mask_sum_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_diskio1_accumulate_blackout_mask_sum.awk`
- promote: `src/decomp/scripts/promote_diskio1_accumulate_blackout_mask_sum_target_gcc.sh`
- Target 952 (`DISKIO1_AppendTimeSlotMaskNoneIfAllBitsSet`):
- compare: `src/decomp/scripts/compare_diskio1_append_time_slot_mask_none_if_all_bits_set_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_diskio1_append_time_slot_mask_none_if_all_bits_set.awk`
- promote: `src/decomp/scripts/promote_diskio1_append_time_slot_mask_none_if_all_bits_set_target_gcc.sh`
- Target 953 (`DISKIO1_AppendBlackoutMaskNoneIfEmpty`):
- compare: `src/decomp/scripts/compare_diskio1_append_blackout_mask_none_if_empty_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_diskio1_append_blackout_mask_none_if_empty.awk`
- promote: `src/decomp/scripts/promote_diskio1_append_blackout_mask_none_if_empty_target_gcc.sh`
- Target 954 (`DISKIO1_AppendTimeSlotMaskOffAirIfEmpty`):
- compare: `src/decomp/scripts/compare_diskio1_append_time_slot_mask_off_air_if_empty_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_diskio1_append_time_slot_mask_off_air_if_empty.awk`
- promote: `src/decomp/scripts/promote_diskio1_append_time_slot_mask_off_air_if_empty_target_gcc.sh`
- Target 955 (`DISKIO1_AppendBlackoutMaskAllIfAllBitsSet`):
- compare: `src/decomp/scripts/compare_diskio1_append_blackout_mask_all_if_all_bits_set_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_diskio1_append_blackout_mask_all_if_all_bits_set.awk`
- promote: `src/decomp/scripts/promote_diskio1_append_blackout_mask_all_if_all_bits_set_target_gcc.sh`
- Target 956 (`DISKIO1_AppendAttrFlagHiliteSrc`):
- compare: `src/decomp/scripts/compare_diskio1_append_attr_flag_hilite_src_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_diskio1_append_attr_flag_hilite_src.awk`
- promote: `src/decomp/scripts/promote_diskio1_append_attr_flag_hilite_src_target_gcc.sh`
- Target 957 (`DISKIO1_AppendAttrFlagSummarySrc`):
- compare: `src/decomp/scripts/compare_diskio1_append_attr_flag_summary_src_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_diskio1_append_attr_flag_summary_src.awk`
- promote: `src/decomp/scripts/promote_diskio1_append_attr_flag_summary_src_target_gcc.sh`
- Target 958 (`DISKIO1_AppendAttrFlagVideoTagDisable`):
- compare: `src/decomp/scripts/compare_diskio1_append_attr_flag_video_tag_disable_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_diskio1_append_attr_flag_video_tag_disable.awk`
- promote: `src/decomp/scripts/promote_diskio1_append_attr_flag_video_tag_disable_target_gcc.sh`
- Target 959 (`DISKIO1_AppendAttrFlagPpvSrc`):
- compare: `src/decomp/scripts/compare_diskio1_append_attr_flag_ppv_src_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_diskio1_append_attr_flag_ppv_src.awk`
- promote: `src/decomp/scripts/promote_diskio1_append_attr_flag_ppv_src_target_gcc.sh`
- Target 960 (`DISKIO1_AppendAttrFlagDitto`):
- compare: `src/decomp/scripts/compare_diskio1_append_attr_flag_ditto_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_diskio1_append_attr_flag_ditto.awk`
- promote: `src/decomp/scripts/promote_diskio1_append_attr_flag_ditto_target_gcc.sh`
- Target 961 (`DISKIO1_AppendAttrFlagAltHiliteSrc`):
- compare: `src/decomp/scripts/compare_diskio1_append_attr_flag_alt_hilite_src_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_diskio1_append_attr_flag_alt_hilite_src.awk`
- promote: `src/decomp/scripts/promote_diskio1_append_attr_flag_alt_hilite_src_target_gcc.sh`
- Target 962 (`DISKIO1_AppendAttrFlagBit7`):
- compare: `src/decomp/scripts/compare_diskio1_append_attr_flag_bit7_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_diskio1_append_attr_flag_bit7.awk`
- promote: `src/decomp/scripts/promote_diskio1_append_attr_flag_bit7_target_gcc.sh`
- Target 963 (`ESQSHARED4_CopyLongwordBlockDbfLoop`):
- compare: `src/decomp/scripts/compare_esqshared4_copy_longword_block_dbf_loop_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqshared4_copy_longword_block_dbf_loop.awk`
- promote: `src/decomp/scripts/promote_esqshared4_copy_longword_block_dbf_loop_target_gcc.sh`
- Target 964 (`ESQSHARED4_ResetBannerColorToStart`):
- compare: `src/decomp/scripts/compare_esqshared4_reset_banner_color_to_start_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqshared4_reset_banner_color_to_start.awk`
- promote: `src/decomp/scripts/promote_esqshared4_reset_banner_color_to_start_target_gcc.sh`
- Target 965 (`ED1_ClearEscMenuMode`):
- compare: `src/decomp/scripts/compare_ed1_clear_esc_menu_mode_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_ed1_clear_esc_menu_mode.awk`
- promote: `src/decomp/scripts/promote_ed1_clear_esc_menu_mode_target_gcc.sh`
- Target 966 (`GCOMMAND_EnableHighlight`):
- compare: `src/decomp/scripts/compare_gcommand_enable_highlight_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_gcommand_enable_highlight.awk`
- promote: `src/decomp/scripts/promote_gcommand_enable_highlight_target_gcc.sh`
- Target 967 (`GCOMMAND_InitPresetDefaults`):
- compare: `src/decomp/scripts/compare_gcommand_init_preset_defaults_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_gcommand_init_preset_defaults.awk`
- promote: `src/decomp/scripts/promote_gcommand_init_preset_defaults_target_gcc.sh`
- Target 968 (`LOCAVAIL2_AutoRequestNoOp`):
- compare: `src/decomp/scripts/compare_locavail2_auto_request_no_op_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_locavail2_auto_request_no_op.awk`
- promote: `src/decomp/scripts/promote_locavail2_auto_request_no_op_target_gcc.sh`
- Target 969 (`ESQSHARED4_SetBannerColorBaseAndLimit`):
- compare: `src/decomp/scripts/compare_esqshared4_set_banner_color_base_and_limit_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqshared4_set_banner_color_base_and_limit.awk`
- promote: `src/decomp/scripts/promote_esqshared4_set_banner_color_base_and_limit_target_gcc.sh`
- Target 970 (`ESQSHARED4_ClearBannerWorkRasterWithOnes`):
- compare: `src/decomp/scripts/compare_esqshared4_clear_banner_work_raster_with_ones_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqshared4_clear_banner_work_raster_with_ones.awk`
- promote: `src/decomp/scripts/promote_esqshared4_clear_banner_work_raster_with_ones_target_gcc.sh`
- Target 971 (`GCOMMAND_GetBannerChar`):
- compare: `src/decomp/scripts/compare_gcommand_get_banner_char_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_gcommand_get_banner_char.awk`
- promote: `src/decomp/scripts/promote_gcommand_get_banner_char_target_gcc.sh`
- Target 972 (`GCOMMAND_AddBannerTableByteDelta`):
- compare: `src/decomp/scripts/compare_gcommand_add_banner_table_byte_delta_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_gcommand_add_banner_table_byte_delta.awk`
- promote: `src/decomp/scripts/promote_gcommand_add_banner_table_byte_delta_target_gcc.sh`
- Target 973 (`FORMAT_Buffer2WriteChar`):
- compare: `src/decomp/scripts/compare_format_buffer2_write_char_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_format_buffer2_write_char.awk`
- promote: `src/decomp/scripts/promote_format_buffer2_write_char_target_gcc.sh`
- Target 974 (`ESQSHARED4_SnapshotDisplayBufferBases`):
- compare: `src/decomp/scripts/compare_esqshared4_snapshot_display_buffer_bases_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqshared4_snapshot_display_buffer_bases.awk`
- promote: `src/decomp/scripts/promote_esqshared4_snapshot_display_buffer_bases_target_gcc.sh`
- Target 975 (`FORMAT_FormatToBuffer2`):
- compare: `src/decomp/scripts/compare_format_to_buffer2_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_format_to_buffer2.awk`
- promote: `src/decomp/scripts/promote_format_to_buffer2_target_gcc.sh`
- Target 976 (`ESQSHARED4_LoadDefaultPaletteToCopper_NoOp`):
- compare: `src/decomp/scripts/compare_esqshared4_load_default_palette_to_copper_noop_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqshared4_load_default_palette_to_copper_noop.awk`
- promote: `src/decomp/scripts/promote_esqshared4_load_default_palette_to_copper_noop_target_gcc.sh`
- Target 977 (`ESQSHARED4_ComputeBannerRowBlitGeometry`):
- compare: `src/decomp/scripts/compare_esqshared4_compute_banner_row_blit_geometry_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqshared4_compute_banner_row_blit_geometry.awk`
- promote: `src/decomp/scripts/promote_esqshared4_compute_banner_row_blit_geometry_target_gcc.sh`
- Target 978 (`ESQSHARED4_ResetBannerColorSweepState`):
- compare: `src/decomp/scripts/compare_esqshared4_reset_banner_color_sweep_state_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqshared4_reset_banner_color_sweep_state.awk`
- promote: `src/decomp/scripts/promote_esqshared4_reset_banner_color_sweep_state_target_gcc.sh`
- Target 979 (`ESQSHARED4_BindAndClearBannerWorkRaster`):
- compare: `src/decomp/scripts/compare_esqshared4_bind_and_clear_banner_work_raster_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqshared4_bind_and_clear_banner_work_raster.awk`
- promote: `src/decomp/scripts/promote_esqshared4_bind_and_clear_banner_work_raster_target_gcc.sh`
- Target 980 (`ESQSHARED4_CopyLivePlanesToSnapshot`):
- compare: `src/decomp/scripts/compare_esqshared4_copy_live_planes_to_snapshot_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqshared4_copy_live_planes_to_snapshot.awk`
- promote: `src/decomp/scripts/promote_esqshared4_copy_live_planes_to_snapshot_target_gcc.sh`
- Target 981 (`ESQSHARED4_ProgramDisplayWindowAndCopper`):
- compare: `src/decomp/scripts/compare_esqshared4_program_display_window_and_copper_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqshared4_program_display_window_and_copper.awk`
- promote: `src/decomp/scripts/promote_esqshared4_program_display_window_and_copper_target_gcc.sh`
- Target 982 (`ESQSHARED4_InitializeBannerCopperSystem`):
- compare: `src/decomp/scripts/compare_esqshared4_initialize_banner_copper_system_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqshared4_initialize_banner_copper_system.awk`
- promote: `src/decomp/scripts/promote_esqshared4_initialize_banner_copper_system_target_gcc.sh`
- Target 983 (`ESQSHARED4_CopyPlanesFromContextToSnapshot`):
- compare: `src/decomp/scripts/compare_esqshared4_copy_planes_from_context_to_snapshot_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqshared4_copy_planes_from_context_to_snapshot.awk`
- promote: `src/decomp/scripts/promote_esqshared4_copy_planes_from_context_to_snapshot_target_gcc.sh`
- Target 984 (`ESQSHARED4_SetBannerCopperColorAndThreshold`):
- compare: `src/decomp/scripts/compare_esqshared4_set_banner_copper_color_and_threshold_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqshared4_set_banner_copper_color_and_threshold.awk`
- promote: `src/decomp/scripts/promote_esqshared4_set_banner_copper_color_and_threshold_target_gcc.sh`
- Target 985 (`ESQSHARED4_ApplyBannerColorStep_Return`):
- compare: `src/decomp/scripts/compare_esqshared4_apply_banner_color_step_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqshared4_apply_banner_color_step_return.awk`
- promote: `src/decomp/scripts/promote_esqshared4_apply_banner_color_step_return_target_gcc.sh`
- Target 986 (`ESQSHARED4_DecodeRgbNibbleTriplet`):
- compare: `src/decomp/scripts/compare_esqshared4_decode_rgb_nibble_triplet_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqshared4_decode_rgb_nibble_triplet.awk`
- promote: `src/decomp/scripts/promote_esqshared4_decode_rgb_nibble_triplet_target_gcc.sh`
- Target 987 (`ESQSHARED4_LoadCopperColorWordsFromNibbleTable`):
- compare: `src/decomp/scripts/compare_esqshared4_load_copper_color_words_from_nibble_table_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqshared4_load_copper_color_words_from_nibble_table.awk`
- promote: `src/decomp/scripts/promote_esqshared4_load_copper_color_words_from_nibble_table_target_gcc.sh`
- Target 988 (`ESQSHARED4_ApplyBannerColorStep`):
- compare: `src/decomp/scripts/compare_esqshared4_apply_banner_color_step_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqshared4_apply_banner_color_step.awk`
- promote: `src/decomp/scripts/promote_esqshared4_apply_banner_color_step_target_gcc.sh`
- Target 989 (`ESQSHARED4_CopyInterleavedRowWordsFromOffset`):
- compare: `src/decomp/scripts/compare_esqshared4_copy_interleaved_row_words_from_offset_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqshared4_copy_interleaved_row_words_from_offset.awk`
- promote: `src/decomp/scripts/promote_esqshared4_copy_interleaved_row_words_from_offset_target_gcc.sh`
- Target 990 (`ESQSHARED4_BlitBannerRowsForActiveField`):
- compare: `src/decomp/scripts/compare_esqshared4_blit_banner_rows_for_active_field_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqshared4_blit_banner_rows_for_active_field.awk`
- promote: `src/decomp/scripts/promote_esqshared4_blit_banner_rows_for_active_field_target_gcc.sh`
- Target 991 (`ESQSHARED4_SetupBannerPlanePointerWords`):
- compare: `src/decomp/scripts/compare_esqshared4_setup_banner_plane_pointer_words_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqshared4_setup_banner_plane_pointer_words.awk`
- promote: `src/decomp/scripts/promote_esqshared4_setup_banner_plane_pointer_words_target_gcc.sh`
- Target 992 (`ESQSHARED4_TickCopperAndBannerTransitions`):
- compare: `src/decomp/scripts/compare_esqshared4_tick_copper_and_banner_transitions_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqshared4_tick_copper_and_banner_transitions.awk`
- promote: `src/decomp/scripts/promote_esqshared4_tick_copper_and_banner_transitions_target_gcc.sh`
- Target 993 (`ESQSHARED4_CopyBannerRowsWithByteOffset`):
- compare: `src/decomp/scripts/compare_esqshared4_copy_banner_rows_with_byte_offset_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqshared4_copy_banner_rows_with_byte_offset.awk`
- promote: `src/decomp/scripts/promote_esqshared4_copy_banner_rows_with_byte_offset_target_gcc.sh`
- Target 994 (`DISKIO1_DumpDefaultCoiInfoBlock_Return`):
- compare: `src/decomp/scripts/compare_diskio1_dump_default_coi_info_block_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_diskio1_dump_default_coi_info_block_return.awk`
- promote: `src/decomp/scripts/promote_diskio1_dump_default_coi_info_block_return_target_gcc.sh`
- Target 995 (`DISKIO1_DumpProgramSourceRecordVerbose_Return`):
- compare: `src/decomp/scripts/compare_diskio1_dump_program_source_record_verbose_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_diskio1_dump_program_source_record_verbose_return.awk`
- promote: `src/decomp/scripts/promote_diskio1_dump_program_source_record_verbose_return_target_gcc.sh`
- Target 996 (`DISKIO1_DumpProgramInfoAttrTable_Return`):
- compare: `src/decomp/scripts/compare_diskio1_dump_program_info_attr_table_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_diskio1_dump_program_info_attr_table_return.awk`
- promote: `src/decomp/scripts/promote_diskio1_dump_program_info_attr_table_return_target_gcc.sh`
- Target 997 (`DISKIO_CloseBufferedFileAndFlush_Return`):
- compare: `src/decomp/scripts/compare_diskio_close_buffered_file_and_flush_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_diskio_close_buffered_file_and_flush_return.awk`
- promote: `src/decomp/scripts/promote_diskio_close_buffered_file_and_flush_return_target_gcc.sh`
- Target 998 (`DISKIO_WriteBufferedBytes_Return`):
- compare: `src/decomp/scripts/compare_diskio_write_buffered_bytes_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_diskio_write_buffered_bytes_return.awk`
- promote: `src/decomp/scripts/promote_diskio_write_buffered_bytes_return_target_gcc.sh`
- Target 999 (`DISKIO_EnsurePc1MountedAndGfxAssigned_Return`):
- compare: `src/decomp/scripts/compare_diskio_ensure_pc1_mounted_and_gfx_assigned_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_diskio_ensure_pc1_mounted_and_gfx_assigned_return.awk`
- promote: `src/decomp/scripts/promote_diskio_ensure_pc1_mounted_and_gfx_assigned_return_target_gcc.sh`
- Target 1000 (`DISKIO_SaveConfigToFileHandle_Return`):
- compare: `src/decomp/scripts/compare_diskio_save_config_to_file_handle_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_diskio_save_config_to_file_handle_return.awk`
- promote: `src/decomp/scripts/promote_diskio_save_config_to_file_handle_return_target_gcc.sh`
- Target 1001 (`ESQSHARED_MatchSelectionCodeWithOptionalSuffix_Return`):
- compare: `src/decomp/scripts/compare_esqshared_match_selection_code_with_optional_suffix_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqshared_match_selection_code_with_optional_suffix_return.awk`
- promote: `src/decomp/scripts/promote_esqshared_match_selection_code_with_optional_suffix_return_target_gcc.sh`
- Target 1002 (`ESQSHARED_CreateGroupEntryAndTitle_Return`):
- compare: `src/decomp/scripts/compare_esqshared_create_group_entry_and_title_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqshared_create_group_entry_and_title_return.awk`
- promote: `src/decomp/scripts/promote_esqshared_create_group_entry_and_title_return_target_gcc.sh`
- Target 1003 (`ESQSHARED_NormalizeInStereoTag_Return`):
- compare: `src/decomp/scripts/compare_esqshared_normalize_in_stereo_tag_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqshared_normalize_in_stereo_tag_return.awk`
- promote: `src/decomp/scripts/promote_esqshared_normalize_in_stereo_tag_return_target_gcc.sh`
- Target 1004 (`ESQSHARED_UpdateMatchingEntriesByTitle_Return`):
- compare: `src/decomp/scripts/compare_esqshared_update_matching_entries_by_title_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqshared_update_matching_entries_by_title_return.awk`
- promote: `src/decomp/scripts/promote_esqshared_update_matching_entries_by_title_return_target_gcc.sh`
- Target 1005 (`ESQPARS_RemoveGroupEntryAndReleaseStrings_Return`):
- compare: `src/decomp/scripts/compare_esqpars_remove_group_entry_and_release_strings_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqpars_remove_group_entry_and_release_strings_return.awk`
- promote: `src/decomp/scripts/promote_esqpars_remove_group_entry_and_release_strings_return_target_gcc.sh`
- Target 1006 (`ESQPARS_ReplaceOwnedString_Return`):
- compare: `src/decomp/scripts/compare_esqpars_replace_owned_string_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqpars_replace_owned_string_return.awk`
- promote: `src/decomp/scripts/promote_esqpars_replace_owned_string_return_target_gcc.sh`
- Target 1007 (`ESQPARS_ReadLengthWordWithChecksumXor_Return`):
- compare: `src/decomp/scripts/compare_esqpars_read_length_word_with_checksum_xor_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_esqpars_read_length_word_with_checksum_xor_return.awk`
- promote: `src/decomp/scripts/promote_esqpars_read_length_word_with_checksum_xor_return_target_gcc.sh`
- Target 1008 (`GCOMMAND_SetPresetEntry_Return`):
- compare: `src/decomp/scripts/compare_gcommand_set_preset_entry_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_gcommand_set_preset_entry_return.awk`
- promote: `src/decomp/scripts/promote_gcommand_set_preset_entry_return_target_gcc.sh`
- Target 1009 (`GCOMMAND_ExpandPresetBlock_Return`):
- compare: `src/decomp/scripts/compare_gcommand_expand_preset_block_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_gcommand_expand_preset_block_return.awk`
- promote: `src/decomp/scripts/promote_gcommand_expand_preset_block_return_target_gcc.sh`
- Target 1010 (`GCOMMAND_ValidatePresetTable_Return`):
- compare: `src/decomp/scripts/compare_gcommand_validate_preset_table_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_gcommand_validate_preset_table_return.awk`
- promote: `src/decomp/scripts/promote_gcommand_validate_preset_table_return_target_gcc.sh`
- Target 1011 (`GCOMMAND_InitPresetTableFromPalette_Return`):
- compare: `src/decomp/scripts/compare_gcommand_init_preset_table_from_palette_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_gcommand_init_preset_table_from_palette_return.awk`
- promote: `src/decomp/scripts/promote_gcommand_init_preset_table_from_palette_return_target_gcc.sh`
- Target 1012 (`GCOMMAND_UpdatePresetEntryCache_Return`):
- compare: `src/decomp/scripts/compare_gcommand_update_preset_entry_cache_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_gcommand_update_preset_entry_cache_return.awk`
- promote: `src/decomp/scripts/promote_gcommand_update_preset_entry_cache_return_target_gcc.sh`
- Target 1013 (`LADFUNC2_EmitEscapedStringWithLimit_Return`):
- compare: `src/decomp/scripts/compare_ladfunc2_emit_escaped_string_with_limit_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_ladfunc2_emit_escaped_string_with_limit_return.awk`
- promote: `src/decomp/scripts/promote_ladfunc2_emit_escaped_string_with_limit_return_target_gcc.sh`
- Target 1014 (`LADFUNC2_EmitEscapedStringChunked_Return`):
- compare: `src/decomp/scripts/compare_ladfunc2_emit_escaped_string_chunked_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_ladfunc2_emit_escaped_string_chunked_return.awk`
- promote: `src/decomp/scripts/promote_ladfunc2_emit_escaped_string_chunked_return_target_gcc.sh`
- Target 1015 (`LOCAVAIL_ParseFilterStateFromBuffer_Return`):
- compare: `src/decomp/scripts/compare_locavail_parse_filter_state_from_buffer_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_locavail_parse_filter_state_from_buffer_return.awk`
- promote: `src/decomp/scripts/promote_locavail_parse_filter_state_from_buffer_return_target_gcc.sh`
- Target 1016 (`LOCAVAIL_MapFilterTokenCharToClass_Return`):
- compare: `src/decomp/scripts/compare_locavail_map_filter_token_char_to_class_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_locavail_map_filter_token_char_to_class_return.awk`
- promote: `src/decomp/scripts/promote_locavail_map_filter_token_char_to_class_return_target_gcc.sh`
- Target 1017 (`LADFUNC_RepackEntryTextAndAttrBuffers_Return`):
- compare: `src/decomp/scripts/compare_ladfunc_repack_entry_text_and_attr_buffers_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_ladfunc_repack_entry_text_and_attr_buffers_return.awk`
- promote: `src/decomp/scripts/promote_ladfunc_repack_entry_text_and_attr_buffers_return_target_gcc.sh`
- Target 1018 (`LADFUNC_UpdateEntryFromTextAndAttrBuffers_Return`):
- compare: `src/decomp/scripts/compare_ladfunc_update_entry_from_text_and_attr_buffers_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_ladfunc_update_entry_from_text_and_attr_buffers_return.awk`
- promote: `src/decomp/scripts/promote_ladfunc_update_entry_from_text_and_attr_buffers_return_target_gcc.sh`
- Target 1019 (`LOCAVAIL_ComputeFilterOffsetForEntry_Return`):
- compare: `src/decomp/scripts/compare_locavail_compute_filter_offset_for_entry_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_locavail_compute_filter_offset_for_entry_return.awk`
- promote: `src/decomp/scripts/promote_locavail_compute_filter_offset_for_entry_return_target_gcc.sh`
- Target 1020 (`LOCAVAIL_SaveAvailabilityDataFile_Return`):
- compare: `src/decomp/scripts/compare_locavail_save_availability_data_file_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_locavail_save_availability_data_file_return.awk`
- promote: `src/decomp/scripts/promote_locavail_save_availability_data_file_return_target_gcc.sh`
- Target 1021 (`LOCAVAIL_LoadAvailabilityDataFile_Return`):
- compare: `src/decomp/scripts/compare_locavail_load_availability_data_file_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_locavail_load_availability_data_file_return.awk`
- promote: `src/decomp/scripts/promote_locavail_load_availability_data_file_return_target_gcc.sh`
- Target 1022 (`LOCAVAIL_UpdateFilterStateMachine_Return`):
- compare: `src/decomp/scripts/compare_locavail_update_filter_state_machine_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_locavail_update_filter_state_machine_return.awk`
- promote: `src/decomp/scripts/promote_locavail_update_filter_state_machine_return_target_gcc.sh`
- Target 1023 (`FLIB_AppendClockStampedLogEntry_Return`):
- compare: `src/decomp/scripts/compare_flib_append_clock_stamped_log_entry_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_flib_append_clock_stamped_log_entry_return.awk`
- promote: `src/decomp/scripts/promote_flib_append_clock_stamped_log_entry_return_target_gcc.sh`
- Target 1024 (`DISPLIB_FindPreviousValidEntryIndex_Return`):
- compare: `src/decomp/scripts/compare_displib_find_previous_valid_entry_index_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_displib_find_previous_valid_entry_index_return.awk`
- promote: `src/decomp/scripts/promote_displib_find_previous_valid_entry_index_return_target_gcc.sh`
- Target 1025 (`DISPLIB_ApplyInlineAlignmentPadding_Return`):
- compare: `src/decomp/scripts/compare_displib_apply_inline_alignment_padding_return_trial_gcc.sh`
- semantic: `src/decomp/scripts/semantic_filter_displib_apply_inline_alignment_padding_return.awk`
- promote: `src/decomp/scripts/promote_displib_apply_inline_alignment_padding_return_target_gcc.sh`
- Target 1026 (`DISKIO_DrawTransferErrorMessageIfDiagnostics`):
- compare: `src/decomp/scripts/compare_diskio_draw_transfer_error_message_if_diagnostics_trial_gcc.sh`
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio_draw_transfer_error_message_if_diagnostics_trial.sh`
- semantic: `src/decomp/scripts/semantic_filter_diskio_draw_transfer_error_message_if_diagnostics.awk`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio_draw_transfer_error_message_if_diagnostics.awk`
- promote: `src/decomp/scripts/promote_diskio_draw_transfer_error_message_if_diagnostics_target_gcc.sh`
- Target 1027 (`DISKIO_WriteBytesToOutputHandleGuarded`):
- compare: `src/decomp/scripts/compare_diskio_write_bytes_to_output_handle_guarded_trial_gcc.sh`
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio_write_bytes_to_output_handle_guarded_trial.sh`
- semantic: `src/decomp/scripts/semantic_filter_diskio_write_bytes_to_output_handle_guarded.awk`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio_write_bytes_to_output_handle_guarded.awk`
- promote: `src/decomp/scripts/promote_diskio_write_bytes_to_output_handle_guarded_target_gcc.sh`
- Target 1028 (`DISKIO_ForceUiRefreshIfIdle`):
- compare: `src/decomp/scripts/compare_diskio_force_ui_refresh_if_idle_trial_gcc.sh`
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio_force_ui_refresh_if_idle_trial.sh`
- semantic: `src/decomp/scripts/semantic_filter_diskio_force_ui_refresh_if_idle.awk`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio_force_ui_refresh_if_idle.awk`
- promote: `src/decomp/scripts/promote_diskio_force_ui_refresh_if_idle_target_gcc.sh`
- Target 1029 (`DISKIO_ResetCtrlInputStateIfIdle`):
- compare: `src/decomp/scripts/compare_diskio_reset_ctrl_input_state_if_idle_trial_gcc.sh`
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio_reset_ctrl_input_state_if_idle_trial.sh`
- semantic: `src/decomp/scripts/semantic_filter_diskio_reset_ctrl_input_state_if_idle.awk`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio_reset_ctrl_input_state_if_idle.awk`
- promote: `src/decomp/scripts/promote_diskio_reset_ctrl_input_state_if_idle_target_gcc.sh`
- Target 1030 (`DISKIO_EnsurePc1MountedAndGfxAssigned`):
- compare: `src/decomp/scripts/compare_diskio_ensure_pc1_mounted_and_gfx_assigned_trial_gcc.sh`
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio_ensure_pc1_mounted_and_gfx_assigned_trial.sh`
- semantic: `src/decomp/scripts/semantic_filter_diskio_ensure_pc1_mounted_and_gfx_assigned.awk`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio_ensure_pc1_mounted_and_gfx_assigned.awk`
- promote: `src/decomp/scripts/promote_diskio_ensure_pc1_mounted_and_gfx_assigned_target_gcc.sh`
- Target 1031 (`DISKIO_GetFilesizeFromHandle`):
- compare: `src/decomp/scripts/compare_diskio_get_filesize_from_handle_trial_gcc.sh`
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio_get_filesize_from_handle_trial.sh`
- semantic: `src/decomp/scripts/semantic_filter_diskio_get_filesize_from_handle.awk`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio_get_filesize_from_handle.awk`
- promote: `src/decomp/scripts/promote_diskio_get_filesize_from_handle_target_gcc.sh`
- Target 1032 (`DISKIO_WriteDecimalField`):
- compare: `src/decomp/scripts/compare_diskio_write_decimal_field_trial_gcc.sh`
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio_write_decimal_field_trial.sh`
- semantic: `src/decomp/scripts/semantic_filter_diskio_write_decimal_field.awk`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio_write_decimal_field.awk`
- promote: `src/decomp/scripts/promote_diskio_write_decimal_field_target_gcc.sh`
- Target 1033 (`DISKIO_QueryVolumeSoftErrorCount`):
- compare: `src/decomp/scripts/compare_diskio_query_volume_soft_error_count_trial_gcc.sh`
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio_query_volume_soft_error_count_trial.sh`
- semantic: `src/decomp/scripts/semantic_filter_diskio_query_volume_soft_error_count.awk`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio_query_volume_soft_error_count.awk`
- promote: `src/decomp/scripts/promote_diskio_query_volume_soft_error_count_target_gcc.sh`
- SAS/C-only lane (`DISKIO_ConsumeCStringFromWorkBuffer`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio_consume_cstring_from_work_buffer_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio_consume_cstring_from_work_buffer.awk`
- SAS/C-only lane (`DISKIO_ParseLongFromWorkBuffer`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio_parse_long_from_work_buffer_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio_parse_long_from_work_buffer.awk`
- SAS/C-only lane (`DISKIO_ConsumeLineFromWorkBuffer`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio_consume_line_from_work_buffer_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio_consume_line_from_work_buffer.awk`
- SAS/C-only lane (`DISKIO_LoadFileToWorkBuffer`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio_load_file_to_work_buffer_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio_load_file_to_work_buffer.awk`
- SAS/C-only lane (`DISKIO_OpenFileWithBuffer`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio_open_file_with_buffer_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio_open_file_with_buffer.awk`
- SAS/C-only lane (`DISKIO_QueryDiskUsagePercentAndSetBufferSize`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio_query_disk_usage_percent_and_set_buffer_size_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio_query_disk_usage_percent_and_set_buffer_size.awk`
- SAS/C-only lane (`DISKIO_WriteBufferedBytes`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio_write_buffered_bytes_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio_write_buffered_bytes.awk`
- SAS/C-only lane (`DISKIO_CloseBufferedFileAndFlush`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio_close_buffered_file_and_flush_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio_close_buffered_file_and_flush.awk`
- SAS/C-only lane (`DISKIO_LoadConfigFromDisk`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio_load_config_from_disk_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio_load_config_from_disk.awk`
- SAS/C-only lane (`DISKIO_SaveConfigToFileHandle`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio_save_config_to_file_handle_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio_save_config_to_file_handle.awk`
- SAS/C-only lane (`DISKIO_ParseConfigBuffer`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio_parse_config_buffer_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio_parse_config_buffer.awk`
- SAS/C-only lane (`DISKIO_CloseBufferedFileAndFlush_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio_close_buffered_file_and_flush_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio_return_stub.awk`
- SAS/C-only lane (`DISKIO_WriteBufferedBytes_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio_write_buffered_bytes_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio_return_stub.awk`
- SAS/C-only lane (`DISKIO_EnsurePc1MountedAndGfxAssigned_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio_ensure_pc1_mounted_and_gfx_assigned_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio_return_stub.awk`
- SAS/C-only lane (`DISKIO_SaveConfigToFileHandle_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio_save_config_to_file_handle_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio_return_stub.awk`
- SAS/C-only lane (`DISKIO_ProbeDrivesAndAssignPaths`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio_probe_drives_and_assign_paths_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio_probe_drives_and_assign_paths.awk`
- SAS/C-only lane (`DISKIO2_FlushDataFilesIfNeeded`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio2_flush_data_files_if_needed_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio2_flush_helper.awk`
- SAS/C-only lane (`DISKIO2_ReloadDataFilesAndRebuildIndex`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio2_reload_data_files_and_rebuild_index_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio2_reload_helper.awk`
- SAS/C-only lane (`DISKIO2_CopyAndSanitizeSlotString`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio2_copy_and_sanitize_slot_string_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio2_copy_sanitize_helper.awk`
- SAS/C-only lane (`DISKIO2_DisplayStatusLine`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio2_display_status_line_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio2_display_status_line.awk`
- SAS/C-only lane (`DISKIO2_RunDiskSyncWorkflow`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio2_run_disk_sync_workflow_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio2_run_disk_sync_workflow.awk`
- SAS/C-only lane (`DISKIO2_ParseIniFileFromDisk`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio2_parse_ini_file_from_disk_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio2_parse_ini_file_from_disk.awk`
- SAS/C-only lane (`DISKIO2_WriteOinfoDataFile`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio2_write_oinfo_data_file_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio2_write_oinfo_data_file.awk`
- SAS/C-only lane (`DISKIO2_LoadOinfoDataFile`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio2_load_oinfo_data_file_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio2_load_oinfo_data_file.awk`
- SAS/C-only lane (`DISKIO2_WriteNxtDayDataFile`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio2_write_nxt_day_data_file_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio2_write_nxt_day_data_file.awk`
- SAS/C-only lane (`DISKIO2_LoadNxtDayDataFile`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio2_load_nxt_day_data_file_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio2_load_nxt_day_data_file.awk`
- SAS/C-only lane (`DISKIO2_WriteQTableIniFile`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio2_write_qtable_ini_file_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio2_write_qtable_ini_file.awk`
- SAS/C-only lane (`DISKIO2_ReceiveTransferBlocksToFile`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio2_receive_transfer_blocks_to_file_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio2_receive_transfer_blocks_to_file.awk`
- SAS/C-only lane (`DISKIO2_HandleInteractiveFileTransfer`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio2_handle_interactive_file_transfer_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio2_handle_interactive_file_transfer.awk`
- SAS/C-only lane (`DISKIO2_LoadCurDayDataFile`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio2_load_cur_day_data_file_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio2_load_cur_day_data_file.awk`
- SAS/C-only lane (`DISKIO2_WriteCurDayDataFile`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio2_write_cur_day_data_file_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio2_write_cur_day_data_file.awk`
- SAS/C-only lane (`ESQSHARED_MatchSelectionCodeWithOptionalSuffix_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esqshared_match_selection_code_with_optional_suffix_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esqshared_return_stub.awk`
- SAS/C-only lane (`ESQSHARED_CreateGroupEntryAndTitle_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esqshared_create_group_entry_and_title_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esqshared_return_stub.awk`
- SAS/C-only lane (`ESQSHARED_NormalizeInStereoTag_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esqshared_normalize_in_stereo_tag_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esqshared_return_stub.awk`
- SAS/C-only lane (`ESQSHARED_UpdateMatchingEntriesByTitle_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esqshared_update_matching_entries_by_title_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esqshared_return_stub.awk`
- SAS/C-only lane (`ESQPARS_RemoveGroupEntryAndReleaseStrings_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esqpars_remove_group_entry_and_release_strings_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esqpars_return_stub.awk`
- SAS/C-only lane (`ESQPARS_ReplaceOwnedString_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esqpars_replace_owned_string_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esqpars_return_stub.awk`
- SAS/C-only lane (`ESQPARS_ReadLengthWordWithChecksumXor_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esqpars_read_length_word_with_checksum_xor_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esqpars_return_stub.awk`
- SAS/C-only lane (`DISPLIB_FindPreviousValidEntryIndex_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_displib_find_previous_valid_entry_index_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_displib_return_stub.awk`
- SAS/C-only lane (`DISPLIB_FindPreviousValidEntryIndex`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_displib_find_previous_valid_entry_index_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_displib_find_previous_valid_entry_index.awk`
- SAS/C-only lane (`DISPLIB_ApplyInlineAlignmentPadding_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_displib_apply_inline_alignment_padding_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_displib_return_stub.awk`
- SAS/C-only lane (`DISPLIB_ApplyInlineAlignmentPadding`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_displib_apply_inline_alignment_padding_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_displib_apply_inline_alignment_padding.awk`
- SAS/C-only lane (`DISPLIB_DisplayTextAtPosition`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_displib_display_text_at_position_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_displib_display_text_at_position.awk`
- SAS/C-only lane (`DISPLIB_NormalizeValueByStep`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_displib_normalize_value_by_step_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_displib_normalize_value_by_step.awk`
- SAS/C-only lane (`DISPLIB_ResetLineTables`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_displib_reset_line_tables_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_displib_reset_line_tables.awk`
- SAS/C-only lane (`DISPLIB_ResetTextBufferAndLineTables`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_displib_reset_text_buffer_and_line_tables_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_displib_reset_text_buffer_and_line_tables.awk`
- SAS/C-only lane (`DISPLIB_CommitCurrentLinePenAndAdvance`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_displib_commit_current_line_pen_and_advance_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_displib_commit_current_line_pen_and_advance.awk`
- SAS/C-only lane (`ESQ_InvokeGcommandInit`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esq_invoke_gcommand_init_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esq_invoke_gcommand_init.awk`
- SAS/C-only lane (`ESQ_TryRomWriteTest`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esq_try_rom_write_test_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esq_try_rom_write_test.awk`
- SAS/C-only lane (`ESQ_SupervisorColdReboot`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esq_supervisor_cold_reboot_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esq_supervisor_cold_reboot.awk`
- SAS/C-only lane (`ESQ_CheckAvailableFastMemory`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esq_check_available_fast_memory_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esq_check_available_fast_memory.awk`
- SAS/C-only lane (`ESQ_CheckCompatibleVideoChip`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esq_check_compatible_video_chip_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esq_check_compatible_video_chip.awk`
- SAS/C-only lane (`ESQ_CheckTopazFontGuard`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esq_check_topaz_font_guard_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esq_check_topaz_font_guard.awk`
- SAS/C-only lane (`ESQ_FormatDiskErrorMessage`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esq_format_disk_error_message_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esq_format_disk_error_message.awk`
- SAS/C-only lane (`ESQ_HandleSerialRbfInterrupt`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esq_handle_serial_rbf_interrupt_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esq_handle_serial_rbf_interrupt.awk`
- SAS/C-only lane (`ESQ_InitAudio1Dma`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esq_init_audio1_dma_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esq_init_audio1_dma.awk`
- SAS/C-only lane (`ESQ_PollCtrlInput`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esq_poll_ctrl_input_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esq_poll_ctrl_input.awk`
- SAS/C-only lane (`ESQ_ReadSerialRbfByte`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esq_read_serial_rbf_byte_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esq_read_serial_rbf_byte.awk`
- SAS/C-only lane (`ESQ_ReturnWithStackCode`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esq_return_with_stack_code_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esq_return_with_stack_code.awk`
- SAS/C-only lane (`ESQ_CaptureCtrlBit4StreamBufferByte`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esq_capture_ctrl_bit4_stream_buffer_byte_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esq_capture_ctrl_bit4_stream_buffer_byte.awk`
- SAS/C-only lane (`ESQ_CaptureCtrlBit4Stream`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esq_capture_ctrl_bit4_stream_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esq_capture_ctrl_bit4_stream.awk`
- SAS/C-only lane (`ESQ_CaptureCtrlBit3Stream`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esq_capture_ctrl_bit3_stream_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esq_capture_ctrl_bit3_stream.awk`
- SAS/C-only lane (`GET_BIT_3_OF_CIAB_PRA_INTO_D1`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_get_bit_3_of_ciab_pra_into_d1_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_get_bit_3_of_ciab_pra_into_d1.awk`
- SAS/C-only lane (`GET_BIT_4_OF_CIAB_PRA_INTO_D1`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_get_bit_4_of_ciab_pra_into_d1_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_get_bit_4_of_ciab_pra_into_d1.awk`
- SAS/C-only lane (`ED1_ClearEscMenuMode`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_ed1_clear_esc_menu_mode_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_ed1_clear_esc_menu_mode.awk`
- SAS/C-only lane (`ESQDISP_TestWordIsZeroBooleanize`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esqdisp_test_word_is_zero_booleanize_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esqdisp_test_word_is_zero_booleanize.awk`
- SAS/C-only lane (`ESQDISP_TestEntryBits0And2`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esqdisp_test_entry_bits0_and2_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esqdisp_test_entry_bits0_and2.awk`
- SAS/C-only lane (`ESQDISP_TestEntryGridEligibility`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esqdisp_test_entry_grid_eligibility_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esqdisp_test_entry_grid_eligibility.awk`
- SAS/C-only lane (`ESQDISP_SetStatusIndicatorColorSlot`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esqdisp_set_status_indicator_color_slot_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esqdisp_set_status_indicator_color_slot.awk`
- SAS/C-only lane (`ESQDISP_QueueHighlightDrawMessage`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esqdisp_queue_highlight_draw_message_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esqdisp_queue_highlight_draw_message.awk`
- SAS/C-only lane (`ESQDISP_ProcessGridMessagesIfIdle`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esqdisp_process_grid_messages_if_idle_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esqdisp_process_grid_messages_if_idle.awk`
- SAS/C-only lane (`ESQDISP_FillProgramInfoHeaderFields`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esqdisp_fill_program_info_header_fields_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esqdisp_fill_program_info_header_fields.awk`
- SAS/C-only lane (`ESQDISP_ComputeScheduleOffsetForRow`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esqdisp_compute_schedule_offset_for_row_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esqdisp_compute_schedule_offset_for_row.awk`
- SAS/C-only lane (`ESQDISP_UpdateStatusMaskAndRefresh`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esqdisp_update_status_mask_and_refresh_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esqdisp_update_status_mask_and_refresh.awk`
- SAS/C-only lane (`ESQDISP_RefreshStatusIndicatorsFromCurrentMask`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esqdisp_refresh_status_indicators_from_current_mask_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esqdisp_refresh_status_indicators_from_current_mask.awk`
- SAS/C-only lane (`ESQDISP_AllocateHighlightBitmaps`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esqdisp_allocate_highlight_bitmaps_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esqdisp_allocate_highlight_bitmaps.awk`
- SAS/C-only lane (`ESQDISP_InitHighlightMessagePattern`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esqdisp_init_highlight_message_pattern_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esqdisp_init_highlight_message_pattern.awk`
- SAS/C-only lane (`ESQDISP_GetEntryPointerByMode`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esqdisp_get_entry_pointer_by_mode_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esqdisp_get_entry_pointer_by_mode.awk`
- SAS/C-only lane (`ESQDISP_GetEntryAuxPointerByMode`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esqdisp_get_entry_aux_pointer_by_mode_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esqdisp_get_entry_aux_pointer_by_mode.awk`
- SAS/C-only lane (`ESQDISP_ApplyStatusMaskToIndicators`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esqdisp_apply_status_mask_to_indicators_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esqdisp_apply_status_mask_to_indicators.awk`
- SAS/C-only lane (`DISPTEXT_SetCurrentLineIndex`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_disptext_set_current_line_index_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_disptext_set_current_line_index.awk`
- SAS/C-only lane (`DISPTEXT_GetTotalLineCount`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_disptext_get_total_line_count_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_disptext_get_total_line_count.awk`
- SAS/C-only lane (`DISPTEXT_HasMultipleLines`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_disptext_has_multiple_lines_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_disptext_has_multiple_lines.awk`
- SAS/C-only lane (`DISPTEXT_IsLastLineSelected`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_disptext_is_last_line_selected_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_disptext_is_last_line_selected.awk`
- SAS/C-only lane (`DISPTEXT_IsCurrentLineLast`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_disptext_is_current_line_last_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_disptext_is_current_line_last.awk`
- SAS/C-only lane (`DISPTEXT_MeasureCurrentLineLength`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_disptext_measure_current_line_length_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_disptext_measure_current_line_length.awk`
- SAS/C-only lane (`DISPTEXT_ComputeVisibleLineCount`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_disptext_compute_visible_line_count_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_disptext_compute_visible_line_count.awk`
- SAS/C-only lane (`DISPTEXT_FinalizeLineTable`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_disptext_finalize_line_table_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_disptext_finalize_line_table.awk`
- SAS/C-only lane (`DISPTEXT_SetLayoutParams`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_disptext_set_layout_params_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_disptext_set_layout_params.awk`
- SAS/C-only lane (`DISPTEXT_InitBuffers`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_disptext_init_buffers_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_disptext_init_buffers.awk`
- SAS/C-only lane (`DISPTEXT_FreeBuffers`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_disptext_free_buffers_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_disptext_free_buffers.awk`
- SAS/C-only lane (`DISPTEXT_ComputeMarkerWidths`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_disptext_compute_marker_widths_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_disptext_compute_marker_widths.awk`
- SAS/C-only lane (`DISPTEXT_BuildLinePointerTable`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_disptext_build_line_pointer_table_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_disptext_build_line_pointer_table.awk`
- SAS/C-only lane (`DISPTEXT_AppendToBuffer`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_disptext_append_to_buffer_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_disptext_append_to_buffer.awk`
- SAS/C-only lane (`DISPTEXT_BuildLayoutForSource`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_disptext_build_layout_for_source_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_disptext_build_layout_for_source.awk`
- SAS/C-only lane (`DISPTEXT_RenderCurrentLine`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_disptext_render_current_line_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_disptext_render_current_line.awk`
- SAS/C-only lane (`DISPTEXT_LayoutSourceToLines`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_disptext_layout_source_to_lines_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_disptext_layout_source_to_lines.awk`
- SAS/C-only lane (`DISPTEXT_LayoutAndAppendToBuffer`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_disptext_layout_and_append_to_buffer_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_disptext_layout_and_append_to_buffer.awk`
- SAS/C-only lane (`DISPTEXT_BuildLineWithWidth`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_disptext_build_line_with_width_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_disptext_build_line_with_width.awk`
- SAS/C-only lane (`DISKIO1_DumpDefaultCoiInfoBlock_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio1_dump_default_coi_info_block_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio1_return_stub.awk`
- SAS/C-only lane (`DISKIO1_DumpDefaultCoiInfoBlock`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio1_dump_default_coi_info_block_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio1_dump_default_coi_info_block.awk`
- SAS/C-only lane (`DISKIO1_DumpProgramSourceRecordVerbose_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio1_dump_program_source_record_verbose_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio1_return_stub.awk`
- SAS/C-only lane (`DISKIO1_DumpProgramSourceRecordVerbose`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio1_dump_program_source_record_verbose_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio1_dump_program_source_record_verbose.awk`
- SAS/C-only lane (`DISKIO1_DumpProgramInfoVerbose` inferred unlabeled body):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio1_dump_program_info_verbose_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio1_dump_program_info_verbose.awk`
- SAS/C-only lane (`DISKIO1_DumpProgramInfoAttrTable_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio1_dump_program_info_attr_table_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio1_return_stub.awk`
- SAS/C-only lane (`DISKIO1_DumpProgramInfoAttrTable`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio1_dump_program_info_attr_table_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio1_dump_program_info_attr_table.awk`
- SAS/C-only lane (`DISKIO1_AdvanceTimeSlotBitIndex`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio1_advance_time_slot_bit_index_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio1_advance_helper.awk`
- SAS/C-only lane (`DISKIO1_AdvanceBlackoutBitIndex`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio1_advance_blackout_bit_index_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio1_advance_helper.awk`
- SAS/C-only lane (`DISKIO1_AccumulateTimeSlotMaskSum`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio1_accumulate_time_slot_mask_sum_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio1_accumulate_helper.awk`
- SAS/C-only lane (`DISKIO1_AccumulateBlackoutMaskSum`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio1_accumulate_blackout_mask_sum_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio1_accumulate_helper.awk`
- SAS/C-only lane (`DISKIO1_AppendAttrFlagHiliteSrc`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio1_append_attr_flag_hilite_src_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio1_append_attr_helper.awk`
- SAS/C-only lane (`DISKIO1_AppendAttrFlagSummarySrc`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio1_append_attr_flag_summary_src_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio1_append_attr_helper.awk`
- SAS/C-only lane (`DISKIO1_AppendAttrFlagVideoTagDisable`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio1_append_attr_flag_video_tag_disable_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio1_append_attr_helper.awk`
- SAS/C-only lane (`DISKIO1_AppendAttrFlagPpvSrc`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio1_append_attr_flag_ppv_src_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio1_append_attr_helper.awk`
- SAS/C-only lane (`DISKIO1_AppendAttrFlagDitto`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio1_append_attr_flag_ditto_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio1_append_attr_helper.awk`
- SAS/C-only lane (`DISKIO1_AppendAttrFlagAltHiliteSrc`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio1_append_attr_flag_alt_hilite_src_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio1_append_attr_helper.awk`
- SAS/C-only lane (`DISKIO1_AppendAttrFlagBit7`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio1_append_attr_flag_bit7_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio1_append_attr_helper.awk`
- SAS/C-only lane (`DISKIO1_AppendTimeSlotMaskValueHeader`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio1_append_time_slot_mask_value_header_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio1_mask_value_helper.awk`
- SAS/C-only lane (`DISKIO1_AppendTimeSlotMaskValueTerminator`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio1_append_time_slot_mask_value_terminator_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio1_mask_value_helper.awk`
- SAS/C-only lane (`DISKIO1_AppendBlackoutMaskValueHeader`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio1_append_blackout_mask_value_header_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio1_mask_value_helper.awk`
- SAS/C-only lane (`DISKIO1_AppendBlackoutMaskValueTerminator`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio1_append_blackout_mask_value_terminator_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio1_mask_value_helper.awk`
- SAS/C-only lane (`DISKIO1_AppendTimeSlotMaskNoneIfAllBitsSet`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio1_append_time_slot_mask_none_if_all_bits_set_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio1_mask_decision_helper.awk`
- SAS/C-only lane (`DISKIO1_AppendTimeSlotMaskOffAirIfEmpty`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio1_append_time_slot_mask_off_air_if_empty_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio1_mask_decision_helper.awk`
- SAS/C-only lane (`DISKIO1_AppendBlackoutMaskNoneIfEmpty`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio1_append_blackout_mask_none_if_empty_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio1_mask_decision_helper.awk`
- SAS/C-only lane (`DISKIO1_AppendBlackoutMaskAllIfAllBitsSet`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio1_append_blackout_mask_all_if_all_bits_set_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio1_mask_decision_helper.awk`
- SAS/C-only lane (`DISKIO1_AppendTimeSlotMaskSelectedTimes`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio1_append_time_slot_mask_selected_times_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio1_selected_times_helper.awk`
- SAS/C-only lane (`DISKIO1_AppendBlackoutMaskSelectedTimes`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio1_append_blackout_mask_selected_times_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio1_selected_times_helper.awk`
- SAS/C-only lane (`DISKIO1_FormatTimeSlotMaskFlags`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio1_format_time_slot_mask_flags_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio1_format_mask_helper.awk`
- SAS/C-only lane (`DISKIO1_FormatBlackoutMaskFlags`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_diskio1_format_blackout_mask_flags_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_diskio1_format_mask_helper.awk`
- SAS/C-only lane (`GCOMMAND_SetPresetEntry_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_gcommand_set_preset_entry_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_gcommand3_return_stub.awk`
- SAS/C-only lane (`GCOMMAND_ExpandPresetBlock_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_gcommand_expand_preset_block_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_gcommand3_return_stub.awk`
- SAS/C-only lane (`GCOMMAND_ValidatePresetTable_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_gcommand_validate_preset_table_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_gcommand3_return_stub.awk`
- SAS/C-only lane (`GCOMMAND_InitPresetTableFromPalette_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_gcommand_init_preset_table_from_palette_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_gcommand3_return_stub.awk`
- SAS/C-only lane (`GCOMMAND_UpdatePresetEntryCache_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_gcommand_update_preset_entry_cache_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_gcommand3_return_stub.awk`
- SAS/C-only lane (`LADFUNC2_EmitEscapedStringWithLimit_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_ladfunc2_emit_escaped_string_with_limit_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_ladfunc2_return_stub.awk`
- SAS/C-only lane (`LADFUNC2_EmitEscapedStringChunked_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_ladfunc2_emit_escaped_string_chunked_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_ladfunc2_return_stub.awk`
- SAS/C-only lane (`LOCAVAIL_ParseFilterStateFromBuffer_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_locavail_parse_filter_state_from_buffer_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_locavail_return_stub.awk`
- SAS/C-only lane (`LOCAVAIL_MapFilterTokenCharToClass_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_locavail_map_filter_token_char_to_class_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_locavail_return_stub.awk`
- SAS/C-only lane (`LOCAVAIL_ComputeFilterOffsetForEntry_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_locavail_compute_filter_offset_for_entry_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_locavail_return_stub.awk`
- SAS/C-only lane (`LOCAVAIL_SaveAvailabilityDataFile_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_locavail_save_availability_data_file_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_locavail_return_stub.awk`
- SAS/C-only lane (`LOCAVAIL_LoadAvailabilityDataFile_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_locavail_load_availability_data_file_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_locavail_return_stub.awk`
- SAS/C-only lane (`LOCAVAIL_UpdateFilterStateMachine_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_locavail_update_filter_state_machine_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_locavail_return_stub.awk`
- SAS/C-only lane (`FLIB_AppendClockStampedLogEntry_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_flib_append_clock_stamped_log_entry_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_flib_return_stub.awk`
- SAS/C-only lane (`LADFUNC_RepackEntryTextAndAttrBuffers_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_ladfunc_repack_entry_text_and_attr_buffers_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_ladfunc_return_stub.awk`
- SAS/C-only lane (`LADFUNC_UpdateEntryFromTextAndAttrBuffers_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_ladfunc_update_entry_from_text_and_attr_buffers_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_ladfunc_return_stub.awk`
- SAS/C-only lane (`ESQIFF2_ApplyIncomingStatusPacket_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esqiff2_apply_incoming_status_packet_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esqiff2_return_stub.awk`
- SAS/C-only lane (`ESQIFF2_ReadSerialBytesToBuffer_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esqiff2_read_serial_bytes_to_buffer_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esqiff2_return_stub.awk`
- SAS/C-only lane (`ESQIFF2_ReadSerialBytesWithXor_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esqiff2_read_serial_bytes_with_xor_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esqiff2_return_stub.awk`
- SAS/C-only lane (`ESQIFF2_ValidateFieldIndexAndLength_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esqiff2_validate_field_index_and_length_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esqiff2_return_stub.awk`
- SAS/C-only lane (`ESQIFF2_PadEntriesToMaxTitleWidth_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esqiff2_pad_entries_to_max_title_width_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esqiff2_return_stub.awk`
- SAS/C-only lane (`ESQIFF2_ParseLineHeadTailRecord_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esqiff2_parse_line_head_tail_record_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esqiff2_return_stub.awk`
- SAS/C-only lane (`ESQIFF2_ParseGroupRecordAndRefresh_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esqiff2_parse_group_record_and_refresh_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esqiff2_return_stub.awk`
- SAS/C-only lane (`ESQIFF2_ReadSerialRecordIntoBuffer_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esqiff2_read_serial_record_into_buffer_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esqiff2_return_stub.awk`
- SAS/C-only lane (`ESQIFF2_ReadSerialSizedTextRecord_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esqiff2_read_serial_sized_text_record_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esqiff2_return_stub.awk`
- SAS/C-only lane (`ESQIFF2_ShowVersionMismatchOverlay_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esqiff2_show_version_mismatch_overlay_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esqiff2_return_stub.awk`
- SAS/C-only lane (`ESQIFF2_ShowAttentionOverlay_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esqiff2_show_attention_overlay_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esqiff2_return_stub.awk`
- SAS/C-only lane (`ESQIFF2_ClearPrimaryEntryFlags34To39_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esqiff2_clear_primary_entry_flags34_to39_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_esqiff2_return_stub.awk`
- SAS/C-only lane (`ESQ_ShutdownAndReturn`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esq_shutdown_and_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_return_stub.awk`
- SAS/C-only lane (`ESQIFF_ShowExternalAssetWithCopperFx_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esqiff_show_external_asset_with_copper_fx_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_return_stub.awk`
- SAS/C-only lane (`ESQIFF_PlayNextExternalAssetFrame_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esqiff_play_next_external_asset_frame_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_return_stub.awk`
- SAS/C-only lane (`ESQSHARED4_ApplyBannerColorStep_Return`):
- compare (SAS/C): `src/decomp/scripts/compare_sasc_esqshared4_apply_banner_color_step_return_trial.sh`
- semantic (SAS/C): `src/decomp/scripts/semantic_filter_sasc_return_stub.awk`
- latest full C trial: `compiled 1031 / 1031`, `export count 1039`, `status: ok`

## Toolchain Notes
- GCC lanes default to `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc` but honor `CROSS_CC` overrides.
- GCC compare scripts support per-run `GCC_CFLAGS=...` tuning.
- vbcc compare scripts are retained for historical/reference work (`compare_memory_*_trial.sh`, `compare_clock_convert_trial.sh`).
- Current target-by-target status and preferred profiles are tracked in `src/decomp/TARGETS.md`.

## SAS/C Trial Lane
- `sc-build-with-dis.sh` now passes `--vols-base-dir` (defaults to `build/decomp/vamos_vols`) so `vamos` temp volumes stay inside workspace-writable paths.
- Fast cadence helper: `src/decomp/scripts/run_sasc_core_sweep.sh` (use `--strict` to fail on any non-zero semantic diff).
- Targeted cadence helper: `run_sasc_core_sweep.sh` now supports repeated `--filter <substring>` args to run only matching lanes while iterating on a specific module cluster.
  - Example: `bash src/decomp/scripts/run_sasc_core_sweep.sh --strict --filter script3_jmptbl --filter script2_jmptbl`
- Cleanup helper: pass `--clean-generated-dis` to remove untracked `src/decomp/sas_c/*.dis` artifacts after a sweep run.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_locavail2_auto_request_no_op_trial.sh` (`LOCAVAIL2_AutoRequestNoOp`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_locavail2_auto_request_no_op.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_gcommand_enable_highlight_trial.sh` (`GCOMMAND_EnableHighlight`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_gcommand_enable_highlight.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_gcommand_disable_highlight_trial.sh` (`GCOMMAND_DisableHighlight`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_gcommand_disable_highlight.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_gcommand_init_preset_defaults_trial.sh` (`GCOMMAND_InitPresetDefaults`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_gcommand_init_preset_defaults.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_gcommand_reset_banner_fade_state_trial.sh` (`GCOMMAND_ResetBannerFadeState`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_gcommand_reset_banner_fade_state.awk`.
- Newly added direct lanes: `src/decomp/scripts/compare_sasc_gcommand_get_banner_char_trial.sh` (`GCOMMAND_GetBannerChar`) and `src/decomp/scripts/compare_sasc_gcommand_add_banner_table_byte_delta_trial.sh` (`GCOMMAND_AddBannerTableByteDelta`) with semantic gates `semantic_filter_sasc_gcommand_get_banner_char.awk` and `semantic_filter_sasc_gcommand_add_banner_table_byte_delta.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_esqshared4_load_default_palette_to_copper_no_op_trial.sh` (`ESQSHARED4_LoadDefaultPaletteToCopper_NoOp`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_esqshared4_load_default_palette_to_copper_no_op.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_esqshared4_set_banner_color_base_and_limit_trial.sh` (`ESQSHARED4_SetBannerColorBaseAndLimit`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_esqshared4_set_banner_color_base_and_limit.awk`.
- Lane cleanup: `compare_sasc_esqshared4_apply_banner_color_step_return_trial.sh` now uses dedicated source `src/decomp/sas_c/esqshared4_apply_banner_color_step_return.c` (instead of piggybacking on `return_misc_stubs.c`).
- Newly added direct lane: `src/decomp/scripts/compare_sasc_esqshared4_compute_banner_row_blit_geometry_trial.sh` (`ESQSHARED4_ComputeBannerRowBlitGeometry`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_esqshared4_compute_banner_row_blit_geometry.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_esqshared4_reset_banner_color_sweep_state_trial.sh` (`ESQSHARED4_ResetBannerColorSweepState`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_esqshared4_reset_banner_color_sweep_state.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_esqshared4_initialize_banner_copper_system_trial.sh` (`ESQSHARED4_InitializeBannerCopperSystem`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_esqshared4_initialize_banner_copper_system.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_esqshared4_decode_rgb_nibble_triplet_trial.sh` (`ESQSHARED4_DecodeRgbNibbleTriplet`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_esqshared4_decode_rgb_nibble_triplet.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_esqshared4_load_copper_color_words_from_nibble_table_trial.sh` (`ESQSHARED4_LoadCopperColorWordsFromNibbleTable`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_esqshared4_load_copper_color_words_from_nibble_table.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_esqshared4_set_banner_copper_color_and_threshold_trial.sh` (`ESQSHARED4_SetBannerCopperColorAndThreshold`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_esqshared4_set_banner_copper_color_and_threshold.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_esqshared4_reset_banner_color_to_start_trial.sh` (`ESQSHARED4_ResetBannerColorToStart`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_esqshared4_reset_banner_color_to_start.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_esqshared4_apply_banner_color_step_trial.sh` (`ESQSHARED4_ApplyBannerColorStep`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_esqshared4_apply_banner_color_step.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_esqshared4_copy_longword_block_dbf_loop_trial.sh` (`ESQSHARED4_CopyLongwordBlockDbfLoop`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_esqshared4_copy_longword_block_dbf_loop.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_esqshared4_copy_interleaved_row_words_from_offset_trial.sh` (`ESQSHARED4_CopyInterleavedRowWordsFromOffset`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_esqshared4_copy_interleaved_row_words_from_offset.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_esqshared4_copy_banner_rows_with_byte_offset_trial.sh` (`ESQSHARED4_CopyBannerRowsWithByteOffset`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_esqshared4_copy_banner_rows_with_byte_offset.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_esqshared4_blit_banner_rows_for_active_field_trial.sh` (`ESQSHARED4_BlitBannerRowsForActiveField`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_esqshared4_blit_banner_rows_for_active_field.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_esqshared4_setup_banner_plane_pointer_words_trial.sh` (`ESQSHARED4_SetupBannerPlanePointerWords`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_esqshared4_setup_banner_plane_pointer_words.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_esqshared4_tick_copper_and_banner_transitions_trial.sh` (`ESQSHARED4_TickCopperAndBannerTransitions`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_esqshared4_tick_copper_and_banner_transitions.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_esqiff2_clear_line_head_tail_by_mode_trial.sh` (`ESQIFF2_ClearLineHeadTailByMode`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_esqiff2_clear_line_head_tail_by_mode.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_esqiff2_read_rbf_bytes_to_buffer_trial.sh` (`ESQIFF2_ReadRbfBytesToBuffer`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_esqiff2_read_rbf_bytes_to_buffer.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_esqiff2_read_rbf_bytes_with_xor_trial.sh` (`ESQIFF2_ReadRbfBytesWithXor`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_esqiff2_read_rbf_bytes_with_xor.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_esqiff2_read_serial_record_into_buffer_trial.sh` (`ESQIFF2_ReadSerialRecordIntoBuffer`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_esqiff2_read_serial_record_into_buffer.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_esqiff2_read_serial_sized_text_record_trial.sh` (`ESQIFF2_ReadSerialSizedTextRecord`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_esqiff2_read_serial_sized_text_record.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_esqiff2_show_version_mismatch_overlay_trial.sh` (`ESQIFF2_ShowVersionMismatchOverlay`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_esqiff2_show_version_mismatch_overlay.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_esqiff2_clear_primary_entry_flags34_to39_trial.sh` (`ESQIFF2_ClearPrimaryEntryFlags34To39`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_esqiff2_clear_primary_entry_flags34_to39.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_esqiff2_pad_entries_to_max_title_width_trial.sh` (`ESQIFF2_PadEntriesToMaxTitleWidth`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_esqiff2_pad_entries_to_max_title_width.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_esqiff2_parse_line_head_tail_record_trial.sh` (`ESQIFF2_ParseLineHeadTailRecord`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_esqiff2_parse_line_head_tail_record.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_esqiff2_apply_incoming_status_packet_trial.sh` (`ESQIFF2_ApplyIncomingStatusPacket`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_esqiff2_apply_incoming_status_packet.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_esqiff2_show_attention_overlay_trial.sh` (`ESQIFF2_ShowAttentionOverlay`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_esqiff2_show_attention_overlay.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_esqiff2_parse_group_record_and_refresh_trial.sh` (`ESQIFF2_ParseGroupRecordAndRefresh`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_esqiff2_parse_group_record_and_refresh.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_esqiff2_validate_ascii_numeric_byte_trial.sh` (`ESQIFF2_ValidateAsciiNumericByte`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_esqiff2_validate_ascii_numeric_byte.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_esqiff2_validate_field_index_and_length_trial.sh` (`ESQIFF2_ValidateFieldIndexAndLength`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_esqiff2_validate_field_index_and_length.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_esqpars_replace_owned_string_trial.sh` (`ESQPARS_ReplaceOwnedString`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_esqpars_replace_owned_string.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_esqpars_read_length_word_with_checksum_xor_trial.sh` (`ESQPARS_ReadLengthWordWithChecksumXor`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_esqpars_read_length_word_with_checksum_xor.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_esqpars_remove_group_entry_and_release_strings_trial.sh` (`ESQPARS_RemoveGroupEntryAndReleaseStrings`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_esqpars_remove_group_entry_and_release_strings.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_esqshared_normalize_in_stereo_tag_trial.sh` (`ESQSHARED_NormalizeInStereoTag`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_esqshared_normalize_in_stereo_tag.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_esqshared_match_selection_code_with_optional_suffix_trial.sh` (`ESQSHARED_MatchSelectionCodeWithOptionalSuffix`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_esqshared_match_selection_code_with_optional_suffix.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_esq_shutdown_and_return_trial.sh` (`ESQ_ShutdownAndReturn`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_esq_shutdown_and_return.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_flib_append_clock_stamped_log_entry_trial.sh` (`FLIB_AppendClockStampedLogEntry`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_flib_append_clock_stamped_log_entry.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_locavail_map_filter_token_char_to_class_trial.sh` (`LOCAVAIL_MapFilterTokenCharToClass`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_locavail_map_filter_token_char_to_class.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_ladfunc2_emit_escaped_string_with_limit_trial.sh` (`LADFUNC2_EmitEscapedStringWithLimit`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_ladfunc2_emit_escaped_string_with_limit.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_gcommand_set_preset_entry_trial.sh` (`GCOMMAND_SetPresetEntry`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_gcommand_set_preset_entry.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_gcommand_update_preset_entry_cache_trial.sh` (`GCOMMAND_UpdatePresetEntryCache`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_gcommand_update_preset_entry_cache.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_gcommand_validate_preset_table_trial.sh` (`GCOMMAND_ValidatePresetTable`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_gcommand_validate_preset_table.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_gcommand_init_preset_table_from_palette_trial.sh` (`GCOMMAND_InitPresetTableFromPalette`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_gcommand_init_preset_table_from_palette.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_gcommand_compute_preset_increment_trial.sh` (`GCOMMAND_ComputePresetIncrement`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_gcommand_compute_preset_increment.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_gcommand_expand_preset_block_trial.sh` (`GCOMMAND_ExpandPresetBlock`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_gcommand_expand_preset_block.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_gcommand_map_keycode_to_preset_trial.sh` (`GCOMMAND_MapKeycodeToPreset`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_gcommand_map_keycode_to_preset.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_gcommand_apply_highlight_flag_trial.sh` (`GCOMMAND_ApplyHighlightFlag`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_gcommand_apply_highlight_flag.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_gcommand_init_preset_work_entry_trial.sh` (`GCOMMAND_InitPresetWorkEntry`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_gcommand_init_preset_work_entry.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_gcommand_load_preset_work_entries_trial.sh` (`GCOMMAND_LoadPresetWorkEntries`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_gcommand_load_preset_work_entries.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_gcommand_tick_highlight_state_trial.sh` (`GCOMMAND_TickHighlightState`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_gcommand_tick_highlight_state.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_gcommand_tick_preset_work_entries_trial.sh` (`GCOMMAND_TickPresetWorkEntries`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_gcommand_tick_preset_work_entries.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_gcommand_update_banner_bounds_trial.sh` (`GCOMMAND_UpdateBannerBounds`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_gcommand_update_banner_bounds.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_gcommand_update_banner_offset_trial.sh` (`GCOMMAND_UpdateBannerOffset`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_gcommand_update_banner_offset.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_gcommand_update_banner_row_pointers_trial.sh` (`GCOMMAND_UpdateBannerRowPointers`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_gcommand_update_banner_row_pointers.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_gcommand_refresh_banner_tables_trial.sh` (`GCOMMAND_RefreshBannerTables`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_gcommand_refresh_banner_tables.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_gcommand_clear_banner_queue_trial.sh` (`GCOMMAND_ClearBannerQueue`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_gcommand_clear_banner_queue.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_gcommand_consume_banner_queue_entry_trial.sh` (`GCOMMAND_ConsumeBannerQueueEntry`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_gcommand_consume_banner_queue_entry.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_gcommand_adjust_banner_copper_offset_trial.sh` (`GCOMMAND_AdjustBannerCopperOffset`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_gcommand_adjust_banner_copper_offset.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_gcommand_reset_highlight_messages_trial.sh` (`GCOMMAND_ResetHighlightMessages`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_gcommand_reset_highlight_messages.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_gcommand_seed_banner_defaults_trial.sh` (`GCOMMAND_SeedBannerDefaults`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_gcommand_seed_banner_defaults.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_gcommand_seed_banner_from_prefs_trial.sh` (`GCOMMAND_SeedBannerFromPrefs`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_gcommand_seed_banner_from_prefs.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_gcommand_rebuild_banner_tables_from_bounds_trial.sh` (`GCOMMAND_RebuildBannerTablesFromBounds`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_gcommand_rebuild_banner_tables_from_bounds.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_gcommand_build_banner_row_trial.sh` (`GCOMMAND_BuildBannerRow`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_gcommand_build_banner_row.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_gcommand_build_banner_tables_trial.sh` (`GCOMMAND_BuildBannerTables`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_gcommand_build_banner_tables.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_gcommand_build_banner_block_trial.sh` (`GCOMMAND_BuildBannerBlock`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_gcommand_build_banner_block.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_gcommand_copy_image_data_to_bitmap_trial.sh` (`GCOMMAND_CopyImageDataToBitmap`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_gcommand_copy_image_data_to_bitmap.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_esqshared4_bind_and_clear_banner_work_raster_trial.sh` (`ESQSHARED4_BindAndClearBannerWorkRaster`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_esqshared4_bind_and_clear_banner_work_raster.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_esqshared4_clear_banner_work_raster_with_ones_trial.sh` (`ESQSHARED4_ClearBannerWorkRasterWithOnes`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_esqshared4_clear_banner_work_raster_with_ones.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_esqshared4_program_display_window_and_copper_trial.sh` (`ESQSHARED4_ProgramDisplayWindowAndCopper`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_esqshared4_program_display_window_and_copper.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_esqshared4_snapshot_display_buffer_bases_trial.sh` (`ESQSHARED4_SnapshotDisplayBufferBases`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_esqshared4_snapshot_display_buffer_bases.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_esqshared4_copy_planes_from_context_to_snapshot_trial.sh` (`ESQSHARED4_CopyPlanesFromContextToSnapshot`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_esqshared4_copy_planes_from_context_to_snapshot.awk`.
- Newly added direct lane: `src/decomp/scripts/compare_sasc_esqshared4_copy_live_planes_to_snapshot_trial.sh` (`ESQSHARED4_CopyLivePlanesToSnapshot`) with semantic gate `src/decomp/scripts/semantic_filter_sasc_esqshared4_copy_live_planes_to_snapshot.awk`.
- Lane cleanup: `compare_sasc_unknown32_jmptbl_esq_return_with_stack_code_trial.sh` now uses dedicated source `src/decomp/sas_c/unknown32_jmptbl_esq_return_with_stack_code.c` (instead of piggybacking on a multi-function source file).
- Coverage status (as of March 5, 2026): strict sweep includes all current `src/decomp/scripts/compare_sasc_*_trial.sh` lanes (`0` missing from the sweep list).
- Current strict sweep coverage includes core string/memory/index lanes plus utility aliases (`ALLOC_AllocFromFreeList`, `ALLOC_InsertFreeBlock`, `ALLOCATE_AllocAndInitializeIOStdReq`, `DATETIME_*`, `CLOCK_Convert*`, `BATTCLOCK_GetSeconds`, `BATTCLOCK_WriteSeconds`, `SIGNAL_CreateMsgPortWithSignal`, `STRUCT_{AllocWithOwner,FreeWithSizeField}`, `MATH_Mulu32`, `GRAPHICS_{AllocRaster,FreeRaster}`, `DST_{RefreshBannerBuffer,UpdateBannerQueue,ComputeBannerIndex}`), parser/buffer helpers (`PARSE_ReadSignedLongSkipClass3*`, `BUFFER_EnsureAllocated`, `BUFFER_FlushAllAndCloseWithCode`, `STRING_ToUpperChar`), DOS/error-state and handle helpers (`DOS_*WithErrorState`, `DOS_OpenNewFileIfMissing`, `DOS_DeleteAndRecreateFile`, `IOSTDREQ_*`, `HANDLE_*ByIndex`, `MEMLIST_*`), selected group jump-table wrappers (`GROUP_AG_JMPTBL_DOS_OpenFileWithMode`, `GROUP_AG_JMPTBL_IOSTDREQ_CleanupSignalAndMsgport`, `GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt`, `GROUP_AG_JMPTBL_STRING_CopyPadNul`, `GROUP_AG_JMPTBL_MEMORY_*`, `GROUP_AG_JMPTBL_MATH_*`, `GROUP_AG_JMPTBL_SIGNAL_CreateMsgPortWithSignal`, `GROUP_AG_JMPTBL_STRUCT_{AllocWithOwner,FreeWithSizeField}`, `GROUP_AA_JMPTBL_STRING_Compare*`, `GROUP_AA_JMPTBL_GRAPHICS_AllocRaster`, `GROUP_AB_JMPTBL_IOSTDREQ_Free`, `GROUP_AB_JMPTBL_GRAPHICS_FreeRaster`, `GROUP_AC_JMPTBL_DST_{RefreshBannerBuffer,UpdateBannerQueue}`, `GROUP_AD_JMPTBL_DATETIME_*`, `GROUP_AD_JMPTBL_DST_ComputeBannerIndex`, `GROUP_AE_JMPTBL_ESQDISP_GetEntry*ByMode`, `GROUP_AV_JMPTBL_ALLOCATE_AllocAndInitializeIOStdReq`, `GROUP_AV_JMPTBL_ESQ_InvokeGcommandInit`, `GROUP_AH_JMPTBL_ESQ_TestBit1Based`, `GROUP_AH_JMPTBL_ESQ_WildcardMatch`, `GROUP_AH_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh`, `GROUP_AH_JMPTBL_PARSE/STR_*`, `GROUP_AI_JMPTBL_{STR*,STRING_AppendAtNull,FORMAT_FormatToBuffer2,NEWGRID_SetSelectionMarkers,TLIBA1_DrawTextWithInsetSegments}`, `GROUP_AJ_JMPTBL_{STRING_FindSubstring,FORMAT_RawDoFmtWithScratchBuffer,MATH_DivU32,MATH_Mulu32,PARSEINI_WriteRtcFromGlobals}`, `GROUP_AK_JMPTBL_ESQ_SetCopperEffect_{AllOn,Custom,Default}`, `GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth`, `GROUP_AR_JMPTBL_STRING_AppendAtNull`, `GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold/STR_FindCharPtr`, `GROUP_AW_JMPTBL_MEM_Move/STRING_CopyPadNul/ESQ_SetCopperEffect_OffDisableHighlight`, `GROUP_AY_JMPTBL_STRING_CompareNoCaseN`, `GROUP_AY_JMPTBL_MATH_Mulu32`, `GROUP_AZ_JMPTBL_ESQ_ColdReboot`), APP2/Unknown42 foundational stubs (`ESQ_NoOp*`, `ESQ_ShutdownAndReturn`, `ESQ_ReturnWithStackCode`, entry/exit noop hooks), APP2 utility lanes (`ESQ_WildcardMatch`, `ESQ_GenerateXorChecksumByte`, `ESQ_WriteDecFixedWidth`, `ESQ_FindSubstringCaseFold`, `ESQ_PackBitsDecode`, `ESQ_GetHalfHourSlotIndex`, `ESQ_ClampBannerCharRange`, `ESQ_ReverseBitsIn6Bytes`, `ESQ_DecColorStep`, `ESQ_BumpColorTowardTargets`), APP2 copper-effect lanes (`ESQ_SetCopperEffect_*`, `ESQ_UpdateCopperListsFromParams`, `ESQ_MoveCopperEntryTowardStart`, `ESQ_MoveCopperEntryTowardEnd`, `ESQ_DecCopperListsPrimary`, `ESQ_IncCopperListsTowardsTargets`), APP2 calendar/time lanes (`ESQ_SeedMinuteEventThresholds`, `ESQ_TickGlobalCounters`, `ESQ_CalcDayOfYearFromMonthDay`, `ESQ_UpdateMonthDayFromDayOfYear`, `ESQ_FormatTimeStamp`, `ESQ_TickClockAndFlagEvents`, `ESQ_AdjustBracketedHourInString`), APP2 control-input lanes (`ESQ_StoreCtrlSampleEntry`, `ESQ_PollCtrlInput`, `ESQ_ReadSerialRbfByte`, `ESQ_HandleSerialRbfInterrupt`, `ESQ_CaptureCtrlBit3Stream`, `ESQ_CaptureCtrlBit4Stream`, `ESQ_CaptureCtrlBit4StreamBufferByte`, `ESQDISP_GetEntry*ByMode`), APP2 boot/guard/reboot lanes (`ESQ_AdvanceBannerCharIndex_Return`, `ESQ_TerminateAfterSecondQuote`, `ESQ_CheckAvailableFastMemory`, `ESQ_CheckCompatibleVideoChip`, `ESQ_CheckTopazFontGuard`, `ESQ_FormatDiskErrorMessage`, `ESQ_InitAudio1Dma`, `ESQ_InvokeGcommandInit`, `ESQ_TryRomWriteTest`, `ESQ_ParseCommandLineAndRun`, `ESQ_ColdReboot*`), clock lanes (`CLOCK_CheckDateOrSecondsFromEpoch`, `CLOCK_SecondsFromEpoch`), and core `PARALLEL_*` formatting lanes.
- Newly promoted strict lanes: `BEVEL_{DrawHorizontalBevel,DrawVerticalBevel,DrawVerticalBevelPair,DrawBevelFrameWithTop,DrawBevelFrameWithTopRight,DrawBeveledFrame}`, `CTASKS_{CloseTaskTeardown,IffTaskCleanup,StartCloseTaskProcess,StartIffTaskProcess}`, `DISKIO1` mask helpers (`Accumulate*MaskSum`, `Advance*BitIndex`, `Append*MaskValue{Header,Terminator}`, `AppendBlackoutMaskNoneIfEmpty`, `AppendTimeSlotMaskOffAirIfEmpty`, `AppendAttrFlag_{AltHiliteSrc,Bit7,Ditto,HiliteSrc,PpvSrc,SummarySrc,VideoTagDisable}`, `Append{BlackoutMaskAllIfAllBitsSet,BlackoutMaskSelectedTimes,TimeSlotMaskNoneIfAllBitsSet,TimeSlotMaskSelectedTimes}`, `Format{BlackoutMaskFlags,TimeSlotMaskFlags}`, `Dump{DefaultCoiInfoBlock,DefaultCoiInfoBlock_Return,ProgramInfoAttrTable,ProgramInfoAttrTable_Return,ProgramInfoVerbose,ProgramSourceRecordVerbose,ProgramSourceRecordVerbose_Return}`), all `DISKIO_*` and `DISKIO2_*` compare lanes, `DST_*` compare lanes, `COI_{ClearAnimObjectStrings,ClearAnimObjectStrings_Return,ComputeEntryTimeDeltaMinutes,ComputeEntryTimeDeltaMinutes_Return,EnsureAnimObjectAllocated,GetAnimFieldPointerByMode,GetAnimFieldPointerByMode_Return,SelectAnimFieldPointer,FreeSubEntryTableEntries,FreeSubEntryTableEntries_Return,AllocSubEntryTable,FormatEntryDisplayText,FormatEntryDisplayText_Return,FreeEntryResources,FreeEntryResources_Return,TestEntryWithinTimeWindow,TestEntryWithinTimeWindow_Return,AppendAnimFieldWithTrailingSpace_Return,CountEscape14BeforeNull,LoadOiDataFile,ProcessEntrySelectionState,RenderClockFormatEntryVariant,WriteOiDataFile}`, `BRUSH_{AllocBrushNode,AppendBrushNode,PopBrushHead,FindBrushByPredicate,FindType3Brush,FreeBrushList_Return,FreeBrushList,PlaneMaskForIndex,SelectBrushSlot_Return,SelectBrushSlot,SelectBrushByLabel,NormalizeBrushNames,CloneBrushRecord,StreamFontChunk,LoadColorTextFont,LoadBrushAsset,PopulateBrushList,FreeBrushResources}`, `DISPLIB_{ApplyInlineAlignmentPadding,ApplyInlineAlignmentPadding_Return,CommitCurrentLinePenAndAdvance,DisplayTextAtPosition,FindPreviousValidEntryIndex,FindPreviousValidEntryIndex_Return,NormalizeValueByStep,ResetLineTables,ResetTextBufferAndLineTables}`, expanded `NEWGRID2_JMPTBL_*` coverage (cleanup/COI/DISPLIB/DISPTEXT/ESQ/ESQDISP/PARSE/STR/TLIBA wrappers) and `NEWGRID_JMPTBL_*` support wrappers (cleanup/datetime/disptext/math/memory/selection preview), and wrappers `ESQIFF_JMPTBL_CTASKS_StartIffTaskProcess`, `ESQSHARED_JMPTBL_COI_EnsureAnimObjectAllocated`, plus `ESQIFF_JMPTBL_BRUSH_{AllocBrushNode,CloneBrushRecord,FindBrushByPredicate,FindType3Brush,FreeBrushList,PopBrushHead,SelectBrushByLabel,SelectBrushSlot}`, `DOS_{OpenFileWithMode,CloseWithSignalCheck,SystemTagList}`, `ESQ_{SetBit1Based,TestBit1Based}` alias lanes, and all `CLEANUP_*`, `DISPTEXT_*`, `ESQDISP_*`, `ESQIFF2_*`, `ESQFUNC_JMPTBL_*`, `ESQPARS_JMPTBL_*`, `ESQIFF_JMPTBL_*`, `PARSEINI_JMPTBL_*`, `PARSEINI2_JMPTBL_*`, and `ED1_*` SAS/C compare lanes, plus non-`JMPTBL` lanes for `ESQPROTO_*`, `ESQSHARED*`, `ESQPARS_*_Return`, `GCOMMAND_*_Return`, `LOCAVAIL_*_Return`, `LADFUNC*_*_Return`, `GET_BIT_3/4_OF_CIAB_PRA`, `GRAPHICS_BltBitMapRastPort`, `RENDER_ShortMonthShortDayOfWeekDay`, `UNKNOWN*` helpers, `PARALLEL_CheckReady*` aliases, and `STRING_ToUpperChar`, additional `GROUP_AA/GROUP_AB` jmptbl cleanup/resource wrappers (`GCOMMAND_FindPathSeparator`, ESQIFF/ESQPARS/LADFUNC/LOCAVAIL/NEWGRID free-path stubs), resolved pair lanes `memory_pair` / `unknown34_pair`, and additional promoted wrappers across `GROUP_{AF,AG,AK,AL,AM,AR,AT,AU,AV,AW,AX,AY}` plus `GROUP_MAIN_{A,B}` and `P_TYPE_JMPTBL_STRING_FindSubstring`.
- Memory pair SAS/C compare script: `src/decomp/scripts/compare_sasc_memory_pair_trial.sh`
- String toupper SAS/C compare script: `src/decomp/scripts/compare_sasc_string_toupper_trial.sh`
- Unknown34 pair SAS/C compare script (`LIST_InitHeader` + `MEM_Move`): `src/decomp/scripts/compare_sasc_unknown34_pair_trial.sh`
- Unknown34 `LIST_InitHeader` SAS/C compare script: `src/decomp/scripts/compare_sasc_list_init_header_trial.sh`
- Unknown34 `MEM_Move` SAS/C compare script: `src/decomp/scripts/compare_sasc_mem_move_trial.sh`
- Unknown34 `DOS_ReadByIndex` SAS/C compare script: `src/decomp/scripts/compare_sasc_dos_read_by_index_trial.sh`
- Unknown11 `DOS_SeekByIndex` SAS/C compare script: `src/decomp/scripts/compare_sasc_dos_seek_by_index_trial.sh`
- Unknown12 `ALLOC_AllocFromFreeList` SAS/C compare script: `src/decomp/scripts/compare_sasc_alloc_alloc_from_free_list_trial.sh`
- Unknown6 `STRING_AppendAtNull` SAS/C compare script: `src/decomp/scripts/compare_sasc_string_append_at_null_trial.sh`
- Unknown5 `STRING_AppendN` SAS/C compare script: `src/decomp/scripts/compare_sasc_string_append_n_trial.sh`
- Unknown5 `STRING_CompareN` SAS/C compare script: `src/decomp/scripts/compare_sasc_string_compare_n_trial.sh`
- Unknown5 `STRING_CompareNoCase` SAS/C compare script: `src/decomp/scripts/compare_sasc_string_compare_nocase_trial.sh`
- Unknown5 `STRING_CopyPadNul` SAS/C compare script: `src/decomp/scripts/compare_sasc_string_copy_pad_nul_trial.sh`
- Unknown5 `STRING_CompareNoCaseN` SAS/C compare script: `src/decomp/scripts/compare_sasc_string_compare_nocase_n_trial.sh`
- Unknown33 `STRING_FindSubstring` SAS/C compare script: `src/decomp/scripts/compare_sasc_string_find_substring_trial.sh`
- Unknown33 `ALLOC_InsertFreeBlock` SAS/C compare script: `src/decomp/scripts/compare_sasc_alloc_insert_free_block_trial.sh`
- Unknown26 `DOS_WriteByIndex` SAS/C compare script: `src/decomp/scripts/compare_sasc_dos_write_by_index_trial.sh`
- Unknown4 `STRING_ToUpperInPlace` SAS/C compare script: `src/decomp/scripts/compare_sasc_string_toupper_inplace_trial.sh`
- Unknown3 `STRING_ToUpperChar` SAS/C compare script: `src/decomp/scripts/compare_sasc_string_toupper_char_trial.sh`
- Unknown23 `HANDLE_GetEntryByIndex` SAS/C compare script: `src/decomp/scripts/compare_sasc_handle_get_entry_by_index_trial.sh`
- Unknown37 `HANDLE_CloseByIndex` SAS/C compare script: `src/decomp/scripts/compare_sasc_handle_close_by_index_trial.sh`
- Unknown19 `DOS_ReadWithErrorState` SAS/C compare script: `src/decomp/scripts/compare_sasc_dos_read_with_error_state_trial.sh`
- Unknown17 `DOS_WriteWithErrorState` SAS/C compare script: `src/decomp/scripts/compare_sasc_dos_write_with_error_state_trial.sh`
- Unknown18 `DOS_SeekWithErrorState` SAS/C compare script: `src/decomp/scripts/compare_sasc_dos_seek_with_error_state_trial.sh`
- Unknown20 `DOS_OpenWithErrorState` SAS/C compare script: `src/decomp/scripts/compare_sasc_dos_open_with_error_state_trial.sh`
- Unknown21 `IOSTDREQ_Free` SAS/C compare script: `src/decomp/scripts/compare_sasc_iostdreq_free_trial.sh`
- Unknown21 `IOSTDREQ_CleanupSignalAndMsgport` SAS/C compare script: `src/decomp/scripts/compare_sasc_iostdreq_cleanup_signal_and_msgport_trial.sh`
- Unknown21 `DOS_OpenNewFileIfMissing` SAS/C compare script: `src/decomp/scripts/compare_sasc_dos_open_new_file_if_missing_trial.sh`
- Unknown21 `DOS_DeleteAndRecreateFile` SAS/C compare script: `src/decomp/scripts/compare_sasc_dos_delete_and_recreate_file_trial.sh`
- Unknown24 `PARSE_ReadSignedLongSkipClass3` SAS/C compare script: `src/decomp/scripts/compare_sasc_parse_read_signed_long_skip_class3_trial.sh`
- Unknown24 `PARSE_ReadSignedLongSkipClass3_Alt` SAS/C compare script: `src/decomp/scripts/compare_sasc_parse_read_signed_long_skip_class3_alt_trial.sh`
- Unknown24 `MEMLIST_FreeAll` SAS/C compare script: `src/decomp/scripts/compare_sasc_memlist_free_all_trial.sh`
- Unknown24 `MEMLIST_AllocTracked` SAS/C compare script: `src/decomp/scripts/compare_sasc_memlist_alloc_tracked_trial.sh`
- Unknown25 `STRUCT_FreeWithSizeField` SAS/C compare script: `src/decomp/scripts/compare_sasc_struct_free_with_size_field_trial.sh`
- Unknown25 `STRUCT_AllocWithOwner` SAS/C compare script: `src/decomp/scripts/compare_sasc_struct_alloc_with_owner_trial.sh`
- Unknown27 `FORMAT_Buffer2WriteChar` SAS/C compare script: `src/decomp/scripts/compare_sasc_format_buffer2_write_char_trial.sh`
- Unknown27 `FORMAT_FormatToBuffer2` SAS/C compare script: `src/decomp/scripts/compare_sasc_format_to_buffer2_trial.sh`
- Unknown2A `FORMAT_RawDoFmtWithScratchBuffer` SAS/C compare script: `src/decomp/scripts/compare_sasc_format_raw_dofmt_with_scratch_buffer_trial.sh`
- Unknown2A `UNKNOWN2A_Stub0` SAS/C compare script: `src/decomp/scripts/compare_sasc_unknown2a_stub0_trial.sh`
- Unknown28 `WDISP_FormatWithCallback` SAS/C compare script: `src/decomp/scripts/compare_sasc_wdisp_format_with_callback_trial.sh`
- Unknown30 `EXEC_CallVector_348` SAS/C compare script: `src/decomp/scripts/compare_sasc_exec_call_vector_348_trial.sh`
- Unknown31 `BUFFER_EnsureAllocated` SAS/C compare script: `src/decomp/scripts/compare_sasc_buffer_ensure_allocated_trial.sh`
- Unknown32 `HANDLE_CloseAllAndReturnWithCode` SAS/C compare script: `src/decomp/scripts/compare_sasc_handle_close_all_and_return_with_code_trial.sh`
- Unknown32 `UNKNOWN32_JMPTBL_ESQ_ReturnWithStackCode` SAS/C compare script: `src/decomp/scripts/compare_sasc_unknown32_jmptbl_esq_return_with_stack_code_trial.sh`
- Unknown35 `HANDLE_OpenWithMode` SAS/C compare script: `src/decomp/scripts/compare_sasc_handle_open_with_mode_trial.sh`
- Unknown36 `UNKNOWN36_FinalizeRequest` SAS/C compare script: `src/decomp/scripts/compare_sasc_unknown36_finalize_request_trial.sh`
- Unknown36 `UNKNOWN36_ShowAbortRequester` SAS/C compare script: `src/decomp/scripts/compare_sasc_unknown36_show_abort_requester_trial.sh`
- Unknown38 `SIGNAL_PollAndDispatch` SAS/C compare script: `src/decomp/scripts/compare_sasc_signal_poll_and_dispatch_trial.sh`
- Unknown39 `GRAPHICS_BltBitMapRastPort` SAS/C compare script: `src/decomp/scripts/compare_sasc_graphics_bltbitmaprastport_trial.sh`
- Unknown DISKIO `DISKIO_GetFilesizeFromHandle` SAS/C compare script: `src/decomp/scripts/compare_sasc_diskio_get_filesize_from_handle_trial.sh`
- Unknown DISKIO `DISKIO_QueryVolumeSoftErrorCount` SAS/C compare script: `src/decomp/scripts/compare_sasc_diskio_query_volume_soft_error_count_trial.sh`
- Unknown DISKIO `DISKIO_WriteBytesToOutputHandleGuarded` SAS/C compare script: `src/decomp/scripts/compare_sasc_diskio_write_bytes_to_output_handle_guarded_trial.sh`
- Unknown DISKIO `DISKIO_ForceUiRefreshIfIdle` SAS/C compare script: `src/decomp/scripts/compare_sasc_diskio_force_ui_refresh_if_idle_trial.sh`
- Unknown DISKIO `DISKIO_ResetCtrlInputStateIfIdle` SAS/C compare script: `src/decomp/scripts/compare_sasc_diskio_reset_ctrl_input_state_if_idle_trial.sh`
- Unknown DISKIO `DISKIO_DrawTransferErrorMessageIfDiagnostics` SAS/C compare script: `src/decomp/scripts/compare_sasc_diskio_draw_transfer_error_message_if_diagnostics_trial.sh`
- Unknown DISKIO `DISKIO_EnsurePc1MountedAndGfxAssigned` SAS/C compare script: `src/decomp/scripts/compare_sasc_diskio_ensure_pc1_mounted_and_gfx_assigned_trial.sh`
- Unknown DISKIO `DISKIO_ConsumeCStringFromWorkBuffer` SAS/C compare script: `src/decomp/scripts/compare_sasc_diskio_consume_cstring_from_work_buffer_trial.sh`
- Unknown DISKIO `DISKIO_ParseLongFromWorkBuffer` SAS/C compare script: `src/decomp/scripts/compare_sasc_diskio_parse_long_from_work_buffer_trial.sh`
- Unknown DISKIO `DISKIO_ConsumeLineFromWorkBuffer` SAS/C compare script: `src/decomp/scripts/compare_sasc_diskio_consume_line_from_work_buffer_trial.sh`
- Unknown DISKIO `DISKIO_LoadFileToWorkBuffer` SAS/C compare script: `src/decomp/scripts/compare_sasc_diskio_load_file_to_work_buffer_trial.sh`
- Unknown DISKIO `DISKIO_OpenFileWithBuffer` SAS/C compare script: `src/decomp/scripts/compare_sasc_diskio_open_file_with_buffer_trial.sh`
- Unknown DISKIO `DISKIO_QueryDiskUsagePercentAndSetBufferSize` SAS/C compare script: `src/decomp/scripts/compare_sasc_diskio_query_disk_usage_percent_and_set_buffer_size_trial.sh`
- Unknown DISKIO `DISKIO_WriteBufferedBytes` SAS/C compare script: `src/decomp/scripts/compare_sasc_diskio_write_buffered_bytes_trial.sh`
- Unknown DISKIO `DISKIO_CloseBufferedFileAndFlush` SAS/C compare script: `src/decomp/scripts/compare_sasc_diskio_close_buffered_file_and_flush_trial.sh`
- Unknown DISKIO `DISKIO_LoadConfigFromDisk` SAS/C compare script: `src/decomp/scripts/compare_sasc_diskio_load_config_from_disk_trial.sh`
- Unknown DISKIO `DISKIO_SaveConfigToFileHandle` SAS/C compare script: `src/decomp/scripts/compare_sasc_diskio_save_config_to_file_handle_trial.sh`
- Unknown DISKIO `DISKIO_ParseConfigBuffer` SAS/C compare script: `src/decomp/scripts/compare_sasc_diskio_parse_config_buffer_trial.sh`
- Unknown DISKIO `DISKIO_CloseBufferedFileAndFlush_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_diskio_close_buffered_file_and_flush_return_trial.sh`
- Unknown DISKIO `DISKIO_WriteBufferedBytes_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_diskio_write_buffered_bytes_return_trial.sh`
- Unknown DISKIO `DISKIO_EnsurePc1MountedAndGfxAssigned_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_diskio_ensure_pc1_mounted_and_gfx_assigned_return_trial.sh`
- Unknown DISKIO `DISKIO_SaveConfigToFileHandle_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_diskio_save_config_to_file_handle_return_trial.sh`
- Unknown DISKIO `DISKIO_ProbeDrivesAndAssignPaths` SAS/C compare script: `src/decomp/scripts/compare_sasc_diskio_probe_drives_and_assign_paths_trial.sh`
- Unknown ESQSHARED `ESQSHARED_MatchSelectionCodeWithOptionalSuffix_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqshared_match_selection_code_with_optional_suffix_return_trial.sh`
- Unknown ESQSHARED `ESQSHARED_CreateGroupEntryAndTitle_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqshared_create_group_entry_and_title_return_trial.sh`
- Unknown ESQSHARED `ESQSHARED_NormalizeInStereoTag_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqshared_normalize_in_stereo_tag_return_trial.sh`
- Unknown ESQSHARED `ESQSHARED_UpdateMatchingEntriesByTitle_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqshared_update_matching_entries_by_title_return_trial.sh`
- Unknown ESQPARS `ESQPARS_RemoveGroupEntryAndReleaseStrings_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqpars_remove_group_entry_and_release_strings_return_trial.sh`
- Unknown ESQPARS `ESQPARS_ReplaceOwnedString_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqpars_replace_owned_string_return_trial.sh`
- Unknown ESQPARS `ESQPARS_ReadLengthWordWithChecksumXor_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqpars_read_length_word_with_checksum_xor_return_trial.sh`
- Unknown DISPLIB `DISPLIB_FindPreviousValidEntryIndex_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_displib_find_previous_valid_entry_index_return_trial.sh`
- Unknown DISPLIB `DISPLIB_ApplyInlineAlignmentPadding_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_displib_apply_inline_alignment_padding_return_trial.sh`
- Unknown DISKIO1 `DISKIO1_DumpDefaultCoiInfoBlock_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_diskio1_dump_default_coi_info_block_return_trial.sh`
- Unknown DISKIO1 `DISKIO1_DumpProgramSourceRecordVerbose_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_diskio1_dump_program_source_record_verbose_return_trial.sh`
- Unknown DISKIO1 `DISKIO1_DumpProgramInfoAttrTable_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_diskio1_dump_program_info_attr_table_return_trial.sh`
- Unknown DISKIO1 `DISKIO1_AdvanceTimeSlotBitIndex` SAS/C compare script: `src/decomp/scripts/compare_sasc_diskio1_advance_time_slot_bit_index_trial.sh`
- Unknown DISKIO1 `DISKIO1_AdvanceBlackoutBitIndex` SAS/C compare script: `src/decomp/scripts/compare_sasc_diskio1_advance_blackout_bit_index_trial.sh`
- Unknown DISKIO1 `DISKIO1_AccumulateTimeSlotMaskSum` SAS/C compare script: `src/decomp/scripts/compare_sasc_diskio1_accumulate_time_slot_mask_sum_trial.sh`
- Unknown DISKIO1 `DISKIO1_AccumulateBlackoutMaskSum` SAS/C compare script: `src/decomp/scripts/compare_sasc_diskio1_accumulate_blackout_mask_sum_trial.sh`
- Unknown DISKIO1 `DISKIO1_AppendAttrFlagHiliteSrc` SAS/C compare script: `src/decomp/scripts/compare_sasc_diskio1_append_attr_flag_hilite_src_trial.sh`
- Unknown DISKIO1 `DISKIO1_AppendAttrFlagSummarySrc` SAS/C compare script: `src/decomp/scripts/compare_sasc_diskio1_append_attr_flag_summary_src_trial.sh`
- Unknown DISKIO1 `DISKIO1_AppendAttrFlagVideoTagDisable` SAS/C compare script: `src/decomp/scripts/compare_sasc_diskio1_append_attr_flag_video_tag_disable_trial.sh`
- Unknown DISKIO1 `DISKIO1_AppendAttrFlagPpvSrc` SAS/C compare script: `src/decomp/scripts/compare_sasc_diskio1_append_attr_flag_ppv_src_trial.sh`
- Unknown DISKIO1 `DISKIO1_AppendAttrFlagDitto` SAS/C compare script: `src/decomp/scripts/compare_sasc_diskio1_append_attr_flag_ditto_trial.sh`
- Unknown DISKIO1 `DISKIO1_AppendAttrFlagAltHiliteSrc` SAS/C compare script: `src/decomp/scripts/compare_sasc_diskio1_append_attr_flag_alt_hilite_src_trial.sh`
- Unknown DISKIO1 `DISKIO1_AppendAttrFlagBit7` SAS/C compare script: `src/decomp/scripts/compare_sasc_diskio1_append_attr_flag_bit7_trial.sh`
- Unknown DISKIO1 `DISKIO1_AppendTimeSlotMaskValueHeader` SAS/C compare script: `src/decomp/scripts/compare_sasc_diskio1_append_time_slot_mask_value_header_trial.sh`
- Unknown DISKIO1 `DISKIO1_AppendTimeSlotMaskValueTerminator` SAS/C compare script: `src/decomp/scripts/compare_sasc_diskio1_append_time_slot_mask_value_terminator_trial.sh`
- Unknown DISKIO1 `DISKIO1_AppendBlackoutMaskValueHeader` SAS/C compare script: `src/decomp/scripts/compare_sasc_diskio1_append_blackout_mask_value_header_trial.sh`
- Unknown DISKIO1 `DISKIO1_AppendBlackoutMaskValueTerminator` SAS/C compare script: `src/decomp/scripts/compare_sasc_diskio1_append_blackout_mask_value_terminator_trial.sh`
- Unknown GCOMMAND `GCOMMAND_SetPresetEntry_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_gcommand_set_preset_entry_return_trial.sh`
- Unknown GCOMMAND `GCOMMAND_ExpandPresetBlock_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_gcommand_expand_preset_block_return_trial.sh`
- Unknown GCOMMAND `GCOMMAND_ValidatePresetTable_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_gcommand_validate_preset_table_return_trial.sh`
- Unknown GCOMMAND `GCOMMAND_InitPresetTableFromPalette_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_gcommand_init_preset_table_from_palette_return_trial.sh`
- Unknown GCOMMAND `GCOMMAND_UpdatePresetEntryCache_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_gcommand_update_preset_entry_cache_return_trial.sh`
- Unknown LADFUNC2 `LADFUNC2_EmitEscapedStringWithLimit_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_ladfunc2_emit_escaped_string_with_limit_return_trial.sh`
- Unknown LADFUNC2 `LADFUNC2_EmitEscapedStringChunked_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_ladfunc2_emit_escaped_string_chunked_return_trial.sh`
- Unknown LOCAVAIL `LOCAVAIL_ParseFilterStateFromBuffer_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_locavail_parse_filter_state_from_buffer_return_trial.sh`
- Unknown LOCAVAIL `LOCAVAIL_MapFilterTokenCharToClass_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_locavail_map_filter_token_char_to_class_return_trial.sh`
- Unknown LOCAVAIL `LOCAVAIL_ComputeFilterOffsetForEntry_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_locavail_compute_filter_offset_for_entry_return_trial.sh`
- Unknown LOCAVAIL `LOCAVAIL_SaveAvailabilityDataFile_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_locavail_save_availability_data_file_return_trial.sh`
- Unknown LOCAVAIL `LOCAVAIL_LoadAvailabilityDataFile_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_locavail_load_availability_data_file_return_trial.sh`
- Unknown LOCAVAIL `LOCAVAIL_UpdateFilterStateMachine_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_locavail_update_filter_state_machine_return_trial.sh`
- Unknown FLIB `FLIB_AppendClockStampedLogEntry_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_flib_append_clock_stamped_log_entry_return_trial.sh`
- Unknown LADFUNC `LADFUNC_RepackEntryTextAndAttrBuffers_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_ladfunc_repack_entry_text_and_attr_buffers_return_trial.sh`
- Unknown LADFUNC `LADFUNC_UpdateEntryFromTextAndAttrBuffers_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_ladfunc_update_entry_from_text_and_attr_buffers_return_trial.sh`
- Unknown ESQIFF2 `ESQIFF2_ApplyIncomingStatusPacket_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff2_apply_incoming_status_packet_return_trial.sh`
- Unknown ESQIFF2 `ESQIFF2_ReadSerialBytesToBuffer_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff2_read_serial_bytes_to_buffer_return_trial.sh`
- Unknown ESQIFF2 `ESQIFF2_ReadSerialBytesWithXor_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff2_read_serial_bytes_with_xor_return_trial.sh`
- Unknown ESQIFF2 `ESQIFF2_ValidateFieldIndexAndLength_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff2_validate_field_index_and_length_return_trial.sh`
- Unknown ESQIFF2 `ESQIFF2_PadEntriesToMaxTitleWidth_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff2_pad_entries_to_max_title_width_return_trial.sh`
- Unknown ESQIFF2 `ESQIFF2_ParseLineHeadTailRecord_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff2_parse_line_head_tail_record_return_trial.sh`
- Unknown ESQIFF2 `ESQIFF2_ParseGroupRecordAndRefresh_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff2_parse_group_record_and_refresh_return_trial.sh`
- Unknown ESQIFF2 `ESQIFF2_ReadSerialRecordIntoBuffer_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff2_read_serial_record_into_buffer_return_trial.sh`
- Unknown ESQIFF2 `ESQIFF2_ReadSerialSizedTextRecord_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff2_read_serial_sized_text_record_return_trial.sh`
- Unknown ESQIFF2 `ESQIFF2_ShowVersionMismatchOverlay_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff2_show_version_mismatch_overlay_return_trial.sh`
- Unknown ESQIFF2 `ESQIFF2_ShowAttentionOverlay_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff2_show_attention_overlay_return_trial.sh`
- Unknown ESQIFF2 `ESQIFF2_ClearPrimaryEntryFlags34To39_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff2_clear_primary_entry_flags34_to39_return_trial.sh`
- Unknown ESQ `ESQ_ShutdownAndReturn` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_shutdown_and_return_trial.sh`
- Unknown ESQIFF `ESQIFF_ShowExternalAssetWithCopperFx_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff_show_external_asset_with_copper_fx_return_trial.sh`
- Unknown ESQIFF `ESQIFF_PlayNextExternalAssetFrame_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff_play_next_external_asset_frame_return_trial.sh`
- Unknown ESQSHARED4 `ESQSHARED4_ApplyBannerColorStep_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqshared4_apply_banner_color_step_return_trial.sh`
- Unknown41 `CLOCK_ConvertAmigaSecondsToClockData` SAS/C compare script: `src/decomp/scripts/compare_sasc_clock_convert_amiga_seconds_to_clock_data_trial.sh`
- Unknown41 `CLOCK_ConvertAmigaSecondsToClockData` SAS/C compare alias script (`clock_convert` naming): `src/decomp/scripts/compare_sasc_clock_convert_trial.sh`
- Unknown DISKIO `DISKIO_WriteDecimalField` SAS/C compare script: `src/decomp/scripts/compare_sasc_diskio_write_decimal_field_trial.sh`
- Unknown7 `STR_CopyUntilAnyDelimN` SAS/C compare script: `src/decomp/scripts/compare_sasc_str_copy_until_any_delim_n_trial.sh`
- Unknown7 `STR_FindChar` SAS/C compare script: `src/decomp/scripts/compare_sasc_str_find_char_trial.sh`
- Unknown7 `STR_FindCharPtr` SAS/C compare script: `src/decomp/scripts/compare_sasc_str_find_char_ptr_trial.sh`
- Unknown7 `STR_FindAnyCharInSet` SAS/C compare script: `src/decomp/scripts/compare_sasc_str_find_any_char_in_set_trial.sh`
- Unknown7 `STR_FindAnyCharPtr` SAS/C compare script: `src/decomp/scripts/compare_sasc_str_find_any_char_ptr_trial.sh`
- Unknown7 `STR_SkipClass3Chars` SAS/C compare script: `src/decomp/scripts/compare_sasc_str_skip_class3_chars_trial.sh`
- Unknown8 `FORMAT_U32ToDecimalString` SAS/C compare script: `src/decomp/scripts/compare_sasc_format_u32_to_decimal_string_trial.sh`
- Unknown9 `FORMAT_U32ToOctalString` SAS/C compare script: `src/decomp/scripts/compare_sasc_format_u32_to_octal_string_trial.sh`
- Unknown10 `FORMAT_U32ToHexString` SAS/C compare script: `src/decomp/scripts/compare_sasc_format_u32_to_hex_trial.sh`
- Unknown10 `UNKNOWN10_PrintfPutcToBuffer` SAS/C compare script: `src/decomp/scripts/compare_sasc_unknown10_printf_putc_to_buffer_trial.sh`
- Unknown10 `WDISP_SPrintf` SAS/C compare script: `src/decomp/scripts/compare_sasc_wdisp_sprintf_trial.sh`
- Unknown10 `PARSE_ReadSignedLong` SAS/C compare script: `src/decomp/scripts/compare_sasc_parse_read_signed_long_trial.sh`
- Unknown10 `PARSE_ReadSignedLong_NoBranch` SAS/C compare script: `src/decomp/scripts/compare_sasc_parse_read_signed_long_nobranch_trial.sh`
- Unknown10 `HANDLE_OpenEntryWithFlags` SAS/C compare script: `src/decomp/scripts/compare_sasc_handle_open_entry_with_flags_trial.sh`
- Unknown13 `FORMAT_CallbackWriteChar` SAS/C compare script: `src/decomp/scripts/compare_sasc_format_callback_write_char_trial.sh`
- Unknown13 `FORMAT_FormatToCallbackBuffer` SAS/C compare script: `src/decomp/scripts/compare_sasc_format_to_callback_buffer_trial.sh`
- Unknown14 `HANDLE_OpenFromModeString` SAS/C compare script: `src/decomp/scripts/compare_sasc_handle_open_from_mode_string_trial.sh`
- Unknown15 `STREAM_ReadLineWithLimit` SAS/C compare script: `src/decomp/scripts/compare_sasc_stream_read_line_with_limit_trial.sh`
- Unknown16 `BUFFER_FlushAllAndCloseWithCode` SAS/C compare script: `src/decomp/scripts/compare_sasc_buffer_flush_all_and_close_with_code_trial.sh`
- Unknown29 `UNKNOWN29_JMPTBL_ESQ_MainInitAndRun` SAS/C compare script: `src/decomp/scripts/compare_sasc_unknown29_jmptbl_esq_main_init_and_run_trial.sh`
- Unknown29 `ESQ_ParseCommandLineAndRun` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_parse_command_line_and_run_trial.sh`
- Unknown2B `ESQ_MainEntryNoOpHook` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_main_entry_noop_hook_trial.sh`
- Unknown2B `ESQ_MainExitNoOpHook` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_main_exit_noop_hook_trial.sh`
- Unknown2B `DOS_OpenFileWithMode` SAS/C compare script: `src/decomp/scripts/compare_sasc_dos_open_file_with_mode_trial.sh`
- Unknown2B `GRAPHICS_AllocRaster` SAS/C compare script: `src/decomp/scripts/compare_sasc_graphics_alloc_raster_trial.sh`
- Unknown2B `GRAPHICS_FreeRaster` SAS/C compare script: `src/decomp/scripts/compare_sasc_graphics_free_raster_trial.sh`
- Unknown2B `DOS_MovepWordReadCallback` remains GCC-only for now (`compare_dos_movep_word_read_callback_trial_gcc.sh`): SAS/C here does not accept inline-assembly/register-binding forms needed to force the `MOVEP.W 0(A2),D6` callback shape.
- Unknown `ESQPROTO_CopyLabelToGlobal` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqproto_copy_label_to_global_trial.sh`
- Unknown `ESQPROTO_ParseDigitLabelAndDisplay` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqproto_parse_digit_label_and_display_trial.sh`
- Unknown `UNKNOWN_ParseRecordAndUpdateDisplay` SAS/C compare script: `src/decomp/scripts/compare_sasc_unknown_parse_record_and_update_display_trial.sh`
- Unknown `UNKNOWN_ParseListAndUpdateEntries` SAS/C compare script: `src/decomp/scripts/compare_sasc_unknown_parse_list_and_update_entries_trial.sh`
- Unknown `ESQPROTO_VerifyChecksumAndParseRecord` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqproto_verify_checksum_and_parse_record_trial.sh`
- Unknown `ESQPROTO_VerifyChecksumAndParseList` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqproto_verify_checksum_and_parse_list_trial.sh`
- DATETIME `DATETIME_IsLeapYear` SAS/C compare script: `src/decomp/scripts/compare_sasc_datetime_isleapyear_trial.sh`
- DATETIME `DATETIME_AdjustMonthIndex` SAS/C compare script: `src/decomp/scripts/compare_sasc_datetime_adjust_month_index_trial.sh`
- DATETIME `DATETIME_NormalizeMonthRange` SAS/C compare script: `src/decomp/scripts/compare_sasc_datetime_normalize_month_range_trial.sh`
- DST `DST_NormalizeDayOfYear` SAS/C compare script: `src/decomp/scripts/compare_sasc_dst_normalize_day_of_year_trial.sh`
- DST `DST_BuildBannerTimeWord` SAS/C compare script: `src/decomp/scripts/compare_sasc_dst_build_banner_time_word_trial.sh`
- DST `DST_FreeBannerStruct` SAS/C compare script: `src/decomp/scripts/compare_sasc_dst_free_banner_struct_trial.sh`
- DST `DST_FreeBannerPair` SAS/C compare script: `src/decomp/scripts/compare_sasc_dst_free_banner_pair_trial.sh`
- DST `DST_AllocateBannerStruct` SAS/C compare script: `src/decomp/scripts/compare_sasc_dst_allocate_banner_struct_trial.sh`
- DST `DST_RebuildBannerPair` SAS/C compare script: `src/decomp/scripts/compare_sasc_dst_rebuild_banner_pair_trial.sh`
- DST `DST_ComputeBannerIndex` SAS/C compare script: `src/decomp/scripts/compare_sasc_dst_compute_banner_index_trial.sh`
- DST `DST_TickBannerCounters` SAS/C compare script: `src/decomp/scripts/compare_sasc_dst_tick_banner_counters_trial.sh`
- DST `DST_AddTimeOffset` SAS/C compare script: `src/decomp/scripts/compare_sasc_dst_add_time_offset_trial.sh`
- DST `DST_WriteRtcFromGlobals` SAS/C compare script: `src/decomp/scripts/compare_sasc_dst_write_rtc_from_globals_trial.sh`
- DST `DST_HandleBannerCommand32_33` SAS/C compare script: `src/decomp/scripts/compare_sasc_dst_handle_banner_command32_33_trial.sh`
- DST `DST_BuildBannerTimeEntry` SAS/C compare script: `src/decomp/scripts/compare_sasc_dst_build_banner_time_entry_trial.sh`
- DST `DST_FormatBannerDateTime` SAS/C compare script: `src/decomp/scripts/compare_sasc_dst_format_banner_datetime_trial.sh`
- DST `DST_UpdateBannerQueue` SAS/C compare script: `src/decomp/scripts/compare_sasc_dst_update_banner_queue_trial.sh`
- DST `DST_RefreshBannerBuffer` SAS/C compare script: `src/decomp/scripts/compare_sasc_dst_refresh_banner_buffer_trial.sh`
- DST `DST_LoadBannerPairFromFiles` SAS/C compare script: `src/decomp/scripts/compare_sasc_dst_load_banner_pair_from_files_trial.sh`
- Unknown `UNKNOWN_JMPTBL_ESQIFF2_ReadSerialRecordIntoBuffer` SAS/C compare script: `src/decomp/scripts/compare_sasc_unknown_jmptbl_esqiff2_read_serial_record_into_buffer_trial.sh`
- Unknown `UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition` SAS/C compare script: `src/decomp/scripts/compare_sasc_unknown_jmptbl_displib_display_text_at_position_trial.sh`
- Unknown `UNKNOWN_JMPTBL_ESQ_WildcardMatch` SAS/C compare script: `src/decomp/scripts/compare_sasc_unknown_jmptbl_esq_wildcard_match_trial.sh`
- Unknown `UNKNOWN_JMPTBL_DST_NormalizeDayOfYear` SAS/C compare script: `src/decomp/scripts/compare_sasc_unknown_jmptbl_dst_normalize_day_of_year_trial.sh`
- Unknown `UNKNOWN_JMPTBL_ESQ_GenerateXorChecksumByte` SAS/C compare script: `src/decomp/scripts/compare_sasc_unknown_jmptbl_esq_generate_xor_checksum_byte_trial.sh`
- Unknown `ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqproto_jmptbl_esqpars_replace_owned_string_trial.sh`
- Group AG `GROUP_AG_JMPTBL_MEMORY_DeallocateMemory` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ag_jmptbl_memory_deallocate_memory_trial.sh`
- Group AG `GROUP_AG_JMPTBL_MEMORY_AllocateMemory` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ag_jmptbl_memory_allocate_memory_trial.sh`
- Group AG `GROUP_AG_JMPTBL_MATH_DivS32` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ag_jmptbl_math_divs32_trial.sh`
- Group AG `GROUP_AG_JMPTBL_MATH_Mulu32` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ag_jmptbl_math_mulu32_trial.sh`
- Group AG `GROUP_AG_JMPTBL_SIGNAL_CreateMsgPortWithSignal` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ag_jmptbl_signal_create_msgport_with_signal_trial.sh`
- Group AG `GROUP_AG_JMPTBL_STRUCT_FreeWithSizeField` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ag_jmptbl_struct_free_with_size_field_trial.sh`
- Group AG `GROUP_AG_JMPTBL_STRUCT_AllocWithOwner` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ag_jmptbl_struct_alloc_with_owner_trial.sh`
- Group AG `GROUP_AG_JMPTBL_IOSTDREQ_CleanupSignalAndMsgport` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ag_jmptbl_iostdreq_cleanup_signal_and_msgport_trial.sh`
- Group AG `GROUP_AG_JMPTBL_STRING_CopyPadNul` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ag_jmptbl_string_copy_pad_nul_trial.sh`
- Group AG `GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ag_jmptbl_parse_read_signed_long_skip_class3_alt_trial.sh`
- Group AG `GROUP_AG_JMPTBL_DOS_OpenFileWithMode` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ag_jmptbl_dos_open_file_with_mode_trial.sh`
- Group AG `GROUP_AG_JMPTBL_SCRIPT_CheckPathExists` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ag_jmptbl_script_check_path_exists_trial.sh`
- Group AG `GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ag_jmptbl_esqfunc_service_ui_tick_if_running_trial.sh`
- Group AG `GROUP_AG_JMPTBL_ESQFUNC_UpdateRefreshModeState` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ag_jmptbl_esqfunc_update_refresh_mode_state_trial.sh`
- Group AG `GROUP_AG_JMPTBL_TEXTDISP_ResetSelectionAndRefresh` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ag_jmptbl_textdisp_reset_selection_and_refresh_trial.sh`
- Group AG `GROUP_AG_JMPTBL_SCRIPT_BeginBannerCharTransition` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ag_jmptbl_script_begin_banner_char_transition_trial.sh`
- Group AG `GROUP_AG_JMPTBL_LADFUNC2_EmitEscapedStringToScratch` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ag_jmptbl_ladfunc2_emit_escaped_string_to_scratch_trial.sh`
- Group MAIN_A `GROUP_MAIN_A_JMPTBL_ESQ_MainExitNoOpHook` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_main_a_jmptbl_esq_main_exit_noop_hook_trial.sh`
- Group MAIN_A `GROUP_MAIN_A_JMPTBL_ESQ_MainEntryNoOpHook` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_main_a_jmptbl_esq_main_entry_noop_hook_trial.sh`
- Group MAIN_A `GROUP_MAIN_A_JMPTBL_MEMLIST_FreeAll` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_main_a_jmptbl_memlist_free_all_trial.sh`
- Group MAIN_A `GROUP_MAIN_A_JMPTBL_ESQ_ParseCommandLineAndRun` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_main_a_jmptbl_esq_parse_command_line_and_run_trial.sh`
- Group MAIN_B `GROUP_MAIN_B_JMPTBL_DOS_Delay` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_main_b_jmptbl_dos_delay_trial.sh`
- Group MAIN_B `GROUP_MAIN_B_JMPTBL_STREAM_BufferedWriteString` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_main_b_jmptbl_stream_buffered_write_string_trial.sh`
- Group MAIN_B `GROUP_MAIN_B_JMPTBL_MATH_Mulu32` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_main_b_jmptbl_math_mulu32_trial.sh`
- Group MAIN_B `GROUP_MAIN_B_JMPTBL_BUFFER_FlushAllAndCloseWithCode` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_main_b_jmptbl_buffer_flush_all_and_close_with_code_trial.sh`
- Group AL `GROUP_AL_JMPTBL_LADFUNC_PackNibblesToByte` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_al_jmptbl_ladfunc_pack_nibbles_to_byte_trial.sh`
- Group AL `GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_al_jmptbl_ladfunc_extract_low_nibble_trial.sh`
- Group AL `GROUP_AL_JMPTBL_LADFUNC_UpdateEntryBuffersForAdIndex` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_al_jmptbl_ladfunc_update_entry_buffers_for_ad_index_trial.sh`
- Group AL `GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_al_jmptbl_esq_write_dec_fixed_width_trial.sh`
- Group AL `GROUP_AL_JMPTBL_LADFUNC_BuildEntryBuffersOrDefault` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_al_jmptbl_ladfunc_build_entry_buffers_or_default_trial.sh`
- Group AL `GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_al_jmptbl_ladfunc_extract_high_nibble_trial.sh`
- Group AY `GROUP_AY_JMPTBL_DISKIO_ConsumeCStringFromWorkBuffer` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ay_jmptbl_diskio_consume_cstring_from_work_buffer_trial.sh`
- Group AY `GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ay_jmptbl_diskio_parse_long_from_work_buffer_trial.sh`
- Group AY `GROUP_AY_JMPTBL_DISKIO_WriteDecimalField` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ay_jmptbl_diskio_write_decimal_field_trial.sh`
- Group AY `GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ay_jmptbl_diskio_write_buffered_bytes_trial.sh`
- Group AY `GROUP_AY_JMPTBL_DISKIO_CloseBufferedFileAndFlush` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ay_jmptbl_diskio_close_buffered_file_and_flush_trial.sh`
- Group AY `GROUP_AY_JMPTBL_STRING_CompareNoCaseN` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ay_jmptbl_string_compare_nocase_n_trial.sh`
- Group AY `GROUP_AY_JMPTBL_MATH_Mulu32` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ay_jmptbl_math_mulu32_trial.sh`
- Group AY `GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ay_jmptbl_diskio_load_file_to_work_buffer_trial.sh`
- Group AY `GROUP_AY_JMPTBL_SCRIPT_ReadCiaBBit5Mask` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ay_jmptbl_script_read_ciab_bit5_mask_trial.sh`
- Group AY `GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ay_jmptbl_diskio_open_file_with_buffer_trial.sh`
- Group AW `GROUP_AW_JMPTBL_TLIBA3_BuildDisplayContextForViewMode` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_aw_jmptbl_tliba3_build_display_context_for_view_mode_trial.sh`
- Group AW `GROUP_AW_JMPTBL_DISPLIB_ApplyInlineAlignmentPadding` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_aw_jmptbl_displib_apply_inline_alignment_padding_trial.sh`
- Group AW `GROUP_AW_JMPTBL_ESQIFF_RunCopperRiseTransition` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_aw_jmptbl_esqiff_run_copper_rise_transition_trial.sh`
- Group AW `GROUP_AW_JMPTBL_ESQIFF_RunCopperDropTransition` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_aw_jmptbl_esqiff_run_copper_drop_transition_trial.sh`
- Group AW `GROUP_AW_JMPTBL_DISPLIB_DisplayTextAtPosition` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_aw_jmptbl_displib_display_text_at_position_trial.sh`
- Group AW `GROUP_AW_JMPTBL_MEM_Move` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_aw_jmptbl_mem_move_trial.sh`
- Group AW `GROUP_AW_JMPTBL_WDISP_SPrintf` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_aw_jmptbl_wdisp_sprintf_trial.sh`
- Group AW `GROUP_AW_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_aw_jmptbl_esq_set_copper_effect_off_disable_highlight_trial.sh`
- Group AW `GROUP_AW_JMPTBL_STRING_CopyPadNul` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_aw_jmptbl_string_copy_pad_nul_trial.sh`
- Group AS `GROUP_AS_JMPTBL_STR_FindCharPtr` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_as_jmptbl_str_find_char_ptr_trial.sh`
- Group AS `GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_as_jmptbl_esq_find_substring_case_fold_trial.sh`
- Group AT `GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit0` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_at_jmptbl_ed1_wait_for_flag_and_clear_bit0_trial.sh`
- Group AT `GROUP_AT_JMPTBL_DOS_SystemTagList` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_at_jmptbl_dos_system_taglist_trial.sh`
- Group AT `GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit1` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_at_jmptbl_ed1_wait_for_flag_and_clear_bit1_trial.sh`
- Group AU `GROUP_AU_JMPTBL_BRUSH_AppendBrushNode` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_au_jmptbl_brush_append_brush_node_trial.sh`
- Group AU `GROUP_AU_JMPTBL_BRUSH_PopulateBrushList` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_au_jmptbl_brush_populate_brush_list_trial.sh`
- Group AX `GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ax_jmptbl_format_raw_dofmt_with_scratch_buffer_trial.sh`
- Group AZ `GROUP_AZ_JMPTBL_ESQ_ColdReboot` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_az_jmptbl_esq_cold_reboot_trial.sh`
- Group AA `GROUP_AA_JMPTBL_STRING_CompareNoCase` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_aa_jmptbl_string_compare_nocase_trial.sh`
- Group AA `GROUP_AA_JMPTBL_STRING_CompareN` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_aa_jmptbl_string_compare_n_trial.sh`
- Group AA `GROUP_AA_JMPTBL_GCOMMAND_FindPathSeparator` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_aa_jmptbl_gcommand_find_path_separator_trial.sh`
- Group AA `GROUP_AA_JMPTBL_GRAPHICS_AllocRaster` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_aa_jmptbl_graphics_alloc_raster_trial.sh`
- Group AR `GROUP_AR_JMPTBL_PARSEINI_WriteErrorLogEntry` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ar_jmptbl_parseini_write_error_log_entry_trial.sh`
- Group AR `GROUP_AR_JMPTBL_STRING_AppendAtNull` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ar_jmptbl_string_append_at_null_trial.sh`
- Group AF `GROUP_AF_JMPTBL_GCOMMAND_SaveBrushResult` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_af_jmptbl_gcommand_save_brush_result_trial.sh`
- Group AV `GROUP_AV_JMPTBL_ALLOCATE_AllocAndInitializeIOStdReq` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_av_jmptbl_allocate_alloc_and_initialize_iostdreq_trial.sh`
- Group AV `GROUP_AV_JMPTBL_SIGNAL_CreateMsgPortWithSignal` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_av_jmptbl_signal_create_msgport_with_signal_trial.sh`
- Group AV `GROUP_AV_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_av_jmptbl_diskio_probe_drives_and_assign_paths_trial.sh`
- Group AV `GROUP_AV_JMPTBL_ESQ_InvokeGcommandInit` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_av_jmptbl_esq_invoke_gcommand_init_trial.sh`
- Group AV `GROUP_AV_JMPTBL_EXEC_CallVector_48` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_av_jmptbl_exec_call_vector_48_trial.sh`
- Group AB `GROUP_AB_JMPTBL_ESQPARS_RemoveGroupEntryAndReleaseStrings` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ab_jmptbl_esqpars_remove_group_entry_and_release_strings_trial.sh`
- Group AB `GROUP_AB_JMPTBL_ESQFUNC_FreeLineTextBuffers` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ab_jmptbl_esqfunc_free_line_text_buffers_trial.sh`
- Group AB `GROUP_AB_JMPTBL_ESQIFF_DeallocateAdsAndLogoLstData` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ab_jmptbl_esqiff_deallocate_ads_and_logo_lst_data_trial.sh`
- Group AB `GROUP_AB_JMPTBL_LADFUNC_FreeBannerRectEntries` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ab_jmptbl_ladfunc_free_banner_rect_entries_trial.sh`
- Group AB `GROUP_AB_JMPTBL_UNKNOWN2A_Stub0` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ab_jmptbl_unknown2_a_stub0_trial.sh`
- Group AB `GROUP_AB_JMPTBL_NEWGRID_ShutdownGridResources` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ab_jmptbl_newgrid_shutdown_grid_resources_trial.sh`
- Group AB `GROUP_AB_JMPTBL_LOCAVAIL_FreeResourceChain` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ab_jmptbl_locavail_free_resource_chain_trial.sh`
- Group AB `GROUP_AB_JMPTBL_GRAPHICS_FreeRaster` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ab_jmptbl_graphics_free_raster_trial.sh`
- Group AB `GROUP_AB_JMPTBL_IOSTDREQ_Free` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ab_jmptbl_iostdreq_free_trial.sh`
- Group AB `GROUP_AB_JMPTBL_ESQIFF2_ClearLineHeadTailByMode` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ab_jmptbl_esqiff2_clear_line_head_tail_by_mode_trial.sh`
- Group AE `GROUP_AE_JMPTBL_TLIBA_FindFirstWildcardMatchIndex` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ae_jmptbl_tliba_find_first_wildcard_match_index_trial.sh`
- Group AE `GROUP_AE_JMPTBL_SCRIPT_BuildTokenIndexMap` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ae_jmptbl_script_build_token_index_map_trial.sh`
- Group AE `GROUP_AE_JMPTBL_ESQDISP_GetEntryAuxPointerByMode` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ae_jmptbl_esqdisp_get_entry_aux_pointer_by_mode_trial.sh`
- Group AE `GROUP_AE_JMPTBL_ESQDISP_GetEntryPointerByMode` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ae_jmptbl_esqdisp_get_entry_pointer_by_mode_trial.sh`
- Group AE `GROUP_AE_JMPTBL_LADFUNC_ParseHexDigit` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ae_jmptbl_ladfunc_parse_hex_digit_trial.sh`
- Group AE `GROUP_AE_JMPTBL_SCRIPT_DeallocateBufferArray` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ae_jmptbl_script_deallocate_buffer_array_trial.sh`
- Group AE `GROUP_AE_JMPTBL_WDISP_SPrintf` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ae_jmptbl_wdisp_s_printf_trial.sh`
- Group AE `GROUP_AE_JMPTBL_SCRIPT_AllocateBufferArray` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ae_jmptbl_script_allocate_buffer_array_trial.sh`
- Group AE `GROUP_AE_JMPTBL_TEXTDISP_ComputeTimeOffset` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ae_jmptbl_textdisp_compute_time_offset_trial.sh`
- Group AE `GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ae_jmptbl_esqpars_replace_owned_string_trial.sh`
- Group AJ `GROUP_AJ_JMPTBL_STRING_FindSubstring` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_aj_jmptbl_string_find_substring_trial.sh`
- Group AJ `GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_aj_jmptbl_format_raw_dofmt_with_scratch_buffer_trial.sh`
- Group AJ `GROUP_AJ_JMPTBL_MATH_DivU32` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_aj_jmptbl_math_div_u32_trial.sh`
- Group AJ `GROUP_AJ_JMPTBL_PARSEINI_WriteRtcFromGlobals` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_aj_jmptbl_parseini_write_rtc_from_globals_trial.sh`
- Group AJ `GROUP_AJ_JMPTBL_MATH_Mulu32` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_aj_jmptbl_math_mulu32_trial.sh`
- Group AI `GROUP_AI_JMPTBL_NEWGRID_SetSelectionMarkers` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ai_jmptbl_newgrid_set_selection_markers_trial.sh`
- Group AI `GROUP_AI_JMPTBL_STR_FindCharPtr` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ai_jmptbl_str_find_char_ptr_trial.sh`
- Group AI `GROUP_AI_JMPTBL_TLIBA1_DrawTextWithInsetSegments` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ai_jmptbl_tliba1_draw_text_with_inset_segments_trial.sh`
- Group AI `GROUP_AI_JMPTBL_FORMAT_FormatToBuffer2` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ai_jmptbl_format_format_to_buffer2_trial.sh`
- Group AI `GROUP_AI_JMPTBL_STR_SkipClass3Chars` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ai_jmptbl_str_skip_class3_chars_trial.sh`
- Group AI `GROUP_AI_JMPTBL_STRING_AppendAtNull` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ai_jmptbl_string_append_at_null_trial.sh`
- Group AI `GROUP_AI_JMPTBL_STR_CopyUntilAnyDelimN` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ai_jmptbl_str_copy_until_any_delim_n_trial.sh`
- Group AK `GROUP_AK_JMPTBL_CLEANUP_RenderAlignedStatusScreen` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ak_jmptbl_cleanup_render_aligned_status_screen_trial.sh`
- Group AK `GROUP_AK_JMPTBL_ESQPARS_ApplyRtcBytesAndPersist` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ak_jmptbl_esqpars_apply_rtc_bytes_and_persist_trial.sh`
- Group AK `GROUP_AK_JMPTBL_ESQ_SetCopperEffect_Custom` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ak_jmptbl_esq_set_copper_effect_custom_trial.sh`
- Group AK `GROUP_AK_JMPTBL_ESQ_SetCopperEffect_Default` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ak_jmptbl_esq_set_copper_effect_default_trial.sh`
- Group AK `GROUP_AK_JMPTBL_GCOMMAND_GetBannerChar` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ak_jmptbl_gcommand_get_banner_char_trial.sh`
- Group AK `GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ak_jmptbl_parseini_parse_ini_buffer_and_dispatch_trial.sh`
- Group AK `GROUP_AK_JMPTBL_PARSEINI_ScanLogoDirectory` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ak_jmptbl_parseini_scan_logo_directory_trial.sh`
- Group AK `GROUP_AK_JMPTBL_PARSEINI_WriteErrorLogEntry` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ak_jmptbl_parseini_write_error_log_entry_trial.sh`
- Group AK `GROUP_AK_JMPTBL_SCRIPT_DeassertCtrlLineNow` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ak_jmptbl_script_deassert_ctrl_line_now_trial.sh`
- Group AK `GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ak_jmptbl_script_update_serial_shadow_from_ctrl_byte_trial.sh`
- Group AK `GROUP_AK_JMPTBL_TEXTDISP_FormatEntryTimeForIndex` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ak_jmptbl_textdisp_format_entry_time_for_index_trial.sh`
- Group AK `GROUP_AK_JMPTBL_TLIBA3_SelectNextViewMode` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ak_jmptbl_tliba3_select_next_view_mode_trial.sh`
- Group AK `GROUP_AK_JMPTBL_ESQ_SetCopperEffect_AllOn` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ak_jmptbl_esq_set_copper_effect_all_on_trial.sh`
- Group AK `GROUP_AK_JMPTBL_GCOMMAND_CopyGfxToWorkIfAvailable` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ak_jmptbl_gcommand_copy_gfx_to_work_if_available_trial.sh`
- Group AK `GROUP_AK_JMPTBL_SCRIPT_AssertCtrlLineNow` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ak_jmptbl_script_assert_ctrl_line_now_trial.sh`
- Group AK `GROUP_AK_JMPTBL_TLIBA3_DrawViewModeGuides` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ak_jmptbl_tliba3_draw_view_mode_guides_trial.sh`
- Group AC `GROUP_AC_JMPTBL_PARSEINI_UpdateClockFromRtc` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ac_jmptbl_parseini_update_clock_from_rtc_trial.sh`
- Group AC `GROUP_AC_JMPTBL_ESQFUNC_DrawDiagnosticsScreen` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ac_jmptbl_esqfunc_draw_diagnostics_screen_trial.sh`
- Group AC `GROUP_AC_JMPTBL_ESQFUNC_DrawMemoryStatusScreen` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ac_jmptbl_esqfunc_draw_memory_status_screen_trial.sh`
- Group AC `GROUP_AC_JMPTBL_SCRIPT_UpdateCtrlStateMachine` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ac_jmptbl_script_update_ctrl_state_machine_trial.sh`
- Group AC `GROUP_AC_JMPTBL_GCOMMAND_UpdateBannerBounds` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ac_jmptbl_gcommand_update_banner_bounds_trial.sh`
- Group AC `GROUP_AC_JMPTBL_SCRIPT_UpdateCtrlLineTimeout` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ac_jmptbl_script_update_ctrl_line_timeout_trial.sh`
- Group AC `GROUP_AC_JMPTBL_SCRIPT_ClearCtrlLineIfEnabled` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ac_jmptbl_script_clear_ctrl_line_if_enabled_trial.sh`
- Group AC `GROUP_AC_JMPTBL_ESQFUNC_FreeExtraTitleTextPointers` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ac_jmptbl_esqfunc_free_extra_title_text_pointers_trial.sh`
- Group AC `GROUP_AC_JMPTBL_ESQDISP_DrawStatusBanner` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ac_jmptbl_esqdisp_draw_status_banner_trial.sh`
- Group AC `GROUP_AC_JMPTBL_DST_UpdateBannerQueue` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ac_jmptbl_dst_update_banner_queue_trial.sh`
- Group AC `GROUP_AC_JMPTBL_DST_RefreshBannerBuffer` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ac_jmptbl_dst_refresh_banner_buffer_trial.sh`
- Group AC `GROUP_AC_JMPTBL_ESQFUNC_DrawEscMenuVersion` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ac_jmptbl_esqfunc_draw_esc_menu_version_trial.sh`
- Group AC `GROUP_AC_JMPTBL_PARSEINI_AdjustHoursTo24HrFormat` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ac_jmptbl_parseini_adjust_hours_to24_hr_format_trial.sh`
- Group AD `GROUP_AD_JMPTBL_TLIBA3_BuildDisplayContextForViewMode` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ad_jmptbl_tliba3_build_display_context_for_view_mode_trial.sh`
- Group AD `GROUP_AD_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ad_jmptbl_script_update_serial_shadow_from_ctrl_byte_trial.sh`
- Group AD `GROUP_AD_JMPTBL_DATETIME_NormalizeMonthRange` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ad_jmptbl_datetime_normalize_month_range_trial.sh`
- Group AD `GROUP_AD_JMPTBL_TEXTDISP_DrawChannelBanner` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ad_jmptbl_textdisp_draw_channel_banner_trial.sh`
- Group AD `GROUP_AD_JMPTBL_TEXTDISP_FormatEntryTime` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ad_jmptbl_textdisp_format_entry_time_trial.sh`
- Group AD `GROUP_AD_JMPTBL_ESQIFF_RunCopperRiseTransition` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ad_jmptbl_esqiff_run_copper_rise_transition_trial.sh`
- Group AD `GROUP_AD_JMPTBL_TEXTDISP_BuildEntryShortName` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ad_jmptbl_textdisp_build_entry_short_name_trial.sh`
- Group AD `GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ad_jmptbl_graphics_blt_bitmap_rast_port_trial.sh`
- Group AD `GROUP_AD_JMPTBL_ESQIFF_RunCopperDropTransition` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ad_jmptbl_esqiff_run_copper_drop_transition_trial.sh`
- Group AD `GROUP_AD_JMPTBL_TLIBA1_BuildClockFormatEntryIfVisible` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ad_jmptbl_tliba1_build_clock_format_entry_if_visible_trial.sh`
- Group AD `GROUP_AD_JMPTBL_TEXTDISP_BuildChannelLabel` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ad_jmptbl_textdisp_build_channel_label_trial.sh`
- Group AD `GROUP_AD_JMPTBL_TEXTDISP_DrawInsetRectFrame` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ad_jmptbl_textdisp_draw_inset_rect_frame_trial.sh`
- Group AD `GROUP_AD_JMPTBL_TEXTDISP_TrimTextToPixelWidth` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ad_jmptbl_textdisp_trim_text_to_pixel_width_trial.sh`
- Group AD `GROUP_AD_JMPTBL_TLIBA3_GetViewModeRastPort` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ad_jmptbl_tliba3_get_view_mode_rast_port_trial.sh`
- Group AD `GROUP_AD_JMPTBL_ESQFUNC_SelectAndApplyBrushForCurrentEntry` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ad_jmptbl_esqfunc_select_and_apply_brush_for_current_entry_trial.sh`
- Group AD `GROUP_AD_JMPTBL_DATETIME_AdjustMonthIndex` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ad_jmptbl_datetime_adjust_month_index_trial.sh`
- Group AD `GROUP_AD_JMPTBL_DST_ComputeBannerIndex` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ad_jmptbl_dst_compute_banner_index_trial.sh`
- Group AD `GROUP_AD_JMPTBL_TLIBA3_GetViewModeHeight` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ad_jmptbl_tliba3_get_view_mode_height_trial.sh`
- Group AH `GROUP_AH_JMPTBL_ESQIFF2_ApplyIncomingStatusPacket` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ah_jmptbl_esqiff2_apply_incoming_status_packet_trial.sh`
- Group AH `GROUP_AH_JMPTBL_NEWGRID_RebuildIndexCache` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ah_jmptbl_newgrid_rebuild_index_cache_trial.sh`
- Group AH `GROUP_AH_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ah_jmptbl_esqshared_apply_program_title_text_filters_trial.sh`
- Group AH `GROUP_AH_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ah_jmptbl_esqdisp_update_status_mask_and_refresh_trial.sh`
- Group AH `GROUP_AH_JMPTBL_ESQSHARED_InitEntryDefaults` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ah_jmptbl_esqshared_init_entry_defaults_trial.sh`
- Group AH `GROUP_AH_JMPTBL_GCOMMAND_LoadPPVTemplate` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ah_jmptbl_gcommand_load_ppv_template_trial.sh`
- Group AH `GROUP_AH_JMPTBL_LOCAVAIL_SaveAvailabilityDataFile` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ah_jmptbl_locavail_save_availability_data_file_trial.sh`
- Group AH `GROUP_AH_JMPTBL_GCOMMAND_LoadCommandFile` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ah_jmptbl_gcommand_load_command_file_trial.sh`
- Group AH `GROUP_AH_JMPTBL_ESQ_WildcardMatch` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ah_jmptbl_esq_wildcard_match_trial.sh`
- Group AH `GROUP_AH_JMPTBL_P_TYPE_WritePromoIdDataFile` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ah_jmptbl_p_type_write_promo_id_data_file_trial.sh`
- Group AH `GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ah_jmptbl_esqfunc_wait_for_clock_change_and_service_ui_trial.sh`
- Group AH `GROUP_AH_JMPTBL_ESQ_TestBit1Based` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ah_jmptbl_esq_test_bit1_based_trial.sh`
- Group AH `GROUP_AH_JMPTBL_ESQIFF2_ShowAttentionOverlay` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ah_jmptbl_esqiff2_show_attention_overlay_trial.sh`
- Group AH `GROUP_AH_JMPTBL_STR_FindAnyCharPtr` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ah_jmptbl_str_find_any_char_ptr_trial.sh`
- Group AH `GROUP_AH_JMPTBL_GCOMMAND_LoadMplexFile` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ah_jmptbl_gcommand_load_mplex_file_trial.sh`
- Group AH `GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ah_jmptbl_script_read_serial_rbf_byte_trial.sh`
- Group AH `GROUP_AH_JMPTBL_ESQPARS_ClearAliasStringPointers` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ah_jmptbl_esqpars_clear_alias_string_pointers_trial.sh`
- Group AH `GROUP_AH_JMPTBL_PARSE_ReadSignedLongSkipClass3` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_ah_jmptbl_parse_read_signed_long_skip_class3_trial.sh`
- Group AM `GROUP_AM_JMPTBL_SIGNAL_CreateMsgPortWithSignal` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_am_jmptbl_signal_createmsgportwithsignal_trial.sh`
- Group AM `GROUP_AM_JMPTBL_LADFUNC_ClearBannerRectEntries` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_am_jmptbl_ladfunc_clearbannerrectentries_trial.sh`
- Group AM `GROUP_AM_JMPTBL_PARSEINI_UpdateClockFromRtc` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_am_jmptbl_parseini_updateclockfromrtc_trial.sh`
- Group AM `GROUP_AM_JMPTBL_SCRIPT_InitCtrlContext` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_am_jmptbl_script_initctrlcontext_trial.sh`
- Group AM `GROUP_AM_JMPTBL_DISKIO2_ParseIniFileFromDisk` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_am_jmptbl_diskio2_parseinifilefromdisk_trial.sh`
- Group AM `GROUP_AM_JMPTBL_ESQ_CheckTopazFontGuard` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_am_jmptbl_esq_checktopazfontguard_trial.sh`
- Group AM `GROUP_AM_JMPTBL_P_TYPE_ResetListsAndLoadPromoIds` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_am_jmptbl_p_type_resetlistsandloadpromoids_trial.sh`
- Group AM `GROUP_AM_JMPTBL_LADFUNC_LoadTextAdsFromFile` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_am_jmptbl_ladfunc_loadtextadsfromfile_trial.sh`
- Group AM `GROUP_AM_JMPTBL_DISKIO_LoadConfigFromDisk` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_am_jmptbl_diskio_loadconfigfromdisk_trial.sh`
- Group AM `GROUP_AM_JMPTBL_TEXTDISP_LoadSourceConfig` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_am_jmptbl_textdisp_loadsourceconfig_trial.sh`
- Group AM `GROUP_AM_JMPTBL_KYBD_InitializeInputDevices` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_am_jmptbl_kybd_initializeinputdevices_trial.sh`
- Group AM `GROUP_AM_JMPTBL_ESQ_CheckCompatibleVideoChip` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_am_jmptbl_esq_checkcompatiblevideochip_trial.sh`
- Group AM `GROUP_AM_JMPTBL_ESQ_CheckAvailableFastMemory` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_am_jmptbl_esq_checkavailablefastmemory_trial.sh`
- Group AM `GROUP_AM_JMPTBL_STRUCT_AllocWithOwner` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_am_jmptbl_struct_allocwithowner_trial.sh`
- Group AM `GROUP_AM_JMPTBL_GCOMMAND_ResetBannerFadeState` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_am_jmptbl_gcommand_resetbannerfadestate_trial.sh`
- Group AM `GROUP_AM_JMPTBL_TLIBA3_InitPatternTable` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_am_jmptbl_tliba3_initpatterntable_trial.sh`
- Group AM `GROUP_AM_JMPTBL_ESQ_FormatDiskErrorMessage` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_am_jmptbl_esq_formatdiskerrormessage_trial.sh`
- Group AM `GROUP_AM_JMPTBL_SCRIPT_PrimeBannerTransitionFromHexCode` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_am_jmptbl_script_primebannertransitionfromhexcode_trial.sh`
- Group AM `GROUP_AM_JMPTBL_LOCAVAIL_ResetFilterStateStruct` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_am_jmptbl_locavail_resetfilterstatestruct_trial.sh`
- Group AM `GROUP_AM_JMPTBL_ESQ_InitAudio1Dma` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_am_jmptbl_esq_initaudio1dma_trial.sh`
- Group AM `GROUP_AM_JMPTBL_LIST_InitHeader` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_am_jmptbl_list_initheader_trial.sh`
- Group AM `GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_am_jmptbl_esq_setcoppereffect_onenablehighlight_trial.sh`
- Group AM `GROUP_AM_JMPTBL_LOCAVAIL_LoadAvailabilityDataFile` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_am_jmptbl_locavail_loadavailabilitydatafile_trial.sh`
- Group AM `GROUP_AM_JMPTBL_GCOMMAND_InitPresetDefaults` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_am_jmptbl_gcommand_initpresetdefaults_trial.sh`
- Group AM `GROUP_AM_JMPTBL_OVERRIDE_INTUITION_FUNCS` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_am_jmptbl_override_intuition_funcs_trial.sh`
- Group AM `GROUP_AM_JMPTBL_BUFFER_FlushAllAndCloseWithCode` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_am_jmptbl_buffer_flushallandclosewithcode_trial.sh`
- Group AM `GROUP_AM_JMPTBL_FLIB2_ResetAndLoadListingTemplates` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_am_jmptbl_flib2_resetandloadlistingtemplates_trial.sh`
- Group AM `GROUP_AM_JMPTBL_WDISP_SPrintf` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_am_jmptbl_wdisp_sprintf_trial.sh`
- Group AM `GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_am_jmptbl_esq_setcoppereffect_offdisablehighlight_trial.sh`
- Group AM `GROUP_AM_JMPTBL_CLEANUP_ShutdownSystem` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_am_jmptbl_cleanup_shutdownsystem_trial.sh`
- Group AM `GROUP_AM_JMPTBL_LADFUNC_AllocBannerRectEntries` SAS/C compare script: `src/decomp/scripts/compare_sasc_group_am_jmptbl_ladfunc_allocbannerrectentries_trial.sh`
- ED1 `ED1_JMPTBL_NEWGRID_DrawTopBorderLine` SAS/C compare script: `src/decomp/scripts/compare_sasc_ed1_jmptbl_newgrid_drawtopborderline_trial.sh`
- ED1 `ED1_JMPTBL_LOCAVAIL_ResetFilterCursorState` SAS/C compare script: `src/decomp/scripts/compare_sasc_ed1_jmptbl_locavail_resetfiltercursorstate_trial.sh`
- ED1 `ED1_JMPTBL_GCOMMAND_ResetHighlightMessages` SAS/C compare script: `src/decomp/scripts/compare_sasc_ed1_jmptbl_gcommand_resethighlightmessages_trial.sh`
- ED1 `ED1_JMPTBL_LADFUNC_MergeHighLowNibbles` SAS/C compare script: `src/decomp/scripts/compare_sasc_ed1_jmptbl_ladfunc_mergehighlownibbles_trial.sh`
- ED1 `ED1_JMPTBL_LADFUNC_SaveTextAdsToFile` SAS/C compare script: `src/decomp/scripts/compare_sasc_ed1_jmptbl_ladfunc_savetextadstofile_trial.sh`
- ED1 `ED1_JMPTBL_ESQ_ColdReboot` SAS/C compare script: `src/decomp/scripts/compare_sasc_ed1_jmptbl_esq_coldreboot_trial.sh`
- ED1 `ED1_JMPTBL_ESQSHARED4_LoadDefaultPaletteToCopper_NoOp` SAS/C compare script: `src/decomp/scripts/compare_sasc_ed1_jmptbl_esqshared4_loaddefaultpalettetocopper_noop_trial.sh`
- ED1 `ED1_JMPTBL_GCOMMAND_SeedBannerDefaults` SAS/C compare script: `src/decomp/scripts/compare_sasc_ed1_jmptbl_gcommand_seedbannerdefaults_trial.sh`
- ED1 `ED1_JMPTBL_MEM_Move` SAS/C compare script: `src/decomp/scripts/compare_sasc_ed1_jmptbl_mem_move_trial.sh`
- ED1 `ED1_JMPTBL_GCOMMAND_SeedBannerFromPrefs` SAS/C compare script: `src/decomp/scripts/compare_sasc_ed1_jmptbl_gcommand_seedbannerfromprefs_trial.sh`
- ED1 `ED1_JMPTBL_CLEANUP_DrawDateTimeBannerRow` SAS/C compare script: `src/decomp/scripts/compare_sasc_ed1_jmptbl_cleanup_drawdatetimebannerrow_trial.sh`
- ED1 `ED1_JMPTBL_LADFUNC_PackNibblesToByte` SAS/C compare script: `src/decomp/scripts/compare_sasc_ed1_jmptbl_ladfunc_packnibblestobyte_trial.sh`
- ESQFUNC `ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqfunc_jmptbl_textdisp_setrastformode_trial.sh`
- ESQFUNC `ESQFUNC_JMPTBL_P_TYPE_PromoteSecondaryList` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqfunc_jmptbl_p_type_promotesecondarylist_trial.sh`
- ESQFUNC `ESQFUNC_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqfunc_jmptbl_diskio_probedrivesandassignpaths_trial.sh`
- ESQFUNC `ESQFUNC_JMPTBL_PARSEINI_UpdateCtrlHDeltaMax` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqfunc_jmptbl_parseini_updatectrlhdeltamax_trial.sh`
- ESQFUNC `ESQFUNC_JMPTBL_ESQ_ClampBannerCharRange` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqfunc_jmptbl_esq_clampbannercharrange_trial.sh`
- ESQFUNC `ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit3Flag` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqfunc_jmptbl_script_readciabbit3flag_trial.sh`
- ESQFUNC `ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqfunc_jmptbl_tliba3_drawcenteredwrappedtextlines_trial.sh`
- ESQFUNC `ESQFUNC_JMPTBL_SCRIPT_GetCtrlLineFlag` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqfunc_jmptbl_script_getctrllineflag_trial.sh`
- ESQFUNC `ESQFUNC_JMPTBL_LOCAVAIL_SyncSecondaryFilterForCurrentGroup` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqfunc_jmptbl_locavail_syncsecondaryfilterforcurrentgroup_trial.sh`
- ESQFUNC `ESQFUNC_JMPTBL_TEXTDISP_ResetSelectionAndRefresh` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqfunc_jmptbl_textdisp_resetselectionandrefresh_trial.sh`
- ESQFUNC `ESQFUNC_JMPTBL_PARSEINI_MonitorClockChange` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqfunc_jmptbl_parseini_monitorclockchange_trial.sh`
- ESQFUNC `ESQFUNC_JMPTBL_LADFUNC_ParseHexDigit` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqfunc_jmptbl_ladfunc_parsehexdigit_trial.sh`
- ESQFUNC `ESQFUNC_JMPTBL_CLEANUP_ProcessAlerts` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqfunc_jmptbl_cleanup_processalerts_trial.sh`
- ESQFUNC `ESQFUNC_JMPTBL_ESQ_GetHalfHourSlotIndex` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqfunc_jmptbl_esq_gethalfhourslotindex_trial.sh`
- ESQFUNC `ESQFUNC_JMPTBL_CLEANUP_DrawClockBanner` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqfunc_jmptbl_cleanup_drawclockbanner_trial.sh`
- ESQFUNC `ESQFUNC_JMPTBL_PARSEINI_ComputeHTCMaxValues` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqfunc_jmptbl_parseini_computehtcmaxvalues_trial.sh`
- ESQFUNC `ESQFUNC_JMPTBL_LADFUNC_UpdateHighlightState` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqfunc_jmptbl_ladfunc_updatehighlightstate_trial.sh`
- ESQFUNC `ESQFUNC_JMPTBL_P_TYPE_EnsureSecondaryList` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqfunc_jmptbl_p_type_ensuresecondarylist_trial.sh`
- ESQFUNC `ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit5Mask` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqfunc_jmptbl_script_readciabbit5mask_trial.sh`
- ESQFUNC `ESQFUNC_JMPTBL_PARSEINI_NormalizeClockData` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqfunc_jmptbl_parseini_normalizeclockdata_trial.sh`
- ESQFUNC `ESQFUNC_JMPTBL_ESQ_TickGlobalCounters` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqfunc_jmptbl_esq_tickglobalcounters_trial.sh`
- ESQFUNC `ESQFUNC_JMPTBL_SCRIPT_HandleSerialCtrlCmd` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqfunc_jmptbl_script_handleserialctrlcmd_trial.sh`
- ESQFUNC `ESQFUNC_JMPTBL_ESQ_HandleSerialRbfInterrupt` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqfunc_jmptbl_esq_handleserialrbfinterrupt_trial.sh`
- ESQFUNC `ESQFUNC_JMPTBL_TEXTDISP_TickDisplayState` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqfunc_jmptbl_textdisp_tickdisplaystate_trial.sh`
- ESQFUNC `ESQFUNC_JMPTBL_ESQ_PollCtrlInput` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqfunc_jmptbl_esq_pollctrlinput_trial.sh`
- ESQFUNC `ESQFUNC_JMPTBL_LOCAVAIL_RebuildFilterStateFromCurrentGroup` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqfunc_jmptbl_locavail_rebuildfilterstatefromcurrentgroup_trial.sh`
- ESQFUNC `ESQFUNC_JMPTBL_STRING_CopyPadNul` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqfunc_jmptbl_string_copypadnul_trial.sh`
- ESQDISP `ESQDISP_JMPTBL_NEWGRID_ProcessGridMessages` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqdisp_jmptbl_newgrid_processgridmessages_trial.sh`
- ESQDISP `ESQDISP_JMPTBL_GRAPHICS_AllocRaster` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqdisp_jmptbl_graphics_allocraster_trial.sh`
- ESQSHARED `ESQSHARED_JMPTBL_DST_BuildBannerTimeWord` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqshared_jmptbl_dst_buildbannertimeword_trial.sh`
- ESQSHARED `ESQSHARED_JMPTBL_ESQ_ReverseBitsIn6Bytes` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqshared_jmptbl_esq_reversebitsin6bytes_trial.sh`
- ESQSHARED `ESQSHARED_JMPTBL_ESQ_SetBit1Based` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqshared_jmptbl_esq_setbit1based_trial.sh`
- ESQSHARED `ESQSHARED_JMPTBL_ESQ_AdjustBracketedHourInString` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqshared_jmptbl_esq_adjustbracketedhourinstring_trial.sh`
- ESQSHARED `ESQSHARED_JMPTBL_COI_EnsureAnimObjectAllocated` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqshared_jmptbl_coi_ensureanimobjectallocated_trial.sh`
- ESQSHARED `ESQSHARED_JMPTBL_ESQ_WildcardMatch` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqshared_jmptbl_esq_wildcardmatch_trial.sh`
- ESQSHARED `ESQSHARED_JMPTBL_STR_SkipClass3Chars` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqshared_jmptbl_str_skipclass3chars_trial.sh`
- ESQSHARED `ESQSHARED_JMPTBL_ESQ_TestBit1Based` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqshared_jmptbl_esq_testbit1based_trial.sh`
- ESQPARS `ESQPARS_JMPTBL_DISKIO2_FlushDataFilesIfNeeded` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqpars_jmptbl_diskio2_flushdatafilesifneeded_trial.sh`
- ESQPARS `ESQPARS_JMPTBL_NEWGRID_RebuildIndexCache` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqpars_jmptbl_newgrid_rebuildindexcache_trial.sh`
- ESQPARS `ESQPARS_JMPTBL_DATETIME_SavePairToFile` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqpars_jmptbl_datetime_savepairtofile_trial.sh`
- ESQPARS `ESQPARS_JMPTBL_ESQPROTO_VerifyChecksumAndParseList` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqpars_jmptbl_esqproto_verifychecksumandparselist_trial.sh`
- ESQPARS `ESQPARS_JMPTBL_P_TYPE_ParseAndStoreTypeRecord` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqpars_jmptbl_p_type_parseandstoretyperecord_trial.sh`
- ESQPARS `ESQPARS_JMPTBL_ESQPROTO_CopyLabelToGlobal` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqpars_jmptbl_esqproto_copylabeltoglobal_trial.sh`
- ESQPARS `ESQPARS_JMPTBL_DST_HandleBannerCommand32_33` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqpars_jmptbl_dst_handlebannercommand32_33_trial.sh`
- ESQPARS `ESQPARS_JMPTBL_ESQ_SeedMinuteEventThresholds` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqpars_jmptbl_esq_seedminuteeventthresholds_trial.sh`
- ESQPARS `ESQPARS_JMPTBL_PARSEINI_HandleFontCommand` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqpars_jmptbl_parseini_handlefontcommand_trial.sh`
- ESQPARS `ESQPARS_JMPTBL_TEXTDISP_ApplySourceConfigAllEntries` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqpars_jmptbl_textdisp_applysourceconfigallentries_trial.sh`
- ESQPARS `ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqpars_jmptbl_brush_planemaskforindex_trial.sh`
- ESQPARS `ESQPARS_JMPTBL_SCRIPT_ResetCtrlContextAndClearStatusLine` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqpars_jmptbl_script_resetctrlcontextandclearstatusline_trial.sh`
- ESQPARS `ESQPARS_JMPTBL_PARSEINI_WriteRtcFromGlobals` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqpars_jmptbl_parseini_writertcfromglobals_trial.sh`
- ESQPARS `ESQPARS_JMPTBL_LOCAVAIL_SaveAvailabilityDataFile` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqpars_jmptbl_locavail_saveavailabilitydatafile_trial.sh`
- ESQPARS `ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqpars_jmptbl_displib_displaytextatposition_trial.sh`
- ESQPARS `ESQPARS_JMPTBL_LADFUNC_SaveTextAdsToFile` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqpars_jmptbl_ladfunc_savetextadstofile_trial.sh`
- ESQPARS `ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqpars_jmptbl_parse_readsignedlongskipclass3_alt_trial.sh`
- ESQPARS `ESQPARS_JMPTBL_DISKIO2_HandleInteractiveFileTransfer` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqpars_jmptbl_diskio2_handleinteractivefiletransfer_trial.sh`
- ESQPARS `ESQPARS_JMPTBL_P_TYPE_WritePromoIdDataFile` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqpars_jmptbl_p_type_writepromoiddatafile_trial.sh`
- ESQPARS `ESQPARS_JMPTBL_COI_FreeEntryResources` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqpars_jmptbl_coi_freeentryresources_trial.sh`
- ESQPARS `ESQPARS_JMPTBL_DST_UpdateBannerQueue` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqpars_jmptbl_dst_updatebannerqueue_trial.sh`
- ESQPARS `ESQPARS_JMPTBL_ESQPROTO_VerifyChecksumAndParseRecord` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqpars_jmptbl_esqproto_verifychecksumandparserecord_trial.sh`
- ESQPARS `ESQPARS_JMPTBL_ESQPROTO_ParseDigitLabelAndDisplay` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqpars_jmptbl_esqproto_parsedigitlabelanddisplay_trial.sh`
- ESQPARS `ESQPARS_JMPTBL_DISKIO_ParseConfigBuffer` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqpars_jmptbl_diskio_parseconfigbuffer_trial.sh`
- ESQPARS `ESQPARS_JMPTBL_CLEANUP_ParseAlignedListingBlock` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqpars_jmptbl_cleanup_parsealignedlistingblock_trial.sh`
- ESQPARS `ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqpars_jmptbl_script_readserialrbfbyte_trial.sh`
- ESQPARS `ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqpars_jmptbl_esq_generatexorchecksumbyte_trial.sh`
- ESQPARS `ESQPARS_JMPTBL_DST_RefreshBannerBuffer` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqpars_jmptbl_dst_refreshbannerbuffer_trial.sh`
- ESQPARS `ESQPARS_JMPTBL_DISKIO_SaveConfigToFileHandle` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqpars_jmptbl_diskio_saveconfigtofilehandle_trial.sh`
- TLIBA1 `TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode` SAS/C compare script: `src/decomp/scripts/compare_sasc_tliba1_jmptbl_coi_getanimfieldpointerbymode_trial.sh`
- TLIBA1 `TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode` SAS/C compare script: `src/decomp/scripts/compare_sasc_tliba1_jmptbl_esqdisp_getentryauxpointerbymode_trial.sh`
- TLIBA1 `TLIBA1_JMPTBL_LADFUNC_ExtractLowNibble` SAS/C compare script: `src/decomp/scripts/compare_sasc_tliba1_jmptbl_ladfunc_extractlownibble_trial.sh`
- TLIBA1 `TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode` SAS/C compare script: `src/decomp/scripts/compare_sasc_tliba1_jmptbl_esqdisp_getentrypointerbymode_trial.sh`
- TLIBA1 `TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow` SAS/C compare script: `src/decomp/scripts/compare_sasc_tliba1_jmptbl_coi_testentrywithintimewindow_trial.sh`
- TLIBA1 `TLIBA1_JMPTBL_CLEANUP_FormatClockFormatEntry` SAS/C compare script: `src/decomp/scripts/compare_sasc_tliba1_jmptbl_cleanup_formatclockformatentry_trial.sh`
- TLIBA1 `TLIBA1_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow` SAS/C compare script: `src/decomp/scripts/compare_sasc_tliba1_jmptbl_esqdisp_computescheduleoffsetforrow_trial.sh`
- TLIBA1 `TLIBA1_JMPTBL_ESQ_FindSubstringCaseFold` SAS/C compare script: `src/decomp/scripts/compare_sasc_tliba1_jmptbl_esq_findsubstringcasefold_trial.sh`
- TLIBA1 `TLIBA1_JMPTBL_DISPLIB_FindPreviousValidEntryIndex` SAS/C compare script: `src/decomp/scripts/compare_sasc_tliba1_jmptbl_displib_findpreviousvalidentryindex_trial.sh`
- TLIBA1 `TLIBA1_JMPTBL_LADFUNC_ExtractHighNibble` SAS/C compare script: `src/decomp/scripts/compare_sasc_tliba1_jmptbl_ladfunc_extracthighnibble_trial.sh`
- TLIBA2 `TLIBA2_JMPTBL_DST_AddTimeOffset` SAS/C compare script: `src/decomp/scripts/compare_sasc_tliba2_jmptbl_dst_addtimeoffset_trial.sh`
- TLIBA2 `TLIBA2_JMPTBL_ESQ_TestBit1Based` SAS/C compare script: `src/decomp/scripts/compare_sasc_tliba2_jmptbl_esq_testbit1based_trial.sh`
- TLIBA3 `TLIBA3_JMPTBL_GCOMMAND_ApplyHighlightFlag` SAS/C compare script: `src/decomp/scripts/compare_sasc_tliba3_jmptbl_gcommand_applyhighlightflag_trial.sh`
- TEXTDISP2 `TEXTDISP2_JMPTBL_LOCAVAIL_GetFilterWindowHalfSpan` SAS/C compare script: `src/decomp/scripts/compare_sasc_textdisp2_jmptbl_locavail_getfilterwindowhalfspan_trial.sh`
- TEXTDISP2 `TEXTDISP2_JMPTBL_LADFUNC_DrawEntryPreview` SAS/C compare script: `src/decomp/scripts/compare_sasc_textdisp2_jmptbl_ladfunc_drawentrypreview_trial.sh`
- TEXTDISP2 `TEXTDISP2_JMPTBL_ESQIFF_RunPendingCopperAnimations` SAS/C compare script: `src/decomp/scripts/compare_sasc_textdisp2_jmptbl_esqiff_runpendingcopperanimations_trial.sh`
- TEXTDISP2 `TEXTDISP2_JMPTBL_ESQIFF_PlayNextExternalAssetFrame` SAS/C compare script: `src/decomp/scripts/compare_sasc_textdisp2_jmptbl_esqiff_playnextexternalassetframe_trial.sh`
- SCRIPT2 `SCRIPT2_JMPTBL_ESQ_CaptureCtrlBit4StreamBufferByte` SAS/C compare script: `src/decomp/scripts/compare_sasc_script2_jmptbl_esq_capturectrlbit4streambufferbyte_trial.sh`
- SCRIPT2 `SCRIPT2_JMPTBL_ESQ_ReadSerialRbfByte` SAS/C compare script: `src/decomp/scripts/compare_sasc_script2_jmptbl_esq_readserialrbfbyte_trial.sh`
- SCRIPT `SCRIPT_JMPTBL_MEMORY_DeallocateMemory` SAS/C compare script: `src/decomp/scripts/compare_sasc_script_jmptbl_memory_deallocatememory_trial.sh`
- SCRIPT `SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes` SAS/C compare script: `src/decomp/scripts/compare_sasc_script_jmptbl_diskio_writebufferedbytes_trial.sh`
- SCRIPT `SCRIPT_JMPTBL_DISKIO_CloseBufferedFileAndFlush` SAS/C compare script: `src/decomp/scripts/compare_sasc_script_jmptbl_diskio_closebufferedfileandflush_trial.sh`
- SCRIPT `SCRIPT_JMPTBL_MEMORY_AllocateMemory` SAS/C compare script: `src/decomp/scripts/compare_sasc_script_jmptbl_memory_allocatememory_trial.sh`
- SCRIPT `SCRIPT_JMPTBL_DISKIO_OpenFileWithBuffer` SAS/C compare script: `src/decomp/scripts/compare_sasc_script_jmptbl_diskio_openfilewithbuffer_trial.sh`
- PARSEINI `PARSEINI_JMPTBL_STRING_CompareNoCase` SAS/C compare script: `src/decomp/scripts/compare_sasc_parseini_jmptbl_string_comparenocase_trial.sh`
- PARSEINI `PARSEINI_JMPTBL_ED1_WaitForFlagAndClearBit0` SAS/C compare script: `src/decomp/scripts/compare_sasc_parseini_jmptbl_ed1_waitforflagandclearbit0_trial.sh`
- PARSEINI `PARSEINI_JMPTBL_DISKIO2_ParseIniFileFromDisk` SAS/C compare script: `src/decomp/scripts/compare_sasc_parseini_jmptbl_diskio2_parseinifilefromdisk_trial.sh`
- PARSEINI `PARSEINI_JMPTBL_STR_FindCharPtr` SAS/C compare script: `src/decomp/scripts/compare_sasc_parseini_jmptbl_str_findcharptr_trial.sh`
- PARSEINI `PARSEINI_JMPTBL_HANDLE_OpenWithMode` SAS/C compare script: `src/decomp/scripts/compare_sasc_parseini_jmptbl_handle_openwithmode_trial.sh`
- PARSEINI `PARSEINI_JMPTBL_ESQIFF_QueueIffBrushLoad` SAS/C compare script: `src/decomp/scripts/compare_sasc_parseini_jmptbl_esqiff_queueiffbrushload_trial.sh`
- PARSEINI `PARSEINI_JMPTBL_ESQIFF_HandleBrushIniReloadHotkey` SAS/C compare script: `src/decomp/scripts/compare_sasc_parseini_jmptbl_esqiff_handlebrushinireloadhotkey_trial.sh`
- PARSEINI `PARSEINI_JMPTBL_BRUSH_FreeBrushResources` SAS/C compare script: `src/decomp/scripts/compare_sasc_parseini_jmptbl_brush_freebrushresources_trial.sh`
- PARSEINI `PARSEINI_JMPTBL_ESQFUNC_RebuildPwBrushListFromTagTableFromTagTable` SAS/C compare script: `src/decomp/scripts/compare_sasc_parseini_jmptbl_esqfunc_rebuildpwbrushlistfromtagtablefromtagtable_trial.sh`
- PARSEINI `PARSEINI_JMPTBL_GCOMMAND_FindPathSeparator` SAS/C compare script: `src/decomp/scripts/compare_sasc_parseini_jmptbl_gcommand_findpathseparator_trial.sh`
- PARSEINI `PARSEINI_JMPTBL_DISKIO_ConsumeLineFromWorkBuffer` SAS/C compare script: `src/decomp/scripts/compare_sasc_parseini_jmptbl_diskio_consumelinefromworkbuffer_trial.sh`
- PARSEINI `PARSEINI_JMPTBL_ED1_DrawDiagnosticsScreen` SAS/C compare script: `src/decomp/scripts/compare_sasc_parseini_jmptbl_ed1_drawdiagnosticsscreen_trial.sh`
- PARSEINI `PARSEINI_JMPTBL_BRUSH_FreeBrushList` SAS/C compare script: `src/decomp/scripts/compare_sasc_parseini_jmptbl_brush_freebrushlist_trial.sh`
- PARSEINI `PARSEINI_JMPTBL_GCOMMAND_ValidatePresetTable` SAS/C compare script: `src/decomp/scripts/compare_sasc_parseini_jmptbl_gcommand_validatepresettable_trial.sh`
- PARSEINI `PARSEINI_JMPTBL_BRUSH_AllocBrushNode` SAS/C compare script: `src/decomp/scripts/compare_sasc_parseini_jmptbl_brush_allocbrushnode_trial.sh`
- PARSEINI `PARSEINI_JMPTBL_UNKNOWN36_FinalizeRequest` SAS/C compare script: `src/decomp/scripts/compare_sasc_parseini_jmptbl_unknown36_finalizerequest_trial.sh`
- PARSEINI `PARSEINI_JMPTBL_GCOMMAND_InitPresetTableFromPalette` SAS/C compare script: `src/decomp/scripts/compare_sasc_parseini_jmptbl_gcommand_initpresettablefrompalette_trial.sh`
- PARSEINI `PARSEINI_JMPTBL_STRING_CompareNoCaseN` SAS/C compare script: `src/decomp/scripts/compare_sasc_parseini_jmptbl_string_comparenocasen_trial.sh`
- PARSEINI `PARSEINI_JMPTBL_STRING_AppendAtNull` SAS/C compare script: `src/decomp/scripts/compare_sasc_parseini_jmptbl_string_appendatnull_trial.sh`
- PARSEINI `PARSEINI_JMPTBL_DISKIO_LoadFileToWorkBuffer` SAS/C compare script: `src/decomp/scripts/compare_sasc_parseini_jmptbl_diskio_loadfiletoworkbuffer_trial.sh`
- PARSEINI `PARSEINI_JMPTBL_ED1_WaitForFlagAndClearBit1` SAS/C compare script: `src/decomp/scripts/compare_sasc_parseini_jmptbl_ed1_waitforflagandclearbit1_trial.sh`
- PARSEINI `PARSEINI_JMPTBL_WDISP_SPrintf` SAS/C compare script: `src/decomp/scripts/compare_sasc_parseini_jmptbl_wdisp_sprintf_trial.sh`
- PARSEINI `PARSEINI_JMPTBL_STREAM_ReadLineWithLimit` SAS/C compare script: `src/decomp/scripts/compare_sasc_parseini_jmptbl_stream_readlinewithlimit_trial.sh`
- PARSEINI `PARSEINI_JMPTBL_STR_FindAnyCharPtr` SAS/C compare script: `src/decomp/scripts/compare_sasc_parseini_jmptbl_str_findanycharptr_trial.sh`
- PARSEINI `PARSEINI_JMPTBL_ED1_ExitEscMenu` SAS/C compare script: `src/decomp/scripts/compare_sasc_parseini_jmptbl_ed1_exitescmenu_trial.sh`
- PARSEINI `PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString` SAS/C compare script: `src/decomp/scripts/compare_sasc_parseini_jmptbl_esqpars_replaceownedstring_trial.sh`
- PARSEINI `PARSEINI_JMPTBL_ED1_EnterEscMenu` SAS/C compare script: `src/decomp/scripts/compare_sasc_parseini_jmptbl_ed1_enterescmenu_trial.sh`
- PARSEINI `PARSEINI_JMPTBL_ESQFUNC_DrawEscMenuVersion` SAS/C compare script: `src/decomp/scripts/compare_sasc_parseini_jmptbl_esqfunc_drawescmenuversion_trial.sh`
- NEWGRID2 `NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid2_jmptbl_coi_selectanimfieldpointer_trial.sh`
- NEWGRID2 `NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid2_jmptbl_disptext_setcurrentlineindex_trial.sh`
- NEWGRID2 `NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid2_jmptbl_disptext_layoutandappendtobuffer_trial.sh`
- NEWGRID2 `NEWGRID2_JMPTBL_DISPTEXT_GetTotalLineCount` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid2_jmptbl_disptext_gettotallinecount_trial.sh`
- NEWGRID2 `NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid2_jmptbl_tliba_findfirstwildcardmatchindex_trial.sh`
- NEWGRID2 `NEWGRID2_JMPTBL_DISPTEXT_BuildLayoutForSource` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid2_jmptbl_disptext_buildlayoutforsource_trial.sh`
- NEWGRID2 `NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid2_jmptbl_bevel_drawbevelframewithtopright_trial.sh`
- NEWGRID2 `NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid2_jmptbl_esqdisp_getentryauxpointerbymode_trial.sh`
- NEWGRID2 `NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevel` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid2_jmptbl_bevel_drawverticalbevel_trial.sh`
- NEWGRID2 `NEWGRID2_JMPTBL_DISPTEXT_LayoutSourceToLines` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid2_jmptbl_disptext_layoutsourcetolines_trial.sh`
- NEWGRID2 `NEWGRID2_JMPTBL_CLEANUP_UpdateEntryFlagBytes` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid2_jmptbl_cleanup_updateentryflagbytes_trial.sh`
- NEWGRID2 `NEWGRID2_JMPTBL_COI_RenderClockFormatEntryVariant` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid2_jmptbl_coi_renderclockformatentryvariant_trial.sh`
- NEWGRID2 `NEWGRID2_JMPTBL_ESQDISP_TestEntryBits0And2` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid2_jmptbl_esqdisp_testentrybits0and2_trial.sh`
- NEWGRID2 `NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid2_jmptbl_disptext_computevisiblelinecount_trial.sh`
- NEWGRID2 `NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid2_jmptbl_esqdisp_getentrypointerbymode_trial.sh`
- NEWGRID2 `NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid2_jmptbl_disptext_rendercurrentline_trial.sh`
- NEWGRID2 `NEWGRID2_JMPTBL_COI_ProcessEntrySelectionState` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid2_jmptbl_coi_processentryselectionstate_trial.sh`
- NEWGRID2 `NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid2_jmptbl_cleanup_formatclockformatentry_trial.sh`
- NEWGRID2 `NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTop` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid2_jmptbl_bevel_drawbevelframewithtop_trial.sh`
- NEWGRID2 `NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid2_jmptbl_esq_gethalfhourslotindex_trial.sh`
- NEWGRID2 `NEWGRID2_JMPTBL_STR_SkipClass3Chars` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid2_jmptbl_str_skipclass3chars_trial.sh`
- NEWGRID2 `NEWGRID2_JMPTBL_STRING_AppendN` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid2_jmptbl_string_appendn_trial.sh`
- NEWGRID2 `NEWGRID2_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid2_jmptbl_esqdisp_computescheduleoffsetforrow_trial.sh`
- NEWGRID2 `NEWGRID2_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid2_jmptbl_parse_readsignedlongskipclass3_alt_trial.sh`
- NEWGRID2 `NEWGRID2_JMPTBL_CLEANUP_TestEntryFlagYAndBit1` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid2_jmptbl_cleanup_testentryflagyandbit1_trial.sh`
- NEWGRID2 `NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid2_jmptbl_disptext_iscurrentlinelast_trial.sh`
- NEWGRID2 `NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid2_jmptbl_disptext_islastlineselected_trial.sh`
- NEWGRID2 `NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid2_jmptbl_bevel_drawbeveledframe_trial.sh`
- NEWGRID2 `NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid2_jmptbl_displib_findpreviousvalidentryindex_trial.sh`
- NEWGRID2 `NEWGRID2_JMPTBL_DISPTEXT_ComputeMarkerWidths` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid2_jmptbl_disptext_computemarkerwidths_trial.sh`
- NEWGRID2 `NEWGRID2_JMPTBL_ESQ_TestBit1Based` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid2_jmptbl_esq_testbit1based_trial.sh`
- NEWGRID2 `NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevelPair` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid2_jmptbl_bevel_drawverticalbevelpair_trial.sh`
- NEWGRID2 `NEWGRID2_JMPTBL_DISPTEXT_MeasureCurrentLineLength` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid2_jmptbl_disptext_measurecurrentlinelength_trial.sh`
- NEWGRID2 `NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid2_jmptbl_disptext_setlayoutparams_trial.sh`
- NEWGRID2 `NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid2_jmptbl_disptext_hasmultiplelines_trial.sh`
- NEWGRID2 `NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid2_jmptbl_bevel_drawhorizontalbevel_trial.sh`
- WDISP `WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples` SAS/C compare script: `src/decomp/scripts/compare_sasc_wdisp_jmptbl_esqiff_restorebasepalettetriples_trial.sh`
- WDISP `WDISP_JMPTBL_ESQFUNC_TrimTextToPixelWidthWordBoundary` SAS/C compare script: `src/decomp/scripts/compare_sasc_wdisp_jmptbl_esqfunc_trimtexttopixelwidthwordboundary_trial.sh`
- WDISP `WDISP_JMPTBL_GCOMMAND_ExpandPresetBlock` SAS/C compare script: `src/decomp/scripts/compare_sasc_wdisp_jmptbl_gcommand_expandpresetblock_trial.sh`
- WDISP `WDISP_JMPTBL_ESQIFF_QueueIffBrushLoad` SAS/C compare script: `src/decomp/scripts/compare_sasc_wdisp_jmptbl_esqiff_queueiffbrushload_trial.sh`
- WDISP `WDISP_JMPTBL_ESQIFF_RunCopperDropTransition` SAS/C compare script: `src/decomp/scripts/compare_sasc_wdisp_jmptbl_esqiff_runcopperdroptransition_trial.sh`
- WDISP `WDISP_JMPTBL_BRUSH_FindBrushByPredicate` SAS/C compare script: `src/decomp/scripts/compare_sasc_wdisp_jmptbl_brush_findbrushbypredicate_trial.sh`
- WDISP `WDISP_JMPTBL_BRUSH_FreeBrushList` SAS/C compare script: `src/decomp/scripts/compare_sasc_wdisp_jmptbl_brush_freebrushlist_trial.sh`
- WDISP `WDISP_JMPTBL_BRUSH_PlaneMaskForIndex` SAS/C compare script: `src/decomp/scripts/compare_sasc_wdisp_jmptbl_brush_planemaskforindex_trial.sh`
- WDISP `WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight` SAS/C compare script: `src/decomp/scripts/compare_sasc_wdisp_jmptbl_esq_setcoppereffect_onenablehighlight_trial.sh`
- WDISP `WDISP_JMPTBL_ESQIFF_RenderWeatherStatusBrushSlice` SAS/C compare script: `src/decomp/scripts/compare_sasc_wdisp_jmptbl_esqiff_renderweatherstatusbrushslice_trial.sh`
- WDISP `WDISP_JMPTBL_BRUSH_SelectBrushSlot` SAS/C compare script: `src/decomp/scripts/compare_sasc_wdisp_jmptbl_brush_selectbrushslot_trial.sh`
- WDISP `WDISP_JMPTBL_NEWGRID_DrawWrappedText` SAS/C compare script: `src/decomp/scripts/compare_sasc_wdisp_jmptbl_newgrid_drawwrappedtext_trial.sh`
- WDISP `WDISP_JMPTBL_NEWGRID_ResetRowTable` SAS/C compare script: `src/decomp/scripts/compare_sasc_wdisp_jmptbl_newgrid_resetrowtable_trial.sh`
- PARSEINI2 `PARSEINI2_JMPTBL_CLOCK_ConvertAmigaSecondsToClockData` SAS/C compare script: `src/decomp/scripts/compare_sasc_parseini2_jmptbl_clock_convertamigasecondstoclockdata_trial.sh`
- PARSEINI2 `PARSEINI2_JMPTBL_ESQ_CalcDayOfYearFromMonthDay` SAS/C compare script: `src/decomp/scripts/compare_sasc_parseini2_jmptbl_esq_calcdayofyearfrommonthday_trial.sh`
- PARSEINI2 `PARSEINI2_JMPTBL_CLOCK_CheckDateOrSecondsFromEpoch` SAS/C compare script: `src/decomp/scripts/compare_sasc_parseini2_jmptbl_clock_checkdateorsecondsfromepoch_trial.sh`
- PARSEINI2 `PARSEINI2_JMPTBL_BATTCLOCK_GetSecondsFromBatteryBackedClock` SAS/C compare script: `src/decomp/scripts/compare_sasc_parseini2_jmptbl_battclock_getsecondsfrombatterybackedclock_trial.sh`
- PARSEINI2 `PARSEINI2_JMPTBL_DATETIME_IsLeapYear` SAS/C compare script: `src/decomp/scripts/compare_sasc_parseini2_jmptbl_datetime_isleapyear_trial.sh`
- PARSEINI2 `PARSEINI2_JMPTBL_BATTCLOCK_WriteSecondsToBatteryBackedClock` SAS/C compare script: `src/decomp/scripts/compare_sasc_parseini2_jmptbl_battclock_writesecondstobatterybackedclock_trial.sh`
- PARSEINI2 `PARSEINI2_JMPTBL_CLOCK_SecondsFromEpoch` SAS/C compare script: `src/decomp/scripts/compare_sasc_parseini2_jmptbl_clock_secondsfromepoch_trial.sh`
- NEWGRID `NEWGRID_JMPTBL_MATH_DivS32` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid_jmptbl_math_divs32_trial.sh`
- NEWGRID `NEWGRID_JMPTBL_DATETIME_SecondsToStruct` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid_jmptbl_datetime_secondstostruct_trial.sh`
- NEWGRID `NEWGRID_JMPTBL_GENERATE_GRID_DATE_STRING` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid_jmptbl_generate_grid_date_string_trial.sh`
- NEWGRID `NEWGRID_JMPTBL_MEMORY_DeallocateMemory` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid_jmptbl_memory_deallocatememory_trial.sh`
- NEWGRID `NEWGRID_JMPTBL_CLEANUP_DrawClockFormatList` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid_jmptbl_cleanup_drawclockformatlist_trial.sh`
- NEWGRID `NEWGRID_JMPTBL_DISPTEXT_FreeBuffers` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid_jmptbl_disptext_freebuffers_trial.sh`
- NEWGRID `NEWGRID_JMPTBL_CLEANUP_DrawClockBanner` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid_jmptbl_cleanup_drawclockbanner_trial.sh`
- NEWGRID `NEWGRID_JMPTBL_MEMORY_AllocateMemory` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid_jmptbl_memory_allocatememory_trial.sh`
- NEWGRID `NEWGRID_JMPTBL_DISPTEXT_InitBuffers` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid_jmptbl_disptext_initbuffers_trial.sh`
- NEWGRID `NEWGRID_JMPTBL_CLEANUP_DrawClockFormatFrame` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid_jmptbl_cleanup_drawclockformatframe_trial.sh`
- NEWGRID `NEWGRID_JMPTBL_DATETIME_NormalizeStructToSeconds` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid_jmptbl_datetime_normalizestructtoseconds_trial.sh`
- NEWGRID `NEWGRID_JMPTBL_STR_CopyUntilAnyDelimN` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid_jmptbl_str_copyuntilanydelimn_trial.sh`
- NEWGRID `NEWGRID_JMPTBL_WDISP_UpdateSelectionPreviewPanel` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid_jmptbl_wdisp_updateselectionpreviewpanel_trial.sh`
- SCRIPT3 `SCRIPT3_JMPTBL_LOCAVAIL_UpdateFilterStateMachine` SAS/C compare script: `src/decomp/scripts/compare_sasc_script3_jmptbl_locavail_updatefilterstatemachine_trial.sh`
- SCRIPT3 `SCRIPT3_JMPTBL_MATH_DivS32` SAS/C compare script: `src/decomp/scripts/compare_sasc_script3_jmptbl_math_divs32_trial.sh`
- SCRIPT3 `SCRIPT3_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters` SAS/C compare script: `src/decomp/scripts/compare_sasc_script3_jmptbl_esqshared_applyprogramtitletextfilters_trial.sh`
- SCRIPT3 `SCRIPT3_JMPTBL_STRING_CompareN` SAS/C compare script: `src/decomp/scripts/compare_sasc_script3_jmptbl_string_comparen_trial.sh`
- SCRIPT3 `SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh` SAS/C compare script: `src/decomp/scripts/compare_sasc_script3_jmptbl_esqdisp_updatestatusmaskandrefresh_trial.sh`
- SCRIPT3 `SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar` SAS/C compare script: `src/decomp/scripts/compare_sasc_script3_jmptbl_gcommand_getbannerchar_trial.sh`
- SCRIPT3 `SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit` SAS/C compare script: `src/decomp/scripts/compare_sasc_script3_jmptbl_ladfunc_parsehexdigit_trial.sh`
- SCRIPT3 `SCRIPT3_JMPTBL_ESQPARS_ApplyRtcBytesAndPersist` SAS/C compare script: `src/decomp/scripts/compare_sasc_script3_jmptbl_esqpars_applyrtcbytesandpersist_trial.sh`
- SCRIPT3 `SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt` SAS/C compare script: `src/decomp/scripts/compare_sasc_script3_jmptbl_parse_readsignedlongskipclass3_alt_trial.sh`
- SCRIPT3 `SCRIPT3_JMPTBL_GCOMMAND_AdjustBannerCopperOffset` SAS/C compare script: `src/decomp/scripts/compare_sasc_script3_jmptbl_gcommand_adjustbannercopperoffset_trial.sh`
- SCRIPT3 `SCRIPT3_JMPTBL_ESQ_SetCopperEffect_Custom` SAS/C compare script: `src/decomp/scripts/compare_sasc_script3_jmptbl_esq_setcoppereffect_custom_trial.sh`
- SCRIPT3 `SCRIPT3_JMPTBL_CLEANUP_RenderAlignedStatusScreen` SAS/C compare script: `src/decomp/scripts/compare_sasc_script3_jmptbl_cleanup_renderalignedstatusscreen_trial.sh`
- SCRIPT3 `SCRIPT3_JMPTBL_LOCAVAIL_ComputeFilterOffsetForEntry` SAS/C compare script: `src/decomp/scripts/compare_sasc_script3_jmptbl_locavail_computefilteroffsetforentry_trial.sh`
- SCRIPT3 `SCRIPT3_JMPTBL_MATH_Mulu32` SAS/C compare script: `src/decomp/scripts/compare_sasc_script3_jmptbl_math_mulu32_trial.sh`
- SCRIPT3 `SCRIPT3_JMPTBL_LOCAVAIL_SetFilterModeAndResetState` SAS/C compare script: `src/decomp/scripts/compare_sasc_script3_jmptbl_locavail_setfiltermodeandresetstate_trial.sh`
- SCRIPT3 `SCRIPT3_JMPTBL_STRING_CopyPadNul` SAS/C compare script: `src/decomp/scripts/compare_sasc_script3_jmptbl_string_copypadnul_trial.sh`
- NEWGRID `NEWGRID_JMPTBL_MATH_Mulu32` SAS/C compare script: `src/decomp/scripts/compare_sasc_newgrid_jmptbl_math_mulu32_trial.sh`
- TEXTDISP `TEXTDISP_JMPTBL_NEWGRID_ShouldOpenEditor` SAS/C compare script: `src/decomp/scripts/compare_sasc_textdisp_jmptbl_newgrid_shouldopeneditor_trial.sh`
- TEXTDISP `TEXTDISP_JMPTBL_ESQDISP_TestEntryGridEligibility` SAS/C compare script: `src/decomp/scripts/compare_sasc_textdisp_jmptbl_esqdisp_testentrygrideligibility_trial.sh`
- TEXTDISP `TEXTDISP_JMPTBL_ESQIFF_RunCopperRiseTransition` SAS/C compare script: `src/decomp/scripts/compare_sasc_textdisp_jmptbl_esqiff_runcopperrisetransition_trial.sh`
- TEXTDISP `TEXTDISP_JMPTBL_CLEANUP_BuildAlignedStatusLine` SAS/C compare script: `src/decomp/scripts/compare_sasc_textdisp_jmptbl_cleanup_buildalignedstatusline_trial.sh`
- TEXTDISP `TEXTDISP_JMPTBL_CLEANUP_DrawInsetRectFrame` SAS/C compare script: `src/decomp/scripts/compare_sasc_textdisp_jmptbl_cleanup_drawinsetrectframe_trial.sh`
- P_TYPE `P_TYPE_JMPTBL_STRING_FindSubstring` SAS/C compare script: `src/decomp/scripts/compare_sasc_p_type_jmptbl_string_findsubstring_trial.sh`
- ESQIFF `ESQIFF_JMPTBL_STRING_CompareNoCase` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff_jmptbl_string_comparenocase_trial.sh`
- ESQIFF `ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff_jmptbl_tliba3_builddisplaycontextforviewmode_trial.sh`
- ESQIFF `ESQIFF_JMPTBL_DISKIO_GetFilesizeFromHandle` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff_jmptbl_diskio_getfilesizefromhandle_trial.sh`
- ESQIFF `ESQIFF_JMPTBL_MATH_DivS32` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff_jmptbl_math_divs32_trial.sh`
- ESQIFF `ESQIFF_JMPTBL_TEXTDISP_FindEntryIndexByWildcard` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff_jmptbl_textdisp_findentryindexbywildcard_trial.sh`
- ESQIFF `ESQIFF_JMPTBL_STRING_CompareN` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff_jmptbl_string_comparen_trial.sh`
- ESQIFF `ESQIFF_JMPTBL_ESQ_NoOp` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff_jmptbl_esq_noop_trial.sh`
- ESQIFF `ESQIFF_JMPTBL_TEXTDISP_DrawChannelBanner` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff_jmptbl_textdisp_drawchannelbanner_trial.sh`
- ESQIFF `ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff_jmptbl_esq_movecopperentrytowardstart_trial.sh`
- ESQIFF `ESQIFF_JMPTBL_MEMORY_DeallocateMemory` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff_jmptbl_memory_deallocatememory_trial.sh`
- ESQIFF `ESQIFF_JMPTBL_DISKIO_ForceUiRefreshIfIdle` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff_jmptbl_diskio_forceuirefreshifidle_trial.sh`
- ESQIFF `ESQIFF_JMPTBL_BRUSH_CloneBrushRecord` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff_jmptbl_brush_clonebrushrecord_trial.sh`
- ESQIFF `ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff_jmptbl_esq_movecopperentrytowardend_trial.sh`
- ESQIFF `ESQIFF_JMPTBL_BRUSH_FindBrushByPredicate` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff_jmptbl_brush_findbrushbypredicate_trial.sh`
- ESQIFF `ESQIFF_JMPTBL_BRUSH_FreeBrushList` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff_jmptbl_brush_freebrushlist_trial.sh`
- ESQIFF `ESQIFF_JMPTBL_BRUSH_FindType3Brush` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff_jmptbl_brush_findtype3brush_trial.sh`
- ESQIFF `ESQIFF_JMPTBL_BRUSH_PopBrushHead` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff_jmptbl_brush_popbrushhead_trial.sh`
- ESQIFF `ESQIFF_JMPTBL_BRUSH_AllocBrushNode` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff_jmptbl_brush_allocbrushnode_trial.sh`
- ESQIFF `ESQIFF_JMPTBL_ESQ_NoOp_006A` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff_jmptbl_esq_noop_006a_trial.sh`
- ESQIFF `ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff_jmptbl_newgrid_validateselectioncode_trial.sh`
- ESQIFF `ESQIFF_JMPTBL_BRUSH_PopulateBrushList` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff_jmptbl_brush_populatebrushlist_trial.sh`
- ESQIFF `ESQIFF_JMPTBL_ESQ_NoOp_0074` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff_jmptbl_esq_noop_0074_trial.sh`
- ESQIFF `ESQIFF_JMPTBL_STRING_CompareNoCaseN` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff_jmptbl_string_comparenocasen_trial.sh`
- ESQIFF `ESQIFF_JMPTBL_SCRIPT_AssertCtrlLineIfEnabled` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff_jmptbl_script_assertctrllineifenabled_trial.sh`
- ESQIFF `ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff_jmptbl_script_beginbannerchartransition_trial.sh`
- ESQIFF `ESQIFF_JMPTBL_MEMORY_AllocateMemory` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff_jmptbl_memory_allocatememory_trial.sh`
- ESQIFF `ESQIFF_JMPTBL_CTASKS_StartIffTaskProcess` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff_jmptbl_ctasks_startifftaskprocess_trial.sh`
- ESQIFF `ESQIFF_JMPTBL_DOS_OpenFileWithMode` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff_jmptbl_dos_openfilewithmode_trial.sh`
- ESQIFF `ESQIFF_JMPTBL_ESQ_IncCopperListsTowardsTargets` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff_jmptbl_esq_inccopperliststowardstargets_trial.sh`
- ESQIFF `ESQIFF_JMPTBL_ESQ_DecCopperListsPrimary` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff_jmptbl_esq_deccopperlistsprimary_trial.sh`
- ESQIFF `ESQIFF_JMPTBL_BRUSH_SelectBrushSlot` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff_jmptbl_brush_selectbrushslot_trial.sh`
- ESQIFF `ESQIFF_JMPTBL_BRUSH_SelectBrushByLabel` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff_jmptbl_brush_selectbrushbylabel_trial.sh`
- ESQIFF `ESQIFF_JMPTBL_MATH_Mulu32` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff_jmptbl_math_mulu32_trial.sh`
- ESQIFF `ESQIFF_JMPTBL_DISKIO_ResetCtrlInputStateIfIdle` SAS/C compare script: `src/decomp/scripts/compare_sasc_esqiff_jmptbl_diskio_resetctrlinputstateifidle_trial.sh`
- APP2 `ESQ_NoOp` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_noop_trial.sh`
- APP2 `ESQ_NoOp_006A` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_noop_006a_trial.sh`
- APP2 `ESQ_NoOp_0074` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_noop_0074_trial.sh`
- APP2 `ESQ_TestBit1Based` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_test_bit1_based_trial.sh` (legacy alias: `compare_sasc_esq_testbit1based_trial.sh`)
- APP2 `ESQ_SetBit1Based` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_set_bit1_based_trial.sh` (legacy alias: `compare_sasc_esq_setbit1based_trial.sh`)
- APP2 `ESQ_TerminateAfterSecondQuote` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_terminate_after_second_quote_trial.sh`
- APP2 `ESQ_WildcardMatch` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_wildcard_match_trial.sh`
- APP2 `ESQ_GenerateXorChecksumByte` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_generate_xor_checksum_byte_trial.sh`
- APP2 `ESQ_FindSubstringCaseFold` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_find_substring_case_fold_trial.sh`
- APP2 `ESQ_WriteDecFixedWidth` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_write_dec_fixed_width_trial.sh`
- APP2 `ESQ_PackBitsDecode` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_packbits_decode_trial.sh`
- APP2 `ESQ_GetHalfHourSlotIndex` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_get_half_hour_slot_index_trial.sh`
- APP2 `ESQ_ClampBannerCharRange` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_clamp_banner_char_range_trial.sh`
- APP2 `ESQ_ReverseBitsIn6Bytes` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_reverse_bits_in6_bytes_trial.sh`
- APP2 `ESQ_DecColorStep` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_dec_color_step_trial.sh`
- APP2 `ESQ_BumpColorTowardTargets` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_bump_color_toward_targets_trial.sh`
- APP2 `ESQ_CalcDayOfYearFromMonthDay` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_calc_day_of_year_from_month_day_trial.sh`
- APP2 `ESQ_UpdateMonthDayFromDayOfYear` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_update_month_day_from_day_of_year_trial.sh`
- APP2 `ESQ_FormatTimeStamp` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_format_time_stamp_trial.sh`
- APP2 `ESQ_StoreCtrlSampleEntry` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_store_ctrl_sample_entry_trial.sh`
- APP2 `ESQ_SetCopperEffectParams` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_set_copper_effect_params_trial.sh`
- APP2 `ESQ_SetCopperEffect_Default` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_set_copper_effect_default_trial.sh`
- APP2 `ESQ_SetCopperEffect_AllOn` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_set_copper_effect_all_on_trial.sh`
- APP2 `ESQ_SetCopperEffect_Custom` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_set_copper_effect_custom_trial.sh`
- APP2 `ESQ_SetCopperEffect_OffDisableHighlight` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_set_copper_effect_off_disable_highlight_trial.sh`
- APP2 `ESQ_SetCopperEffect_OnEnableHighlight` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_set_copper_effect_on_enable_highlight_trial.sh`
- APP2 `ESQ_UpdateCopperListsFromParams` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_update_copper_lists_from_params_trial.sh`
- APP2 `ESQ_MoveCopperEntryTowardStart` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_move_copper_entry_toward_start_trial.sh`
- APP2 `ESQ_MoveCopperEntryTowardEnd` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_move_copper_entry_toward_end_trial.sh`
- APP2 `ESQ_DecCopperListsPrimary` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_dec_copper_lists_primary_trial.sh`
- APP2 `ESQ_IncCopperListsTowardsTargets` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_inc_copper_lists_towards_targets_trial.sh`
- APP2 `ESQ_SeedMinuteEventThresholds` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_seed_minute_event_thresholds_trial.sh`
- APP2 `ESQ_TickGlobalCounters` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_tick_global_counters_trial.sh`
- APP2 `ESQ_AdjustBracketedHourInString` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_adjust_bracketed_hour_in_string_trial.sh`
- APP2 `ESQ_AdvanceBannerCharIndex_Return` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_advance_banner_char_index_return_trial.sh`
- APP2 `ESQ_TickClockAndFlagEvents` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_tick_clock_and_flag_events_trial.sh`
- APP2 `ESQ_ColdReboot` + `ESQ_ColdRebootViaSupervisor` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_cold_reboot_pair_trial.sh`
- APP2 `ESQ_ColdReboot` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_cold_reboot_trial.sh`
- APP2 `ESQ_ColdRebootViaSupervisor` SAS/C compare script: `src/decomp/scripts/compare_sasc_esq_cold_reboot_via_supervisor_trial.sh`
- Unknown22 `DOS_CloseWithSignalCheck` SAS/C compare script: `src/decomp/scripts/compare_sasc_dos_close_with_signal_check_trial.sh`
- Unknown22 `MATH_Mulu32` SAS/C compare script: `src/decomp/scripts/compare_sasc_math_mulu32_trial.sh`
- Unknown22 `MATH_DivS32` SAS/C compare script: `src/decomp/scripts/compare_sasc_math_divs32_trial.sh`
- Unknown22 `MATH_DivU32` SAS/C compare script: `src/decomp/scripts/compare_sasc_math_divu32_trial.sh`
- Unknown22 `SIGNAL_CreateMsgPortWithSignal` SAS/C compare script: `src/decomp/scripts/compare_sasc_signal_create_msgport_with_signal_trial.sh`
- Unknown22 `ALLOCATE_AllocAndInitializeIOStdReq` SAS/C compare script: `src/decomp/scripts/compare_sasc_allocate_alloc_and_initialize_iostdreq_trial.sh`
- Unknown40 `DOS_Delay` SAS/C compare script: `src/decomp/scripts/compare_sasc_dos_delay_trial.sh`
- Unknown40 `DOS_SystemTagList` SAS/C compare script: `src/decomp/scripts/compare_sasc_dos_system_tag_list_trial.sh`
- Unknown40 `DOS_SystemTagList` SAS/C compare alias script (`taglist` naming): `src/decomp/scripts/compare_sasc_dos_system_taglist_trial.sh`
- Unknown40 `BATTCLOCK_GetSecondsFromBatteryBackedClock` SAS/C compare script: `src/decomp/scripts/compare_sasc_battclock_get_seconds_trial.sh`
- Unknown40 `BATTCLOCK_WriteSecondsToBatteryBackedClock` SAS/C compare script: `src/decomp/scripts/compare_sasc_battclock_write_seconds_trial.sh`
- Unknown40 `EXEC_CallVector_48` SAS/C compare script: `src/decomp/scripts/compare_sasc_exec_call_vector_48_trial.sh`
- Unknown42 `CLOCK_CheckDateOrSecondsFromEpoch` SAS/C compare script: `src/decomp/scripts/compare_sasc_clock_check_date_or_seconds_from_epoch_trial.sh`
- Unknown42 `CLOCK_SecondsFromEpoch` SAS/C compare script: `src/decomp/scripts/compare_sasc_clock_seconds_from_epoch_trial.sh`
- Unknown42 `PARALLEL_CheckReadyStub` SAS/C compare script: `src/decomp/scripts/compare_sasc_parallel_check_ready_stub_trial.sh` (legacy alias: `compare_sasc_parallel_checkready_stub_trial.sh`)
- Unknown42 `PARALLEL_CheckReady` SAS/C compare script: `src/decomp/scripts/compare_sasc_parallel_check_ready_trial.sh` (legacy alias: `compare_sasc_parallel_checkready_trial.sh`)
- Unknown42 `PARALLEL_WaitReady` SAS/C compare script: `src/decomp/scripts/compare_sasc_parallel_wait_ready_trial.sh` (legacy alias: `compare_sasc_parallel_waitready_trial.sh`)
- Unknown42 `PARALLEL_WriteCharD0` SAS/C compare script: `src/decomp/scripts/compare_sasc_parallel_write_char_d0_trial.sh` (legacy alias: `compare_sasc_parallel_writechard0_trial.sh`)
- Unknown42 `PARALLEL_WriteStringLoop` SAS/C compare script: `src/decomp/scripts/compare_sasc_parallel_writestringloop_trial.sh`
- Unknown42 `PARALLEL_RawDoFmtStackArgs` SAS/C compare script: `src/decomp/scripts/compare_sasc_parallel_rawdofmtstackargs_trial.sh`
- Unknown42 `PARALLEL_RawDoFmtCommon` SAS/C compare script: `src/decomp/scripts/compare_sasc_parallel_rawdofmtcommon_trial.sh`
- Unknown42 `PARALLEL_WriteCharHw` SAS/C compare script: `src/decomp/scripts/compare_sasc_parallel_writecharhw_trial.sh`
- Unknown42 `PARALLEL_RawDoFmt` SAS/C compare script: `src/decomp/scripts/compare_sasc_parallel_rawdofmt_trial.sh`
- SAS/C trial sources currently used:
- `src/decomp/sas_c/test_memory_pair.c`
- `src/decomp/sas_c/string_to_upper_char.c`
- `src/decomp/sas_c/unknown34_pair.c`
- `src/decomp/sas_c/unknown34_dos_read_by_index.c`
- `src/decomp/sas_c/unknown11_dos_seek_by_index.c`
- `src/decomp/sas_c/unknown12_alloc_alloc_from_free_list.c`
- `src/decomp/sas_c/unknown6_string_append_at_null.c`
- `src/decomp/sas_c/unknown5_string_append_n.c`
- `src/decomp/sas_c/unknown5_string_compare_n.c`
- `src/decomp/sas_c/unknown5_string_compare_nocase.c`
- `src/decomp/sas_c/unknown5_string_copy_pad_nul.c`
- `src/decomp/sas_c/unknown5_string_compare_nocase_n.c`
- `src/decomp/sas_c/unknown33_string_find_substring.c`
- `src/decomp/sas_c/unknown26_dos_write_by_index.c`
- `src/decomp/sas_c/unknown4_string_toupper_inplace.c`
- `src/decomp/sas_c/unknown3_string_toupper_char.c`
- `src/decomp/sas_c/unknown23_handle_get_entry_by_index.c`
- `src/decomp/sas_c/unknown37_handle_close_by_index.c`
- `src/decomp/sas_c/unknown19_dos_read_with_error_state.c`
- `src/decomp/sas_c/unknown17_dos_write_with_error_state.c`
- `src/decomp/sas_c/unknown18_dos_seek_with_error_state.c`
- `src/decomp/sas_c/unknown20_dos_open_with_error_state.c`
- `src/decomp/sas_c/unknown21_iostdreq_free.c`
- `src/decomp/sas_c/unknown21_iostdreq_cleanup_signal_and_msgport.c`
- `src/decomp/sas_c/unknown21_dos_open_new_file_if_missing.c`
- `src/decomp/sas_c/unknown21_dos_delete_and_recreate_file.c`
- `src/decomp/sas_c/unknown24_parse_read_signed_long_skip_class3.c`
- `src/decomp/sas_c/unknown24_memlist_alloc_free.c`
- `src/decomp/sas_c/unknown25_struct_alloc_free.c`
- `src/decomp/sas_c/unknown27_format_buffer2.c`
- `src/decomp/sas_c/unknown2a_format_raw_dofmt_with_scratch_buffer.c`
- `src/decomp/sas_c/unknown28_wdisp_format_with_callback.c`
- `src/decomp/sas_c/unknown30_exec_call_vector_348.c`
- `src/decomp/sas_c/unknown31_buffer_ensure_allocated.c`
- `src/decomp/sas_c/unknown32_handle_close_all_and_return_with_code.c`
- `src/decomp/sas_c/unknown35_handle_open_with_mode.c`
- `src/decomp/sas_c/unknown36_finalize_and_abort_requester.c`
- `src/decomp/sas_c/unknown38_signal_poll_and_dispatch.c`
- `src/decomp/sas_c/unknown39_graphics_bltbitmaprastport.c`
- `src/decomp/sas_c/diskio_get_filesize_from_handle.c`
- `src/decomp/sas_c/diskio_query_volume_soft_error_count.c`
- `src/decomp/sas_c/diskio_write_bytes_to_output_handle_guarded.c`
- `src/decomp/sas_c/diskio_force_ui_refresh_if_idle.c`
- `src/decomp/sas_c/diskio_reset_ctrl_input_state_if_idle.c`
- `src/decomp/sas_c/diskio_draw_transfer_error_message_if_diagnostics.c`
- `src/decomp/sas_c/diskio_ensure_pc1_mounted_and_gfx_assigned.c`
- `src/decomp/sas_c/diskio_consume_cstring_from_work_buffer.c`
- `src/decomp/sas_c/diskio_parse_long_from_work_buffer.c`
- `src/decomp/sas_c/diskio_consume_line_from_work_buffer.c`
- `src/decomp/sas_c/diskio_load_file_to_work_buffer.c`
- `src/decomp/sas_c/diskio_open_file_with_buffer.c`
- `src/decomp/sas_c/diskio_query_disk_usage_percent_and_set_buffer_size.c`
- `src/decomp/sas_c/diskio_write_buffered_bytes.c`
- `src/decomp/sas_c/diskio_close_buffered_file_and_flush.c`
- `src/decomp/sas_c/diskio_load_config_from_disk.c`
- `src/decomp/sas_c/diskio_save_config_to_file_handle.c`
- `src/decomp/sas_c/diskio_parse_config_buffer.c`
- `src/decomp/sas_c/diskio_return_stubs.c`
- `src/decomp/sas_c/diskio_probe_drives_and_assign_paths.c`
- `src/decomp/sas_c/diskio2_flush_reload_helpers.c`
- `src/decomp/sas_c/diskio2_copy_sanitize_helpers.c`
- `src/decomp/sas_c/diskio2_display_status_line.c`
- `src/decomp/sas_c/diskio2_run_disk_sync_workflow.c`
- `src/decomp/sas_c/diskio2_parse_ini_file_from_disk.c`
- `src/decomp/sas_c/diskio2_write_oinfo_data_file.c`
- `src/decomp/sas_c/diskio2_load_oinfo_data_file.c`
- `src/decomp/sas_c/diskio2_write_nxt_day_data_file.c`
- `src/decomp/sas_c/diskio2_load_nxt_day_data_file.c`
- `src/decomp/sas_c/diskio2_write_qtable_ini_file.c`
- `src/decomp/sas_c/diskio2_receive_transfer_blocks_to_file.c`
- `src/decomp/sas_c/diskio2_handle_interactive_file_transfer.c`
- `src/decomp/sas_c/diskio2_load_cur_day_data_file.c`
- `src/decomp/sas_c/diskio2_write_cur_day_data_file.c`
- `src/decomp/sas_c/diskio1_dump_default_coi_info_block.c`
- `src/decomp/sas_c/diskio1_dump_program_source_record_verbose.c`
- `src/decomp/sas_c/diskio1_dump_program_info_verbose.c`
- `src/decomp/sas_c/diskio1_dump_program_info_attr_table.c`
- `src/decomp/sas_c/esqshared_return_stubs.c`
- `src/decomp/sas_c/esqpars_return_stubs.c`
- `src/decomp/sas_c/displib_return_stubs.c`
- `src/decomp/sas_c/displib_find_previous_valid_entry_index.c`
- `src/decomp/sas_c/displib_apply_inline_alignment_padding.c`
- `src/decomp/sas_c/displib_display_text_at_position.c`
- `src/decomp/sas_c/displib_normalize_value_by_step.c`
- `src/decomp/sas_c/displib_reset_line_tables.c`
- `src/decomp/sas_c/displib_reset_text_buffer_and_line_tables.c`
- `src/decomp/sas_c/displib_commit_current_line_pen_and_advance.c`
- `src/decomp/sas_c/esq_invoke_gcommand_init.c`
- `src/decomp/sas_c/esq_try_rom_write_test.c`
- `src/decomp/sas_c/esq_supervisor_cold_reboot.c`
- `src/decomp/sas_c/esq_check_available_fast_memory.c`
- `src/decomp/sas_c/esq_check_compatible_video_chip.c`
- `src/decomp/sas_c/esq_check_topaz_font_guard.c`
- `src/decomp/sas_c/esq_format_disk_error_message.c`
- `src/decomp/sas_c/esq_handle_serial_rbf_interrupt.c`
- `src/decomp/sas_c/esq_init_audio1_dma.c`
- `src/decomp/sas_c/esq_poll_ctrl_input.c`
- `src/decomp/sas_c/esq_read_serial_rbf_byte.c`
- `src/decomp/sas_c/esq_return_with_stack_code.c`
- `src/decomp/sas_c/esq_capture_ctrl_bit4_stream_buffer_byte.c`
- `src/decomp/sas_c/esq_capture_ctrl_bit4_stream.c`
- `src/decomp/sas_c/esq_capture_ctrl_bit3_stream.c`
- `src/decomp/sas_c/get_bit_3_of_ciab_pra_into_d1.c`
- `src/decomp/sas_c/get_bit_4_of_ciab_pra_into_d1.c`
- `src/decomp/sas_c/ed1_clear_esc_menu_mode.c`
- `src/decomp/sas_c/esqdisp_test_word_is_zero_booleanize.c`
- `src/decomp/sas_c/esqdisp_test_entry_bits0_and2.c`
- `src/decomp/sas_c/esqdisp_test_entry_grid_eligibility.c`
- `src/decomp/sas_c/esqdisp_set_status_indicator_color_slot.c`
- `src/decomp/sas_c/esqdisp_queue_highlight_draw_message.c`
- `src/decomp/sas_c/esqdisp_process_grid_messages_if_idle.c`
- `src/decomp/sas_c/esqdisp_fill_program_info_header_fields.c`
- `src/decomp/sas_c/esqdisp_compute_schedule_offset_for_row.c`
- `src/decomp/sas_c/esqdisp_update_status_mask_and_refresh.c`
- `src/decomp/sas_c/esqdisp_refresh_status_indicators_from_current_mask.c`
- `src/decomp/sas_c/esqdisp_allocate_highlight_bitmaps.c`
- `src/decomp/sas_c/esqdisp_init_highlight_message_pattern.c`
- `src/decomp/sas_c/esqdisp_get_entry_pointers_by_mode.c`
- `src/decomp/sas_c/esqdisp_apply_status_mask_to_indicators.c`
- `src/decomp/sas_c/disptext_small_helpers.c`
- `src/decomp/sas_c/disptext_compute_visible_line_count.c`
- `src/decomp/sas_c/disptext_layout_helpers.c`
- `src/decomp/sas_c/disptext_buffer_helpers.c`
- `src/decomp/sas_c/disptext_marker_helpers.c`
- `src/decomp/sas_c/disptext_table_helpers.c`
- `src/decomp/sas_c/disptext_append_helpers.c`
- `src/decomp/sas_c/disptext_layout_source_helpers.c`
- `src/decomp/sas_c/disptext_render_helpers.c`
- `src/decomp/sas_c/disptext_layout_lines_helpers.c`
- `src/decomp/sas_c/disptext_layout_append_helpers.c`
- `src/decomp/sas_c/disptext_build_line_helpers.c`
- `src/decomp/sas_c/diskio1_return_stubs.c`
- `src/decomp/sas_c/diskio1_advance_helpers.c`
- `src/decomp/sas_c/diskio1_accumulate_helpers.c`
- `src/decomp/sas_c/diskio1_append_attr_helpers.c`
- `src/decomp/sas_c/diskio1_mask_value_helpers.c`
- `src/decomp/sas_c/diskio1_mask_decision_helpers.c`
- `src/decomp/sas_c/diskio1_selected_times_helpers.c`
- `src/decomp/sas_c/diskio1_format_mask_helpers.c`
- `src/decomp/sas_c/gcommand3_return_stubs.c`
- `src/decomp/sas_c/ladfunc2_return_stubs.c`
- `src/decomp/sas_c/locavail_return_stubs.c`
- `src/decomp/sas_c/flib_return_stubs.c`
- `src/decomp/sas_c/ladfunc_return_stubs.c`
- `src/decomp/sas_c/esqiff2_return_stubs.c`
- `src/decomp/sas_c/return_misc_stubs.c`
- `src/decomp/sas_c/unknown41_clock_convert_amiga_seconds_to_clock_data.c`
- `src/decomp/sas_c/diskio_write_decimal_field.c`
- `src/decomp/sas_c/unknown7_str_core_helpers.c`
- `src/decomp/sas_c/unknown8_format_u32_to_decimal_string.c`
- `src/decomp/sas_c/unknown9_format_u32_to_octal_string.c`
- `src/decomp/sas_c/unknown10_format_u32_to_hex_string.c`
- `src/decomp/sas_c/unknown10_printf_putc_to_buffer.c`
- `src/decomp/sas_c/unknown10_wdisp_sprintf.c`
- `src/decomp/sas_c/unknown10_parse_read_signed_long.c`
- `src/decomp/sas_c/unknown10_parse_read_signed_long_nobranch.c`
- `src/decomp/sas_c/unknown10_handle_open_entry_with_flags.c`
- `src/decomp/sas_c/unknown13_format_callback_buffer.c`
- `src/decomp/sas_c/unknown14_handle_open_from_mode_string.c`
- `src/decomp/sas_c/unknown15_stream_read_line_with_limit.c`
- `src/decomp/sas_c/unknown16_buffer_flush_all_and_close_with_code.c`
- `src/decomp/sas_c/unknown29_jmptbl_esq_main_init_and_run.c`
- `src/decomp/sas_c/unknown29_esq_parse_command_line_and_run.c`
- `src/decomp/sas_c/unknown2b_main_noop_hooks.c`
- `src/decomp/sas_c/dos_open_file_with_mode.c`
- `src/decomp/sas_c/graphics_alloc_raster.c`
- `src/decomp/sas_c/graphics_free_raster.c`
- `src/decomp/sas_c/unknown_esqproto_copy_label_to_global.c`
- `src/decomp/sas_c/unknown_esqproto_parse_digit_label_and_display.c`
- `src/decomp/sas_c/unknown_parse_record_and_update_display.c`
- `src/decomp/sas_c/unknown_parse_list_and_update_entries.c`
- `src/decomp/sas_c/unknown_esqproto_verify_checksum_and_parse_record.c`
- `src/decomp/sas_c/unknown_esqproto_verify_checksum_and_parse_list.c`
- `src/decomp/sas_c/datetime_isleapyear.c`
- `src/decomp/sas_c/script3_jmptbl_stubs.c`
- `src/decomp/sas_c/textdisp_jmptbl_stubs.c`
- `src/decomp/sas_c/p_type_jmptbl_stubs.c`
- `src/decomp/sas_c/esqiff_jmptbl_stubs_a.c`
- `src/decomp/sas_c/esqiff_jmptbl_stubs_b.c`
- `src/decomp/sas_c/esqiff_jmptbl_stubs_c.c`
- `src/decomp/sas_c/esqiff_jmptbl_stubs_d.c`
- `src/decomp/sas_c/esqiff_jmptbl_stubs_e.c`
- `src/decomp/sas_c/esqiff_jmptbl_stubs_f.c`
- `src/decomp/sas_c/esqiff_jmptbl_stubs_g.c`
- `src/decomp/sas_c/esqiff_jmptbl_stubs_h.c`
- `src/decomp/sas_c/esqiff_jmptbl_stubs_i.c`
- `src/decomp/sas_c/esq_noop_triplet.c`
- `src/decomp/sas_c/esq_bit1_ops.c`
- `src/decomp/sas_c/esq_terminate_after_second_quote.c`
- `src/decomp/sas_c/esq_wildcard_match.c`
- `src/decomp/sas_c/esq_generate_xor_checksum_byte.c`
- `src/decomp/sas_c/esq_find_substring_case_fold.c`
- `src/decomp/sas_c/esq_write_dec_fixed_width.c`
- `src/decomp/sas_c/esq_packbits_decode.c`
- `src/decomp/sas_c/esq_get_half_hour_slot_index.c`
- `src/decomp/sas_c/esq_clamp_banner_char_range.c`
- `src/decomp/sas_c/esq_reverse_bits_in6_bytes.c`
- `src/decomp/sas_c/esq_dec_color_step.c`
- `src/decomp/sas_c/esq_bump_color_toward_targets.c`
- `src/decomp/sas_c/esq_calc_day_of_year_from_month_day.c`
- `src/decomp/sas_c/esq_update_month_day_from_day_of_year.c`
- `src/decomp/sas_c/esq_format_time_stamp.c`
- `src/decomp/sas_c/esq_store_ctrl_sample_entry.c`
- `src/decomp/sas_c/esq_set_copper_effect_params.c`
- `src/decomp/sas_c/esq_set_copper_effect_default.c`
- `src/decomp/sas_c/esq_set_copper_effect_all_on.c`
- `src/decomp/sas_c/esq_set_copper_effect_custom.c`
- `src/decomp/sas_c/esq_set_copper_effect_off_disable_highlight.c`
- `src/decomp/sas_c/esq_set_copper_effect_on_enable_highlight.c`
- `src/decomp/sas_c/esq_update_copper_lists_from_params.c`
- `src/decomp/sas_c/esq_move_copper_entry_toward_start.c`
- `src/decomp/sas_c/esq_move_copper_entry_toward_end.c`
- `src/decomp/sas_c/esq_dec_copper_lists_primary.c`
- `src/decomp/sas_c/esq_inc_copper_lists_towards_targets.c`
- `src/decomp/sas_c/esq_seed_minute_event_thresholds.c`
- `src/decomp/sas_c/esq_tick_global_counters.c`
- `src/decomp/sas_c/esq_adjust_bracketed_hour_in_string.c`
- `src/decomp/sas_c/esq_advance_banner_char_index_return.c`
- `src/decomp/sas_c/esq_tick_clock_and_flag_events.c`
- `src/decomp/sas_c/esq_cold_reboot_pair.c`
- `src/decomp/sas_c/datetime_adjust_month_index.c`
- `src/decomp/sas_c/datetime_normalize_month_range.c`
- `src/decomp/sas_c/dst_normalize_day_of_year.c`
- `src/decomp/sas_c/dst_build_banner_time_word.c`
- `src/decomp/sas_c/dst_free_banner_struct.c`
- `src/decomp/sas_c/dst_free_banner_pair.c`
- `src/decomp/sas_c/dst_allocate_banner_struct.c`
- `src/decomp/sas_c/dst_rebuild_banner_pair.c`
- `src/decomp/sas_c/dst_compute_banner_index.c`
- `src/decomp/sas_c/dst_tick_banner_counters.c`
- `src/decomp/sas_c/dst_add_time_offset.c`
- `src/decomp/sas_c/dst_write_rtc_from_globals.c`
- `src/decomp/sas_c/newgrid_jmptbl_stubs.c`
- `src/decomp/sas_c/newgrid_jmptbl_cleanup_draw_clock_format_list.c`
- `src/decomp/sas_c/newgrid_jmptbl_cleanup_draw_clock_banner.c`
- `src/decomp/sas_c/newgrid_jmptbl_cleanup_draw_clock_format_frame.c`
- `src/decomp/sas_c/dst_handle_banner_command32_33.c`
- `src/decomp/sas_c/dst_build_banner_time_entry.c`
- `src/decomp/sas_c/dst_format_banner_datetime.c`
- `src/decomp/sas_c/dst_update_banner_queue.c`
- `src/decomp/sas_c/dst_refresh_banner_buffer.c`
- `src/decomp/sas_c/dst_load_banner_pair_from_files.c`
- `src/decomp/sas_c/unknown_jmptbl_core_stubs.c`
- `src/decomp/sas_c/group_ag_jmptbl_memory_deallocate_memory.c`
- `src/decomp/sas_c/group_ag_jmptbl_memory_allocate_memory.c`
- `src/decomp/sas_c/group_ag_jmptbl_math_stubs.c`
- `src/decomp/sas_c/group_ag_jmptbl_signal_struct_stubs.c`
- `src/decomp/sas_c/group_ag_jmptbl_misc_stubs.c`
- `src/decomp/sas_c/group_ag_jmptbl_parse_dos_script_stubs.c`
- `src/decomp/sas_c/parseini2_jmptbl_stubs.c`
- `src/decomp/sas_c/group_ag_jmptbl_esqfunc_textdisp_stubs.c`
- `src/decomp/sas_c/newgrid2_jmptbl_stubs.c`
- `src/decomp/sas_c/newgrid2_jmptbl_esqdisp_get_entry_pointer_by_mode.c`
- `src/decomp/sas_c/newgrid2_jmptbl_bevel_draw_bevel_frame_with_top.c`
- `src/decomp/sas_c/newgrid2_jmptbl_disptext_compute_marker_widths.c`
- `src/decomp/sas_c/newgrid2_jmptbl_bevel_draw_vertical_bevel_pair.c`
- `src/decomp/sas_c/wdisp_jmptbl_stubs.c`
- `src/decomp/sas_c/group_ag_jmptbl_script_ladfunc2_stubs.c`
- `src/decomp/sas_c/group_main_a_jmptbl_stubs.c`
- `src/decomp/sas_c/group_main_b_jmptbl_stubs.c`
- `src/decomp/sas_c/group_al_jmptbl_stubs.c`
- `src/decomp/sas_c/group_ay_jmptbl_stubs.c`
- `src/decomp/sas_c/group_aw_jmptbl_stubs_core.c`
- `src/decomp/sas_c/group_aw_jmptbl_esqiff_run_copper_drop_transition.c`
- `src/decomp/sas_c/group_as_jmptbl_stubs.c`
- `src/decomp/sas_c/group_at_jmptbl_stubs_core.c`
- `src/decomp/sas_c/group_at_jmptbl_ed1_wait_for_flag_and_clear_bit1.c`
- `src/decomp/sas_c/group_au_jmptbl_stubs.c`
- `src/decomp/sas_c/group_ax_jmptbl_format_raw_dofmt_with_scratch_buffer.c`
- `src/decomp/sas_c/group_az_jmptbl_esq_cold_reboot.c`
- `src/decomp/sas_c/group_aa_jmptbl_stubs.c`
- `src/decomp/sas_c/group_ar_jmptbl_stubs.c`
- `src/decomp/sas_c/group_af_jmptbl_gcommand_save_brush_result.c`
- `src/decomp/sas_c/group_av_jmptbl_stubs.c`
- `src/decomp/sas_c/group_ab_jmptbl_stubs.c`
- `src/decomp/sas_c/group_ae_jmptbl_stubs_core.c`
- `src/decomp/sas_c/group_ae_jmptbl_esqdisp_get_entry_pointer_by_mode.c`
- `src/decomp/sas_c/group_aj_jmptbl_stubs.c`
- `src/decomp/sas_c/group_ai_jmptbl_stubs.c`
- `src/decomp/sas_c/group_ak_jmptbl_stubs.c`
- `src/decomp/sas_c/group_ak_jmptbl_esq_set_copper_effect_default.c`
- `src/decomp/sas_c/group_ak_jmptbl_xjump2_stubs.c`
- `src/decomp/sas_c/group_ac_jmptbl_stubs.c`
- `src/decomp/sas_c/group_ac_jmptbl_script_update_ctrl_state_machine.c`
- `src/decomp/sas_c/group_ad_jmptbl_stubs.c`
- `src/decomp/sas_c/group_ad_jmptbl_esqiff_run_copper_rise_transition.c`
- `src/decomp/sas_c/group_ad_jmptbl_tliba3_get_view_mode_rast_port.c`
- `src/decomp/sas_c/group_ah_jmptbl_stubs.c`
- `src/decomp/sas_c/group_am_jmptbl_stubs.c`
- `src/decomp/sas_c/group_am_jmptbl_esq_set_copper_effect_off_disable_highlight.c`
- `src/decomp/sas_c/ed1_jmptbl_stubs.c`
- `src/decomp/sas_c/esqfunc_jmptbl_stubs.c`
- `src/decomp/sas_c/esqfunc_jmptbl_script_read_ciab_bit5_mask.c`
- `src/decomp/sas_c/esqdisp_jmptbl_stubs.c`
- `src/decomp/sas_c/esqshared_jmptbl_stubs.c`
- `src/decomp/sas_c/esqpars_jmptbl_stubs.c`
- `src/decomp/sas_c/esqpars_jmptbl_esqproto_verify_checksum_and_parse_record.c`
- `src/decomp/sas_c/tliba1_jmptbl_stubs.c`
- `src/decomp/sas_c/tliba2_jmptbl_stubs.c`
- `src/decomp/sas_c/tliba3_jmptbl_stubs.c`
- `src/decomp/sas_c/textdisp2_jmptbl_stubs.c`
- `src/decomp/sas_c/script2_jmptbl_stubs.c`
- `src/decomp/sas_c/script_jmptbl_stubs.c`
- `src/decomp/sas_c/parseini_jmptbl_stubs.c`
- `src/decomp/sas_c/parseini_jmptbl_string_compare_nocase_n.c`
- `src/decomp/sas_c/parseini_jmptbl_ed1_wait_for_flag_and_clear_bit1.c`
- `src/decomp/sas_c/newgrid2_jmptbl_stubs.c`
- `src/decomp/sas_c/newgrid2_jmptbl_esqdisp_get_entry_pointer_by_mode.c`
- `src/decomp/sas_c/newgrid2_jmptbl_bevel_draw_bevel_frame_with_top.c`
- `src/decomp/sas_c/newgrid2_jmptbl_disptext_compute_marker_widths.c`
- `src/decomp/sas_c/newgrid2_jmptbl_bevel_draw_vertical_bevel_pair.c`
- `src/decomp/sas_c/wdisp_jmptbl_stubs.c`
- `src/decomp/sas_c/unknown22_dos_close_with_signal_check.c`
- `src/decomp/sas_c/unknown22_math_mulu32.c`
- `src/decomp/sas_c/unknown22_math_divs32.c`
- `src/decomp/sas_c/unknown22_math_divu32.c`
- `src/decomp/sas_c/unknown22_signal_create_msgport_with_signal.c`
- `src/decomp/sas_c/unknown22_allocate_alloc_and_initialize_iostdreq.c`
- `src/decomp/sas_c/unknown40_dos_delay.c`
- `src/decomp/sas_c/unknown40_dos_system_tag_list.c`
- `src/decomp/sas_c/unknown40_battclock_get_seconds.c`
- `src/decomp/sas_c/unknown40_battclock_write_seconds.c`
- `src/decomp/sas_c/unknown40_exec_call_vector_48.c`
- `src/decomp/sas_c/unknown42_clock_wrappers.c`
- `src/decomp/sas_c/unknown42_parallel_ready.c`
- `src/decomp/sas_c/unknown42_parallel_writechar.c`
- `src/decomp/sas_c/unknown42_parallel_string_and_rawdofmt.c`
- `src/decomp/sas_c/unknown42_parallel_hw_and_rawdofmt.c`
- Semantic checkpoints for SAS/C trials:
- `src/decomp/scripts/semantic_filter_sasc_memory_allocate.awk`
- `src/decomp/scripts/semantic_filter_sasc_memory_deallocate.awk`
- `src/decomp/scripts/semantic_filter_sasc_string_toupper.awk`
- `src/decomp/scripts/semantic_filter_sasc_list_init.awk`
- `src/decomp/scripts/semantic_filter_sasc_mem_move.awk`
- `src/decomp/scripts/semantic_filter_sasc_list_init_header.awk`
- `src/decomp/scripts/semantic_filter_sasc_dos_read_by_index.awk`
- `src/decomp/scripts/semantic_filter_sasc_dos_seek_by_index.awk`
- `src/decomp/scripts/semantic_filter_sasc_alloc_alloc_from_free_list.awk`
- `src/decomp/scripts/semantic_filter_sasc_string_append_at_null.awk`
- `src/decomp/scripts/semantic_filter_sasc_string_append_n.awk`
- `src/decomp/scripts/semantic_filter_sasc_string_compare_n.awk`
- `src/decomp/scripts/semantic_filter_sasc_string_compare_nocase.awk`
- `src/decomp/scripts/semantic_filter_sasc_string_copy_pad_nul.awk`
- `src/decomp/scripts/semantic_filter_sasc_string_compare_nocase_n.awk`
- `src/decomp/scripts/semantic_filter_sasc_string_find_substring.awk`
- `src/decomp/scripts/semantic_filter_sasc_alloc_insert_free_block.awk`
- `src/decomp/scripts/semantic_filter_sasc_dos_write_by_index.awk`
- `src/decomp/scripts/semantic_filter_sasc_string_toupper_inplace.awk`
- `src/decomp/scripts/semantic_filter_sasc_string_toupper_char.awk`
- `src/decomp/scripts/semantic_filter_sasc_handle_get_entry_by_index.awk`
- `src/decomp/scripts/semantic_filter_sasc_handle_close_by_index.awk`
- `src/decomp/scripts/semantic_filter_sasc_dos_read_with_error_state.awk`
- `src/decomp/scripts/semantic_filter_sasc_dos_write_with_error_state.awk`
- `src/decomp/scripts/semantic_filter_sasc_dos_seek_with_error_state.awk`
- `src/decomp/scripts/semantic_filter_sasc_dos_open_with_error_state.awk`
- `src/decomp/scripts/semantic_filter_sasc_iostdreq_free.awk`
- `src/decomp/scripts/semantic_filter_sasc_iostdreq_cleanup_signal_and_msgport.awk`
- `src/decomp/scripts/semantic_filter_sasc_dos_open_new_file_if_missing.awk`
- `src/decomp/scripts/semantic_filter_sasc_dos_delete_and_recreate_file.awk`
- `src/decomp/scripts/semantic_filter_sasc_parse_read_signed_long_skip_class3.awk`
- `src/decomp/scripts/semantic_filter_sasc_parse_read_signed_long_skip_class3_alt.awk`
- `src/decomp/scripts/semantic_filter_sasc_memlist_free_all.awk`
- `src/decomp/scripts/semantic_filter_sasc_memlist_alloc_tracked.awk`
- `src/decomp/scripts/semantic_filter_sasc_struct_free_with_size_field.awk`
- `src/decomp/scripts/semantic_filter_sasc_struct_alloc_with_owner.awk`
- `src/decomp/scripts/semantic_filter_sasc_format_buffer2_write_char.awk`
- `src/decomp/scripts/semantic_filter_sasc_format_to_buffer2.awk`
- `src/decomp/scripts/semantic_filter_sasc_format_raw_dofmt_with_scratch_buffer.awk`
- `src/decomp/scripts/semantic_filter_sasc_unknown2a_stub0.awk`
- `src/decomp/scripts/semantic_filter_sasc_wdisp_format_with_callback.awk`
- `src/decomp/scripts/semantic_filter_sasc_exec_call_vector_348.awk`
- `src/decomp/scripts/semantic_filter_sasc_buffer_ensure_allocated.awk`
- `src/decomp/scripts/semantic_filter_sasc_handle_close_all_and_return_with_code.awk`
- `src/decomp/scripts/semantic_filter_sasc_unknown32_jmptbl_esq_return_with_stack_code.awk`
- `src/decomp/scripts/semantic_filter_sasc_handle_open_with_mode.awk`
- `src/decomp/scripts/semantic_filter_sasc_unknown36_finalize_request.awk`
- `src/decomp/scripts/semantic_filter_sasc_unknown36_show_abort_requester.awk`
- `src/decomp/scripts/semantic_filter_sasc_signal_poll_and_dispatch.awk`
- `src/decomp/scripts/semantic_filter_sasc_graphics_bltbitmaprastport.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio_get_filesize_from_handle.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio_query_volume_soft_error_count.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio_write_bytes_to_output_handle_guarded.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio_force_ui_refresh_if_idle.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio_reset_ctrl_input_state_if_idle.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio_draw_transfer_error_message_if_diagnostics.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio_ensure_pc1_mounted_and_gfx_assigned.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio_consume_cstring_from_work_buffer.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio_parse_long_from_work_buffer.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio_consume_line_from_work_buffer.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio_load_file_to_work_buffer.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio_open_file_with_buffer.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio_query_disk_usage_percent_and_set_buffer_size.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio_write_buffered_bytes.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio_close_buffered_file_and_flush.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio_load_config_from_disk.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio_save_config_to_file_handle.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio_parse_config_buffer.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio_return_stub.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio_probe_drives_and_assign_paths.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio2_flush_helper.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio2_reload_helper.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio2_copy_sanitize_helper.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio2_display_status_line.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio2_run_disk_sync_workflow.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio2_parse_ini_file_from_disk.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio2_write_oinfo_data_file.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio2_load_oinfo_data_file.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio2_write_nxt_day_data_file.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio2_load_nxt_day_data_file.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio2_write_qtable_ini_file.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio2_receive_transfer_blocks_to_file.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio2_handle_interactive_file_transfer.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio2_load_cur_day_data_file.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio2_write_cur_day_data_file.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio1_dump_default_coi_info_block.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio1_dump_program_source_record_verbose.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio1_dump_program_info_verbose.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio1_dump_program_info_attr_table.awk`
- `src/decomp/scripts/semantic_filter_sasc_esqshared_return_stub.awk`
- `src/decomp/scripts/semantic_filter_sasc_esqpars_return_stub.awk`
- `src/decomp/scripts/semantic_filter_sasc_displib_return_stub.awk`
- `src/decomp/scripts/semantic_filter_sasc_displib_find_previous_valid_entry_index.awk`
- `src/decomp/scripts/semantic_filter_sasc_displib_apply_inline_alignment_padding.awk`
- `src/decomp/scripts/semantic_filter_sasc_displib_display_text_at_position.awk`
- `src/decomp/scripts/semantic_filter_sasc_displib_normalize_value_by_step.awk`
- `src/decomp/scripts/semantic_filter_sasc_displib_reset_line_tables.awk`
- `src/decomp/scripts/semantic_filter_sasc_displib_reset_text_buffer_and_line_tables.awk`
- `src/decomp/scripts/semantic_filter_sasc_displib_commit_current_line_pen_and_advance.awk`
- `src/decomp/scripts/semantic_filter_sasc_esq_invoke_gcommand_init.awk`
- `src/decomp/scripts/semantic_filter_sasc_esq_try_rom_write_test.awk`
- `src/decomp/scripts/semantic_filter_sasc_esq_supervisor_cold_reboot.awk`
- `src/decomp/scripts/semantic_filter_sasc_esq_check_available_fast_memory.awk`
- `src/decomp/scripts/semantic_filter_sasc_esq_check_compatible_video_chip.awk`
- `src/decomp/scripts/semantic_filter_sasc_esq_check_topaz_font_guard.awk`
- `src/decomp/scripts/semantic_filter_sasc_esq_format_disk_error_message.awk`
- `src/decomp/scripts/semantic_filter_sasc_esq_handle_serial_rbf_interrupt.awk`
- `src/decomp/scripts/semantic_filter_sasc_esq_init_audio1_dma.awk`
- `src/decomp/scripts/semantic_filter_sasc_esq_poll_ctrl_input.awk`
- `src/decomp/scripts/semantic_filter_sasc_esq_read_serial_rbf_byte.awk`
- `src/decomp/scripts/semantic_filter_sasc_esq_return_with_stack_code.awk`
- `src/decomp/scripts/semantic_filter_sasc_esq_capture_ctrl_bit4_stream_buffer_byte.awk`
- `src/decomp/scripts/semantic_filter_sasc_esq_capture_ctrl_bit4_stream.awk`
- `src/decomp/scripts/semantic_filter_sasc_esq_capture_ctrl_bit3_stream.awk`
- `src/decomp/scripts/semantic_filter_sasc_get_bit_3_of_ciab_pra_into_d1.awk`
- `src/decomp/scripts/semantic_filter_sasc_get_bit_4_of_ciab_pra_into_d1.awk`
- `src/decomp/scripts/semantic_filter_sasc_ed1_clear_esc_menu_mode.awk`
- `src/decomp/scripts/semantic_filter_sasc_esqdisp_test_word_is_zero_booleanize.awk`
- `src/decomp/scripts/semantic_filter_sasc_esqdisp_test_entry_bits0_and2.awk`
- `src/decomp/scripts/semantic_filter_sasc_esqdisp_test_entry_grid_eligibility.awk`
- `src/decomp/scripts/semantic_filter_sasc_esqdisp_set_status_indicator_color_slot.awk`
- `src/decomp/scripts/semantic_filter_sasc_esqdisp_queue_highlight_draw_message.awk`
- `src/decomp/scripts/semantic_filter_sasc_esqdisp_process_grid_messages_if_idle.awk`
- `src/decomp/scripts/semantic_filter_sasc_esqdisp_fill_program_info_header_fields.awk`
- `src/decomp/scripts/semantic_filter_sasc_esqdisp_compute_schedule_offset_for_row.awk`
- `src/decomp/scripts/semantic_filter_sasc_esqdisp_update_status_mask_and_refresh.awk`
- `src/decomp/scripts/semantic_filter_sasc_esqdisp_refresh_status_indicators_from_current_mask.awk`
- `src/decomp/scripts/semantic_filter_sasc_esqdisp_allocate_highlight_bitmaps.awk`
- `src/decomp/scripts/semantic_filter_sasc_esqdisp_init_highlight_message_pattern.awk`
- `src/decomp/scripts/semantic_filter_sasc_esqdisp_get_entry_pointer_by_mode.awk`
- `src/decomp/scripts/semantic_filter_sasc_esqdisp_get_entry_aux_pointer_by_mode.awk`
- `src/decomp/scripts/semantic_filter_sasc_esqdisp_apply_status_mask_to_indicators.awk`
- `src/decomp/scripts/semantic_filter_sasc_disptext_set_current_line_index.awk`
- `src/decomp/scripts/semantic_filter_sasc_disptext_get_total_line_count.awk`
- `src/decomp/scripts/semantic_filter_sasc_disptext_has_multiple_lines.awk`
- `src/decomp/scripts/semantic_filter_sasc_disptext_is_last_line_selected.awk`
- `src/decomp/scripts/semantic_filter_sasc_disptext_is_current_line_last.awk`
- `src/decomp/scripts/semantic_filter_sasc_disptext_measure_current_line_length.awk`
- `src/decomp/scripts/semantic_filter_sasc_disptext_compute_visible_line_count.awk`
- `src/decomp/scripts/semantic_filter_sasc_disptext_finalize_line_table.awk`
- `src/decomp/scripts/semantic_filter_sasc_disptext_set_layout_params.awk`
- `src/decomp/scripts/semantic_filter_sasc_disptext_init_buffers.awk`
- `src/decomp/scripts/semantic_filter_sasc_disptext_free_buffers.awk`
- `src/decomp/scripts/semantic_filter_sasc_disptext_compute_marker_widths.awk`
- `src/decomp/scripts/semantic_filter_sasc_disptext_build_line_pointer_table.awk`
- `src/decomp/scripts/semantic_filter_sasc_disptext_append_to_buffer.awk`
- `src/decomp/scripts/semantic_filter_sasc_disptext_build_layout_for_source.awk`
- `src/decomp/scripts/semantic_filter_sasc_disptext_render_current_line.awk`
- `src/decomp/scripts/semantic_filter_sasc_disptext_layout_source_to_lines.awk`
- `src/decomp/scripts/semantic_filter_sasc_disptext_layout_and_append_to_buffer.awk`
- `src/decomp/scripts/semantic_filter_sasc_disptext_build_line_with_width.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio1_return_stub.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio1_advance_helper.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio1_accumulate_helper.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio1_append_attr_helper.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio1_mask_value_helper.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio1_mask_decision_helper.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio1_selected_times_helper.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio1_format_mask_helper.awk`
- `src/decomp/scripts/semantic_filter_sasc_gcommand3_return_stub.awk`
- `src/decomp/scripts/semantic_filter_sasc_ladfunc2_return_stub.awk`
- `src/decomp/scripts/semantic_filter_sasc_locavail_return_stub.awk`
- `src/decomp/scripts/semantic_filter_sasc_flib_return_stub.awk`
- `src/decomp/scripts/semantic_filter_sasc_ladfunc_return_stub.awk`
- `src/decomp/scripts/semantic_filter_sasc_esqiff2_return_stub.awk`
- `src/decomp/scripts/semantic_filter_sasc_return_stub.awk`
- `src/decomp/scripts/semantic_filter_sasc_clock_convert_amiga_seconds_to_clock_data.awk`
- `src/decomp/scripts/semantic_filter_sasc_diskio_write_decimal_field.awk`
- `src/decomp/scripts/semantic_filter_sasc_str_copy_until_any_delim_n.awk`
- `src/decomp/scripts/semantic_filter_sasc_str_find_char.awk`
- `src/decomp/scripts/semantic_filter_sasc_str_find_char_ptr.awk`
- `src/decomp/scripts/semantic_filter_sasc_str_find_any_char_in_set.awk`
- `src/decomp/scripts/semantic_filter_sasc_str_find_any_char_ptr.awk`
- `src/decomp/scripts/semantic_filter_sasc_str_skip_class3_chars.awk`
- `src/decomp/scripts/semantic_filter_sasc_format_u32_to_decimal_string.awk`
- `src/decomp/scripts/semantic_filter_sasc_format_u32_to_octal_string.awk`
- `src/decomp/scripts/semantic_filter_sasc_format_u32_to_hex.awk`
- `src/decomp/scripts/semantic_filter_sasc_unknown10_printf_putc_to_buffer.awk`
- `src/decomp/scripts/semantic_filter_sasc_wdisp_sprintf.awk`
- `src/decomp/scripts/semantic_filter_sasc_parse_read_signed_long.awk`
- `src/decomp/scripts/semantic_filter_sasc_handle_open_entry_with_flags.awk`
- `src/decomp/scripts/semantic_filter_sasc_format_callback_write_char.awk`
- `src/decomp/scripts/semantic_filter_sasc_format_to_callback_buffer.awk`
- `src/decomp/scripts/semantic_filter_sasc_handle_open_from_mode_string.awk`
- `src/decomp/scripts/semantic_filter_sasc_stream_read_line_with_limit.awk`
- `src/decomp/scripts/semantic_filter_sasc_buffer_flush_all_and_close_with_code.awk`
- `src/decomp/scripts/semantic_filter_sasc_unknown29_jmptbl_esq_main_init_and_run.awk`
- `src/decomp/scripts/semantic_filter_sasc_esq_parse_command_line_and_run.awk`
- `src/decomp/scripts/semantic_filter_sasc_esq_main_noop_hook.awk`
- `src/decomp/scripts/semantic_filter_sasc_esqproto_copy_label_to_global.awk`
- `src/decomp/scripts/semantic_filter_sasc_esqproto_parse_digit_label_and_display.awk`
- `src/decomp/scripts/semantic_filter_sasc_unknown_parse_record_and_update_display.awk`
- `src/decomp/scripts/semantic_filter_sasc_unknown_parse_list_and_update_entries.awk`
- `src/decomp/scripts/semantic_filter_sasc_esqproto_verify_checksum_and_parse_record.awk`
- `src/decomp/scripts/semantic_filter_sasc_esqproto_verify_checksum_and_parse_list.awk`
- `src/decomp/scripts/semantic_filter_sasc_datetime_isleapyear.awk`
- `src/decomp/scripts/semantic_filter_sasc_datetime_adjust_month_index.awk`
- `src/decomp/scripts/semantic_filter_sasc_datetime_normalize_month_range.awk`
- `src/decomp/scripts/semantic_filter_sasc_dst_normalize_day_of_year.awk`
- `src/decomp/scripts/semantic_filter_sasc_dst_build_banner_time_word.awk`
- `src/decomp/scripts/semantic_filter_sasc_dst_free_banner_struct.awk`
- `src/decomp/scripts/semantic_filter_sasc_dst_free_banner_pair.awk`
- `src/decomp/scripts/semantic_filter_sasc_dst_allocate_banner_struct.awk`
- `src/decomp/scripts/semantic_filter_sasc_dst_rebuild_banner_pair.awk`
- `src/decomp/scripts/semantic_filter_sasc_dst_compute_banner_index.awk`
- `src/decomp/scripts/semantic_filter_sasc_dst_tick_banner_counters.awk`
- `src/decomp/scripts/semantic_filter_sasc_dst_add_time_offset.awk`
- `src/decomp/scripts/semantic_filter_sasc_dst_write_rtc_from_globals.awk`
- `src/decomp/scripts/semantic_filter_sasc_dst_handle_banner_command32_33.awk`
- `src/decomp/scripts/semantic_filter_sasc_dst_build_banner_time_entry.awk`
- `src/decomp/scripts/semantic_filter_sasc_dst_format_banner_datetime.awk`
- `src/decomp/scripts/semantic_filter_sasc_dst_update_banner_queue.awk`
- `src/decomp/scripts/semantic_filter_sasc_dst_refresh_banner_buffer.awk`
- `src/decomp/scripts/semantic_filter_sasc_dst_load_banner_pair_from_files.awk`
- `src/decomp/scripts/semantic_filter_sasc_unknown_jmptbl_esqiff2_read_serial_record_into_buffer.awk`
- `src/decomp/scripts/semantic_filter_sasc_unknown_jmptbl_displib_display_text_at_position.awk`
- `src/decomp/scripts/semantic_filter_sasc_unknown_jmptbl_esq_wildcard_match.awk`
- `src/decomp/scripts/semantic_filter_sasc_unknown_jmptbl_dst_normalize_day_of_year.awk`
- `src/decomp/scripts/semantic_filter_sasc_unknown_jmptbl_esq_generate_xor_checksum_byte.awk`
- `src/decomp/scripts/semantic_filter_sasc_esqproto_jmptbl_esqpars_replace_owned_string.awk`
- `src/decomp/scripts/semantic_filter_sasc_group_ag_jmptbl_memory_deallocate_memory.awk`
- `src/decomp/scripts/semantic_filter_sasc_group_ag_jmptbl_memory_allocate_memory.awk`
- `src/decomp/scripts/semantic_filter_sasc_group_ag_jmptbl_math_divs32.awk`
- `src/decomp/scripts/semantic_filter_sasc_group_ag_jmptbl_math_mulu32.awk`
- `src/decomp/scripts/semantic_filter_sasc_group_ag_jmptbl_signal_create_msgport_with_signal.awk`
- `src/decomp/scripts/semantic_filter_sasc_group_ag_jmptbl_struct_free_with_size_field.awk`
- `src/decomp/scripts/semantic_filter_sasc_group_ag_jmptbl_struct_alloc_with_owner.awk`
- `src/decomp/scripts/semantic_filter_sasc_group_ag_jmptbl_iostdreq_cleanup_signal_and_msgport.awk`
- `src/decomp/scripts/semantic_filter_sasc_group_ag_jmptbl_string_copy_pad_nul.awk`
- `src/decomp/scripts/semantic_filter_sasc_group_ag_jmptbl_parse_read_signed_long_skip_class3_alt.awk`
- `src/decomp/scripts/semantic_filter_sasc_group_ag_jmptbl_dos_open_file_with_mode.awk`
- `src/decomp/scripts/semantic_filter_sasc_group_ag_jmptbl_script_check_path_exists.awk`
- `src/decomp/scripts/semantic_filter_sasc_group_ag_jmptbl_esqfunc_service_ui_tick_if_running.awk`
- `src/decomp/scripts/semantic_filter_sasc_group_ag_jmptbl_esqfunc_update_refresh_mode_state.awk`
- `src/decomp/scripts/semantic_filter_sasc_group_ag_jmptbl_textdisp_reset_selection_and_refresh.awk`
- `src/decomp/scripts/semantic_filter_sasc_group_ag_jmptbl_script_begin_banner_char_transition.awk`
- `src/decomp/scripts/semantic_filter_sasc_group_ag_jmptbl_ladfunc2_emit_escaped_string_to_scratch.awk`
- `src/decomp/scripts/semantic_filter_sasc_jmptbl_stub.awk`
- `src/decomp/scripts/semantic_filter_sasc_dos_close_with_signal_check.awk`
- `src/decomp/scripts/semantic_filter_sasc_math_mulu32.awk`
- `src/decomp/scripts/semantic_filter_sasc_math_divs32.awk`
- `src/decomp/scripts/semantic_filter_sasc_math_divu32.awk`
- `src/decomp/scripts/semantic_filter_sasc_signal_create_msgport_with_signal.awk`
- `src/decomp/scripts/semantic_filter_sasc_allocate_alloc_and_initialize_iostdreq.awk`
- `src/decomp/scripts/semantic_filter_sasc_dos_delay.awk`
- `src/decomp/scripts/semantic_filter_sasc_dos_system_tag_list.awk`
- `src/decomp/scripts/semantic_filter_sasc_battclock_get_seconds.awk`
- `src/decomp/scripts/semantic_filter_sasc_battclock_write_seconds.awk`
- `src/decomp/scripts/semantic_filter_sasc_exec_call_vector_48.awk`
- `src/decomp/scripts/semantic_filter_sasc_clock_check_date_or_seconds_from_epoch.awk`
- `src/decomp/scripts/semantic_filter_sasc_clock_seconds_from_epoch.awk`
- `src/decomp/scripts/semantic_filter_sasc_parallel_checkready_stub.awk`
- `src/decomp/scripts/semantic_filter_sasc_parallel_checkready.awk`
- `src/decomp/scripts/semantic_filter_sasc_parallel_waitready.awk`
- `src/decomp/scripts/semantic_filter_sasc_parallel_writechard0.awk`
- `src/decomp/scripts/semantic_filter_sasc_parallel_writestringloop.awk`
- `src/decomp/scripts/semantic_filter_sasc_parallel_rawdofmtstackargs.awk`
- `src/decomp/scripts/semantic_filter_sasc_parallel_rawdofmtcommon.awk`
- `src/decomp/scripts/semantic_filter_sasc_parallel_writecharhw.awk`
- `src/decomp/scripts/semantic_filter_sasc_parallel_rawdofmt.awk`
- `src/decomp/scripts/semantic_filter_sasc_noop.awk`
- `src/decomp/scripts/semantic_filter_sasc_bit1_ops.awk`
- `src/decomp/scripts/semantic_filter_sasc_terminate_after_second_quote.awk`
- `src/decomp/scripts/semantic_filter_sasc_wildcard_match.awk`
- `src/decomp/scripts/semantic_filter_sasc_generate_xor_checksum_byte.awk`
- `src/decomp/scripts/semantic_filter_sasc_find_substring_case_fold.awk`
- `src/decomp/scripts/semantic_filter_sasc_write_dec_fixed_width.awk`
- `src/decomp/scripts/semantic_filter_sasc_packbits_decode.awk`
- `src/decomp/scripts/semantic_filter_sasc_get_half_hour_slot_index.awk`
- `src/decomp/scripts/semantic_filter_sasc_clamp_banner_char_range.awk`
- `src/decomp/scripts/semantic_filter_sasc_reverse_bits_in6_bytes.awk`
- `src/decomp/scripts/semantic_filter_sasc_dec_color_step.awk`
- `src/decomp/scripts/semantic_filter_sasc_bump_color_toward_targets.awk`
- `src/decomp/scripts/semantic_filter_sasc_calc_day_of_year_from_month_day.awk`
- `src/decomp/scripts/semantic_filter_sasc_update_month_day_from_day_of_year.awk`
- `src/decomp/scripts/semantic_filter_sasc_format_time_stamp.awk`
- `src/decomp/scripts/semantic_filter_sasc_store_ctrl_sample_entry.awk`
- `src/decomp/scripts/semantic_filter_sasc_set_copper_effect_params.awk`
- `src/decomp/scripts/semantic_filter_sasc_set_copper_effect_default.awk`
- `src/decomp/scripts/semantic_filter_sasc_set_copper_effect_all_on.awk`
- `src/decomp/scripts/semantic_filter_sasc_set_copper_effect_custom.awk`
- `src/decomp/scripts/semantic_filter_sasc_set_copper_effect_off_disable_highlight.awk`
- `src/decomp/scripts/semantic_filter_sasc_set_copper_effect_on_enable_highlight.awk`
- `src/decomp/scripts/semantic_filter_sasc_update_copper_lists_from_params.awk`
- `src/decomp/scripts/semantic_filter_sasc_move_copper_entry_toward_start.awk`
- `src/decomp/scripts/semantic_filter_sasc_move_copper_entry_toward_end.awk`
- `src/decomp/scripts/semantic_filter_sasc_dec_copper_lists_primary.awk`
- `src/decomp/scripts/semantic_filter_sasc_inc_copper_lists_towards_targets.awk`
- `src/decomp/scripts/semantic_filter_sasc_seed_minute_event_thresholds.awk`
- `src/decomp/scripts/semantic_filter_sasc_tick_global_counters.awk`
- `src/decomp/scripts/semantic_filter_sasc_adjust_bracketed_hour_in_string.awk`
- `src/decomp/scripts/semantic_filter_sasc_advance_banner_char_index_return.awk`
- `src/decomp/scripts/semantic_filter_sasc_tick_clock_and_flag_events.awk`
- `src/decomp/scripts/semantic_filter_sasc_cold_reboot_pair.awk`
- `src/decomp/scripts/semantic_filter_sasc_cold_reboot.awk`
- `src/decomp/scripts/semantic_filter_sasc_cold_reboot_via_supervisor.awk`
- `src/decomp/scripts/semantic_filter_sasc_dos_open_file_with_mode.awk`
- `src/decomp/scripts/semantic_filter_sasc_graphics_alloc_raster.awk`
- `src/decomp/scripts/semantic_filter_sasc_graphics_free_raster.awk`
- `src/decomp/scripts/compare_sasc_brush_planemaskforindex_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_brush_planemaskforindex.awk`
- `src/decomp/sas_c/brush_planemaskforindex.c`
- `src/decomp/scripts/compare_sasc_brush_free_brush_list_return_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_brush_free_brush_list_return.awk`
- `src/decomp/sas_c/brush_free_brush_list_return.c`
- `src/decomp/scripts/compare_sasc_brush_select_brush_slot_return_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_brush_select_brush_slot_return.awk`
- `src/decomp/sas_c/brush_select_brush_slot_return.c`
- `src/decomp/scripts/compare_sasc_brush_find_brush_by_predicate_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_brush_find_brush_by_predicate.awk`
- `src/decomp/sas_c/brush_find_brush_by_predicate.c`
- `src/decomp/scripts/compare_sasc_brush_pop_brush_head_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_brush_pop_brush_head.awk`
- `src/decomp/sas_c/brush_pop_brush_head.c`
- `src/decomp/scripts/compare_sasc_brush_append_brush_node_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_brush_append_brush_node.awk`
- `src/decomp/sas_c/brush_append_brush_node.c`
- `src/decomp/scripts/compare_sasc_brush_alloc_brush_node_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_brush_alloc_brush_node.awk`
- `src/decomp/sas_c/brush_alloc_brush_node.c`
- `src/decomp/scripts/compare_sasc_brush_select_brush_by_label_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_brush_select_brush_by_label.awk`
- `src/decomp/sas_c/brush_select_brush_by_label.c`
- `src/decomp/scripts/compare_sasc_brush_free_brush_resources_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_brush_free_brush_resources.awk`
- `src/decomp/sas_c/brush_free_brush_resources.c`
- `src/decomp/scripts/compare_sasc_brush_find_type3_brush_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_brush_find_type3_brush.awk`
- `src/decomp/sas_c/brush_find_type3_brush.c`
- `src/decomp/scripts/compare_sasc_brush_normalize_brush_names_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_brush_normalize_brush_names.awk`
- `src/decomp/sas_c/brush_normalize_brush_names.c`
- `src/decomp/scripts/compare_sasc_brush_stream_font_chunk_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_brush_stream_font_chunk.awk`
- `src/decomp/sas_c/brush_stream_font_chunk.c`
- `src/decomp/scripts/compare_sasc_brush_populate_brush_list_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_brush_populate_brush_list.awk`
- `src/decomp/sas_c/brush_populate_brush_list.c`
- `src/decomp/scripts/compare_sasc_brush_free_brush_list_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_brush_free_brush_list.awk`
- `src/decomp/sas_c/brush_free_brush_list.c`
- `src/decomp/scripts/compare_sasc_brush_load_color_text_font_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_brush_load_color_text_font.awk`
- `src/decomp/sas_c/brush_load_color_text_font.c`
- `src/decomp/scripts/compare_sasc_brush_load_brush_asset_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_brush_load_brush_asset.awk`
- `src/decomp/sas_c/brush_load_brush_asset.c`
- `src/decomp/scripts/compare_sasc_brush_clone_brush_record_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_brush_clone_brush_record.awk`
- `src/decomp/sas_c/brush_clone_brush_record.c`
- `src/decomp/scripts/compare_sasc_brush_select_brush_slot_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_brush_select_brush_slot.awk`
- `src/decomp/sas_c/brush_select_brush_slot.c`
- `src/decomp/scripts/compare_sasc_coi_process_entry_selection_state_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_coi_process_entry_selection_state.awk`
- `src/decomp/sas_c/coi_process_entry_selection_state.c`
- `src/decomp/scripts/compare_sasc_coi_render_clock_format_entry_variant_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_coi_render_clock_format_entry_variant.awk`
- `src/decomp/sas_c/coi_render_clock_format_entry_variant.c`
- `src/decomp/scripts/compare_sasc_coi_select_anim_field_pointer_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_coi_select_anim_field_pointer.awk`
- `src/decomp/sas_c/coi_select_anim_field_pointer.c`
- `src/decomp/scripts/compare_sasc_coi_clear_anim_object_strings_return_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_coi_clear_anim_object_strings_return.awk`
- `src/decomp/sas_c/coi_clear_anim_object_strings_return.c`
- `src/decomp/scripts/compare_sasc_coi_free_entry_resources_return_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_coi_free_entry_resources_return.awk`
- `src/decomp/sas_c/coi_free_entry_resources_return.c`
- `src/decomp/scripts/compare_sasc_coi_get_anim_field_pointer_by_mode_return_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_coi_get_anim_field_pointer_by_mode_return.awk`
- `src/decomp/sas_c/coi_get_anim_field_pointer_by_mode_return.c`
- `src/decomp/scripts/compare_sasc_coi_compute_entry_time_delta_minutes_return_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_coi_compute_entry_time_delta_minutes_return.awk`
- `src/decomp/sas_c/coi_compute_entry_time_delta_minutes_return.c`
- `src/decomp/scripts/compare_sasc_coi_compute_entry_time_delta_minutes_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_coi_compute_entry_time_delta_minutes.awk`
- `src/decomp/sas_c/coi_compute_entry_time_delta_minutes.c`
- `src/decomp/scripts/compare_sasc_coi_write_oi_data_file_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_coi_write_oi_data_file.awk`
- `src/decomp/sas_c/coi_write_oi_data_file.c`
- `src/decomp/scripts/compare_sasc_coi_load_oi_data_file_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_coi_load_oi_data_file.awk`
- `src/decomp/sas_c/coi_load_oi_data_file.c`
- `src/decomp/scripts/compare_sasc_coi_append_anim_field_with_trailing_space_return_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_coi_append_anim_field_with_trailing_space_return.awk`
- `src/decomp/sas_c/coi_append_anim_field_with_trailing_space_return.c`
- `src/decomp/scripts/compare_sasc_coi_format_entry_display_text_return_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_coi_format_entry_display_text_return.awk`
- `src/decomp/sas_c/coi_format_entry_display_text_return.c`
- `src/decomp/scripts/compare_sasc_coi_format_entry_display_text_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_coi_format_entry_display_text.awk`
- `src/decomp/sas_c/coi_format_entry_display_text.c`
- `src/decomp/scripts/compare_sasc_cleanup_test_entry_flag_y_and_bit1_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_cleanup_test_entry_flag_y_and_bit1.awk`
- `src/decomp/sas_c/cleanup_test_entry_flag_y_and_bit1.c`
- `src/decomp/scripts/compare_sasc_cleanup_update_entry_flag_bytes_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_cleanup_update_entry_flag_bytes.awk`
- `src/decomp/sas_c/cleanup_update_entry_flag_bytes.c`
- `src/decomp/scripts/compare_sasc_cleanup_format_entry_string_tokens_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_cleanup_format_entry_string_tokens.awk`
- `src/decomp/sas_c/cleanup_format_entry_string_tokens.c`
- `src/decomp/scripts/compare_sasc_cleanup_format_clock_format_entry_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_cleanup_format_clock_format_entry.awk`
- `src/decomp/sas_c/cleanup_format_clock_format_entry.c`
- `src/decomp/scripts/compare_sasc_cleanup_build_aligned_status_line_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_cleanup_build_aligned_status_line.awk`
- `src/decomp/sas_c/cleanup_build_aligned_status_line.c`
- `src/decomp/scripts/compare_sasc_cleanup_build_and_render_aligned_status_banner_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_cleanup_build_and_render_aligned_status_banner.awk`
- `src/decomp/sas_c/cleanup_build_and_render_aligned_status_banner.c`
- `src/decomp/scripts/compare_sasc_cleanup_parse_aligned_listing_block_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_cleanup_parse_aligned_listing_block.awk`
- `src/decomp/sas_c/cleanup_parse_aligned_listing_block.c`
- `src/decomp/scripts/compare_sasc_cleanup_draw_inset_rect_frame_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_cleanup_draw_inset_rect_frame.awk`
- `src/decomp/sas_c/cleanup_draw_inset_rect_frame.c`
- `src/decomp/scripts/compare_sasc_cleanup_draw_banner_spacer_segment_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_cleanup_draw_banner_spacer_segment.awk`
- `src/decomp/sas_c/cleanup_draw_banner_spacer_segment.c`
- `src/decomp/scripts/compare_sasc_cleanup_draw_date_banner_segment_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_cleanup_draw_date_banner_segment.awk`
- `src/decomp/sas_c/cleanup_draw_date_banner_segment.c`
- `src/decomp/scripts/compare_sasc_cleanup_draw_time_banner_segment_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_cleanup_draw_time_banner_segment.awk`
- `src/decomp/sas_c/cleanup_draw_time_banner_segment.c`
- `src/decomp/scripts/compare_sasc_cleanup_draw_date_time_banner_row_trial.sh`
- `src/decomp/scripts/compare_sasc_cleanup_draw_datetime_banner_row_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_cleanup_draw_date_time_banner_row.awk`
- `src/decomp/sas_c/cleanup_draw_date_time_banner_row.c`
- `src/decomp/scripts/compare_sasc_cleanup_draw_grid_time_banner_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_cleanup_draw_grid_time_banner.awk`
- `src/decomp/sas_c/cleanup_draw_grid_time_banner.c`
- `src/decomp/scripts/compare_sasc_cleanup_draw_clock_format_frame_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_cleanup_draw_clock_format_frame.awk`
- `src/decomp/sas_c/cleanup_draw_clock_format_frame.c`
- `src/decomp/scripts/compare_sasc_cleanup_draw_clock_format_list_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_cleanup_draw_clock_format_list.awk`
- `src/decomp/sas_c/cleanup_draw_clock_format_list.c`
- `src/decomp/scripts/compare_sasc_cleanup_draw_clock_banner_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_cleanup_draw_clock_banner.awk`
- `src/decomp/sas_c/cleanup_draw_clock_banner.c`
- `src/decomp/scripts/compare_sasc_cleanup_process_alerts_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_cleanup_process_alerts.awk`
- `src/decomp/sas_c/cleanup_process_alerts.c`
- `src/decomp/scripts/compare_sasc_cleanup_clear_aud1_interrupt_vector_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_cleanup_clear_aud1_interrupt_vector.awk`
- `src/decomp/sas_c/cleanup_clear_aud1_interrupt_vector.c`
- `src/decomp/scripts/compare_sasc_cleanup_clear_vertb_interrupt_server_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_cleanup_clear_vertb_interrupt_server.awk`
- `src/decomp/sas_c/cleanup_clear_vertb_interrupt_server.c`
- `src/decomp/scripts/compare_sasc_cleanup_clear_rbf_interrupt_and_serial_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_cleanup_clear_rbf_interrupt_and_serial.awk`
- `src/decomp/sas_c/cleanup_clear_rbf_interrupt_and_serial.c`
- `src/decomp/scripts/compare_sasc_cleanup_shutdown_input_devices_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_cleanup_shutdown_input_devices.awk`
- `src/decomp/sas_c/cleanup_shutdown_input_devices.c`
- `src/decomp/scripts/compare_sasc_cleanup_shutdown_system_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_cleanup_shutdown_system.awk`
- `src/decomp/sas_c/cleanup_shutdown_system.c`
- `src/decomp/scripts/compare_sasc_cleanup_release_display_resources_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_cleanup_release_display_resources.awk`
- `src/decomp/sas_c/cleanup_release_display_resources.c`
- `src/decomp/scripts/compare_sasc_cleanup_render_aligned_status_screen_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_cleanup_render_aligned_status_screen.awk`
- `src/decomp/scripts/compare_sasc_group_ab_jmptbl_unknown2a_stub0_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_group_ab_jmptbl_unknown2a_stub0.awk`
- `src/decomp/sas_c/group_ab_jmptbl_unknown2a_stub0.c`
- `src/decomp/scripts/compare_sasc_bevel_draw_vertical_bevel_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_bevel_draw_vertical_bevel.awk`
- `src/decomp/sas_c/bevel_draw_vertical_bevel.c`
- `src/decomp/scripts/compare_sasc_bevel_draw_horizontal_bevel_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_bevel_draw_horizontal_bevel.awk`
- `src/decomp/sas_c/bevel_draw_horizontal_bevel.c`
- `src/decomp/scripts/compare_sasc_bevel_draw_vertical_bevel_pair_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_bevel_draw_vertical_bevel_pair.awk`
- `src/decomp/sas_c/bevel_draw_vertical_bevel_pair.c`
- `src/decomp/scripts/compare_sasc_bevel_draw_beveled_frame_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_bevel_draw_beveled_frame.awk`
- `src/decomp/sas_c/bevel_draw_beveled_frame.c`
- `src/decomp/scripts/compare_sasc_bevel_draw_bevel_frame_with_top_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_bevel_draw_bevel_frame_with_top.awk`
- `src/decomp/sas_c/bevel_draw_bevel_frame_with_top.c`
- `src/decomp/scripts/compare_sasc_bevel_draw_bevel_frame_with_top_right_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_bevel_draw_bevel_frame_with_top_right.awk`
- `src/decomp/sas_c/bevel_draw_bevel_frame_with_top_right.c`
- `src/decomp/scripts/compare_sasc_battclock_get_seconds_from_battery_backed_clock_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_battclock_get_seconds_from_battery_backed_clock.awk`
- `src/decomp/sas_c/battclock_get_seconds_from_battery_backed_clock.c`
- `src/decomp/scripts/compare_sasc_battclock_write_seconds_to_battery_backed_clock_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_battclock_write_seconds_to_battery_backed_clock.awk`
- `src/decomp/sas_c/battclock_write_seconds_to_battery_backed_clock.c`
- `src/decomp/scripts/compare_sasc_dos_delay_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_dos_delay.awk`
- `src/decomp/sas_c/unknown40_dos_delay.c`
- `src/decomp/scripts/compare_sasc_dos_system_tag_list_trial.sh`
- `src/decomp/scripts/compare_sasc_dos_system_taglist_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_dos_system_tag_list.awk`
- `src/decomp/sas_c/unknown40_dos_system_tag_list.c`
- `src/decomp/scripts/compare_sasc_exec_call_vector_48_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_exec_call_vector_48.awk`
- `src/decomp/sas_c/unknown40_exec_call_vector_48.c`
- `src/decomp/scripts/compare_sasc_render_short_month_short_day_of_week_day_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_render_short_month_short_day_of_week_day.awk`
- `src/decomp/sas_c/render_short_month_short_day_of_week_day.c`
- `src/decomp/scripts/compare_sasc_coi_free_entry_resources_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_coi_free_entry_resources.awk`
- `src/decomp/sas_c/coi_free_entry_resources.c`
- `src/decomp/scripts/compare_sasc_coi_ensure_anim_object_allocated_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_coi_ensure_anim_object_allocated.awk`
- `src/decomp/sas_c/coi_ensure_anim_object_allocated.c`
- `src/decomp/scripts/compare_sasc_coi_count_escape14_before_null_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_coi_count_escape14_before_null.awk`
- `src/decomp/sas_c/coi_count_escape14_before_null.c`
- `src/decomp/scripts/compare_sasc_coi_clear_anim_object_strings_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_coi_clear_anim_object_strings.awk`
- `src/decomp/sas_c/coi_clear_anim_object_strings.c`
- `src/decomp/scripts/compare_sasc_coi_free_sub_entry_table_entries_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_coi_free_sub_entry_table_entries.awk`
- `src/decomp/sas_c/coi_free_sub_entry_table_entries.c`
- `src/decomp/scripts/compare_sasc_coi_free_sub_entry_table_entries_return_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_coi_free_sub_entry_table_entries_return.awk`
- `src/decomp/sas_c/coi_free_sub_entry_table_entries_return.c`
- `src/decomp/scripts/compare_sasc_coi_test_entry_within_time_window_return_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_coi_test_entry_within_time_window_return.awk`
- `src/decomp/sas_c/coi_test_entry_within_time_window_return.c`
- `src/decomp/scripts/compare_sasc_coi_test_entry_within_time_window_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_coi_test_entry_within_time_window.awk`
- `src/decomp/sas_c/coi_test_entry_within_time_window.c`
- `src/decomp/scripts/compare_sasc_coi_get_anim_field_pointer_by_mode_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_coi_get_anim_field_pointer_by_mode.awk`
- `src/decomp/sas_c/coi_get_anim_field_pointer_by_mode.c`
- `src/decomp/scripts/compare_sasc_coi_alloc_sub_entry_table_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_coi_alloc_sub_entry_table.awk`
- `src/decomp/sas_c/coi_alloc_sub_entry_table.c`
- `src/decomp/scripts/compare_sasc_ctasks_close_task_teardown_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_ctasks_close_task_teardown.awk`
- `src/decomp/sas_c/ctasks_close_task_teardown.c`
- `src/decomp/scripts/compare_sasc_ctasks_start_close_task_process_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_ctasks_start_close_task_process.awk`
- `src/decomp/sas_c/ctasks_start_close_task_process.c`
- `src/decomp/scripts/compare_sasc_ctasks_start_iff_task_process_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_ctasks_start_iff_task_process.awk`
- `src/decomp/sas_c/ctasks_start_iff_task_process.c`
- `src/decomp/scripts/compare_sasc_ctasks_iff_task_cleanup_trial.sh`
- `src/decomp/scripts/semantic_filter_sasc_ctasks_iff_task_cleanup.awk`
- `src/decomp/sas_c/ctasks_iff_task_cleanup.c`
- For `FreeMem` with SAS/C `#pragma libcall`, use `#pragma libcall AbsExecBase FreeMem d2 902` (emits `A1` + `D0` argument setup before `_LVOFreeMem`).
- Run SAS/C compare scripts serially; parallel invocations can contend on `vamos` temp setup.
