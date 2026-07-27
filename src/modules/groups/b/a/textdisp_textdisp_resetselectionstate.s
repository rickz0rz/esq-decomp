    XDEF    _TEXTDISP_ResetSelectionState


;------------------------------------------------------------------------------
; FUNC: _TEXTDISP_ResetSelectionState   (Reset selection fields)
; ARGS:
;   stack +8: entryPtr (A3)
; RET:
;   none
; CLOBBERS:
;   D0/A3
; WRITES:
;   entry+210, entry+214, entry+218, entry+220
; DESC:
;   Initializes selection state fields to defaults (-1/0) for an entry.
; NOTES:
;   Uses mode=3 and clears pending flags.
;------------------------------------------------------------------------------
_TEXTDISP_ResetSelectionState:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    MOVE.L  A3,D0
    BEQ.S   .return

    MOVEQ   #3,D0
    MOVE.L  D0,210(A3)
    MOVEQ   #-1,D0
    MOVE.L  D0,214(A3)
    MOVE.W  #(-1),218(A3)
    CLR.B   220(A3)

.return:
    MOVEA.L (A7)+,A3
    RTS

;!======