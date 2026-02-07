;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_DrawWeatherStatusOverlayIntoBrush   (Routine at ESQIFF_DrawWeatherStatusOverlayIntoBrush)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +20: arg_2 (via 24(A5))
;   stack +24: arg_3 (via 28(A5))
;   stack +28: arg_4 (via 32(A5))
;   stack +32: arg_5 (via 36(A5))
;   stack +36: arg_6 (via 40(A5))
;   stack +40: arg_7 (via 44(A5))
;   stack +44: arg_8 (via 48(A5))
;   stack +48: arg_9 (via 52(A5))
;   stack +52: arg_10 (via 56(A5))
;   stack +56: arg_11 (via 60(A5))
;   stack +60: arg_12 (via 64(A5))
;   stack +61: arg_13 (via 65(A5))
;   stack +62: arg_14 (via 66(A5))
;   stack +84: arg_15 (via 88(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A5/A6/A7/D0/D1/D2/D5/D6/D7
; CALLS:
;   ESQIFF_JMPTBL_BRUSH_FindBrushByPredicate, ESQIFF_JMPTBL_BRUSH_SelectBrushSlot, ESQIFF_JMPTBL_MATH_DivS32, ESQIFF_JMPTBL_MATH_Mulu32, ESQIFF_JMPTBL_MEMORY_DeallocateMemory, ESQFUNC_TrimTextToPixelWidthWordBoundary, ESQPARS_ReplaceOwnedString, _LVOMove, _LVOSetAPen, _LVOSetDrMd, _LVOSetFont, _LVOSetRast, _LVOText, _LVOTextLength
; READS:
;   Global_HANDLE_PREVUEC_FONT, Global_REF_GRAPHICS_LIBRARY, Global_STR_ESQIFF_C_1, LAB_09F1, LAB_09F6, LAB_09F8, WDISP_WeatherStatusOverlayTextPtr, ESQFUNC_PwBrushListHead, DATA_ESQFUNC_STR_I5_1EDD, WDISP_WeatherStatusBrushIndex
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_DrawWeatherStatusOverlayIntoBrush:
    LINK.W  A5,#-68
    MOVEM.L D2/D5-D7/A3,-(A7)

    MOVEA.L 8(A5),A3
    CLR.L   -4(A5)
    MOVEQ   #0,D7
    MOVEQ   #30,D6
    MOVEQ   #0,D5
    CLR.L   -24(A5)
    MOVEQ   #0,D0
    MOVE.B  WDISP_WeatherStatusBrushIndex,D0
    ASL.L   #2,D0
    LEA     DATA_ESQFUNC_STR_I5_1EDD,A0
    ADDA.L  D0,A0
    PEA     ESQFUNC_PwBrushListHead
    MOVE.L  (A0),-(A7)
    JSR     ESQIFF_JMPTBL_BRUSH_FindBrushByPredicate(PC)

    MOVE.L  -4(A5),(A7)
    MOVE.L  WDISP_WeatherStatusOverlayTextPtr,-(A7)
    MOVE.L  D0,-52(A5)
    JSR     ESQPARS_ReplaceOwnedString(PC)

    LEA     12(A7),A7
    MOVEA.L D0,A0

.lab_09E9:
    TST.B   (A0)+
    BNE.S   .lab_09E9

    SUBQ.L  #1,A0
    SUBA.L  D0,A0
    MOVE.L  A0,D1
    ADDQ.L  #1,D1
    MOVE.L  D0,-8(A5)
    MOVE.L  D0,-4(A5)
    MOVE.L  D1,-28(A5)

.lab_09EA:
    MOVEA.L -8(A5),A0
    TST.B   (A0)
    BEQ.S   .lab_09EC

    MOVEQ   #24,D0
    CMP.B   (A0),D0
    BNE.S   .lab_09EB

    CLR.B   (A0)
    ADDQ.L  #1,D5

.lab_09EB:
    ADDQ.L  #1,-8(A5)
    BRA.S   .lab_09EA

.lab_09EC:
    MOVEA.L -4(A5),A0
    MOVE.L  A0,-8(A5)
    TST.B   (A0)
    BNE.S   .lab_09ED

    ADDQ.L  #1,-8(A5)
    SUBQ.L  #1,D5

.lab_09ED:
    MOVEQ   #10,D0
    CMP.L   D0,D5
    BLE.S   .lab_09EE

    MOVE.L  D0,D5

.lab_09EE:
    MOVE.B  64(A3),-65(A5)
    MOVE.B  61(A3),-66(A5)
    LEA     36(A3),A0
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    LEA     36(A3),A0
    MOVEA.L A0,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    LEA     36(A3),A0
    MOVEA.L A0,A1
    MOVEA.L Global_HANDLE_PREVUEC_FONT,A0
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
    JSR     ESQIFF_JMPTBL_BRUSH_SelectBrushSlot(PC)

    LEA     28(A7),A7
    MOVEQ   #0,D0
    MOVEA.L Global_HANDLE_PREVUEC_FONT,A0
    MOVE.W  20(A0),D0
    MOVE.L  D5,D1
    ADDQ.L  #1,D1
    TST.L   D1
    BPL.S   .lab_09EF

    ADDQ.L  #1,D1

.lab_09EF:
    ASR.L   #1,D1
    MOVE.L  D0,-48(A5)
    MOVE.L  D1,-32(A5)
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    MOVEQ   #80,D1
    ADD.L   D1,D1
    SUB.L   D0,D1
    MOVE.L  -32(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-36(A5)
    MOVE.L  D1,D0
    MOVE.L  D1,-40(A5)
    MOVE.L  -36(A5),D1
    JSR     ESQIFF_JMPTBL_MATH_DivS32(PC)

    MOVEQ   #0,D1
    MOVE.W  176(A3),D1
    MOVEQ   #0,D2
    MOVEA.L -52(A5),A0
    MOVE.W  176(A0),D2
    SUB.L   D2,D1
    TST.L   D1
    BPL.S   .lab_09F0

    ADDQ.L  #1,D1

.lab_09F0:
    ASR.L   #1,D1
    MOVE.L  D0,-44(A5)
    MOVE.L  D1,-56(A5)

.lab_09F1:
    MOVE.L  -24(A5),D0
    CMP.L   D5,D0
    BGE.W   .lab_09F8

    TST.L   D0
    BPL.S   .lab_09F2

    ADDQ.L  #1,D0

.lab_09F2:
    ASR.L   #1,D0
    MOVE.L  -44(A5),D1
    MOVE.L  -48(A5),D2
    ADD.L   D1,D2
    MOVE.L  D2,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    ADD.L   -44(A5),D0
    MOVEQ   #0,D1
    MOVEA.L Global_HANDLE_PREVUEC_FONT,A0
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
    BGE.W   .lab_09F8

    LEA     36(A3),A0
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -56(A5),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   ESQFUNC_TrimTextToPixelWidthWordBoundary

    LEA     12(A7),A7
    LEA     36(A3),A0
    MOVE.L  D0,-60(A5)
    MOVEA.L A0,A1
    MOVEA.L -8(A5),A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  -56(A5),D1
    SUB.L   D0,D1
    SUBQ.L  #1,D1
    TST.L   D1
    BPL.S   .lab_09F3

    ADDQ.L  #1,D1

.lab_09F3:
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
    BGE.W   .lab_09F6

    MOVEA.L -8(A5),A0

.lab_09F4:
    TST.B   (A0)+
    BNE.S   .lab_09F4

    SUBQ.L  #1,A0
    SUBA.L  -8(A5),A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    ADD.L   D0,-8(A5)
    LEA     36(A3),A0
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -56(A5),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   ESQFUNC_TrimTextToPixelWidthWordBoundary

    LEA     12(A7),A7
    LEA     36(A3),A0
    MOVE.L  D0,-60(A5)
    MOVEA.L A0,A1
    MOVEA.L -8(A5),A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  -56(A5),D1
    ADD.L   D0,D1
    TST.L   D1
    BPL.S   .lab_09F5

    ADDQ.L  #1,D1

.lab_09F5:
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

.lab_09F6:
    MOVEA.L -8(A5),A0

.lab_09F7:
    TST.B   (A0)+
    BNE.S   .lab_09F7

    SUBQ.L  #1,A0
    SUBA.L  -8(A5),A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    ADD.L   D0,-8(A5)

    BRA.W   .lab_09F1

.lab_09F8:
    MOVE.L  -28(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     672.W
    PEA     Global_STR_ESQIFF_C_1
    JSR     ESQIFF_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     36(A3),A0
    MOVE.B  -65(A5),D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L A0,A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
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

;------------------------------------------------------------------------------
; FUNC: ESQIFF_QueueIffBrushLoad   (Routine at ESQIFF_QueueIffBrushLoad)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A7/D0/D1/D7
; CALLS:
;   ESQIFF_JMPTBL_BRUSH_AllocBrushNode, ESQIFF_JMPTBL_BRUSH_CloneBrushRecord, ESQIFF_JMPTBL_CTASKS_StartIffTaskProcess, ESQIFF_JMPTBL_MEMORY_DeallocateMemory, ESQIFF_JMPTBL_STRING_CompareNoCase, ESQIFF_DrawWeatherStatusOverlayIntoBrush
; READS:
;   Global_STR_ESQIFF_C_2, PARSEINI_BannerBrushResourceHead, CTASKS_PendingIffBrushDescriptor, DATA_ESQIFF_BSS_LONG_1EE9, DATA_ESQIFF_STR_WEATHER_1EEA, WDISP_WeatherStatusCountdown, WDISP_WeatherStatusDigitChar, lab_09FD, lab_09FE
; WRITES:
;   CTASKS_PendingIffBrushDescriptor, WDISP_WeatherStatusBrushListHead, CTASKS_IffTaskState, DATA_ESQIFF_BSS_LONG_1EE9
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_QueueIffBrushLoad:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7
    TST.L   DATA_ESQIFF_BSS_LONG_1EE9
    BEQ.S   .lab_09FA

    MOVEQ   #1,D0
    CMP.L   D0,D7
    BNE.S   .lab_09FB

.lab_09FA:
    MOVE.L  PARSEINI_BannerBrushResourceHead,DATA_ESQIFF_BSS_LONG_1EE9

.lab_09FB:
    MOVEQ   #0,D0
    TST.L   D0
    BEQ.W   .lab_09FD

    PEA     DATA_ESQIFF_STR_WEATHER_1EEA
    MOVE.L  DATA_ESQIFF_BSS_LONG_1EE9,-(A7)
    JSR     ESQIFF_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .lab_09FC

    MOVEQ   #2,D0
    CMP.L   D0,D7
    BNE.W   .lab_09FD

.lab_09FC:
    MOVE.B  WDISP_WeatherStatusCountdown,D0
    MOVEQ   #0,D1
    CMP.B   D1,D0
    BLS.W   .lab_09FE

    MOVE.W  WDISP_WeatherStatusDigitChar,D0
    MOVEQ   #48,D1
    CMP.W   D1,D0
    BEQ.W   .lab_09FE

    CLR.L   -(A7)
    MOVE.L  DATA_ESQIFF_BSS_LONG_1EE9,-(A7)
    JSR     ESQIFF_JMPTBL_BRUSH_AllocBrushNode(PC)

    MOVE.L  D0,CTASKS_PendingIffBrushDescriptor
    MOVEA.L D0,A0
    MOVE.B  #11,190(A0)
    MOVEA.L CTASKS_PendingIffBrushDescriptor,A0
    MOVE.W  #$280,128(A0)
    MOVEA.L CTASKS_PendingIffBrushDescriptor,A0
    MOVE.W  #160,130(A0)
    MOVEA.L CTASKS_PendingIffBrushDescriptor,A0
    MOVE.B  #3,136(A0)
    MOVE.L  CTASKS_PendingIffBrushDescriptor,(A7)
    JSR     ESQIFF_JMPTBL_BRUSH_CloneBrushRecord(PC)

    MOVE.L  D0,WDISP_WeatherStatusBrushListHead
    MOVE.L  D0,(A7)
    BSR.W   ESQIFF_DrawWeatherStatusOverlayIntoBrush

    PEA     238.W
    MOVE.L  CTASKS_PendingIffBrushDescriptor,-(A7)
    PEA     724.W
    PEA     Global_STR_ESQIFF_C_2
    JSR     ESQIFF_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     24(A7),A7
    BRA.S   .lab_09FE

.lab_09FD:
    TST.L   DATA_ESQIFF_BSS_LONG_1EE9
    BEQ.S   .lab_09FE

    TST.L   DATA_ESQIFF_BSS_LONG_1EE9
    BEQ.S   .lab_09FE

    CLR.L   -(A7)
    MOVE.L  DATA_ESQIFF_BSS_LONG_1EE9,-(A7)
    JSR     ESQIFF_JMPTBL_BRUSH_AllocBrushNode(PC)

    MOVE.L  D0,CTASKS_PendingIffBrushDescriptor
    MOVEA.L D0,A0
    MOVE.B  #$6,190(A0)
    MOVE.W  #6,CTASKS_IffTaskState
    JSR     ESQIFF_JMPTBL_CTASKS_StartIffTaskProcess(PC)

    ADDQ.W  #8,A7

.lab_09FE:
    MOVEQ   #2,D0
    CMP.L   D0,D7
    BEQ.S   .return

    MOVEA.L DATA_ESQIFF_BSS_LONG_1EE9,A0
    MOVE.L  234(A0),DATA_ESQIFF_BSS_LONG_1EE9

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======

    LINK.W  A5,#0
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_RenderWeatherStatusBrushSlice   (Routine at ESQIFF_RenderWeatherStatusBrushSlice)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A3/A7/D0/D1/D2/D6/D7
; CALLS:
;   ESQIFF_JMPTBL_BRUSH_SelectBrushSlot, ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode
; READS:
;   ESQIFF_RenderWeatherStatusBrushSlice_Return, DATA_CTASKS_STR_Y_1BBF, DATA_ESQFUNC_CONST_WORD_1ECD, DATA_ESQIFF_BSS_WORD_1EEC, DATA_ESQIFF_BSS_WORD_1EED, DATA_ESQIFF_CONST_WORD_1EEE
; WRITES:
;   DATA_ESQFUNC_CONST_WORD_1ECD, DATA_ESQIFF_BSS_WORD_1EEC, DATA_ESQIFF_BSS_WORD_1EED, DATA_ESQIFF_CONST_WORD_1EEE
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_RenderWeatherStatusBrushSlice:
    MOVEM.L D2/D6-D7/A2-A3,-(A7)

    SetOffsetForStack   5
    UseStackLong    MOVEA.L,1,A3
    UseStackLong    MOVEA.L,2,A2

    MOVE.L  A2,D0
    BNE.S   .lab_0A01

    MOVEQ   #0,D0
    MOVE.W  D0,DATA_ESQIFF_BSS_WORD_1EEC
    BRA.W   ESQIFF_RenderWeatherStatusBrushSlice_Return

.lab_0A01:
    MOVE.W  DATA_ESQIFF_BSS_WORD_1EEC,D0
    TST.W   D0
    BLE.S   .lab_0A02

    TST.W   DATA_ESQFUNC_CONST_WORD_1ECD
    BEQ.S   .lab_0A03

.lab_0A02:
    MOVEQ   #0,D0
    MOVE.W  D0,DATA_ESQFUNC_CONST_WORD_1ECD
    MOVE.W  178(A2),D1
    MOVE.B  #$1,DATA_ESQIFF_CONST_WORD_1EEE
    MOVE.W  D0,DATA_ESQIFF_BSS_WORD_1EED
    MOVE.W  D1,DATA_ESQIFF_BSS_WORD_1EEC

.lab_0A03:
    MOVE.W  DATA_ESQIFF_BSS_WORD_1EEC,D0
    MOVEQ   #30,D1
    CMP.W   D1,D0
    BGE.S   .lab_0A04

    MOVE.L  D0,D7
    BRA.S   .lab_0A05

.lab_0A04:
    MOVE.L  D1,D7

.lab_0A05:
    MOVEQ   #9,D0
    CMP.B   32(A2),D0
    BNE.S   .lab_0A06

    MOVEQ   #42,D6
    MOVEQ   #0,D0
    MOVE.W  176(A2),D0
    ADD.L   D6,D0
    MOVE.L  D7,D1
    EXT.L   D1
    LEA     60(A3),A0
    MOVE.W  DATA_ESQIFF_BSS_WORD_1EED,D2
    EXT.L   D2
    MOVE.L  D2,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  A2,-(A7)
    JSR     ESQIFF_JMPTBL_BRUSH_SelectBrushSlot(PC)

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
    MOVE.W  DATA_ESQIFF_BSS_WORD_1EED,D2
    EXT.L   D2
    MOVE.L  D2,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    CLR.L   -(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  A2,-(A7)
    JSR     ESQIFF_JMPTBL_BRUSH_SelectBrushSlot(PC)

    LEA     52(A7),A7
    BRA.S   .branch_1

.lab_0A06:
    MOVEQ   #0,D0
    MOVE.W  176(A2),D0
    MOVE.L  #696,D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .branch

    ADDQ.L  #1,D1

.branch:
    ASR.L   #1,D1
    MOVE.L  D1,D6
    SUBQ.L  #1,D6
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ADD.L   D6,D1
    MOVE.L  D7,D0
    EXT.L   D0
    LEA     60(A3),A0
    MOVE.W  DATA_ESQIFF_BSS_WORD_1EED,D2
    EXT.L   D2
    MOVE.L  D2,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    CLR.L   -(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  A2,-(A7)
    JSR     ESQIFF_JMPTBL_BRUSH_SelectBrushSlot(PC)

    LEA     28(A7),A7
    MOVEQ   #11,D0
    CMP.B   32(A2),D0
    BNE.S   .branch_1

    MOVEQ   #1,D0
    CMP.B   DATA_ESQIFF_CONST_WORD_1EEE,D0
    BNE.S   .branch_1

    MOVE.B  DATA_CTASKS_STR_Y_1BBF,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .branch_1

    PEA     16.W
    MOVE.L  A3,-(A7)
    JSR     ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode(PC)

    ADDQ.W  #8,A7
    CLR.B   DATA_ESQIFF_CONST_WORD_1EEE

.branch_1:
    SUB.W   D7,DATA_ESQIFF_BSS_WORD_1EEC
    ADD.W   D7,DATA_ESQIFF_BSS_WORD_1EED
    MOVE.L  D7,D0
    TST.W   D0
    BPL.S   .branch_2

    ADDQ.W  #1,D0

.branch_2:
    ASR.W   #1,D0
    MOVE.W  D0,52(A3)
    MOVE.W  DATA_ESQIFF_BSS_WORD_1EEC,D0

;------------------------------------------------------------------------------
; FUNC: ESQIFF_RenderWeatherStatusBrushSlice_Return   (Routine at ESQIFF_RenderWeatherStatusBrushSlice_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D2
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_RenderWeatherStatusBrushSlice_Return:
    MOVEM.L (A7)+,D2/D6-D7/A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_ReloadExternalAssetCatalogBuffers   (Routine at ESQIFF_ReloadExternalAssetCatalogBuffers)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A6/A7/D0/D1/D2/D3/D6/D7
; CALLS:
;   ESQIFF_JMPTBL_BRUSH_FreeBrushList, ESQIFF_JMPTBL_DISKIO_GetFilesizeFromHandle, ESQIFF_JMPTBL_MEMORY_AllocateMemory, ESQIFF_JMPTBL_MEMORY_DeallocateMemory, ESQIFF_JMPTBL_UNKNOWN2B_OpenFileWithAccessMode, _LVOClose, _LVOForbid, _LVOPermit, _LVORead
; READS:
;   AbsExecBase, Global_PTR_STR_DF0_LOGO_LST, Global_PTR_STR_GFX_G_ADS, Global_REF_DOS_LIBRARY_2, Global_REF_LONG_DF0_LOGO_LST_DATA, Global_REF_LONG_DF0_LOGO_LST_FILESIZE, Global_REF_LONG_GFX_G_ADS_DATA, Global_REF_LONG_GFX_G_ADS_FILESIZE, Global_STR_ESQIFF_C_3, Global_STR_ESQIFF_C_4, Global_STR_ESQIFF_C_5, Global_STR_ESQIFF_C_6, LAB_0A10, CTASKS_IffTaskDoneFlag, ED_DiagGraphModeChar, ESQIFF_GAdsBrushListHead, ESQIFF_LogoBrushListHead, DATA_WDISP_BSS_WORD_2294, ESQIFF_ExternalAssetFlags, DISKIO_Drive0WriteProtectedCode, DATA_WDISP_BSS_LONG_2319, MEMF_PUBLIC, MODE_OLDFILE, return, stackLong1
; WRITES:
;   Global_REF_LONG_DF0_LOGO_LST_DATA, Global_REF_LONG_DF0_LOGO_LST_FILESIZE, Global_REF_LONG_GFX_G_ADS_DATA, Global_REF_LONG_GFX_G_ADS_FILESIZE, ESQIFF_GAdsBrushListCount, ESQIFF_LogoBrushListCount, ESQIFF_ExternalAssetFlags, DATA_WDISP_BSS_WORD_22AC, DATA_WDISP_BSS_LONG_22AD
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_ReloadExternalAssetCatalogBuffers:
    MOVEM.L D2-D3/D6-D7,-(A7)

    SetOffsetForStack   4
    ; UseStackLong    MOVE.L,1,D7
    EmitStackAddress    1
    MOVE.L  .stackLong1(A7),D7

    TST.W   CTASKS_IffTaskDoneFlag
    BEQ.W   .return

    MOVEQ   #1,D0
    CMP.L   D0,D7
    BNE.W   .lab_0A10

    MOVE.B  ED_DiagGraphModeChar,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BEQ.W   .lab_0A10

    TST.L   DATA_WDISP_BSS_LONG_2319
    BNE.W   .lab_0A10

    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    CLR.L   -(A7)

    PEA     ESQIFF_GAdsBrushListHead
    JSR     ESQIFF_JMPTBL_BRUSH_FreeBrushList(PC)

    ADDQ.W  #8,A7

    MOVEQ   #0,D0
    MOVE.L  D0,ESQIFF_GAdsBrushListCount
    CLR.W   DATA_WDISP_BSS_LONG_22AD
    MOVEA.L AbsExecBase,A6
    JSR     _LVOPermit(A6)

    TST.L   Global_REF_LONG_GFX_G_ADS_DATA
    BEQ.S   .loadGfxGAdsFile

    TST.L   Global_REF_LONG_GFX_G_ADS_FILESIZE
    BEQ.S   .loadGfxGAdsFile

    MOVE.L  Global_REF_LONG_GFX_G_ADS_FILESIZE,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  Global_REF_LONG_GFX_G_ADS_DATA,-(A7)
    PEA     882.W
    PEA     Global_STR_ESQIFF_C_3
    JSR     ESQIFF_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.loadGfxGAdsFile:
    CLR.L   Global_REF_LONG_GFX_G_ADS_DATA
    CLR.L   Global_REF_LONG_GFX_G_ADS_FILESIZE

    PEA     MODE_OLDFILE
    MOVE.L  Global_PTR_STR_GFX_G_ADS,-(A7)
    JSR     ESQIFF_JMPTBL_UNKNOWN2B_OpenFileWithAccessMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D6
    TST.L   D6
    BLE.S   .lab_0A0E

    MOVE.L  D6,-(A7)
    JSR     ESQIFF_JMPTBL_DISKIO_GetFilesizeFromHandle(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,Global_REF_LONG_GFX_G_ADS_FILESIZE
    TST.L   D0
    BLE.S   .gfxGAdsFileWithoutData

    ADDQ.L  #1,D0
    PEA     (MEMF_PUBLIC).W
    MOVE.L  D0,-(A7)
    PEA     898.W
    PEA     Global_STR_ESQIFF_C_4
    JSR     ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7

    MOVE.L  D0,Global_REF_LONG_GFX_G_ADS_DATA
    MOVE.L  D6,D1
    MOVE.L  D0,D2
    MOVE.L  Global_REF_LONG_GFX_G_ADS_FILESIZE,D3
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVORead(A6)

    CMP.L   Global_REF_LONG_GFX_G_ADS_FILESIZE,D0
    BNE.S   .gfxGAdsFileWithoutData

    MOVE.W  ESQIFF_ExternalAssetFlags,D0
    ORI.W   #1,D0
    MOVE.W  D0,ESQIFF_ExternalAssetFlags

.gfxGAdsFileWithoutData:
    MOVE.L  D6,D1
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOClose(A6)

.lab_0A0E:
    TST.W   DATA_WDISP_BSS_WORD_2294
    BEQ.S   .lab_0A0F

    MOVE.W  #1,DATA_WDISP_BSS_LONG_22AD
    BRA.S   .lab_0A10

.lab_0A0F:
    CLR.W   DATA_WDISP_BSS_LONG_22AD

.lab_0A10:
    TST.L   D7
    BNE.W   .return

    TST.L   DISKIO_Drive0WriteProtectedCode
    BNE.W   .return

    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    CLR.L   -(A7)
    PEA     ESQIFF_LogoBrushListHead
    JSR     ESQIFF_JMPTBL_BRUSH_FreeBrushList(PC)

    ADDQ.W  #8,A7
    MOVEQ   #0,D0
    MOVE.L  D0,ESQIFF_LogoBrushListCount
    CLR.W   DATA_WDISP_BSS_WORD_22AC
    MOVEA.L AbsExecBase,A6
    JSR     _LVOPermit(A6)

    TST.L   Global_REF_LONG_DF0_LOGO_LST_DATA
    BEQ.S   .loadDf0LogoLstFile

    TST.L   Global_REF_LONG_DF0_LOGO_LST_FILESIZE
    BEQ.S   .loadDf0LogoLstFile

    MOVE.L  Global_REF_LONG_DF0_LOGO_LST_FILESIZE,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  Global_REF_LONG_DF0_LOGO_LST_DATA,-(A7)
    PEA     963.W
    PEA     Global_STR_ESQIFF_C_5
    JSR     ESQIFF_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.loadDf0LogoLstFile:
    CLR.L   Global_REF_LONG_DF0_LOGO_LST_DATA
    CLR.L   Global_REF_LONG_DF0_LOGO_LST_FILESIZE
    PEA     MODE_OLDFILE
    MOVE.L  Global_PTR_STR_DF0_LOGO_LST,-(A7)
    JSR     ESQIFF_JMPTBL_UNKNOWN2B_OpenFileWithAccessMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D6
    TST.L   D6
    BLE.S   .return

    MOVE.L  D6,-(A7)
    JSR     ESQIFF_JMPTBL_DISKIO_GetFilesizeFromHandle(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,Global_REF_LONG_DF0_LOGO_LST_FILESIZE
    TST.L   D0
    BLE.S   .df0LogoLstFileWithoutData

    ADDQ.L  #1,D0

    PEA     (MEMF_PUBLIC).W
    MOVE.L  D0,-(A7)
    PEA     979.W
    PEA     Global_STR_ESQIFF_C_6
    JSR     ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,Global_REF_LONG_DF0_LOGO_LST_DATA
    MOVE.L  D6,D1
    MOVE.L  D0,D2
    MOVE.L  Global_REF_LONG_DF0_LOGO_LST_FILESIZE,D3
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVORead(A6)

    CMP.L   Global_REF_LONG_DF0_LOGO_LST_FILESIZE,D0
    BNE.S   .df0LogoLstFileWithoutData

    MOVE.W  ESQIFF_ExternalAssetFlags,D0
    ORI.W   #2,D0
    MOVE.W  D0,ESQIFF_ExternalAssetFlags

.df0LogoLstFileWithoutData:
    MOVE.L  D6,D1
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOClose(A6)

.return:
    MOVEM.L (A7)+,D2-D3/D6-D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_QueueNextExternalAssetIffJob   (Routine at ESQIFF_QueueNextExternalAssetIffJob)
; ARGS:
;   stack +36: arg_1 (via 40(A5))
;   stack +37: arg_2 (via 41(A5))
;   stack +76: arg_3 (via 80(A5))
;   stack +116: arg_4 (via 120(A5))
;   stack +124: arg_5 (via 128(A5))
;   stack +126: arg_6 (via 130(A5))
;   stack +130: arg_7 (via 134(A5))
;   stack +134: arg_8 (via 138(A5))
;   stack +138: arg_9 (via 142(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A6/A7/D0/D1/D2/D5/D6/D7
; CALLS:
;   ESQIFF_JMPTBL_BRUSH_AllocBrushNode, ESQIFF_JMPTBL_CTASKS_StartIffTaskProcess, ESQIFF_JMPTBL_STRING_CompareNoCaseN, ESQIFF_JMPTBL_TEXTDISP_FindEntryIndexByWildcard, GCOMMAND_FindPathSeparator, ESQDISP_ProcessGridMessagesIfIdle, ESQIFF_ReadNextExternalAssetPathEntry, _LVOForbid, _LVOPermit
; READS:
;   AbsExecBase, Global_REF_LONG_DF0_LOGO_LST_DATA, Global_REF_LONG_GFX_G_ADS_DATA, LAB_0A1A, LAB_0A22, LAB_0A23, LAB_0A27, LAB_0A32, CTASKS_IffTaskDoneFlag, ESQIFF_GAdsBrushListHead, ESQIFF_LogoBrushListHead, DATA_ESQIFF_PATH_DF0_COLON_1EF3, DATA_ESQIFF_PATH_RAM_COLON_LOGOS_SLASH_1EF4, DATA_WDISP_BSS_WORD_22AC, ESQIFF_AssetSourceSelect, DATA_WDISP_BSS_LONG_22C3, TEXTDISP_CurrentMatchIndex, fa00, return
; WRITES:
;   CTASKS_PendingLogoBrushDescriptor, CTASKS_PendingGAdsBrushDescriptor, ESQIFF_GAdsBrushListCount, ESQIFF_LogoBrushListCount, DATA_WDISP_BSS_LONG_22A8, DATA_WDISP_BSS_LONG_22C2, TEXTDISP_CurrentMatchIndex
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_QueueNextExternalAssetIffJob:
    LINK.W  A5,#-144
    MOVEM.L D2/D5-D7,-(A7)
    MOVEQ   #0,D0
    MOVE.L  D0,-138(A5)
    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    TST.W   CTASKS_IffTaskDoneFlag
    BNE.S   .lab_0A15

    JSR     _LVOPermit(A6)

    MOVEQ   #0,D0
    BRA.W   .return

.lab_0A15:
    MOVE.W  ESQIFF_AssetSourceSelect,D0
    BEQ.S   .lab_0A16

    CMPI.L  #$1,ESQIFF_LogoBrushListCount
    BLT.S   .lab_0A16

    JSR     _LVOPermit(A6)

    MOVEQ   #0,D0
    BRA.W   .return

.lab_0A16:
    MOVE.W  ESQIFF_AssetSourceSelect,D0
    BNE.S   .lab_0A17

    CMPI.L  #$2,ESQIFF_GAdsBrushListCount
    BLT.S   .lab_0A17

    JSR     _LVOPermit(A6)

    MOVEQ   #0,D0
    BRA.W   .return

.lab_0A17:
    JSR     _LVOPermit(A6)

    MOVEQ   #0,D0
    MOVE.B  D0,-40(A5)
    MOVE.W  DATA_WDISP_BSS_WORD_22AC,D6
    MOVEQ   #0,D1
    MOVE.W  D1,-128(A5)
    TST.L   Global_REF_LONG_DF0_LOGO_LST_DATA
    BEQ.S   .lab_0A18

    MOVE.W  ESQIFF_AssetSourceSelect,D2
    BNE.S   .lab_0A19

.lab_0A18:
    TST.L   Global_REF_LONG_GFX_G_ADS_DATA
    BEQ.W   .lab_0A32

    MOVE.W  ESQIFF_AssetSourceSelect,D2
    BNE.W   .lab_0A32

.lab_0A19:
    MOVE.B  D0,-41(A5)
    MOVE.W  TEXTDISP_CurrentMatchIndex,D5

.lab_0A1A:
    PEA     -40(A5)
    BSR.W   ESQIFF_ReadNextExternalAssetPathEntry

    ADDQ.W  #4,A7
    LEA     -40(A5),A0
    MOVEA.L A0,A1

.lab_0A1B:
    TST.B   (A1)+
    BNE.S   .lab_0A1B

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    BEQ.W   .lab_0A22

    MOVE.W  ESQIFF_AssetSourceSelect,D0
    BEQ.S   .lab_0A20

    TST.W   DATA_WDISP_BSS_LONG_22C3
    BEQ.S   .lab_0A1C

    MOVE.W  #1,-128(A5)
    BRA.W   .lab_0A23

.lab_0A1C:
    MOVEQ   #0,D7

.lab_0A1D:
    MOVEQ   #40,D0
    CMP.W   D0,D7
    BGE.S   .lab_0A1F

    MOVE.B  -40(A5,D7.W),-80(A5,D7.W)
    TST.B   -80(A5,D7.W)
    BEQ.S   .lab_0A1F

    MOVEQ   #33,D0
    CMP.B   -80(A5,D7.W),D0
    BNE.S   .lab_0A1E

    MOVE.B  #$2a,-80(A5,D7.W)
    MOVE.L  D7,D0
    EXT.L   D0
    CLR.B   -79(A5,D0.L)
    BRA.S   .lab_0A1F

.lab_0A1E:
    ADDQ.W  #1,D7
    BRA.S   .lab_0A1D

.lab_0A1F:
    PEA     -80(A5)
    JSR     GCOMMAND_FindPathSeparator(PC)

    MOVE.L  D0,(A7)
    JSR     ESQIFF_JMPTBL_TEXTDISP_FindEntryIndexByWildcard(PC)

    ADDQ.W  #4,A7
    SUBQ.W  #1,D0
    BNE.S   .lab_0A21

    MOVE.W  #1,-128(A5)
    MOVE.W  TEXTDISP_CurrentMatchIndex,DATA_WDISP_BSS_LONG_22C2
    BRA.S   .lab_0A23

.lab_0A20:
    MOVEQ   #4,D0
    MOVE.L  D0,-(A7)
    PEA     -40(A5)
    PEA     DATA_ESQIFF_PATH_DF0_COLON_1EF3
    JSR     ESQIFF_JMPTBL_STRING_CompareNoCaseN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BEQ.S   .lab_0A23

    MOVEQ   #11,D0
    MOVE.L  D0,-(A7)
    PEA     -40(A5)
    PEA     DATA_ESQIFF_PATH_RAM_COLON_LOGOS_SLASH_1EF4
    JSR     ESQIFF_JMPTBL_STRING_CompareNoCaseN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BEQ.S   .lab_0A23

    MOVE.W  #1,-128(A5)
    BRA.S   .lab_0A23

.lab_0A21:
    JSR     ESQDISP_ProcessGridMessagesIfIdle(PC)

.lab_0A22:
    MOVE.W  DATA_WDISP_BSS_WORD_22AC,D0
    CMP.W   D0,D6
    BNE.W   .lab_0A1A

.lab_0A23:
    MOVE.W  D5,TEXTDISP_CurrentMatchIndex
    TST.W   -128(A5)
    BEQ.W   .lab_0A32

    MOVE.W  ESQIFF_AssetSourceSelect,D0
    BEQ.S   .lab_0A24

    MOVE.L  #$fa00,-134(A5)
    BRA.S   .lab_0A25

.lab_0A24:
    MOVE.L  #$13880,-134(A5)

.lab_0A25:
    LEA     -40(A5),A0
    LEA     -120(A5),A1

.lab_0A26:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .lab_0A26

.lab_0A27:
    MOVE.W  #1,-130(A5)
    JSR     ESQDISP_ProcessGridMessagesIfIdle(PC)

    MOVE.W  ESQIFF_AssetSourceSelect,D0
    BEQ.S   .lab_0A28

    MOVEA.L ESQIFF_LogoBrushListHead,A0
    MOVE.L  A0,-142(A5)
    BRA.S   .lab_0A29

.lab_0A28:
    MOVEA.L ESQIFF_GAdsBrushListHead,A0
    MOVE.L  A0,-142(A5)

.lab_0A29:
    MOVE.L  A0,D0
    BEQ.S   .lab_0A2B

    CMPA.L  ESQIFF_LogoBrushListHead,A0
    BNE.S   .lab_0A2B

    LEA     -40(A5),A0
    MOVEA.L -142(A5),A1

.lab_0A2A:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.S   .lab_0A2B

    TST.B   D0
    BNE.S   .lab_0A2A

    BNE.S   .lab_0A2B

    MOVEQ   #1,D0
    MOVE.L  D0,-138(A5)

.lab_0A2B:
    TST.L   -138(A5)
    BNE.S   .lab_0A2E

    CLR.L   -(A7)
    PEA     -40(A5)
    JSR     ESQIFF_JMPTBL_BRUSH_AllocBrushNode(PC)

    ADDQ.W  #8,A7
    MOVE.W  ESQIFF_AssetSourceSelect,D1
    MOVE.L  D0,DATA_WDISP_BSS_LONG_22A8
    TST.W   D1
    BEQ.S   .lab_0A2C

    MOVEA.L D0,A0
    MOVE.B  #$4,190(A0)
    MOVE.L  D0,CTASKS_PendingLogoBrushDescriptor
    BRA.S   .lab_0A2D

.lab_0A2C:
    MOVEA.L D0,A0
    MOVE.B  #$5,190(A0)
    MOVE.L  D0,CTASKS_PendingGAdsBrushDescriptor

.lab_0A2D:
    JSR     ESQIFF_JMPTBL_CTASKS_StartIffTaskProcess(PC)

.lab_0A2E:
    JSR     ESQDISP_ProcessGridMessagesIfIdle(PC)

    MOVEQ   #-1,D0
    CMP.W   -130(A5),D0
    BNE.S   .lab_0A2F

    PEA     -40(A5)
    BSR.W   ESQIFF_ReadNextExternalAssetPathEntry

    ADDQ.W  #4,A7

.lab_0A2F:
    LEA     -120(A5),A0
    LEA     -40(A5),A1

.lab_0A30:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.S   .lab_0A31

    TST.B   D0
    BNE.S   .lab_0A30

    BEQ.S   .lab_0A32

.lab_0A31:
    MOVEQ   #-1,D0
    CMP.W   -130(A5),D0
    BEQ.W   .lab_0A27

.lab_0A32:
    TST.W   -128(A5)
    BNE.S   .lab_0A33

    MOVEQ   #-1,D0
    MOVE.W  D0,-130(A5)

.lab_0A33:
    MOVE.W  -130(A5),D0

.return:
    MOVEM.L (A7)+,D2/D5-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_ReadNextExternalAssetPathEntry   (Routine at ESQIFF_ReadNextExternalAssetPathEntry)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +10: arg_2 (via 14(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A3/A5/A7/D0/D4/D5/D6/D7
; CALLS:
;   ESQDISP_ProcessGridMessagesIfIdle
; READS:
;   Global_REF_LONG_DF0_LOGO_LST_DATA, Global_REF_LONG_DF0_LOGO_LST_FILESIZE, Global_REF_LONG_GFX_G_ADS_DATA, Global_REF_LONG_GFX_G_ADS_FILESIZE, DATA_WDISP_BSS_WORD_22AC, DATA_WDISP_BSS_LONG_22AD, ESQIFF_AssetSourceSelect, ESQIFF_GAdsSourceEnabled, return
; WRITES:
;   DATA_WDISP_BSS_WORD_22AC, DATA_WDISP_BSS_LONG_22AD, DATA_WDISP_BSS_LONG_22C3
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_ReadNextExternalAssetPathEntry:
    LINK.W  A5,#-16
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    JSR     ESQDISP_ProcessGridMessagesIfIdle(PC)

    MOVE.W  ESQIFF_AssetSourceSelect,D0
    BEQ.S   .lab_0A36

    MOVE.L  Global_REF_LONG_DF0_LOGO_LST_FILESIZE,D4
    MOVE.L  Global_REF_LONG_DF0_LOGO_LST_DATA,-14(A5)
    MOVE.W  DATA_WDISP_BSS_WORD_22AC,D6
    MOVEQ   #0,D0
    MOVE.W  D0,DATA_WDISP_BSS_LONG_22C3
    BRA.S   .lab_0A38

.lab_0A36:
    MOVE.W  ESQIFF_GAdsSourceEnabled,D0
    BEQ.S   .lab_0A37

    MOVE.L  Global_REF_LONG_GFX_G_ADS_FILESIZE,D4
    MOVE.L  Global_REF_LONG_GFX_G_ADS_DATA,-14(A5)
    MOVE.W  DATA_WDISP_BSS_LONG_22AD,D6
    BRA.S   .lab_0A38

.lab_0A37:
    MOVEQ   #0,D0
    BRA.W   .return

.lab_0A38:
    MOVEQ   #0,D7

.lab_0A39:
    CMP.W   D6,D7
    BGE.S   .lab_0A3B

    TST.L   D4
    BLE.S   .lab_0A3B

    MOVEA.L -14(A5),A0
    MOVE.B  (A0)+,D5
    MOVE.L  A0,-14(A5)
    MOVEQ   #10,D0
    CMP.B   D0,D5
    BNE.S   .lab_0A3A

    ADDQ.W  #1,D7

.lab_0A3A:
    SUBQ.L  #1,D4
    BRA.S   .lab_0A39

.lab_0A3B:
    TST.L   D4
    BNE.S   .lab_0A3E

    MOVE.W  ESQIFF_AssetSourceSelect,D0
    BEQ.S   .lab_0A3C

    MOVE.L  Global_REF_LONG_DF0_LOGO_LST_FILESIZE,D4
    MOVE.L  Global_REF_LONG_DF0_LOGO_LST_DATA,-14(A5)
    BRA.S   .lab_0A3D

.lab_0A3C:
    MOVE.L  Global_REF_LONG_GFX_G_ADS_FILESIZE,D4
    MOVE.L  Global_REF_LONG_GFX_G_ADS_DATA,-14(A5)

.lab_0A3D:
    MOVEQ   #1,D6
    BRA.S   .lab_0A3F

.lab_0A3E:
    ADDQ.W  #1,D6

.lab_0A3F:
    MOVE.W  ESQIFF_AssetSourceSelect,D0
    BEQ.S   .lab_0A40

    MOVE.W  D6,DATA_WDISP_BSS_WORD_22AC
    BRA.S   .lab_0A41

.lab_0A40:
    MOVE.W  D6,DATA_WDISP_BSS_LONG_22AD

.lab_0A41:
    MOVEA.L -14(A5),A0
    MOVE.B  (A0)+,D5
    MOVE.L  A0,-14(A5)
    MOVEQ   #10,D0
    CMP.B   D0,D5
    BEQ.S   .lab_0A43

    MOVEQ   #13,D0
    CMP.B   D0,D5
    BEQ.S   .lab_0A43

    MOVEQ   #32,D0
    CMP.B   D0,D5
    BEQ.S   .lab_0A43

    MOVE.L  D4,D0
    SUBQ.L  #1,D4
    TST.L   D0
    BLE.S   .lab_0A43

    MOVEQ   #44,D0
    CMP.B   D0,D5
    BNE.S   .lab_0A42

    CLR.B   (A3)
    MOVE.W  #1,DATA_WDISP_BSS_LONG_22C3
    BRA.S   .lab_0A43

.lab_0A42:
    MOVE.B  D5,(A3)+
    BRA.S   .lab_0A41

.lab_0A43:
    CLR.B   (A3)
    MOVEQ   #1,D0

.return:
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_RestoreBasePaletteTriples   (Routine at ESQIFF_RestoreBasePaletteTriples)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A7/D0/D7
; CALLS:
;   (none)
; READS:
;   DATA_ESQFUNC_CONST_LONG_1ECC, WDISP_PaletteTriplesRBase
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_RestoreBasePaletteTriples:
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D7

.lab_0A46:
    MOVEQ   #24,D0
    CMP.W   D0,D7
    BGE.S   .return

    LEA     WDISP_PaletteTriplesRBase,A0
    ADDA.W  D7,A0
    LEA     DATA_ESQFUNC_CONST_LONG_1ECC,A1
    ADDA.W  D7,A1
    MOVE.B  (A1),(A0)
    ADDQ.W  #1,D7
    BRA.S   .lab_0A46

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_RunCopperRiseTransition   (Routine at ESQIFF_RunCopperRiseTransition)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQIFF_RunPendingCopperAnimations
; READS:
;   (none observed)
; WRITES:
;   DATA_COMMON_BSS_WORD_1B1C
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_RunCopperRiseTransition:
    MOVE.W  #15,DATA_COMMON_BSS_WORD_1B1C
    BSR.W   ESQIFF_RunPendingCopperAnimations

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_RunCopperDropTransition   (Routine at ESQIFF_RunCopperDropTransition)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQIFF_RunPendingCopperAnimations
; READS:
;   (none observed)
; WRITES:
;   DATA_COMMON_BSS_WORD_1B1B
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_RunCopperDropTransition:
    MOVE.W  #15,DATA_COMMON_BSS_WORD_1B1B
    BSR.W   ESQIFF_RunPendingCopperAnimations

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_ServicePendingCopperPaletteMoves   (Routine at ESQIFF_ServicePendingCopperPaletteMoves)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A4/A7/D0/D1
; CALLS:
;   ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd, ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart
; READS:
;   Global_REF_LONG_FILE_SCRATCH, DATA_COMMON_BSS_WORD_1B15, DATA_COMMON_BSS_WORD_1B16, DATA_COMMON_BSS_WORD_1B17, DATA_COMMON_BSS_LONG_1B18, WDISP_AccumulatorRow0_MoveFlags, WDISP_AccumulatorRow0_CopperIndexStart, WDISP_AccumulatorRow0_CopperIndexEnd, WDISP_AccumulatorRow1_MoveFlags, WDISP_AccumulatorRow1_CopperIndexStart, WDISP_AccumulatorRow1_CopperIndexEnd, WDISP_AccumulatorRow2_MoveFlags, WDISP_AccumulatorRow2_CopperIndexStart, WDISP_AccumulatorRow2_CopperIndexEnd, WDISP_AccumulatorRow3_MoveFlags, WDISP_AccumulatorRow3_CopperIndexStart, WDISP_AccumulatorRow3_CopperIndexEnd
; WRITES:
;   DATA_COMMON_BSS_WORD_1B15, DATA_COMMON_BSS_WORD_1B16, DATA_COMMON_BSS_WORD_1B17, DATA_COMMON_BSS_LONG_1B18
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_ServicePendingCopperPaletteMoves:
    MOVE.L  A4,-(A7)
    LEA     Global_REF_LONG_FILE_SCRATCH,A4
    MOVE.W  DATA_COMMON_BSS_WORD_1B15,D0
    SUBQ.W  #1,D0
    BNE.S   .lab_0A4C

    TST.W   WDISP_AccumulatorRow0_MoveFlags
    BEQ.S   .lab_0A4C

    CLR.W   DATA_COMMON_BSS_WORD_1B15
    MOVE.W  WDISP_AccumulatorRow0_MoveFlags,D0
    BTST    #1,D0
    BEQ.S   .lab_0A4B

    MOVEQ   #0,D0
    MOVE.B  WDISP_AccumulatorRow0_CopperIndexStart,D0
    MOVEQ   #0,D1
    MOVE.B  WDISP_AccumulatorRow0_CopperIndexEnd,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd(PC)

    ADDQ.W  #8,A7
    BRA.S   .lab_0A4C

.lab_0A4B:
    MOVEQ   #0,D0
    MOVE.B  WDISP_AccumulatorRow0_CopperIndexStart,D0
    MOVEQ   #0,D1
    MOVE.B  WDISP_AccumulatorRow0_CopperIndexEnd,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart(PC)

    ADDQ.W  #8,A7

.lab_0A4C:
    MOVE.W  DATA_COMMON_BSS_WORD_1B16,D0
    SUBQ.W  #1,D0
    BNE.S   .lab_0A4E

    TST.W   WDISP_AccumulatorRow1_MoveFlags
    BEQ.S   .lab_0A4E

    CLR.W   DATA_COMMON_BSS_WORD_1B16
    MOVE.W  WDISP_AccumulatorRow1_MoveFlags,D0
    BTST    #1,D0
    BEQ.S   .lab_0A4D

    MOVEQ   #0,D0
    MOVE.B  WDISP_AccumulatorRow1_CopperIndexStart,D0
    MOVEQ   #0,D1
    MOVE.B  WDISP_AccumulatorRow1_CopperIndexEnd,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd(PC)

    ADDQ.W  #8,A7
    BRA.S   .lab_0A4E

.lab_0A4D:
    MOVEQ   #0,D0
    MOVE.B  WDISP_AccumulatorRow1_CopperIndexStart,D0
    MOVEQ   #0,D1
    MOVE.B  WDISP_AccumulatorRow1_CopperIndexEnd,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart(PC)

    ADDQ.W  #8,A7

.lab_0A4E:
    MOVE.W  DATA_COMMON_BSS_WORD_1B17,D0
    SUBQ.W  #1,D0
    BNE.S   .lab_0A50

    TST.W   WDISP_AccumulatorRow2_MoveFlags
    BEQ.S   .lab_0A50

    CLR.W   DATA_COMMON_BSS_WORD_1B17
    MOVE.W  WDISP_AccumulatorRow2_MoveFlags,D0
    BTST    #1,D0
    BEQ.S   .lab_0A4F

    MOVEQ   #0,D0
    MOVE.B  WDISP_AccumulatorRow2_CopperIndexStart,D0
    MOVEQ   #0,D1
    MOVE.B  WDISP_AccumulatorRow2_CopperIndexEnd,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd(PC)

    ADDQ.W  #8,A7
    BRA.S   .lab_0A50

.lab_0A4F:
    MOVEQ   #0,D0
    MOVE.B  WDISP_AccumulatorRow2_CopperIndexStart,D0
    MOVEQ   #0,D1
    MOVE.B  WDISP_AccumulatorRow2_CopperIndexEnd,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart(PC)

    ADDQ.W  #8,A7

.lab_0A50:
    MOVE.W  DATA_COMMON_BSS_LONG_1B18,D0
    SUBQ.W  #1,D0
    BNE.S   .lab_0A52

    TST.W   WDISP_AccumulatorRow3_MoveFlags
    BEQ.S   .lab_0A52

    CLR.W   DATA_COMMON_BSS_LONG_1B18
    MOVE.W  WDISP_AccumulatorRow3_MoveFlags,D0
    BTST    #1,D0
    BEQ.S   .lab_0A51

    MOVEQ   #0,D0
    MOVE.B  WDISP_AccumulatorRow3_CopperIndexStart,D0
    MOVEQ   #0,D1
    MOVE.B  WDISP_AccumulatorRow3_CopperIndexEnd,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd(PC)

    ADDQ.W  #8,A7
    BRA.S   .lab_0A52

.lab_0A51:
    MOVEQ   #0,D0
    MOVE.B  WDISP_AccumulatorRow3_CopperIndexStart,D0
    MOVEQ   #0,D1
    MOVE.B  WDISP_AccumulatorRow3_CopperIndexEnd,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart(PC)

    ADDQ.W  #8,A7

.lab_0A52:
    MOVEA.L (A7)+,A4
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_SetApenToBrightestPaletteIndex   (Routine at ESQIFF_SetApenToBrightestPaletteIndex)
; ARGS:
;   stack +10: arg_1 (via 14(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A6/A7/D0/D1/D2/D4/D5/D6/D7
; CALLS:
;   _LVOSetAPen
; READS:
;   Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_2, WDISP_DisplayContextBase, WDISP_PaletteTriplesRBase, WDISP_PaletteTriplesGBase, WDISP_PaletteTriplesBBase, DATA_WDISP_BSS_LONG_22AE
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_SetApenToBrightestPaletteIndex:
    LINK.W  A5,#-16
    MOVEM.L D2/D4-D7,-(A7)
    MOVEQ   #0,D0
    MOVE.B  DATA_WDISP_BSS_LONG_22AE,D0
    MOVEQ   #1,D1
    ASL.L   D0,D1
    MOVE.L  D1,D4
    MOVEQ   #0,D0
    MOVE.B  WDISP_PaletteTriplesRBase,D0
    MOVEQ   #0,D1
    MOVE.B  WDISP_PaletteTriplesGBase,D1
    ADD.L   D1,D0
    MOVEQ   #0,D1
    MOVE.B  WDISP_PaletteTriplesBBase,D1
    ADD.L   D1,D0
    MOVE.L  D0,D6
    CLR.L   -14(A5)
    MOVEQ   #1,D7

.lab_0A54:
    MOVE.L  D7,D0
    EXT.L   D0
    CMP.L   D4,D0
    BGE.S   .lab_0A56

    MOVE.L  D7,D0
    MOVEQ   #3,D1
    MULS    D1,D0
    LEA     WDISP_PaletteTriplesRBase,A0
    ADDA.L  D0,A0
    MOVE.L  D7,D0
    MULS    D1,D0
    LEA     WDISP_PaletteTriplesGBase,A1
    ADDA.L  D0,A1
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVEQ   #0,D2
    MOVE.B  (A1),D2
    ADD.L   D2,D0
    MOVE.L  D7,D2
    MULS    D1,D2
    LEA     WDISP_PaletteTriplesBBase,A0
    ADDA.L  D2,A0
    MOVEQ   #0,D1
    MOVE.B  (A0),D1
    ADD.L   D1,D0
    MOVE.L  D0,D5
    CMP.W   D5,D6
    BGE.S   .lab_0A55

    MOVE.L  D5,D6
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-14(A5)

.lab_0A55:
    ADDQ.W  #1,D7
    BRA.S   .lab_0A54

.lab_0A56:
    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    MOVEA.L A0,A1
    MOVE.L  -14(A5),D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEM.L (A7)+,D2/D4-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_ShowExternalAssetWithCopperFx   (Routine at ESQIFF_ShowExternalAssetWithCopperFx)
; ARGS:
;   stack +6: arg_1 (via 10(A5))
;   stack +10: arg_2 (via 14(A5))
;   stack +14: arg_3 (via 18(A5))
;   stack +18: arg_4 (via 22(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A6/A7/D0/D1/D2/D4/D5/D6/D7
; CALLS:
;   ESQIFF_JMPTBL_BRUSH_SelectBrushSlot, ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode, ESQIFF_JMPTBL_MATH_DivS32, ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition, ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex, ESQIFF_RunCopperRiseTransition, ESQIFF_RunCopperDropTransition, _LVOCopyMem, _LVOSetAPen, _LVOSetRast
; READS:
;   AbsExecBase, Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_2, DATA_COMMON_BSS_WORD_1B0D, DATA_COMMON_BSS_WORD_1B0E, DATA_COMMON_BSS_WORD_1B0F, ESQIFF_GAdsBrushListHead, ESQIFF_LogoBrushListHead, SCRIPT_BannerTransitionActive, WDISP_DisplayContextBase, WDISP_PaletteTriplesRBase, WDISP_AccumulatorRowTable, WDISP_AccumulatorRow0_Value, WDISP_AccumulatorRow0_CopperIndexStart, WDISP_AccumulatorRow0_CopperIndexEnd, WDISP_AccumulatorRow1_Value, WDISP_AccumulatorRow1_CopperIndexStart, WDISP_AccumulatorRow1_CopperIndexEnd, WDISP_AccumulatorRow2_Value, WDISP_AccumulatorRow2_CopperIndexStart, WDISP_AccumulatorRow2_CopperIndexEnd, WDISP_AccumulatorRow3_Value, WDISP_AccumulatorRow3_CopperIndexStart, WDISP_AccumulatorRow3_CopperIndexEnd, e8, lab_0A72
; WRITES:
;   DATA_COMMON_BSS_WORD_1B0D, DATA_COMMON_BSS_WORD_1B0E, DATA_COMMON_BSS_WORD_1B0F, DATA_COMMON_BSS_WORD_1B10, DATA_COMMON_BSS_WORD_1B11, DATA_COMMON_BSS_WORD_1B12, DATA_COMMON_BSS_WORD_1B13, DATA_COMMON_BSS_WORD_1B14, DATA_COMMON_BSS_WORD_1B15, DATA_COMMON_BSS_WORD_1B16, DATA_COMMON_BSS_WORD_1B17, DATA_COMMON_BSS_LONG_1B18, DATA_ESQFUNC_BSS_WORD_1EE4, WDISP_DisplayContextBase, WDISP_AccumulatorCaptureActive, WDISP_AccumulatorFlushPending
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_ShowExternalAssetWithCopperFx:
    LINK.W  A5,#-36
    MOVEM.L D2/D4-D7,-(A7)
    MOVE.W  10(A5),D7
    TST.W   D7
    BEQ.S   .lab_0A58

    MOVE.L  ESQIFF_GAdsBrushListHead,-22(A5)

.lab_0A58:
    TST.W   D7
    BNE.S   .lab_0A59

    MOVEA.L ESQIFF_LogoBrushListHead,A0
    MOVE.L  A0,-22(A5)

.lab_0A59:
    TST.L   -22(A5)
    BEQ.W   .lab_0A72

    BSR.W   ESQIFF_RunCopperDropTransition

    MOVEQ   #20,D6
    MOVEA.L -22(A5),A0
    ADD.W   178(A0),D6
    BTST    #2,199(A0)
    BEQ.S   .lab_0A5A

    MOVEQ   #2,D0
    BRA.S   .lab_0A5B

.lab_0A5A:
    MOVEQ   #1,D0

.lab_0A5B:
    MOVE.L  D6,D1
    EXT.L   D1
    MOVE.L  D0,20(A7)
    MOVE.L  D1,D0
    MOVE.L  20(A7),D1
    JSR     ESQIFF_JMPTBL_MATH_DivS32(PC)

    MOVE.L  D0,D6
    MOVEQ   #120,D0
    CMP.W   D0,D6
    BLE.S   .lab_0A5C

    MOVE.L  D0,D6

.lab_0A5C:
    ADDI.W  #22,D6
    MOVE.L  D6,D0
    EXT.L   D0
    PEA     1000.W
    MOVE.L  D0,-(A7)
    JSR     ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition(PC)

    ADDQ.W  #8,A7

.lab_0A5D:
    TST.W   SCRIPT_BannerTransitionActive
    BNE.S   .lab_0A5D

    MOVE.W  #1,WDISP_AccumulatorCaptureActive
    CLR.W   WDISP_AccumulatorFlushPending
    MOVEQ   #0,D5

.lab_0A5E:
    MOVEQ   #4,D0
    CMP.L   D0,D5
    BGE.S   .lab_0A5F

    MOVE.L  D5,D0
    ASL.L   #3,D0
    MOVEA.L -22(A5),A0
    ADDA.L  D0,A0
    LEA     200(A0),A1
    LEA     WDISP_AccumulatorRowTable,A0
    ADDA.L  D0,A0
    MOVE.L  A0,28(A7)
    MOVEA.L A1,A0
    MOVEA.L 28(A7),A1
    MOVEQ   #8,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCopyMem(A6)

    ADDQ.L  #1,D5
    BRA.S   .lab_0A5E

.lab_0A5F:
    CLR.W   WDISP_AccumulatorCaptureActive
    MOVE.W  #1,WDISP_AccumulatorFlushPending
    MOVE.L  #$8004,D0
    MOVEA.L -22(A5),A0
    AND.L   196(A0),D0
    CMPI.L  #$8004,D0
    BNE.S   .lab_0A60

    MOVEQ   #0,D0
    MOVE.B  184(A0),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    PEA     4.W
    JSR     ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(PC)

    LEA     12(A7),A7
    MOVE.L  D0,WDISP_DisplayContextBase
    MOVEQ   #20,D4
    BRA.S   .lab_0A63

.lab_0A60:
    BTST    #7,198(A0)
    BEQ.S   .lab_0A61

    MOVEQ   #0,D0
    MOVE.B  184(A0),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    PEA     6.W
    JSR     ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(PC)

    LEA     12(A7),A7
    MOVE.L  D0,WDISP_DisplayContextBase
    MOVEQ   #10,D4
    BRA.S   .lab_0A63

.lab_0A61:
    BTST    #2,199(A0)
    BEQ.S   .lab_0A62

    MOVEQ   #0,D0
    MOVE.B  184(A0),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    PEA     5.W
    JSR     ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(PC)

    LEA     12(A7),A7
    MOVE.L  D0,WDISP_DisplayContextBase
    MOVEQ   #20,D4
    BRA.S   .lab_0A63

.lab_0A62:
    MOVEQ   #0,D0
    MOVE.B  184(A0),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    PEA     7.W
    JSR     ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(PC)

    LEA     12(A7),A7
    MOVE.L  D0,WDISP_DisplayContextBase
    MOVEQ   #10,D4

.lab_0A63:
    MOVEA.L D0,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    MOVEA.L A0,A1
    MOVEQ   #7,D0
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVEA.L WDISP_DisplayContextBase,A0
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
    JSR     ESQIFF_JMPTBL_BRUSH_SelectBrushSlot(PC)

    LEA     28(A7),A7
    MOVEA.L -22(A5),A0
    TST.L   328(A0)
    BEQ.S   .lab_0A64

    MOVEQ   #1,D0
    CMP.L   328(A0),D0
    BNE.S   .lab_0A66

.lab_0A64:
    PEA     5.W
    JSR     ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex(PC)

    MOVE.L  D0,D1
    LSL.L   #2,D1
    SUB.L   D0,D1
    MOVEQ   #0,D0
    MOVEA.L -22(A5),A0
    MOVE.B  184(A0),D0
    MOVE.L  D0,(A7)
    MOVE.L  D1,-14(A5)
    JSR     ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D1
    LSL.L   #2,D1
    SUB.L   D0,D1
    MOVEQ   #0,D5
    MOVE.L  D1,-18(A5)

.branch:
    CMP.L   -18(A5),D5
    BGE.S   .lab_0A66

    CMP.L   -14(A5),D5
    BGE.S   .lab_0A66

    LEA     WDISP_PaletteTriplesRBase,A0
    ADDA.L  D5,A0
    MOVEA.L -22(A5),A1
    MOVE.L  D5,D0
    ADDI.L  #$e8,D0
    MOVE.B  0(A1,D0.L),(A0)
    ADDQ.L  #1,D5
    BRA.S   .branch

.lab_0A66:
    MOVE.B  WDISP_AccumulatorRow0_CopperIndexStart,D0
    MOVEQ   #32,D1
    CMP.B   D1,D0
    BCC.S   .branch_1

    MOVE.B  WDISP_AccumulatorRow0_CopperIndexEnd,D0
    CMP.B   D1,D0
    BCC.S   .branch_1

    MOVE.W  WDISP_AccumulatorRow0_Value,D0
    CMPI.W  #$4000,D0
    BGE.S   .branch_1

    MOVE.W  D0,DATA_COMMON_BSS_WORD_1B0D
    BRA.S   .branch_2

.branch_1:
    MOVEQ   #0,D0
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1B0D

.branch_2:
    MOVE.B  WDISP_AccumulatorRow1_CopperIndexStart,D2
    CMP.B   D1,D2
    BCC.S   .branch_3

    MOVE.B  WDISP_AccumulatorRow1_CopperIndexEnd,D2
    CMP.B   D1,D2
    BCC.S   .branch_3

    MOVE.W  WDISP_AccumulatorRow1_Value,D2
    CMPI.W  #$4000,D2
    BGE.S   .branch_3

    MOVE.W  D2,DATA_COMMON_BSS_WORD_1B0E
    BRA.S   .branch_4

.branch_3:
    MOVEQ   #0,D2
    MOVE.W  D2,DATA_COMMON_BSS_WORD_1B0E

.branch_4:
    MOVE.B  WDISP_AccumulatorRow2_CopperIndexStart,D0
    CMP.B   D1,D0
    BCC.S   .branch_5

    MOVE.B  WDISP_AccumulatorRow2_CopperIndexEnd,D0
    CMP.B   D1,D0
    BCC.S   .branch_5

    MOVE.W  WDISP_AccumulatorRow2_Value,D0
    CMPI.W  #$4000,D0
    BGE.S   .branch_5

    MOVE.W  D0,DATA_COMMON_BSS_WORD_1B0F
    BRA.S   .branch_6

.branch_5:
    MOVEQ   #0,D0
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1B0F

.branch_6:
    MOVE.B  WDISP_AccumulatorRow3_CopperIndexStart,D2
    CMP.B   D1,D2
    BCC.S   .branch_7

    MOVE.B  WDISP_AccumulatorRow3_CopperIndexEnd,D2
    CMP.B   D1,D2
    BCC.S   .branch_7

    MOVE.W  WDISP_AccumulatorRow3_Value,D1
    CMPI.W  #$4000,D1
    BGE.S   .branch_7

    MOVE.W  D1,DATA_COMMON_BSS_WORD_1B10
    BRA.S   .branch_8

.branch_7:
    MOVEQ   #0,D1
    MOVE.W  D1,DATA_COMMON_BSS_WORD_1B10

.branch_8:
    TST.W   DATA_COMMON_BSS_WORD_1B0D
    BNE.S   .branch_9

    TST.W   DATA_COMMON_BSS_WORD_1B0E
    BNE.S   .branch_9

    TST.W   DATA_COMMON_BSS_WORD_1B0F
    BNE.S   .branch_9

    TST.W   D1
    BEQ.S   .branch_10

.branch_9:
    MOVE.W  #1,WDISP_AccumulatorCaptureActive
    BRA.S   .branch_11

.branch_10:
    MOVEQ   #0,D0
    MOVE.W  D0,WDISP_AccumulatorCaptureActive

.branch_11:
    MOVEQ   #0,D0
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1B11
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1B15
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1B12
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1B16
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1B13
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1B17
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1B14
    MOVE.W  D0,DATA_COMMON_BSS_LONG_1B18
    BSR.W   ESQIFF_RunCopperRiseTransition

    BRA.S   ESQIFF_ShowExternalAssetWithCopperFx_Return

.lab_0A72:
    TST.W   D7
    BEQ.S   .branch_12

    MOVEQ   #1,D0
    BRA.S   .branch_13

.branch_12:
    MOVEQ   #2,D0

.branch_13:
    OR.L    D0,DATA_ESQFUNC_BSS_WORD_1EE4

;------------------------------------------------------------------------------
; FUNC: ESQIFF_ShowExternalAssetWithCopperFx_Return   (Routine at ESQIFF_ShowExternalAssetWithCopperFx_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D2
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_ShowExternalAssetWithCopperFx_Return:
    MOVEM.L (A7)+,D2/D4-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_ServiceExternalAssetSourceState   (Routine at ESQIFF_ServiceExternalAssetSourceState)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D1/D7
; CALLS:
;   ESQDISP_ProcessGridMessagesIfIdle, ESQIFF_ReloadExternalAssetCatalogBuffers, ESQIFF_QueueNextExternalAssetIffJob
; READS:
;   Global_WORD_SELECT_CODE_IS_RAVESC, DATA_COI_BSS_WORD_1B85, ESQIFF_ExternalAssetFlags, DISKIO_Drive0WriteProtectedCode, DATA_WDISP_BSS_LONG_2319
; WRITES:
;   ESQIFF_AssetSourceSelect, ESQIFF_GAdsSourceEnabled
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_ServiceExternalAssetSourceState:
    MOVE.L  D7,-(A7)
    MOVE.W  10(A7),D7
    TST.W   Global_WORD_SELECT_CODE_IS_RAVESC
    BNE.S   .return

    JSR     ESQDISP_ProcessGridMessagesIfIdle(PC)

    TST.W   DATA_COI_BSS_WORD_1B85
    BNE.S   .return

    TST.W   D7
    BEQ.S   .lab_0A77

    MOVEQ   #0,D0
    MOVE.W  D0,ESQIFF_AssetSourceSelect
    MOVEQ   #-1,D1
    MOVE.W  D1,ESQIFF_GAdsSourceEnabled
    BRA.S   .lab_0A78

.lab_0A77:
    CLR.W   ESQIFF_GAdsSourceEnabled
    MOVE.W  #(-1),ESQIFF_AssetSourceSelect

.lab_0A78:
    TST.L   DISKIO_Drive0WriteProtectedCode
    BNE.S   .lab_0A79

    MOVE.W  ESQIFF_ExternalAssetFlags,D0
    ANDI.W  #2,D0
    SUBQ.W  #2,D0
    BEQ.S   .lab_0A79

    CLR.L   -(A7)
    BSR.W   ESQIFF_ReloadExternalAssetCatalogBuffers

    ADDQ.W  #4,A7

.lab_0A79:
    TST.L   DATA_WDISP_BSS_LONG_2319
    BNE.S   .lab_0A7A

    MOVE.W  ESQIFF_ExternalAssetFlags,D0
    ANDI.W  #1,D0
    SUBQ.W  #1,D0
    BEQ.S   .lab_0A7A

    PEA     1.W
    BSR.W   ESQIFF_ReloadExternalAssetCatalogBuffers

    ADDQ.W  #4,A7

.lab_0A7A:
    JSR     ESQDISP_ProcessGridMessagesIfIdle(PC)

    BSR.W   ESQIFF_QueueNextExternalAssetIffJob

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_PlayNextExternalAssetFrame   (Routine at ESQIFF_PlayNextExternalAssetFrame)
; ARGS:
;   stack +6: arg_1 (via 10(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A6/A7/D0/D1/D6/D7
; CALLS:
;   ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode, ESQIFF_JMPTBL_BRUSH_PopBrushHead, ESQIFF_JMPTBL_ESQ_NoOp, ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode, ESQIFF_JMPTBL_SCRIPT_AssertCtrlLineIfEnabled, ESQIFF_JMPTBL_TEXTDISP_DrawChannelBanner, GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight, ESQDISP_ProcessGridMessagesIfIdle, ESQIFF_RestoreBasePaletteTriples, ESQIFF_RunCopperRiseTransition, ESQIFF_RunCopperDropTransition, ESQIFF_SetApenToBrightestPaletteIndex, ESQIFF_ShowExternalAssetWithCopperFx, ESQIFF_ServiceExternalAssetSourceState, _LVOForbid, _LVOPermit, _LVOSetAPen, _LVOSetDrMd, _LVOSetRast
; READS:
;   AbsExecBase, Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_2, TEXTDISP_DeferredActionCountdown, ESQIFF_GAdsBrushListHead, ESQIFF_LogoBrushListHead, WDISP_DisplayContextBase, TEXTDISP_PrimaryGroupEntryCount, WDISP_AccumulatorCaptureActive, DATA_WDISP_BSS_LONG_22C2, DATA_WDISP_BSS_LONG_22C3, lab_0A87, lab_0A88
; WRITES:
;   ESQIFF_GAdsBrushListCount, ESQIFF_LogoBrushListCount, ESQIFF_GAdsBrushListHead, ESQIFF_LogoBrushListHead, WDISP_DisplayContextBase, WDISP_AccumulatorCaptureActive, TEXTDISP_CurrentMatchIndex
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_PlayNextExternalAssetFrame:
    LINK.W  A5,#-8
    MOVEM.L D6-D7,-(A7)
    MOVE.W  10(A5),D7
    BSR.W   ESQIFF_RunCopperDropTransition

    TST.W   D7
    BEQ.S   .lab_0A7D

    TST.L   ESQIFF_GAdsBrushListHead
    BNE.S   .lab_0A7E

.lab_0A7D:
    TST.W   D7
    BNE.W   .lab_0A87

    TST.L   ESQIFF_LogoBrushListHead
    BEQ.W   .lab_0A87

.lab_0A7E:
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
    MOVE.W  DATA_WDISP_BSS_LONG_22C2,D1
    CMP.W   D1,D0
    BCC.S   .lab_0A7F

    TST.W   D7
    BNE.S   .lab_0A7F

    TST.W   DATA_WDISP_BSS_LONG_22C3
    BNE.S   .lab_0A7F

    BSR.W   ESQIFF_RestoreBasePaletteTriples

    JSR     GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight(PC)

    PEA     2.W
    JSR     ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode(PC)

    ADDQ.W  #4,A7
    BRA.W   .lab_0A88

.lab_0A7F:
    JSR     GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight(PC)

    PEA     1.W
    CLR.L   -(A7)
    PEA     4.W
    JSR     ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(PC)

    MOVE.L  D0,WDISP_DisplayContextBase
    MOVEA.L D0,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    MOVEA.L A0,A1
    MOVEQ   #2,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    JSR     ESQDISP_ProcessGridMessagesIfIdle(PC)

    LEA     12(A7),A7
    TST.W   D7
    BEQ.S   .lab_0A80

    MOVEA.L ESQIFF_GAdsBrushListHead,A0
    BRA.S   .lab_0A81

.lab_0A80:
    MOVEA.L ESQIFF_LogoBrushListHead,A0

.lab_0A81:
    MOVE.L  A0,-6(A5)
    JSR     ESQIFF_JMPTBL_ESQ_NoOp(PC)

    MOVEQ   #1,D0
    CMP.W   D0,D7
    BNE.S   .lab_0A83

    MOVE.W  TEXTDISP_DeferredActionCountdown,D0
    SUBQ.W  #2,D0
    BEQ.S   .lab_0A82

    MOVE.W  TEXTDISP_DeferredActionCountdown,D0
    SUBQ.W  #3,D0
    BNE.S   .lab_0A83

.lab_0A82:
    JSR     ESQIFF_JMPTBL_SCRIPT_AssertCtrlLineIfEnabled(PC)

.lab_0A83:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   ESQIFF_ShowExternalAssetWithCopperFx

    ADDQ.W  #4,A7
    TST.W   D7
    BNE.S   .lab_0A84

    TST.W   DATA_WDISP_BSS_LONG_22C3
    BNE.S   .lab_0A84

    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    BSR.W   ESQIFF_SetApenToBrightestPaletteIndex

    MOVE.W  DATA_WDISP_BSS_LONG_22C2,TEXTDISP_CurrentMatchIndex
    PEA     2.W
    PEA     1.W
    JSR     ESQIFF_JMPTBL_TEXTDISP_DrawChannelBanner(PC)

    ADDQ.W  #8,A7
    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    MOVEA.L A0,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

.lab_0A84:
    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    MOVEA.L A0,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    TST.W   D7
    BEQ.S   .lab_0A85

    SUBQ.L  #1,ESQIFF_GAdsBrushListCount
    MOVE.L  ESQIFF_GAdsBrushListHead,-(A7)
    JSR     ESQIFF_JMPTBL_BRUSH_PopBrushHead(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,ESQIFF_GAdsBrushListHead
    BRA.S   .lab_0A86

.lab_0A85:
    SUBQ.L  #1,ESQIFF_LogoBrushListCount
    MOVE.L  ESQIFF_LogoBrushListHead,-(A7)
    JSR     ESQIFF_JMPTBL_BRUSH_PopBrushHead(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,ESQIFF_LogoBrushListHead

.lab_0A86:
    MOVEA.L AbsExecBase,A6
    JSR     _LVOPermit(A6)

    BRA.S   .lab_0A88

.lab_0A87:
    BSR.W   ESQIFF_RestoreBasePaletteTriples

    JSR     GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight(PC)

    PEA     2.W
    JSR     ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode(PC)

    ADDQ.W  #4,A7

.lab_0A88:
    MOVE.W  WDISP_AccumulatorCaptureActive,D6
    CLR.W   WDISP_AccumulatorCaptureActive
    BSR.W   ESQIFF_RunCopperRiseTransition

    MOVE.W  D6,WDISP_AccumulatorCaptureActive
    TST.W   D7
    BEQ.S   .lab_0A89

    PEA     1.W
    BSR.W   ESQIFF_ServiceExternalAssetSourceState

    ADDQ.W  #4,A7
    BRA.S   ESQIFF_PlayNextExternalAssetFrame_Return

.lab_0A89:
    CLR.L   -(A7)
    BSR.W   ESQIFF_ServiceExternalAssetSourceState

    ADDQ.W  #4,A7

;------------------------------------------------------------------------------
; FUNC: ESQIFF_PlayNextExternalAssetFrame_Return   (Routine at ESQIFF_PlayNextExternalAssetFrame_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D6
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_PlayNextExternalAssetFrame_Return:
    MOVEM.L (A7)+,D6-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_DeallocateAdsAndLogoLstData   (Routine at ESQIFF_DeallocateAdsAndLogoLstData)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0
; CALLS:
;   ESQIFF_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   Global_REF_LONG_DF0_LOGO_LST_DATA, Global_REF_LONG_DF0_LOGO_LST_FILESIZE, Global_REF_LONG_GFX_G_ADS_DATA, Global_REF_LONG_GFX_G_ADS_FILESIZE, Global_STR_ESQIFF_C_7, Global_STR_ESQIFF_C_8
; WRITES:
;   Global_REF_LONG_DF0_LOGO_LST_DATA, Global_REF_LONG_DF0_LOGO_LST_FILESIZE, Global_REF_LONG_GFX_G_ADS_DATA, Global_REF_LONG_GFX_G_ADS_FILESIZE
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_DeallocateAdsAndLogoLstData:
    TST.L   Global_REF_LONG_GFX_G_ADS_DATA
    BEQ.S   .deallocLogoLstData

    TST.L   Global_REF_LONG_GFX_G_ADS_FILESIZE
    BEQ.S   .deallocLogoLstData

    MOVE.L  Global_REF_LONG_GFX_G_ADS_FILESIZE,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  Global_REF_LONG_GFX_G_ADS_DATA,-(A7)
    PEA     1988.W
    PEA     Global_STR_ESQIFF_C_7
    JSR     ESQIFF_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    CLR.L   Global_REF_LONG_GFX_G_ADS_DATA
    CLR.L   Global_REF_LONG_GFX_G_ADS_FILESIZE

.deallocLogoLstData:
    TST.L   Global_REF_LONG_DF0_LOGO_LST_DATA
    BEQ.S   .return

    TST.L   Global_REF_LONG_DF0_LOGO_LST_FILESIZE
    BEQ.S   .return

    MOVE.L  Global_REF_LONG_DF0_LOGO_LST_FILESIZE,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  Global_REF_LONG_DF0_LOGO_LST_DATA,-(A7)
    PEA     1994.W
    PEA     Global_STR_ESQIFF_C_8
    JSR     ESQIFF_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    CLR.L   Global_REF_LONG_DF0_LOGO_LST_DATA
    CLR.L   Global_REF_LONG_DF0_LOGO_LST_FILESIZE

.return:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_RunPendingCopperAnimations   (Routine at ESQIFF_RunPendingCopperAnimations)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/D1
; CALLS:
;   ESQIFF_JMPTBL_ESQ_DecCopperListsPrimary, ESQIFF_JMPTBL_ESQ_IncCopperListsTowardsTargets, ESQIFF_JMPTBL_ESQ_NoOp_006A, ESQIFF_JMPTBL_ESQ_NoOp_0074
; READS:
;   DATA_COMMON_BSS_WORD_1B19, DATA_COMMON_BSS_WORD_1B1A, DATA_COMMON_BSS_WORD_1B1B, DATA_COMMON_BSS_WORD_1B1C
; WRITES:
;   DATA_COMMON_BSS_WORD_1B19, DATA_COMMON_BSS_WORD_1B1A, DATA_COMMON_BSS_WORD_1B1B, DATA_COMMON_BSS_WORD_1B1C
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_RunPendingCopperAnimations:
    MOVE.W  DATA_COMMON_BSS_WORD_1B19,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   .lab_0A8F

    JSR     ESQIFF_JMPTBL_ESQ_NoOp_006A(PC)

    MOVE.W  DATA_COMMON_BSS_WORD_1B19,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1B19
    BRA.S   ESQIFF_RunPendingCopperAnimations

.lab_0A8F:
    MOVE.W  DATA_COMMON_BSS_WORD_1B1A,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   .lab_0A90

    JSR     ESQIFF_JMPTBL_ESQ_NoOp_0074(PC)

    MOVE.W  DATA_COMMON_BSS_WORD_1B1A,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1B1A
    BRA.S   .lab_0A8F

.lab_0A90:
    MOVE.W  DATA_COMMON_BSS_WORD_1B1B,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   .lab_0A91

    JSR     ESQIFF_JMPTBL_ESQ_DecCopperListsPrimary(PC)

    MOVE.W  DATA_COMMON_BSS_WORD_1B1B,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1B1B
    BRA.S   .lab_0A90

.lab_0A91:
    MOVE.W  DATA_COMMON_BSS_WORD_1B1C,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   .lab_0A92

    JSR     ESQIFF_JMPTBL_ESQ_IncCopperListsTowardsTargets(PC)

    MOVE.W  DATA_COMMON_BSS_WORD_1B1C,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1B1C
    BRA.S   .lab_0A91

.lab_0A92:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_HandleBrushIniReloadHotkey   (Routine at ESQIFF_HandleBrushIniReloadHotkey)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D7
; CALLS:
;   ESQIFF_JMPTBL_BRUSH_FindBrushByPredicate, ESQIFF_JMPTBL_BRUSH_FindType3Brush, ESQIFF_JMPTBL_BRUSH_FreeBrushList, ESQIFF_JMPTBL_BRUSH_SelectBrushByLabel, ESQIFF_JMPTBL_DISKIO_ForceUiRefreshIfIdle, ESQIFF_JMPTBL_DISKIO_ResetCtrlInputStateIfIdle, GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch, GROUP_AU_JMPTBL_BRUSH_PopulateBrushList
; READS:
;   BRUSH_SelectedNode, Global_STR_DF0_BRUSH_INI_2, PARSEINI_ParsedDescriptorListHead, ESQIFF_BrushIniListHead, DATA_ESQIFF_TAG_DT_1EF8, DATA_ESQIFF_TAG_DITHER_1EF9
; WRITES:
;   BRUSH_SelectedNode, DATA_ESQFUNC_BSS_LONG_1ED0
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_HandleBrushIniReloadHotkey:
    MOVE.L  D7,-(A7)

    MOVE.B  11(A7),D7
    MOVEQ   #97,D0
    CMP.B   D0,D7
    BNE.S   .return

    JSR     ESQIFF_JMPTBL_DISKIO_ForceUiRefreshIfIdle(PC)

    CLR.L   -(A7)
    PEA     ESQIFF_BrushIniListHead
    JSR     ESQIFF_JMPTBL_BRUSH_FreeBrushList(PC)

    PEA     Global_STR_DF0_BRUSH_INI_2
    JSR     GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch(PC)

    PEA     ESQIFF_BrushIniListHead
    MOVE.L  PARSEINI_ParsedDescriptorListHead,-(A7)
    JSR     GROUP_AU_JMPTBL_BRUSH_PopulateBrushList(PC)

    PEA     DATA_ESQIFF_TAG_DT_1EF8
    JSR     ESQIFF_JMPTBL_BRUSH_SelectBrushByLabel(PC)

    LEA     24(A7),A7
    TST.L   BRUSH_SelectedNode
    BNE.S   .lab_0A94

    PEA     ESQIFF_BrushIniListHead
    PEA     DATA_ESQIFF_TAG_DITHER_1EF9
    JSR     ESQIFF_JMPTBL_BRUSH_FindBrushByPredicate(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,BRUSH_SelectedNode

.lab_0A94:
    PEA     ESQIFF_BrushIniListHead
    JSR     ESQIFF_JMPTBL_BRUSH_FindType3Brush(PC)

    MOVE.L  D0,DATA_ESQFUNC_BSS_LONG_1ED0
    JSR     ESQIFF_JMPTBL_DISKIO_ResetCtrlInputStateIfIdle(PC)

    ADDQ.W  #4,A7

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======

    ; Alignment bytes
    DC.W    $0000

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_STRING_CompareNoCase   (Routine at ESQIFF_JMPTBL_STRING_CompareNoCase)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   STRING_CompareNoCase
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_STRING_CompareNoCase:
    JMP     STRING_CompareNoCase

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode   (Routine at ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   TLIBA3_BuildDisplayContextForViewMode
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode:
    JMP     TLIBA3_BuildDisplayContextForViewMode

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_DISKIO_GetFilesizeFromHandle   (Routine at ESQIFF_JMPTBL_DISKIO_GetFilesizeFromHandle)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   DISKIO_GetFilesizeFromHandle
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_DISKIO_GetFilesizeFromHandle:
    JMP     DISKIO_GetFilesizeFromHandle

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_MATH_DivS32   (Routine at ESQIFF_JMPTBL_MATH_DivS32)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   MATH_DivS32
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_MATH_DivS32:
    JMP     MATH_DivS32

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_TEXTDISP_FindEntryIndexByWildcard   (Routine at ESQIFF_JMPTBL_TEXTDISP_FindEntryIndexByWildcard)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   TEXTDISP_FindEntryIndexByWildcard
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_TEXTDISP_FindEntryIndexByWildcard:
    JMP     TEXTDISP_FindEntryIndexByWildcard

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_STRING_CompareN   (Routine at ESQIFF_JMPTBL_STRING_CompareN)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   STRING_CompareN
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_STRING_CompareN:
    JMP     STRING_CompareN

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_ESQ_NoOp   (Routine at ESQIFF_JMPTBL_ESQ_NoOp)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_NoOp
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_ESQ_NoOp:
    JMP     ESQ_NoOp

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_TEXTDISP_DrawChannelBanner   (Routine at ESQIFF_JMPTBL_TEXTDISP_DrawChannelBanner)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   TEXTDISP_DrawChannelBanner
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_TEXTDISP_DrawChannelBanner:
    JMP     TEXTDISP_DrawChannelBanner

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart   (Routine at ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_MoveCopperEntryTowardStart
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart:
    JMP     ESQ_MoveCopperEntryTowardStart

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_MEMORY_DeallocateMemory   (Routine at ESQIFF_JMPTBL_MEMORY_DeallocateMemory)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   MEMORY_DeallocateMemory
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_MEMORY_DeallocateMemory:
    JMP     MEMORY_DeallocateMemory

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_DISKIO_ForceUiRefreshIfIdle   (Routine at ESQIFF_JMPTBL_DISKIO_ForceUiRefreshIfIdle)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   DISKIO_ForceUiRefreshIfIdle
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_DISKIO_ForceUiRefreshIfIdle:
    JMP     DISKIO_ForceUiRefreshIfIdle

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_BRUSH_CloneBrushRecord   (Routine at ESQIFF_JMPTBL_BRUSH_CloneBrushRecord)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   BRUSH_CloneBrushRecord
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_BRUSH_CloneBrushRecord:
    JMP     BRUSH_CloneBrushRecord

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd   (Routine at ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_MoveCopperEntryTowardEnd
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd:
    JMP     ESQ_MoveCopperEntryTowardEnd

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_BRUSH_FindBrushByPredicate   (Routine at ESQIFF_JMPTBL_BRUSH_FindBrushByPredicate)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   BRUSH_FindBrushByPredicate
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_BRUSH_FindBrushByPredicate:
    JMP     BRUSH_FindBrushByPredicate

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_BRUSH_FreeBrushList   (Routine at ESQIFF_JMPTBL_BRUSH_FreeBrushList)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   BRUSH_FreeBrushList
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_BRUSH_FreeBrushList:
    JMP     BRUSH_FreeBrushList

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_BRUSH_FindType3Brush   (Routine at ESQIFF_JMPTBL_BRUSH_FindType3Brush)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   BRUSH_FindType3Brush
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_BRUSH_FindType3Brush:
    JMP     BRUSH_FindType3Brush

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_BRUSH_PopBrushHead   (Routine at ESQIFF_JMPTBL_BRUSH_PopBrushHead)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   BRUSH_PopBrushHead
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_BRUSH_PopBrushHead:
    JMP     BRUSH_PopBrushHead

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_BRUSH_AllocBrushNode   (Routine at ESQIFF_JMPTBL_BRUSH_AllocBrushNode)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   BRUSH_AllocBrushNode
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_BRUSH_AllocBrushNode:
    JMP     BRUSH_AllocBrushNode

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_ESQ_NoOp_006A   (Routine at ESQIFF_JMPTBL_ESQ_NoOp_006A)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_NoOp_006A
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_ESQ_NoOp_006A:
    JMP     ESQ_NoOp_006A

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode   (Routine at ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   NEWGRID_ValidateSelectionCode
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode:
    JMP     NEWGRID_ValidateSelectionCode

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_BRUSH_PopulateBrushList   (Routine at ESQIFF_JMPTBL_BRUSH_PopulateBrushList)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   BRUSH_PopulateBrushList
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_BRUSH_PopulateBrushList:
    JMP     BRUSH_PopulateBrushList

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_ESQ_NoOp_0074   (Routine at ESQIFF_JMPTBL_ESQ_NoOp_0074)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_NoOp_0074
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_ESQ_NoOp_0074:
    JMP     ESQ_NoOp_0074

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_STRING_CompareNoCaseN   (Routine at ESQIFF_JMPTBL_STRING_CompareNoCaseN)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   STRING_CompareNoCaseN
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_STRING_CompareNoCaseN:
    JMP     STRING_CompareNoCaseN

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_SCRIPT_AssertCtrlLineIfEnabled   (Routine at ESQIFF_JMPTBL_SCRIPT_AssertCtrlLineIfEnabled)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   SCRIPT_AssertCtrlLineIfEnabled
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_SCRIPT_AssertCtrlLineIfEnabled:
    JMP     SCRIPT_AssertCtrlLineIfEnabled

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition   (Routine at ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   SCRIPT_BeginBannerCharTransition
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition:
    JMP     SCRIPT_BeginBannerCharTransition

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_MEMORY_AllocateMemory   (Routine at ESQIFF_JMPTBL_MEMORY_AllocateMemory)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   MEMORY_AllocateMemory
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_MEMORY_AllocateMemory:
    JMP     MEMORY_AllocateMemory

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_CTASKS_StartIffTaskProcess   (Routine at ESQIFF_JMPTBL_CTASKS_StartIffTaskProcess)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   CTASKS_StartIffTaskProcess
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_CTASKS_StartIffTaskProcess:
    JMP     CTASKS_StartIffTaskProcess

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_UNKNOWN2B_OpenFileWithAccessMode   (Routine at ESQIFF_JMPTBL_UNKNOWN2B_OpenFileWithAccessMode)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   UNKNOWN2B_OpenFileWithAccessMode
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_UNKNOWN2B_OpenFileWithAccessMode:
    JMP     UNKNOWN2B_OpenFileWithAccessMode

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_ESQ_IncCopperListsTowardsTargets   (Routine at ESQIFF_JMPTBL_ESQ_IncCopperListsTowardsTargets)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_IncCopperListsTowardsTargets
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_ESQ_IncCopperListsTowardsTargets:
    JMP     ESQ_IncCopperListsTowardsTargets

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_ESQ_DecCopperListsPrimary   (Routine at ESQIFF_JMPTBL_ESQ_DecCopperListsPrimary)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_DecCopperListsPrimary
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_ESQ_DecCopperListsPrimary:
    JMP     ESQ_DecCopperListsPrimary

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_BRUSH_SelectBrushSlot   (Routine at ESQIFF_JMPTBL_BRUSH_SelectBrushSlot)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   BRUSH_SelectBrushSlot
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_BRUSH_SelectBrushSlot:
    JMP     BRUSH_SelectBrushSlot

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_BRUSH_SelectBrushByLabel   (Routine at ESQIFF_JMPTBL_BRUSH_SelectBrushByLabel)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   BRUSH_SelectBrushByLabel
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_BRUSH_SelectBrushByLabel:
    JMP     BRUSH_SelectBrushByLabel

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_MATH_Mulu32   (Routine at ESQIFF_JMPTBL_MATH_Mulu32)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   MATH_Mulu32
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_MATH_Mulu32:
    JMP     MATH_Mulu32

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_DISKIO_ResetCtrlInputStateIfIdle   (Routine at ESQIFF_JMPTBL_DISKIO_ResetCtrlInputStateIfIdle)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   DISKIO_ResetCtrlInputStateIfIdle
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_DISKIO_ResetCtrlInputStateIfIdle:
    JMP     DISKIO_ResetCtrlInputStateIfIdle
