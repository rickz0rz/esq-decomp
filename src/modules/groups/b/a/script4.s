LAB_15A2:
    MOVE.B  #$64,LAB_2377
    MOVE.B  #$31,LAB_2373
    MOVE.W  #(-1),LAB_2364
    RTS

;!======

LAB_15A3:
    MOVE.L  D7,-(A7)
    MOVE.B  LAB_2377,D0
    MOVEQ   #100,D1
    CMP.B   D1,D0
    BEQ.S   .LAB_15A4

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    BRA.S   .return

.LAB_15A4:
    MOVEQ   #0,D0
    MOVE.B  LAB_2373,D0
    MOVE.L  D0,D1

.return:
    MOVE.L  D1,D7
    MOVE.L  D7,D0
    MOVE.L  (A7)+,D7
    RTS

;!======

LAB_15A6:
    LINK.W  A5,#-8
    MOVEM.L D5-D7/A2-A3,-(A7)
    MOVEA.L 36(A7),A3
    MOVE.B  43(A7),D7
    MOVE.B  47(A7),D6
    MOVEA.L 48(A7),A2
    MOVE.L  A2,D0
    BEQ.W   .return

    TST.B   (A2)
    BEQ.W   .return

    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVEQ   #0,D1
    NOT.B   D1
    CMP.L   D1,D0
    BEQ.S   .LAB_15A8

    ADDQ.W  #4,36(A3)
    MOVE.L  D6,D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L A2,A0

.LAB_15A7:
    TST.B   (A0)+
    BNE.S   .LAB_15A7

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    MOVE.L  D0,20(A7)
    MOVE.L  A0,24(A7)
    MOVEA.L A3,A1
    MOVEA.L A2,A0
    MOVE.L  24(A7),D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    EXT.L   D0
    MOVE.W  58(A3),D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  28(A7),-(A7)
    MOVE.L  A3,-(A7)
    JSR     GROUP_BA_JMPTBL_CLEANUP_DrawInsetRectFrame(PC)

    LEA     16(A7),A7

.LAB_15A8:
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEQ   #0,D1
    NOT.B   D1
    CMP.L   D1,D0
    BEQ.S   .LAB_15A9

    MOVE.B  25(A3),D5
    EXT.W   D5
    EXT.L   D5
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEA.L A3,A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

.LAB_15A9:
    MOVEA.L A2,A0

.LAB_15AA:
    TST.B   (A0)+
    BNE.S   .LAB_15AA

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    MOVE.L  A0,20(A7)
    MOVEA.L A3,A1
    MOVEA.L A2,A0
    MOVE.L  20(A7),D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOText(A6)

    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEQ   #0,D1
    NOT.B   D1
    CMP.L   D1,D0
    BEQ.S   .LAB_15AB

    MOVEA.L A3,A1
    MOVE.L  D5,D0
    JSR     _LVOSetAPen(A6)

.LAB_15AB:
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVEQ   #0,D1
    NOT.B   D1
    CMP.L   D1,D0
    BEQ.S   .return

    SUBQ.W  #2,38(A3)
    ADDQ.W  #4,36(A3)

.return:
    MOVEM.L (A7)+,D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_15AD:
    LINK.W  A5,#-176
    MOVEM.L D2/D5-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    CLR.L   -(A7)
    PEA     4.W
    JSR     LAB_183C(PC)

    PEA     3.W
    CLR.L   -(A7)
    PEA     4.W
    JSR     LAB_183E(PC)

    MOVE.L  D0,LAB_2216
    JSR     GROUP_BA_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(PC)

    MOVEQ   #0,D5
    MOVEA.L LAB_2216,A0
    MOVE.W  4(A0),D5
    MOVEQ   #0,D0
    MOVE.W  2(A0),D0
    MOVE.L  D0,-20(A5)
    JSR     GROUPD_JMPTBL_LAB_0A49(PC)

    JSR     GROUPD_JMPTBL_LAB_0A45(PC)

    LEA     20(A7),A7
    MOVEA.L LAB_2216,A0
    MOVE.W  (A0),D0
    BTST    #2,D0
    BEQ.S   .LAB_15AE

    MOVEQ   #2,D0
    BRA.S   .LAB_15AF

.LAB_15AE:
    MOVEQ   #1,D0

.LAB_15AF:
    MOVE.L  D0,20(A7)
    MOVE.L  D5,D0
    MOVE.L  20(A7),D1
    JSR     MATH_DivS32(PC)

    MOVE.W  D0,-172(A5)
    ADDI.W  #22,D0
    MOVE.W  D0,-172(A5)
    EXT.L   D0
    PEA     500.W
    MOVE.L  D0,-(A7)
    JSR     SCRIPT_BeginBannerCharTransition(PC)

    ADDQ.W  #8,A7
    MOVE.L  A3,D0
    BEQ.W   .return

    TST.B   (A3)
    BEQ.W   .return

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVE.W  #1,LAB_22AA
    CLR.W   LAB_22AB
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    PEA     3.W
    MOVE.L  A0,-4(A5)
    JSR     LAB_183E(PC)

    LEA     12(A7),A7
    MOVE.L  D0,LAB_2216
    CLR.L   -28(A5)
    MOVE.L  A3,-170(A5)

.LAB_15B0:
    MOVEA.L -170(A5),A0
    TST.B   (A0)
    BEQ.S   .LAB_15B2

    MOVE.L  -28(A5),D0
    MOVEQ   #64,D1
    ADD.L   D1,D1
    CMP.L   D1,D0
    BGE.S   .LAB_15B2

    MOVE.B  (A0),D1
    MOVEQ   #32,D2
    CMP.B   D2,D1
    BCS.S   .LAB_15B1

    LEA     -161(A5),A0
    ADDA.L  D0,A0
    ADDQ.L  #1,-28(A5)
    MOVE.B  D1,(A0)

