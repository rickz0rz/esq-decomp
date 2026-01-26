;!======

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
    JSR     LAB_0D57(PC)

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
    JMP     LAB_00B3

LAB_0C73:
    JMP     LAB_00B2

LAB_0C74:
    JMP     LAB_00A7

LAB_0C75:
    JMP     LAB_0345

LAB_0C76:
    JMP     LAB_00BE

LAB_0C77:
    JMP     LAB_1985

LAB_0C78:
    JMP     LAB_00B1

;!======

    ; Dead code
    MOVEM.L D0-D1/A0-A4,-(A7)
    MOVE.W  LAB_226D,D0
    JSR     LAB_0C79

    MOVE.W  #$62,LAB_1F46
    MOVE.W  #0,LAB_1F3D
    MOVE.W  #0,LAB_1F3E
    LEA     LAB_1E2B,A4
    MOVE.W  GLOB_REF_WORD_HEX_CODE_8E,D0
    JSR     LAB_0CAD

    MOVEM.L (A7)+,D0-D1/A0-A4
    RTS

;!======

    ; Dead code.
    MOVEM.L D0-D1/A0-A4,-(A7)
    MOVE.W  LAB_226D,D0
    JSR     LAB_0C79

    MOVE.W  #$62,LAB_1F46
    MOVE.W  #1,LAB_1F3D
    JSR     LAB_0CAC

    MOVEM.L (A7)+,D0-D1/A0-A4
    RTS

;!======

LAB_0C79:
    MOVEQ   #0,D0
    MOVE.B  #$f6,LAB_1E4E
    MOVE.B  #$f6,LAB_1E7B
    MOVE.W  #$f5,D0
    ADD.W   GLOB_REF_WORD_HEX_CODE_8E,D0
    SUBI.W  #$80,D0
    MOVE.W  D0,LAB_1F42
    MOVE.W  #$62,LAB_1F46
    MOVE.W  #1,LAB_1F3D
    JSR     LAB_0CAC

    RTS

;!======

LAB_0C7A:
    MOVEM.L D0-D1/A0-A4,-(A7)
    MOVE.W  #$62,D0
    MOVE.W  D0,LAB_1F43
    SUBQ.W  #2,D0
    MOVE.W  D0,LAB_1F44
    MOVE.W  #5,LAB_1F45
    MOVE.W  #2,LAB_1F40
    MOVE.W  #10,LAB_1F3F
    JSR     LAB_0C92

    JSR     LAB_0C79(PC)

    JSR     LAB_0C7B

    MOVEA.L #CIAB_PRA,A1
    MOVE.B  (A1),D1
    BSET    #7,D1
    MOVE.B  D1,(A1)
    MOVEA.L #CIAB_PRA,A1
    MOVE.B  (A1),D1
    BSET    #6,D1
    MOVE.B  D1,(A1)
    MOVE.W  GLOB_REF_WORD_HEX_CODE_8E,D0
    MOVE.B  D0,LAB_1E2B
    MOVE.B  D0,LAB_1E58
    MOVE.W  #1,LAB_1F3B
    MOVEM.L (A7)+,D0-D1/A0-A4
    RTS

;!======

