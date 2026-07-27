    XDEF    SCRIPT_ApplyPendingBannerTarget
    XDEF    SCRIPT_DispatchPlaybackCursorCommand
    XDEF    SCRIPT_LoadCtrlContextSnapshot
    XDEF    _SCRIPT_ResetCtrlContext
    XDEF    SCRIPT_ResetCtrlContextAndClearStatusLine
    XDEF    SCRIPT_SaveCtrlContextSnapshot
    XDEF    _SCRIPT_SetCtrlContextMode
    XDEF    SCRIPT_SplitAndNormalizeSearchBuffer
    XDEF    SCRIPT_UpdateCtrlStateMachine
    XDEF    SCRIPT_UpdateRuntimeModeForPlaybackCursor
    XDEF    SCRIPT3_JMPTBL_CLEANUP_RenderAlignedStatusScreen
    XDEF    _SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh
    XDEF    SCRIPT3_JMPTBL_ESQPARS_ApplyRtcBytesAndPersist
    XDEF    _SCRIPT3_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters
    XDEF    SCRIPT3_JMPTBL_ESQ_SetCopperEffect_Custom
    XDEF    _SCRIPT3_JMPTBL_GCOMMAND_AdjustBannerCopperOffset
    XDEF    _SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar
    XDEF    _SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit
    XDEF    SCRIPT3_JMPTBL_LOCAVAIL_ComputeFilterOffsetForEntry
    XDEF    SCRIPT3_JMPTBL_LOCAVAIL_SetFilterModeAndResetState
    XDEF    SCRIPT3_JMPTBL_LOCAVAIL_UpdateFilterStateMachine
    XDEF    SCRIPT3_JMPTBL_MATH_DivS32
    XDEF    SCRIPT3_JMPTBL_MATH_Mulu32
    XDEF    SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt
    XDEF    SCRIPT3_JMPTBL_STRING_CompareN
    XDEF    SCRIPT3_JMPTBL_STRING_CopyPadNul

;------------------------------------------------------------------------------
; FUNC: SCRIPT_SplitAndNormalizeSearchBuffer   (SplitAndNormalizeSearchBuffer)
; ARGS:
;   stack +16: parseBuffer (char *)
;   stack +20: parseLen (long)
; RET:
;   D0: none
; CLOBBERS:
;   A0/A1/A3/A7/D0/D6/D7
; CALLS:
;   _SCRIPT3_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters
; READS:
;   _TEXTDISP_PrimarySearchText, _TEXTDISP_SecondarySearchText, c8
; WRITES:
;   _TEXTDISP_PrimarySearchText, _TEXTDISP_SecondarySearchText
; DESC:
;   Splits raw search text around delimiter 18 and copies primary/secondary
;   portions into dedicated buffers.
; NOTES:
;   Calls _SCRIPT3_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters with max length 128 for non-empty strings.
;------------------------------------------------------------------------------
SCRIPT_SplitAndNormalizeSearchBuffer:
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVE.L  20(A7),D7
    MOVEQ   #18,D0
    CMP.B   1(A3),D0
    BNE.S   .split_search_check_trailing_delimiter

    LEA     2(A3),A0
    LEA     _TEXTDISP_SecondarySearchText,A1

.split_search_copy_secondary_only:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .split_search_copy_secondary_only

    MOVEQ   #0,D0
    MOVE.B  D0,_TEXTDISP_PrimarySearchText
    BRA.S   .split_search_filter_primary

.split_search_check_trailing_delimiter:
    CMP.B   -1(A3,D7.L),D0
    BNE.S   .split_search_find_mid_delimiter

    CLR.B   -1(A3,D7.L)
    LEA     1(A3),A0
    LEA     _TEXTDISP_PrimarySearchText,A1

.split_search_copy_primary_only:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .split_search_copy_primary_only

    CLR.B   _TEXTDISP_SecondarySearchText
    BRA.S   .split_search_filter_primary

.split_search_find_mid_delimiter:
    MOVEQ   #1,D6

.split_search_find_mid_delimiter_loop:
    MOVEQ   #18,D0
    CMP.B   0(A3,D6.W),D0
    BEQ.S   .split_search_split_at_delimiter

    CMPI.W  #$c8,D6
    BGE.S   .split_search_split_at_delimiter

    ADDQ.W  #1,D6
    BRA.S   .split_search_find_mid_delimiter_loop

.split_search_split_at_delimiter:
    CLR.B   0(A3,D6.W)
    MOVE.L  D6,D0
    EXT.L   D0
    MOVEA.L A3,A0
    ADDA.L  D0,A0
    LEA     1(A0),A1
    LEA     _TEXTDISP_SecondarySearchText,A0

.split_search_copy_secondary_part:
    MOVE.B  (A1)+,(A0)+
    BNE.S   .split_search_copy_secondary_part

    LEA     1(A3),A0
    LEA     _TEXTDISP_PrimarySearchText,A1

.split_search_copy_primary_part:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .split_search_copy_primary_part

.split_search_filter_primary:
    LEA     _TEXTDISP_PrimarySearchText,A0
    MOVE.L  A0,D0
    BEQ.S   .split_search_filter_secondary

    TST.B   _TEXTDISP_PrimarySearchText
    BEQ.S   .split_search_filter_secondary

    PEA     128.W
    MOVE.L  A0,-(A7)
    JSR     _SCRIPT3_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters(PC)

    ADDQ.W  #8,A7

.split_search_filter_secondary:
    LEA     _TEXTDISP_SecondarySearchText,A0
    MOVE.L  A0,D0
    BEQ.S   .return

    TST.B   _TEXTDISP_SecondarySearchText
    BEQ.S   .return

    PEA     128.W
    MOVE.L  A0,-(A7)
    JSR     _SCRIPT3_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters(PC)

    ADDQ.W  #8,A7

