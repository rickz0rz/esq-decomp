    XDEF    _TLIBA3_InitPatternTable



;------------------------------------------------------------------------------
; FUNC: _TLIBA3_InitPatternTable   (InitPatternTableuncertain)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A1/A3
; CALLS:
;   _MATH_Mulu32, _TLIBA3_InitRuntimeEntries
; READS:
;   (none)
; WRITES:
;   _TLIBA3_VmArrayPatternTable, _TLIBA1_PatternTableInitGuard
; DESC:
;   Initializes a pattern/lookup table with a fixed sequence of word values.
; NOTES:
;   Fills 10 records of 76 bytes each in _TLIBA3_VmArrayPatternTable.
;------------------------------------------------------------------------------
_TLIBA3_InitPatternTable:
    LINK.W  A5,#-36
    MOVEM.L D2-D7/A2-A3,-(A7)
    MOVE.W  #1,_TLIBA1_PatternTableInitGuard
    BSR.W   _TLIBA3_InitRuntimeEntries

    MOVEQ   #0,D7

.loop_180C:
    MOVEQ   #9,D0
    CMP.L   D0,D7
    BGE.W   .return_181D

    MOVE.L  D7,D0
    MOVEQ   #76,D1
    JSR     _MATH_Mulu32(PC)

    LEA     _TLIBA3_VmArrayPatternTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.W  #$8e,(A1)
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.W  #$90,4(A1)
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.W  #$92,8(A1)
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.W  #$94,12(A1)
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.W  #$108,16(A1)
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.W  #$10a,20(A1)
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.W  #$100,24(A1)
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.W  #$102,28(A1)
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.W  #$104,32(A1)
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.W  #$e0,36(A1)
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.W  #$e2,40(A1)
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.W  #$e4,44(A1)
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.W  #$e6,48(A1)
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.W  #$e8,52(A1)
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.W  #$ea,56(A1)
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.W  #$ec,60(A1)
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.W  #$ee,64(A1)
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.W  #$f0,68(A1)
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.W  #$f2,72(A1)
    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     _MATH_Mulu32(PC)

    LEA     _TLIBA3_VmArrayRuntimeTable,A1
    MOVEA.L A1,A2
    ADDA.L  D0,A2
    MOVE.W  6(A2),D0
    MOVE.L  D0,D1
    TST.W   D1
    BPL.S   .if_pl_180D

    ADDQ.W  #1,D1

.if_pl_180D:
    ASR.W   #1,D1
    MOVE.W  D0,-16(A5)
    EXT.L   D0
    MOVE.W  D1,-12(A5)
    MOVEQ   #16,D1
    JSR     _MATH_DivS32(PC)

    ASL.L   #2,D0
    MOVE.W  -16(A5),D1
    EXT.L   D1
    DIVS    #16,D1
    SWAP    D1
    MOVE.W  D0,-14(A5)
    MOVEM.W D1,-18(A5)
    TST.W   D1
    BEQ.S   .if_eq_1810

    EXT.L   D1
    TST.L   D1
    BPL.S   .if_pl_180E

    ADDQ.L  #1,D1

.if_pl_180E:
    ASR.L   #1,D1
    ASL.L   #4,D1
    MOVE.W  -18(A5),D2
    EXT.L   D2
    TST.L   D2
    BPL.S   .if_pl_180F

    ADDQ.L  #1,D2

.if_pl_180F:
    ASR.L   #1,D2
    ADD.L   D2,D1
    BRA.S   .skip_1811

.if_eq_1810:
    MOVEQ   #0,D1

.skip_1811:
    MOVEQ   #40,D6
    MOVE.L  D7,D0
    MOVE.W  D1,-20(A5)
    MOVEQ   #76,D1
    JSR     _MATH_Mulu32(PC)

    MOVEA.L A0,A2
    ADDA.L  D0,A2
    MOVE.L  D6,D0
    MOVE.W  -14(A5),D1
    ADD.W   D1,D0
    MOVE.W  D0,10(A2)
    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     _MATH_Mulu32(PC)

    MOVEA.L A1,A2
    ADDA.L  D0,A2
    BTST    #7,(A2)
    BEQ.S   .if_eq_1812

    MOVEQ   #4,D0
    BRA.S   .skip_1813

.if_eq_1812:
    MOVEQ   #2,D0

