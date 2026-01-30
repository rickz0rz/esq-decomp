; Rename this file to its proper purpose.

LAB_0AB8:
    MOVEM.L D2/D6-D7/A3,-(A7)
    MOVEA.L 20(A7),A3

    MOVE.B  LAB_1DD7,D6
    MOVEQ   #0,D7

LAB_0AB9:
    MOVEQ   #20,D0
    CMP.W   D0,D7
    BGE.S   LAB_0ABA

    LEA     LAB_1DC8,A0
    ADDA.W  D7,A0
    MOVE.B  0(A3,D7.W),(A0)
    ADDQ.W  #1,D7
    BRA.S   LAB_0AB9

LAB_0ABA:
    TST.L   LAB_1FE6
    BNE.S   LAB_0ABB

    MOVE.B  LAB_1DD7,D0
    CMP.B   D0,D6
    BEQ.S   LAB_0ABB

    MOVE.W  LAB_2346,D0
    BEQ.S   LAB_0ABB

    MOVEQ   #1,D0
    MOVE.L  D0,LAB_2125

LAB_0ABB:
    MOVE.B  LAB_1DD1,D0
    MOVEQ   #49,D1
    CMP.B   D1,D0
    BCS.S   LAB_0ABC

    MOVEQ   #72,D1
    CMP.B   D1,D0
    BLS.S   LAB_0ABD

LAB_0ABC:
    MOVE.B  #$36,LAB_1DD1

