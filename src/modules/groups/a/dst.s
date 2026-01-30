LAB_0613:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    MOVE.L  A3,D0
    BEQ.S   .return

    TST.L   (A3)
    BEQ.S   .LAB_0614

    PEA     22.W
    MOVE.L  (A3),-(A7)
    PEA     773.W
    PEA     GLOB_STR_DST_C_1
    JSR     GROUPA_JMP_TBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.LAB_0614:
    TST.L   4(A3)
    BEQ.S   .LAB_0615

    PEA     22.W
    MOVE.L  4(A3),-(A7)
    PEA     777.W
    PEA     GLOB_STR_DST_C_2
    JSR     GROUPA_JMP_TBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.LAB_0615:
    PEA     18.W
    MOVE.L  A3,-(A7)
    PEA     779.W
    PEA     GLOB_STR_DST_C_3
    JSR     GROUPA_JMP_TBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.return:
    MOVEA.L (A7)+,A3
    RTS

;!======

LAB_0617:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    MOVE.L  (A3),-(A7)
    BSR.S   LAB_0613

    CLR.L   (A3)
    MOVE.L  4(A3),(A7)
    BSR.S   LAB_0613

    ADDQ.W  #4,A7
    CLR.L   4(A3)
    MOVEA.L (A7)+,A3
    RTS

;!======

LAB_0618:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEQ   #0,D7
    MOVE.L  A3,-(A7)
    BSR.W   LAB_0613

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),(A7)
    PEA     18.W                            ; What's 18 bytes big?
    PEA     798.W
    PEA     GLOB_STR_DST_C_4
    JSR     GROUPA_JMP_TBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L D0,A3
    TST.L   D0
    BEQ.S   .LAB_0619

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     22.W                            ; What's 22 bytes big?
    PEA     803.W
    PEA     GLOB_STR_DST_C_5
    JSR     GROUPA_JMP_TBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,(A3)
    TST.L   D0
    BEQ.S   .LAB_0619

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     22.W                            ; What's 22 bytes big?
    PEA     807.W
    PEA     GLOB_STR_DST_C_6
    JSR     GROUPA_JMP_TBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,4(A3)
    TST.L   D0
    BEQ.S   .LAB_0619

    MOVEQ   #1,D7
    CLR.W   16(A3)

.LAB_0619:
    TST.L   D7
    BNE.S   .return

    MOVE.L  A3,-(A7)
    BSR.W   LAB_0613

    ADDQ.W  #4,A7

.return:
    MOVE.L  A3,D0
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

LAB_061B:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEQ   #0,D7
    MOVE.L  A3,-(A7)
    BSR.W   LAB_0617

    MOVE.L  (A3),(A7)
    BSR.W   LAB_0618

    ADDQ.W  #4,A7
    MOVE.L  D0,(A3)
    TST.L   D0
    BEQ.S   .LAB_061C

    MOVE.L  4(A3),-(A7)
    BSR.W   LAB_0618

    ADDQ.W  #4,A7
    MOVE.L  D0,4(A3)
    TST.L   (A3)
    BEQ.S   .LAB_061C

    MOVEQ   #1,D7

.LAB_061C:
    TST.W   D7
    BNE.S   .return

    MOVE.L  A3,-(A7)
    BSR.W   LAB_0617

    ADDQ.W  #4,A7

.return:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

LAB_061E:
    LINK.W  A5,#-56
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  A3,-(A7)
    BSR.S   LAB_061B

    MOVE.L  LAB_1CF7,(A7)
    JSR     LAB_03AC(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BNE.S   LAB_061F

    MOVEQ   #0,D0
    BRA.W   LAB_0622

LAB_061F:
    MOVEA.L LAB_21BC,A0
    MOVE.L  GLOB_REF_LONG_FILE_SCRATCH,D7
    PEA     GLOB_STR_G2
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-48(A5)
    JSR     LAB_066C(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-52(A5)
    BEQ.S   LAB_0620

    PEA     4.W
    MOVE.L  D0,-(A7)
    PEA     -22(A5)
    BSR.W   LAB_05FC

    PEA     19.W
    MOVE.L  -52(A5),-(A7)
    PEA     -44(A5)
    BSR.W   LAB_05FC

    PEA     -44(A5)
    PEA     -22(A5)
    MOVE.L  4(A3),-(A7)
    BSR.W   LAB_05F8

    LEA     36(A7),A7

LAB_0620:
    PEA     GLOB_STR_G3
    MOVE.L  -48(A5),-(A7)
    JSR     LAB_066C(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-52(A5)
    BEQ.S   LAB_0621

    PEA     4.W
    MOVE.L  D0,-(A7)
    PEA     -22(A5)
    BSR.W   LAB_05FC

    PEA     19.W
    MOVE.L  -52(A5),-(A7)
    PEA     -44(A5)
    BSR.W   LAB_05FC

    PEA     -44(A5)
    PEA     -22(A5)
    MOVE.L  (A3),-(A7)
    BSR.W   LAB_05F8

    LEA     36(A7),A7

LAB_0621:
    MOVE.L  D7,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -48(A5),-(A7)
    PEA     889.W
    PEA     GLOB_STR_DST_C_7
    JSR     GROUPA_JMP_TBL_MEMORY_DeallocateMemory(PC)

    MOVE.L  A3,(A7)
    BSR.W   DST_UpdateBannerQueue

    MOVEQ   #1,D0

LAB_0622:
    MOVEM.L -64(A5),D7/A3
    UNLK    A5
    RTS
