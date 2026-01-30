LAB_180B:
    LINK.W  A5,#-36
    MOVEM.L D2-D7/A2-A3,-(A7)
    MOVE.W  #1,LAB_2173
    BSR.W   LAB_1857

    MOVEQ   #0,D7

LAB_180C:
    MOVEQ   #9,D0
    CMP.L   D0,D7
    BGE.W   LAB_181D

    MOVE.L  D7,D0
    MOVEQ   #76,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_237F,A0
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
    JSR     LAB_1A06(PC)

    LEA     LAB_237E,A1
    MOVEA.L A1,A2
    ADDA.L  D0,A2
    MOVE.W  6(A2),D0
    MOVE.L  D0,D1
    TST.W   D1
    BPL.S   LAB_180D

    ADDQ.W  #1,D1

LAB_180D:
    ASR.W   #1,D1
    MOVE.W  D0,-16(A5)
    EXT.L   D0
    MOVE.W  D1,-12(A5)
    MOVEQ   #16,D1
    JSR     LAB_1A07(PC)

    ASL.L   #2,D0
    MOVE.W  -16(A5),D1
    EXT.L   D1
    DIVS    #16,D1
    SWAP    D1
    MOVE.W  D0,-14(A5)
    MOVEM.W D1,-18(A5)
    TST.W   D1
    BEQ.S   LAB_1810

    EXT.L   D1
    TST.L   D1
    BPL.S   LAB_180E

    ADDQ.L  #1,D1

LAB_180E:
    ASR.L   #1,D1
    ASL.L   #4,D1
    MOVE.W  -18(A5),D2
    EXT.L   D2
    TST.L   D2
    BPL.S   LAB_180F

    ADDQ.L  #1,D2

LAB_180F:
    ASR.L   #1,D2
    ADD.L   D2,D1
    BRA.S   LAB_1811

LAB_1810:
    MOVEQ   #0,D1

LAB_1811:
    MOVEQ   #40,D6
    MOVE.L  D7,D0
    MOVE.W  D1,-20(A5)
    MOVEQ   #76,D1
    JSR     LAB_1A06(PC)

    MOVEA.L A0,A2
    ADDA.L  D0,A2
    MOVE.L  D6,D0
    MOVE.W  -14(A5),D1
    ADD.W   D1,D0
    MOVE.W  D0,10(A2)
    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     LAB_1A06(PC)

    MOVEA.L A1,A2
    ADDA.L  D0,A2
    BTST    #7,(A2)
    BEQ.S   LAB_1812

    MOVEQ   #4,D0
    BRA.S   LAB_1813

LAB_1812:
    MOVEQ   #2,D0

LAB_1813:
    MOVE.L  D0,D4
    MOVE.L  D7,D0
    MOVEQ   #76,D1
    JSR     LAB_1A06(PC)

    MOVEA.L A0,A2
    ADDA.L  D0,A2
    MOVE.W  -14(A5),D1
    ADD.W   D6,D1
    MOVE.L  D0,32(A7)
    MOVE.L  D7,D0
    MOVE.W  D1,40(A7)
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     LAB_1A06(PC)

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
    BEQ.S   LAB_1814

    MOVEQ   #2,D0
    BRA.S   LAB_1815

LAB_1814:
    MOVEQ   #1,D0

LAB_1815:
    MOVE.L  D0,D4
    MOVE.L  D7,D0
    MOVEQ   #76,D1
    JSR     LAB_1A06(PC)

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
    JSR     LAB_1A06(PC)

    MOVEA.L A1,A3
    ADDA.L  D0,A3
    MOVEQ   #0,D1
    MOVE.W  2(A3),D1
    MOVEQ   #0,D3
    MOVE.W  D4,D3
    MOVE.L  D0,40(A7)
    MOVE.L  D1,D0
    MOVE.L  D3,D1
    JSR     LAB_1A07(PC)

    MOVE.L  36(A7),D1
    ADD.L   D0,D1
    AND.L   D2,D1
    ADDI.L  #$ff00,D1
    MOVE.W  D1,6(A2)
    MOVE.L  40(A7),D0
    MOVEA.L A1,A2
    ADDA.L  D0,A2
    BTST    #2,1(A2)
    BEQ.S   LAB_1816

    MOVEA.L A1,A2
    ADDA.L  D0,A2
    MOVEQ   #0,D0
    MOVE.W  2(A2),D0
    MOVEQ   #15,D1
    ADD.L   D1,D0
    ASR.L   #3,D0
    ANDI.L  #$fffe,D0
    BRA.S   LAB_1817

