LAB_18D7:
    LINK.W  A5,#-16
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3

    MOVE.B  (A3)+,D6
    MOVE.B  (A3)+,D5
    MOVE.B  (A3)+,D4
    ADDQ.L  #1,A3
    MOVEQ   #2,D0
    CMP.B   D0,D4
    BCS.S   .LAB_18D8

    MOVEQ   #6,D0
    CMP.B   D0,D4
    BLS.S   .LAB_18D9

.LAB_18D8:
    MOVEQ   #1,D4

.LAB_18D9:
    MOVEQ   #0,D7

.LAB_18DA:
    MOVE.B  (A3)+,D0
    MOVE.B  D0,-16(A5,D7.W)
    MOVEQ   #18,D1
    CMP.B   D1,D0
    BEQ.S   .LAB_18DB

    MOVEQ   #10,D0
    CMP.W   D0,D7
    BGE.S   .LAB_18DB

    ADDQ.W  #1,D7
    BRA.S   .LAB_18DA

.LAB_18DB:
    MOVEQ   #0,D0
    MOVE.B  D0,-16(A5,D7.W)
    MOVE.B  -16(A5),D1
    TST.B   D1
    BEQ.S   .return

    PEA     -16(A5)
    PEA     LAB_2245
    JSR     LAB_1902(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   .return

    MOVE.L  LAB_1DEC,-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_1905(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_1DEC
    MOVE.B  D6,LAB_227F
    MOVE.B  D5,LAB_229B
    MOVE.B  D4,LAB_229C
    TST.W   LAB_2252
    BEQ.S   .return

    MOVE.L  LAB_1DEC,-(A7)
    PEA     172.W
    CLR.L   -(A7)
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     JMP_TBL_DISPLAY_TEXT_AT_POSITION_2(PC)

    LEA     16(A7),A7

.return:
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======

LAB_18DD:
    LINK.W  A5,#-36
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3

    MOVEQ   #0,D7

.LAB_18DE:
    MOVE.B  (A3)+,D0
    MOVE.B  D0,-15(A5,D7.W)
    MOVEQ   #18,D1
    CMP.B   D1,D0
    BEQ.S   .LAB_18DF

    MOVEQ   #10,D0
    CMP.W   D0,D7
    BGE.S   .LAB_18DF

    ADDQ.W  #1,D7
    BRA.S   .LAB_18DE

.LAB_18DF:
    MOVEQ   #0,D0
    MOVE.B  D0,-15(A5,D7.W)
    MOVE.B  -15(A5),D1
    TST.B   D1
    BEQ.W   .return

    PEA     -15(A5)
    PEA     LAB_2246
    JSR     LAB_1902(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.W   .return

    MOVEQ   #0,D7

.LAB_18E0:
    MOVEQ   #4,D0
    CMP.W   D0,D7
    BGE.S   .LAB_18E1

    MOVE.L  D7,D0
    MULS    #20,D0
    LEA     LAB_2197,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEQ   #1,D1
    MOVE.L  D1,16(A1)
    MOVE.W  LAB_227C,D1
    ADD.W   D7,D1
    MOVE.L  D1,D6
    ADDQ.W  #1,D6
    ADDA.L  D0,A0
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.W  LAB_2277,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,28(A7)
    JSR     LAB_1903(PC)

    ADDQ.W  #8,A7
    EXT.L   D0
    MOVEA.L 20(A7),A0
    MOVE.L  D0,(A0)
    ADDQ.W  #1,D7
    BRA.S   .LAB_18E0

.LAB_18E1:
    MOVE.B  (A3)+,LAB_2196
    MOVE.B  (A3)+,D5

.LAB_18E2:
    MOVEQ   #43,D0
    CMP.B   D0,D5
    BNE.W   .return

    PEA     3.W
    MOVE.L  A3,-(A7)
    PEA     -25(A5)
    JSR     LAB_1955(PC)

    CLR.B   -22(A5)
    PEA     -25(A5)
    JSR     LAB_1A23(PC)

    LEA     16(A7),A7
    MOVE.L  D0,D6
    ADDQ.L  #3,A3
    MOVEQ   #0,D4

.LAB_18E3:
    MOVE.L  D4,D0
    MOVEQ   #20,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_2197,A0
    ADDA.L  D0,A0
    MOVE.L  D6,D0
    EXT.L   D0
    CMP.L   (A0),D0
    BEQ.S   .LAB_18E4

    MOVEQ   #4,D0
    CMP.L   D0,D4
    BGE.S   .LAB_18E4

    ADDQ.L  #1,D4
    BRA.S   .LAB_18E3

.LAB_18E4:
    TST.L   D4
    BMI.S   .LAB_18E5

    MOVEQ   #3,D0
    CMP.L   D0,D4
    BLE.S   .LAB_18E6

.LAB_18E5:
    MOVEQ   #0,D5

.LAB_18E6:
    MOVEQ   #43,D0
    CMP.B   D0,D5
    BNE.W   .LAB_18ED

    MOVE.L  D4,D0
    MOVEQ   #20,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_2197,A0
    ADDA.L  D0,A0
    CLR.L   16(A0)
    PEA     1.W
    MOVE.L  A3,-(A7)
    PEA     -25(A5)
    JSR     LAB_1955(PC)

    LEA     12(A7),A7
    CLR.B   -24(A5)
    MOVE.B  -25(A5),D0
    MOVEQ   #63,D1
    CMP.B   D1,D0
    BNE.S   .LAB_18E7

    MOVE.L  D4,D0
    MOVEQ   #20,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_2197,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEQ   #1,D0
    MOVE.L  D0,4(A1)
    BRA.S   .LAB_18E8

.LAB_18E7:
    MOVE.L  D4,D0
    MOVEQ   #20,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_2197,A0
    ADDA.L  D0,A0
    PEA     -25(A5)
    MOVE.L  A0,24(A7)
    JSR     LAB_1A23(PC)

    ADDQ.W  #4,A7
    MOVEA.L 20(A7),A0
    MOVE.L  D0,4(A0)

.LAB_18E8:
    ADDQ.L  #1,A3
    PEA     3.W
    MOVE.L  A3,-(A7)
    PEA     -25(A5)
    JSR     LAB_1955(PC)

    LEA     12(A7),A7
    CLR.B   -22(A5)
    MOVE.B  -25(A5),D0
    MOVEQ   #63,D1
    CMP.B   D1,D0
    BNE.S   .LAB_18E9

    MOVE.L  D4,D0
    MOVEQ   #20,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_2197,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  #(-999),8(A1)
    BRA.S   .LAB_18EA

.LAB_18E9:
    MOVE.L  D4,D0
    MOVEQ   #20,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_2197,A0
    ADDA.L  D0,A0
    PEA     -25(A5)
    MOVE.L  A0,24(A7)
    JSR     LAB_1A23(PC)

    ADDQ.W  #4,A7
    MOVEA.L 20(A7),A0
    MOVE.L  D0,8(A0)

.LAB_18EA:
    ADDQ.L  #3,A3
    PEA     3.W
    MOVE.L  A3,-(A7)
    PEA     -25(A5)
    JSR     LAB_1955(PC)

    LEA     12(A7),A7
    CLR.B   -22(A5)
    MOVE.B  -25(A5),D0
    MOVEQ   #63,D1
    CMP.B   D1,D0
    BNE.S   .LAB_18EB

    MOVE.L  D4,D0
    MOVEQ   #20,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_2197,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  #(-999),12(A1)
    BRA.S   .LAB_18EC

.LAB_18EB:
    MOVE.L  D4,D0
    MOVEQ   #20,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_2197,A0
    ADDA.L  D0,A0
    PEA     -25(A5)
    MOVE.L  A0,24(A7)
    JSR     LAB_1A23(PC)

    ADDQ.W  #4,A7
    MOVEA.L 20(A7),A0
    MOVE.L  D0,12(A0)

.LAB_18EC:
    ADDQ.L  #3,A3
    MOVE.B  (A3)+,D5
    BRA.W   .LAB_18E2

.LAB_18ED:
    ADDQ.L  #7,A3
    MOVE.B  (A3)+,D5
    BRA.W   .LAB_18E2

.return:
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======

LAB_18EF:
    MOVE.L  D7,-(A7)

    MOVE.B  11(A7),D7
    MOVE.W  LAB_2285,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2285
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_229A,-(A7)
    JSR     LAB_1900(PC)

    MOVE.W  D0,LAB_2232
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEQ   #0,D1
    MOVE.W  LAB_2232,D1
    MOVE.L  D1,(A7)
    MOVE.L  LAB_229A,-(A7)
    MOVE.L  D0,-(A7)
    JSR     JMP_TBL_GENERATE_CHECKSUM_BYTE_INTO_D0_2(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  LAB_2253,D1
    CMP.L   D1,D0
    BNE.S   .LAB_18F0

    MOVE.L  LAB_229A,-(A7)
    BSR.W   LAB_18D7

    ADDQ.W  #4,A7
    BRA.S   .return

.LAB_18F0:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======

LAB_18F2:
    MOVE.L  D7,-(A7)

    MOVE.B  11(A7),D7
    MOVE.W  LAB_2285,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2285
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_229A,-(A7)
    JSR     LAB_1900(PC)

    MOVE.W  D0,LAB_2232
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEQ   #0,D1
    MOVE.W  LAB_2232,D1
    MOVE.L  D1,(A7)
    MOVE.L  LAB_229A,-(A7)
    MOVE.L  D0,-(A7)
    JSR     JMP_TBL_GENERATE_CHECKSUM_BYTE_INTO_D0_2(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  LAB_2253,D1
    CMP.L   D1,D0
    BNE.S   .LAB_18F3

    MOVE.L  LAB_229A,-(A7)
    BSR.W   LAB_18DD

    ADDQ.W  #4,A7
    BRA.S   .return

.LAB_18F3:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======

LAB_18F5:
    LINK.W  A5,#-16
    MOVEM.L D2/D7/A3,-(A7)
    MOVEA.L 8(A5),A3

    MOVEQ   #0,D0
    MOVE.B  (A3)+,D0
    MOVE.W  D0,LAB_229D
    MOVEQ   #48,D1
    CMP.W   D1,D0
    BLT.S   .LAB_18F6

    MOVEQ   #57,D2
    CMP.W   D2,D0
    BLE.S   .LAB_18F7

.LAB_18F6:
    MOVE.W  D1,LAB_229D

.LAB_18F7:
    MOVEQ   #0,D7

.LAB_18F8:
    MOVE.B  (A3)+,D0
    MOVE.B  D0,-13(A5,D7.W)
    MOVEQ   #18,D1
    CMP.B   D1,D0
    BEQ.S   .LAB_18F9

    MOVEQ   #10,D0
    CMP.W   D0,D7
    BGE.S   .LAB_18F9

    ADDQ.W  #1,D7
    BRA.S   .LAB_18F8

.LAB_18F9:
    CLR.B   -13(A5,D7.W)
    LEA     -13(A5),A0
    LEA     LAB_2245,A1

.LAB_18FA:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .LAB_18FA

    MOVE.L  LAB_1DD9,-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_1905(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_1DD9
    TST.W   LAB_2252
    BEQ.S   .return

    MOVE.L  D0,-(A7)
    PEA     172.W
    CLR.L   -(A7)
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     JMP_TBL_DISPLAY_TEXT_AT_POSITION_2(PC)

    LEA     16(A7),A7

.return:
    MOVEM.L (A7)+,D2/D7/A3
    UNLK    A5
    RTS

;!======

LAB_18FC:
    LINK.W  A5,#-16
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEQ   #0,D7

.LAB_18FD:
    MOVE.B  (A3)+,D0
    MOVE.B  D0,-13(A5,D7.W)
    MOVEQ   #18,D1
    CMP.B   D1,D0
    BEQ.S   .LAB_18FE

    MOVEQ   #10,D0
    CMP.W   D0,D7
    BGE.S   .LAB_18FE

    ADDQ.W  #1,D7
    BRA.S   .LAB_18FD

.LAB_18FE:
    CLR.B   -13(A5,D7.W)
    LEA     -13(A5),A0
    LEA     LAB_2246,A1

.LAB_18FF:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .LAB_18FF

    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======

LAB_1900:
    JMP     LAB_0B0E

JMP_TBL_DISPLAY_TEXT_AT_POSITION_2:
    JMP     DISPLAY_TEXT_AT_POSITION

LAB_1902:
    JMP     ESQ_WildcardMatch

LAB_1903:
    JMP     LAB_0631

JMP_TBL_GENERATE_CHECKSUM_BYTE_INTO_D0_2:
    JMP     GENERATE_CHECKSUM_BYTE_INTO_D0

LAB_1905:
    JMP     LAB_0B44

;!======

    ; Alignment
    RTS
    DC.W    $0000
