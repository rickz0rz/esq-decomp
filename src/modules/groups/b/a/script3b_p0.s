    XDEF    SCRIPT_ApplyPendingBannerTarget
    XDEF    SCRIPT_UpdateCtrlStateMachine
    XDEF    SCRIPT_UpdateRuntimeModeForPlaybackCursor



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
;   _CONFIG_BannerCopperHeadByte, _SCRIPT_PendingBannerTargetChar, _SCRIPT_PendingBannerSpeedMs, _SCRIPT_ReadModeActiveLatch
; WRITES:
;   _ESQPARS2_ReadModeFlags, _SCRIPT_PendingBannerTargetChar, _SCRIPT_ReadModeActiveLatch
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
    CMP.W   _SCRIPT_PendingBannerTargetChar,D0
    BNE.S   .check_specific_pending_target

    MOVEQ   #-1,D0
    MOVE.W  D0,_SCRIPT_PendingBannerTargetChar
    BRA.S   .maybe_clear_readmode_flags

.check_specific_pending_target:
    MOVE.W  _SCRIPT_PendingBannerTargetChar,D0
    MOVEQ   #-1,D1
    CMP.W   D1,D0
    BEQ.S   .compare_against_default_target

    EXT.L   D0
    MOVE.W  _SCRIPT_PendingBannerSpeedMs,D1
    MOVEQ   #0,D2
    MOVE.W  D1,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   SCRIPT_BeginBannerCharTransition

    ADDQ.W  #8,A7
    MOVE.W  #(-1),_SCRIPT_PendingBannerTargetChar
    BRA.S   .maybe_clear_readmode_flags

.compare_against_default_target:
    MOVE.W  _CONFIG_BannerCopperHeadByte,D0
    CMP.W   D0,D7
    BEQ.S   .maybe_clear_readmode_flags

    EXT.L   D0
    MOVE.W  _SCRIPT_PendingBannerSpeedMs,D1
    MOVEQ   #0,D2
    MOVE.W  D1,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   SCRIPT_BeginBannerCharTransition

    ADDQ.W  #8,A7
    MOVE.W  #(-1),_SCRIPT_PendingBannerTargetChar

.maybe_clear_readmode_flags:
    TST.W   _SCRIPT_ReadModeActiveLatch
    BEQ.S   .return

    MOVEQ   #0,D0
    MOVE.W  D0,_ESQPARS2_ReadModeFlags
    MOVE.W  D0,_SCRIPT_ReadModeActiveLatch

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
;   _SCRIPT_UpdateSerialShadowFromCtrlByte, _SCRIPT_ClearSearchTextsAndChannels, SCRIPT_BeginBannerCharTransition, SCRIPT_DeassertCtrlLineNow, _TEXTDISP_SetRastForMode, _WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight
; READS:
;   _CONFIG_BannerCopperHeadByte, CONFIG_RuntimeMode12BannerJumpEnabledFlag, CONFIG_MsnRuntimeModeSelectorChar_LRBN, _CONFIG_MSN_FlagChar, _SCRIPT_RuntimeMode
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
    JSR     _WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(PC)

    CLR.L   -(A7)
    JSR     _TEXTDISP_SetRastForMode(PC)

    ADDQ.W  #4,A7
    MOVE.B  _CONFIG_MSN_FlagChar,D0
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
;   SCRIPT_DeassertCtrlLineNow, _TEXTDISP_ResetSelectionAndRefresh, _STR_FindCharPtr, _SCRIPT_ReadHandshakeBit3Flag
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

    JSR     _TEXTDISP_ResetSelectionAndRefresh(PC)

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

    JSR     _SCRIPT_ReadHandshakeBit3Flag(PC)

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