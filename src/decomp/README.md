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

## Toolchain Notes
- GCC lanes default to `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc` but honor `CROSS_CC` overrides.
- GCC compare scripts support per-run `GCC_CFLAGS=...` tuning.
- vbcc compare scripts are retained for historical/reference work (`compare_memory_*_trial.sh`, `compare_clock_convert_trial.sh`).
- Current target-by-target status and preferred profiles are tracked in `src/decomp/TARGETS.md`.
