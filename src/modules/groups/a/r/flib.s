LAB_0CB5:
    LINK.W  A5,#-132
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 8(A5),A3

LAB_0CB6:
    TST.L   LAB_1F57
    BNE.S   LAB_0CB6

    MOVEQ   #1,D0
    MOVE.L  D0,LAB_1F57
    MOVE.W  LAB_233A,D0
    CMPI.W  #$2710,D0
    BLE.S   LAB_0CB7

    CLR.L   LAB_1F57
    MOVEQ   #0,D0
    BRA.W   LAB_0CBF

LAB_0CB7:
    MOVEA.L A3,A0

LAB_0CB8:
    TST.B   (A0)+
    BNE.S   LAB_0CB8

    SUBQ.L  #1,A0
    SUBA.L  A3,A0
    MOVE.L  A0,D7
    MOVEQ   #100,D0
    CMP.W   D0,D7
    BLE.S   LAB_0CB9

    MOVE.L  D0,D7
    CLR.B   99(A3)

LAB_0CB9:
    MOVE.W  LAB_223E,D0
    EXT.L   D0
    MOVEQ   #100,D1
    JSR     JMPTBL_MATH_DivS32_3(PC)

    MOVE.W  LAB_223F,D0
    EXT.L   D0
    MOVE.L  D1,8(A7)
    MOVEQ   #100,D1
    JSR     JMPTBL_MATH_DivS32_3(PC)

    MOVE.W  GLOB_REF_CLOCKDATA_STRUCT,D0
    EXT.L   D0
    MOVE.L  D1,12(A7)
    MOVEQ   #100,D1
    JSR     JMPTBL_MATH_DivS32_3(PC)

    TST.W   LAB_2243
    BEQ.S   LAB_0CBA

    LEA     LAB_1F59,A0
    BRA.S   LAB_0CBB

LAB_0CBA:
    LEA     LAB_1F5A,A0

LAB_0CBB:
    MOVE.L  A0,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  20(A7),-(A7)
    MOVE.L  20(A7),-(A7)
    PEA     LAB_1F58
    PEA     -119(A5)
    JSR     GROUP_AW_JMPTBL_WDISP_SPrintf(PC)

    LEA     24(A7),A7
    ADDI.W  #14,D7
    PEA     LAB_1F5B
    PEA     -119(A5)
    JSR     GROUP_AR_JMPTBL_STRING_AppendAtNull(PC)

    MOVE.L  A3,(A7)
    PEA     -119(A5)
    JSR     GROUP_AR_JMPTBL_STRING_AppendAtNull(PC)

    PEA     LAB_1F5C
    PEA     -119(A5)
    JSR     GROUP_AR_JMPTBL_STRING_AppendAtNull(PC)

    LEA     20(A7),A7
    MOVE.W  LAB_233A,D0
    MOVE.L  D0,D1
    ADD.W   D7,D1
    MOVE.W  D1,LAB_233A
    EXT.L   D1
    ADDQ.L  #1,D1
    PEA     (MEMF_PUBLIC).W
    MOVE.L  D1,-(A7)
    PEA     173.W
    PEA     GLOB_STR_FLIB_C_1
    JSR     NEWGRID_JMPTBL_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.W  LAB_233A,D1
    MOVE.L  D0,-4(A5)
    CMP.W   D7,D1
    BEQ.S   LAB_0CBD

    MOVEA.L LAB_2049,A0
    MOVEA.L D0,A1

LAB_0CBC:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_0CBC

    BRA.S   LAB_0CBE

LAB_0CBD:
    MOVEA.L D0,A0
    CLR.B   (A0)

LAB_0CBE:
    PEA     -119(A5)
    MOVE.L  -4(A5),-(A7)
    JSR     GROUP_AR_JMPTBL_STRING_AppendAtNull(PC)

    MOVE.L  LAB_2049,(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     LAB_0B44(PC)

    MOVE.L  D0,LAB_2049
    MOVE.W  LAB_233A,D0
    EXT.L   D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     198.W
    PEA     GLOB_STR_FLIB_C_2
    JSR     NEWGRID_JMPTBL_DeallocateMemory(PC)

    CLR.L   LAB_1F57

LAB_0CBF:
    MOVEM.L -140(A5),D7/A3
    UNLK    A5
    RTS

;!======

    MOVEM.L D6-D7,-(A7)
    MOVE.W  14(A7),D7
    MOVEQ   #0,D6
    TST.W   D7
    BNE.S   LAB_0CC0

    MOVE.W  LAB_223A,D0
    SUBQ.W  #3,D0
    BNE.S   LAB_0CC1

    MOVE.W  LAB_223C,D0
    MOVEQ   #7,D1
    CMP.W   D1,D0
    BGE.S   LAB_0CC1

    MOVE.W  LAB_223E,D0
    SUBQ.W  #5,D0
    BNE.S   LAB_0CC1

LAB_0CC0:
    MOVEQ   #1,D6

LAB_0CC1:
    TST.W   D6
    BEQ.S   LAB_0CC2

    MOVE.L  LAB_2049,-(A7)
    PEA     LAB_1F5F
    JSR     LAB_0B44(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_2049
    CLR.W   LAB_233A

LAB_0CC2:
    PEA     LAB_22CB
    BSR.W   LAB_0CB5

    JSR     GROUP_AR_JMPTBL_PARSEINI_WriteErrorLogEntry(PC)

    ADDQ.W  #4,A7
    MOVEM.L (A7)+,D6-D7
    RTS

;!======

    ; Dead code
    MOVEM.L D2-D3/A2-A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVEA.L 24(A7),A2
    MOVE.B  3(A3),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.B  2(A3),D1
    EXT.W   D1
    EXT.L   D1
    MOVE.B  1(A3),D2
    EXT.W   D2
    EXT.L   D2
    MOVE.B  (A3),D3
    EXT.W   D3
    EXT.L   D3
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_1F60
    MOVE.L  A2,-(A7)
    JSR     GROUP_AW_JMPTBL_WDISP_SPrintf(PC)

    LEA     24(A7),A7
    MOVEM.L (A7)+,D2-D3/A2-A3
    RTS

;!======

    RTS
