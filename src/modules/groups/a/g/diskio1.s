; Unreachable Code?
    LINK.W  A5,#-36
    MOVEM.L D2-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  D7,-(A7)
    PEA     LAB_1BED
    JSR     LAB_066D(PC)

    MOVEQ   #0,D0
    MOVE.B  (A3),D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_1BEE
    JSR     LAB_066D(PC)

    LEA     1(A3),A0
    MOVE.L  A0,(A7)
    PEA     LAB_1BEF
    JSR     LAB_066D(PC)

    LEA     12(A3),A0
    MOVE.L  A0,(A7)
    PEA     LAB_1BF0
    JSR     LAB_066D(PC)

    LEA     19(A3),A0
    MOVE.L  A0,(A7)
    PEA     LAB_1BF1
    JSR     LAB_066D(PC)

    MOVEQ   #0,D0
    MOVE.B  27(A3),D0
    MOVE.L  D0,(A7)
    PEA     LAB_1BF2
    JSR     LAB_066D(PC)

    LEA     32(A7),A7
    MOVEQ   #1,D0
    CMP.B   27(A3),D0
    BNE.S   LAB_0420

    PEA     LAB_1BF3
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7

LAB_0420:
    BTST    #1,27(A3)
    BEQ.S   LAB_0421

    PEA     LAB_1BF4
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7

LAB_0421:
    BTST    #2,27(A3)
    BEQ.S   LAB_0422

    PEA     LAB_1BF5
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7

LAB_0422:
    BTST    #3,27(A3)
    BEQ.S   LAB_0423

    PEA     LAB_1BF6
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7

LAB_0423:
    BTST    #4,27(A3)
    BEQ.S   LAB_0424

    PEA     LAB_1BF7
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7

LAB_0424:
    BTST    #5,27(A3)
    BEQ.S   LAB_0425

    PEA     LAB_1BF8
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7

LAB_0425:
    BTST    #6,27(A3)
    BEQ.S   LAB_0426

    PEA     LAB_1BF9
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7

LAB_0426:
    BTST    #7,27(A3)
    BEQ.S   LAB_0427

    PEA     LAB_1BFA
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7

