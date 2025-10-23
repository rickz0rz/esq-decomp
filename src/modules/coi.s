;!======

LAB_02CE:
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVE.L  A3,D0
    BEQ.S   LAB_02D0

    MOVEA.L 48(A3),A2
    MOVE.L  A3,-(A7)
    BSR.W   LAB_02D5

    MOVE.L  A3,(A7)
    BSR.W   LAB_02D1

    ADDQ.W  #4,A7
    MOVE.L  A2,D0
    BEQ.S   LAB_02CF

    PEA     42.W
    MOVE.L  A2,-(A7)
    PEA     815.W
    PEA     GLOB_STR_COI_C_3
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

    LEA     16(A7),A7

LAB_02CF:
    CLR.L   48(A3)

LAB_02D0:
    MOVEM.L (A7)+,A2-A3
    RTS

;!======

LAB_02D1:
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVE.L  A3,D0
    BEQ.S   LAB_02D2

    MOVEA.L 48(A3),A0
    BRA.S   LAB_02D3

LAB_02D2:
    SUBA.L  A0,A0

LAB_02D3:
    MOVEA.L A0,A2
    MOVE.L  A2,D0
    BEQ.S   LAB_02D4

    MOVEQ   #0,D0
    MOVE.B  D0,(A2)
    MOVE.B  D0,1(A2)
    MOVE.B  D0,2(A2)
    MOVE.B  D0,3(A2)
    MOVE.L  4(A2),-(A7)
    CLR.L   -(A7)
    JSR     LAB_0385(PC)

    MOVE.L  D0,4(A2)
    MOVE.L  8(A2),(A7)
    CLR.L   -(A7)
    JSR     LAB_0385(PC)

    MOVE.L  D0,8(A2)
    MOVE.L  12(A2),(A7)
    CLR.L   -(A7)
    JSR     LAB_0385(PC)

    MOVE.L  D0,12(A2)
    MOVE.L  16(A2),(A7)
    CLR.L   -(A7)
    JSR     LAB_0385(PC)

    MOVE.L  D0,16(A2)
    MOVE.L  20(A2),(A7)
    CLR.L   -(A7)
    JSR     LAB_0385(PC)

    MOVE.L  D0,20(A2)
    MOVE.L  24(A2),(A7)
    CLR.L   -(A7)
    JSR     LAB_0385(PC)

    MOVE.L  D0,24(A2)
    MOVE.L  28(A2),(A7)
    CLR.L   -(A7)
    JSR     LAB_0385(PC)

    LEA     32(A7),A7
    MOVE.L  D0,28(A2)
    CLR.L   32(A2)

LAB_02D4:
    MOVEM.L (A7)+,A2-A3
    RTS

;!======

LAB_02D5:
    LINK.W  A5,#-12
    MOVEM.L D7/A2-A3,-(A7)
    TST.L   8(A5)
    BEQ.S   LAB_02D6

    MOVEA.L 8(A5),A1
    MOVEA.L 48(A1),A0
    BRA.S   LAB_02D7

LAB_02D6:
    SUBA.L  A0,A0

LAB_02D7:
    MOVEA.L A0,A3
    MOVE.L  A3,D0
    BEQ.W   LAB_02DB

    MOVEQ   #0,D7

LAB_02D8:
    CMP.W   36(A3),D7
    BGE.S   LAB_02D9

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L 38(A3),A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A2
    CLR.W   (A2)
    MOVE.L  2(A2),-(A7)
    CLR.L   -(A7)
    JSR     LAB_0385(PC)

    MOVE.L  D0,2(A2)
    MOVE.L  6(A2),(A7)
    CLR.L   -(A7)
    JSR     LAB_0385(PC)

    MOVE.L  D0,6(A2)
    MOVE.L  10(A2),(A7)
    CLR.L   -(A7)
    JSR     LAB_0385(PC)

    MOVE.L  D0,10(A2)
    MOVE.L  14(A2),(A7)
    CLR.L   -(A7)
    JSR     LAB_0385(PC)

    MOVE.L  D0,14(A2)
    MOVE.L  18(A2),(A7)
    CLR.L   -(A7)
    JSR     LAB_0385(PC)

    MOVE.L  D0,18(A2)
    MOVE.L  22(A2),(A7)
    CLR.L   -(A7)
    JSR     LAB_0385(PC)

    LEA     28(A7),A7
    MOVE.L  D0,22(A2)
    CLR.L   26(A2)
    ADDQ.W  #1,D7
    BRA.S   LAB_02D8

LAB_02D9:
    TST.W   36(A3)
    BEQ.S   LAB_02DA

    MOVE.W  36(A3),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     30.W
    MOVE.L  38(A3),-(A7)
    JSR     LAB_0381(PC)

    MOVE.W  36(A3),D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVE.L  D0,(A7)
    MOVE.L  38(A3),-(A7)
    PEA     876.W
    PEA     GLOB_STR_COI_C_4
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

    LEA     24(A7),A7

LAB_02DA:
    CLR.W   36(A3)
    CLR.L   38(A3)

LAB_02DB:
    MOVEM.L (A7)+,D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_02DC:
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 24(A7),A3
    MOVE.L  28(A7),D7
    MOVEQ   #0,D5
    MOVEQ   #0,D6
    MOVE.L  D6,D4

LAB_02DD:
    TST.W   D5
    BNE.S   LAB_02E1

    MOVE.L  D6,D0
    EXT.L   D0
    CMP.L   D7,D0
    BGE.S   LAB_02E1

    MOVEQ   #0,D0
    MOVE.B  0(A3,D6.W),D0
    TST.W   D0
    BEQ.S   LAB_02DE

    SUBI.W  #20,D0
    BEQ.S   LAB_02DF

    BRA.S   LAB_02E0

LAB_02DE:
    MOVEQ   #1,D5
    BRA.S   LAB_02E0

LAB_02DF:
    ADDQ.W  #1,D4
    ADDQ.W  #1,D6

LAB_02E0:
    ADDQ.W  #1,D6
    BRA.S   LAB_02DD

LAB_02E1:
    MOVE.L  D4,D0
    MOVEM.L (A7)+,D4-D7/A3
    RTS

;!======

LAB_02E2:
    LINK.W  A5,#-152
    MOVEM.L D5-D7/A2-A3/A6,-(A7)
    MOVE.B  11(A5),D7
    MOVE.W  LAB_2231,D0
    CMPI.W  #$c8,D0
    BLS.S   LAB_02E3

    MOVEQ   #1,D0
    BRA.W   LAB_0315

LAB_02E3:
    MOVE.B  LAB_222D,D0
    CMP.B   D7,D0
    BNE.S   LAB_02E4

    MOVE.B  LAB_222E,D0
    SUBQ.B  #1,D0
    BNE.S   LAB_02E4

    MOVEQ   #1,D0
    MOVE.B  D0,LAB_1B90
    MOVE.B  D7,LAB_1B92
    MOVE.W  LAB_222F,D1
    MOVE.W  D1,-32(A5)
    BRA.S   LAB_02E6

LAB_02E4:
    MOVE.B  LAB_2230,D0
    CMP.B   D7,D0
    BNE.S   LAB_02E5

    MOVE.B  #$1,LAB_1B8F
    MOVE.B  D7,LAB_1B91
    MOVE.W  LAB_2231,D0
    MOVE.W  D0,-32(A5)
    BRA.S   LAB_02E6

LAB_02E5:
    MOVEQ   #1,D0
    BRA.W   LAB_0315

