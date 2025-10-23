;!======

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
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

    LEA     16(A7),A7

.LAB_0614:
    TST.L   4(A3)
    BEQ.S   .LAB_0615

    PEA     22.W
    MOVE.L  4(A3),-(A7)
    PEA     777.W
    PEA     GLOB_STR_DST_C_2
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

    LEA     16(A7),A7

.LAB_0615:
    PEA     18.W
    MOVE.L  A3,-(A7)
    PEA     779.W
    PEA     GLOB_STR_DST_C_3
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

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
    JSR     JMP_TBL_ALLOCATE_MEMORY_1(PC)

    LEA     16(A7),A7
    MOVEA.L D0,A3
    TST.L   D0
    BEQ.S   .LAB_0619

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     22.W                            ; What's 22 bytes big?
    PEA     803.W
    PEA     GLOB_STR_DST_C_5
    JSR     JMP_TBL_ALLOCATE_MEMORY_1(PC)

    LEA     16(A7),A7
    MOVE.L  D0,(A3)
    TST.L   D0
    BEQ.S   .LAB_0619

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     22.W                            ; What's 22 bytes big?
    PEA     807.W
    PEA     GLOB_STR_DST_C_6
    JSR     JMP_TBL_ALLOCATE_MEMORY_1(PC)

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
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

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
    JSR     JMP_TBL_LAB_1A06_2(PC)

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
    JSR     JMP_TBL_LAB_1A06_2(PC)

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
    DC.W    $0000

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

;!======

LAB_0671:
    MOVE.L  LAB_231C,D0
    MOVE.L  LAB_231B,D1
    CMP.L   D0,D1
    BEQ.W   LAB_0677

    TST.L   LAB_1D14
    BEQ.W   LAB_0677

    CLR.L   LAB_1D14
    LSL.L   #2,D0
    ADD.L   LAB_231C,D0
    LEA     LAB_231D,A0
    ADDA.L  D0,A0
    MOVE.B  (A0),LAB_21ED
    TST.W   LAB_2263
    BEQ.S   .LAB_0672

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    JSR     _LVOSetBPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

.LAB_0672:
    MOVE.B  LAB_1D13,D0
    EXT.W   D0
    CMPI.W  #$19,D0
    BCC.W   .LAB_0675

    ADD.W   D0,D0
    MOVE.W  .LAB_0673(PC,D0.W),D0
    JMP     .LAB_0673+2(PC,D0.W)    ; This jumps somewhere past LAB_0673 ... maybe to the JSR?

; This looks like data that's not processed right.
; This might actually be a Copperlist or some other coprocessor data...?
; http://amigadev.elowar.com/read/ADCD_2.1/Hardware_Manual_guide/node004A.html
.LAB_0673:
    ; ORI.B   #$3c,66(A0,D0.W)
    DC.B    $00,$30,$00,$3c,$00,$42
    ORI.W   #$4e,D2
    DC.W    $0048
    ORI.W   #$60,(A2)+
    ORI.W   #$54,-(A6)
    ORI.W   #$72,120(A4)
    DC.W    $007e
    ORI.L   #$8a008e,D4
    DC.W    $008e
    DC.W    $008e
    DC.W    $008e
    DC.W    $008e
    DC.W    $008e
    DC.W    $008e
    DC.W    $008e
    DC.W    $0036
    JSR     LAB_0756(PC)

    BRA.S   .LAB_0675

    BSR.W   LAB_06C1

    BRA.S   .LAB_0675

    BSR.W   LAB_0701

    BRA.S   .LAB_0675

    BSR.W   LAB_06EC

    BRA.S   .LAB_0675

    BSR.W   LAB_06FC

    BRA.S   .LAB_0675

    BSR.W   LAB_0678

    BRA.S   .LAB_0675

    BSR.W   LAB_06C0

    BRA.S   .LAB_0675

    JSR     LAB_07B8(PC)

    BRA.S   .LAB_0675

    JSR     LAB_079A(PC)

    BRA.S   .LAB_0675

    BSR.W   LAB_070C

    BRA.S   .LAB_0675

    BSR.W   LAB_06DB

    BRA.S   .LAB_0675

    BSR.W   LAB_06E2

    BRA.S   .LAB_0675

    BSR.W   LAB_06E4

    BRA.S   .LAB_0675

    BSR.W   LAB_06E6

    BRA.S   .LAB_0675

    BSR.W   LAB_06E8

    BRA.S   .LAB_0675

    BSR.W   LAB_06CE

.LAB_0675:
    ADDQ.L  #1,LAB_231C
    CMPI.L  #$14,LAB_231C
    BLT.S   .LAB_0676

    CLR.L   LAB_231C

.LAB_0676:
    MOVEQ   #1,D0
    MOVE.L  D0,LAB_1D14

LAB_0677:
    RTS

;!======

LAB_0678:
    LINK.W  A5,#-4
    MOVEM.L D2/D7/A2,-(A7)
    TST.L   LAB_1D15
    BEQ.S   LAB_0679

    MOVEQ   #1,D0
    MOVE.L  D0,GLOB_REF_BOOL_IS_TEXT_OR_CURSOR
    LEA     LAB_21F7,A0
    ADDA.L  LAB_21E8,A0
    MOVE.B  (A0),LAB_21E1
    CLR.L   LAB_1D15

LAB_0679:
    JSR     LAB_07F4(PC)

    MOVEQ   #0,D0
    MOVE.B  LAB_21ED,D0
    SUBQ.W  #1,D0
    BEQ.W   LAB_067D

    SUBQ.W  #1,D0
    BEQ.W   LAB_0680

    SUBQ.W  #1,D0
    BEQ.W   LAB_0681

    SUBQ.W  #3,D0
    BEQ.W   LAB_067F

    SUBQ.W  #2,D0
    BEQ.W   LAB_0684

    SUBQ.W  #1,D0
    BEQ.W   LAB_06BC

    SUBQ.W  #4,D0
    BEQ.S   LAB_067B

    SUBQ.W  #1,D0
    BEQ.W   LAB_067E

    SUBI.W  #13,D0
    BEQ.S   LAB_067A

    SUBI.W  #$64,D0
    BEQ.W   LAB_0685

    SUBI.W  #$1c,D0
    BEQ.W   LAB_0689

    BRA.W   LAB_06BB

LAB_067A:
    MOVEQ   #1,D0
    MOVE.L  D0,GLOB_REF_BOOL_IS_TEXT_OR_CURSOR
    MOVE.L  D0,LAB_1D15
    JSR     LAB_0852(PC)

    JSR     DRAW_BOTTOM_HELP_FOR_ESC_MENU(PC)

    BRA.W   LAB_06BF

LAB_067B:
    MOVE.L  LAB_21FB,D0
    MOVE.L  D0,D1
    SUBQ.L  #1,D1
    MOVEQ   #40,D0
    JSR     JMP_TBL_LAB_1A06_2(PC)

    MOVE.L  LAB_21E8,D1
    CMP.L   D0,D1
    BGE.S   LAB_067C

    MOVE.L  LAB_21E9,D0
    ADDQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     JMP_TBL_LAB_1A06_2(PC)

    MOVE.L  D0,LAB_21E8
    BRA.W   LAB_06BC

LAB_067C:
    MOVE.L  LAB_21FB,D0
    SUBQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     JMP_TBL_LAB_1A06_2(PC)

    MOVE.L  D0,LAB_21E8
    BRA.W   LAB_06BC

LAB_067D:
    MOVEQ   #1,D0
    MOVE.L  D0,LAB_21EA
    JSR     LAB_0805(PC)

    BRA.W   LAB_06BC

LAB_067E:
    CLR.L   LAB_21EA
    JSR     LAB_0805(PC)

    BRA.W   LAB_06BC