LAB_1816:
    MOVEQ   #0,D0

LAB_1817:
    MOVE.W  D0,-22(A5)
    TST.L   D7
    BNE.S   LAB_1818

    MOVE.W  D0,-22(A5)
    BRA.S   LAB_181C

LAB_1818:
    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     LAB_1A06(PC)

    MOVEA.L A1,A2
    ADDA.L  D0,A2
    MOVEQ   #0,D0
    MOVE.W  (A2),D0
    MOVE.L  #$8004,D1
    AND.L   D1,D0
    CMPI.L  #$8004,D0
    BNE.S   LAB_1819

    SUBQ.W  #4,-22(A5)
    BRA.S   LAB_181C

LAB_1819:
    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     LAB_1A06(PC)

    MOVEA.L A1,A2
    ADDA.L  D0,A2
    BTST    #7,(A2)
    BEQ.S   LAB_181A

    SUBQ.W  #4,-22(A5)
    BRA.S   LAB_181C

LAB_181A:
    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     LAB_1A06(PC)

    MOVEA.L A1,A2
    ADDA.L  D0,A2
    BTST    #2,1(A2)
    BEQ.S   LAB_181B

    SUBQ.W  #2,-22(A5)
    BRA.S   LAB_181C

LAB_181B:
    SUBQ.W  #2,-22(A5)

LAB_181C:
    MOVE.L  D7,D0
    MOVEQ   #76,D1
    JSR     LAB_1A06(PC)

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
    JSR     LAB_1A06(PC)

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
    BRA.W   LAB_180C

LAB_181D:
    MOVEM.L (A7)+,D2-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_181E:
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
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
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

.LAB_181F:
    MOVEA.L A2,A0

.LAB_1820:
    TST.B   (A0)+
    BNE.S   .LAB_1820

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    MOVE.L  A0,-12(A5)

.LAB_1821:
    MOVE.L  -12(A5),D0
    TST.L   D0
    BLE.S   .LAB_1823

    MOVEA.L A3,A1
    MOVEA.L A2,A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D5,D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .LAB_1822

    ADDQ.L  #1,D1

.LAB_1822:
    ASR.L   #1,D1
    MOVE.L  D1,D6
    BGE.S   .LAB_1823

    SUBQ.L  #1,-12(A5)
    BRA.S   .LAB_1821

.LAB_1823:
    TST.B   -18(A5)
    BEQ.S   .LAB_1824

    MOVEQ   #0,D0
    BRA.S   .LAB_1825

.LAB_1824:
    MOVE.L  -12(A5),D0
    MOVE.B  0(A2,D0.L),D0
    EXT.W   D0
    EXT.L   D0

.LAB_1825:
    MOVE.L  -12(A5),D1
    CLR.B   0(A2,D1.L)
    MOVE.B  D0,-18(A5)
    TST.L   D6
    BMI.S   .LAB_1826

    MOVE.L  A2,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  A3,-(A7)
    JSR     JMP_TBL_DISPLAY_TEXT_AT_POSITION_2(PC)

    LEA     16(A7),A7

.LAB_1826:
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
    BNE.W   .LAB_181F

    MOVE.B  -16(A5),D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L A3,A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
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

LAB_1827:
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
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
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

