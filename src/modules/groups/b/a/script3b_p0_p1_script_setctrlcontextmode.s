    XDEF    _SCRIPT_SetCtrlContextMode



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