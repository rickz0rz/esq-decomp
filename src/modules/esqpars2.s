LAB_0C48:
    LINK.W  A5,#-76
    MOVEM.L D2-D7/A2-A3/A6,-(A7)

    MOVEA.L 8(A5),A3
    MOVE.B  15(A5),D7
    MOVE.B  19(A5),D6
    MOVE.B  23(A5),D5
    MOVEA.L 24(A5),A2

    MOVE.L  D6,D0
    ANDI.B  #$40,D0
    ANDI.B  #$3f,D6
    MOVE.B  D0,-15(A5)
    MOVEQ   #1,D0
    CMP.B   D0,D6
    BCS.S   LAB_0C49

    MOVEQ   #48,D1
    CMP.B   D1,D6
    BLS.S   LAB_0C4A

LAB_0C49:
    MOVEQ   #0,D0
    BRA.W   LAB_0C70

LAB_0C4A:
    MOVE.B  LAB_222D,D0
    CMP.B   D7,D0
    BNE.S   LAB_0C4B

    MOVE.B  LAB_222E,D0
    SUBQ.B  #1,D0
    BNE.S   LAB_0C4B

    MOVE.W  LAB_222F,D0
    MOVE.W  D0,-14(A5)
    BRA.S   LAB_0C4D

LAB_0C4B:
    MOVE.B  LAB_2230,D0
    CMP.B   D0,D7
    BNE.S   LAB_0C4C

    MOVE.W  LAB_2231,D0
    MOVE.W  D0,-14(A5)
    BRA.S   LAB_0C4D

LAB_0C4C:
    MOVEQ   #0,D0
    BRA.W   LAB_0C70

LAB_0C4D:
    CLR.W   -10(A5)

LAB_0C4E:
    MOVE.W  -10(A5),D0
    CMP.W   -14(A5),D0
    BGE.W   LAB_0C70

    MOVE.B  LAB_222D,D1
    CMP.B   D1,D7
    BNE.S   LAB_0C4F

    MOVE.B  LAB_222E,D1
    SUBQ.B  #1,D1
    BNE.S   LAB_0C4F

    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     LAB_2235,A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-4(A5)
    LEA     LAB_2237,A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-8(A5)
    BRA.S   LAB_0C50

LAB_0C4F:
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     LAB_2233,A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-4(A5)
    LEA     LAB_2236,A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-8(A5)

