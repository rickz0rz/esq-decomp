LAB_167D:
    PEA     3.W
    JSR     LAB_14B1(PC)

    MOVE.W  #(-1),LAB_2364
    CLR.L   (A7)
    JSR     LAB_1696(PC)

    ADDQ.W  #4,A7
    RTS

;!======

LAB_167E:
    MOVEM.L D2/D7,-(A7)
    MOVE.W  14(A7),D7
    CLR.W   LAB_22AB
    JSR     GROUPD_JMPTBL_LAB_0A49(PC)

    TST.W   D7
    BNE.S   LAB_167F

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    PEA     3.W
    JSR     LAB_183E(PC)

    LEA     12(A7),A7
    MOVE.L  D0,LAB_2216
    BRA.S   LAB_1680

LAB_167F:
    PEA     4.W
    CLR.L   -(A7)
    PEA     7.W
    JSR     LAB_183E(PC)

    LEA     12(A7),A7
    MOVE.L  D0,LAB_2216
    MOVE.L  D7,D1
    MOVEQ   #3,D2
    MULS    D2,D1
    LEA     LAB_2295,A0
    ADDA.L  D1,A0
    MOVE.B  (A0),LAB_2295
    MOVE.L  D7,D0
    MULS    D2,D0
    LEA     LAB_2296,A0
    ADDA.L  D0,A0
    MOVE.B  (A0),LAB_2296
    MOVE.L  D7,D0
    MULS    D2,D0
    LEA     LAB_2297,A0
    ADDA.L  D0,A0
    MOVE.B  (A0),LAB_2297
    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVE.L  D7,D0
    EXT.L   D0
    MOVEA.L A0,A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

LAB_1680:
    MOVEM.L (A7)+,D2/D7
    RTS

;!======

LAB_1681:
    MOVE.W  LAB_2265,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVEQ   #1,D0
    CMP.W   4(A1),D0
    BEQ.S   LAB_1682

    MOVE.W  LAB_2265,D0
    EXT.L   D0
    ADDQ.L  #1,D0
    MOVEQ   #46,D1
    JSR     LAB_1A07(PC)

    MOVE.W  D1,LAB_2265
    BRA.S   LAB_1681

LAB_1682:
    MOVE.W  LAB_2265,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_1694(PC)

    ADDQ.W  #4,A7
    MOVE.W  LAB_2265,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2265
    RTS

;!======

LAB_1683:
    MOVEM.L D2/D7,-(A7)
    MOVEQ   #1,D0
    CMP.L   LAB_1FE6,D0
    BNE.S   LAB_1687

    MOVE.L  LAB_1FE8,D1
    MOVEQ   #-1,D2
    CMP.L   D2,D1
    BNE.S   LAB_1684

    MOVE.L  LAB_1FE9,D1

LAB_1684:
    MOVE.L  D1,D7
    MOVE.B  LAB_1DD6,D1
    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   LAB_1685

    MOVEQ   #2,D1
    CMP.L   D1,D7
    BNE.S   LAB_1685

    MOVE.L  D0,-(A7)
    JSR     LAB_1696(PC)

    ADDQ.W  #4,A7
    BRA.S   LAB_168A

LAB_1685:
    MOVE.W  WDISP_HighlightActive,D1
    SUBQ.W  #1,D1
    BNE.S   LAB_1686

    MOVEQ   #3,D1
    CMP.L   D1,D7
    BNE.S   LAB_1686

    BSR.W   LAB_1681

    BRA.S   LAB_168A

LAB_1686:
    BSR.W   LAB_167D

    BRA.S   LAB_168A

LAB_1687:
    MOVE.B  LAB_1DD6,D1
    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   LAB_1688

    MOVE.L  D0,-(A7)
    JSR     LAB_1696(PC)

    ADDQ.W  #4,A7
    BRA.S   LAB_168A

LAB_1688:
    MOVE.W  WDISP_HighlightActive,D1
    SUBQ.W  #1,D1
    BNE.S   LAB_1689

    BSR.W   LAB_1681

    BRA.S   LAB_168A

LAB_1689:
    BSR.W   LAB_167D

LAB_168A:
    MOVEM.L (A7)+,D2/D7
    RTS

;!======

    PEA     3.W
    CLR.L   -(A7)
    PEA     4.W
    JSR     LAB_183E(PC)

    MOVE.L  D0,LAB_2216
    JSR     GROUPD_JMPTBL_LAB_0A45(PC)

    LEA     12(A7),A7
    CLR.W   LAB_22AB
    RTS

;!======

LAB_168B:
    MOVE.L  D2,-(A7)
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_2363
    TST.W   LAB_1DF4
    BNE.W   LAB_1692

    TST.W   LAB_2263
    BNE.W   LAB_1690

    MOVE.W  LAB_2346,D1
    SUBQ.W  #2,D1
    BEQ.S   LAB_1690

    MOVE.W  LAB_1DDE,D1
    BEQ.S   LAB_168F

    MOVE.W  LAB_1DDF,D2
    BEQ.S   LAB_168F

    MOVE.W  D0,LAB_1DDF
    MOVE.W  LAB_1DDE,D0
    SUBQ.W  #3,D0
    BEQ.S   LAB_168C

    MOVE.W  LAB_1DDE,D0
    SUBQ.W  #2,D0
    BNE.S   LAB_168D

LAB_168C:
    JSR     LAB_1693(PC)

    MOVE.W  D0,LAB_22A5
    JSR     SCRIPT_AssertCtrlLineIfEnabled(PC)

    BSR.W   LAB_1683

    BRA.S   LAB_168E

LAB_168D:
    MOVEQ   #-1,D0
    CMP.L   LAB_1FE9,D0
    BEQ.S   LAB_168E

    MOVE.L  D0,LAB_1FE9

LAB_168E:
    MOVE.W  LAB_1DDE,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   LAB_168F

    SUBQ.W  #1,D0
    MOVE.W  D0,LAB_1DDE

LAB_168F:
    MOVE.W  LAB_234A,D0
    CMPI.W  #$b4,D0
    BLT.S   LAB_1691

    CLR.W   LAB_234A
    BSR.W   LAB_167D

    BRA.S   LAB_1691

LAB_1690:
    MOVE.W  LAB_234A,D0
    ADDQ.W  #1,D0
    BEQ.S   LAB_1691

    CLR.W   LAB_234A

LAB_1691:
    JSR     LAB_1695(PC)

LAB_1692:
    MOVE.L  (A7)+,D2
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

LAB_1693:
    JMP     LAB_0F78

LAB_1694:
    JMP     LAB_0E83

LAB_1695:
    JMP     LAB_0A8E

LAB_1696:
    JMP     LAB_0A7C
