    XDEF    _P_TYPE_CloneEntry



;------------------------------------------------------------------------------
; FUNC: _P_TYPE_CloneEntry   (Deep-copy entry and payload)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +96: arg_3 (via 100(A5))
; CLOBBERS:
;   A0/A2/A3/A7/D0/D7
; CALLS:
;   _P_TYPE_FreeEntry, _P_TYPE_AllocateEntry
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Frees destination entry first, then deep-copies source payload into a newly
;   allocated destination entry.
; NOTES:
;   Uses a fixed local scratch buffer for payload copy before reallocation.
;------------------------------------------------------------------------------
_P_TYPE_CloneEntry:
    LINK.W  A5,#-104
    MOVEM.L D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2

    MOVE.L  A3,-(A7)
    BSR.S   _P_TYPE_FreeEntry

    ADDQ.W  #4,A7
    SUBA.L  A3,A3
    MOVE.L  A2,D0
    BEQ.S   .if_eq_1369

    MOVEQ   #0,D7

.loop_1367:
    CMP.L   2(A2),D7
    BGE.S   .if_ge_1368

    MOVEA.L 6(A2),A0
    ADDA.L  D7,A0
    MOVE.B  (A0),D0
    MOVE.B  D0,-100(A5,D7.L)
    ADDQ.L  #1,D7
    BRA.S   .loop_1367

.if_ge_1368:
    CLR.B   -100(A5,D7.L)
    MOVEQ   #0,D0
    MOVE.B  (A2),D0
    PEA     -100(A5)
    MOVE.L  2(A2),-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   _P_TYPE_AllocateEntry

    LEA     12(A7),A7
    MOVEA.L D0,A3

.if_eq_1369:
    MOVE.L  A3,D0
    MOVEM.L (A7)+,D7/A2-A3
    UNLK    A5
    RTS

;!======