.return:
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_ApplyPendingBannerTarget   (ApplyPendingBannerTarget)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   A7/D0/D1/D2/D7
; CALLS:
;   _SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar, SCRIPT_BeginBannerCharTransition
; READS:
;   _CONFIG_BannerCopperHeadByte, SCRIPT_PendingBannerTargetChar, SCRIPT_PendingBannerSpeedMs, SCRIPT_ReadModeActiveLatch
; WRITES:
;   _ESQPARS2_ReadModeFlags, SCRIPT_PendingBannerTargetChar, SCRIPT_ReadModeActiveLatch
; DESC:
;   Applies any pending banner target request and kicks a transition if needed.
; NOTES:
;   A pending value of -2 is normalized to -1 (no deferred target).
;------------------------------------------------------------------------------
SCRIPT_ApplyPendingBannerTarget:
    MOVEM.L D2/D7,-(A7)
    JSR     _SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar(PC)

    MOVE.L  D0,D7
    MOVEQ   #-2,D0
    CMP.W   SCRIPT_PendingBannerTargetChar,D0
    BNE.S   .check_specific_pending_target

    MOVEQ   #-1,D0
    MOVE.W  D0,SCRIPT_PendingBannerTargetChar
    BRA.S   .maybe_clear_readmode_flags

.check_specific_pending_target:
    MOVE.W  SCRIPT_PendingBannerTargetChar,D0
    MOVEQ   #-1,D1
    CMP.W   D1,D0
    BEQ.S   .compare_against_default_target

    EXT.L   D0
    MOVE.W  SCRIPT_PendingBannerSpeedMs,D1
    MOVEQ   #0,D2
    MOVE.W  D1,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   SCRIPT_BeginBannerCharTransition

    ADDQ.W  #8,A7
    MOVE.W  #(-1),SCRIPT_PendingBannerTargetChar
    BRA.S   .maybe_clear_readmode_flags

.compare_against_default_target:
    MOVE.W  _CONFIG_BannerCopperHeadByte,D0
    CMP.W   D0,D7
    BEQ.S   .maybe_clear_readmode_flags

    EXT.L   D0
    MOVE.W  SCRIPT_PendingBannerSpeedMs,D1
    MOVEQ   #0,D2
    MOVE.W  D1,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   SCRIPT_BeginBannerCharTransition

    ADDQ.W  #8,A7
    MOVE.W  #(-1),SCRIPT_PendingBannerTargetChar

.maybe_clear_readmode_flags:
    TST.W   SCRIPT_ReadModeActiveLatch
    BEQ.S   .return

    MOVEQ   #0,D0
    MOVE.W  D0,_ESQPARS2_ReadModeFlags
    MOVE.W  D0,SCRIPT_ReadModeActiveLatch

.return:
    MOVEM.L (A7)+,D2/D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_UpdateRuntimeModeForPlaybackCursor   (UpdateRuntimeModeForPlaybackCursor)
; ARGS:
;   (none)
; RET:
;   D0: 1 when a mode-change path was consumed, else 0
; CLOBBERS:
;   A7/D0/D1/D7
; CALLS:
;   _SCRIPT_UpdateSerialShadowFromCtrlByte, _SCRIPT_ClearSearchTextsAndChannels, SCRIPT_BeginBannerCharTransition, SCRIPT_DeassertCtrlLineNow, TEXTDISP_SetRastForMode, WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight
; READS:
;   _CONFIG_BannerCopperHeadByte, CONFIG_RuntimeMode12BannerJumpEnabledFlag, CONFIG_MsnRuntimeModeSelectorChar_LRBN, CONFIG_MSN_FlagChar, _SCRIPT_RuntimeMode
; WRITES:
;   SCRIPT_CtrlHandshakeRetryCount, SCRIPT_RuntimeModeDispatchLatch, _SCRIPT_RuntimeMode, _TEXTDISP_CurrentMatchIndex
; DESC:
;   Handles runtime-mode transitions around playback cursor commands and
;   updates the serial shadow byte according to current mode/flags.
; NOTES:
;   Returns 1 when it handled the mode transition and caller should stop.
;------------------------------------------------------------------------------
SCRIPT_UpdateRuntimeModeForPlaybackCursor:
    MOVE.L  D7,-(A7)

    MOVE.W  _SCRIPT_RuntimeMode,D0
    SUBQ.W  #1,D0
    BNE.W   .runtime_mode_else_paths

    MOVE.B  CONFIG_RuntimeMode12BannerJumpEnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .runtime_mode_enter_mode2

    MOVE.W  _CONFIG_BannerCopperHeadByte,D0
    ADDI.W  #28,D0
    EXT.L   D0
    PEA     1000.W
    MOVE.L  D0,-(A7)
    BSR.W   SCRIPT_BeginBannerCharTransition

    ADDQ.W  #8,A7

.runtime_mode_enter_mode2:
    CLR.W   SCRIPT_CtrlHandshakeRetryCount
    MOVE.W  #(-1),_TEXTDISP_CurrentMatchIndex
    MOVE.W  #2,_SCRIPT_RuntimeMode
    MOVE.W  #1,SCRIPT_RuntimeModeDispatchLatch
    JSR     WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(PC)

    CLR.L   -(A7)
    JSR     TEXTDISP_SetRastForMode(PC)

    ADDQ.W  #4,A7
    MOVE.B  CONFIG_MSN_FlagChar,D0
    MOVEQ   #77,D1
    CMP.B   D1,D0
    BEQ.S   .runtime_mode_pick_shadow_byte

    MOVEQ   #83,D1
    CMP.B   D1,D0
    BNE.S   .runtime_mode_shadow_default

.runtime_mode_pick_shadow_byte:
    MOVE.B  CONFIG_MsnRuntimeModeSelectorChar_LRBN,D0
    EXT.W   D0
    SUBI.W  #$42,D0
    BEQ.S   .runtime_mode_shadow_case_3

    SUBI.W  #10,D0
    BEQ.S   .runtime_mode_shadow_case_1

    SUBQ.W  #2,D0
    BEQ.S   .runtime_mode_shadow_case_0

    SUBQ.W  #4,D0
    BEQ.S   .runtime_mode_shadow_case_2

    BRA.S   .runtime_mode_shadow_case_0