LAB_0427:
    PEA     LAB_1BFB
    JSR     LAB_066D(PC)

    MOVEQ   #0,D0
    MOVE.B  28(A3),D0
    MOVEQ   #0,D1
    MOVE.B  29(A3),D1
    MOVEQ   #0,D2
    MOVE.B  30(A3),D2
    MOVEQ   #0,D3
    MOVE.B  31(A3),D3
    MOVE.L  D0,32(A7)
    MOVEQ   #0,D0
    MOVE.B  32(A3),D0
    MOVE.L  D0,48(A7)
    MOVEQ   #0,D0
    MOVE.B  33(A3),D0
    MOVE.L  D0,(A7)
    MOVE.L  48(A7),-(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  48(A7),-(A7)
    PEA     LAB_1BFC
    JSR     LAB_066D(PC)

    LEA     28(A7),A7
    MOVEQ   #0,D5
    MOVEQ   #0,D6

LAB_0428:
    MOVEQ   #6,D0
    CMP.L   D0,D6
    BGE.S   LAB_0429

    MOVEQ   #0,D0
    MOVE.B  28(A3,D6.L),D0
    ADD.L   D0,D5
    ADDQ.L  #1,D6
    BRA.S   LAB_0428

LAB_0429:
    CMPI.L  #$5fa,D5
    BNE.S   LAB_042A

    PEA     LAB_1BFD
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7
    BRA.S   LAB_042F

LAB_042A:
    TST.L   D5
    BNE.S   LAB_042B

    PEA     GLOB_STR_OFF_AIR_2
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7
    BRA.S   LAB_042F

LAB_042B:
    PEA     LAB_1BFF
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7
    MOVEQ   #1,D4

LAB_042C:
    MOVEQ   #49,D0
    CMP.B   D0,D4
    BCC.S   LAB_042E

    LEA     28(A3),A0
    MOVEQ   #0,D0
    MOVE.B  D4,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BEQ.S   LAB_042D

    MOVEQ   #0,D0
    MOVE.B  D4,D0
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    MOVEA.L GLOB_REF_STR_CLOCK_FORMAT,A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-(A7)
    PEA     LAB_1C00
    JSR     LAB_066D(PC)

    ADDQ.W  #8,A7

LAB_042D:
    ADDQ.B  #1,D4
    BRA.S   LAB_042C

LAB_042E:
    PEA     LAB_1C01
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7

LAB_042F:
    MOVEQ   #0,D0
    MOVE.B  34(A3),D0
    MOVEQ   #0,D1
    MOVE.B  35(A3),D1
    MOVEQ   #0,D2
    MOVE.B  36(A3),D2
    MOVEQ   #0,D3
    MOVE.B  37(A3),D3
    MOVE.L  D0,28(A7)
    MOVEQ   #0,D0
    MOVE.B  38(A3),D0
    MOVE.L  D0,44(A7)
    MOVEQ   #0,D0
    MOVE.B  39(A3),D0
    MOVE.L  D0,-(A7)
    MOVE.L  48(A7),-(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  48(A7),-(A7)
    PEA     LAB_1C02
    JSR     LAB_066D(PC)

    LEA     28(A7),A7
    MOVEQ   #0,D5
    MOVEQ   #0,D6

LAB_0430:
    MOVEQ   #6,D0
    CMP.L   D0,D6
    BGE.S   LAB_0431

    MOVEQ   #0,D0
    MOVE.B  34(A3,D6.L),D0
    ADD.L   D0,D5
    ADDQ.L  #1,D6
    BRA.S   LAB_0430

LAB_0431:
    TST.L   D5
    BNE.S   LAB_0432

    PEA     LAB_1C03
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7
    BRA.S   LAB_0437

LAB_0432:
    CMPI.L  #$5fa,D5
    BNE.S   LAB_0433

    PEA     LAB_1C04
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7
    BRA.S   LAB_0437

LAB_0433:
    PEA     LAB_1C05
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7
    MOVEQ   #1,D4

LAB_0434:
    MOVEQ   #49,D0
    CMP.B   D0,D4
    BCC.S   LAB_0436

    LEA     34(A3),A0
    MOVEQ   #0,D0
    MOVE.B  D4,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.S   LAB_0435

    MOVEQ   #0,D0
    MOVE.B  D4,D0
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    MOVEA.L GLOB_REF_STR_CLOCK_FORMAT,A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-(A7)
    PEA     LAB_1C06
    JSR     LAB_066D(PC)

    ADDQ.W  #8,A7

LAB_0435:
    ADDQ.B  #1,D4
    BRA.S   LAB_0434

LAB_0436:
    PEA     LAB_1C07
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7

LAB_0437:
    MOVEQ   #0,D0
    MOVE.B  40(A3),D0
    MOVEQ   #0,D1
    MOVE.W  46(A3),D1
    MOVEQ   #0,D2
    MOVE.B  41(A3),D2
    MOVEQ   #0,D3
    MOVE.B  42(A3),D3
    LEA     43(A3),A0
    MOVE.L  A0,-(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_1C08
    JSR     LAB_066D(PC)

    MOVE.L  48(A3),D0
    MOVE.L  D0,(A7)
    PEA     LAB_1C09
    JSR     LAB_066D(PC)

    LEA     28(A7),A7
    TST.L   48(A3)
    BEQ.W   LAB_0438

    MOVE.L  48(A3),-14(A5)
    PEA     LAB_1C0A
    JSR     LAB_066D(PC)

    MOVE.L  -14(A5),(A7)
    PEA     LAB_1C0B
    JSR     LAB_066D(PC)

    MOVEA.L -14(A5),A1
    MOVEA.L 4(A1),A0
    MOVE.L  A0,(A7)
    MOVE.L  A0,-(A7)
    PEA     LAB_1C0C
    JSR     LAB_066D(PC)

    MOVEA.L -14(A5),A1
    MOVEA.L 8(A1),A0
    MOVE.L  A0,(A7)
    MOVE.L  A0,-(A7)
    PEA     LAB_1C0D
    JSR     LAB_066D(PC)

    MOVEA.L -14(A5),A1
    MOVEA.L 12(A1),A0
    MOVE.L  A0,(A7)
    MOVE.L  A0,-(A7)
    PEA     LAB_1C0E
    JSR     LAB_066D(PC)

    MOVEA.L -14(A5),A1
    MOVEA.L 16(A1),A0
    MOVE.L  A0,(A7)
    MOVE.L  A0,-(A7)
    PEA     LAB_1C0F
    JSR     LAB_066D(PC)

    MOVEA.L -14(A5),A1
    MOVEA.L 20(A1),A0
    MOVE.L  A0,(A7)
    MOVE.L  A0,-(A7)
    PEA     LAB_1C10
    JSR     LAB_066D(PC)

    MOVEA.L -14(A5),A0
    MOVE.W  36(A0),D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    PEA     LAB_1C11
    JSR     LAB_066D(PC)

    MOVEA.L -14(A5),A0
    MOVE.L  38(A0),(A7)
    PEA     LAB_1C12
    JSR     LAB_066D(PC)

    LEA     56(A7),A7

LAB_0438:
    MOVEM.L (A7)+,D2-D7/A3
    UNLK    A5
    RTS

;!======

LAB_0439:
    MOVEM.L D2-D5/D7/A2-A3,-(A7)
    MOVEA.L 32(A7),A3
    MOVE.L  36(A7),D7
    MOVE.L  D7,-(A7)
    PEA     LAB_1C13
    JSR     LAB_066D(PC)

    MOVEQ   #0,D0
    MOVE.B  (A3),D0
    LEA     1(A3),A0
    LEA     12(A3),A1
    LEA     19(A3),A2
    MOVE.L  A2,(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_1C14
    JSR     LAB_066D(PC)

    PEA     LAB_1C15
    JSR     LAB_066D(PC)

    LEA     28(A7),A7
    MOVEQ   #1,D0
    CMP.B   27(A3),D0
    BNE.S   LAB_043A

    PEA     LAB_1C16
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7

LAB_043A:
    BTST    #1,27(A3)
    BEQ.S   LAB_043B

    PEA     LAB_1C17
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7

LAB_043B:
    BTST    #2,27(A3)
    BEQ.S   LAB_043C

    PEA     LAB_1C18
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7

LAB_043C:
    BTST    #3,27(A3)
    BEQ.S   LAB_043D

    PEA     LAB_1C19
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7

LAB_043D:
    BTST    #4,27(A3)
    BEQ.S   LAB_043E

    PEA     LAB_1C1A
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7

LAB_043E:
    BTST    #5,27(A3)
    BEQ.S   LAB_043F

    PEA     LAB_1C1B
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7

LAB_043F:
    BTST    #6,27(A3)
    BEQ.S   LAB_0440

    PEA     LAB_1C1C
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7

LAB_0440:
    BTST    #7,27(A3)
    BEQ.S   LAB_0441

    PEA     LAB_1C1D
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7

LAB_0441:
    PEA     LAB_1C1E
    JSR     LAB_066D(PC)

    MOVEQ   #0,D0
    MOVE.B  28(A3),D0
    MOVEQ   #0,D1
    MOVE.B  29(A3),D1
    MOVEQ   #0,D2
    MOVE.B  30(A3),D2
    MOVEQ   #0,D3
    MOVE.B  31(A3),D3
    MOVEQ   #0,D4
    MOVE.B  32(A3),D4
    MOVEQ   #0,D5
    MOVE.B  33(A3),D5
    MOVE.L  D5,(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_1C1F
    JSR     LAB_066D(PC)

    MOVEQ   #0,D0
    MOVE.B  34(A3),D0
    MOVEQ   #0,D1
    MOVE.B  35(A3),D1
    MOVEQ   #0,D2
    MOVE.B  36(A3),D2
    MOVEQ   #0,D3
    MOVE.B  37(A3),D3
    MOVEQ   #0,D4
    MOVE.B  38(A3),D4
    MOVEQ   #0,D5
    MOVE.B  39(A3),D5
    MOVE.L  D5,(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_1C20
    JSR     LAB_066D(PC)

    MOVEQ   #0,D0
    MOVE.B  40(A3),D0
    MOVEQ   #0,D1
    MOVE.W  46(A3),D1
    MOVEQ   #0,D2
    MOVE.B  41(A3),D2
    MOVEQ   #0,D3
    MOVE.B  42(A3),D3
    LEA     43(A3),A0
    MOVE.L  A0,(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_1C21
    JSR     LAB_066D(PC)

    LEA     72(A7),A7
    MOVEM.L (A7)+,D2-D5/D7/A2-A3
    RTS

;!======

    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVE.L  20(A7),D7
    MOVE.L  D7,-(A7)
    PEA     LAB_1C22
    JSR     LAB_066D(PC)

    MOVE.L  A3,(A7)
    PEA     LAB_1C23
    JSR     LAB_066D(PC)

    LEA     12(A7),A7
    MOVE.L  A3,D0
    BNE.S   LAB_0442

    PEA     LAB_1C24
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7
    BRA.W   LAB_044F

LAB_0442:
    MOVEQ   #1,D6

LAB_0443:
    MOVEQ   #49,D0
    CMP.L   D0,D6
    BGE.W   LAB_044E

    MOVE.L  D6,D0
    ASL.L   #2,D0
    MOVEA.L GLOB_REF_STR_CLOCK_FORMAT,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  7(A3,D6.L),D0
    MOVE.L  D0,-(A7)
    MOVE.L  (A0),-(A7)
    MOVE.L  D6,-(A7)
    PEA     LAB_1C25
    JSR     LAB_066D(PC)

    LEA     16(A7),A7
    MOVEQ   #1,D0
    CMP.B   7(A3,D6.L),D0
    BNE.S   LAB_0444

    PEA     LAB_1C26
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7

LAB_0444:
    BTST    #1,7(A3,D6.L)
    BEQ.S   LAB_0445

    PEA     LAB_1C27
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7

LAB_0445:
    BTST    #2,7(A3,D6.L)
    BEQ.S   LAB_0446

    PEA     LAB_1C28
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7

LAB_0446:
    BTST    #3,7(A3,D6.L)
    BEQ.S   LAB_0447

    PEA     LAB_1C29
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7

LAB_0447:
    BTST    #4,7(A3,D6.L)
    BEQ.S   LAB_0448

    PEA     LAB_1C2A
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7

LAB_0448:
    BTST    #5,7(A3,D6.L)
    BEQ.S   LAB_0449

    PEA     LAB_1C2B
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7

LAB_0449:
    BTST    #6,7(A3,D6.L)
    BEQ.S   LAB_044A

    PEA     LAB_1C2C
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7

LAB_044A:
    BTST    #7,7(A3,D6.L)
    BEQ.S   LAB_044B

    PEA     LAB_1C2D
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7

LAB_044B:
    PEA     LAB_1C2E
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7
    MOVE.L  D6,D0
    ASL.L   #2,D0
    TST.L   56(A3,D0.L)
    BEQ.S   LAB_044C

    MOVE.L  56(A3,D0.L),-(A7)
    PEA     LAB_1C2F
    JSR     LAB_066D(PC)

    ADDQ.W  #8,A7
    BRA.S   LAB_044D

LAB_044C:
    PEA     LAB_1C30
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7

LAB_044D:
    ADDQ.L  #1,D6
    BRA.W   LAB_0443

LAB_044E:
    PEA     LAB_1C31
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7

LAB_044F:
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======

    LINK.W  A5,#-48
    MOVEM.L D2-D3/D6-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  D7,-(A7)
    PEA     LAB_1C32
    JSR     LAB_066D(PC)

    ADDQ.W  #8,A7
    MOVE.L  A3,D0
    BNE.S   LAB_0450

    PEA     LAB_1C33
    JSR     LAB_066D(PC)

    BRA.W   LAB_045F

LAB_0450:
    MOVE.L  A3,-(A7)
    PEA     LAB_1C34
    JSR     LAB_066D(PC)

    ADDQ.W  #8,A7
    CLR.B   -5(A5)
    MOVEQ   #1,D6

LAB_0451:
    MOVEQ   #49,D0
    CMP.L   D0,D6
    BGE.W   LAB_045F

    MOVEQ   #1,D0
    CMP.B   7(A3,D6.L),D0
    BNE.S   LAB_0452

    MOVE.L  D6,D0
    ASL.L   #2,D0
    TST.L   56(A3,D0.L)
    BEQ.W   LAB_045E

LAB_0452:
    MOVE.L  D6,D0
    ASL.L   #2,D0
    MOVEA.L GLOB_REF_STR_CLOCK_FORMAT,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    MOVE.L  D6,-(A7)
    PEA     LAB_1C35
    JSR     LAB_066D(PC)

    LEA     12(A7),A7
    MOVEQ   #1,D0
    CMP.B   7(A3,D6.L),D0
    BNE.S   LAB_0453

    PEA     LAB_1C36
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7

LAB_0453:
    BTST    #1,7(A3,D6.L)
    BEQ.S   LAB_0454

    PEA     LAB_1C37
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7

LAB_0454:
    BTST    #2,7(A3,D6.L)
    BEQ.S   LAB_0455

    PEA     LAB_1C38
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7

LAB_0455:
    BTST    #3,7(A3,D6.L)
    BEQ.S   LAB_0456

    PEA     LAB_1C39
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7

LAB_0456:
    BTST    #4,7(A3,D6.L)
    BEQ.S   LAB_0457

    PEA     LAB_1C3A
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7

LAB_0457:
    BTST    #5,7(A3,D6.L)
    BEQ.S   LAB_0458

    PEA     LAB_1C3B
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7

LAB_0458:
    BTST    #6,7(A3,D6.L)
    BEQ.S   LAB_0459

    PEA     LAB_1C3C
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7

LAB_0459:
    BTST    #7,7(A3,D6.L)
    BEQ.S   LAB_045A

    PEA     LAB_1C3D
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7

LAB_045A:
    PEA     LAB_1C3E
    JSR     LAB_066D(PC)

    ADDQ.W  #4,A7
    MOVE.L  D6,D0
    ASL.L   #2,D0
    TST.L   56(A3,D0.L)
    BEQ.S   LAB_045B

    PEA     40.W
    MOVE.L  56(A3,D0.L),-(A7)
    PEA     -45(A5)
    JSR     LAB_0470(PC)

    LEA     12(A7),A7
    BRA.S   LAB_045D

LAB_045B:
    LEA     LAB_1C3F,A0
    LEA     -45(A5),A1

LAB_045C:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_045C

LAB_045D:
    PEA     -45(A5)
    JSR     LAB_046A(PC)

    MOVEQ   #0,D0
    MOVE.L  D6,D1
    ADDI.L  #$fc,D1
    MOVE.B  0(A3,D1.L),D0
    MOVEQ   #0,D1
    MOVE.L  D6,D2
    ADDI.L  #$12d,D2
    MOVE.B  0(A3,D2.L),D1
    MOVEQ   #0,D2
    MOVE.L  D6,D3
    ADDI.L  #$15e,D3
    MOVE.B  0(A3,D3.L),D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_1C40
    JSR     LAB_066D(PC)

    LEA     16(A7),A7

LAB_045E:
    ADDQ.L  #1,D6
    BRA.W   LAB_0451

LAB_045F:
    MOVEM.L -68(A5),D2-D3/D6-D7/A3
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD
