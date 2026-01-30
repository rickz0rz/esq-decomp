LAB_17D3:
    LINK.W  A5,#-8
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.B  15(A5),D7
    CLR.L   -8(A5)
    MOVEA.L A3,A0

LAB_17D4:
    TST.B   (A0)+
    BNE.S   LAB_17D4

    SUBQ.L  #1,A0
    SUBA.L  A3,A0
    MOVE.L  A0,D0
    MOVEA.L A3,A1
    ADDA.L  D0,A1
    SUBQ.L  #1,A1
    MOVE.L  A1,-4(A5)

LAB_17D5:
    MOVEA.L -4(A5),A0
    MOVE.B  (A0),D0
    CMP.B   D7,D0
    BNE.S   LAB_17D6

    MOVE.L  A0,-8(A5)
    BRA.S   LAB_17D7

LAB_17D6:
    SUBQ.L  #1,-4(A5)
    MOVEA.L -4(A5),A0
    CMPA.L  A3,A0
    BCC.S   LAB_17D5

LAB_17D7:
    MOVE.L  -8(A5),D0
    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======

LAB_17D8:
    LINK.W  A5,#-40
    MOVEM.L D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  16(A5),D7
    MOVE.L  24(A5),D6
    MOVEQ   #0,D5
    CLR.L   -34(A5)
    BTST    #0,D6
    BEQ.W   LAB_17DB

    BTST    #1,7(A2,D7.L)
    BEQ.W   LAB_17DB

    MOVE.L  D7,D0
    ASL.L   #2,D0
    MOVEA.L 56(A2,D0.L),A0
    PEA     34.W
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-12(A5)
    BSR.W   LAB_17D3

    ADDQ.W  #8,A7
    MOVE.L  D0,-28(A5)
    BEQ.W   LAB_17DB

    PEA     40.W
    MOVE.L  D0,-(A7)
    BSR.W   LAB_17D3

    ADDQ.W  #8,A7
    MOVE.L  D0,-16(A5)
    TST.L   D0
    BEQ.W   LAB_17DB

    PEA     41.W
    MOVE.L  D0,-(A7)
    BSR.W   LAB_17D3

    ADDQ.W  #8,A7
    MOVE.L  D0,-20(A5)
    TST.L   D0
    BEQ.W   LAB_17DB

    PEA     58.W
    MOVE.L  -16(A5),-(A7)
    BSR.W   LAB_17D3

    ADDQ.W  #8,A7
    MOVE.L  D0,-24(A5)
    TST.L   D0
    BEQ.S   LAB_17DB

    MOVEA.L D0,A0
    CLR.B   (A0)
    MOVEQ   #32,D0
    MOVEA.L -16(A5),A0
    CMP.B   1(A0),D0
    BNE.S   LAB_17D9

    LEA     2(A0),A1
    MOVE.L  A1,-(A7)
    JSR     LAB_1A23(PC)

    ADDQ.W  #4,A7
    MOVEA.L 20(A5),A0
    MOVE.L  D0,(A0)
    BRA.S   LAB_17DA

LAB_17D9:
    LEA     1(A0),A1
    MOVE.L  A1,-(A7)
    JSR     LAB_1A23(PC)

    ADDQ.W  #4,A7
    MOVEA.L 20(A5),A0
    MOVE.L  D0,(A0)

LAB_17DA:
    MOVEA.L -24(A5),A0
    MOVE.B  #$3a,(A0)
    MOVEA.L -20(A5),A0
    CLR.B   (A0)
    MOVEA.L -24(A5),A0
    ADDQ.L  #1,A0
    MOVE.L  A0,-(A7)
    JSR     LAB_1A23(PC)

    MOVEA.L 20(A5),A0
    MOVE.L  D0,4(A0)
    MOVEA.L -20(A5),A0
    MOVE.B  #$29,(A0)
    MOVE.L  -34(A5),D0
    BRA.W   LAB_17E5

LAB_17DB:
    MOVE.L  D7,D0
    ASL.L   #2,D0
    TST.L   56(A2,D0.L)
    BEQ.S   LAB_17DC

    ADDQ.L  #1,D7
    ADDQ.L  #1,-34(A5)