LAB_0C7B:
    MOVEM.L D0-D1/A0-A4,-(A7)
    LEA     LAB_1F2F,A1
    LEA     LAB_2267,A3
    MOVEA.L (A3),A2
    LEA     2992(A2),A2
    MOVE.L  A2,D0
    MOVE.W  D0,LAB_1E31
    SWAP    D0
    MOVE.W  D0,LAB_1E30
    MOVEA.L (A3),A2
    LEA     3080(A2),A2
    MOVE.L  A2,D0
    MOVE.W  D0,LAB_1E5E
    SWAP    D0
    MOVE.W  D0,LAB_1E5D
    LEA     LAB_1F38,A4
    LEA     LAB_1F2F,A1
    MOVEA.L (A3),A2
    LEA     5984(A2),A2
    MOVE.L  A2,(A1)+
    MOVE.L  A2,(A4)+
    MOVE.L  A2,D0
    MOVE.W  D0,LAB_1E3C
    MOVE.W  D0,LAB_1E48
    SWAP    D0
    MOVE.W  D0,LAB_1E3B
    MOVE.W  D0,LAB_1E47
    MOVEA.L (A3),A2
    LEA     6072(A2),A2
    MOVE.L  A2,D0
    MOVE.W  D0,LAB_1E69
    MOVE.W  D0,LAB_1E75
    SWAP    D0
    MOVE.W  D0,LAB_1E68
    MOVE.W  D0,LAB_1E74
    LEA     LAB_2268,A3
    MOVEA.L (A3),A2
    LEA     2992(A2),A2
    MOVE.L  A2,D0
    MOVE.W  D0,LAB_1E33
    SWAP    D0
    MOVE.W  D0,LAB_1E32
    MOVEA.L (A3),A2
    LEA     3080(A2),A2
    MOVE.L  A2,D0
    MOVE.W  D0,LAB_1E60
    SWAP    D0
    MOVE.W  D0,LAB_1E5F
    MOVEA.L (A3),A2
    LEA     5984(A2),A2
    MOVE.L  A2,(A1)+
    MOVE.L  A2,LAB_1F39
    MOVE.L  A2,D0
    MOVE.W  D0,LAB_1E3E
    MOVE.W  D0,LAB_1E4A
    SWAP    D0
    MOVE.W  D0,LAB_1E3D
    MOVE.W  D0,LAB_1E49
    MOVEA.L (A3),A2
    LEA     6072(A2),A2
    MOVE.L  A2,D0
    MOVE.W  D0,LAB_1E6B
    MOVE.W  D0,LAB_1E77
    SWAP    D0
    MOVE.W  D0,LAB_1E6A
    MOVE.W  D0,LAB_1E76
    LEA     LAB_2269,A3
    MOVEA.L (A3),A2
    LEA     2992(A2),A2
    MOVE.L  A2,D0
    MOVE.W  D0,LAB_1E35
    SWAP    D0
    MOVE.W  D0,LAB_1E34
    MOVEA.L (A3),A2
    LEA     3080(A2),A2
    MOVE.L  A2,D0
    MOVE.W  D0,LAB_1E62
    SWAP    D0
    MOVE.W  D0,LAB_1E61
    MOVEA.L (A3),A2
    LEA     5984(A2),A2
    MOVE.L  A2,(A1)
    MOVE.L  A2,LAB_1F3A
    MOVE.L  A2,D0
    MOVE.W  D0,LAB_1E40
    MOVE.W  D0,LAB_1E4C
    SWAP    D0
    MOVE.W  D0,LAB_1E3F
    MOVE.W  D0,LAB_1E4B
    MOVEA.L (A3),A2
    LEA     6072(A2),A2
    MOVE.L  A2,D0
    MOVE.W  D0,LAB_1E6D
    MOVE.W  D0,LAB_1E79
    SWAP    D0
    MOVE.W  D0,LAB_1E6C
    MOVE.W  D0,LAB_1E78
    MOVE.W  LAB_1F49,D0
    BSR.W   LAB_0C7C

    MOVEM.L (A7)+,D0-D1/A0-A4
    RTS

;!======

    MOVEM.L D2-D7/A2-A6,-(A7)
    MOVEQ   #0,D0
    MOVE.W  LAB_1F4A,D0
    BSR.W   LAB_0C7C

    MOVEM.L (A7)+,D2-D7/A2-A6
    RTS

;!======

LAB_0C7C:
    MOVE.W  D0,LAB_1F4A
    MOVE.W  #$d9,D1
    MOVE.B  D0,LAB_1E45
    MOVE.B  D0,LAB_1E72
    MOVE.B  D1,LAB_1E46
    MOVE.B  D1,LAB_1E73
    RTS

;!======