.skip_1813:
    MOVE.L  D0,D4
    MOVE.L  D7,D0
    MOVEQ   #76,D1
    JSR     _MATH_Mulu32(PC)

    MOVEA.L A0,A2
    ADDA.L  D0,A2
    MOVE.W  -14(A5),D1
    ADD.W   D6,D1
    MOVE.L  D0,32(A7)
    MOVE.L  D7,D0
    MOVE.W  D1,40(A7)
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     _MATH_Mulu32(PC)

    MOVEA.L A1,A3
    ADDA.L  D0,A3
    MOVE.W  2(A3),D1
    ANDI.L  #$ffff,D1
    DIVU    D4,D1
    MOVE.W  40(A7),D2
    ADD.W   D1,D2
    MOVE.W  D2,14(A2)
    MOVEQ   #0,D1
    MOVE.W  D6,D1
    MOVEQ   #9,D2
    ADD.L   D2,D1
    ADD.L   D1,D1
    SUBQ.L  #1,D1
    MOVEQ   #0,D2
    NOT.B   D2
    AND.L   D2,D1
    MOVE.L  D1,D5
    MOVE.L  32(A7),D1
    MOVEA.L A0,A2
    ADDA.L  D1,A2
    MOVE.W  -12(A5),D1
    MOVE.L  D1,D3
    ADD.W   D5,D3
    ANDI.W  #$ff,D3
    ADDI.W  #$1700,D3
    MOVE.W  D3,2(A2)
    MOVEA.L A1,A2
    ADDA.L  D0,A2
    BTST    #7,(A2)
    BEQ.S   .if_eq_1814

    MOVEQ   #2,D0
    BRA.S   .skip_1815

.if_eq_1814:
    MOVEQ   #1,D0

.skip_1815:
    MOVE.L  D0,D4
    MOVE.L  D7,D0
    MOVEQ   #76,D1
    JSR     _MATH_Mulu32(PC)

    MOVEA.L A0,A2
    ADDA.L  D0,A2
    MOVEQ   #0,D0
    MOVE.W  D5,D0
    MOVE.W  -12(A5),D1
    EXT.L   D1
    ADD.L   D1,D0
    MOVE.L  D0,36(A7)
    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     _MATH_Mulu32(PC)

    MOVEA.L A1,A3
    ADDA.L  D0,A3
    MOVEQ   #0,D1
    MOVE.W  2(A3),D1
    MOVEQ   #0,D3
    MOVE.W  D4,D3
    MOVE.L  D0,40(A7)
    MOVE.L  D1,D0
    MOVE.L  D3,D1
    JSR     _MATH_DivS32(PC)

    MOVE.L  36(A7),D1
    ADD.L   D0,D1
    AND.L   D2,D1
    ADDI.L  #$ff00,D1
    MOVE.W  D1,6(A2)
    MOVE.L  40(A7),D0
    MOVEA.L A1,A2
    ADDA.L  D0,A2
    BTST    #2,1(A2)
    BEQ.S   .if_eq_1816

    MOVEA.L A1,A2
    ADDA.L  D0,A2
    MOVEQ   #0,D0
    MOVE.W  2(A2),D0
    MOVEQ   #15,D1
    ADD.L   D1,D0
    ASR.L   #3,D0
    ANDI.L  #$fffe,D0
    BRA.S   .skip_1817

.if_eq_1816:
    MOVEQ   #0,D0

.skip_1817:
    MOVE.W  D0,-22(A5)
    TST.L   D7
    BNE.S   .if_ne_1818

    MOVE.W  D0,-22(A5)
    BRA.S   .skip_181C

.if_ne_1818:
    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     _MATH_Mulu32(PC)

    MOVEA.L A1,A2
    ADDA.L  D0,A2
    MOVEQ   #0,D0
    MOVE.W  (A2),D0
    MOVE.L  #$8004,D1
    AND.L   D1,D0
    CMPI.L  #$8004,D0
    BNE.S   .if_ne_1819

    SUBQ.W  #4,-22(A5)
    BRA.S   .skip_181C

.if_ne_1819:
    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     _MATH_Mulu32(PC)

    MOVEA.L A1,A2
    ADDA.L  D0,A2
    BTST    #7,(A2)
    BEQ.S   .if_eq_181A

    SUBQ.W  #4,-22(A5)
    BRA.S   .skip_181C

