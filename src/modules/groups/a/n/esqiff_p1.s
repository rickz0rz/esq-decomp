    XDEF    ESQIFF_QueueNextExternalAssetIffJob
    XDEF    ESQIFF_ReadNextExternalAssetPathEntry


;------------------------------------------------------------------------------
; FUNC: ESQIFF_QueueNextExternalAssetIffJob   (Queue next external-asset IFF decode job)
; ARGS:
;   stack +36: arg_1 (via 40(A5))
;   stack +37: arg_2 (via 41(A5))
;   stack +76: arg_3 (via 80(A5))
;   stack +116: arg_4 (via 120(A5))
;   stack +124: arg_5 (via 128(A5))
;   stack +126: arg_6 (via 130(A5))
;   stack +130: arg_7 (via 134(A5))
;   stack +134: arg_8 (via 138(A5))
;   stack +138: arg_9 (via 142(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A6/A7/D0/D1/D2/D5/D6/D7
; CALLS:
;   _ESQIFF_JMPTBL_BRUSH_AllocBrushNode, ESQIFF_JMPTBL_CTASKS_StartIffTaskProcess, ESQIFF_JMPTBL_STRING_CompareNoCaseN, ESQIFF_JMPTBL_TEXTDISP_FindEntryIndexByWildcard, GCOMMAND_FindPathSeparator, _ESQDISP_ProcessGridMessagesIfIdle, ESQIFF_ReadNextExternalAssetPathEntry, _LVOForbid, _LVOPermit
; READS:
;   AbsExecBase, _Global_REF_LONG_DF0_LOGO_LST_DATA, _Global_REF_LONG_GFX_G_ADS_DATA, _CTASKS_IffTaskDoneFlag, _ESQIFF_GAdsBrushListHead, _ESQIFF_LogoBrushListHead, ESQIFF_PATH_DF0_COLON, ESQIFF_PATH_RAM_COLON_LOGOS_SLASH, _ESQIFF_LogoListLineIndex, _ESQIFF_AssetSourceSelect, ESQIFF_ExternalAssetPathCommaFlag, _TEXTDISP_CurrentMatchIndex, fa00
; WRITES:
;   _CTASKS_PendingLogoBrushDescriptor, _CTASKS_PendingGAdsBrushDescriptor, _ESQIFF_GAdsBrushListCount, _ESQIFF_LogoBrushListCount, ESQIFF_PendingExternalBrushNode, ESQIFF_ExternalAssetStateTable, _TEXTDISP_CurrentMatchIndex
; DESC:
;   Chooses the next external asset path from active catalog data, filters/skips
;   disallowed entries, allocates a descriptor, and starts IFF decode task when needed.
; NOTES:
;   Uses `_TEXTDISP_CurrentMatchIndex` snapshot/restore while probing wildcard matches.
;------------------------------------------------------------------------------
ESQIFF_QueueNextExternalAssetIffJob:
    LINK.W  A5,#-144
    MOVEM.L D2/D5-D7,-(A7)
    MOVEQ   #0,D0
    MOVE.L  D0,-138(A5)
    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    TST.W   _CTASKS_IffTaskDoneFlag
    BNE.S   .permit_and_return_no_job

    JSR     _LVOPermit(A6)

    MOVEQ   #0,D0
    BRA.W   .return

.permit_and_return_no_job:
    MOVE.W  _ESQIFF_AssetSourceSelect,D0
    BEQ.S   .check_gads_quota

    CMPI.L  #$1,_ESQIFF_LogoBrushListCount
    BLT.S   .check_gads_quota

    JSR     _LVOPermit(A6)

    MOVEQ   #0,D0
    BRA.W   .return

.check_gads_quota:
    MOVE.W  _ESQIFF_AssetSourceSelect,D0
    BNE.S   .begin_path_selection

    CMPI.L  #$2,_ESQIFF_GAdsBrushListCount
    BLT.S   .begin_path_selection

    JSR     _LVOPermit(A6)

    MOVEQ   #0,D0
    BRA.W   .return

.begin_path_selection:
    JSR     _LVOPermit(A6)

    MOVEQ   #0,D0
    MOVE.B  D0,-40(A5)
    MOVE.W  _ESQIFF_LogoListLineIndex,D6
    MOVEQ   #0,D1
    MOVE.W  D1,-128(A5)
    TST.L   _Global_REF_LONG_DF0_LOGO_LST_DATA
    BEQ.S   .check_gads_blob_for_source0

    MOVE.W  _ESQIFF_AssetSourceSelect,D2
    BNE.S   .scan_candidate_paths

.check_gads_blob_for_source0:
    TST.L   _Global_REF_LONG_GFX_G_ADS_DATA
    BEQ.W   .finalize_no_candidate

    MOVE.W  _ESQIFF_AssetSourceSelect,D2
    BNE.W   .finalize_no_candidate

.scan_candidate_paths:
    MOVE.B  D0,-41(A5)
    MOVE.W  _TEXTDISP_CurrentMatchIndex,D5

.loop_read_candidate_path:
    PEA     -40(A5)
    BSR.W   ESQIFF_ReadNextExternalAssetPathEntry

    ADDQ.W  #4,A7
    LEA     -40(A5),A0
    MOVEA.L A0,A1

.loop_measure_candidate_len:
    TST.B   (A1)+
    BNE.S   .loop_measure_candidate_len

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    BEQ.W   .check_scan_progress_or_retry

    MOVE.W  _ESQIFF_AssetSourceSelect,D0
    BEQ.S   .validate_source0_path_prefixes

    TST.W   ESQIFF_ExternalAssetPathCommaFlag
    BEQ.S   .build_wildcard_probe_path

    MOVE.W  #1,-128(A5)
    BRA.W   .finalize_candidate_filter

.build_wildcard_probe_path:
    MOVEQ   #0,D7

.loop_rewrite_bang_to_wildcard:
    MOVEQ   #40,D0
    CMP.W   D0,D7
    BGE.S   .probe_match_index_by_wildcard

    MOVE.B  -40(A5,D7.W),-80(A5,D7.W)
    TST.B   -80(A5,D7.W)
    BEQ.S   .probe_match_index_by_wildcard

    MOVEQ   #33,D0
    CMP.B   -80(A5,D7.W),D0
    BNE.S   .advance_probe_char

    MOVE.B  #$2a,-80(A5,D7.W)
    MOVE.L  D7,D0
    EXT.L   D0
    CLR.B   -79(A5,D0.L)
    BRA.S   .probe_match_index_by_wildcard

.advance_probe_char:
    ADDQ.W  #1,D7
    BRA.S   .loop_rewrite_bang_to_wildcard

.probe_match_index_by_wildcard:
    PEA     -80(A5)
    JSR     GCOMMAND_FindPathSeparator(PC)

    MOVE.L  D0,(A7)
    JSR     ESQIFF_JMPTBL_TEXTDISP_FindEntryIndexByWildcard(PC)

    ADDQ.W  #4,A7
    SUBQ.W  #1,D0
    BNE.S   .yield_grid_while_scanning

    MOVE.W  #1,-128(A5)
    MOVE.W  _TEXTDISP_CurrentMatchIndex,ESQIFF_ExternalAssetStateTable
    BRA.S   .finalize_candidate_filter

.validate_source0_path_prefixes:
    MOVEQ   #4,D0
    MOVE.L  D0,-(A7)
    PEA     -40(A5)
    PEA     ESQIFF_PATH_DF0_COLON
    JSR     ESQIFF_JMPTBL_STRING_CompareNoCaseN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BEQ.S   .finalize_candidate_filter

    MOVEQ   #11,D0
    MOVE.L  D0,-(A7)
    PEA     -40(A5)
    PEA     ESQIFF_PATH_RAM_COLON_LOGOS_SLASH
    JSR     ESQIFF_JMPTBL_STRING_CompareNoCaseN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BEQ.S   .finalize_candidate_filter

    MOVE.W  #1,-128(A5)
    BRA.S   .finalize_candidate_filter

.yield_grid_while_scanning:
    JSR     _ESQDISP_ProcessGridMessagesIfIdle(PC)

.check_scan_progress_or_retry:
    MOVE.W  _ESQIFF_LogoListLineIndex,D0
    CMP.W   D0,D6
    BNE.W   .loop_read_candidate_path

.finalize_candidate_filter:
    MOVE.W  D5,_TEXTDISP_CurrentMatchIndex
    TST.W   -128(A5)
    BEQ.W   .finalize_no_candidate

    MOVE.W  _ESQIFF_AssetSourceSelect,D0
    BEQ.S   .set_logo_poll_limit

    MOVE.L  #$fa00,-134(A5)
    BRA.S   .snapshot_candidate_path

.set_logo_poll_limit:
    MOVE.L  #$13880,-134(A5)

.snapshot_candidate_path:
    LEA     -40(A5),A0
    LEA     -120(A5),A1

.loop_copy_candidate_snapshot:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .loop_copy_candidate_snapshot

.loop_queue_until_path_changes:
    MOVE.W  #1,-130(A5)
    JSR     _ESQDISP_ProcessGridMessagesIfIdle(PC)

    MOVE.W  _ESQIFF_AssetSourceSelect,D0
    BEQ.S   .select_gads_list_head

    MOVEA.L _ESQIFF_LogoBrushListHead,A0
    MOVE.L  A0,-142(A5)
    BRA.S   .test_duplicate_head_path

.select_gads_list_head:
    MOVEA.L _ESQIFF_GAdsBrushListHead,A0
    MOVE.L  A0,-142(A5)

.test_duplicate_head_path:
    MOVE.L  A0,D0
    BEQ.S   .allocate_descriptor_if_needed

    CMPA.L  _ESQIFF_LogoBrushListHead,A0
    BNE.S   .allocate_descriptor_if_needed

    LEA     -40(A5),A0
    MOVEA.L -142(A5),A1

.loop_compare_candidate_with_head:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.S   .allocate_descriptor_if_needed

    TST.B   D0
    BNE.S   .loop_compare_candidate_with_head

    BNE.S   .allocate_descriptor_if_needed

    MOVEQ   #1,D0
    MOVE.L  D0,-138(A5)

.allocate_descriptor_if_needed:
    TST.L   -138(A5)
    BNE.S   .poll_until_path_change_or_timeout

    CLR.L   -(A7)
    PEA     -40(A5)
    JSR     _ESQIFF_JMPTBL_BRUSH_AllocBrushNode(PC)

    ADDQ.W  #8,A7
    MOVE.W  _ESQIFF_AssetSourceSelect,D1
    MOVE.L  D0,ESQIFF_PendingExternalBrushNode
    TST.W   D1
    BEQ.S   .init_gads_pending_descriptor

    MOVEA.L D0,A0
    MOVE.B  #$4,190(A0)
    MOVE.L  D0,_CTASKS_PendingLogoBrushDescriptor
    BRA.S   .start_iff_task_for_pending_descriptor

.init_gads_pending_descriptor:
    MOVEA.L D0,A0
    MOVE.B  #$5,190(A0)
    MOVE.L  D0,_CTASKS_PendingGAdsBrushDescriptor

.start_iff_task_for_pending_descriptor:
    JSR     ESQIFF_JMPTBL_CTASKS_StartIffTaskProcess(PC)

.poll_until_path_change_or_timeout:
    JSR     _ESQDISP_ProcessGridMessagesIfIdle(PC)

    MOVEQ   #-1,D0
    CMP.W   -130(A5),D0
    BNE.S   .compare_snapshot_with_current_path

    PEA     -40(A5)
    BSR.W   ESQIFF_ReadNextExternalAssetPathEntry

    ADDQ.W  #4,A7

.compare_snapshot_with_current_path:
    LEA     -120(A5),A0
    LEA     -40(A5),A1

.loop_compare_paths:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.S   .retry_queue_loop_if_timeout

    TST.B   D0
    BNE.S   .loop_compare_paths

    BEQ.S   .finalize_no_candidate

.retry_queue_loop_if_timeout:
    MOVEQ   #-1,D0
    CMP.W   -130(A5),D0
    BEQ.W   .loop_queue_until_path_changes

.finalize_no_candidate:
    TST.W   -128(A5)
    BNE.S   .return_current_timeout_state

    MOVEQ   #-1,D0
    MOVE.W  D0,-130(A5)

.return_current_timeout_state:
    MOVE.W  -130(A5),D0

.return:
    MOVEM.L (A7)+,D2/D5-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_ReadNextExternalAssetPathEntry   (Read next newline-delimited external asset path entry)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +10: arg_2 (via 14(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A3/A5/A7/D0/D4/D5/D6/D7
; CALLS:
;   _ESQDISP_ProcessGridMessagesIfIdle
; READS:
;   _Global_REF_LONG_DF0_LOGO_LST_DATA, _Global_REF_LONG_DF0_LOGO_LST_FILESIZE, _Global_REF_LONG_GFX_G_ADS_DATA, _Global_REF_LONG_GFX_G_ADS_FILESIZE, _ESQIFF_LogoListLineIndex, _ESQIFF_GAdsListLineIndex, _ESQIFF_AssetSourceSelect, ESQIFF_GAdsSourceEnabled
; WRITES:
;   _ESQIFF_LogoListLineIndex, _ESQIFF_GAdsListLineIndex, ESQIFF_ExternalAssetPathCommaFlag
; DESC:
;   Selects active catalog stream, advances to current line index, then copies one
;   path entry into output buffer stopping on CR/LF/space or comma delimiters.
; NOTES:
;   Comma delimiter sets ESQIFF_ExternalAssetPathCommaFlag and returns empty string.
;------------------------------------------------------------------------------
ESQIFF_ReadNextExternalAssetPathEntry:
    LINK.W  A5,#-16
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    JSR     _ESQDISP_ProcessGridMessagesIfIdle(PC)

    MOVE.W  _ESQIFF_AssetSourceSelect,D0
    BEQ.S   .select_gads_catalog

    MOVE.L  _Global_REF_LONG_DF0_LOGO_LST_FILESIZE,D4
    MOVE.L  _Global_REF_LONG_DF0_LOGO_LST_DATA,-14(A5)
    MOVE.W  _ESQIFF_LogoListLineIndex,D6
    MOVEQ   #0,D0
    MOVE.W  D0,ESQIFF_ExternalAssetPathCommaFlag
    BRA.S   .begin_line_seek

.select_gads_catalog:
    MOVE.W  ESQIFF_GAdsSourceEnabled,D0
    BEQ.S   .return_no_catalog_enabled

    MOVE.L  _Global_REF_LONG_GFX_G_ADS_FILESIZE,D4
    MOVE.L  _Global_REF_LONG_GFX_G_ADS_DATA,-14(A5)
    MOVE.W  _ESQIFF_GAdsListLineIndex,D6
    BRA.S   .begin_line_seek

.return_no_catalog_enabled:
    MOVEQ   #0,D0
    BRA.W   .return

.begin_line_seek:
    MOVEQ   #0,D7

.loop_seek_to_target_line:
    CMP.W   D6,D7
    BGE.S   .begin_entry_copy

    TST.L   D4
    BLE.S   .begin_entry_copy

    MOVEA.L -14(A5),A0
    MOVE.B  (A0)+,D5
    MOVE.L  A0,-14(A5)
    MOVEQ   #10,D0
    CMP.B   D0,D5
    BNE.S   .consume_seek_char

    ADDQ.W  #1,D7

.consume_seek_char:
    SUBQ.L  #1,D4
    BRA.S   .loop_seek_to_target_line

.begin_entry_copy:
    TST.L   D4
    BNE.S   .advance_line_index_counter

    MOVE.W  _ESQIFF_AssetSourceSelect,D0
    BEQ.S   .reload_gads_catalog_start

    MOVE.L  _Global_REF_LONG_DF0_LOGO_LST_FILESIZE,D4
    MOVE.L  _Global_REF_LONG_DF0_LOGO_LST_DATA,-14(A5)
    BRA.S   .reset_line_index_to_one

.reload_gads_catalog_start:
    MOVE.L  _Global_REF_LONG_GFX_G_ADS_FILESIZE,D4
    MOVE.L  _Global_REF_LONG_GFX_G_ADS_DATA,-14(A5)

.reset_line_index_to_one:
    MOVEQ   #1,D6
    BRA.S   .store_updated_line_index

.advance_line_index_counter:
    ADDQ.W  #1,D6

.store_updated_line_index:
    MOVE.W  _ESQIFF_AssetSourceSelect,D0
    BEQ.S   .store_gads_line_index

    MOVE.W  D6,_ESQIFF_LogoListLineIndex
    BRA.S   .loop_copy_entry_chars

.store_gads_line_index:
    MOVE.W  D6,_ESQIFF_GAdsListLineIndex

.loop_copy_entry_chars:
    MOVEA.L -14(A5),A0
    MOVE.B  (A0)+,D5
    MOVE.L  A0,-14(A5)
    MOVEQ   #10,D0
    CMP.B   D0,D5
    BEQ.S   .terminate_and_return_entry

    MOVEQ   #13,D0
    CMP.B   D0,D5
    BEQ.S   .terminate_and_return_entry

    MOVEQ   #32,D0
    CMP.B   D0,D5
    BEQ.S   .terminate_and_return_entry

    MOVE.L  D4,D0
    SUBQ.L  #1,D4
    TST.L   D0
    BLE.S   .terminate_and_return_entry

    MOVEQ   #44,D0
    CMP.B   D0,D5
    BNE.S   .append_entry_char

    CLR.B   (A3)
    MOVE.W  #1,ESQIFF_ExternalAssetPathCommaFlag
    BRA.S   .terminate_and_return_entry

.append_entry_char:
    MOVE.B  D5,(A3)+
    BRA.S   .loop_copy_entry_chars

.terminate_and_return_entry:
    CLR.B   (A3)
    MOVEQ   #1,D0

.return:
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======
