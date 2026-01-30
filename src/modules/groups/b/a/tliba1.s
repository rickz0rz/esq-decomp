;!======

LAB_175F:
    LINK.W  A5,#-20
    MOVEM.L D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  16(A5),D6
    MOVE.B  23(A5),D5
    MOVEA.L 28(A5),A2
    CLR.L   -16(A5)
    MOVE.L  A2,D0
    BEQ.S   LAB_1762

    TST.B   (A2)
    BEQ.S   LAB_1762

    MOVEA.L A2,A0

LAB_1760:
    TST.B   (A0)+
    BNE.S   LAB_1760

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-20(A5)
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D0,-(A7)
    PEA     1842.W
    PEA     GLOB_STR_TLIBA1_C_1
    JSR     MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-16(A5)
    MOVEA.L A2,A0
    MOVEA.L D0,A1

LAB_1761:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_1761

LAB_1762:
    TST.L   -16(A5)
    BEQ.W   LAB_176B

    MOVEA.L -16(A5),A0
    PEA     19.W
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-12(A5)
    JSR     LAB_1979(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    MOVEA.L A3,A1
    MOVE.L  D7,D0
    MOVE.L  D6,D1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    TST.L   -8(A5)
    BEQ.W   LAB_1768

LAB_1763:
    MOVEA.L -12(A5),A0
    PEA     20.W
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-4(A5)
    JSR     LAB_1979(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-12(A5)
    TST.L   -8(A5)
    BEQ.S   LAB_1764

    MOVEQ   #0,D1
    MOVEA.L -8(A5),A0
    MOVE.B  D1,(A0)+
    MOVE.L  A0,-8(A5)

LAB_1764:
    TST.L   D0
    BEQ.S   LAB_1765

    MOVEA.L D0,A0
    CLR.B   (A0)+
    MOVE.L  A0,-12(A5)

LAB_1765:
    TST.L   -4(A5)
    BEQ.S   LAB_1767

    MOVEA.L -4(A5),A0
    TST.B   (A0)
    BEQ.S   LAB_1767

LAB_1766:
    TST.B   (A0)+
    BNE.S   LAB_1766

    SUBQ.L  #1,A0
    SUBA.L  -4(A5),A0
    MOVEA.L A3,A1
    MOVE.L  A0,D0
    MOVEA.L -4(A5),A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOText(A6)

LAB_1767:
    MOVEQ   #0,D0
    MOVE.B  D5,D0
    MOVEQ   #0,D1
    MOVE.B  27(A5),D1
    MOVE.L  -8(A5),-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_15A6(PC)

    LEA     16(A7),A7
    PEA     19.W
    MOVE.L  -12(A5),-(A7)
    JSR     LAB_1979(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    TST.L   D0
    BNE.W   LAB_1763

LAB_1768:
    TST.L   -12(A5)
    BEQ.S   LAB_176A

    MOVEA.L -12(A5),A0
    TST.B   (A0)
    BEQ.S   LAB_176A

LAB_1769:
    TST.B   (A0)+
    BNE.S   LAB_1769

    SUBQ.L  #1,A0
    SUBA.L  -12(A5),A0
    MOVEA.L A3,A1
    MOVE.L  A0,D0
    MOVEA.L -12(A5),A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOText(A6)

LAB_176A:
    MOVE.L  -20(A5),-(A7)
    MOVE.L  -16(A5),-(A7)
    PEA     1885.W
    PEA     GLOB_STR_TLIBA1_C_2
    JSR     MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

LAB_176B:
    MOVEM.L (A7)+,D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_176C:
    MOVE.L  D7,-(A7)
    MOVE.B  11(A7),D7
    MOVEQ   #88,D0
    CMP.B   D0,D7
    BNE.S   LAB_176D

    MOVEQ   #-1,D7
    BRA.S   LAB_1770

LAB_176D:
    MOVEQ   #49,D0
    CMP.B   D0,D7
    BCS.S   LAB_176E

    MOVEQ   #55,D0
    CMP.B   D0,D7
    BLS.S   LAB_176F

LAB_176E:
    MOVEQ   #0,D7
    BRA.S   LAB_1770

LAB_176F:
    SUBI.B  #$30,D7

LAB_1770:
    MOVE.L  D7,D0
    MOVE.L  (A7)+,D7
    RTS

;!======

LAB_1771:
    LINK.W  A5,#-24
    MOVEM.L D2-D3/D5-D7/A2-A3/A6,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  16(A5),D6
    MOVEA.L 20(A5),A2
    MOVEQ   #0,D0
    MOVE.L  D0,-18(A5)
    MOVE.L  D0,-14(A5)
    TST.B   LAB_1B5D
    BEQ.S   LAB_1772

    PEA     19.W
    MOVE.L  A2,-(A7)
    JSR     LAB_1979(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   LAB_1772

    PEA     20.W
    MOVE.L  A2,-(A7)
    JSR     LAB_1979(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   LAB_1772

    MOVEQ   #0,D0
    MOVE.B  LAB_21B4,D0
    MOVEQ   #0,D1
    MOVE.B  LAB_21B3,D1
    MOVE.L  A2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_175F

    LEA     24(A7),A7
    CLR.B   LAB_1B5D
    BRA.W   LAB_1788

LAB_1772:
    PEA     30.W
    MOVE.L  A2,-(A7)
    JSR     LAB_1979(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.W   LAB_1780

LAB_1773:
    MOVEQ   #1,D0
    MOVEA.L -4(A5),A0
    ADDQ.L  #1,A0
    MOVE.L  D0,-22(A5)
    MOVE.L  A0,-8(A5)

LAB_1774:
    MOVEA.L -8(A5),A0
    CMPI.B  #$20,(A0)
    BLS.S   LAB_1775

    ADDQ.L  #1,-8(A5)
    ADDQ.L  #1,-22(A5)
    BRA.S   LAB_1774

LAB_1775:
    MOVEA.L A3,A1
    MOVEA.L -4(A5),A0
    MOVE.L  -22(A5),D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    ADD.L   D0,-14(A5)
    CMPI.L  #$2,-22(A5)
    BLE.S   LAB_1776

    MOVEQ   #0,D0
    MOVEA.L -4(A5),A0
    MOVE.B  1(A0),D0
    MOVE.L  D0,-(A7)
    BSR.W   LAB_176C

    MOVEQ   #0,D1
    MOVEA.L -4(A5),A0
    MOVE.B  2(A0),D1
    MOVE.L  D1,(A7)
    MOVE.B  D0,-10(A5)
    BSR.W   LAB_176C

    ADDQ.W  #4,A7
    MOVE.L  D0,D5
    BRA.S   LAB_1777

LAB_1776:
    MOVEQ   #0,D0
    MOVE.L  D0,D5
    MOVE.B  D0,-10(A5)

LAB_1777:
    MOVEQ   #0,D0
    MOVE.B  -10(A5),D0
    MOVEQ   #0,D1
    NOT.B   D1
    CMP.L   D1,D0
    BEQ.S   LAB_1778

    MOVEQ   #1,D2
    CMP.B   D2,D0
    BCS.S   LAB_177A

    MOVEQ   #7,D3
    CMP.B   D3,D0
    BHI.S   LAB_177A

LAB_1778:
    MOVEQ   #0,D0
    MOVE.B  D5,D0
    CMP.L   D1,D0
    BEQ.S   LAB_1779

    MOVEQ   #1,D0
    CMP.B   D0,D5
    BCS.S   LAB_177A

    MOVEQ   #7,D0
    CMP.B   D0,D5
    BHI.S   LAB_177A

LAB_1779:
    MOVEA.L -4(A5),A0
    CMPI.B  #$20,3(A0)
    BHI.S   LAB_177C

LAB_177A:
    MOVEA.L -8(A5),A0

LAB_177B:
    TST.B   (A0)+
    BNE.S   LAB_177B

    SUBQ.L  #1,A0
    SUBA.L  -8(A5),A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  -8(A5),-(A7)
    JSR     LAB_1AAE(PC)

    LEA     12(A7),A7
    BRA.S   LAB_177E

LAB_177C:
    MOVE.B  #$13,(A0)
    LEA     3(A0),A1
    LEA     1(A0),A6
    MOVE.L  -22(A5),D0
    SUBQ.L  #3,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A6,-(A7)
    MOVE.L  A1,-(A7)
    JSR     LAB_1AAE(PC)

    MOVEA.L -4(A5),A0
    ADDA.L  -22(A5),A0
    MOVE.B  #$14,-2(A0)
    SUBQ.L  #1,A0
    MOVEA.L -8(A5),A1

LAB_177D:
    TST.B   (A1)+
    BNE.S   LAB_177D

    SUBQ.L  #1,A1
    SUBA.L  -8(A5),A1
    MOVE.L  A1,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  -8(A5),-(A7)
    JSR     LAB_1AAE(PC)

    LEA     20(A7),A7
    MOVEA.L -4(A5),A0
    ADDQ.L  #1,A0
    MOVE.L  -22(A5),D0
    SUBQ.L  #3,D0
    MOVEA.L A3,A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    ADD.L   D0,-18(A5)
    MOVEQ   #0,D0
    MOVE.B  -10(A5),D0
    MOVEQ   #0,D1
    NOT.B   D1
    CMP.L   D1,D0
    BEQ.S   LAB_177E

    ADDQ.L  #8,-18(A5)

LAB_177E:
    PEA     30.W
    MOVE.L  A2,-(A7)
    JSR     LAB_1979(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BNE.W   LAB_1773

    MOVE.L  -14(A5),D0
    SUB.L   -18(A5),D0
    TST.L   D0
    BPL.S   LAB_177F

    ADDQ.L  #1,D0

LAB_177F:
    ASR.L   #1,D0
    ADD.L   D0,D7
    MOVEQ   #0,D0
    MOVE.B  D5,D0
    MOVEQ   #0,D1
    MOVE.B  -10(A5),D1
    MOVE.L  A2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_175F

    LEA     24(A7),A7
    BRA.W   LAB_1788

LAB_1780:
    PEA     23.W
    MOVE.L  A2,-(A7)
    JSR     LAB_1979(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.W   LAB_1787

    MOVEA.L D0,A0
    MOVE.B  #$13,(A0)+
    MOVE.L  A0,-4(A5)
    MOVEA.L A3,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    TST.L   D0
    BPL.S   LAB_1781

    ADDQ.L  #1,D0

LAB_1781:
    ASR.L   #1,D0
    ADD.L   D0,D7
    MOVEQ   #0,D0
    MOVEA.L -4(A5),A0
    MOVE.B  (A0),D0
    MOVE.L  D0,-(A7)
    JSR     GROUPD_JMP_TBL_LAB_0EE8(PC)

    ADDQ.W  #4,A7
    MOVE.B  D0,-10(A5)
    MOVEQ   #1,D1
    CMP.B   D1,D0
    BCS.S   LAB_1782

    MOVEQ   #7,D1
    CMP.B   D1,D0
    BLS.S   LAB_1783

LAB_1782:
    MOVE.B  #$ff,-10(A5)

LAB_1783:
    MOVEQ   #0,D0
    MOVEA.L -4(A5),A0
    MOVE.B  (A0),D0
    MOVE.L  D0,-(A7)
    JSR     GROUPD_JMP_TBL_LAB_0EE9(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D5
    MOVEQ   #1,D0
    CMP.B   D0,D5
    BCS.S   LAB_1784

    MOVEQ   #7,D0
    CMP.B   D0,D5
    BLS.S   LAB_1785

LAB_1784:
    MOVEQ   #-1,D5

LAB_1785:
    MOVEA.L -4(A5),A0
    MOVE.B  1(A0),D0
    MOVEQ   #32,D1
    CMP.B   D1,D0
    BLS.S   LAB_1786

    MOVE.B  D0,(A0)
    ADDQ.L  #1,-4(A5)
    BRA.S   LAB_1785

LAB_1786:
    MOVEA.L -4(A5),A0
    MOVE.B  #$14,(A0)
    MOVEQ   #0,D0
    MOVE.B  D5,D0
    MOVEQ   #0,D1
    MOVE.B  -10(A5),D1
    MOVE.L  A2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_175F

    LEA     24(A7),A7
    BRA.S   LAB_1788

LAB_1787:
    MOVE.L  A2,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  A3,-(A7)
    JSR     JMP_TBL_DISPLAY_TEXT_AT_POSITION_2(PC)

    LEA     16(A7),A7

LAB_1788:
    MOVEM.L (A7)+,D2-D3/D5-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

LAB_1789:
    LINK.W  A5,#-48
    MOVEM.L D2-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.W  18(A5),D7
    MOVE.W  22(A5),D6
    MOVE.W  26(A5),D5
    MOVEQ   #0,D0
    MOVE.L  D5,D1
    SUB.W   D7,D1
    ADDQ.W  #1,D1
    MOVE.W  30(A5),D2
    SUB.W   D6,D2
    ADDQ.W  #1,D2
    MOVE.L  A2,-8(A5)
    MOVE.W  D0,-28(A5)
    MOVE.W  D0,-30(A5)
    MOVE.W  D0,-32(A5)
    MOVE.W  D0,-34(A5)
    MOVE.W  D0,-36(A5)
    MOVE.W  D0,-12(A5)
    MOVE.W  D0,-18(A5)
    MOVE.W  D0,-20(A5)
    MOVE.W  D0,-40(A5)
    MOVE.W  D0,-38(A5)
    MOVE.W  D0,-10(A5)
    MOVE.W  D1,-14(A5)
    MOVE.W  D2,-16(A5)

LAB_178A:
    MOVEA.L -8(A5),A0
    TST.B   (A0)
    BEQ.S   LAB_178E

    MOVE.B  (A0),D0
    MOVEQ   #24,D1
    CMP.B   D1,D0
    BEQ.S   LAB_178B

    MOVEQ   #25,D1
    CMP.B   D1,D0
    BEQ.S   LAB_178B

    SUBQ.B  #6,D0
    BNE.S   LAB_178C

LAB_178B:
    TST.W   -40(A5)
    BNE.S   LAB_178D

    MOVEQ   #1,D0
    ADDQ.W  #1,-18(A5)
    MOVE.W  D0,-40(A5)
    BRA.S   LAB_178D

LAB_178C:
    CLR.W   -40(A5)

LAB_178D:
    ADDQ.L  #1,-8(A5)
    BRA.S   LAB_178A

LAB_178E:
    MOVEQ   #0,D0
    MOVE.W  D0,-40(A5)
    TST.W   -18(A5)
    BEQ.W   LAB_17A7

    MOVE.W  -18(A5),D0
    EXT.L   D0
    MOVEQ   #10,D1
    JSR     LAB_1A06(PC)

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D0,-(A7)
    PEA     2115.W
    PEA     GLOB_STR_TLIBA1_C_3
    JSR     MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.W   LAB_17A7

    MOVE.L  A2,-8(A5)
    MOVE.W  #2,-32(A5)

LAB_178F:
    MOVEA.L -8(A5),A0
    MOVE.B  (A0),D0
    EXT.W   D0
    TST.W   D0
    BEQ.W   LAB_1798

    SUBQ.W  #6,D0
    BEQ.W   LAB_1794

    SUBI.W  #12,D0
    BEQ.W   LAB_1799

    SUBQ.W  #6,D0
    BEQ.S   LAB_1790

    SUBQ.W  #1,D0
    BEQ.W   LAB_1792

    BRA.W   LAB_179A

LAB_1790:
    TST.W   -40(A5)
    BEQ.S   LAB_1791

    SUBQ.W  #1,-28(A5)
    MOVE.W  -28(A5),D0
    MOVE.L  D0,D1
    MOVEQ   #10,D2
    MULS    D2,D1
    MOVEQ   #1,D3
    MOVEA.L -4(A5),A0
    MOVE.W  D3,0(A0,D1.L)
    MULS    D2,D0
    MOVE.W  -36(A5),D1
    MOVE.L  D1,D4
    ADDQ.W  #1,D4
    MOVE.W  D4,2(A0,D0.L)
    ADDQ.W  #1,-28(A5)
    BRA.W   LAB_179B

LAB_1791:
    MOVE.W  -28(A5),D0
    MOVE.L  D0,D1
    MOVEQ   #10,D2
    MULS    D2,D1
    MOVEQ   #0,D3
    MOVEA.L -4(A5),A0
    MOVE.W  D3,4(A0,D1.L)
    MOVEQ   #1,D4
    MOVE.W  D4,0(A0,D1.L)
    MULS    D2,D0
    MOVE.W  -36(A5),D1
    ADDQ.W  #1,D1
    MOVE.W  D1,2(A0,D0.L)
    MOVE.W  D4,8(A0,D0.L)
    ADDQ.W  #1,-28(A5)
    MOVEA.L -8(A5),A0
    CLR.B   (A0)
    MOVEA.L 52(A3),A0
    MOVE.W  20(A0),D0
    ADDQ.W  #1,D0
    ADD.W   D0,-30(A5)
    ADDQ.W  #1,-32(A5)
    MOVE.W  D3,-38(A5)
    MOVE.W  D4,-40(A5)
    BRA.W   LAB_179B

LAB_1792:
    TST.W   -40(A5)
    BEQ.S   LAB_1793

    SUBQ.W  #1,-28(A5)
    MOVE.W  -28(A5),D0
    MOVE.L  D0,D1
    MOVEQ   #10,D2
    MULS    D2,D1
    MOVEQ   #3,D3
    MOVEA.L -4(A5),A0
    MOVE.W  D3,0(A0,D1.L)
    MULS    D2,D0
    MOVE.W  -36(A5),D1
    MOVE.L  D1,D4
    ADDQ.W  #1,D4
    MOVE.W  D4,2(A0,D0.L)
    ADDQ.W  #1,-28(A5)
    BRA.W   LAB_179B

LAB_1793:
    MOVE.W  -28(A5),D0
    MOVE.L  D0,D1
    MOVEQ   #10,D2
    MULS    D2,D1
    MOVEQ   #0,D3
    MOVEA.L -4(A5),A0
    MOVE.W  D3,4(A0,D1.L)
    MOVE.W  #3,0(A0,D1.L)
    MULS    D2,D0
    MOVE.W  -36(A5),D1
    ADDQ.W  #1,D1
    MOVE.W  D1,2(A0,D0.L)
    MOVEQ   #1,D1
    MOVE.W  D1,8(A0,D0.L)
    ADDQ.W  #1,-28(A5)
    MOVEA.L -8(A5),A0
    CLR.B   (A0)
    MOVEA.L 52(A3),A0
    MOVE.W  20(A0),D0
    ADDQ.W  #1,D0
    ADD.W   D0,-30(A5)
    ADDQ.W  #1,-32(A5)
    MOVE.W  D1,-40(A5)
    MOVE.W  D3,-38(A5)
    BRA.W   LAB_179B

LAB_1794:
    TST.W   -40(A5)
    BEQ.S   LAB_1795

    SUBQ.W  #1,-28(A5)

LAB_1795:
    MOVE.W  -28(A5),D0
    MOVE.L  D0,D1
    MOVEQ   #10,D2
    MULS    D2,D1
    MOVEQ   #1,D3
    MOVEA.L -4(A5),A0
    MOVE.W  D3,4(A0,D1.L)
    MOVE.W  D3,0(A0,D1.L)
    MULS    D2,D0
    MOVE.W  -36(A5),D1
    ADDQ.W  #1,D1
    MOVE.W  D1,2(A0,D0.L)
    TST.W   -38(A5)
    BEQ.S   LAB_1796

    MOVEQ   #0,D1
    MOVE.W  D1,8(A0,D0.L)
    BRA.S   LAB_1797

LAB_1796:
    MOVE.W  -28(A5),D0
    MOVE.L  D0,D1
    MULS    D2,D1
    MOVE.W  D3,8(A0,D1.L)
    ADDQ.W  #1,-32(A5)

LAB_1797:
    ADDQ.W  #1,-28(A5)
    MOVEA.L -8(A5),A0
    CLR.B   (A0)
    MOVEA.L GLOB_HANDLE_PREVUE_FONT,A0
    MOVE.W  20(A0),D0
    ADD.W   D0,-30(A5)
    CLR.W   -40(A5)
    MOVE.W  D3,-38(A5)
    BRA.S   LAB_179B

LAB_1798:
    MOVEQ   #1,D0
    ADDQ.W  #1,-32(A5)
    MOVE.W  D0,-10(A5)
    BRA.S   LAB_179B

LAB_1799:
    TST.W   -38(A5)
    BNE.S   LAB_179B

    MOVEA.L -8(A5),A0
    MOVE.B  #$20,(A0)
    BRA.S   LAB_179B

LAB_179A:
    CLR.W   -40(A5)

LAB_179B:
    ADDQ.W  #1,-36(A5)
    ADDQ.L  #1,-8(A5)
    TST.W   -10(A5)
    BEQ.W   LAB_178F

    MOVE.W  -16(A5),D0
    EXT.L   D0
    MOVE.W  -30(A5),D1
    EXT.L   D1
    SUB.L   D1,D0
    MOVE.W  -32(A5),D1
    EXT.L   D1
    JSR     LAB_1A07(PC)

    MOVE.B  25(A3),-21(A5)
    MOVE.L  52(A3),-26(A5)
    CLR.W   -12(A5)
    MOVE.W  D0,-30(A5)
    MOVE.W  D0,-34(A5)

LAB_179C:
    MOVE.W  -12(A5),D0
    CMP.W   -18(A5),D0
    BGE.W   LAB_17A6

    TST.W   LAB_236C
    BEQ.S   LAB_179D

    MULS    #10,D0
    MOVEA.L -4(A5),A0
    MOVE.W  0(A0,D0.L),D1
    EXT.L   D1
    MOVEA.L A3,A1
    MOVE.L  D1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

LAB_179D:
    MOVE.W  -12(A5),D0
    MULS    #10,D0
    MOVEA.L -4(A5),A0
    TST.W   4(A0,D0.L)
    BEQ.S   LAB_179E

    MOVEA.L A3,A1
    MOVEA.L GLOB_HANDLE_PREVUE_FONT,A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    BRA.S   LAB_179F

LAB_179E:
    MOVEA.L A3,A1
    MOVEA.L -26(A5),A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

LAB_179F:
    MOVE.W  -12(A5),D0
    MULS    #10,D0
    MOVEA.L A2,A0
    MOVEA.L -4(A5),A1
    ADDA.W  2(A1,D0.L),A0
    MOVEA.L A0,A1

LAB_17A0:
    TST.B   (A1)+
    BNE.S   LAB_17A0

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,36(A7)
    MOVEA.L A3,A1
    MOVE.L  36(A7),D0
    JSR     _LVOTextLength(A6)

    TST.B   LAB_1B5D
    BEQ.S   LAB_17A1

    MOVEQ   #0,D1
    MOVE.B  LAB_21B3,D1
    MOVEQ   #0,D2
    NOT.B   D2
    CMP.L   D2,D1
    BEQ.S   LAB_17A1

    MOVEQ   #8,D1
    BRA.S   LAB_17A2

LAB_17A1:
    MOVEQ   #0,D1

LAB_17A2:
    ADD.L   D1,D0
    MOVE.W  D0,-20(A5)
    MOVE.W  -14(A5),D1
    CMP.W   D1,D0
    BLE.S   LAB_17A3

    MOVE.W  D1,-20(A5)

LAB_17A3:
    MOVE.W  -12(A5),D0
    MOVE.L  D0,D2
    MOVEQ   #10,D3
    MULS    D3,D2
    MOVEA.L -4(A5),A0
    TST.W   8(A0,D2.L)
    BEQ.S   LAB_17A4

    MOVE.W  -34(A5),D2
    ADDQ.W  #1,D2
    ADD.W   D2,-30(A5)

LAB_17A4:
    MOVE.W  58(A3),D2
    ADD.W   D2,-30(A5)
    EXT.L   D1
    MOVE.W  -20(A5),D2
    EXT.L   D2
    SUB.L   D2,D1
    TST.L   D1
    BPL.S   LAB_17A5

    ADDQ.L  #1,D1

LAB_17A5:
    ASR.L   #1,D1
    MOVE.L  D7,D2
    EXT.L   D2
    ADD.L   D1,D2
    MOVE.L  D6,D1
    EXT.L   D1
    MOVE.W  -30(A5),D4
    EXT.L   D4
    ADD.L   D4,D1
    MULS    D3,D0
    MOVEA.L A2,A0
    MOVEA.L -4(A5),A1
    ADDA.W  2(A1,D0.L),A0
    MOVE.L  A0,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1771

    LEA     16(A7),A7
    ADDQ.W  #1,-12(A5)
    BRA.W   LAB_179C

LAB_17A6:
    MOVE.B  -21(A5),D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L A3,A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L A3,A1
    MOVEA.L -26(A5),A0
    JSR     _LVOSetFont(A6)

    TST.L   -4(A5)
    BEQ.S   LAB_17A7

    MOVE.W  -18(A5),D0
    EXT.L   D0
    MOVEQ   #10,D1
    JSR     LAB_1A06(PC)

    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     2385.W
    PEA     LAB_2164
    JSR     MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

LAB_17A7:
    MOVEM.L (A7)+,D2-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_17A8:
    LINK.W  A5,#-32
    MOVEM.L D5-D7/A3,-(A7)
    MOVE.W  10(A5),D7
    MOVE.W  14(A5),D6
    MOVEA.L 16(A5),A3
    MOVE.W  22(A5),D5
    CLR.W   -30(A5)
    MOVE.W  LAB_2153,D0
    SUBQ.W  #1,D0
    BNE.S   LAB_17A9

    MOVE.L  D7,D0
    EXT.L   D0
    PEA     1.W
    MOVE.L  D0,-(A7)
    JSR     GROUPD_JMP_TBL_LAB_0923(PC)

    MOVE.L  D7,D1
    EXT.L   D1
    PEA     1.W
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-4(A5)
    JSR     GROUPD_JMP_TBL_LAB_0926(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-8(A5)
    BRA.S   LAB_17AA

LAB_17A9:
    MOVE.L  D7,D0
    EXT.L   D0
    PEA     2.W
    MOVE.L  D0,-(A7)
    JSR     GROUPD_JMP_TBL_LAB_0923(PC)

    MOVE.L  D7,D1
    EXT.L   D1
    PEA     2.W
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-4(A5)
    JSR     GROUPD_JMP_TBL_LAB_0926(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-8(A5)

LAB_17AA:
    MOVE.L  D6,D1
    EXT.L   D1
    PEA     5.W
    MOVE.L  D1,-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     GROUPD_JMP_TBL_LAB_0347(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    PEA     3.W
    MOVE.L  D1,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  D0,-12(A5)
    JSR     GROUPD_JMP_TBL_LAB_0347(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    PEA     2.W
    MOVE.L  D1,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  D0,-16(A5)
    JSR     GROUPD_JMP_TBL_LAB_0347(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    PEA     4.W
    MOVE.L  D1,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  D0,-20(A5)
    JSR     GROUPD_JMP_TBL_LAB_0347(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    PEA     1.W
    MOVE.L  D1,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  D0,-24(A5)
    JSR     GROUPD_JMP_TBL_LAB_0347(PC)

    LEA     60(A7),A7
    MOVE.L  D0,-28(A5)
    MOVEQ   #-1,D0
    CMP.W   D0,D6
    BEQ.S   LAB_17AB

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  LAB_1BBD,-(A7)
    PEA     1440.W
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     GROUPD_JMP_TBL_LAB_036C(PC)

    LEA     20(A7),A7
    TST.L   D0
    BEQ.S   LAB_17AE

LAB_17AB:
    TST.L   -12(A5)
    BNE.S   LAB_17AC

    TST.L   -16(A5)
    BNE.S   LAB_17AC

    TST.L   -20(A5)
    BNE.S   LAB_17AC

    TST.L   -24(A5)
    BNE.S   LAB_17AC

    TST.L   -28(A5)
    BEQ.S   LAB_17AE

LAB_17AC:
    MOVE.L  A3,D0
    BEQ.S   LAB_17AD

    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -28(A5),-(A7)
    MOVE.L  -24(A5),-(A7)
    MOVE.L  -20(A5),-(A7)
    MOVE.L  -16(A5),-(A7)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_17B1

    LEA     28(A7),A7

LAB_17AD:
    MOVE.W  #1,-30(A5)
    BRA.S   LAB_17B0

LAB_17AE:
    MOVE.L  A3,D0
    BEQ.S   LAB_17AF

    CLR.B   (A3)

LAB_17AF:
    MOVEQ   #0,D0
    MOVE.W  D0,-30(A5)

LAB_17B0:
    MOVE.W  -30(A5),D0
    MOVEM.L (A7)+,D5-D7/A3
    UNLK    A5
    RTS

;!======

LAB_17B1:
    LINK.W  A5,#-544
    MOVEM.L D2/D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.W  34(A5),D7
    LEA     LAB_2165,A0
    LEA     -532(A5),A1
    MOVE.W  #$1ff,D0
; This is weird, it's purposefully one byte back
; so that it can start the loop as if it's doing a
; do/while loop.
LAB_17B2:
    MOVE.B  (A0)+,(A1)+
    DBF     D0,LAB_17B2
    MOVE.L  A2,D0
    BEQ.S   LAB_17B3

    MOVEQ   #0,D0
    MOVE.B  2(A2),D0
    BRA.S   LAB_17B4

LAB_17B3:
    MOVEQ   #65,D0

LAB_17B4:
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #1,(A0)
    BEQ.S   LAB_17B7

    MOVE.L  A2,D0
    BEQ.S   LAB_17B5

    MOVEQ   #0,D0
    MOVE.B  2(A2),D0
    BRA.S   LAB_17B6

LAB_17B5:
    MOVEQ   #65,D0

LAB_17B6:
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   LAB_17B9

LAB_17B7:
    MOVE.L  A2,D0
    BEQ.S   LAB_17B8

    MOVEQ   #0,D0
    MOVE.B  2(A2),D0
    BRA.S   LAB_17B9

LAB_17B8:
    MOVEQ   #65,D0

LAB_17B9:
    MOVE.L  D0,D6
    MOVE.L  D6,D0
    SUBI.B  #$41,D0
    MOVE.L  D0,D5
    ADDQ.B  #1,D5
    TST.W   D7
    BNE.S   LAB_17BA

    MOVEQ   #0,D0
    CMP.B   D0,D5
    BCS.S   LAB_17BA

    MOVEQ   #2,D1
    CMP.B   D1,D5
    BCC.S   LAB_17BA

    MOVEQ   #0,D1
    MOVE.B  D5,D1
    MOVE.L  D1,D2
    EXT.L   D2
    ASL.L   #2,D2
    LEA     LAB_2156,A0
    ADDA.L  D2,A0
    MOVE.L  (A0),-4(A5)
    BRA.S   LAB_17BB

LAB_17BA:
    MOVE.L  LAB_2156,-4(A5)

LAB_17BB:
    TST.L   28(A5)
    BEQ.S   LAB_17BC

    MOVEA.L 28(A5),A0
    BRA.S   LAB_17BD

LAB_17BC:
    LEA     LAB_2166,A0

LAB_17BD:
    MOVE.L  A0,-20(A5)
    TST.L   16(A5)
    BEQ.S   LAB_17BE

    MOVEA.L 16(A5),A0
    BRA.S   LAB_17BF

LAB_17BE:
    LEA     LAB_2167,A0

LAB_17BF:
    MOVE.L  A0,-16(A5)
    TST.L   24(A5)
    BEQ.S   LAB_17C0

    MOVEA.L 24(A5),A0
    BRA.S   LAB_17C1

LAB_17C0:
    LEA     LAB_2168,A0

LAB_17C1:
    MOVE.L  A0,-12(A5)
    TST.L   20(A5)
    BEQ.S   LAB_17C2

    MOVEA.L 20(A5),A0
    BRA.S   LAB_17C3

LAB_17C2:
    LEA     LAB_2169,A0

LAB_17C3:
    MOVE.L  A0,-8(A5)
    CLR.B   (A3)
    CLR.L   -538(A5)

LAB_17C4:
    MOVE.L  -538(A5),D0
    MOVEQ   #4,D1
    CMP.L   D1,D0
    BGE.S   LAB_17C8

    ASL.L   #2,D0
    MOVEA.L -20(A5,D0.L),A0

LAB_17C5:
    TST.B   (A0)+
    BNE.S   LAB_17C5

    SUBQ.L  #1,A0
    SUBA.L  -20(A5,D0.L),A0
    MOVE.L  A0,-542(A5)
    BLE.S   LAB_17C7

    MOVE.L  A0,D0
    CMPI.L  #$200,D0
    BGE.S   LAB_17C7

    MOVEA.L A3,A0

LAB_17C6:
    TST.B   (A0)+
    BNE.S   LAB_17C6

    SUBQ.L  #1,A0
    SUBA.L  A3,A0
    MOVE.L  A0,D1
    ADD.L   D1,D0
    CMPI.L  #$200,D0
    BGE.S   LAB_17C7

    CLR.B   -532(A5)
    MOVEQ   #0,D0
    MOVEA.L -4(A5),A0
    MOVE.L  -538(A5),D1
    MOVE.B  0(A0,D1.L),D0
    ASL.L   #2,D1
    MOVE.L  -20(A5,D1.L),-(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_216A
    PEA     -532(A5)
    JSR     WDISP_SPrintf(PC)

    PEA     -532(A5)
    MOVE.L  A3,-(A7)
    JSR     UNKNOWN6_AppendDataAtNull(PC)

    LEA     24(A7),A7

LAB_17C7:
    ADDQ.L  #1,-538(A5)
    BRA.S   LAB_17C4

LAB_17C8:
    MOVEM.L (A7)+,D2/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    MOVE.L  A3,-(A7)
    PEA     LAB_216B
    JSR     LAB_1906(PC)

    PEA     LAB_216C
    JSR     LAB_1906(PC)

    MOVE.W  (A3),D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    PEA     LAB_216D
    JSR     LAB_1906(PC)

    MOVE.W  2(A3),D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    PEA     LAB_216E
    JSR     LAB_1906(PC)

    MOVE.W  4(A3),D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    PEA     LAB_216F
    JSR     LAB_1906(PC)

    MOVE.W  6(A3),D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    PEA     LAB_2170
    JSR     LAB_1906(PC)

    MOVE.W  8(A3),D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    PEA     LAB_2171
    JSR     LAB_1906(PC)

    PEA     LAB_2172
    JSR     LAB_1906(PC)

    LEA     36(A7),A7
    MOVEA.L (A7)+,A3
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

GROUPD_JMP_TBL_LAB_0347:
    JMP     LAB_0347

GROUPD_JMP_TBL_LAB_0926:
    JMP     LAB_0926

GROUPD_JMP_TBL_LAB_0EE9:
    JMP     LAB_0EE9

GROUPD_JMP_TBL_LAB_0923:
    JMP     LAB_0923

GROUPD_JMP_TBL_LAB_036C:
    JMP     LAB_036C

TLIBA1_JMP_TBL_CLEANUP_FormatClockFormatEntry:
LAB_17CE:
    JMP     CLEANUP_FormatClockFormatEntry

GROUPD_JMP_TBL_LAB_08DF:
    JMP     LAB_08DF

GROUPD_JMP_TBL_ESQ_FindSubstringCaseFold:
    JMP     ESQ_FindSubstringCaseFold

GROUPD_JMP_TBL_LAB_054C:
    JMP     LAB_054C

GROUPD_JMP_TBL_LAB_0EE8:
    JMP     LAB_0EE8

;!======

    ; Alignment
    RTS
    DC.W    $0000
