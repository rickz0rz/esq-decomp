    XDEF    _P_TYPE_ConsumePrimaryTypeIfPresent


;------------------------------------------------------------------------------
; FUNC: _P_TYPE_ConsumePrimaryTypeIfPresent   (Test first byte against primary list and clear it)
; ARGS:
;   stack +8: inOutBytePtr (u8 *)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A7/D0/D6/D7
; CALLS:
;   (none)
; READS:
;   _P_TYPE_PrimaryGroupListPtr
; WRITES:
;   *inOutBytePtr
; DESC:
;   Searches primary list payload for the input byte, returns 1 if found, and
;   clears the input byte in all cases.
; NOTES:
;   Returns 0 when list is missing/empty or no byte match is present.
;------------------------------------------------------------------------------
_P_TYPE_ConsumePrimaryTypeIfPresent:
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVEQ   #0,D7
    TST.L   _P_TYPE_PrimaryGroupListPtr
    BEQ.S   .branch_1372

    MOVEA.L _P_TYPE_PrimaryGroupListPtr,A0
    MOVE.L  2(A0),D0
    TST.L   D0
    BLE.S   .branch_1372

    MOVEQ   #0,D6

.loop_1370:
    TST.L   D7
    BNE.S   .branch_1372

    MOVEA.L _P_TYPE_PrimaryGroupListPtr,A0
    CMP.L   2(A0),D6
    BGE.S   .branch_1372

    MOVEA.L _P_TYPE_PrimaryGroupListPtr,A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    MOVE.B  (A3),D0
    CMP.B   (A0),D0
    BNE.S   .if_ne_1371

    MOVEQ   #1,D7

.if_ne_1371:
    ADDQ.L  #1,D6
    BRA.S   .loop_1370

.branch_1372:
    CLR.B   (A3)
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======