LAB_0ABD:
    PEA     LAB_21DF
    JSR     LAB_0BFE(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BNE.S   LAB_0ABE

    JSR     LAB_0C05(PC)

LAB_0ABE:
    PEA     1.W
    JSR     ESQDISP_DrawStatusBanner(PC)

    ADDQ.W  #4,A7
    MOVE.B  LAB_1DCF,D0
    MOVEQ   #9,D1
    CMP.B   D1,D0
    BHI.S   LAB_0ABF

    MOVEQ   #0,D2
    CMP.B   D2,D0
    BHI.S   LAB_0AC0

LAB_0ABF:
    MOVEQ   #1,D2
    MOVE.B  D2,LAB_1DCF

LAB_0AC0:
    MOVE.B  LAB_1DD0,D0
    CMP.B   D1,D0
    BHI.S   LAB_0AC1

    MOVEQ   #0,D1
    CMP.B   D1,D0
    BHI.S   LAB_0AC2

LAB_0AC1:
    MOVEQ   #1,D1
    MOVE.B  D1,LAB_1DD0

LAB_0AC2:
    MOVEQ   #0,D0
    MOVE.B  LAB_1DCF,D0
    MOVEQ   #0,D1
    MOVE.B  LAB_1DD0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_0BF1(PC)

    ADDQ.W  #8,A7
    TST.W   LAB_2252
    BEQ.S   LAB_0AC3

    JSR     DRAW_DIAGNOSTIC_MODE_TEXT(PC)

LAB_0AC3:
    TST.L   LAB_21E2
    BNE.S   LAB_0AC5

    MOVEQ   #0,D0
    MOVE.B  GLOB_STR_SATELLITE_DELIVERED_SCROLL_SPEED,D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVE.L  D0,D7
    MOVEQ   #1,D0
    CMP.W   D0,D7
    BLT.S   LAB_0AC4

    MOVEQ   #8,D1
    CMP.W   D1,D7
    BGT.S   LAB_0AC4

    MOVE.W  D7,LAB_1F40
    BRA.S   LAB_0AC5

LAB_0AC4:
    MOVE.W  #4,LAB_1F40

LAB_0AC5:
    MOVE.W  #1,LAB_2299
    MOVEM.L (A7)+,D2/D6-D7/A3
    RTS

;!======

LAB_0AC6:
    MOVE.L  D7,-(A7)
    MOVE.B  11(A7),D7

    MOVEQ   #1,D0
    CMP.B   D0,D7
    BLT.S   .return

    MOVEQ   #48,D1
    CMP.B   D1,D7
    BGT.S   .return

    MOVE.L  D7,D0

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======

LAB_0AC8:
    MOVE.L  D7,-(A7)
    MOVE.W  10(A7),D7
    MOVEQ   #2,D0
    CMP.W   D0,D7
    BNE.S   LAB_0AC9

    MOVE.L  LAB_1DE9,-(A7)
    CLR.L   -(A7)
    BSR.W   LAB_0B44

    MOVE.L  D0,LAB_1DE9
    MOVE.L  LAB_1DEA,(A7)
    CLR.L   -(A7)
    BSR.W   LAB_0B44

    LEA     12(A7),A7
    MOVE.L  D0,LAB_1DEA
    BRA.S   LAB_0ACA

LAB_0AC9:
    MOVE.L  LAB_1DDB,-(A7)
    CLR.L   -(A7)
    BSR.W   LAB_0B44

    MOVE.L  D0,LAB_1DDB
    MOVE.L  LAB_1DDC,(A7)
    CLR.L   -(A7)
    BSR.W   LAB_0B44

    LEA     12(A7),A7
    MOVE.L  D0,LAB_1DDC

LAB_0ACA:
    MOVE.L  (A7)+,D7
    RTS

;!======

LAB_0ACB:
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVEQ   #0,D0
    MOVE.B  (A3),D0
    MOVEQ   #0,D1
    NOT.B   D1
    AND.L   D1,D0
    MOVE.L  D0,D7
    MOVE.B  LAB_2230,D0
    CMP.B   D0,D7
    BNE.W   LAB_0AD1

    PEA     1.W
    BSR.W   LAB_0AC8

    ADDQ.W  #4,A7
    MOVEQ   #18,D0
    CMP.B   1(A3),D0
    BNE.S   LAB_0ACD

    SUBA.L  A0,A0
    MOVE.L  A0,LAB_1DDB
    MOVEQ   #0,D1
    MOVE.W  LAB_2232,D1
    CMP.B   -1(A3,D1.L),D0
    BNE.S   LAB_0ACC

    MOVE.L  A0,LAB_1DDC
    BRA.W   LAB_0AD7

LAB_0ACC:
    LEA     2(A3),A0
    MOVE.L  LAB_1DDC,-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   LAB_0B44

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_1DDC
    BRA.W   LAB_0AD7

LAB_0ACD:
    MOVEQ   #0,D0
    MOVE.W  LAB_2232,D0
    MOVEQ   #18,D1
    CMP.B   -1(A3,D0.L),D1
    BNE.S   LAB_0ACE

    MOVEQ   #0,D1
    MOVE.W  D0,D1
    CLR.B   -1(A3,D1.L)
    LEA     1(A3),A0
    MOVE.L  LAB_1DDB,-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   LAB_0B44

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_1DDB
    CLR.L   LAB_1DDC
    BRA.W   LAB_0AD7

LAB_0ACE:
    MOVEQ   #3,D6

LAB_0ACF:
    MOVEQ   #18,D0
    CMP.B   0(A3,D6.W),D0
    BEQ.S   LAB_0AD0

    MOVEQ   #103,D0
    CMP.W   D0,D6
    BGE.S   LAB_0AD0

    ADDQ.W  #1,D6
    BRA.S   LAB_0ACF

LAB_0AD0:
    CLR.B   0(A3,D6.W)
    LEA     1(A3),A0
    MOVE.L  LAB_1DDB,-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   LAB_0B44

    MOVE.L  D0,LAB_1DDB
    MOVE.L  D6,D0
    EXT.L   D0
    MOVEA.L A3,A0
    ADDA.L  D0,A0
    LEA     1(A0),A1
    MOVE.L  LAB_1DDC,(A7)
    MOVE.L  A1,-(A7)
    BSR.W   LAB_0B44

    LEA     12(A7),A7
    MOVE.L  D0,LAB_1DDC
    BRA.W   LAB_0AD7

LAB_0AD1:
    MOVE.B  LAB_222D,D0
    CMP.B   D0,D7
    BNE.W   LAB_0AD7

    PEA     2.W
    BSR.W   LAB_0AC8

    ADDQ.W  #4,A7
    MOVE.W  #1,LAB_228F
    MOVEQ   #18,D0
    CMP.B   1(A3),D0
    BNE.S   LAB_0AD3

    SUBA.L  A0,A0
    MOVE.L  A0,LAB_1DE9
    MOVEQ   #0,D1
    MOVE.W  LAB_2232,D1
    CMP.B   -1(A3,D1.L),D0
    BNE.S   LAB_0AD2

    MOVE.L  A0,LAB_1DEA
    BRA.W   LAB_0AD7

LAB_0AD2:
    LEA     2(A3),A0
    MOVE.L  LAB_1DEA,-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   LAB_0B44

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_1DEA
    BRA.W   LAB_0AD7

LAB_0AD3:
    MOVEQ   #0,D0
    MOVE.W  LAB_2232,D0
    MOVEQ   #18,D1
    CMP.B   -1(A3,D0.L),D1
    BNE.S   LAB_0AD4

    LEA     1(A3),A0
    MOVE.L  LAB_1DE9,-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   LAB_0B44

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_1DE9
    CLR.L   LAB_1DEA
    BRA.S   LAB_0AD7

LAB_0AD4:
    MOVEQ   #3,D6

LAB_0AD5:
    MOVEQ   #18,D0
    CMP.B   0(A3,D6.W),D0
    BEQ.S   LAB_0AD6

    MOVEQ   #103,D0
    CMP.W   D0,D6
    BGE.S   LAB_0AD6

    ADDQ.W  #1,D6
    BRA.S   LAB_0AD5

LAB_0AD6:
    CLR.B   0(A3,D6.W)
    LEA     1(A3),A0
    MOVE.L  LAB_1DE9,-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   LAB_0B44

    MOVE.L  D0,LAB_1DE9
    MOVE.L  D6,D0
    EXT.L   D0
    MOVEA.L A3,A0
    ADDA.L  D0,A0
    LEA     1(A0),A1
    MOVE.L  LAB_1DEA,(A7)
    MOVE.L  A1,-(A7)
    BSR.W   LAB_0B44

    LEA     12(A7),A7
    MOVE.L  D0,LAB_1DEA

LAB_0AD7:
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======

LAB_0AD8:
    LINK.W  A5,#-20
    MOVEM.L D2/D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEQ   #0,D0
    MOVE.B  (A3)+,D0
    MOVEQ   #0,D1
    NOT.B   D1
    AND.L   D1,D0
    MOVE.L  D0,D7
    MOVE.B  LAB_2230,D0
    CMP.B   D0,D7
    BNE.S   LAB_0ADA

    MOVE.W  LAB_2248,D0
    MOVE.W  LAB_2232,D1
    CMP.W   D1,D0
    BNE.S   LAB_0AD9

    MOVE.B  LAB_2247,D0
    MOVE.B  LAB_2253,D2
    CMP.B   D2,D0
    BEQ.S   LAB_0ADA

LAB_0AD9:
    MOVE.W  D1,LAB_2248
    MOVE.B  LAB_2253,LAB_2247
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_224C
    MOVE.W  LAB_2231,D1
    CMP.W   D0,D1
    BLS.S   LAB_0ADD

    PEA     1.W
    BSR.W   LAB_0B38

    ADDQ.W  #4,A7
    MOVEQ   #1,D0
    MOVE.L  D0,LAB_225F
    BRA.S   LAB_0ADD

LAB_0ADA:
    MOVE.B  LAB_222D,D0
    CMP.B   D0,D7
    BNE.S   LAB_0ADC

    MOVE.W  LAB_224E,D0
    MOVE.W  LAB_2232,D1
    CMP.W   D1,D0
    BNE.S   LAB_0ADB

    MOVE.B  LAB_224D,D0
    MOVE.B  LAB_2253,D2
    CMP.B   D2,D0
    BEQ.S   LAB_0ADC

LAB_0ADB:
    MOVE.W  D1,LAB_224E
    MOVE.B  LAB_2253,LAB_224D
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_224C
    MOVE.W  LAB_222F,D1
    CMP.W   D0,D1
    BLS.S   LAB_0ADD

    PEA     2.W
    BSR.W   LAB_0B38

    ADDQ.W  #4,A7
    BRA.S   LAB_0ADD

LAB_0ADC:
    MOVEQ   #0,D0
    BRA.W   LAB_0AF5

LAB_0ADD:
    MOVEQ   #1,D6
    MOVEQ   #0,D0
    MOVE.B  D0,LAB_22C4
    MOVE.B  D0,LAB_22C6
    MOVEQ   #0,D5

LAB_0ADE:
    MOVEQ   #6,D0
    CMP.W   D0,D5
    BGE.S   LAB_0ADF

    LEA     LAB_22C8,A0
    ADDA.W  D5,A0
    MOVE.B  #$ff,(A0)
    ADDQ.W  #1,D5
    BRA.S   LAB_0ADE

LAB_0ADF:
    CLR.B   LAB_22C9
    MOVEQ   #0,D4
    MOVEQ   #0,D5
    MOVEQ   #1,D0
    MOVE.L  D0,-8(A5)
    CLR.L   -12(A5)
    CLR.W   -14(A5)

LAB_0AE0:
    MOVE.B  (A3)+,D0
    MOVE.B  D0,-3(A5)
    TST.B   D0
    BEQ.W   LAB_0AF3

    TST.L   -12(A5)
    BNE.W   LAB_0AF3

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    SUBQ.W  #1,D1
    BEQ.W   LAB_0AEE

    SUBI.W  #16,D1
    BEQ.W   LAB_0AE9

    SUBQ.W  #1,D1
    BEQ.S   LAB_0AE1

    SUBQ.W  #2,D1
    BEQ.W   LAB_0AEB

    BRA.W   LAB_0AF1

LAB_0AE1:
    MOVE.L  D4,D0
    EXT.L   D0
    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0AF6

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_0AE2

    MOVEQ   #1,D0
    MOVE.L  D0,-12(A5)
    BRA.S   LAB_0AE0

LAB_0AE2:
    MOVE.L  D4,D0
    MULS    #10,D0
    LEA     LAB_22C4,A0
    ADDA.L  D0,A0
    ADDA.W  D5,A0
    CLR.B   (A0)
    TST.L   -8(A5)
    BNE.S   LAB_0AE5

    TST.W   -14(A5)
    BNE.S   LAB_0AE4

    LEA     LAB_22C4,A0
    LEA     LAB_22C9,A1

LAB_0AE3:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_0AE3

LAB_0AE4:
    MOVEQ   #0,D0
    MOVE.B  D0,LAB_22C5
    MOVE.B  D0,LAB_22C7
    MOVE.B  D0,LAB_22CA
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEQ   #0,D1
    MOVE.B  D6,D1
    PEA     LAB_22C9
    PEA     LAB_22C8
    PEA     LAB_22C6
    PEA     LAB_22C4
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_0C1E(PC)

    LEA     24(A7),A7
    MOVEQ   #0,D0
    MOVE.W  D0,-14(A5)
    BRA.S   LAB_0AE6

LAB_0AE5:
    CLR.L   -8(A5)

LAB_0AE6:
    MOVEQ   #0,D0
    MOVE.B  D0,LAB_22C4
    MOVE.B  D0,LAB_22C6
    MOVEQ   #0,D5

LAB_0AE7:
    MOVEQ   #6,D0
    CMP.W   D0,D5
    BGE.S   LAB_0AE8

    LEA     LAB_22C8,A0
    ADDA.W  D5,A0
    MOVE.B  #$ff,(A0)
    ADDQ.W  #1,D5
    BRA.S   LAB_0AE7

LAB_0AE8:
    CLR.B   LAB_22C9
    MOVEQ   #0,D4
    MOVEQ   #0,D5
    MOVE.B  (A3)+,D6
    BRA.W   LAB_0AE0

LAB_0AE9:
    MOVE.L  D4,D0
    EXT.L   D0
    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0AF6

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_0AEA

    MOVEQ   #1,D0
    MOVE.L  D0,-12(A5)
    BRA.W   LAB_0AE0

LAB_0AEA:
    MOVE.L  D4,D0
    MULS    #10,D0
    LEA     LAB_22C4,A0
    ADDA.L  D0,A0
    ADDA.W  D5,A0
    CLR.B   (A0)
    MOVEQ   #1,D4
    MOVEQ   #0,D5
    BRA.W   LAB_0AE0

LAB_0AEB:
    MOVE.L  D4,D0
    EXT.L   D0
    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0AF6

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_0AEC

    MOVEQ   #1,D0
    MOVE.L  D0,-12(A5)
    BRA.W   LAB_0AE0

LAB_0AEC:
    MOVE.L  D4,D0
    MULS    #10,D0
    LEA     LAB_22C4,A0
    ADDA.L  D0,A0
    ADDA.W  D5,A0
    CLR.B   (A0)
    MOVEQ   #0,D5

LAB_0AED:
    MOVEQ   #6,D0
    CMP.W   D0,D5
    BGE.W   LAB_0AE0

    LEA     LAB_22C8,A0
    ADDA.W  D5,A0
    MOVE.B  (A3)+,(A0)
    ADDQ.W  #1,D5
    BRA.S   LAB_0AED

LAB_0AEE:
    MOVE.L  D4,D0
    EXT.L   D0
    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0AF6

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_0AEF

    MOVEQ   #1,D0
    MOVE.L  D0,-12(A5)
    BRA.W   LAB_0AE0

LAB_0AEF:
    MOVEQ   #2,D0
    CMP.W   D0,D4
    BEQ.S   LAB_0AF0

    MOVE.L  D4,D0
    MULS    #10,D0
    LEA     LAB_22C4,A0
    ADDA.L  D0,A0
    ADDA.W  D5,A0
    CLR.B   (A0)

LAB_0AF0:
    MOVEQ   #3,D4
    MOVEQ   #0,D5
    MOVE.W  #1,-14(A5)
    BRA.W   LAB_0AE0

LAB_0AF1:
    MOVE.L  D4,D0
    EXT.L   D0
    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0AF6

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_0AF2

    MOVEQ   #1,D0
    MOVE.L  D0,-12(A5)
    BRA.W   LAB_0AE0

LAB_0AF2:
    MOVE.L  D4,D0
    MULS    #10,D0
    LEA     LAB_22C4,A0
    ADDA.L  D0,A0
    MOVE.L  D5,D0
    ADDQ.W  #1,D5
    ADDA.W  D0,A0
    MOVE.B  -3(A5),(A0)
    BRA.W   LAB_0AE0

LAB_0AF3:
    MOVE.L  D4,D0
    EXT.L   D0
    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0AF6

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_0AF4

    MOVEQ   #0,D0
    BRA.S   LAB_0AF5

LAB_0AF4:
    MOVE.L  D4,D0
    MULS    #10,D0
    LEA     LAB_22C4,A0
    ADDA.L  D0,A0
    ADDA.W  D5,A0
    MOVEQ   #0,D0
    MOVE.B  D0,(A0)
    MOVE.B  D0,LAB_22C5
    MOVE.B  D0,LAB_22C7
    MOVE.B  D0,LAB_22CA
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEQ   #0,D1
    MOVE.B  D6,D1
    PEA     LAB_22C9
    PEA     LAB_22C8
    PEA     LAB_22C6
    PEA     LAB_22C4
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_0C1E(PC)

    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D0,(A7)
    BSR.W   LAB_0AFB

    JSR     LAB_0BF3(PC)

    JSR     LAB_0BEB(PC)

LAB_0AF5:
    MOVEM.L -44(A5),D2/D4-D7/A3
    UNLK    A5
    RTS

;!======

LAB_0AF6:
    MOVEM.L D6-D7,-(A7)
    MOVE.W  14(A7),D7
    MOVE.W  18(A7),D6
    MOVEQ   #3,D0
    CMP.W   D0,D7
    BLE.S   LAB_0AF7

    MOVEQ   #0,D0
    BRA.S   LAB_0AFA

LAB_0AF7:
    MOVEQ   #1,D0
    CMP.W   D0,D7
    BNE.S   LAB_0AF8

    MOVEQ   #10,D0
    CMP.W   D0,D6
    BLE.S   LAB_0AF9

    MOVEQ   #0,D0
    BRA.S   LAB_0AFA

LAB_0AF8:
    MOVEQ   #7,D0
    CMP.W   D0,D6
    BLE.S   LAB_0AF9

    MOVEQ   #0,D0
    BRA.S   LAB_0AFA

LAB_0AF9:
    MOVEQ   #1,D0

LAB_0AFA:
    MOVEM.L (A7)+,D6-D7
    RTS

;!======

LAB_0AFB:
    LINK.W  A5,#-24
    MOVEM.L D4-D7,-(A7)
    MOVE.B  11(A5),D7
    MOVE.B  LAB_222D,D0
    CMP.B   D7,D0
    BNE.S   LAB_0AFC

    MOVE.W  LAB_222F,D0
    MOVE.W  D0,-12(A5)
    BRA.S   LAB_0AFE

LAB_0AFC:
    MOVE.B  LAB_2230,D0
    CMP.B   D0,D7
    BNE.S   LAB_0AFD

    MOVE.W  LAB_2231,D0
    MOVE.W  D0,-12(A5)
    BRA.S   LAB_0AFE

LAB_0AFD:
    MOVEQ   #0,D0
    BRA.W   LAB_0B07

LAB_0AFE:
    MOVEQ   #0,D6

LAB_0AFF:
    CMP.W   -12(A5),D6
    BGE.W   LAB_0B07

    MOVE.B  LAB_222D,D0
    CMP.B   D0,D7
    BNE.S   LAB_0B00

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2235,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    BRA.S   LAB_0B01

LAB_0B00:
    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2233,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)

