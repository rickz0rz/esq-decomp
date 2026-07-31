    XDEF    _DATETIME_CopyPairAndRecalc



;------------------------------------------------------------------------------
; FUNC: _DATETIME_CopyPairAndRecalc   (Copy two date structs and recalc)
; ARGS:
;   stack +8: A3 = dest struct
;   stack +12: A2 = src1 pointer
;   stack +16: A0 = src2 pointer
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A7/D0
; CALLS:
;   _DATETIME_NormalizeStructToSeconds
; READS:
;   A2, A0
; WRITES:
;   A3+0/4/8/12
; DESC:
;   Copies two 22-byte blocks into A3 and recalculates time values.
; NOTES:
;   DBF loops run (Dn+1) iterations (22 bytes).
;------------------------------------------------------------------------------
_DATETIME_CopyPairAndRecalc:
    LINK.W  A5,#0
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  A3,D0
    BEQ.S   .return

    TST.L   (A3)
    BEQ.S   .return

    TST.L   4(A3)
    BEQ.S   .return

    MOVEQ   #21,D0
    MOVEA.L A2,A0
    MOVEA.L (A3),A1

.copy_first_loop:
    MOVE.B  (A0)+,(A1)+
    DBF     D0,.copy_first_loop
    MOVEQ   #21,D0
    MOVEA.L 16(A5),A0
    MOVEA.L 4(A3),A1

.copy_second_loop:
    MOVE.B  (A0)+,(A1)+
    DBF     D0,.copy_second_loop
    MOVE.L  A2,-(A7)
    BSR.W   _DATETIME_NormalizeStructToSeconds

    MOVE.L  D0,8(A3)
    MOVE.L  16(A5),(A7)
    BSR.W   _DATETIME_NormalizeStructToSeconds

    ADDQ.W  #4,A7
    MOVE.L  D0,12(A3)

.return:
    MOVEM.L (A7)+,A2-A3
    UNLK    A5
    RTS

;!======