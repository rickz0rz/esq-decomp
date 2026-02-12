;------------------------------------------------------------------------------
; FUNC: TLIBA3_InitPatternTable   (InitPatternTableuncertain)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A1/A3
; CALLS:
;   MATH_Mulu32, TLIBA3_InitRuntimeEntries
; READS:
;   (none)
; WRITES:
;   TLIBA3_VmArrayPatternTable, DATA_TLIBA1_BSS_WORD_2173
; DESC:
;   Initializes a pattern/lookup table with a fixed sequence of word values.
; NOTES:
;   Fills 10 records of 76 bytes each in TLIBA3_VmArrayPatternTable.
;------------------------------------------------------------------------------
TLIBA3_InitPatternTable:
    LINK.W  A5,#-36
    MOVEM.L D2-D7/A2-A3,-(A7)
    MOVE.W  #1,DATA_TLIBA1_BSS_WORD_2173
    BSR.W   TLIBA3_InitRuntimeEntries

    MOVEQ   #0,D7

.loop_180C:
    MOVEQ   #9,D0
    CMP.L   D0,D7
    BGE.W   .return_181D

    MOVE.L  D7,D0
    MOVEQ   #76,D1
    JSR     MATH_Mulu32(PC)

    LEA     TLIBA3_VmArrayPatternTable,A0
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
    JSR     MATH_Mulu32(PC)

    LEA     TLIBA3_VmArrayRuntimeTable,A1
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
    JSR     MATH_DivS32(PC)

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
    JSR     MATH_Mulu32(PC)

    MOVEA.L A0,A2
    ADDA.L  D0,A2
    MOVE.L  D6,D0
    MOVE.W  -14(A5),D1
    ADD.W   D1,D0
    MOVE.W  D0,10(A2)
    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     MATH_Mulu32(PC)

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
    JSR     MATH_Mulu32(PC)

    MOVEA.L A0,A2
    ADDA.L  D0,A2
    MOVE.W  -14(A5),D1
    ADD.W   D6,D1
    MOVE.L  D0,32(A7)
    MOVE.L  D7,D0
    MOVE.W  D1,40(A7)
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     MATH_Mulu32(PC)

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
    JSR     MATH_Mulu32(PC)

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
    JSR     MATH_Mulu32(PC)

    MOVEA.L A1,A3
    ADDA.L  D0,A3
    MOVEQ   #0,D1
    MOVE.W  2(A3),D1
    MOVEQ   #0,D3
    MOVE.W  D4,D3
    MOVE.L  D0,40(A7)
    MOVE.L  D1,D0
    MOVE.L  D3,D1
    JSR     MATH_DivS32(PC)

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
    JSR     MATH_Mulu32(PC)

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
    JSR     MATH_Mulu32(PC)

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
    JSR     MATH_Mulu32(PC)

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
    JSR     MATH_Mulu32(PC)

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
    JSR     MATH_Mulu32(PC)

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

