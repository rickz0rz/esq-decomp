    XDEF    _TLIBA2_ParseEntryTimeWindow


;------------------------------------------------------------------------------
; FUNC: _TLIBA2_ParseEntryTimeWindow   (Parse "(HH:MM)" style window from entry text)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
;   stack +16: arg_4 (via 20(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A7/D0/D6/D7
; CALLS:
;   _PARSE_ReadSignedLongSkipClass3_Alt, _STR_FindCharPtr
; READS:
;   branch_17F0
; WRITES:
;   (none observed)
; DESC:
;   Extracts time values from the selected entry text into the output pair.
;   Requires delimiter sequence including ':' and ')' before accepting.
; NOTES:
;   Returns 1 on successful parse, 0 otherwise.
;------------------------------------------------------------------------------
_TLIBA2_ParseEntryTimeWindow:
    LINK.W  A5,#-24
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVEA.L 16(A5),A2
    MOVEQ   #0,D6
    MOVE.L  A3,D0
    BEQ.S   .if_eq_17EB

    MOVE.L  D7,D0
    ASL.L   #2,D0
    MOVEA.L 56(A3,D0.L),A0
    BRA.S   .skip_17EC

.if_eq_17EB:
    SUBA.L  A0,A0

.skip_17EC:
    MOVE.L  A0,-4(A5)
    BEQ.W   .branch_17F0

    PEA     40.W
    MOVE.L  A0,-(A7)
    JSR     _STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    TST.L   D0
    BEQ.W   .branch_17F0

    PEA     58.W
    MOVE.L  D0,-(A7)
    JSR     _STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-16(A5)
    TST.L   D0
    BEQ.W   .branch_17F0

    PEA     41.W
    MOVE.L  D0,-(A7)
    JSR     _STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-12(A5)
    TST.L   D0
    BEQ.S   .branch_17F0

    PEA     34.W
    MOVE.L  -4(A5),-(A7)
    JSR     _STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-20(A5)
    BEQ.S   .if_eq_17ED

    MOVEA.L -12(A5),A0
    CMPA.L  D0,A0
    BCC.S   .branch_17F0

.if_eq_17ED:
    MOVEA.L -16(A5),A0
    CLR.B   (A0)
    MOVEQ   #32,D0
    MOVEA.L -8(A5),A0
    CMP.B   1(A0),D0
    BNE.S   .if_ne_17EE

    LEA     2(A0),A1
    MOVE.L  A1,-(A7)
    JSR     _PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,(A2)
    BRA.S   .skip_17EF

.if_ne_17EE:
    LEA     1(A0),A1
    MOVE.L  A1,-(A7)
    JSR     _PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,(A2)

.skip_17EF:
    MOVEA.L -16(A5),A0
    MOVE.B  #$3a,(A0)
    MOVEA.L -12(A5),A0
    CLR.B   (A0)
    MOVEA.L -16(A5),A0
    ADDQ.L  #1,A0
    MOVE.L  A0,-(A7)
    JSR     _PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,4(A2)
    MOVEA.L -12(A5),A0
    MOVE.B  #$29,(A0)
    MOVEQ   #1,D6

.branch_17F0:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7/A2-A3
    UNLK    A5
    RTS

;!======