LAB_0C7D:
    MOVEM.L D0/A0-A1,-(A7)

    LEA     LAB_2229,A0
    MOVEA.L (A0),A1
    LEA (A1),A1
    MOVE.L  A1,D0
    MOVE.W  D0,LAB_1E2D
    MOVE.W  D0,LAB_1E39
    MOVE.W  D0,LAB_1E50
    MOVE.W  D0,LAB_1E5A
    MOVE.W  D0,LAB_1E66
    MOVE.W  D0,LAB_1E7D
    SWAP    D0
    MOVE.W  D0,LAB_1E2C
    MOVE.W  D0,LAB_1E38
    MOVE.W  D0,LAB_1E4F
    MOVE.W  D0,LAB_1E59
    MOVE.W  D0,LAB_1E65
    MOVE.W  D0,LAB_1E7C
    JSR     LAB_0C7E

    MOVEM.L (A7)+,D0/A0-A1
    RTS

;!======

LAB_0C7E:
    LEA     LAB_2229,A1
    MOVEA.L (A1),A0
    LEA (A0),A0
    MOVE.L  #$149,D1

.LAB_0C7F:
    MOVE.L  #$ffffffff,(A0)+
    DBF     D1,.LAB_0C7F
    RTS

;!======

LAB_0C80:
    LEA     BLTDDAT,A0
    MOVE.W  #$1761,(DIWSTRT-BLTDDAT)(A0)    ; $17, $61  -> 23, 97
    MOVE.W  #$ffc5,(DIWSTOP-BLTDDAT)(A0)    ; $ff, $c5  -> 255, 197
    MOVE.W  #DDFSTRT_WIDE,(DDFSTRT-BLTDDAT)(A0)
    MOVE.W  #DDFSTOP_WIDE,(DDFSTOP-BLTDDAT)(A0)
    ; $58 = 88
    ; 88 * 8 = 704
    ; SCREEN_WIDTH_BYTES	equ (320/8)
    ; SCREEN_BIT_DEPTH	equ 5
    ; BPL1MOD,SCREEN_WIDTH_BYTES*SCREEN_BIT_DEPTH-SCREEN_WIDTH_BYTES
    ; how is this calculated?
    MOVE.W  #$58,(BPL1MOD-BLTDDAT)(A0)
    MOVE.W  #$58,(BPL2MOD-BLTDDAT)(A0)
    JSR     LAB_0CA7

    LEA     LAB_1E51,A2
    MOVE.L  A2,D0
    MOVE.W  D0,LAB_1E24
    SWAP    D0
    MOVE.W  D0,LAB_1E23
    LEA     LAB_1E22,A2
    MOVE.L  A2,D0
    MOVE.W  D0,LAB_1E53
    SWAP    D0
    MOVE.W  D0,LAB_1E52
    LEA     LAB_1E4D,A2
    MOVE.L  A2,D0
    MOVE.W  D0,LAB_1E42
    SWAP    D0
    MOVE.W  D0,LAB_1E41
    LEA     LAB_1E7A,A2
    MOVE.L  A2,D0
    MOVE.W  D0,LAB_1E6F
    SWAP    D0
    MOVE.W  D0,LAB_1E6E
    LEA     LAB_1E51,A2
    MOVE.W  (VPOSR-BLTDDAT)(A0),D0
    BPL.S   LAB_0C81

    LEA     LAB_1E22,A2

LAB_0C81:
    MOVE.L  A2,(COP1LCH-BLTDDAT)(A0)
    MOVE.W  (COPJMP1-BLTDDAT)(A0),D0
    MOVE.W  #$20,(DMACON-BLTDDAT)(A0)
    MOVE.W  #$8180,(DMACON-BLTDDAT)(A0)
    RTS

;!======

LAB_0C82:
    MOVEM.L D0-D3/A0-A6,-(A7)

    LEA     BLTDDAT,A0
    LEA     LAB_1E22,A2
    MOVEQ   #1,D1
    MOVE.W  (VPOSR-BLTDDAT)(A0),D0
    BPL.S   .LAB_0C83            ; BPL = checks to see if bit 15 is set (LOF), if it is jump to LAB_0C83

    LEA     LAB_1E51,A2
    MOVEQ   #0,D1

