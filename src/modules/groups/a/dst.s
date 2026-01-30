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

;!======

LAB_0623:
    LINK.W  A5,#-44
    MOVEM.L D7/A3,-(A7)
    MOVE.B  11(A5),D7
    MOVEA.L 12(A5),A3
    MOVE.B  D7,D0
    EXT.W   D0
    SUBI.W  #$32,D0
    BEQ.S   LAB_0624

    SUBQ.W  #1,D0
    BEQ.S   LAB_0625

    BRA.S   LAB_0626

LAB_0624:
    PEA     4.W
    MOVE.L  A3,-(A7)
    PEA     -22(A5)
    BSR.W   LAB_05FC

    PEA     19.W
    MOVE.L  A3,-(A7)
    PEA     -44(A5)
    BSR.W   LAB_05FC

    PEA     -44(A5)
    PEA     -22(A5)
    MOVE.L  LAB_21E0,-(A7)
    BSR.W   LAB_05F8

    LEA     36(A7),A7
    BRA.S   LAB_0626

LAB_0625:
    PEA     4.W
    MOVE.L  A3,-(A7)
    PEA     -22(A5)
    BSR.W   LAB_05FC

    PEA     19.W
    MOVE.L  A3,-(A7)
    PEA     -44(A5)
    BSR.W   LAB_05FC

    PEA     -44(A5)
    PEA     -22(A5)
    MOVE.L  LAB_21DF,-(A7)
    BSR.W   LAB_05F8

    LEA     36(A7),A7

LAB_0626:
    PEA     LAB_21DF
    BSR.W   DST_UpdateBannerQueue

    MOVEM.L -52(A5),D7/A3
    UNLK    A5
    RTS

;!======

LAB_0627:
    JSR     LAB_066F(PC)

    RTS

;!======

; Update the rotating banner queue; free resources when entries expire.
DST_UpdateBannerQueue:
LAB_0628:
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVEQ   #0,D6
    MOVE.L  A3,D0
    BEQ.W   LAB_0630

    TST.L   (A3)
    BEQ.S   LAB_062B

    MOVEA.L (A3),A0
    MOVE.W  LAB_2241,16(A0)
    MOVE.L  (A3),-(A7)
    BSR.W   LAB_05F6

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   LAB_062C

    MOVEA.L (A3),A0
    TST.W   16(A0)
    BEQ.S   LAB_0629

    MOVEQ   #1,D0
    BRA.S   LAB_062A

LAB_0629:
    MOVEQ   #-1,D0

LAB_062A:
    MOVE.L  D0,D7
    MOVE.L  D7,D0
    EXT.L   D0
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_223A
    BSR.W   LAB_0656

    MOVEA.L (A3),A0
    MOVE.W  16(A0),LAB_2241
    BSR.S   LAB_0627

    LEA     12(A7),A7
    MOVEQ   #1,D6
    BRA.S   LAB_062C

LAB_062B:
    MOVE.W  LAB_2241,D0
    SUBQ.W  #1,D0
    BNE.S   LAB_062C

    CLR.L   -(A7)
    PEA     -1.W
    PEA     LAB_223A
    BSR.W   LAB_0656

    LEA     12(A7),A7
    CLR.W   LAB_2241
    MOVEQ   #1,D6

LAB_062C:
    MOVE.B  LAB_1DD2,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   LAB_062E

    TST.L   4(A3)
    BEQ.S   LAB_062D

    MOVEA.L 4(A3),A0
    MOVE.W  LAB_227B,16(A0)
    MOVE.L  4(A3),-(A7)
    BSR.W   LAB_05F6

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   LAB_062F

    MOVEA.L 4(A3),A0
    MOVE.W  16(A0),D0
    MOVE.W  D0,LAB_227B
    MOVEQ   #1,D6
    BRA.S   LAB_062F

LAB_062D:
    MOVE.W  LAB_227B,D0
    SUBQ.W  #1,D0
    BNE.S   LAB_062F

    MOVEQ   #0,D0
    MOVE.W  D0,LAB_227B
    MOVEQ   #1,D6
    BRA.S   LAB_062F

