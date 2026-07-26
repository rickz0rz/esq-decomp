    XDEF    P_TYPE_CloneEntry
    XDEF    P_TYPE_EnsureSecondaryList


;------------------------------------------------------------------------------
; FUNC: P_TYPE_CloneEntry   (Deep-copy entry and payload)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +96: arg_3 (via 100(A5))
; CLOBBERS:
;   A0/A2/A3/A7/D0/D7
; CALLS:
;   _P_TYPE_FreeEntry, P_TYPE_AllocateEntry
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
P_TYPE_CloneEntry:
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
    BSR.W   P_TYPE_AllocateEntry

    LEA     12(A7),A7
    MOVEA.L D0,A3

.if_eq_1369:
    MOVE.L  A3,D0
    MOVEM.L (A7)+,D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: P_TYPE_EnsureSecondaryList   (Clone primary list into secondary list if missing)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A0/A7
; CALLS:
;   P_TYPE_CloneEntry
; READS:
;   TEXTDISP_SecondaryGroupCode, _P_TYPE_PrimaryGroupListPtr, _P_TYPE_SecondaryGroupListPtr
; WRITES:
;   _P_TYPE_SecondaryGroupListPtr
; DESC:
;   If primary list exists and secondary list is null, clones primary into
;   secondary and updates the cloned type byte to SecondaryGroupCode.
; NOTES:
;   No-op when primary is null or secondary already exists.
;------------------------------------------------------------------------------
P_TYPE_EnsureSecondaryList:
    TST.L   _P_TYPE_PrimaryGroupListPtr
    BEQ.S   .return_136B

    TST.L   _P_TYPE_SecondaryGroupListPtr
    BNE.S   .return_136B

    MOVE.L  _P_TYPE_PrimaryGroupListPtr,-(A7)
    MOVE.L  _P_TYPE_SecondaryGroupListPtr,-(A7)
    BSR.S   P_TYPE_CloneEntry

    ADDQ.W  #8,A7
    MOVE.L  D0,_P_TYPE_SecondaryGroupListPtr
    MOVEA.L D0,A0
    MOVE.B  TEXTDISP_SecondaryGroupCode,(A0)

.return_136B:
    RTS

;!======
