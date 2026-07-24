    XDEF    _NEWGRID_GetGridModeIndex

;------------------------------------------------------------------------------
; FUNC: _NEWGRID_GetGridModeIndex   (Return grid mode index)
; ARGS:
;   (none)
; RET:
;   D0: mode index (1 or 6)
; CLOBBERS:
;   D0/D7
; CALLS:
;   none
; READS:
;   _NEWGRID_ModeSelectorState
; WRITES:
;   none
; DESC:
;   Returns 1 when _NEWGRID_ModeSelectorState==1, otherwise 6.
; NOTES:
;   Simple helper for mode selection.
;------------------------------------------------------------------------------
_NEWGRID_GetGridModeIndex:
    MOVE.L  D7,-(A7)
    MOVEQ   #1,D0
    CMP.L   _NEWGRID_ModeSelectorState,D0
    BEQ.S   .done

    MOVEQ   #6,D0

.done:
    MOVE.L  D0,D7
    MOVE.L  D7,D0
    MOVE.L  (A7)+,D7
    RTS

;!======