.LAB_0C83:
    MOVE.L  A2,(COP1LCH-BLTDDAT)(A0)
    MOVE.L  D1,LAB_1F51
    TST.W   LAB_1F3B
    BEQ.S   .LAB_0C84

    JSR     LAB_0C80(PC)

    MOVE.W  #0,LAB_1F3B
    BRA.W   .LAB_0C8B

.LAB_0C84:
    JSR     LAB_14C8

    TST.W   LAB_2121
    BNE.W   .LAB_0C8B

    TST.B   LAB_1FA9
    BNE.W   .LAB_0C8A

    CMPI.W  #$200,LAB_1F45
    BNE.W   .LAB_0C85

    MOVE.W  #$100,LAB_1F45
    BRA.W   .LAB_0C89

.LAB_0C85:
    CMPI.W  #$102,LAB_1F45
    BNE.W   .LAB_0C86

    BRA.W   .LAB_0C8B

.LAB_0C86:
    CMPI.W  #$101,LAB_1F45
    BNE.W   .LAB_0C87

    BRA.W   .LAB_0C8B

.LAB_0C87:
    CMPI.W  #$100,LAB_1F45
    BEQ.W   .LAB_0C8B

    TST.W   LAB_1F45
    BMI.S   .LAB_0C88

    MOVEQ   #1,D0
    SUB.W   D0,LAB_1F45
    BRA.W   .LAB_0C8B

.LAB_0C88:
    SUBQ.W  #1,LAB_1F3F
    BPL.S   .LAB_0C8B

.LAB_0C89:
    MOVE.W  LAB_1F40,LAB_1F3F
    TST.W   LAB_1D31
    BEQ.S   .LAB_0C8B

    JSR     LAB_0DCF

    BRA.S   .LAB_0C8B

.LAB_0C8A:
    SUBQ.B  #1,LAB_1FA9
    SUBQ.W  #1,LAB_1F3F
    JSR     LAB_0C9E

.LAB_0C8B:
    MOVEM.L (A7)+,D0-D3/A0-A6
    RTS

;!======

    MOVE.W  LAB_1E3C,LAB_1F30
    MOVE.W  LAB_1E3B,LAB_1F2F
    MOVE.W  LAB_1E3E,LAB_1F32
    MOVE.W  LAB_1E3D,LAB_1F31
    MOVE.W  LAB_1E40,LAB_1F34
    MOVE.W  LAB_1E3F,LAB_1F33
    RTS

;!======

    MOVE.L  #$b0,D1
    MOVEQ   #1,D0
    ADD.W   D1,LAB_1E3C
    BCC.S   LAB_0C8C

    ADD.W   D0,LAB_1E3B

LAB_0C8C:
    ADD.W   D1,LAB_1E3E
    BCC.S   LAB_0C8D

    ADD.W   D0,LAB_1E3D

LAB_0C8D:
    ADD.W   D1,LAB_1E40
    BCC.S   LAB_0C8E

    ADD.W   D0,LAB_1E3F

LAB_0C8E:
    ADD.W   D1,LAB_1E69
    BCC.S   LAB_0C8F

    ADD.W   D0,LAB_1E68

LAB_0C8F:
    ADD.W   D1,LAB_1E6B
    BCC.S   LAB_0C90

    ADD.W   D0,LAB_1E6A

LAB_0C90:
    ADD.W   D1,LAB_1E6D
    BCC.S   LAB_0C91

    ADD.W   D0,LAB_1E6C

LAB_0C91:
    RTS

;!======

LAB_0C92:
    MOVE.L  A1,-(A7)
    LEA     LAB_2207,A1
    MOVE.L  (A1),LAB_1F35
    LEA     LAB_2208,A1
    MOVE.L  (A1),LAB_1F36
    LEA     LAB_2209,A1
    MOVE.L  (A1),LAB_1F37
    MOVEA.L (A7)+,A1
    RTS

;!======

