    XDEF    _SCRIPT_DispatchPlaybackCursorCommand


;------------------------------------------------------------------------------
; FUNC: _SCRIPT_DispatchPlaybackCursorCommand   (DispatchPlaybackCursorCommand)
; ARGS:
;   stack +8: playbackCursorPtr (long *)
; RET:
;   D0: none
; CLOBBERS:
;   A3/A7/D0/D1
; CALLS:
;   _SCRIPT_UpdateSerialShadowFromCtrlByte, _SCRIPT_ClearSearchTextsAndChannels, _TEXTDISP_ResetSelectionAndRefresh, _WDISP_HandleWeatherStatusCommand, _SCRIPT3_JMPTBL_CLEANUP_RenderAlignedStatusScreen, _SCRIPT3_JMPTBL_ESQ_SetCopperEffect_Custom, _SCRIPT_AssertCtrlLineNow, _TEXTDISP_HandleScriptCommand, _TEXTDISP_SetRastForMode, _WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight
; READS:
;   _CONFIG_BannerCopperHeadByte, _CONFIG_MSN_FlagChar, _TEXTDISP_DeferredActionCountdown, _SCRIPT_PlaybackFallbackCounter, _SCRIPT_PendingWeatherCommandChar, _SCRIPT_PendingTextdispCmdChar, _SCRIPT_PendingTextdispCmdArg, _SCRIPT_CommandTextPtr, _SCRIPT_ChannelRangeDigitChar, _SCRIPT_SearchMatchCountOrIndex, _TEXTDISP_ChannelSourceMode
; WRITES:
;   _TEXTDISP_DeferredActionCountdown, _TEXTDISP_DeferredActionArmed, _ESQPARS2_ReadModeFlags, _SCRIPT_PlaybackFallbackCounter, _SCRIPT_PendingBannerTargetChar, _SCRIPT_PendingBannerSpeedMs, _SCRIPT_ReadModeActiveLatch, _SCRIPT_RuntimeMode, _TEXTDISP_CurrentMatchIndex
; DESC:
;   Dispatches command behavior from *playbackCursorPtr using a compiler
;   switch/jumptable and clears the command slot afterward.
; NOTES:
;   Valid dispatch range is cursor values 1..15.
;------------------------------------------------------------------------------
_SCRIPT_DispatchPlaybackCursorCommand:
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
    MOVE.W  #1,_SCRIPT_ReadModeActiveLatch
    MOVE.W  #256,_ESQPARS2_ReadModeFlags
    BRA.W   .return

.playback_cmd_case_set_read_mode_off:
    MOVEQ   #0,D0
    MOVE.W  D0,_SCRIPT_ReadModeActiveLatch
    MOVE.W  D0,_ESQPARS2_ReadModeFlags
    BRA.W   .return

.playback_cmd_case_highlight_and_banner_plus28:
    JSR     _WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(PC)

    CLR.L   -(A7)
    JSR     _TEXTDISP_SetRastForMode(PC)

    ADDQ.W  #4,A7
    MOVE.W  _CONFIG_BannerCopperHeadByte,D0
    ADDI.W  #28,D0
    MOVE.W  #1000,_SCRIPT_PendingBannerSpeedMs
    MOVE.W  D0,_SCRIPT_PendingBannerTargetChar
    BRA.W   .return

.playback_cmd_case_banner_current:
    MOVE.W  _CONFIG_BannerCopperHeadByte,D0
    MOVE.W  #1000,_SCRIPT_PendingBannerSpeedMs
    MOVE.W  D0,_SCRIPT_PendingBannerTargetChar
    BRA.W   .return

.playback_cmd_case_custom_copper_effect:
    JSR     _SCRIPT3_JMPTBL_ESQ_SetCopperEffect_Custom(PC)

    BRA.W   .return

.playback_cmd_case_reset_selection:
    JSR     _TEXTDISP_ResetSelectionAndRefresh(PC)

    BRA.W   .return

.playback_cmd_case_enter_mode2_and_shadow:
    MOVE.W  #(-1),_TEXTDISP_CurrentMatchIndex
    JSR     _WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(PC)

    CLR.L   -(A7)
    JSR     _TEXTDISP_SetRastForMode(PC)

    ADDQ.W  #4,A7
    MOVE.B  _CONFIG_MSN_FlagChar,D0
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
    JSR     _WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(PC)

    CLR.L   -(A7)
    JSR     _TEXTDISP_SetRastForMode(PC)

    PEA     1.W
    JSR     _SCRIPT_UpdateSerialShadowFromCtrlByte(PC)

    ADDQ.W  #8,A7
    BRA.W   .return

.playback_cmd_case_enter_mode2_defer
    MOVE.W  #(-1),_TEXTDISP_CurrentMatchIndex
    MOVE.W  _TEXTDISP_DeferredActionCountdown,D0
    BNE.W   .return

    PEA     3.W
    JSR     _SCRIPT_UpdateSerialShadowFromCtrlByte(PC)

    ADDQ.W  #4,A7
    MOVE.W  #3,_TEXTDISP_DeferredActionCountdown
    MOVE.W  #1,_TEXTDISP_DeferredActionArmed
    BRA.W   .return

.playback_cmd_case_render_aligned_current:
    MOVE.W  _TEXTDISP_ChannelSourceMode,D0
    EXT.L   D0
    MOVE.W  _SCRIPT_ChannelRangeDigitChar,D1
    EXT.L   D1
    CLR.L   -(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     _SCRIPT3_JMPTBL_CLEANUP_RenderAlignedStatusScreen(PC)

    LEA     12(A7),A7
    BRA.W   .return

.playback_cmd_case_render_aligned_primary:
    MOVE.L  _SCRIPT_SearchMatchCountOrIndex,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     53.W
    PEA     1.W
    JSR     _SCRIPT3_JMPTBL_CLEANUP_RenderAlignedStatusScreen(PC)

    LEA     12(A7),A7
    BRA.W   .return

.playback_cmd_case_render_aligned_secondary:
    MOVE.L  _SCRIPT_SearchMatchCountOrIndex,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     53.W
    CLR.L   -(A7)
    JSR     _SCRIPT3_JMPTBL_CLEANUP_RenderAlignedStatusScreen(PC)

    LEA     12(A7),A7
    BRA.S   .return

.playback_cmd_case_weather_status:
    MOVE.W  #(-1),_TEXTDISP_CurrentMatchIndex
    MOVEQ   #0,D0
    MOVE.B  _SCRIPT_PendingWeatherCommandChar,D0
    MOVE.L  D0,-(A7)
    JSR     _WDISP_HandleWeatherStatusCommand(PC)

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
    JSR     _SCRIPT_AssertCtrlLineNow(PC)

    MOVE.W  #1,_SCRIPT_RuntimeMode
    BRA.S   .return

.playback_cmd_case_default_increment:
    MOVE.W  #(-1),_TEXTDISP_CurrentMatchIndex
    MOVE.W  _SCRIPT_PlaybackFallbackCounter,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_SCRIPT_PlaybackFallbackCounter

.return:
    BSR.W   _SCRIPT_ClearSearchTextsAndChannels

    CLR.L   (A3)
    MOVEA.L (A7)+,A3
    RTS

;!======