LAB_0B01:
    MOVEA.L -4(A5),A0
    ADDQ.L  #1,A0
    MOVEA.L A0,A1

LAB_0B02:
    TST.B   (A1)+
    BNE.S   LAB_0B02

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.W  LAB_224C,D0
    EXT.L   D0
    MOVE.L  A1,D1
    SUB.L   D1,D0
    MOVE.L  D0,D4
    TST.W   D4
    BLE.S   LAB_0B06

    MOVEQ   #0,D5

LAB_0B03:
    MOVEQ   #10,D0
    CMP.W   D0,D5
    BGE.S   LAB_0B04

    MOVE.B  #$20,-24(A5,D5.W)
    ADDQ.W  #1,D5
    BRA.S   LAB_0B03

LAB_0B04:
    CLR.B   -24(A5,D4.W)
    MOVEA.L -4(A5),A0
    ADDQ.L  #1,A0
    MOVE.L  A0,-(A7)
    PEA     -24(A5)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_2(PC)

    ADDQ.W  #8,A7
    MOVEA.L -4(A5),A0
    ADDQ.L  #1,A0
    LEA     -24(A5),A1

LAB_0B05:
    MOVE.B  (A1)+,(A0)+
    BNE.S   LAB_0B05

LAB_0B06:
    ADDQ.W  #1,D6
    BRA.W   LAB_0AFF

