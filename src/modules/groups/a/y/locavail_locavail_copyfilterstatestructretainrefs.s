    XDEF    _LOCAVAIL_CopyFilterStateStructRetainRefs


;------------------------------------------------------------------------------
; FUNC: _LOCAVAIL_CopyFilterStateStructRetainRefs   (Copy filter state while retaining shared refs)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A0/A2/A3/A7
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   destination state fields at A3; increments shared refcount when present
; DESC:
;   Copies scalar state plus shared-header/node-array pointers from source to
;   destination and bumps shared refcount for retained shared resources.
; NOTES:
;   Shallow copy by design for retained arrays.
;------------------------------------------------------------------------------
_LOCAVAIL_CopyFilterStateStructRetainRefs:
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEA.L 16(A7),A2
    MOVE.B  (A2),(A3)
    MOVE.L  2(A2),2(A3)
    MOVE.B  6(A2),6(A3)
    MOVEA.L 16(A2),A0
    MOVE.L  A0,16(A3)
    MOVE.L  20(A2),20(A3)
    TST.L   16(A3)
    BEQ.S   .return

    MOVEA.L 16(A3),A0
    ADDQ.L  #1,(A0)

.return:
    MOVEM.L (A7)+,A2-A3
    RTS

;!======