.LAB_1828:
    MOVEA.L 4(A3),A0
    MOVEQ   #0,D0
    MOVE.W  2(A0),D0
    SUBQ.L  #1,D0
    CMP.L   D0,D6
    BGE.W   .return

    MOVE.L  D6,D0
    MOVEQ   #10,D1
    JSR     LAB_1A07(PC)

    TST.L   D1
    BNE.S   .LAB_182A

    TST.L   D6
    BEQ.S   .LAB_182A

    MOVEA.L A3,A1
    MOVE.L  D7,D0
    MOVE.L  D6,D1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
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
    PEA     LAB_2175
    PEA     -84(A5)
    JSR     WDISP_SPrintf(PC)

    LEA     12(A7),A7
    LEA     -84(A5),A0
    MOVEA.L A0,A1

.LAB_1829:
    TST.B   (A1)+
    BNE.S   .LAB_1829

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,16(A7)
    MOVEA.L A3,A1
    MOVE.L  16(A7),D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOText(A6)

    BRA.S   .LAB_182B

.LAB_182A:
    MOVE.L  D6,D0
    MOVEQ   #5,D1
    JSR     LAB_1A07(PC)

    TST.L   D1
    BNE.S   .LAB_182B

    MOVEA.L A3,A1
    MOVE.L  D7,D0
    MOVE.L  D6,D1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVE.L  D7,D0
    MOVEQ   #10,D1
    ADD.L   D1,D0
    MOVEA.L A3,A1
    MOVE.L  D6,D1
    JSR     _LVODraw(A6)

.LAB_182B:
    ADDQ.L  #1,D6
    BRA.W   .LAB_1828

.return:
    MOVEM.L (A7)+,D5-D7/A3
    UNLK    A5
    RTS

;!======

LAB_182D:
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
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
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

.LAB_182E:
    MOVEA.L 4(A3),A0
    MOVEQ   #0,D0
    MOVE.W  (A0),D0
    ASL.L   #3,D0
    SUBQ.L  #1,D0
    CMP.L   D0,D6
    BGE.W   .return

    MOVE.L  D6,D0
    MOVEQ   #25,D1
    JSR     LAB_1A07(PC)

    TST.L   D1
    BNE.W   .LAB_1832

    TST.L   D6
    BEQ.W   .LAB_1832

    MOVEA.L A3,A1
    MOVE.L  D6,D0
    MOVE.L  D7,D1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
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
    PEA     LAB_2176
    PEA     -84(A5)
    JSR     WDISP_SPrintf(PC)

    LEA     12(A7),A7
    LEA     -84(A5),A0
    MOVEA.L A0,A1

.LAB_182F:
    TST.B   (A1)+
    BNE.S  .LAB_182F

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,16(A7)
    MOVEA.L A3,A1
    MOVE.L  16(A7),D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    TST.L   D0
    BPL.S   .LAB_1830

    ADDQ.L  #1,D0

.LAB_1830:
    ASR.L   #1,D0
    MOVE.L  D6,D1
    SUB.L   D0,D1
    MOVE.L  D6,D0
    MOVE.L  D1,16(A7)
    MOVEQ   #2,D1
    JSR     LAB_1A07(PC)

    MOVEQ   #10,D0
    JSR     LAB_1A06(PC)

    MOVE.L  D5,D1
    ADD.L   D0,D1
    MOVEA.L A3,A1
    MOVE.L  16(A7),D0
    JSR     _LVOMove(A6)

    LEA     -84(A5),A0
    MOVEA.L A0,A1

.LAB_1831:
    TST.B   (A1)+
    BNE.S   .LAB_1831

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,16(A7)
    MOVEA.L A3,A1
    MOVE.L  16(A7),D0
    JSR     _LVOText(A6)

    BRA.S   .LAB_1833