LAB_02E6:
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEQ   #2,D1
    JSR     JMP_TBL_LAB_1A07_1(PC)

    MOVE.W  D1,-30(A5)
    EXT.L   D1
    MOVE.L  D1,-(A7)
    PEA     GLOB_STR_DF0_OI_PERCENT_2_LX_DAT_1
    PEA     -112(A5)
    JSR     JMP_TBL_PRINTF_1(PC)

    PEA     MODE_NEWFILE.W
    PEA     -112(A5)
    JSR     LOAD_FILE_CONTENTS_INTO_MEMORY_MAYBE(PC)

    LEA     20(A7),A7
    MOVE.L  D0,D5
    TST.L   D5
    BNE.S   LAB_02E7

    MOVEQ   #-3,D0
    BRA.W   LAB_0315

LAB_02E7:
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D0,-(A7)
    PEA     LAB_1B6E
    PEA     -152(A5)
    JSR     JMP_TBL_PRINTF_1(PC)

    LEA     -152(A5),A0
    MOVEA.L A0,A1

LAB_02E8:
    TST.B   (A1)+
    BNE.S   LAB_02E8

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    PEA     1.W
    PEA     LAB_1B5F
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    PEA     2.W
    PEA     LAB_1B6F
    PEA     -152(A5)
    JSR     JMP_TBL_PRINTF_1(PC)

    LEA     -152(A5),A0
    MOVEA.L A0,A1

LAB_02E9:
    TST.B   (A1)+
    BNE.S   LAB_02E9

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    PEA     2.W
    PEA     LAB_1B60
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    LEA     64(A7),A7
    CLR.W   -26(A5)

LAB_02EA:
    MOVE.W  -26(A5),D0
    CMP.W   -32(A5),D0
    BGE.W   LAB_0314

    MOVE.B  LAB_222D,D1
    CMP.B   D1,D7
    BNE.S   LAB_02EB

    MOVE.B  LAB_222E,D1
    SUBQ.B  #1,D1
    BNE.S   LAB_02EB

    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     LAB_2235,A0
    ADDA.L  D1,A0
    MOVEA.L (A0),A3
    BRA.S   LAB_02EC

LAB_02EB:
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     LAB_2233,A0
    ADDA.L  D1,A0
    MOVEA.L (A0),A3

LAB_02EC:
    CLR.W   -28(A5)
    MOVE.W  -28(A5),D6
    EXT.L   D6

LAB_02ED:
    MOVE.W  -28(A5),D0
    CMP.W   -26(A5),D0
    BGE.S   LAB_02F0

    TST.L   D6
    BNE.S   LAB_02F0

    MOVE.B  LAB_222D,D1
    CMP.B   D1,D7
    BNE.S   LAB_02EE

    MOVE.B  LAB_222E,D1
    SUBQ.B  #1,D1
    BNE.S   LAB_02EE

    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     LAB_2235,A0
    ADDA.L  D1,A0
    MOVEA.L (A0),A1
    BRA.S   LAB_02EF

LAB_02EE:
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     LAB_2233,A0
    ADDA.L  D1,A0
    MOVEA.L (A0),A1