;------------------------------------------------------------------------------
; FUNC: TLIBA3_DrawCenteredWrappedTextLines   (TLIBA3_DrawCenteredWrappedTextLines)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +9: arg_3 (via 13(A5))
;   stack +10: arg_4 (via 14(A5))
;   stack +11: arg_5 (via 15(A5))
;   stack +12: arg_6 (via 16(A5))
;   stack +13: arg_7 (via 17(A5))
;   stack +14: arg_8 (via 18(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0/D1/D5/D6/D7
; CALLS:
;   UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition, _LVOSetAPen, _LVOSetBPen, _LVOSetDrMd, _LVOTextLength
; READS:
;   Global_REF_GRAPHICS_LIBRARY, LAB_181F
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
TLIBA3_DrawCenteredWrappedTextLines:
    LINK.W  A5,#-20
    MOVEM.L D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  16(A5),D7
    CLR.B   -18(A5)

    MOVE.B  28(A3),-15(A5)
    MOVE.B  25(A3),-16(A5)
    MOVE.B  26(A3),-17(A5)
    MOVE.B  24(A3),-14(A5)
    MOVEA.L 4(A3),A0
    MOVE.B  5(A0),-13(A5)
    MOVEA.L A3,A1

    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L A3,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L A3,A1
    MOVEQ   #7,D0
    JSR     _LVOSetBPen(A6)

    MOVEA.L 4(A3),A0
    MOVEQ   #0,D5
    MOVE.W  (A0),D5
    ASL.L   #3,D5

.lab_181F:
    MOVEA.L A2,A0

.lab_1820:
    TST.B   (A0)+
    BNE.S   .lab_1820

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    MOVE.L  A0,-12(A5)

.lab_1821:
    MOVE.L  -12(A5),D0
    TST.L   D0
    BLE.S   .lab_1823

    MOVEA.L A3,A1
    MOVEA.L A2,A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D5,D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .lab_1822

    ADDQ.L  #1,D1

.lab_1822:
    ASR.L   #1,D1
    MOVE.L  D1,D6
    BGE.S   .lab_1823

    SUBQ.L  #1,-12(A5)
    BRA.S   .lab_1821

.lab_1823:
    TST.B   -18(A5)
    BEQ.S   .lab_1824

    MOVEQ   #0,D0
    BRA.S   .lab_1825

.lab_1824:
    MOVE.L  -12(A5),D0
    MOVE.B  0(A2,D0.L),D0
    EXT.W   D0
    EXT.L   D0

.lab_1825:
    MOVE.L  -12(A5),D1
    CLR.B   0(A2,D1.L)
    MOVE.B  D0,-18(A5)
    TST.L   D6
    BMI.S   .lab_1826

    MOVE.L  A2,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  A3,-(A7)
    JSR     UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7

.lab_1826:
    MOVEA.L 52(A3),A0
    MOVEQ   #0,D0
    MOVE.W  20(A0),D0
    ADDQ.L  #1,D0
    ADD.L   D0,D7
    MOVEA.L A2,A0
    ADDA.L  -12(A5),A0
    MOVE.B  -18(A5),(A0)
    MOVEA.L A0,A2
    TST.B   (A2)
    BNE.W   .lab_181F

    MOVE.B  -16(A5),D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L A3,A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVE.B  -17(A5),D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L A3,A1
    JSR     _LVOSetBPen(A6)

    MOVE.B  -15(A5),D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L A3,A1
    JSR     _LVOSetDrMd(A6)

    MOVE.B  -14(A5),24(A3)
    MOVEA.L 4(A3),A0
    MOVE.B  -13(A5),5(A0)

    MOVEM.L (A7)+,D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TLIBA3_DrawVerticalScaleTicks   (TLIBA3_DrawVerticalScaleTicks)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +80: arg_3 (via 84(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A6/A7/D0/D1/D5/D6/D7
; CALLS:
;   MATH_DivS32, WDISP_SPrintf, _LVODraw, _LVOMove, _LVOText
; READS:
;   Global_REF_GRAPHICS_LIBRARY, LAB_1828, DATA_TLIBA1_FMT_PCT_03LD_2175, return
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
TLIBA3_DrawVerticalScaleTicks:
    LINK.W  A5,#-92
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7

    MOVE.L  D7,D5
    MOVEQ   #25,D0
    ADD.L   D0,D5
    MOVEA.L A3,A1
    MOVE.L  D7,D0
    MOVEQ   #0,D1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVEA.L 4(A3),A0
    MOVEQ   #0,D0
    MOVE.W  2(A0),D0
    SUBQ.L  #1,D0
    MOVE.L  D0,16(A7)
    MOVEA.L A3,A1
    MOVE.L  D7,D0
    MOVE.L  16(A7),D1
    JSR     _LVODraw(A6)

    MOVEQ   #0,D6

.lab_1828:
    MOVEA.L 4(A3),A0
    MOVEQ   #0,D0
    MOVE.W  2(A0),D0
    SUBQ.L  #1,D0
    CMP.L   D0,D6
    BGE.W   .return

    MOVE.L  D6,D0
    MOVEQ   #10,D1
    JSR     MATH_DivS32(PC)

    TST.L   D1
    BNE.S   .lab_182A

    TST.L   D6
    BEQ.S   .lab_182A

    MOVEA.L A3,A1
    MOVE.L  D7,D0
    MOVE.L  D6,D1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVE.L  D7,D0
    MOVEQ   #20,D1
    ADD.L   D1,D0
    MOVEA.L A3,A1
    MOVE.L  D6,D1
    JSR     _LVODraw(A6)

    MOVEA.L A3,A1
    MOVE.L  D5,D0
    MOVE.L  D6,D1
    JSR     _LVOMove(A6)

    MOVE.L  D6,-(A7)
    PEA     DATA_TLIBA1_FMT_PCT_03LD_2175
    PEA     -84(A5)
    JSR     WDISP_SPrintf(PC)

    LEA     12(A7),A7
    LEA     -84(A5),A0
    MOVEA.L A0,A1

.lab_1829:
    TST.B   (A1)+
    BNE.S   .lab_1829

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,16(A7)
    MOVEA.L A3,A1
    MOVE.L  16(A7),D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOText(A6)

    BRA.S   .lab_182B

.lab_182A:
    MOVE.L  D6,D0
    MOVEQ   #5,D1
    JSR     MATH_DivS32(PC)

    TST.L   D1
    BNE.S   .lab_182B

    MOVEA.L A3,A1
    MOVE.L  D7,D0
    MOVE.L  D6,D1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVE.L  D7,D0
    MOVEQ   #10,D1
    ADD.L   D1,D0
    MOVEA.L A3,A1
    MOVE.L  D6,D1
    JSR     _LVODraw(A6)

.lab_182B:
    ADDQ.L  #1,D6
    BRA.W   .lab_1828

.return:
    MOVEM.L (A7)+,D5-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TLIBA3_DrawHorizontalScaleTicks   (TLIBA3_DrawHorizontalScaleTicks)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +80: arg_3 (via 84(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A6/A7/D0/D1/D5/D6/D7
; CALLS:
;   MATH_DivS32, MATH_Mulu32, WDISP_SPrintf, _LVODraw, _LVOMove, _LVOText, _LVOTextLength
; READS:
;   Global_REF_GRAPHICS_LIBRARY, LAB_182E, LAB_1832, DATA_TLIBA1_FMT_PCT_03LD_2176, return
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
TLIBA3_DrawHorizontalScaleTicks:
    LINK.W  A5,#-92
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7

    MOVE.L  D7,D5
    MOVEQ   #25,D0
    ADD.L   D0,D5
    MOVEA.L A3,A1
    MOVE.L  D7,D1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVEA.L 4(A3),A0
    MOVEQ   #0,D0
    MOVE.W  (A0),D0
    ASL.L   #3,D0
    SUBQ.L  #1,D0
    MOVEA.L A3,A1
    MOVE.L  D7,D1
    JSR     _LVODraw(A6)

    MOVEQ   #0,D6

.lab_182E:
    MOVEA.L 4(A3),A0
    MOVEQ   #0,D0
    MOVE.W  (A0),D0
    ASL.L   #3,D0
    SUBQ.L  #1,D0
    CMP.L   D0,D6
    BGE.W   .return

    MOVE.L  D6,D0
    MOVEQ   #25,D1
    JSR     MATH_DivS32(PC)

    TST.L   D1
    BNE.W   .lab_1832

    TST.L   D6
    BEQ.W   .lab_1832

    MOVEA.L A3,A1
    MOVE.L  D6,D0
    MOVE.L  D7,D1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVE.L  D7,D0
    MOVEQ   #20,D1
    ADD.L   D1,D0
    MOVE.L  D0,16(A7)
    MOVEA.L A3,A1
    MOVE.L  D6,D0
    MOVE.L  16(A7),D1
    JSR     _LVODraw(A6)

    MOVE.L  D6,-(A7)
    PEA     DATA_TLIBA1_FMT_PCT_03LD_2176
    PEA     -84(A5)
    JSR     WDISP_SPrintf(PC)

    LEA     12(A7),A7
    LEA     -84(A5),A0
    MOVEA.L A0,A1

.lab_182F:
    TST.B   (A1)+
    BNE.S  .lab_182F

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,16(A7)
    MOVEA.L A3,A1
    MOVE.L  16(A7),D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    TST.L   D0
    BPL.S   .lab_1830

    ADDQ.L  #1,D0

.lab_1830:
    ASR.L   #1,D0
    MOVE.L  D6,D1
    SUB.L   D0,D1
    MOVE.L  D6,D0
    MOVE.L  D1,16(A7)
    MOVEQ   #2,D1
    JSR     MATH_DivS32(PC)

    MOVEQ   #10,D0
    JSR     MATH_Mulu32(PC)

    MOVE.L  D5,D1
    ADD.L   D0,D1
    MOVEA.L A3,A1
    MOVE.L  16(A7),D0
    JSR     _LVOMove(A6)

    LEA     -84(A5),A0
    MOVEA.L A0,A1

.lab_1831:
    TST.B   (A1)+
    BNE.S   .lab_1831

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,16(A7)
    MOVEA.L A3,A1
    MOVE.L  16(A7),D0
    JSR     _LVOText(A6)

    BRA.S   .lab_1833

.lab_1832:
    MOVE.L  D6,D0
    MOVEQ   #5,D1
    JSR     MATH_DivS32(PC)

    TST.L   D1
    BNE.S   .lab_1833

    MOVEA.L A3,A1
    MOVE.L  D6,D0
    MOVE.L  D7,D1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVE.L  D7,D0
    MOVEQ   #10,D1
    ADD.L   D1,D0
    MOVE.L  D0,16(A7)
    MOVEA.L A3,A1
    MOVE.L  D6,D0
    MOVE.L  16(A7),D1
    JSR     _LVODraw(A6)

.lab_1833:
    ADDQ.L  #1,D6
    BRA.W   .lab_182E

.return:
    MOVEM.L (A7)+,D5-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TLIBA3_DrawOuterFrameBorder   (TLIBA3_DrawOuterFrameBorder)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A6/A7/D0/D1
; CALLS:
;   _LVODraw, _LVOMove
; READS:
;   Global_REF_GRAPHICS_LIBRARY
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
TLIBA3_DrawOuterFrameBorder:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVEA.L 4(A3),A0
    MOVEQ   #0,D0
    MOVE.W  (A0),D0
    ASL.L   #3,D0
    SUBQ.L  #1,D0
    MOVEA.L A3,A1
    MOVEQ   #0,D1
    JSR     _LVODraw(A6)

    MOVEA.L 4(A3),A0
    MOVEQ   #0,D0
    MOVE.W  (A0),D0
    ASL.L   #3,D0

    SUBQ.L  #1,D0
    MOVEQ   #0,D1
    MOVE.W  2(A0),D1
    SUBQ.L  #1,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVEA.L 4(A3),A0
    MOVEQ   #0,D0
    MOVE.W  2(A0),D0
    SUBQ.L  #1,D0
    MOVEA.L A3,A1
    MOVE.L  D0,D1
    MOVEQ   #0,D0
    JSR     _LVODraw(A6)

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    JSR     _LVODraw(A6)

    MOVEA.L (A7)+,A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TLIBA3_DrawInnerFrameBorder   (TLIBA3_DrawInnerFrameBorder)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A6/A7/D0/D1
; CALLS:
;   _LVODraw, _LVOMove
; READS:
;   Global_REF_GRAPHICS_LIBRARY
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
TLIBA3_DrawInnerFrameBorder:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVEA.L 4(A3),A0
    MOVEQ   #0,D0
    MOVE.W  (A0),D0
    ASL.L   #3,D0
    SUBQ.L  #1,D0
    MOVEQ   #0,D1
    MOVE.W  2(A0),D1
    SUBQ.L  #1,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVEA.L 4(A3),A0
    MOVEQ   #0,D0
    MOVE.W  (A0),D0
    ASL.L   #3,D0
    SUBQ.L  #1,D0
    MOVEA.L A3,A1
    MOVEQ   #0,D1
    JSR     _LVOMove(A6)

    MOVEA.L 4(A3),A0
    MOVEQ   #0,D0
    MOVE.W  2(A0),D0
    SUBQ.L  #1,D0
    MOVEA.L A3,A1
    MOVE.L  D0,D1
    MOVEQ   #0,D0
    JSR     _LVODraw(A6)

    MOVEA.L (A7)+,A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TLIBA3_DrawViewModeGuides   (TLIBA3_DrawViewModeGuides)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A6/A7/D0
; CALLS:
;   TLIBA3_DrawVerticalScaleTicks, TLIBA3_DrawHorizontalScaleTicks, TLIBA3_DrawOuterFrameBorder, TLIBA3_DrawInnerFrameBorder, _LVOSetAPen, _LVOSetDrMd, _LVOSetFont
; READS:
;   Global_HANDLE_PREVUEC_FONT, Global_HANDLE_TOPAZ_FONT, Global_REF_GRAPHICS_LIBRARY
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
TLIBA3_DrawViewModeGuides:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    MOVEA.L A3,A1
    MOVEA.L Global_HANDLE_TOPAZ_FONT,A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    MOVEA.L A3,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L 4(A3),A0
    MOVEQ   #0,D0
    MOVE.W  (A0),D0
    ASL.L   #3,D0
    TST.L   D0
    BPL.S   .lab_1838

    ADDQ.L  #1,D0

.lab_1838:
    ASR.L   #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   TLIBA3_DrawVerticalScaleTicks

    MOVEA.L 4(A3),A0
    MOVEQ   #0,D0
    MOVE.W  2(A0),D0
    TST.L   D0
    BPL.S   .lab_1839

    ADDQ.L  #1,D0

.lab_1839:
    ASR.L   #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  A3,-(A7)
    BSR.W   TLIBA3_DrawHorizontalScaleTicks

    MOVE.L  A3,(A7)
    BSR.W   TLIBA3_DrawOuterFrameBorder

    MOVE.L  A3,(A7)
    BSR.W   TLIBA3_DrawInnerFrameBorder

    LEA     12(A7),A7
    MOVEA.L A3,A1
    MOVEA.L Global_HANDLE_PREVUEC_FONT,A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    MOVEA.L (A7)+,A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TLIBA3_DrawViewModeOverlay   (TLIBA3_DrawViewModeOverlay)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +84: arg_2 (via 88(A5))
;   stack +96: arg_3 (via 100(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A6/A7/D0/D1/D5/D6/D7
; CALLS:
;   TLIBA3_DrawCenteredWrappedTextLines, TLIBA3_DrawViewModeGuides, MATH_Mulu32, WDISP_SPrintf, _LVOSetAPen, _LVOSetBPen, _LVOSetDrMd, _LVOSetFont, _LVOSetRast
; READS:
;   Global_HANDLE_PREVUEC_FONT, Global_REF_GRAPHICS_LIBRARY, DATA_TLIBA1_FMT_VIEWMODE_PCT_LD_2177, TLIBA3_VmArrayRuntimeTable
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
TLIBA3_DrawViewModeOverlay:
    LINK.W  A5,#-88
    MOVEM.L D5-D7,-(A7)
    MOVE.L  8(A5),D7

    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     MATH_Mulu32(PC)

    LEA     TLIBA3_VmArrayRuntimeTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEQ   #0,D6
    MOVE.W  2(A1),D6
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEQ   #0,D5
    MOVE.W  4(A1),D5
    ADDA.L  D0,A0
    LEA     10(A0),A1
    MOVEA.L Global_HANDLE_PREVUEC_FONT,A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     MATH_Mulu32(PC)

    LEA     TLIBA3_VmArrayRuntimeTable,A0
    ADDA.L  D0,A0
    LEA     10(A0),A1
    MOVEQ   #0,D0
    JSR     _LVOSetRast(A6)

    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     MATH_Mulu32(PC)

    LEA     TLIBA3_VmArrayRuntimeTable,A0
    ADDA.L  D0,A0
    LEA     10(A0),A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     MATH_Mulu32(PC)

    LEA     TLIBA3_VmArrayRuntimeTable,A0
    ADDA.L  D0,A0
    LEA     10(A0),A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     MATH_Mulu32(PC)

    LEA     TLIBA3_VmArrayRuntimeTable,A0
    ADDA.L  D0,A0
    LEA     10(A0),A1
    MOVEQ   #0,D0
    JSR     _LVOSetBPen(A6)

    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     MATH_Mulu32(PC)

    LEA     TLIBA3_VmArrayRuntimeTable,A0
    ADDA.L  D0,A0
    LEA     10(A0),A1
    MOVE.L  A1,-(A7)
    BSR.W   TLIBA3_DrawViewModeGuides

    MOVE.L  D7,(A7)
    PEA     DATA_TLIBA1_FMT_VIEWMODE_PCT_LD_2177
    PEA     -88(A5)
    JSR     WDISP_SPrintf(PC)

    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     MATH_Mulu32(PC)

    LEA     TLIBA3_VmArrayRuntimeTable,A0
    ADDA.L  D0,A0
    LEA     10(A0),A1
    PEA     90.W
    PEA     -88(A5)
    MOVE.L  A1,-(A7)
    BSR.W   TLIBA3_DrawCenteredWrappedTextLines

    MOVEM.L -100(A5),D5-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TLIBA3_GetViewModeHeight   (TLIBA3_GetViewModeHeight)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A7/D0/D1/D7
; CALLS:
;   MATH_Mulu32
; READS:
;   TLIBA3_VmArrayRuntimeTable
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
TLIBA3_GetViewModeHeight:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7

    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     MATH_Mulu32(PC)

    LEA     TLIBA3_VmArrayRuntimeTable,A0
    ADDA.L  D0,A0
    MOVE.W  4(A0),D0

    MOVE.L  (A7)+,D7
    RTS

;!======

    ; Dead code.
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7
    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     MATH_Mulu32(PC)

    LEA     TLIBA3_VmArrayRuntimeTable,A0
    ADDA.L  D0,A0
    MOVE.W  2(A0),D0
    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TLIBA3_ClearViewModeRastPort   (TLIBA3_ClearViewModeRastPort)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A6/A7/D0/D1/D6/D7
; CALLS:
;   MATH_Mulu32, _LVOSetRast
; READS:
;   Global_REF_GRAPHICS_LIBRARY, TLIBA3_VmArrayRuntimeTable
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
TLIBA3_ClearViewModeRastPort:
    MOVEM.L D6-D7,-(A7)
    MOVE.L  12(A7),D7
    MOVE.L  16(A7),D6

    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     MATH_Mulu32(PC)

    LEA     TLIBA3_VmArrayRuntimeTable,A0
    ADDA.L  D0,A0
    LEA     10(A0),A1
    MOVE.L  D6,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    MOVEM.L (A7)+,D6-D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TLIBA3_GetViewModeRastPort   (TLIBA3_GetViewModeRastPort)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A7/D0/D1/D7
; CALLS:
;   MATH_Mulu32
; READS:
;   TLIBA3_VmArrayRuntimeTable
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
TLIBA3_GetViewModeRastPort:
    MOVE.L  D7,-(A7)

    MOVE.L  8(A7),D7
    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     MATH_Mulu32(PC)

    LEA     TLIBA3_VmArrayRuntimeTable,A0
    ADDA.L  D0,A0
    LEA     10(A0),A1
    MOVE.L  A1,D0

    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TLIBA3_BuildDisplayContextForViewMode   (TLIBA3_BuildDisplayContextForViewMode)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +14: arg_2 (via 18(A5))
;   stack +54: arg_3 (via 58(A5))
;   stack +66: arg_4 (via 70(A5))
;   stack +70: arg_5 (via 74(A5))
;   stack +80: arg_6 (via 84(A5))
;   stack +118: arg_7 (via 122(A5))
;   stack +156: arg_8 (via 160(A5))
;   stack +194: arg_9 (via 198(A5))
;   stack +232: arg_10 (via 236(A5))
;   stack +240: arg_11 (via 244(A5))
;   stack +244: arg_12 (via 248(A5))
;   stack +248: arg_13 (via 252(A5))
;   stack +252: arg_14 (via 256(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A5/A7/D0/D1/D2/D3/D5/D6/D7
; CALLS:
;   TLIBA3_BuildDisplayContextForViewMode, MATH_Mulu32, TLIBA3_InitPatternTable, TLIBA3_JMPTBL_GCOMMAND_ApplyHighlightFlag
; READS:
;   LAB_1840, LAB_1847, LAB_1848, LAB_184D, LAB_184E, DATA_ESQ_BSS_LONG_1E25, DATA_ESQ_BSS_LONG_1E54, DATA_TLIBA1_BSS_WORD_2173, DATA_TLIBA1_BSS_LONG_2178, TLIBA3_VmArrayRuntimeTable, TLIBA3_VmArrayPatternTable, fffe, ffff
; WRITES:
;   DATA_TLIBA1_BSS_LONG_2178, WDISP_DisplayContextBase
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
TLIBA3_BuildDisplayContextForViewMode:
    LINK.W  A5,#-256
    MOVEM.L D2-D3/D5-D7/A2,-(A7)
    MOVE.L  8(A5),D7
    MOVE.W  18(A5),D6

    MOVE.L  D7,DATA_TLIBA1_BSS_LONG_2178
    TST.W   DATA_TLIBA1_BSS_WORD_2173
    BNE.S   .lab_183F

    BSR.W   TLIBA3_InitPatternTable

.lab_183F:
    MOVE.L  #DATA_ESQ_BSS_LONG_1E25,-4(A5)
    MOVE.L  #DATA_ESQ_BSS_LONG_1E54,-8(A5)
    MOVE.L  D7,D0
    MOVEQ   #76,D1
    JSR     MATH_Mulu32(PC)

    LEA     TLIBA3_VmArrayPatternTable,A0
    ADDA.L  D0,A0
    LEA     -84(A5),A1
    MOVEA.L A1,A2
    MOVEQ   #18,D0

.lab_1840:
    MOVE.L  (A0)+,(A2)+
    DBF     D0,.lab_1840
    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     MATH_Mulu32(PC)

    LEA     TLIBA3_VmArrayRuntimeTable,A0
    MOVEA.L A0,A2
    ADDA.L  D0,A2
    MOVEQ   #0,D1
    MOVE.W  (A2),D1
    MOVE.L  #$8004,D2
    AND.L   D2,D1
    CMPI.L  #$8004,D1
    BNE.S   .lab_1841

    MOVEQ   #-2,D1
    MOVEA.L A0,A2
    ADDA.L  D0,A2
    MOVEQ   #0,D0
    MOVE.W  2(A2),D0
    MOVEQ   #15,D2
    ADD.L   D2,D0
    ASR.L   #3,D0
    MOVE.L  #$fffe,D3
    AND.L   D3,D0
    SUBQ.L  #2,D0
    MOVE.L  D0,-248(A5)
    MOVE.L  D1,-244(A5)
    BRA.S   .lab_1844

.lab_1841:
    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     MATH_Mulu32(PC)

    MOVEA.L A0,A2
    ADDA.L  D0,A2
    BTST    #7,(A2)
    BEQ.S   .lab_1842

    MOVEQ   #-2,D0
    MOVE.L  D0,-248(A5)
    MOVE.L  D0,-244(A5)
    BRA.S   .lab_1844

.lab_1842:
    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     MATH_Mulu32(PC)

    MOVEA.L A0,A2
    ADDA.L  D0,A2
    BTST    #2,1(A2)
    BEQ.S   .lab_1843

    MOVEQ   #0,D1
    MOVEA.L A0,A2
    ADDA.L  D0,A2
    MOVEQ   #0,D0
    MOVE.W  2(A2),D0
    MOVEQ   #15,D2
    ADD.L   D2,D0
    ASR.L   #3,D0
    MOVE.L  #$fffe,D3
    AND.L   D3,D0
    MOVE.L  D0,-248(A5)
    MOVE.L  D1,-244(A5)
    BRA.S   .lab_1844

.lab_1843:
    MOVEQ   #0,D0
    MOVE.L  D0,-248(A5)
    MOVE.L  D0,-244(A5)

.lab_1844:
    TST.L   D7
    BNE.S   .lab_1845

    MOVEQ   #0,D0
    MOVE.L  D0,-244(A5)
    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     MATH_Mulu32(PC)

    MOVEA.L A0,A2
    ADDA.L  D0,A2
    MOVEQ   #0,D0
    MOVE.W  2(A2),D0
    MOVEQ   #15,D1
    ADD.L   D1,D0
    ASR.L   #3,D0
    ANDI.L  #$fffe,D0
    MOVE.W  -74(A5),D1
    ADDQ.W  #4,D1
    MOVE.W  D1,-74(A5)
    MOVE.W  -70(A5),D1
    SUBQ.W  #4,D1
    MOVE.W  D1,-70(A5)
    MOVE.L  D0,-248(A5)

.lab_1845:
    MOVEQ   #-1,D0
    CMP.W   D0,D6
    BEQ.S   .lab_1846

    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     MATH_Mulu32(PC)

    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.W  (A0),D0
    ANDI.W  #$8fff,D0
    MOVE.L  D6,D1
    EXT.L   D1
    ASL.L   #8,D1
    ASL.L   #4,D1
    OR.L    D1,D0
    MOVE.W  D0,-58(A5)

.lab_1846:
    MOVEA.L A1,A0
    LEA     -160(A5),A2
    MOVEQ   #18,D0

.lab_1847:
    MOVE.L  (A0)+,(A2)+
    DBF     D0,.lab_1847
    LEA     -236(A5),A0
    MOVEQ   #18,D0

.lab_1848:
    MOVE.L  (A1)+,(A0)+
    DBF     D0,.lab_1848
    LEA     -122(A5),A0
    CLR.L   -256(A5)
    MOVE.L  A0,-252(A5)

.lab_1849:
    CMPI.L  #$5,-256(A5)
    BGE.S   .lab_184A

    MOVEQ   #0,D0
    MOVEA.L -252(A5),A0
    MOVE.W  (A0),D0
    SWAP    D0
    CLR.W   D0
    MOVEQ   #0,D1
    MOVE.W  4(A0),D1
    ADD.L   D1,D0
    MOVE.L  D0,D5
    ADD.L   -244(A5),D5
    MOVE.L  D5,D0
    SWAP    D0
    EXT.L   D0
    MOVE.W  D0,(A0)
    MOVE.L  D5,D0
    ANDI.L  #$ffff,D0
    MOVE.W  D0,4(A0)
    ADDQ.L  #8,-252(A5)
    ADDQ.L  #1,-256(A5)
    BRA.S   .lab_1849

.lab_184A:
    LEA     -198(A5),A0
    CLR.L   -256(A5)
    MOVE.L  A0,-252(A5)

.lab_184B:
    CMPI.L  #$5,-256(A5)
    BGE.S   .lab_184C

    MOVEQ   #0,D0
    MOVEA.L -252(A5),A0
    MOVE.W  (A0),D0
    SWAP    D0
    CLR.W   D0
    MOVEQ   #0,D1
    MOVE.W  4(A0),D1
    ADD.L   D1,D0
    MOVE.L  D0,D5
    ADD.L   -248(A5),D5
    MOVE.L  D5,D0
    SWAP    D0
    EXT.L   D0
    MOVE.W  D0,(A0)
    MOVE.L  D5,D0
    ANDI.L  #$ffff,D0
    MOVE.W  D0,4(A0)
    ADDQ.L  #8,-252(A5)
    ADDQ.L  #1,-256(A5)
    BRA.S   .lab_184B

.lab_184C:
    LEA     -160(A5),A0
    MOVEA.L -4(A5),A1
    MOVEQ   #18,D0

.lab_184D:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.lab_184D
    LEA     -236(A5),A0
    MOVEA.L -8(A5),A1
    MOVEQ   #18,D0

.lab_184E:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.lab_184E
    JSR     TLIBA3_JMPTBL_GCOMMAND_ApplyHighlightFlag(PC)

    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     MATH_Mulu32(PC)

    LEA     TLIBA3_VmArrayRuntimeTable,A0
    ADDA.L  D0,A0
    MOVE.L  A0,D0
    MOVEM.L (A7)+,D2-D3/D5-D7/A2
    UNLK    A5
    RTS

;!======

    ; Dead code.
    MOVE.L  D7,-(A7)
    MOVE.W  10(A7),D7
    MOVE.L  D7,D0
    EXT.L   D0
    PEA     -1.W
    MOVE.L  D0,-(A7)
    MOVE.L  DATA_TLIBA1_BSS_LONG_2178,-(A7)
    BSR.W   TLIBA3_BuildDisplayContextForViewMode

    LEA     12(A7),A7
    MOVE.L  D0,WDISP_DisplayContextBase
    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TLIBA3_SelectNextViewMode   (TLIBA3_SelectNextViewMode)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D1
; CALLS:
;   TLIBA3_DrawViewModeOverlay, TLIBA3_BuildDisplayContextForViewMode, MATH_DivS32
; READS:
;   DATA_TLIBA1_BSS_LONG_2178
; WRITES:
;   DATA_TLIBA1_BSS_LONG_2178, WDISP_DisplayContextBase
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
TLIBA3_SelectNextViewMode:
    MOVE.L  DATA_TLIBA1_BSS_LONG_2178,D0
    ADDQ.L  #1,D0
    MOVEQ   #9,D1
    JSR     MATH_DivS32(PC)

    MOVE.L  D1,DATA_TLIBA1_BSS_LONG_2178
    PEA     -1.W
    CLR.L   -(A7)
    MOVE.L  D1,-(A7)
    BSR.W   TLIBA3_BuildDisplayContextForViewMode

    MOVE.L  D0,WDISP_DisplayContextBase
    MOVE.L  DATA_TLIBA1_BSS_LONG_2178,(A7)
    BSR.W   TLIBA3_DrawViewModeOverlay

    LEA     12(A7),A7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TLIBA3_FormatPatternRegisterDump   (TLIBA3_FormatPatternRegisterDump)
; ARGS:
;   stack +76: arg_1 (via 80(A5))
;   stack +80: arg_2 (via 84(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A2/A3/A7/D0/D1/D2/D3/D7
; CALLS:
;   FORMAT_RawDoFmtWithScratchBuffer, TLIBA3_FormatPatternRegisterDump, MATH_Mulu32, WDISP_SPrintf
; READS:
;   Global_STR_VM_ARRAY_1, Global_STR_VM_ARRAY_2, DATA_TLIBA1_BSS_LONG_2178, DATA_TLIBA1_BSS_WORD_2179, DATA_TLIBA1_BSS_WORD_217A, DATA_TLIBA1_BSS_WORD_217B, DATA_TLIBA1_FMT_PCT_S_COLON_DIWOFFSET_PCT_04LX_DDFOF_217C, DATA_TLIBA1_FMT_DIWSTRT_COLON_0X_PCT_04LX_0X_PCT_04L_217D, DATA_TLIBA1_FMT_DIWSTOP_COLON_0X_PCT_04LX_0X_PCT_04L_217E, DATA_TLIBA1_FMT_DDFSTRT_COLON_0X_PCT_04LX_0X_PCT_04L_217F, DATA_TLIBA1_FMT_DDFSTOP_COLON_0X_PCT_04LX_0X_PCT_04L_2180, DATA_TLIBA1_FMT_BPL1MOD_COLON_0X_PCT_04LX_0X_PCT_04L_2181, DATA_TLIBA1_FMT_BPL2MOD_COLON_0X_PCT_04LX_0X_PCT_04L_2182, DATA_TLIBA1_FMT_BPLCON0_COLON_0X_PCT_04LX_0X_PCT_04L_2183, DATA_TLIBA1_FMT_BPLCON1_COLON_0X_PCT_04LX_0X_PCT_04L_2184, DATA_TLIBA1_FMT_BPLCON2_COLON_0X_PCT_04LX_0X_PCT_04L_2185, DATA_TLIBA1_FMT_BPL1PTH_COLON_0X_PCT_04LX_0X_PCT_04L_2186, DATA_TLIBA1_FMT_BPL1PTL_COLON_0X_PCT_04LX_0X_PCT_04L_2187, DATA_TLIBA1_FMT_BPL2PTH_COLON_0X_PCT_04LX_0X_PCT_04L_2188, DATA_TLIBA1_FMT_BPL2PTL_COLON_0X_PCT_04LX_0X_PCT_04L_2189, DATA_TLIBA1_FMT_BPL3PTH_COLON_0X_PCT_04LX_0X_PCT_04L_218A, DATA_TLIBA1_FMT_BPL3PTL_COLON_0X_PCT_04LX_0X_PCT_04L_218B, DATA_TLIBA1_FMT_BPL4PTH_COLON_0X_PCT_04LX_0X_PCT_04L_218C, DATA_TLIBA1_FMT_BPL4PTL_COLON_0X_PCT_04LX_0X_PCT_04L_218D, DATA_TLIBA1_FMT_BPL5PTH_COLON_0X_PCT_04LX_0X_PCT_04L_218E, DATA_TLIBA1_FMT_BPL5PTL_COLON_0X_PCT_04LX_0X_PCT_04L_218F, DATA_TLIBA1_STR_2190, DATA_TLIBA1_STR_2193, TLIBA3_VmArrayPatternTable
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
TLIBA3_FormatPatternRegisterDump:
    MOVEM.L D2-D3/A2-A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVEA.L 24(A7),A2
    MOVE.W  DATA_TLIBA1_BSS_WORD_2179,D0
    EXT.L   D0
    MOVE.W  DATA_TLIBA1_BSS_WORD_217A,D1
    EXT.L   D1
    MOVE.W  DATA_TLIBA1_BSS_WORD_217B,D2
    EXT.L   D2
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    PEA     DATA_TLIBA1_FMT_PCT_S_COLON_DIWOFFSET_PCT_04LX_DDFOF_217C
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.W  (A2),D0
    MOVEQ   #0,D1
    MOVE.W  2(A2),D1
    MOVEQ   #0,D2
    MOVE.W  D1,D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     DATA_TLIBA1_FMT_DIWSTRT_COLON_0X_PCT_04LX_0X_PCT_04L_217D
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.W  4(A2),D0
    MOVEQ   #0,D1
    MOVE.W  6(A2),D1
    MOVEQ   #0,D2
    MOVE.W  D1,D2
    ADDI.L  #$100,D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     DATA_TLIBA1_FMT_DIWSTOP_COLON_0X_PCT_04LX_0X_PCT_04L_217E
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.W  8(A2),D0
    MOVEQ   #0,D1
    MOVE.W  10(A2),D1
    MOVEQ   #0,D2
    MOVE.W  D1,D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     DATA_TLIBA1_FMT_DDFSTRT_COLON_0X_PCT_04LX_0X_PCT_04L_217F
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.W  12(A2),D0
    MOVEQ   #0,D1
    MOVE.W  14(A2),D1
    MOVEQ   #0,D2
    MOVE.W  D1,D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     DATA_TLIBA1_FMT_DDFSTOP_COLON_0X_PCT_04LX_0X_PCT_04L_2180
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     68(A7),A7
    MOVEQ   #0,D0
    MOVE.W  16(A2),D0
    MOVEQ   #0,D1
    MOVE.W  18(A2),D1
    MOVEQ   #0,D2
    MOVE.W  D1,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     DATA_TLIBA1_FMT_BPL1MOD_COLON_0X_PCT_04LX_0X_PCT_04L_2181
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.W  20(A2),D0
    MOVEQ   #0,D1
    MOVE.W  22(A2),D1
    MOVEQ   #0,D2
    MOVE.W  D1,D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     DATA_TLIBA1_FMT_BPL2MOD_COLON_0X_PCT_04LX_0X_PCT_04L_2182
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.W  24(A2),D0
    MOVEQ   #0,D1
    MOVE.W  26(A2),D1
    MOVEQ   #0,D2
    MOVE.W  D1,D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     DATA_TLIBA1_FMT_BPLCON0_COLON_0X_PCT_04LX_0X_PCT_04L_2183
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.W  28(A2),D0
    MOVEQ   #0,D1
    MOVE.W  30(A2),D1
    MOVEQ   #0,D2
    MOVE.W  D1,D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     DATA_TLIBA1_FMT_BPLCON1_COLON_0X_PCT_04LX_0X_PCT_04L_2184
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.W  32(A2),D0
    MOVEQ   #0,D1
    MOVE.W  34(A2),D1
    MOVEQ   #0,D2
    MOVE.W  D1,D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     DATA_TLIBA1_FMT_BPLCON2_COLON_0X_PCT_04LX_0X_PCT_04L_2185
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.W  36(A2),D0
    MOVEQ   #0,D1
    MOVE.W  38(A2),D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    PEA     DATA_TLIBA1_FMT_BPL1PTH_COLON_0X_PCT_04LX_0X_PCT_04L_2186
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     72(A7),A7
    MOVEQ   #0,D0
    MOVE.W  40(A2),D0
    MOVEQ   #0,D1
    MOVE.W  42(A2),D1
    MOVEQ   #0,D2
    MOVE.W  38(A2),D2
    SWAP    D2
    CLR.W   D2
    MOVEQ   #0,D3
    MOVE.W  D1,D3
    OR.L    D3,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     DATA_TLIBA1_FMT_BPL1PTL_COLON_0X_PCT_04LX_0X_PCT_04L_2187
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.W  44(A2),D0
    MOVEQ   #0,D1
    MOVE.W  46(A2),D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    PEA     DATA_TLIBA1_FMT_BPL2PTH_COLON_0X_PCT_04LX_0X_PCT_04L_2188
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.W  48(A2),D0
    MOVEQ   #0,D1
    MOVE.W  50(A2),D1
    MOVEQ   #0,D2
    MOVE.W  46(A2),D2
    SWAP    D2
    CLR.W   D2
    MOVEQ   #0,D3
    MOVE.W  D1,D3
    OR.L    D3,D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     DATA_TLIBA1_FMT_BPL2PTL_COLON_0X_PCT_04LX_0X_PCT_04L_2189
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.W  52(A2),D0
    MOVEQ   #0,D1
    MOVE.W  54(A2),D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    PEA     DATA_TLIBA1_FMT_BPL3PTH_COLON_0X_PCT_04LX_0X_PCT_04L_218A
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.W  56(A2),D0
    MOVEQ   #0,D1
    MOVE.W  58(A2),D1
    MOVEQ   #0,D2
    MOVE.W  54(A2),D2
    SWAP    D2
    CLR.W   D2
    MOVEQ   #0,D3
    MOVE.W  D1,D3
    OR.L    D3,D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     DATA_TLIBA1_FMT_BPL3PTL_COLON_0X_PCT_04LX_0X_PCT_04L_218B
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.W  60(A2),D0
    MOVEQ   #0,D1
    MOVE.W  62(A2),D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    PEA     DATA_TLIBA1_FMT_BPL4PTH_COLON_0X_PCT_04LX_0X_PCT_04L_218C
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.W  64(A2),D0
    MOVEQ   #0,D1
    MOVE.W  66(A2),D1
    MOVEQ   #0,D2
    MOVE.W  62(A2),D2
    SWAP    D2
    CLR.W   D2
    MOVEQ   #0,D3
    MOVE.W  D1,D3
    OR.L    D3,D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     DATA_TLIBA1_FMT_BPL4PTL_COLON_0X_PCT_04LX_0X_PCT_04L_218D
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     76(A7),A7
    MOVEQ   #0,D0
    MOVE.W  68(A2),D0
    MOVEQ   #0,D1
    MOVE.W  70(A2),D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     DATA_TLIBA1_FMT_BPL5PTH_COLON_0X_PCT_04LX_0X_PCT_04L_218E
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.W  72(A2),D0
    MOVEQ   #0,D1
    MOVE.W  74(A2),D1
    MOVEQ   #0,D2
    MOVE.W  70(A2),D2
    SWAP    D2
    CLR.W   D2
    MOVEQ   #0,D3
    MOVE.W  D1,D3
    OR.L    D3,D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     DATA_TLIBA1_FMT_BPL5PTL_COLON_0X_PCT_04LX_0X_PCT_04L_218F
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    PEA     DATA_TLIBA1_STR_2190
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     28(A7),A7
    MOVEM.L (A7)+,D2-D3/A2-A3
    RTS

;!======

    LINK.W  A5,#-80

    MOVE.L  DATA_TLIBA1_BSS_LONG_2178,-(A7)
    PEA     Global_STR_VM_ARRAY_1
    PEA     -80(A5)
    JSR     WDISP_SPrintf(PC)

    MOVE.L  DATA_TLIBA1_BSS_LONG_2178,D0
    MOVEQ   #76,D1
    JSR     MATH_Mulu32(PC)

    LEA     TLIBA3_VmArrayPatternTable,A0
    ADDA.L  D0,A0
    MOVE.L  A0,(A7)
    PEA     -80(A5)
    BSR.W   TLIBA3_FormatPatternRegisterDump

    UNLK    A5
    RTS

;!======

    ; Dead code.
    LINK.W  A5,#-84
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D7

.lab_1851:              ; maybe this is the entry point and it's getting removed by a few bytes?
    MOVEQ   #9,D0       ; or is this just being calculated weirdly?
    CMP.L   D0,D7
    BGE.S   .return

    MOVE.L  D7,-(A7)
    PEA     Global_STR_VM_ARRAY_2
    PEA     -84(A5)
    JSR     WDISP_SPrintf(PC)

    MOVE.L  D7,D0
    MOVEQ   #76,D1
    JSR     MATH_Mulu32(PC)

    LEA     TLIBA3_VmArrayPatternTable,A0
    ADDA.L  D0,A0
    MOVE.L  A0,(A7)
    PEA     -84(A5)
    BSR.W   TLIBA3_FormatPatternRegisterDump

    PEA     DATA_TLIBA1_STR_2193
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     20(A7),A7
    ADDQ.L  #1,D7
    BRA.S   .lab_1851

.return:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TLIBA3_InitRuntimeEntry   (TLIBA3_InitRuntimeEntry)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +10: arg_2 (via 14(A5))
;   stack +14: arg_3 (via 18(A5))
;   stack +18: arg_4 (via 22(A5))
;   stack +22: arg_5 (via 26(A5))
;   stack +26: arg_6 (via 30(A5))
;   stack +31: arg_7 (via 35(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0/D1/D2/D4/D5/D6/D7
; CALLS:
;   MATH_Mulu32, _LVOInitBitMap
; READS:
;   Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, LAB_1854, WDISP_DisplayContextPlanePointer0, TLIBA3_VmArrayRuntimeTable
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
TLIBA3_InitRuntimeEntry:
    LINK.W  A5,#-4
    MOVEM.L D2/D4-D7/A2-A3,-(A7)
    MOVE.L  8(A5),D7
    MOVE.W  14(A5),D6
    MOVE.W  18(A5),D5
    MOVE.W  22(A5),D4
    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     MATH_Mulu32(PC)

    LEA     TLIBA3_VmArrayRuntimeTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.W  D6,(A1)
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.W  D5,2(A1)
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.W  D4,4(A1)
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.W  26(A5),6(A1)
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.W  30(A5),8(A1)
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    LEA     10(A1),A2
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #24,D1

.lab_1854:
    MOVE.L  (A1)+,(A2)+
    DBF     D1,.lab_1854
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L A0,A2
    ADDA.L  D0,A2
    LEA     110(A2),A3
    MOVE.L  A3,14(A1)
    ADDA.L  D0,A0
    LEA     110(A0),A1
    MOVEQ   #0,D0
    MOVE.B  35(A5),D0
    MOVEQ   #0,D1
    MOVE.W  D5,D1
    MOVEQ   #0,D2
    MOVE.W  D4,D2
    MOVEA.L A1,A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitBitMap(A6)

    CLR.L   -4(A5)

.lab_1855:
    MOVE.L  -4(A5),D0
    MOVEQ   #5,D1
    CMP.L   D1,D0
    BGE.S   .lab_1856

    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     MATH_Mulu32(PC)

    LEA     TLIBA3_VmArrayRuntimeTable,A0
    ADDA.L  D0,A0
    MOVE.L  -4(A5),D0
    ASL.L   #2,D0
    ADDA.L  D0,A0
    LEA     WDISP_DisplayContextPlanePointer0,A1
    ADDA.L  D0,A1
    MOVE.L  (A1),118(A0)
    ADDQ.L  #1,-4(A5)
    BRA.S   .lab_1855

.lab_1856:
    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     MATH_Mulu32(PC)

    LEA     TLIBA3_VmArrayRuntimeTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEQ   #0,D1
    MOVE.W  D1,150(A1)
    ADDA.L  D0,A0
    MOVE.W  D1,152(A0)
    MOVEM.L (A7)+,D2/D4-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TLIBA3_InitRuntimeEntries   (TLIBA3_InitRuntimeEntries)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A7/D0/D1/D7
; CALLS:
;   TLIBA3_InitRuntimeEntry
; READS:
;   Global_REF_GRAPHICS_LIBRARY, c300, c304
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
TLIBA3_InitRuntimeEntries:
    MOVE.L  D7,-(A7)

    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A0
    MOVE.W  206(A0),D0
    MOVE.L  D0,D7
    ANDI.W  #2,D7
    MOVEQ   #0,D0
    MOVE.W  D7,D0
    ADDI.L  #$c304,D0
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    PEA     4.W
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    PEA     360.W
    PEA     240.W
    PEA     352.W
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   TLIBA3_InitRuntimeEntry

    MOVEQ   #0,D0
    MOVE.W  D7,D0
    ADDI.L  #$c304,D0
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    PEA     4.W
    CLR.L   -(A7)
    PEA     16.W
    PEA     240.W
    PEA     352.W
    MOVE.L  D1,-(A7)
    PEA     1.W
    BSR.W   TLIBA3_InitRuntimeEntry

    MOVEQ   #0,D0
    MOVE.W  D7,D0
    ADDI.L  #$c304,D0
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    PEA     4.W
    CLR.L   -(A7)
    PEA     8.W
    PEA     240.W
    PEA     696.W
    MOVE.L  D1,-(A7)
    PEA     2.W
    BSR.W   TLIBA3_InitRuntimeEntry

    LEA     84(A7),A7
    MOVEQ   #0,D0
    MOVE.W  D7,D0
    ADDI.L  #$8304,D0
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    PEA     1.W
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    PEA     240.W
    PEA     696.W
    MOVE.L  D1,-(A7)
    PEA     3.W
    BSR.W   TLIBA3_InitRuntimeEntry

    MOVEQ   #0,D0
    MOVE.W  D7,D0
    ADDI.L  #$c304,D0
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVEQ   #4,D0
    MOVE.L  D0,(A7)
    CLR.L   -(A7)
    PEA     44.W
    PEA     240.W
    PEA     640.W
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   TLIBA3_InitRuntimeEntry

    LEA     52(A7),A7
    MOVE.L  D7,D0
    ADDI.W  #$4304,D0
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVEQ   #5,D0
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    PEA     44.W
    PEA     240.W
    PEA     320.W
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   TLIBA3_InitRuntimeEntry

    MOVEQ   #0,D0
    MOVE.W  D7,D0
    ADDI.L  #$c300,D0
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    PEA     4.W
    CLR.L   -(A7)
    PEA     44.W
    PEA     120.W
    PEA     640.W
    MOVE.L  D1,-(A7)
    PEA     6.W
    BSR.W   TLIBA3_InitRuntimeEntry

    LEA     56(A7),A7
    MOVE.L  D7,D0
    ADDI.W  #$4300,D0
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    PEA     5.W
    CLR.L   -(A7)
    PEA     44.W
    PEA     120.W
    PEA     320.W
    MOVE.L  D1,-(A7)
    PEA     7.W
    BSR.W   TLIBA3_InitRuntimeEntry

    MOVEQ   #0,D0
    MOVE.W  D7,D0
    ADDI.L  #$c304,D0
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    PEA     4.W
    CLR.L   -(A7)
    PEA     16.W
    PEA     296.W
    PEA     320.W
    MOVE.L  D1,-(A7)
    PEA     8.W
    BSR.W   TLIBA3_InitRuntimeEntry

    LEA     56(A7),A7

    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TLIBA3_SetFontForAllViewModes   (TLIBA3_SetFontForAllViewModes)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A6/A7/D0/D1/D7
; CALLS:
;   MATH_Mulu32, _LVOSetFont
; READS:
;   Global_REF_GRAPHICS_LIBRARY, TLIBA3_VmArrayRuntimeTable
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
TLIBA3_SetFontForAllViewModes:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEQ   #0,D7

.lab_1859:
    MOVEQ   #9,D0
    CMP.L   D0,D7
    BGE.S   .return

    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     MATH_Mulu32(PC)

    LEA     TLIBA3_VmArrayRuntimeTable,A0
    ADDA.L  D0,A0
    LEA     10(A0),A1
    MOVEA.L A3,A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    ADDQ.L  #1,D7
    BRA.S   .lab_1859

.return:
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TLIBA3_JMPTBL_GCOMMAND_ApplyHighlightFlag   (TLIBA3_JMPTBL_GCOMMAND_ApplyHighlightFlag)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   GCOMMAND_ApplyHighlightFlag
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
TLIBA3_JMPTBL_GCOMMAND_ApplyHighlightFlag:
    JMP     GCOMMAND_ApplyHighlightFlag

;!======

    ; Alignment
    MOVEQ   #97,D0