LAB_062E:
    MOVE.W  LAB_227B,D0
    SUBQ.W  #1,D0
    BNE.S   LAB_062F

    MOVE.L  4(A3),-(A7)
    BSR.W   LAB_0618

    ADDQ.W  #4,A7
    MOVE.L  D0,4(A3)
    CLR.W   LAB_227B
    MOVEQ   #1,D6

LAB_062F:
    TST.L   D6
    BEQ.S   LAB_0630

    BSR.W   DST_RefreshBannerBuffer

LAB_0630:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======

LAB_0631:
    MOVEM.L D5-D7,-(A7)
    MOVE.W  18(A7),D7
    MOVE.W  22(A7),D6
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0660

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   LAB_0632

    MOVE.L  #366,D0
    BRA.S   LAB_0633

LAB_0632:
    MOVE.L  #$16d,D0

LAB_0633:
    MOVE.L  D0,D5

LAB_0634:
    CMP.W   D5,D7
    BLE.S   LAB_0637

    SUB.W   D5,D7
    ADDQ.W  #1,D6
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0660

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   LAB_0635

    MOVE.L  #366,D0
    BRA.S   LAB_0636

LAB_0635:
    MOVE.L  #$16d,D0

LAB_0636:
    MOVE.L  D0,D5
    BRA.S   LAB_0634

LAB_0637:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D5-D7
    RTS

;!======

LAB_0638:
    LINK.W  A5,#-36
    MOVEM.L D2-D3/D5-D7/A2-A3,-(A7)
    MOVE.W  10(A5),D7
    MOVE.B  15(A5),D6
    MOVEA.L 16(A5),A3
    MOVEA.L 20(A5),A2
    LEA     LAB_223A,A0
    LEA     -22(A5),A1
    MOVEQ   #4,D0

LAB_0639:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,LAB_0639
    MOVE.W  (A0),(A1)
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVE.W  LAB_2242,D1
    MOVE.W  D0,-30(A5)
    CMPI.W  #$ff,D1
    BLT.S   LAB_063B

    CMP.W   D0,D1
    BEQ.S   LAB_063B

    MOVE.L  D1,D2
    ANDI.W  #$ff,D2
    CMP.W   D0,D2
    BEQ.S   LAB_063A

    EXT.L   D1
    ADDQ.L  #1,D1
    MOVEQ   #0,D2
    NOT.B   D2
    AND.L   D2,D1
    EXT.L   D0
    CMP.L   D1,D0
    BNE.S   LAB_063B

LAB_063A:
    BSET    #0,-30(A5)

LAB_063B:
    MOVE.W  -30(A5),D0
    MOVEQ   #1,D1
    CMP.W   D1,D0
    BNE.S   LAB_063C

    MOVE.W  LAB_2242,D2
    SUBQ.W  #1,D2
    BEQ.S   LAB_063C

    MOVE.W  -16(A5),D2
    ADDQ.W  #1,D2
    MOVE.W  D2,-16(A5)

LAB_063C:
    MOVEQ   #39,D2
    CMP.W   D2,D7
    BLT.S   LAB_063D

    ADDQ.W  #1,-30(A5)

LAB_063D:
    MOVE.W  LAB_223D,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0660

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   LAB_063E

    MOVE.L  #366,D0
    BRA.S   LAB_063F

LAB_063E:
    MOVE.L  #$16d,D0

LAB_063F:
    MOVE.W  D0,-36(A5)
    MOVE.W  -30(A5),D1
    CMP.W   D0,D1
    BLE.S   LAB_0640

    SUB.W   D0,-30(A5)
    MOVE.W  -16(A5),D0
    ADDQ.W  #1,D0
    MOVE.W  D0,-16(A5)

LAB_0640:
    MOVE.W  -30(A5),-6(A5)
    MOVEQ   #0,D0
    MOVE.W  D0,-10(A5)
    MOVE.L  D7,D1
    EXT.L   D1
    SUBQ.L  #1,D1
    MOVE.L  D1,D0
    MOVEQ   #2,D1
    JSR     JMP_TBL_LAB_1A07_1(PC)

    MOVEQ   #30,D0
    JSR     GROUPA_JMP_TBL_LAB_1A06(PC)

    MOVE.W  D0,-12(A5)
    MOVE.L  D7,D0
    EXT.L   D0
    SUBQ.L  #1,D0
    TST.L   D0
    BPL.S   LAB_0641

    ADDQ.L  #1,D0