.runtime_mode_shadow_case_1:
    MOVEQ   #1,D7
    BRA.S   .runtime_mode_apply_shadow_and_clear_search

.runtime_mode_shadow_case_2:
    MOVEQ   #2,D7
    BRA.S   .runtime_mode_apply_shadow_and_clear_search

.runtime_mode_shadow_case_3:
    MOVEQ   #3,D7
    BRA.S   .runtime_mode_apply_shadow_and_clear_search

.runtime_mode_shadow_case_0:
    MOVEQ   #0,D7
    BRA.S   .runtime_mode_apply_shadow_and_clear_search

.runtime_mode_shadow_default:
    MOVEQ   #0,D7

.runtime_mode_apply_shadow_and_clear_search:
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D0,-(A7)
    JSR     _SCRIPT_UpdateSerialShadowFromCtrlByte(PC)

    BSR.W   _SCRIPT_ClearSearchTextsAndChannels

    ADDQ.W  #4,A7
    MOVEQ   #1,D0
    BRA.S   .runtime_mode_return

.runtime_mode_else_paths:
    MOVE.W  _SCRIPT_RuntimeMode,D0
    SUBQ.W  #3,D0
    BNE.S   .runtime_mode_clear_to_zero

    JSR     SCRIPT_DeassertCtrlLineNow(PC)

    MOVEQ   #0,D0
    MOVE.W  D0,SCRIPT_RuntimeModeDispatchLatch

.runtime_mode_clear_to_zero:
    MOVEQ   #0,D0
    MOVE.W  D0,_SCRIPT_RuntimeMode

.runtime_mode_return:
    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_UpdateCtrlStateMachine   (Update ctrl-line runtime state machine)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1
; CALLS:
;   SCRIPT_DeassertCtrlLineNow, TEXTDISP_ResetSelectionAndRefresh, _STR_FindCharPtr, SCRIPT_ReadHandshakeBit3Flag
; READS:
;   _SCRIPT_RuntimeMode, SCRIPT_CtrlHandshakeStage, SCRIPT_CtrlHandshakeRetryCount, _ED_DiagVinModeChar, _Global_UIBusyFlag
; WRITES:
;   _SCRIPT_RuntimeMode, SCRIPT_CtrlHandshakeStage, SCRIPT_CtrlHandshakeRetryCount
; DESC:
;   Advances a small control state machine and triggers follow-up actions when
;   counters hit thresholds.
; NOTES:
;   Uses _ED_DiagVinModeChar via _STR_FindCharPtr to probe a control flag string.
;------------------------------------------------------------------------------
SCRIPT_UpdateCtrlStateMachine:
    BSR.W   .refresh_ctrl_state

    MOVE.W  _SCRIPT_RuntimeMode,D0
    SUBQ.W  #2,D0
    BNE.S   .reset_state

    MOVE.W  SCRIPT_CtrlHandshakeStage,D0
    SUBQ.W  #1,D0
    BNE.S   .check_state_two

    MOVE.W  SCRIPT_CtrlHandshakeRetryCount,D0
    MOVE.L  D0,D1
    ADDQ.W  #1,D1
    MOVE.W  D1,SCRIPT_CtrlHandshakeRetryCount
    MOVEQ   #3,D0
    CMP.W   D0,D1
    BLT.S   .return_status

    CLR.W   SCRIPT_CtrlHandshakeRetryCount
    MOVE.W  D0,_SCRIPT_RuntimeMode
    JSR     SCRIPT_DeassertCtrlLineNow(PC)

    JSR     TEXTDISP_ResetSelectionAndRefresh(PC)

    BRA.S   .return_status

.check_state_two:
    MOVE.W  SCRIPT_CtrlHandshakeStage,D0
    SUBQ.W  #2,D0
    BNE.S   .check_banner_active

    MOVEQ   #0,D0
    MOVE.W  D0,SCRIPT_CtrlHandshakeRetryCount
    BRA.S   .return_status

.check_banner_active:
    TST.W   _Global_UIBusyFlag
    BEQ.S   .return_status

    MOVE.W  #3,_SCRIPT_RuntimeMode
    BRA.S   .return_status

.reset_state:
    CLR.W   SCRIPT_CtrlHandshakeRetryCount

.return_status:
    RTS

;!======

.refresh_ctrl_state:
    MOVEQ   #0,D0
    MOVE.B  _ED_DiagVinModeChar,D0
    MOVE.L  D0,-(A7)
    PEA     SCRIPT_Tag_YL
    ; strchr-style membership test against "YL" mode-gate chars.
    JSR     _STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .clear_state

    JSR     SCRIPT_ReadHandshakeBit3Flag(PC)

    TST.B   D0
    BEQ.S   .set_state_one

    MOVE.W  #2,SCRIPT_CtrlHandshakeStage
    BRA.S   .refresh_done

.set_state_one:
    MOVE.W  #1,SCRIPT_CtrlHandshakeStage
    BRA.S   .refresh_done

.clear_state:
    CLR.W   SCRIPT_CtrlHandshakeStage