LAB_0C93:
    MOVEM.L D1/A1-A4,-(A7)
    LEA     20(A1),A1
    LEA     LAB_1F2F,A2
    MOVEA.L (A1),A3
    MOVEA.L (A2)+,A4
    MOVE.L  #$2b,D1

LAB_0C94:
    MOVE.L  (A3)+,(A4)+
    DBF     D1,LAB_0C94
    MOVE.L  A3,(A1)+
    MOVEA.L (A1),A3
    MOVEA.L (A2)+,A4
    MOVE.L  #$2b,D1

LAB_0C95:
    MOVE.L  (A3)+,(A4)+
    DBF     D1,LAB_0C95
    MOVE.L  A3,(A1)+
    MOVEA.L (A1),A3
    MOVEA.L (A2)+,A4
    MOVE.L  #$2b,D1

LAB_0C96:
    MOVE.L  (A3)+,(A4)+
    DBF     D1,LAB_0C96
    MOVE.L  A3,(A1)+
    MOVEM.L (A7)+,D1/A1-A4
    RTS

;!======

LAB_0C97:
    MOVEM.L D0-D1/A0-A4,-(A7)
    LEA     LAB_2207,A1
    MOVEA.L (A1),A3
    LEA     LAB_1F2F,A2
    MOVEA.L (A2)+,A4
    MOVE.L  #$2b,D1

LAB_0C98:
    MOVE.L  (A3)+,(A4)+
    DBF     D1,LAB_0C98
    LEA     LAB_2208,A1
    MOVEA.L (A1),A3
    MOVEA.L (A2)+,A4
    MOVE.L  #$2b,D1

LAB_0C99:
    MOVE.L  (A3)+,(A4)+
    DBF     D1,LAB_0C99
    LEA     LAB_2209,A1
    MOVEA.L (A1),A3
    MOVEA.L (A2)+,A4
    MOVE.L  #$2b,D1

LAB_0C9A:
    MOVE.L  (A3)+,(A4)+
    DBF     D1,LAB_0C9A
    MOVEM.L (A7)+,D0-D1/A0-A4
    RTS

;!======

LAB_0C9B:
    MOVE.L  LAB_1F52,D0
    MULU    #$58,D0
    MOVE.L  D0,LAB_1F4C
    CLR.L   D0
    MOVE.W  LAB_1F53,D0
    LSR.W   #3,D0
    MOVE.L  D0,LAB_1F4D
    ADDI.L  #$58,D0
    MOVE.L  D0,LAB_1F50
    MOVE.W  LAB_1F54,D0
    LSR.W   #5,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,LAB_1F4B
    MOVE.W  #$22,D0
    LSR.W   #1,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,LAB_1F55
    RTS

;!======

LAB_0C9C:
    MOVEM.L D0/A0-A2,-(A7)
    MOVEA.L A0,A1
    ADDA.L  LAB_2310,A1
    MOVEA.L A1,A2
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    MOVEA.L A0,A2
    ADDA.L  LAB_2311,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    MOVEM.L (A7)+,D0/A0-A2
    RTS

;!======

LAB_0C9D:
    MOVEM.L D0-D1/A0-A2,-(A7)
    MOVE.L  LAB_1F4E,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L A1,A2
    ADDA.L  #$b0,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  LAB_1F50,A1
    ADDA.L  LAB_1F50,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  LAB_1F50,A1
    ADDA.L  LAB_1F50,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  LAB_1F50,A1
    ADDA.L  LAB_1F50,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  LAB_1F50,A1
    ADDA.L  LAB_1F50,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  LAB_1F50,A1
    ADDA.L  LAB_1F50,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  LAB_1F50,A1
    ADDA.L  LAB_1F50,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  LAB_1F50,A1
    ADDA.L  LAB_1F50,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  LAB_1F50,A1
    ADDA.L  LAB_1F50,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  LAB_1F50,A1
    ADDA.L  LAB_1F50,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  LAB_1F50,A1
    ADDA.L  LAB_1F50,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  LAB_1F50,A1
    ADDA.L  LAB_1F50,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  LAB_1F50,A1
    ADDA.L  LAB_1F50,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  LAB_1F50,A1
    ADDA.L  LAB_1F50,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  LAB_1F50,A1
    ADDA.L  LAB_1F50,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  LAB_1F50,A1
    ADDA.L  LAB_1F50,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  LAB_1F50,A1
    MOVE.L  LAB_2307,D1
    ADD.L   LAB_1F4F,D1
    MOVEA.L A0,A2
    ADDA.L  D1,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVEM.L (A7)+,D0-D1/A0-A2
    RTS