LAB_0641:
    ASR.L   #1,D0
    ADDQ.L  #5,D0
    MOVEQ   #12,D1
    JSR     JMP_TBL_LAB_1A07_1(PC)

    MOVE.W  D1,-14(A5)
    BNE.S   LAB_0642

    MOVE.W  #12,-14(A5)

LAB_0642:
    MOVE.L  D7,D0
    EXT.L   D0
    SUBQ.L  #1,D0
    TST.L   D0
    BPL.S   LAB_0643

    ADDQ.L  #1,D0

LAB_0643:
    ASR.L   #1,D0
    ADDQ.L  #5,D0
    MOVEQ   #24,D1
    JSR     JMP_TBL_LAB_1A07_1(PC)

    MOVEQ   #11,D0
    CMP.L   D0,D1
    BLE.S   LAB_0644

    MOVEQ   #-1,D0
    BRA.S   LAB_0645

LAB_0644:
    MOVEQ   #0,D0

LAB_0645:
    MOVE.W  D0,-4(A5)
    MOVE.W  -8(A5),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     54.W
    LEA     -22(A5),A0
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   LAB_05E1

    LEA     16(A7),A7
    MOVE.L  D0,D5
    MOVE.B  LAB_1DD2,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   LAB_0646

    MOVE.L  D5,-(A7)
    MOVE.L  LAB_21E0,-(A7)
    BSR.W   LAB_05E5

    ADDQ.W  #8,A7
    EXT.L   D0
    BRA.S   LAB_0647

LAB_0646:
    MOVEQ   #0,D0

LAB_0647:
    MOVE.L  D5,-(A7)
    MOVE.L  LAB_21DF,-(A7)
    MOVE.W  D0,-32(A5)
    BSR.W   LAB_05E5

    ADDQ.W  #8,A7
    MOVEQ   #0,D1
    MOVE.B  LAB_1DD1,D1
    MOVEQ   #54,D2
    SUB.L   D2,D1
    MOVE.W  D0,-34(A5)
    MOVEM.W D1,-28(A5)
    MOVEQ   #1,D2
    CMP.W   D2,D0
    BNE.S   LAB_0648

    SUBQ.W  #1,-28(A5)

LAB_0648:
    CMP.W   -32(A5),D2
    BNE.S   LAB_0649

    ADDQ.W  #1,-28(A5)

LAB_0649:
    MOVE.W  -28(A5),D1
    MOVE.W  D1,(A3)
    MOVE.L  A2,D3
    BEQ.S   LAB_064C

    SUBQ.W  #1,D0
    BNE.S   LAB_064A

    MOVEQ   #1,D0
    BRA.S   LAB_064B

LAB_064A:
    MOVEQ   #0,D0

LAB_064B:
    EXT.L   D1
    ADD.L   D0,D1
    MOVE.W  D1,-28(A5)
    MULS    #$e10,D1
    ADD.L   D1,D5
    MOVEQ   #0,D0
    MOVE.B  LAB_1DD8,D0
    MOVEQ   #60,D1
    JSR     GROUPA_JMP_TBL_LAB_1A06(PC)

    ADD.L   D0,D5
    MOVE.L  A2,-(A7)
    MOVE.L  D5,-(A7)
    BSR.W   LAB_05C7

    ADDQ.W  #8,A7
    MOVE.W  -32(A5),14(A2)

LAB_064C:
    MOVEM.L (A7)+,D2-D3/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_064D:
    LINK.W  A5,#-4
    MOVEM.L D6-D7,-(A7)
    MOVE.W  10(A5),D7
    MOVE.B  15(A5),D6
    MOVE.L  D7,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  D6,D1
    CLR.L   -(A7)
    PEA     -2(A5)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0638

    MOVE.W  -2(A5),D0
    MOVEM.L -12(A5),D6-D7
    UNLK    A5
    RTS