.LAB_1832:
    MOVE.L  D6,D0
    MOVEQ   #5,D1
    JSR     LAB_1A07(PC)

    TST.L   D1
    BNE.S   .LAB_1833

    MOVEA.L A3,A1
    MOVE.L  D6,D0
    MOVE.L  D7,D1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVE.L  D7,D0
    MOVEQ   #10,D1
    ADD.L   D1,D0
    MOVE.L  D0,16(A7)
    MOVEA.L A3,A1
    MOVE.L  D6,D0
    MOVE.L  16(A7),D1
    JSR     _LVODraw(A6)

.LAB_1833:
    ADDQ.L  #1,D6
    BRA.W   .LAB_182E

.return:
    MOVEM.L (A7)+,D5-D7/A3
    UNLK    A5
    RTS

;!======

LAB_1835:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
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

LAB_1836:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
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

LAB_1837:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    MOVEA.L A3,A1
    MOVEA.L GLOB_HANDLE_TOPAZ_FONT,A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
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
    BPL.S   .LAB_1838

    ADDQ.L  #1,D0

.LAB_1838:
    ASR.L   #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1827

    MOVEA.L 4(A3),A0
    MOVEQ   #0,D0
    MOVE.W  2(A0),D0
    TST.L   D0
    BPL.S   .LAB_1839

    ADDQ.L  #1,D0

.LAB_1839:
    ASR.L   #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_182D

    MOVE.L  A3,(A7)
    BSR.W   LAB_1835

    MOVE.L  A3,(A7)
    BSR.W   LAB_1836

    LEA     12(A7),A7
    MOVEA.L A3,A1
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    MOVEA.L (A7)+,A3
    RTS

;!======

LAB_183A:
    LINK.W  A5,#-88
    MOVEM.L D5-D7,-(A7)
    MOVE.L  8(A5),D7

    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_237E,A0
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
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_237E,A0
    ADDA.L  D0,A0
    LEA     10(A0),A1
    MOVEQ   #0,D0
    JSR     _LVOSetRast(A6)

    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_237E,A0
    ADDA.L  D0,A0
    LEA     10(A0),A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_237E,A0
    ADDA.L  D0,A0
    LEA     10(A0),A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_237E,A0
    ADDA.L  D0,A0
    LEA     10(A0),A1
    MOVEQ   #0,D0
    JSR     _LVOSetBPen(A6)

    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_237E,A0
    ADDA.L  D0,A0
    LEA     10(A0),A1
    MOVE.L  A1,-(A7)
    BSR.W   LAB_1837

    MOVE.L  D7,(A7)
    PEA     LAB_2177
    PEA     -88(A5)
    JSR     WDISP_SPrintf(PC)

    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_237E,A0
    ADDA.L  D0,A0
    LEA     10(A0),A1
    PEA     90.W
    PEA     -88(A5)
    MOVE.L  A1,-(A7)
    BSR.W   LAB_181E

    MOVEM.L -100(A5),D5-D7
    UNLK    A5
    RTS

;!======

LAB_183B:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7

    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_237E,A0
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
    JSR     LAB_1A06(PC)

    LEA     LAB_237E,A0
    ADDA.L  D0,A0
    MOVE.W  2(A0),D0
    MOVE.L  (A7)+,D7
    RTS

;!======

LAB_183C:
    MOVEM.L D6-D7,-(A7)
    MOVE.L  12(A7),D7
    MOVE.L  16(A7),D6

    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_237E,A0
    ADDA.L  D0,A0
    LEA     10(A0),A1
    MOVE.L  D6,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    MOVEM.L (A7)+,D6-D7
    RTS

;!======

LAB_183D:
    MOVE.L  D7,-(A7)

    MOVE.L  8(A7),D7
    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_237E,A0
    ADDA.L  D0,A0
    LEA     10(A0),A1
    MOVE.L  A1,D0

    MOVE.L  (A7)+,D7
    RTS

;!======

LAB_183E:
    LINK.W  A5,#-256
    MOVEM.L D2-D3/D5-D7/A2,-(A7)
    MOVE.L  8(A5),D7
    MOVE.W  18(A5),D6

    MOVE.L  D7,LAB_2178
    TST.W   LAB_2173
    BNE.S   .LAB_183F

    BSR.W   LAB_180B

