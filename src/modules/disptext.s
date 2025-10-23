;!======

LAB_056A:
    LINK.W  A5,#-8
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    CLR.L   -8(A5)
    TST.L   LAB_21D3
    BEQ.W   LAB_056F

    MOVEA.L LAB_21D3,A0

LAB_056B:
    TST.B   (A0)+
    BNE.S   LAB_056B

    SUBQ.L  #1,A0
    SUBA.L  LAB_21D3,A0
    MOVEA.L A3,A1

LAB_056C:
    TST.B   (A1)+
    BNE.S   LAB_056C

    SUBQ.L  #1,A1
    SUBA.L  A3,A1
    MOVE.L  A0,D0
    MOVE.L  A1,D1
    ADD.L   D1,D0
    MOVE.L  D0,D7
    ADDQ.L  #1,D7
    MOVEQ   #1,D1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOAvailMem(A6)

    CMPI.L  #$2710,D0
    BLE.S   LAB_056D

    PEA     (MEMF_PUBLIC).W
    MOVE.L  D7,-(A7)
    PEA     127.W
    PEA     GLOB_STR_DISPTEXT_C_1
    JSR     JMP_TBL_ALLOCATE_MEMORY_1(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-8(A5)

LAB_056D:
    TST.L   -8(A5)
    BEQ.S   LAB_0570

    MOVEA.L LAB_21D3,A0
    MOVEA.L -8(A5),A1

LAB_056E:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_056E

    MOVE.L  A3,-(A7)
    MOVE.L  -8(A5),-(A7)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    MOVE.L  LAB_21D3,(A7)
    CLR.L   -(A7)
    JSR     LAB_0385(PC)

    LEA     12(A7),A7
    MOVEA.L -8(A5),A0
    MOVE.L  A0,LAB_21D3
    BRA.S   LAB_0570

LAB_056F:
    MOVE.L  LAB_21D3,-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_0385(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_21D3

LAB_0570:
    TST.L   LAB_21D3
    SNE     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======

LAB_0571:
    LINK.W  A5,#-76
    MOVEM.L D2-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  20(A5),D7
    MOVEA.L A3,A1
    LEA     LAB_1CEA,A0
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVEA.L 16(A5),A0
    CLR.B   (A0)
    MOVE.L  D0,-16(A5)

LAB_0572:
    MOVE.L  A2,D0
    BEQ.W   LAB_057D

    TST.B   (A2)
    BEQ.W   LAB_057D

    CMP.L   -16(A5),D7
    BLE.W   LAB_057D

    MOVEA.L 16(A5),A0
    TST.B   (A0)
    BEQ.S   LAB_0573

    PEA     LAB_1CEB
    MOVE.L  A0,-(A7)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    ADDQ.W  #8,A7
    SUB.L   -16(A5),D7

LAB_0573:
    MOVE.L  A2,-(A7)
    JSR     LAB_05C4(PC)

    MOVEA.L D0,A2
    MOVE.L  A2,-20(A5)
    PEA     LAB_1CEC
    PEA     50.W
    PEA     -73(A5)
    MOVE.L  A2,-(A7)
    JSR     LAB_05C6(PC)

    LEA     20(A7),A7
    MOVEA.L D0,A2
    LEA     -73(A5),A0
    MOVEA.L A0,A1

LAB_0574:
    TST.B   (A1)+
    BNE.S   LAB_0574

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D6
    MOVEA.L A3,A1
    MOVE.L  D6,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,D5
    MOVEA.L -20(A5),A0
    MOVE.B  (A0),D0
    MOVEQ   #19,D1
    CMP.B   D1,D0
    BNE.S   LAB_0575

    ADDQ.L  #8,D5

LAB_0575:
    CMP.L   D7,D5
    BLE.S   LAB_057C

    MOVE.W  LAB_21D6,D2
    MOVEQ   #2,D3
    CMP.W   D3,D2
    BCC.S   LAB_0576

    MOVE.L  LAB_21DA,D2
    BRA.S   LAB_0577

LAB_0576:
    MOVEQ   #0,D2

LAB_0577:
    MOVE.L  LAB_21D9,D3
    SUB.L   D2,D3
    MOVE.L  D3,D4
    CMP.L   D4,D5
    BLE.S   LAB_057B

    CMP.B   D1,D0
    BEQ.W   LAB_0572

LAB_0578:
    CMP.L   D7,D5
    BLE.S   LAB_0579

    TST.L   D6
    BLE.S   LAB_0579

    SUBQ.L  #1,D6
    MOVEA.L A3,A1
    MOVE.L  D6,D0
    LEA     -73(A5),A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,D5
    BRA.S   LAB_0578

LAB_0579:
    TST.L   D6
    BLE.S   LAB_057A

    CLR.B   -73(A5,D6.L)
    PEA     -73(A5)
    MOVE.L  16(A5),-(A7)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    ADDQ.W  #8,A7

LAB_057A:
    MOVEA.L -20(A5),A0
    MOVEA.L A0,A1
    ADDA.L  D6,A1
    MOVEA.L A1,A2
    MOVEQ   #0,D7
    BRA.W   LAB_0572

LAB_057B:
    MOVEA.L -20(A5),A2
    MOVEQ   #0,D7
    BRA.W   LAB_0572

LAB_057C:
    PEA     -73(A5)
    MOVE.L  16(A5),-(A7)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    ADDQ.W  #8,A7
    SUB.L   D5,D7
    MOVEQ   #19,D1
    MOVEA.L -20(A5),A0
    CMP.B   (A0),D1
    SEQ     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVE.W  LAB_21DC,D1
    EXT.L   D1
    OR.L    D0,D1
    MOVE.W  D1,LAB_21DC
    BRA.W   LAB_0572

LAB_057D:
    TST.B   (A2)
    BNE.S   LAB_057E

    SUBA.L  A2,A2

LAB_057E:
    MOVE.L  A2,D0
    MOVEM.L (A7)+,D2-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_057F:
    MOVEM.L D5-D7/A2-A3,-(A7)
    MOVE.L  24(A7),D7
    TST.L   LAB_21DB
    BNE.S   LAB_0584

    MOVE.L  LAB_21D3,LAB_21D4
    MOVEQ   #0,D0
    MOVE.W  LAB_21D6,D0
    ADD.L   D0,D0
    LEA     LAB_21D7,A0
    ADDA.L  D0,A0
    TST.W   (A0)
    BEQ.S   LAB_0580

    MOVEQ   #1,D0
    BRA.S   LAB_0581

LAB_0580:
    MOVEQ   #0,D0

LAB_0581:
    MOVEQ   #0,D1
    MOVE.W  LAB_21D6,D1
    ADD.L   D0,D1
    MOVE.L  D1,D5
    MOVEQ   #1,D6

LAB_0582:
    CMP.L   D5,D6
    BGE.S   LAB_0583

    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     LAB_21D4,A0
    ADDA.L  D0,A0
    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     LAB_21D3,A1
    ADDA.L  D0,A1
    MOVE.L  D6,D0
    ADD.L   D0,D0
    LEA     LAB_21D6,A2
    ADDA.L  D0,A2
    MOVEA.L (A1),A3
    MOVEQ   #0,D0
    MOVE.W  (A2),D0
    ADDA.L  D0,A3
    MOVE.L  A3,(A0)
    ADDQ.L  #1,D6
    BRA.S   LAB_0582

LAB_0583:
    MOVE.L  D7,LAB_21DB

LAB_0584:
    MOVEM.L (A7)+,D5-D7/A2-A3
    RTS

;!======

LAB_0585:
    TST.L   LAB_21DB
    BNE.S   LAB_0587

    MOVE.W  LAB_21D6,D0
    MOVE.W  D0,LAB_21D5
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ADD.L   D1,D1
    LEA     LAB_21D7,A0
    ADDA.L  D1,A0
    TST.W   (A0)
    BEQ.S   LAB_0586

    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_21D5

LAB_0586:
    PEA     1.W
    BSR.W   LAB_057F

    ADDQ.W  #4,A7
    CLR.W   LAB_21D6

LAB_0587:
    RTS

;!======

LAB_0588:
    TST.L   LAB_1CED
    BEQ.S   .return

    CLR.L   LAB_21D3
    BSR.W   LAB_0563

    CLR.L   LAB_1CED

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     1000.W
    PEA     320.W
    PEA     GLOB_STR_DISPTEXT_C_2
    JSR     JMP_TBL_ALLOCATE_MEMORY_1(PC)

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),(A7)
    PEA     1000.W
    PEA     321.W
    PEA     GLOB_STR_DISPTEXT_C_3
    MOVE.L  D0,GLOB_REF_1000_BYTES_ALLOCATED_1
    JSR     JMP_TBL_ALLOCATE_MEMORY_1(PC)

    LEA     28(A7),A7
    MOVE.L  D0,GLOB_REF_1000_BYTES_ALLOCATED_2

.return:
    RTS

;!======

LAB_058A:
    BSR.W   LAB_0566

    TST.L   GLOB_REF_1000_BYTES_ALLOCATED_1
    BEQ.S   .freeSecondBlock

    PEA     1000.W
    MOVE.L  GLOB_REF_1000_BYTES_ALLOCATED_1,-(A7)
    PEA     338.W
    PEA     GLOB_STR_DISPTEXT_C_4
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

    LEA     16(A7),A7
    CLR.L   GLOB_REF_1000_BYTES_ALLOCATED_1

.freeSecondBlock:
    TST.L   GLOB_REF_1000_BYTES_ALLOCATED_2
    BEQ.S   .return

    PEA     1000.W
    MOVE.L  GLOB_REF_1000_BYTES_ALLOCATED_2,-(A7)
    PEA     343.W
    PEA     GLOB_STR_DISPTEXT_C_5
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

    LEA     16(A7),A7
    CLR.L   GLOB_REF_1000_BYTES_ALLOCATED_2

.return:
    RTS

;!======

LAB_058D:
    MOVEM.L D5-D7,-(A7)
    MOVE.L  16(A7),D7
    MOVE.L  20(A7),D6
    MOVE.L  24(A7),D5
    BSR.W   LAB_0566

    TST.L   D7
    BMI.S   LAB_058E

    CMPI.L  #624,D7
    BGT.S   LAB_058E

    MOVE.L  D7,LAB_21D9

LAB_058E:
    TST.L   D6
    BLE.S   LAB_058F

    MOVEQ   #20,D0
    CMP.L   D0,D6
    BGT.S   LAB_058F

    MOVE.L  D6,D0
    MOVE.W  D0,LAB_21D5

LAB_058F:
    MOVE.L  D5,-(A7)
    BSR.W   LAB_0567

    ADDQ.W  #4,A7
    MOVE.L  LAB_21D9,D0
    CMP.L   D7,D0
    BNE.S   LAB_0590

    MOVEQ   #0,D0
    MOVE.W  LAB_21D5,D0
    CMP.L   D6,D0
    BNE.S   LAB_0590

    MOVEQ   #1,D0
    BRA.S   LAB_0591

LAB_0590:
    MOVEQ   #0,D0

LAB_0591:
    MOVEM.L (A7)+,D5-D7
    RTS

;!======

LAB_0592:
    LINK.W  A5,#-12
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  16(A5),D6
    PEA     -4(A5)
    PEA     -3(A5)
    PEA     -2(A5)
    PEA     -1(A5)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    JSR     LAB_05C0(PC)

    LEA     24(A7),A7
    TST.B   -1(A5)
    BEQ.S   LAB_0593

    MOVEA.L A3,A1
    LEA     -1(A5),A0
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    BRA.S   LAB_0594

LAB_0593:
    MOVEQ   #0,D0

LAB_0594:
    MOVE.L  D0,D5
    TST.B   -3(A5)
    BEQ.S   LAB_0595

    MOVEA.L A3,A1
    LEA     -3(A5),A0
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    BRA.S   LAB_0596

LAB_0595:
    MOVEQ   #0,D0

LAB_0596:
    MOVE.L  D0,D4
    MOVE.L  D5,D0
    ADD.L   D4,D0
    MOVE.L  D0,LAB_21DA
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======

LAB_0597:
    LINK.W  A5,#-276
    MOVEM.L D2/D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVEQ   #0,D7
    TST.L   LAB_21DB
    BNE.W   LAB_059E

    MOVE.W  LAB_21D6,D0
    MOVE.W  LAB_21D5,D1
    CMP.W   D1,D0
    BCC.W   LAB_059E

    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ADD.L   D1,D1
    LEA     LAB_21D7,A0
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    TST.W   (A1)
    BEQ.S   LAB_0598

    MOVEQ   #0,D2
    MOVE.W  D0,D2
    ASL.L   #2,D2
    LEA     LAB_21D4,A1
    ADDA.L  D2,A1
    ADDA.L  D1,A0
    MOVEQ   #0,D0
    MOVE.W  (A0),D0
    MOVE.L  A1,28(A7)
    MOVEA.L A3,A1
    MOVEA.L 28(A7),A0
    MOVEA.L (A0),A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  LAB_21D9,D1
    MOVE.L  D1,D2
    SUB.L   D0,D2
    MOVE.L  D2,D6
    BRA.S   LAB_0599

LAB_0598:
    MOVE.L  LAB_21D9,D6

LAB_0599:
    MOVE.W  LAB_21D6,D0
    MOVEQ   #2,D1
    CMP.W   D1,D0
    BCC.S   LAB_059A

    SUB.L   LAB_21DA,D6

LAB_059A:
    MOVEQ   #0,D2
    MOVE.W  D0,D2
    ADD.L   D2,D2
    LEA     LAB_21D7,A0
    ADDA.L  D2,A0
    TST.W   (A0)
    BEQ.S   LAB_059C

    MOVEA.L A3,A1
    LEA     LAB_1CF2,A0
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,D5
    CMP.L   D5,D6
    BLE.S   LAB_059B

    SUB.L   D5,D6
    BRA.S   LAB_059C

LAB_059B:
    ADDQ.L  #1,D7
    MOVEQ   #0,D0
    MOVE.W  LAB_21D6,D0
    ADD.L   D7,D0
    MOVEQ   #0,D1
    MOVE.W  LAB_21D5,D1
    CMP.L   D1,D0
    BGE.S   LAB_059C

    MOVE.L  LAB_21D9,D6

LAB_059C:
    MOVE.L  A2,D0
    BEQ.S   LAB_059E

    TST.B   (A2)
    BEQ.S   LAB_059E

    MOVEQ   #0,D0
    MOVE.W  LAB_21D6,D0
    ADD.L   D7,D0
    MOVEQ   #0,D1
    MOVE.W  LAB_21D5,D1
    CMP.L   D1,D0
    BGE.S   LAB_059E

    MOVE.L  D6,-(A7)
    PEA     -268(A5)
    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_0571

    LEA     16(A7),A7
    MOVEA.L D0,A2
    MOVE.L  LAB_21D9,D6
    MOVE.W  LAB_21D6,D0
    MOVEQ   #2,D1
    CMP.W   D1,D0
    BCC.S   LAB_059D

    SUB.L   LAB_21DA,D6

LAB_059D:
    MOVE.L  A2,D0
    BEQ.S   LAB_059C

    ADDQ.L  #1,D7
    BRA.S   LAB_059C

LAB_059E:
    MOVE.L  A2,D1
    SEQ     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVEM.L (A7)+,D2/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_059F:
    LINK.W  A5,#-276
    MOVEM.L D2/D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    TST.L   LAB_21DB
    BNE.W   LAB_05A9

    MOVE.W  LAB_21D6,D0
    MOVE.W  LAB_21D5,D1
    CMP.W   D1,D0
    BCC.W   LAB_05A9

    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ADD.L   D1,D1
    LEA     LAB_21D7,A0
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    TST.W   (A1)
    BEQ.S   LAB_05A0

    MOVEQ   #0,D2
    MOVE.W  D0,D2
    ASL.L   #2,D2
    LEA     LAB_21D4,A1
    ADDA.L  D2,A1
    ADDA.L  D1,A0
    MOVEQ   #0,D0
    MOVE.W  (A0),D0
    MOVE.L  A1,28(A7)
    MOVEA.L A3,A1
    MOVEA.L 28(A7),A0
    MOVEA.L (A0),A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  LAB_21D9,D1
    MOVE.L  D1,D2
    SUB.L   D0,D2
    MOVE.L  D2,D7
    BRA.S   LAB_05A1

LAB_05A0:
    MOVE.L  LAB_21D9,D7

LAB_05A1:
    MOVE.W  LAB_21D6,D0
    MOVEQ   #2,D1
    CMP.W   D1,D0
    BCC.S   LAB_05A2

    SUB.L   LAB_21DA,D7

LAB_05A2:
    MOVEA.L GLOB_REF_1000_BYTES_ALLOCATED_2,A0
    CLR.B   (A0)
    MOVEQ   #0,D0
    MOVE.W  LAB_21D6,D0
    ADD.L   D0,D0
    LEA     LAB_21D7,A1
    ADDA.L  D0,A1
    TST.W   (A1)
    BEQ.S   LAB_05A5

    MOVEA.L A3,A1
    LEA     LAB_1CF3,A0
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,D6
    CMP.L   D6,D7
    BLE.S   LAB_05A4

    LEA     LAB_1CF4,A0
    MOVEA.L GLOB_REF_1000_BYTES_ALLOCATED_2,A1

LAB_05A3:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_05A3

    SUB.L   D6,D7
    MOVEQ   #0,D0
    MOVE.W  LAB_21D6,D0
    ADD.L   D0,D0
    LEA     LAB_21D7,A0
    ADDA.L  D0,A0
    ADDQ.W  #1,(A0)
    BRA.S   LAB_05A5

LAB_05A4:
    MOVEQ   #0,D0
    MOVE.W  LAB_21D6,D0
    ASL.L   #2,D0
    LEA     LAB_21D8,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    BSR.W   LAB_0567

    ADDQ.W  #4,A7
    MOVE.W  LAB_21D6,D0
    MOVE.W  LAB_21D5,D1
    CMP.W   D1,D0
    BCC.S   LAB_05A5

    MOVE.L  LAB_21D9,D7

LAB_05A5:
    MOVE.L  A2,D0
    BEQ.W   LAB_05A8

    TST.B   (A2)
    BEQ.W   LAB_05A8

    MOVE.W  LAB_21D6,D0
    MOVE.W  LAB_21D5,D1
    CMP.W   D1,D0
    BCC.W   LAB_05A8

    MOVE.L  D7,-(A7)
    PEA     -268(A5)
    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_0571

    MOVEA.L D0,A2
    LEA     -268(A5),A0
    MOVEA.L A0,A1

LAB_05A6:
    TST.B   (A1)+
    BNE.S   LAB_05A6

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D5
    MOVE.L  A0,(A7)
    MOVE.L  GLOB_REF_1000_BYTES_ALLOCATED_2,-(A7)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D0
    MOVE.W  LAB_21D6,D0
    ADD.L   D0,D0
    LEA     LAB_21D7,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.W  (A0),D0
    MOVE.L  D0,D1
    ADD.L   D5,D1
    MOVE.W  D1,(A0)
    MOVE.L  LAB_21D9,D7
    MOVE.W  LAB_21D6,D0
    MOVEQ   #2,D1
    CMP.W   D1,D0
    BCC.S   LAB_05A7

    SUB.L   LAB_21DA,D7

LAB_05A7:
    MOVE.L  A2,D1
    BEQ.W   LAB_05A5

    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ASL.L   #2,D1
    LEA     LAB_21D8,A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-(A7)
    BSR.W   LAB_0567

    ADDQ.W  #4,A7
    BRA.W   LAB_05A5

LAB_05A8:
    MOVEA.L GLOB_REF_1000_BYTES_ALLOCATED_2,A0
    TST.B   (A0)
    BEQ.S   LAB_05A9

    MOVE.L  A0,-(A7)
    BSR.W   LAB_056A

    CLR.L   (A7)
    BSR.W   LAB_057F

    ADDQ.W  #4,A7

LAB_05A9:
    MOVE.L  A2,D1
    SEQ     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVEM.L (A7)+,D2/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_05AA:
    LINK.W  A5,#-8
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEQ   #0,D7
    TST.L   LAB_21DB
    BNE.S   LAB_05AB

    LEA     16(A5),A0
    MOVE.L  A0,-(A7)
    MOVE.L  12(A5),-(A7)
    MOVE.L  GLOB_REF_1000_BYTES_ALLOCATED_1,-(A7)
    MOVE.L  A0,-8(A5)
    JSR     LAB_05C3(PC)

    MOVE.L  GLOB_REF_1000_BYTES_ALLOCATED_1,(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_059F

    LEA     16(A7),A7
    MOVE.L  D0,D7

LAB_05AB:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======

LAB_05AC:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7
    TST.L   LAB_21DB
    BNE.S   .return

    MOVEQ   #1,D0
    CMP.L   D0,D7
    BLT.S   .return

    MOVEQ   #3,D0
    CMP.L   D0,D7
    BGT.S   .return

    MOVE.L  D7,-(A7)
    BSR.W   LAB_0567

    ADDQ.W  #4,A7

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======

LAB_05AE:
    LINK.W  A5,#-12
    MOVEM.L D5-D7,-(A7)
    MOVE.L  8(A5),D7
    BSR.W   LAB_0585

    MOVEQ   #0,D0
    MOVE.W  LAB_21D5,D0
    CMP.L   D7,D0
    BGE.S   LAB_05AF

    MOVE.L  D7,D1
    BRA.S   LAB_05B0

LAB_05AF:
    MOVEQ   #0,D1
    MOVE.W  D0,D1

LAB_05B0:
    MOVE.L  D1,D6
    MOVEQ   #0,D1
    MOVE.W  LAB_2328,D1
    MOVE.L  D6,D0
    JSR     JMP_TBL_LAB_1A06_2(PC)

    TST.L   D0
    BPL.S   LAB_05B1

    ADDQ.L  #3,D0

LAB_05B1:
    ASR.L   #2,D0
    MOVE.L  D0,D5
    MOVEQ   #1,D0
    CMP.L   D0,D6
    BNE.S   LAB_05B2

    MOVEQ   #2,D0
    BRA.S   LAB_05B3

LAB_05B2:
    MOVEQ   #0,D0

LAB_05B3:
    ADD.L   D0,D5
    TST.W   LAB_21DC
    BEQ.S   LAB_05B4

    MOVE.W  LAB_21D5,D0
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ASL.L   #2,D1
    LEA     LAB_21D3,A0
    ADDA.L  D1,A0
    MOVEA.L (A0),A1
    MOVE.L  A1,-12(A5)
    BEQ.S   LAB_05B4

    PEA     19.W
    MOVE.L  A1,-(A7)
    JSR     LAB_05C1(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   LAB_05B4

    PEA     20.W
    MOVE.L  -12(A5),-(A7)
    JSR     LAB_05C1(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   LAB_05B4

    ADDQ.L  #2,D5

LAB_05B4:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D5-D7
    UNLK    A5
    RTS

;!======

LAB_05B5:
    BSR.W   LAB_0585

    MOVEQ   #0,D0
    MOVE.W  LAB_21D5,D0
    RTS

;!======

LAB_05B6:
    BSR.W   LAB_0585

    MOVE.W  LAB_21D6,D0
    BNE.S   .LAB_05B7

    MOVE.W  LAB_21D5,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   .LAB_05B7

    MOVEQ   #1,D0
    BRA.S   .return

.LAB_05B7:
    MOVEQ   #0,D0

.return:
    RTS

;!======

LAB_05B9:
    MOVE.L  D2,-(A7)
    BSR.W   LAB_0585

    MOVEQ   #0,D0
    MOVE.W  LAB_21D5,D0
    SUBQ.L  #1,D0
    MOVEQ   #0,D1
    MOVE.W  LAB_21D6,D1
    CMP.L   D0,D1
    SEQ     D2
    NEG.B   D2
    EXT.W   D2
    EXT.L   D2
    MOVE.L  D2,D0
    MOVE.L  (A7)+,D2
    RTS

;!======

LAB_05BA:
    MOVE.L  D2,-(A7)
    BSR.W   LAB_0585

    MOVE.W  LAB_21D6,D0
    MOVE.W  LAB_21D5,D1
    CMP.W   D1,D0
    SEQ     D2
    NEG.B   D2
    EXT.W   D2
    EXT.L   D2
    MOVE.L  D2,D0
    MOVE.L  (A7)+,D2
    RTS

;!======

LAB_05BB:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    BSR.W   LAB_0585

    MOVEQ   #0,D0
    MOVE.W  LAB_21D6,D0
    ASL.L   #2,D0
    LEA     LAB_21D4,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.W  LAB_21D6,D0
    ADD.L   D0,D0
    LEA     LAB_21D7,A1
    ADDA.L  D0,A1
    MOVEQ   #0,D0
    MOVE.W  (A1),D0
    MOVEA.L A3,A1
    MOVEA.L (A0),A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVEA.L (A7)+,A3
    RTS

;!======

LAB_05BC:
    LINK.W  A5,#-12
    MOVEM.L D2-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  16(A5),D6
    BSR.W   LAB_0585

    MOVEQ   #0,D0
    MOVE.L  D0,LAB_1CE8
    MOVE.L  LAB_21D9,D1
    TST.L   D1
    BLE.W   LAB_05BF

    MOVE.W  LAB_21D6,D1
    MOVE.W  LAB_21D5,D2
    CMP.W   D2,D1
    BCC.W   LAB_05BF

    MOVEQ   #0,D2
    MOVE.W  D1,D2
    ASL.L   #2,D2
    LEA     LAB_21D4,A0
    MOVEA.L A0,A1
    ADDA.L  D2,A1
    TST.L   (A1)
    BEQ.W   LAB_05BF

    MOVEQ   #0,D2
    MOVE.W  D1,D2
    ASL.L   #2,D2
    ADDA.L  D2,A0
    MOVE.L  (A0),-6(A5)
    MOVEQ   #0,D3
    MOVE.W  D1,D3
    ADD.L   D3,D3
    LEA     LAB_21D7,A0
    ADDA.L  D3,A0
    MOVEQ   #0,D4
    MOVE.W  (A0),D4
    TST.L   D4
    BLE.W   LAB_05BF

    LEA     LAB_21D8,A0
    ADDA.L  D2,A0
    MOVEA.L A3,A1
    MOVE.L  (A0),D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L -6(A5),A0
    MOVE.B  0(A0,D4.L),D5
    CLR.B   0(A0,D4.L)
    TST.W   LAB_21DC
    BEQ.S   LAB_05BD

    PEA     19.W
    MOVE.L  A0,-(A7)
    JSR     LAB_05C1(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   LAB_05BD

    PEA     20.W
    MOVE.L  -6(A5),-(A7)
    JSR     LAB_05C1(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   LAB_05BD

    MOVEQ   #0,D0
    MOVE.B  LAB_21B2,D0
    MOVEQ   #0,D1
    MOVE.B  LAB_21B1,D1
    MOVE.L  -6(A5),-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_05C2(PC)

    LEA     24(A7),A7
    MOVEQ   #4,D0
    MOVE.L  D0,LAB_1CE8
    BRA.S   LAB_05BE

LAB_05BD:
    MOVEA.L A3,A1
    MOVE.L  D7,D0
    MOVE.L  D6,D1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVEA.L A3,A1
    MOVE.L  D4,D0
    MOVEA.L -6(A5),A0
    JSR     _LVOText(A6)

LAB_05BE:
    MOVEA.L -6(A5),A0
    MOVE.B  D5,0(A0,D4.L)
    MOVE.W  LAB_21D6,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_21D6

LAB_05BF:
    MOVEM.L (A7)+,D2-D7/A3
    UNLK    A5
    RTS

;!======

LAB_05C0:
    JMP     LAB_10BE

LAB_05C1:
    JMP     LAB_1979

LAB_05C2:
    JMP     LAB_175F

LAB_05C3:
    JMP     LAB_1A3A

LAB_05C4:
    JMP     LAB_1985

JMP_TBL_APPEND_DATA_AT_NULL_1:
    JMP     APPEND_DATA_AT_NULL

LAB_05C6:
    JMP     LAB_1970

    MOVEQ   #97,D0

LAB_05C7:
    MOVEM.L D4-D7/A3,-(A7)
    MOVE.L  24(A7),D7
    MOVEA.L 28(A7),A3
    TST.L   D7
    BPL.S   LAB_05C8

    MOVEQ   #0,D7

LAB_05C8:
    MOVE.L  D7,D0
    MOVEQ   #60,D1
    JSR     JMP_TBL_LAB_1A07_1(PC)

    MOVE.W  D1,12(A3)
    MOVE.L  D7,D0
    MOVEQ   #60,D1
    JSR     JMP_TBL_LAB_1A07_1(PC)

    MOVE.L  D0,D7
    MOVE.L  D7,D0
    MOVEQ   #60,D1
    JSR     JMP_TBL_LAB_1A07_1(PC)

    MOVE.W  D1,10(A3)
    MOVE.L  D7,D0
    MOVEQ   #60,D1
    JSR     JMP_TBL_LAB_1A07_1(PC)

    MOVE.L  D0,D7
    MOVE.L  D7,D0
    MOVE.L  #$88f8,D1
    JSR     JMP_TBL_LAB_1A07_1(PC)

    MOVE.L  D0,D5
    MOVE.L  D5,D0
    ASL.L   #2,D0
    MOVE.W  D0,6(A3)
    ADDI.W  #$7b2,6(A3)
    MOVE.L  D5,D0
    MOVE.L  #$5b5,D1
    JSR     JMP_TBL_LAB_1A06_3(PC)

    MOVE.L  D0,D4
    MOVE.L  D7,D0
    MOVE.L  #$88f8,D1
    JSR     JMP_TBL_LAB_1A07_1(PC)

    MOVE.L  D1,D7

LAB_05C9:
    MOVE.L  #$2238,D6
    MOVE.W  6(A3),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0660

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   LAB_05CA

    MOVEQ   #24,D0
    ADD.L   D0,D6

LAB_05CA:
    CMP.L   D6,D7
    BLT.S   LAB_05CB

    MOVE.L  D6,D0
    MOVEQ   #24,D1
    JSR     JMP_TBL_LAB_1A07_1(PC)

    ADD.L   D0,D4
    ADDQ.W  #1,6(A3)
    SUB.L   D6,D7
    BRA.S   LAB_05C9

LAB_05CB:
    MOVE.L  D7,D0
    MOVEQ   #24,D1
    JSR     JMP_TBL_LAB_1A07_1(PC)

    MOVE.W  D1,8(A3)
    MOVE.L  D7,D0
    MOVEQ   #24,D1
    JSR     JMP_TBL_LAB_1A07_1(PC)

    MOVE.L  D0,D7
    MOVE.L  D7,D0
    ADDQ.L  #4,D0
    ADD.L   D0,D4
    MOVE.L  D4,D0
    MOVEQ   #7,D1
    JSR     LAB_066E(PC)

    MOVE.W  D1,(A3)
    ADDQ.L  #1,D7
    MOVE.L  D7,D0
    MOVE.W  D0,16(A3)
    MOVE.W  6(A3),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0660

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   LAB_05CC

    MOVEQ   #-1,D0
    BRA.S   LAB_05CD

LAB_05CC:
    MOVEQ   #0,D0

LAB_05CD:
    MOVE.W  D0,20(A3)
    ADDQ.W  #1,D0
    BNE.S   LAB_05CF

    MOVEQ   #60,D0
    CMP.L   D0,D7
    BLE.S   LAB_05CE

    SUBQ.L  #1,D7
    BRA.S   LAB_05CF

LAB_05CE:
    CMP.L   D0,D7
    BNE.S   LAB_05CF

    MOVE.W  #1,2(A3)
    MOVE.W  #$1d,4(A3)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_0668

    ADDQ.W  #4,A7
    MOVE.L  A3,D0
    BRA.S   LAB_05D2

LAB_05CF:
    CLR.W   2(A3)

LAB_05D0:
    LEA     LAB_1CF5,A0
    MOVE.W  2(A3),D0
    MOVEA.L A0,A1
    ADDA.W  D0,A1
    MOVE.B  (A1),D1
    EXT.W   D1
    EXT.L   D1
    CMP.L   D7,D1
    BGE.S   LAB_05D1

    ADDA.W  D0,A0
    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    SUB.L   D0,D7
    ADDQ.W  #1,2(A3)
    BRA.S   LAB_05D0

LAB_05D1:
    MOVE.L  D7,D0
    MOVE.W  D0,4(A3)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_0668

    ADDQ.W  #4,A7
    MOVE.L  A3,D0

LAB_05D2:
    MOVEM.L (A7)+,D4-D7/A3
    RTS

;!======

LAB_05D3:
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 24(A7),A3
    MOVE.W  6(A3),D0
    CMPI.W  #$76c,D0
    BGE.S   LAB_05D4

    ADDI.W  #$76c,6(A3)

LAB_05D4:
    MOVE.W  6(A3),D0
    CMPI.W  #$7b2,D0
    BLT.S   LAB_05D5

    CMPI.W  #$7f6,D0
    BLE.S   LAB_05D6

LAB_05D5:
    MOVEQ   #-1,D0
    BRA.W   LAB_05E0

LAB_05D6:
    MOVE.L  A3,-(A7)
    BSR.W   LAB_0665

    ADDQ.W  #4,A7
    MOVE.W  12(A3),D0
    EXT.L   D0
    MOVEQ   #60,D1
    DIVS    D1,D0
    ADD.W   D0,10(A3)
    MOVE.W  12(A3),D0
    EXT.L   D0
    DIVS    D1,D0
    SWAP    D0
    MOVE.W  D0,12(A3)
    MOVE.W  10(A3),D0
    EXT.L   D0
    DIVS    D1,D0
    ADD.W   D0,8(A3)
    MOVE.W  10(A3),D0
    EXT.L   D0
    DIVS    D1,D0
    SWAP    D0
    MOVE.W  D0,10(A3)
    MOVE.W  8(A3),D0
    EXT.L   D0
    MOVEQ   #24,D1
    DIVS    D1,D0
    ADD.W   D0,4(A3)
    MOVE.W  8(A3),D0
    EXT.L   D0
    DIVS    D1,D0
    ADD.W   D0,16(A3)
    MOVE.W  8(A3),D0
    EXT.L   D0
    DIVS    D1,D0
    SWAP    D0
    MOVE.W  D0,8(A3)
    MOVE.W  6(A3),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0660

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   LAB_05D7

    MOVE.L  #366,D0
    BRA.S   LAB_05D8

LAB_05D7:
    MOVE.L  #$16d,D0

LAB_05D8:
    MOVE.L  D0,D6

LAB_05D9:
    MOVE.W  16(A3),D0
    EXT.L   D0
    CMP.L   D6,D0
    BLE.S   LAB_05DC

    MOVE.W  16(A3),D0
    EXT.L   D0
    SUB.L   D6,D0
    MOVE.W  D0,16(A3)
    ADDQ.W  #1,6(A3)
    MOVE.W  6(A3),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0660

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   LAB_05DA

    MOVE.L  #366,D0
    BRA.S   LAB_05DB

LAB_05DA:
    MOVE.L  #$16d,D0

LAB_05DB:
    MOVE.L  D0,D6
    BRA.S   LAB_05D9

LAB_05DC:
    MOVE.W  6(A3),D0
    EXT.L   D0
    SUBI.L  #$7b0,D0
    TST.L   D0
    BPL.S   LAB_05DD

    ADDQ.L  #3,D0

LAB_05DD:
    ASR.L   #2,D0
    MOVE.L  D0,D7
    MOVE.W  6(A3),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0660

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   LAB_05DE

    SUBQ.L  #1,D7

LAB_05DE:
    MOVE.W  6(A3),D0
    EXT.L   D0
    SUBI.L  #$7b2,D0
    MOVE.L  #$16d,D1
    JSR     JMP_TBL_LAB_1A06_2(PC)

    ADD.L   D7,D0
    MOVE.W  16(A3),D1
    EXT.L   D1
    ADD.L   D1,D0
    MOVE.L  D0,D5
    SUBQ.L  #1,D5
    MOVE.L  D5,D0
    MOVE.L  #$15180,D1
    JSR     JMP_TBL_LAB_1A06_2(PC)

    MOVE.W  8(A3),D1
    MULS    #$e10,D1
    ADD.L   D1,D0
    MOVE.W  10(A3),D1
    MULS    #$3c,D1
    ADD.L   D1,D0
    MOVE.W  12(A3),D1
    EXT.L   D1
    ADD.L   D1,D0
    MOVE.L  D0,D4
    MOVE.L  A3,-(A7)
    BSR.W   LAB_0668

    ADDQ.W  #4,A7
    TST.L   D4
    BLE.S   LAB_05DF

    MOVE.L  D4,D0
    BRA.S   LAB_05E0

LAB_05DF:
    MOVEQ   #-1,D0

LAB_05E0:
    MOVEM.L (A7)+,D4-D7/A3
    RTS

;!======

;!======
LAB_05E1:
    LINK.W  A5,#-12
    MOVEM.L D4-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.W  18(A5),D7
    MOVE.W  22(A5),D6
    MOVE.L  A3,-(A7)
    BSR.W   LAB_05D3

    ADDQ.W  #4,A7
    MOVE.L  D0,D5
    MOVE.L  D7,D0
    SUBI.W  #$36,D0
    MOVEM.W D0,-10(A5)
    MOVEQ   #1,D1
    CMP.W   D1,D6
    BNE.S   LAB_05E2

    MOVEQ   #1,D1
    BRA.S   LAB_05E3

LAB_05E2:
    MOVEQ   #0,D1

LAB_05E3:
    EXT.L   D0
    MOVE.W  D1,-12(A5)
    EXT.L   D1
    SUB.L   D1,D0
    MOVE.L  #$e10,D1
    JSR     JMP_TBL_LAB_1A06_2(PC)

    MOVE.L  D5,D4
    ADD.L   D0,D4
    MOVE.L  A2,-(A7)
    MOVE.L  D4,-(A7)
    BSR.W   LAB_05C7

    CLR.W   14(A2)
    MOVE.L  D4,D0
    MOVEM.L -36(A5),D4-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_05E4:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVE.W  LAB_2241,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     54.W
    MOVE.L  A3,-(A7)
    PEA     LAB_223A
    BSR.W   LAB_05E1

    LEA     16(A7),A7
    MOVE.L  D0,D7
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

LAB_05E5:
    LINK.W  A5,#-12
    MOVEM.L D2/D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVEQ   #0,D0
    MOVE.B  D0,-11(A5)
    MOVE.L  A3,D1
    BNE.S   LAB_05E6

    MOVEQ   #0,D0
    BRA.W   LAB_05F5

LAB_05E6:
    MOVE.L  12(A3),D0
    MOVE.L  8(A3),D1
    CMP.L   D0,D1
    BGE.S   LAB_05E7

    MOVE.B  -11(A5),D2
    MOVE.L  D1,D5
    MOVE.L  D0,D4
    MOVE.B  D2,-11(A5)
    BRA.S   LAB_05E9

LAB_05E7:
    CMP.L   D0,D1
    BLE.S   LAB_05E8

    BSET    #4,-11(A5)
    MOVE.L  D0,D5
    MOVE.L  D1,D4
    BRA.S   LAB_05E9

LAB_05E8:
    MOVEQ   #0,D0
    BRA.S   LAB_05F5

LAB_05E9:
    CMP.L   D5,D7
    BGE.S   LAB_05EA

    MOVE.B  -11(A5),D0
    MOVE.B  D0,-11(A5)
    BRA.S   LAB_05EC

LAB_05EA:
    CMP.L   D4,D7
    BGE.S   LAB_05EB

    BSET    #0,-11(A5)
    BRA.S   LAB_05EC

LAB_05EB:
    BSET    #1,-11(A5)

LAB_05EC:
    MOVEQ   #0,D0
    MOVE.B  -11(A5),D0
    TST.W   D0
    BEQ.S   LAB_05ED

    SUBQ.W  #1,D0
    BEQ.S   LAB_05EE

    SUBQ.W  #1,D0
    BEQ.S   LAB_05EF

    SUBI.W  #14,D0
    BEQ.S   LAB_05F0

    SUBQ.W  #1,D0
    BEQ.S   LAB_05F1

    SUBQ.W  #1,D0
    BEQ.S   LAB_05F2

    BRA.S   LAB_05F3

LAB_05ED:
    MOVEQ   #0,D6
    BRA.S   LAB_05F4

LAB_05EE:
    MOVEQ   #1,D6
    BRA.S   LAB_05F4

LAB_05EF:
    MOVEQ   #0,D6
    BRA.S   LAB_05F4

LAB_05F0:
    MOVEQ   #1,D6
    BRA.S   LAB_05F4

LAB_05F1:
    MOVEQ   #0,D6
    BRA.S   LAB_05F4

LAB_05F2:
    MOVEQ   #1,D6
    BRA.S   LAB_05F4

LAB_05F3:
    MOVEQ   #0,D6

LAB_05F4:
    MOVE.L  D6,D0

LAB_05F5:
    MOVEM.L (A7)+,D2/D4-D7/A3
    UNLK    A5
    RTS

;!======

LAB_05F6:
    LINK.W  A5,#-32
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEQ   #0,D6
    MOVE.L  A3,D0
    BEQ.S   LAB_05F7

    PEA     -26(A5)
    BSR.W   LAB_05E4

    MOVE.L  D0,D7
    MOVE.L  D7,(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_05E5

    ADDQ.W  #8,A7
    MOVE.L  D0,D5
    MOVE.W  16(A3),D0
    CMP.W   D5,D0
    BEQ.S   LAB_05F7

    MOVE.W  D5,16(A3)
    MOVEQ   #1,D6

LAB_05F7:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D5-D7/A3
    UNLK    A5
    RTS

;!======

LAB_05F8:
    LINK.W  A5,#0
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  A3,D0
    BEQ.S   LAB_05FB

    TST.L   (A3)
    BEQ.S   LAB_05FB

    TST.L   4(A3)
    BEQ.S   LAB_05FB

    MOVEQ   #21,D0
    MOVEA.L A2,A0
    MOVEA.L (A3),A1

LAB_05F9:
    MOVE.B  (A0)+,(A1)+
    DBF     D0,LAB_05F9
    MOVEQ   #21,D0
    MOVEA.L 16(A5),A0
    MOVEA.L 4(A3),A1

LAB_05FA:
    MOVE.B  (A0)+,(A1)+
    DBF     D0,LAB_05FA
    MOVE.L  A2,-(A7)
    BSR.W   LAB_05D3

    MOVE.L  D0,8(A3)
    MOVE.L  16(A5),(A7)
    BSR.W   LAB_05D3

    ADDQ.W  #4,A7
    MOVE.L  D0,12(A3)

LAB_05FB:
    MOVEM.L (A7)+,A2-A3
    UNLK    A5
    RTS

;!======

LAB_05FC:
    LINK.W  A5,#-20
    MOVEM.L D2/D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.B  19(A5),D7
    MOVEQ   #0,D5
    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A2,-(A7)
    JSR     LAB_05C1(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-12(A5)
    BEQ.W   LAB_0602

    MOVE.L  A3,D0
    BEQ.W   LAB_0602

    MOVEQ   #21,D0
    MOVEQ   #0,D1
    MOVEA.L A3,A0

LAB_05FD:
    MOVE.B  D1,(A0)+
    DBF     D0,LAB_05FD
    MOVEA.L -12(A5),A0
    ADDQ.L  #1,A0
    PEA     7.W
    MOVE.L  A0,-(A7)
    PEA     -8(A5)
    JSR     LAB_0470(PC)

    CLR.B   -1(A5)
    PEA     -8(A5)
    JSR     LAB_0468(PC)

    LEA     16(A7),A7
    MOVE.L  D0,D6
    MOVE.L  D6,D0
    MOVE.L  #1000,D1
    JSR     JMP_TBL_LAB_1A07_1(PC)

    MOVE.W  D0,6(A3)
    MOVE.L  D6,D0
    MOVE.L  #1000,D1
    JSR     JMP_TBL_LAB_1A07_1(PC)

    MOVE.W  D1,16(A3)
    MOVE.W  6(A3),D0
    EXT.L   D0
    MOVE.W  LAB_223D,D2
    EXT.L   D2
    SUB.L   D2,D0
    BGE.S   LAB_05FE

    MOVE.W  6(A3),D0
    EXT.L   D0
    MOVE.W  LAB_223D,D2
    EXT.L   D2
    SUB.L   D2,D0
    NEG.L   D0
    BRA.S   LAB_05FF

LAB_05FE:
    MOVE.W  6(A3),D0
    EXT.L   D0
    MOVE.W  LAB_223D,D2
    EXT.L   D2
    SUB.L   D2,D0

LAB_05FF:
    MOVEQ   #1,D2
    CMP.L   D2,D0
    BGT.W   LAB_0602

    MOVEQ   #1,D0
    CMP.W   D0,D1
    BLE.W   LAB_0602

    MOVE.W  6(A3),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0660

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   LAB_0600

    MOVEQ   #1,D0
    BRA.S   LAB_0601

LAB_0600:
    MOVEQ   #0,D0

LAB_0601:
    ADDI.L  #366,D0
    MOVE.W  16(A3),D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   LAB_0602

    MOVEA.L -12(A5),A0
    ADDQ.L  #8,A0
    MOVE.L  A0,-(A7)
    JSR     LAB_0468(PC)

    ADDQ.W  #4,A7
    MOVE.W  D0,8(A3)
    TST.W   D0
    BMI.S   LAB_0602

    MOVEQ   #24,D1
    CMP.W   D1,D0
    BGE.S   LAB_0602

    MOVEA.L -12(A5),A0
    ADDA.W  #11,A0
    MOVE.L  A0,-(A7)
    JSR     LAB_0468(PC)

    ADDQ.W  #4,A7
    MOVE.W  D0,10(A3)
    TST.W   D0
    BMI.S   LAB_0602

    MOVEQ   #60,D1
    CMP.W   D1,D0
    BGE.S   LAB_0602

    MOVEQ   #0,D0
    MOVE.W  D0,12(A3)
    MOVE.W  D0,14(A3)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_0668

    MOVE.L  A3,(A7)
    BSR.W   LAB_05D3

    MOVE.L  A3,(A7)
    MOVE.L  D0,-(A7)
    BSR.W   LAB_05C7

    ADDQ.W  #8,A7
    MOVEQ   #1,D5

LAB_0602:
    TST.W   D5
    BNE.S   LAB_0604

    MOVEQ   #21,D0
    MOVEQ   #0,D1
    MOVEA.L A3,A0

LAB_0603:
    MOVE.B  D1,(A0)+
    DBF     D0,LAB_0603

LAB_0604:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D2/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_0605:
    LINK.W  A5,#-140
    MOVEM.L D6-D7/A3,-(A7)
    MOVE.L  8(A5),D7
    MOVEA.L 12(A5),A3
    CLR.B   -87(A5)
    MOVE.L  A3,D0
    BEQ.W   LAB_060D

    MOVEA.L (A3),A0
    MOVE.L  A0,-4(A5)
    MOVE.L  A0,D0
    BEQ.W   LAB_0608

    PEA     4.W
    PEA     LAB_1CF8
    PEA     -138(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    PEA     -138(A5)
    PEA     -87(A5)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    MOVEA.L -4(A5),A0
    MOVE.W  6(A0),D0
    EXT.L   D0
    MOVE.W  16(A0),D1
    EXT.L   D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_1CF9
    PEA     -138(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    PEA     -138(A5)
    PEA     -87(A5)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    LEA     40(A7),A7
    MOVEA.L -4(A5),A0
    MOVE.W  8(A0),D0
    EXT.L   D0
    MOVEQ   #12,D1
    JSR     JMP_TBL_LAB_1A07_1(PC)

    TST.W   18(A0)
    BEQ.S   LAB_0606

    MOVEQ   #12,D0
    BRA.S   LAB_0607

LAB_0606:
    MOVEQ   #0,D0

LAB_0607:
    ADD.L   D0,D1
    MOVE.L  D1,D6
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.W  10(A0),D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_1CFA
    PEA     -138(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    PEA     -138(A5)
    PEA     -87(A5)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    LEA     24(A7),A7
    BRA.S   LAB_0609

LAB_0608:
    PEA     LAB_1CFB
    PEA     -87(A5)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    ADDQ.W  #8,A7

LAB_0609:
    MOVEA.L 4(A3),A0
    MOVE.L  A0,-4(A5)
    MOVE.L  A0,D0
    BEQ.W   LAB_060C

    PEA     19.W
    PEA     LAB_1CFC
    PEA     -138(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    PEA     -138(A5)
    PEA     -87(A5)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    MOVEA.L -4(A5),A0
    MOVE.W  6(A0),D0
    EXT.L   D0
    MOVE.W  16(A0),D1
    EXT.L   D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_1CFD
    PEA     -138(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    PEA     -138(A5)
    PEA     -87(A5)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    LEA     40(A7),A7
    MOVEA.L -4(A5),A0
    MOVE.W  8(A0),D0
    EXT.L   D0
    MOVEQ   #12,D1
    JSR     JMP_TBL_LAB_1A07_1(PC)

    TST.W   18(A0)
    BEQ.S   LAB_060A

    MOVEQ   #12,D0
    BRA.S   LAB_060B

LAB_060A:
    MOVEQ   #0,D0

LAB_060B:
    ADD.L   D0,D1
    MOVE.L  D1,D6
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.W  10(A0),D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_1CFE
    PEA     -138(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    PEA     -138(A5)
    PEA     -87(A5)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    LEA     24(A7),A7
    BRA.S   LAB_060E

LAB_060C:
    PEA     LAB_1CFF
    PEA     -87(A5)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    ADDQ.W  #8,A7
    BRA.S   LAB_060E

LAB_060D:
    PEA     LAB_1D00
    PEA     -87(A5)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    ADDQ.W  #8,A7

LAB_060E:
    LEA     -87(A5),A0
    MOVEA.L A0,A1

LAB_060F:
    TST.B   (A1)+
    BNE.S   LAB_060F

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D7,-(A7)
    JSR     LAB_03A0(PC)

    MOVEM.L -152(A5),D6-D7/A3
    UNLK    A5
    RTS

;!======

LAB_0610:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVE.L  A3,D0
    BEQ.S   .LAB_0611

    TST.L   (A3)
    BEQ.S   .LAB_0611

    TST.L   4(A3)
    BEQ.S   .LAB_0611

    PEA     MODE_NEWFILE.W
    MOVE.L  LAB_1CF7,-(A7)
    JSR     LOAD_FILE_CONTENTS_INTO_MEMORY_MAYBE(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D7
    TST.L   D7
    BEQ.S   .LAB_0611

    PEA     4.W
    PEA     LAB_1D01
    MOVE.L  D7,-(A7)
    JSR     LAB_03A0(PC)

    MOVE.L  4(A3),(A7)
    MOVE.L  D7,-(A7)
    BSR.W   LAB_0605

    PEA     4.W
    PEA     LAB_1D02
    MOVE.L  D7,-(A7)
    JSR     LAB_03A0(PC)

    MOVE.L  (A3),(A7)
    MOVE.L  D7,-(A7)
    BSR.W   LAB_0605

    MOVE.L  D7,(A7)
    JSR     LAB_039A(PC)

    LEA     32(A7),A7
    MOVEQ   #1,D0
    BRA.S   .return

.LAB_0611:
    MOVEQ   #0,D0

.return:
    MOVEM.L (A7)+,D7/A3
    RTS
