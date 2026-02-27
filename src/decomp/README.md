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
- `src/decomp/scripts/compare_unknown_parse_list_and_update_entries_trial_gcc.sh`: GCC-specific compare lane for `Target 084` (`UNKNOWN_ParseListAndUpdateEntries`).
- `src/decomp/scripts/compare_esq_parse_command_line_and_run_trial_gcc.sh`: GCC-specific compare lane for `Target 085` (`ESQ_ParseCommandLineAndRun`).
- `src/decomp/scripts/compare_stream_buffered_write_string_trial_gcc.sh`: GCC-specific compare lane for `Target 086` (`STREAM_BufferedWriteString`).
- `src/decomp/scripts/compare_unknown29_jmptbl_esq_main_init_and_run_trial_gcc.sh`: GCC-specific compare lane for `Target 087` (`UNKNOWN29_JMPTBL_ESQ_MainInitAndRun`).
- `src/decomp/scripts/compare_group_ag_jmptbl_memory_deallocate_memory_trial_gcc.sh`: GCC-specific compare lane for `Target 096` (`GROUP_AG_JMPTBL_MEMORY_DeallocateMemory`).
- `src/decomp/scripts/compare_group_ag_jmptbl_memory_allocate_memory_trial_gcc.sh`: GCC-specific compare lane for `Target 097` (`GROUP_AG_JMPTBL_MEMORY_AllocateMemory`).
- `src/decomp/scripts/compare_group_ag_jmptbl_struct_alloc_with_owner_trial_gcc.sh`: GCC-specific compare lane for `Target 098` (`GROUP_AG_JMPTBL_STRUCT_AllocWithOwner`).
- `src/decomp/scripts/compare_group_ag_jmptbl_struct_free_with_size_field_trial_gcc.sh`: GCC-specific compare lane for `Target 099` (`GROUP_AG_JMPTBL_STRUCT_FreeWithSizeField`).
- `src/decomp/scripts/compare_group_ag_jmptbl_math_divs32_trial_gcc.sh`: GCC-specific compare lane for `Target 100` (`GROUP_AG_JMPTBL_MATH_DivS32`).
- `src/decomp/scripts/compare_group_ag_jmptbl_math_mulu32_trial_gcc.sh`: GCC-specific compare lane for `Target 101` (`GROUP_AG_JMPTBL_MATH_Mulu32`).
- `src/decomp/scripts/compare_group_ag_jmptbl_dos_open_file_with_mode_trial_gcc.sh`: GCC-specific compare lane for `Target 102` (`GROUP_AG_JMPTBL_DOS_OpenFileWithMode`).
- `src/decomp/scripts/compare_group_ag_jmptbl_string_copy_pad_nul_trial_gcc.sh`: GCC-specific compare lane for `Target 103` (`GROUP_AG_JMPTBL_STRING_CopyPadNul`).
- `src/decomp/scripts/compare_group_ag_jmptbl_parse_read_signed_long_skip_class3_alt_trial_gcc.sh`: GCC-specific compare lane for `Target 107` (`GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt`).
- `src/decomp/scripts/compare_group_am_jmptbl_signal_create_msgport_with_signal_trial_gcc.sh`: GCC-specific compare lane for `Target 104` (`GROUP_AM_JMPTBL_SIGNAL_CreateMsgPortWithSignal`).
- `src/decomp/scripts/compare_group_am_jmptbl_struct_alloc_with_owner_trial_gcc.sh`: GCC-specific compare lane for `Target 105` (`GROUP_AM_JMPTBL_STRUCT_AllocWithOwner`).
- `src/decomp/scripts/compare_group_am_jmptbl_list_init_header_trial_gcc.sh`: GCC-specific compare lane for `Target 106` (`GROUP_AM_JMPTBL_LIST_InitHeader`).
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
- `src/decomp/scripts/compare_group_ad_jmptbl_textdisp_draw_channel_banner_trial_gcc.sh`: GCC-specific compare lane for `Target 146` (`GROUP_AD_JMPTBL_TEXTDISP_DrawChannelBanner`).
- `src/decomp/scripts/compare_group_ad_jmptbl_textdisp_format_entry_time_trial_gcc.sh`: GCC-specific compare lane for `Target 147` (`GROUP_AD_JMPTBL_TEXTDISP_FormatEntryTime`).
- `src/decomp/scripts/compare_group_ad_jmptbl_tliba3_get_view_mode_height_trial_gcc.sh`: GCC-specific compare lane for `Target 148` (`GROUP_AD_JMPTBL_TLIBA3_GetViewModeHeight`).
- `src/decomp/scripts/compare_group_ad_jmptbl_tliba3_get_view_mode_rast_port_trial_gcc.sh`: GCC-specific compare lane for `Target 149` (`GROUP_AD_JMPTBL_TLIBA3_GetViewModeRastPort`).
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
- `src/decomp/scripts/semantic_filter_unknown_parse_list_and_update_entries.awk`: semantic post-filter for `UNKNOWN_ParseListAndUpdateEntries` compare lane.
- `src/decomp/scripts/semantic_filter_esq_parse_command_line_and_run.awk`: semantic post-filter for `ESQ_ParseCommandLineAndRun` compare lane.
- `src/decomp/scripts/semantic_filter_stream_buffered_write_string.awk`: semantic post-filter for `STREAM_BufferedWriteString` compare lane.
- `src/decomp/scripts/semantic_filter_unknown29_jmptbl_esq_main_init_and_run.awk`: semantic post-filter for `UNKNOWN29_JMPTBL_ESQ_MainInitAndRun` compare lane.
- `src/decomp/scripts/semantic_filter_group_ag_jmptbl_memory_deallocate_memory.awk`: semantic post-filter for `GROUP_AG_JMPTBL_MEMORY_DeallocateMemory` compare lane.
- `src/decomp/scripts/semantic_filter_group_ag_jmptbl_memory_allocate_memory.awk`: semantic post-filter for `GROUP_AG_JMPTBL_MEMORY_AllocateMemory` compare lane.
- `src/decomp/scripts/semantic_filter_group_ag_jmptbl_struct_alloc_with_owner.awk`: semantic post-filter for `GROUP_AG_JMPTBL_STRUCT_AllocWithOwner` compare lane.
- `src/decomp/scripts/semantic_filter_group_ag_jmptbl_struct_free_with_size_field.awk`: semantic post-filter for `GROUP_AG_JMPTBL_STRUCT_FreeWithSizeField` compare lane.
- `src/decomp/scripts/semantic_filter_group_ag_jmptbl_math_divs32.awk`: semantic post-filter for `GROUP_AG_JMPTBL_MATH_DivS32` compare lane.
- `src/decomp/scripts/semantic_filter_group_ag_jmptbl_math_mulu32.awk`: semantic post-filter for `GROUP_AG_JMPTBL_MATH_Mulu32` compare lane.
- `src/decomp/scripts/semantic_filter_group_ag_jmptbl_dos_open_file_with_mode.awk`: semantic post-filter for `GROUP_AG_JMPTBL_DOS_OpenFileWithMode` compare lane.
- `src/decomp/scripts/semantic_filter_group_ag_jmptbl_string_copy_pad_nul.awk`: semantic post-filter for `GROUP_AG_JMPTBL_STRING_CopyPadNul` compare lane.
- `src/decomp/scripts/semantic_filter_group_ag_jmptbl_parse_read_signed_long_skip_class3_alt.awk`: semantic post-filter for `GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt` compare lane.
- `src/decomp/scripts/semantic_filter_group_am_jmptbl_signal_create_msgport_with_signal.awk`: semantic post-filter for `GROUP_AM_JMPTBL_SIGNAL_CreateMsgPortWithSignal` compare lane.
- `src/decomp/scripts/semantic_filter_group_am_jmptbl_struct_alloc_with_owner.awk`: semantic post-filter for `GROUP_AM_JMPTBL_STRUCT_AllocWithOwner` compare lane.
- `src/decomp/scripts/semantic_filter_group_am_jmptbl_list_init_header.awk`: semantic post-filter for `GROUP_AM_JMPTBL_LIST_InitHeader` compare lane.
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
- `src/decomp/scripts/semantic_filter_group_ad_jmptbl_textdisp_draw_channel_banner.awk`: semantic post-filter for `GROUP_AD_JMPTBL_TEXTDISP_DrawChannelBanner` compare lane.
- `src/decomp/scripts/semantic_filter_group_ad_jmptbl_textdisp_format_entry_time.awk`: semantic post-filter for `GROUP_AD_JMPTBL_TEXTDISP_FormatEntryTime` compare lane.
- `src/decomp/scripts/semantic_filter_group_ad_jmptbl_tliba3_get_view_mode_height.awk`: semantic post-filter for `GROUP_AD_JMPTBL_TLIBA3_GetViewModeHeight` compare lane.
- `src/decomp/scripts/semantic_filter_group_ad_jmptbl_tliba3_get_view_mode_rast_port.awk`: semantic post-filter for `GROUP_AD_JMPTBL_TLIBA3_GetViewModeRastPort` compare lane.
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
- `src/decomp/scripts/promote_unknown_parse_list_and_update_entries_target_gcc.sh`: promotion gate for Target 084 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_esq_parse_command_line_and_run_target_gcc.sh`: promotion gate for Target 085 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_stream_buffered_write_string_target_gcc.sh`: promotion gate for Target 086 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_unknown29_jmptbl_esq_main_init_and_run_target_gcc.sh`: promotion gate for Target 087 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ag_jmptbl_memory_deallocate_memory_target_gcc.sh`: promotion gate for Target 096 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ag_jmptbl_memory_allocate_memory_target_gcc.sh`: promotion gate for Target 097 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ag_jmptbl_struct_alloc_with_owner_target_gcc.sh`: promotion gate for Target 098 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ag_jmptbl_struct_free_with_size_field_target_gcc.sh`: promotion gate for Target 099 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ag_jmptbl_math_divs32_target_gcc.sh`: promotion gate for Target 100 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ag_jmptbl_math_mulu32_target_gcc.sh`: promotion gate for Target 101 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ag_jmptbl_dos_open_file_with_mode_target_gcc.sh`: promotion gate for Target 102 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ag_jmptbl_string_copy_pad_nul_target_gcc.sh`: promotion gate for Target 103 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ag_jmptbl_parse_read_signed_long_skip_class3_alt_target_gcc.sh`: promotion gate for Target 107 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_am_jmptbl_signal_create_msgport_with_signal_target_gcc.sh`: promotion gate for Target 104 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_am_jmptbl_struct_alloc_with_owner_target_gcc.sh`: promotion gate for Target 105 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_am_jmptbl_list_init_header_target_gcc.sh`: promotion gate for Target 106 GCC lane (semantic + build/hash gates).
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
- `src/decomp/scripts/promote_group_ad_jmptbl_textdisp_draw_channel_banner_target_gcc.sh`: promotion gate for Target 146 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ad_jmptbl_textdisp_format_entry_time_target_gcc.sh`: promotion gate for Target 147 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ad_jmptbl_tliba3_get_view_mode_height_target_gcc.sh`: promotion gate for Target 148 GCC lane (semantic + build/hash gates).
- `src/decomp/scripts/promote_group_ad_jmptbl_tliba3_get_view_mode_rast_port_target_gcc.sh`: promotion gate for Target 149 GCC lane (semantic + build/hash gates).
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
bash src/decomp/scripts/promote_esq_main_exit_noop_hook_target_gcc.sh
bash src/decomp/scripts/promote_dos_open_file_with_mode_target_gcc.sh
bash src/decomp/scripts/promote_graphics_alloc_raster_target_gcc.sh
bash src/decomp/scripts/promote_graphics_free_raster_target_gcc.sh
bash src/decomp/scripts/promote_dos_movep_word_read_callback_target_gcc.sh
bash src/decomp/scripts/promote_unknown_parse_list_and_update_entries_target_gcc.sh
bash src/decomp/scripts/promote_esq_parse_command_line_and_run_target_gcc.sh
bash src/decomp/scripts/promote_stream_buffered_write_string_target_gcc.sh
bash src/decomp/scripts/promote_unknown29_jmptbl_esq_main_init_and_run_target_gcc.sh
bash src/decomp/scripts/promote_group_ag_jmptbl_memory_deallocate_memory_target_gcc.sh
bash src/decomp/scripts/promote_group_ag_jmptbl_memory_allocate_memory_target_gcc.sh
bash src/decomp/scripts/promote_group_ag_jmptbl_struct_alloc_with_owner_target_gcc.sh
bash src/decomp/scripts/promote_group_ag_jmptbl_struct_free_with_size_field_target_gcc.sh
bash src/decomp/scripts/promote_group_ag_jmptbl_math_divs32_target_gcc.sh
bash src/decomp/scripts/promote_group_ag_jmptbl_math_mulu32_target_gcc.sh
bash src/decomp/scripts/promote_group_ag_jmptbl_dos_open_file_with_mode_target_gcc.sh
bash src/decomp/scripts/promote_group_ag_jmptbl_string_copy_pad_nul_target_gcc.sh
bash src/decomp/scripts/promote_group_ag_jmptbl_parse_read_signed_long_skip_class3_alt_target_gcc.sh
bash src/decomp/scripts/promote_group_am_jmptbl_signal_create_msgport_with_signal_target_gcc.sh
bash src/decomp/scripts/promote_group_am_jmptbl_struct_alloc_with_owner_target_gcc.sh
bash src/decomp/scripts/promote_group_am_jmptbl_list_init_header_target_gcc.sh
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
bash src/decomp/scripts/promote_group_ad_jmptbl_textdisp_draw_channel_banner_target_gcc.sh
bash src/decomp/scripts/promote_group_ad_jmptbl_textdisp_format_entry_time_target_gcc.sh
bash src/decomp/scripts/promote_group_ad_jmptbl_tliba3_get_view_mode_height_target_gcc.sh
bash src/decomp/scripts/promote_group_ad_jmptbl_tliba3_get_view_mode_rast_port_target_gcc.sh
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
- Targets 148/149/150/151/152/153/154/155/156/157/158/159/160/161/162/163/164/165/166/167/168/169/170/171/172/173/174/175/176/177/178/179/180/181/182/183/184/185/186/187/188/189/190/191/192/193/194/195/196/197/198/199/200/201/202/203/204/205/206/207/208/209/210/211/212/213/214/215/216/217: `-O1 -m68000 -ffreestanding -fno-builtin -fno-inline -fomit-frame-pointer`

## Toolchain Notes
- GCC lanes default to `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc` but honor `CROSS_CC` overrides.
- GCC compare scripts support per-run `GCC_CFLAGS=...` tuning.
- vbcc compare scripts are retained for historical/reference work (`compare_memory_*_trial.sh`, `compare_clock_convert_trial.sh`).
- Current target-by-target status and preferred profiles are tracked in `src/decomp/TARGETS.md`.
