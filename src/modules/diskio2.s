;!======

LAB_0471:
    LINK.W  A5,#-24
    MOVEM.L D6-D7,-(A7)
    MOVE.W  LAB_2231,D0
    CMPI.W  #$c8,D0
    BLS.S   LAB_0472

    MOVEQ   #0,D0
    BRA.W   LAB_0482

LAB_0472:
    TST.L   LAB_1B9F
    BNE.S   LAB_0473

    MOVEQ   #0,D0
    BRA.W   LAB_0482

LAB_0473:
    CLR.L   LAB_1B9F
    CLR.B   -17(A5)

    ; DISKIO2.C:152 - Allocate 1000 bytes
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     1000.W
    PEA     152.W
    PEA     GLOB_STR_DISKIO2_C_1
    JSR     JMP_TBL_ALLOCATE_MEMORY_1(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-22(A5)
    BNE.S   LAB_0474

    MOVEQ   #1,D0
    MOVE.L  D0,LAB_1B9F
    MOVEQ   #-1,D0
    BRA.W   LAB_0482

LAB_0474:
    PEA     MODE_NEWFILE.W
    PEA     LAB_1B9B
    JSR     LOAD_FILE_CONTENTS_INTO_MEMORY_MAYBE(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_21BE
    TST.L   D0
    BNE.S   LAB_0475

    PEA     1000.W
    MOVE.L  -22(A5),-(A7)
    PEA     176.W
    PEA     GLOB_STR_DISKIO2_C_2
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

    MOVEQ   #1,D0
    MOVE.L  D0,LAB_1B9F
    MOVEQ   #-1,D0
    BRA.W   LAB_0482

LAB_0475:
    PEA     21.W
    PEA     LAB_1DC8
    MOVE.L  LAB_21BE,-(A7)
    JSR     LAB_03A0(PC)

    MOVE.W  LAB_2241,D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  LAB_21BE,-(A7)
    JSR     LAB_03A9(PC)

    PEA     7.W
    PEA     GLOB_STR_DREV_5_1
    MOVE.L  LAB_21BE,-(A7)
    JSR     LAB_03A0(PC)

    LEA     LAB_2245,A0
    MOVEA.L A0,A1

LAB_0476:
    TST.B   (A1)+
    BNE.S   LAB_0476

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  LAB_21BE,-(A7)
    JSR     LAB_03A0(PC)

    LEA     36(A7),A7
    TST.L   LAB_1DD9
    BNE.S   LAB_0477

    LEA     -17(A5),A0
    MOVE.L  A0,-12(A5)
    BRA.S   LAB_0478

LAB_0477:
    MOVEA.L LAB_1DD9,A0
    MOVE.L  A0,-12(A5)

LAB_0478:
    TST.B   (A0)+
    BNE.S   LAB_0478

    SUBQ.L  #1,A0
    SUBA.L  -12(A5),A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  LAB_21BE,-(A7)
    JSR     LAB_03A0(PC)

    MOVEQ   #0,D0
    MOVE.B  LAB_2230,D0
    MOVE.L  D0,(A7)
    MOVE.L  LAB_21BE,-(A7)
    JSR     LAB_03A9(PC)

    MOVEQ   #0,D0
    MOVE.W  LAB_2231,D0
    MOVE.L  D0,(A7)
    MOVE.L  LAB_21BE,-(A7)
    JSR     LAB_03A9(PC)

    MOVEQ   #0,D0
    MOVE.B  LAB_2247,D0
    MOVE.L  D0,(A7)
    MOVE.L  LAB_21BE,-(A7)
    JSR     LAB_03A9(PC)

    MOVEQ   #0,D0
    MOVE.W  LAB_2248,D0
    MOVE.L  D0,(A7)
    MOVE.L  LAB_21BE,-(A7)
    JSR     LAB_03A9(PC)

    LEA     28(A7),A7
    MOVEQ   #0,D7

LAB_0479:
    MOVE.W  LAB_2231,D0
    CMP.W   D0,D7
    BGE.W   LAB_0481

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2233,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    LEA     LAB_2236,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-8(A5)
    PEA     48.W
    MOVE.L  -4(A5),-(A7)
    MOVE.L  LAB_21BE,-(A7)
    JSR     LAB_03A0(PC)

    MOVEA.L -8(A5),A0

LAB_047A:
    TST.B   (A0)+
    BNE.S   LAB_047A

    SUBQ.L  #1,A0
    SUBA.L  -8(A5),A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  LAB_21BE,-(A7)
    JSR     LAB_03A0(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D6

LAB_047B:
    MOVEQ   #49,D0
    CMP.W   D0,D6
    BGE.W   LAB_0480

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -8(A5),A0
    TST.L   56(A0,D0.L)
    BEQ.W   LAB_047F

    MOVEA.L -4(A5),A1
    ADDA.W  #$1c,A1
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A1,-(A7)
    JSR     LAB_0545(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.W   LAB_047F

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_21BE,-(A7)
    JSR     LAB_03A9(PC)

    MOVEQ   #0,D0
    MOVEA.L -8(A5),A0
    MOVE.B  7(A0,D6.W),D0
    MOVE.L  D0,(A7)
    MOVE.L  LAB_21BE,-(A7)
    JSR     LAB_03A9(PC)

    MOVEQ   #0,D0
    MOVEA.L -8(A5),A0
    MOVE.L  D6,D1
    ADDI.W  #$fc,D1
    MOVE.B  0(A0,D1.W),D0
    MOVE.L  D0,(A7)
    MOVE.L  LAB_21BE,-(A7)
    JSR     LAB_03A9(PC)

    MOVEQ   #0,D0
    MOVEA.L -8(A5),A0
    MOVE.L  D6,D1
    ADDI.W  #$12d,D1
    MOVE.B  0(A0,D1.W),D0
    MOVE.L  D0,(A7)
    MOVE.L  LAB_21BE,-(A7)
    JSR     LAB_03A9(PC)

    MOVEQ   #0,D0
    MOVEA.L -8(A5),A0
    MOVE.L  D6,D1
    ADDI.W  #$15e,D1
    MOVE.B  0(A0,D1.W),D0
    MOVE.L  D0,(A7)
    MOVE.L  LAB_21BE,-(A7)
    JSR     LAB_03A9(PC)

    LEA     24(A7),A7
    MOVE.W  LAB_2231,D0
    MOVEQ   #100,D1
    CMP.W   D1,D0
    BLS.S   LAB_047C

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  -22(A5),-(A7)
    BSR.W   LAB_052D

    LEA     16(A7),A7
    MOVE.L  D0,-12(A5)
    BRA.S   LAB_047D

LAB_047C:
    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -8(A5),A0
    MOVEA.L 56(A0,D0.L),A0
    MOVE.L  A0,-12(A5)

LAB_047D:
    MOVEA.L -12(A5),A0

LAB_047E:
    TST.B   (A0)+
    BNE.S   LAB_047E

    SUBQ.L  #1,A0
    SUBA.L  -12(A5),A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  LAB_21BE,-(A7)
    JSR     LAB_03A0(PC)

    LEA     12(A7),A7

LAB_047F:
    ADDQ.W  #1,D6
    BRA.W   LAB_047B

LAB_0480:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_21BE,-(A7)
    JSR     LAB_03A9(PC)

    ADDQ.W  #8,A7
    ADDQ.W  #1,D7
    BRA.W   LAB_0479

LAB_0481:
    MOVE.L  LAB_21BE,-(A7)
    JSR     LAB_039A(PC)

    MOVEQ   #1,D0
    MOVE.L  D0,LAB_1B9F
    PEA     1000.W
    MOVE.L  -22(A5),-(A7)
    PEA     275.W
    PEA     GLOB_STR_DISKIO2_C_3
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

    MOVEQ   #0,D0

LAB_0482:
    MOVEM.L -32(A5),D6-D7
    UNLK    A5
    RTS

;!======

LAB_0483:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    PEA     GLOB_STR_38_SPACES
    PEA     120.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLAY_TEXT_AT_POSITION(PC)

    MOVE.L  A3,(A7)
    PEA     120.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLAY_TEXT_AT_POSITION(PC)

    LEA     28(A7),A7
    MOVEA.L (A7)+,A3
    RTS

;!======

LAB_0484:
    LINK.W  A5,#-100
    MOVE.L  D7,-(A7)
    MOVE.L  8(A5),D7

    PEA     1.W
    PEA     256.W
    JSR     LAB_053D(PC)

    ADDQ.W  #8,A7
    LEA     LAB_1C47,A0
    LEA     -100(A5),A1
    MOVEQ   #8,D0

LAB_0485:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,LAB_0485
    TST.L   D7
    BEQ.S   LAB_0486

    PEA     -100(A5)
    BSR.W   LAB_0483

    ADDQ.W  #4,A7

LAB_0486:
    BSR.W   LAB_0535

    LEA     LAB_1C48,A0
    LEA     -100(A5),A1
    MOVEQ   #8,D0

LAB_0487:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,LAB_0487
    TST.L   D7
    BEQ.S   LAB_0488

    PEA     -100(A5)
    BSR.W   LAB_0483

    ADDQ.W  #4,A7

LAB_0488:
    JSR     LAB_0720(PC)

    LEA     LAB_1C49,A0
    LEA     -100(A5),A1
    MOVEQ   #8,D0

LAB_0489:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,LAB_0489
    TST.L   D7
    BEQ.S   LAB_048A

    PEA     -100(A5)
    BSR.W   LAB_0483

    ADDQ.W  #4,A7

LAB_048A:
    JSR     LAB_041A(PC)

    LEA     LAB_1C4A,A0
    LEA     -100(A5),A1
    MOVEQ   #8,D0

LAB_048B:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,LAB_048B
    TST.L   D7
    BEQ.S   LAB_048C

    PEA     -100(A5)
    BSR.W   LAB_0483

    ADDQ.W  #4,A7

LAB_048C:
    PEA     LAB_2324
    PEA     LAB_2321
    JSR     LAB_0540(PC)

    ADDQ.W  #8,A7
    LEA     LAB_1C4B,A0
    LEA     -100(A5),A1
    MOVEQ   #8,D0

LAB_048D:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,LAB_048D
    TST.L   D7
    BEQ.S   LAB_048E

    PEA     -100(A5)
    BSR.W   LAB_0483

    ADDQ.W  #4,A7

LAB_048E:
    BSR.W   LAB_04E6

    LEA     LAB_1C4C,A0
    LEA     -100(A5),A1
    MOVEQ   #8,D0

LAB_048F:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,LAB_048F
    TST.L   D7
    BEQ.S   LAB_0490

    PEA     -100(A5)
    BSR.W   LAB_0483

    ADDQ.W  #4,A7

LAB_0490:
    JSR     LAB_07CA(PC)

    LEA     LAB_1C4D,A0
    LEA     -100(A5),A1
    MOVEQ   #8,D0

LAB_0491:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,LAB_0491
    TST.L   D7
    BEQ.S   LAB_0492

    PEA     -100(A5)
    BSR.W   LAB_0483

    ADDQ.W  #4,A7

LAB_0492:
    PEA     LAB_21DF
    JSR     LAB_0610(PC)

    ADDQ.W  #4,A7
    LEA     LAB_1C4E,A0
    LEA     -100(A5),A1
    MOVEQ   #8,D0

LAB_0493:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,LAB_0493
    TST.L   D7
    BEQ.S   LAB_0494

    PEA     -100(A5)
    BSR.W   LAB_0483

    ADDQ.W  #4,A7

LAB_0494:
    JSR     LAB_0543(PC)

    LEA     LAB_1C4F,A0
    LEA     -100(A5),A1
    MOVEQ   #8,D0

LAB_0495:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,LAB_0495
    TST.L   D7
    BEQ.S   LAB_0496

    PEA     -100(A5)
    BSR.W   LAB_0483

    ADDQ.W  #4,A7

LAB_0496:
    JSR     LAB_0541(PC)

    JSR     LAB_0548(PC)

    JSR     LAB_053F(PC)

    CLR.L   -(A7)
    PEA     256.W
    JSR     LAB_053D(PC)

    MOVE.L  -104(A5),D7
    UNLK    A5
    RTS

;!======

LAB_0497:
    LINK.W  A5,#-76
    MOVEM.L D5-D7/A2-A3,-(A7)
    MOVE.W  #(-1),-28(A5)
    MOVEQ   #0,D7

LAB_0498:
    MOVEQ   #21,D0
    CMP.W   D0,D7
    BGE.S   LAB_0499

    LEA     LAB_1DC8,A0
    ADDA.W  D7,A0
    MOVE.B  (A0),-65(A5,D7.W)
    ADDQ.W  #1,D7
    BRA.S   LAB_0498

LAB_0499:
    PEA     LAB_1B9B
    JSR     LAB_03AC(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BNE.S   LAB_049A

    CLR.W   LAB_2241
    PEA     -65(A5)
    JSR     LAB_053A(PC)

    MOVEQ   #-1,D0
    BRA.W   LAB_04C0

LAB_049A:
    MOVE.L  GLOB_REF_LONG_FILE_SCRATCH,-40(A5)
    MOVE.L  LAB_21BC,-16(A5)
    MOVEQ   #0,D7

LAB_049B:
    MOVE.L  GLOB_REF_LONG_FILE_SCRATCH,D0
    TST.L   D0
    BLE.S   LAB_049C

    MOVEQ   #21,D1
    CMP.W   D1,D7
    BGE.S   LAB_049C

    MOVEA.L LAB_21BC,A0
    MOVE.B  (A0)+,-65(A5,D7.W)
    MOVE.L  A0,LAB_21BC
    SUBQ.L  #1,GLOB_REF_LONG_FILE_SCRATCH
    ADDQ.W  #1,D7
    BRA.S   LAB_049B

LAB_049C:
    JSR     LAB_03B6(PC)

    MOVE.W  D0,LAB_2241
    PEA     -65(A5)
    JSR     LAB_053A(PC)

    JSR     LAB_03B2(PC)

    ADDQ.W  #4,A7
    MOVEA.W #$ffff,A0
    MOVE.L  D0,-12(A5)
    CMP.L   A0,D0
    BNE.S   LAB_049D

    MOVE.L  -40(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -16(A5),-(A7)
    PEA     520.W
    PEA     GLOB_STR_DISKIO2_C_4
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

    MOVEQ   #-1,D0
    BRA.W   LAB_04C0

LAB_049D:
    MOVEA.L D0,A0
    LEA     LAB_2249,A1

LAB_049E:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_049E

    PEA     LAB_1C51
    PEA     LAB_2249
    JSR     LAB_0542(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   LAB_049F

    MOVE.W  #1,LAB_1C41
    MOVEQ   #40,D0
    MOVE.L  D0,-32(A5)
    BRA.W   LAB_04A4

LAB_049F:
    PEA     LAB_1C52
    PEA     LAB_2249
    JSR     LAB_0542(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   LAB_04A0

    MOVE.W  #2,LAB_1C41
    MOVEQ   #41,D0
    MOVE.L  D0,-32(A5)
    BRA.W   LAB_04A4

LAB_04A0:
    PEA     LAB_1C53
    PEA     LAB_2249
    JSR     LAB_0542(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   LAB_04A1

    MOVE.W  #3,LAB_1C41
    MOVEQ   #46,D0
    MOVE.L  D0,-32(A5)
    BRA.S   LAB_04A4

LAB_04A1:
    PEA     LAB_1C54
    PEA     LAB_2249
    JSR     LAB_0542(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   LAB_04A2

    MOVE.W  #4,LAB_1C41
    MOVEQ   #48,D0
    MOVE.L  D0,-32(A5)
    BRA.S   LAB_04A4

LAB_04A2:
    PEA     LAB_1C55
    PEA     LAB_2249
    JSR     LAB_0542(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   LAB_04A3

    MOVE.W  #5,LAB_1C41
    MOVEQ   #48,D0
    MOVE.L  D0,-32(A5)
    BRA.S   LAB_04A4

LAB_04A3:
    MOVE.L  -40(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -16(A5),-(A7)
    PEA     561.W
    PEA     GLOB_STR_DISKIO2_C_5
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

    MOVEQ   #-1,D0
    BRA.W   LAB_04C0

LAB_04A4:
    JSR     LAB_03B2(PC)

    MOVEA.W #$ffff,A0
    MOVE.L  D0,-12(A5)
    CMP.L   A0,D0
    BNE.S   LAB_04A5

    MOVE.L  -40(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -16(A5),-(A7)
    PEA     570.W
    PEA     GLOB_STR_DISKIO2_C_6
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

    MOVEQ   #-1,D0
    BRA.W   LAB_04C0

LAB_04A5:
    MOVEA.L D0,A0
    LEA     LAB_2245,A1

LAB_04A6:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_04A6

    MOVE.W  LAB_1C41,D0
    TST.W   D0
    BLE.S   LAB_04A8

    JSR     LAB_03B2(PC)

    MOVEA.W #$ffff,A0
    MOVE.L  D0,-12(A5)
    CMP.L   A0,D0
    BNE.S   LAB_04A7

    MOVE.L  -40(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -16(A5),-(A7)
    PEA     588.W
    PEA     GLOB_STR_DISKIO2_C_7
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

    MOVEQ   #-1,D0
    BRA.W   LAB_04C0

LAB_04A7:
    MOVE.L  LAB_1DD9,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_0385(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_1DD9

LAB_04A8:
    JSR     LAB_03B6(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #0,D0
    NOT.B   D0
    AND.L   D0,D1
    MOVEQ   #0,D7
    MOVE.B  LAB_2230,D0
    MOVE.B  D1,-41(A5)
    CMP.B   D0,D1
    BNE.W   LAB_04BC

    JSR     LAB_03B6(PC)

    MOVE.W  D0,-44(A5)
    JSR     LAB_03B6(PC)

    MOVE.B  D0,LAB_2247
    JSR     LAB_03B6(PC)

    MOVE.W  D0,LAB_2248
    MOVE.B  #$1,LAB_224A
    MOVE.W  #1,LAB_224B
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_224C
    CLR.L   -36(A5)
    MOVE.L  D0,D7

LAB_04A9:
    CMP.W   -44(A5),D7
    BGE.W   LAB_04BD

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     52.W
    PEA     634.W
    PEA     GLOB_STR_DISKIO2_C_8
    JSR     JMP_TBL_ALLOCATE_MEMORY_1(PC)

    LEA     16(A7),A7
    MOVEA.L D0,A3
    MOVE.L  A3,D0
    BNE.S   LAB_04AA

    MOVEQ   #-1,D0
    MOVE.L  D0,-36(A5)
    BRA.W   LAB_04BD

LAB_04AA:
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     500.W
    PEA     640.W
    PEA     GLOB_STR_DISKIO2_C_9
    JSR     JMP_TBL_ALLOCATE_MEMORY_1(PC)

    LEA     16(A7),A7
    MOVEA.L D0,A2
    MOVE.L  A2,D0
    BNE.S   LAB_04AB

    MOVEQ   #-1,D0
    MOVE.L  D0,-36(A5)
    PEA     52.W
    MOVE.L  A3,-(A7)
    PEA     644.W
    PEA     GLOB_STR_DISKIO2_C_10
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

    LEA     16(A7),A7
    BRA.W   LAB_04BD

LAB_04AB:
    MOVE.L  A3,-(A7)
    JSR     LAB_053E(PC)

    MOVE.L  A3,(A7)
    JSR     LAB_0345(PC)

    ADDQ.W  #4,A7
    MOVE.L  A3,-20(A5)
    MOVEQ   #0,D6

LAB_04AC:
    MOVE.L  D6,D0
    EXT.L   D0
    CMP.L   -32(A5),D0
    BGE.S   LAB_04AD

    MOVEA.L LAB_21BC,A0
    MOVEA.L -20(A5),A1
    MOVE.B  (A0)+,(A1)+
    MOVE.L  A0,LAB_21BC
    SUBQ.L  #1,GLOB_REF_LONG_FILE_SCRATCH
    MOVE.L  A1,-20(A5)
    ADDQ.W  #1,D6
    BRA.S   LAB_04AC

LAB_04AD:
    MOVEQ   #0,D0
    MOVE.B  40(A3),D0
    ANDI.W  #$ff7f,D0
    MOVE.B  D0,40(A3)
    LEA     1(A3),A0
    MOVEA.L A0,A1

LAB_04AE:
    TST.B   (A1)+
    BNE.S   LAB_04AE

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D5
    MOVE.W  LAB_224C,D0
    CMP.W   D0,D5
    BLE.S   LAB_04AF

    MOVE.W  D5,LAB_224C

LAB_04AF:
    JSR     LAB_03B2(PC)

    MOVEA.W #$ffff,A0
    MOVE.L  D0,-12(A5)
    CMP.L   A0,D0
    BNE.S   LAB_04B0

    MOVE.L  A0,-36(A5)
    BRA.W   LAB_04BD

LAB_04B0:
    MOVEA.L D0,A0
    MOVEA.L A2,A1

LAB_04B1:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_04B1

    MOVE.W  #(-1),-28(A5)
    MOVEQ   #0,D5

LAB_04B2:
    MOVEQ   #49,D0
    CMP.W   D0,D5
    BGE.W   LAB_04B9

    MOVE.B  #$1,7(A2,D5.W)
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    CLR.L   56(A2,D0.L)
    CMPI.W  #4,LAB_1C41
    BLE.S   LAB_04B5

    MOVE.W  -28(A5),D0
    TST.W   D0
    BPL.S   LAB_04B3

    JSR     LAB_03B6(PC)

    MOVE.W  D0,-28(A5)

LAB_04B3:
    CMP.W   D0,D5
    BGE.S   LAB_04B4

    BRA.W   LAB_04B8

LAB_04B4:
    MOVE.W  #(-1),-28(A5)

LAB_04B5:
    JSR     LAB_03B6(PC)

    MOVE.B  D0,7(A2,D5.W)
    CMPI.W  #1,LAB_1C41
    BLE.S   LAB_04B6

    JSR     LAB_03B6(PC)

    MOVE.L  D5,D1
    ADDI.W  #$fc,D1
    MOVE.B  D0,0(A2,D1.W)
    JSR     LAB_03B6(PC)

    MOVE.L  D5,D1
    ADDI.W  #$12d,D1
    MOVE.B  D0,0(A2,D1.W)
    JSR     LAB_03B6(PC)

    MOVE.L  D5,D1
    ADDI.W  #$15e,D1
    MOVE.B  D0,0(A2,D1.W)

LAB_04B6:
    JSR     LAB_03B2(PC)

    MOVEA.W #$ffff,A0
    MOVE.L  D0,-12(A5)
    CMP.L   A0,D0
    BNE.S   LAB_04B7

    MOVE.L  A0,-36(A5)
    BRA.S   LAB_04B9

LAB_04B7:
    MOVEQ   #0,D1
    MOVE.B  27(A3),D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_053C(PC)

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVE.L  56(A2,D0.L),(A7)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  D0,36(A7)
    JSR     LAB_0385(PC)

    LEA     12(A7),A7
    MOVE.L  24(A7),D1
    MOVE.L  D0,56(A2,D1.L)
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    TST.L   56(A2,D0.L)
    BEQ.S   LAB_04B8

    MOVEQ   #0,D0
    MOVE.B  40(A3),D0
    ORI.W   #$80,D0
    MOVE.B  D0,40(A3)

LAB_04B8:
    ADDQ.W  #1,D5
    BRA.W   LAB_04B2

LAB_04B9:
    CMPI.W  #4,LAB_1C41
    BLE.S   LAB_04BA

    MOVEQ   #-1,D0
    CMP.W   -28(A5),D0
    BNE.S   LAB_04BA

    JSR     LAB_03B6(PC)

    MOVE.W  D0,-28(A5)

LAB_04BA:
    MOVEQ   #-1,D0
    CMP.L   -36(A5),D0
    BNE.S   LAB_04BB

    PEA     52.W
    MOVE.L  A3,-(A7)
    PEA     736.W
    PEA     GLOB_STR_DISKIO2_C_11
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

    PEA     500.W
    MOVE.L  A2,-(A7)
    PEA     737.W
    PEA     GLOB_STR_DISKIO2_C_12
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

    LEA     32(A7),A7
    BRA.S   LAB_04BD

LAB_04BB:
    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2233,A0
    ADDA.L  D0,A0
    MOVE.L  A3,(A0)
    LEA     LAB_2236,A0
    ADDA.L  D0,A0
    MOVE.L  A2,(A0)
    ADDQ.W  #1,D7
    BRA.W   LAB_04A9

LAB_04BC:
    MOVEQ   #-1,D0
    MOVE.L  D0,-36(A5)

LAB_04BD:
    MOVE.B  -41(A5),LAB_2238
    MOVE.L  D7,D0
    MOVE.W  D0,LAB_2231
    MOVE.L  -40(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -16(A5),-(A7)
    PEA     764.W
    PEA     GLOB_STR_DISKIO2_C_13
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

    MOVEQ   #0,D0
    MOVE.B  -41(A5),D0
    MOVE.L  D0,(A7)
    JSR     LAB_031A(PC)

    LEA     16(A7),A7
    ADDQ.L  #1,D0
    BEQ.S   LAB_04BE

    MOVE.B  #$1,LAB_1B8F
    MOVE.B  -41(A5),LAB_1B91
    BRA.S   LAB_04BF

LAB_04BE:
    MOVEQ   #0,D0
    MOVE.B  D0,LAB_1B8F
    MOVE.B  D0,LAB_1B91

LAB_04BF:
    MOVE.L  -36(A5),D0

LAB_04C0:
    MOVEM.L -96(A5),D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_04C1:
    LINK.W  A5,#-24
    MOVEM.L D6-D7,-(A7)

.offsetAllocatedMemory  = -22
.desiredMemory          = 1000

    MOVE.W  LAB_222F,D0
    CMPI.W  #200,D0
    BLS.S   .LAB_04C2

    MOVEQ   #0,D0
    BRA.W   .return

.LAB_04C2:
    TST.L   LAB_1B9F
    BNE.S   .LAB_04C3

    MOVEQ   #0,D0
    BRA.W   .return

.LAB_04C3:
    CLR.L   LAB_1B9F
    CLR.B   -17(A5)

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     (.desiredMemory).W
    PEA     817.W
    PEA     GLOB_STR_DISKIO2_C_14
    JSR     JMP_TBL_ALLOCATE_MEMORY_1(PC)

    LEA     16(A7),A7
    MOVE.L  D0,.offsetAllocatedMemory(A5)
    BNE.S   .LAB_04C4

    MOVEQ   #1,D0
    MOVE.L  D0,LAB_1B9F
    MOVEQ   #-1,D0
    BRA.W   .return

.LAB_04C4:
    PEA     (MODE_NEWFILE).W
    PEA     GLOB_STR_DF0_NXTDAY_DAT
    JSR     LOAD_FILE_CONTENTS_INTO_MEMORY_MAYBE(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_21C1
    TST.L   D0
    BNE.S   .LAB_04C5

    MOVEQ   #1,D0
    MOVE.L  D0,LAB_1B9F
    PEA     (.desiredMemory).W
    MOVE.L  .offsetAllocatedMemory(A5),-(A7)
    PEA     839.W
    PEA     GLOB_STR_DISKIO2_C_15
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

    MOVEQ   #-1,D0
    BRA.W   .return

.LAB_04C5:
    MOVEQ   #0,D0
    MOVE.B  LAB_222D,D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_21C1,-(A7)
    JSR     LAB_03A9(PC)

    MOVEQ   #0,D0
    MOVE.W  LAB_222F,D0
    MOVE.L  D0,(A7)
    MOVE.L  LAB_21C1,-(A7)
    JSR     LAB_03A9(PC)

    MOVEQ   #0,D0
    MOVE.B  LAB_224D,D0
    MOVE.L  D0,(A7)
    MOVE.L  LAB_21C1,-(A7)
    JSR     LAB_03A9(PC)

    MOVEQ   #0,D0
    MOVE.W  LAB_224E,D0
    MOVE.L  D0,(A7)
    MOVE.L  LAB_21C1,-(A7)
    JSR     LAB_03A9(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D7

.LAB_04C6:
    MOVE.W  LAB_222F,D0
    CMP.W   D0,D7
    BGE.W   .LAB_04CE

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2235,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    LEA     LAB_2237,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-8(A5)
    PEA     48.W
    MOVE.L  -4(A5),-(A7)
    MOVE.L  LAB_21C1,-(A7)
    JSR     LAB_03A0(PC)

    MOVEA.L -8(A5),A0

.LAB_04C7:
    TST.B   (A0)+
    BNE.S   .LAB_04C7

    SUBQ.L  #1,A0
    SUBA.L  -8(A5),A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  LAB_21C1,-(A7)
    JSR     LAB_03A0(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D6

.LAB_04C8:
    MOVEQ   #49,D0
    CMP.W   D0,D6
    BGE.W   .LAB_04CD

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -8(A5),A0
    TST.L   56(A0,D0.L)
    BEQ.W   .LAB_04CC

    MOVEA.L -4(A5),A1
    ADDA.W  #28,A1
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A1,-(A7)
    JSR     LAB_0545(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.W   .LAB_04CC

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_21C1,-(A7)
    JSR     LAB_03A9(PC)

    MOVEQ   #0,D0
    MOVEA.L -8(A5),A0
    MOVE.B  7(A0,D6.W),D0
    MOVE.L  D0,(A7)
    MOVE.L  LAB_21C1,-(A7)
    JSR     LAB_03A9(PC)

    MOVEQ   #0,D0
    MOVEA.L -8(A5),A0
    MOVE.L  D6,D1
    ADDI.W  #252,D1
    MOVE.B  0(A0,D1.W),D0
    MOVE.L  D0,(A7)
    MOVE.L  LAB_21C1,-(A7)
    JSR     LAB_03A9(PC)

    MOVEQ   #0,D0
    MOVEA.L -8(A5),A0
    MOVE.L  D6,D1
    ADDI.W  #301,D1
    MOVE.B  0(A0,D1.W),D0
    MOVE.L  D0,(A7)
    MOVE.L  LAB_21C1,-(A7)
    JSR     LAB_03A9(PC)

    MOVEQ   #0,D0
    MOVEA.L -8(A5),A0
    MOVE.L  D6,D1
    ADDI.W  #350,D1
    MOVE.B  0(A0,D1.W),D0
    MOVE.L  D0,(A7)
    MOVE.L  LAB_21C1,-(A7)
    JSR     LAB_03A9(PC)

    LEA     24(A7),A7
    MOVE.W  LAB_222F,D0
    MOVEQ   #100,D1
    CMP.W   D1,D0
    BLS.S   .LAB_04C9

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  -22(A5),-(A7)
    BSR.W   LAB_052D

    LEA     16(A7),A7
    MOVE.L  D0,-12(A5)
    BRA.S   .LAB_04CA

.LAB_04C9:
    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -8(A5),A0
    MOVEA.L 56(A0,D0.L),A0
    MOVE.L  A0,-12(A5)

.LAB_04CA:
    MOVEA.L -12(A5),A0

.LAB_04CB:
    TST.B   (A0)+
    BNE.S   .LAB_04CB

    SUBQ.L  #1,A0
    SUBA.L  -12(A5),A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  LAB_21C1,-(A7)
    JSR     LAB_03A0(PC)

    LEA     12(A7),A7

.LAB_04CC:
    ADDQ.W  #1,D6
    BRA.W   .LAB_04C8

.LAB_04CD:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_21C1,-(A7)
    JSR     LAB_03A9(PC)

    ADDQ.W  #8,A7
    ADDQ.W  #1,D7
    BRA.W   .LAB_04C6

.LAB_04CE:
    MOVE.L  LAB_21C1,-(A7)
    JSR     LAB_039A(PC)

    MOVEQ   #1,D0
    MOVE.L  D0,LAB_1B9F
    PEA     (.desiredMemory).W
    MOVE.L  -22(A5),-(A7)
    PEA     901.W
    PEA     GLOB_STR_DISKIO2_C_16
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

    MOVEQ   #0,D0

.return:
    MOVEM.L -32(A5),D6-D7
    UNLK    A5
    RTS

;!======

LAB_04D0:
    LINK.W  A5,#-48
    MOVEM.L D5-D7/A2-A3,-(A7)

    PEA     GLOB_STR_DF0_NXTDAY_DAT
    JSR     LAB_03AC(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BNE.S   LAB_04D1

    MOVEQ   #-1,D0
    BRA.W   LAB_04E5

LAB_04D1:
    MOVE.L  GLOB_REF_LONG_FILE_SCRATCH,-36(A5)
    MOVE.L  LAB_21BC,-16(A5)
    JSR     LAB_03B6(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #0,D0
    NOT.B   D0
    AND.L   D0,D1
    MOVEQ   #0,D7
    MOVE.B  LAB_222D,D0
    MOVE.B  D1,-37(A5)
    CMP.B   D0,D1
    BNE.W   LAB_04E2

    JSR     LAB_03B6(PC)

    MOVE.W  D0,-40(A5)
    JSR     LAB_03B6(PC)

    MOVE.B  D0,LAB_224D
    JSR     LAB_03B6(PC)

    MOVE.W  D0,LAB_224E
    MOVE.B  #$1,LAB_222E
    CLR.L   -32(A5)
    MOVEQ   #0,D7

LAB_04D2:
    CMP.W   -40(A5),D7
    BGE.W   LAB_04E2

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     52.W
    PEA     948.W
    PEA     GLOB_STR_DISKIO2_C_17
    JSR     JMP_TBL_ALLOCATE_MEMORY_1(PC)

    LEA     16(A7),A7
    MOVEA.L D0,A3
    MOVE.L  A3,D0
    BNE.S   LAB_04D3

    MOVEQ   #-1,D0
    MOVE.L  D0,-32(A5)
    BRA.W   LAB_04E2

LAB_04D3:
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     500.W
    PEA     954.W
    PEA     GLOB_STR_DISKIO2_C_18
    JSR     JMP_TBL_ALLOCATE_MEMORY_1(PC)

    LEA     16(A7),A7
    MOVEA.L D0,A2
    MOVE.L  A2,D0
    BNE.S   LAB_04D4

    MOVEQ   #-1,D0
    MOVE.L  D0,-32(A5)
    PEA     52.W
    MOVE.L  A3,-(A7)
    PEA     958.W
    PEA     GLOB_STR_DISKIO2_C_19
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

    LEA     16(A7),A7
    BRA.W   LAB_04E2

LAB_04D4:
    MOVE.L  A3,-(A7)
    JSR     LAB_053E(PC)

    MOVE.L  A3,(A7)
    JSR     LAB_0345(PC)

    ADDQ.W  #4,A7
    MOVE.L  A3,-20(A5)
    MOVEQ   #0,D6

LAB_04D5:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVEQ   #48,D1
    CMP.L   D1,D0
    BCC.S   LAB_04D6

    MOVEA.L LAB_21BC,A0
    MOVEA.L -20(A5),A1
    MOVE.B  (A0)+,(A1)+
    MOVE.L  A0,LAB_21BC
    SUBQ.L  #1,GLOB_REF_LONG_FILE_SCRATCH
    MOVE.L  A1,-20(A5)
    ADDQ.W  #1,D6
    BRA.S   LAB_04D5

LAB_04D6:
    MOVEQ   #0,D0
    MOVE.B  40(A3),D0
    ANDI.W  #$ff7f,D0
    MOVE.B  D0,40(A3)
    JSR     LAB_03B2(PC)

    MOVEA.W #$ffff,A0
    MOVE.L  D0,-12(A5)
    CMP.L   A0,D0
    BNE.S   LAB_04D7

    MOVE.L  A0,-32(A5)
    BRA.W   LAB_04E2

LAB_04D7:
    MOVEA.L D0,A0
    MOVEA.L A2,A1

LAB_04D8:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_04D8

    MOVE.W  #(-1),-28(A5)
    MOVEQ   #0,D5

LAB_04D9:
    MOVEQ   #49,D0
    CMP.W   D0,D5
    BGE.W   LAB_04DF

    MOVE.B  #$1,7(A2,D5.W)
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    CLR.L   56(A2,D0.L)
    CMPI.W  #4,LAB_1C41
    BLE.S   LAB_04DC

    MOVE.W  -28(A5),D0
    TST.W   D0
    BPL.S   LAB_04DA

    JSR     LAB_03B6(PC)

    MOVE.W  D0,-28(A5)

LAB_04DA:
    CMP.W   D0,D5
    BGE.S   LAB_04DB

    BRA.W   LAB_04DE

LAB_04DB:
    MOVE.W  #(-1),-28(A5)

LAB_04DC:
    JSR     LAB_03B6(PC)

    MOVE.B  D0,7(A2,D5.W)
    JSR     LAB_03B6(PC)

    MOVE.L  D5,D1
    ADDI.W  #$fc,D1
    MOVE.B  D0,0(A2,D1.W)
    JSR     LAB_03B6(PC)

    MOVE.L  D5,D1
    ADDI.W  #$12d,D1
    MOVE.B  D0,0(A2,D1.W)
    JSR     LAB_03B6(PC)

    MOVE.L  D5,D1
    ADDI.W  #$15e,D1
    MOVE.B  D0,0(A2,D1.W)
    JSR     LAB_03B2(PC)

    MOVEA.W #$ffff,A0
    MOVE.L  D0,-12(A5)
    CMP.L   A0,D0
    BNE.S   LAB_04DD

    MOVE.L  A0,-32(A5)
    BRA.S   LAB_04DF

LAB_04DD:
    MOVEQ   #0,D1
    MOVE.B  27(A3),D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_053C(PC)

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVE.L  56(A2,D0.L),(A7)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  D0,36(A7)
    JSR     LAB_0385(PC)

    LEA     12(A7),A7
    MOVE.L  24(A7),D1
    MOVE.L  D0,56(A2,D1.L)
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    TST.L   56(A2,D0.L)
    BEQ.S   LAB_04DE

    MOVEQ   #0,D0
    MOVE.B  40(A3),D0
    ORI.W   #$80,D0
    MOVE.B  D0,40(A3)

LAB_04DE:
    ADDQ.W  #1,D5
    BRA.W   LAB_04D9

LAB_04DF:
    CMPI.W  #4,LAB_1C41
    BLE.S   LAB_04E0

    MOVEQ   #-1,D0
    CMP.W   -28(A5),D0
    BNE.S   LAB_04E0

    JSR     LAB_03B6(PC)

    MOVE.W  D0,-28(A5)

LAB_04E0:
    MOVEQ   #-1,D0
    CMP.L   -32(A5),D0
    BNE.S   LAB_04E1

    PEA     52.W
    MOVE.L  A3,-(A7)
    PEA     1027.W
    PEA     GLOB_STR_DISKIO2_C_20
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

    PEA     500.W
    MOVE.L  A2,-(A7)
    PEA     1028.W
    PEA     GLOB_STR_DISKIO2_C_21
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

    LEA     32(A7),A7
    BRA.S   LAB_04E2

LAB_04E1:
    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2235,A0
    ADDA.L  D0,A0
    MOVE.L  A3,(A0)
    LEA     LAB_2237,A0
    ADDA.L  D0,A0
    MOVE.L  A2,(A0)
    ADDQ.W  #1,D7
    BRA.W   LAB_04D2

LAB_04E2:
    MOVE.B  -37(A5),LAB_2239
    MOVE.L  D7,D0
    MOVE.W  D0,LAB_222F
    MOVE.L  -36(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -16(A5),-(A7)
    PEA     1041.W
    PEA     GLOB_STR_DISKIO2_C_22
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

    MOVEQ   #0,D0
    MOVE.B  -37(A5),D0
    MOVE.L  D0,(A7)
    JSR     LAB_031A(PC)

    LEA     16(A7),A7
    ADDQ.L  #1,D0
    BEQ.S   LAB_04E3

    MOVE.B  #$1,LAB_1B90
    MOVE.B  -37(A5),LAB_1B92
    BRA.S   LAB_04E4

LAB_04E3:
    MOVEQ   #0,D0
    MOVE.B  D0,LAB_1B90
    MOVE.B  D0,LAB_1B92

LAB_04E4:
    MOVE.L  -32(A5),D0

LAB_04E5:
    MOVEM.L (A7)+,D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_04E6:
    LINK.W  A5,#-12
    MOVE.L  D7,-(A7)
    MOVE.L  #LAB_1C68,-4(A5)
    MOVE.W  LAB_1DDA,D0
    MOVEQ   #1,D1
    CMP.W   D1,D0
    BGE.S   LAB_04E7

    MOVEQ   #-1,D0
    BRA.W   LAB_04EF

LAB_04E7:
    PEA     MODE_NEWFILE.W
    PEA     LAB_1B9C
    JSR     LOAD_FILE_CONTENTS_INTO_MEMORY_MAYBE(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_21BF
    TST.L   D0
    BEQ.S   LAB_04E8

    MOVE.W  LAB_1DDA,D0
    BNE.S   LAB_04E9

LAB_04E8:
    MOVEQ   #-1,D0
    BRA.W   LAB_04EF

LAB_04E9:
    MOVEA.L -4(A5),A0

LAB_04EA:
    TST.B   (A0)+
    BNE.S   LAB_04EA

    SUBQ.L  #1,A0
    SUBA.L  -4(A5),A0
    MOVE.L  A0,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  LAB_21BF,-(A7)
    JSR     LAB_03A0(PC)

    PEA     2.W
    PEA     LAB_1C69
    MOVE.L  LAB_21BF,-(A7)
    JSR     LAB_03A0(PC)

    LEA     24(A7),A7
    MOVEQ   #0,D7

LAB_04EB:
    MOVE.W  LAB_1DDA,D0
    CMP.W   D0,D7
    BCC.W   LAB_04EE

    MOVEQ   #0,D0
    MOVE.W  D7,D0
    ASL.L   #2,D0
    LEA     LAB_224F,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-8(A5)
    MOVEA.L -8(A5),A1
    MOVEA.L (A1),A0

LAB_04EC:
    TST.B   (A0)+
    BNE.S   LAB_04EC

    SUBQ.L  #1,A0
    SUBA.L  (A1),A0
    MOVE.L  A0,-(A7)
    MOVE.L  (A1),-(A7)
    MOVE.L  LAB_21BF,-(A7)
    JSR     LAB_03A0(PC)

    PEA     1.W
    PEA     LAB_1C6A
    MOVE.L  LAB_21BF,-(A7)
    JSR     LAB_03A0(PC)

    PEA     1.W
    PEA     LAB_1C6B
    MOVE.L  LAB_21BF,-(A7)
    JSR     LAB_03A0(PC)

    MOVEA.L -8(A5),A1
    MOVEA.L 4(A1),A0

LAB_04ED:
    TST.B   (A0)+
    BNE.S   LAB_04ED

    SUBQ.L  #1,A0
    SUBA.L  4(A1),A0
    MOVE.L  A0,(A7)
    MOVE.L  4(A1),-(A7)
    MOVE.L  LAB_21BF,-(A7)
    JSR     LAB_03A0(PC)

    PEA     1.W
    PEA     LAB_1C6C
    MOVE.L  LAB_21BF,-(A7)
    JSR     LAB_03A0(PC)

    PEA     2.W
    PEA     LAB_1C6D
    MOVE.L  LAB_21BF,-(A7)
    JSR     LAB_03A0(PC)

    LEA     68(A7),A7
    ADDQ.W  #1,D7
    BRA.W   LAB_04EB

LAB_04EE:
    MOVE.L  LAB_21BF,-(A7)
    JSR     LAB_039A(PC)

LAB_04EF:
    MOVE.L  -16(A5),D7
    UNLK    A5
    RTS

;!======

LAB_04F0:
    JSR     LAB_054A(PC)

    PEA     LAB_1B9C
    JSR     JMP_TBL_PARSE_INI(PC)

    ADDQ.W  #4,A7
    RTS

;!======

LAB_04F1:
    LINK.W  A5,#-8
    PEA     MODE_NEWFILE.W
    PEA     LAB_1B9D
    JSR     LOAD_FILE_CONTENTS_INTO_MEMORY_MAYBE(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_21C0
    TST.L   D0
    BNE.S   LAB_04F2

    MOVEQ   #-1,D0
    BRA.W   LAB_04F9

LAB_04F2:
    CLR.B   -5(A5)
    MOVEQ   #0,D0
    MOVE.B  LAB_2230,D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_21C0,-(A7)
    JSR     LAB_03A9(PC)

    ADDQ.W  #8,A7
    TST.L   LAB_1DDB
    BNE.S   LAB_04F3

    LEA     -5(A5),A0
    BRA.S   LAB_04F4

LAB_04F3:
    MOVEA.L LAB_1DDB,A0

LAB_04F4:
    MOVEA.L A0,A1

LAB_04F5:
    TST.B   (A1)+
    BNE.S   LAB_04F5

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  LAB_21C0,-(A7)
    MOVE.L  A0,-4(A5)
    JSR     LAB_03A0(PC)

    LEA     12(A7),A7
    TST.L   LAB_1DDC
    BNE.S   LAB_04F6

    LEA     -5(A5),A0
    BRA.S   LAB_04F7

LAB_04F6:
    MOVEA.L LAB_1DDC,A0

LAB_04F7:
    MOVEA.L A0,A1

LAB_04F8:
    TST.B   (A1)+
    BNE.S   LAB_04F8

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  LAB_21C0,-(A7)
    MOVE.L  A0,-4(A5)
    JSR     LAB_03A0(PC)

    MOVE.L  LAB_21C0,(A7)
    JSR     LAB_039A(PC)

    MOVEQ   #0,D0

LAB_04F9:
    UNLK    A5
    RTS

;!======

LAB_04FA:
    LINK.W  A5,#-20
    MOVEM.L D6-D7/A2,-(A7)
    SUBA.L  A0,A0
    PEA     LAB_1B9D
    MOVE.L  A0,-8(A5)
    MOVE.L  A0,-4(A5)
    JSR     LAB_03AC(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BNE.S   LAB_04FB

    MOVEQ   #-1,D0
    BRA.W   LAB_04FE

LAB_04FB:
    MOVE.L  GLOB_REF_LONG_FILE_SCRATCH,D6
    MOVE.L  LAB_21BC,-12(A5)
    JSR     LAB_03B6(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #0,D0
    NOT.B   D0
    AND.L   D0,D1
    MOVE.L  D1,D7
    MOVE.B  LAB_2230,D0
    CMP.B   D0,D7
    BNE.S   LAB_04FC

    JSR     LAB_03B2(PC)

    MOVE.L  D0,-4(A5)
    JSR     LAB_03B2(PC)

    MOVE.L  D0,-8(A5)

LAB_04FC:
    MOVEA.W #$ffff,A0
    MOVEA.L -4(A5),A1
    CMPA.L  A1,A0
    BEQ.S   LAB_04FD

    MOVEA.L -8(A5),A2
    CMPA.L  A0,A2
    BEQ.S   LAB_04FD

    MOVE.L  LAB_1DDB,-(A7)
    MOVE.L  A1,-(A7)
    JSR     LAB_0385(PC)

    MOVE.L  D0,LAB_1DDB
    MOVE.L  LAB_1DDC,(A7)
    MOVE.L  -8(A5),-(A7)
    JSR     LAB_0385(PC)

    LEA     12(A7),A7
    MOVE.L  D0,LAB_1DDC

LAB_04FD:
    MOVE.L  D6,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -12(A5),-(A7)
    PEA     1191.W
    PEA     GLOB_STR_DISKIO2_C_23
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

    MOVEQ   #0,D0

LAB_04FE:
    MOVEM.L -32(A5),D6-D7/A2
    UNLK    A5
    RTS

;!======

LAB_04FF:
    LINK.W  A5,#-160
    MOVEM.L D2-D3/D5-D7,-(A7)
    MOVE.B  11(A5),D7
    PEA     1.W
    PEA     4.W
    JSR     LAB_053D(PC)

    ADDQ.W  #8,A7
    MOVEQ   #1,D5
    CLR.B   -17(A5)
    TST.B   D7
    BEQ.S   LAB_0500

    MOVE.B  #$c2,LAB_21C7
    BRA.S   LAB_0501

LAB_0500:
    MOVE.B  #$b7,LAB_21C7

LAB_0501:
    JSR     LAB_0544(PC)

LAB_0502:
    CMPI.B  #$1f,-17(A5)
    BCC.S   LAB_0503

    JSR     LAB_0549(PC)

    MOVE.B  D0,-18(A5)
    TST.B   D0
    BEQ.S   LAB_0503

    MOVE.B  -17(A5),D1
    ADDQ.B  #1,-17(A5)
    MOVEQ   #0,D2
    MOVE.B  D1,D2
    LEA     LAB_21C2,A0
    ADDA.W  D2,A0
    MOVE.B  D0,(A0)
    MOVE.B  LAB_21C7,D1
    EOR.B   D0,D1
    MOVE.B  D1,LAB_21C7
    JSR     LAB_0544(PC)

    BRA.S   LAB_0502

LAB_0503:
    MOVEQ   #0,D0
    MOVE.B  -17(A5),D0
    LEA     LAB_21C2,A0
    ADDA.W  D0,A0
    CLR.B   (A0)
    MOVEQ   #13,D1
    CMP.B   D1,D0
    BNE.S   LAB_0504

    PEA     LAB_1B9A
    PEA     LAB_21C3
    JSR     LAB_0542(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   LAB_0504

    MOVEQ   #0,D5
    TST.W   LAB_2252
    BEQ.S   LAB_0504

    PEA     GLOB_STR_SPECIAL_NGAD
    PEA     240.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLAY_TEXT_AT_POSITION(PC)

    LEA     16(A7),A7

LAB_0504:
    LEA     LAB_21C2,A0
    LEA     -58(A5),A1

LAB_0505:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_0505

    PEA     4.W
    PEA     GLOB_STR_RAM
    PEA     -58(A5)
    JSR     LAB_0470(PC)

    LEA     12(A7),A7
    TST.W   LAB_2252
    BEQ.S   LAB_0506

    PEA     GLOB_STR_FILENAME
    PEA     180.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLAY_TEXT_AT_POSITION(PC)

    PEA     LAB_21C2
    PEA     180.W
    PEA     205.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLAY_TEXT_AT_POSITION(PC)

    LEA     32(A7),A7

LAB_0506:
    PEA     4.W
    PEA     LAB_21C2
    PEA     -68(A5)
    JSR     LAB_0470(PC)

    LEA     12(A7),A7
    MOVEQ   #0,D0
    MOVE.B  D0,-64(A5)
    TST.B   D7
    BEQ.W   LAB_050D

    MOVE.B  D0,-17(A5)
    JSR     LAB_0544(PC)

LAB_0507:
    CMPI.B  #$8,-17(A5)
    BCC.S   LAB_0508

    JSR     LAB_0549(PC)

    MOVE.B  D0,-18(A5)
    TST.B   D0
    BEQ.S   LAB_0508

    MOVE.B  -17(A5),D1
    ADDQ.B  #1,-17(A5)
    MOVEQ   #0,D2
    MOVE.B  D1,D2
    LEA     LAB_21C4,A0
    ADDA.W  D2,A0
    MOVE.B  D0,(A0)
    MOVE.B  LAB_21C7,D1
    EOR.B   D0,D1
    MOVE.B  D1,LAB_21C7
    JSR     LAB_0544(PC)

    BRA.S   LAB_0507

LAB_0508:
    MOVEQ   #0,D0
    MOVE.B  -17(A5),D0
    LEA     LAB_21C4,A0
    ADDA.W  D0,A0
    CLR.B   (A0)
    LEA     -68(A5),A0
    MOVE.L  A0,D1
    MOVEQ   #-2,D2
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOLock(A6)

    MOVE.L  D0,-76(A5)
    TST.L   D0
    BEQ.S   LAB_050B

    MOVE.L  #(MEMF_CLEAR),-(A7)
    PEA     Struct_InfoData_Size.W
    PEA     1312.W
    PEA     GLOB_STR_DISKIO2_C_24
    JSR     JMP_TBL_ALLOCATE_MEMORY_1(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-72(A5)
    TST.L   D0
    BEQ.S   LAB_050A

    MOVE.L  D0,D2
    MOVE.L  -76(A5),D1
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOInfo(A6)

    TST.L   D0
    BEQ.S   LAB_0509

    MOVE.L  #$6de,D0
    MOVEA.L D2,A0
    SUB.L   16(A0),D0
    ASL.L   #8,D0
    ADD.L   D0,D0
    SUBI.L  #$1000,D0
    MOVE.L  D0,-12(A5)

LAB_0509:
    PEA     Struct_InfoData_Size.W
    MOVE.L  D2,-(A7)
    PEA     1318.W
    PEA     GLOB_STR_DISKIO2_C_25
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

    LEA     16(A7),A7

LAB_050A:
    MOVE.L  -76(A5),D1
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOUnLock(A6)

LAB_050B:
    PEA     LAB_21C4
    JSR     LAB_054B(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,-16(A5)
    CMP.L   -12(A5),D0
    BLE.S   LAB_050D

    LEA     LAB_21C2,A0
    LEA     BRUSH_SnapshotHeader,A1   ; refresh saved UI header with on-disk metadata

LAB_050C:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_050C

    PEA     2.W
    JSR     LAB_0546(PC)

    MOVEQ   #0,D0
    MOVE.L  D0,LAB_21BD
    MOVE.L  D0,(A7)
    PEA     4.W
    JSR     LAB_053D(PC)

    MOVEQ   #-2,D0
    BRA.W   LAB_0519

LAB_050D:
    JSR     LAB_0544(PC)

    JSR     LAB_0549(PC)

    MOVE.B  D0,LAB_2253
    MOVE.B  LAB_21C7,D1
    CMP.B   D1,D0
    BNE.W   LAB_0518

    MOVEQ   #1,D0
    CMP.L   D0,D5
    BNE.W   LAB_0518

    PEA     (MODE_NEWFILE).W
    PEA     -58(A5)
    JSR     JMP_TBL_OPEN_FILE_WITH_ACCESS_MODE_1(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_21C5
    TST.L   D0
    BNE.S   LAB_050E

    PEA     5.W
    JSR     LAB_03DE(PC)

    CLR.L   (A7)
    PEA     4.W
    JSR     LAB_053D(PC)

    MOVEQ   #-1,D0
    BRA.W   LAB_0519

LAB_050E:
    MOVE.W  LAB_1F45,LAB_21CB
    MOVE.W  #$100,LAB_1F45
    CLR.L   LAB_21CC
    CLR.B   LAB_21C8
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     4352.W
    PEA     1389.W
    PEA     GLOB_STR_DISKIO2_C_26
    JSR     JMP_TBL_ALLOCATE_MEMORY_1(PC)

    LEA     16(A7),A7
    MOVE.L  D0,LAB_21C9
    MOVE.W  LAB_21CB,LAB_1F45
    CLR.W   LAB_21CA

LAB_050F:
    JSR     LAB_0544(PC)

    JSR     LAB_0549(PC)

    MOVE.B  D0,-18(A5)
    MOVEQ   #85,D0
    CMP.B   -18(A5),D0
    BNE.S   LAB_050F

    JSR     LAB_0544(PC)

    JSR     LAB_0549(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.B  D0,-18(A5)
    MOVEQ   #85,D0
    ADD.L   D0,D0
    CMP.L   D0,D1
    BNE.S   LAB_050F

    JSR     LAB_0544(PC)

    JSR     LAB_0549(PC)

    MOVE.B  D0,-18(A5)
    MOVEQ   #72,D1
    CMP.B   D1,D0
    BEQ.S   LAB_0510

    MOVEQ   #61,D1
    CMP.B   D1,D0
    BNE.S   LAB_0513

LAB_0510:
    MOVEQ   #61,D1
    CMP.B   D1,D0
    BNE.S   LAB_0511

    MOVE.B  #$c2,LAB_21C7
    BRA.S   LAB_0512

LAB_0511:
    MOVE.B  #$b7,LAB_21C7

LAB_0512:
    CMP.B   D1,D0
    SEQ     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,-(A7)
    BSR.W   LAB_051A

    ADDQ.W  #4,A7
    MOVE.L  D0,D6
    TST.L   D6
    BEQ.S   LAB_050F

    BRA.S   LAB_0514

LAB_0513:
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #68,D0
    NOT.B   D0
    CMP.L   D0,D1
    BNE.W   LAB_050F

    JSR     LAB_0544(PC)

    JSR     LAB_0549(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.B  D0,-18(A5)
    MOVEQ   #68,D0
    NOT.B   D0
    CMP.L   D0,D1
    BNE.W   LAB_050F

    JSR     LAB_0544(PC)

    JSR     LAB_0549(PC)

    MOVE.B  D0,-18(A5)
    BNE.W   LAB_050F

    JSR     LAB_0544(PC)

    JSR     LAB_0549(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.B  D0,-18(A5)
    MOVEQ   #0,D0
    NOT.B   D0
    CMP.L   D0,D1
    BNE.W   LAB_050F

    MOVEQ   #4,D6

LAB_0514:
    MOVE.W  LAB_1F45,LAB_21CB
    MOVE.W  #$100,LAB_1F45
    MOVE.L  LAB_21C5,D1
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOClose(A6)

    PEA     4352.W
    MOVE.L  LAB_21C9,-(A7)
    PEA     1499.W
    PEA     GLOB_STR_DISKIO2_C_27
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

    LEA     16(A7),A7
    TST.W   LAB_2252
    BEQ.S   LAB_0515

    PEA     LAB_1C76
    PEA     210.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLAY_TEXT_AT_POSITION(PC)

    PEA     LAB_1C77
    PEA     240.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLAY_TEXT_AT_POSITION(PC)

    LEA     32(A7),A7

LAB_0515:
    MOVEQ   #-1,D0
    CMP.L   D0,D6

    BNE.W   LAB_0516

    LEA     LAB_21C2,A0
    MOVE.L  A0,D1
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVODeleteFile(A6)

    JSR     LAB_03CB(PC)

    LEA     GLOB_STR_COPY_NIL,A0
    LEA     -156(A5),A1
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    PEA     -58(A5)
    PEA     -156(A5)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    PEA     LAB_1C79
    PEA     -156(A5)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    PEA     LAB_21C2
    PEA     -156(A5)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    LEA     -156(A5),A0
    MOVE.L  A0,D1
    MOVEQ   #0,D2
    MOVE.L  D2,D3
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOExecute(A6)

    LEA     -58(A5),A0
    MOVE.L  A0,D1
    JSR     _LVODeleteFile(A6)

    JSR     LAB_03CD(PC)

    LEA     24(A7),A7
    TST.W   LAB_2252
    BEQ.S   LAB_0517

    PEA     GLOB_STR_STORED
    PEA     180.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLAY_TEXT_AT_POSITION(PC)

    LEA     16(A7),A7
    BRA.S   LAB_0517

LAB_0516:
    MOVE.L  D6,-(A7)
    JSR     LAB_03DE(PC)

    ADDQ.W  #4,A7
    LEA     -58(A5),A0
    MOVE.L  A0,D1
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVODeleteFile(A6)

LAB_0517:
    MOVE.W  LAB_21CB,LAB_1F45

LAB_0518:
    MOVEQ   #0,D0
    MOVE.L  D0,LAB_21BD
    MOVE.L  D0,-(A7)
    PEA     4.W
    JSR     LAB_053D(PC)

    ADDQ.W  #8,A7
    TST.W   LAB_2252
    BEQ.S   LAB_0519

    PEA     LAB_1C7C
    JSR     LAB_03C0(PC)

    PEA     LAB_1C7D
    MOVE.L  D0,28(A7)
    JSR     LAB_03C4(PC)

    MOVE.L  D0,(A7)
    MOVE.L  28(A7),-(A7)
    PEA     GLOB_STR_DISK_0_IS_FULL_WITH_ERRORS_FORMATTED
    PEA     -58(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    PEA     -58(A5)
    PEA     90.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLAY_TEXT_AT_POSITION(PC)

    LEA     36(A7),A7

LAB_0519:
    MOVEM.L -180(A5),D2-D3/D5-D7
    UNLK    A5
    RTS

;!======

LAB_051A:
    LINK.W  A5,#-1040
    MOVEM.L D2-D7,-(A7)

    MOVE.B  11(A5),D7
    MOVEQ   #-1,D0
    MOVE.L  D0,-10(A5)
    CLR.L   -14(A5)
    CLR.B   -16(A5)
    LEA     LAB_1C7E,A0
    LEA     -1040(A5),A1
    MOVE.W  #$ff,D0

LAB_051B:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,LAB_051B

    JSR     LAB_0544(PC)

    JSR     LAB_0549(PC)

    MOVE.L  D0,D4
    MOVE.W  LAB_2285,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2285
    MOVE.B  LAB_21C8,D0
    CMP.B   D0,D4
    BNE.W   LAB_0529

    MOVE.B  LAB_21C7,D1
    EOR.B   D0,D1
    MOVE.B  D1,LAB_21C7
    JSR     LAB_0544(PC)

    JSR     LAB_0549(PC)

    MOVE.B  D0,LAB_21C6
    TST.B   D0
    BEQ.W   LAB_0524

    MOVE.B  LAB_21C7,D1
    EOR.B   D0,D1
    MOVE.B  D1,LAB_21C7
    MOVE.W  LAB_21CA,D5
    MOVEQ   #0,D6

LAB_051C:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  LAB_21C6,D1
    CMP.L   D1,D0
    BEQ.S   LAB_051D

    JSR     LAB_0544(PC)

    JSR     LAB_0549(PC)

    MOVE.L  D0,D4
    MOVE.B  LAB_21C7,D0
    EOR.B   D4,D0
    MOVE.B  D0,LAB_21C7
    MOVEQ   #0,D0
    MOVE.B  D4,D0
    MOVE.L  -10(A5),D1
    EOR.L   D1,D0
    MOVEQ   #0,D2
    NOT.B   D2
    AND.L   D2,D0
    ASL.L   #2,D0
    LEA     -1040(A5),A0
    ADDA.L  D0,A0
    LSR.L   #8,D1
    MOVE.L  (A0),D0
    EOR.L   D1,D0
    MOVE.L  D5,D1
    ADDQ.W  #1,D5
    MOVEA.L LAB_21C9,A0
    ADDA.W  D1,A0
    MOVE.B  D4,(A0)
    MOVE.L  D0,-10(A5)
    ADDQ.W  #1,D6
    BRA.S   LAB_051C

LAB_051D:
    TST.B   D7
    BEQ.S   LAB_0520

    CLR.L   -14(A5)
    MOVEQ   #0,D6

LAB_051E:
    MOVEQ   #4,D0
    CMP.W   D0,D6
    BGE.S   LAB_051F

    JSR     LAB_0544(PC)

    JSR     LAB_0549(PC)

    MOVE.B  LAB_21C7,D1
    EOR.B   D0,D1
    MOVE.B  D1,LAB_21C7
    MOVE.L  -14(A5),D1
    ASL.L   #8,D1
    MOVEQ   #0,D2
    MOVE.B  D0,D2
    MOVEQ   #0,D3
    NOT.B   D3
    AND.L   D3,D2
    OR.L    D2,D1
    MOVE.B  D0,-15(A5)
    MOVE.L  D1,-14(A5)
    ADDQ.W  #1,D6
    BRA.S   LAB_051E

LAB_051F:
    MOVE.L  -10(A5),D0
    CMP.L   -14(A5),D0
    BEQ.S   LAB_0520

    MOVEQ   #1,D0
    MOVE.B  D0,-16(A5)

LAB_0520:
    TST.B   -16(A5)
    BNE.S   LAB_0523

    JSR     LAB_0544(PC)

    JSR     LAB_0549(PC)

    MOVE.B  D0,LAB_2253
    MOVE.B  LAB_21C7,D1
    CMP.B   D1,D0
    BNE.W   LAB_0528

    MOVE.W  D5,LAB_21CA
    CMPI.W  #$1000,D5
    BLT.S   LAB_0522

    MOVE.L  D5,D0
    MOVE.W  D0,LAB_21CA
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_21C9,-(A7)
    JSR     LAB_03C8(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.S   LAB_0521

    MOVEQ   #2,D0
    BRA.W   LAB_052C

LAB_0521:
    CLR.W   LAB_21CA

LAB_0522:
    MOVE.B  LAB_21C8,D0
    MOVE.L  D0,D1
    ADDQ.B  #1,D1
    MOVE.B  D1,LAB_21C8
    MOVEQ   #0,D0
    MOVE.B  D1,D0
    MOVEQ   #0,D1
    NOT.B   D1
    AND.L   D1,D0
    MOVE.B  D0,LAB_21C8
    MOVEQ   #0,D0
    MOVE.L  D0,LAB_21CC
    BRA.S   LAB_0528

LAB_0523:
    CLR.B   -16(A5)
    ADDQ.L  #1,LAB_21CC
    BRA.S   LAB_0528

LAB_0524:
    JSR     LAB_0544(PC)

    JSR     LAB_0549(PC)

    MOVE.B  D0,LAB_2253
    MOVE.B  LAB_21C7,D1
    CMP.B   D1,D0
    BNE.S   LAB_0527

    MOVE.W  LAB_21CA,D0
    BLE.S   LAB_0526

    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_21C9,-(A7)
    JSR     LAB_03C8(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.S   LAB_0525

    MOVEQ   #3,D0
    BRA.S   LAB_052C

LAB_0525:
    CLR.W   LAB_21CA

LAB_0526:
    MOVEQ   #-1,D0
    BRA.S   LAB_052C

LAB_0527:
    MOVE.B  #$1,-16(A5)
    ADDQ.L  #1,LAB_21CC

LAB_0528:
    MOVEQ   #0,D0
    BRA.S   LAB_052C

LAB_0529:
    MOVEQ   #0,D0
    MOVE.B  D4,D0
    ADDQ.L  #1,D0
    MOVEQ   #0,D1
    NOT.B   D1
    AND.L   D1,D0
    MOVEQ   #0,D1
    MOVE.B  LAB_21C8,D1
    CMP.L   D1,D0
    BNE.S   LAB_052A

    MOVEQ   #0,D0
    BRA.S   LAB_052C

LAB_052A:
    LEA     LAB_21C2,A0
    LEA     BRUSH_SnapshotHeader,A1   ; keep error dialog text in sync with disk state

LAB_052B:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_052B

    PEA     1.W
    JSR     LAB_0546(PC)

    MOVEQ   #1,D0

LAB_052C:
    MOVEM.L -1064(A5),D2-D7
    UNLK    A5
    RTS

;!======

LAB_052D:
    LINK.W  A5,#-12
    MOVEM.L D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.W  22(A5),D7
    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L 16(A5),A0
    MOVEA.L 56(A0,D0.L),A0
    MOVE.L  A0,-12(A5)
    MOVE.L  A2,D0
    BEQ.W   LAB_0534

    TST.L   16(A5)
    BEQ.W   LAB_0534

    TST.W   D7
    BLE.W   LAB_0534

    MOVEQ   #49,D0
    CMP.W   D0,D7
    BGE.W   LAB_0534

    MOVE.L  A0,D0
    BEQ.W   LAB_0534

    TST.B   (A0)
    BEQ.W   LAB_0534

    MOVEA.L 16(A5),A0
    BTST    #1,7(A0,D7.W)
    BNE.S   LAB_052E

    BTST    #4,27(A2)
    BEQ.S   LAB_0534

LAB_052E:
    MOVEA.L -12(A5),A0
    MOVEA.L A3,A1

LAB_052F:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_052F

    PEA     34.W
    MOVE.L  A3,-(A7)
    JSR     LAB_05C1(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    BEQ.S   LAB_0530

    ADDQ.L  #1,-4(A5)
    PEA     34.W
    MOVE.L  -4(A5),-(A7)
    JSR     LAB_05C1(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)

LAB_0530:
    TST.L   D0
    BEQ.S   LAB_0533

    PEA     LAB_2018
    MOVE.L  D0,-(A7)
    JSR     LAB_0547(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    BEQ.S   LAB_0531

    MOVE.L  D0,-4(A5)

LAB_0531:
    MOVEA.L -4(A5),A0
    TST.B   (A0)
    BEQ.S   LAB_0532

    MOVEQ   #32,D0
    CMP.B   (A0),D0
    BEQ.S   LAB_0532

    ADDQ.L  #1,-4(A5)
    BRA.S   LAB_0531

LAB_0532:
    MOVEA.L -4(A5),A0
    CLR.B   (A0)

LAB_0533:
    MOVEA.L A3,A0
    MOVE.L  A0,-12(A5)

LAB_0534:
    MOVE.L  -12(A5),D0
    MOVEM.L (A7)+,D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_0535:
    TST.W   LAB_1C7F
    BNE.S   LAB_0538

    MOVE.W  #1,LAB_1C7F
    MOVE.W  LAB_2231,D0
    CMPI.W  #$c9,D0
    BCC.S   LAB_0537

    BSR.W   LAB_0471

    BSR.W   LAB_04C1

    BSR.W   LAB_04F1

    TST.B   LAB_1B8F
    BEQ.S   LAB_0536

    MOVEQ   #0,D0
    MOVE.B  LAB_1B91,D0
    MOVE.L  D0,-(A7)
    JSR     LAB_02E2(PC)

    ADDQ.W  #4,A7

LAB_0536:
    TST.B   LAB_1B90
    BEQ.S   LAB_0537

    MOVEQ   #0,D0
    MOVE.B  LAB_1B92,D0
    MOVE.L  D0,-(A7)
    JSR     LAB_02E2(PC)

    ADDQ.W  #4,A7

LAB_0537:
    CLR.W   LAB_1C7F

LAB_0538:
    RTS

;!======

LAB_0539:
    BSR.W   LAB_0497

    BSR.W   LAB_04D0

    BSR.W   LAB_04FA

    JSR     LAB_053B(PC)

    RTS

;!======

LAB_053A:
    JMP     LAB_0AB8

LAB_053B:
    JMP     LAB_1070

LAB_053C:
    JMP     LAB_0C31

LAB_053D:
    JMP     LAB_08DA

LAB_053E:
    JMP     LAB_0C1C

LAB_053F:
    JMP     GCOMMAND_LoadPPVTemplate

LAB_0540:
    JMP     LAB_0F4D

LAB_0541:
    JMP     GCOMMAND_LoadCommandFile

LAB_0542:
    JMP     LAB_00BE

LAB_0543:
    JMP     LAB_1378

LAB_0544:
    JMP     LAB_096D

LAB_0545:
    JMP     LAB_00B1

LAB_0546:
    JMP     LAB_0B26

LAB_0547:
    JMP     LAB_1984

LAB_0548:
    JMP     GCOMMAND_LoadMplexFile

LAB_0549:
    JMP     LAB_14AF

LAB_054A:
    JMP     LAB_0B34

LAB_054B:
    JMP     LAB_1A20

;!======

LAB_054C:
    MOVEM.L D5-D7/A2-A3,-(A7)

    MOVEA.L 24(A7),A3
    MOVEA.L 28(A7),A2
    MOVE.L  32(A7),D7

    BTST    #5,27(A3)
    BEQ.S   LAB_054D

    MOVEQ   #48,D5
    BRA.S   LAB_054E

LAB_054D:
    MOVEQ   #7,D5

LAB_054E:
    MOVE.L  D7,D6
    SUB.L   D5,D6
    MOVEQ   #1,D0
    CMP.L   D0,D6
    BGE.S   LAB_054F

    MOVE.L  D0,D6

LAB_054F:
    MOVE.L  D7,D0
    ASL.L   #2,D0
    TST.L   56(A2,D0.L)
    BNE.S   LAB_0551

    SUBQ.L  #1,D7
    CMP.L   D6,D7
    BGE.S   LAB_0550

    MOVEQ   #0,D7
    CLR.W   LAB_2255
    BRA.S   LAB_0551

LAB_0550:
    BTST    #5,27(A3)
    BNE.S   LAB_054F

    MOVE.W  #1,LAB_2255
    BRA.S   LAB_054F

LAB_0551:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D5-D7/A2-A3
    RTS