.if_eq_181A:
    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     _MATH_Mulu32(PC)

    MOVEA.L A1,A2
    ADDA.L  D0,A2
    BTST    #2,1(A2)
    BEQ.S   .if_eq_181B

    SUBQ.W  #2,-22(A5)
    BRA.S   .skip_181C

.if_eq_181B:
    SUBQ.W  #2,-22(A5)

.skip_181C:
    MOVE.L  D7,D0
    MOVEQ   #76,D1
    JSR     _MATH_Mulu32(PC)

    MOVEA.L A0,A2
    ADDA.L  D0,A2
    MOVE.W  -22(A5),D1
    MOVE.W  D1,18(A2)
    MOVEA.L A0,A2
    ADDA.L  D0,A2
    MOVE.W  D1,22(A2)
    MOVEA.L A0,A2
    ADDA.L  D0,A2
    MOVE.L  D0,32(A7)
    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     _MATH_Mulu32(PC)

    MOVEA.L A1,A3
    ADDA.L  D0,A3
    MOVE.W  (A3),26(A2)
    MOVE.L  32(A7),D1
    MOVEA.L A0,A2
    ADDA.L  D1,A2
    MOVE.W  -20(A5),D2
    MOVE.W  D2,30(A2)
    MOVEA.L A0,A2
    ADDA.L  D1,A2
    MOVE.W  #$24,34(A2)
    MOVEA.L A0,A2
    ADDA.L  D1,A2
    MOVEA.L A1,A3
    ADDA.L  D0,A3
    MOVE.L  118(A3),D2
    ANDI.W  #0,D2
    CLR.W   D2
    SWAP    D2
    MOVE.W  D2,38(A2)
    MOVEA.L A0,A2
    ADDA.L  D1,A2
    MOVEA.L A1,A3
    ADDA.L  D0,A3
    MOVE.L  118(A3),D2
    MOVE.L  #$ffff,D3
    AND.L   D3,D2
    MOVE.W  D2,42(A2)
    MOVEA.L A0,A2
    ADDA.L  D1,A2
    MOVEA.L A1,A3
    ADDA.L  D0,A3
    MOVE.L  122(A3),D2
    ANDI.W  #0,D2
    CLR.W   D2
    SWAP    D2
    MOVE.W  D2,46(A2)
    MOVEA.L A0,A2
    ADDA.L  D1,A2
    MOVEA.L A1,A3
    ADDA.L  D0,A3
    MOVE.L  122(A3),D2
    AND.L   D3,D2
    MOVE.W  D2,50(A2)
    MOVEA.L A0,A2
    ADDA.L  D1,A2
    MOVEA.L A1,A3
    ADDA.L  D0,A3
    MOVE.L  126(A3),D2
    ANDI.W  #0,D2
    CLR.W   D2
    SWAP    D2
    MOVE.W  D2,54(A2)
    MOVEA.L A0,A2
    ADDA.L  D1,A2
    MOVEA.L A1,A3
    ADDA.L  D0,A3
    MOVE.L  126(A3),D2
    AND.L   D3,D2
    MOVE.W  D2,58(A2)
    MOVEA.L A0,A2
    ADDA.L  D1,A2
    MOVEA.L A1,A3
    ADDA.L  D0,A3
    MOVE.L  130(A3),D2
    ANDI.W  #0,D2
    CLR.W   D2
    SWAP    D2
    MOVE.W  D2,62(A2)
    MOVEA.L A0,A2
    ADDA.L  D1,A2
    MOVEA.L A1,A3
    ADDA.L  D0,A3
    MOVE.L  130(A3),D2
    AND.L   D3,D2
    MOVE.W  D2,66(A2)
    MOVEA.L A0,A2
    ADDA.L  D1,A2
    MOVEA.L A1,A3
    ADDA.L  D0,A3
    MOVE.L  134(A3),D2
    ANDI.W  #0,D2
    CLR.W   D2
    SWAP    D2
    MOVE.W  D2,70(A2)
    ADDA.L  D1,A0
    ADDA.L  D0,A1
    MOVE.L  134(A1),D0
    ANDI.L  #$ffff,D0
    MOVE.W  D0,74(A0)
    ADDQ.L  #1,D7
    BRA.W   .loop_180C

.return_181D:
    MOVEM.L (A7)+,D2-D7/A2-A3
    UNLK    A5
    RTS

;!======