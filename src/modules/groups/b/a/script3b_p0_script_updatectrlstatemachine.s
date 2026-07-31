    XDEF    _SCRIPT_UpdateCtrlStateMachine


;------------------------------------------------------------------------------
; FUNC: _SCRIPT_UpdateCtrlStateMachine   (Update ctrl-line runtime state machine)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1
; CALLS:
;   _SCRIPT_DeassertCtrlLineNow, _TEXTDISP_ResetSelectionAndRefresh, _STR_FindCharPtr, _SCRIPT_ReadHandshakeBit3Flag
; READS:
;   _SCRIPT_RuntimeMode, _SCRIPT_CtrlHandshakeStage, _SCRIPT_CtrlHandshakeRetryCount, _ED_DiagVinModeChar, _Global_UIBusyFlag
; WRITES:
;   _SCRIPT_RuntimeMode, _SCRIPT_CtrlHandshakeStage, _SCRIPT_CtrlHandshakeRetryCount
; DESC:
;   Advances a small control state machine and triggers follow-up actions when
;   counters hit thresholds.
; NOTES:
;   Uses _ED_DiagVinModeChar via _STR_FindCharPtr to probe a control flag string.
;------------------------------------------------------------------------------
_SCRIPT_UpdateCtrlStateMachine:
    BSR.W   SCRIPT_RefreshCtrlState

    MOVE.W  _SCRIPT_RuntimeMode,D0
    SUBQ.W  #2,D0
    BNE.S   .reset_state

    MOVE.W  _SCRIPT_CtrlHandshakeStage,D0
    SUBQ.W  #1,D0
    BNE.S   .check_state_two

    MOVE.W  _SCRIPT_CtrlHandshakeRetryCount,D0
    MOVE.L  D0,D1
    ADDQ.W  #1,D1
    MOVE.W  D1,_SCRIPT_CtrlHandshakeRetryCount
    MOVEQ   #3,D0
    CMP.W   D0,D1
    BLT.S   .return_status

    CLR.W   _SCRIPT_CtrlHandshakeRetryCount
    MOVE.W  D0,_SCRIPT_RuntimeMode
    JSR     _SCRIPT_DeassertCtrlLineNow(PC)

    JSR     _TEXTDISP_ResetSelectionAndRefresh(PC)

    BRA.S   .return_status

.check_state_two:
    MOVE.W  _SCRIPT_CtrlHandshakeStage,D0
    SUBQ.W  #2,D0
    BNE.S   .check_banner_active

    MOVEQ   #0,D0
    MOVE.W  D0,_SCRIPT_CtrlHandshakeRetryCount
    BRA.S   .return_status

.check_banner_active:
    TST.W   _Global_UIBusyFlag
    BEQ.S   .return_status

    MOVE.W  #3,_SCRIPT_RuntimeMode
    BRA.S   .return_status

.reset_state:
    CLR.W   _SCRIPT_CtrlHandshakeRetryCount

.return_status:
    RTS

;!======