LAB_17DC:
    MOVEQ   #49,D0
    CMP.L   D0,D7
    BGE.S   LAB_17DF

    LEA     28(A3),A0
    MOVE.L  D7,-(A7)
    MOVE.L  A0,-(A7)
    JSR     GROUPD_JMP_TBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.S   LAB_17DE

    MOVE.L  D7,D0
    ASL.L   #2,D0
    TST.L   56(A2,D0.L)
    BEQ.S   LAB_17DD

    MOVEQ   #1,D5
    BRA.S   LAB_17DF

LAB_17DD:
    ADDQ.L  #1,D7
    ADDQ.L  #1,-34(A5)
    BRA.S   LAB_17DC

LAB_17DE:
    MOVEQ   #1,D5

LAB_17DF:
    TST.W   D5
    BNE.S   LAB_17E2

    MOVE.L  A2,-(A7)
    BSR.W   LAB_17E6

    ADDQ.W  #4,A7
    MOVE.L  D0,-38(A5)
    ADDQ.L  #1,D0
    BEQ.S   LAB_17E2

    MOVE.L  -38(A5),D0
    ASL.L   #2,D0
    LEA     LAB_2235,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    LEA     LAB_2237,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-8(A5)
    MOVEQ   #1,D7

LAB_17E0:
    MOVEQ   #49,D0
    CMP.L   D0,D7
    BGE.S   LAB_17E2

    MOVEA.L -4(A5),A0
    ADDA.W  #$1c,A0
    MOVE.L  D7,-(A7)
    MOVE.L  A0,-(A7)
    JSR     GROUPD_JMP_TBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.S   LAB_17E2

    MOVE.L  D7,D0
    ASL.L   #2,D0
    MOVEA.L -8(A5),A0
    TST.L   56(A0,D0.L)
    BEQ.S   LAB_17E1

    BTST    #7,7(A0,D7.L)
    BEQ.S   LAB_17E2

LAB_17E1:
    ADDQ.L  #1,D7
    ADDQ.L  #1,-34(A5)
    BRA.S   LAB_17E0

LAB_17E2:
    BTST    #0,D6
    BEQ.S   LAB_17E4

    MOVE.L  -34(A5),D0
    MOVE.L  D0,D1
    TST.L   D1
    BPL.S   LAB_17E3

    ADDQ.L  #1,D1

LAB_17E3:
    ASR.L   #1,D1
    MOVEA.L 20(A5),A0
    MOVE.L  D1,(A0)
    MOVEQ   #2,D1
    JSR     LAB_1A07(PC)

    MOVEQ   #30,D0
    JSR     LAB_1A06(PC)

    MOVE.L  D0,4(A0)

LAB_17E4:
    MOVE.L  -34(A5),D0

