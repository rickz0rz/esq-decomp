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
    JSR     LAB_17CA(PC)

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
    JSR     LAB_17CC(PC)

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
    JSR     LAB_17CD(PC)

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
    JSR     APPEND_DATA_AT_NULL(PC)

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
    JSR     APPEND_DATA_AT_NULL(PC)

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
    JSR     APPEND_DATA_AT_NULL(PC)

    ADDQ.W  #8,A7

LAB_15DC:
    PEA     LAB_2137
    PEA     -137(A5)
    JSR     APPEND_DATA_AT_NULL(PC)

    PEA     -188(A5)
    PEA     -137(A5)
    JSR     APPEND_DATA_AT_NULL(PC)

    LEA     16(A7),A7

LAB_15DD:
    TST.L   -196(A5)
    BEQ.S   LAB_15DF

    MOVE.B  -137(A5),D0
    TST.B   D0
    BEQ.S   LAB_15DE

    PEA     LAB_2138
    PEA     -137(A5)
    JSR     APPEND_DATA_AT_NULL(PC)

    ADDQ.W  #8,A7

LAB_15DE:
    MOVEQ   #0,D0
    MOVEA.L -196(A5),A0
    MOVE.B  (A0),D0
    MOVE.L  D0,-(A7)
    PEA     LAB_2139
    PEA     -188(A5)
    JSR     PRINTF(PC)

    PEA     -188(A5)
    PEA     -137(A5)
    JSR     APPEND_DATA_AT_NULL(PC)

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
    JSR     LAB_167B(PC)

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
    JSR     APPEND_DATA_AT_NULL(PC)

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
    JSR     LAB_17CA(PC)

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
    JSR     LAB_17CC(PC)

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
    JSR     LAB_17CD(PC)

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
    JSR     LAB_17C9(PC)

    MOVE.L  D5,D1
    EXT.L   D1
    PEA     3.W
    MOVE.L  D1,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  D0,-142(A5)
    JSR     LAB_17C9(PC)

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
    JSR     APPEND_DATA_AT_NULL(PC)

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
    JSR     APPEND_DATA_AT_NULL(PC)

    ADDQ.W  #8,A7

