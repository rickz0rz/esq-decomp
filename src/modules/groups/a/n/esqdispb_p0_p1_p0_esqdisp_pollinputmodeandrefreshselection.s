    XDEF    _ESQDISP_PollInputModeAndRefreshSelection


;------------------------------------------------------------------------------
; FUNC: _ESQDISP_PollInputModeAndRefreshSelection   (Debounce input mode and refresh selection)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A5/A7/D0/D1/D7
; CALLS:
;   _ESQFUNC_JMPTBL_TEXTDISP_ResetSelectionAndRefresh, _ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode
; READS:
;   _ESQDISP_LatchedInputModeBit, bfd0ee
; WRITES:
;   _ESQDISP_LatchedInputModeBit, _ESQDISP_InputModeDebounceCount, _Global_RefreshTickCounter
; DESC:
;   Polls CIAB input mode bits with debounce; when stable change is detected,
;   updates mode state and either resets selection or redraws rast mode.
; NOTES:
;   Requires >5 consecutive polls before committing mode change.
;------------------------------------------------------------------------------
_ESQDISP_PollInputModeAndRefreshSelection:
    LINK.W  A5,#-8
    MOVE.L  D7,-(A7)
    MOVE.W  #(-1),_Global_RefreshTickCounter
    MOVE.L  #$bfd0ee,-6(A5) ; uncertain, between PRA_CIAB and PRB_CIAB
    MOVEQ   #4,D7
    MOVEA.L -6(A5),A0
    AND.B   (A0),D7
    MOVE.B  _ESQDISP_LatchedInputModeBit,D0
    CMP.B   D7,D0
    BEQ.S   .lab_092D

    ADDQ.L  #1,_ESQDISP_InputModeDebounceCount
    BRA.S   .lab_092E

.lab_092D:
    MOVEQ   #0,D0
    MOVE.L  D0,_ESQDISP_InputModeDebounceCount

.lab_092E:
    CMPI.L  #$5,_ESQDISP_InputModeDebounceCount
    BLE.S   .return

    MOVE.L  D7,D0
    MOVE.B  D0,_ESQDISP_LatchedInputModeBit
    MOVEQ   #0,D1
    MOVE.L  D1,_ESQDISP_InputModeDebounceCount
    TST.B   D0
    BNE.S   .lab_092F

    MOVE.L  D1,-(A7)
    JSR     _ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode(PC)

    ADDQ.W  #4,A7
    BRA.S   .return

.lab_092F:
    JSR     _ESQFUNC_JMPTBL_TEXTDISP_ResetSelectionAndRefresh(PC)

.return:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======