    XDEF    SCRIPT_HandleBrushCommand
    XDEF    SCRIPT_HandleSerialCtrlCmd
    XDEF    SCRIPT_ProcessCtrlContextPlaybackTick
    XDEF    SCRIPT_SelectPlaybackCursorFromSearchText

;------------------------------------------------------------------------------
; FUNC: SCRIPT_HandleSerialCtrlCmd   (HandleSerialCtrlCmd)
; ARGS:
;   (none)
; RET:
;   D0: none (status handled via globals)
; CLOBBERS:
;   D0-D7/A0-A1
; CALLS:
;   SCRIPT_ESQ_CaptureCtrlBit4StreamBufferByte, PARSEINI_CheckCtrlHChange, SCRIPT_HandleBrushCommand, SCRIPT_ApplyPendingBannerTarget,
;   WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight, TEXTDISP_SetRastForMode, SCRIPT_ProcessCtrlContextPlaybackTick, _SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh, _TEXTDISP_ResetSelectionAndRefresh
; READS:
;   Global_WORD_SELECT_CODE_IS_RAVESC, CONFIG_MSN_FlagChar, SCRIPT_StatusRefreshHoldFlag, ESQDISP_DisplayActiveFlag, SCRIPT_StatusMaskRefreshPending
;   _Global_REF_CLOCKDATA_STRUCT, Global_WORD_CLOCK_SECONDS
;   SCRIPT_CTRL_READ_INDEX, SCRIPT_CTRL_CHECKSUM, SCRIPT_CTRL_STATE,
;   _SCRIPT_RuntimeMode/2347/2348/2349/234A, SCRIPT_CTRL_CMD_BUFFER
; WRITES:
;   _Global_RefreshTickCounter, SCRIPT_StatusMaskRefreshPending, Global_WORD_CLOCK_SECONDS,
;   SCRIPT_CTRL_READ_INDEX, SCRIPT_CTRL_CHECKSUM, SCRIPT_CTRL_STATE,
;   SCRIPT_CTRL_CMD_BUFFER, _SCRIPT_CtrlCmdCount/2348/2349
; DESC:
;   Polls the CTRL input buffer and advances a small state machine to parse
;   serial control commands; dispatches actions via a jump table.
; NOTES:
;   The jump table is a compiler switch/jumptable on the input byte (0..21).
;   SCRIPT_CTRL_STATE acts as a parser state: 0=idle, 1/2/3=substates uncertain.
;------------------------------------------------------------------------------
SCRIPT_HandleSerialCtrlCmd:
    MOVEM.L D6-D7,-(A7)

    TST.W   Global_WORD_SELECT_CODE_IS_RAVESC
    BNE.S   .selectCodeIsNotRAVSEC

    MOVE.B  CONFIG_MSN_FlagChar,D0
    MOVEQ   #'M',D1
    CMP.B   D1,D0
    BNE.S   .ctrl_cmd_gate_refresh_disabled

.selectCodeIsNotRAVSEC:
    MOVE.W  #(-1),_Global_RefreshTickCounter
    BRA.S   .ctrl_cmd_handle_status_timeout

.ctrl_cmd_gate_refresh_disabled:
    TST.W   SCRIPT_StatusRefreshHoldFlag
    BEQ.S   .ctrl_cmd_check_display_state

    MOVEQ   #0,D0
    MOVE.W  D0,_Global_RefreshTickCounter
    BRA.W   .return

.ctrl_cmd_check_display_state:
    MOVEQ   #1,D0
    CMP.L   ESQDISP_DisplayActiveFlag,D0
    BEQ.W   .return

.ctrl_cmd_handle_status_timeout:
    TST.W   SCRIPT_StatusMaskRefreshPending
    BEQ.S   .ctrl_cmd_poll_input

    MOVE.W  _Global_REF_CLOCKDATA_STRUCT,D0
    MOVE.W  Global_WORD_CLOCK_SECONDS,D1
    CMP.W   D1,D0
    BEQ.S   .ctrl_cmd_poll_input

    ADDQ.W  #1,Global_WORD_CLOCK_SECONDS
    CMPI.W  #3,Global_WORD_CLOCK_SECONDS
    BLT.S   .ctrl_cmd_poll_input

    CLR.W   SCRIPT_StatusMaskRefreshPending
    CLR.L   -(A7)
    PEA     32.W
    JSR     _SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(PC)

    ADDQ.W  #8,A7

.ctrl_cmd_poll_input:
    JSR     PARSEINI_CheckCtrlHChange(PC)

    MOVE.L  D0,D6
    TST.W   _Global_UIBusyFlag
    BNE.W   .return

    TST.W   D6
    BEQ.W   .return

    MOVE.W  _Global_RefreshTickCounter,D0
    ADDQ.W  #1,D0
    BEQ.S   .ctrl_cmd_parse_state_dispatch

    CLR.W   _Global_RefreshTickCounter

.ctrl_cmd_parse_state_dispatch:
    JSR     SCRIPT_ESQ_CaptureCtrlBit4StreamBufferByte(PC)

    MOVE.L  D0,D7
    MOVE.W  SCRIPT_CTRL_STATE,D0
    TST.W   D0
    BEQ.S   .ctrl_cmd_state_idle

    SUBQ.W  #1,D0
    BEQ.W   .ctrl_cmd_state_collect_body

    SUBQ.W  #1,D0
    BEQ.W   .ctrl_cmd_state_expect_checksum

    SUBQ.W  #1,D0
    BEQ.W   .ctrl_cmd_state3_clear

    BRA.W   .ctrl_cmd_state_invalid_reset

.ctrl_cmd_state_idle:
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    SUBQ.W  #1,D0
    BLT.W   .finish_29ABA

    CMPI.W  #22,D0
    BGE.W   .finish_29ABA

    ADD.W   D0,D0
    MOVE.W  .ctrl_cmd_jmptbl(PC,D0.W),D0
    JMP     .ctrl_cmd_jmptbl+2(PC,D0.W)

; switch/jumptable
.ctrl_cmd_jmptbl:
    DC.W    .ctrl_cmd_case_start_packet-.ctrl_cmd_jmptbl-2
    DC.W    .ctrl_cmd_case_gated_by_select_code-.ctrl_cmd_jmptbl-2
    DC.W    .ctrl_cmd_case_gated_by_select_code-.ctrl_cmd_jmptbl-2
    DC.W    .ctrl_cmd_case_gated_by_select_code-.ctrl_cmd_jmptbl-2
    DC.W    .ctrl_cmd_case_gated_by_select_code-.ctrl_cmd_jmptbl-2
    DC.W    .ctrl_cmd_finish_dispatch-.ctrl_cmd_jmptbl-2
    DC.W    .ctrl_cmd_case_gated_by_select_code-.ctrl_cmd_jmptbl-2
    DC.W    .ctrl_cmd_finish_dispatch-.ctrl_cmd_jmptbl-2
    DC.W    .ctrl_cmd_finish_dispatch-.ctrl_cmd_jmptbl-2
    DC.W    .ctrl_cmd_finish_dispatch-.ctrl_cmd_jmptbl-2
    DC.W    .ctrl_cmd_case_gated_by_select_code-.ctrl_cmd_jmptbl-2
    DC.W    .ctrl_cmd_case_start_packet-.ctrl_cmd_jmptbl-2
    DC.W    .ctrl_cmd_case_enter_state3-.ctrl_cmd_jmptbl-2
    DC.W    .ctrl_cmd_finish_dispatch-.ctrl_cmd_jmptbl-2
    DC.W    .ctrl_cmd_case_start_packet-.ctrl_cmd_jmptbl-2
    DC.W    .ctrl_cmd_case_gated_by_select_code-.ctrl_cmd_jmptbl-2
    DC.W    .ctrl_cmd_case_gated_by_select_code-.ctrl_cmd_jmptbl-2
    DC.W    .ctrl_cmd_finish_dispatch-.ctrl_cmd_jmptbl-2
    DC.W    .ctrl_cmd_finish_dispatch-.ctrl_cmd_jmptbl-2
    DC.W    .ctrl_cmd_case_gated_by_select_code-.ctrl_cmd_jmptbl-2
    DC.W    .ctrl_cmd_finish_dispatch-.ctrl_cmd_jmptbl-2
    DC.W    .ctrl_cmd_case_gated_by_select_code-.ctrl_cmd_jmptbl-2