.refresh_done:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_DispatchPlaybackCursorCommand   (DispatchPlaybackCursorCommand)
; ARGS:
;   stack +8: playbackCursorPtr (long *)
; RET:
;   D0: none
; CLOBBERS:
;   A3/A7/D0/D1
; CALLS:
;   _SCRIPT_UpdateSerialShadowFromCtrlByte, _SCRIPT_ClearSearchTextsAndChannels, TEXTDISP_ResetSelectionAndRefresh, WDISP_HandleWeatherStatusCommand, SCRIPT3_JMPTBL_CLEANUP_RenderAlignedStatusScreen, SCRIPT3_JMPTBL_ESQ_SetCopperEffect_Custom, SCRIPT_AssertCtrlLineNow, _TEXTDISP_HandleScriptCommand, TEXTDISP_SetRastForMode, WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight
; READS:
;   _CONFIG_BannerCopperHeadByte, CONFIG_MSN_FlagChar, TEXTDISP_DeferredActionCountdown, SCRIPT_PlaybackFallbackCounter, _SCRIPT_PendingWeatherCommandChar, _SCRIPT_PendingTextdispCmdChar, _SCRIPT_PendingTextdispCmdArg, _SCRIPT_CommandTextPtr, _SCRIPT_ChannelRangeDigitChar, _SCRIPT_SearchMatchCountOrIndex, _TEXTDISP_ChannelSourceMode
; WRITES:
;   TEXTDISP_DeferredActionCountdown, TEXTDISP_DeferredActionArmed, _ESQPARS2_ReadModeFlags, SCRIPT_PlaybackFallbackCounter, SCRIPT_PendingBannerTargetChar, SCRIPT_PendingBannerSpeedMs, SCRIPT_ReadModeActiveLatch, _SCRIPT_RuntimeMode, _TEXTDISP_CurrentMatchIndex
; DESC:
;   Dispatches command behavior from *playbackCursorPtr using a compiler
;   switch/jumptable and clears the command slot afterward.
; NOTES:
;   Valid dispatch range is cursor values 1..15.
;------------------------------------------------------------------------------
SCRIPT_DispatchPlaybackCursorCommand:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    MOVE.L  (A3),D0
    SUBQ.L  #1,D0
    BLT.W   .playback_cmd_case_default_increment

    CMPI.L  #$f,D0
    BGE.W   .playback_cmd_case_default_increment

    ADD.W   D0,D0
    MOVE.W  .playback_cmd_jmptbl(PC,D0.W),D0
    JMP     .playback_cmd_jmptbl+2(PC,D0.W)

; switch/jumptable
.playback_cmd_jmptbl:
    DC.W    .playback_cmd_case_reset_selection-.playback_cmd_jmptbl-2
    DC.W    .playback_cmd_case_enter_mode2_and_shadow-.playback_cmd_jmptbl-2
    DC.W    .playback_cmd_case_enter_mode2_no_defer-.playback_cmd_jmptbl-2
    DC.W    .playback_cmd_case_enter_mode2_defer-.playback_cmd_jmptbl-2
    DC.W    .playback_cmd_case_render_aligned_current-.playback_cmd_jmptbl-2
    DC.W    .playback_cmd_case_render_aligned_primary-.playback_cmd_jmptbl-2
    DC.W    .playback_cmd_case_render_aligned_secondary-.playback_cmd_jmptbl-2
    DC.W    .playback_cmd_case_weather_status-.playback_cmd_jmptbl-2
    DC.W    .playback_cmd_case_textdisp_command-.playback_cmd_jmptbl-2
    DC.W    .playback_cmd_case_assert_ctrl_mode1-.playback_cmd_jmptbl-2
    DC.W    .playback_cmd_case_highlight_and_banner_plus28-.playback_cmd_jmptbl-2
    DC.W    .playback_cmd_case_banner_current-.playback_cmd_jmptbl-2
    DC.W    .playback_cmd_case_custom_copper_effect-.playback_cmd_jmptbl-2
    DC.W    .playback_cmd_case_set_read_mode_on-.playback_cmd_jmptbl-2
    DC.W    .playback_cmd_case_set_read_mode_off-.playback_cmd_jmptbl-2

.playback_cmd_case_set_read_mode_on:
    MOVE.W  #1,SCRIPT_ReadModeActiveLatch
    MOVE.W  #256,_ESQPARS2_ReadModeFlags
    BRA.W   .return

.playback_cmd_case_set_read_mode_off:
    MOVEQ   #0,D0
    MOVE.W  D0,SCRIPT_ReadModeActiveLatch
    MOVE.W  D0,_ESQPARS2_ReadModeFlags
    BRA.W   .return

.playback_cmd_case_highlight_and_banner_plus28:
    JSR     WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(PC)

    CLR.L   -(A7)
    JSR     TEXTDISP_SetRastForMode(PC)

    ADDQ.W  #4,A7
    MOVE.W  _CONFIG_BannerCopperHeadByte,D0
    ADDI.W  #28,D0
    MOVE.W  #1000,SCRIPT_PendingBannerSpeedMs
    MOVE.W  D0,SCRIPT_PendingBannerTargetChar
    BRA.W   .return

.playback_cmd_case_banner_current:
    MOVE.W  _CONFIG_BannerCopperHeadByte,D0
    MOVE.W  #1000,SCRIPT_PendingBannerSpeedMs
    MOVE.W  D0,SCRIPT_PendingBannerTargetChar
    BRA.W   .return

.playback_cmd_case_custom_copper_effect:
    JSR     SCRIPT3_JMPTBL_ESQ_SetCopperEffect_Custom(PC)

    BRA.W   .return

.playback_cmd_case_reset_selection:
    JSR     TEXTDISP_ResetSelectionAndRefresh(PC)

    BRA.W   .return

.playback_cmd_case_enter_mode2_and_shadow:
    MOVE.W  #(-1),_TEXTDISP_CurrentMatchIndex
    JSR     WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(PC)

    CLR.L   -(A7)
    JSR     TEXTDISP_SetRastForMode(PC)

    ADDQ.W  #4,A7
    MOVE.B  CONFIG_MSN_FlagChar,D0
    MOVEQ   #77,D1
    CMP.B   D1,D0
    BNE.S   .playback_cmd_case_shadow_fallback

    PEA     3.W
    JSR     _SCRIPT_UpdateSerialShadowFromCtrlByte(PC)

    ADDQ.W  #4,A7
    BRA.W   .return

.playback_cmd_case_shadow_fallback:
    PEA     1.W
    JSR     _SCRIPT_UpdateSerialShadowFromCtrlByte(PC)

    ADDQ.W  #4,A7
    BRA.W   .return