LAB_02EF:
    LEA     12(A3),A0
    LEA     12(A1),A6
    MOVE.L  A6,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  A1,-16(A5)
    JSR     LAB_00BE(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    SEQ     D1
    NEG.B   D1
    EXT.W   D1
    EXT.L   D1
    MOVE.L  D1,D6
    ADDQ.W  #1,-28(A5)
    BRA.S   LAB_02ED

LAB_02F0:
    TST.L   D6
    BNE.W   LAB_0313

    MOVEA.L 48(A3),A2
    LEA     12(A3),A0
    MOVE.L  A0,D0
    BEQ.S   LAB_02F2

    LEA     12(A3),A0
    LEA     12(A3),A1
    MOVEA.L A1,A6

LAB_02F1:
    TST.B   (A6)+
    BNE.S   LAB_02F1

    SUBQ.L  #1,A6
    SUBA.L  A1,A6
    MOVE.L  A6,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    LEA     12(A7),A7

LAB_02F2:
    PEA     1.W
    PEA     LAB_1B5F
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    LEA     12(A7),A7
    TST.L   24(A2)
    BEQ.S   LAB_02F4

    MOVEA.L 24(A2),A0

LAB_02F3:
    TST.B   (A0)+
    BNE.S   LAB_02F3

    SUBQ.L  #1,A0
    SUBA.L  24(A2),A0
    MOVE.L  A0,-(A7)
    MOVE.L  24(A2),-(A7)
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    LEA     12(A7),A7

LAB_02F4:
    PEA     1.W
    PEA     LAB_1B70
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    LEA     12(A7),A7
    TST.L   28(A2)
    BEQ.S   LAB_02F6

    MOVEA.L 28(A2),A0

LAB_02F5:
    TST.B   (A0)+
    BNE.S   LAB_02F5

    SUBQ.L  #1,A0
    SUBA.L  28(A2),A0
    MOVE.L  A0,-(A7)
    MOVE.L  28(A2),-(A7)
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    LEA     12(A7),A7

LAB_02F6:
    PEA     1.W
    PEA     LAB_1B5F
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    MOVE.L  32(A2),(A7)
    PEA     LAB_1B71
    PEA     -152(A5)
    JSR     JMP_TBL_PRINTF_1(PC)

    LEA     -152(A5),A0
    MOVEA.L A0,A1

LAB_02F7:
    TST.B   (A1)+
    BNE.S   LAB_02F7

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    PEA     1.W
    PEA     LAB_1B5F
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    LEA     40(A7),A7
    TST.L   4(A2)
    BEQ.S   LAB_02F9

    MOVEA.L 4(A2),A0

LAB_02F8:
    TST.B   (A0)+
    BNE.S   LAB_02F8

    SUBQ.L  #1,A0
    SUBA.L  4(A2),A0
    MOVE.L  A0,-(A7)
    MOVE.L  4(A2),-(A7)
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    LEA     12(A7),A7

LAB_02F9:
    PEA     1.W
    PEA     LAB_1B5F
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    MOVEA.L A2,A0

LAB_02FA:
    TST.B   (A0)+
    BNE.S   LAB_02FA

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    MOVE.L  A0,(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    PEA     1.W
    PEA     LAB_1B5F
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    LEA     32(A7),A7
    TST.L   12(A2)
    BEQ.S   LAB_02FC

    MOVEA.L 12(A2),A0

LAB_02FB:
    TST.B   (A0)+
    BNE.S   LAB_02FB

    SUBQ.L  #1,A0
    SUBA.L  12(A2),A0
    MOVE.L  A0,-(A7)
    MOVE.L  12(A2),-(A7)
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    LEA     12(A7),A7

LAB_02FC:
    PEA     1.W
    PEA     LAB_1B5F
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    LEA     12(A7),A7
    TST.L   16(A2)
    BEQ.S   LAB_02FE

    MOVEA.L 16(A2),A0

LAB_02FD:
    TST.B   (A0)+
    BNE.S   LAB_02FD

    SUBQ.L  #1,A0
    SUBA.L  16(A2),A0
    MOVE.L  A0,-(A7)
    MOVE.L  16(A2),-(A7)
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    LEA     12(A7),A7

LAB_02FE:
    PEA     1.W
    PEA     LAB_1B5F
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    LEA     12(A7),A7
    TST.L   20(A2)
    BEQ.S   LAB_0300

    MOVEA.L 20(A2),A0

LAB_02FF:
    TST.B   (A0)+
    BNE.S   LAB_02FF

    SUBQ.L  #1,A0
    SUBA.L  20(A2),A0
    MOVE.L  A0,-(A7)
    MOVE.L  20(A2),-(A7)
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    LEA     12(A7),A7

LAB_0300:
    PEA     1.W
    PEA     LAB_1B5F
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    LEA     12(A7),A7
    TST.L   8(A2)
    BEQ.S   LAB_0302

    MOVEA.L 8(A2),A0

LAB_0301:
    TST.B   (A0)+
    BNE.S   LAB_0301

    SUBQ.L  #1,A0
    SUBA.L  8(A2),A0
    MOVE.L  A0,-(A7)
    MOVE.L  8(A2),-(A7)
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    LEA     12(A7),A7

LAB_0302:
    PEA     1.W
    PEA     LAB_1B5F
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    MOVE.W  36(A2),D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    PEA     LAB_1B72
    PEA     -152(A5)
    JSR     JMP_TBL_PRINTF_1(PC)

    LEA     -152(A5),A0
    MOVEA.L A0,A1

LAB_0303:
    TST.B   (A1)+
    BNE.S   LAB_0303

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    PEA     2.W
    PEA     LAB_1B60
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    LEA     40(A7),A7
    CLR.W   -28(A5)

LAB_0304:
    MOVE.W  -28(A5),D0
    CMP.W   36(A2),D0
    BGE.W   LAB_0313

    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    MOVEA.L 38(A2),A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-12(A5)
    MOVEA.L -12(A5),A0
    MOVE.W  (A0),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     LAB_1B73
    PEA     -152(A5)
    JSR     JMP_TBL_PRINTF_1(PC)

    LEA     -152(A5),A0
    MOVEA.L A0,A1

LAB_0305:
    TST.B   (A1)+
    BNE.S   LAB_0305

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    PEA     1.W
    PEA     LAB_1B5F
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    LEA     32(A7),A7
    MOVEA.L -12(A5),A0
    TST.L   18(A0)
    BEQ.S   LAB_0307

    MOVEA.L 18(A0),A1

LAB_0306:
    TST.B   (A1)+
    BNE.S   LAB_0306

    SUBQ.L  #1,A1
    SUBA.L  18(A0),A1
    MOVE.L  A1,-(A7)
    MOVE.L  18(A0),-(A7)
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    LEA     12(A7),A7

LAB_0307:
    PEA     1.W
    PEA     LAB_1B74
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    LEA     12(A7),A7
    MOVEA.L -12(A5),A0
    TST.L   22(A0)
    BEQ.S   LAB_0309

    MOVEA.L -12(A5),A1
    MOVEA.L 22(A1),A0

LAB_0308:
    TST.B   (A0)+
    BNE.S   LAB_0308

    SUBQ.L  #1,A0
    SUBA.L  22(A1),A0
    MOVE.L  A0,-(A7)
    MOVE.L  22(A1),-(A7)
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    LEA     12(A7),A7

LAB_0309:
    PEA     1.W
    PEA     LAB_1B5F
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    MOVEA.L -12(A5),A0
    MOVE.L  26(A0),(A7)
    PEA     LAB_1B75
    PEA     -152(A5)
    JSR     JMP_TBL_PRINTF_1(PC)

    LEA     -152(A5),A0
    MOVEA.L A0,A1

LAB_030A:
    TST.B   (A1)+
    BNE.S   LAB_030A

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    PEA     1.W
    PEA     LAB_1B5F
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    LEA     40(A7),A7
    MOVEA.L -12(A5),A0
    TST.L   6(A0)
    BEQ.S   LAB_030C

    MOVEA.L -12(A5),A1
    MOVEA.L 6(A1),A0

LAB_030B:
    TST.B   (A0)+
    BNE.S   LAB_030B

    SUBQ.L  #1,A0
    SUBA.L  6(A1),A0
    MOVE.L  A0,-(A7)
    MOVE.L  6(A1),-(A7)
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    LEA     12(A7),A7

LAB_030C:
    PEA     1.W
    PEA     LAB_1B5F
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    LEA     12(A7),A7
    MOVEA.L -12(A5),A0
    TST.L   10(A0)
    BEQ.S   LAB_030E

    MOVEA.L -12(A5),A1
    MOVEA.L 10(A1),A0

LAB_030D:
    TST.B   (A0)+
    BNE.S   LAB_030D

    SUBQ.L  #1,A0
    SUBA.L  10(A1),A0
    MOVE.L  A0,-(A7)
    MOVE.L  10(A1),-(A7)
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    LEA     12(A7),A7

LAB_030E:
    PEA     1.W
    PEA     LAB_1B5F
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    LEA     12(A7),A7
    MOVEA.L -12(A5),A0
    TST.L   14(A0)
    BEQ.S   LAB_0310

    MOVEA.L -12(A5),A1
    MOVEA.L 14(A1),A0

LAB_030F:
    TST.B   (A0)+
    BNE.S   LAB_030F

    SUBQ.L  #1,A0
    SUBA.L  14(A1),A0
    MOVE.L  A0,-(A7)
    MOVE.L  14(A1),-(A7)
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    LEA     12(A7),A7

LAB_0310:
    PEA     1.W
    PEA     LAB_1B5F
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    LEA     12(A7),A7
    MOVEA.L -12(A5),A0
    TST.L   2(A0)
    BEQ.S   LAB_0312

    MOVEA.L -12(A5),A1
    MOVEA.L 2(A1),A0

LAB_0311:
    TST.B   (A0)+
    BNE.S   LAB_0311

    SUBQ.L  #1,A0
    SUBA.L  2(A1),A0
    MOVE.L  A0,-(A7)
    MOVE.L  2(A1),-(A7)
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    LEA     12(A7),A7

LAB_0312:
    PEA     2.W
    PEA     LAB_1B60
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    LEA     12(A7),A7
    ADDQ.W  #1,-28(A5)
    BRA.W   LAB_0304

LAB_0313:
    ADDQ.W  #1,-26(A5)
    BRA.W   LAB_02EA

LAB_0314:
    PEA     1.W
    PEA     LAB_1B5E
    MOVE.L  D5,-(A7)
    JSR     LAB_03A0(PC)

    MOVE.L  D5,(A7)
    JSR     LAB_039A(PC)

    MOVEQ   #0,D0

LAB_0315:
    MOVEM.L -176(A5),D5-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

LAB_0316:
    LINK.W  A5,#-4
    MOVE.L  A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVE.L  A3,D0
    BEQ.S   .LAB_0317

    MOVEA.L 48(A3),A0
    BRA.S   .LAB_0318

.LAB_0317:
    SUBA.L  A0,A0

.LAB_0318:
    MOVE.L  A0,-4(A5)
    MOVE.L  A0,D0
    BEQ.S   .return

    MOVE.W  36(A0),D0
    TST.W   D0
    BLE.S   .return

    EXT.L   D0
    ASL.L   #2,D0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D0,-(A7)
    PEA     1123.W
    PEA     GLOB_STR_COI_C_5
    JSR     JMP_TBL_ALLOCATE_MEMORY_1(PC)

    MOVEA.L -4(A5),A0
    MOVE.L  D0,38(A0)
    MOVE.W  36(A0),D1
    EXT.L   D1
    MOVE.L  D1,(A7)
    PEA     30.W
    MOVE.L  D0,-(A7)
    JSR     LAB_0383(PC)

    LEA     24(A7),A7

.return:
    MOVEA.L (A7)+,A3
    UNLK    A5
    RTS

;!======

LAB_031A:
    LINK.W  A5,#-648
    MOVEM.L D2-D3/D5-D7/A2-A3,-(A7)
    MOVE.B  11(A5),D7
    MOVEQ   #0,D0
    MOVEQ   #9,D1
    MOVE.B  D1,-615(A5)
    MOVE.B  D1,-614(A5)
    MOVE.B  D1,-613(A5)
    MOVE.B  D1,-612(A5)
    MOVE.B  D1,-611(A5)
    MOVE.B  D1,-610(A5)
    MOVE.B  D1,-609(A5)
    MOVE.B  D1,-608(A5)
    MOVE.B  D1,-607(A5)
    MOVEQ   #13,D2
    MOVE.B  D2,-606(A5)
    MOVEQ   #10,D3
    MOVE.B  D3,-605(A5)
    MOVE.B  D1,-640(A5)
    MOVE.B  D1,-639(A5)
    MOVE.B  D1,-638(A5)
    MOVE.B  D1,-637(A5)
    MOVE.B  D1,-636(A5)
    MOVE.B  D1,-635(A5)
    MOVE.B  D2,-634(A5)
    MOVE.B  D3,-633(A5)
    MOVEQ   #0,D1
    MOVE.B  D7,D1
    MOVE.L  D0,-582(A5)
    MOVE.L  D0,-578(A5)
    MOVE.L  D1,D0
    MOVEQ   #2,D1
    JSR     JMP_TBL_LAB_1A07_1(PC)

    MOVE.W  D1,-334(A5)
    EXT.L   D1
    MOVE.L  D1,-(A7)
    PEA     GLOB_STR_DF0_OI_PERCENT_2_LX_DAT_2
    PEA     -566(A5)
    JSR     JMP_TBL_PRINTF_1(PC)

    PEA     -566(A5)
    JSR     LAB_03AC(PC)

    LEA     16(A7),A7
    ADDQ.L  #1,D0
    BNE.S   LAB_031B

    MOVEQ   #-1,D0
    BRA.W   LAB_0344

LAB_031B:
    MOVE.L  GLOB_REF_LONG_FILE_SCRATCH,D0
    MOVEA.L LAB_21BC,A0
    MOVE.B  LAB_222D,D1
    MOVE.L  D0,-574(A5)
    MOVE.L  A0,-570(A5)
    CMP.B   D7,D1
    BNE.S   LAB_031C

    MOVE.B  LAB_222E,D0
    SUBQ.B  #1,D0
    BNE.S   LAB_031C

    MOVE.W  LAB_222F,D0
    MOVE.W  D0,-336(A5)
    BRA.S   LAB_031E

LAB_031C:
    MOVE.B  LAB_2230,D0
    CMP.B   D0,D7
    BNE.S   LAB_031D

    MOVE.W  LAB_2231,D0
    MOVE.W  D0,-336(A5)
    BRA.S   LAB_031E

LAB_031D:
    MOVE.L  -574(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    PEA     1198.W
    PEA     GLOB_STR_COI_C_6
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

    MOVEQ   #-1,D0
    BRA.W   LAB_0344

LAB_031E:
    MOVEQ   #0,D0
    MOVE.L  D0,-578(A5)
    MOVE.L  D0,-582(A5)

LAB_031F:
    MOVEA.L LAB_21BC,A0
    ADDA.L  -578(A5),A0
    ADDA.L  -582(A5),A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.L  D0,-(A7)
    PEA     LAB_1B79
    JSR     LAB_05C1(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_0320

    LEA     -486(A5),A0
    MOVE.L  -582(A5),D0
    ADDA.L  D0,A0
    MOVEA.L LAB_21BC,A1
    ADDA.L  -578(A5),A1
    ADDA.L  D0,A1
    MOVE.B  (A1),(A0)
    ADDQ.L  #1,-582(A5)
    BRA.S   LAB_031F

LAB_0320:
    LEA     -486(A5),A0
    MOVEA.L A0,A1
    ADDA.L  -582(A5),A1
    CLR.B   (A1)
    PEA     9.W
    MOVE.L  A0,-(A7)
    JSR     LAB_05C1(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-648(A5)
    TST.L   D0
    BEQ.S   LAB_0321

    MOVEA.L D0,A0
    CLR.B   (A0)+
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-648(A5)
    JSR     LAB_0468(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,-644(A5)
    BRA.S   LAB_0322

LAB_0321:
    CLR.L   -644(A5)

LAB_0322:
    PEA     -486(A5)
    JSR     LAB_0468(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D7,D1
    CMP.L   D0,D1
    BEQ.S   LAB_0323

    MOVEQ   #-1,D0
    BRA.W   LAB_0344

LAB_0323:
    MOVEA.L LAB_21BC,A0
    ADDA.L  -578(A5),A0
    ADDA.L  -582(A5),A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.L  D0,-(A7)
    PEA     LAB_1B7A
    JSR     LAB_05C1(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   LAB_0324

    MOVEA.L LAB_21BC,A0
    ADDA.L  -578(A5),A0
    MOVE.L  -582(A5),D0
    ADDA.L  D0,A0
    CLR.B   (A0)
    ADDQ.L  #1,-582(A5)
    BRA.S   LAB_0323

LAB_0324:
    MOVE.W  #$12d,D0
    MOVEQ   #0,D1
    LEA     -326(A5),A0

LAB_0325:
    MOVE.B  D1,(A0)+
    DBF     D0,LAB_0325
    MOVEQ   #0,D6

LAB_0326:
    CMP.W   -336(A5),D6
    BGE.W   LAB_0343

    MOVE.L  -582(A5),D0
    ADD.L   D0,-578(A5)
    MOVEQ   #2,D0
    CMP.L   -644(A5),D0
    BNE.S   LAB_0327

    MOVEA.L LAB_21BC,A0
    ADDA.L  -578(A5),A0
    MOVE.L  -574(A5),D0
    EXT.L   D0
    PEA     1.W
    PEA     26.W
    MOVE.L  D0,-(A7)
    PEA     -615(A5)
    PEA     11.W
    PEA     -604(A5)
    MOVE.L  A0,-(A7)
    JSR     LAB_037D(PC)

    LEA     28(A7),A7
    BRA.S   LAB_0329

LAB_0327:
    MOVEQ   #21,D0
    MOVEQ   #0,D1
    LEA     -604(A5),A0

LAB_0328:
    MOVE.B  D1,(A0)+
    DBF     D0,LAB_0328
    MOVEA.L LAB_21BC,A0
    ADDA.L  -578(A5),A0
    MOVE.L  -574(A5),D0
    EXT.L   D0
    PEA     1.W
    PEA     26.W
    MOVE.L  D0,-(A7)
    PEA     -613(A5)
    PEA     11.W
    PEA     -600(A5)
    MOVE.L  A0,-(A7)
    JSR     LAB_037D(PC)

    LEA     28(A7),A7

LAB_0329:
    MOVE.W  -584(A5),D0
    EXT.L   D0
    MOVEQ   #0,D5
    MOVE.L  D0,-582(A5)

LAB_032A:
    CMP.W   -336(A5),D5
    BGE.W   LAB_033C

    MOVE.B  LAB_222D,D0
    CMP.B   D0,D7
    BNE.S   LAB_032B

    MOVE.B  LAB_222E,D0
    SUBQ.B  #1,D0
    BNE.S   LAB_032B

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2235,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    BRA.S   LAB_032C

LAB_032B:
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2233,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1

LAB_032C:
    LEA     12(A1),A0
    MOVEA.L LAB_21BC,A2
    ADDA.L  -578(A5),A2
    MOVE.L  A2,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  A1,-4(A5)
    JSR     LAB_00BE(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.W   LAB_033B

    LEA     -326(A5),A0
    ADDA.W  D5,A0
    TST.B   (A0)
    BNE.W   LAB_0331

    MOVEA.L -4(A5),A0
    MOVE.L  48(A0),-8(A5)
    MOVEA.L LAB_21BC,A0
    ADDA.L  -578(A5),A0
    ADDA.W  -600(A5),A0
    MOVEA.L -8(A5),A1
    MOVE.L  4(A1),-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -8(A5),A0
    MOVE.L  D0,4(A0)
    MOVEA.L LAB_21BC,A1
    ADDA.L  -578(A5),A1
    MOVEA.W -598(A5),A2
    MOVE.L  A2,D0
    MOVE.B  0(A1,D0.W),(A0)
    MOVE.B  1(A1,D0.W),1(A0)
    MOVE.B  2(A1,D0.W),2(A0)
    CLR.B   3(A0)
    ADDA.W  -596(A5),A1
    MOVE.L  12(A0),(A7)
    MOVE.L  A1,-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -8(A5),A0
    MOVE.L  D0,12(A0)
    MOVEA.L LAB_21BC,A1
    ADDA.L  -578(A5),A1
    ADDA.W  -594(A5),A1
    MOVE.L  16(A0),(A7)
    MOVE.L  A1,-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -8(A5),A0
    MOVE.L  D0,16(A0)
    MOVEA.L LAB_21BC,A1
    ADDA.L  -578(A5),A1
    ADDA.W  -592(A5),A1
    MOVE.L  20(A0),(A7)
    MOVE.L  A1,-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -8(A5),A0
    MOVE.L  D0,20(A0)
    MOVEA.L LAB_21BC,A1
    ADDA.L  -578(A5),A1
    ADDA.W  -590(A5),A1
    MOVE.L  8(A0),(A7)
    MOVE.L  A1,-(A7)
    JSR     LAB_0385(PC)

    LEA     24(A7),A7
    MOVEA.L -8(A5),A0
    MOVE.L  D0,8(A0)
    MOVE.W  -604(A5),D0
    BLE.S   LAB_032D

    MOVE.L  -578(A5),D1
    MOVEA.L LAB_21BC,A1
    MOVEA.L A1,A2
    ADDA.L  D1,A2
    ADDA.W  D0,A2
    MOVE.L  A2,D2
    BEQ.S   LAB_032D

    LEA     24(A0),A2
    LEA     28(A0),A3
    ADDA.L  D1,A1
    ADDA.W  D0,A1
    MOVE.L  A1,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  A2,-(A7)
    BSR.W   LAB_0290

    LEA     12(A7),A7
    BRA.S   LAB_032E

LAB_032D:
    MOVE.L  24(A0),-(A7)
    CLR.L   -(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -8(A5),A0
    MOVE.L  D0,24(A0)
    MOVE.L  28(A0),(A7)
    PEA     LAB_1B7B
    JSR     LAB_0385(PC)

    LEA     12(A7),A7
    MOVEA.L -8(A5),A0
    MOVE.L  D0,28(A0)

LAB_032E:
    MOVE.W  -602(A5),D0
    BEQ.S   LAB_032F

    MOVE.L  -578(A5),D1
    MOVEA.L LAB_21BC,A0
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    ADDA.W  D0,A1
    MOVE.L  A1,D2
    BEQ.S   LAB_032F

    ADDA.L  D1,A0
    ADDA.W  D0,A0
    MOVE.L  A0,-(A7)
    JSR     LAB_0468(PC)

    ADDQ.W  #4,A7
    MOVEA.L -8(A5),A0
    MOVE.L  D0,32(A0)
    BRA.S   LAB_0330

LAB_032F:
    MOVEQ   #-1,D0
    MOVEA.L -8(A5),A0
    MOVE.L  D0,32(A0)

LAB_0330:
    MOVEA.L LAB_21BC,A0
    ADDA.L  -578(A5),A0
    ADDA.W  -588(A5),A0
    MOVE.L  A0,-(A7)
    PEA     GLOB_STR_PERCENT_S_1
    PEA     -486(A5)
    JSR     JMP_TBL_PRINTF_1(PC)

    PEA     -486(A5)
    JSR     LAB_0468(PC)

    LEA     16(A7),A7
    MOVEA.L -8(A5),A0
    MOVE.W  D0,36(A0)

LAB_0331:
    MOVE.L  -4(A5),-(A7)
    BSR.W   LAB_0316

    ADDQ.W  #4,A7
    CLR.W   -332(A5)

LAB_0332:
    MOVE.W  -332(A5),D0
    MOVEA.L -8(A5),A0
    CMP.W   36(A0),D0
    BGE.W   LAB_033A

    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    MOVEA.L -8(A5),A1
    MOVEA.L 38(A1),A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-12(A5)
    MOVE.L  -582(A5),D0
    ADD.L   D0,-578(A5)
    MOVEQ   #2,D0
    CMP.L   -644(A5),D0
    BNE.S   LAB_0333

    MOVEA.L LAB_21BC,A0
    ADDA.L  -578(A5),A0
    MOVE.L  -574(A5),D0
    EXT.L   D0
    PEA     1.W
    PEA     26.W
    MOVE.L  D0,-(A7)
    PEA     -640(A5)
    PEA     8.W
    PEA     -632(A5)
    MOVE.L  A0,-(A7)
    JSR     LAB_037D(PC)

    LEA     28(A7),A7
    BRA.S   LAB_0335

LAB_0333:
    MOVEQ   #15,D0
    MOVEQ   #0,D1
    LEA     -632(A5),A0

LAB_0334:
    MOVE.B  D1,(A0)+
    DBF     D0,LAB_0334
    MOVEA.L LAB_21BC,A0
    ADDA.L  -578(A5),A0
    MOVE.L  -574(A5),D0
    EXT.L   D0
    PEA     1.W
    PEA     26.W
    MOVE.L  D0,-(A7)
    PEA     -638(A5)
    PEA     6.W
    PEA     -628(A5)
    MOVE.L  A0,-(A7)
    JSR     LAB_037D(PC)

    LEA     28(A7),A7

LAB_0335:
    LEA     -326(A5),A0
    ADDA.W  D5,A0
    TST.B   (A0)
    BNE.W   LAB_0339

    MOVEA.L LAB_21BC,A0
    ADDA.L  -578(A5),A0
    MOVE.L  A0,-(A7)
    JSR     LAB_0468(PC)

    MOVEA.L -12(A5),A0
    MOVE.W  D0,(A0)
    MOVEA.L LAB_21BC,A1
    ADDA.L  -578(A5),A1
    ADDA.W  -628(A5),A1
    MOVE.L  6(A0),(A7)
    MOVE.L  A1,-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -12(A5),A0
    MOVE.L  D0,6(A0)
    MOVEA.L LAB_21BC,A1
    ADDA.L  -578(A5),A1
    ADDA.W  -626(A5),A1
    MOVE.L  10(A0),(A7)
    MOVE.L  A1,-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -12(A5),A0
    MOVE.L  D0,10(A0)
    MOVEA.L LAB_21BC,A1
    ADDA.L  -578(A5),A1
    ADDA.W  -624(A5),A1
    MOVE.L  14(A0),(A7)
    MOVE.L  A1,-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -12(A5),A0
    MOVE.L  D0,14(A0)
    MOVEA.L LAB_21BC,A1
    ADDA.L  -578(A5),A1
    ADDA.W  -622(A5),A1
    MOVE.L  2(A0),(A7)
    MOVE.L  A1,-(A7)
    JSR     LAB_0385(PC)

    LEA     20(A7),A7
    MOVEA.L -12(A5),A0
    MOVE.L  D0,2(A0)
    MOVE.W  -632(A5),D0
    BLE.S   LAB_0336

    MOVE.L  -578(A5),D1
    MOVEA.L LAB_21BC,A1
    MOVEA.L A1,A2
    ADDA.L  D1,A2
    ADDA.W  D0,A2
    MOVE.L  A2,D2
    BEQ.S   LAB_0336

    LEA     18(A0),A2
    LEA     22(A0),A3
    ADDA.L  D1,A1
    ADDA.W  D0,A1
    MOVE.L  A1,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  A2,-(A7)
    BSR.W   LAB_0290

    LEA     12(A7),A7
    BRA.S   LAB_0337

LAB_0336:
    MOVE.L  18(A0),-(A7)
    MOVEA.L -8(A5),A0
    MOVE.L  24(A0),-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -12(A5),A0
    MOVE.L  D0,18(A0)
    MOVE.L  22(A0),(A7)
    MOVEA.L -8(A5),A0
    MOVE.L  28(A0),-(A7)
    JSR     LAB_0385(PC)

    LEA     12(A7),A7
    MOVEA.L -12(A5),A0
    MOVE.L  D0,22(A0)

LAB_0337:
    MOVE.W  -630(A5),D0
    BLE.S   LAB_0338

    MOVE.L  -578(A5),D1
    MOVEA.L LAB_21BC,A0
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    ADDA.W  D0,A1
    MOVE.L  A1,D2
    BEQ.S   LAB_0338

    ADDA.L  D1,A0
    ADDA.W  D0,A0
    MOVE.L  A0,-(A7)
    JSR     LAB_0468(PC)

    ADDQ.W  #4,A7
    MOVEA.L -12(A5),A0
    MOVE.L  D0,26(A0)
    BRA.S   LAB_0339

LAB_0338:
    MOVEA.L -8(A5),A0
    MOVEA.L -12(A5),A1
    MOVE.L  32(A0),26(A1)

LAB_0339:
    MOVE.W  -618(A5),D0
    EXT.L   D0
    MOVE.L  D0,-582(A5)
    ADDQ.W  #1,-332(A5)
    BRA.W   LAB_0332

LAB_033A:
    LEA     -326(A5),A0
    MOVEA.L A0,A1
    ADDA.W  D5,A1
    TST.B   (A1)
    BNE.S   LAB_033C

    ADDA.W  D5,A0
    MOVE.B  #$1,(A0)
    BRA.S   LAB_033C

LAB_033B:
    ADDQ.W  #1,D5
    BRA.W   LAB_032A

LAB_033C:
    ADDQ.W  #1,D5

LAB_033D:
    CMP.W   -336(A5),D5
    BGE.W   LAB_0342

    MOVE.B  LAB_222D,D0
    CMP.B   D0,D7
    BNE.S   LAB_033E

    MOVE.B  LAB_222E,D0
    SUBQ.B  #1,D0
    BNE.S   LAB_033E

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2235,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    BRA.S   LAB_033F

LAB_033E:
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2233,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1

LAB_033F:
    MOVEA.L -4(A5),A0
    ADDA.W  #12,A0
    LEA     12(A1),A2
    MOVE.L  A2,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  A1,-16(A5)
    JSR     LAB_00BE(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.W   LAB_0341

    LEA     -326(A5),A0
    MOVEA.L A0,A1
    ADDA.W  D5,A1
    TST.B   (A1)
    BNE.W   LAB_0341

    ADDA.W  D5,A0
    MOVE.B  #$1,(A0)
    MOVEA.L -16(A5),A0
    MOVE.L  48(A0),-20(A5)
    MOVEA.L -20(A5),A0
    MOVE.L  4(A0),-(A7)
    MOVEA.L -8(A5),A1
    MOVE.L  4(A1),-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -20(A5),A0
    MOVE.L  D0,4(A0)
    MOVEA.L -8(A5),A0
    MOVEA.L -20(A5),A1
    MOVE.B  (A0),(A1)
    MOVE.B  1(A0),1(A1)
    MOVE.B  2(A0),2(A1)
    MOVE.B  3(A0),3(A1)
    MOVE.L  12(A1),(A7)
    MOVE.L  12(A0),-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -20(A5),A0
    MOVE.L  D0,12(A0)
    MOVE.L  16(A0),(A7)
    MOVEA.L -8(A5),A0
    MOVE.L  16(A0),-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -20(A5),A0
    MOVE.L  D0,16(A0)
    MOVE.L  20(A0),(A7)
    MOVEA.L -8(A5),A0
    MOVE.L  20(A0),-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -20(A5),A0
    MOVE.L  D0,20(A0)
    MOVE.L  8(A0),(A7)
    MOVEA.L -8(A5),A0
    MOVE.L  8(A0),-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -20(A5),A0
    MOVE.L  D0,8(A0)
    MOVE.L  24(A0),(A7)
    MOVEA.L -8(A5),A0
    MOVE.L  24(A0),-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -20(A5),A0
    MOVE.L  D0,24(A0)
    MOVE.L  28(A0),(A7)
    MOVEA.L -8(A5),A0
    MOVE.L  28(A0),-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -20(A5),A0
    MOVE.L  D0,28(A0)
    MOVEA.L -8(A5),A0
    MOVEA.L -20(A5),A1
    MOVE.L  32(A0),32(A1)
    MOVE.W  36(A0),36(A1)
    MOVE.L  -16(A5),(A7)
    BSR.W   LAB_0316

    LEA     32(A7),A7
    CLR.W   -332(A5)

LAB_0340:
    MOVE.W  -332(A5),D0
    MOVEA.L -20(A5),A0
    CMP.W   36(A0),D0
    BGE.W   LAB_0341

    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    MOVEA.L -20(A5),A1
    MOVEA.L 38(A1),A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-24(A5)
    MOVEA.L -8(A5),A1
    MOVEA.L 38(A1),A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-12(A5)
    MOVEA.L -12(A5),A0
    MOVEA.L -24(A5),A1
    MOVE.W  (A0),(A1)
    MOVE.L  6(A1),-(A7)
    MOVE.L  6(A0),-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -24(A5),A0
    MOVE.L  D0,6(A0)
    MOVE.L  10(A0),(A7)
    MOVEA.L -12(A5),A0
    MOVE.L  10(A0),-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -24(A5),A0
    MOVE.L  D0,10(A0)
    MOVE.L  14(A0),(A7)
    MOVEA.L -12(A5),A0
    MOVE.L  14(A0),-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -24(A5),A0
    MOVE.L  D0,14(A0)
    MOVE.L  2(A0),(A7)
    MOVEA.L -12(A5),A0
    MOVE.L  2(A0),-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -24(A5),A0
    MOVE.L  D0,2(A0)
    MOVE.L  18(A0),(A7)
    MOVEA.L -12(A5),A0
    MOVE.L  18(A0),-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -24(A5),A0
    MOVE.L  D0,18(A0)
    MOVE.L  22(A0),(A7)
    MOVEA.L -12(A5),A0
    MOVE.L  22(A0),-(A7)
    JSR     LAB_0385(PC)

    LEA     28(A7),A7
    MOVEA.L -24(A5),A0
    MOVE.L  D0,22(A0)
    MOVEA.L -12(A5),A0
    MOVEA.L -24(A5),A1
    MOVE.L  26(A0),26(A1)
    ADDQ.W  #1,-332(A5)
    BRA.W   LAB_0340

LAB_0341:
    ADDQ.W  #1,D5
    BRA.W   LAB_033D

LAB_0342:
    ADDQ.W  #1,D6
    BRA.W   LAB_0326

LAB_0343:
    MOVE.L  -574(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -570(A5),-(A7)
    PEA     1443.W
    PEA     GLOB_STR_COI_C_1
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

    MOVEQ   #0,D0

LAB_0344:
    MOVEM.L -676(A5),D2-D3/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_0345:
    LINK.W  A5,#-8
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  A3,D0
    BEQ.S   .return

    MOVEA.L 48(A3),A0
    MOVE.L  A0,-4(A5)
    BNE.S   .return

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     Struct_AnimOb_Size.W
    PEA     1458.W
    PEA     GLOB_STR_COI_C_2
    JSR     JMP_TBL_ALLOCATE_MEMORY_1(PC)

    MOVE.L  D0,48(A3)
    MOVEA.L D0,A0
    MOVE.L  28(A0),(A7)
    PEA     LAB_1B7F
    MOVE.L  D0,24(A7)
    JSR     LAB_0385(PC)

    LEA     20(A7),A7
    MOVEA.L 4(A7),A0
    MOVE.L  D0,28(A0)
    MOVEA.L 48(A3),A0
    MOVEQ   #-1,D0
    MOVE.L  D0,32(A0)

.return:
    MOVEA.L (A7)+,A3
    UNLK    A5
    RTS

;!======

LAB_0347:
    LINK.W  A5,#-20
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVE.W  18(A5),D6
    SUBA.L  A0,A0
    MOVEQ   #0,D4
    MOVE.L  A0,-12(A5)
    MOVE.L  A3,D0
    BEQ.S   LAB_0348

    TST.L   48(A3)
    BNE.S   LAB_0349

LAB_0348:
    MOVE.L  A0,D0
    BRA.W   LAB_0357

LAB_0349:
    MOVE.L  48(A3),-4(A5)
    MOVEQ   #0,D5

LAB_034A:
    MOVEA.L -4(A5),A0
    CMP.W   36(A0),D5
    BGE.S   LAB_034C

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -4(A5),A1
    MOVEA.L 38(A1),A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  A1,-8(A5)
    MOVE.W  (A1),D0
    CMP.W   D7,D0
    BNE.S   LAB_034B

    MOVEQ   #1,D4
    MOVE.L  A1,-12(A5)
    BRA.S   LAB_034C

LAB_034B:
    ADDQ.W  #1,D5
    BRA.S   LAB_034A

LAB_034C:
    MOVE.L  D6,D0
    CMPI.W  #8,D0
    BCC.W   LAB_0355

    ADD.W   D0,D0
    MOVE.W  LAB_034D(PC,D0.W),D0
    JMP     LAB_034D+2(PC,D0.W)

LAB_034D:
    ORI.B   #$26,(A0)+
    ORI.W   #$64,D6
    ORI.L   #$e009c,D0
    ORI.L   #$2b6dfffc,$FFFFFFF0
    BRA.W   LAB_0356

    MOVEA.L -4(A5),A0
    MOVE.L  4(A0),-16(A5)
    BRA.W   LAB_0356

    TST.W   D4
    BEQ.S   LAB_034F

    MOVEA.L -12(A5),A0
    MOVE.L  2(A0),-16(A5)
    BRA.W   LAB_0356

LAB_034F:
    MOVEA.L -4(A5),A0
    MOVE.L  8(A0),-16(A5)
    BRA.W   LAB_0356

    TST.W   D4
    BEQ.S   LAB_0350

    MOVEA.L -12(A5),A0
    MOVE.L  6(A0),-16(A5)
    BRA.W   LAB_0356

LAB_0350:
    MOVEA.L -4(A5),A0
    MOVE.L  12(A0),-16(A5)
    BRA.S   LAB_0356

    TST.W   D4
    BEQ.S   LAB_0351

    MOVEA.L -12(A5),A0
    MOVE.L  10(A0),-16(A5)
    BRA.S   LAB_0356

LAB_0351:
    MOVEA.L -4(A5),A0
    MOVE.L  16(A0),-16(A5)
    BRA.S   LAB_0356

    TST.W   D4
    BEQ.S   LAB_0352

    MOVEA.L -12(A5),A0
    MOVE.L  14(A0),-16(A5)
    BRA.S   LAB_0356

LAB_0352:
    MOVEA.L -4(A5),A0
    MOVE.L  20(A0),-16(A5)
    BRA.S   LAB_0356

    TST.W   D4
    BEQ.S   LAB_0353

    MOVEA.L -12(A5),A0
    MOVE.L  18(A0),-16(A5)
    BRA.S   LAB_0356

LAB_0353:
    MOVEA.L -4(A5),A0
    MOVE.L  24(A0),-16(A5)
    BRA.S   LAB_0356

    TST.W   D4
    BEQ.S   LAB_0354

    MOVEA.L -12(A5),A0
    MOVE.L  22(A0),-16(A5)
    BRA.S   LAB_0356

LAB_0354:
    MOVEA.L -4(A5),A0
    MOVE.L  28(A0),-16(A5)
    BRA.S   LAB_0356

LAB_0355:
    CLR.L   -16(A5)

LAB_0356:
    MOVE.L  -16(A5),D0

LAB_0357:
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======

LAB_0358:
    LINK.W  A5,#-44
    MOVEM.L D2/D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  16(A5),D7
    MOVE.L  24(A5),D6
    MOVEQ   #-1,D0
    CMP.L   D0,D6
    BNE.S   LAB_0359

    MOVE.L  LAB_22E6,D1
    BRA.S   LAB_035A

LAB_0359:
    MOVE.L  #1440,D1

LAB_035A:
    MOVE.L  D1,-28(A5)
    CMP.L   D0,D6
    BNE.S   LAB_035B

    MOVE.L  LAB_22E7,D0
    BRA.S   LAB_035C

LAB_035B:
    MOVE.L  LAB_1BBD,D0

LAB_035C:
    MOVE.L  D7,D2
    EXT.L   D2
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  D0,-32(A5)
    BSR.W   LAB_036C

    LEA     20(A7),A7
    TST.L   D0
    BEQ.W   LAB_0363

    MOVE.L  D7,D0
    EXT.L   D0
    PEA     1.W
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_0347

    LEA     12(A7),A7
    MOVE.L  D0,-20(A5)
    MOVEQ   #-1,D0
    CMP.L   D0,D6
    BNE.S   LAB_035D

    SUBA.L  A0,A0
    MOVE.L  A0,-16(A5)
    MOVE.L  A0,-12(A5)
    MOVE.L  A0,-8(A5)
    MOVEQ   #3,D6
    BRA.S   LAB_035E

LAB_035D:
    MOVE.L  D7,D0
    EXT.L   D0
    PEA     3.W
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_0347

    MOVE.L  D0,-16(A5)
    MOVE.L  D7,D0
    EXT.L   D0
    PEA     4.W
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_0347

    MOVE.L  D0,-12(A5)
    MOVE.L  D7,D0
    EXT.L   D0
    PEA     2.W
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_0347

    LEA     36(A7),A7
    MOVE.L  D0,-8(A5)

LAB_035E:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D6,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_0277

    LEA     12(A7),A7
    TST.L   D0
    BEQ.S   LAB_035F

    MOVE.L  D7,D0
    EXT.L   D0
    PEA     6.W
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_0347

    PEA     20.W
    MOVE.L  D0,-(A7)
    PEA     19.W
    PEA     LAB_1B80
    PEA     -44(A5)
    MOVE.L  D0,-36(A5)
    JSR     JMP_TBL_PRINTF_1(PC)

    LEA     -44(A5),A0
    MOVE.L  A0,-4(A5)
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_027A

    LEA     36(A7),A7
    BRA.S   LAB_0360

LAB_035F:
    CLR.L   -4(A5)

LAB_0360:
    MOVEQ   #0,D5

LAB_0361:
    MOVEQ   #5,D0
    CMP.L   D0,D5
    BGE.S   LAB_0363

    MOVE.L  D5,D0
    ASL.L   #2,D0
    TST.L   -20(A5,D0.L)
    BEQ.S   LAB_0362

    MOVEA.L -20(A5,D0.L),A0
    TST.B   (A0)
    BEQ.S   LAB_0362

    PEA     LAB_1B81
    MOVE.L  20(A5),-(A7)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    MOVE.L  D5,D0
    ASL.L   #2,D0
    MOVE.L  -20(A5,D0.L),(A7)
    MOVE.L  20(A5),-(A7)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    LEA     12(A7),A7

LAB_0362:
    ADDQ.L  #1,D5
    BRA.S   LAB_0361

LAB_0363:
    MOVE.L  20(A5),D0
    MOVEM.L (A7)+,D2/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_0364:
    MOVEM.L D5-D7/A3,-(A7)

    SetOffsetForStack 4
    UseStackLong    MOVEA.L,1,A3
    UseStackWord    MOVE.W,5,D7

    MOVEQ   #49,D6
    MOVEQ   #-1,D5
    TST.W   D7
    BLE.W   LAB_036B

    MOVEQ   #49,D0
    CMP.W   D0,D7
    BGE.W   LAB_036B

    MOVE.L  D7,D6
    ADDQ.W  #1,D6

LAB_0365:
    MOVEQ   #49,D0
    CMP.W   D0,D6
    BGE.S   LAB_0366

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    TST.L   56(A3,D0.L)
    BNE.S   LAB_0366

    ADDQ.W  #1,D6
    BRA.S   LAB_0365

LAB_0366:
    MOVEQ   #48,D0
    CMP.W   D0,D6
    BLE.S   LAB_0369

    MOVE.B  LAB_2230,D0
    MOVE.B  498(A3),D1
    CMP.B   D0,D1
    BNE.S   LAB_0369

    MOVE.L  A3,-(A7)
    JSR     LAB_037C(PC)

    MOVE.L  D0,D6
    MOVE.L  D6,D0
    EXT.L   D0
    PEA     2.W
    MOVE.L  D0,-(A7)
    JSR     LAB_037E(PC)

    LEA     12(A7),A7
    MOVEA.L D0,A3
    MOVE.L  A3,D0
    BEQ.S   LAB_0368

    MOVEQ   #1,D6

LAB_0367:
    MOVEQ   #49,D0
    CMP.W   D0,D6
    BGE.S   LAB_0369

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    TST.L   56(A3,D0.L)
    BNE.S   LAB_0369

    ADDQ.W  #1,D6
    BRA.S   LAB_0367

LAB_0368:
    MOVEQ   #49,D6

LAB_0369:
    MOVEQ   #48,D0
    CMP.W   D0,D6
    BLE.S   LAB_036A

    MOVE.W  LAB_2270,D0
    MULU    #30,D0
    MOVE.L  #2880,D1
    SUB.L   D0,D1
    MOVE.L  D1,D5
    BRA.S   LAB_036B

LAB_036A:
    MOVEQ   #0,D0
    MOVE.B  498(A3),D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_0384(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D5

LAB_036B:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======

LAB_036C:
    LINK.W  A5,#-24
    MOVEM.L D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.W  18(A5),D7
    MOVE.L  20(A5),D6
    MOVE.L  24(A5),D5
    MOVEQ   #1,D0
    MOVE.L  D0,-4(A5)
    MOVEQ   #0,D0
    SUBA.L  A0,A0
    MOVE.L  D0,-12(A5)
    MOVE.L  D0,-8(A5)
    MOVE.L  A0,-20(A5)
    MOVE.L  A0,-16(A5)
    MOVE.L  A3,D0
    BEQ.W   LAB_0378

    MOVE.L  A2,D0
    BEQ.W   LAB_0378

    TST.W   D7
    BLE.W   LAB_0378

    TST.W   D7
    BLE.S   LAB_036D

    MOVEQ   #49,D0
    CMP.W   D0,D7
    BGE.S   LAB_036D

    MOVEQ   #0,D0
    MOVE.B  (A3),D0
    EXT.L   D0
    MOVE.L  D7,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_0384(PC)

    LEA     12(A7),A7
    MOVE.L  D0,-8(A5)
    BRA.S   LAB_036E

LAB_036D:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.W  LAB_2270,D1
    SUB.L   D1,D0
    MOVEQ   #30,D1
    JSR     JMP_TBL_LAB_1A06_2(PC)

    MOVE.L  D0,-8(A5)

LAB_036E:
    BTST    #4,27(A3)
    BEQ.S   LAB_0375

    MOVEA.L 48(A3),A0
    MOVE.L  A0,-16(A5)
    BEQ.S   LAB_0374

    CLR.L   -24(A5)

LAB_036F:
    MOVEA.L -16(A5),A0
    MOVE.W  36(A0),D0
    EXT.L   D0
    MOVE.L  -24(A5),D1
    CMP.L   D0,D1
    BGE.S   LAB_0371

    ASL.L   #2,D1
    MOVEA.L -16(A5),A1
    MOVEA.L 38(A1),A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-20(A5)
    MOVEA.L -20(A5),A0
    MOVE.W  (A0),D0
    CMP.W   D7,D0
    BNE.S   LAB_0370

    BRA.S   LAB_0371

LAB_0370:
    CLR.L   -20(A5)
    ADDQ.L  #1,-24(A5)
    BRA.S   LAB_036F

LAB_0371:
    TST.L   -20(A5)
    BEQ.S   LAB_0372

    MOVEA.L -20(A5),A0
    MOVE.L  26(A0),-12(A5)
    BRA.S   LAB_0373

LAB_0372:
    MOVEA.L -16(A5),A0
    MOVE.L  32(A0),D0
    MOVE.L  D0,-12(A5)

LAB_0373:
    MOVEQ   #-1,D0
    CMP.L   -12(A5),D0
    BNE.S   LAB_0376

    MOVE.L  D5,-12(A5)
    BRA.S   LAB_0376

LAB_0374:
    MOVE.L  D5,-12(A5)
    BRA.S   LAB_0376

LAB_0375:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A2,-(A7)
    BSR.W   LAB_0364

    ADDQ.W  #8,A7
    MOVE.L  -8(A5),D1
    SUB.L   D1,D0
    MOVE.L  D0,-12(A5)

LAB_0376:
    MOVE.L  -12(A5),D0
    TST.L   D0
    BMI.S   LAB_0377

    MOVE.L  -8(A5),D1
    CMP.L   D6,D1
    BGT.S   LAB_0377

    NEG.L   D0
    CMP.L   D0,D1
    BGE.S   LAB_0379

LAB_0377:
    MOVEQ   #0,D0
    MOVE.L  D0,-4(A5)
    BRA.S   LAB_0379

LAB_0378:
    MOVEQ   #0,D0
    MOVE.L  D0,-4(A5)

LAB_0379:
    MOVE.L  -4(A5),D0
    MOVEM.L (A7)+,D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

    LINK.W  A5,#-4
    MOVEM.L D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVEA.L 16(A5),A2
    MOVE.L  D7,D0
    EXT.L   D0
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_0347

    LEA     12(A7),A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.S   LAB_037B

    MOVEA.L A2,A0

LAB_037A:
    TST.B   (A0)+
    BNE.S   LAB_037A

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    MOVE.L  A0,D0
    MOVEA.L A2,A1
    ADDA.L  D0,A1
    MOVE.L  -4(A5),-(A7)
    PEA     LAB_1B82
    MOVE.L  A1,-(A7)
    JSR     JMP_TBL_PRINTF_1(PC)

    LEA     12(A7),A7

LAB_037B:
    MOVE.L  A2,D0
    MOVEM.L (A7)+,D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_037C:
    JMP     LAB_17E6

LAB_037D:
    JMP     LAB_149E

LAB_037E:
    JMP     LAB_0926

LAB_037F:
    JMP     LAB_0923

LAB_0380:
    JMP     LAB_0E2D

LAB_0381:
    JMP     LAB_149B

JMP_TBL_PRINTF_1:
    JMP     PRINTF

LAB_0383:
    JMP     LAB_1498

LAB_0384:
    JMP     LAB_16FF

LAB_0385:
    JMP     LAB_0B44
