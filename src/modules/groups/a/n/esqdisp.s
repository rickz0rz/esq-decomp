LAB_08BB:
    LINK.W  A5,#-4
    MOVEM.L D2/D7/A3,-(A7)
    MOVEA.L 24(A7),A3
    MOVEQ   #0,D0
    MOVE.W  LAB_222B,D0
    MOVEA.L A3,A0
    MOVE.L  D0,D2
    MOVEQ   #3,D0
    MOVE.L  #696,D1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitBitMap(A6)

    MOVEQ   #0,D7

LAB_08BC:
    MOVEQ   #3,D0
    CMP.L   D0,D7
    BGE.S   LAB_08BD

    MOVE.L  D7,D0
    ASL.L   #2,D0
    MOVEQ   #0,D1

    MOVE.W  LAB_222B,D1
    MOVE.L  D1,-(A7)                    ; Height
    PEA     696.W                       ; Width
    PEA     79.W                        ; Line Number
    PEA     GLOB_STR_ESQDISP_C          ; Calling File
    MOVE.L  D0,28(A7)
    JSR     JMPTBL_UNKNOWN2B_AllocRaster_2(PC)

    LEA     16(A7),A7
    MOVE.L  12(A7),D1
    MOVE.L  D0,8(A3,D1.L)
    MOVE.L  D7,D0
    ASL.L   #2,D0
    MOVE.W  LAB_222B,D1
    MULU    #$58,D1
    MOVE.L  D0,12(A7)
    MOVE.L  D1,D0
    MOVE.L  12(A7),D2
    MOVEA.L 8(A3,D2.L),A1
    MOVEQ   #0,D1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOBltClear(A6)

    ADDQ.L  #1,D7
    BRA.S   LAB_08BC

LAB_08BD:
    MOVEM.L (A7)+,D2/D7/A3
    UNLK    A5
    RTS

;!======

LAB_08BE:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEQ   #0,D7

LAB_08BF:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.S   LAB_08C0

    MOVE.L  D7,D0
    ADDQ.L  #4,D0
    MOVE.B  D0,55(A3,D7.L)
    ADDQ.L  #1,D7
    BRA.S   LAB_08BF

LAB_08C0:
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