.playback_cmd_case_enter_mode2_no_defer:
    MOVE.W  #(-1),_TEXTDISP_CurrentMatchIndex
    JSR     WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(PC)

    CLR.L   -(A7)
    JSR     TEXTDISP_SetRastForMode(PC)

    PEA     1.W
    JSR     _SCRIPT_UpdateSerialShadowFromCtrlByte(PC)

    ADDQ.W  #8,A7
    BRA.W   .return

.playback_cmd_case_enter_mode2_defer
    MOVE.W  #(-1),_TEXTDISP_CurrentMatchIndex
    MOVE.W  TEXTDISP_DeferredActionCountdown,D0
    BNE.W   .return

    PEA     3.W
    JSR     _SCRIPT_UpdateSerialShadowFromCtrlByte(PC)

    ADDQ.W  #4,A7
    MOVE.W  #3,TEXTDISP_DeferredActionCountdown
    MOVE.W  #1,TEXTDISP_DeferredActionArmed
    BRA.W   .return

.playback_cmd_case_render_aligned_current:
    MOVE.W  _TEXTDISP_ChannelSourceMode,D0
    EXT.L   D0
    MOVE.W  _SCRIPT_ChannelRangeDigitChar,D1
    EXT.L   D1
    CLR.L   -(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     SCRIPT3_JMPTBL_CLEANUP_RenderAlignedStatusScreen(PC)

    LEA     12(A7),A7
    BRA.W   .return

.playback_cmd_case_render_aligned_primary:
    MOVE.L  _SCRIPT_SearchMatchCountOrIndex,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     53.W
    PEA     1.W
    JSR     SCRIPT3_JMPTBL_CLEANUP_RenderAlignedStatusScreen(PC)

    LEA     12(A7),A7
    BRA.W   .return

.playback_cmd_case_render_aligned_secondary:
    MOVE.L  _SCRIPT_SearchMatchCountOrIndex,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     53.W
    CLR.L   -(A7)
    JSR     SCRIPT3_JMPTBL_CLEANUP_RenderAlignedStatusScreen(PC)

    LEA     12(A7),A7
    BRA.S   .return

.playback_cmd_case_weather_status:
    MOVE.W  #(-1),_TEXTDISP_CurrentMatchIndex
    MOVEQ   #0,D0
    MOVE.B  _SCRIPT_PendingWeatherCommandChar,D0
    MOVE.L  D0,-(A7)
    JSR     WDISP_HandleWeatherStatusCommand(PC)

    ADDQ.W  #4,A7
    BRA.S   .return

.playback_cmd_case_textdisp_command:
    MOVE.W  #(-1),_TEXTDISP_CurrentMatchIndex
    MOVEQ   #0,D0
    MOVE.B  _SCRIPT_PendingTextdispCmdChar,D0
    MOVEQ   #0,D1
    MOVE.B  _SCRIPT_PendingTextdispCmdArg,D1
    MOVE.L  _SCRIPT_CommandTextPtr,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     _TEXTDISP_HandleScriptCommand(PC)

    LEA     12(A7),A7
    BRA.S   .return

.playback_cmd_case_assert_ctrl_mode1:
    JSR     SCRIPT_AssertCtrlLineNow(PC)

    MOVE.W  #1,_SCRIPT_RuntimeMode
    BRA.S   .return

.playback_cmd_case_default_increment:
    MOVE.W  #(-1),_TEXTDISP_CurrentMatchIndex
    MOVE.W  SCRIPT_PlaybackFallbackCounter,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,SCRIPT_PlaybackFallbackCounter

.return:
    BSR.W   _SCRIPT_ClearSearchTextsAndChannels

    CLR.L   (A3)
    MOVEA.L (A7)+,A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _SCRIPT_SetCtrlContextMode   (Set ctrl context mode + reset snapshot)
; ARGS:
;   (none observed)
; RET:
;   D0: none
; CLOBBERS:
;   D0/D7/A3
; CALLS:
;   _SCRIPT_ResetCtrlContext
; READS:
;   (none)
; WRITES:
;   A3+0, A3+2, and full context via _SCRIPT_ResetCtrlContext
; DESC:
;   Stores a mode flag into the CTRL context header and reinitializes it.
; NOTES:
;   Calls _SCRIPT_ResetCtrlContext to clear and reset the rest of the structure.
;------------------------------------------------------------------------------
_SCRIPT_SetCtrlContextMode:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVE.W  18(A7),D7
    MOVE.W  D7,(A3)
    MOVE.W  #1,2(A3)
    MOVE.L  A3,-(A7)
    BSR.W   _SCRIPT_ResetCtrlContext

    ADDQ.W  #4,A7
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _SCRIPT_ResetCtrlContext   (Reset ctrl context snapshot fields)
; ARGS:
;   stack +12: ctxPtr (A3)
; RET:
;   D0: none
; CLOBBERS:
;   D0/D1/D7/A3
; CALLS:
;   _ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString
; READS:
;   (none observed)
; WRITES:
;   A3 fields: +26/+226 strings, +426 flag, +436..+439, +440 handle, and
;   clears ranges at +428..+431 and +0x1B0..+0x1B3 (4 bytes each).
; DESC:
;   Clears and initializes the CTRL context structure and refreshes a resource.
; NOTES:
;   The loop runs 4 iterations (D7 = 0..3), clearing two 4-byte subranges.
;------------------------------------------------------------------------------
_SCRIPT_ResetCtrlContext:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEQ   #0,D0
    MOVE.B  D0,436(A3)
    MOVE.B  #120,437(A3)
    MOVE.B  D0,438(A3)
    MOVE.B  D0,439(A3)
    MOVE.L  440(A3),-(A7)
    CLR.L   -(A7)
    JSR     _ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,440(A3)
    MOVEQ   #0,D0
    MOVE.B  D0,226(A3)
    MOVE.B  D0,26(A3)
    MOVEQ   #0,D0
    MOVE.W  D0,6(A3)
    MOVE.W  D0,4(A3)
    MOVE.W  D0,10(A3)
    MOVE.W  D0,12(A3)
    MOVE.W  D0,14(A3)
    MOVEQ   #0,D1
    MOVE.L  D1,16(A3)
    MOVE.L  D1,20(A3)
    MOVE.W  D0,24(A3)
    MOVE.W  #1,426(A3)
    MOVE.L  D1,D7

.ctrl_context_reset_clear_loop:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.S   .return

    MOVEQ   #0,D0
    MOVE.L  D7,D1
    ADDI.L  #428,D1
    MOVE.B  D0,0(A3,D1.L)
    MOVE.L  D7,D1
    ADDI.L  #$1b0,D1
    MOVE.B  D0,0(A3,D1.L)
    ADDQ.L  #1,D7
    BRA.S   .ctrl_context_reset_clear_loop

.return:
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_LoadCtrlContextSnapshot   (LoadCtrlContextSnapshot)
; ARGS:
;   stack +12: ctxPtr (A3)
; RET:
;   D0: none
; CLOBBERS:
;   A0/A1/A3/A7/D0/D1/D7
; CALLS:
;   _ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString
; READS:
;   _SCRIPT_CommandTextPtr, _SCRIPT_RuntimeMode, _TEXTDISP_PrimarySearchText, _TEXTDISP_SecondarySearchText, _TEXTDISP_BannerFallbackEntryIndex, _TEXTDISP_BannerSelectedEntryIndex
; WRITES:
;   _SCRIPT_Type20SubtypeCache, _SCRIPT_PendingWeatherCommandChar, _SCRIPT_PendingTextdispCmdChar, _SCRIPT_PendingTextdispCmdArg, _SCRIPT_CommandTextPtr, _TEXTDISP_ActiveGroupId, _SCRIPT_RuntimeMode, _TEXTDISP_PrimaryChannelCode, _TEXTDISP_SecondaryChannelCode, _SCRIPT_ChannelRangeDigitChar, _SCRIPT_SearchMatchCountOrIndex, _SCRIPT_PlaybackCursor, _SCRIPT_PrimarySearchFirstFlag, _SCRIPT_ChannelRangeArmedFlag, _TEXTDISP_CurrentMatchIndex, _TEXTDISP_ChannelSourceMode
; DESC:
;   Loads saved CTRL context fields into live script/text-display globals.
; NOTES:
;   Copies two NUL-terminated text buffers from context offsets +26 and +226.
;------------------------------------------------------------------------------
SCRIPT_LoadCtrlContextSnapshot:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVE.B  436(A3),_SCRIPT_Type20SubtypeCache
    MOVE.B  437(A3),_SCRIPT_PendingWeatherCommandChar
    MOVE.B  438(A3),_SCRIPT_PendingTextdispCmdChar
    MOVE.B  439(A3),_SCRIPT_PendingTextdispCmdArg
    MOVE.L  _SCRIPT_CommandTextPtr,-(A7)
    MOVE.L  440(A3),-(A7)
    JSR     _ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,_SCRIPT_CommandTextPtr
    MOVE.W  2(A3),_SCRIPT_PrimarySearchFirstFlag
    MOVE.W  4(A3),_TEXTDISP_PrimaryChannelCode
    MOVE.W  6(A3),_TEXTDISP_SecondaryChannelCode
    LEA     26(A3),A0
    LEA     _TEXTDISP_PrimarySearchText,A1

.ctrl_context_load_copy_primary_search:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .ctrl_context_load_copy_primary_search

    LEA     226(A3),A0
    LEA     _TEXTDISP_SecondarySearchText,A1

.ctrl_context_load_copy_secondary_search:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .ctrl_context_load_copy_secondary_search

    MOVE.W  8(A3),_TEXTDISP_CurrentMatchIndex
    MOVE.W  10(A3),_SCRIPT_ChannelRangeArmedFlag
    MOVE.W  12(A3),_TEXTDISP_ChannelSourceMode
    MOVE.W  14(A3),_SCRIPT_ChannelRangeDigitChar
    MOVE.L  16(A3),_SCRIPT_SearchMatchCountOrIndex
    MOVE.L  20(A3),_SCRIPT_PlaybackCursor
    MOVE.W  _SCRIPT_RuntimeMode,D0
    SUBQ.W  #2,D0
    BNE.S   .ctrl_context_load_runtime_gate

    MOVE.W  24(A3),D0
    MOVEQ   #3,D1
    CMP.W   D1,D0
    BEQ.S   .ctrl_context_load_apply_saved_mode

.ctrl_context_load_runtime_gate:
    MOVE.W  _SCRIPT_RuntimeMode,D0
    BNE.S   .ctrl_context_load_copy_active_group

    MOVE.W  24(A3),D0
    MOVEQ   #1,D1
    CMP.W   D1,D0
    BNE.S   .ctrl_context_load_copy_active_group

.ctrl_context_load_apply_saved_mode:
    MOVE.W  D0,_SCRIPT_RuntimeMode

.ctrl_context_load_copy_active_group:
    MOVE.W  426(A3),_TEXTDISP_ActiveGroupId
    MOVEQ   #0,D7

.ctrl_context_load_copy_shadow_bytes_loop:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.S   .return

    LEA     _TEXTDISP_BannerFallbackEntryIndex,A0
    ADDA.L  D7,A0
    MOVE.L  D7,D0
    ADDI.L  #$1ac,D0
    MOVE.B  0(A3,D0.L),(A0)
    LEA     _TEXTDISP_BannerSelectedEntryIndex,A0
    ADDA.L  D7,A0
    MOVE.L  D7,D0
    ADDI.L  #$1b0,D0
    MOVE.B  0(A3,D0.L),(A0)
    ADDQ.L  #1,D7
    BRA.S   .ctrl_context_load_copy_shadow_bytes_loop

.return:
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_SaveCtrlContextSnapshot   (SaveCtrlContextSnapshot)
; ARGS:
;   stack +12: ctxPtr (A3)
; RET:
;   D0: none
; CLOBBERS:
;   A0/A1/A3/A7/D0/D7
; CALLS:
;   _ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString
; READS:
;   _SCRIPT_Type20SubtypeCache, _SCRIPT_PendingWeatherCommandChar, _SCRIPT_PendingTextdispCmdChar, _SCRIPT_PendingTextdispCmdArg, _SCRIPT_CommandTextPtr, _TEXTDISP_ActiveGroupId, _SCRIPT_RuntimeMode, _TEXTDISP_PrimarySearchText, _TEXTDISP_SecondarySearchText, _TEXTDISP_PrimaryChannelCode, _TEXTDISP_SecondaryChannelCode, _SCRIPT_ChannelRangeDigitChar, _SCRIPT_SearchMatchCountOrIndex, _SCRIPT_PlaybackCursor, _SCRIPT_PrimarySearchFirstFlag, _SCRIPT_ChannelRangeArmedFlag, _TEXTDISP_CurrentMatchIndex, _TEXTDISP_ChannelSourceMode, _TEXTDISP_BannerFallbackEntryIndex, _TEXTDISP_BannerSelectedEntryIndex
; WRITES:
;   Context fields at A3+2/+4/+6/+8/+10/+12/+14/+16/+20/+24/+26/+226/+426/+436..+440 and A3+0x1AC..0x1B3
; DESC:
;   Saves live script/text-display globals back into the CTRL context block.
;------------------------------------------------------------------------------
SCRIPT_SaveCtrlContextSnapshot:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3

    MOVE.B  _SCRIPT_Type20SubtypeCache,436(A3)
    MOVE.B  _SCRIPT_PendingWeatherCommandChar,437(A3)
    MOVE.B  _SCRIPT_PendingTextdispCmdChar,438(A3)
    MOVE.B  _SCRIPT_PendingTextdispCmdArg,439(A3)
    MOVE.L  440(A3),-(A7)
    MOVE.L  _SCRIPT_CommandTextPtr,-(A7)
    JSR     _ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,440(A3)
    MOVE.W  _SCRIPT_PrimarySearchFirstFlag,2(A3)
    MOVE.W  _TEXTDISP_PrimaryChannelCode,4(A3)
    MOVE.W  _TEXTDISP_SecondaryChannelCode,6(A3)
    LEA     26(A3),A0
    LEA     _TEXTDISP_PrimarySearchText,A1

.ctrl_context_save_copy_primary_search:
    MOVE.B  (A1)+,(A0)+
    BNE.S   .ctrl_context_save_copy_primary_search

    LEA     226(A3),A0
    LEA     _TEXTDISP_SecondarySearchText,A1

.ctrl_context_save_copy_secondary_search:
    MOVE.B  (A1)+,(A0)+
    BNE.S   .ctrl_context_save_copy_secondary_search

    MOVE.W  _TEXTDISP_CurrentMatchIndex,8(A3)
    MOVE.W  _SCRIPT_ChannelRangeArmedFlag,10(A3)
    MOVE.W  _TEXTDISP_ChannelSourceMode,12(A3)
    MOVE.W  _SCRIPT_ChannelRangeDigitChar,14(A3)
    MOVE.L  _SCRIPT_SearchMatchCountOrIndex,16(A3)
    MOVE.L  _SCRIPT_PlaybackCursor,20(A3)
    MOVE.W  _SCRIPT_RuntimeMode,24(A3)
    MOVE.W  _TEXTDISP_ActiveGroupId,426(A3)
    MOVEQ   #0,D7

.ctrl_context_save_copy_shadow_bytes_loop:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.S   .return

    LEA     _TEXTDISP_BannerFallbackEntryIndex,A0
    ADDA.L  D7,A0
    MOVE.L  D7,D0
    ADDI.L  #$1ac,D0
    MOVE.B  (A0),0(A3,D0.L)
    LEA     _TEXTDISP_BannerSelectedEntryIndex,A0
    ADDA.L  D7,A0
    MOVE.L  D7,D0
    ADDI.L  #$1b0,D0
    MOVE.B  (A0),0(A3,D0.L)
    ADDQ.L  #1,D7
    BRA.S   .ctrl_context_save_copy_shadow_bytes_loop

.return:
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_ResetCtrlContextAndClearStatusLine   (ResetCtrlContextAndClearStatusLine)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   A7/D0
; CALLS:
;   _SCRIPT_ResetCtrlContext, _TEXTDISP_HandleScriptCommand
; READS:
;   _SCRIPT_CTRL_CONTEXT
; WRITES:
;   _SCRIPT_CTRL_CONTEXT (via _SCRIPT_ResetCtrlContext)
; DESC:
;   Clears the status line via _TEXTDISP_HandleScriptCommand and reinitializes
;   _SCRIPT_CTRL_CONTEXT.
;------------------------------------------------------------------------------
SCRIPT_ResetCtrlContextAndClearStatusLine:
    CLR.L   -(A7)
    MOVEQ   #0,D0
    NOT.B   D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    JSR     _TEXTDISP_HandleScriptCommand(PC)

    PEA     _SCRIPT_CTRL_CONTEXT
    BSR.W   _SCRIPT_ResetCtrlContext

    LEA     16(A7),A7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT3_JMPTBL_LOCAVAIL_UpdateFilterStateMachine   (Routine at SCRIPT3_JMPTBL_LOCAVAIL_UpdateFilterStateMachine)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   LOCAVAIL_UpdateFilterStateMachine
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
SCRIPT3_JMPTBL_LOCAVAIL_UpdateFilterStateMachine:
    JMP     LOCAVAIL_UpdateFilterStateMachine

;------------------------------------------------------------------------------
; FUNC: SCRIPT3_JMPTBL_MATH_DivS32   (Routine at SCRIPT3_JMPTBL_MATH_DivS32)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _MATH_DivS32
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
SCRIPT3_JMPTBL_MATH_DivS32:
    BRA.W   _MATH_DivS32

;------------------------------------------------------------------------------
; FUNC: _SCRIPT3_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   ESQSHARED_ApplyProgramTitleTextFilters
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to ESQSHARED_ApplyProgramTitleTextFilters.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_SCRIPT3_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters:
    JMP     ESQSHARED_ApplyProgramTitleTextFilters

;------------------------------------------------------------------------------
; FUNC: SCRIPT3_JMPTBL_STRING_CompareN   (Routine at SCRIPT3_JMPTBL_STRING_CompareN)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   STRING_CompareN
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
SCRIPT3_JMPTBL_STRING_CompareN:
    BRA.W   STRING_CompareN

;------------------------------------------------------------------------------
; FUNC: _SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   ESQDISP_UpdateStatusMaskAndRefresh
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to ESQDISP_UpdateStatusMaskAndRefresh.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh:
    JMP     ESQDISP_UpdateStatusMaskAndRefresh

;------------------------------------------------------------------------------
; FUNC: _SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar   (JumpStub_GCOMMAND_GetBannerChar)
; ARGS:
;   (none)
; RET:
;   D0: banner char (see _GCOMMAND_GetBannerChar)
; CLOBBERS:
;   (none)
; CALLS:
;   _GCOMMAND_GetBannerChar
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _GCOMMAND_GetBannerChar.
;------------------------------------------------------------------------------
_SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar:
    JMP     _GCOMMAND_GetBannerChar

;------------------------------------------------------------------------------
; FUNC: _SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit   (JumpStub_LADFUNC_ParseHexDigit)
; ARGS:
;   (none)
; RET:
;   D0: parsed digit (see LADFUNC_ParseHexDigit)
; CLOBBERS:
;   (none)
; CALLS:
;   LADFUNC_ParseHexDigit
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LADFUNC_ParseHexDigit.
;------------------------------------------------------------------------------
_SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit:
    JMP     LADFUNC_ParseHexDigit

;------------------------------------------------------------------------------
; FUNC: SCRIPT3_JMPTBL_ESQPARS_ApplyRtcBytesAndPersist   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   ESQPARS_ApplyRtcBytesAndPersist
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to ESQPARS_ApplyRtcBytesAndPersist.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
SCRIPT3_JMPTBL_ESQPARS_ApplyRtcBytesAndPersist:
    JMP     ESQPARS_ApplyRtcBytesAndPersist

;------------------------------------------------------------------------------
; FUNC: SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt   (JumpStub_PARSE_ReadSignedLongSkipClass3_Alt)
; ARGS:
;   (none)
; RET:
;   D0: parsed value (see _PARSE_ReadSignedLongSkipClass3_Alt)
; CLOBBERS:
;   (none)
; CALLS:
;   _PARSE_ReadSignedLongSkipClass3_Alt
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _PARSE_ReadSignedLongSkipClass3_Alt.
;------------------------------------------------------------------------------
SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt:
    BRA.W   _PARSE_ReadSignedLongSkipClass3_Alt

;------------------------------------------------------------------------------
; FUNC: _SCRIPT3_JMPTBL_GCOMMAND_AdjustBannerCopperOffset   (JumpStub_GCOMMAND_AdjustBannerCopperOffset)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   GCOMMAND_AdjustBannerCopperOffset
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to GCOMMAND_AdjustBannerCopperOffset.
;------------------------------------------------------------------------------
_SCRIPT3_JMPTBL_GCOMMAND_AdjustBannerCopperOffset:
    JMP     GCOMMAND_AdjustBannerCopperOffset

;------------------------------------------------------------------------------
; FUNC: SCRIPT3_JMPTBL_ESQ_SetCopperEffect_Custom   (JumpStub_ESQ_SetCopperEffect_Custom)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   ESQ_SetCopperEffect_Custom
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to ESQ_SetCopperEffect_Custom.
;------------------------------------------------------------------------------
SCRIPT3_JMPTBL_ESQ_SetCopperEffect_Custom:
    JMP     ESQ_SetCopperEffect_Custom

;------------------------------------------------------------------------------
; FUNC: SCRIPT3_JMPTBL_CLEANUP_RenderAlignedStatusScreen   (JumpStub_CLEANUP_RenderAlignedStatusScreen)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   CLEANUP_RenderAlignedStatusScreen
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to CLEANUP_RenderAlignedStatusScreen.
;------------------------------------------------------------------------------
SCRIPT3_JMPTBL_CLEANUP_RenderAlignedStatusScreen:
    JMP     CLEANUP_RenderAlignedStatusScreen

;------------------------------------------------------------------------------
; FUNC: SCRIPT3_JMPTBL_LOCAVAIL_ComputeFilterOffsetForEntry   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   LOCAVAIL_ComputeFilterOffsetForEntry
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LOCAVAIL_ComputeFilterOffsetForEntry.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
SCRIPT3_JMPTBL_LOCAVAIL_ComputeFilterOffsetForEntry:
    JMP     LOCAVAIL_ComputeFilterOffsetForEntry

;------------------------------------------------------------------------------
; FUNC: SCRIPT3_JMPTBL_MATH_Mulu32   (Routine at SCRIPT3_JMPTBL_MATH_Mulu32)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _MATH_Mulu32
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
SCRIPT3_JMPTBL_MATH_Mulu32:
    BRA.W   _MATH_Mulu32

;------------------------------------------------------------------------------
; FUNC: SCRIPT3_JMPTBL_LOCAVAIL_SetFilterModeAndResetState   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   LOCAVAIL_SetFilterModeAndResetState
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LOCAVAIL_SetFilterModeAndResetState.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
SCRIPT3_JMPTBL_LOCAVAIL_SetFilterModeAndResetState:
    JMP     LOCAVAIL_SetFilterModeAndResetState

;------------------------------------------------------------------------------
; FUNC: SCRIPT3_JMPTBL_STRING_CopyPadNul   (JumpStub_STRING_CopyPadNul)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   _STRING_CopyPadNul
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _STRING_CopyPadNul.
;------------------------------------------------------------------------------
SCRIPT3_JMPTBL_STRING_CopyPadNul:
    BRA.W   _STRING_CopyPadNul