.ctrl_cmd_case_enter_state3:
    MOVE.W  #3,SCRIPT_CTRL_STATE
    BRA.W   .finish_29ABA    

.ctrl_cmd_case_gated_by_select_code:
    TST.W   Global_WORD_SELECT_CODE_IS_RAVESC
    BNE.W   .return

.ctrl_cmd_case_start_packet:
    MOVEQ   #1,D0
    LEA     SCRIPT_CTRL_CMD_BUFFER,A0
    ADDA.W  SCRIPT_CTRL_READ_INDEX,A0
    MOVE.B  D7,(A0)
    MOVEQ   #0,D1
    MOVE.B  D7,D1
    MOVE.W  D1,SCRIPT_CTRL_CHECKSUM
    MOVE.W  _SCRIPT_CtrlCmdCount,D1
    ADDQ.W  #1,D1
    MOVE.W  D1,_SCRIPT_CtrlCmdCount
    MOVE.W  D0,SCRIPT_CTRL_STATE
    BRA.W   .finish_29ABA

.ctrl_cmd_state_collect_body:
    MOVE.W  SCRIPT_CTRL_READ_INDEX,D0
    MOVE.L  D0,D1
    ADDQ.W  #1,D1
    MOVE.W  D1,SCRIPT_CTRL_READ_INDEX
    LEA     SCRIPT_CTRL_CMD_BUFFER,A0
    ADDA.W  D1,A0
    MOVE.L  D7,D0
    MOVE.B  D0,(A0)
    MOVEQ   #13,D1
    CMP.B   D1,D0
    BNE.S   .ctrl_cmd_state_collect_update_checksum

    MOVE.W  #2,SCRIPT_CTRL_STATE

.ctrl_cmd_state_collect_update_checksum:
    MOVE.W  SCRIPT_CTRL_CHECKSUM,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  D7,D1
    EOR.L   D1,D0
    MOVE.W  D0,SCRIPT_CTRL_CHECKSUM
    BRA.W   .finish_29ABA

.ctrl_cmd_state_expect_checksum:
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.W  SCRIPT_CTRL_CHECKSUM,D1
    EXT.L   D1
    CMP.L   D1,D0
    BNE.S   .ctrl_cmd_checksum_mismatch

    TST.W   Global_WORD_SELECT_CODE_IS_RAVESC
    BEQ.S   .ctrl_cmd_checksum_ok_normal_mode

    MOVE.W  SCRIPT_CTRL_READ_INDEX,D0
    EXT.L   D0
    ; Pass packet length into SCRIPT_HandleBrushCommand; command bytes live in
    ; SCRIPT_CTRL_CMD_BUFFER (200-byte storage in data/wdisp.s).
    MOVE.L  D0,-(A7)
    PEA     SCRIPT_CTRL_CMD_BUFFER
    PEA     _SCRIPT_CTRL_CONTEXT
    BSR.W   SCRIPT_HandleBrushCommand

    BSR.W   SCRIPT_ApplyPendingBannerTarget

    JSR     WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(PC)

    CLR.L   (A7)
    JSR     TEXTDISP_SetRastForMode(PC)

    LEA     12(A7),A7
    BRA.S   .ctrl_cmd_reset_parser

.ctrl_cmd_checksum_ok_normal_mode:
    MOVE.W  TEXTDISP_DeferredActionCountdown,D0
    BEQ.S   .ctrl_cmd_dispatch_brush_now

    SUBQ.W  #1,D0
    BNE.S   .ctrl_cmd_defer_dispatch

.ctrl_cmd_dispatch_brush_now:
    MOVE.W  SCRIPT_CTRL_READ_INDEX,D0
    EXT.L   D0
    ; Same packet-length/path as above (SCRIPT_CTRL_CMD_BUFFER + read index).
    MOVE.L  D0,-(A7)
    PEA     SCRIPT_CTRL_CMD_BUFFER
    PEA     _SCRIPT_CTRL_CONTEXT
    BSR.W   SCRIPT_HandleBrushCommand

    PEA     _SCRIPT_CTRL_CONTEXT
    BSR.W   SCRIPT_ProcessCtrlContextPlaybackTick

    LEA     16(A7),A7
    BRA.S   .ctrl_cmd_reset_parser

.ctrl_cmd_defer_dispatch:
    MOVE.W  SCRIPT_CtrlCmdDeferCounter,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,SCRIPT_CtrlCmdDeferCounter
    BRA.S   .ctrl_cmd_reset_parser

.ctrl_cmd_checksum_mismatch:
    PEA     1.W
    PEA     32.W
    JSR     _SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(PC)

    ADDQ.W  #8,A7
    MOVE.W  _Global_REF_CLOCKDATA_STRUCT,Global_WORD_CLOCK_SECONDS
    MOVEQ   #1,D0
    MOVE.W  _SCRIPT_CtrlCmdChecksumErrorCount,D1
    ADDQ.W  #1,D1
    MOVE.W  D1,_SCRIPT_CtrlCmdChecksumErrorCount
    MOVE.W  D0,SCRIPT_StatusMaskRefreshPending

.ctrl_cmd_reset_parser:
    MOVEQ   #0,D0
    MOVE.W  D0,SCRIPT_CTRL_CHECKSUM
    MOVE.W  D0,SCRIPT_CTRL_READ_INDEX
    MOVE.W  D0,SCRIPT_CTRL_STATE
    BRA.S   .finish_29ABA

.ctrl_cmd_state3_clear:
    CLR.W   SCRIPT_CTRL_STATE
    BRA.S   .finish_29ABA

.ctrl_cmd_state_invalid_reset:
    MOVEQ   #0,D0
    MOVE.W  D0,SCRIPT_CTRL_CHECKSUM
    MOVE.W  D0,SCRIPT_CTRL_READ_INDEX
    MOVE.W  D0,SCRIPT_CTRL_STATE

.ctrl_cmd_finish_dispatch:
.finish_29ABA:
    MOVE.W  SCRIPT_CTRL_READ_INDEX,D0
    CMPI.W  #198,D0
    BLE.S   .return

    MOVE.W  _SCRIPT_CtrlCmdLengthErrorCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_SCRIPT_CtrlCmdLengthErrorCount
    MOVEQ   #0,D0
    MOVE.W  D0,SCRIPT_CTRL_CHECKSUM
    MOVE.W  D0,SCRIPT_CTRL_READ_INDEX
    MOVE.W  _SCRIPT_RuntimeMode,D1
    MOVE.W  D0,SCRIPT_CTRL_STATE
    TST.W   D1
    BNE.S   .return

    JSR     _TEXTDISP_ResetSelectionAndRefresh(PC)

.return:
    MOVEM.L (A7)+,D6-D7
    RTS

;!======

