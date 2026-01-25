;!======

LAB_09E8:
    LINK.W  A5,#-68
    MOVEM.L D2/D5-D7/A3,-(A7)

    MOVEA.L 8(A5),A3
    CLR.L   -4(A5)
    MOVEQ   #0,D7
    MOVEQ   #30,D6
    MOVEQ   #0,D5
    CLR.L   -24(A5)
    MOVEQ   #0,D0
    MOVE.B  LAB_229C,D0
    ASL.L   #2,D0
    LEA     LAB_1EDD,A0
    ADDA.L  D0,A0
    PEA     LAB_1ED4
    MOVE.L  (A0),-(A7)
    JSR     LAB_0AA3(PC)

    MOVE.L  -4(A5),(A7)
    MOVE.L  LAB_1DEC,-(A7)
    MOVE.L  D0,-52(A5)
    JSR     LAB_0B44(PC)

    LEA     12(A7),A7
    MOVEA.L D0,A0

.LAB_09E9:
    TST.B   (A0)+
    BNE.S   .LAB_09E9

    SUBQ.L  #1,A0
    SUBA.L  D0,A0
    MOVE.L  A0,D1
    ADDQ.L  #1,D1
    MOVE.L  D0,-8(A5)
    MOVE.L  D0,-4(A5)
    MOVE.L  D1,-28(A5)

.LAB_09EA:
    MOVEA.L -8(A5),A0
    TST.B   (A0)
    BEQ.S   .LAB_09EC

    MOVEQ   #24,D0
    CMP.B   (A0),D0
    BNE.S   .LAB_09EB

    CLR.B   (A0)
    ADDQ.L  #1,D5

.LAB_09EB:
    ADDQ.L  #1,-8(A5)
    BRA.S   .LAB_09EA

.LAB_09EC:
    MOVEA.L -4(A5),A0
    MOVE.L  A0,-8(A5)
    TST.B   (A0)
    BNE.S   .LAB_09ED

    ADDQ.L  #1,-8(A5)
    SUBQ.L  #1,D5

.LAB_09ED:
    MOVEQ   #10,D0
    CMP.L   D0,D5
    BLE.S   .LAB_09EE

    MOVE.L  D0,D5

.LAB_09EE:
    MOVE.B  64(A3),-65(A5)
    MOVE.B  61(A3),-66(A5)
    LEA     36(A3),A0
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    LEA     36(A3),A0
    MOVEA.L A0,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    LEA     36(A3),A0
    MOVEA.L A0,A1
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    JSR     _LVOSetFont(A6)

    LEA     36(A3),A0
    MOVEA.L A0,A1
    MOVEQ   #7,D0
    JSR     _LVOSetRast(A6)

    MOVEQ   #1,D0
    MOVEA.L -52(A5),A0
    MOVE.L  D0,356(A0)
    MOVE.L  D0,360(A0)
    MOVEQ   #0,D0
    MOVE.W  176(A3),D0
    MOVEQ   #0,D1
    MOVE.W  178(A3),D1
    LEA     36(A3),A1
    MOVEQ   #0,D2
    MOVE.L  D2,-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_0AB4(PC)

    LEA     28(A7),A7
    MOVEQ   #0,D0
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    MOVE.W  20(A0),D0
    MOVE.L  D5,D1
    ADDQ.L  #1,D1
    TST.L   D1
    BPL.S   .LAB_09EF

    ADDQ.L  #1,D1