;!======

LAB_0C9E:
    MOVEM.L D0/A0-A1,-(A7)
    MOVE.L  LAB_1F4C,D1
    MOVE.L  LAB_1F4D,D0
    TST.L   LAB_1F51
    BNE.S   LAB_0C9F

    ADDI.L  #$58,D0
    LEA     LAB_1E2B,A0
    BRA.S   LAB_0CA0

LAB_0C9F:
    LEA     LAB_1E58,A0

LAB_0CA0:
    MOVE.L  D0,LAB_1F4F
    ADD.L   D0,D1
    MOVE.L  D1,LAB_1F4E
    JSR     LAB_0C9C(PC)

    LEA     LAB_2267,A1
    MOVEA.L (A1),A0
    JSR     LAB_0C9D(PC)

    LEA     LAB_2268,A1
    MOVEA.L (A1),A0
    JSR     LAB_0C9D(PC)

    LEA     LAB_2269,A1
    MOVEA.L (A1),A0
    JSR     LAB_0C9D(PC)

    MOVEM.L (A7)+,D0/A0-A1
    RTS

;!======

LAB_0CA1:
    MOVEQ   #7,D4

LAB_0CA2:
    JSR     LAB_0CA6

    CMPI.W  #4,D3
    BEQ.W   LAB_0CA3

    CMPI.W  #$1c,D3
    BEQ.W   LAB_0CA4

    MOVE.W  D0,0(A2,D3.W)
    MOVE.W  D0,0(A3,D3.W)
    BRA.W   LAB_0CA5

LAB_0CA3:
    LEA     LAB_1E36,A4
    MOVE.W  D0,(A4)
    LEA     LAB_1E63,A4
    MOVE.W  D0,(A4)
    LEA     LAB_1E43,A4
    MOVE.W  D0,(A4)
    LEA     LAB_1E70,A4
    MOVE.W  D0,(A4)
    BRA.W   LAB_0CA5

LAB_0CA4:
    LEA     LAB_1E44,A4
    MOVE.W  D0,(A4)
    LEA     LAB_1E71,A4
    MOVE.W  D0,(A4)

LAB_0CA5:
    ADDQ.W  #4,D3
    DBF     D4,LAB_0CA2
    RTS

;!======

LAB_0CA6:
    MOVE.B  (A1)+,D2
    MOVE.B  (A1)+,D1
    MOVE.B  (A1)+,D0
    ANDI.W  #15,D2
    ANDI.W  #15,D1
    ANDI.W  #15,D0
    LSL.W   #8,D2
    LSL.W   #4,D1
    ADD.W   D1,D0
    ADD.W   D2,D0
    RTS

;!======

LAB_0CA7:
    RTS

;!======

    MOVEM.L D0-D4/A0-A4,-(A7)
    LEA     LAB_1E2E,A2
    LEA     LAB_1E5B,A3
    MOVE.W  #0,D3
    LEA     LAB_1DE0,A1
    JSR     LAB_0CA1(PC)

    MOVEM.L (A7)+,D0-D4/A0-A4
    RTS

;!======

LAB_0CA8:
    MOVE.B  D0,(A4)
    LEA     LAB_1E58,A4
    MOVE.B  D0,(A4)
    LEA     LAB_1E2F,A4
    ADDI.B  #$1,D0
    MOVE.B  D0,(A4)
    LEA     LAB_1E5C,A4
    MOVE.B  D0,(A4)
    ADDI.B  #$11,D0
    LEA     LAB_1E37,A4
    MOVE.B  D0,(A4)
    LEA     LAB_1E64,A4
    MOVE.B  D0,(A4)
    ADDQ.W  #1,D0
    LEA     LAB_1E3A,A4
    MOVE.B  D0,(A4)
    LEA     LAB_1E67,A4
    MOVE.B  D0,(A4)
    ANDI.W  #$ff,D0
    MOVE.W  D0,LAB_1F49
    RTS