LAB_0B07:
    MOVEM.L (A7)+,D4-D7
    UNLK    A5
    RTS

;!======

LAB_0B08:
    LINK.W  A5,#-4
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 24(A7),A3
    MOVE.W  30(A7),D7
    MOVEQ   #0,D6

LAB_0B09:
    CMP.W   D7,D6
    BGE.S   LAB_0B0A

    JSR     LAB_096D(PC)

    MOVEA.L A3,A0
    ADDQ.L  #1,A3
    MOVE.L  A0,12(A7)
    JSR     LAB_0C03(PC)

    MOVEA.L 12(A7),A0
    MOVE.B  D0,(A0)
    ADDQ.W  #1,D6
    BRA.S   LAB_0B09

LAB_0B0A:
    MOVE.L  A3,D0
    MOVEM.L (A7)+,D6-D7/A3
    UNLK    A5
    RTS

;!======

LAB_0B0B:
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.W  26(A7),D7
    MOVEA.L 28(A7),A2
    MOVEQ   #0,D6

LAB_0B0C:
    CMP.W   D7,D6
    BGE.S   LAB_0B0D

    JSR     LAB_096D(PC)

    JSR     LAB_0C03(PC)

    MOVE.B  D0,(A3)
    ADDQ.L  #1,A3
    EOR.B   D0,(A2)
    ADDQ.W  #1,D6
    BRA.S   LAB_0B0C