LAB_067F:
    MOVEQ   #0,D0
    MOVE.B  LAB_21E1,D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,16(A7)
    JSR     LAB_0859(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    ADDQ.L  #1,D1
    MOVE.L  D1,D0
    MOVEQ   #8,D1
    JSR     JMP_TBL_LAB_1A07_1(PC)

    MOVEQ   #0,D0
    MOVE.B  D1,D0
    MOVE.L  D0,(A7)
    MOVE.L  16(A7),-(A7)
    JSR     LAB_071F(PC)

    ADDQ.W  #8,A7
    MOVE.B  D0,LAB_21E1
    MOVEQ   #1,D0
    CMP.L   GLOB_REF_BOOL_IS_TEXT_OR_CURSOR,D0
    BNE.W   LAB_06BC

    LEA     LAB_21F7,A0
    ADDA.L  LAB_21E8,A0
    MOVE.B  LAB_21E1,(A0)
    BRA.W   LAB_06BC

LAB_0680:
    MOVEQ   #0,D0
    MOVE.B  LAB_21E1,D0
    MOVE.L  D0,-(A7)
    JSR     LAB_085D(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    ADDQ.L  #1,D1
    MOVE.L  D1,D0
    MOVEQ   #8,D1
    JSR     JMP_TBL_LAB_1A07_1(PC)

    MOVEQ   #0,D0
    MOVE.B  D1,D0
    MOVEQ   #0,D1
    MOVE.B  LAB_21E1,D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_0727(PC)

    ADDQ.W  #8,A7
    MOVE.B  D0,LAB_21E1
    MOVEQ   #1,D0
    CMP.L   GLOB_REF_BOOL_IS_TEXT_OR_CURSOR,D0
    BNE.W   LAB_06BC

    LEA     LAB_21F7,A0
    ADDA.L  LAB_21E8,A0
    MOVE.B  LAB_21E1,(A0)
    BRA.W   LAB_06BC

LAB_0681:
    MOVEQ   #1,D0
    CMP.L   GLOB_REF_BOOL_IS_TEXT_OR_CURSOR,D0
    BNE.S   LAB_0682

    MOVEQ   #0,D1
    BRA.S   LAB_0683

LAB_0682:
    MOVE.L  D0,D1

LAB_0683:
    MOVE.L  D1,GLOB_REF_BOOL_IS_TEXT_OR_CURSOR
    MOVE.L  D1,-(A7)
    JSR     SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR(PC)

    ADDQ.W  #4,A7
    BRA.W   LAB_06BC

LAB_0684:
    TST.L   LAB_21E8
    BEQ.W   LAB_06BC

    SUBQ.L  #1,LAB_21E8

LAB_0685:
    MOVE.L  LAB_21EB,D0
    SUBQ.L  #1,D0
    MOVE.L  LAB_21E8,D1
    CMP.L   D0,D1
    BGE.W   LAB_0688

    TST.L   GLOB_REF_BOOL_IS_LINE_OR_PAGE
    BNE.W   LAB_0687

    MOVE.L  LAB_21E9,D0
    ADDQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     JMP_TBL_LAB_1A06_2(PC)

    SUBQ.L  #1,D0
    MOVE.L  D0,LAB_21EE
    MOVE.L  LAB_21E8,D1
    CMP.L   D0,D1
    BGE.S   LAB_0686

    LEA     LAB_21F1,A0
    ADDA.L  D1,A0
    LEA     LAB_21F0,A1
    ADDA.L  D1,A1
    SUB.L   D1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_0724(PC)

    LEA     LAB_21F8,A0
    MOVE.L  LAB_21E8,D0
    ADDA.L  D0,A0
    LEA     LAB_21F7,A1
    ADDA.L  D0,A1
    MOVE.L  LAB_21EE,D1
    SUB.L   D0,D1
    MOVE.L  D1,(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_0724(PC)

    LEA     20(A7),A7

LAB_0686:
    LEA     LAB_21F0,A0
    MOVE.L  LAB_21EE,D0
    ADDA.L  D0,A0
    MOVE.B  #$20,(A0)
    LEA     LAB_21F7,A0
    MOVE.L  LAB_21EE,D0
    ADDA.L  D0,A0
    LEA     LAB_21F6,A1
    ADDA.L  D0,A1
    MOVE.B  (A1),(A0)
    MOVE.L  LAB_21E9,-(A7)
    JSR     LAB_080B(PC)

    ADDQ.W  #4,A7
    BRA.W   LAB_06BC

LAB_0687:
    MOVE.L  LAB_21EB,D0
    SUBQ.L  #1,D0
    MOVE.L  D0,LAB_21EE
    LEA     LAB_21F1,A0
    MOVE.L  LAB_21E8,D1
    ADDA.L  D1,A0
    LEA     LAB_21F0,A1
    ADDA.L  D1,A1
    SUB.L   D1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_0724(PC)

    LEA     LAB_21F8,A0
    MOVE.L  LAB_21E8,D0
    ADDA.L  D0,A0
    LEA     LAB_21F7,A1
    ADDA.L  D0,A1
    MOVE.L  LAB_21EE,D1
    SUB.L   D0,D1
    MOVE.L  D1,(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_0724(PC)

    LEA     LAB_21F0,A0
    MOVE.L  LAB_21EE,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.B  #$20,(A1)
    LEA     LAB_21F7,A1
    MOVE.L  LAB_21EE,D0
    ADDA.L  D0,A1
    LEA     LAB_21F6,A2
    ADDA.L  D0,A2
    MOVE.B  (A2),(A1)
    ADDA.L  LAB_21EB,A0
    CLR.B   (A0)
    JSR     LAB_0808(PC)

    LEA     20(A7),A7
    BRA.W   LAB_06BC

LAB_0688:
    LEA     LAB_21EF,A0
    ADDA.L  LAB_21EB,A0
    MOVE.B  #$20,(A0)
    JSR     LAB_07F4(PC)

    BRA.W   LAB_06BC

LAB_0689:
    MOVE.L  LAB_231C,D0
    LSL.L   #2,D0
    ADD.L   LAB_231C,D0
    LEA     LAB_231D,A0
    ADDA.L  D0,A0
    MOVE.B  1(A0),D0
    MOVE.B  D0,LAB_21FA
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    SUBI.W  #$20,D1
    BEQ.W   LAB_068E

    SUBI.W  #16,D1
    BEQ.W   LAB_0691

    SUBQ.W  #1,D1
    BEQ.W   LAB_0693

    SUBQ.W  #1,D1
    BEQ.W   LAB_0696

    SUBQ.W  #1,D1
    BEQ.W   LAB_069A

    SUBQ.W  #1,D1
    BEQ.W   LAB_069E

    SUBQ.W  #1,D1
    BEQ.W   LAB_06A2

    SUBQ.W  #1,D1
    BEQ.W   LAB_06AA

    SUBQ.W  #1,D1
    BEQ.W   LAB_06AE

    SUBQ.W  #1,D1
    BEQ.W   LAB_06B2

    SUBQ.W  #1,D1
    BEQ.W   LAB_06B7

    SUBQ.W  #6,D1
    BEQ.W   LAB_0690

    SUBQ.W  #2,D1
    BEQ.S   LAB_068A

    SUBQ.W  #1,D1
    BEQ.S   LAB_068B

    SUBQ.W  #1,D1
    BEQ.S   LAB_068C

    SUBQ.W  #1,D1
    BEQ.S   LAB_068D

    BRA.W   LAB_06BC

LAB_068A:
    MOVE.L  LAB_21E8,D0
    MOVEQ   #39,D1
    CMP.L   D1,D0
    BLE.W   LAB_06BC

    MOVEQ   #40,D1
    SUB.L   D1,LAB_21E8
    BRA.W   LAB_06BC

LAB_068B:
    MOVE.L  LAB_21FB,D0
    SUBQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     JMP_TBL_LAB_1A06_2(PC)

    MOVE.L  LAB_21E8,D1
    CMP.L   D0,D1
    BGE.W   LAB_06BC

    MOVEQ   #40,D0
    ADD.L   D0,LAB_21E8
    BRA.W   LAB_06BC

LAB_068C:
    MOVE.L  LAB_21EB,D0
    SUBQ.L  #1,D0
    MOVE.L  LAB_21E8,D1
    CMP.L   D0,D1
    BGE.W   LAB_06BC

    ADDQ.L  #1,LAB_21E8
    BRA.W   LAB_06BC

LAB_068D:
    MOVE.L  LAB_21E8,D0
    TST.L   D0
    BLE.W   LAB_06BC

    SUBQ.L  #1,LAB_21E8
    BRA.W   LAB_06BC

LAB_068E:
    MOVE.L  LAB_231C,D0
    LSL.L   #2,D0
    ADD.L   LAB_231C,D0
    LEA     LAB_231D,A0
    ADDA.L  D0,A0
    MOVE.B  2(A0),D0
    MOVE.B  D0,LAB_21ED
    MOVEQ   #64,D1
    CMP.B   D1,D0
    BNE.S   LAB_068F

    JSR     LAB_0853(PC)

LAB_068F:
    MOVE.B  LAB_21ED,D0
    MOVEQ   #65,D1
    CMP.B   D1,D0
    BNE.W   LAB_06BC

    JSR     LAB_0855(PC)

    BRA.W   LAB_06BC

LAB_0690:
    MOVE.B  #$9,LAB_1D13
    JSR     LAB_0857(PC)

    BRA.W   LAB_06BC

LAB_0691:
    MOVEQ   #1,D0
    CMP.L   GLOB_REF_BOOL_IS_LINE_OR_PAGE,D0
    BNE.S   LAB_0692

    CLR.L   LAB_21E8
    BRA.W   LAB_06BC

LAB_0692:
    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     JMP_TBL_LAB_1A06_2(PC)

    MOVE.L  D0,LAB_21E8
    BRA.W   LAB_06BC

LAB_0693:
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #6,D0
    JSR     _LVOSetBPen(A6)

    MOVE.L  GLOB_REF_BOOL_IS_LINE_OR_PAGE,D0
    ADDQ.L  #1,D0
    MOVEQ   #2,D1
    JSR     JMP_TBL_LAB_1A07_1(PC)

    MOVE.L  D1,GLOB_REF_BOOL_IS_LINE_OR_PAGE
    BEQ.S   LAB_0694

    LEA     LAB_1D16,A0
    BRA.S   LAB_0695

LAB_0694:
    LEA     LAB_1D17,A0

LAB_0695:
    MOVE.L  A0,-(A7)
    PEA     390.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLAY_TEXT_AT_POSITION(PC)

    LEA     16(A7),A7
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetBPen(A6)

    BRA.W   LAB_06BC

LAB_0696:
    TST.L   GLOB_REF_BOOL_IS_LINE_OR_PAGE
    BNE.S   LAB_0697

    JSR     LAB_0831(PC)

    MOVE.L  LAB_21E9,-(A7)
    JSR     LAB_080B(PC)

    ADDQ.W  #4,A7
    BRA.W   LAB_06BC

LAB_0697:
    CLR.L   LAB_21E9

LAB_0698:
    MOVE.L  LAB_21E9,D0
    CMP.L   LAB_21FB,D0
    BGE.S   LAB_0699

    JSR     LAB_0831(PC)

    ADDQ.L  #1,LAB_21E9
    BRA.S   LAB_0698

LAB_0699:
    CLR.L   LAB_21E8
    JSR     LAB_0808(PC)

    BRA.W   LAB_06BC

LAB_069A:
    TST.L   GLOB_REF_BOOL_IS_LINE_OR_PAGE
    BNE.S   LAB_069B

    JSR     LAB_0813(PC)

    MOVE.L  LAB_21E9,-(A7)
    JSR     LAB_080B(PC)

    ADDQ.W  #4,A7
    BRA.W   LAB_06BC

LAB_069B:
    CLR.L   LAB_21E9

LAB_069C:
    MOVE.L  LAB_21E9,D0
    CMP.L   LAB_21FB,D0
    BGE.S   LAB_069D

    JSR     LAB_0813(PC)

    ADDQ.L  #1,LAB_21E9
    BRA.S   LAB_069C

LAB_069D:
    CLR.L   LAB_21E8
    JSR     LAB_0808(PC)

    BRA.W   LAB_06BC

LAB_069E:
    TST.L   GLOB_REF_BOOL_IS_LINE_OR_PAGE
    BNE.S   LAB_069F

    JSR     LAB_0822(PC)

    MOVE.L  LAB_21E9,-(A7)
    JSR     LAB_080B(PC)

    ADDQ.W  #4,A7
    BRA.W   LAB_06BC

LAB_069F:
    CLR.L   LAB_21E9

LAB_06A0:
    MOVE.L  LAB_21E9,D0
    CMP.L   LAB_21FB,D0
    BGE.S   LAB_06A1

    JSR     LAB_0822(PC)

    ADDQ.L  #1,LAB_21E9
    BRA.S   LAB_06A0

LAB_06A1:
    CLR.L   LAB_21E8
    JSR     LAB_0808(PC)

    BRA.W   LAB_06BC

LAB_06A2:
    TST.L   GLOB_REF_BOOL_IS_LINE_OR_PAGE
    BNE.S   LAB_06A5

    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     JMP_TBL_LAB_1A06_2(PC)

    LEA     LAB_21F0,A0
    ADDA.L  D0,A0
    MOVEQ   #39,D0
    MOVEQ   #32,D1

LAB_06A3:
    MOVE.B  D1,(A0)+
    DBF     D0,LAB_06A3
    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     JMP_TBL_LAB_1A06_2(PC)

    LEA     LAB_21F7,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  LAB_21E1,D0
    MOVEQ   #39,D1

LAB_06A4:
    MOVE.B  D0,(A0)+
    DBF     D1,LAB_06A4
    MOVE.L  LAB_21E9,-(A7)
    JSR     LAB_080B(PC)

    ADDQ.W  #4,A7
    BRA.W   LAB_06BC

LAB_06A5:
    MOVE.L  LAB_21EB,D0
    MOVEQ   #32,D1
    LEA     LAB_21F0,A0
    BRA.S   LAB_06A7

LAB_06A6:
    MOVE.B  D1,(A0)+

LAB_06A7:
    SUBQ.L  #1,D0
    BCC.S   LAB_06A6

    MOVEQ   #0,D0
    MOVE.B  LAB_21E1,D0
    MOVE.L  LAB_21EB,D1
    LEA     LAB_21F7,A0
    BRA.S   LAB_06A9

LAB_06A8:
    MOVE.B  D0,(A0)+

LAB_06A9:
    SUBQ.L  #1,D1
    BCC.S   LAB_06A8

    LEA     LAB_21F0,A0
    ADDA.L  LAB_21EB,A0
    CLR.B   (A0)
    JSR     LAB_0808(PC)

    BRA.W   LAB_06BC

LAB_06AA:
    MOVE.L  LAB_21FB,D0
    SUBQ.L  #1,D0
    MOVE.L  LAB_21E9,D1
    CMP.L   D0,D1
    BGE.W   LAB_06BC

    MOVEQ   #40,D0
    JSR     JMP_TBL_LAB_1A06_2(PC)

    LEA     LAB_21F0,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  LAB_21E9,D0
    ADDQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     JMP_TBL_LAB_1A06_2(PC)

    ADDA.L  D0,A0
    MOVE.L  LAB_21EB,D1
    SUB.L   D0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  A1,-(A7)
    JSR     LAB_0724(PC)

    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     JMP_TBL_LAB_1A06_2(PC)

    LEA     LAB_21F7,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  LAB_21E9,D0
    ADDQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     JMP_TBL_LAB_1A06_2(PC)

    ADDA.L  D0,A0
    MOVE.L  LAB_21EB,D1
    SUB.L   D0,D1
    MOVE.L  D1,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  A1,-(A7)
    JSR     LAB_0724(PC)

    LEA     20(A7),A7
    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     JMP_TBL_LAB_1A06_2(PC)

    LEA     LAB_21F0,A0
    ADDA.L  D0,A0
    MOVEQ   #39,D0
    MOVEQ   #32,D1

LAB_06AB:
    MOVE.B  D1,(A0)+
    DBF     D0,LAB_06AB
    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     JMP_TBL_LAB_1A06_2(PC)

    LEA     LAB_21F7,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  LAB_21E1,D0
    MOVEQ   #39,D1

LAB_06AC:
    MOVE.B  D0,(A0)+
    DBF     D1,LAB_06AC
    LEA     LAB_21F0,A0
    ADDA.L  LAB_21EB,A0
    CLR.B   (A0)
    MOVE.L  LAB_21E9,D7

LAB_06AD:
    CMP.L   LAB_21FB,D7
    BGE.W   LAB_06BC

    MOVE.L  D7,-(A7)
    JSR     LAB_080B(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D7
    BRA.S   LAB_06AD

LAB_06AE:
    MOVE.L  LAB_21FB,D0
    SUBQ.L  #1,D0
    MOVE.L  LAB_21E9,D1
    CMP.L   D0,D1
    BGE.W   LAB_06BC

    MOVE.L  D1,D0
    ADDQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     JMP_TBL_LAB_1A06_2(PC)

    LEA     LAB_21F0,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  D0,12(A7)
    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     JMP_TBL_LAB_1A06_2(PC)

    ADDA.L  D0,A0
    MOVE.L  12(A7),D0
    MOVE.L  LAB_21EB,D1
    SUB.L   D0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  A1,-(A7)
    JSR     LAB_0724(PC)

    MOVE.L  LAB_21E9,D0
    MOVE.L  D0,D1
    ADDQ.L  #1,D1
    MOVEQ   #40,D0
    JSR     JMP_TBL_LAB_1A06_2(PC)

    LEA     LAB_21F7,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  D0,24(A7)
    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     JMP_TBL_LAB_1A06_2(PC)

    ADDA.L  D0,A0
    MOVE.L  24(A7),D0
    MOVE.L  LAB_21EB,D1
    SUB.L   D0,D1
    MOVE.L  D1,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  A1,-(A7)
    JSR     LAB_0724(PC)

    LEA     20(A7),A7
    MOVE.L  LAB_21FB,D0
    SUBQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     JMP_TBL_LAB_1A06_2(PC)

    LEA     LAB_21F0,A0
    ADDA.L  D0,A0
    MOVEQ   #39,D0
    MOVEQ   #32,D1

LAB_06AF:
    MOVE.B  D1,(A0)+
    DBF     D0,LAB_06AF
    MOVE.L  LAB_21FB,D0
    SUBQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     JMP_TBL_LAB_1A06_2(PC)

    LEA     LAB_21F7,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  LAB_21E1,D0
    MOVEQ   #39,D1

LAB_06B0:
    MOVE.B  D0,(A0)+
    DBF     D1,LAB_06B0
    LEA     LAB_21F0,A0
    ADDA.L  LAB_21EB,A0
    CLR.B   (A0)
    MOVE.L  LAB_21E9,D7

LAB_06B1:
    CMP.L   LAB_21FB,D7
    BGE.W   LAB_06BC

    MOVE.L  D7,-(A7)
    JSR     LAB_080B(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D7
    BRA.S   LAB_06B1

LAB_06B2:
    TST.L   GLOB_REF_BOOL_IS_LINE_OR_PAGE
    BNE.S   LAB_06B4

    MOVE.L  LAB_21E9,D0
    MOVEQ   #40,D1
    JSR     JMP_TBL_LAB_1A06_2(PC)

    LEA     LAB_21F7,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  LAB_21E1,D0
    MOVEQ   #39,D1

LAB_06B3:
    MOVE.B  D0,(A0)+
    DBF     D1,LAB_06B3
    MOVE.L  LAB_21E9,-(A7)
    JSR     LAB_080B(PC)

    ADDQ.W  #4,A7
    BRA.W   LAB_06BC

LAB_06B4:
    MOVEQ   #0,D0
    MOVE.B  LAB_21E1,D0
    MOVE.L  LAB_21EB,D1
    LEA     LAB_21F7,A0
    BRA.S   LAB_06B6

LAB_06B5:
    MOVE.B  D0,(A0)+

LAB_06B6:
    SUBQ.L  #1,D1
    BCC.S   LAB_06B5

    JSR     LAB_0808(PC)

    BRA.W   LAB_06BC

LAB_06B7:
    MOVE.L  LAB_21EB,D0
    SUBQ.L  #1,D0
    MOVE.L  LAB_21E8,D1
    CMP.L   D0,D1
    BGE.W   LAB_06BA

    TST.L   GLOB_REF_BOOL_IS_LINE_OR_PAGE
    BNE.W   LAB_06B9

    MOVE.L  LAB_21E9,D0
    ADDQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     JMP_TBL_LAB_1A06_2(PC)

    SUBQ.L  #1,D0
    MOVE.L  D0,LAB_21EE
    MOVE.L  LAB_21E8,D1
    CMP.L   D0,D1
    BGE.S   LAB_06B8

    LEA     LAB_21F0,A0
    ADDA.L  D1,A0
    LEA     LAB_21F1,A1
    ADDA.L  D1,A1
    SUB.L   D1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_0724(PC)

    LEA     LAB_21F7,A0
    MOVE.L  LAB_21E8,D0
    ADDA.L  D0,A0
    LEA     LAB_21F8,A1
    ADDA.L  D0,A1
    MOVE.L  LAB_21EE,D1
    SUB.L   D0,D1
    MOVE.L  D1,(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_0724(PC)

    LEA     20(A7),A7

LAB_06B8:
    LEA     LAB_21F0,A0
    MOVE.L  LAB_21E8,D0
    ADDA.L  D0,A0
    MOVE.B  #$20,(A0)
    LEA     LAB_21F7,A0
    ADDA.L  LAB_21E8,A0
    MOVE.B  LAB_21E1,(A0)
    MOVE.L  LAB_21E9,-(A7)
    JSR     LAB_080B(PC)

    ADDQ.W  #4,A7
    BRA.W   LAB_06BC

LAB_06B9:
    MOVE.L  LAB_21EB,D0
    SUBQ.L  #1,D0
    MOVE.L  D0,LAB_21EE
    LEA     LAB_21F0,A0
    MOVE.L  LAB_21E8,D1
    ADDA.L  D1,A0
    LEA     LAB_21F1,A1
    ADDA.L  D1,A1
    SUB.L   D1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_0724(PC)

    LEA     LAB_21F7,A0
    MOVE.L  LAB_21E8,D0
    ADDA.L  D0,A0
    LEA     LAB_21F8,A1
    ADDA.L  D0,A1
    MOVE.L  LAB_21EE,D1
    SUB.L   D0,D1
    MOVE.L  D1,(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_0724(PC)

    LEA     LAB_21F0,A0
    MOVE.L  LAB_21E8,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.B  #$20,(A1)
    LEA     LAB_21F7,A1
    ADDA.L  LAB_21E8,A1
    MOVE.B  LAB_21E1,(A1)
    ADDA.L  LAB_21EB,A0
    CLR.B   (A0)
    JSR     LAB_0808(PC)

    LEA     20(A7),A7
    BRA.S   LAB_06BC

LAB_06BA:
    LEA     LAB_21EF,A0
    ADDA.L  LAB_21EB,A0
    MOVE.B  #$20,(A0)
    JSR     LAB_07F4(PC)

    BRA.S   LAB_06BC

LAB_06BB:
    MOVE.B  LAB_21ED,D0
    MOVEQ   #25,D1
    CMP.B   D1,D0
    BLS.S   LAB_06BC

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #64,D2
    ADD.L   D2,D2
    CMP.L   D2,D1
    BGE.S   LAB_06BC

    LEA     LAB_21F0,A0
    MOVE.L  LAB_21E8,D1
    ADDA.L  D1,A0
    MOVE.B  D0,(A0)
    LEA     LAB_21F7,A0
    ADDA.L  LAB_21E8,A0
    MOVE.B  LAB_21E1,(A0)
    JSR     LAB_07F4(PC)

    MOVE.L  LAB_21EB,D0
    SUBQ.L  #1,D0
    MOVE.L  LAB_21E8,D1
    CMP.L   D0,D1
    BGE.S   LAB_06BC

    ADDQ.L  #1,LAB_21E8

LAB_06BC:
    TST.L   GLOB_REF_BOOL_IS_TEXT_OR_CURSOR
    BNE.S   LAB_06BD

    LEA     LAB_21F7,A0
    MOVE.L  LAB_21E8,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.B  LAB_21E1,(A1)
    BRA.S   LAB_06BE

LAB_06BD:
    LEA     LAB_21F7,A0
    ADDA.L  LAB_21E8,A0
    MOVE.B  (A0),LAB_21E1

LAB_06BE:
    MOVE.B  LAB_1D13,D0
    SUBQ.B  #4,D0
    BNE.S   LAB_06BF

    JSR     LAB_07F3(PC)

    MOVEQ   #0,D0
    MOVE.B  LAB_21E1,D0
    MOVE.L  D0,-(A7)
    JSR     LAB_07F8(PC)

    ADDQ.W  #4,A7

LAB_06BF:
    MOVEM.L (A7)+,D2/D7/A2
    UNLK    A5
    RTS

;!======

LAB_06C0:
    MOVE.B  #$4,LAB_1D13
    JSR     LAB_0812(PC)

    JSR     LAB_0808(PC)

    JSR     LAB_07F3(PC)

    LEA     LAB_21F7,A0
    ADDA.L  LAB_21E8,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.L  D0,-(A7)
    JSR     LAB_07F8(PC)

    ADDQ.W  #4,A7
    RTS

;!======

LAB_06C1:
    LINK.W  A5,#-28
    MOVE.L  D7,-(A7)
    LEA     LAB_1D1A,A0
    LEA     -25(A5),A1
    MOVEQ   #23,D0

LAB_06C2:
    MOVE.B  (A0)+,(A1)+
    DBF     D0,LAB_06C2
    MOVE.L  LAB_231C,D0
    LSL.L   #2,D0
    ADD.L   LAB_231C,D0
    LEA     LAB_231D,A0
    ADDA.L  D0,A0
    MOVE.B  (A0),D0
    MOVE.B  D0,LAB_21ED
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    LEA     LAB_21A8,A0
    ADDA.L  D1,A0
    BTST    #7,(A0)
    BEQ.S   LAB_06C5

    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_09B2(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D7
    TST.L   LAB_1D18
    BNE.S   LAB_06C3

    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D0,LAB_1D19
    BRA.S   LAB_06C6

LAB_06C3:
    MOVE.L  LAB_1D19,D0
    TST.L   D0
    BMI.S   LAB_06C4

    MOVEQ   #8,D1
    CMP.L   D1,D0
    BGE.S   LAB_06C4

    MOVEQ   #13,D1
    CMP.B   D1,D7
    BCC.S   LAB_06C4

    LSL.L   #2,D0
    SUB.L   LAB_1D19,D0
    MOVE.L  LAB_1D18,D1
    ADD.L   D1,D0
    LEA     LAB_1FB7,A0
    ADDA.L  D0,A0
    MOVE.B  D7,(A0)
    BRA.S   LAB_06C6

LAB_06C4:
    MOVEQ   #-1,D0
    MOVE.L  D0,LAB_1D19
    BRA.S   LAB_06C6

LAB_06C5:
    MOVEQ   #-1,D0
    MOVE.L  D0,LAB_1D19

LAB_06C6:
    MOVE.L  LAB_1D18,D0
    ADDQ.L  #1,D0
    MOVEQ   #4,D1
    JSR     JMP_TBL_LAB_1A07_1(PC)

    MOVE.L  D1,LAB_1D18
    BNE.S   LAB_06C9

    MOVE.L  LAB_1D19,D0
    TST.L   D0
    BPL.S   LAB_06C8

    CLR.L   LAB_1D19

LAB_06C7:
    MOVE.L  LAB_1D19,D0
    MOVEQ   #24,D1
    CMP.L   D1,D0
    BGE.S   LAB_06C8

    LEA     LAB_1FB8,A0
    ADDA.L  D0,A0
    MOVE.B  -25(A5,D0.L),(A0)
    ADDQ.L  #1,LAB_1D19
    BRA.S   LAB_06C7

LAB_06C8:
    CLR.B   LAB_1D13

LAB_06C9:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======

LAB_06CA:
    LINK.W  A5,#-4
    MOVEM.L D7/A3,-(A7)
    MOVE.B  11(A5),D7
    MOVEA.L 12(A5),A3
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_05C1(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.S   LAB_06CB

    ADDQ.L  #1,-4(A5)
    BRA.S   LAB_06CC

LAB_06CB:
    MOVE.L  A3,-4(A5)

LAB_06CC:
    MOVEA.L -4(A5),A0
    TST.B   (A0)
    BNE.S   LAB_06CD

    MOVE.L  A3,-4(A5)

LAB_06CD:
    MOVEA.L -4(A5),A0
    MOVE.B  (A0),D0
    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======

LAB_06CE:
    MOVE.L  D2,-(A7)
    MOVEQ   #0,D0
    MOVE.B  LAB_21ED,D0
    SUBI.W  #13,D0
    BEQ.S   LAB_06CF

    SUBI.W  #14,D0
    BEQ.S   LAB_06CF

    SUBI.W  #$27,D0
    BEQ.W   LAB_06D4

    SUBQ.W  #5,D0
    BEQ.W   LAB_06D2

    SUBI.W  #11,D0
    BEQ.S   LAB_06D0

    SUBI.W  #16,D0
    BEQ.W   LAB_06D5

    SUBQ.W  #5,D0
    BEQ.W   LAB_06D3

    SUBI.W  #11,D0
    BEQ.S   LAB_06D1

    SUBI.W  #$29,D0
    BEQ.W   LAB_06D6

    BRA.W   LAB_06D7

LAB_06CF:
    JSR     DRAW_BOTTOM_HELP_FOR_ESC_MENU(PC)

    BRA.W   LAB_06DA

LAB_06D0:
    MOVE.L  LAB_21EE,D0
    LSL.L   #2,D0
    SUB.L   LAB_21EE,D0
    LEA     LAB_1DE0,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.B  (A1),D1
    ADDQ.B  #1,(A1)
    MOVEQ   #15,D2
    CMP.B   D2,D1
    BCS.W   LAB_06D8

    ADDA.L  D0,A0
    CLR.B   (A0)
    BRA.W   LAB_06D8

LAB_06D1:
    MOVE.L  LAB_21EE,D0
    LSL.L   #2,D0
    SUB.L   LAB_21EE,D0
    LEA     LAB_1DE0,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    SUBQ.B  #1,(A1)
    CMPI.B  #$f,(A1)
    BLS.W   LAB_06D8

    ADDA.L  D0,A0
    MOVE.B  #$f,(A0)
    BRA.W   LAB_06D8

LAB_06D2:
    MOVE.L  LAB_21EE,D0
    LSL.L   #2,D0
    SUB.L   LAB_21EE,D0
    LEA     LAB_1DE1,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.B  (A1),D1
    ADDQ.B  #1,(A1)
    MOVEQ   #15,D2
    CMP.B   D2,D1
    BCS.W   LAB_06D8

    ADDA.L  D0,A0
    CLR.B   (A0)
    BRA.W   LAB_06D8

LAB_06D3:
    MOVE.L  LAB_21EE,D0
    LSL.L   #2,D0
    SUB.L   LAB_21EE,D0
    LEA     LAB_1DE1,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    SUBQ.B  #1,(A1)
    CMPI.B  #$f,(A1)
    BLS.W   LAB_06D8

    ADDA.L  D0,A0
    MOVE.B  #$f,(A0)
    BRA.W   LAB_06D8

LAB_06D4:
    MOVE.L  LAB_21EE,D0
    LSL.L   #2,D0
    SUB.L   LAB_21EE,D0
    LEA     LAB_1DE2,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.B  (A1),D1
    ADDQ.B  #1,(A1)
    MOVEQ   #15,D2
    CMP.B   D2,D1
    BCS.S   LAB_06D8

    ADDA.L  D0,A0
    CLR.B   (A0)
    BRA.S   LAB_06D8

LAB_06D5:
    MOVE.L  LAB_21EE,D0
    LSL.L   #2,D0
    SUB.L   LAB_21EE,D0
    LEA     LAB_1DE2,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    SUBQ.B  #1,(A1)
    CMPI.B  #$f,(A1)
    BLS.S   LAB_06D8

    ADDA.L  D0,A0
    MOVE.B  #$f,(A0)
    BRA.S   LAB_06D8

LAB_06D6:
    MOVE.L  LAB_231C,D0
    LSL.L   #2,D0
    ADD.L   LAB_231C,D0
    LEA     LAB_231D,A0
    ADDA.L  D0,A0
    MOVE.B  1(A0),D0
    MOVE.B  D0,LAB_21FA
    MOVEQ   #68,D1
    CMP.B   D1,D0
    BNE.S   LAB_06D7

    SUBQ.L  #1,LAB_21EE
    BGE.S   LAB_06D8

    MOVEQ   #39,D0
    MOVE.L  D0,LAB_21EE
    BRA.S   LAB_06D8

LAB_06D7:
    ADDQ.L  #1,LAB_21EE
    MOVEQ   #40,D0
    CMP.L   LAB_21EE,D0
    BNE.S   LAB_06D8

    CLR.L   LAB_21EE

LAB_06D8:
    MOVE.L  LAB_21EE,D0
    TST.L   D0
    BMI.S   LAB_06D9

    MOVEQ   #40,D1
    CMP.L   D1,D0
    BGE.S   LAB_06D9

    JSR     LAB_0722(PC)

LAB_06D9:
    JSR     LAB_07EE(PC)

LAB_06DA:
    MOVE.L  (A7)+,D2
    RTS

;!======

LAB_06DB:
    MOVEM.L D2-D3/D7,-(A7)
    JSR     LAB_07D4(PC)

    MOVE.L  D0,D7
    MOVE.B  D7,D0
    EXT.W   D0
    CMPI.W  #8,D0
    BCC.W   LAB_06DF

    ADD.W   D0,D0

    ; Custom offsets on this again...?
    ; these instructions must be getting mangled or something.
    MOVE.W  LAB_06DC(PC,D0.W),D0
    JMP     LAB_06DD(PC,D0.W)

LAB_06DC:
    DC.W    $000e

LAB_06DD:
    ORI.B   #$42,(A6)
    ORI.W   #$9a,582(A6)
    BTST    D0,D0
    DC.W    $00de

    ; ---------

    JSR     DRAW_BOTTOM_HELP_FOR_ESC_MENU(PC)

    BRA.W   LAB_06E1

    ; Possible jump point from above.

    JSR     LAB_07EF(PC)

    PEA     LAB_1D1B
    PEA     90.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLAY_TEXT_AT_POSITION(PC)

    LEA     16(A7),A7
    MOVE.B  #$b,LAB_1D13

    BRA.W   LAB_06E1

    ; Possible jump point from above.

    JSR     LAB_07EF(PC)

    PEA     LAB_1D1C
    PEA     90.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLAY_TEXT_AT_POSITION(PC)

    LEA     16(A7),A7
    MOVE.B  #$c,LAB_1D13
    BRA.W   LAB_06E1

    JSR     LAB_07EF(PC)

    PEA     LAB_1D1D
    PEA     90.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLAY_TEXT_AT_POSITION(PC)

    LEA     16(A7),A7
    MOVE.B  #$d,LAB_1D13
    BRA.W   LAB_06E1

    JSR     LAB_07EF(PC)

    PEA     GLOB_STR_COMPUTER_WILL_RESET
    PEA     90.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLAY_TEXT_AT_POSITION(PC)

    PEA     GLOB_STR_GO_OFF_AIR_FOR_1_2_MINS
    PEA     120.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLAY_TEXT_AT_POSITION(PC)

    LEA     32(A7),A7
    MOVE.B  #$e,LAB_1D13
    BRA.W   LAB_06E1

    SUBQ.L  #1,LAB_21E8
    BGE.S   LAB_06DE

    MOVEQ   #3,D0
    MOVE.L  D0,LAB_21E8

LAB_06DE:
    PEA     4.W
    JSR     LAB_07E9(PC)

    JSR     DRAW_ESC_SPECIAL_FUNCTIONS_MENU_TEXT(PC)

    ADDQ.W  #4,A7
    BRA.W   LAB_06E1

    MOVEQ   #2,D0
    CMP.L   LAB_21E8,D0
    BNE.W   LAB_06DF

    MOVE.B  #$f,LAB_1D13

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVE.L  #328,D1
    MOVEQ   #115,D2
    MOVE.L  #399,D3
    JSR     _LVORectFill(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVE.L  D2,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVE.L  #328,D1
    MOVEQ   #95,D2
    ADD.L   D2,D2
    JSR     _LVORectFill(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    JSR     _LVOSetAPen(A6)

    MOVE.L  D2,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVE.L  #328,D1
    MOVE.L  #265,D2
    JSR     _LVORectFill(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #3,D0
    JSR     _LVOSetAPen(A6)

    MOVE.L  D2,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVE.L  #328,D1
    MOVE.L  #340,D2
    JSR     _LVORectFill(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #4,D0
    JSR     _LVOSetAPen(A6)

    MOVE.L  D2,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVE.L  #328,D1
    MOVE.L  #415,D2
    JSR     _LVORectFill(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #5,D0
    JSR     _LVOSetAPen(A6)

    MOVE.L  D2,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVE.L  #328,D1
    MOVE.L  #$1ea,D2
    JSR     _LVORectFill(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #6,D0
    JSR     _LVOSetAPen(A6)

    MOVE.L  D2,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVE.L  #328,D1
    MOVE.L  #$235,D2
    JSR     _LVORectFill(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    JSR     _LVOSetAPen(A6)

    MOVE.L  D2,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVE.L  #328,D1
    MOVE.L  #$280,D2
    JSR     _LVORectFill(A6)

    CLR.L   LAB_21EE
    JSR     LAB_07EE(PC)

    BRA.S   LAB_06E1

LAB_06DF:
    ADDQ.L  #1,LAB_21E8
    MOVEQ   #4,D0
    CMP.L   LAB_21E8,D0
    BNE.S   LAB_06E0

    CLR.L   LAB_21E8

LAB_06E0:
    MOVE.L  D0,-(A7)
    JSR     LAB_07E9(PC)

    JSR     DRAW_ESC_SPECIAL_FUNCTIONS_MENU_TEXT(PC)

    ADDQ.W  #4,A7

LAB_06E1:
    MOVEM.L (A7)+,D2-D3/D7
    RTS

;!======

; Print 'Saving "EVERYTHING" to disk'
LAB_06E2:
    MOVE.L  D7,-(A7)
    JSR     LAB_07DD(PC)

    MOVE.L  D0,D7
    TST.B   D7
    BNE.S   LAB_06E3

    PEA     GLOB_STR_SAVING_EVERYTHING_TO_DISK
    PEA     90.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLAY_TEXT_AT_POSITION(PC)

    PEA     1.W
    JSR     LAB_0484(PC)

    LEA     20(A7),A7

LAB_06E3:
    JSR     DRAW_BOTTOM_HELP_FOR_ESC_MENU(PC)

    MOVE.L  (A7)+,D7
    RTS

;!======

LAB_06E4:
    MOVE.L  D7,-(A7)
    JSR     LAB_07DD(PC)

    MOVE.L  D0,D7
    TST.B   D7
    BNE.S   LAB_06E5

    PEA     GLOB_STR_SAVING_PREVUE_DATA_TO_DISK
    PEA     120.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLAY_TEXT_AT_POSITION(PC)

    JSR     LAB_0471(PC)

    LEA     16(A7),A7

LAB_06E5:
    JSR     DRAW_BOTTOM_HELP_FOR_ESC_MENU(PC)

    MOVE.L  (A7)+,D7
    RTS

;!======

LAB_06E6:
    MOVE.L  D7,-(A7)

    JSR     LAB_07DD(PC)

    MOVE.L  D0,D7
    TST.B   D7
    BNE.S   LAB_06E7

    PEA     GLOB_STR_LOADING_TEXT_ADS_FROM_DH2
    PEA     120.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLAY_TEXT_AT_POSITION(PC)

    JSR     LAB_08A3(PC)

    LEA     16(A7),A7

LAB_06E7:
    JSR     DRAW_BOTTOM_HELP_FOR_ESC_MENU(PC)

    MOVE.L  (A7)+,D7
    RTS

;!======

; display 'rebooting computer' while requesting a reboot through supervisor?
LAB_06E8:
    MOVEM.L D6-D7,-(A7)

    JSR     LAB_07DD(PC)

    MOVE.L  D0,D7
    TST.B   D7
    BNE.S   LAB_06EB

    PEA     GLOB_STR_REBOOTING_COMPUTER     ; string
    PEA     120.W                           ; y
    PEA     40.W                            ; x
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)                  ; rastport
    JSR     DISPLAY_TEXT_AT_POSITION(PC)

    LEA     16(A7),A7
    MOVEQ   #0,D6

LAB_06E9:
    CMPI.L  #$aae60,D6
    BGE.S   LAB_06EA

    ADDQ.L  #1,D6
    ADDQ.L  #1,D6
    BRA.S   LAB_06E9

LAB_06EA:
    JSR     LAB_0721(PC)

LAB_06EB:
    JSR     DRAW_BOTTOM_HELP_FOR_ESC_MENU(PC)

    MOVEM.L (A7)+,D6-D7
    RTS

;!======

; Draw 'Edit Attributes' menu
LAB_06EC:
    MOVEM.L D2-D4,-(A7)
    JSR     LAB_07F4(PC)

    MOVEQ   #0,D0
    MOVE.B  LAB_21ED,D0
    SUBQ.W  #8,D0
    BEQ.S   LAB_06ED

    SUBQ.W  #5,D0
    BEQ.S   LAB_06F1

    SUBI.W  #$8e,D0
    BEQ.S   LAB_06EF

    BRA.W   LAB_06F9

LAB_06ED:
    MOVE.L  LAB_21E8,D0
    MOVEQ   #12,D1
    CMP.L   D1,D0
    BLE.S   LAB_06EE

    SUBQ.L  #1,LAB_21E8
    LEA     LAB_21F0,A0
    ADDA.L  LAB_21E8,A0
    MOVE.B  #$20,(A0)

LAB_06EE:
    JSR     LAB_07F4(PC)

    BRA.W   LAB_06FA

LAB_06EF:
    MOVE.L  LAB_231C,D0
    LSL.L   #2,D0
    ADD.L   LAB_231C,D0
    LEA     LAB_231D,A0
    ADDA.L  D0,A0
    MOVE.B  1(A0),D0
    MOVE.B  D0,LAB_21FA
    MOVEQ   #67,D1
    CMP.B   D1,D0
    BNE.S   LAB_06F0

    MOVEQ   #13,D1
    MOVE.L  D1,LAB_21E8
    BRA.W   LAB_06FA

LAB_06F0:
    MOVEQ   #68,D1
    CMP.B   D1,D0
    BNE.W   LAB_06FA

    MOVEQ   #12,D0
    MOVE.L  D0,LAB_21E8
    BRA.W   LAB_06FA

LAB_06F1:
    MOVE.B  LAB_21F2,D0
    MOVEQ   #32,D1
    CMP.B   D1,D0
    BNE.S   LAB_06F3

    MOVE.B  LAB_21F3,D2
    CMP.B   D1,D2
    BEQ.S   LAB_06F2

    MOVEQ   #0,D3
    MOVE.B  D2,D3
    MOVEQ   #48,D4
    SUB.L   D4,D3
    MOVE.L  D3,GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER
    BRA.S   LAB_06F5

LAB_06F2:
    MOVEQ   #1,D3
    MOVE.L  D3,GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER
    BRA.S   LAB_06F5

LAB_06F3:
    MOVE.B  LAB_21F3,D2
    CMP.B   D1,D2
    BNE.S   LAB_06F4

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #48,D3
    SUB.L   D3,D1
    MOVE.L  D1,GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER
    BRA.S   LAB_06F5

LAB_06F4:
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #48,D0
    SUB.L   D0,D1
    MOVEQ   #10,D0
    JSR     JMP_TBL_LAB_1A06_2(PC)

    MOVEQ   #0,D1
    MOVE.B  D2,D1
    ADD.L   D1,D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVE.L  D0,GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER

LAB_06F5:
    MOVE.L  GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER,D0
    CMP.L   LAB_21FD,D0
    BLE.S   LAB_06F6

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #4,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    PEA     LAB_1D24
    PEA     150.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLAY_TEXT_AT_POSITION(PC)

    LEA     16(A7),A7
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    BRA.W   LAB_06FB

LAB_06F6:
    TST.L   D0
    BNE.S   LAB_06F7

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #4,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    PEA     LAB_1D25
    PEA     150.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLAY_TEXT_AT_POSITION(PC)

    LEA     16(A7),A7
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    BRA.W   LAB_06FB

LAB_06F7:
    MOVE.B  LAB_1D13,D0
    SUBQ.B  #2,D0
    BNE.S   LAB_06F8

    MOVE.B  #$4,LAB_1D13
    JSR     LAB_0812(PC)

    JSR     LAB_084B(PC)

    MOVEQ   #1,D0
    MOVE.L  D0,LAB_21E4
    BRA.W   LAB_06FB

LAB_06F8:
    MOVE.B  #$5,LAB_1D13
    PEA     6.W
    JSR     DRAW_SOME_RECTANGLES(PC)

    JSR     LAB_0803(PC)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    PEA     LAB_1D26
    PEA     330.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLAY_TEXT_AT_POSITION(PC)

    PEA     LAB_1D27
    PEA     360.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLAY_TEXT_AT_POSITION(PC)

    PEA     LAB_1D28
    PEA     390.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLAY_TEXT_AT_POSITION(PC)

    LEA     52(A7),A7
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    BRA.S   LAB_06FB

LAB_06F9:
    MOVE.B  LAB_21ED,D0
    MOVEQ   #48,D1
    CMP.B   D1,D0
    BCS.S   LAB_06FA

    MOVEQ   #57,D1
    CMP.B   D1,D0
    BHI.S   LAB_06FA

    JSR     LAB_07F4(PC)

    LEA     LAB_21F0,A0
    MOVE.L  LAB_21E8,D0
    ADDA.L  D0,A0
    MOVE.B  LAB_21ED,(A0)
    CMPI.L  #$d,LAB_21E8
    BGE.S   LAB_06FA

    JSR     LAB_07F4(PC)

    LEA     LAB_21F0,A0
    ADDA.L  LAB_21E8,A0
    ADDQ.L  #1,LAB_21E8
    MOVE.B  LAB_21ED,(A0)

LAB_06FA:
    JSR     LAB_07F3(PC)

LAB_06FB:
    MOVEM.L (A7)+,D2-D4
    RTS

;!======

LAB_06FC:
    MOVEQ   #0,D0
    MOVE.B  LAB_21ED,D0
    SUBI.W  #13,D0
    BEQ.S   LAB_06FE

    SUBI.W  #14,D0
    BEQ.S   LAB_06FE

    SUBI.W  #$80,D0
    BNE.S   LAB_06FF

    MOVE.L  LAB_231C,D0
    LSL.L   #2,D0
    ADD.L   LAB_231C,D0
    LEA     LAB_231D,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEQ   #32,D1
    CMP.B   1(A1),D1
    BNE.S   LAB_0700

    ADDA.L  D0,A0
    MOVEQ   #64,D0
    CMP.B   2(A0),D0
    BNE.S   LAB_06FD

    JSR     LAB_07FF(PC)

    BRA.S   LAB_0700

LAB_06FD:
    MOVE.L  LAB_231C,D0
    LSL.L   #2,D0
    ADD.L   LAB_231C,D0
    LEA     LAB_231D,A0
    ADDA.L  D0,A0
    MOVEQ   #65,D0
    CMP.B   2(A0),D0
    BNE.S   LAB_0700

    JSR     LAB_0801(PC)

    BRA.S   LAB_0700

LAB_06FE:
    JSR     DRAW_BOTTOM_HELP_FOR_ESC_MENU(PC)

    MOVEQ   #1,D0
    MOVE.L  D0,LAB_21E4
    JSR     LAB_0805(PC)

    BRA.S   LAB_0700

LAB_06FF:
    MOVE.L  LAB_21EA,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_095F(PC)

    ADDQ.W  #4,A7
    EXT.L   D0
    MOVE.L  D0,LAB_21EA
    MOVEQ   #1,D0
    MOVE.L  D0,LAB_21FE

LAB_0700:
    JSR     LAB_080E(PC)

    RTS

;!======

LAB_0701:
    MOVEM.L D6-D7,-(A7)
    JSR     LAB_07D4(PC)

    MOVE.L  D0,D7
    MOVEQ   #0,D6
    MOVE.B  D7,D0
    EXT.W   D0
    CMPI.W  #9,D0
    BCC.W   .LAB_0706

    ADD.W   D0,D0
    MOVE.W  .LAB_0702(PC,D0.W),D0
    JMP     .LAB_0702+2(PC,D0.W)

.LAB_0702:
    ORI.B   #$18,(A0)
    DC.W    $003a
    ORI.W   #$84,(A4)+
    DC.W    $008a
    ORI.L   #$c600bc,24832(A6)
    DC.W    $033e
    BRA.W   .LAB_0709

    MOVE.B  LAB_1BC4,D0
    MOVEQ   #76,D1
    CMP.B   D1,D0
    BNE.S   .LAB_0704

    JSR     LAB_07F0(PC)

    MOVE.B  #$2,LAB_1D13
    BRA.W   .LAB_0709

.LAB_0704:
    MOVEQ   #1,D6
    BRA.W   .LAB_0709

    MOVE.B  LAB_1BC4,D0
    MOVEQ   #76,D1
    CMP.B   D1,D0
    BNE.S   .LAB_0705

    JSR     LAB_07F0(PC)

    MOVE.B  #$3,LAB_1D13
    BRA.W   .LAB_0709

.LAB_0705:
    MOVEQ   #1,D6
    BRA.W   .LAB_0709

    MOVE.B  #$6,LAB_1D13
    JSR     LAB_07EB(PC)

    MOVE.L  LAB_21E2,LAB_21E8
    PEA     9.W
    JSR     LAB_07E9(PC)

    JSR     LAB_07EC(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D6
    BRA.S   .LAB_0709

    BSR.W   LAB_0718

    BRA.S   .LAB_0709

    MOVE.B  #$a,LAB_1D13
    JSR     LAB_07EB(PC)

    CLR.L   LAB_21E8
    PEA     4.W
    JSR     LAB_07E9(PC)

    JSR     DRAW_ESC_SPECIAL_FUNCTIONS_MENU_TEXT(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D6
    BRA.S   .LAB_0709

    MOVE.B  #$8,LAB_1D13
    JSR     LAB_07E4(PC)

    BRA.S   .LAB_0709

    MOVE.W  #1,LAB_1DE4
    BRA.S   .LAB_0709

.LAB_0706:
    MOVEQ   #9,D0
    CMP.B   D0,D7
    BNE.S   .LAB_0707

    MOVEQ   #5,D0
    BRA.S   .LAB_0708

.LAB_0707:
    MOVEQ   #1,D0

.LAB_0708:
    ADD.L   D0,LAB_21E8
    MOVE.L  LAB_21E8,D0
    MOVEQ   #6,D1
    JSR     JMP_TBL_LAB_1A07_2(PC)

    MOVE.L  D1,LAB_21E8
    JSR     LAB_07E5(PC)

.LAB_0709:
    TST.B   D6
    BEQ.S   .LAB_070B

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #4,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVE.B  D6,D0
    EXT.W   D0
    SUBQ.W  #1,D0
    BNE.S   .LAB_070A

    PEA     LAB_1D29
    PEA     270.W
    PEA     145.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLAY_TEXT_AT_POSITION(PC)

    LEA     16(A7),A7

.LAB_070A:
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

.LAB_070B:
    MOVEM.L (A7)+,D6-D7
    RTS

;!======

LAB_070C:
    MOVE.L  LAB_231C,D0
    LSL.L   #2,D0
    ADD.L   LAB_231C,D0
    LEA     LAB_231D,A0
    ADDA.L  D0,A0
    MOVE.B  (A0),D0
    MOVE.B  D0,LAB_21ED
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    SUBI.W  #$31,D1
    BEQ.S   LAB_070D

    JSR     DRAW_BOTTOM_HELP_FOR_ESC_MENU(PC)

    CLR.W   LAB_2252

LAB_070D:
    RTS

;!======

LAB_070E:
    LINK.W  A5,#-48
    MOVEM.L D2/D7,-(A7)

    MOVE.W  #1,LAB_2263
    MOVE.B  LAB_1DD6,D0
    MOVE.B  D0,LAB_21E3
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEA.L GLOB_HANDLE_H26F_FONT,A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    LEA     GLOB_REF_696_400_BITMAP,A0
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVE.L  A0,4(A1)
    MOVEQ   #3,D0
    MOVE.L  #696,D1
    MOVE.L  #509,D2
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitBitMap(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    JSR     _LVOSetRast(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    JSR     LAB_0A49(PC)

    MOVEQ   #0,D7

LAB_070F:
    MOVEQ   #24,D0
    CMP.L   D0,D7
    BGE.S   LAB_0710

    LEA     LAB_2295,A0
    ADDA.L  D7,A0
    LEA     LAB_1FB8,A1
    ADDA.L  D7,A1
    MOVE.B  (A1),(A0)
    ADDQ.L  #1,D7
    BRA.S   LAB_070F

LAB_0710:
    MOVEA.L AbsExecBase,A6
    JSR     _LVODisable(A6)

    MOVE.W  #$100,LAB_1F45
    CLR.W   LAB_226D
    PEA     3.W
    JSR     LAB_07C4(PC)

    JSR     LAB_08B8(PC)

    CLR.L   LAB_21E4
    JSR     LAB_0723(PC)

    ADDQ.W  #4,A7
    MOVEA.L AbsExecBase,A6
    JSR     _LVOEnable(A6)

    MOVEQ   #0,D0
    MOVE.B  LAB_1DCB,D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVEQ   #10,D1
    JSR     JMP_TBL_LAB_1A06_4(PC)

    MOVEQ   #0,D1
    MOVE.B  LAB_1DCB+1,D1
    ADD.L   D1,D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVE.L  D0,LAB_21FD
    MOVEQ   #0,D0
    MOVE.B  LAB_1DCD,D0
    SUB.L   D1,D0
    MOVE.L  D0,LAB_21FB
    MOVEQ   #6,D1
    CMP.L   D1,D0
    BLE.S   LAB_0711

    MOVE.L  D1,LAB_21FB
    MOVE.B  #$36,LAB_1DCD

LAB_0711:
    MOVE.L  LAB_21FB,D0
    MOVEQ   #40,D1
    JSR     JMP_TBL_LAB_1A06_4(PC)

    MOVE.L  D0,LAB_21EB
    MOVEQ   #1,D0
    MOVE.L  D0,GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER
    JSR     DRAW_BOTTOM_HELP_FOR_ESC_MENU(PC)

    MOVE.L  GLOB_LONG_PATCH_VERSION_NUMBER,-(A7)
    PEA     GLOB_STR_NINE_POINT_ZERO
    PEA     GLOB_STR_VER_PERCENT_S_PERCENT_L_D
    PEA     -41(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    JSR     LAB_0726(PC)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #3,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEA.L 52(A1),A0
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    MOVEQ   #34,D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   LAB_0712

    ADDQ.L  #1,D1

LAB_0712:
    ASR.L   #1,D1
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    ADD.L   D0,D1
    MOVEQ   #33,D0
    ADD.L   D0,D1
    PEA     -41(A5)
    MOVE.L  D1,-(A7)
    PEA     280.W
    MOVE.L  A1,-(A7)
    JSR     DISPLAY_TEXT_AT_POSITION(PC)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    JSR     LAB_0A48(PC)

    PEA     LAB_2321
    JSR     LAB_071D(PC)

    MOVEM.L -56(A5),D2/D7
    UNLK    A5
    RTS

;!======

LAB_0713:
    MOVE.L  D2,-(A7)

    CLR.W   LAB_1B85

    LEA     GLOB_REF_696_400_BITMAP,A0
    MOVEQ   #3,D0
    MOVE.L  #696,D1
    MOVE.L  #400,D2
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitBitMap(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1          ; rastport
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0     ; font
    JSR     _LVOSetFont(A6)

    JSR     LAB_071E(PC)

    MOVEQ   #0,D0
    MOVE.W  D0,LAB_2252
    MOVE.W  D0,LAB_1DF3
    JSR     LAB_08AD(PC)

    CLR.W   LAB_1F3C
    JSR     LAB_09B7(PC)

    JSR     LAB_0969(PC)

    BSR.W   LAB_0719

    MOVEQ   #1,D0
    MOVE.L  D0,LAB_225F
    MOVE.L  LAB_2262,-(A7)
    MOVE.L  LAB_2260,-(A7)
    JSR     LAB_098A(PC)

    JSR     JMP_TBL_DRAW_FILLED_RECT_0_0_TO_695_1_PEN_7(PC)

    ADDQ.W  #8,A7
    MOVEQ   #1,D0
    CMP.L   LAB_21E4,D0
    BNE.S   LAB_0714

    JSR     LAB_0720(PC)

LAB_0714:
    MOVEQ   #-1,D0
    MOVE.L  D0,LAB_1FE9
    MOVE.B  LAB_21E3,D0
    MOVE.B  LAB_1DD6,D1
    CMP.B   D1,D0
    BEQ.S   LAB_0716

    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   LAB_0715

    CMP.B   D2,D0
    BNE.S   LAB_0715

    BSR.W   LAB_071B

LAB_0715:
    MOVE.B  LAB_1DD6,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BNE.S   LAB_0716

    MOVE.B  LAB_21E3,D0
    CMP.B   D1,D0
    BEQ.S   LAB_0716

    CLR.L   -(A7)
    PEA     LAB_1ED2
    JSR     LAB_0AA4(PC)

    ADDQ.W  #8,A7
    CLR.L   LAB_1B27

LAB_0716:
    MOVE.W  LAB_2346,D0
    BEQ.S   LAB_0717

    MOVE.W  #3,LAB_2346

LAB_0717:
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_2284
    MOVE.W  D0,LAB_2282
    MOVE.W  D0,CTRL_H
    MOVE.W  D0,LAB_2263
    JSR     LAB_0725(PC)

    JSR     LAB_07E4(PC)

    PEA     1.W
    JSR     LAB_09A7(PC)

    JSR     LAB_0A48(PC)

    ADDQ.W  #4,A7
    CLR.W   LAB_1F45

    MOVE.L  (A7)+,D2
    RTS

;!======

LAB_0718:

.printfResult   = -41

    LINK.W  A5,#-48

    MOVE.B  #$7,LAB_1D13
    MOVE.W  #1,LAB_2252

    JSR     LAB_07E4(PC)

    PEA     GLOB_PTR_STR_SELECT_CODE
    PEA     360.W
    PEA     90.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLAY_TEXT_AT_POSITION(PC)

    PEA     LAB_2245    ; I have no idea what this text is...
    PEA     360.W
    PEA     210.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLAY_TEXT_AT_POSITION(PC)

    MOVE.L  GLOB_REF_BAUD_RATE,(A7)
    PEA     GLOB_STR_BAUD_RATE_DIAGNOSTIC_MODE
    PEA     .printfResult(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    PEA     .printfResult(A5)
    PEA     360.W
    PEA     410.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLAY_TEXT_AT_POSITION(PC)

    PEA     LAB_1D2E
    JSR     LAB_03C0(PC)

    PEA     LAB_1D2F
    MOVE.L  D0,64(A7)
    JSR     LAB_03C4(PC)

    MOVE.L  D0,(A7)
    MOVE.L  64(A7),-(A7)
    PEA     GLOB_STR_DISK_0_IS_VAR_FULL_WITH_VAR_ERRORS
    PEA     .printfResult(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    LEA     76(A7),A7
    PEA     .printfResult(A5)
    PEA     88.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLAY_TEXT_AT_POSITION(PC)

    JSR     DRAW_DIAGNOSTIC_MODE_TEXT(PC)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #6,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    PEA     GLOB_STR_PUSH_ANY_KEY_TO_CONTINUE_2
    PEA     390.W
    PEA     175.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLAY_TEXT_AT_POSITION(PC)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    UNLK    A5
    RTS

;!======

LAB_0719:
    CLR.B   LAB_1D13
    RTS

;!======

LAB_071A:
    TST.W   LAB_1B83
    BEQ.S   LAB_071A

    MOVE.W  #$2e,LAB_2265
    MOVE.W  LAB_22A9,D0
    ANDI.W  #$fffd,D0
    MOVE.W  D0,LAB_22A9
    CLR.L   -(A7)
    JSR     LAB_0A0B(PC)

    ADDQ.W  #4,A7
    RTS

;!======

LAB_071B:
    TST.W   LAB_1B83

    BEQ.S   LAB_071B

    MOVE.W  #$2e,LAB_2265
    MOVE.W  LAB_22A9,D0
    ANDI.W  #$fffe,D0
    MOVE.W  D0,LAB_22A9
    PEA     1.W
    JSR     LAB_0A0B(PC)

    ADDQ.W  #4,A7
    RTS

;!======

JMP_TBL_DRAW_FILLED_RECT_0_0_TO_695_1_PEN_7:
    JMP     DRAW_FILLED_RECT_0_0_TO_695_1_PEN_7

LAB_071D:
    JMP     LAB_0F12

;!======

    ; Alignment
    ORI.B   #0,D0
    ORI.B   #0,D0
    ORI.B   #0,D0
    ORI.B   #0,D0
    ORI.B   #0,D0
    ORI.B   #0,D0

;!======

LAB_071E:
    JMP     LAB_0DD5

LAB_071F:
    JMP     LAB_0EE7

LAB_0720:
    JMP     LAB_0E48

LAB_0721:
    JMP     LAB_00E3

LAB_0722:
    JMP     LAB_0CA7

LAB_0723:
    JMP     GCOMMAND_SeedBannerDefaults

LAB_0724:
    JMP     LAB_1AAE

LAB_0725:
    JMP     GCOMMAND_SeedBannerFromPrefs

LAB_0726:
    JMP     LAB_020C

LAB_0727:
    JMP     LAB_0EE6

;!======

LAB_0728:
    LINK.W  A5,#-44

    MOVE.W  LAB_1F40,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     LAB_1D34
    PEA     -41(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    PEA     210.W
    PEA     -41(A5)
    MOVE.L  A0,-(A7)
    JSR     LAB_09AD(PC)

    UNLK    A5
    RTS

;!======

LAB_0729:
    LINK.W  A5,#-52
    MOVE.L  D2,-(A7)
    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVEA.L A0,A1
    MOVEQ   #2,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    MOVE.B  LAB_1BA4,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.B  LAB_1BA5,D1
    EXT.W   D1
    EXT.L   D1
    MOVE.B  LAB_1BAD,D2
    EXT.W   D2
    EXT.L   D2
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_1D35
    PEA     -51(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    PEA     120.W
    PEA     -51(A5)
    MOVE.L  A0,-(A7)
    JSR     LAB_09AD(PC)

    MOVE.B  LAB_1BB7,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  LAB_1BBD,(A7)
    MOVE.L  LAB_1BBE,-(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_1D36
    PEA     -51(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    PEA     150.W
    PEA     -51(A5)
    MOVE.L  A0,-(A7)
    JSR     LAB_09AD(PC)

    MOVE.B  LAB_1BC9,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    PEA     GLOB_STR_CLOCKCMD_EQUALS_PCT_C
    PEA     -51(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    LEA     68(A7),A7
    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    PEA     180.W
    PEA     -51(A5)
    MOVE.L  A0,-(A7)
    JSR     LAB_09AD(PC)

    MOVE.L  -56(A5),D2
    UNLK    A5
    RTS