;!======

LAB_064E:
    LINK.W  A5,#-4
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVE.B  19(A5),D6
    MOVE.L  D7,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  D6,D1
    MOVE.L  A3,-(A7)
    PEA     -2(A5)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0638

    LEA     16(A7),A7
    MOVE.W  8(A3),D0
    EXT.L   D0
    MOVEQ   #12,D1
    JSR     JMP_TBL_LAB_1A07_1(PC)

    TST.W   18(A3)
    BEQ.S   LAB_064F

    MOVEQ   #12,D0
    BRA.S   LAB_0650

LAB_064F:
    MOVEQ   #0,D0

LAB_0650:
    ADD.L   D0,D1
    ADD.L   D1,D1
    CMPI.W  #$1d,10(A3)
    SGT     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    ADD.L   D0,D1
    BEQ.S   LAB_0651

    MOVEQ   #1,D0
    BRA.S   LAB_0652

LAB_0651:
    MOVEQ   #0,D0

LAB_0652:
    MOVE.L  D0,D7
    ADDI.W  #$26,D7
    MOVE.L  D7,D0
    EXT.L   D0
    DIVS    #$30,D0
    SWAP    D0
    MOVE.L  D0,D7
    ADDQ.W  #1,D7
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D6-D7/A3
    UNLK    A5
    RTS

;!======

LAB_0653:
    MOVEQ   #0,D0
    MOVE.B  LAB_1DD1,D0
    SUBI.W  #$36,D0
    MOVE.W  D0,LAB_225C
    MOVE.W  LAB_2241,D1
    SUBQ.W  #1,D1
    BNE.S   LAB_0654

    MOVE.L  D0,D1
    SUBQ.W  #1,D1
    MOVE.W  D1,LAB_225C

LAB_0654:
    MOVE.W  LAB_227B,D0
    SUBQ.W  #1,D0
    BNE.S   LAB_0655

    MOVE.W  LAB_225C,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_225C

LAB_0655:
    RTS

;!======

LAB_0656:
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.W  26(A7),D7
    MOVE.W  30(A7),D6
    MOVE.L  A3,-(A7)
    BSR.W   LAB_05D3

    ADDQ.W  #4,A7
    MOVE.L  D0,D5
    MOVE.L  D7,D0
    MULS    #$e10,D0
    MOVE.L  D6,D1
    MULS    #$3c,D1
    ADD.L   D1,D0
    ADD.L   D0,D5
    MOVE.L  A3,-(A7)
    MOVE.L  D5,-(A7)
    BSR.W   LAB_05C7

    ADDQ.W  #8,A7
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======

LAB_0657:
    LINK.W  A5,#-40
    MOVEM.L D2-D6/A2-A3/A6,-(A7)
    MOVEA.L 80(A7),A3
    MOVEA.L 84(A7),A2
    MOVE.W  (A2),D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     GLOB_JMP_TBL_SHORT_DAYS_OF_WEEK,A0
    ADDA.L  D0,A0
    MOVE.W  2(A2),D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     GLOB_JMP_TBL_SHORT_MONTHS,A1
    ADDA.L  D0,A1
    MOVE.W  4(A2),D0
    EXT.L   D0
    MOVE.W  6(A2),D1
    EXT.L   D1
    MOVE.W  16(A2),D2
    EXT.L   D2
    MOVE.W  8(A2),D3
    EXT.L   D3
    MOVE.W  10(A2),D4
    EXT.L   D4
    MOVE.W  12(A2),D5
    EXT.L   D5
    TST.W   18(A2)
    BEQ.S   LAB_0658

    LEA     LAB_1D0D,A6
    BRA.S   LAB_0659

LAB_0658:
    LEA     LAB_1D0E,A6

LAB_0659:
    MOVE.L  A6,64(A7)
    MOVEQ   #1,D6
    CMP.W   14(A2),D6
    BNE.S   LAB_065A

    LEA     LAB_1D0F,A6
    BRA.S   LAB_065B

LAB_065A:
    LEA     LAB_1D10,A6