LAB_0B0D:
    MOVE.L  A3,D0
    MOVEM.L (A7)+,D6-D7/A2-A3
    RTS

;!======

LAB_0B0E:
    LINK.W  A5,#-12
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVE.W  18(A5),D6
    MOVEQ   #0,D4
    MOVE.W  D4,-6(A5)

LAB_0B0F:
    CMPI.W  #$2328,D4
    BCC.W   LAB_0B15

    JSR     LAB_096D(PC)

    MOVEQ   #0,D0
    MOVE.W  D4,D0
    MOVE.L  D0,20(A7)
    JSR     LAB_0C03(PC)

    MOVE.L  20(A7),D1
    MOVE.B  D0,0(A3,D1.L)
    TST.B   D0
    BNE.S   LAB_0B11

    TST.W   D7
    BNE.S   LAB_0B10

    BRA.W   LAB_0B15

LAB_0B10:
    MOVEQ   #1,D0
    CMP.W   D0,D4
    BHI.W   LAB_0B15

LAB_0B11:
    MOVEQ   #0,D0
    MOVE.W  D4,D0
    MOVEQ   #20,D1
    CMP.B   0(A3,D0.L),D1
    BNE.S   LAB_0B13

    MOVEQ   #1,D0
    CMP.W   D0,D7
    BNE.S   LAB_0B13

    ADDQ.W  #1,D4
    MOVEQ   #0,D5

