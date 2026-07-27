    XDEF    _P_TYPE_GetSubtypeIfType20


;------------------------------------------------------------------------------
; FUNC: _P_TYPE_GetSubtypeIfType20   (Return subtype byte for type-20 entries)
; ARGS:
;   stack +8: entryPtr (struct PTypeEntry *)
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A7/D0/D7
; CALLS:
;   (none)
; READS:
;   entry type byte at +0, subtype byte at +1
; WRITES:
;   (none observed)
; DESC:
;   Returns entry[1] only when entry exists, entry[0]==20, and entry[1]!=0.
; NOTES:
;   Returns 0 for non-type-20 entries or missing subtype.
;------------------------------------------------------------------------------
_P_TYPE_GetSubtypeIfType20:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEQ   #0,D7
    MOVE.L  A3,D0
    BEQ.S   .return_136E

    MOVEQ   #20,D0
    CMP.B   (A3),D0
    BNE.S   .return_136E

    TST.B   1(A3)
    BEQ.S   .return_136E

    MOVE.B  1(A3),D7

.return_136E:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A3
    RTS

;!======