LAB_17E5:
    MOVEM.L -60(A5),D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

    MOVEM.L D7/A2-A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVEA.L 20(A7),A2
    MOVE.L  24(A7),D7
    CLR.L   -(A7)
    CLR.L   -(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_17D8

    LEA     20(A7),A7
    MOVEM.L (A7)+,D7/A2-A3
    RTS

;!======

LAB_17E6:
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVEQ   #-1,D6
    MOVEQ   #0,D7

LAB_17E7:
    MOVEQ   #0,D0
    MOVE.W  LAB_222F,D0
    CMP.L   D0,D7
    BGE.S   LAB_17E9

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2237,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  A1,-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_1902(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   LAB_17E8

    MOVE.L  D7,D6
    BRA.S   LAB_17E9

LAB_17E8:
    ADDQ.L  #1,D7
    BRA.S   LAB_17E7

LAB_17E9:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======

LAB_17EA:
    LINK.W  A5,#-24
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVEA.L 16(A5),A2
    MOVEQ   #0,D6
    MOVE.L  A3,D0
    BEQ.S   LAB_17EB

    MOVE.L  D7,D0
    ASL.L   #2,D0
    MOVEA.L 56(A3,D0.L),A0
    BRA.S   LAB_17EC

LAB_17EB:
    SUBA.L  A0,A0

LAB_17EC:
    MOVE.L  A0,-4(A5)
    BEQ.W   LAB_17F0

    PEA     40.W
    MOVE.L  A0,-(A7)
    JSR     LAB_1979(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    TST.L   D0
    BEQ.W   LAB_17F0

    PEA     58.W
    MOVE.L  D0,-(A7)
    JSR     LAB_1979(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-16(A5)
    TST.L   D0
    BEQ.W   LAB_17F0

    PEA     41.W
    MOVE.L  D0,-(A7)
    JSR     LAB_1979(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-12(A5)
    TST.L   D0
    BEQ.S   LAB_17F0

    PEA     34.W
    MOVE.L  -4(A5),-(A7)
    JSR     LAB_1979(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-20(A5)
    BEQ.S   LAB_17ED

    MOVEA.L -12(A5),A0
    CMPA.L  D0,A0
    BCC.S   LAB_17F0

LAB_17ED:
    MOVEA.L -16(A5),A0
    CLR.B   (A0)
    MOVEQ   #32,D0
    MOVEA.L -8(A5),A0
    CMP.B   1(A0),D0
    BNE.S   LAB_17EE

    LEA     2(A0),A1
    MOVE.L  A1,-(A7)
    JSR     LAB_1A23(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,(A2)
    BRA.S   LAB_17EF

LAB_17EE:
    LEA     1(A0),A1
    MOVE.L  A1,-(A7)
    JSR     LAB_1A23(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,(A2)

LAB_17EF:
    MOVEA.L -16(A5),A0
    MOVE.B  #$3a,(A0)
    MOVEA.L -12(A5),A0
    CLR.B   (A0)
    MOVEA.L -16(A5),A0
    ADDQ.L  #1,A0
    MOVE.L  A0,-(A7)
    JSR     LAB_1A23(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,4(A2)
    MOVEA.L -12(A5),A0
    MOVE.B  #$29,(A0)
    MOVEQ   #1,D6

LAB_17F0:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_17F1:
    LINK.W  A5,#-36
    MOVEM.L D2-D3/D5-D7/A2-A3/A6,-(A7)
    MOVE.W  10(A5),D7
    MOVEA.L 12(A5),A3
    MOVE.L  16(A5),D6
    MOVE.L  20(A5),D5
    MOVEA.L 24(A5),A2
    LEA     LAB_2274,A0
    LEA     LAB_237B,A1
    MOVEA.L A1,A6
    MOVEQ   #4,D0

LAB_17F2:
    MOVE.L  (A0)+,(A6)+
    DBF     D0,LAB_17F2
    MOVE.W  (A0),(A6)
    MOVE.W  LAB_237C,D0
    MOVEQ   #12,D1
    CMP.W   D1,D0
    BNE.S   LAB_17F3

    MOVE.W  LAB_237D,D2
    BEQ.S   LAB_17F4

LAB_17F3:
    MOVEQ   #5,D2
    CMP.W   D2,D0
    BGE.S   LAB_17FD

    MOVE.W  LAB_237D,D0
    BNE.S   LAB_17FD

LAB_17F4:
    MOVE.L  D5,D0
    MOVEQ   #39,D2
    SUB.L   D2,D0
    TST.L   D0
    BPL.S   LAB_17F5

    ADDQ.L  #1,D0

LAB_17F5:
    ASR.L   #1,D0
    MOVE.W  D0,-32(A5)
    MOVEQ   #38,D0
    CMP.L   D0,D5
    BLE.S   LAB_17F9

    MOVE.L  D5,D0
    MOVEQ   #1,D3
    AND.L   D3,D0
    SUBQ.L  #1,D0
    BNE.S   LAB_17F6

    MOVEQ   #0,D0
    MOVE.W  D0,-34(A5)
    BRA.S   LAB_17F7

LAB_17F6:
    MOVEQ   #30,D0
    MOVE.W  D0,-34(A5)

LAB_17F7:
    MOVE.L  D5,D0
    SUB.L   D2,D0
    TST.L   D0
    BPL.S   LAB_17F8

    ADDQ.L  #1,D0

LAB_17F8:
    ASR.L   #1,D0
    MOVE.W  D0,-32(A5)
    BRA.S   LAB_1801

LAB_17F9:
    MOVE.L  D5,D0
    MOVEQ   #1,D3
    AND.L   D3,D0
    SUBQ.L  #1,D0
    BNE.S   LAB_17FA

    MOVEQ   #0,D0
    MOVE.W  D0,-34(A5)
    BRA.S   LAB_17FB

LAB_17FA:
    MOVE.W  #$ffe2,-34(A5)

LAB_17FB:
    SUB.L   D5,D2
    TST.L   D2
    BPL.S   LAB_17FC

    ADDQ.L  #1,D2

LAB_17FC:
    ASR.L   #1,D2
    NEG.L   D2
    MOVE.W  D2,-32(A5)
    BRA.S   LAB_1801

LAB_17FD:
    MOVE.L  D5,D0
    MOVEQ   #1,D2
    AND.L   D2,D0
    SUBQ.L  #1,D0
    BNE.S   LAB_17FE

    MOVEQ   #0,D0
    MOVE.W  D0,-34(A5)
    BRA.S   LAB_17FF

LAB_17FE:
    MOVEQ   #30,D0
    MOVE.W  D0,-34(A5)

LAB_17FF:
    MOVE.L  D5,D2
    SUBQ.L  #1,D2
    TST.L   D2
    BPL.S   LAB_1800

    ADDQ.L  #1,D2

LAB_1800:
    ASR.L   #1,D2
    ADDQ.L  #5,D2
    MOVE.W  D2,-32(A5)

LAB_1801:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVEQ   #0,D2
    MOVE.B  LAB_2230,D2
    CMP.L   D2,D0
    BEQ.S   LAB_1802

    MOVEQ   #24,D0
    ADD.W   D0,-32(A5)

LAB_1802:
    LEA     -30(A5),A0
    MOVEQ   #4,D0

LAB_1803:
    MOVE.L  (A1)+,(A0)+
    DBF     D0,LAB_1803
    MOVE.W  (A1),(A0)
    MOVE.W  D1,-22(A5)
    MOVEQ   #0,D0
    MOVE.W  D0,-20(A5)
    MOVE.W  D0,-12(A5)
    MOVE.W  -32(A5),D0
    EXT.L   D0
    MOVE.W  -34(A5),D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -30(A5)
    JSR     GROUPD_JMP_TBL_LAB_0656(PC)

    LEA     12(A7),A7
    MOVE.W  -24(A5),D0
    EXT.L   D0
    MOVE.L  D0,(A2)
    MOVE.W  -28(A5),D0
    EXT.L   D0
    MOVE.L  D0,4(A2)
    MOVE.W  -26(A5),D0
    EXT.L   D0
    MOVE.L  D0,8(A2)
    MOVE.W  -22(A5),D0
    EXT.L   D0
    MOVEA.L 28(A5),A0
    MOVE.L  D0,(A0)
    MOVE.W  -20(A5),D1
    EXT.L   D1
    MOVE.L  D1,4(A0)
    MOVEQ   #12,D0
    CMP.L   (A0),D0
    BNE.S   LAB_1804

    MOVE.W  -12(A5),D1
    BNE.S   LAB_1804

    MOVEQ   #0,D2
    MOVE.L  D2,(A0)
    BRA.S   LAB_1805

LAB_1804:
    MOVE.L  (A0),D1
    CMP.L   D0,D1
    BGE.S   LAB_1805

    MOVE.W  -12(A5),D2
    ADDQ.W  #1,D2
    BNE.S   LAB_1805

    MOVEQ   #12,D0
    ADD.L   D0,(A0)

LAB_1805:
    MOVE.L  A3,D0
    BEQ.S   LAB_1806

    PEA     -8(A5)
    MOVE.L  D6,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_17EA

    LEA     12(A7),A7
    MOVE.W  D0,-36(A5)
    BRA.S   LAB_1807

LAB_1806:
    MOVEQ   #0,D0
    MOVE.W  D0,-36(A5)

LAB_1807:
    TST.W   D0
    BEQ.S   LAB_1808

    MOVE.L  -4(A5),D0
    MOVEA.L 28(A5),A0
    CMP.L   4(A0),D0
    BLE.S   LAB_1808

    MOVE.L  D0,4(A0)

LAB_1808:
    MOVEM.L (A7)+,D2-D3/D5-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

GROUPD_JMP_TBL_LAB_0656:
    JMP     LAB_0656

GROUPD_JMP_TBL_ESQ_TestBit1Based:
    JMP     ESQ_TestBit1Based

;!======

    ; Alignment
    RTS
    DC.W    $0000