.LAB_09EF:
    ASR.L   #1,D1
    MOVE.L  D0,-48(A5)
    MOVE.L  D1,-32(A5)
    JSR     JMP_TBL_LAB_1A06_4(PC)

    MOVEQ   #80,D1
    ADD.L   D1,D1
    SUB.L   D0,D1
    MOVE.L  -32(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-36(A5)
    MOVE.L  D1,D0
    MOVE.L  D1,-40(A5)
    MOVE.L  -36(A5),D1
    JSR     JMP_TBL_LAB_1A07_2(PC)

    MOVEQ   #0,D1
    MOVE.W  176(A3),D1
    MOVEQ   #0,D2
    MOVEA.L -52(A5),A0
    MOVE.W  176(A0),D2
    SUB.L   D2,D1
    TST.L   D1
    BPL.S   .LAB_09F0

    ADDQ.L  #1,D1

.LAB_09F0:
    ASR.L   #1,D1
    MOVE.L  D0,-44(A5)
    MOVE.L  D1,-56(A5)

.LAB_09F1:
    MOVE.L  -24(A5),D0
    CMP.L   D5,D0
    BGE.W   .LAB_09F8

    TST.L   D0
    BPL.S   .LAB_09F2

    ADDQ.L  #1,D0

.LAB_09F2:
    ASR.L   #1,D0
    MOVE.L  -44(A5),D1
    MOVE.L  -48(A5),D2
    ADD.L   D1,D2
    MOVE.L  D2,D1
    JSR     JMP_TBL_LAB_1A06_4(PC)

    ADD.L   -44(A5),D0
    MOVEQ   #0,D1
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    MOVE.W  26(A0),D1
    ADD.L   D1,D0
    MOVE.L  D0,D6
    MOVEQ   #0,D0
    MOVE.W  20(A0),D0
    MOVE.L  D6,D2
    ADD.L   D0,D2
    MOVEQ   #0,D0
    MOVE.W  D1,D0
    SUB.L   D0,D2
    MOVEQ   #80,D0
    ADD.L   D0,D0
    CMP.L   D0,D2
    BGE.W   .LAB_09F8

    LEA     36(A3),A0
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -56(A5),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   LAB_09E2

    LEA     12(A7),A7
    LEA     36(A3),A0
    MOVE.L  D0,-60(A5)
    MOVEA.L A0,A1
    MOVEA.L -8(A5),A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  -56(A5),D1
    SUB.L   D0,D1
    SUBQ.L  #1,D1
    TST.L   D1
    BPL.S   .LAB_09F3

    ADDQ.L  #1,D1

.LAB_09F3:
    ASR.L   #1,D1
    MOVE.L  D1,D7
    LEA     36(A3),A0
    MOVE.L  D0,-64(A5)
    MOVEA.L A0,A1
    MOVE.L  D7,D0
    MOVE.L  D6,D1
    JSR     _LVOMove(A6)

    LEA     36(A3),A0
    MOVEA.L A0,A1
    MOVEA.L -8(A5),A0
    MOVE.L  -60(A5),D0
    JSR     _LVOText(A6)

    ADDQ.L  #1,-24(A5)
    MOVE.L  -24(A5),D0
    CMP.L   D5,D0
    BGE.W   .LAB_09F6

    MOVEA.L -8(A5),A0

.LAB_09F4:
    TST.B   (A0)+
    BNE.S   .LAB_09F4

    SUBQ.L  #1,A0
    SUBA.L  -8(A5),A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    ADD.L   D0,-8(A5)
    LEA     36(A3),A0
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -56(A5),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   LAB_09E2

    LEA     12(A7),A7
    LEA     36(A3),A0
    MOVE.L  D0,-60(A5)
    MOVEA.L A0,A1
    MOVEA.L -8(A5),A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  -56(A5),D1
    ADD.L   D0,D1
    TST.L   D1
    BPL.S   .LAB_09F5

    ADDQ.L  #1,D1

.LAB_09F5:
    ASR.L   #1,D1
    MOVEQ   #0,D2
    MOVE.W  176(A3),D2
    SUB.L   D1,D2
    MOVE.L  D2,D7
    SUBQ.L  #1,D7
    LEA     36(A3),A0
    MOVE.L  D0,-64(A5)
    MOVEA.L A0,A1
    MOVE.L  D7,D0
    MOVE.L  D6,D1
    JSR     _LVOMove(A6)

    LEA     36(A3),A0
    MOVEA.L A0,A1
    MOVEA.L -8(A5),A0
    MOVE.L  -60(A5),D0
    JSR     _LVOText(A6)

    ADDQ.L  #1,-24(A5)

.LAB_09F6:
    MOVEA.L -8(A5),A0

.LAB_09F7:
    TST.B   (A0)+
    BNE.S   .LAB_09F7

    SUBQ.L  #1,A0
    SUBA.L  -8(A5),A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    ADD.L   D0,-8(A5)

    BRA.W   .LAB_09F1

.LAB_09F8:
    MOVE.L  -28(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     672.W
    PEA     GLOB_STR_ESQIFF_C_1
    JSR     JMP_TBL_DEALLOCATE_MEMORY_2(PC)

    LEA     36(A3),A0
    MOVE.B  -65(A5),D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L A0,A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    LEA     36(A3),A0
    MOVE.B  -66(A5),D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L A0,A1
    JSR     _LVOSetAPen(A6)

    MOVEM.L -88(A5),D2/D5-D7/A3
    UNLK    A5
    RTS

;!======

LAB_09F9:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7
    TST.L   LAB_1EE9
    BEQ.S   LAB_09FA

    MOVEQ   #1,D0
    CMP.L   D0,D7
    BNE.S   LAB_09FB

LAB_09FA:
    MOVE.L  LAB_1B23,LAB_1EE9

LAB_09FB:
    MOVEQ   #0,D0
    TST.L   D0
    BEQ.W   LAB_09FD

    PEA     LAB_1EEA
    MOVE.L  LAB_1EE9,-(A7)
    JSR     JMP_TBL_LAB_1968_2(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   LAB_09FC

    MOVEQ   #2,D0
    CMP.L   D0,D7
    BNE.W   LAB_09FD

LAB_09FC:
    MOVE.B  LAB_227F,D0
    MOVEQ   #0,D1
    CMP.B   D1,D0
    BLS.W   LAB_09FE

    MOVE.W  LAB_229D,D0
    MOVEQ   #48,D1
    CMP.W   D1,D0
    BEQ.W   LAB_09FE

    CLR.L   -(A7)
    MOVE.L  LAB_1EE9,-(A7)
    JSR     LAB_0AA7(PC)

    MOVE.L  D0,LAB_1B24
    MOVEA.L D0,A0
    MOVE.B  #11,190(A0)
    MOVEA.L LAB_1B24,A0
    MOVE.W  #$280,128(A0)
    MOVEA.L LAB_1B24,A0
    MOVE.W  #160,130(A0)
    MOVEA.L LAB_1B24,A0
    MOVE.B  #3,136(A0)
    MOVE.L  LAB_1B24,(A7)
    JSR     LAB_0AA1(PC)

    MOVE.L  D0,LAB_1B25
    MOVE.L  D0,(A7)
    BSR.W   LAB_09E8

    PEA     238.W
    MOVE.L  LAB_1B24,-(A7)
    PEA     724.W
    PEA     GLOB_STR_ESQIFF_C_2
    JSR     JMP_TBL_DEALLOCATE_MEMORY_2(PC)

    LEA     24(A7),A7
    BRA.S   LAB_09FE

LAB_09FD:
    TST.L   LAB_1EE9
    BEQ.S   LAB_09FE

    TST.L   LAB_1EE9
    BEQ.S   LAB_09FE

    CLR.L   -(A7)
    MOVE.L  LAB_1EE9,-(A7)
    JSR     LAB_0AA7(PC)

    MOVE.L  D0,LAB_1B24
    MOVEA.L D0,A0
    MOVE.B  #$6,190(A0)
    MOVE.W  #6,LAB_1B84
    JSR     LAB_0AB0(PC)

    ADDQ.W  #8,A7

LAB_09FE:
    MOVEQ   #2,D0
    CMP.L   D0,D7
    BEQ.S   LAB_09FF

    MOVEA.L LAB_1EE9,A0
    MOVE.L  234(A0),LAB_1EE9

LAB_09FF:
    MOVE.L  (A7)+,D7
    RTS

;!======

    LINK.W  A5,#0
    UNLK    A5
    RTS

;!======

LAB_0A00:
    MOVEM.L D2/D6-D7/A2-A3,-(A7)

    SetOffsetForStack   5
    UseStackLong    MOVEA.L,1,A3
    UseStackLong    MOVEA.L,2,A2

    MOVE.L  A2,D0
    BNE.S   LAB_0A01

    MOVEQ   #0,D0
    MOVE.W  D0,LAB_1EEC
    BRA.W   LAB_0A0A

LAB_0A01:
    MOVE.W  LAB_1EEC,D0
    TST.W   D0
    BLE.S   LAB_0A02

    TST.W   LAB_1ECD
    BEQ.S   LAB_0A03

LAB_0A02:
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_1ECD
    MOVE.W  178(A2),D1
    MOVE.B  #$1,LAB_1EEE
    MOVE.W  D0,LAB_1EED
    MOVE.W  D1,LAB_1EEC

LAB_0A03:
    MOVE.W  LAB_1EEC,D0
    MOVEQ   #30,D1
    CMP.W   D1,D0
    BGE.S   LAB_0A04

    MOVE.L  D0,D7
    BRA.S   LAB_0A05

LAB_0A04:
    MOVE.L  D1,D7

LAB_0A05:
    MOVEQ   #9,D0
    CMP.B   32(A2),D0
    BNE.S   LAB_0A06

    MOVEQ   #42,D6
    MOVEQ   #0,D0
    MOVE.W  176(A2),D0
    ADD.L   D6,D0
    MOVE.L  D7,D1
    EXT.L   D1
    LEA     60(A3),A0
    MOVE.W  LAB_1EED,D2
    EXT.L   D2
    MOVE.L  D2,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  A2,-(A7)
    JSR     LAB_0AB4(PC)

    MOVEQ   #0,D0
    MOVE.W  176(A2),D0
    MOVE.L  #$28e,D1
    SUB.L   D0,D1
    MOVE.L  D1,D6
    SUBQ.L  #1,D6
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ADD.L   D6,D1
    MOVE.L  D7,D0
    EXT.L   D0
    LEA     60(A3),A0
    MOVE.W  LAB_1EED,D2
    EXT.L   D2
    MOVE.L  D2,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    CLR.L   -(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  A2,-(A7)
    JSR     LAB_0AB4(PC)

    LEA     52(A7),A7
    BRA.S   LAB_0A08

LAB_0A06:
    MOVEQ   #0,D0
    MOVE.W  176(A2),D0
    MOVE.L  #696,D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   LAB_0A07

    ADDQ.L  #1,D1

LAB_0A07:
    ASR.L   #1,D1
    MOVE.L  D1,D6
    SUBQ.L  #1,D6
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ADD.L   D6,D1
    MOVE.L  D7,D0
    EXT.L   D0
    LEA     60(A3),A0
    MOVE.W  LAB_1EED,D2
    EXT.L   D2
    MOVE.L  D2,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    CLR.L   -(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  A2,-(A7)
    JSR     LAB_0AB4(PC)

    LEA     28(A7),A7
    MOVEQ   #11,D0
    CMP.B   32(A2),D0
    BNE.S   LAB_0A08

    MOVEQ   #1,D0
    CMP.B   LAB_1EEE,D0
    BNE.S   LAB_0A08

    MOVE.B  LAB_1BBF,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   LAB_0A08

    PEA     16.W
    MOVE.L  A3,-(A7)
    JSR     LAB_0AA9(PC)

    ADDQ.W  #8,A7
    CLR.B   LAB_1EEE

LAB_0A08:
    SUB.W   D7,LAB_1EEC
    ADD.W   D7,LAB_1EED
    MOVE.L  D7,D0
    TST.W   D0
    BPL.S   LAB_0A09

    ADDQ.W  #1,D0

LAB_0A09:
    ASR.W   #1,D0
    MOVE.W  D0,52(A3)
    MOVE.W  LAB_1EEC,D0

LAB_0A0A:
    MOVEM.L (A7)+,D2/D6-D7/A2-A3
    RTS

;!======

LAB_0A0B:
    MOVEM.L D2-D3/D6-D7,-(A7)

    SetOffsetForStack   4
    ; UseStackLong    MOVE.L,1,D7
    EmitStackAddress    1
    MOVE.L  .stackLong1(A7),D7

    TST.W   LAB_1B83
    BEQ.W   .return

    MOVEQ   #1,D0
    CMP.L   D0,D7
    BNE.W   .LAB_0A10

    MOVE.B  LAB_1DD6,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BEQ.W   .LAB_0A10

    TST.L   LAB_2319
    BNE.W   .LAB_0A10

    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    CLR.L   -(A7)

    PEA     LAB_1ED2
    JSR     LAB_0AA4(PC)

    ADDQ.W  #8,A7

    MOVEQ   #0,D0
    MOVE.L  D0,LAB_1B27
    CLR.W   LAB_22AD
    MOVEA.L AbsExecBase,A6
    JSR     _LVOPermit(A6)

    TST.L   GLOB_REF_LONG_GFX_G_ADS_DATA
    BEQ.S   .loadGfxGAdsFile

    TST.L   GLOB_REF_LONG_GFX_G_ADS_FILESIZE
    BEQ.S   .loadGfxGAdsFile

    MOVE.L  GLOB_REF_LONG_GFX_G_ADS_FILESIZE,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  GLOB_REF_LONG_GFX_G_ADS_DATA,-(A7)
    PEA     882.W
    PEA     GLOB_STR_ESQIFF_C_3
    JSR     JMP_TBL_DEALLOCATE_MEMORY_2(PC)

    LEA     16(A7),A7

.loadGfxGAdsFile:
    CLR.L   GLOB_REF_LONG_GFX_G_ADS_DATA
    CLR.L   GLOB_REF_LONG_GFX_G_ADS_FILESIZE

    PEA     MODE_OLDFILE
    MOVE.L  GLOB_PTR_STR_GFX_G_ADS,-(A7)
    JSR     JMP_TBL_OPEN_FILE_WITH_ACCESS_MODE_2(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D6
    TST.L   D6
    BLE.S   .LAB_0A0E

    MOVE.L  D6,-(A7)
    JSR     JMP_TBL_GET_FILESIZE_FROM_HANDLE(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,GLOB_REF_LONG_GFX_G_ADS_FILESIZE
    TST.L   D0
    BLE.S   .gfxGAdsFileWithoutData

    ADDQ.L  #1,D0
    PEA     (MEMF_PUBLIC).W
    MOVE.L  D0,-(A7)
    PEA     898.W
    PEA     GLOB_STR_ESQIFF_C_4
    JSR     JMP_TBL_ALLOCATE_MEMORY_2(PC)

    LEA     16(A7),A7

    MOVE.L  D0,GLOB_REF_LONG_GFX_G_ADS_DATA
    MOVE.L  D6,D1
    MOVE.L  D0,D2
    MOVE.L  GLOB_REF_LONG_GFX_G_ADS_FILESIZE,D3
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVORead(A6)

    CMP.L   GLOB_REF_LONG_GFX_G_ADS_FILESIZE,D0
    BNE.S   .gfxGAdsFileWithoutData

    MOVE.W  LAB_22A9,D0
    ORI.W   #1,D0
    MOVE.W  D0,LAB_22A9

.gfxGAdsFileWithoutData:
    MOVE.L  D6,D1
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOClose(A6)

.LAB_0A0E:
    TST.W   LAB_2294
    BEQ.S   .LAB_0A0F

    MOVE.W  #1,LAB_22AD
    BRA.S   .LAB_0A10

.LAB_0A0F:
    CLR.W   LAB_22AD

.LAB_0A10:
    TST.L   D7
    BNE.W   .return

    TST.L   LAB_2318
    BNE.W   .return

    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    CLR.L   -(A7)
    PEA     LAB_1ED3
    JSR     LAB_0AA4(PC)

    ADDQ.W  #8,A7
    MOVEQ   #0,D0
    MOVE.L  D0,LAB_1B28
    CLR.W   LAB_22AC
    MOVEA.L AbsExecBase,A6
    JSR     _LVOPermit(A6)

    TST.L   GLOB_REF_LONG_DF0_LOGO_LST_DATA
    BEQ.S   .loadDf0LogoLstFile

    TST.L   GLOB_REF_LONG_DF0_LOGO_LST_FILESIZE
    BEQ.S   .loadDf0LogoLstFile

    MOVE.L  GLOB_REF_LONG_DF0_LOGO_LST_FILESIZE,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  GLOB_REF_LONG_DF0_LOGO_LST_DATA,-(A7)
    PEA     963.W
    PEA     GLOB_STR_ESQIFF_C_5
    JSR     JMP_TBL_DEALLOCATE_MEMORY_2(PC)

    LEA     16(A7),A7

.loadDf0LogoLstFile:
    CLR.L   GLOB_REF_LONG_DF0_LOGO_LST_DATA
    CLR.L   GLOB_REF_LONG_DF0_LOGO_LST_FILESIZE
    PEA     MODE_OLDFILE
    MOVE.L  GLOB_PTR_STR_DF0_LOGO_LST,-(A7)
    JSR     JMP_TBL_OPEN_FILE_WITH_ACCESS_MODE_2(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D6
    TST.L   D6
    BLE.S   .return

    MOVE.L  D6,-(A7)
    JSR     JMP_TBL_GET_FILESIZE_FROM_HANDLE(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,GLOB_REF_LONG_DF0_LOGO_LST_FILESIZE
    TST.L   D0
    BLE.S   .df0LogoLstFileWithoutData

    ADDQ.L  #1,D0

    PEA     (MEMF_PUBLIC).W
    MOVE.L  D0,-(A7)
    PEA     979.W
    PEA     GLOB_STR_ESQIFF_C_6
    JSR     JMP_TBL_ALLOCATE_MEMORY_2(PC)

    LEA     16(A7),A7
    MOVE.L  D0,GLOB_REF_LONG_DF0_LOGO_LST_DATA
    MOVE.L  D6,D1
    MOVE.L  D0,D2
    MOVE.L  GLOB_REF_LONG_DF0_LOGO_LST_FILESIZE,D3
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVORead(A6)

    CMP.L   GLOB_REF_LONG_DF0_LOGO_LST_FILESIZE,D0
    BNE.S   .df0LogoLstFileWithoutData

    MOVE.W  LAB_22A9,D0
    ORI.W   #2,D0
    MOVE.W  D0,LAB_22A9

.df0LogoLstFileWithoutData:
    MOVE.L  D6,D1
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOClose(A6)

.return:
    MOVEM.L (A7)+,D2-D3/D6-D7
    RTS

;!======

LAB_0A14:
    LINK.W  A5,#-144
    MOVEM.L D2/D5-D7,-(A7)
    MOVEQ   #0,D0
    MOVE.L  D0,-138(A5)
    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    TST.W   LAB_1B83
    BNE.S   .LAB_0A15

    JSR     _LVOPermit(A6)

    MOVEQ   #0,D0
    BRA.W   .return

.LAB_0A15:
    MOVE.W  LAB_22C0,D0
    BEQ.S   .LAB_0A16

    CMPI.L  #$1,LAB_1B28
    BLT.S   .LAB_0A16

    JSR     _LVOPermit(A6)

    MOVEQ   #0,D0
    BRA.W   .return

.LAB_0A16:
    MOVE.W  LAB_22C0,D0
    BNE.S   .LAB_0A17

    CMPI.L  #$2,LAB_1B27
    BLT.S   .LAB_0A17

    JSR     _LVOPermit(A6)

    MOVEQ   #0,D0
    BRA.W   .return

.LAB_0A17:
    JSR     _LVOPermit(A6)

    MOVEQ   #0,D0
    MOVE.B  D0,-40(A5)
    MOVE.W  LAB_22AC,D6
    MOVEQ   #0,D1
    MOVE.W  D1,-128(A5)
    TST.L   GLOB_REF_LONG_DF0_LOGO_LST_DATA
    BEQ.S   .LAB_0A18

    MOVE.W  LAB_22C0,D2
    BNE.S   .LAB_0A19

.LAB_0A18:
    TST.L   GLOB_REF_LONG_GFX_G_ADS_DATA
    BEQ.W   .LAB_0A32

    MOVE.W  LAB_22C0,D2
    BNE.W   .LAB_0A32

.LAB_0A19:
    MOVE.B  D0,-41(A5)
    MOVE.W  LAB_2364,D5

.LAB_0A1A:
    PEA     -40(A5)
    BSR.W   LAB_0A35

    ADDQ.W  #4,A7
    LEA     -40(A5),A0
    MOVEA.L A0,A1

.LAB_0A1B:
    TST.B   (A1)+
    BNE.S   .LAB_0A1B

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    BEQ.W   .LAB_0A22

    MOVE.W  LAB_22C0,D0
    BEQ.S   .LAB_0A20

    TST.W   LAB_22C3
    BEQ.S   .LAB_0A1C

    MOVE.W  #1,-128(A5)
    BRA.W   .LAB_0A23

.LAB_0A1C:
    MOVEQ   #0,D7

.LAB_0A1D:
    MOVEQ   #40,D0
    CMP.W   D0,D7
    BGE.S   .LAB_0A1F

    MOVE.B  -40(A5,D7.W),-80(A5,D7.W)
    TST.B   -80(A5,D7.W)
    BEQ.S   .LAB_0A1F

    MOVEQ   #33,D0
    CMP.B   -80(A5,D7.W),D0
    BNE.S   .LAB_0A1E

    MOVE.B  #$2a,-80(A5,D7.W)
    MOVE.L  D7,D0
    EXT.L   D0
    CLR.B   -79(A5,D0.L)
    BRA.S   .LAB_0A1F

.LAB_0A1E:
    ADDQ.W  #1,D7
    BRA.S   .LAB_0A1D

.LAB_0A1F:
    PEA     -80(A5)
    JSR     GCOMMAND_FindPathSeparator(PC)

    MOVE.L  D0,(A7)
    JSR     LAB_0A9A(PC)

    ADDQ.W  #4,A7
    SUBQ.W  #1,D0
    BNE.S   .LAB_0A21

    MOVE.W  #1,-128(A5)
    MOVE.W  LAB_2364,LAB_22C2
    BRA.S   .LAB_0A23

.LAB_0A20:
    MOVEQ   #4,D0
    MOVE.L  D0,-(A7)
    PEA     -40(A5)
    PEA     LAB_1EF3
    JSR     LAB_0AAC(PC)

    LEA     12(A7),A7
    TST.L   D0
    BEQ.S   .LAB_0A23

    MOVEQ   #11,D0
    MOVE.L  D0,-(A7)
    PEA     -40(A5)
    PEA     LAB_1EF4
    JSR     LAB_0AAC(PC)

    LEA     12(A7),A7
    TST.L   D0
    BEQ.S   .LAB_0A23

    MOVE.W  #1,-128(A5)
    BRA.S   .LAB_0A23

.LAB_0A21:
    JSR     LAB_08C2(PC)

.LAB_0A22:
    MOVE.W  LAB_22AC,D0
    CMP.W   D0,D6
    BNE.W   .LAB_0A1A

.LAB_0A23:
    MOVE.W  D5,LAB_2364
    TST.W   -128(A5)
    BEQ.W   .LAB_0A32

    MOVE.W  LAB_22C0,D0
    BEQ.S   .LAB_0A24

    MOVE.L  #$fa00,-134(A5)
    BRA.S   .LAB_0A25

.LAB_0A24:
    MOVE.L  #$13880,-134(A5)

.LAB_0A25:
    LEA     -40(A5),A0
    LEA     -120(A5),A1

.LAB_0A26:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .LAB_0A26

.LAB_0A27:
    MOVE.W  #1,-130(A5)
    JSR     LAB_08C2(PC)

    MOVE.W  LAB_22C0,D0
    BEQ.S   .LAB_0A28

    MOVEA.L LAB_1ED3,A0
    MOVE.L  A0,-142(A5)
    BRA.S   .LAB_0A29

.LAB_0A28:
    MOVEA.L LAB_1ED2,A0
    MOVE.L  A0,-142(A5)

.LAB_0A29:
    MOVE.L  A0,D0
    BEQ.S   .LAB_0A2B

    CMPA.L  LAB_1ED3,A0
    BNE.S   .LAB_0A2B

    LEA     -40(A5),A0
    MOVEA.L -142(A5),A1

.LAB_0A2A:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.S   .LAB_0A2B

    TST.B   D0
    BNE.S   .LAB_0A2A

    BNE.S   .LAB_0A2B

    MOVEQ   #1,D0
    MOVE.L  D0,-138(A5)

.LAB_0A2B:
    TST.L   -138(A5)
    BNE.S   .LAB_0A2E

    CLR.L   -(A7)
    PEA     -40(A5)
    JSR     LAB_0AA7(PC)

    ADDQ.W  #8,A7
    MOVE.W  LAB_22C0,D1
    MOVE.L  D0,LAB_22A8
    TST.W   D1
    BEQ.S   .LAB_0A2C

    MOVEA.L D0,A0
    MOVE.B  #$4,190(A0)
    MOVE.L  D0,LAB_1B20
    BRA.S   .LAB_0A2D

.LAB_0A2C:
    MOVEA.L D0,A0
    MOVE.B  #$5,190(A0)
    MOVE.L  D0,LAB_1B21

.LAB_0A2D:
    JSR     LAB_0AB0(PC)

.LAB_0A2E:
    JSR     LAB_08C2(PC)

    MOVEQ   #-1,D0
    CMP.W   -130(A5),D0
    BNE.S   .LAB_0A2F

    PEA     -40(A5)
    BSR.W   LAB_0A35

    ADDQ.W  #4,A7

.LAB_0A2F:
    LEA     -120(A5),A0
    LEA     -40(A5),A1

.LAB_0A30:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.S   .LAB_0A31

    TST.B   D0
    BNE.S   .LAB_0A30

    BEQ.S   .LAB_0A32

.LAB_0A31:
    MOVEQ   #-1,D0
    CMP.W   -130(A5),D0
    BEQ.W   .LAB_0A27

.LAB_0A32:
    TST.W   -128(A5)
    BNE.S   .LAB_0A33

    MOVEQ   #-1,D0
    MOVE.W  D0,-130(A5)

.LAB_0A33:
    MOVE.W  -130(A5),D0

.return:
    MOVEM.L (A7)+,D2/D5-D7
    UNLK    A5
    RTS

;!======

LAB_0A35:
    LINK.W  A5,#-16
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    JSR     LAB_08C2(PC)

    MOVE.W  LAB_22C0,D0
    BEQ.S   .LAB_0A36

    MOVE.L  GLOB_REF_LONG_DF0_LOGO_LST_FILESIZE,D4
    MOVE.L  GLOB_REF_LONG_DF0_LOGO_LST_DATA,-14(A5)
    MOVE.W  LAB_22AC,D6
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_22C3
    BRA.S   .LAB_0A38

.LAB_0A36:
    MOVE.W  LAB_22C1,D0
    BEQ.S   .LAB_0A37

    MOVE.L  GLOB_REF_LONG_GFX_G_ADS_FILESIZE,D4
    MOVE.L  GLOB_REF_LONG_GFX_G_ADS_DATA,-14(A5)
    MOVE.W  LAB_22AD,D6
    BRA.S   .LAB_0A38

.LAB_0A37:
    MOVEQ   #0,D0
    BRA.W   .return

.LAB_0A38:
    MOVEQ   #0,D7

.LAB_0A39:
    CMP.W   D6,D7
    BGE.S   .LAB_0A3B

    TST.L   D4
    BLE.S   .LAB_0A3B

    MOVEA.L -14(A5),A0
    MOVE.B  (A0)+,D5
    MOVE.L  A0,-14(A5)
    MOVEQ   #10,D0
    CMP.B   D0,D5
    BNE.S   .LAB_0A3A

    ADDQ.W  #1,D7

.LAB_0A3A:
    SUBQ.L  #1,D4
    BRA.S   .LAB_0A39

.LAB_0A3B:
    TST.L   D4
    BNE.S   .LAB_0A3E

    MOVE.W  LAB_22C0,D0
    BEQ.S   .LAB_0A3C

    MOVE.L  GLOB_REF_LONG_DF0_LOGO_LST_FILESIZE,D4
    MOVE.L  GLOB_REF_LONG_DF0_LOGO_LST_DATA,-14(A5)
    BRA.S   .LAB_0A3D

.LAB_0A3C:
    MOVE.L  GLOB_REF_LONG_GFX_G_ADS_FILESIZE,D4
    MOVE.L  GLOB_REF_LONG_GFX_G_ADS_DATA,-14(A5)

.LAB_0A3D:
    MOVEQ   #1,D6
    BRA.S   .LAB_0A3F

.LAB_0A3E:
    ADDQ.W  #1,D6

.LAB_0A3F:
    MOVE.W  LAB_22C0,D0
    BEQ.S   .LAB_0A40

    MOVE.W  D6,LAB_22AC
    BRA.S   .LAB_0A41

.LAB_0A40:
    MOVE.W  D6,LAB_22AD

.LAB_0A41:
    MOVEA.L -14(A5),A0
    MOVE.B  (A0)+,D5
    MOVE.L  A0,-14(A5)
    MOVEQ   #10,D0
    CMP.B   D0,D5
    BEQ.S   .LAB_0A43

    MOVEQ   #13,D0
    CMP.B   D0,D5
    BEQ.S   .LAB_0A43

    MOVEQ   #32,D0
    CMP.B   D0,D5
    BEQ.S   .LAB_0A43

    MOVE.L  D4,D0
    SUBQ.L  #1,D4
    TST.L   D0
    BLE.S   .LAB_0A43

    MOVEQ   #44,D0
    CMP.B   D0,D5
    BNE.S   .LAB_0A42

    CLR.B   (A3)
    MOVE.W  #1,LAB_22C3
    BRA.S   .LAB_0A43

.LAB_0A42:
    MOVE.B  D5,(A3)+
    BRA.S   .LAB_0A41

.LAB_0A43:
    CLR.B   (A3)
    MOVEQ   #1,D0

.return:
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======

LAB_0A45:
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D7

.LAB_0A46:
    MOVEQ   #24,D0
    CMP.W   D0,D7
    BGE.S   .return

    LEA     LAB_2295,A0
    ADDA.W  D7,A0
    LEA     LAB_1ECC,A1
    ADDA.W  D7,A1
    MOVE.B  (A1),(A0)
    ADDQ.W  #1,D7
    BRA.S   .LAB_0A46

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======

LAB_0A48:
    MOVE.W  #15,LAB_1B1C
    BSR.W   LAB_0A8E

    RTS

;!======

LAB_0A49:
    MOVE.W  #15,LAB_1B1B
    BSR.W   LAB_0A8E

    RTS

;!======

LAB_0A4A:
    MOVE.L  A4,-(A7)
    LEA     GLOB_REF_LONG_FILE_SCRATCH,A4
    MOVE.W  LAB_1B15,D0
    SUBQ.W  #1,D0
    BNE.S   LAB_0A4C

    TST.W   LAB_22B1
    BEQ.S   LAB_0A4C

    CLR.W   LAB_1B15
    MOVE.W  LAB_22B1,D0
    BTST    #1,D0
    BEQ.S   LAB_0A4B

    MOVEQ   #0,D0
    MOVE.B  LAB_22B2,D0
    MOVEQ   #0,D1
    MOVE.B  LAB_22B3,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_0AA2(PC)

    ADDQ.W  #8,A7
    BRA.S   LAB_0A4C

LAB_0A4B:
    MOVEQ   #0,D0
    MOVE.B  LAB_22B2,D0
    MOVEQ   #0,D1
    MOVE.B  LAB_22B3,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_0A9E(PC)

    ADDQ.W  #8,A7

LAB_0A4C:
    MOVE.W  LAB_1B16,D0
    SUBQ.W  #1,D0
    BNE.S   LAB_0A4E

    TST.W   LAB_22B5
    BEQ.S   LAB_0A4E

    CLR.W   LAB_1B16
    MOVE.W  LAB_22B5,D0
    BTST    #1,D0
    BEQ.S   LAB_0A4D

    MOVEQ   #0,D0
    MOVE.B  LAB_22B6,D0
    MOVEQ   #0,D1
    MOVE.B  LAB_22B7,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_0AA2(PC)

    ADDQ.W  #8,A7
    BRA.S   LAB_0A4E

LAB_0A4D:
    MOVEQ   #0,D0
    MOVE.B  LAB_22B6,D0
    MOVEQ   #0,D1
    MOVE.B  LAB_22B7,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_0A9E(PC)

    ADDQ.W  #8,A7

LAB_0A4E:
    MOVE.W  LAB_1B17,D0
    SUBQ.W  #1,D0
    BNE.S   LAB_0A50

    TST.W   LAB_22B9
    BEQ.S   LAB_0A50

    CLR.W   LAB_1B17
    MOVE.W  LAB_22B9,D0
    BTST    #1,D0
    BEQ.S   LAB_0A4F

    MOVEQ   #0,D0
    MOVE.B  LAB_22BA,D0
    MOVEQ   #0,D1
    MOVE.B  LAB_22BB,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_0AA2(PC)

    ADDQ.W  #8,A7
    BRA.S   LAB_0A50

LAB_0A4F:
    MOVEQ   #0,D0
    MOVE.B  LAB_22BA,D0
    MOVEQ   #0,D1
    MOVE.B  LAB_22BB,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_0A9E(PC)

    ADDQ.W  #8,A7

LAB_0A50:
    MOVE.W  LAB_1B18,D0
    SUBQ.W  #1,D0
    BNE.S   LAB_0A52

    TST.W   LAB_22BD
    BEQ.S   LAB_0A52

    CLR.W   LAB_1B18
    MOVE.W  LAB_22BD,D0
    BTST    #1,D0
    BEQ.S   LAB_0A51

    MOVEQ   #0,D0
    MOVE.B  LAB_22BE,D0
    MOVEQ   #0,D1
    MOVE.B  LAB_22BF,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_0AA2(PC)

    ADDQ.W  #8,A7
    BRA.S   LAB_0A52

LAB_0A51:
    MOVEQ   #0,D0
    MOVE.B  LAB_22BE,D0
    MOVEQ   #0,D1
    MOVE.B  LAB_22BF,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_0A9E(PC)

    ADDQ.W  #8,A7

LAB_0A52:
    MOVEA.L (A7)+,A4
    RTS

;!======

LAB_0A53:
    LINK.W  A5,#-16
    MOVEM.L D2/D4-D7,-(A7)
    MOVEQ   #0,D0
    MOVE.B  LAB_22AE,D0
    MOVEQ   #1,D1
    ASL.L   D0,D1
    MOVE.L  D1,D4
    MOVEQ   #0,D0
    MOVE.B  LAB_2295,D0
    MOVEQ   #0,D1
    MOVE.B  LAB_2296,D1
    ADD.L   D1,D0
    MOVEQ   #0,D1
    MOVE.B  LAB_2297,D1
    ADD.L   D1,D0
    MOVE.L  D0,D6
    CLR.L   -14(A5)
    MOVEQ   #1,D7

LAB_0A54:
    MOVE.L  D7,D0
    EXT.L   D0
    CMP.L   D4,D0
    BGE.S   LAB_0A56

    MOVE.L  D7,D0
    MOVEQ   #3,D1
    MULS    D1,D0
    LEA     LAB_2295,A0
    ADDA.L  D0,A0
    MOVE.L  D7,D0
    MULS    D1,D0
    LEA     LAB_2296,A1
    ADDA.L  D0,A1
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVEQ   #0,D2
    MOVE.B  (A1),D2
    ADD.L   D2,D0
    MOVE.L  D7,D2
    MULS    D1,D2
    LEA     LAB_2297,A0
    ADDA.L  D2,A0
    MOVEQ   #0,D1
    MOVE.B  (A0),D1
    ADD.L   D1,D0
    MOVE.L  D0,D5
    CMP.W   D5,D6
    BGE.S   LAB_0A55

    MOVE.L  D5,D6
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-14(A5)

LAB_0A55:
    ADDQ.W  #1,D7
    BRA.S   LAB_0A54

LAB_0A56:
    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVEA.L A0,A1
    MOVE.L  -14(A5),D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEM.L (A7)+,D2/D4-D7
    UNLK    A5
    RTS

;!======

LAB_0A57:
    LINK.W  A5,#-36
    MOVEM.L D2/D4-D7,-(A7)
    MOVE.W  10(A5),D7
    TST.W   D7
    BEQ.S   LAB_0A58

    MOVE.L  LAB_1ED2,-22(A5)

LAB_0A58:
    TST.W   D7
    BNE.S   LAB_0A59

    MOVEA.L LAB_1ED3,A0
    MOVE.L  A0,-22(A5)

LAB_0A59:
    TST.L   -22(A5)
    BEQ.W   LAB_0A72

    BSR.W   LAB_0A49

    MOVEQ   #20,D6
    MOVEA.L -22(A5),A0
    ADD.W   178(A0),D6
    BTST    #2,199(A0)
    BEQ.S   LAB_0A5A

    MOVEQ   #2,D0
    BRA.S   LAB_0A5B

LAB_0A5A:
    MOVEQ   #1,D0

LAB_0A5B:
    MOVE.L  D6,D1
    EXT.L   D1
    MOVE.L  D0,20(A7)
    MOVE.L  D1,D0
    MOVE.L  20(A7),D1
    JSR     JMP_TBL_LAB_1A07_2(PC)

    MOVE.L  D0,D6
    MOVEQ   #120,D0
    CMP.W   D0,D6
    BLE.S   LAB_0A5C

    MOVE.L  D0,D6

LAB_0A5C:
    ADDI.W  #22,D6
    MOVE.L  D6,D0
    EXT.L   D0
    PEA     1000.W
    MOVE.L  D0,-(A7)
    JSR     JMP_TBL_LAB_14D0_2(PC)

    ADDQ.W  #8,A7

LAB_0A5D:
    TST.W   LAB_2121
    BNE.S   LAB_0A5D

    MOVE.W  #1,LAB_22AA
    CLR.W   LAB_22AB
    MOVEQ   #0,D5

LAB_0A5E:
    MOVEQ   #4,D0
    CMP.L   D0,D5
    BGE.S   LAB_0A5F

    MOVE.L  D5,D0
    ASL.L   #3,D0
    MOVEA.L -22(A5),A0
    ADDA.L  D0,A0
    LEA     200(A0),A1
    LEA     LAB_22AF,A0
    ADDA.L  D0,A0
    MOVE.L  A0,28(A7)
    MOVEA.L A1,A0
    MOVEA.L 28(A7),A1
    MOVEQ   #8,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCopyMem(A6)

    ADDQ.L  #1,D5
    BRA.S   LAB_0A5E

LAB_0A5F:
    CLR.W   LAB_22AA
    MOVE.W  #1,LAB_22AB
    MOVE.L  #$8004,D0
    MOVEA.L -22(A5),A0
    AND.L   196(A0),D0
    CMPI.L  #$8004,D0
    BNE.S   LAB_0A60

    MOVEQ   #0,D0
    MOVE.B  184(A0),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    PEA     4.W
    JSR     LAB_0A97(PC)

    LEA     12(A7),A7
    MOVE.L  D0,LAB_2216
    MOVEQ   #20,D4
    BRA.S   LAB_0A63

LAB_0A60:
    BTST    #7,198(A0)
    BEQ.S   LAB_0A61

    MOVEQ   #0,D0
    MOVE.B  184(A0),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    PEA     6.W
    JSR     LAB_0A97(PC)

    LEA     12(A7),A7
    MOVE.L  D0,LAB_2216
    MOVEQ   #10,D4
    BRA.S   LAB_0A63

LAB_0A61:
    BTST    #2,199(A0)
    BEQ.S   LAB_0A62

    MOVEQ   #0,D0
    MOVE.B  184(A0),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    PEA     5.W
    JSR     LAB_0A97(PC)

    LEA     12(A7),A7
    MOVE.L  D0,LAB_2216
    MOVEQ   #20,D4
    BRA.S   LAB_0A63

LAB_0A62:
    MOVEQ   #0,D0
    MOVE.B  184(A0),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    PEA     7.W
    JSR     LAB_0A97(PC)

    LEA     12(A7),A7
    MOVE.L  D0,LAB_2216
    MOVEQ   #10,D4

LAB_0A63:
    MOVEA.L D0,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVEA.L A0,A1
    MOVEQ   #7,D0
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVEA.L LAB_2216,A0
    MOVE.W  2(A0),D0
    SUBQ.L  #1,D0
    MOVEQ   #0,D1
    MOVE.W  4(A0),D1
    SUBQ.L  #1,D1
    LEA     10(A0),A1
    MOVEQ   #0,D2
    MOVE.L  D2,-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  -22(A5),-(A7)
    JSR     LAB_0AB4(PC)

    LEA     28(A7),A7
    MOVEA.L -22(A5),A0
    TST.L   328(A0)
    BEQ.S   LAB_0A64

    MOVEQ   #1,D0
    CMP.L   328(A0),D0
    BNE.S   LAB_0A66

LAB_0A64:
    PEA     5.W
    JSR     LAB_0BF4(PC)

    MOVE.L  D0,D1
    LSL.L   #2,D1
    SUB.L   D0,D1
    MOVEQ   #0,D0
    MOVEA.L -22(A5),A0
    MOVE.B  184(A0),D0
    MOVE.L  D0,(A7)
    MOVE.L  D1,-14(A5)
    JSR     LAB_0BF4(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D1
    LSL.L   #2,D1
    SUB.L   D0,D1
    MOVEQ   #0,D5
    MOVE.L  D1,-18(A5)

LAB_0A65:
    CMP.L   -18(A5),D5
    BGE.S   LAB_0A66

    CMP.L   -14(A5),D5
    BGE.S   LAB_0A66

    LEA     LAB_2295,A0
    ADDA.L  D5,A0
    MOVEA.L -22(A5),A1
    MOVE.L  D5,D0
    ADDI.L  #$e8,D0
    MOVE.B  0(A1,D0.L),(A0)
    ADDQ.L  #1,D5
    BRA.S   LAB_0A65

LAB_0A66:
    MOVE.B  LAB_22B2,D0
    MOVEQ   #32,D1
    CMP.B   D1,D0
    BCC.S   LAB_0A67

    MOVE.B  LAB_22B3,D0
    CMP.B   D1,D0
    BCC.S   LAB_0A67

    MOVE.W  LAB_22B0,D0
    CMPI.W  #$4000,D0
    BGE.S   LAB_0A67

    MOVE.W  D0,LAB_1B0D
    BRA.S   LAB_0A68

LAB_0A67:
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_1B0D

LAB_0A68:
    MOVE.B  LAB_22B6,D2
    CMP.B   D1,D2
    BCC.S   LAB_0A69

    MOVE.B  LAB_22B7,D2
    CMP.B   D1,D2
    BCC.S   LAB_0A69

    MOVE.W  LAB_22B4,D2
    CMPI.W  #$4000,D2
    BGE.S   LAB_0A69

    MOVE.W  D2,LAB_1B0E
    BRA.S   LAB_0A6A

LAB_0A69:
    MOVEQ   #0,D2
    MOVE.W  D2,LAB_1B0E

LAB_0A6A:
    MOVE.B  LAB_22BA,D0
    CMP.B   D1,D0
    BCC.S   LAB_0A6B

    MOVE.B  LAB_22BB,D0
    CMP.B   D1,D0
    BCC.S   LAB_0A6B

    MOVE.W  LAB_22B8,D0
    CMPI.W  #$4000,D0
    BGE.S   LAB_0A6B

    MOVE.W  D0,LAB_1B0F
    BRA.S   LAB_0A6C

LAB_0A6B:
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_1B0F

LAB_0A6C:
    MOVE.B  LAB_22BE,D2
    CMP.B   D1,D2
    BCC.S   LAB_0A6D

    MOVE.B  LAB_22BF,D2
    CMP.B   D1,D2
    BCC.S   LAB_0A6D

    MOVE.W  LAB_22BC,D1
    CMPI.W  #$4000,D1
    BGE.S   LAB_0A6D

    MOVE.W  D1,LAB_1B10
    BRA.S   LAB_0A6E

LAB_0A6D:
    MOVEQ   #0,D1
    MOVE.W  D1,LAB_1B10

LAB_0A6E:
    TST.W   LAB_1B0D
    BNE.S   LAB_0A6F

    TST.W   LAB_1B0E
    BNE.S   LAB_0A6F

    TST.W   LAB_1B0F
    BNE.S   LAB_0A6F

    TST.W   D1
    BEQ.S   LAB_0A70

LAB_0A6F:
    MOVE.W  #1,LAB_22AA
    BRA.S   LAB_0A71

LAB_0A70:
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_22AA

LAB_0A71:
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_1B11
    MOVE.W  D0,LAB_1B15
    MOVE.W  D0,LAB_1B12
    MOVE.W  D0,LAB_1B16
    MOVE.W  D0,LAB_1B13
    MOVE.W  D0,LAB_1B17
    MOVE.W  D0,LAB_1B14
    MOVE.W  D0,LAB_1B18
    BSR.W   LAB_0A48

    BRA.S   LAB_0A75

LAB_0A72:
    TST.W   D7
    BEQ.S   LAB_0A73

    MOVEQ   #1,D0
    BRA.S   LAB_0A74

LAB_0A73:
    MOVEQ   #2,D0

LAB_0A74:
    OR.L    D0,LAB_1EE4

LAB_0A75:
    MOVEM.L (A7)+,D2/D4-D7
    UNLK    A5
    RTS

;!======

LAB_0A76:
    MOVE.L  D7,-(A7)
    MOVE.W  10(A7),D7
    TST.W   GLOB_WORD_SELECT_CODE_IS_RAVESC
    BNE.S   .return

    JSR     LAB_08C2(PC)

    TST.W   LAB_1B85
    BNE.S   .return

    TST.W   D7
    BEQ.S   .LAB_0A77

    MOVEQ   #0,D0
    MOVE.W  D0,LAB_22C0
    MOVEQ   #-1,D1
    MOVE.W  D1,LAB_22C1
    BRA.S   .LAB_0A78

.LAB_0A77:
    CLR.W   LAB_22C1
    MOVE.W  #(-1),LAB_22C0

.LAB_0A78:
    TST.L   LAB_2318
    BNE.S   .LAB_0A79

    MOVE.W  LAB_22A9,D0
    ANDI.W  #2,D0
    SUBQ.W  #2,D0
    BEQ.S   .LAB_0A79

    CLR.L   -(A7)
    BSR.W   LAB_0A0B

    ADDQ.W  #4,A7

.LAB_0A79:
    TST.L   LAB_2319
    BNE.S   .LAB_0A7A

    MOVE.W  LAB_22A9,D0
    ANDI.W  #1,D0
    SUBQ.W  #1,D0
    BEQ.S   .LAB_0A7A

    PEA     1.W
    BSR.W   LAB_0A0B

    ADDQ.W  #4,A7

.LAB_0A7A:
    JSR     LAB_08C2(PC)

    BSR.W   LAB_0A14

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======

LAB_0A7C:
    LINK.W  A5,#-8
    MOVEM.L D6-D7,-(A7)
    MOVE.W  10(A5),D7
    BSR.W   LAB_0A49

    TST.W   D7
    BEQ.S   LAB_0A7D

    TST.L   LAB_1ED2
    BNE.S   LAB_0A7E

LAB_0A7D:
    TST.W   D7
    BNE.W   LAB_0A87

    TST.L   LAB_1ED3
    BEQ.W   LAB_0A87

LAB_0A7E:
    MOVE.W  LAB_2231,D0
    MOVE.W  LAB_22C2,D1
    CMP.W   D1,D0
    BCC.S   LAB_0A7F

    TST.W   D7
    BNE.S   LAB_0A7F

    TST.W   LAB_22C3
    BNE.S   LAB_0A7F

    BSR.W   LAB_0A45

    JSR     LAB_08B8(PC)

    PEA     2.W
    JSR     LAB_09A7(PC)

    ADDQ.W  #4,A7
    BRA.W   LAB_0A88

LAB_0A7F:
    JSR     LAB_08B8(PC)

    PEA     1.W
    CLR.L   -(A7)
    PEA     4.W
    JSR     LAB_0A97(PC)

    MOVE.L  D0,LAB_2216
    MOVEA.L D0,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVEA.L A0,A1
    MOVEQ   #2,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    JSR     LAB_08C2(PC)

    LEA     12(A7),A7
    TST.W   D7
    BEQ.S   LAB_0A80

    MOVEA.L LAB_1ED2,A0
    BRA.S   LAB_0A81

LAB_0A80:
    MOVEA.L LAB_1ED3,A0

LAB_0A81:
    MOVE.L  A0,-6(A5)
    JSR     LAB_0A9C(PC)

    MOVEQ   #1,D0
    CMP.W   D0,D7
    BNE.S   LAB_0A83

    MOVE.W  LAB_1DDE,D0
    SUBQ.W  #2,D0
    BEQ.S   LAB_0A82

    MOVE.W  LAB_1DDE,D0
    SUBQ.W  #3,D0
    BNE.S   LAB_0A83

LAB_0A82:
    JSR     LAB_0AAD(PC)

LAB_0A83:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0A57

    ADDQ.W  #4,A7
    TST.W   D7
    BNE.S   LAB_0A84

    TST.W   LAB_22C3
    BNE.S   LAB_0A84

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    BSR.W   LAB_0A53

    MOVE.W  LAB_22C2,LAB_2364
    PEA     2.W
    PEA     1.W
    JSR     LAB_0A9D(PC)

    ADDQ.W  #8,A7
    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVEA.L A0,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

LAB_0A84:
    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVEA.L A0,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    TST.W   D7
    BEQ.S   LAB_0A85

    SUBQ.L  #1,LAB_1B27
    MOVE.L  LAB_1ED2,-(A7)
    JSR     LAB_0AA6(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,LAB_1ED2
    BRA.S   LAB_0A86

LAB_0A85:
    SUBQ.L  #1,LAB_1B28
    MOVE.L  LAB_1ED3,-(A7)
    JSR     LAB_0AA6(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,LAB_1ED3

LAB_0A86:
    MOVEA.L AbsExecBase,A6
    JSR     _LVOPermit(A6)

    BRA.S   LAB_0A88

LAB_0A87:
    BSR.W   LAB_0A45

    JSR     LAB_08B8(PC)

    PEA     2.W
    JSR     LAB_09A7(PC)

    ADDQ.W  #4,A7

LAB_0A88:
    MOVE.W  LAB_22AA,D6
    CLR.W   LAB_22AA
    BSR.W   LAB_0A48

    MOVE.W  D6,LAB_22AA
    TST.W   D7
    BEQ.S   LAB_0A89

    PEA     1.W
    BSR.W   LAB_0A76

    ADDQ.W  #4,A7
    BRA.S   LAB_0A8A

LAB_0A89:
    CLR.L   -(A7)
    BSR.W   LAB_0A76

    ADDQ.W  #4,A7

LAB_0A8A:
    MOVEM.L (A7)+,D6-D7
    UNLK    A5
    RTS

;!======

DEALLOC_ADS_AND_LOGO_LST_DATA:
    TST.L   GLOB_REF_LONG_GFX_G_ADS_DATA
    BEQ.S   .deallocLogoLstData

    TST.L   GLOB_REF_LONG_GFX_G_ADS_FILESIZE
    BEQ.S   .deallocLogoLstData

    MOVE.L  GLOB_REF_LONG_GFX_G_ADS_FILESIZE,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  GLOB_REF_LONG_GFX_G_ADS_DATA,-(A7)
    PEA     1988.W
    PEA     GLOB_STR_ESQIFF_C_7
    JSR     JMP_TBL_DEALLOCATE_MEMORY_2(PC)

    LEA     16(A7),A7
    CLR.L   GLOB_REF_LONG_GFX_G_ADS_DATA
    CLR.L   GLOB_REF_LONG_GFX_G_ADS_FILESIZE

.deallocLogoLstData:
    TST.L   GLOB_REF_LONG_DF0_LOGO_LST_DATA
    BEQ.S   .return

    TST.L   GLOB_REF_LONG_DF0_LOGO_LST_FILESIZE
    BEQ.S   .return

    MOVE.L  GLOB_REF_LONG_DF0_LOGO_LST_FILESIZE,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  GLOB_REF_LONG_DF0_LOGO_LST_DATA,-(A7)
    PEA     1994.W
    PEA     GLOB_STR_ESQIFF_C_8
    JSR     JMP_TBL_DEALLOCATE_MEMORY_2(PC)

    LEA     16(A7),A7
    CLR.L   GLOB_REF_LONG_DF0_LOGO_LST_DATA
    CLR.L   GLOB_REF_LONG_DF0_LOGO_LST_FILESIZE

.return:
    RTS

;!======

LAB_0A8E:
    MOVE.W  LAB_1B19,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   LAB_0A8F

    JSR     LAB_0AA8(PC)

    MOVE.W  LAB_1B19,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,LAB_1B19
    BRA.S   LAB_0A8E

LAB_0A8F:
    MOVE.W  LAB_1B1A,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   LAB_0A90

    JSR     LAB_0AAB(PC)

    MOVE.W  LAB_1B1A,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,LAB_1B1A
    BRA.S   LAB_0A8F

LAB_0A90:
    MOVE.W  LAB_1B1B,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   LAB_0A91

    JSR     LAB_0AB3(PC)

    MOVE.W  LAB_1B1B,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,LAB_1B1B
    BRA.S   LAB_0A90

LAB_0A91:
    MOVE.W  LAB_1B1C,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   LAB_0A92

    JSR     LAB_0AB2(PC)

    MOVE.W  LAB_1B1C,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,LAB_1B1C
    BRA.S   LAB_0A91

LAB_0A92:
    RTS

;!======

LAB_0A93:
    MOVE.L  D7,-(A7)

    MOVE.B  11(A7),D7
    MOVEQ   #97,D0
    CMP.B   D0,D7
    BNE.S   .return

    JSR     LAB_0AA0(PC)

    CLR.L   -(A7)
    PEA     LAB_1ED1
    JSR     LAB_0AA4(PC)

    PEA     GLOB_STR_DF0_BRUSH_INI_2
    JSR     JMP_TBL_PARSE_INI(PC)

    PEA     LAB_1ED1
    MOVE.L  LAB_1B1F,-(A7)
    JSR     LAB_0DFA(PC)

    PEA     LAB_1EF8
    JSR     LAB_0AB5(PC)

    LEA     24(A7),A7
    TST.L   BRUSH_SelectedNode
    BNE.S   .LAB_0A94

    PEA     LAB_1ED1
    PEA     LAB_1EF9
    JSR     LAB_0AA3(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,BRUSH_SelectedNode

.LAB_0A94:
    PEA     LAB_1ED1
    JSR     LAB_0AA5(PC)

    MOVE.L  D0,LAB_1ED0
    JSR     LAB_0AB7(PC)

    ADDQ.W  #4,A7

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======

    ; Alignment bytes
    DC.W    $0000

;!======

JMP_TBL_LAB_1968_2:
    JMP     LAB_1968

LAB_0A97:
    JMP     LAB_183E

JMP_TBL_GET_FILESIZE_FROM_HANDLE:
    JMP     GET_FILESIZE_FROM_HANDLE

JMP_TBL_LAB_1A07_2:
    JMP     LAB_1A07

LAB_0A9A:
    JMP     LAB_1697

JMP_TBL_LAB_195B_2:
    JMP     LAB_195B

LAB_0A9C:
    JMP     LAB_005C

LAB_0A9D:
    JMP     LAB_16E3

LAB_0A9E:
    JMP     LAB_005D

JMP_TBL_DEALLOCATE_MEMORY_2:
    JMP     DEALLOCATE_MEMORY

LAB_0AA0:
    JMP     LAB_03CB

LAB_0AA1:
    JMP     BRUSH_CloneBrushRecord

LAB_0AA2:
    JMP     LAB_0062

LAB_0AA3:
    JMP     BRUSH_FindBrushByPredicate

LAB_0AA4:
    JMP     BRUSH_FreeBrushList

LAB_0AA5:
    JMP     BRUSH_FindType3Brush

LAB_0AA6:
    JMP     BRUSH_PopBrushHead

LAB_0AA7:
    JMP     BRUSH_AllocBrushNode

LAB_0AA8:
    JMP     LAB_006A

LAB_0AA9:
    JMP     LAB_1038

LAB_0AAA:
    JMP     BRUSH_PopulateBrushList

LAB_0AAB:
    JMP     LAB_0074

LAB_0AAC:
    JMP     LAB_194E

LAB_0AAD:
    JMP     LAB_14B3

JMP_TBL_LAB_14D0_2:
    JMP     LAB_14D0

JMP_TBL_ALLOCATE_MEMORY_2:
    JMP     ALLOCATE_MEMORY

LAB_0AB0:
    JMP     LAB_038E

JMP_TBL_OPEN_FILE_WITH_ACCESS_MODE_2:
    JMP     OPEN_FILE_WITH_ACCESS_MODE

LAB_0AB2:
    JMP     LAB_0071

LAB_0AB3:
    JMP     LAB_0067

LAB_0AB4:
    JMP     BRUSH_SelectBrushSlot

LAB_0AB5:
    JMP     BRUSH_SelectBrushByLabel

JMP_TBL_LAB_1A06_4:
    JMP     LAB_1A06

LAB_0AB7:
    JMP     LAB_03CD

;!======

LAB_0AB8:
    MOVEM.L D2/D6-D7/A3,-(A7)
    MOVEA.L 20(A7),A3

    MOVE.B  LAB_1DD7,D6
    MOVEQ   #0,D7

LAB_0AB9:
    MOVEQ   #20,D0
    CMP.W   D0,D7
    BGE.S   LAB_0ABA

    LEA     LAB_1DC8,A0
    ADDA.W  D7,A0
    MOVE.B  0(A3,D7.W),(A0)
    ADDQ.W  #1,D7
    BRA.S   LAB_0AB9

LAB_0ABA:
    TST.L   LAB_1FE6
    BNE.S   LAB_0ABB

    MOVE.B  LAB_1DD7,D0
    CMP.B   D0,D6
    BEQ.S   LAB_0ABB

    MOVE.W  LAB_2346,D0
    BEQ.S   LAB_0ABB

    MOVEQ   #1,D0
    MOVE.L  D0,LAB_2125

LAB_0ABB:
    MOVE.B  LAB_1DD1,D0
    MOVEQ   #49,D1
    CMP.B   D1,D0
    BCS.S   LAB_0ABC

    MOVEQ   #72,D1
    CMP.B   D1,D0
    BLS.S   LAB_0ABD

LAB_0ABC:
    MOVE.B  #$36,LAB_1DD1

LAB_0ABD:
    PEA     LAB_21DF
    JSR     LAB_0BFE(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BNE.S   LAB_0ABE

    JSR     LAB_0C05(PC)

LAB_0ABE:
    PEA     1.W
    JSR     ESQDISP_DrawStatusBanner(PC)

    ADDQ.W  #4,A7
    MOVE.B  LAB_1DCF,D0
    MOVEQ   #9,D1
    CMP.B   D1,D0
    BHI.S   LAB_0ABF

    MOVEQ   #0,D2
    CMP.B   D2,D0
    BHI.S   LAB_0AC0

LAB_0ABF:
    MOVEQ   #1,D2
    MOVE.B  D2,LAB_1DCF

LAB_0AC0:
    MOVE.B  LAB_1DD0,D0
    CMP.B   D1,D0
    BHI.S   LAB_0AC1

    MOVEQ   #0,D1
    CMP.B   D1,D0
    BHI.S   LAB_0AC2

LAB_0AC1:
    MOVEQ   #1,D1
    MOVE.B  D1,LAB_1DD0

LAB_0AC2:
    MOVEQ   #0,D0
    MOVE.B  LAB_1DCF,D0
    MOVEQ   #0,D1
    MOVE.B  LAB_1DD0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_0BF1(PC)

    ADDQ.W  #8,A7
    TST.W   LAB_2252
    BEQ.S   LAB_0AC3

    JSR     DRAW_DIAGNOSTIC_MODE_TEXT(PC)

LAB_0AC3:
    TST.L   LAB_21E2
    BNE.S   LAB_0AC5

    MOVEQ   #0,D0
    MOVE.B  GLOB_STR_SATELLITE_DELIVERED_SCROLL_SPEED,D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVE.L  D0,D7
    MOVEQ   #1,D0
    CMP.W   D0,D7
    BLT.S   LAB_0AC4

    MOVEQ   #8,D1
    CMP.W   D1,D7
    BGT.S   LAB_0AC4

    MOVE.W  D7,LAB_1F40
    BRA.S   LAB_0AC5

LAB_0AC4:
    MOVE.W  #4,LAB_1F40

LAB_0AC5:
    MOVE.W  #1,LAB_2299
    MOVEM.L (A7)+,D2/D6-D7/A3
    RTS

;!======

LAB_0AC6:
    MOVE.L  D7,-(A7)
    MOVE.B  11(A7),D7

    MOVEQ   #1,D0
    CMP.B   D0,D7
    BLT.S   .return

    MOVEQ   #48,D1
    CMP.B   D1,D7
    BGT.S   .return

    MOVE.L  D7,D0

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======

LAB_0AC8:
    MOVE.L  D7,-(A7)
    MOVE.W  10(A7),D7
    MOVEQ   #2,D0
    CMP.W   D0,D7
    BNE.S   LAB_0AC9

    MOVE.L  LAB_1DE9,-(A7)
    CLR.L   -(A7)
    BSR.W   LAB_0B44

    MOVE.L  D0,LAB_1DE9
    MOVE.L  LAB_1DEA,(A7)
    CLR.L   -(A7)
    BSR.W   LAB_0B44

    LEA     12(A7),A7
    MOVE.L  D0,LAB_1DEA
    BRA.S   LAB_0ACA

LAB_0AC9:
    MOVE.L  LAB_1DDB,-(A7)
    CLR.L   -(A7)
    BSR.W   LAB_0B44

    MOVE.L  D0,LAB_1DDB
    MOVE.L  LAB_1DDC,(A7)
    CLR.L   -(A7)
    BSR.W   LAB_0B44

    LEA     12(A7),A7
    MOVE.L  D0,LAB_1DDC

LAB_0ACA:
    MOVE.L  (A7)+,D7
    RTS

;!======

LAB_0ACB:
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVEQ   #0,D0
    MOVE.B  (A3),D0
    MOVEQ   #0,D1
    NOT.B   D1
    AND.L   D1,D0
    MOVE.L  D0,D7
    MOVE.B  LAB_2230,D0
    CMP.B   D0,D7
    BNE.W   LAB_0AD1

    PEA     1.W
    BSR.W   LAB_0AC8

    ADDQ.W  #4,A7
    MOVEQ   #18,D0
    CMP.B   1(A3),D0
    BNE.S   LAB_0ACD

    SUBA.L  A0,A0
    MOVE.L  A0,LAB_1DDB
    MOVEQ   #0,D1
    MOVE.W  LAB_2232,D1
    CMP.B   -1(A3,D1.L),D0
    BNE.S   LAB_0ACC

    MOVE.L  A0,LAB_1DDC
    BRA.W   LAB_0AD7

LAB_0ACC:
    LEA     2(A3),A0
    MOVE.L  LAB_1DDC,-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   LAB_0B44

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_1DDC
    BRA.W   LAB_0AD7

LAB_0ACD:
    MOVEQ   #0,D0
    MOVE.W  LAB_2232,D0
    MOVEQ   #18,D1
    CMP.B   -1(A3,D0.L),D1
    BNE.S   LAB_0ACE

    MOVEQ   #0,D1
    MOVE.W  D0,D1
    CLR.B   -1(A3,D1.L)
    LEA     1(A3),A0
    MOVE.L  LAB_1DDB,-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   LAB_0B44

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_1DDB
    CLR.L   LAB_1DDC
    BRA.W   LAB_0AD7

LAB_0ACE:
    MOVEQ   #3,D6

LAB_0ACF:
    MOVEQ   #18,D0
    CMP.B   0(A3,D6.W),D0
    BEQ.S   LAB_0AD0

    MOVEQ   #103,D0
    CMP.W   D0,D6
    BGE.S   LAB_0AD0

    ADDQ.W  #1,D6
    BRA.S   LAB_0ACF

LAB_0AD0:
    CLR.B   0(A3,D6.W)
    LEA     1(A3),A0
    MOVE.L  LAB_1DDB,-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   LAB_0B44

    MOVE.L  D0,LAB_1DDB
    MOVE.L  D6,D0
    EXT.L   D0
    MOVEA.L A3,A0
    ADDA.L  D0,A0
    LEA     1(A0),A1
    MOVE.L  LAB_1DDC,(A7)
    MOVE.L  A1,-(A7)
    BSR.W   LAB_0B44

    LEA     12(A7),A7
    MOVE.L  D0,LAB_1DDC
    BRA.W   LAB_0AD7

LAB_0AD1:
    MOVE.B  LAB_222D,D0
    CMP.B   D0,D7
    BNE.W   LAB_0AD7

    PEA     2.W
    BSR.W   LAB_0AC8

    ADDQ.W  #4,A7
    MOVE.W  #1,LAB_228F
    MOVEQ   #18,D0
    CMP.B   1(A3),D0
    BNE.S   LAB_0AD3

    SUBA.L  A0,A0
    MOVE.L  A0,LAB_1DE9
    MOVEQ   #0,D1
    MOVE.W  LAB_2232,D1
    CMP.B   -1(A3,D1.L),D0
    BNE.S   LAB_0AD2

    MOVE.L  A0,LAB_1DEA
    BRA.W   LAB_0AD7

LAB_0AD2:
    LEA     2(A3),A0
    MOVE.L  LAB_1DEA,-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   LAB_0B44

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_1DEA
    BRA.W   LAB_0AD7

LAB_0AD3:
    MOVEQ   #0,D0
    MOVE.W  LAB_2232,D0
    MOVEQ   #18,D1
    CMP.B   -1(A3,D0.L),D1
    BNE.S   LAB_0AD4

    LEA     1(A3),A0
    MOVE.L  LAB_1DE9,-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   LAB_0B44

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_1DE9
    CLR.L   LAB_1DEA
    BRA.S   LAB_0AD7

LAB_0AD4:
    MOVEQ   #3,D6

LAB_0AD5:
    MOVEQ   #18,D0
    CMP.B   0(A3,D6.W),D0
    BEQ.S   LAB_0AD6

    MOVEQ   #103,D0
    CMP.W   D0,D6
    BGE.S   LAB_0AD6

    ADDQ.W  #1,D6
    BRA.S   LAB_0AD5

LAB_0AD6:
    CLR.B   0(A3,D6.W)
    LEA     1(A3),A0
    MOVE.L  LAB_1DE9,-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   LAB_0B44

    MOVE.L  D0,LAB_1DE9
    MOVE.L  D6,D0
    EXT.L   D0
    MOVEA.L A3,A0
    ADDA.L  D0,A0
    LEA     1(A0),A1
    MOVE.L  LAB_1DEA,(A7)
    MOVE.L  A1,-(A7)
    BSR.W   LAB_0B44

    LEA     12(A7),A7
    MOVE.L  D0,LAB_1DEA

LAB_0AD7:
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======

LAB_0AD8:
    LINK.W  A5,#-20
    MOVEM.L D2/D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEQ   #0,D0
    MOVE.B  (A3)+,D0
    MOVEQ   #0,D1
    NOT.B   D1
    AND.L   D1,D0
    MOVE.L  D0,D7
    MOVE.B  LAB_2230,D0
    CMP.B   D0,D7
    BNE.S   LAB_0ADA

    MOVE.W  LAB_2248,D0
    MOVE.W  LAB_2232,D1
    CMP.W   D1,D0
    BNE.S   LAB_0AD9

    MOVE.B  LAB_2247,D0
    MOVE.B  LAB_2253,D2
    CMP.B   D2,D0
    BEQ.S   LAB_0ADA

LAB_0AD9:
    MOVE.W  D1,LAB_2248
    MOVE.B  LAB_2253,LAB_2247
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_224C
    MOVE.W  LAB_2231,D1
    CMP.W   D0,D1
    BLS.S   LAB_0ADD

    PEA     1.W
    BSR.W   LAB_0B38

    ADDQ.W  #4,A7
    MOVEQ   #1,D0
    MOVE.L  D0,LAB_225F
    BRA.S   LAB_0ADD

LAB_0ADA:
    MOVE.B  LAB_222D,D0
    CMP.B   D0,D7
    BNE.S   LAB_0ADC

    MOVE.W  LAB_224E,D0
    MOVE.W  LAB_2232,D1
    CMP.W   D1,D0
    BNE.S   LAB_0ADB

    MOVE.B  LAB_224D,D0
    MOVE.B  LAB_2253,D2
    CMP.B   D2,D0
    BEQ.S   LAB_0ADC

LAB_0ADB:
    MOVE.W  D1,LAB_224E
    MOVE.B  LAB_2253,LAB_224D
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_224C
    MOVE.W  LAB_222F,D1
    CMP.W   D0,D1
    BLS.S   LAB_0ADD

    PEA     2.W
    BSR.W   LAB_0B38

    ADDQ.W  #4,A7
    BRA.S   LAB_0ADD

LAB_0ADC:
    MOVEQ   #0,D0
    BRA.W   LAB_0AF5

LAB_0ADD:
    MOVEQ   #1,D6
    MOVEQ   #0,D0
    MOVE.B  D0,LAB_22C4
    MOVE.B  D0,LAB_22C6
    MOVEQ   #0,D5

LAB_0ADE:
    MOVEQ   #6,D0
    CMP.W   D0,D5
    BGE.S   LAB_0ADF

    LEA     LAB_22C8,A0
    ADDA.W  D5,A0
    MOVE.B  #$ff,(A0)
    ADDQ.W  #1,D5
    BRA.S   LAB_0ADE

LAB_0ADF:
    CLR.B   LAB_22C9
    MOVEQ   #0,D4
    MOVEQ   #0,D5
    MOVEQ   #1,D0
    MOVE.L  D0,-8(A5)
    CLR.L   -12(A5)
    CLR.W   -14(A5)

LAB_0AE0:
    MOVE.B  (A3)+,D0
    MOVE.B  D0,-3(A5)
    TST.B   D0
    BEQ.W   LAB_0AF3

    TST.L   -12(A5)
    BNE.W   LAB_0AF3

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    SUBQ.W  #1,D1
    BEQ.W   LAB_0AEE

    SUBI.W  #16,D1
    BEQ.W   LAB_0AE9

    SUBQ.W  #1,D1
    BEQ.S   LAB_0AE1

    SUBQ.W  #2,D1
    BEQ.W   LAB_0AEB

    BRA.W   LAB_0AF1

LAB_0AE1:
    MOVE.L  D4,D0
    EXT.L   D0
    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0AF6

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_0AE2

    MOVEQ   #1,D0
    MOVE.L  D0,-12(A5)
    BRA.S   LAB_0AE0

LAB_0AE2:
    MOVE.L  D4,D0
    MULS    #10,D0
    LEA     LAB_22C4,A0
    ADDA.L  D0,A0
    ADDA.W  D5,A0
    CLR.B   (A0)
    TST.L   -8(A5)
    BNE.S   LAB_0AE5

    TST.W   -14(A5)
    BNE.S   LAB_0AE4

    LEA     LAB_22C4,A0
    LEA     LAB_22C9,A1

LAB_0AE3:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_0AE3

LAB_0AE4:
    MOVEQ   #0,D0
    MOVE.B  D0,LAB_22C5
    MOVE.B  D0,LAB_22C7
    MOVE.B  D0,LAB_22CA
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEQ   #0,D1
    MOVE.B  D6,D1
    PEA     LAB_22C9
    PEA     LAB_22C8
    PEA     LAB_22C6
    PEA     LAB_22C4
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_0C1E(PC)

    LEA     24(A7),A7
    MOVEQ   #0,D0
    MOVE.W  D0,-14(A5)
    BRA.S   LAB_0AE6

LAB_0AE5:
    CLR.L   -8(A5)

LAB_0AE6:
    MOVEQ   #0,D0
    MOVE.B  D0,LAB_22C4
    MOVE.B  D0,LAB_22C6
    MOVEQ   #0,D5

LAB_0AE7:
    MOVEQ   #6,D0
    CMP.W   D0,D5
    BGE.S   LAB_0AE8

    LEA     LAB_22C8,A0
    ADDA.W  D5,A0
    MOVE.B  #$ff,(A0)
    ADDQ.W  #1,D5
    BRA.S   LAB_0AE7

LAB_0AE8:
    CLR.B   LAB_22C9
    MOVEQ   #0,D4
    MOVEQ   #0,D5
    MOVE.B  (A3)+,D6
    BRA.W   LAB_0AE0

LAB_0AE9:
    MOVE.L  D4,D0
    EXT.L   D0
    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0AF6

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_0AEA

    MOVEQ   #1,D0
    MOVE.L  D0,-12(A5)
    BRA.W   LAB_0AE0

LAB_0AEA:
    MOVE.L  D4,D0
    MULS    #10,D0
    LEA     LAB_22C4,A0
    ADDA.L  D0,A0
    ADDA.W  D5,A0
    CLR.B   (A0)
    MOVEQ   #1,D4
    MOVEQ   #0,D5
    BRA.W   LAB_0AE0

LAB_0AEB:
    MOVE.L  D4,D0
    EXT.L   D0
    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0AF6

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_0AEC

    MOVEQ   #1,D0
    MOVE.L  D0,-12(A5)
    BRA.W   LAB_0AE0

LAB_0AEC:
    MOVE.L  D4,D0
    MULS    #10,D0
    LEA     LAB_22C4,A0
    ADDA.L  D0,A0
    ADDA.W  D5,A0
    CLR.B   (A0)
    MOVEQ   #0,D5

LAB_0AED:
    MOVEQ   #6,D0
    CMP.W   D0,D5
    BGE.W   LAB_0AE0

    LEA     LAB_22C8,A0
    ADDA.W  D5,A0
    MOVE.B  (A3)+,(A0)
    ADDQ.W  #1,D5
    BRA.S   LAB_0AED

LAB_0AEE:
    MOVE.L  D4,D0
    EXT.L   D0
    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0AF6

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_0AEF

    MOVEQ   #1,D0
    MOVE.L  D0,-12(A5)
    BRA.W   LAB_0AE0

LAB_0AEF:
    MOVEQ   #2,D0
    CMP.W   D0,D4
    BEQ.S   LAB_0AF0

    MOVE.L  D4,D0
    MULS    #10,D0
    LEA     LAB_22C4,A0
    ADDA.L  D0,A0
    ADDA.W  D5,A0
    CLR.B   (A0)

LAB_0AF0:
    MOVEQ   #3,D4
    MOVEQ   #0,D5
    MOVE.W  #1,-14(A5)
    BRA.W   LAB_0AE0

LAB_0AF1:
    MOVE.L  D4,D0
    EXT.L   D0
    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0AF6

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_0AF2

    MOVEQ   #1,D0
    MOVE.L  D0,-12(A5)
    BRA.W   LAB_0AE0

LAB_0AF2:
    MOVE.L  D4,D0
    MULS    #10,D0
    LEA     LAB_22C4,A0
    ADDA.L  D0,A0
    MOVE.L  D5,D0
    ADDQ.W  #1,D5
    ADDA.W  D0,A0
    MOVE.B  -3(A5),(A0)
    BRA.W   LAB_0AE0

LAB_0AF3:
    MOVE.L  D4,D0
    EXT.L   D0
    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0AF6

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_0AF4

    MOVEQ   #0,D0
    BRA.S   LAB_0AF5

LAB_0AF4:
    MOVE.L  D4,D0
    MULS    #10,D0
    LEA     LAB_22C4,A0
    ADDA.L  D0,A0
    ADDA.W  D5,A0
    MOVEQ   #0,D0
    MOVE.B  D0,(A0)
    MOVE.B  D0,LAB_22C5
    MOVE.B  D0,LAB_22C7
    MOVE.B  D0,LAB_22CA
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEQ   #0,D1
    MOVE.B  D6,D1
    PEA     LAB_22C9
    PEA     LAB_22C8
    PEA     LAB_22C6
    PEA     LAB_22C4
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_0C1E(PC)

    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D0,(A7)
    BSR.W   LAB_0AFB

    JSR     LAB_0BF3(PC)

    JSR     LAB_0BEB(PC)

LAB_0AF5:
    MOVEM.L -44(A5),D2/D4-D7/A3
    UNLK    A5
    RTS

;!======

LAB_0AF6:
    MOVEM.L D6-D7,-(A7)
    MOVE.W  14(A7),D7
    MOVE.W  18(A7),D6
    MOVEQ   #3,D0
    CMP.W   D0,D7
    BLE.S   LAB_0AF7

    MOVEQ   #0,D0
    BRA.S   LAB_0AFA

LAB_0AF7:
    MOVEQ   #1,D0
    CMP.W   D0,D7
    BNE.S   LAB_0AF8

    MOVEQ   #10,D0
    CMP.W   D0,D6
    BLE.S   LAB_0AF9

    MOVEQ   #0,D0
    BRA.S   LAB_0AFA

LAB_0AF8:
    MOVEQ   #7,D0
    CMP.W   D0,D6
    BLE.S   LAB_0AF9

    MOVEQ   #0,D0
    BRA.S   LAB_0AFA

LAB_0AF9:
    MOVEQ   #1,D0

LAB_0AFA:
    MOVEM.L (A7)+,D6-D7
    RTS

;!======

LAB_0AFB:
    LINK.W  A5,#-24
    MOVEM.L D4-D7,-(A7)
    MOVE.B  11(A5),D7
    MOVE.B  LAB_222D,D0
    CMP.B   D7,D0
    BNE.S   LAB_0AFC

    MOVE.W  LAB_222F,D0
    MOVE.W  D0,-12(A5)
    BRA.S   LAB_0AFE

LAB_0AFC:
    MOVE.B  LAB_2230,D0
    CMP.B   D0,D7
    BNE.S   LAB_0AFD

    MOVE.W  LAB_2231,D0
    MOVE.W  D0,-12(A5)
    BRA.S   LAB_0AFE

LAB_0AFD:
    MOVEQ   #0,D0
    BRA.W   LAB_0B07

LAB_0AFE:
    MOVEQ   #0,D6

LAB_0AFF:
    CMP.W   -12(A5),D6
    BGE.W   LAB_0B07

    MOVE.B  LAB_222D,D0
    CMP.B   D0,D7
    BNE.S   LAB_0B00

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2235,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    BRA.S   LAB_0B01

LAB_0B00:
    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2233,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)

LAB_0B01:
    MOVEA.L -4(A5),A0
    ADDQ.L  #1,A0
    MOVEA.L A0,A1

LAB_0B02:
    TST.B   (A1)+
    BNE.S   LAB_0B02

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.W  LAB_224C,D0
    EXT.L   D0
    MOVE.L  A1,D1
    SUB.L   D1,D0
    MOVE.L  D0,D4
    TST.W   D4
    BLE.S   LAB_0B06

    MOVEQ   #0,D5

LAB_0B03:
    MOVEQ   #10,D0
    CMP.W   D0,D5
    BGE.S   LAB_0B04

    MOVE.B  #$20,-24(A5,D5.W)
    ADDQ.W  #1,D5
    BRA.S   LAB_0B03

LAB_0B04:
    CLR.B   -24(A5,D4.W)
    MOVEA.L -4(A5),A0
    ADDQ.L  #1,A0
    MOVE.L  A0,-(A7)
    PEA     -24(A5)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_2(PC)

    ADDQ.W  #8,A7
    MOVEA.L -4(A5),A0
    ADDQ.L  #1,A0
    LEA     -24(A5),A1

LAB_0B05:
    MOVE.B  (A1)+,(A0)+
    BNE.S   LAB_0B05

LAB_0B06:
    ADDQ.W  #1,D6
    BRA.W   LAB_0AFF

LAB_0B07:
    MOVEM.L (A7)+,D4-D7
    UNLK    A5
    RTS

;!======

LAB_0B08:
    LINK.W  A5,#-4
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 24(A7),A3
    MOVE.W  30(A7),D7
    MOVEQ   #0,D6

LAB_0B09:
    CMP.W   D7,D6
    BGE.S   LAB_0B0A

    JSR     LAB_096D(PC)

    MOVEA.L A3,A0
    ADDQ.L  #1,A3
    MOVE.L  A0,12(A7)
    JSR     LAB_0C03(PC)

    MOVEA.L 12(A7),A0
    MOVE.B  D0,(A0)
    ADDQ.W  #1,D6
    BRA.S   LAB_0B09

LAB_0B0A:
    MOVE.L  A3,D0
    MOVEM.L (A7)+,D6-D7/A3
    UNLK    A5
    RTS

;!======

LAB_0B0B:
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.W  26(A7),D7
    MOVEA.L 28(A7),A2
    MOVEQ   #0,D6

LAB_0B0C:
    CMP.W   D7,D6
    BGE.S   LAB_0B0D

    JSR     LAB_096D(PC)

    JSR     LAB_0C03(PC)

    MOVE.B  D0,(A3)
    ADDQ.L  #1,A3
    EOR.B   D0,(A2)
    ADDQ.W  #1,D6
    BRA.S   LAB_0B0C

LAB_0B0D:
    MOVE.L  A3,D0
    MOVEM.L (A7)+,D6-D7/A2-A3
    RTS

;!======

LAB_0B0E:
    LINK.W  A5,#-12
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVE.W  18(A5),D6
    MOVEQ   #0,D4
    MOVE.W  D4,-6(A5)

LAB_0B0F:
    CMPI.W  #$2328,D4
    BCC.W   LAB_0B15

    JSR     LAB_096D(PC)

    MOVEQ   #0,D0
    MOVE.W  D4,D0
    MOVE.L  D0,20(A7)
    JSR     LAB_0C03(PC)

    MOVE.L  20(A7),D1
    MOVE.B  D0,0(A3,D1.L)
    TST.B   D0
    BNE.S   LAB_0B11

    TST.W   D7
    BNE.S   LAB_0B10

    BRA.W   LAB_0B15

LAB_0B10:
    MOVEQ   #1,D0
    CMP.W   D0,D4
    BHI.W   LAB_0B15

LAB_0B11:
    MOVEQ   #0,D0
    MOVE.W  D4,D0
    MOVEQ   #20,D1
    CMP.B   0(A3,D0.L),D1
    BNE.S   LAB_0B13

    MOVEQ   #1,D0
    CMP.W   D0,D7
    BNE.S   LAB_0B13

    ADDQ.W  #1,D4
    MOVEQ   #0,D5

LAB_0B12:
    CMP.W   D6,D5
    BCC.S   LAB_0B0F

    JSR     LAB_096D(PC)

    MOVE.L  D4,D0
    ADDQ.W  #1,D4
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,20(A7)
    JSR     LAB_0C03(PC)

    MOVE.L  20(A7),D1
    MOVE.B  D0,0(A3,D1.L)
    ADDQ.W  #1,D5
    BRA.S   LAB_0B12

LAB_0B13:
    MOVEQ   #0,D0
    MOVE.W  D4,D0
    MOVEQ   #18,D1
    CMP.B   0(A3,D0.L),D1
    BNE.S   LAB_0B14

    MOVEQ   #1,D0
    CMP.W   D0,D7
    BNE.S   LAB_0B14

    ADDQ.W  #1,D4
    JSR     LAB_096D(PC)

    MOVE.L  D4,D0
    ADDQ.W  #1,D4
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,20(A7)
    JSR     LAB_0C03(PC)

    MOVE.L  20(A7),D1
    MOVE.B  D0,0(A3,D1.L)
    ADDQ.W  #1,-6(A5)
    CMPI.W  #$12e,-6(A5)
    BCS.W   LAB_0B0F

    MOVEQ   #0,D0
    BRA.S   LAB_0B16

LAB_0B14:
    ADDQ.W  #1,D4
    BRA.W   LAB_0B0F

LAB_0B15:
    JSR     LAB_096D(PC)

    JSR     LAB_0C03(PC)

    MOVE.B  D0,LAB_2253
    MOVE.L  D4,D0

LAB_0B16:
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======

LAB_0B17:
    LINK.W  A5,#-4
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 32(A7),A3
    MOVE.L  36(A7),D7
    TST.L   D7
    BLE.S   LAB_0B18

    CMPI.L  #$2328,D7
    BLT.S   LAB_0B19

LAB_0B18:
    MOVEQ   #0,D0
    BRA.W   LAB_0B21

LAB_0B19:
    MOVEQ   #0,D6
    MOVEQ   #0,D4

LAB_0B1A:
    CMP.L   D7,D6
    BGE.S   LAB_0B1B

    CMPI.L  #$2328,D6
    BGE.S   LAB_0B1B

    JSR     LAB_096D(PC)

    MOVEQ   #0,D0
    MOVE.W  D4,D0
    MOVE.L  D0,20(A7)
    JSR     LAB_0C03(PC)

    MOVE.L  20(A7),D1
    MOVE.B  D0,0(A3,D1.L)
    ADDQ.L  #1,D6
    ADDQ.W  #1,D4
    BRA.S   LAB_0B1A

LAB_0B1B:
    MOVEQ   #0,D0
    MOVE.W  D4,D0
    CLR.B   0(A3,D0.L)
    MOVE.L  A3,-(A7)
    JSR     LAB_0BFA(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D5
    MOVEQ   #0,D0
    MOVE.W  D4,D0
    MOVE.B  #$20,0(A3,D0.L)
    MOVEQ   #0,D6

LAB_0B1C:
    MOVEQ   #0,D0
    MOVE.W  D4,D0
    TST.B   -1(A3,D0.L)
    BEQ.S   LAB_0B1D

    CMP.L   D5,D6
    BGE.S   LAB_0B1D

    CMPI.W  #$2328,D4
    BCC.S   LAB_0B1D

    JSR     LAB_096D(PC)

    MOVEQ   #0,D0
    MOVE.W  D4,D0
    MOVE.L  D0,20(A7)
    JSR     LAB_0C03(PC)

    MOVE.L  20(A7),D1
    MOVE.B  D0,0(A3,D1.L)
    ADDQ.L  #1,D6
    ADDQ.W  #1,D4
    BRA.S   LAB_0B1C

LAB_0B1D:
    MOVEQ   #0,D0
    MOVE.W  D4,D0
    TST.B   -1(A3,D0.L)
    BNE.S   LAB_0B1E

    CMP.L   D5,D6
    BEQ.S   LAB_0B1F

LAB_0B1E:
    MOVEQ   #0,D4
    CLR.B   (A3)
    BRA.S   LAB_0B20

LAB_0B1F:
    JSR     LAB_096D(PC)

    JSR     LAB_0C03(PC)

    MOVE.B  D0,LAB_2253

LAB_0B20:
    MOVE.L  D4,D0

LAB_0B21:
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======

LAB_0B22:
    LINK.W  A5,#-40
    MOVEM.L D2-D3,-(A7)

    MOVEA.L LAB_229A,A0
    CLR.B   20(A0)
    MOVE.L  GLOB_LONG_PATCH_VERSION_NUMBER,-(A7)
    PEA     GLOB_STR_MAJOR_MINOR_VERSION_1
    PEA     LAB_1EFA
    PEA     -40(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    MOVEA.L LAB_229A,A0
    ADDQ.L  #1,A0
    MOVE.L  A0,(A7)
    PEA     -40(A5)
    JSR     LAB_0C76(PC)

    LEA     20(A7),A7
    TST.B   D0
    BEQ.W   LAB_0B25

    TST.W   LAB_2263
    BEQ.S   LAB_0B23

    TST.W   LAB_2252
    BEQ.W   LAB_0B25

LAB_0B23:
    MOVEA.L AbsExecBase,A6
    JSR     _LVODisable(A6)

    MOVE.W  #$100,LAB_1F45
    JSR     GCOMMAND_SeedBannerFromPrefs(PC)

    MOVEA.L AbsExecBase,A6
    JSR     _LVOEnable(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  #GLOB_REF_696_400_BITMAP,4(A0)
    CLR.W   LAB_2252
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVEQ   #60,D1
    MOVE.L  #679,D2
    MOVEQ   #100,D3
    NOT.B   D3
    JSR     _LVORectFill(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #3,D0
    JSR     _LVOSetAPen(A6)

    PEA     LAB_1EFC
    PEA     90.W
    PEA     30.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     JMP_TBL_DISPLAY_TEXT_AT_POSITION_1(PC)

    MOVE.L  GLOB_LONG_PATCH_VERSION_NUMBER,(A7)
    PEA     GLOB_STR_MAJOR_MINOR_VERSION_2
    PEA     LAB_1EFD
    PEA     -40(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    PEA     -40(A5)
    PEA     120.W
    PEA     30.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     JMP_TBL_DISPLAY_TEXT_AT_POSITION_1(PC)

    LEA     LAB_1EFF,A0
    LEA     -40(A5),A1
    MOVEQ   #4,D0

; Concatenate a string with an apostrophe before displaying
; the text at a 30,150
LAB_0B24:
    MOVE.L  (A0)+,(A1)+ ; Iterate copying A0 into A1 and...
    DBF     D0,LAB_0B24 ; incrementing both until A0 is null.

    CLR.B   (A1)
    MOVEA.L LAB_229A,A0
    ADDQ.L  #1,A0
    MOVE.L  A0,(A7)
    PEA     -40(A5)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_2(PC)

    PEA     GLOB_STR_APOSTROPHE
    PEA     -40(A5)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_2(PC)

    PEA     -40(A5)
    PEA     150.W
    PEA     30.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     JMP_TBL_DISPLAY_TEXT_AT_POSITION_1(PC)

    LEA     72(A7),A7

LAB_0B25:
    MOVEM.L (A7)+,D2-D3
    UNLK    A5
    RTS

;!======

LAB_0B26:
    LINK.W  A5,#-140
    MOVEM.L D2-D3/D5-D7,-(A7)
    MOVE.B  11(A5),D7
    MOVEQ   #-1,D5
    TST.W   LAB_2263
    BEQ.S   .LAB_0B27

    TST.W   LAB_2252
    BEQ.W   LAB_0B2E

.LAB_0B27:
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    SUBQ.W  #1,D0
    BLT.S   LAB_0B2A

    CMPI.W  #5,D0
    BGE.S   LAB_0B2A

    ADD.W   D0,D0
    MOVE.W  LAB_0B28(PC,D0.W),D0
    JMP     LAB_0B28+2(PC,D0.W)

; This is a switch statement that's turned into a jump table.
LAB_0B28:
    DC.W    LAB_0B29_0008-LAB_0B28-2
    DC.W    LAB_0B29_000C-LAB_0B28-2
    DC.W    LAB_0B29_0010-LAB_0B28-2
    DC.W    LAB_0B29_0014-LAB_0B28-2
    DC.W    LAB_0B29_0018-LAB_0B28-2

LAB_0B29_0008:
    MOVEQ   #1,D5
    BRA.S   LAB_0B2A

LAB_0B29_000C:
    MOVEQ   #2,D5
    BRA.S   LAB_0B2A

LAB_0B29_0010:
    MOVEQ   #8,D5
    BRA.S   LAB_0B2A

LAB_0B29_0014:
    MOVEQ   #9,D5
    BRA.S   LAB_0B2A

LAB_0B29_0018:
    MOVEQ   #10,D5

LAB_0B2A:
    TST.L   D5
    BLE.W   LAB_0B2E

    MOVEA.L AbsExecBase,A6
    JSR     _LVODisable(A6)

    MOVE.W  #$100,LAB_1F45
    JSR     GCOMMAND_SeedBannerFromPrefs(PC)

    MOVEA.L AbsExecBase,A6
    JSR     _LVOEnable(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  4(A0),-138(A5)
    MOVE.L  #GLOB_REF_696_400_BITMAP,4(A0)
    CLR.W   LAB_2252
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVEQ   #65,D1
    MOVE.L  #$2ac,D2
    MOVEQ   #40,D3
    NOT.B   D3
    JSR     _LVORectFill(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #3,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.B  28(A0),D6
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    PEA     GLB_STR_PLEASE_STANDBY_2
    PEA     90.W
    PEA     35.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     JMP_TBL_DISPLAY_TEXT_AT_POSITION_1(PC)

    PEA     GLOB_STR_ATTENTION_SYSTEM_ENGINEER_2
    PEA     120.W
    PEA     35.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     JMP_TBL_DISPLAY_TEXT_AT_POSITION_1(PC)

    MOVE.L  D5,(A7)
    PEA     GLOB_STR_REPORT_ERROR_CODE_FORMATTED
    PEA     -128(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    PEA     -128(A5)
    PEA     150.W
    PEA     35.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     JMP_TBL_DISPLAY_TEXT_AT_POSITION_1(PC)

    LEA     56(A7),A7
    MOVEQ   #9,D0
    CMP.L   D0,D5
    BEQ.S   LAB_0B2B

    MOVEQ   #10,D0
    CMP.L   D0,D5
    BNE.S   LAB_0B2C

LAB_0B2B:
    MOVE.L  BRUSH_SnapshotDepth,-(A7)   ; reuse cached brush dimensions in file dialog
    JSR     LAB_0BF4(PC)

    MOVE.L  D0,(A7)
    MOVE.L  BRUSH_SnapshotWidth,-(A7)
    PEA     BRUSH_SnapshotHeader
    PEA     GLOB_STR_FILE_WIDTH_COLORS_FORMATTED
    PEA     -128(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    LEA     20(A7),A7
    MOVE.W  #1,LAB_1B85
    BRA.S   LAB_0B2D

LAB_0B2C:
    PEA     BRUSH_SnapshotHeader
    PEA     GLOB_STR_FILE_PERCENT_S
    PEA     -128(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    LEA     12(A7),A7

LAB_0B2D:
    PEA     -128(A5)
    PEA     180.W
    PEA     35.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     JMP_TBL_DISPLAY_TEXT_AT_POSITION_1(PC)

    PEA     GLOB_STR_PRESS_ESC_TWICE_TO_RESUME_SCROLL
    PEA     210.W
    PEA     35.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     JMP_TBL_DISPLAY_TEXT_AT_POSITION_1(PC)

    LEA     32(A7),A7
    MOVE.L  D6,D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  -138(A5),4(A0)

LAB_0B2E:
    MOVEM.L (A7)+,D2-D3/D5-D7
    UNLK    A5
    RTS

;!======

LAB_0B2F:
    LINK.W  A5,#-8
    MOVEM.L D6-D7,-(A7)
    MOVEQ   #0,D7

LAB_0B30:
    MOVE.W  LAB_2231,D0
    CMP.W   D0,D7
    BGE.S   LAB_0B33

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2233,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    MOVEQ   #0,D6

LAB_0B31:
    MOVEQ   #6,D0
    CMP.W   D0,D6
    BGE.S   LAB_0B32

    MOVEA.L -4(A5),A0
    CLR.B   34(A0,D6.W)
    ADDQ.W  #1,D6
    BRA.S   LAB_0B31

LAB_0B32:
    ADDQ.W  #1,D7
    BRA.S   LAB_0B30

LAB_0B33:
    MOVEM.L (A7)+,D6-D7
    UNLK    A5
    RTS
