    XDEF    _TLIBA2_ResolveEntryWindowAndSlotCount


;------------------------------------------------------------------------------
; FUNC: _TLIBA2_ResolveEntryWindowAndSlotCount   (Resolve explicit time range or compute slot count fallback)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
;   stack +16: arg_4 (via 20(A5))
;   stack +20: arg_5 (via 24(A5))
;   stack +24: arg_6 (via 28(A5))
;   stack +30: arg_7 (via 34(A5))
;   stack +34: arg_8 (via 38(A5))
;   stack +56: arg_9 (via 60(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A7/D0/D1/D5/D6/D7
; CALLS:
;   TLIBA_FindFirstWildcardMatchIndex, _MATH_DivS32, _MATH_Mulu32,
;   _PARSE_ReadSignedLongSkipClass3_Alt, _TLIBA2_FindLastCharInString,
;   TLIBA2_JMPTBL_ESQ_TestBit1Based
; READS:
;   _TEXTDISP_SecondaryEntryPtrTable, _TEXTDISP_SecondaryTitlePtrTable, if_eq_17DB, return_17E5
; WRITES:
;   (none observed)
; DESC:
;   Tries to parse an explicit "(HH:MM)" range from the entry text. When no
;   explicit range is present, counts matching/eligible slots and optionally
;   derives a half-hour based fallback window.
; NOTES:
;   Uses text and bitfield gates in both primary and secondary tables.
;------------------------------------------------------------------------------
_TLIBA2_ResolveEntryWindowAndSlotCount:
    LINK.W  A5,#-40
    MOVEM.L D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  16(A5),D7
    MOVE.L  24(A5),D6
    MOVEQ   #0,D5
    CLR.L   -34(A5)
    BTST    #0,D6
    BEQ.W   .if_eq_17DB

    BTST    #1,7(A2,D7.L)
    BEQ.W   .if_eq_17DB

    MOVE.L  D7,D0
    ASL.L   #2,D0
    MOVEA.L 56(A2,D0.L),A0
    PEA     34.W
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-12(A5)
    BSR.W   _TLIBA2_FindLastCharInString

    ADDQ.W  #8,A7
    MOVE.L  D0,-28(A5)
    BEQ.W   .if_eq_17DB

    PEA     40.W
    MOVE.L  D0,-(A7)
    BSR.W   _TLIBA2_FindLastCharInString

    ADDQ.W  #8,A7
    MOVE.L  D0,-16(A5)
    TST.L   D0
    BEQ.W   .if_eq_17DB

    PEA     41.W
    MOVE.L  D0,-(A7)
    BSR.W   _TLIBA2_FindLastCharInString

    ADDQ.W  #8,A7
    MOVE.L  D0,-20(A5)
    TST.L   D0
    BEQ.W   .if_eq_17DB

    PEA     58.W
    MOVE.L  -16(A5),-(A7)
    BSR.W   _TLIBA2_FindLastCharInString

    ADDQ.W  #8,A7
    MOVE.L  D0,-24(A5)
    TST.L   D0
    BEQ.S   .if_eq_17DB

    MOVEA.L D0,A0
    CLR.B   (A0)
    MOVEQ   #32,D0
    MOVEA.L -16(A5),A0
    CMP.B   1(A0),D0
    BNE.S   .if_ne_17D9

    LEA     2(A0),A1
    MOVE.L  A1,-(A7)
    JSR     _PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVEA.L 20(A5),A0
    MOVE.L  D0,(A0)
    BRA.S   .skip_17DA

.if_ne_17D9:
    LEA     1(A0),A1
    MOVE.L  A1,-(A7)
    JSR     _PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVEA.L 20(A5),A0
    MOVE.L  D0,(A0)

.skip_17DA:
    MOVEA.L -24(A5),A0
    MOVE.B  #$3a,(A0)
    MOVEA.L -20(A5),A0
    CLR.B   (A0)
    MOVEA.L -24(A5),A0
    ADDQ.L  #1,A0
    MOVE.L  A0,-(A7)
    JSR     _PARSE_ReadSignedLongSkipClass3_Alt(PC)

    MOVEA.L 20(A5),A0
    MOVE.L  D0,4(A0)
    MOVEA.L -20(A5),A0
    MOVE.B  #$29,(A0)
    MOVE.L  -34(A5),D0
    BRA.W   .return_17E5

.if_eq_17DB:
    MOVE.L  D7,D0
    ASL.L   #2,D0
    TST.L   56(A2,D0.L)
    BEQ.S   .loop_17DC

    ADDQ.L  #1,D7
    ADDQ.L  #1,-34(A5)

.loop_17DC:
    MOVEQ   #49,D0
    CMP.L   D0,D7
    BGE.S   .skip_17DF

    LEA     28(A3),A0
    MOVE.L  D7,-(A7)
    MOVE.L  A0,-(A7)
    JSR     TLIBA2_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.S   .if_ne_17DE

    MOVE.L  D7,D0
    ASL.L   #2,D0
    TST.L   56(A2,D0.L)
    BEQ.S   .if_eq_17DD

    MOVEQ   #1,D5
    BRA.S   .skip_17DF

.if_eq_17DD:
    ADDQ.L  #1,D7
    ADDQ.L  #1,-34(A5)
    BRA.S   .loop_17DC

.if_ne_17DE:
    MOVEQ   #1,D5

.skip_17DF:
    TST.W   D5
    BNE.S   .branch_17E2

    MOVE.L  A2,-(A7)
    BSR.W   TLIBA_FindFirstWildcardMatchIndex

    ADDQ.W  #4,A7
    MOVE.L  D0,-38(A5)
    ADDQ.L  #1,D0
    BEQ.S   .branch_17E2

    MOVE.L  -38(A5),D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    LEA     _TEXTDISP_SecondaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-8(A5)
    MOVEQ   #1,D7

.loop_17E0:
    MOVEQ   #49,D0
    CMP.L   D0,D7
    BGE.S   .branch_17E2

    MOVEA.L -4(A5),A0
    ADDA.W  #$1c,A0
    MOVE.L  D7,-(A7)
    MOVE.L  A0,-(A7)
    JSR     TLIBA2_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.S   .branch_17E2

    MOVE.L  D7,D0
    ASL.L   #2,D0
    MOVEA.L -8(A5),A0
    TST.L   56(A0,D0.L)
    BEQ.S   .if_eq_17E1

    BTST    #7,7(A0,D7.L)
    BEQ.S   .branch_17E2

.if_eq_17E1:
    ADDQ.L  #1,D7
    ADDQ.L  #1,-34(A5)
    BRA.S   .loop_17E0

.branch_17E2:
    BTST    #0,D6
    BEQ.S   .if_eq_17E4

    MOVE.L  -34(A5),D0
    MOVE.L  D0,D1
    TST.L   D1
    BPL.S   .if_pl_17E3

    ADDQ.L  #1,D1

.if_pl_17E3:
    ASR.L   #1,D1
    MOVEA.L 20(A5),A0
    MOVE.L  D1,(A0)
    MOVEQ   #2,D1
    JSR     _MATH_DivS32(PC)

    MOVEQ   #30,D0
    JSR     _MATH_Mulu32(PC)

    MOVE.L  D0,4(A0)

.if_eq_17E4:
    MOVE.L  -34(A5),D0

.return_17E5:
    MOVEM.L -60(A5),D5-D7/A2-A3
    UNLK    A5
    RTS

;!======