LAB_0B12:
    CMP.W   D6,D5
    BCC.S   LAB_0B0F

    JSR     LAB_096D(PC)

    MOVE.L  D4,D0
    ADDQ.W  #1,D4
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,20(A7)
    JSR     LAB_0C03(PC)

    MOVE.L  20(A7),D1
    MOVE.B  D0,0(A3,D1.L)
    ADDQ.W  #1,D5
    BRA.S   LAB_0B12

LAB_0B13:
    MOVEQ   #0,D0
    MOVE.W  D4,D0
    MOVEQ   #18,D1
    CMP.B   0(A3,D0.L),D1
    BNE.S   LAB_0B14

    MOVEQ   #1,D0
    CMP.W   D0,D7
    BNE.S   LAB_0B14

    ADDQ.W  #1,D4
    JSR     LAB_096D(PC)

    MOVE.L  D4,D0
    ADDQ.W  #1,D4
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,20(A7)
    JSR     LAB_0C03(PC)

    MOVE.L  20(A7),D1
    MOVE.B  D0,0(A3,D1.L)
    ADDQ.W  #1,-6(A5)
    CMPI.W  #$12e,-6(A5)
    BCS.W   LAB_0B0F

    MOVEQ   #0,D0
    BRA.S   LAB_0B16

LAB_0B14:
    ADDQ.W  #1,D4
    BRA.W   LAB_0B0F

LAB_0B15:
    JSR     LAB_096D(PC)

    JSR     LAB_0C03(PC)

    MOVE.B  D0,LAB_2253
    MOVE.L  D4,D0

LAB_0B16:
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======

LAB_0B17:
    LINK.W  A5,#-4
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 32(A7),A3
    MOVE.L  36(A7),D7
    TST.L   D7
    BLE.S   LAB_0B18

    CMPI.L  #$2328,D7
    BLT.S   LAB_0B19

LAB_0B18:
    MOVEQ   #0,D0
    BRA.W   LAB_0B21

LAB_0B19:
    MOVEQ   #0,D6
    MOVEQ   #0,D4

LAB_0B1A:
    CMP.L   D7,D6
    BGE.S   LAB_0B1B

    CMPI.L  #$2328,D6
    BGE.S   LAB_0B1B

    JSR     LAB_096D(PC)

    MOVEQ   #0,D0
    MOVE.W  D4,D0
    MOVE.L  D0,20(A7)
    JSR     LAB_0C03(PC)

    MOVE.L  20(A7),D1
    MOVE.B  D0,0(A3,D1.L)
    ADDQ.L  #1,D6
    ADDQ.W  #1,D4
    BRA.S   LAB_0B1A

