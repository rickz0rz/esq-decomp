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
    JSR     GROUPB_JMPTBL_MATH_Mulu32(PC)

    MOVEQ   #80,D1
    ADD.L   D1,D1
    SUB.L   D0,D1
    MOVE.L  -32(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-36(A5)
    MOVE.L  D1,D0
    MOVE.L  D1,-40(A5)
    MOVE.L  -36(A5),D1
    JSR     GROUPB_JMPTBL_MATH_DivS32(PC)

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
    JSR     GROUPB_JMPTBL_MATH_Mulu32(PC)

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
    JSR     GROUPB_JMPTBL_MEMORY_DeallocateMemory(PC)

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
    JSR     GROUPB_JMPTBL_STRING_CompareNoCase(PC)

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
    JSR     GROUPB_JMPTBL_MEMORY_DeallocateMemory(PC)

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
    JSR     GROUPB_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.loadGfxGAdsFile:
    CLR.L   GLOB_REF_LONG_GFX_G_ADS_DATA
    CLR.L   GLOB_REF_LONG_GFX_G_ADS_FILESIZE

    PEA     MODE_OLDFILE
    MOVE.L  GLOB_PTR_STR_GFX_G_ADS,-(A7)
    JSR     GROUPB_JMPTBL_UNKNOWN2B_OpenFileWithAccessMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D6
    TST.L   D6
    BLE.S   .LAB_0A0E

    MOVE.L  D6,-(A7)
    JSR     GROUPB_JMPTBL_DISKIO_GetFilesizeFromHandle(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,GLOB_REF_LONG_GFX_G_ADS_FILESIZE
    TST.L   D0
    BLE.S   .gfxGAdsFileWithoutData

    ADDQ.L  #1,D0
    PEA     (MEMF_PUBLIC).W
    MOVE.L  D0,-(A7)
    PEA     898.W
    PEA     GLOB_STR_ESQIFF_C_4
    JSR     GROUPB_JMPTBL_MEMORY_AllocateMemory(PC)

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
    JSR     GROUPB_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.loadDf0LogoLstFile:
    CLR.L   GLOB_REF_LONG_DF0_LOGO_LST_DATA
    CLR.L   GLOB_REF_LONG_DF0_LOGO_LST_FILESIZE
    PEA     MODE_OLDFILE
    MOVE.L  GLOB_PTR_STR_DF0_LOGO_LST,-(A7)
    JSR     GROUPB_JMPTBL_UNKNOWN2B_OpenFileWithAccessMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D6
    TST.L   D6
    BLE.S   .return

    MOVE.L  D6,-(A7)
    JSR     GROUPB_JMPTBL_DISKIO_GetFilesizeFromHandle(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,GLOB_REF_LONG_DF0_LOGO_LST_FILESIZE
    TST.L   D0
    BLE.S   .df0LogoLstFileWithoutData

    ADDQ.L  #1,D0

    PEA     (MEMF_PUBLIC).W
    MOVE.L  D0,-(A7)
    PEA     979.W
    PEA     GLOB_STR_ESQIFF_C_6
    JSR     GROUPB_JMPTBL_MEMORY_AllocateMemory(PC)

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
    JSR     GROUPB_JMPTBL_MATH_DivS32(PC)

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
    JSR     GROUPB_JMPTBL_SCRIPT_BeginBannerCharTransition(PC)

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
    JSR     GROUPB_JMPTBL_LAB_0A97(PC)

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
    JSR     GROUPB_JMPTBL_LAB_0A97(PC)

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
    JSR     GROUPB_JMPTBL_LAB_0A97(PC)

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
    JSR     GROUPB_JMPTBL_LAB_0A97(PC)

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

    JSR     GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight(PC)

    PEA     2.W
    JSR     LAB_09A7(PC)

    ADDQ.W  #4,A7
    BRA.W   LAB_0A88

LAB_0A7F:
    JSR     GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight(PC)

    PEA     1.W
    CLR.L   -(A7)
    PEA     4.W
    JSR     GROUPB_JMPTBL_LAB_0A97(PC)

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
    JSR     GROUPB_JMPTBL_SCRIPT_AssertCtrlLineIfEnabled(PC)

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

    JSR     GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight(PC)

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

ESQIFF_DeallocateAdsAndLogoLstData:
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
    JSR     GROUPB_JMPTBL_MEMORY_DeallocateMemory(PC)

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
    JSR     GROUPB_JMPTBL_MEMORY_DeallocateMemory(PC)

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
    JSR     GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch(PC)

    PEA     LAB_1ED1
    MOVE.L  LAB_1B1F,-(A7)
    JSR     GROUP_AU_JMPTBL_BRUSH_PopulateBrushList(PC)

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

GROUPB_JMPTBL_STRING_CompareNoCase:
    JMP     STRING_CompareNoCase

GROUPB_JMPTBL_LAB_0A97:
    JMP     LAB_183E

GROUPB_JMPTBL_DISKIO_GetFilesizeFromHandle:
    JMP     DISKIO_GetFilesizeFromHandle

GROUPB_JMPTBL_MATH_DivS32:
    JMP     MATH_DivS32

LAB_0A9A:
    JMP     TEXTDISP_FindEntryIndexByWildcard

JMPTBL_STRING_CompareN_2:
    JMP     STRING_CompareN

LAB_0A9C:
    JMP     ESQ_NoOp

LAB_0A9D:
    JMP     TEXTDISP_DrawChannelBanner

LAB_0A9E:
    JMP     ESQ_MoveCopperEntryTowardStart

GROUPB_JMPTBL_MEMORY_DeallocateMemory:
    JMP     MEMORY_DeallocateMemory

LAB_0AA0:
    JMP     LAB_03CB

LAB_0AA1:
    JMP     BRUSH_CloneBrushRecord

LAB_0AA2:
    JMP     ESQ_MoveCopperEntryTowardEnd

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
    JMP     ESQ_NoOp_006A

LAB_0AA9:
    JMP     LAB_1038

GROUP_AN_JMPTBL_BRUSH_PopulateBrushList:
    JMP     BRUSH_PopulateBrushList

LAB_0AAB:
    JMP     ESQ_NoOp_0074

LAB_0AAC:
    JMP     STRING_CompareNoCaseN

GROUPB_JMPTBL_SCRIPT_AssertCtrlLineIfEnabled:
    JMP     SCRIPT_AssertCtrlLineIfEnabled

GROUPB_JMPTBL_SCRIPT_BeginBannerCharTransition:
    JMP     SCRIPT_BeginBannerCharTransition

GROUPB_JMPTBL_MEMORY_AllocateMemory:
    JMP     MEMORY_AllocateMemory

LAB_0AB0:
    JMP     LAB_038E

GROUPB_JMPTBL_UNKNOWN2B_OpenFileWithAccessMode:
    JMP     UNKNOWN2B_OpenFileWithAccessMode

LAB_0AB2:
    JMP     ESQ_IncCopperListsTowardsTargets

LAB_0AB3:
    JMP     ESQ_DecCopperListsPrimary

LAB_0AB4:
    JMP     BRUSH_SelectBrushSlot

LAB_0AB5:
    JMP     BRUSH_SelectBrushByLabel

GROUPB_JMPTBL_MATH_Mulu32:
    JMP     MATH_Mulu32

LAB_0AB7:
    JMP     LAB_03CD
