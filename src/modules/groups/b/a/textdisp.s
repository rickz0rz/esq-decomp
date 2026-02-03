;!======

LAB_15C5:
    LINK.W  A5,#-216
    MOVEM.L D2-D3/D5-D7,-(A7)
    MOVE.W  10(A5),D7
    MOVE.W  14(A5),D6
    MOVE.W  18(A5),D5
    CLR.L   -196(A5)
    MOVEQ   #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    MOVEM.L D0,-216(A5)
    TST.W   D7
    BNE.S   LAB_15C6

    MOVEQ   #2,D0

LAB_15C6:
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    JSR     GROUPD_JMPTBL_LAB_0926(PC)

    ADDQ.W  #8,A7
    MOVE.L  D6,D1
    EXT.L   D1
    MOVEM.L D0,-4(A5)
    TST.W   D7
    BEQ.S   LAB_15C7

    MOVEQ   #1,D2
    BRA.S   LAB_15C8

LAB_15C7:
    MOVEQ   #2,D2

LAB_15C8:
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    JSR     GROUPD_JMPTBL_LAB_0923(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    TST.L   D0
    BEQ.W   LAB_15E0

    TST.L   -4(A5)
    BEQ.W   LAB_15E0

    MOVE.W  LAB_234D,D1
    BNE.S   LAB_15C9

    MOVEQ   #48,D2
    MOVE.W  D2,LAB_234D

LAB_15C9:
    CLR.B   -137(A5)
    MOVE.W  LAB_234D,D1
    MOVEQ   #48,D2
    CMP.W   D2,D1
    BLT.S   LAB_15CA

    MOVEQ   #67,D2
    CMP.W   D2,D1
    BLE.S   LAB_15CB

LAB_15CA:
    MOVEQ   #72,D2
    CMP.W   D2,D1
    BLT.S   LAB_15CC

    MOVEQ   #77,D2
    CMP.W   D2,D1
    BGT.S   LAB_15CC

LAB_15CB:
    EXT.L   D1
    LEA     GLOB_STR_TEXTDISP_C_3,A0
    ADDA.L  D1,A0
    MOVE.W  LAB_2274,D1
    EXT.L   D1
    MOVEQ   #1,D2
    ASL.L   D1,D2
    MOVEQ   #0,D1
    MOVE.B  (A0),D1
    AND.L   D2,D1
    TST.L   D1
    BEQ.S   LAB_15CC

    MOVEQ   #1,D2
    BRA.S   LAB_15CD

LAB_15CC:
    MOVEQ   #0,D2

LAB_15CD:
    MOVE.L  D2,-212(A5)
    BEQ.W   LAB_15D4

    TST.W   D5
    BLE.W   LAB_15D4

    MOVEQ   #49,D1
    CMP.W   D1,D5
    BGE.W   LAB_15D4

    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  LAB_1BBD,-(A7)
    PEA     1440.W
    MOVE.L  D1,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  D0,-(A7)
    JSR     GROUPD_JMPTBL_LAB_036C(PC)

    LEA     20(A7),A7
    TST.L   D0
    BEQ.W   LAB_15D4

    MOVE.B  LAB_2377,D0
    MOVEQ   #100,D1
    CMP.B   D1,D0
    BEQ.S   LAB_15CE

    MOVEQ   #0,D0
    MOVE.B  LAB_2378,D0
    BRA.S   LAB_15CF

LAB_15CE:
    MOVEQ   #0,D0
    MOVE.B  LAB_2374,D0

LAB_15CF:
    MOVE.L  D0,-200(A5)
    SUBQ.L  #1,D0
    BNE.S   LAB_15D1

    LEA     GLOB_STR_ALIGNED_NOW_SHOWING,A0
    LEA     -188(A5),A1

LAB_15D0:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_15D0

    LEA     -188(A5),A0
    MOVE.L  A0,-192(A5)
    BRA.S   LAB_15D2

LAB_15D1:
    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  -4(A5),-(A7)
    MOVE.L  D0,-(A7)
    PEA     -188(A5)
    JSR     LAB_16F7(PC)

    PEA     -188(A5)
    JSR     LAB_1985(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-192(A5)

LAB_15D2:
    LEA     LAB_2134,A0
    LEA     -137(A5),A1

LAB_15D3:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_15D3

    MOVE.L  -192(A5),-(A7)
    PEA     -137(A5)
    JSR     UNKNOWN6_AppendDataAtNull(PC)

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -4(A5),A0
    MOVE.L  56(A0,D0.L),(A7)
    JSR     LAB_16A3(PC)

    ADDQ.W  #8,A7
    CLR.L   -216(A5)
    MOVE.L  D0,-196(A5)
    BRA.S   LAB_15D8

LAB_15D4:
    MOVE.W  LAB_234D,D0
    MOVEQ   #48,D1
    CMP.W   D1,D0
    BLE.S   LAB_15D5

    MOVEQ   #67,D1
    CMP.W   D1,D0
    BLE.S   LAB_15D6

LAB_15D5:
    MOVEQ   #72,D1
    CMP.W   D1,D0
    BLT.S   LAB_15D8

    MOVEQ   #77,D1
    CMP.W   D1,D0
    BGT.S   LAB_15D8

LAB_15D6:
    LEA     LAB_2135,A0
    LEA     -137(A5),A1

LAB_15D7:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_15D7

    MOVE.W  LAB_234D,D0
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     LAB_20ED,A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-(A7)
    PEA     -137(A5)
    JSR     UNKNOWN6_AppendDataAtNull(PC)

    PEA     LAB_234B
    JSR     LAB_16A3(PC)

    LEA     12(A7),A7
    MOVEQ   #0,D1
    MOVE.L  D0,-196(A5)
    MOVE.L  D1,-216(A5)

LAB_15D8:
    TST.L   -216(A5)
    BNE.W   LAB_15E3

    MOVEQ   #0,D0
    MOVE.L  D0,-204(A5)
    MOVE.L  D0,-208(A5)

LAB_15D9:
    MOVEA.L -8(A5),A0
    MOVE.L  -204(A5),D0
    TST.B   1(A0,D0.L)
    BEQ.S   LAB_15DB

    MOVEQ   #32,D1
    CMP.B   1(A0,D0.L),D1
    BEQ.S   LAB_15DA

    LEA     -188(A5),A1
    ADDA.L  -208(A5),A1
    ADDQ.L  #1,-208(A5)
    MOVE.B  1(A0,D0.L),(A1)

LAB_15DA:
    ADDQ.L  #1,-204(A5)
    BRA.S   LAB_15D9

LAB_15DB:
    LEA     -188(A5),A0
    ADDA.L  -208(A5),A0
    MOVEQ   #0,D0
    MOVE.B  D0,(A0)
    MOVE.B  -188(A5),D1
    TST.B   D1
    BEQ.S   LAB_15DD

    MOVE.B  -137(A5),D1
    TST.B   D1
    BEQ.S   LAB_15DC

    PEA     LAB_2136
    PEA     -137(A5)
    JSR     UNKNOWN6_AppendDataAtNull(PC)

    ADDQ.W  #8,A7

LAB_15DC:
    PEA     LAB_2137
    PEA     -137(A5)
    JSR     UNKNOWN6_AppendDataAtNull(PC)

    PEA     -188(A5)
    PEA     -137(A5)
    JSR     UNKNOWN6_AppendDataAtNull(PC)

    LEA     16(A7),A7

LAB_15DD:
    TST.L   -196(A5)
    BEQ.S   LAB_15DF

    MOVE.B  -137(A5),D0
    TST.B   D0
    BEQ.S   LAB_15DE

    PEA     LAB_2138
    PEA     -137(A5)
    JSR     UNKNOWN6_AppendDataAtNull(PC)

    ADDQ.W  #8,A7

LAB_15DE:
    MOVEQ   #0,D0
    MOVEA.L -196(A5),A0
    MOVE.B  (A0),D0
    MOVE.L  D0,-(A7)
    PEA     LAB_2139
    PEA     -188(A5)
    JSR     WDISP_SPrintf(PC)

    PEA     -188(A5)
    PEA     -137(A5)
    JSR     UNKNOWN6_AppendDataAtNull(PC)

    LEA     20(A7),A7

LAB_15DF:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    MOVE.L  D5,D2
    EXT.L   D2
    MOVEQ   #0,D3
    MOVE.L  D3,-(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -137(A5)
    JSR     GROUP_BA_JMPTBL_CLEANUP_BuildAlignedStatusLine(PC)

    LEA     24(A7),A7
    BRA.S   LAB_15E3

LAB_15E0:
    TST.L   LAB_205C
    BEQ.S   LAB_15E2

    MOVEA.L LAB_205C,A0
    TST.B   (A0)
    BEQ.S   LAB_15E2

    LEA     LAB_213A,A0
    LEA     -137(A5),A1

LAB_15E1:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_15E1

    MOVE.L  LAB_205C,-(A7)
    PEA     -137(A5)
    JSR     UNKNOWN6_AppendDataAtNull(PC)

    ADDQ.W  #8,A7
    BRA.S   LAB_15E3

LAB_15E2:
    CLR.B   -137(A5)

LAB_15E3:
    PEA     -137(A5)
    BSR.W   LAB_15AD

    MOVEM.L -236(A5),D2-D3/D5-D7
    UNLK    A5
    RTS

;!======

LAB_15E4:
    LINK.W  A5,#-148
    MOVEM.L D2-D3/D5-D7,-(A7)
    MOVE.W  10(A5),D7
    MOVE.W  14(A5),D6
    MOVE.W  18(A5),D5
    MOVE.L  D6,D0
    EXT.L   D0
    TST.W   D7
    BEQ.S   LAB_15E5

    MOVEQ   #1,D1
    BRA.S   LAB_15E6

LAB_15E5:
    MOVEQ   #2,D1

LAB_15E6:
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     GROUPD_JMPTBL_LAB_0926(PC)

    ADDQ.W  #8,A7
    MOVE.L  D6,D1
    EXT.L   D1
    MOVEM.L D0,-8(A5)
    TST.W   D7
    BEQ.S   LAB_15E7

    MOVEQ   #1,D2
    BRA.S   LAB_15E8

LAB_15E7:
    MOVEQ   #2,D2

LAB_15E8:
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    JSR     GROUPD_JMPTBL_LAB_0923(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.W   LAB_15F0

    TST.L   -8(A5)
    BEQ.W   LAB_15F0

    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  LAB_1BBD,-(A7)
    PEA     30.W
    MOVE.L  D1,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  D0,-(A7)
    JSR     GROUPD_JMPTBL_LAB_036C(PC)

    LEA     20(A7),A7
    TST.L   D0
    BEQ.W   LAB_15F0

    MOVEQ   #1,D0
    CMP.W   D0,D5
    BLT.S   LAB_15E9

    MOVEQ   #48,D0
    CMP.W   D0,D5
    BLE.S   LAB_15EA

LAB_15E9:
    MOVEQ   #-1,D5

LAB_15EA:
    MOVE.L  D5,D0
    EXT.L   D0
    PEA     2.W
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     GROUPD_JMPTBL_LAB_0347(PC)

    MOVE.L  D5,D1
    EXT.L   D1
    PEA     3.W
    MOVE.L  D1,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  D0,-142(A5)
    JSR     GROUPD_JMPTBL_LAB_0347(PC)

    LEA     24(A7),A7
    MOVE.L  D0,-146(A5)
    TST.L   -142(A5)
    BEQ.S   LAB_15EC

    LEA     LAB_213B,A0
    LEA     -137(A5),A1

LAB_15EB:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_15EB

    MOVE.L  -142(A5),-(A7)
    PEA     -137(A5)
    JSR     UNKNOWN6_AppendDataAtNull(PC)

    ADDQ.W  #8,A7
    BRA.S   LAB_15ED

LAB_15EC:
    MOVEQ   #0,D0
    MOVE.B  D0,-137(A5)

LAB_15ED:
    TST.L   -146(A5)
    BEQ.S   LAB_15EF

    MOVE.B  -137(A5),D0
    TST.B   D0
    BEQ.S   LAB_15EE

    PEA     LAB_213C
    PEA     -137(A5)
    JSR     UNKNOWN6_AppendDataAtNull(PC)

    ADDQ.W  #8,A7

LAB_15EE:
    PEA     LAB_213D
    PEA     -137(A5)
    JSR     UNKNOWN6_AppendDataAtNull(PC)

    MOVE.L  -146(A5),(A7)
    PEA     -137(A5)
    JSR     UNKNOWN6_AppendDataAtNull(PC)

    LEA     12(A7),A7

LAB_15EF:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    MOVE.L  D5,D2
    EXT.L   D2
    MOVEQ   #0,D3
    MOVE.L  D3,-(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -137(A5)
    JSR     GROUP_BA_JMPTBL_CLEANUP_BuildAlignedStatusLine(PC)

    LEA     24(A7),A7
    TST.B   -137(A5)
    BEQ.S   LAB_15F0

    PEA     -137(A5)
    BSR.W   LAB_15AD

    ADDQ.W  #4,A7

LAB_15F0:
    MOVEM.L (A7)+,D2-D3/D5-D7
    UNLK    A5
    RTS

;!======

LAB_15F1:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEQ   #0,D7
    MOVE.L  A3,D0
    BEQ.S   LAB_15F4

    BTST    #0,40(A3)
    BEQ.S   LAB_15F2

    BTST    #3,40(A3)
    BEQ.S   LAB_15F2

    MOVE.L  A3,-(A7)
    JSR     LAB_1678(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BNE.S   LAB_15F2

    BTST    #3,27(A3)
    BNE.S   LAB_15F2

    MOVEQ   #1,D0
    BRA.S   LAB_15F3

LAB_15F2:
    MOVEQ   #0,D0

LAB_15F3:
    MOVE.L  D0,D7

LAB_15F4:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

LAB_15F5:
    MOVEM.L D6-D7,-(A7)
    MOVE.L  12(A7),D7
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    BEQ.S   LAB_15F6

    SUBQ.L  #1,D0
    BEQ.S   LAB_15F7

    BRA.S   LAB_15F8

LAB_15F6:
    MOVE.W  LAB_2231,D6
    BRA.S   LAB_15F9

LAB_15F7:
    MOVE.W  LAB_222F,D6
    BRA.S   LAB_15F9

LAB_15F8:
    MOVEQ   #0,D6

LAB_15F9:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7
    RTS

;!======

LAB_15FA:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    MOVE.L  A3,D0
    BEQ.S   LAB_15FB

    MOVEQ   #3,D0
    MOVE.L  D0,210(A3)
    MOVEQ   #-1,D0
    MOVE.L  D0,214(A3)
    MOVE.W  #(-1),218(A3)
    CLR.B   220(A3)

LAB_15FB:
    MOVEA.L (A7)+,A3
    RTS

;!======

LAB_15FC:
    LINK.W  A5,#-4
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.B  LAB_1BC7,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   LAB_15FD

    MOVEQ   #0,D0
    MOVE.W  LAB_2174,D0
    MOVE.L  D0,LAB_2362
    BRA.S   LAB_15FE

LAB_15FD:
    MOVEQ   #0,D0
    MOVE.W  GLOB_REF_WORD_HEX_CODE_8E,D0
    MOVE.L  D0,LAB_2362

LAB_15FE:
    MOVE.L  A3,D0
    BEQ.S   LAB_1602

    MOVEA.L A3,A0
    MOVE.L  A0,-4(A5)
    MOVE.L  A2,D0
    BEQ.S   LAB_15FF

    PEA     9.W
    MOVE.L  A2,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_1955(PC)

    LEA     12(A7),A7
    MOVEQ   #0,D0
    MOVEA.L -4(A5),A0
    MOVE.B  D0,9(A0)
    BRA.S   LAB_1600

LAB_15FF:
    CLR.B   (A0)

LAB_1600:
    LEA     10(A3),A1
    MOVE.L  A1,-4(A5)
    MOVE.L  A2,D0
    BEQ.S   LAB_1601

    PEA     199.W
    MOVE.L  16(A5),-(A7)
    MOVE.L  A1,-(A7)
    JSR     LAB_1955(PC)

    LEA     12(A7),A7
    MOVEQ   #0,D0
    MOVEA.L -4(A5),A0
    MOVE.B  D0,199(A0)
    BRA.S   LAB_1602

LAB_1601:
    CLR.B   (A1)

LAB_1602:
    MOVEM.L (A7)+,A2-A3
    UNLK    A5
    RTS

;!======

LAB_1603:
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.L  24(A7),D7
    MOVE.L  28(A7),D6
    MOVE.L  32(A7),D5
    MOVE.L  A3,D0
    BEQ.S   LAB_160C

    MOVEQ   #1,D0
    CMP.L   D0,D7
    BEQ.S   LAB_1604

    MOVEQ   #2,D0
    CMP.L   D0,D7
    BNE.S   LAB_1605

LAB_1604:
    MOVE.L  D7,D0
    BRA.S   LAB_1606

LAB_1605:
    MOVEQ   #3,D0

LAB_1606:
    MOVE.L  D0,210(A3)
    MOVE.L  D0,-(A7)
    BSR.W   LAB_15F5

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    CMP.L   D1,D6
    BGE.S   LAB_1607

    MOVE.L  D6,D0
    BRA.S   LAB_1608

LAB_1607:
    MOVEQ   #-1,D0

LAB_1608:
    MOVE.L  D0,214(A3)
    TST.L   D5
    BLE.S   LAB_1609

    MOVEQ   #49,D1
    CMP.L   D1,D5
    BGE.S   LAB_1609

    MOVE.L  D5,D1
    BRA.S   LAB_160A

LAB_1609:
    MOVEQ   #-1,D1

LAB_160A:
    MOVE.W  D1,218(A3)
    CLR.B   220(A3)
    MOVEQ   #3,D0
    CMP.L   210(A3),D0
    BEQ.S   LAB_160B

    MOVEQ   #-1,D0
    CMP.L   214(A3),D0
    BEQ.S   LAB_160B

    MOVEQ   #-1,D0
    CMP.W   218(A3),D0
    BNE.S   LAB_160C

LAB_160B:
    MOVE.L  A3,-(A7)
    BSR.W   LAB_15FA

    ADDQ.W  #4,A7

LAB_160C:
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======

LAB_160D:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    MOVE.L  A3,D0
    BEQ.S   LAB_160F

    MOVEQ   #40,D0
    CMP.B   (A3),D0
    BNE.S   LAB_160E

    ADDQ.L  #8,A3

LAB_160E:
    MOVEQ   #0,D0
    MOVE.B  (A3),D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #3,(A0)
    BEQ.S   LAB_160F

    ADDQ.L  #1,A3
    BRA.S   LAB_160E

LAB_160F:
    MOVE.L  A3,D0
    MOVEA.L (A7)+,A3
    RTS

;!======

LAB_1610:
    LINK.W  A5,#-540
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  A3,D0
    BEQ.W   LAB_162B

    MOVEQ   #3,D0
    CMP.L   210(A3),D0
    BEQ.S   LAB_1611

    MOVEQ   #-1,D0
    CMP.L   214(A3),D0
    BEQ.S   LAB_1611

    MOVEQ   #-1,D0
    CMP.W   218(A3),D0
    BNE.S   LAB_1612

LAB_1611:
    MOVE.L  A3,-(A7)
    BSR.W   LAB_15FA

    ADDQ.W  #4,A7
    BRA.W   LAB_162B

LAB_1612:
    LEA     10(A3),A0
    MOVE.L  210(A3),-(A7)
    MOVE.L  214(A3),-(A7)
    MOVE.L  A0,-4(A5)
    JSR     GROUPD_JMPTBL_LAB_0926(PC)

    MOVE.L  210(A3),(A7)
    MOVE.L  214(A3),-(A7)
    MOVE.L  D0,-532(A5)
    JSR     GROUPD_JMPTBL_LAB_0923(PC)

    LEA     220(A3),A0
    CLR.B   (A0)
    PEA     -524(A5)
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-528(A5)
    MOVE.L  A0,-8(A5)
    JSR     LAB_16D3(PC)

    LEA     20(A7),A7
    LEA     -524(A5),A0
    MOVE.L  A0,-12(A5)

LAB_1613:
    MOVEQ   #0,D0
    MOVEA.L -12(A5),A0
    MOVE.B  (A0),D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #3,(A0)
    BNE.S   LAB_1614

    MOVEQ   #24,D1
    CMP.B   D1,D0
    BEQ.S   LAB_1614

    MOVEQ   #25,D1
    CMP.B   D1,D0
    BNE.S   LAB_1615

LAB_1614:
    ADDQ.L  #1,-12(A5)
    BRA.S   LAB_1613

LAB_1615:
    MOVEA.L -12(A5),A0
    TST.B   (A0)
    BEQ.S   LAB_1617

    LEA     LAB_213E,A1
    MOVEA.L -8(A5),A2

LAB_1616:
    MOVE.B  (A1)+,(A2)+
    BNE.S   LAB_1616

    MOVE.L  -12(A5),-(A7)
    MOVE.L  -8(A5),-(A7)
    JSR     UNKNOWN6_AppendDataAtNull(PC)

    ADDQ.W  #8,A7

LAB_1617:
    MOVE.W  218(A3),D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -532(A5),A0
    MOVE.L  56(A0,D0.L),-(A7)
    BSR.W   LAB_160D

    ADDQ.W  #4,A7
    MOVE.L  D0,-12(A5)
    BEQ.W   LAB_1623

    MOVEA.L D0,A0
    TST.B   (A0)
    BEQ.W   LAB_1623

    MOVEA.L -4(A5),A0

LAB_1618:
    TST.B   (A0)+
    BNE.S   LAB_1618

    SUBQ.L  #1,A0
    SUBA.L  -4(A5),A0
    MOVE.L  A0,D7
    MOVEA.L D0,A0

LAB_1619:
    TST.B   (A0)+
    BNE.S   LAB_1619

    SUBQ.L  #1,A0
    SUBA.L  D0,A0
    CMPA.L  D7,A0
    BLT.S   LAB_161A

    ADD.L   D7,-12(A5)

LAB_161A:
    MOVEQ   #0,D0
    MOVEA.L -12(A5),A0
    MOVE.B  (A0),D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   LAB_161B

    ADDQ.L  #1,-12(A5)
    BRA.S   LAB_161A

LAB_161B:
    MOVE.L  -12(A5),-(A7)
    PEA     LAB_213F
    PEA     -524(A5)
    JSR     WDISP_SPrintf(PC)

    PEA     LAB_2140
    PEA     -524(A5)
    JSR     GROUPD_JMPTBL_ESQ_FindSubstringCaseFold(PC)

    LEA     20(A7),A7
    MOVE.L  D0,-12(A5)
    TST.L   D0
    BNE.S   LAB_161C

    PEA     LAB_2141
    PEA     -524(A5)
    JSR     GROUPD_JMPTBL_ESQ_FindSubstringCaseFold(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-12(A5)

LAB_161C:
    TST.L   D0
    BNE.S   LAB_161D

    PEA     LAB_2142
    PEA     -524(A5)
    JSR     GROUPD_JMPTBL_ESQ_FindSubstringCaseFold(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-12(A5)

LAB_161D:
    TST.L   D0
    BEQ.S   LAB_161F

    MOVEA.L D0,A0
    MOVE.B  #$18,(A0)

LAB_161E:
    ADDQ.L  #1,-12(A5)
    MOVEQ   #0,D0
    MOVEA.L -12(A5),A0
    MOVE.B  (A0),D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #3,(A0)
    BEQ.S   LAB_161E

    MOVEA.L -12(A5),A0
    MOVE.B  #$18,(A0)
    BRA.S   LAB_1620

LAB_161F:
    LEA     -524(A5),A0
    MOVE.L  A0,-12(A5)

LAB_1620:
    PEA     40.W
    MOVE.L  A0,-(A7)
    JSR     LAB_1979(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-12(A5)
    BEQ.S   LAB_1622

LAB_1621:
    MOVEA.L -12(A5),A0
    CLR.B   (A0)
    SUBQ.L  #1,-12(A5)
    MOVEQ   #0,D0
    MOVEA.L -12(A5),A0
    MOVE.B  (A0),D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #3,(A0)
    BNE.S   LAB_1621

LAB_1622:
    PEA     -524(A5)
    MOVE.L  -8(A5),-(A7)
    JSR     UNKNOWN6_AppendDataAtNull(PC)

    ADDQ.W  #8,A7

LAB_1623:
    MOVE.W  218(A3),D0
    EXT.L   D0
    MOVE.L  -532(A5),-(A7)
    MOVE.L  D0,-(A7)
    PEA     -524(A5)
    JSR     LAB_16F7(PC)

    LEA     12(A7),A7
    LEA     -524(A5),A0
    MOVE.L  A0,-12(A5)

LAB_1624:
    MOVEQ   #0,D0
    MOVEA.L -12(A5),A0
    MOVE.B  (A0),D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #3,(A0)
    BEQ.S   LAB_1625

    ADDQ.L  #1,-12(A5)
    BRA.S   LAB_1624

LAB_1625:
    MOVEA.L -12(A5),A0
    TST.B   (A0)
    BEQ.S   LAB_1626

    PEA     LAB_2143
    MOVE.L  -8(A5),-(A7)
    JSR     UNKNOWN6_AppendDataAtNull(PC)

    MOVE.L  -12(A5),(A7)
    MOVE.L  -8(A5),-(A7)
    JSR     UNKNOWN6_AppendDataAtNull(PC)

    LEA     12(A7),A7

LAB_1626:
    MOVEQ   #0,D6
    MOVE.L  D6,D7

LAB_1627:
    MOVEA.L -528(A5),A0
    TST.B   1(A0,D7.L)
    BEQ.S   LAB_1629

    MOVEQ   #32,D0
    CMP.B   1(A0,D7.L),D0
    BEQ.S   LAB_1628

    LEA     -524(A5),A1
    ADDA.L  D6,A1
    ADDQ.L  #1,D6
    MOVE.B  1(A0,D7.L),(A1)

LAB_1628:
    ADDQ.L  #1,D7
    BRA.S   LAB_1627

LAB_1629:
    LEA     -524(A5),A0
    ADDA.L  D6,A0
    MOVEQ   #0,D0
    MOVE.B  D0,(A0)
    MOVE.B  -524(A5),D1
    TST.B   D1
    BEQ.S   LAB_162A

    PEA     GLOB_STR_ALIGNED_CHANNEL_2
    MOVE.L  -8(A5),-(A7)
    JSR     UNKNOWN6_AppendDataAtNull(PC)

    PEA     -524(A5)
    MOVE.L  -8(A5),-(A7)
    JSR     UNKNOWN6_AppendDataAtNull(PC)

    LEA     16(A7),A7

LAB_162A:
    PEA     284.W
    MOVE.L  -8(A5),-(A7)
    JSR     LAB_1755(PC)

    ADDQ.W  #8,A7

LAB_162B:
    MOVEM.L (A7)+,D6-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_162C:
    LINK.W  A5,#-36
    MOVEM.L D2/D5-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.B  15(A5),D7
    CLR.L   -20(A5)
    MOVE.L  A3,D0
    BNE.S   LAB_162D

    MOVEQ   #0,D7
    BRA.S   LAB_162F

LAB_162D:
    MOVE.L  A3,-30(A5)
    LEA     10(A3),A0
    MOVE.L  A0,-34(A5)
    MOVEA.L -30(A5),A1
    TST.B   (A1)
    BEQ.S   LAB_162E

    TST.B   (A0)
    BNE.S   LAB_162F

LAB_162E:
    MOVEQ   #0,D7

LAB_162F:
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    TST.W   D0
    BEQ.W   LAB_164A

    SUBI.W  #$46,D0
    BEQ.S   LAB_1630

    SUBI.W  #18,D0
    BEQ.S   LAB_1633

    BRA.W   LAB_164A

LAB_1630:
    CLR.W   LAB_2359
    MOVE.B  #$1,LAB_2145
    MOVE.L  -30(A5),-(A7)
    PEA     LAB_2146
    JSR     LAB_1902(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BEQ.S   LAB_1631

    MOVE.L  -30(A5),-(A7)
    PEA     LAB_2147
    JSR     LAB_1902(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BEQ.S   LAB_1631

    MOVEQ   #0,D0
    BRA.S   LAB_1632

LAB_1631:
    MOVEQ   #1,D0

LAB_1632:
    MOVE.L  -30(A5),-(A7)
    PEA     LAB_2148
    MOVE.W  D0,LAB_235B
    JSR     LAB_1902(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    SEQ     D1
    NEG.B   D1
    EXT.W   D1
    EXT.L   D1
    MOVE.W  D1,LAB_235C

LAB_1633:
    TST.L   -20(A5)
    BNE.W   LAB_164B

    MOVE.B  LAB_2145,D0
    MOVEQ   #3,D1
    CMP.B   D1,D0
    BEQ.W   LAB_164B

    TST.W   LAB_2359
    BNE.W   LAB_163D

    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   LAB_15F5

    ADDQ.W  #4,A7
    MOVEQ   #0,D5
    MOVE.W  D0,D5
    MOVEQ   #0,D6
    MOVE.L  D6,D0
    MOVE.W  D0,LAB_235A

LAB_1634:
    CMP.L   D5,D6
    BGE.W   LAB_1639

    MOVE.B  LAB_2145,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  D6,-(A7)
    JSR     GROUPD_JMPTBL_LAB_0923(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    MOVEA.L D0,A0
    BTST    #3,27(A0)
    BNE.S   LAB_1638

    TST.W   LAB_235B
    BEQ.S   LAB_1635

    BTST    #4,27(A0)
    BNE.S   LAB_1637

LAB_1635:
    TST.W   LAB_235C
    BEQ.S   LAB_1636

    MOVE.L  D0,-(A7)
    BSR.W   LAB_15F1

    ADDQ.W  #4,A7
    TST.L   D0
    BNE.S   LAB_1637

LAB_1636:
    MOVEA.L -8(A5),A0
    ADDA.W  #12,A0
    MOVE.L  -30(A5),-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_1902(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   LAB_1638

LAB_1637:
    MOVE.W  LAB_235A,D0
    ADDQ.W  #1,LAB_235A
    LEA     LAB_2371,A0
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ADDA.L  D1,A0
    MOVE.L  D6,D0
    MOVE.B  D0,(A0)

LAB_1638:
    ADDQ.L  #1,D6
    BRA.W   LAB_1634

LAB_1639:
    CMPI.W  #0,LAB_235A
    BLS.S   LAB_163C

    CLR.W   LAB_2358
    MOVEQ   #1,D0
    CMP.B   LAB_2145,D0
    BNE.S   LAB_163A

    MOVEQ   #0,D0
    MOVE.W  LAB_2270,D0
    BRA.S   LAB_163B

LAB_163A:
    MOVEQ   #1,D0

LAB_163B:
    MOVE.W  D0,LAB_2359
    BRA.S   LAB_163D

LAB_163C:
    MOVE.W  #$31,LAB_2359

LAB_163D:
    TST.L   -20(A5)
    BNE.W   LAB_1647

    CMPI.W  #$31,LAB_2359
    BCC.W   LAB_1647

LAB_163E:
    TST.L   -20(A5)
    BNE.W   LAB_1646

    MOVE.W  LAB_2358,D0
    CMP.W   LAB_235A,D0
    BCC.W   LAB_1646

    LEA     LAB_2371,A0
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ADDA.L  D1,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.B  LAB_2145,D1
    EXT.W   D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     GROUPD_JMPTBL_LAB_0926(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.W   LAB_1645

    MOVEQ   #1,D1
    CMP.B   LAB_2145,D1
    BNE.W   LAB_1641

    MOVE.W  LAB_2270,D1
    MOVE.W  LAB_2359,D2
    CMP.W   D2,D1
    BNE.W   LAB_1641

    MOVEQ   #0,D1
    MOVE.W  D2,D1
    ASL.L   #2,D1
    MOVEA.L D0,A0
    MOVE.L  56(A0,D1.L),-26(A5)
    MOVE.W  D2,-22(A5)

LAB_163F:
    MOVE.W  -22(A5),D0
    TST.W   D0
    BLE.S   LAB_1640

    TST.L   -26(A5)
    BNE.S   LAB_1640

    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    MOVEA.L -4(A5),A0
    MOVE.L  56(A0,D1.L),-26(A5)
    SUBQ.W  #1,-22(A5)
    BRA.S   LAB_163F

LAB_1640:
    TST.L   -26(A5)
    BEQ.S   LAB_1642

    LEA     LAB_2371,A0
    MOVEQ   #0,D0
    MOVE.W  LAB_2358,D0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.B  LAB_2145,D1
    EXT.W   D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     GROUPD_JMPTBL_LAB_0923(PC)

    MOVE.W  -22(A5),D1
    EXT.L   D1
    MOVE.L  LAB_1BBD,(A7)
    PEA     1440.W
    MOVE.L  D1,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-8(A5)
    JSR     GROUPD_JMPTBL_LAB_036C(PC)

    LEA     24(A7),A7
    TST.L   D0
    BNE.S   LAB_1642

    CLR.L   -26(A5)
    BRA.S   LAB_1642

LAB_1641:
    MOVE.W  LAB_2359,D0
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    MOVEA.L -4(A5),A0
    MOVEA.L 56(A0,D1.L),A0
    MOVE.W  D0,-22(A5)
    MOVE.L  A0,-26(A5)

LAB_1642:
    TST.L   -26(A5)
    BEQ.W   LAB_1645

    MOVE.L  -26(A5),-(A7)
    BSR.W   LAB_160D

    ADDQ.W  #4,A7
    MOVE.L  D0,-26(A5)
    TST.W   LAB_235C
    BEQ.S   LAB_1643

    MOVE.W  -22(A5),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     LAB_1679(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.W   LAB_1645

LAB_1643:
    MOVEA.L -34(A5),A0

LAB_1644:
    TST.B   (A0)+
    BNE.S   LAB_1644

    SUBQ.L  #1,A0
    SUBA.L  -34(A5),A0
    MOVE.L  A0,-(A7)
    MOVE.L  -26(A5),-(A7)
    MOVE.L  -34(A5),-(A7)
    JSR     LAB_194E(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.W   LAB_1645

    LEA     LAB_2371,A0
    MOVEQ   #0,D0
    MOVE.W  LAB_2358,D0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.B  LAB_2145,D1
    EXT.W   D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     GROUPD_JMPTBL_LAB_0923(PC)

    MOVEA.L D0,A0
    LEA     28(A0),A1
    MOVE.W  -22(A5),D1
    EXT.L   D1
    MOVE.L  D1,(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  D0,-8(A5)
    JSR     GROUPD_JMPTBL_ESQ_TestBit1Based(PC)

    LEA     12(A7),A7
    ADDQ.L  #1,D0
    BNE.S   LAB_1645

    MOVEQ   #1,D0
    MOVE.L  D0,-20(A5)
    MOVE.B  LAB_2145,D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_2371,A0
    MOVEQ   #0,D1
    MOVE.W  LAB_2358,D1
    ADDA.L  D1,A0
    MOVEQ   #0,D1
    MOVE.B  (A0),D1
    MOVE.W  -22(A5),D2
    EXT.L   D2
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1603

    MOVE.L  A3,(A7)
    BSR.W   LAB_1610

    LEA     16(A7),A7

LAB_1645:
    ADDQ.W  #1,LAB_2358
    BRA.W   LAB_163E

LAB_1646:
    TST.L   -20(A5)
    BNE.W   LAB_163D

    ADDQ.W  #1,LAB_2359
    CLR.W   LAB_2358
    BRA.W   LAB_163D

LAB_1647:
    CMPI.W  #$30,LAB_2359
    BLS.W   LAB_1633

    CLR.W   LAB_2359
    MOVE.B  LAB_2145,D0
    EXT.W   D0
    SUBQ.W  #1,D0
    BEQ.S   LAB_1648

    SUBQ.W  #1,D0
    BEQ.S   LAB_1649

    BRA.S   LAB_1649

LAB_1648:
    MOVE.B  #$2,LAB_2145
    BRA.W   LAB_1633

LAB_1649:
    MOVE.B  #$3,LAB_2145
    BRA.W   LAB_1633

LAB_164A:
    MOVE.B  #$3,LAB_2145

LAB_164B:
    TST.L   -20(A5)
    BNE.S   LAB_164C

    MOVE.L  A3,-(A7)
    BSR.W   LAB_15FA

    ADDQ.W  #4,A7

LAB_164C:
    MOVE.L  -20(A5),D0
    MOVEM.L (A7)+,D2/D5-D7/A3
    UNLK    A5
    RTS

;!======

LAB_164D:
    LINK.W  A5,#-32
    MOVEM.L D2-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  A3,D0
    BEQ.W   LAB_1655

    TST.B   220(A3)
    BEQ.W   LAB_1655

    CLR.L   -(A7)
    PEA     8.W
    JSR     LAB_183C(PC)

    PEA     3.W
    CLR.L   -(A7)
    PEA     8.W
    JSR     LAB_183E(PC)

    MOVE.L  D0,LAB_2216
    JSR     GROUP_BA_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D0
    MOVEA.L LAB_2216,A0
    MOVE.W  4(A0),D0
    MOVEQ   #-22,D1
    ADD.L   LAB_2362,D1
    MOVE.W  (A0),D2
    MOVE.L  D0,-22(A5)
    MOVE.L  D1,-26(A5)
    BTST    #2,D2
    BEQ.S   LAB_164E

    MOVEQ   #2,D0
    BRA.S   LAB_164F

LAB_164E:
    MOVEQ   #1,D0

LAB_164F:
    JSR     LAB_1A06(PC)

    MOVE.L  D0,-26(A5)
    MOVE.L  -22(A5),D1
    CMP.L   D0,D1
    BLT.S   LAB_1650

    MOVE.L  D0,D1

LAB_1650:
    MOVEQ   #0,D0
    MOVE.W  2(A0),D0
    MOVE.W  #1,LAB_22AA
    CLR.W   LAB_22AB
    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVE.L  D0,-18(A5)
    MOVE.L  D1,-22(A5)
    MOVE.L  A0,-4(A5)
    JSR     GROUPD_JMPTBL_LAB_0A49(PC)

    JSR     GROUPD_JMPTBL_LAB_0A45(PC)

    MOVE.B  LAB_1BC7,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   LAB_1653

    MOVEA.L LAB_2216,A0
    MOVE.W  (A0),D0
    BTST    #2,D0
    BEQ.S   LAB_1651

    MOVEQ   #2,D0
    BRA.S   LAB_1652

LAB_1651:
    MOVEQ   #1,D0

LAB_1652:
    MOVE.L  D0,28(A7)
    MOVE.L  -22(A5),D0
    MOVE.L  28(A7),D1
    JSR     LAB_1A07(PC)

    MOVE.L  D0,D7
    ADDI.W  #22,D7
    MOVE.L  D7,D0
    EXT.L   D0
    PEA     500.W
    MOVE.L  D0,-(A7)
    JSR     SCRIPT_BeginBannerCharTransition(PC)

    ADDQ.W  #8,A7

LAB_1653:
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    PEA     3.W
    JSR     LAB_183E(PC)

    LEA     12(A7),A7
    MOVE.L  D0,LAB_2216
    MOVE.L  #$fffffee4,D0
    ADD.L   -18(A5),D0
    TST.L   D0
    BPL.S   LAB_1654

    ADDQ.L  #1,D0

LAB_1654:
    ASR.L   #1,D0
    MOVE.L  D0,D6
    MOVEQ   #0,D4
    MOVE.L  D6,D5
    ADDI.W  #$11b,D5
    MOVE.L  -22(A5),D0
    SUBQ.L  #1,D0
    MOVE.W  D0,-14(A5)
    MOVEA.L -4(A5),A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVE.W  #1,LAB_236C
    LEA     220(A3),A0
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D4,D1
    EXT.L   D1
    MOVE.L  D5,D2
    EXT.L   D2
    MOVE.W  -14(A5),D3
    EXT.L   D3
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     LAB_1789(PC)

    PEA     3.W
    CLR.L   -(A7)
    PEA     8.W
    JSR     LAB_183E(PC)

    MOVE.L  D0,LAB_2216
    JSR     LAB_167A(PC)

    MOVE.L  A3,(A7)
    BSR.W   LAB_15FA

    LEA     36(A7),A7

LAB_1655:
    MOVEM.L (A7)+,D2-D7/A3
    UNLK    A5
    RTS

;!======

LAB_1656:
    LINK.W  A5,#-208
    MOVEM.L D2/D4-D7/A3,-(A7)
    MOVE.B  11(A5),D7
    MOVE.B  15(A5),D6
    MOVEA.L 16(A5),A3
    MOVEQ   #1,D5
    MOVEQ   #1,D4
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    ADDQ.W  #1,D0
    BEQ.W   LAB_1661

    SUBI.W  #$43,D0
    BEQ.S   LAB_1657

    SUBQ.W  #7,D0
    BEQ.W   LAB_165C

    SUBI.W  #10,D0
    BEQ.W   LAB_165D

    BRA.W   LAB_1661

LAB_1657:
    MOVE.L  A3,-(A7)
    PEA     LAB_214C
    PEA     -200(A5)
    JSR     WDISP_SPrintf(PC)

    MOVE.W  LAB_234D,D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    PEA     LAB_234B
    MOVE.L  A3,-(A7)
    JSR     LAB_1704(PC)

    LEA     20(A7),A7
    SUBQ.W  #1,D0
    BNE.S   LAB_1658

    MOVE.W  LAB_2153,LAB_235D
    MOVE.W  LAB_2364,LAB_2149
    BSR.W   LAB_15A3

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.W  D1,LAB_214A
    BRA.S   LAB_165B

LAB_1658:
    MOVE.W  LAB_2360,D0
    ADDQ.W  #1,D0
    BEQ.S   LAB_1659

    MOVE.W  #1,LAB_235D
    MOVE.W  LAB_2360,LAB_2149
    MOVEQ   #-1,D0
    MOVE.W  D0,LAB_214A
    BRA.S   LAB_165B

LAB_1659:
    MOVE.W  LAB_2361,D0
    ADDQ.W  #1,D0
    BEQ.S   LAB_165A

    CLR.W   LAB_235D
    MOVE.W  LAB_2361,LAB_2149
    MOVEQ   #-1,D0
    MOVE.W  D0,LAB_214A
    BRA.S   LAB_165B

LAB_165A:
    MOVEQ   #-1,D0
    MOVE.W  D0,LAB_214A
    MOVE.W  D0,LAB_2149
    MOVE.W  D0,LAB_235D

LAB_165B:
    MOVE.W  LAB_235D,D0
    EXT.L   D0
    MOVE.W  LAB_2149,D1
    EXT.L   D1
    MOVE.W  LAB_214A,D2
    EXT.L   D2
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   LAB_15C5

    BSR.W   LAB_15A2

    LEA     12(A7),A7
    MOVEQ   #0,D5
    BRA.W   LAB_1661

LAB_165C:
    MOVE.W  LAB_235D,D0
    EXT.L   D0
    MOVE.W  LAB_2149,D1
    EXT.L   D1
    MOVE.W  LAB_214A,D2
    EXT.L   D2
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   LAB_15E4

    LEA     12(A7),A7
    MOVEQ   #0,D5
    BRA.W   LAB_1661

LAB_165D:
    MOVEQ   #70,D0
    CMP.B   D0,D7
    BNE.S   LAB_1660

    TST.L   LAB_214B
    BNE.S   LAB_165E

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     732.W
    PEA     1084.W
    PEA     GLOB_STR_TEXTDISP_C_1
    JSR     MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,LAB_214B

LAB_165E:
    PEA     LAB_234B
    MOVE.L  A3,-(A7)
    MOVE.L  LAB_214B,-(A7)
    BSR.W   LAB_15FC

    PEA     70.W
    MOVE.L  LAB_214B,-(A7)
    BSR.W   LAB_162C

    LEA     20(A7),A7
    TST.L   D0
    BNE.S   LAB_1660

    TST.L   LAB_214B
    BEQ.S   LAB_1660

    MOVEA.L LAB_214B,A0
    ADDA.W  #$dc,A0
    LEA     LAB_214E,A1

LAB_165F:
    MOVE.B  (A1)+,(A0)+
    BNE.S   LAB_165F

LAB_1660:
    MOVE.L  LAB_214B,-(A7)
    BSR.W   LAB_164D

    PEA     88.W
    MOVE.L  LAB_214B,-(A7)
    BSR.W   LAB_162C

    LEA     12(A7),A7
    MOVEQ   #0,D4

LAB_1661:
    TST.L   D5
    BEQ.S   LAB_1662

    MOVE.W  #(-1),LAB_2149
    MOVE.W  #$31,LAB_214A

LAB_1662:
    TST.L   D4
    BEQ.S   LAB_1663

    CLR.L   -(A7)
    CLR.L   -(A7)
    BSR.W   LAB_162C

    ADDQ.W  #8,A7
    TST.L   LAB_214B
    BEQ.S   LAB_1663

    PEA     732.W
    MOVE.L  LAB_214B,-(A7)
    PEA     1106.W
    PEA     GLOB_STR_TEXTDISP_C_2
    JSR     MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    CLR.L   LAB_214B

LAB_1663:
    MOVEM.L (A7)+,D2/D4-D7/A3
    UNLK    A5
    RTS

;!======

LAB_1664:
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D7

LAB_1665:
    CMPI.L  #$12e,D7
    BGE.S   LAB_1666

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_235E,A0
    ADDA.L  D0,A0
    CLR.L   (A0)
    ADDQ.L  #1,D7
    BRA.S   LAB_1665

LAB_1666:
    CLR.L   LAB_235F
    CLR.B   LAB_2131
    PEA     GLOB_STR_DF0_SOURCECFG_INI_2
    JSR     PARSEINI_ParseConfigBuffer(PC)

    ADDQ.W  #4,A7
    MOVE.L  (A7)+,D7
    RTS

;!======

LAB_1667:
    LINK.W  A5,#-8
    MOVEM.L D7/A2,-(A7)
    MOVEQ   #0,D7

LAB_1668:
    CMP.L   LAB_235F,D7
    BGE.S   LAB_166A

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_235E,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    TST.L   (A1)
    BEQ.S   LAB_1669

    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A2
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  (A1),-(A7)
    CLR.L   -(A7)
    MOVE.L  A2,20(A7)
    JSR     LAB_1905(PC)

    MOVEA.L 20(A7),A0
    MOVE.L  D0,(A0)
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_235E,A0
    ADDA.L  D0,A0
    PEA     6.W
    MOVE.L  (A0),-(A7)
    PEA     1153.W
    PEA     GLOB_STR_TEXTDISP_C_3
    JSR     MEMORY_DeallocateMemory(PC)

    LEA     24(A7),A7
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_235E,A0
    ADDA.L  D0,A0
    CLR.L   (A0)

LAB_1669:
    ADDQ.L  #1,D7
    BRA.S   LAB_1668

LAB_166A:
    CLR.L   LAB_235F
    CLR.B   LAB_2131
    MOVEM.L (A7)+,D7/A2
    UNLK    A5
    RTS

;!======

LAB_166B:
    MOVEM.L D7/A2-A3/A6,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.L  A3,D0
    BEQ.S   LAB_166F

    MOVE.B  LAB_2131,D0
    NOT.B   D0
    AND.B   D0,40(A3)
    MOVEQ   #0,D7

LAB_166C:
    CMP.L   LAB_235F,D7
    BGE.S   LAB_166F

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_235E,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A2
    LEA     12(A3),A1
    ADDA.L  D0,A0
    MOVEA.L (A0),A6
    MOVEA.L (A6),A0

LAB_166D:
    TST.B   (A0)+
    BNE.S   LAB_166D

    SUBQ.L  #1,A0
    SUBA.L  (A6),A0
    MOVE.L  A0,-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  (A2),-(A7)
    JSR     LAB_194E(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   LAB_166E

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_235E,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.B  4(A1),D0
    OR.B    D0,40(A3)

LAB_166E:
    ADDQ.L  #1,D7
    BRA.S   LAB_166C

LAB_166F:
    MOVEM.L (A7)+,D7/A2-A3/A6
    RTS

;!======

LAB_1670:
    LINK.W  A5,#-8
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D7

LAB_1671:
    MOVEQ   #0,D0
    MOVE.W  LAB_2231,D0
    CMP.L   D0,D7
    BGE.S   LAB_1672

    PEA     1.W
    MOVE.L  D7,-(A7)
    JSR     GROUPD_JMPTBL_LAB_0923(PC)

    MOVE.L  D0,(A7)
    MOVE.L  D0,-8(A5)
    BSR.W   LAB_166B

    ADDQ.W  #8,A7
    ADDQ.L  #1,D7
    BRA.S   LAB_1671

LAB_1672:
    MOVEQ   #0,D7

LAB_1673:
    MOVEQ   #0,D0
    MOVE.W  LAB_222F,D0
    CMP.L   D0,D7
    BGE.S   LAB_1674

    PEA     2.W
    MOVE.L  D7,-(A7)
    JSR     GROUPD_JMPTBL_LAB_0923(PC)

    MOVE.L  D0,(A7)
    MOVE.L  D0,-8(A5)
    BSR.W   LAB_166B

    ADDQ.W  #8,A7
    ADDQ.L  #1,D7
    BRA.S   LAB_1673

LAB_1674:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======

LAB_1675:
    LINK.W  A5,#-8
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  LAB_235F,D0
    ASL.L   #2,D0
    LEA     LAB_235E,A0
    ADDA.L  D0,A0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     6.W
    PEA     1229.W
    PEA     GLOB_STR_TEXTDISP_C_4
    MOVE.L  A0,24(A7)
    JSR     MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L 8(A7),A0
    MOVE.L  D0,(A0)
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.S   LAB_1677

    ADDQ.L  #1,LAB_235F
    MOVEA.L D0,A0
    MOVE.L  (A0),-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_1905(PC)

    MOVEA.L -4(A5),A0
    MOVE.L  D0,(A0)
    MOVE.L  LAB_2133,(A7)
    MOVE.L  A2,-(A7)
    JSR     LAB_1968(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   LAB_1676

    MOVEQ   #8,D0
    MOVEA.L -4(A5),A0
    MOVE.B  D0,4(A0)

LAB_1676:
    MOVE.B  LAB_2131,D0
    MOVEA.L -4(A5),A0
    OR.B    4(A0),D0
    MOVE.B  D0,LAB_2131

LAB_1677:
    MOVEM.L (A7)+,A2-A3
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

LAB_1678:
    JMP     LAB_0FF5

LAB_1679:
    JMP     LAB_091A

LAB_167A:
    JMP     LAB_0A48

GROUP_BA_JMPTBL_CLEANUP_BuildAlignedStatusLine:
    JMP     CLEANUP_BuildAlignedStatusLine

GROUP_BA_JMPTBL_CLEANUP_DrawInsetRectFrame:
    JMP     CLEANUP_DrawInsetRectFrame

;!======

    ; Alignment
    MOVEQ   #97,D0