;!======

    LEA     LAB_1F4A,A4
    MOVEQ   #0,D0
    MOVE.W  (A4),D0
    SUBQ.W  #2,D0
    CMP.W   LAB_1F49,D0
    BPL.W   LAB_0CA9

    RTS

;!======

LAB_0CA9:
    SUBI.W  #1,LAB_1F3D
    BNE.W   LAB_0CAA

    BRA.W   LAB_0CAB

LAB_0CAA:
    BPL.W   LAB_0CAB

    MOVE.W  #0,LAB_1F3D
    JSR     LAB_005C

LAB_0CAB:
    SUBI.W  #1,LAB_1F46
    LEA     LAB_1E2B,A4
    MOVEQ   #0,D0
    MOVE.B  (A4),D0
    ADDQ.W  #1,D0
    CMPI.B  #$f6,D0
    BNE.W   LAB_0CAD

LAB_0CAC:
    LEA     LAB_1E2B,A4
    MOVE.W  #$62,LAB_1F46
    MOVE.W  #$19,D0

LAB_0CAD:
    BSR.W   LAB_0CA8

    MOVE.W  #$58,D1
    JSR     LAB_0C7D(PC)

    RTS

;!======

    MOVEM.L D2-D7/A2-A6,-(A7)
    LEA     LAB_1E2B,A4
    MOVEQ   #0,D0
    MOVE.B  (A4),D0
    BSR.W   LAB_0CA8

    MOVEM.L (A7)+,D2-D7/A2-A6
    RTS

;!======

    LEA     LAB_1F4A,A4
    MOVEQ   #0,D0
    MOVE.W  (A4),D0
    SUBQ.W  #2,D0
    CMP.W   LAB_1F49,D0
    BPL.W   LAB_0CAE

    RTS

;!======

LAB_0CAE:
    SUBI.W  #1,LAB_1F3E
    BNE.W   LAB_0CAF

    BRA.W   LAB_0CB0

LAB_0CAF:
    BPL.W   LAB_0CB0

    MOVE.W  #0,LAB_1F3E
    JSR     LAB_005C

LAB_0CB0:
    ADDI.W  #1,LAB_1F46
    LEA     LAB_1E2B,A4
    MOVEQ   #0,D0
    MOVE.B  (A4),D0
    SUBQ.W  #1,D0
    BRA.S   LAB_0CAD

    LEA     LAB_1E2B,A4
    MOVE.W  #$62,LAB_1F46
    MOVE.W  #$19,D0
    BRA.W   LAB_0CAD

    RTS

;!======

    MOVEM.L D0-D1/A2,-(A7)
    MOVE.W  LAB_1E48,D0
    MOVE.W  LAB_1E3C,D1
    CMP.W   D0,D1
    BEQ.S   LAB_0CB1

    MOVE.W  LAB_1F4A,D0
    CMPI.W  #$f6,D0
    BLT.S   LAB_0CB2

LAB_0CB1:
    MOVE.W  #$8a,LAB_1E45
    MOVE.W  #$8a,LAB_1F47

LAB_0CB2:
    MOVE.W  LAB_1E75,D0
    MOVE.W  LAB_1E69,D1
    CMP.W   D0,D1
    BEQ.S   LAB_0CB3

    MOVE.W  LAB_1F4A,D0
    CMPI.W  #$f6,D0
    BLT.S   LAB_0CB4

LAB_0CB3:
    MOVE.W  #$8a,LAB_1E72
    MOVE.W  #$8a,LAB_1F47

LAB_0CB4:
    MOVEM.L (A7)+,D0-D1/A2
    RTS

;!======

    ; Alignment
    ALIGN_WORD