LAB_0C50:
    MOVE.L  A3,-(A7)
    MOVE.L  -8(A5),-(A7)
    JSR     LAB_0C76(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.W   LAB_0C6F

    MOVEA.L -4(A5),A0
    ADDA.W  #$22,A0
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_0C78(PC)

    ADDQ.W  #8,A7
    MOVE.W  D0,-12(A5)
    TST.B   -15(A5)
    BNE.S   LAB_0C51

    TST.W   D0
    BNE.W   LAB_0C6F

LAB_0C51:
    TST.B   -15(A5)
    BEQ.S   LAB_0C52

    MOVEA.L -4(A5),A0
    ADDA.W  #$22,A0
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_0C73(PC)

    ADDQ.W  #8,A7

LAB_0C52:
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVEA.L -8(A5),A0
    MOVE.B  D5,7(A0,D0.W)
    MOVEQ   #0,D0
    MOVEA.L -4(A5),A1
    MOVE.B  27(A1),D0
    MOVE.L  D0,-(A7)
    MOVE.L  A2,-(A7)
    BSR.W   LAB_0C31

    ADDQ.W  #8,A7
    MOVEQ   #0,D0
    MOVEA.L A2,A0
    MOVEA.L A0,A1

LAB_0C53:
    TST.B   (A1)+
    BNE.S   LAB_0C53

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D1
    MOVE.L  A0,-34(A5)
    ADDA.L  D1,A0
    MOVE.B  D0,-30(A5)
    MOVE.B  D0,-29(A5)
    MOVE.L  A0,-28(A5)
    MOVE.B  -1(A0),D0
    MOVEQ   #41,D1
    CMP.B   D1,D0
    BNE.S   LAB_0C54

    MOVE.B  -4(A0),D2
    MOVEQ   #58,D3
    CMP.B   D3,D2
    BNE.S   LAB_0C54

    MOVEQ   #40,D4
    CMP.B   -6(A0),D4
    BNE.S   LAB_0C54

    MOVEQ   #1,D4
    MOVE.B  D4,-29(A5)

LAB_0C54:
    CMP.B   D1,D0
    BNE.S   LAB_0C55

    MOVEQ   #58,D0
    CMP.B   -4(A0),D0
    BNE.S   LAB_0C55

    MOVEQ   #40,D0
    CMP.B   -5(A0),D0
    BNE.S   LAB_0C55

    MOVEQ   #1,D0
    MOVE.B  D0,-30(A5)

LAB_0C55:
    TST.B   -29(A5)
    BNE.S   LAB_0C56

    TST.B   -30(A5)
    BEQ.W   LAB_0C5F

LAB_0C56:
    MOVEQ   #0,D0
    SUBA.L  A1,A1
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     50.W
    PEA     720.W
    PEA     GLOB_STR_ESQPARS2_C_1
    MOVE.L  D0,-42(A5)
    MOVE.L  D0,-38(A5)
    MOVE.L  A1,-70(A5)
    MOVE.L  A1,-66(A5)
    JSR     JMP_TBL_ALLOCATE_MEMORY_2(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-70(A5)
    MOVE.L  D0,-66(A5)
    TST.B   -29(A5)
    BEQ.S   LAB_0C57

    MOVEA.L -28(A5),A0
    MOVE.B  -5(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVE.L  D0,-38(A5)

LAB_0C57:
    MOVEA.L -28(A5),A0
    MOVE.B  -3(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVEQ   #10,D1
    MOVE.L  D0,-42(A5)
    JSR     JMP_TBL_LAB_1A06_4(PC)

    MOVE.B  -2(A0),D1
    EXT.W   D1
    EXT.L   D1
    ADD.L   D1,D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVEM.L D0,-42(A5)
    MOVE.L  -38(A5),D1
    TST.L   D1
    BLE.S   LAB_0C59

    MOVE.L  D0,-(A7)
    PEA     LAB_1F29
    PEA     -52(A5)
    JSR     JMP_TBL_PRINTF_3(PC)

    MOVE.L  -38(A5),(A7)
    PEA     LAB_1F2A
    PEA     -62(A5)
    JSR     JMP_TBL_PRINTF_3(PC)

    PEA     -62(A5)
    MOVE.L  -66(A5),-(A7)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_2(PC)

    LEA     28(A7),A7
    MOVEQ   #1,D0
    CMP.L   -38(A5),D0
    BNE.S   LAB_0C58

    PEA     LAB_2103
    MOVE.L  -66(A5),-(A7)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_2(PC)

    ADDQ.W  #8,A7
    BRA.S   LAB_0C5A

LAB_0C58:
    PEA     LAB_2102
    MOVE.L  -66(A5),-(A7)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_2(PC)

    ADDQ.W  #8,A7
    BRA.S   LAB_0C5A

LAB_0C59:
    MOVE.L  D0,-(A7)
    PEA     LAB_1F2B
    PEA     -52(A5)
    JSR     JMP_TBL_PRINTF_3(PC)

    LEA     12(A7),A7

LAB_0C5A:
    MOVE.L  -42(A5),D0
    TST.L   D0
    BLE.S   LAB_0C5B

    PEA     -52(A5)
    MOVE.L  -66(A5),-(A7)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_2(PC)

    PEA     LAB_2104
    MOVE.L  -66(A5),-(A7)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_2(PC)

    LEA     16(A7),A7
    BRA.S   LAB_0C5D

LAB_0C5B:
    MOVEA.L -66(A5),A0

LAB_0C5C:
    TST.B   (A0)+
    BNE.S   LAB_0C5C

    SUBQ.L  #1,A0
    SUBA.L  -66(A5),A0
    MOVEA.L -66(A5),A1
    MOVE.L  A0,D0
    CLR.B   -1(A1,D0.L)
    PEA     LAB_1F2C
    MOVE.L  A1,-(A7)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_2(PC)

    ADDQ.W  #8,A7

LAB_0C5D:
    MOVEA.L -28(A5),A0
    SUBQ.L  #6,A0
    MOVEA.L -66(A5),A1

LAB_0C5E:
    MOVE.B  (A1)+,(A0)+
    BNE.S   LAB_0C5E

    TST.L   -70(A5)
    BEQ.S   LAB_0C5F

    PEA     50.W
    MOVE.L  -70(A5),-(A7)
    PEA     765.W
    PEA     GLOB_STR_ESQPARS2_C_2
    JSR     JMP_TBL_DEALLOCATE_MEMORY_2(PC)

    LEA     16(A7),A7

LAB_0C5F:
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVE.L  D0,D2
    EXT.L   D2
    ASL.L   #2,D2
    MOVEA.L -8(A5),A0
    MOVE.L  56(A0,D2.L),-(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  D1,44(A7)
    JSR     LAB_0B44(PC)

    ADDQ.W  #8,A7
    MOVEA.L -8(A5),A0
    MOVE.L  36(A7),D1
    MOVE.L  D0,56(A0,D1.L)
    MOVE.B  LAB_1DD8,D0
    MOVEQ   #0,D1
    CMP.B   D1,D0
    BLS.W   LAB_0C6D

    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    PEA     91.W
    MOVE.L  56(A0,D1.L),-(A7)
    JSR     GCOMMAND_JMP_TBL_LAB_1979(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-20(A5)
    TST.L   D0
    BEQ.W   LAB_0C6D

    MOVEA.L D0,A0
    MOVE.B  1(A0),D1
    EXT.W   D1
    EXT.L   D1
    LEA     LAB_21A8,A1
    MOVEA.L A1,A6
    ADDA.L  D1,A6
    BTST    #2,(A6)
    BEQ.S   LAB_0C60

    MOVE.B  1(A0),D1
    EXT.W   D1
    EXT.L   D1
    MOVEQ   #48,D2
    SUB.L   D2,D1
    MOVEQ   #10,D0
    JSR     JMP_TBL_LAB_1A06_4(PC)

    BRA.S   LAB_0C61

LAB_0C60:
    MOVEQ   #0,D0

LAB_0C61:
    MOVE.B  2(A0),D1
    EXT.W   D1
    EXT.L   D1
    MOVEA.L A1,A6
    ADDA.L  D1,A6
    MOVE.W  D0,-22(A5)
    BTST    #2,(A6)
    BEQ.S   LAB_0C62

    MOVE.B  2(A0),D1
    EXT.W   D1
    EXT.L   D1
    MOVEQ   #48,D2
    SUB.L   D2,D1
    BRA.S   LAB_0C63

LAB_0C62:
    MOVEQ   #0,D1

LAB_0C63:
    EXT.L   D0
    ADD.L   D1,D0
    MOVE.B  4(A0),D1
    EXT.W   D1
    EXT.L   D1
    MOVEA.L A1,A6
    ADDA.L  D1,A6
    MOVE.W  D0,-22(A5)
    BTST    #2,(A6)
    BEQ.S   LAB_0C64

    MOVE.B  4(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVEQ   #10,D1
    JSR     JMP_TBL_LAB_1A06_4(PC)

    BRA.S   LAB_0C65

LAB_0C64:
    MOVEQ   #0,D0

LAB_0C65:
    MOVE.B  5(A0),D1
    EXT.W   D1
    EXT.L   D1
    ADDA.L  D1,A1
    MOVE.W  D0,-24(A5)
    BTST    #2,(A1)
    BEQ.S   LAB_0C66

    MOVE.B  5(A0),D1
    EXT.W   D1
    EXT.L   D1
    MOVEQ   #48,D2
    SUB.L   D2,D1
    BRA.S   LAB_0C67

LAB_0C66:
    MOVEQ   #0,D1

LAB_0C67:
    EXT.L   D0
    ADD.L   D1,D0
    MOVE.W  D0,-24(A5)
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  LAB_1DD8,D1
    ADD.L   D1,D0
    MOVE.W  D0,-24(A5)

LAB_0C68:
    MOVE.W  -24(A5),D0
    MOVEQ   #59,D1
    CMP.W   D1,D0
    BLE.S   LAB_0C69

    MOVEQ   #60,D1
    SUB.W   D1,-24(A5)
    ADDQ.W  #1,-22(A5)
    BRA.S   LAB_0C68

LAB_0C69:
    MOVE.W  -22(A5),D0
    MOVEQ   #12,D1
    CMP.W   D1,D0
    BLE.S   LAB_0C6A

    MOVEQ   #12,D1
    SUB.W   D1,-22(A5)
    BRA.S   LAB_0C69

LAB_0C6A:
    MOVE.W  -22(A5),D0
    EXT.L   D0
    MOVEQ   #10,D1
    JSR     JMP_TBL_LAB_1A07_3(PC)

    MOVEQ   #48,D0
    ADD.L   D0,D1
    MOVEA.L -20(A5),A0
    MOVE.B  D1,2(A0)
    MOVE.W  -22(A5),D1
    EXT.L   D1
    DIVS    #10,D1
    MOVEM.W D1,-22(A5)
    BLE.S   LAB_0C6B

    EXT.L   D1
    ADD.L   D0,D1
    BRA.S   LAB_0C6C

LAB_0C6B:
    MOVEQ   #32,D1

LAB_0C6C:
    MOVE.B  D1,1(A0)
    MOVE.W  -24(A5),D1
    EXT.L   D1
    MOVE.L  D1,D0
    MOVEQ   #10,D1
    JSR     JMP_TBL_LAB_1A07_3(PC)

    MOVEQ   #48,D1
    ADD.L   D1,D0
    MOVE.B  D0,4(A0)
    MOVE.W  -24(A5),D0
    EXT.L   D0
    MOVEQ   #10,D1
    JSR     JMP_TBL_LAB_1A07_3(PC)

    MOVEQ   #48,D0
    ADD.L   D0,D1
    MOVE.B  D1,5(A0)

LAB_0C6D:
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    EXT.L   D0
    MOVEQ   #0,D2
    MOVEA.L -8(A5),A0
    MOVE.B  498(A0),D2
    MOVE.L  D2,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D1,44(A7)
    JSR     LAB_0C71(PC)

    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVEA.L -8(A5),A0
    MOVE.L  44(A7),D1
    MOVE.L  56(A0,D1.L),-(A7)
    JSR     LAB_0C74(PC)

    LEA     12(A7),A7
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVEA.L -8(A5),A0
    BTST    #4,7(A0,D0.W)
    BEQ.S   LAB_0C6E

    MOVEA.L -4(A5),A0
    BSET    #0,40(A0)

LAB_0C6E:
    MOVEQ   #0,D0
    MOVEA.L -4(A5),A0
    MOVE.B  40(A0),D0
    ORI.W   #$80,D0
    MOVE.B  D0,40(A0)

LAB_0C6F:
    ADDQ.W  #1,-10(A5)
    BRA.W   LAB_0C4E

LAB_0C70:
    MOVEM.L (A7)+,D2-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

LAB_0C71:
    JMP     LAB_064D

LAB_0C72:
    JMP     ESQ_ReverseBitsIn6Bytes

LAB_0C73:
    JMP     ESQ_SetBit1Based

LAB_0C74:
    JMP     ESQ_AdjustBracketedHourInString

LAB_0C75:
    JMP     LAB_0345

LAB_0C76:
    JMP     ESQ_WildcardMatch

LAB_0C77:
    JMP     LAB_1985

LAB_0C78:
    JMP     ESQ_TestBit1Based
