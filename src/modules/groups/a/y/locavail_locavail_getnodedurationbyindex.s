    XDEF    _LOCAVAIL_GetNodeDurationByIndex


    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVE.L  20(A7),D7
    MOVEQ   #0,D6
    MOVE.L  A3,D0
    BEQ.S   _LOCAVAIL_GetNodeDurationByIndex

    TST.L   D7
    BMI.S   _LOCAVAIL_GetNodeDurationByIndex

    CMP.L   2(A3),D7
    BGE.S   _LOCAVAIL_GetNodeDurationByIndex

    MOVE.L  D7,D0
    MOVEQ   #10,D1
    JSR     _NEWGRID_JMPTBL_MATH_Mulu32(PC)

    MOVEA.L 20(A3),A0
    ADDA.L  D0,A0
    MOVE.W  2(A0),D6

;------------------------------------------------------------------------------
; FUNC: _LOCAVAIL_GetNodeDurationByIndex   (Return node duration by index with bounds checks)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/D6
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Returns node duration word (+2) for valid index, else returns 0.
; NOTES:
;   Handles NULL state pointer and out-of-range indices as empty result.
;------------------------------------------------------------------------------
_LOCAVAIL_GetNodeDurationByIndex:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======