.LAB_183F:
    MOVE.L  #LAB_1E25,-4(A5)
    MOVE.L  #LAB_1E54,-8(A5)
    MOVE.L  D7,D0
    MOVEQ   #76,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_237F,A0
    ADDA.L  D0,A0
    LEA     -84(A5),A1
    MOVEA.L A1,A2
    MOVEQ   #18,D0

.LAB_1840:
    MOVE.L  (A0)+,(A2)+
    DBF     D0,.LAB_1840
    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_237E,A0
    MOVEA.L A0,A2
    ADDA.L  D0,A2
    MOVEQ   #0,D1
    MOVE.W  (A2),D1
    MOVE.L  #$8004,D2
    AND.L   D2,D1
    CMPI.L  #$8004,D1
    BNE.S   .LAB_1841

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
    BRA.S   .LAB_1844

.LAB_1841:
    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     LAB_1A06(PC)

    MOVEA.L A0,A2
    ADDA.L  D0,A2
    BTST    #7,(A2)
    BEQ.S   .LAB_1842

    MOVEQ   #-2,D0
    MOVE.L  D0,-248(A5)
    MOVE.L  D0,-244(A5)
    BRA.S   .LAB_1844

.LAB_1842:
    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     LAB_1A06(PC)

    MOVEA.L A0,A2
    ADDA.L  D0,A2
    BTST    #2,1(A2)
    BEQ.S   .LAB_1843

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
    BRA.S   .LAB_1844

.LAB_1843:
    MOVEQ   #0,D0
    MOVE.L  D0,-248(A5)
    MOVE.L  D0,-244(A5)

.LAB_1844:
    TST.L   D7
    BNE.S   .LAB_1845

    MOVEQ   #0,D0
    MOVE.L  D0,-244(A5)
    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     LAB_1A06(PC)

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

.LAB_1845:
    MOVEQ   #-1,D0
    CMP.W   D0,D6
    BEQ.S   .LAB_1846

    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     LAB_1A06(PC)

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

.LAB_1846:
    MOVEA.L A1,A0
    LEA     -160(A5),A2
    MOVEQ   #18,D0

.LAB_1847:
    MOVE.L  (A0)+,(A2)+
    DBF     D0,.LAB_1847
    LEA     -236(A5),A0
    MOVEQ   #18,D0

.LAB_1848:
    MOVE.L  (A1)+,(A0)+
    DBF     D0,.LAB_1848
    LEA     -122(A5),A0
    CLR.L   -256(A5)
    MOVE.L  A0,-252(A5)

.LAB_1849:
    CMPI.L  #$5,-256(A5)
    BGE.S   .LAB_184A

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
    BRA.S   .LAB_1849

.LAB_184A:
    LEA     -198(A5),A0
    CLR.L   -256(A5)
    MOVE.L  A0,-252(A5)

.LAB_184B:
    CMPI.L  #$5,-256(A5)
    BGE.S   .LAB_184C

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
    BRA.S   .LAB_184B

.LAB_184C:
    LEA     -160(A5),A0
    MOVEA.L -4(A5),A1
    MOVEQ   #18,D0

.LAB_184D:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.LAB_184D
    LEA     -236(A5),A0
    MOVEA.L -8(A5),A1
    MOVEQ   #18,D0

.LAB_184E:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.LAB_184E
    JSR     LAB_185B(PC)

    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_237E,A0
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
    MOVE.L  LAB_2178,-(A7)
    BSR.W   LAB_183E

    LEA     12(A7),A7
    MOVE.L  D0,LAB_2216
    MOVE.L  (A7)+,D7
    RTS

;!======

LAB_184F:
    MOVE.L  LAB_2178,D0
    ADDQ.L  #1,D0
    MOVEQ   #9,D1
    JSR     LAB_1A07(PC)

    MOVE.L  D1,LAB_2178
    PEA     -1.W
    CLR.L   -(A7)
    MOVE.L  D1,-(A7)
    BSR.W   LAB_183E

    MOVE.L  D0,LAB_2216
    MOVE.L  LAB_2178,(A7)
    BSR.W   LAB_183A

    LEA     12(A7),A7
    RTS