.LAB_15B1:
    ADDQ.L  #1,-170(A5)
    BRA.S   .LAB_15B0

.LAB_15B2:
    MOVEA.L -170(A5),A0
    TST.B   (A0)
    BEQ.S   .LAB_15B3

    MOVEQ   #0,D0
    MOVE.B  D0,(A0)

.LAB_15B3:
    LEA     -161(A5),A0
    MOVE.L  -28(A5),D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    CLR.B   (A1)
    MOVEA.L -4(A5),A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    TST.B   LAB_1B5D
    BEQ.S   .LAB_15B4

    MOVEQ   #0,D1
    MOVE.B  LAB_21B3,D1
    MOVEQ   #0,D2
    NOT.B   D2
    CMP.L   D2,D1
    BEQ.S   .LAB_15B4

    MOVEQ   #8,D1
    BRA.S   .LAB_15B5

.LAB_15B4:
    MOVEQ   #0,D1

.LAB_15B5:
    ADD.L   D1,D0
    MOVE.L  -20(A5),D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .LAB_15B6

    ADDQ.L  #1,D1

.LAB_15B6:
    ASR.L   #1,D1
    MOVE.L  D1,D7
    MOVE.L  D5,D6
    MOVEQ   #26,D1
    SUB.L   D1,D6
    MOVE.L  D0,-24(A5)
    MOVEA.L -4(A5),A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L -4(A5),A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVE.L  D7,D0
    MOVE.L  D6,D1
    MOVEA.L -4(A5),A1
    JSR     _LVOMove(A6)

    MOVEA.L A3,A0
    MOVEQ   #0,D0
    MOVE.L  D0,-32(A5)
    MOVE.L  D0,-28(A5)
    MOVE.L  A0,-166(A5)
    MOVE.L  A0,-170(A5)

.LAB_15B7:
    TST.L   -32(A5)
    BNE.W   .LAB_15C3

    MOVEQ   #0,D0
    MOVEA.L -166(A5),A0
    MOVE.B  (A0),D0
    TST.W   D0
    BEQ.S   .LAB_15B8

    SUBI.W  #19,D0
    BEQ.W   .LAB_15BE

    SUBQ.W  #1,D0
    BEQ.W   .LAB_15C0

    SUBQ.W  #4,D0
    BEQ.S   .LAB_15BA

    SUBQ.W  #1,D0
    BEQ.S   .LAB_15BA

    BRA.W   .LAB_15C1

.LAB_15B8:
    MOVE.L  -28(A5),D0
    TST.L   D0
    BLE.S   .LAB_15B9

    MOVEA.L -4(A5),A1
    MOVEA.L -170(A5),A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOText(A6)

.LAB_15B9:
    MOVEQ   #1,D0
    MOVE.L  D0,-32(A5)
    BRA.W   .LAB_15C2

.LAB_15BA:
    MOVE.L  -28(A5),D0
    TST.L   D0
    BLE.S   .LAB_15BB

    MOVEA.L -4(A5),A1
    MOVEA.L -170(A5),A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOText(A6)

.LAB_15BB:
    MOVEQ   #24,D0
    MOVEA.L -166(A5),A0
    CMP.B   (A0),D0
    BNE.S   .LAB_15BC

    MOVEQ   #1,D0
    BRA.S   .LAB_15BD

.LAB_15BC:
    MOVEQ   #3,D0

.LAB_15BD:
    MOVEA.L -4(A5),A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L -166(A5),A0
    ADDQ.L  #1,A0
    CLR.L   -28(A5)
    MOVE.L  A0,-170(A5)
    BRA.W   .LAB_15C2

.LAB_15BE:
    MOVE.L  -28(A5),D0
    TST.L   D0
    BLE.S   .LAB_15BF

    MOVEA.L -4(A5),A1
    MOVEA.L -170(A5),A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOText(A6)

.LAB_15BF:
    MOVEA.L -166(A5),A0
    ADDQ.L  #1,A0
    CLR.L   -28(A5)
    MOVE.L  A0,-170(A5)
    BRA.S   .LAB_15C2

.LAB_15C0:
    MOVE.L  -28(A5),-(A7)
    MOVE.L  -170(A5),-(A7)
    PEA     -161(A5)
    JSR     STRING_CopyPadNul(PC)

    LEA     -161(A5),A0
    MOVEA.L A0,A1
    ADDA.L  -28(A5),A1
    CLR.B   (A1)
    MOVEQ   #0,D0
    MOVE.B  LAB_21B4,D0
    MOVEQ   #0,D1
    MOVE.B  LAB_21B3,D1
    MOVE.L  A0,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    BSR.W   LAB_15A6

    LEA     24(A7),A7
    MOVEA.L -166(A5),A0
    ADDQ.L  #1,A0
    CLR.L   -28(A5)
    CLR.B   LAB_1B5D
    MOVE.L  A0,-170(A5)
    BRA.S   .LAB_15C2

.LAB_15C1:
    MOVEA.L -166(A5),A0
    CMPI.B  #$20,(A0)
    BCS.S   .LAB_15C2

    ADDQ.L  #1,-28(A5)

.LAB_15C2:
    ADDQ.L  #1,-166(A5)
    BRA.W   .LAB_15B7

.LAB_15C3:
    PEA     3.W
    CLR.L   -(A7)
    PEA     4.W
    JSR     LAB_183E(PC)

    LEA     12(A7),A7
    MOVE.L  D0,LAB_2216

.return:
    JSR     TEXTDISP_JMPTBL_LAB_0A48(PC)

    MOVEM.L (A7)+,D2/D5-D7/A3
    UNLK    A5
    RTS