; Dispatch helper for brush-control script commands (handles primary/secondary selection requests).
;------------------------------------------------------------------------------
; FUNC: SCRIPT_HandleBrushCommand   (Parse CTRL brush command payload)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +6: arg_2 (via 10(A5))
;   stack +7: arg_3 (via 11(A5))
;   stack +8: arg_4 (via 12(A5))
;   stack +9: arg_5 (via 13(A5))
;   stack +10: arg_6 (via 14(A5))
;   stack +11: arg_7 (via 15(A5))
;   stack +12: arg_8 (via 16(A5))
;   stack +13: arg_9 (via 17(A5))
;   stack +14: arg_10 (via 18(A5))
;   stack +16: arg_11 (via 20(A5))
;   stack +24: arg_12 (via 28(A5))
;   stack +28: arg_13 (via 32(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A7/D0/D1/D2/D3/D4/D5/D6/D7
; CALLS:
;   P_TYPE_GetSubtypeIfType20, P_TYPE_ConsumePrimaryTypeIfPresent, SCRIPT_SelectPlaybackCursorFromSearchText, SCRIPT_SplitAndNormalizeSearchBuffer, SCRIPT_LoadCtrlContextSnapshot, SCRIPT_SaveCtrlContextSnapshot, SCRIPT3_JMPTBL_ESQPARS_ApplyRtcBytesAndPersist, SCRIPT3_JMPTBL_LOCAVAIL_SetFilterModeAndResetState, SCRIPT3_JMPTBL_LOCAVAIL_ComputeFilterOffsetForEntry, _SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit, SCRIPT3_JMPTBL_MATH_Mulu32, SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt, SCRIPT3_JMPTBL_STRING_CompareN, SCRIPT3_JMPTBL_STRING_CopyPadNul, _SCRIPT_ReadHandshakeBit5Mask, TEXTDISP_FindEntryIndexByWildcard, _TEXTDISP_HandleScriptCommand, TEXTDISP_UpdateChannelRangeFlags, _ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString
; READS:
;   _BRUSH_SelectedNode, _CONFIG_LRBN_FlagChar, CONFIG_MSN_FlagChar, _CTASKS_STR_1, ESQ_DefaultNoFlagChar, _ED_DiagGraphModeChar, _ED_DiagVinModeChar, _ESQIFF_BrushIniListHead, _ESQIFF_GAdsBrushListCount, Global_WORD_SELECT_CODE_IS_RAVESC, _LOCAVAIL_FilterModeFlag, _LOCAVAIL_FilterStep, _LOCAVAIL_PrimaryFilterState, _SCRIPT_Type20SubtypeCache, _SCRIPT_CommandTextPtr, SCRIPT_BrushTag_Default00_Primary, SCRIPT_BrushTag_Default00_Secondary, SCRIPT_BrushTag_Clear11_Primary, SCRIPT_BrushTag_Clear11_Secondary, _SCRIPT_ChannelRangeArmedFlag, _TEXTDISP_ChannelSourceMode, _SCRIPT_RuntimeMode, _SCRIPT_PlaybackCursor, _SCRIPT_PrimarySearchFirstFlag, _TEXTDISP_CurrentMatchIndex, CLEANUP_AlignedStatusMatchIndex, _WDISP_CharClassTable, WDISP_HighlightActive
; WRITES:
;   BRUSH_ScriptPrimarySelection, BRUSH_ScriptSecondarySelection, HIGHLIGHT_CustomValue, _SCRIPT_Type20SubtypeCache, SCRIPT_PendingBannerTargetChar, SCRIPT_PendingBannerSpeedMs, _SCRIPT_PendingWeatherCommandChar, _SCRIPT_PendingTextdispCmdChar, _SCRIPT_PendingTextdispCmdArg, _SCRIPT_CommandTextPtr, _SCRIPT_RuntimeMode, _TEXTDISP_PrimaryChannelCode, _TEXTDISP_SecondaryChannelCode, _SCRIPT_ChannelRangeDigitChar, _SCRIPT_PlaybackCursor, _SCRIPT_PrimarySearchFirstFlag, _SCRIPT_ChannelRangeArmedFlag, _TEXTDISP_CurrentMatchIndex
; DESC:
;   Parses one CTRL packet payload via a 22-way switch/jumptable and updates
;   brush selection, playback cursor/runtime mode, channel filters, search text,
;   and pending banner-target state before optional script-command dispatch.
; NOTES:
;   Saves and restores control-context snapshots around command handling.
;------------------------------------------------------------------------------
SCRIPT_HandleBrushCommand:
    LINK.W  A5,#-36
    MOVEM.L D2-D7/A2-A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  16(A5),D7

    MOVEQ   #1,D6
    MOVEQ   #1,D0
    MOVE.L  D0,-8(A5)
    MOVE.W  _SCRIPT_RuntimeMode,D5
    MOVE.L  A3,-(A7)
    BSR.W   SCRIPT_LoadCtrlContextSnapshot

    ADDQ.W  #4,A7
    CLR.L   _SCRIPT_PlaybackCursor
    CLR.B   0(A2,D7.L)
    MOVEQ   #0,D0
    MOVE.B  (A2),D0
    SUBQ.W  #1,D0
    BLT.W   .brush_cmd_finalize

    CMPI.W  #22,D0
    BGE.W   .brush_cmd_finalize

    ADD.W   D0,D0
    MOVE.W  .brush_cmd_jmptbl(PC,D0.W),D0
    JMP     .brush_cmd_jmptbl+2(PC,D0.W)

; switch/jumptable
.brush_cmd_jmptbl:
    DC.W    .brush_cmd_case_dispatch_subcommand-.brush_cmd_jmptbl-2
    DC.W    .brush_cmd_case_select_primary_secondary-.brush_cmd_jmptbl-2
    DC.W    .brush_cmd_case_noop-.brush_cmd_jmptbl-2
    DC.W    .brush_cmd_case_toggle_primary_search_order-.brush_cmd_jmptbl-2
    DC.W    .brush_cmd_case_set_channel_codes-.brush_cmd_jmptbl-2
    DC.W    .brush_cmd_case_noop-.brush_cmd_jmptbl-2
    DC.W    .brush_cmd_case_set_cursor_15-.brush_cmd_jmptbl-2
    DC.W    .brush_cmd_case_noop-.brush_cmd_jmptbl-2
    DC.W    .brush_cmd_case_noop-.brush_cmd_jmptbl-2
    DC.W    .brush_cmd_case_noop-.brush_cmd_jmptbl-2
    DC.W    .brush_cmd_case_apply_rtc_yyyymmddhhmm-.brush_cmd_jmptbl-2
    DC.W    .brush_cmd_case_select_playback_mode-.brush_cmd_jmptbl-2
    DC.W    .brush_cmd_case_noop-.brush_cmd_jmptbl-2
    DC.W    .brush_cmd_case_noop-.brush_cmd_jmptbl-2
    DC.W    .brush_cmd_case_set_string_value-.brush_cmd_jmptbl-2
    DC.W    .brush_cmd_case_set_cursor_14-.brush_cmd_jmptbl-2
    DC.W    .brush_cmd_case_split_search_buffer-.brush_cmd_jmptbl-2
    DC.W    .brush_cmd_case_noop-.brush_cmd_jmptbl-2
    DC.W    .brush_cmd_case_noop-.brush_cmd_jmptbl-2
    DC.W    .brush_cmd_case_type20_subtype-.brush_cmd_jmptbl-2
    DC.W    .brush_cmd_case_noop-.brush_cmd_jmptbl-2
    DC.W    .brush_cmd_case_filter_or_runtime_mode-.brush_cmd_jmptbl-2

.brush_cmd_case_select_primary_secondary:
    MOVEQ   #0,D0
    LEA     3(A2),A0
    PEA     2.W
    MOVE.L  A0,-(A7)
    PEA     SCRIPT_BrushTag_Default00_Primary
    MOVE.L  D0,-20(A5)
    MOVE.L  D0,-16(A5)
    JSR     SCRIPT3_JMPTBL_STRING_CompareN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .brush_cmd_after_tag_primary00

    MOVE.L  _BRUSH_SelectedNode,BRUSH_ScriptPrimarySelection    ; default primary selection to current brush
    MOVEQ   #1,D0
    MOVE.L  D0,-16(A5)

.brush_cmd_after_tag_primary00:
    LEA     1(A2),A0
    PEA     2.W
    MOVE.L  A0,-(A7)
    PEA     SCRIPT_BrushTag_Default00_Secondary
    JSR     SCRIPT3_JMPTBL_STRING_CompareN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .brush_cmd_after_tag_secondary00

    MOVE.L  _BRUSH_SelectedNode,BRUSH_ScriptSecondarySelection  ; same for secondary fallback
    MOVEQ   #1,D0
    MOVE.L  D0,-20(A5)

.brush_cmd_after_tag_secondary00:
    LEA     3(A2),A0
    PEA     2.W
    MOVE.L  A0,-(A7)
    PEA     SCRIPT_BrushTag_Clear11_Primary
    JSR     SCRIPT3_JMPTBL_STRING_CompareN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .brush_cmd_after_tag_primary11

    TST.L   -16(A5)
    BNE.S   .brush_cmd_after_tag_primary11

    CLR.L   BRUSH_ScriptPrimarySelection
    MOVEQ   #1,D0
    MOVE.L  D0,-16(A5)

.brush_cmd_after_tag_primary11:
    LEA     1(A2),A0
    PEA     2.W
    MOVE.L  A0,-(A7)
    PEA     SCRIPT_BrushTag_Clear11_Secondary
    JSR     SCRIPT3_JMPTBL_STRING_CompareN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .brush_cmd_after_tag_secondary11

    TST.L   -20(A5)
    BNE.S   .brush_cmd_after_tag_secondary11

    CLR.L   BRUSH_ScriptSecondarySelection
    MOVEQ   #1,D0
    MOVE.L  D0,-20(A5)

.brush_cmd_after_tag_secondary11:
    TST.L   -16(A5)
    BEQ.S   .brush_cmd_scan_selection_list

    TST.L   -20(A5)
    BNE.W   .brush_cmd_finalize

.brush_cmd_scan_selection_list:
    MOVE.L  _ESQIFF_BrushIniListHead,-12(A5)

.brush_cmd_scan_nodes_loop:
    ; Scan available brushes to pick the first entries matching the requested names.
    TST.L   -12(A5)
    BEQ.W   .brush_cmd_scan_complete

    MOVEA.L -12(A5),A0
    ADDA.W  #$21,A0
    LEA     3(A2),A1
    PEA     2.W
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     SCRIPT3_JMPTBL_STRING_CompareN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .brush_cmd_check_secondary_tag_loop

    TST.L   -16(A5)
    BNE.S   .brush_cmd_check_secondary_tag_loop

    MOVE.L  -12(A5),BRUSH_ScriptPrimarySelection
    MOVEQ   #1,D0
    MOVE.L  D0,-16(A5)
    BEQ.S   .brush_cmd_check_secondary_tag_loop

    TST.L   -20(A5)
    BNE.S   .brush_cmd_scan_complete

.brush_cmd_check_secondary_tag_loop:
    MOVEA.L -12(A5),A0
    ADDA.W  #$21,A0
    LEA     1(A2),A1
    PEA     2.W
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     SCRIPT3_JMPTBL_STRING_CompareN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .brush_cmd_advance_node

    TST.L   -20(A5)
    BNE.S   .brush_cmd_advance_node

    MOVE.L  -12(A5),BRUSH_ScriptSecondarySelection
    MOVEQ   #1,D0
    MOVE.L  D0,-20(A5)
    TST.L   -16(A5)
    BEQ.S   .brush_cmd_advance_node

    TST.L   D0
    BNE.S   .brush_cmd_scan_complete

.brush_cmd_advance_node:
    MOVEA.L -12(A5),A0
    MOVE.L  368(A0),-12(A5)
    BRA.W   .brush_cmd_scan_nodes_loop

.brush_cmd_scan_complete:
    TST.L   -16(A5)
    BNE.S   .brush_cmd_ensure_primary_default

    MOVEA.L _BRUSH_SelectedNode,A0
    MOVE.L  A0,BRUSH_ScriptPrimarySelection

.brush_cmd_ensure_primary_default:
    TST.L   -20(A5)
    BNE.W   .brush_cmd_finalize

    MOVE.L  _BRUSH_SelectedNode,BRUSH_ScriptSecondarySelection
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_type20_subtype:
    MOVE.L  A2,-(A7)
    JSR     P_TYPE_GetSubtypeIfType20(PC)

    ADDQ.W  #4,A7
    MOVE.B  D0,_SCRIPT_Type20SubtypeCache
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_set_channel_codes:
    MOVEQ   #0,D0
    MOVE.B  1(A2),D0
    MOVE.W  D0,_TEXTDISP_PrimaryChannelCode
    MOVEQ   #0,D0
    MOVE.B  2(A2),D0
    MOVE.W  D0,_TEXTDISP_SecondaryChannelCode
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_toggle_primary_search_order:
    MOVE.B  1(A2),D0
    MOVEQ   #76,D1
    CMP.B   D1,D0
    BNE.S   .brush_cmd_toggle_primary_search_if_r

    MOVE.W  #1,_SCRIPT_PrimarySearchFirstFlag
    BRA.W   .brush_cmd_finalize

.brush_cmd_toggle_primary_search_if_r:
    MOVEQ   #82,D1
    CMP.B   D1,D0
    BNE.S   .brush_cmd_toggle_primary_search_auto

    MOVEQ   #0,D0
    MOVE.W  D0,_SCRIPT_PrimarySearchFirstFlag
    BRA.W   .brush_cmd_finalize

.brush_cmd_toggle_primary_search_auto:
    TST.W   _SCRIPT_PrimarySearchFirstFlag
    BEQ.S   .brush_cmd_toggle_pick_secondary_first

    MOVEQ   #0,D0
    BRA.S   .brush_cmd_toggle_store_flag

.brush_cmd_toggle_pick_secondary_first:
    MOVEQ   #1,D0

.brush_cmd_toggle_store_flag:
    MOVE.W  D0,_SCRIPT_PrimarySearchFirstFlag
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_apply_rtc_yyyymmddhhmm:
    MOVE.B  _CTASKS_STR_1,D0
    MOVEQ   #49,D1
    CMP.B   D1,D0
    BNE.W   .brush_cmd_finalize

    MOVEA.L A2,A0

.brush_cmd_find_cmd_terminator:
    TST.B   (A0)+
    BNE.S   .brush_cmd_find_cmd_terminator

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    CMPA.W  #12,A0
    BNE.W   .brush_cmd_finalize

    LEA     4(A2),A0
    PEA     4.W
    MOVE.L  A0,-(A7)
    PEA     -28(A5)
    JSR     SCRIPT3_JMPTBL_STRING_CopyPadNul(PC)

    PEA     -28(A5)
    JSR     SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    LEA     16(A7),A7
    MOVEQ   #-48,D1
    ADD.B   1(A2),D1
    MOVE.B  D1,-18(A5)
    MOVEQ   #-48,D2
    ADD.B   2(A2),D2
    MOVE.B  D2,-17(A5)
    MOVEQ   #-48,D3
    ADD.B   3(A2),D3
    MOVE.B  D3,-16(A5)
    MOVE.L  D0,-32(A5)
    SUBI.L  #1900,D0
    MOVE.B  D0,-15(A5)
    MOVEQ   #-48,D0
    ADD.B   8(A2),D0
    MOVE.B  D0,-14(A5)
    MOVEQ   #-48,D0
    ADD.B   9(A2),D0
    MOVE.B  D0,-13(A5)
    MOVEQ   #-48,D0
    ADD.B   10(A2),D0
    MOVE.B  D0,-12(A5)
    MOVEQ   #-48,D3
    ADD.B   11(A2),D3
    MOVE.B  D3,-11(A5)
    CLR.B   -10(A5)
    MOVEQ   #7,D3
    CMP.B   D3,D1
    BGE.W   .brush_cmd_finalize

    MOVEQ   #12,D1
    CMP.B   D1,D2
    BGE.W   .brush_cmd_finalize

    MOVEQ   #60,D1
    CMP.B   D1,D0
    BGE.W   .brush_cmd_finalize

    PEA     -18(A5)
    JSR     SCRIPT3_JMPTBL_ESQPARS_ApplyRtcBytesAndPersist(PC)

    ADDQ.W  #4,A7
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_select_playback_mode:
    MOVE.L  _LOCAVAIL_FilterStep,D0
    MOVEQ   #1,D1
    CMP.L   D1,D0
    BEQ.S   .brush_cmd_playback_cursor_mode2

    SUBQ.L  #2,D0
    BNE.S   .brush_cmd_filter_mode_dispatch

.brush_cmd_playback_cursor_mode2:
    MOVE.W  #(-1),_TEXTDISP_CurrentMatchIndex
    MOVEQ   #2,D0
    MOVE.L  D0,_SCRIPT_PlaybackCursor
    BRA.W   .brush_cmd_finalize

.brush_cmd_filter_mode_dispatch:
    CMP.L   _LOCAVAIL_FilterModeFlag,D1
    BEQ.S   .brush_cmd_try_consume_primary_type

    MOVE.B  _ED_DiagGraphModeChar,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BEQ.S   .brush_cmd_filter_highlight_gate

    TST.L   _ESQIFF_GAdsBrushListCount
    BNE.S   .brush_cmd_set_playback_cursor_4

.brush_cmd_filter_highlight_gate:
    TST.W   WDISP_HighlightActive
    BNE.S   .brush_cmd_set_playback_cursor_4

.brush_cmd_try_consume_primary_type:
    PEA     _SCRIPT_Type20SubtypeCache
    JSR     P_TYPE_ConsumePrimaryTypeIfPresent(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .brush_cmd_filter_cmd_dispatch

    MOVEQ   #1,D0
    MOVE.L  D0,_SCRIPT_PlaybackCursor
    BRA.W   .brush_cmd_finalize

.brush_cmd_filter_cmd_dispatch:
    MOVEQ   #49,D0
    CMP.B   1(A2),D0
    BNE.S   .brush_cmd_filter_cmd_case3

    MOVE.L  D7,-(A7)
    MOVE.L  A2,-(A7)
    CLR.L   -(A7)
    BSR.W   SCRIPT_SelectPlaybackCursorFromSearchText

    LEA     12(A7),A7
    MOVE.L  D0,D6
    BRA.W   .brush_cmd_finalize

.brush_cmd_filter_cmd_case3:
    MOVEQ   #51,D0
    CMP.B   1(A2),D0
    BNE.W   .brush_cmd_finalize

    MOVE.W  #(-1),_TEXTDISP_CurrentMatchIndex
    MOVEQ   #2,D0
    MOVE.L  D0,_SCRIPT_PlaybackCursor
    BRA.W   .brush_cmd_finalize

.brush_cmd_set_playback_cursor_4:
    MOVEQ   #4,D0
    MOVE.L  D0,_SCRIPT_PlaybackCursor
    CLR.W   _SCRIPT_ChannelRangeArmedFlag
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_dispatch_subcommand:
    PEA     _SCRIPT_Type20SubtypeCache
    JSR     P_TYPE_ConsumePrimaryTypeIfPresent(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .brush_cmd_dispatch_by_subcode

    MOVEQ   #1,D0
    MOVE.L  D0,_SCRIPT_PlaybackCursor
    BRA.W   .brush_cmd_finalize

.brush_cmd_dispatch_by_subcode:
    MOVEQ   #0,D0
    MOVE.B  1(A2),D0
    SUBI.W  #$31,D0
    BEQ.W   .brush_cmd_case_select_cursor_from_primary_search

    SUBQ.W  #2,D0
    BEQ.W   .brush_cmd_case_reset_match_and_pick_cursor

    SUBQ.W  #1,D0
    BEQ.W   .brush_cmd_case_find_wildcard_then_set_cursor

    SUBQ.W  #1,D0
    BEQ.W   .brush_cmd_case_pending_banner_hex

    SUBQ.W  #1,D0
    BEQ.W   .brush_cmd_case_find_wildcard_then_set_cursor

    SUBQ.W  #1,D0
    BEQ.S   .brush_cmd_case_channel_range_gate

    SUBQ.W  #1,D0
    BEQ.W   .brush_cmd_case_select_cursor_from_secondary_search

    SUBI.W  #12,D0
    BEQ.W   .brush_cmd_case_reset_match_cursor_1

    SUBQ.W  #2,D0
    BEQ.S   .brush_cmd_case_set_cursor_9_and_banner_text

    SUBI.W  #17,D0
    BEQ.S   .brush_cmd_case_set_cursor_8_and_byte

    SUBQ.W  #1,D0
    BNE.W   .brush_cmd_finalize

.brush_cmd_case_set_cursor_9_and_banner_text:
    MOVEQ   #9,D0
    MOVE.L  D0,_SCRIPT_PlaybackCursor
    MOVE.B  1(A2),_SCRIPT_PendingTextdispCmdChar
    MOVE.B  2(A2),_SCRIPT_PendingTextdispCmdArg
    LEA     3(A2),A0                        ; payload tail inside SCRIPT_CTRL_CMD_BUFFER packet
    ; Source is NUL-terminated by caller at packet end (0(A2,D7)=0).
    MOVE.L  _SCRIPT_CommandTextPtr,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,_SCRIPT_CommandTextPtr
    CLR.L   -8(A5)
    MOVE.W  #(-2),SCRIPT_PendingBannerTargetChar
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_set_cursor_8_and_byte:
    MOVEQ   #8,D0
    MOVE.L  D0,_SCRIPT_PlaybackCursor
    MOVE.B  2(A2),_SCRIPT_PendingWeatherCommandChar
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_channel_range_gate:
    TST.W   _SCRIPT_ChannelRangeArmedFlag
    BNE.S   .brush_cmd_case_channel_range_read_digit

    MOVEQ   #0,D6
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_channel_range_read_digit:
    MOVE.W  _TEXTDISP_ChannelSourceMode,D0
    SUBQ.W  #1,D0
    BNE.S   .brush_cmd_case_channel_offset_secondary

    MOVEQ   #2,D0
    BRA.S   .brush_cmd_case_channel_offset_selected

.brush_cmd_case_channel_offset_secondary:
    MOVEQ   #3,D0

.brush_cmd_case_channel_offset_selected:
    MOVEQ   #0,D1
    MOVE.B  0(A2,D0.L),D1
    MOVE.W  D1,_SCRIPT_ChannelRangeDigitChar
    MOVEQ   #48,D0
    CMP.W   D0,D1
    BNE.S   .brush_cmd_case_require_match_index

    MOVEQ   #0,D6
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_require_match_index:
    MOVE.W  _TEXTDISP_CurrentMatchIndex,D0
    ADDQ.W  #1,D0
    BNE.S   .brush_cmd_case_resolve_match_index

    MOVE.W  CLEANUP_AlignedStatusMatchIndex,D0
    ADDQ.W  #1,D0
    BNE.S   .brush_cmd_case_resolve_match_index

    MOVEQ   #0,D6
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_resolve_match_index:
    MOVE.W  _TEXTDISP_CurrentMatchIndex,D0
    ADDQ.W  #1,D0
    BNE.S   .brush_cmd_case_apply_channel_range

    MOVE.W  CLEANUP_AlignedStatusMatchIndex,_TEXTDISP_CurrentMatchIndex

.brush_cmd_case_apply_channel_range:
    JSR     TEXTDISP_UpdateChannelRangeFlags(PC)

    MOVEQ   #5,D0
    MOVE.L  D0,_SCRIPT_PlaybackCursor
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_pending_banner_hex:
    MOVE.B  _CONFIG_LRBN_FlagChar,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BEQ.S   .brush_cmd_case_parse_pending_banner_hex

    MOVE.W  #(-1),SCRIPT_PendingBannerTargetChar
    MOVEQ   #1,D0
    MOVE.L  D0,_SCRIPT_PlaybackCursor
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_parse_pending_banner_hex:
    MOVEQ   #0,D0
    MOVE.B  2(A2),D0
    LEA     _WDISP_CharClassTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #7,(A1)
    BEQ.W   .brush_cmd_case_pending_banner_invalid

    MOVEQ   #0,D1
    MOVE.B  3(A2),D1
    ADDA.L  D1,A0
    BTST    #7,(A0)
    BEQ.W   .brush_cmd_case_pending_banner_invalid

    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     _SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    ASL.L   #4,D1
    MOVE.B  3(A2),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  D1,36(A7)
    JSR     _SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  32(A7),D0
    ADD.L   D1,D0
    MOVEQ   #0,D1
    MOVE.B  4(A2),D1
    LEA     _WDISP_CharClassTable,A0
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    MOVE.W  D0,SCRIPT_PendingBannerTargetChar
    BTST    #2,(A1)
    BEQ.S   .brush_cmd_case_default_banner_speed

    MOVEQ   #0,D0
    MOVE.B  5(A2),D0
    ADDA.L  D0,A0
    BTST    #2,(A0)
    BEQ.S   .brush_cmd_case_default_banner_speed

    MOVEQ   #0,D2
    MOVE.B  D1,D2
    MOVEQ   #48,D1
    SUB.L   D1,D2
    MOVE.L  D2,D0
    MOVE.L  #1000,D1
    JSR     SCRIPT3_JMPTBL_MATH_Mulu32(PC)

    MOVEQ   #0,D1
    MOVE.B  5(A2),D1
    MOVEQ   #48,D2
    SUB.L   D2,D1
    MOVE.L  D0,32(A7)
    MOVEQ   #100,D0
    JSR     SCRIPT3_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  32(A7),D1
    ADD.L   D0,D1
    MOVE.W  D1,SCRIPT_PendingBannerSpeedMs
    BRA.S   .brush_cmd_case_after_banner_speed

.brush_cmd_case_default_banner_speed:
    MOVE.W  #1000,SCRIPT_PendingBannerSpeedMs

.brush_cmd_case_after_banner_speed:
    TST.B   6(A2)
    BNE.S   .checkIfSelectCodeIsRAVESC

    MOVE.W  #(-1),_TEXTDISP_CurrentMatchIndex
    MOVEQ   #2,D0
    MOVE.L  D0,_SCRIPT_PlaybackCursor
    BRA.W   .brush_cmd_finalize

.checkIfSelectCodeIsRAVESC:
    TST.W   Global_WORD_SELECT_CODE_IS_RAVESC
    BNE.S   .selectCodeIsRAVESC

    MOVE.B  CONFIG_MSN_FlagChar,D0
    MOVEQ   #'M',D1
    CMP.B   D1,D0
    BEQ.S   .selectCodeIsRAVESC

    LEA     6(A2),A0
    MOVE.L  A0,-(A7)
    JSR     TEXTDISP_FindEntryIndexByWildcard(PC)

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   .selectCodeIsNotRAVESC

.selectCodeIsRAVESC:
    MOVEQ   #3,D0
    MOVE.L  D0,_SCRIPT_PlaybackCursor
    BRA.W   .brush_cmd_finalize

.selectCodeIsNotRAVESC:
    MOVEQ   #-1,D0
    MOVEQ   #1,D1
    MOVE.L  D1,_SCRIPT_PlaybackCursor
    MOVE.W  D0,SCRIPT_PendingBannerTargetChar
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_pending_banner_invalid:
    MOVE.W  #(-1),SCRIPT_PendingBannerTargetChar
    MOVEQ   #1,D0
    MOVE.L  D0,_SCRIPT_PlaybackCursor
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_reset_match_and_pick_cursor:
    MOVE.W  #(-1),_TEXTDISP_CurrentMatchIndex
    MOVE.B  ESQ_DefaultNoFlagChar,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .brush_cmd_case_set_cursor_2

    MOVEQ   #1,D0
    MOVE.L  D0,_SCRIPT_PlaybackCursor
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_set_cursor_2:
    MOVEQ   #2,D0
    MOVE.L  D0,_SCRIPT_PlaybackCursor
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_reset_match_cursor_1:
    MOVE.W  #(-1),_TEXTDISP_CurrentMatchIndex
    MOVEQ   #1,D0
    MOVE.L  D0,_SCRIPT_PlaybackCursor
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_find_wildcard_then_set_cursor:
    LEA     2(A2),A0
    MOVE.L  A0,-(A7)
    JSR     TEXTDISP_FindEntryIndexByWildcard(PC)

    ADDQ.W  #4,A7
    TST.W   D0
    BNE.S   .brush_cmd_case_wildcard_found_cursor_3

    MOVEQ   #0,D6
    MOVEQ   #1,D0
    MOVE.L  D0,_SCRIPT_PlaybackCursor
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_wildcard_found_cursor_3:
    MOVEQ   #3,D0
    MOVE.L  D0,_SCRIPT_PlaybackCursor
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_select_cursor_from_primary_search:
    MOVE.L  D7,-(A7)
    MOVE.L  A2,-(A7)
    CLR.L   -(A7)
    BSR.W   SCRIPT_SelectPlaybackCursorFromSearchText

    LEA     12(A7),A7
    MOVE.L  D0,D6
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_select_cursor_from_secondary_search:
    MOVE.L  D7,-(A7)
    MOVE.L  A2,-(A7)
    PEA     1.W
    BSR.W   SCRIPT_SelectPlaybackCursorFromSearchText

    LEA     12(A7),A7
    MOVE.L  D0,D6
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_set_string_value:
    LEA     1(A2),A0
    MOVE.L  A0,-(A7)
    JSR     SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVEQ   #63,D1
    SUB.L   D0,D1
    MOVE.B  D1,HIGHLIGHT_CustomValue
    MOVEQ   #63,D0
    CMP.B   D0,D1

    BGT.S   .brush_cmd_case_clamp_common_str_value

    TST.B   D1
    BPL.S   .brush_cmd_case_set_cursor_13

.brush_cmd_case_clamp_common_str_value:
    MOVE.B  D0,HIGHLIGHT_CustomValue

.brush_cmd_case_set_cursor_13:
    MOVEQ   #13,D0
    MOVE.L  D0,_SCRIPT_PlaybackCursor
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_set_cursor_14:
    MOVEQ   #14,D0
    MOVE.L  D0,_SCRIPT_PlaybackCursor
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_set_cursor_15:
    MOVEQ   #15,D0
    MOVE.L  D0,_SCRIPT_PlaybackCursor
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_filter_or_runtime_mode:
    MOVEQ   #57,D0
    CMP.B   1(A2),D0
    BNE.S   .brush_cmd_case_filter_update_entry

    PEA     1.W
    JSR     SCRIPT3_JMPTBL_LOCAVAIL_SetFilterModeAndResetState(PC)

    LEA     2(A2),A0
    PEA     _LOCAVAIL_PrimaryFilterState
    MOVE.L  A0,-(A7)
    JSR     SCRIPT3_JMPTBL_LOCAVAIL_ComputeFilterOffsetForEntry(PC)

    LEA     12(A7),A7
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_filter_update_entry:
    MOVEQ   #1,D0
    CMP.L   _LOCAVAIL_FilterModeFlag,D0
    BNE.S   .brush_cmd_case_filter_mode_checks

    MOVEQ   #56,D0
    CMP.B   1(A2),D0
    BNE.S   .brush_cmd_case_filter_mode_checks

    CLR.L   -(A7)
    JSR     SCRIPT3_JMPTBL_LOCAVAIL_SetFilterModeAndResetState(PC)

    ADDQ.W  #4,A7
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_filter_mode_checks:
    MOVEQ   #1,D0
    CMP.L   _LOCAVAIL_FilterModeFlag,D0
    BNE.S   .brush_cmd_case_diag_char_mode_checks

    MOVEQ   #0,D6
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_diag_char_mode_checks:
    MOVEQ   #0,D0
    MOVE.B  _ED_DiagVinModeChar,D0
    LEA     _WDISP_CharClassTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #1,(A1)
    BEQ.S   .brush_cmd_case_diag_char_keep

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #32,D2
    SUB.L   D2,D1
    BRA.S   .brush_cmd_case_diag_char_normalized

.brush_cmd_case_diag_char_keep:
    MOVEQ   #0,D1
    MOVE.B  D0,D1

.brush_cmd_case_diag_char_normalized:
    MOVEQ   #89,D2
    CMP.L   D2,D1
    BNE.S   .brush_cmd_case_check_l2

    MOVE.B  1(A2),D1
    MOVEQ   #48,D3
    CMP.B   D3,D1
    BEQ.S   .brush_cmd_case_set_runtime_mode_3

.brush_cmd_case_check_l2:
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    BTST    #1,(A1)
    BEQ.S   .brush_cmd_case_check_l2_keep

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #32,D3
    SUB.L   D3,D1
    BRA.S   .brush_cmd_case_check_l2_normalized

.brush_cmd_case_check_l2_keep:
    MOVEQ   #0,D1
    MOVE.B  D0,D1

.brush_cmd_case_check_l2_normalized:
    MOVEQ   #76,D3
    CMP.L   D3,D1
    BNE.S   .brush_cmd_case_check_y1

    MOVE.B  1(A2),D1
    MOVEQ   #50,D4
    CMP.B   D4,D1
    BNE.S   .brush_cmd_case_check_y1

.brush_cmd_case_set_runtime_mode_3:
    MOVE.W  #3,_SCRIPT_RuntimeMode
    BRA.S   .brush_cmd_finalize

.brush_cmd_case_check_y1:
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    BTST    #1,(A1)
    BEQ.S   .brush_cmd_case_check_y1_keep

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #32,D4
    SUB.L   D4,D1
    BRA.S   .brush_cmd_case_check_y1_normalized

.brush_cmd_case_check_y1_keep:
    MOVEQ   #0,D1
    MOVE.B  D0,D1

.brush_cmd_case_check_y1_normalized:
    CMP.L   D2,D1
    BNE.S   .brush_cmd_case_check_l3

    MOVE.B  1(A2),D1
    MOVEQ   #49,D2
    CMP.B   D2,D1
    BEQ.S   .brush_cmd_case_try_cursor_10

.brush_cmd_case_check_l3:
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    ADDA.L  D1,A0
    BTST    #1,(A0)
    BEQ.S   .brush_cmd_case_check_l3_keep

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #32,D2
    SUB.L   D2,D1
    BRA.S   .brush_cmd_case_check_l3_normalized

.brush_cmd_case_check_l3_keep:
    MOVEQ   #0,D1
    MOVE.B  D0,D1

.brush_cmd_case_check_l3_normalized:
    CMP.L   D3,D1
    BNE.S   .brush_cmd_case_fail

    MOVEQ   #51,D0
    CMP.B   1(A2),D0
    BNE.S   .brush_cmd_case_fail

.brush_cmd_case_try_cursor_10:
    JSR     _SCRIPT_ReadHandshakeBit5Mask(PC)

    TST.B   D0
    BEQ.S   .brush_cmd_case_fail

    MOVEQ   #10,D0
    MOVE.L  D0,_SCRIPT_PlaybackCursor
    BRA.S   .brush_cmd_finalize

.brush_cmd_case_fail:
    MOVEQ   #0,D6
    BRA.S   .brush_cmd_finalize

.brush_cmd_case_split_search_buffer:
    MOVE.L  D7,-(A7)
    MOVE.L  A2,-(A7)
    BSR.W   SCRIPT_SplitAndNormalizeSearchBuffer

    ADDQ.W  #8,A7

.brush_cmd_case_noop:
.brush_cmd_finalize:
    MOVE.L  A3,-(A7)
    BSR.W   SCRIPT_SaveCtrlContextSnapshot

    ADDQ.W  #4,A7
    TST.L   -8(A5)
    BEQ.S   .return

    TST.L   _SCRIPT_PlaybackCursor
    BEQ.S   .return

    CLR.L   -(A7)
    MOVEQ   #0,D0
    NOT.B   D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    JSR     _TEXTDISP_HandleScriptCommand(PC)

    LEA     12(A7),A7

.return:
    MOVE.W  D5,_SCRIPT_RuntimeMode
    MOVE.L  D6,D0

    MOVEM.L (A7)+,D2-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_SelectPlaybackCursorFromSearchText   (Resolve cursor from split search windows)
; ARGS:
;   stack +8: matchCountOrIndex (long) ??
;   stack +12: parseBuffer (char *)
; RET:
;   D0: 1 when a primary or secondary lookup matched, else 0
; CLOBBERS:
;   A0/A1/A3/A7/D0/D5/D6/D7
; CALLS:
;   _TEXTDISP_SelectGroupAndEntry
; READS:
;   _TEXTDISP_PrimarySearchText, _TEXTDISP_SecondarySearchText, _TEXTDISP_PrimaryChannelCode, _TEXTDISP_SecondaryChannelCode, _SCRIPT_PrimarySearchFirstFlag
; WRITES:
;   _SCRIPT_SearchMatchCountOrIndex, _SCRIPT_PlaybackCursor, _SCRIPT_ChannelRangeArmedFlag
; DESC:
;   Splits the incoming parse buffer into primary/secondary lookup windows and
;   tries entry selection in preferred order based on _SCRIPT_PrimarySearchFirstFlag.
; NOTES:
;   Sets _SCRIPT_PlaybackCursor to 6/7 on successful primary/secondary matches,
;   otherwise forces cursor 1 and clears _SCRIPT_ChannelRangeArmedFlag.
;------------------------------------------------------------------------------
SCRIPT_SelectPlaybackCursorFromSearchText:
    LINK.W  A5,#-4
    MOVEM.L D5-D7/A3,-(A7)
    MOVE.L  8(A5),D7
    MOVEA.L 12(A5),A3
    MOVEQ   #1,D6
    MOVE.L  D7,_SCRIPT_SearchMatchCountOrIndex
    MOVE.W  #1,_SCRIPT_ChannelRangeArmedFlag
    MOVEQ   #3,D5

.loop_1546:
    MOVEQ   #18,D0
    CMP.B   0(A3,D5.W),D0
    BEQ.S   .branch_1547

    MOVEQ   #30,D0
    CMP.W   D0,D5
    BGE.S   .branch_1547

    ADDQ.W  #1,D5
    BRA.S   .loop_1546

.branch_1547:
    CLR.B   0(A3,D5.W)
    TST.W   _SCRIPT_PrimarySearchFirstFlag
    BNE.S   .if_ne_1548

    MOVE.L  D5,D0
    EXT.L   D0
    MOVEA.L A3,A0
    ADDA.L  D0,A0
    LEA     1(A0),A1
    MOVE.W  _TEXTDISP_SecondaryChannelCode,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     _TEXTDISP_SecondarySearchText
    MOVE.L  A1,-(A7)
    JSR     _TEXTDISP_SelectGroupAndEntry(PC)

    LEA     12(A7),A7
    SUBQ.W  #1,D0
    BNE.S   .if_ne_1548

    MOVEQ   #7,D0
    MOVE.L  D0,_SCRIPT_PlaybackCursor
    BRA.S   .skip_154B

.if_ne_1548:
    LEA     2(A3),A0
    MOVE.W  _TEXTDISP_PrimaryChannelCode,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     _TEXTDISP_PrimarySearchText
    MOVE.L  A0,-(A7)
    JSR     _TEXTDISP_SelectGroupAndEntry(PC)

    LEA     12(A7),A7
    SUBQ.W  #1,D0
    BNE.S   .if_ne_1549

    MOVEQ   #6,D0
    MOVE.L  D0,_SCRIPT_PlaybackCursor
    BRA.S   .skip_154B

.if_ne_1549:
    TST.W   _SCRIPT_PrimarySearchFirstFlag
    BEQ.S   .branch_154A

    MOVE.L  D5,D0
    EXT.L   D0
    MOVEA.L A3,A0
    ADDA.L  D0,A0
    LEA     1(A0),A1
    MOVE.W  _TEXTDISP_SecondaryChannelCode,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     _TEXTDISP_SecondarySearchText
    MOVE.L  A1,-(A7)
    JSR     _TEXTDISP_SelectGroupAndEntry(PC)

    LEA     12(A7),A7
    SUBQ.W  #1,D0
    BNE.S   .branch_154A

    MOVEQ   #7,D0
    MOVE.L  D0,_SCRIPT_PlaybackCursor
    BRA.S   .skip_154B

.branch_154A:
    MOVEQ   #0,D6
    CLR.W   _SCRIPT_ChannelRangeArmedFlag
    MOVEQ   #1,D0
    MOVE.L  D0,_SCRIPT_PlaybackCursor

.skip_154B:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D5-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_ProcessCtrlContextPlaybackTick   (ProcessCtrlContextPlaybackTick)
; ARGS:
;   stack +12: ctxPtr (A3)
; RET:
;   D0: none
; CLOBBERS:
;   A3/A7/D0/D1/D2
; CALLS:
;   SCRIPT_ApplyPendingBannerTarget, SCRIPT_UpdateRuntimeModeForPlaybackCursor, SCRIPT_DispatchPlaybackCursorCommand, SCRIPT_LoadCtrlContextSnapshot, SCRIPT_SaveCtrlContextSnapshot, SCRIPT3_JMPTBL_LOCAVAIL_UpdateFilterStateMachine
; READS:
;   CONFIG_MSN_FlagChar, SCRIPT_RuntimeModeDispatchLatch, SCRIPT_RuntimeModeDeferredFlag, _LOCAVAIL_PrimaryFilterState, _SCRIPT_RuntimeMode, _SCRIPT_PlaybackCursor, _TEXTDISP_CurrentMatchIndex
; WRITES:
;   SCRIPT_RuntimeModeDispatchLatch, SCRIPT_RuntimeModeDeferredFlag, _SCRIPT_RuntimeMode, _SCRIPT_PlaybackCursor, TEXTDISP_CurrentMatchIndexSaved
; DESC:
;   Loads context state, applies mode/cursor gating, runs playback-command
;   dispatch, then saves the updated state back into the context snapshot.
; NOTES:
;   Playback cursor dispatch is only attempted for cursor values 1..15.
;------------------------------------------------------------------------------
SCRIPT_ProcessCtrlContextPlaybackTick:
    MOVEM.L D2/A3,-(A7)
    MOVEA.L 12(A7),A3
    PEA     _LOCAVAIL_PrimaryFilterState
    MOVE.L  A3,-(A7)
    JSR     SCRIPT3_JMPTBL_LOCAVAIL_UpdateFilterStateMachine(PC)

    MOVE.L  A3,(A7)
    BSR.W   SCRIPT_LoadCtrlContextSnapshot

    ADDQ.W  #8,A7
    TST.L   SCRIPT_RuntimeModeDeferredFlag
    BEQ.S   .playback_tick_apply_pending_mode_change

    MOVEQ   #3,D0
    MOVE.W  D0,_SCRIPT_RuntimeMode
    MOVEQ   #0,D0
    MOVE.L  D0,SCRIPT_RuntimeModeDeferredFlag

.playback_tick_apply_pending_mode_change:
    MOVE.B  CONFIG_MSN_FlagChar,D0
    MOVEQ   #77,D1
    CMP.B   D1,D0
    BNE.S   .playback_tick_gate_cursor_for_m_mode

    MOVE.L  _SCRIPT_PlaybackCursor,D0
    TST.L   D0
    BLE.S   .playback_tick_gate_cursor_for_m_mode

    MOVEQ   #10,D1
    CMP.L   D1,D0
    BGE.S   .playback_tick_gate_cursor_for_m_mode

    MOVEQ   #2,D2
    MOVE.L  D2,_SCRIPT_PlaybackCursor

.playback_tick_gate_cursor_for_m_mode:
    MOVE.W  _SCRIPT_RuntimeMode,D0
    SUBQ.W  #2,D0
    BNE.S   .playback_tick_maybe_dispatch_cursor

    TST.W   SCRIPT_RuntimeModeDispatchLatch
    BEQ.S   .playback_tick_clear_runtime_latch

    MOVE.L  _SCRIPT_PlaybackCursor,D0
    MOVEQ   #10,D1
    CMP.L   D1,D0
    BLE.S   .playback_tick_clear_runtime_latch

.playback_tick_maybe_dispatch_cursor:
    MOVE.L  _SCRIPT_PlaybackCursor,D0
    TST.L   D0
    BLE.S   .return

    MOVEQ   #15,D1
    CMP.L   D1,D0
    BGT.S   .return

    BSR.W   SCRIPT_UpdateRuntimeModeForPlaybackCursor

    TST.W   D0
    BNE.S   .return

    MOVEQ   #1,D0
    CMP.L   _SCRIPT_PlaybackCursor,D0
    BEQ.S   .playback_tick_dispatch_cursor

    BSR.W   SCRIPT_ApplyPendingBannerTarget

.playback_tick_dispatch_cursor:
    PEA     _SCRIPT_PlaybackCursor
    BSR.W   SCRIPT_DispatchPlaybackCursorCommand

    ADDQ.W  #4,A7
    BRA.S   .return

.playback_tick_clear_runtime_latch:
    CLR.W   SCRIPT_RuntimeModeDispatchLatch

.return:
    MOVE.W  _TEXTDISP_CurrentMatchIndex,TEXTDISP_CurrentMatchIndexSaved
    MOVE.L  A3,-(A7)
    BSR.W   SCRIPT_SaveCtrlContextSnapshot

    ADDQ.W  #4,A7
    MOVEM.L (A7)+,D2/A3
    RTS

;!======