;!======

LAB_1850:
    MOVEM.L D2-D3/A2-A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVEA.L 24(A7),A2
    MOVE.W  LAB_2179,D0
    EXT.L   D0
    MOVE.W  LAB_217A,D1
    EXT.L   D1
    MOVE.W  LAB_217B,D2
    EXT.L   D2
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    PEA     LAB_217C
    JSR     LAB_1906(PC)

    MOVEQ   #0,D0
    MOVE.W  (A2),D0
    MOVEQ   #0,D1
    MOVE.W  2(A2),D1
    MOVEQ   #0,D2
    MOVE.W  D1,D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_217D
    JSR     LAB_1906(PC)

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
    PEA     LAB_217E
    JSR     LAB_1906(PC)

    MOVEQ   #0,D0
    MOVE.W  8(A2),D0
    MOVEQ   #0,D1
    MOVE.W  10(A2),D1
    MOVEQ   #0,D2
    MOVE.W  D1,D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_217F
    JSR     LAB_1906(PC)

    MOVEQ   #0,D0
    MOVE.W  12(A2),D0
    MOVEQ   #0,D1
    MOVE.W  14(A2),D1
    MOVEQ   #0,D2
    MOVE.W  D1,D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_2180
    JSR     LAB_1906(PC)

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
    PEA     LAB_2181
    JSR     LAB_1906(PC)

    MOVEQ   #0,D0
    MOVE.W  20(A2),D0
    MOVEQ   #0,D1
    MOVE.W  22(A2),D1
    MOVEQ   #0,D2
    MOVE.W  D1,D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_2182
    JSR     LAB_1906(PC)

    MOVEQ   #0,D0
    MOVE.W  24(A2),D0
    MOVEQ   #0,D1
    MOVE.W  26(A2),D1
    MOVEQ   #0,D2
    MOVE.W  D1,D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_2183
    JSR     LAB_1906(PC)

    MOVEQ   #0,D0
    MOVE.W  28(A2),D0
    MOVEQ   #0,D1
    MOVE.W  30(A2),D1
    MOVEQ   #0,D2
    MOVE.W  D1,D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_2184
    JSR     LAB_1906(PC)

    MOVEQ   #0,D0
    MOVE.W  32(A2),D0
    MOVEQ   #0,D1
    MOVE.W  34(A2),D1
    MOVEQ   #0,D2
    MOVE.W  D1,D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_2185
    JSR     LAB_1906(PC)

    MOVEQ   #0,D0
    MOVE.W  36(A2),D0
    MOVEQ   #0,D1
    MOVE.W  38(A2),D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_2186
    JSR     LAB_1906(PC)

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
    PEA     LAB_2187
    JSR     LAB_1906(PC)

    MOVEQ   #0,D0
    MOVE.W  44(A2),D0
    MOVEQ   #0,D1
    MOVE.W  46(A2),D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_2188
    JSR     LAB_1906(PC)

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
    PEA     LAB_2189
    JSR     LAB_1906(PC)

    MOVEQ   #0,D0
    MOVE.W  52(A2),D0
    MOVEQ   #0,D1
    MOVE.W  54(A2),D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_218A
    JSR     LAB_1906(PC)

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
    PEA     LAB_218B
    JSR     LAB_1906(PC)

    MOVEQ   #0,D0
    MOVE.W  60(A2),D0
    MOVEQ   #0,D1
    MOVE.W  62(A2),D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_218C
    JSR     LAB_1906(PC)

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
    PEA     LAB_218D
    JSR     LAB_1906(PC)

    LEA     76(A7),A7
    MOVEQ   #0,D0
    MOVE.W  68(A2),D0
    MOVEQ   #0,D1
    MOVE.W  70(A2),D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_218E
    JSR     LAB_1906(PC)

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
    PEA     LAB_218F
    JSR     LAB_1906(PC)

    PEA     LAB_2190
    JSR     LAB_1906(PC)

    LEA     28(A7),A7
    MOVEM.L (A7)+,D2-D3/A2-A3
    RTS