LAB_065B:
    MOVE.L  A6,68(A7)
    TST.W   20(A2)
    BEQ.S   LAB_065C

    LEA     LAB_1D11,A6
    BRA.S   LAB_065D

LAB_065C:
    LEA     LAB_1D12,A6

LAB_065D:
    MOVE.L  A6,-(A7)
    MOVE.L  72(A7),-(A7)
    MOVE.L  72(A7),-(A7)
    MOVE.L  D5,-(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  (A1),-(A7)
    MOVE.L  (A0),-(A7)
    MOVE.L  A3,-(A7)
    PEA     LAB_1D0C
    JSR     LAB_066D(PC)

    MOVEM.L -72(A5),D2-D6/A2-A3/A6
    UNLK    A5
    RTS

;!======

; Copy the next banner entry into the staging buffer and trigger drawing.
DST_RefreshBannerBuffer:
LAB_065E:
    MOVE.L  D7,-(A7)
    BSR.W   LAB_0653

    MOVE.W  LAB_227B,D7
    LEA     LAB_223A,A0
    LEA     LAB_2274,A1
    MOVEQ   #4,D0

LAB_065F:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,LAB_065F
    MOVE.W  (A0),(A1)
    MOVE.W  D7,LAB_227B
    MOVE.W  LAB_225C,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  LAB_1DD8,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_2274
    BSR.W   LAB_0656

    LEA     12(A7),A7
    MOVE.L  (A7)+,D7
    RTS

;!======

LAB_0660:
    MOVEM.L D6-D7,-(A7)
    MOVE.L  12(A7),D7
    CMPI.L  #$76c,D7
    BGE.S   LAB_0661

    ADDI.L  #$76c,D7

LAB_0661:
    MOVE.L  D7,D0
    MOVEQ   #4,D1
    JSR     JMP_TBL_LAB_1A07_1(PC)

    TST.L   D1
    BNE.S   LAB_0662

    MOVE.L  D7,D0
    MOVEQ   #100,D1
    JSR     JMP_TBL_LAB_1A07_1(PC)

    TST.L   D1
    BNE.S   LAB_0663

LAB_0662:
    MOVE.L  D7,D0
    MOVE.L  #400,D1
    JSR     JMP_TBL_LAB_1A07_1(PC)

    TST.L   D1
    BEQ.S   LAB_0663

    MOVEQ   #0,D0
    BRA.S   LAB_0664

LAB_0663:
    MOVEQ   #1,D0

LAB_0664:
    MOVE.L  D0,D6
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7
    RTS

;!======

LAB_0665:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    MOVE.W  8(A3),D0
    EXT.L   D0
    MOVEQ   #12,D1
    JSR     JMP_TBL_LAB_1A07_1(PC)

    TST.W   18(A3)
    BEQ.S   LAB_0666

    MOVEQ   #12,D0
    BRA.S   LAB_0667

LAB_0666:
    MOVEQ   #0,D0

LAB_0667:
    ADD.L   D0,D1
    MOVE.W  D1,8(A3)
    MOVE.L  D1,D0
    MOVEA.L (A7)+,A3
    RTS

;!======

LAB_0668:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    MOVE.W  8(A3),D0
    MOVEQ   #11,D1
    CMP.W   D1,D0
    BLE.S   LAB_0669

    MOVEQ   #-1,D1
    BRA.S   LAB_066A

LAB_0669:
    MOVEQ   #0,D1

LAB_066A:
    MOVE.W  D1,18(A3)
    MOVE.W  8(A3),D0
    EXT.L   D0
    MOVEQ   #12,D1
    DIVS    D1,D0
    SWAP    D0
    MOVE.W  D0,8(A3)
    TST.W   D0
    BNE.S   LAB_066B

    MOVE.W  D1,8(A3)

LAB_066B:
    MOVEA.L (A7)+,A3
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

LAB_066C:
    JMP     LAB_1A97

LAB_066D:
    JMP     LAB_1906

LAB_066E:
    JMP     LAB_1A0A

LAB_066F:
    JMP     LAB_146E

JMP_TBL_LAB_1A06_3:
    JMP     LAB_1A06

;!======

    ; Alignment
    MOVEQ   #97,D0
