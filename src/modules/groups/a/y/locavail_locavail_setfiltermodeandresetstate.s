    XDEF    _LOCAVAIL_SetFilterModeAndResetState


;------------------------------------------------------------------------------
; FUNC: _LOCAVAIL_SetFilterModeAndResetState   (Apply filter mode change and reset cursors)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D7
; CALLS:
;   (none)
; READS:
;   _LOCAVAIL_FilterModeFlag, _LOCAVAIL_PrimaryFilterState
; WRITES:
;   _LOCAVAIL_FilterModeFlag
; DESC:
;   Updates `_LOCAVAIL_FilterModeFlag` only for supported mode values (0/1) and
;   resets primary filter cursor state when mode actually changes.
; NOTES:
;   Ignores unsupported mode values and no-op transitions.
;------------------------------------------------------------------------------
_LOCAVAIL_SetFilterModeAndResetState:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7
    MOVE.L  _LOCAVAIL_FilterModeFlag,D0
    CMP.L   D7,D0
    BEQ.S   .return

    MOVEQ   #1,D0
    CMP.L   D0,D7
    BEQ.S   .set_mode_and_reset

    TST.L   D7
    BNE.S   .return

.set_mode_and_reset:
    MOVE.L  D7,_LOCAVAIL_FilterModeFlag
    PEA     _LOCAVAIL_PrimaryFilterState
    BSR.S   _LOCAVAIL_ResetFilterCursorState

    ADDQ.W  #4,A7

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======