;!======

LAB_1850_NOT_DIRECT_CALLED:
    LINK.W  A5,#-80

    MOVE.L  LAB_2178,-(A7)
    PEA     GLOB_STR_VM_ARRAY_1
    PEA     -80(A5)
    JSR     WDISP_SPrintf(PC)

    MOVE.L  LAB_2178,D0
    MOVEQ   #76,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_237F,A0
    ADDA.L  D0,A0
    MOVE.L  A0,(A7)
    PEA     -80(A5)
    BSR.W   LAB_1850

    UNLK    A5
    RTS

;!======

    ; Dead code.
    LINK.W  A5,#-84
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D7

.LAB_1851:              ; maybe this is the entry point and it's getting removed by a few bytes?
    MOVEQ   #9,D0       ; or is this just being calculated weirdly?
    CMP.L   D0,D7
    BGE.S   .return

    MOVE.L  D7,-(A7)
    PEA     GLOB_STR_VM_ARRAY_2
    PEA     -84(A5)
    JSR     WDISP_SPrintf(PC)

    MOVE.L  D7,D0
    MOVEQ   #76,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_237F,A0
    ADDA.L  D0,A0
    MOVE.L  A0,(A7)
    PEA     -84(A5)
    BSR.W   LAB_1850

    PEA     LAB_2193
    JSR     LAB_1906(PC)

    LEA     20(A7),A7
    ADDQ.L  #1,D7
    BRA.S   .LAB_1851

.return:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======

LAB_1853:
    LINK.W  A5,#-4
    MOVEM.L D2/D4-D7/A2-A3,-(A7)
    MOVE.L  8(A5),D7
    MOVE.W  14(A5),D6
    MOVE.W  18(A5),D5
    MOVE.W  22(A5),D4
    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_237E,A0
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
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #24,D1

.LAB_1854:
    MOVE.L  (A1)+,(A2)+
    DBF     D1,.LAB_1854
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
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitBitMap(A6)

    CLR.L   -4(A5)

.LAB_1855:
    MOVE.L  -4(A5),D0
    MOVEQ   #5,D1
    CMP.L   D1,D0
    BGE.S   .LAB_1856

    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_237E,A0
    ADDA.L  D0,A0
    MOVE.L  -4(A5),D0
    ASL.L   #2,D0
    ADDA.L  D0,A0
    LEA     LAB_2224,A1
    ADDA.L  D0,A1
    MOVE.L  (A1),118(A0)
    ADDQ.L  #1,-4(A5)
    BRA.S   .LAB_1855

.LAB_1856:
    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_237E,A0
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

LAB_1857:
    MOVE.L  D7,-(A7)

    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A0
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
    BSR.W   LAB_1853

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
    BSR.W   LAB_1853

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
    BSR.W   LAB_1853

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
    BSR.W   LAB_1853

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
    BSR.W   LAB_1853

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
    BSR.W   LAB_1853

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
    BSR.W   LAB_1853

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
    BSR.W   LAB_1853

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
    BSR.W   LAB_1853

    LEA     56(A7),A7

    MOVE.L  (A7)+,D7
    RTS

;!======

LAB_1858:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEQ   #0,D7

.LAB_1859:
    MOVEQ   #9,D0
    CMP.L   D0,D7
    BGE.S   .return

    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_237E,A0
    ADDA.L  D0,A0
    LEA     10(A0),A1
    MOVEA.L A3,A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    ADDQ.L  #1,D7
    BRA.S   .LAB_1859

.return:
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

LAB_185B:
    JMP     GCOMMAND_ApplyHighlightFlag

;!======

    ; Alignment
    MOVEQ   #97,D0