LAB_15EE:
    PEA     LAB_213D
    PEA     -137(A5)
    JSR     APPEND_DATA_AT_NULL(PC)

    MOVE.L  -146(A5),(A7)
    PEA     -137(A5)
    JSR     APPEND_DATA_AT_NULL(PC)

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
    JSR     LAB_167B(PC)

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
    JSR     LAB_17CA(PC)

    MOVE.L  210(A3),(A7)
    MOVE.L  214(A3),-(A7)
    MOVE.L  D0,-532(A5)
    JSR     LAB_17CC(PC)

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
    JSR     APPEND_DATA_AT_NULL(PC)

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
    JSR     PRINTF(PC)

    PEA     LAB_2140
    PEA     -524(A5)
    JSR     LAB_17D0(PC)

    LEA     20(A7),A7
    MOVE.L  D0,-12(A5)
    TST.L   D0
    BNE.S   LAB_161C

    PEA     LAB_2141
    PEA     -524(A5)
    JSR     LAB_17D0(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-12(A5)

LAB_161C:
    TST.L   D0
    BNE.S   LAB_161D

    PEA     LAB_2142
    PEA     -524(A5)
    JSR     LAB_17D0(PC)

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
    JSR     APPEND_DATA_AT_NULL(PC)

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
    JSR     APPEND_DATA_AT_NULL(PC)

    MOVE.L  -12(A5),(A7)
    MOVE.L  -8(A5),-(A7)
    JSR     APPEND_DATA_AT_NULL(PC)

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
    JSR     APPEND_DATA_AT_NULL(PC)

    PEA     -524(A5)
    MOVE.L  -8(A5),-(A7)
    JSR     APPEND_DATA_AT_NULL(PC)

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
    JSR     LAB_17CC(PC)

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
    JSR     LAB_17CA(PC)

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
    JSR     LAB_17CC(PC)

    MOVE.W  -22(A5),D1
    EXT.L   D1
    MOVE.L  LAB_1BBD,(A7)
    PEA     1440.W
    MOVE.L  D1,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-8(A5)
    JSR     LAB_17CD(PC)

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
    JSR     LAB_17CC(PC)

    MOVEA.L D0,A0
    LEA     28(A0),A1
    MOVE.W  -22(A5),D1
    EXT.L   D1
    MOVE.L  D1,(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  D0,-8(A5)
    JSR     LAB_180A(PC)

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
    JSR     LAB_18D2(PC)

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
    JSR     LAB_18CE(PC)

    JSR     LAB_18CA(PC)

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
    JSR     PRINTF(PC)

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
    JSR     ALLOCATE_MEMORY(PC)

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
    JSR     DEALLOCATE_MEMORY(PC)

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
    JSR     PARSE_INI(PC)

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
    JSR     DEALLOCATE_MEMORY(PC)

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
    JSR     LAB_17CC(PC)

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
    JSR     LAB_17CC(PC)

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
    JSR     ALLOCATE_MEMORY(PC)

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

TEXTDISP_JMP_TBL_CLEANUP_BuildAlignedStatusLine:
LAB_167B:
    JMP     CLEANUP_BuildAlignedStatusLine

TEXTDISP_JMP_TBL_CLEANUP_DrawInsetRectFrame:
LAB_167C:
    JMP     CLEANUP_DrawInsetRectFrame

;!======

    ; Alignment
    MOVEQ   #97,D0

;!======

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
    JSR     LAB_18CE(PC)

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
    JSR     LAB_18CA(PC)

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

;!======

LAB_1697:
    LINK.W  A5,#-12
    MOVEM.L D7/A2-A3,-(A7)
    MOVE.W  LAB_2364,LAB_236E
    MOVEQ   #0,D7

LAB_1698:
    MOVE.W  LAB_2231,D0
    CMP.W   D0,D7
    BGE.S   LAB_169A

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2236,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A3
    LEA     LAB_2233,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A2
    BTST    #3,27(A2)
    BNE.S   LAB_1699

    MOVE.L  8(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_1902(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   LAB_1699

    MOVE.W  D7,LAB_2364
    MOVEQ   #1,D0
    BRA.S   LAB_169B

LAB_1699:
    ADDQ.W  #1,D7
    BRA.S   LAB_1698

LAB_169A:
    MOVEQ   #0,D0

LAB_169B:
    MOVEM.L (A7)+,D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_169C:
    LINK.W  A5,#-24
    MOVEM.L D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    LEA     12(A3),A0
    LEA     -21(A5),A1

LAB_169D:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_169D

    MOVEQ   #0,D7

LAB_169E:
    MOVE.W  LAB_1DDA,D0
    CMP.W   D0,D7
    BGE.S   LAB_16A1

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_224F,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A2
    MOVEA.L (A2),A0

LAB_169F:
    TST.B   (A0)+
    BNE.S   LAB_169F

    SUBQ.L  #1,A0
    SUBA.L  (A2),A0
    MOVE.L  A0,-(A7)
    MOVE.L  (A2),-(A7)
    PEA     -21(A5)
    JSR     LAB_194E(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   LAB_16A0

    MOVE.L  D7,D0
    BRA.S   LAB_16A2

LAB_16A0:
    ADDQ.W  #1,D7
    BRA.S   LAB_169E

LAB_16A1:
    MOVEQ   #-1,D0

LAB_16A2:
    MOVEM.L (A7)+,D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_16A3:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3

LAB_16A4:
    TST.B   (A3)
    BEQ.S   LAB_16A7

    BTST    #7,(A3)
    BEQ.S   LAB_16A6

    MOVEQ   #0,D0
    MOVE.B  (A3),D0
    SUBI.W  #$84,D0
    BEQ.S   LAB_16A5

    SUBQ.W  #1,D0
    BEQ.S   LAB_16A5

    SUBQ.W  #1,D0
    BEQ.S   LAB_16A5

    SUBQ.W  #1,D0
    BEQ.S   LAB_16A5

    SUBQ.W  #5,D0
    BEQ.S   LAB_16A5

    SUBQ.W  #1,D0
    BEQ.S   LAB_16A5

    SUBQ.W  #2,D0
    BEQ.S   LAB_16A5

    SUBQ.W  #1,D0
    BEQ.S   LAB_16A5

    SUBQ.W  #3,D0
    BEQ.S   LAB_16A5

    SUBQ.W  #6,D0
    BEQ.S   LAB_16A5

    SUBQ.W  #1,D0
    BEQ.S   LAB_16A5

    SUBQ.W  #1,D0
    BEQ.S   LAB_16A5

    SUBQ.W  #8,D0
    BNE.S   LAB_16A6

LAB_16A5:
    MOVE.L  A3,D0
    BRA.S   LAB_16A8

LAB_16A6:
    ADDQ.L  #1,A3
    BRA.S   LAB_16A4

LAB_16A7:
    MOVEQ   #0,D0

LAB_16A8:
    MOVEA.L (A7)+,A3
    RTS

;!======

LAB_16A9:
    LINK.W  A5,#-12
    MOVEM.L D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    CLR.L   -8(A5)
    MOVEA.L 20(A5),A0
    CLR.L   (A0)
    PEA     34.W
    MOVE.L  A3,-(A7)
    JSR     LAB_1979(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.S   LAB_16AA

    MOVEA.L D0,A0
    ADDQ.L  #1,A0
    PEA     34.W
    MOVE.L  A0,-(A7)
    JSR     LAB_1979(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)

LAB_16AA:
    TST.L   -8(A5)
    BNE.S   LAB_16AF

    TST.L   -4(A5)
    BNE.S   LAB_16AB

    MOVEA.L A3,A0
    MOVE.L  A0,-4(A5)

LAB_16AB:
    MOVEQ   #40,D0
    MOVEA.L -4(A5),A0
    CMP.B   (A0),D0
    BNE.S   LAB_16AC

    ADDQ.L  #8,-4(A5)

LAB_16AC:
    MOVEA.L 16(A5),A0
    MOVE.L  A0,-8(A5)
    BEQ.S   LAB_16AD

    SUBQ.L  #1,-8(A5)
    BRA.S   LAB_16B0

LAB_16AD:
    MOVEA.L A3,A0

LAB_16AE:
    TST.B   (A0)+
    BNE.S   LAB_16AE

    SUBQ.L  #1,A0
    SUBA.L  A3,A0
    MOVE.L  A0,D0
    MOVEA.L A3,A1
    ADDA.L  D0,A1
    SUBQ.L  #1,A1
    MOVE.L  A1,-8(A5)
    BRA.S   LAB_16B0

LAB_16AF:
    MOVEQ   #1,D0
    MOVEA.L 20(A5),A0
    MOVE.L  D0,(A0)

LAB_16B0:
    MOVEA.L -4(A5),A0
    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   LAB_16B1

    ADDQ.L  #1,-4(A5)
    BRA.S   LAB_16B0

LAB_16B1:
    MOVEA.L -8(A5),A0
    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   LAB_16B2

    SUBQ.L  #1,-8(A5)
    BRA.S   LAB_16B1

LAB_16B2:
    MOVEA.L -4(A5),A0
    MOVE.L  A0,(A2)
    MOVE.L  -8(A5),D0
    SUB.L   -4(A5),D0
    MOVE.L  D0,D7
    ADDQ.L  #1,D7
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_16B3:
    LINK.W  A5,#-56
    MOVEM.L D5-D7/A2-A3,-(A7)
    MOVE.W  14(A5),D7
    MOVE.B  19(A5),D6
    MOVEQ   #0,D0
    SUBA.L  A0,A0
    MOVE.L  A0,-34(A5)
    MOVE.L  A0,-38(A5)
    MOVE.L  D0,-22(A5)
    MOVE.L  D0,-18(A5)
    MOVEA.L 8(A5),A0
    TST.B   (A0)
    BNE.S   LAB_16B4

    MOVEQ   #49,D0
    BRA.W   LAB_16CD

LAB_16B4:
    MOVE.W  LAB_2153,D0
    SUBQ.W  #1,D0
    BNE.S   LAB_16B5

    MOVEQ   #0,D0
    MOVE.W  LAB_2270,D0
    BRA.S   LAB_16B6

LAB_16B5:
    MOVEQ   #1,D0

LAB_16B6:
    MOVE.L  D0,D5
    MOVE.W  LAB_2153,D0
    SUBQ.W  #1,D0
    BNE.S   LAB_16B7

    MOVE.W  LAB_2364,D0
    EXT.L   D0
    PEA     1.W
    MOVE.L  D0,-(A7)
    JSR     LAB_17CA(PC)

    MOVEA.L D0,A3
    MOVE.W  LAB_2364,D0
    EXT.L   D0
    PEA     1.W
    MOVE.L  D0,-(A7)
    JSR     LAB_17CC(PC)

    LEA     16(A7),A7
    MOVEA.L D0,A2
    BRA.S   LAB_16B8

LAB_16B7:
    MOVE.W  LAB_2364,D0
    EXT.L   D0
    PEA     2.W
    MOVE.L  D0,-(A7)
    JSR     LAB_17CA(PC)

    MOVEA.L D0,A3
    MOVE.W  LAB_2364,D0
    EXT.L   D0
    PEA     2.W
    MOVE.L  D0,-(A7)
    JSR     LAB_17CC(PC)

    LEA     16(A7),A7
    MOVEA.L D0,A2

LAB_16B8:
    MOVEQ   #2,D0
    CMP.W   D0,D7
    BNE.S   LAB_16BB

    MOVE.W  LAB_2153,D0
    SUBQ.W  #1,D0
    BNE.S   LAB_16B9

    MOVEQ   #0,D0
    MOVE.W  LAB_2270,D0
    ADDQ.L  #1,D0
    BRA.S   LAB_16BA

LAB_16B9:
    MOVEQ   #1,D0

LAB_16BA:
    MOVE.L  D0,D5
    BRA.W   LAB_16C4

LAB_16BB:
    MOVEQ   #1,D0
    CMP.W   D0,D7
    BNE.S   LAB_16BF

    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  A2,-(A7)
    JSR     LAB_17D1(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D5
    TST.W   D5
    BEQ.S   LAB_16BC

    BTST    #7,7(A3,D5.W)
    BEQ.S   LAB_16C4

LAB_16BC:
    MOVE.W  LAB_2153,D0
    SUBQ.W  #1,D0
    BNE.S   LAB_16BD

    MOVEQ   #0,D0
    MOVE.W  LAB_2270,D0
    BRA.S   LAB_16BE

LAB_16BD:
    MOVEQ   #1,D0

LAB_16BE:
    MOVE.L  D0,D5
    BRA.S   LAB_16C4

LAB_16BF:
    MOVEQ   #3,D0
    CMP.W   D0,D7
    BNE.S   LAB_16C3

    MOVE.L  D5,D0
    EXT.L   D0
    SUBQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  A2,-(A7)
    JSR     LAB_17D1(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D5
    TST.W   D5
    BEQ.S   LAB_16C0

    BTST    #7,7(A3,D5.W)
    BEQ.S   LAB_16C4

LAB_16C0:
    MOVE.W  LAB_2153,D0
    SUBQ.W  #1,D0
    BNE.S   LAB_16C1

    MOVEQ   #0,D0
    MOVE.W  LAB_2270,D0
    BRA.S   LAB_16C2

LAB_16C1:
    MOVEQ   #1,D0

LAB_16C2:
    MOVE.L  D0,D5
    BRA.S   LAB_16C4

LAB_16C3:
    MOVEQ   #1,D5

LAB_16C4:
    MOVE.L  8(A5),-(A7)
    BSR.W   LAB_16A3

    PEA     -26(A5)
    MOVE.L  D0,-(A7)
    PEA     -34(A5)
    MOVE.L  8(A5),-(A7)
    MOVE.L  D0,-52(A5)
    BSR.W   LAB_16A9

    LEA     20(A7),A7
    MOVEA.L -34(A5),A0
    ADDA.L  D0,A0
    MOVE.B  (A0),D1
    CLR.B   (A0)
    MOVE.L  D0,-44(A5)
    MOVE.B  D1,-39(A5)

LAB_16C5:
    MOVEQ   #49,D0
    CMP.W   D0,D5
    BGE.W   LAB_16CC

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    TST.L   56(A3,D0.L)
    BEQ.W   LAB_16CB

    MOVE.B  7(A3,D5.W),D0
    AND.B   D6,D0
    CMP.B   D6,D0
    BNE.W   LAB_16CB

    LEA     28(A2),A0
    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_180A(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.W   LAB_16CB

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L 56(A3,D0.L),A0
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-14(A5)
    BSR.W   LAB_16A3

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.L  D0,-56(A5)
    MOVE.L  D1,-18(A5)
    MOVE.L  D1,-22(A5)
    TST.L   -52(A5)
    BNE.S   LAB_16C6

    MOVEQ   #1,D1
    MOVE.L  D1,-22(A5)
    BRA.S   LAB_16C7

LAB_16C6:
    TST.L   D0
    BEQ.S   LAB_16C7

    MOVEA.L -52(A5),A0
    MOVE.B  (A0),D1
    MOVEA.L D0,A0
    CMP.B   (A0),D1
    BNE.S   LAB_16C7

    MOVEQ   #1,D1
    MOVE.L  D1,-22(A5)

LAB_16C7:
    MOVEQ   #1,D1
    CMP.L   -22(A5),D1
    BNE.W   LAB_16CA

    PEA     -30(A5)
    MOVE.L  D0,-(A7)
    PEA     -38(A5)
    MOVE.L  -14(A5),-(A7)
    BSR.W   LAB_16A9

    LEA     16(A7),A7
    MOVEA.L -38(A5),A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.B  (A1),D1
    CLR.B   (A1)
    MOVE.L  D0,-48(A5)
    MOVE.B  D1,-40(A5)
    TST.L   -26(A5)
    BEQ.S   LAB_16C8

    TST.L   -30(A5)
    BEQ.S   LAB_16C9

    MOVE.L  -44(A5),D1
    CMP.L   D0,D1
    BNE.S   LAB_16C9

    MOVE.L  -38(A5),-(A7)
    MOVE.L  -34(A5),-(A7)
    JSR     LAB_1968(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    SEQ     D1
    NEG.B   D1
    EXT.W   D1
    EXT.L   D1
    MOVE.L  D1,-18(A5)
    BRA.S   LAB_16C9

LAB_16C8:
    MOVE.L  -44(A5),D1
    CMP.L   D0,D1
    BGT.S   LAB_16C9

    MOVE.L  -34(A5),-(A7)
    MOVE.L  -38(A5),-(A7)
    JSR     LAB_17D0(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    SNE     D1
    NEG.B   D1
    EXT.W   D1
    EXT.L   D1
    MOVE.L  D1,-18(A5)

LAB_16C9:
    MOVEA.L -38(A5),A0
    ADDA.L  -48(A5),A0
    MOVE.B  -40(A5),D0
    MOVE.B  D0,(A0)

LAB_16CA:
    TST.L   -18(A5)
    BEQ.S   LAB_16CB

    TST.L   -22(A5)
    BNE.S   LAB_16CC

LAB_16CB:
    ADDQ.W  #1,D5
    BRA.W   LAB_16C5

LAB_16CC:
    MOVEA.L -34(A5),A0
    ADDA.L  -44(A5),A0
    MOVE.B  -39(A5),D0
    MOVE.B  D0,(A0)
    MOVE.L  D5,D0

LAB_16CD:
    MOVEM.L (A7)+,D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_16CE:
    LINK.W  A5,#-8
    MOVEM.L D2-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVEQ   #0,D6
    MOVEA.L LAB_2216,A0
    MOVE.W  2(A0),D0
    MOVE.L  D0,D4
    SUBQ.W  #1,D4
    MOVEQ   #0,D5
    MOVE.W  4(A0),D0
    SUBQ.W  #1,D0
    MOVEM.W D0,-8(A5)
    MOVEQ   #2,D1
    CMP.W   D1,D7
    BNE.S   LAB_16D0

    MOVE.L  D4,D1
    TST.W   D1
    BPL.S   LAB_16CF

    ADDQ.W  #1,D1

LAB_16CF:
    ASR.W   #1,D1
    MOVE.L  D1,D6
    ADDQ.W  #1,D6

LAB_16D0:
    MOVEQ   #3,D1
    CMP.W   D1,D7
    BNE.S   LAB_16D1

    MOVE.L  D6,D1
    EXT.L   D1
    MOVE.L  D5,D2
    EXT.L   D2
    MOVE.L  D4,D3
    EXT.L   D3
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  GLOB_REF_RASTPORT_2,-(A7)
    BSR.W   LAB_1789

    LEA     24(A7),A7
    BRA.S   LAB_16D2

LAB_16D1:
    LEA     10(A0),A1
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  D4,D2
    EXT.L   D2
    MOVE.W  -8(A5),D3
    EXT.L   D3
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  A1,-(A7)
    BSR.W   LAB_1789

    LEA     24(A7),A7

LAB_16D2:
    MOVEM.L (A7)+,D2-D7/A3
    UNLK    A5
    RTS

;!======

LAB_16D3:
    LINK.W  A5,#-12
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    CLR.B   (A2)
    MOVE.L  A3,D0
    BEQ.S   LAB_16D8

    MOVE.L  A3,-(A7)
    BSR.W   LAB_169C

    ADDQ.W  #4,A7
    MOVE.L  D0,D7
    EXT.L   D7
    MOVEQ   #-1,D0
    CMP.L   D0,D7
    BEQ.S   LAB_16D5

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_224F,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    MOVEA.L -4(A5),A1
    MOVEA.L 4(A1),A0
    MOVEA.L A2,A1

LAB_16D4:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_16D4

    BRA.S   LAB_16D8

LAB_16D5:
    LEA     19(A3),A0
    MOVEA.L A0,A1

LAB_16D6:
    TST.B   (A1)+
    BNE.S   LAB_16D6

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D6
    MOVEQ   #8,D0
    CMP.L   D0,D6
    BGE.S   LAB_16D8

    TST.L   D6
    BEQ.S   LAB_16D8

    LEA     LAB_2157,A0
    MOVEA.L A2,A1

LAB_16D7:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_16D7

    LEA     19(A3),A0
    MOVE.L  A0,-(A7)
    MOVE.L  A2,-(A7)
    JSR     APPEND_DATA_AT_NULL(PC)

    ADDQ.W  #8,A7

LAB_16D8:
    MOVEM.L (A7)+,D6-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_16D9:
    LINK.W  A5,#-20
    MOVEM.L D6-D7/A3,-(A7)
    MOVE.W  10(A5),D7
    MOVE.W  LAB_2364,D0
    EXT.L   D0
    TST.W   LAB_2153
    BEQ.S   LAB_16DA

    MOVEQ   #1,D1
    BRA.S   LAB_16DB

LAB_16DA:
    MOVEQ   #2,D1

LAB_16DB:
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_17CC(PC)

    ADDQ.W  #8,A7
    MOVEA.L D0,A3
    MOVE.L  A3,D0
    BEQ.S   LAB_16DD

    LEA     1(A3),A0
    LEA     -17(A5),A1

LAB_16DC:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_16DC

    BRA.S   LAB_16DE

LAB_16DD:
    CLR.B   -17(A5)

LAB_16DE:
    LEA     -17(A5),A0
    MOVEA.L A0,A1

LAB_16DF:
    TST.B   (A1)+
    BNE.S   LAB_16DF

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D6
    CLR.L   LAB_237A
    MOVEQ   #1,D0
    CMP.W   D0,D6
    BLE.S   LAB_16E2

    MOVE.L  D6,D0
    EXT.L   D0
    MOVEQ   #32,D1
    CMP.B   -19(A5,D0.L),D1
    BEQ.S   LAB_16E2

    TST.W   D7
    BEQ.S   LAB_16E0

    PEA     GLOB_STR_ALIGNED_ON
    PEA     LAB_2259
    JSR     APPEND_DATA_AT_NULL(PC)

    ADDQ.W  #8,A7

LAB_16E0:
    PEA     GLOB_STR_ALIGNED_CHANNEL_1
    PEA     LAB_2259
    JSR     APPEND_DATA_AT_NULL(PC)

    LEA     1(A3),A0
    MOVE.L  A0,(A7)
    PEA     LAB_2259
    JSR     APPEND_DATA_AT_NULL(PC)

    LEA     12(A7),A7
    LEA     LAB_2259,A0
    MOVEA.L A0,A1

LAB_16E1:
    TST.B   (A1)+
    BNE.S   LAB_16E1

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    LEA     LAB_2258,A0
    ADDA.L  D0,A0
    CLR.B   (A0)
    MOVEQ   #1,D0
    MOVE.L  D0,LAB_237A

LAB_16E2:
    MOVEM.L (A7)+,D6-D7/A3
    UNLK    A5
    RTS

;!======

LAB_16E3:
    LINK.W  A5,#-8
    MOVEM.L D5-D7,-(A7)
    MOVE.W  10(A5),D7
    MOVE.W  14(A5),D6
    MOVE.W  LAB_2364,D0
    EXT.L   D0
    TST.W   LAB_2153
    BEQ.S   LAB_16E4

    MOVEQ   #1,D1
    BRA.S   LAB_16E5

LAB_16E4:
    MOVEQ   #2,D1

LAB_16E5:
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_17CC(PC)

    PEA     LAB_236B
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-4(A5)
    BSR.W   LAB_16D3

    LEA     LAB_236B,A0
    LEA     LAB_2259,A1

LAB_16E6:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_16E6

    PEA     1.W
    BSR.W   LAB_16D9

    LEA     20(A7),A7
    CLR.W   LAB_236D
    MOVEQ   #3,D0
    CMP.W   D0,D6
    BNE.S   LAB_16E7

    MOVEA.L GLOB_REF_RASTPORT_2,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    BRA.S   LAB_16E8

LAB_16E7:
    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

LAB_16E8:
    MOVE.W  #1,LAB_236C
    MOVEQ   #0,D5
    MOVEA.L LAB_2216,A0
    MOVE.W  2(A0),D5
    MOVEQ   #2,D0
    CMP.W   D0,D7
    BNE.S   LAB_16EA

    TST.L   D5
    BPL.S   LAB_16E9

    ADDQ.L  #1,D5

LAB_16E9:
    ASR.L   #1,D5

LAB_16EA:
    MOVE.L  D5,-(A7)
    PEA     LAB_2259
    BSR.W   LAB_1755

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    PEA     LAB_2259
    BSR.W   LAB_16CE

    LEA     12(A7),A7
    MOVEQ   #3,D0
    CMP.W   D0,D6
    BNE.S   LAB_16EB

    MOVEA.L GLOB_REF_RASTPORT_2,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    BRA.S   LAB_16EC

LAB_16EB:
    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVEA.L A0,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

LAB_16EC:
    MOVEM.L (A7)+,D5-D7
    UNLK    A5
    RTS

;!======

LAB_16ED:
    LINK.W  A5,#-16
    MOVEM.L D4-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    TST.W   LAB_2153
    BEQ.S   LAB_16EE

    MOVE.W  LAB_2364,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2236,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A2
    MOVE.L  D7,D1
    EXT.L   D1
    ASL.L   #2,D1
    ADDA.L  D1,A2
    MOVE.L  56(A2),-4(A5)
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.B  498(A1),D6
    BRA.S   LAB_16EF

LAB_16EE:
    MOVE.W  LAB_2364,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2237,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A2
    MOVE.L  D7,D1
    EXT.L   D1
    ASL.L   #2,D1
    ADDA.L  D1,A2
    MOVE.L  56(A2),-4(A5)
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.B  498(A1),D6

LAB_16EF:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  D6,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_17CF(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D5
    TST.L   -4(A5)
    BEQ.W   LAB_16F5

    MOVEA.L -4(A5),A0
    TST.B   (A0)
    BEQ.W   LAB_16F5

    MOVEQ   #40,D0
    CMP.B   (A0),D0
    BNE.S   LAB_16F0

    MOVEQ   #58,D0
    CMP.B   3(A0),D0
    BEQ.S   LAB_16F1

LAB_16F0:
    MOVEQ   #0,D0
    MOVE.B  LAB_1DD8,D0
    MOVEQ   #30,D1
    JSR     LAB_1A07(PC)

    MOVE.L  D5,D1
    EXT.L   D1
    ADD.L   D0,D1
    MOVE.L  D1,D5
    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  A3,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_17CE(PC)

    ADDQ.W  #8,A7
    BRA.W   LAB_16F6

LAB_16F1:
    MOVEQ   #0,D0
    MOVE.B  4(A0),D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVEQ   #10,D1
    JSR     LAB_1A06(PC)

    MOVEQ   #0,D1
    MOVE.B  5(A0),D1
    ADD.L   D1,D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVE.L  D0,D4
    MOVEQ   #0,D0
    MOVE.B  LAB_1DD8,D0
    MOVEQ   #30,D1
    JSR     LAB_1A07(PC)

    MOVE.L  D5,D1
    EXT.L   D1
    ADD.L   D0,D1
    MOVE.L  D1,D5
    MOVE.L  D4,D0
    EXT.L   D0
    MOVEQ   #30,D1
    JSR     LAB_1A07(PC)

    MOVEQ   #0,D0
    MOVE.B  LAB_1DD8,D0
    MOVE.L  D1,24(A7)
    MOVEQ   #30,D1
    JSR     LAB_1A07(PC)

    MOVE.L  24(A7),D0
    CMP.L   D1,D0
    BGE.S   LAB_16F2

    ADDQ.W  #1,D5

LAB_16F2:
    MOVE.L  D4,D0
    EXT.L   D0
    DIVS    #$1e,D0
    SWAP    D0
    MOVE.L  D0,D4
    MOVEQ   #48,D0
    CMP.W   D0,D5
    BLE.S   LAB_16F3

    SUBI.W  #$30,D5

LAB_16F3:
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L GLOB_REF_STR_CLOCK_FORMAT,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVEA.L A3,A2

LAB_16F4:
    MOVE.B  (A1)+,(A2)+
    BNE.S   LAB_16F4

    MOVEQ   #0,D0
    MOVE.B  3(A3),D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVEQ   #10,D1
    JSR     LAB_1A06(PC)

    MOVE.L  D4,D1
    EXT.L   D1
    ADD.L   D0,D1
    MOVE.L  D1,D4
    MOVE.L  D4,D0
    EXT.L   D0
    MOVEQ   #10,D1
    JSR     LAB_1A07(PC)

    MOVEQ   #48,D1
    ADD.L   D1,D0
    MOVE.B  D0,3(A3)
    MOVE.L  D4,D0
    EXT.L   D0
    MOVEQ   #10,D1
    JSR     LAB_1A07(PC)

    MOVEQ   #48,D0
    ADD.L   D0,D1
    MOVE.B  D1,4(A3)
    BRA.S   LAB_16F6

LAB_16F5:
    CLR.B   (A3)

LAB_16F6:
    MOVEM.L (A7)+,D4-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_16F7:
    LINK.W  A5,#-12
    MOVEM.L D5-D7/A2-A3/A6,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVEA.L 16(A5),A2
    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVE.L  56(A2,D0.L),-4(A5)
    MOVE.L  D7,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  498(A2),D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_17CF(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D5
    TST.L   -4(A5)
    BEQ.W   LAB_16FD

    MOVEA.L -4(A5),A0
    TST.B   (A0)
    BEQ.W   LAB_16FD

    MOVEQ   #40,D0
    CMP.B   (A0),D0
    BNE.S   LAB_16F8

    MOVEQ   #58,D0
    CMP.B   3(A0),D0
    BEQ.S   LAB_16F9

LAB_16F8:
    MOVEQ   #0,D0
    MOVE.B  LAB_1DD8,D0
    MOVEQ   #30,D1
    JSR     LAB_1A07(PC)

    MOVE.L  D5,D1
    EXT.L   D1
    ADD.L   D0,D1
    MOVE.L  D1,D5
    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  A3,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_17CE(PC)

    ADDQ.W  #8,A7
    BRA.W   LAB_16FE

LAB_16F9:
    MOVEQ   #0,D0
    MOVE.B  4(A0),D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVEQ   #10,D1
    JSR     LAB_1A06(PC)

    MOVEQ   #0,D1
    MOVE.B  5(A0),D1
    ADD.L   D1,D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVE.L  D0,D6
    MOVEQ   #0,D0
    MOVE.B  LAB_1DD8,D0
    MOVEQ   #30,D1
    JSR     LAB_1A07(PC)

    MOVE.L  D5,D1
    EXT.L   D1
    ADD.L   D0,D1
    MOVE.L  D1,D5
    MOVE.L  D6,D0
    EXT.L   D0
    MOVEQ   #30,D1
    JSR     LAB_1A07(PC)

    MOVEQ   #0,D0
    MOVE.B  LAB_1DD8,D0
    MOVE.L  D1,24(A7)
    MOVEQ   #30,D1
    JSR     LAB_1A07(PC)

    MOVE.L  24(A7),D0
    CMP.L   D1,D0
    BGE.S   LAB_16FA

    ADDQ.W  #1,D5

LAB_16FA:
    MOVE.L  D6,D0
    EXT.L   D0
    DIVS    #$1e,D0
    SWAP    D0
    MOVE.L  D0,D6
    MOVEQ   #48,D0
    CMP.W   D0,D5
    BLE.S   LAB_16FB

    SUBI.W  #$30,D5

LAB_16FB:
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L GLOB_REF_STR_CLOCK_FORMAT,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVEA.L A3,A6

LAB_16FC:
    MOVE.B  (A1)+,(A6)+
    BNE.S   LAB_16FC

    MOVEQ   #0,D0
    MOVE.B  3(A3),D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVEQ   #10,D1
    JSR     LAB_1A06(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    ADD.L   D0,D1
    MOVE.L  D1,D6
    MOVE.L  D6,D0
    EXT.L   D0
    MOVEQ   #10,D1
    JSR     LAB_1A07(PC)

    MOVEQ   #48,D1
    ADD.L   D1,D0
    MOVE.B  D0,3(A3)
    MOVE.L  D6,D0
    EXT.L   D0
    MOVEQ   #10,D1
    JSR     LAB_1A07(PC)

    MOVEQ   #48,D0
    ADD.L   D0,D1
    MOVE.B  D1,4(A3)
    BRA.S   LAB_16FE

LAB_16FD:
    CLR.B   (A3)

LAB_16FE:
    MOVEM.L (A7)+,D5-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

LAB_16FF:
    LINK.W  A5,#-36
    MOVEM.L D2-D7/A3,-(A7)
    MOVE.W  10(A5),D7
    MOVEA.L 12(A5),A3
    MOVE.W  18(A5),D6
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    MOVE.L  D6,D2
    EXT.L   D2
    MOVEQ   #0,D3
    MOVE.B  498(A3),D3
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D0,36(A7)
    MOVE.L  D1,40(A7)
    JSR     LAB_17CF(PC)

    EXT.L   D0
    PEA     -8(A5)
    PEA     -20(A5)
    MOVE.L  D0,-(A7)
    MOVE.L  52(A7),-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  56(A7),-(A7)
    JSR     LAB_17F1(PC)

    LEA     32(A7),A7
    MOVE.W  LAB_2277,D0
    EXT.L   D0
    MOVE.L  -20(A5),D1
    SUB.L   D0,D1
    MOVE.L  D1,D4
    TST.L   D4
    BNE.S   LAB_1700

    MOVE.W  LAB_2275,D0
    EXT.L   D0
    MOVE.L  -16(A5),D1
    SUB.L   D0,D1
    MOVE.L  D1,D4

LAB_1700:
    TST.L   D4
    BNE.S   LAB_1701

    MOVE.W  LAB_2276,D0
    EXT.L   D0
    MOVE.L  -12(A5),D1
    SUB.L   D0,D1
    MOVE.L  D1,D4

LAB_1701:
    MOVE.L  -8(A5),D0
    MOVEQ   #60,D1
    JSR     LAB_1A06(PC)

    ADD.L   -4(A5),D0
    MOVE.L  D0,D5
    MOVE.W  GLOB_WORD_CURRENT_HOUR,D0
    EXT.L   D0
    MOVEQ   #12,D1
    JSR     LAB_1A07(PC)

    TST.W   GLOB_WORD_USE_24_HR_FMT
    BEQ.S   LAB_1702

    MOVEQ   #12,D0
    BRA.S   LAB_1703

LAB_1702:
    MOVEQ   #0,D0

LAB_1703:
    ADD.L   D0,D1
    MOVEQ   #60,D0
    JSR     LAB_1A06(PC)

    MOVE.W  GLOB_WORD_CURRENT_MINUTE,D1
    EXT.L   D1
    ADD.L   D1,D0
    SUB.L   D0,D5
    MOVE.L  D4,D0
    MOVE.L  #$5a0,D1
    JSR     LAB_1A06(PC)

    ADD.L   D0,D5
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D2-D7/A3
    UNLK    A5
    RTS

;!======

LAB_1704:
    MOVEM.L D5-D7/A2-A3,-(A7)
    MOVEA.L 24(A7),A3
    MOVEA.L 28(A7),A2
    MOVE.W  34(A7),D7
    MOVEQ   #-1,D0
    MOVE.W  D0,LAB_2360
    MOVE.W  D0,LAB_2361
    CLR.W   LAB_236F
    MOVE.W  #1,LAB_2153
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_170F

    ADDQ.W  #8,A7
    MOVE.L  D0,D6
    TST.W   D6
    BEQ.S   LAB_1705

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D7,D1
    EXT.L   D1
    MOVE.L  A3,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A2,-(A7)
    BSR.W   LAB_1722

    LEA     16(A7),A7
    MOVE.L  D0,D5
    MOVEQ   #0,D0
    MOVE.B  LAB_2371,D0
    MOVE.W  D0,LAB_2360

LAB_1705:
    TST.W   D6
    BEQ.S   LAB_1706

    TST.W   D5
    BNE.S   LAB_1707

LAB_1706:
    MOVE.W  LAB_224E,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   LAB_1707

    MOVE.W  D1,LAB_2153
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_170F

    ADDQ.W  #8,A7
    MOVE.L  D0,D6
    TST.W   D6
    BEQ.S   LAB_1707

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D7,D1
    EXT.L   D1
    MOVE.L  A3,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A2,-(A7)
    BSR.W   LAB_1722

    LEA     16(A7),A7
    MOVE.L  D0,D5
    MOVEQ   #0,D0
    MOVE.B  LAB_2371,D0
    MOVE.W  D0,LAB_2361

LAB_1707:
    TST.W   D6
    BEQ.S   LAB_1708

    TST.W   D5
    BNE.S   LAB_1709

LAB_1708:
    MOVEQ   #1,D0
    MOVE.W  D0,LAB_2153
    MOVEQ   #0,D0
    BRA.S   LAB_170E

LAB_1709:
    MOVEQ   #2,D0
    CMP.W   D0,D5
    BNE.S   LAB_170C

    MOVE.B  LAB_2377,D0
    MOVEQ   #100,D1
    CMP.B   D1,D0
    BNE.S   LAB_170A

    MOVEQ   #0,D0
    MOVE.B  LAB_2372,D0
    BRA.S   LAB_170B

LAB_170A:
    MOVEQ   #0,D0
    MOVE.B  LAB_2376,D0

LAB_170B:
    MOVE.W  D0,LAB_2364
    BRA.S   LAB_170D

LAB_170C:
    MOVEQ   #0,D0
    MOVE.B  LAB_2371,D0
    MOVE.W  D0,LAB_2364

LAB_170D:
    MOVEQ   #1,D0

LAB_170E:
    MOVEM.L (A7)+,D5-D7/A2-A3
    RTS

;!======

LAB_170F:
    LINK.W  A5,#-20
    MOVEM.L D4-D7/A2-A3,-(A7)
    MOVE.W  14(A5),D7
    MOVEQ   #0,D5
    TST.L   8(A5)
    BEQ.W   LAB_1721

    MOVE.L  8(A5),-(A7)
    PEA     LAB_2159
    JSR     LAB_1902(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   LAB_1710

    MOVEQ   #1,D4
    BRA.S   LAB_1712

LAB_1710:
    MOVE.L  8(A5),-(A7)
    PEA     LAB_215A
    JSR     LAB_1902(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   LAB_1711

    MOVEQ   #1,D0
    MOVE.W  D0,LAB_236F
    MOVE.L  D0,D4
    BRA.S   LAB_1712

LAB_1711:
    MOVEQ   #0,D4

LAB_1712:
    MOVE.L  8(A5),-(A7)
    PEA     LAB_215B
    JSR     LAB_1902(PC)

    TST.B   D0
    SEQ     D1
    NEG.B   D1
    EXT.W   D1
    EXT.L   D1
    MOVE.L  8(A5),(A7)
    PEA     LAB_215C
    MOVE.W  D1,-16(A5)
    JSR     LAB_1902(PC)

    LEA     12(A7),A7
    TST.B   D0
    BNE.S   LAB_1713

    LEA     GLOB_STR_ASTERISK_2,A0
    MOVE.L  A0,8(A5)

LAB_1713:
    LEA     LAB_215E,A0
    MOVEA.L 8(A5),A1

LAB_1714:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.S   LAB_1715

    TST.B   D0
    BNE.S   LAB_1714

    BNE.S   LAB_1715

    MOVEQ   #1,D0
    MOVE.W  D0,LAB_2370
    MOVE.L  #GLOB_STR_ASTERISK_3,8(A5)
    BRA.S   LAB_1716

LAB_1715:
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_2370

LAB_1716:
    MOVEQ   #0,D5
    MOVE.W  LAB_2153,D0
    SUBQ.W  #1,D0
    BNE.S   LAB_1717

    MOVEQ   #0,D0
    MOVE.W  LAB_2231,D0
    MOVE.L  D0,-20(A5)
    BRA.S   LAB_1718

LAB_1717:
    MOVEQ   #0,D0
    MOVE.W  LAB_222F,D0
    MOVE.L  D0,-20(A5)

LAB_1718:
    MOVEQ   #0,D6

LAB_1719:
    MOVE.L  D6,D0
    EXT.L   D0
    CMP.L   -20(A5),D0
    BGE.W   LAB_1721

    MOVE.W  LAB_2153,D0
    SUBQ.W  #1,D0
    BNE.S   LAB_171A

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2236,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A3
    LEA     LAB_2233,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A2
    BRA.S   LAB_171B

LAB_171A:
    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2237,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A3
    LEA     LAB_2235,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A2

LAB_171B:
    BTST    #3,27(A2)
    BNE.S   LAB_1720

    MOVEQ   #69,D0
    CMP.W   D0,D7
    BNE.S   LAB_171C

    BTST    #7,40(A2)
    BEQ.S   LAB_1720

LAB_171C:
    TST.W   D4
    BEQ.S   LAB_171D

    BTST    #4,27(A2)
    BNE.S   LAB_171F

LAB_171D:
    TST.W   -16(A5)
    BEQ.S   LAB_171E

    MOVE.L  A2,-(A7)
    JSR     LAB_15F1(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BNE.S   LAB_171F

LAB_171E:
    MOVE.L  8(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_1902(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   LAB_1720

LAB_171F:
    LEA     LAB_2371,A0
    ADDA.W  D5,A0
    MOVE.L  D6,D0
    MOVE.B  D0,(A0)
    ADDQ.W  #1,D5

LAB_1720:
    ADDQ.W  #1,D6
    BRA.W   LAB_1719

LAB_1721:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D4-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_1722:
    LINK.W  A5,#-24
    MOVEM.L D2-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVE.W  18(A5),D6
    MOVEA.L 20(A5),A2
    MOVE.W  #$fffa,-12(A5)
    MOVE.W  #$5a1,-20(A5)
    MOVE.W  #$fa5f,-22(A5)
    MOVEQ   #0,D0
    MOVE.B  D0,LAB_2375
    MOVE.B  D0,LAB_2379
    MOVE.B  #$64,LAB_2377
    LEA     LAB_2160,A0
    MOVEA.L A2,A1
    MOVE.B  D0,-23(A5)

LAB_1723:
    MOVE.B  (A0)+,D1
    CMP.B   (A1)+,D1
    BNE.S   LAB_1724

    TST.B   D1
    BNE.S   LAB_1723

    BNE.S   LAB_1724

    MOVE.B  #$8,-13(A5)
    BRA.S   LAB_1725

LAB_1724:
    MOVE.B  D0,-13(A5)

LAB_1725:
    MOVE.W  #$31,-6(A5)
    MOVE.W  -6(A5),D0
    MOVE.B  D0,LAB_2373
    TST.W   D6
    BNE.S   LAB_1726

    MOVEQ   #48,D6

LAB_1726:
    MOVEQ   #48,D0
    CMP.W   D0,D6
    BLT.S   LAB_1727

    MOVEQ   #67,D0
    CMP.W   D0,D6
    BLE.S   LAB_1728

LAB_1727:
    MOVEQ   #72,D0
    CMP.W   D0,D6
    BLT.W   LAB_174B

    MOVEQ   #77,D0
    CMP.W   D0,D6
    BGT.W   LAB_174B

LAB_1728:
    MOVE.L  D6,D0
    EXT.L   D0
    LEA     GLOB_STR_TEXTDISP_C_3,A0
    ADDA.L  D0,A0
    MOVE.W  LAB_2274,D0
    EXT.L   D0
    MOVEQ   #1,D1
    ASL.L   D0,D1
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    AND.L   D1,D0
    TST.L   D0
    BEQ.W   LAB_174B

    MOVEQ   #0,D5

LAB_1729:
    CMP.W   D7,D5
    BGE.W   LAB_1741

    LEA     LAB_2371,A0
    ADDA.W  D5,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.W  D0,LAB_2364
    MOVEQ   #0,D0
    MOVE.B  -13(A5),D0
    MOVE.L  D0,-(A7)
    PEA     1.W
    MOVE.L  A3,-(A7)
    BSR.W   LAB_16B3

    LEA     12(A7),A7
    MOVE.W  D0,-4(A5)
    MOVEQ   #49,D1
    CMP.W   D1,D0
    BGE.W   LAB_173F

    TST.W   LAB_2153
    BEQ.S   LAB_172A

    MOVEQ   #0,D1
    MOVE.B  LAB_2230,D1
    EXT.L   D1
    MOVE.W  LAB_2364,D2
    EXT.L   D2
    ASL.L   #2,D2
    LEA     LAB_2236,A0
    ADDA.L  D2,A0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  (A0),-(A7)
    MOVE.L  D1,-(A7)
    BSR.W   LAB_16FF

    LEA     12(A7),A7
    MOVE.W  D0,-18(A5)
    BRA.S   LAB_172B

LAB_172A:
    MOVEQ   #0,D0
    MOVE.B  LAB_222D,D0
    EXT.L   D0
    MOVE.W  LAB_2364,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     LAB_2237,A0
    ADDA.L  D1,A0
    MOVE.W  -4(A5),D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  (A0),-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   LAB_16FF

    LEA     12(A7),A7
    MOVE.W  D0,-18(A5)

LAB_172B:
    TST.W   LAB_2153
    BNE.S   LAB_172C

    CLR.B   -23(A5)
    BRA.S   LAB_1730

LAB_172C:
    MOVE.W  LAB_2270,D1
    MOVE.W  -4(A5),D2
    CMP.W   D1,D2
    BLT.S   LAB_172D

    CMP.W   D2,D1
    BNE.S   LAB_172E

    TST.W   D0
    BGT.S   LAB_172E

LAB_172D:
    MOVEQ   #1,D0
    BRA.S   LAB_172F

LAB_172E:
    MOVEQ   #0,D0

LAB_172F:
    MOVE.B  D0,-23(A5)

LAB_1730:
    TST.W   LAB_2153
    BEQ.S   LAB_1731

    MOVEQ   #0,D0
    MOVE.W  LAB_2270,D0
    BRA.S   LAB_1732

LAB_1731:
    MOVEQ   #1,D0

LAB_1732:
    MOVE.W  -4(A5),D1
    EXT.L   D1
    CMP.L   D0,D1
    BGT.S   LAB_1734

    MOVEQ   #0,D0
    MOVE.B  -13(A5),D0
    MOVE.L  D0,-(A7)
    PEA     2.W
    MOVE.L  A3,-(A7)
    BSR.W   LAB_16B3

    LEA     12(A7),A7
    MOVE.W  D0,-16(A5)
    MOVEQ   #49,D1
    CMP.W   D1,D0
    BGE.S   LAB_1733

    MOVE.B  #$1,LAB_2375
    BRA.S   LAB_1735

LAB_1733:
    MOVE.W  -4(A5),D0
    MOVE.W  D0,-16(A5)
    BRA.S   LAB_1735

LAB_1734:
    MOVE.W  -4(A5),D0
    MOVE.W  D0,-16(A5)

LAB_1735:
    TST.W   LAB_2153
    BEQ.S   LAB_1736

    MOVEQ   #0,D1
    MOVE.B  LAB_2230,D1
    EXT.L   D1
    MOVE.W  LAB_2364,D2
    EXT.L   D2
    ASL.L   #2,D2
    LEA     LAB_2236,A0
    ADDA.L  D2,A0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  (A0),-(A7)
    MOVE.L  D1,-(A7)
    BSR.W   LAB_16FF

    LEA     12(A7),A7
    MOVE.W  D0,-18(A5)
    BRA.S   LAB_1737

LAB_1736:
    MOVEQ   #0,D0
    MOVE.B  LAB_222D,D0
    EXT.L   D0
    MOVE.W  LAB_2364,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     LAB_2237,A0
    ADDA.L  D1,A0
    MOVE.W  -16(A5),D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  (A0),-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   LAB_16FF

    LEA     12(A7),A7
    MOVE.W  D0,-18(A5)

LAB_1737:
    TST.W   LAB_2153
    BEQ.S   LAB_1738

    MOVE.W  LAB_2270,D1
    MOVE.W  -4(A5),D2
    CMP.W   D1,D2
    BNE.S   LAB_1738

    TST.W   D0
    BLE.S   LAB_1738

    MOVEQ   #0,D0
    MOVE.B  -13(A5),D0
    MOVE.L  D0,-(A7)
    PEA     3.W
    MOVE.L  A3,-(A7)
    BSR.W   LAB_16B3

    LEA     12(A7),A7
    MOVE.W  D0,-4(A5)

LAB_1738:
    TST.W   LAB_2153
    BEQ.S   LAB_1739

    MOVE.W  LAB_2364,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2236,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-10(A5)
    BRA.S   LAB_173A

LAB_1739:
    MOVE.W  LAB_2364,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2237,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-10(A5)

LAB_173A:
    MOVE.W  -18(A5),D0
    TST.W   D0
    BLE.S   LAB_173B

    MOVE.W  -16(A5),D1
    EXT.L   D1
    ADD.L   D1,D1
    MOVE.W  -12(A5),D2
    MOVEA.L -10(A5),A0
    MOVE.L  D1,D3
    ADDI.L  #400,D3
    CMP.W   0(A0,D3.L),D2
    BLS.S   LAB_173B

    MOVEQ   #1,D1
    MOVE.B  D1,LAB_2379
    MOVE.W  -16(A5),D3
    MOVE.B  D3,LAB_2377
    MOVE.W  LAB_2364,D4
    MOVE.B  D4,LAB_2376
    MOVE.B  -23(A5),D2
    MOVE.B  D2,LAB_2378

LAB_173B:
    TST.W   D0
    BLE.S   LAB_173C

    CMP.W   -20(A5),D0
    BGE.S   LAB_173C

    MOVEQ   #1,D1
    MOVE.B  D1,LAB_2375
    MOVE.W  -16(A5),D1
    MOVE.B  D1,LAB_2373
    MOVE.W  LAB_2364,D2
    MOVE.B  D2,LAB_2372
    MOVE.B  -23(A5),D3
    MOVE.B  D3,LAB_2374
    MOVE.W  D0,-20(A5)
    BRA.W   LAB_173E

LAB_173C:
    TST.B   LAB_2379
    BNE.S   LAB_173D

    TST.W   D0
    BGT.S   LAB_173D

    MOVE.W  -22(A5),D1
    CMP.W   D1,D0
    BLE.S   LAB_173D

    MOVE.W  -16(A5),D2
    EXT.L   D2
    ADD.L   D2,D2
    MOVE.W  -12(A5),D3
    MOVEA.L -10(A5),A0
    MOVE.L  D2,D4
    ADDI.L  #400,D4
    CMP.W   0(A0,D4.L),D3
    BLS.S   LAB_173D

    MOVE.W  -16(A5),D2
    MOVE.B  D2,LAB_2377
    MOVE.W  LAB_2364,D3
    MOVE.B  D3,LAB_2376
    MOVE.B  -23(A5),D4
    MOVE.B  D4,LAB_2378

LAB_173D:
    TST.B   LAB_2375
    BNE.S   LAB_173E

    TST.W   D0
    BGT.S   LAB_173E

    CMP.W   -22(A5),D0
    BLE.S   LAB_173E

    MOVE.W  -16(A5),D1
    MOVE.B  D1,LAB_2373
    MOVE.W  LAB_2364,D2
    MOVE.B  D2,LAB_2372
    MOVE.B  -23(A5),LAB_2374
    MOVE.W  D0,-22(A5)

LAB_173E:
    MOVE.W  -16(A5),D0
    EXT.L   D0
    ADD.L   D0,D0
    MOVEA.L -10(A5),A0
    MOVE.L  D0,D1
    ADDI.L  #400,D1
    MOVE.W  0(A0,D1.L),-12(A5)
    MOVE.W  -4(A5),D0
    MOVE.W  LAB_2370,D1
    MOVE.W  D0,-6(A5)
    SUBQ.W  #1,D1
    BNE.S   LAB_173F

    MOVEQ   #2,D0
    BRA.W   LAB_174C

LAB_173F:
    MOVEQ   #49,D0
    CMP.W   -6(A5),D0
    BNE.S   LAB_1740

    TST.W   LAB_236F
    BNE.S   LAB_1740

    MOVEQ   #0,D0
    MOVE.B  -13(A5),D0
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_16B3

    LEA     12(A7),A7
    MOVE.W  LAB_2364,D1
    MOVE.B  D1,LAB_2372
    MOVE.W  D0,-6(A5)

LAB_1740:
    ADDQ.W  #1,D5
    BRA.W   LAB_1729

LAB_1741:
    CMPI.W  #$31,-6(A5)
    BGE.S   LAB_1746

    CMPI.W  #$3d,-20(A5)
    BGE.S   LAB_1742

    MOVEQ   #100,D0
    MOVE.B  D0,LAB_2377

LAB_1742:
    MOVE.B  LAB_2377,D0
    MOVEQ   #100,D1
    CMP.B   D1,D0
    BEQ.S   LAB_1745

    TST.W   LAB_2153
    BEQ.S   LAB_1743

    MOVEQ   #0,D1
    MOVE.B  LAB_2376,D1
    MOVE.L  D1,D2
    EXT.L   D2
    ASL.L   #2,D2
    LEA     LAB_2236,A0
    ADDA.L  D2,A0
    MOVE.L  (A0),-10(A5)
    BRA.S   LAB_1744

LAB_1743:
    MOVEQ   #0,D1
    MOVE.B  LAB_2376,D1
    MOVE.L  D1,D2
    EXT.L   D2
    ASL.L   #2,D2
    LEA     LAB_2237,A0
    ADDA.L  D2,A0
    MOVE.L  (A0),-10(A5)

LAB_1744:
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,D0
    EXT.L   D0
    ADD.L   D0,D0
    MOVEA.L -10(A5),A0
    MOVE.L  D0,D1
    ADDI.L  #400,D1
    ADDQ.W  #1,0(A0,D1.L)

LAB_1745:
    MOVEQ   #2,D0
    BRA.S   LAB_174C

LAB_1746:
    MOVEQ   #48,D0
    CMP.W   D0,D6
    BLE.S   LAB_1747

    MOVEQ   #58,D0
    CMP.W   D0,D6
    BLT.S   LAB_1749

LAB_1747:
    MOVEQ   #62,D0
    CMP.W   D0,D6
    BLE.S   LAB_1748

    MOVEQ   #68,D0
    CMP.W   D0,D6
    BLT.S   LAB_1749

LAB_1748:
    MOVEQ   #71,D0
    CMP.W   D0,D6
    BLE.S   LAB_174A

    MOVEQ   #78,D0
    CMP.W   D0,D6
    BGE.S   LAB_174A

LAB_1749:
    MOVEQ   #68,D6
    MOVEQ   #1,D0
    BRA.S   LAB_174C

LAB_174A:
    MOVEQ   #0,D0
    BRA.S   LAB_174C

LAB_174B:
    MOVEQ   #1,D0

LAB_174C:
    MOVEM.L (A7)+,D2-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_174D:
    LINK.W  A5,#-8
    MOVEM.L D2/D7,-(A7)
    MOVE.W  LAB_2365,D0
    SUBQ.W  #1,D0
    BNE.S   LAB_174E

    MOVE.L  #LAB_234B,-4(A5)
    MOVE.W  LAB_234D,D7
    BRA.S   LAB_174F

LAB_174E:
    LEA     LAB_234C,A0
    MOVE.W  LAB_234E,D7
    MOVE.L  A0,-4(A5)

LAB_174F:
    TST.W   D7
    BNE.S   LAB_1750

    MOVEQ   #48,D7

LAB_1750:
    MOVEQ   #48,D0
    CMP.W   D0,D7
    BLT.S   LAB_1751

    MOVEQ   #67,D0
    CMP.W   D0,D7
    BLE.S   LAB_1752

LAB_1751:
    MOVEQ   #72,D0
    CMP.W   D0,D7
    BLT.S   LAB_1753

    MOVEQ   #77,D0
    CMP.W   D0,D7
    BGT.S   LAB_1753

LAB_1752:
    MOVE.L  D7,D0
    EXT.L   D0
    LEA     GLOB_STR_TEXTDISP_C_3,A0
    ADDA.L  D0,A0
    MOVE.W  LAB_2274,D0
    EXT.L   D0
    MOVEQ   #1,D1
    MOVE.L  D1,D2
    ASL.L   D0,D2
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    AND.L   D2,D0
    TST.L   D0
    BEQ.S   LAB_1753

    CLR.L   -(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  -4(A5),-(A7)
    BSR.W   LAB_16B3

    LEA     12(A7),A7
    MOVE.B  D0,LAB_2373
    BRA.S   LAB_1754

LAB_1753:
    MOVE.B  #$64,LAB_2377
    MOVE.B  #$31,LAB_2373

LAB_1754:
    MOVEM.L (A7)+,D2/D7
    UNLK    A5
    RTS

;!======

LAB_1755:
    LINK.W  A5,#-28
    MOVEM.L D4-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVEQ   #25,D4
    MOVEA.L A3,A0
    CLR.L   -8(A5)
    MOVEQ   #0,D6
    MOVEA.L LAB_2216,A1
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A1
    MOVEA.L A0,A2

LAB_1756:
    TST.B   (A2)+
    BNE.S   LAB_1756

    SUBQ.L  #1,A2
    SUBA.L  A0,A2
    MOVE.L  A0,-4(A5)
    MOVE.L  A2,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,D5

LAB_1757:
    CMP.L   D7,D5
    BLE.W   LAB_175E

    MOVEA.L -4(A5),A0
    TST.B   (A0)
    BEQ.W   LAB_175E

    MOVE.B  (A0),D0
    MOVEQ   #24,D1
    CMP.B   D1,D0
    BEQ.S   LAB_1758

    MOVEQ   #25,D1
    CMP.B   D1,D0
    BNE.S   LAB_175A

LAB_1758:
    MOVE.L  D0,D4
    ADDQ.L  #1,-4(A5)
    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVEA.L -4(A5),A1

LAB_1759:
    TST.B   (A1)+
    BNE.S   LAB_1759

    SUBQ.L  #1,A1
    SUBA.L  -4(A5),A1
    MOVE.L  A1,28(A7)
    MOVEA.L A0,A1
    MOVEA.L -4(A5),A0
    MOVE.L  28(A7),D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,D5
    MOVEQ   #0,D6
    CLR.L   -8(A5)
    BRA.S   LAB_1757

LAB_175A:
    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVEA.L A0,A1
    MOVEA.L -4(A5),A0
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    ADD.L   D0,D6
    CMP.L   D7,D6
    BLE.S   LAB_175C

    TST.L   -8(A5)
    BEQ.S   LAB_175E

    MOVEA.L -8(A5),A0
    MOVE.B  D4,(A0)
    LEA     1(A0),A1
    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVEA.L A1,A2

LAB_175B:
    TST.B   (A2)+
    BNE.S   LAB_175B

    SUBQ.L  #1,A2
    SUBA.L  A1,A2
    MOVE.L  A1,-4(A5)
    MOVEA.L A0,A1
    MOVE.L  A2,D0
    MOVEA.L -4(A5),A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,D5
    MOVEQ   #0,D6
    CLR.L   -8(A5)
    BRA.W   LAB_1757

LAB_175C:
    MOVEQ   #32,D0
    MOVEA.L -4(A5),A0
    CMP.B   (A0),D0
    BNE.S   LAB_175D

    MOVE.L  A0,-8(A5)

LAB_175D:
    ADDQ.L  #1,-4(A5)
    BRA.W   LAB_1757

LAB_175E:
    MOVEM.L (A7)+,D4-D7/A2-A3
    UNLK    A5
    RTS