LAB_08C1:
    LINK.W  A5,#-4
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2

    MOVE.B  #$5,8(A3)
    MOVE.W  #$a0,18(A3)
    MOVE.L  LAB_1DC6,14(A3)
    MOVE.L  8(A2),20(A3)
    MOVE.L  12(A2),24(A3)
    MOVE.L  16(A2),28(A3)
    CLR.W   52(A3)
    CLR.L   -(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_0AA9(PC)

    CLR.L   32(A3)
    MOVE.L  A3,(A7)
    BSR.S   LAB_08BE

    ADDQ.W  #8,A7
    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitRastPort(A6)

    MOVE.L  A2,64(A3)
    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVE.L  112(A3),-4(A5)
    MOVEA.L -4(A5),A0
    MOVE.B  #$1,55(A0)
    BSET    #0,53(A0)
    MOVEA.L A3,A1
    MOVEA.L LAB_1DC5,A0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOPutMsg(A6)

    MOVEM.L (A7)+,A2-A3
    UNLK    A5
    RTS

;!======

LAB_08C2:
    TST.W   LAB_1DF2
    BNE.S   LAB_08C3

    TST.W   LAB_2263
    BNE.S   LAB_08C3

    TST.L   LAB_2260
    BNE.S   LAB_08C3

    JSR     LAB_08E0(PC)

LAB_08C3:
    RTS

;!======

LAB_08C4:
    LINK.W  A5,#-20
    MOVEM.L D2-D7,-(A7)
    MOVE.L  8(A5),D7
    MOVE.L  12(A5),D6

    TST.L   D6
    BEQ.S   .LAB_08C5

    MOVEQ   #1,D0
    CMP.L   D0,D6
    BNE.W   .return

.LAB_08C5:
    TST.B   LAB_1DEE
    BEQ.S   .LAB_08C6

    MOVEQ   #-1,D0
    CMP.L   D0,D7
    BEQ.W   .return

    MOVE.L  D6,D1
    ASL.L   #2,D1
    LEA     LAB_1E80,A0
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    MOVE.L  D7,(A1)
    BRA.W   .return

.LAB_08C6:
    MOVEQ   #-1,D0
    CMP.L   D0,D7
    BNE.S   .LAB_08C7

    MOVE.L  D6,D1
    ASL.L   #2,D1
    LEA     LAB_1E80,A0
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    MOVE.L  (A1),D7
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    MOVE.L  D0,(A1)

.LAB_08C7:
    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     LAB_1E80,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  (A1),D1
    CMP.L   D7,D1
    BEQ.W   .return

    ADDA.L  D0,A0
    MOVE.L  D7,(A0)
    MOVE.L  #$28f,D4
    MOVEQ   #1,D0
    CMP.L   D0,D6
    BNE.S   .LAB_08C8

    MOVEQ   #40,D0
    MOVE.L  D0,-16(A5)
    BRA.S   .LAB_08C9

.LAB_08C8:
    MOVEQ   #57,D0
    MOVE.L  D0,-16(A5)

.LAB_08C9:
    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.B  25(A0),D5
    EXT.W   D5
    EXT.L   D5
    MOVE.L  4(A0),-4(A5)
    MOVE.L  #GLOB_REF_696_400_BITMAP,4(A0)
    MOVEQ   #7,D0
    CMP.L   D0,D7
    BEQ.S   .readPixelAt655x55

    MOVEQ   #6,D0
    CMP.L   D0,D7
    BNE.S   .LAB_08CB

.readPixelAt655x55:
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVE.L  #655,D0
    MOVEQ   #55,D1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOReadPixel(A6)

    MOVE.L  D0,D7

.LAB_08CB:
    MOVE.L  D7,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVE.L  D4,D0
    ADDQ.L  #6,D0
    MOVE.L  -16(A5),D1
    MOVE.L  D1,D2
    ADDQ.L  #4,D2
    MOVE.L  D0,24(A7)
    MOVE.L  D4,D0
    MOVE.L  D2,D3
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVE.L  24(A7),D2
    JSR     _LVORectFill(A6)

    MOVE.L  D5,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  -4(A5),4(A0)

.return:
    MOVEM.L (A7)+,D2-D7
    UNLK    A5
    RTS

;!======

LAB_08CD:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7
    MOVEQ   #-1,D0
    CMP.L   D0,D7
    BNE.S   LAB_08CE

    PEA     1.W
    MOVE.L  D0,-(A7)
    BSR.W   LAB_08C4

    ADDQ.W  #8,A7
    BRA.S   LAB_08D1

LAB_08CE:
    BTST    #4,D7
    BEQ.S   LAB_08D0

    BTST    #5,D7
    BEQ.S   LAB_08CF

    PEA     1.W
    PEA     4.W
    BSR.W   LAB_08C4

    ADDQ.W  #8,A7
    BRA.S   LAB_08D1

LAB_08CF:
    PEA     1.W
    PEA     2.W
    BSR.W   LAB_08C4

    ADDQ.W  #8,A7
    BRA.S   LAB_08D1

LAB_08D0:
    PEA     1.W
    PEA     7.W
    BSR.W   LAB_08C4

    ADDQ.W  #8,A7

LAB_08D1:
    MOVEQ   #-1,D0
    CMP.L   D0,D7
    BNE.S   LAB_08D2

    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    BSR.W   LAB_08C4

    ADDQ.W  #8,A7
    BRA.W   LAB_08D9

LAB_08D2:
    BTST    #8,D7
    BEQ.S   LAB_08D3

    CLR.L   -(A7)
    PEA     4.W
    BSR.W   LAB_08C4

    ADDQ.W  #8,A7
    BRA.S   LAB_08D9

LAB_08D3:
    BTST    #0,D7
    BEQ.S   LAB_08D6

    BTST    #2,D7
    BEQ.S   LAB_08D4

    CLR.L   -(A7)
    PEA     4.W
    BSR.W   LAB_08C4

    ADDQ.W  #8,A7
    BRA.S   LAB_08D9

LAB_08D4:
    BTST    #1,D7
    BEQ.S   LAB_08D5

    CLR.L   -(A7)
    PEA     2.W
    BSR.W   LAB_08C4

    ADDQ.W  #8,A7
    BRA.S   LAB_08D9

LAB_08D5:
    CLR.L   -(A7)
    PEA     1.W
    BSR.W   LAB_08C4

    ADDQ.W  #8,A7
    BRA.S   LAB_08D9

LAB_08D6:
    BTST    #2,D7
    BEQ.S   LAB_08D7

    CLR.L   -(A7)
    PEA     3.W
    BSR.W   LAB_08C4

    ADDQ.W  #8,A7
    BRA.S   LAB_08D9

LAB_08D7:
    BTST    #1,D7
    BEQ.S   LAB_08D8

    CLR.L   -(A7)
    PEA     3.W
    BSR.W   LAB_08C4

    ADDQ.W  #8,A7
    BRA.S   LAB_08D9

LAB_08D8:
    CLR.L   -(A7)
    PEA     7.W
    BSR.W   LAB_08C4

    ADDQ.W  #8,A7

LAB_08D9:
    MOVE.L  (A7)+,D7
    RTS

;!======

LAB_08DA:
    MOVEM.L D5-D7,-(A7)
    MOVE.L  16(A7),D7
    MOVE.L  20(A7),D6
    MOVEQ   #-1,D5
    MOVE.L  LAB_1E81,D5
    TST.L   D6
    BEQ.S   LAB_08DB

    OR.L    D7,LAB_1E81
    BRA.S   LAB_08DC

LAB_08DB:
    MOVE.L  D7,D0
    NOT.L   D0
    AND.L   D0,LAB_1E81

LAB_08DC:
    ANDI.L  #$fff,LAB_1E81
    MOVE.L  LAB_1E81,D0
    CMP.L   D0,D5
    BEQ.S   LAB_08DD

    MOVE.L  D0,-(A7)
    BSR.W   LAB_08CD

    ADDQ.W  #4,A7

LAB_08DD:
    MOVEM.L (A7)+,D5-D7
    RTS

;!======

LAB_08DE:
    PEA     -1.W
    BSR.W   LAB_08CD

    ADDQ.W  #4,A7
    RTS

;!======

LAB_08DF:
    MOVEM.L D5-D7,-(A7)
    MOVE.W  18(A7),D7
    MOVE.B  23(A7),D6
    MOVE.L  D7,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  D6,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     DST_BuildBannerTimeWord(PC)

    MOVE.L  D0,D1
    EXT.L   D1
    ADD.L   D1,D1
    MOVE.L  D7,D0
    EXT.L   D0
    ADD.L   D1,D0
    MOVE.L  D0,D5
    MOVE.L  D5,D0
    EXT.L   D0
    PEA     48.W
    PEA     1.W
    MOVE.L  D0,-(A7)
    JSR     LAB_055F(PC)

    LEA     20(A7),A7
    MOVE.L  D0,D5
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D5-D7
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

LAB_08E0:
    JMP     LAB_100D

JMPTBL_UNKNOWN2B_AllocRaster_2:
    JMP     UNKNOWN2B_AllocRaster

;!======

LAB_08E2:
    MOVEM.L D4-D7/A2-A3,-(A7)
    MOVEA.L 28(A7),A3
    MOVE.B  35(A7),D7
    MOVE.W  38(A7),D6
    MOVE.B  43(A7),D5
    MOVE.B  47(A7),D4
    MOVEA.L 48(A7),A2
    MOVE.L  A3,D0
    BEQ.S   LAB_08E3

    MOVE.B  D7,40(A3)
    MOVE.W  D6,46(A3)
    MOVE.B  D5,41(A3)
    MOVE.B  D4,42(A3)
    LEA     43(A3),A0
    PEA     2.W
    MOVE.L  A2,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_09C1(PC)

    LEA     12(A7),A7
    CLR.B   45(A3)

LAB_08E3:
    MOVEM.L (A7)+,D4-D7/A2-A3
    RTS

;!======

LAB_08E4:
    LINK.W  A5,#-40
    MOVEM.L D2-D3/D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEQ   #0,D6
    MOVE.B  (A3)+,D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #0,D1
    NOT.B   D1
    AND.L   D1,D0
    MOVEQ   #0,D1
    MOVE.B  LAB_222D,D1
    MOVE.L  D0,-16(A5)
    CMP.L   D0,D1
    BNE.S   LAB_08E5

    MOVE.B  LAB_222E,D1
    SUBQ.B  #1,D1
    BNE.S   LAB_08E5

    MOVEQ   #0,D6
    MOVE.W  LAB_222F,D6
    MOVE.L  #LAB_2235,-40(A5)
    BRA.S   LAB_08E6

LAB_08E5:
    MOVEQ   #0,D1
    MOVE.B  LAB_2230,D1
    CMP.L   D1,D0
    BNE.S   LAB_08E6

    MOVEQ   #0,D6
    MOVE.W  LAB_2231,D6
    MOVE.L  #LAB_2233,-40(A5)       ; A5 is some struct, what's at -40(A5)?

LAB_08E6:
    MOVE.B  (A3),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #2,(A1)
    BEQ.S   LAB_08E7

    MOVE.B  (A3),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVEQ   #10,D1
    JSR     GROUPB_JMPTBL_MATH_Mulu32(PC)

    BRA.S   LAB_08E8

LAB_08E7:
    MOVEQ   #0,D0

LAB_08E8:
    MOVE.L  D0,D5
    ADDQ.L  #1,A3
    MOVE.B  (A3),D0
    EXT.W   D0
    EXT.L   D0
    ADDA.L  D0,A0
    BTST    #2,(A0)
    BEQ.S   LAB_08E9

    MOVE.B  (A3),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    BRA.S   LAB_08EA

LAB_08E9:
    MOVEQ   #0,D0

LAB_08EA:
    ADD.L   D0,D5
    ADDQ.L  #1,A3
    TST.L   D6
    BLE.W   LAB_0919

    MOVEQ   #6,D0
    CMP.L   D0,D5
    BLT.W   LAB_0919

    CLR.B   -25(A5)

LAB_08EB:
    MOVEQ   #18,D0
    CMP.B   (A3),D0
    BNE.W   LAB_0919

    ADDQ.L  #1,A3
    MOVE.L  A3,-20(A5)
    CLR.L   -24(A5)
    MOVEQ   #0,D7

LAB_08EC:
    MOVEQ   #6,D0
    CMP.L   D0,D7
    BGE.S   LAB_08EE

    ADDQ.L  #1,A3
    MOVEQ   #4,D0
    CMP.B   (A3),D0
    BNE.S   LAB_08ED

    CLR.B   (A3)+
    MOVE.L  A3,-24(A5)
    ADDA.L  D5,A3
    BRA.S   LAB_08EE

LAB_08ED:
    ADDQ.L  #1,D7
    BRA.S   LAB_08EC

LAB_08EE:
    TST.L   -24(A5)
    BEQ.S   LAB_08EB

    MOVEQ   #0,D7

LAB_08EF:
    CMP.L   D6,D7
    BGE.S   LAB_08EB

    MOVE.L  D7,D0
    ASL.L   #2,D0
    MOVEA.L -40(A5),A0
    MOVEA.L 0(A0,D0.L),A0
    LEA     12(A0),A1
    MOVEA.L -20(A5),A0

LAB_08F0:
    MOVE.B  (A1)+,D0
    CMP.B   (A0)+,D0
    BNE.W   LAB_0918

    TST.B   D0
    BNE.S   LAB_08F0

    BNE.W   LAB_0918

    MOVE.L  D7,D0
    ASL.L   #2,D0
    MOVEA.L -40(A5),A0
    MOVE.L  0(A0,D0.L),-36(A5)
    MOVEA.L -36(A5),A0
    MOVE.B  40(A0),D0
    MOVE.W  46(A0),-32(A5)
    MOVE.B  D0,-28(A5)
    TST.L   D5
    BLE.S   LAB_08F4

    MOVEA.L -24(A5),A0
    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    MOVEA.L A1,A2
    ADDA.L  D0,A2
    BTST    #1,(A2)
    BEQ.S   LAB_08F1

    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   LAB_08F2

LAB_08F1:
    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0

LAB_08F2:
    MOVEQ   #89,D1
    CMP.L   D1,D0
    BNE.S   LAB_08F3

    BSET    #1,-28(A5)
    BRA.S   LAB_08F4

LAB_08F3:
    BCLR    #1,-28(A5)

LAB_08F4:
    MOVEQ   #1,D0
    CMP.L   D0,D5
    BLE.S   LAB_08F8

    MOVEA.L -24(A5),A0
    MOVE.B  1(A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    MOVEA.L A1,A2
    ADDA.L  D0,A2
    BTST    #1,(A2)
    BEQ.S   LAB_08F5

    MOVE.B  1(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   LAB_08F6

LAB_08F5:
    MOVE.B  1(A0),D0
    EXT.W   D0
    EXT.L   D0

LAB_08F6:
    MOVEQ   #89,D1
    CMP.L   D1,D0
    BNE.S   LAB_08F7

    BSET    #2,-28(A5)
    BRA.S   LAB_08F8

LAB_08F7:
    BCLR    #2,-28(A5)

LAB_08F8:
    MOVEQ   #2,D0
    CMP.L   D0,D5
    BLE.S   LAB_08F9

    MOVEA.L -24(A5),A0
    MOVE.B  2(A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #7,(A1)
    BEQ.S   LAB_08F9

    MOVE.B  2(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_09B2(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    BRA.S   LAB_08FA

LAB_08F9:
    MOVEQ   #0,D1
    NOT.B   D1

LAB_08FA:
    MOVE.B  D1,-29(A5)
    MOVEQ   #0,D0
    CMP.B   D0,D1
    BCS.S   LAB_08FB

    MOVEQ   #15,D0
    CMP.B   D0,D1
    BLS.S   LAB_08FC

LAB_08FB:
    MOVE.B  #$ff,-29(A5)

LAB_08FC:
    MOVEQ   #3,D0
    CMP.L   D0,D5
    BLE.S   LAB_08FD

    MOVEA.L -24(A5),A0
    MOVE.B  3(A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #7,(A1)
    BEQ.S   LAB_08FD

    MOVE.B  3(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_09B2(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    BRA.S   LAB_08FE

LAB_08FD:
    MOVEQ   #0,D1
    NOT.B   D1

LAB_08FE:
    MOVE.B  D1,-30(A5)
    MOVEQ   #1,D0
    CMP.B   D0,D1
    BCS.S   LAB_08FF

    MOVEQ   #3,D0
    CMP.B   D0,D1
    BLS.S   LAB_0900

LAB_08FF:
    MOVE.B  #$ff,-30(A5)

LAB_0900:
    MOVEQ   #5,D0
    CMP.L   D0,D5
    BLE.S   LAB_0901

    MOVEA.L -24(A5),A0
    ADDQ.L  #4,A0
    PEA     2.W
    MOVE.L  A0,-(A7)
    PEA     -27(A5)
    JSR     LAB_09C1(PC)

    LEA     12(A7),A7
    BRA.S   LAB_0903

LAB_0901:
    LEA     LAB_1E8A,A0
    LEA     -27(A5),A1

LAB_0902:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_0902

LAB_0903:
    MOVEQ   #6,D0
    CMP.L   D0,D5
    BLE.S   LAB_0907

    MOVEA.L -24(A5),A0
    MOVE.B  6(A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    MOVEA.L A1,A2
    ADDA.L  D0,A2
    BTST    #1,(A2)
    BEQ.S   LAB_0904

    MOVE.B  6(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   LAB_0905

LAB_0904:
    MOVE.B  6(A0),D0
    EXT.W   D0
    EXT.L   D0

LAB_0905:
    MOVEQ   #89,D1
    CMP.L   D1,D0
    BNE.S   LAB_0906

    BSET    #0,-31(A5)
    BRA.S   LAB_0907

LAB_0906:
    BCLR    #0,-31(A5)

LAB_0907:
    MOVEQ   #7,D0
    CMP.L   D0,D5
    BLE.S   LAB_090B

    MOVEA.L -24(A5),A0
    MOVE.B  7(A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    MOVEA.L A1,A2
    ADDA.L  D0,A2
    BTST    #1,(A2)
    BEQ.S   LAB_0908

    MOVE.B  7(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   LAB_0909

LAB_0908:
    MOVE.B  7(A0),D0
    EXT.W   D0
    EXT.L   D0

LAB_0909:
    MOVEQ   #89,D1
    CMP.L   D1,D0
    BNE.S   LAB_090A

    BSET    #1,-31(A5)
    BRA.S   LAB_090B

LAB_090A:
    BCLR    #1,-31(A5)

LAB_090B:
    MOVEQ   #8,D0
    CMP.L   D0,D5
    BLE.S   LAB_090F

    MOVEA.L -24(A5),A0
    MOVE.B  8(A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    MOVEA.L A1,A2
    ADDA.L  D0,A2
    BTST    #1,(A2)
    BEQ.S   LAB_090C

    MOVE.B  8(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   LAB_090D

LAB_090C:
    MOVE.B  8(A0),D0
    EXT.W   D0
    EXT.L   D0

LAB_090D:
    MOVEQ   #89,D1
    CMP.L   D1,D0
    BNE.S   LAB_090E

    BSET    #2,-31(A5)
    BRA.S   LAB_090F

LAB_090E:
    BCLR    #2,-31(A5)

LAB_090F:
    MOVEQ   #9,D0
    CMP.L   D0,D5
    BLE.S   LAB_0913

    MOVEA.L -24(A5),A0
    MOVE.B  9(A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    MOVEA.L A1,A2
    ADDA.L  D0,A2
    BTST    #1,(A2)
    BEQ.S   LAB_0910

    MOVE.B  9(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   LAB_0911

LAB_0910:
    MOVE.B  9(A0),D0
    EXT.W   D0
    EXT.L   D0

LAB_0911:
    MOVEQ   #89,D1
    CMP.L   D1,D0
    BNE.S   LAB_0912

    BSET    #3,-31(A5)
    BRA.S   LAB_0913

LAB_0912:
    BCLR    #3,-31(A5)

LAB_0913:
    MOVEQ   #10,D0
    CMP.L   D0,D5
    BLE.S   LAB_0917

    MOVEA.L -24(A5),A0
    MOVE.B  10(A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #1,(A1)
    BEQ.S   LAB_0914

    MOVE.B  10(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   LAB_0915

LAB_0914:
    MOVE.B  10(A0),D0
    EXT.W   D0
    EXT.L   D0

LAB_0915:
    MOVEQ   #89,D1
    CMP.L   D1,D0
    BNE.S   LAB_0916

    BSET    #4,-31(A5)
    BRA.S   LAB_0917

LAB_0916:
    BCLR    #4,-31(A5)

LAB_0917:
    MOVEQ   #0,D0
    MOVE.B  -28(A5),D0
    MOVEQ   #0,D1
    MOVE.W  -32(A5),D1
    MOVEQ   #0,D2
    MOVE.B  -29(A5),D2
    MOVEQ   #0,D3
    MOVE.B  -30(A5),D3
    PEA     -27(A5)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -36(A5),-(A7)
    BSR.W   LAB_08E2

    LEA     24(A7),A7

LAB_0918:
    ADDQ.L  #1,D7
    BRA.W   LAB_08EF

LAB_0919:
    MOVEM.L (A7)+,D2-D3/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_091A:
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVE.W  22(A7),D7

    MOVEQ   #0,D6
    TST.W   D7
    BLE.S   LAB_091E

    MOVEQ   #49,D0
    CMP.W   D0,D7
    BGE.S   LAB_091E

    MOVE.L  A3,D0
    BEQ.S   LAB_091E

    BTST    #4,7(A3,D7.W)
    BNE.S   LAB_091C

    MOVE.L  D7,D0
    ADDI.W  #$fc,D0
    CMPI.B  #$5,0(A3,D0.W)
    BCS.S   LAB_091B

    MOVE.L  D7,D0
    ADDI.W  #$fc,D0
    CMPI.B  #$a,0(A3,D0.W)
    BLS.S   LAB_091C

LAB_091B:
    MOVEQ   #0,D0
    BRA.S   LAB_091D

LAB_091C:
    MOVEQ   #1,D0

LAB_091D:
    MOVE.L  D0,D6

LAB_091E:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======

LAB_091F:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3

    MOVEQ   #0,D7
    MOVE.L  A3,D0
    BEQ.S   .return

    BTST    #0,40(A3)
    BEQ.S   .LAB_0920

    BTST    #2,40(A3)
    BEQ.S   .LAB_0920

    MOVEQ   #1,D0
    BRA.S   .LAB_0921

.LAB_0920:
    MOVEQ   #0,D0

.LAB_0921:
    MOVE.L  D0,D7

.return:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

LAB_0923:
    LINK.W  A5,#-4
    MOVEM.L D6-D7,-(A7)
    MOVE.L  8(A5),D7
    MOVE.L  12(A5),D6
    CLR.L   -4(A5)

    MOVEQ   #1,D0
    CMP.L   D0,D6
    BNE.S   .LAB_0924

    TST.L   D7
    BMI.S   .return

    MOVEQ   #0,D0
    MOVE.W  LAB_2231,D0
    CMP.L   D0,D7
    BGE.S   .return

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2233,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    BRA.S   .return

.LAB_0924:
    MOVEQ   #2,D0
    CMP.L   D0,D6
    BNE.S   .return

    TST.L   D7
    BMI.S   .return

    MOVEQ   #0,D0
    MOVE.W  LAB_222F,D0
    CMP.L   D0,D7
    BGE.S   .return

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2235,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  A1,-4(A5)

.return:
    MOVE.L  -4(A5),D0
    MOVEM.L (A7)+,D6-D7
    UNLK    A5
    RTS

;!======

LAB_0926:
    LINK.W  A5,#-4
    MOVEM.L D6-D7,-(A7)
    MOVE.L  8(A5),D7
    MOVE.L  12(A5),D6
    CLR.L   -4(A5)

    MOVEQ   #1,D0
    CMP.L   D0,D6
    BNE.S   .LAB_0927

    TST.L   D7
    BMI.S   .return

    MOVEQ   #0,D0
    MOVE.W  LAB_2231,D0
    CMP.L   D0,D7
    BGE.S   .return

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2236,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    BRA.S   .return

.LAB_0927:
    MOVEQ   #2,D0
    CMP.L   D0,D6
    BNE.S   .return

    TST.L   D7
    BMI.S   .return

    MOVEQ   #0,D0
    MOVE.W  LAB_222F,D0
    CMP.L   D0,D7
    BGE.S   .return

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2237,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  A1,-4(A5)

.return:
    MOVE.L  -4(A5),D0
    MOVEM.L (A7)+,D6-D7
    UNLK    A5
    RTS

;!======

; Unreferenced Code
    MOVE.L  D7,-(A7)
    MOVE.W  10(A7),D7

    MOVEQ   #23,D1
    CMP.W   D1,D7
    SGT     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0

    MOVE.L  (A7)+,D7
    RTS

;!======

; Unreferenced Code
    MOVEM.L D5-D7,-(A7)
    MOVE.W  18(A7),D7
    MOVE.W  22(A7),D6

    MOVEQ   #-1,D0
    CMP.W   D0,D6
    BNE.S   .LAB_0929

    CMPI.W  #$16e,D7
    BLE.S   .LAB_0929

    MOVEQ   #1,D5
    BRA.S   .LAB_092B

.LAB_0929:
    TST.W   D6
    BNE.S   .LAB_092A

    CMPI.W  #$16d,D7
    BLE.S   .LAB_092A

    MOVEQ   #1,D5
    BRA.S   .LAB_092B

.LAB_092A:
    MOVEQ   #0,D5

.LAB_092B:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D5-D7
    RTS

;!======

; Unreferenced Code
    MOVE.L  D7,-(A7)
    MOVE.W  10(A7),D7

    TST.W   D7
    SMI     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0

    MOVE.L  (A7)+,D7
    RTS

;!======

; Unreferenced Code
    MOVE.L  D7,-(A7)
    MOVE.W  10(A7),D7

    MOVEQ   #1,D1
    CMP.W   D1,D7
    SLT     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0

    MOVE.L  (A7)+,D7
    RTS

;!======

LAB_092C:
    LINK.W  A5,#-8
    MOVE.L  D7,-(A7)
    MOVE.W  #(-1),LAB_234A
    MOVE.L  #$bfd0ee,-6(A5) ; ??, between PRA_CIAB and PRB_CIAB
    MOVEQ   #4,D7
    MOVEA.L -6(A5),A0
    AND.B   (A0),D7
    MOVE.B  LAB_1E8B,D0
    CMP.B   D7,D0
    BEQ.S   .LAB_092D

    ADDQ.L  #1,LAB_1E8C
    BRA.S   .LAB_092E

.LAB_092D:
    MOVEQ   #0,D0
    MOVE.L  D0,LAB_1E8C

.LAB_092E:
    CMPI.L  #$5,LAB_1E8C
    BLE.S   .return

    MOVE.L  D7,D0
    MOVE.B  D0,LAB_1E8B
    MOVEQ   #0,D1
    MOVE.L  D1,LAB_1E8C
    TST.B   D0
    BNE.S   .LAB_092F

    MOVE.L  D1,-(A7)
    JSR     LAB_09A7(PC)

    ADDQ.W  #4,A7
    BRA.S   .return

.LAB_092F:
    JSR     LAB_09B0(PC)

.return:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======

LAB_0931:
    LINK.W  A5,#-4
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  A3,-(A7)
    PEA     LAB_223A
    JSR     LAB_09BA(PC)

    PEA     LAB_21DF
    JSR     DST_UpdateBannerQueue(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .LAB_0932

    JSR     DST_RefreshBannerBuffer(PC)

.LAB_0932:
    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  4(A0),-4(A5)
    MOVE.L  #GLOB_REF_696_400_BITMAP,4(A0)
    JSR     ESQFUNC_JMPTBL_CLEANUP_DrawClockBanner(PC)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  -4(A5),4(A0)
    PEA     1.W
    BSR.W   LAB_0933

    MOVEA.L -8(A5),A3
    UNLK    A5
    RTS

;!======

; Draw the status banner into rastport 1 (with optional highlight).
ESQDISP_DrawStatusBanner:
LAB_0933:
    LINK.W  A5,#-4
    MOVEM.L D2-D3/D5-D7/A2,-(A7)
    MOVE.W  38(A7),D7
    MOVEQ   #0,D5
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    PEA     LAB_223A
    JSR     LAB_09B4(PC)

    ADDQ.W  #4,A7
    MOVE.W  D0,LAB_2270
    TST.W   LAB_1E85
    BEQ.S   LAB_0934

    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVEQ   #0,D0
    MOVE.B  LAB_1DC8,D0
    MOVEQ   #0,D2
    MOVE.B  LAB_1DC9,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    JSR     LAB_09AB(PC)

    LEA     12(A7),A7

LAB_0934:
    JSR     LAB_09B7(PC)

    TST.W   D7
    BEQ.S   LAB_0935

    MOVEQ   #1,D0
    MOVE.W  D0,LAB_1B08

LAB_0935:
    MOVE.W  LAB_2270,D0
    MOVEQ   #2,D1
    CMP.W   D1,D0
    BCS.S   LAB_0937

    MOVEQ   #39,D1
    CMP.W   D1,D0
    BCC.S   LAB_0937

    MOVE.W  LAB_2242,D1
    EXT.L   D1
    MOVEQ   #0,D2
    NOT.B   D2
    AND.L   D2,D1
    MOVE.B  D1,LAB_2230
    MOVE.W  LAB_223C,D0
    MOVEQ   #31,D3
    CMP.W   D3,D0
    BNE.S   LAB_0936

    MOVE.W  LAB_223B,D0
    MOVEQ   #11,D3
    CMP.W   D3,D0
    BNE.S   LAB_0936

    MOVE.B  #$1,LAB_222D
    BRA.S   LAB_093A

LAB_0936:
    MOVEQ   #0,D0
    MOVE.B  D1,D0
    ADDQ.L  #1,D0
    AND.L   D2,D0
    MOVE.B  D0,LAB_222D
    BRA.S   LAB_093A

LAB_0937:
    MOVE.W  LAB_2242,D1
    EXT.L   D1
    MOVEQ   #0,D2
    NOT.B   D2
    AND.L   D2,D1
    MOVE.B  D1,LAB_222D
    MOVE.W  LAB_2242,D0
    SUBQ.W  #1,D0
    BNE.S   LAB_0939

    MOVE.W  LAB_223D,D0
    EXT.L   D0
    SUBQ.L  #1,D0
    MOVEQ   #3,D1
    AND.L   D1,D0
    BNE.S   LAB_0938

    MOVE.B  #$6e,LAB_2230
    BRA.S   LAB_093A

LAB_0938:
    MOVE.B  #$6d,LAB_2230
    BRA.S   LAB_093A

LAB_0939:
    MOVE.W  LAB_2242,D0
    EXT.L   D0
    SUBQ.L  #1,D0
    AND.L   D2,D0
    MOVE.B  D0,LAB_2230

LAB_093A:
    MOVE.W  LAB_2241,D0
    MOVE.W  LAB_1E8D,D1
    CMP.W   D0,D1
    BEQ.S   LAB_093C

    MOVE.W  D0,LAB_1E8D
    SUBQ.W  #1,D0
    BNE.S   LAB_093C

    MOVE.W  LAB_2270,D0
    SUBQ.W  #3,D0
    BNE.S   LAB_093B

    MOVEQ   #0,D0
    MOVE.W  D0,LAB_1E8E
    BRA.S   LAB_093C

LAB_093B:
    MOVE.W  LAB_2270,D0
    MOVEQ   #46,D1
    CMP.W   D1,D0
    BNE.S   LAB_093C

    CLR.W   LAB_1E8F

LAB_093C:
    MOVEQ   #0,D6

LAB_093D:
    TST.L   D5
    BNE.S   LAB_0941

    MOVEQ   #4,D0
    CMP.L   D0,D6
    BGE.S   LAB_0941

    MOVE.L  D6,D0
    MOVEQ   #20,D1
    JSR     GROUPB_JMPTBL_MATH_Mulu32(PC)

    LEA     LAB_2197,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    TST.L   16(A1)
    BNE.S   LAB_093E

    MOVE.W  LAB_227C,D1
    EXT.L   D1
    ADD.L   D6,D1
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    CMP.L   (A1),D1
    BEQ.S   LAB_093F

LAB_093E:
    MOVE.W  LAB_227C,D0
    EXT.L   D0
    ADD.L   D6,D0
    MOVE.L  D0,24(A7)
    MOVE.L  D6,D0
    MOVEQ   #20,D1
    JSR     GROUPB_JMPTBL_MATH_Mulu32(PC)

    ADDA.L  D0,A0
    MOVE.L  24(A7),D0
    ADDI.L  #$100,D0
    CMP.L   (A0),D0
    BEQ.S   LAB_093F

    MOVEQ   #0,D0
    BRA.S   LAB_0940

LAB_093F:
    MOVEQ   #1,D0

LAB_0940:
    MOVE.L  D0,D5
    ADDQ.L  #1,D6
    BRA.S   LAB_093D

LAB_0941:
    TST.L   D5
    BEQ.S   LAB_0945

    LEA     LAB_2198,A0
    MOVEA.L A0,A1
    LEA     LAB_2197,A2
    MOVEQ   #4,D0

LAB_0942:
    MOVE.L  (A1)+,(A2)+
    DBF     D0,LAB_0942
    LEA     LAB_2199,A0
    MOVEA.L A0,A1
    LEA     LAB_2198,A2
    MOVEQ   #4,D0

LAB_0943:
    MOVE.L  (A1)+,(A2)+
    DBF     D0,LAB_0943
    LEA     LAB_219A,A0
    LEA     LAB_2199,A1
    MOVEQ   #4,D0

LAB_0944:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,LAB_0944
    MOVEQ   #1,D0
    MOVE.L  D0,LAB_219B

LAB_0945:
    MOVE.W  LAB_2270,D0
    SUBQ.W  #1,D0
    BNE.S   LAB_0946

    MOVEQ   #0,D0
    MOVE.W  D0,LAB_1E8E

LAB_0946:
    MOVE.W  LAB_2270,D0
    MOVEQ   #2,D1
    CMP.W   D1,D0
    BCS.S   LAB_0947

    TST.W   LAB_1E8E
    BNE.S   LAB_0947

    MOVEQ   #1,D1
    MOVE.L  D1,LAB_1E88
    MOVE.W  #1,LAB_1E8E

LAB_0947:
    MOVEQ   #44,D1
    CMP.W   D1,D0
    BNE.S   LAB_0948

    MOVEQ   #0,D1
    MOVE.W  D1,LAB_1E8F

LAB_0948:
    MOVEQ   #45,D1
    CMP.W   D1,D0
    BCS.S   LAB_0949

    TST.W   LAB_1E8F
    BNE.S   LAB_0949

    BSR.W   LAB_094F

    JSR     LAB_09AF(PC)

    JSR     LAB_09B8(PC)

    MOVE.W  #1,LAB_1E8F

LAB_0949:
    MOVEM.L (A7)+,D2-D3/D5-D7/A2
    UNLK    A5
    RTS

;!======

LAB_094A:
    LINK.W  A5,#-12
    MOVEM.L D2-D3/D7/A2-A3/A6,-(A7)
    MOVE.W  LAB_222F,D0
    BNE.W   LAB_094D

    MOVEQ   #0,D7

LAB_094B:
    MOVEQ   #0,D0
    MOVE.W  LAB_2231,D0
    CMP.L   D0,D7
    BGE.W   LAB_094C

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2233,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    MOVEQ   #0,D0
    MOVE.B  LAB_222D,D0
    MOVEQ   #0,D1
    MOVEA.L -4(A5),A0
    MOVE.B  27(A0),D1
    LEA     12(A0),A1
    LEA     1(A0),A2
    LEA     28(A0),A3
    LEA     19(A0),A6
    MOVE.L  A6,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_0C1E(PC)

    MOVE.W  LAB_222F,D0
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ASL.L   #2,D1
    LEA     LAB_2234,A0
    ADDA.L  D1,A0
    MOVEA.L (A0),A1
    MOVEQ   #0,D0
    MOVEA.L -4(A5),A0
    MOVE.B  40(A0),D0
    ANDI.W  #$ff7f,D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #0,D0
    MOVE.W  46(A0),D0
    MOVEQ   #0,D2
    MOVE.B  41(A0),D2
    MOVEQ   #0,D3
    MOVE.B  42(A0),D3
    LEA     43(A0),A2
    MOVE.L  A2,(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A1,-8(A5)
    BSR.W   LAB_08E2

    LEA     44(A7),A7
    ADDQ.L  #1,D7
    BRA.W   LAB_094B

LAB_094C:
    MOVE.W  #1,LAB_1E87
    BRA.S   LAB_094E

LAB_094D:
    CLR.W   LAB_1E87

LAB_094E:
    MOVEM.L (A7)+,D2-D3/D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

LAB_094F:
    LINK.W  A5,#-40
    MOVEM.L D2-D7/A2-A3/A6,-(A7)
    MOVE.W  LAB_2231,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.W   LAB_0958

    MOVE.W  LAB_222F,D0
    CMP.W   D1,D0
    BLS.W   LAB_0958

    MOVEQ   #0,D7

LAB_0950:
    MOVEQ   #0,D0
    MOVE.W  LAB_222F,D0
    CMP.L   D0,D7
    BGE.W   LAB_0958

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2237,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    TST.L   60(A1)
    BNE.W   LAB_0957

    LEA     LAB_2235,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    LEA     28(A1),A0
    PEA     1.W
    MOVE.L  A0,-(A7)
    JSR     GROUPB_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.W   LAB_0957

    MOVEQ   #0,D4
    MOVEQ   #0,D6

LAB_0951:
    MOVEQ   #0,D0
    MOVE.W  LAB_2231,D0
    CMP.L   D0,D6
    BGE.W   LAB_0957

    TST.L   D4
    BNE.W   LAB_0957

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2237,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     LAB_2236,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A2
    MOVE.L  A2,-(A7)
    MOVE.L  A1,-(A7)
    JSR     GROUPB_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.W   LAB_0956

    MOVEQ   #48,D5
    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     LAB_2233,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    BTST    #5,27(A1)
    BEQ.S   LAB_0952

    MOVEQ   #0,D0
    BRA.S   LAB_0953

LAB_0952:
    MOVEQ   #44,D0

LAB_0953:
    MOVE.L  D0,-20(A5)

LAB_0954:
    CMP.L   -20(A5),D5
    BLE.W   LAB_0956

    TST.L   D4
    BNE.W   LAB_0956

    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     LAB_2233,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    LEA     28(A1),A0
    MOVE.L  D5,-(A7)
    MOVE.L  A0,-(A7)
    JSR     GROUPB_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.W   LAB_0955

    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     LAB_2236,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A2
    MOVE.L  D5,D1
    ASL.L   #2,D1
    ADDA.L  D1,A2
    TST.L   56(A2)
    BEQ.W   LAB_0955

    MOVE.L  D7,D2
    ASL.L   #2,D2
    LEA     LAB_2237,A1
    MOVEA.L A1,A2
    ADDA.L  D2,A2
    MOVEA.L (A2),A3
    MOVEA.L A0,A2
    ADDA.L  D0,A2
    MOVEA.L (A2),A6
    ADDA.L  D5,A6
    MOVEQ   #0,D3
    MOVE.B  7(A6),D3
    ORI.W   #$80,D3
    MOVE.B  D3,8(A3)
    MOVEA.L A1,A2
    ADDA.L  D2,A2
    MOVEA.L (A2),A3
    ADDA.L  D0,A0
    MOVEA.L (A0),A2
    ADDA.L  D1,A2
    ADDA.L  D2,A1
    MOVEA.L (A1),A0
    MOVE.L  60(A0),-(A7)
    MOVE.L  56(A2),-(A7)
    MOVE.L  A3,60(A7)
    JSR     LAB_0B44(PC)

    ADDQ.W  #8,A7
    MOVEA.L 52(A7),A0
    MOVE.L  D0,60(A0)
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2237,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A2
    MOVE.L  D6,D1
    ASL.L   #2,D1
    LEA     LAB_2236,A1
    MOVEA.L A1,A3
    ADDA.L  D1,A3
    MOVEA.L (A3),A6
    ADDA.L  D5,A6
    MOVE.B  252(A6),253(A2)
    MOVEA.L A0,A2
    ADDA.L  D0,A2
    MOVEA.L (A2),A3
    MOVEA.L A1,A2
    ADDA.L  D1,A2
    MOVEA.L (A2),A6
    ADDA.L  D5,A6
    MOVE.B  301(A6),302(A3)
    ADDA.L  D0,A0
    MOVEA.L (A0),A2
    ADDA.L  D1,A1
    MOVEA.L (A1),A0
    ADDA.L  D5,A0
    MOVE.B  350(A0),351(A2)
    LEA     LAB_2235,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVEQ   #0,D0
    MOVE.B  40(A1),D0
    MOVE.L  D0,D1
    ORI.W   #$80,D1
    MOVE.B  D1,40(A1)
    MOVEQ   #1,D4

LAB_0955:
    SUBQ.L  #1,D5
    BRA.W   LAB_0954

LAB_0956:
    ADDQ.L  #1,D6
    BRA.W   LAB_0951

LAB_0957:
    ADDQ.L  #1,D7
    BRA.W   LAB_0950

LAB_0958:
    MOVEM.L (A7)+,D2-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

LAB_0959:
    MOVEM.L D7/A2-A3,-(A7)
    PEA     1.W
    JSR     LAB_0B38(PC)

    ADDQ.W  #4,A7
    MOVEQ   #1,D0
    MOVE.L  D0,LAB_225F
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_224B
    CLR.B   LAB_2247
    MOVE.W  D0,LAB_2248
    MOVE.B  LAB_222E,D1
    SUBQ.B  #1,D1
    BNE.W   LAB_095C

    MOVE.L  D0,D7

LAB_095A:
    MOVE.W  LAB_222F,D0
    CMP.W   D0,D7
    BGE.S   LAB_095B

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2233,A0
    ADDA.L  D0,A0
    LEA     LAB_2235,A1
    MOVEA.L A1,A2
    ADDA.L  D0,A2
    MOVE.L  (A2),(A0)
    LEA     LAB_2236,A0
    ADDA.L  D0,A0
    LEA     LAB_2237,A2
    MOVEA.L A2,A3
    ADDA.L  D0,A3
    MOVE.L  (A3),(A0)
    ADDA.L  D0,A1
    SUBA.L  A0,A0
    MOVE.L  A0,(A1)
    ADDA.L  D0,A2
    MOVE.L  A0,(A2)
    ADDQ.W  #1,D7
    BRA.S   LAB_095A

LAB_095B:
    MOVE.W  LAB_222F,LAB_2231
    MOVE.B  LAB_224D,LAB_2247
    MOVE.B  LAB_2239,LAB_2238
    MOVE.W  LAB_224E,LAB_2248
    MOVE.B  #$1,LAB_224A
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_222F
    MOVEQ   #0,D1
    MOVE.B  D1,LAB_224D
    MOVE.W  D0,LAB_224E
    MOVE.B  D1,LAB_222E
    MOVE.W  #3,LAB_224B

LAB_095C:
    MOVE.B  LAB_1B92,LAB_1B91
    MOVE.B  LAB_1B90,LAB_1B8F
    MOVE.B  #$ff,LAB_1B92
    CLR.B   LAB_1B90
    JSR     LAB_0BEB(PC)

    MOVEM.L (A7)+,D7/A2-A3
    RTS

;!======

LAB_095D:
    TST.W   LAB_228F
    BEQ.S   LAB_095E

    PEA     1.W
    JSR     LAB_0AC8(PC)

    ADDQ.W  #4,A7
    MOVE.L  LAB_1DE9,LAB_1DDB
    MOVE.L  LAB_1DEA,LAB_1DDC
    SUBA.L  A0,A0
    MOVE.L  A0,LAB_1DE9
    MOVE.L  A0,LAB_1DEA

LAB_095E:
    CLR.W   LAB_228F
    RTS

;!======

LAB_095F:
    MOVE.L  D7,-(A7)
    MOVE.W  10(A7),D7
    TST.W   D7
    SEQ     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D7
    MOVE.L  D7,D0
    MOVE.L  (A7)+,D7
    RTS