LAB_0B1B:
    MOVEQ   #0,D0
    MOVE.W  D4,D0
    CLR.B   0(A3,D0.L)
    MOVE.L  A3,-(A7)
    JSR     LAB_0BFA(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D5
    MOVEQ   #0,D0
    MOVE.W  D4,D0
    MOVE.B  #$20,0(A3,D0.L)
    MOVEQ   #0,D6

LAB_0B1C:
    MOVEQ   #0,D0
    MOVE.W  D4,D0
    TST.B   -1(A3,D0.L)
    BEQ.S   LAB_0B1D

    CMP.L   D5,D6
    BGE.S   LAB_0B1D

    CMPI.W  #$2328,D4
    BCC.S   LAB_0B1D

    JSR     LAB_096D(PC)

    MOVEQ   #0,D0
    MOVE.W  D4,D0
    MOVE.L  D0,20(A7)
    JSR     LAB_0C03(PC)

    MOVE.L  20(A7),D1
    MOVE.B  D0,0(A3,D1.L)
    ADDQ.L  #1,D6
    ADDQ.W  #1,D4
    BRA.S   LAB_0B1C

LAB_0B1D:
    MOVEQ   #0,D0
    MOVE.W  D4,D0
    TST.B   -1(A3,D0.L)
    BNE.S   LAB_0B1E

    CMP.L   D5,D6
    BEQ.S   LAB_0B1F

LAB_0B1E:
    MOVEQ   #0,D4
    CLR.B   (A3)
    BRA.S   LAB_0B20

LAB_0B1F:
    JSR     LAB_096D(PC)

    JSR     LAB_0C03(PC)

    MOVE.B  D0,LAB_2253

LAB_0B20:
    MOVE.L  D4,D0

LAB_0B21:
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======

LAB_0B22:
    LINK.W  A5,#-40
    MOVEM.L D2-D3,-(A7)

    MOVEA.L LAB_229A,A0
    CLR.B   20(A0)
    MOVE.L  GLOB_LONG_PATCH_VERSION_NUMBER,-(A7)
    PEA     GLOB_STR_MAJOR_MINOR_VERSION_1
    PEA     LAB_1EFA
    PEA     -40(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    MOVEA.L LAB_229A,A0
    ADDQ.L  #1,A0
    MOVE.L  A0,(A7)
    PEA     -40(A5)
    JSR     LAB_0C76(PC)

    LEA     20(A7),A7
    TST.B   D0
    BEQ.W   LAB_0B25

    TST.W   LAB_2263
    BEQ.S   LAB_0B23

    TST.W   LAB_2252
    BEQ.W   LAB_0B25

LAB_0B23:
    MOVEA.L AbsExecBase,A6
    JSR     _LVODisable(A6)

    MOVE.W  #$100,LAB_1F45
    JSR     GCOMMAND_SeedBannerFromPrefs(PC)

    MOVEA.L AbsExecBase,A6
    JSR     _LVOEnable(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  #GLOB_REF_696_400_BITMAP,4(A0)
    CLR.W   LAB_2252
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVEQ   #60,D1
    MOVE.L  #679,D2
    MOVEQ   #100,D3
    NOT.B   D3
    JSR     _LVORectFill(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #3,D0
    JSR     _LVOSetAPen(A6)

    PEA     LAB_1EFC
    PEA     90.W
    PEA     30.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     JMP_TBL_DISPLAY_TEXT_AT_POSITION_1(PC)

    MOVE.L  GLOB_LONG_PATCH_VERSION_NUMBER,(A7)
    PEA     GLOB_STR_MAJOR_MINOR_VERSION_2
    PEA     LAB_1EFD
    PEA     -40(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    PEA     -40(A5)
    PEA     120.W
    PEA     30.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     JMP_TBL_DISPLAY_TEXT_AT_POSITION_1(PC)

    LEA     LAB_1EFF,A0
    LEA     -40(A5),A1
    MOVEQ   #4,D0

; Concatenate a string with an apostrophe before displaying
; the text at a 30,150
LAB_0B24:
    MOVE.L  (A0)+,(A1)+ ; Iterate copying A0 into A1 and...
    DBF     D0,LAB_0B24 ; incrementing both until A0 is null.

    CLR.B   (A1)
    MOVEA.L LAB_229A,A0
    ADDQ.L  #1,A0
    MOVE.L  A0,(A7)
    PEA     -40(A5)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_2(PC)

    PEA     GLOB_STR_APOSTROPHE
    PEA     -40(A5)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_2(PC)

    PEA     -40(A5)
    PEA     150.W
    PEA     30.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     JMP_TBL_DISPLAY_TEXT_AT_POSITION_1(PC)

    LEA     72(A7),A7

LAB_0B25:
    MOVEM.L (A7)+,D2-D3
    UNLK    A5
    RTS

;!======

LAB_0B26:
    LINK.W  A5,#-140
    MOVEM.L D2-D3/D5-D7,-(A7)
    MOVE.B  11(A5),D7
    MOVEQ   #-1,D5
    TST.W   LAB_2263
    BEQ.S   .LAB_0B27

    TST.W   LAB_2252
    BEQ.W   LAB_0B2E

.LAB_0B27:
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    SUBQ.W  #1,D0
    BLT.S   LAB_0B2A

    CMPI.W  #5,D0
    BGE.S   LAB_0B2A

    ADD.W   D0,D0
    MOVE.W  LAB_0B28(PC,D0.W),D0
    JMP     LAB_0B28+2(PC,D0.W)

; switch/jumptable
LAB_0B28:
    DC.W    LAB_0B29_0008-LAB_0B28-2
    DC.W    LAB_0B29_000C-LAB_0B28-2
    DC.W    LAB_0B29_0010-LAB_0B28-2
    DC.W    LAB_0B29_0014-LAB_0B28-2
    DC.W    LAB_0B29_0018-LAB_0B28-2

LAB_0B29_0008:
    MOVEQ   #1,D5
    BRA.S   LAB_0B2A

LAB_0B29_000C:
    MOVEQ   #2,D5
    BRA.S   LAB_0B2A

LAB_0B29_0010:
    MOVEQ   #8,D5
    BRA.S   LAB_0B2A

LAB_0B29_0014:
    MOVEQ   #9,D5
    BRA.S   LAB_0B2A

LAB_0B29_0018:
    MOVEQ   #10,D5

LAB_0B2A:
    TST.L   D5
    BLE.W   LAB_0B2E

    MOVEA.L AbsExecBase,A6
    JSR     _LVODisable(A6)

    MOVE.W  #$100,LAB_1F45
    JSR     GCOMMAND_SeedBannerFromPrefs(PC)

    MOVEA.L AbsExecBase,A6
    JSR     _LVOEnable(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  4(A0),-138(A5)
    MOVE.L  #GLOB_REF_696_400_BITMAP,4(A0)
    CLR.W   LAB_2252
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVEQ   #65,D1
    MOVE.L  #$2ac,D2
    MOVEQ   #40,D3
    NOT.B   D3
    JSR     _LVORectFill(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #3,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.B  28(A0),D6
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    PEA     GLB_STR_PLEASE_STANDBY_2
    PEA     90.W
    PEA     35.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     JMP_TBL_DISPLAY_TEXT_AT_POSITION_1(PC)

    PEA     GLOB_STR_ATTENTION_SYSTEM_ENGINEER_2
    PEA     120.W
    PEA     35.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     JMP_TBL_DISPLAY_TEXT_AT_POSITION_1(PC)

    MOVE.L  D5,(A7)
    PEA     GLOB_STR_REPORT_ERROR_CODE_FORMATTED
    PEA     -128(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    PEA     -128(A5)
    PEA     150.W
    PEA     35.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     JMP_TBL_DISPLAY_TEXT_AT_POSITION_1(PC)

    LEA     56(A7),A7
    MOVEQ   #9,D0
    CMP.L   D0,D5
    BEQ.S   LAB_0B2B

    MOVEQ   #10,D0
    CMP.L   D0,D5
    BNE.S   LAB_0B2C

LAB_0B2B:
    MOVE.L  BRUSH_SnapshotDepth,-(A7)   ; reuse cached brush dimensions in file dialog
    JSR     LAB_0BF4(PC)

    MOVE.L  D0,(A7)
    MOVE.L  BRUSH_SnapshotWidth,-(A7)
    PEA     BRUSH_SnapshotHeader
    PEA     GLOB_STR_FILE_WIDTH_COLORS_FORMATTED
    PEA     -128(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    LEA     20(A7),A7
    MOVE.W  #1,LAB_1B85
    BRA.S   LAB_0B2D

LAB_0B2C:
    PEA     BRUSH_SnapshotHeader
    PEA     GLOB_STR_FILE_PERCENT_S
    PEA     -128(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    LEA     12(A7),A7

LAB_0B2D:
    PEA     -128(A5)
    PEA     180.W
    PEA     35.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     JMP_TBL_DISPLAY_TEXT_AT_POSITION_1(PC)

    PEA     GLOB_STR_PRESS_ESC_TWICE_TO_RESUME_SCROLL
    PEA     210.W
    PEA     35.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     JMP_TBL_DISPLAY_TEXT_AT_POSITION_1(PC)

    LEA     32(A7),A7
    MOVE.L  D6,D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  -138(A5),4(A0)

LAB_0B2E:
    MOVEM.L (A7)+,D2-D3/D5-D7
    UNLK    A5
    RTS

;!======

LAB_0B2F:
    LINK.W  A5,#-8
    MOVEM.L D6-D7,-(A7)
    MOVEQ   #0,D7

LAB_0B30:
    MOVE.W  LAB_2231,D0
    CMP.W   D0,D7
    BGE.S   LAB_0B33

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2233,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    MOVEQ   #0,D6

LAB_0B31:
    MOVEQ   #6,D0
    CMP.W   D0,D6
    BGE.S   LAB_0B32

    MOVEA.L -4(A5),A0
    CLR.B   34(A0,D6.W)
    ADDQ.W  #1,D6
    BRA.S   LAB_0B31

LAB_0B32:
    ADDQ.W  #1,D7
    BRA.S   LAB_0B30

LAB_0B33:
    MOVEM.L (A7)+,D6-D7
    UNLK    A5
    RTS
