;!======

; weather status rendering/control
;------------------------------------------------------------------------------
; FUNC: WDISP_DrawWeatherStatusOverlay   (DrawWeatherStatusOverlay)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
;   stack +136: arg_4 (via 140(A5))
;   stack +144: arg_5 (via 148(A5))
;   stack +148: arg_6 (via 152(A5))
;   stack +152: arg_7 (via 156(A5))
;   stack +156: arg_8 (via 160(A5))
;   stack +160: arg_9 (via 164(A5))
;   stack +164: arg_10 (via 168(A5))
;   stack +168: arg_11 (via 172(A5))
;   stack +172: arg_12 (via 176(A5))
;   stack +176: arg_13 (via 180(A5))
;   stack +180: arg_14 (via 184(A5))
;   stack +184: arg_15 (via 188(A5))
;   stack +188: arg_16 (via 192(A5))
;   stack +192: arg_17 (via 196(A5))
;   stack +196: arg_18 (via 200(A5))
;   stack +200: arg_19 (via 204(A5))
;   stack +204: arg_20 (via 208(A5))
;   stack +208: arg_21 (via 212(A5))
;   stack +212: arg_22 (via 216(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A5/A6/A7/D0/D1/D2/D3/D5/D6/D7
; CALLS:
;   MATH_DivS32, MATH_Mulu32, MEMORY_DeallocateMemory, UNKNOWN_JMPTBL_ESQPARS_ReplaceOwnedString, WDISP_JMPTBL_BRUSH_FindBrushByPredicate, WDISP_JMPTBL_BRUSH_PlaneMaskForIndex, WDISP_JMPTBL_BRUSH_SelectBrushSlot, WDISP_JMPTBL_ESQFUNC_TrimTextToPixelWidthWordBoundary, _LVOCopyMem, _LVOMove, _LVOSetAPen, _LVOSetDrMd, _LVOSetFont, _LVOSetRast, _LVOText, _LVOTextLength
; READS:
;   AbsExecBase, GLOB_HANDLE_PREVUEC_FONT, GLOB_REF_GRAPHICS_LIBRARY, GLOB_STR_PTR_NO_CURRENT_WEATHER_DATA_AVIALABLE, GLOB_STR_WDISP_C, LAB_186B, LAB_1874, LAB_187B, LAB_187C, WDISP_WeatherStatusTextPtr, WDISP_WeatherStatusOverlayTextPtr, ESQFUNC_PwBrushListHead, DATA_ESQFUNC_STR_I5_1EDD, DATA_ESQFUNC_CONST_LONG_1EDF, DATA_P_TYPE_BSS_LONG_205A, WDISP_WeatherStatusCountdown, WDISP_PaletteTriplesRBase, WDISP_WeatherStatusBrushIndex, WDISP_WeatherStatusDigitChar, DATA_WDISP_BSS_WORD_22AF, a, aa, e8, return
; WRITES:
;   WDISP_AccumulatorCaptureActive, WDISP_AccumulatorFlushPending
; DESC:
;   Draws the weather-status overlay text/brush composition into the target
;   RastPort, including centered fallback text when no status brush is active.
; NOTES:
;   Uses delimiter 24 to split overlay text into up to two centered lines.
;------------------------------------------------------------------------------
WDISP_DrawWeatherStatusOverlay:
    LINK.W  A5,#-228
    MOVEM.L D2-D3/D5-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  16(A5),D6
    CLR.L   -8(A5)
    MOVEQ   #0,D0
    MOVE.B  WDISP_WeatherStatusCountdown,D1
    MOVE.L  D0,-156(A5)
    MOVE.L  D0,-152(A5)
    MOVEQ   #0,D0
    CMP.B   D0,D1
    BLS.W   .LAB_187C

    MOVE.W  WDISP_WeatherStatusDigitChar,D0
    MOVEQ   #48,D1
    CMP.W   D1,D0
    BEQ.W   .LAB_187C

    MOVE.B  WDISP_WeatherStatusBrushIndex,D0
    SUBQ.B  #1,D0
    BNE.S   .LAB_185D

    PEA     ESQFUNC_PwBrushListHead
    MOVE.L  DATA_ESQFUNC_CONST_LONG_1EDF,-(A7)
    JSR     WDISP_JMPTBL_BRUSH_FindBrushByPredicate(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    BRA.S   .LAB_185E

.LAB_185D:
    MOVEQ   #0,D0
    MOVE.B  WDISP_WeatherStatusBrushIndex,D0
    ASL.L   #2,D0
    LEA     DATA_ESQFUNC_STR_I5_1EDD,A0
    ADDA.L  D0,A0
    PEA     ESQFUNC_PwBrushListHead
    MOVE.L  (A0),-(A7)
    JSR     WDISP_JMPTBL_BRUSH_FindBrushByPredicate(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)

.LAB_185E:
    TST.L   D0
    BEQ.S   .LAB_185F

    MOVEQ   #0,D1
    MOVEA.L D0,A0
    MOVE.W  178(A0),D1
    MOVEQ   #0,D0
    MOVE.W  176(A0),D0
    MOVE.L  D0,-216(A5)
    MOVE.L  D1,-212(A5)
    BRA.S   .LAB_1860

.LAB_185F:
    MOVEQ   #90,D0
    MOVE.L  D0,-212(A5)
    MOVE.L  #$aa,-216(A5)

.LAB_1860:
    MOVE.L  -8(A5),-(A7)
    MOVE.L  WDISP_WeatherStatusOverlayTextPtr,-(A7)
    JSR     UNKNOWN_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVEA.L D0,A0

.LAB_1861:
    TST.B   (A0)+
    BNE.S   .LAB_1861

    SUBQ.L  #1,A0
    SUBA.L  D0,A0
    MOVE.L  A0,D1
    ADDQ.L  #1,D1
    MOVE.L  D0,-12(A5)
    MOVE.L  D0,-8(A5)
    MOVE.L  D1,-160(A5)

.LAB_1862:
    MOVEA.L -12(A5),A0
    TST.B   (A0)
    BEQ.S   .LAB_1864

    MOVEQ   #24,D0
    CMP.B   (A0),D0
    BNE.S   .LAB_1863

    CLR.B   (A0)
    ADDQ.L  #1,-152(A5)

.LAB_1863:
    ADDQ.L  #1,-12(A5)
    BRA.S   .LAB_1862

.LAB_1864:
    MOVEA.L -8(A5),A0
    MOVE.L  A0,-12(A5)
    TST.B   (A0)
    BNE.S   .LAB_1865

    ADDQ.L  #1,-12(A5)
    SUBQ.L  #1,-152(A5)

.LAB_1865:
    CMPI.L  #$a,-152(A5)
    BLE.S   .LAB_1866

    MOVEQ   #10,D0
    MOVE.L  D0,-152(A5)

.LAB_1866:
    MOVEA.L A3,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L A3,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L A3,A1
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    JSR     _LVOSetFont(A6)

    MOVEQ   #0,D0
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    MOVE.W  26(A0),D0
    MOVE.L  D6,D1
    SUB.L   D0,D1
    SUB.L   -212(A5),D1
    SUBQ.L  #5,D1
    MOVE.B  WDISP_WeatherStatusBrushIndex,D0
    MOVE.L  D1,-196(A5)
    SUBQ.B  #1,D0
    BEQ.W   .LAB_186B

    TST.L   -4(A5)
    BEQ.W   .LAB_186B

    MOVEQ   #1,D0
    MOVEA.L -4(A5),A0
    MOVE.L  D0,356(A0)
    MOVE.L  D0,360(A0)
    PEA     5.W
    JSR     WDISP_JMPTBL_BRUSH_PlaneMaskForIndex(PC)

    MOVE.L  D0,D1
    LSL.L   #2,D1
    SUB.L   D0,D1
    MOVEQ   #0,D0
    MOVEA.L -4(A5),A0
    MOVE.B  184(A0),D0
    MOVE.L  D0,(A7)
    MOVE.L  D1,-184(A5)
    JSR     WDISP_JMPTBL_BRUSH_PlaneMaskForIndex(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D1
    LSL.L   #2,D1
    SUB.L   D0,D1
    CLR.L   -192(A5)
    MOVE.L  D1,-188(A5)

.LAB_1867:
    MOVE.L  -192(A5),D0
    CMP.L   -188(A5),D0
    BGE.S   .LAB_1868

    CMP.L   -184(A5),D0
    BGE.S   .LAB_1868

    LEA     WDISP_PaletteTriplesRBase,A0
    ADDA.L  D0,A0
    MOVEA.L -4(A5),A1
    MOVE.L  D0,D0
    ADDI.L  #$e8,D0
    MOVE.B  0(A1,D0.L),(A0)
    ADDQ.L  #1,-192(A5)
    BRA.S   .LAB_1867

.LAB_1868:
    MOVE.W  #1,WDISP_AccumulatorCaptureActive
    CLR.W   WDISP_AccumulatorFlushPending
    CLR.L   -192(A5)

.LAB_1869:
    MOVE.L  -192(A5),D0
    MOVEQ   #4,D1
    CMP.L   D1,D0
    BGE.S   .LAB_186A

    ASL.L   #3,D0
    MOVEA.L -4(A5),A0
    ADDA.L  D0,A0
    LEA     200(A0),A1
    LEA     DATA_WDISP_BSS_WORD_22AF,A0
    ADDA.L  D0,A0
    MOVE.L  A0,32(A7)
    MOVEA.L A1,A0
    MOVEA.L 32(A7),A1
    MOVEQ   #8,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCopyMem(A6)

    ADDQ.L  #1,-192(A5)
    BRA.S   .LAB_1869

.LAB_186A:
    CLR.W   WDISP_AccumulatorCaptureActive
    MOVE.W  #1,WDISP_AccumulatorFlushPending
    MOVE.L  -196(A5),D0
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  D0,-148(A5)
    JSR     WDISP_JMPTBL_BRUSH_SelectBrushSlot(PC)

    LEA     28(A7),A7

.LAB_186B:
    TST.L   WDISP_WeatherStatusTextPtr
    BEQ.S   .LAB_186D

    MOVEA.L WDISP_WeatherStatusTextPtr,A0
    TST.B   (A0)
    BEQ.S   .LAB_186D

    LEA     -140(A5),A1

.LAB_186C:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .LAB_186C

    BRA.S   .LAB_186E

.LAB_186D:
    CLR.B   -140(A5)

.LAB_186E:
    LEA     -140(A5),A0
    MOVEA.L A0,A1

.LAB_186F:
    TST.B   (A1)+
    BNE.S   .LAB_186F

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,-204(A5)
    BLE.S   .LAB_1871

    MOVEA.L A3,A1
    MOVE.L  -204(A5),D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D7,D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .LAB_1870

    ADDQ.L  #1,D1

.LAB_1870:
    ASR.L   #1,D1
    MOVE.L  D1,D5
    MOVEQ   #0,D0
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    MOVE.W  20(A0),D0
    MOVE.L  D6,D1
    SUB.L   D0,D1
    SUB.L   -212(A5),D1
    SUBQ.L  #5,D1
    MOVE.L  D1,-148(A5)
    MOVEA.L A3,A1
    MOVEQ   #3,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L A3,A1
    MOVE.L  D5,D0
    MOVE.L  -148(A5),D1
    JSR     _LVOMove(A6)

    MOVEA.L A3,A1
    LEA     -140(A5),A0
    MOVE.L  -204(A5),D0
    JSR     _LVOText(A6)

.LAB_1871:
    MOVEQ   #0,D0
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    MOVE.W  20(A0),D0
    MOVE.L  -152(A5),D1
    ADDQ.L  #1,D1
    TST.L   D1
    BPL.S   .LAB_1872

    ADDQ.L  #1,D1

.LAB_1872:
    ASR.L   #1,D1
    MOVE.L  D1,D2
    ADDQ.L  #1,D2
    MOVEQ   #0,D3
    MOVE.W  26(A0),D3
    ADD.L   -212(A5),D3
    MOVE.L  D0,-180(A5)
    MOVE.L  D1,-164(A5)
    JSR     MATH_Mulu32(PC)

    SUB.L   D0,D3
    ADDQ.L  #5,D3
    MOVE.L  D3,D0
    MOVE.L  D2,D1
    MOVE.L  D0,-172(A5)
    MOVE.L  D1,-168(A5)
    JSR     MATH_DivS32(PC)

    MOVE.L  D7,D1
    SUB.L   -216(A5),D1
    TST.L   D1
    BPL.S   .LAB_1873

    ADDQ.L  #1,D1

.LAB_1873:
    ASR.L   #1,D1
    MOVE.L  D0,-176(A5)
    MOVE.L  D1,-200(A5)
    MOVEA.L A3,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

.LAB_1874:
    MOVE.L  -156(A5),D0
    CMP.L   -152(A5),D0
    BGE.W   .LAB_187B

    TST.L   D0
    BPL.S   .LAB_1875

    ADDQ.L  #1,D0

.LAB_1875:
    ASR.L   #1,D0
    MOVE.L  -176(A5),D1
    MOVE.L  -180(A5),D2
    ADD.L   D1,D2
    MOVE.L  D2,D1
    JSR     MATH_Mulu32(PC)

    MOVE.L  -196(A5),D1
    ADD.L   D0,D1
    ADD.L   -176(A5),D1
    MOVEQ   #0,D0
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    MOVE.W  26(A0),D0
    ADD.L   D0,D1
    MOVEQ   #0,D2
    MOVE.W  20(A0),D2
    MOVE.L  D1,-148(A5)
    ADD.L   D2,D1
    MOVEQ   #0,D2
    MOVE.W  D0,D2
    SUB.L   D2,D1
    CMP.L   D6,D1
    BGE.W   .LAB_187B

    MOVE.L  -12(A5),-(A7)
    MOVE.L  -200(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     WDISP_JMPTBL_ESQFUNC_TrimTextToPixelWidthWordBoundary(PC)

    LEA     12(A7),A7
    MOVE.L  D0,-204(A5)
    MOVEA.L A3,A1
    MOVEA.L -12(A5),A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  -200(A5),D1
    SUB.L   D0,D1
    SUBQ.L  #1,D1
    TST.L   D1
    BPL.S   .LAB_1876

    ADDQ.L  #1,D1

.LAB_1876:
    ASR.L   #1,D1
    MOVE.L  D1,D5
    MOVE.L  D0,-208(A5)
    MOVEA.L A3,A1
    MOVE.L  D5,D0
    MOVE.L  -148(A5),D1
    JSR     _LVOMove(A6)

    MOVEA.L A3,A1
    MOVEA.L -12(A5),A0
    MOVE.L  -204(A5),D0
    JSR     _LVOText(A6)

    ADDQ.L  #1,-156(A5)
    MOVE.L  -156(A5),D0
    CMP.L   -152(A5),D0
    BGE.S   .LAB_1879

    MOVEA.L -12(A5),A0

.LAB_1877:
    TST.B   (A0)+
    BNE.S   .LAB_1877

    SUBQ.L  #1,A0
    SUBA.L  -12(A5),A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    ADD.L   D0,-12(A5)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  -200(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     WDISP_JMPTBL_ESQFUNC_TrimTextToPixelWidthWordBoundary(PC)

    LEA     12(A7),A7
    MOVE.L  D0,-204(A5)
    MOVEA.L A3,A1
    MOVEA.L -12(A5),A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  -200(A5),D1
    ADD.L   D0,D1
    TST.L   D1
    BPL.S   .LAB_1878

    ADDQ.L  #1,D1

.LAB_1878:
    ASR.L   #1,D1
    MOVE.L  D7,D2
    SUB.L   D1,D2
    MOVE.L  D2,D5
    SUBQ.L  #1,D5
    MOVE.L  D0,-208(A5)
    MOVEA.L A3,A1
    MOVE.L  D5,D0
    MOVE.L  -148(A5),D1
    JSR     _LVOMove(A6)

    MOVEA.L A3,A1
    MOVEA.L -12(A5),A0
    MOVE.L  -204(A5),D0
    JSR     _LVOText(A6)

    ADDQ.L  #1,-156(A5)

.LAB_1879:
    MOVEA.L -12(A5),A0

.LAB_187A:
    TST.B   (A0)+
    BNE.S   .LAB_187A

    SUBQ.L  #1,A0
    SUBA.L  -12(A5),A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    ADD.L   D0,-12(A5)
    BRA.W   .LAB_1874

.LAB_187B:
    MOVE.L  -160(A5),-(A7)
    MOVE.L  -8(A5),-(A7)
    PEA     301.W
    PEA     GLOB_STR_WDISP_C
    JSR     MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    BRA.W   .return

.LAB_187C:
    TST.L   DATA_P_TYPE_BSS_LONG_205A
    BEQ.S   .LAB_187D

    MOVE.L  DATA_P_TYPE_BSS_LONG_205A,-12(A5)
    BRA.S   .LAB_187E

.LAB_187D:
    MOVEA.L GLOB_STR_PTR_NO_CURRENT_WEATHER_DATA_AVIALABLE,A0
    MOVE.L  A0,-12(A5)

.LAB_187E:
    MOVEA.L -12(A5),A0

.LAB_187F:
    TST.B   (A0)+
    BNE.S   .LAB_187F

    SUBQ.L  #1,A0
    SUBA.L  -12(A5),A0
    MOVE.L  A0,-204(A5)
    MOVEA.L A3,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L A3,A1
    MOVEA.L -12(A5),A0
    MOVE.L  -204(A5),D0
    JSR     _LVOTextLength(A6)

    MOVE.L  D7,D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .LAB_1880

    ADDQ.L  #1,D1

.LAB_1880:
    ASR.L   #1,D1
    MOVEQ   #0,D0
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    MOVE.W  20(A0),D0
    MOVE.L  D6,D2
    SUB.L   D0,D2
    TST.L   D2
    BPL.S   .LAB_1881

    ADDQ.L  #1,D2

.LAB_1881:
    ASR.L   #1,D2
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    ADD.L   D0,D2
    MOVEA.L A3,A1
    MOVE.L  D1,D0
    MOVE.L  D2,D1
    JSR     _LVOMove(A6)

    MOVEA.L A3,A1
    MOVEA.L -12(A5),A0
    MOVE.L  -204(A5),D0
    JSR     _LVOText(A6)

.return:
    MOVEM.L (A7)+,D2-D3/D5-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: WDISP_DrawWeatherStatusDayEntry   (DrawWeatherStatusDayEntry)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
;   stack +16: arg_4 (via 20(A5))
;   stack +22: arg_5 (via 26(A5))
;   stack +42: arg_6 (via 46(A5))
;   stack +46: arg_7 (via 50(A5))
;   stack +50: arg_8 (via 54(A5))
;   stack +54: arg_9 (via 58(A5))
;   stack +55: arg_10 (via 59(A5))
;   stack +60: arg_11 (via 64(A5))
;   stack +64: arg_12 (via 68(A5))
;   stack +68: arg_13 (via 72(A5))
;   stack +72: arg_14 (via 76(A5))
;   stack +76: arg_15 (via 80(A5))
;   stack +80: arg_16 (via 84(A5))
;   stack +84: arg_17 (via 88(A5))
;   stack +88: arg_18 (via 92(A5))
;   stack +92: arg_19 (via 96(A5))
;   stack +96: arg_20 (via 100(A5))
;   stack +100: arg_21 (via 104(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0/D1/D2/D3/D4/D5/D6/D7
; CALLS:
;   MATH_DivS32, MATH_Mulu32, STRING_AppendAtNull, WDISP_JMPTBL_BRUSH_FindBrushByPredicate, WDISP_JMPTBL_BRUSH_PlaneMaskForIndex, WDISP_JMPTBL_BRUSH_SelectBrushSlot, WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples, WDISP_JMPTBL_NEWGRID_DrawWrappedText, WDISP_SPrintf, _LVOCopyMem, _LVOMove, _LVOSetAPen, _LVOSetDrMd, _LVOText, _LVOTextLength
; READS:
;   AbsExecBase, GLOB_HANDLE_PREVUEC_FONT, GLOB_JMPTBL_DAYS_OF_WEEK, GLOB_REF_GRAPHICS_LIBRARY, GLOB_STR_PERCENT_D, GLOB_STR_PERCENT_D_SLASH, LAB_188D, LAB_1895, LAB_1896, LAB_189B, LAB_189E, LAB_189F, ESQFUNC_PwBrushListHead, DATA_ESQFUNC_STR_I5_1EDD, DATA_P_TYPE_BSS_LONG_205B, WDISP_StatusDayEntry0, WDISP_STR_UNKNOWN_NUM_WITH_SLASH, WDISP_STR_UNKNOWN_NUM, WDISP_CharClassTable, CLOCK_CurrentDayOfWeekIndex, WDISP_PaletteTriplesRBase, DATA_WDISP_BSS_WORD_22AF, e8, fffffc19, return
; WRITES:
;   WDISP_AccumulatorCaptureActive, WDISP_AccumulatorFlushPending
; DESC:
;   Renders one day-entry panel for the weather status display.
; NOTES:
;   Accepts day-slot index D7 in range 0..3; out-of-range returns immediately.
;------------------------------------------------------------------------------
WDISP_DrawWeatherStatusDayEntry:
    LINK.W  A5,#-116
    MOVEM.L D2-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  16(A5),D6
    MOVE.L  20(A5),D5

    MOVEQ   #0,D0
    MOVEQ   #1,D1
    CLR.L   -104(A5)
    MOVE.L  D0,-68(A5)
    MOVE.L  D0,-64(A5)
    MOVE.L  D1,-100(A5)
    TST.L   D7
    BMI.W   .return

    MOVEQ   #4,D2
    CMP.L   D2,D7
    BGE.W   .return

    MOVE.L  D6,D0
    MOVEQ   #3,D1
    JSR     MATH_DivS32(PC)

    MOVE.L  D7,D1
    MOVE.L  D0,-4(A5)
    JSR     MATH_Mulu32(PC)

    MOVE.L  D0,-8(A5)
    MOVE.L  D7,D0
    MOVEQ   #20,D1
    JSR     MATH_Mulu32(PC)

    LEA     WDISP_StatusDayEntry0,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  4(A1),D1
    ADDA.L  D0,A0
    MOVEM.L D1,-88(A5)
    MOVEQ   #1,D0
    CMP.L   16(A0),D0
    BEQ.S   .LAB_1884

    MOVEQ   #2,D0
    CMP.L   D0,D1
    BLT.S   .LAB_1884

    MOVEQ   #6,D3
    CMP.L   D3,D1
    BLE.S   .LAB_1885

.LAB_1884:
    MOVEQ   #2,D0
    CLR.L   -100(A5)
    MOVE.L  D0,-88(A5)

.LAB_1885:
    MOVE.L  -88(A5),D0
    ASL.L   #2,D0
    LEA     DATA_ESQFUNC_STR_I5_1EDD,A0
    ADDA.L  D0,A0
    PEA     ESQFUNC_PwBrushListHead
    MOVE.L  (A0),-(A7)
    JSR     WDISP_JMPTBL_BRUSH_FindBrushByPredicate(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-104(A5)
    TST.L   D0
    BEQ.S   .LAB_1886

    MOVEQ   #0,D1
    MOVEA.L D0,A0
    MOVE.W  178(A0),D1
    MOVEQ   #0,D2
    MOVE.W  176(A0),D2
    MOVE.L  D1,-12(A5)
    MOVE.L  D2,-16(A5)
    BRA.S   .LAB_1887

.LAB_1886:
    MOVEQ   #90,D1
    MOVE.L  D1,-12(A5)
    MOVEQ   #0,D1
    MOVE.L  D1,-100(A5)
    MOVE.L  D1,-16(A5)

.LAB_1887:
    MOVE.L  D7,D0
    MOVEQ   #20,D1
    JSR     MATH_Mulu32(PC)

    LEA     WDISP_StatusDayEntry0,A0
    ADDA.L  D0,A0
    TST.L   16(A0)
    BNE.W   .LAB_1895

    MOVE.W  #1,WDISP_AccumulatorCaptureActive
    CLR.W   WDISP_AccumulatorFlushPending
    TST.L   -100(A5)
    BEQ.W   .LAB_188D

    PEA     5.W
    JSR     WDISP_JMPTBL_BRUSH_PlaneMaskForIndex(PC)

    MOVE.L  D0,D1
    LSL.L   #2,D1
    SUB.L   D0,D1
    MOVEQ   #0,D0
    MOVEA.L -104(A5),A0
    MOVE.B  184(A0),D0
    MOVE.L  D0,(A7)
    MOVE.L  D1,-76(A5)
    JSR     WDISP_JMPTBL_BRUSH_PlaneMaskForIndex(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D1
    LSL.L   #2,D1
    SUB.L   D0,D1
    CLR.L   -84(A5)
    MOVE.L  D1,-80(A5)

.LAB_1888:
    MOVE.L  -84(A5),D0
    CMP.L   -80(A5),D0
    BGE.S   .LAB_1889

    CMP.L   -76(A5),D0
    BGE.S   .LAB_1889

    LEA     WDISP_PaletteTriplesRBase,A0
    ADDA.L  D0,A0
    MOVEA.L -104(A5),A1
    MOVE.L  D0,D0
    ADDI.L  #$e8,D0
    MOVE.B  0(A1,D0.L),(A0)
    ADDQ.L  #1,-84(A5)
    BRA.S   .LAB_1888

.LAB_1889:
    CLR.L   -84(A5)

.LAB_188A:
    MOVE.L  -84(A5),D0
    MOVEQ   #4,D1
    CMP.L   D1,D0
    BGE.S   .LAB_188B

    ASL.L   #3,D0
    MOVEA.L -104(A5),A0
    ADDA.L  D0,A0
    LEA     200(A0),A1
    LEA     DATA_WDISP_BSS_WORD_22AF,A0
    ADDA.L  D0,A0
    MOVE.L  A0,40(A7)
    MOVEA.L A1,A0
    MOVEA.L 40(A7),A1
    MOVEQ   #8,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCopyMem(A6)

    ADDQ.L  #1,-84(A5)
    BRA.S   .LAB_188A

.LAB_188B:
    CLR.W   WDISP_AccumulatorCaptureActive
    MOVE.W  #1,WDISP_AccumulatorFlushPending
    MOVE.L  -16(A5),D0
    MOVE.L  -4(A5),D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .LAB_188C

    ADDQ.L  #1,D1

.LAB_188C:
    ASR.L   #1,D1
    MOVE.L  -8(A5),D2
    ADD.L   D1,D2
    MOVE.L  D5,D1
    MOVE.L  -12(A5),D3
    SUB.L   D3,D1
    MOVEQ   #0,D4
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    MOVE.W  26(A0),D4
    SUB.L   D4,D1
    SUBQ.L  #5,D1
    ADD.L   D2,D0
    ADD.L   D1,D3
    CLR.L   -(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  -104(A5),-(A7)
    MOVE.L  D1,-96(A5)
    MOVE.L  D2,-92(A5)
    JSR     WDISP_JMPTBL_BRUSH_SelectBrushSlot(PC)

    LEA     28(A7),A7
    BRA.S   .LAB_188E

.LAB_188D:
    JSR     WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples(PC)

.LAB_188E:
    MOVE.L  D7,D0
    MOVEQ   #20,D1
    JSR     MATH_Mulu32(PC)

    LEA     WDISP_StatusDayEntry0,A0
    ADDA.L  D0,A0
    CMPI.L  #$fffffc19,8(A0)
    BNE.S   .LAB_188F

    LEA     WDISP_STR_UNKNOWN_NUM_WITH_SLASH,A0
    LEA     -46(A5),A1
    MOVE.L  (A0)+,(A1)+
    CLR.B   (A1)
    BRA.S   .LAB_1890

.LAB_188F:
    MOVE.L  D7,D0
    MOVEQ   #20,D1
    JSR     MATH_Mulu32(PC)

    LEA     WDISP_StatusDayEntry0,A0
    ADDA.L  D0,A0
    MOVE.L  8(A0),-(A7)
    PEA     GLOB_STR_PERCENT_D_SLASH
    PEA     -46(A5)
    JSR     WDISP_SPrintf(PC)

    LEA     12(A7),A7

.LAB_1890:
    MOVE.L  D7,D0
    MOVEQ   #20,D1
    JSR     MATH_Mulu32(PC)

    LEA     WDISP_StatusDayEntry0,A0
    ADDA.L  D0,A0
    CMPI.L  #$fffffc19,12(A0)   ; -999
    BNE.S   .LAB_1891

    LEA     WDISP_STR_UNKNOWN_NUM,A0
    LEA     -26(A5),A1
    MOVE.L  (A0)+,(A1)+
    BRA.S   .LAB_1892

.LAB_1891:
    MOVE.L  D7,D0
    MOVEQ   #20,D1
    JSR     MATH_Mulu32(PC)

    LEA     WDISP_StatusDayEntry0,A0
    ADDA.L  D0,A0
    MOVE.L  12(A0),-(A7)
    PEA     GLOB_STR_PERCENT_D
    PEA     -26(A5)
    JSR     WDISP_SPrintf(PC)

    LEA     12(A7),A7

.LAB_1892:
    PEA     -26(A5)
    PEA     -46(A5)
    JSR     STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7
    MOVEA.L A3,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    LEA     -46(A5),A0
    MOVEA.L A0,A1

.LAB_1893:
    TST.B   (A1)+
    BNE.S   .LAB_1893

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,-50(A5)
    MOVEA.L A3,A1
    MOVE.L  -50(A5),D0
    JSR     _LVOTextLength(A6)

    MOVE.L  -4(A5),D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .LAB_1894

    ADDQ.L  #1,D1

.LAB_1894:
    ASR.L   #1,D1
    MOVE.L  -8(A5),D0
    ADD.L   D1,D0
    MOVE.L  D5,D1
    SUBQ.L  #5,D1
    MOVE.L  D0,-92(A5)
    MOVE.L  D1,-96(A5)
    MOVEA.L A3,A1
    JSR     _LVOMove(A6)

    MOVEA.L A3,A1
    LEA     -46(A5),A0
    MOVE.L  -50(A5),D0
    JSR     _LVOText(A6)

    BRA.W   .LAB_189F

.LAB_1895:
    MOVE.L  DATA_P_TYPE_BSS_LONG_205B,-54(A5)
    MOVEQ   #20,D0
    SUB.L   D0,-4(A5)
    CLR.L   -68(A5)
    MOVE.L  #$8c,-64(A5)
    MOVEA.L A3,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

.LAB_1896:
    TST.L   -54(A5)
    BEQ.W   .LAB_189E

    CMPI.L  #$4,-68(A5)
    BGE.W   .LAB_189E

.LAB_1897:
    MOVEA.L -54(A5),A0
    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     WDISP_CharClassTable,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .LAB_1898

    ADDQ.L  #1,-54(A5)
    BRA.S   .LAB_1897

.LAB_1898:
    CLR.L   -(A7)
    MOVE.L  -54(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  -64(A5),-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     WDISP_JMPTBL_NEWGRID_DrawWrappedText(PC)

    LEA     24(A7),A7
    MOVE.L  D0,-58(A5)
    TST.L   D0
    BEQ.W   .LAB_189B

    MOVEA.L D0,A0
    MOVE.B  (A0),-59(A5)
    CLR.B   (A0)
    MOVEA.L -54(A5),A0

.LAB_1899:
    TST.B   (A0)+
    BNE.S   .LAB_1899

    SUBQ.L  #1,A0
    SUBA.L  -54(A5),A0
    MOVEA.L D0,A1
    MOVE.B  -59(A5),(A1)
    MOVE.L  A0,-72(A5)
    MOVEA.L A3,A1
    MOVE.L  A0,D0
    MOVEA.L -54(A5),A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  -4(A5),D1
    MOVE.L  D1,D2
    SUB.L   D0,D2
    MOVEQ   #20,D0
    ADD.L   D0,D2
    TST.L   D2
    BPL.S   .LAB_189A

    ADDQ.L  #1,D2

.LAB_189A:
    ASR.L   #1,D2
    MOVE.L  -8(A5),D0
    ADD.L   D2,D0
    PEA     1.W
    MOVE.L  -54(A5),-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  -64(A5),-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  D0,-92(A5)
    JSR     WDISP_JMPTBL_NEWGRID_DrawWrappedText(PC)

    LEA     24(A7),A7
    MOVEQ   #0,D1
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    MOVE.W  20(A0),D1
    ADDQ.L  #4,D1
    ADD.L   D1,-64(A5)
    ADDQ.L  #1,-68(A5)
    MOVE.L  D0,-54(A5)
    BRA.W   .LAB_1896

.LAB_189B:
    MOVEA.L -54(A5),A0

.LAB_189C:
    TST.B   (A0)+
    BNE.S   .LAB_189C

    SUBQ.L  #1,A0
    SUBA.L  -54(A5),A0
    MOVEA.L A3,A1
    MOVE.L  A0,D0
    MOVEA.L -54(A5),A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  -4(A5),D1
    MOVE.L  D1,D2
    SUB.L   D0,D2
    MOVEQ   #20,D0
    ADD.L   D0,D2
    TST.L   D2
    BPL.S   .LAB_189D

    ADDQ.L  #1,D2

.LAB_189D:
    ASR.L   #1,D2
    MOVE.L  -8(A5),D0
    ADD.L   D2,D0
    PEA     1.W
    MOVE.L  -54(A5),-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  -64(A5),-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  D0,-92(A5)
    JSR     WDISP_JMPTBL_NEWGRID_DrawWrappedText(PC)

    LEA     24(A7),A7
    MOVE.L  D0,-54(A5)
    BRA.W   .LAB_1896

.LAB_189E:
    MOVEQ   #20,D0
    ADD.L   D0,-4(A5)

.LAB_189F:
    MOVE.W  CLOCK_CurrentDayOfWeekIndex,D0
    EXT.L   D0
    ADD.L   D7,D0
    ADDQ.L  #1,D0
    MOVEQ   #7,D1
    JSR     MATH_DivS32(PC)

    ASL.L   #2,D1
    LEA     GLOB_JMPTBL_DAYS_OF_WEEK,A0
    ADDA.L  D1,A0
    MOVEA.L (A0),A1
    LEA     -46(A5),A2

.LAB_18A0:
    MOVE.B  (A1)+,(A2)+
    BNE.S   .LAB_18A0

    LEA     -46(A5),A0
    MOVEA.L A0,A1

.LAB_18A1:
    TST.B   (A1)+
    BNE.S   .LAB_18A1

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,-50(A5)
    MOVEA.L A3,A1
    MOVE.L  -50(A5),D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  -4(A5),D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .LAB_18A2

    ADDQ.L  #1,D1

.LAB_18A2:
    ASR.L   #1,D1
    MOVE.L  -8(A5),D0
    ADD.L   D1,D0
    MOVE.L  D5,D1
    SUB.L   -12(A5),D1
    MOVEQ   #0,D2
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    MOVE.W  20(A0),D2
    SUB.L   D2,D1
    SUBQ.L  #5,D1
    MOVE.L  D0,-92(A5)
    MOVE.L  D1,-96(A5)
    MOVEA.L A3,A1
    MOVEQ   #3,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L A3,A1
    MOVE.L  -92(A5),D0
    MOVE.L  -96(A5),D1
    JSR     _LVOMove(A6)

    MOVEA.L A3,A1
    LEA     -46(A5),A0
    MOVE.L  -50(A5),D0
    JSR     _LVOText(A6)

.return:
    MOVEM.L (A7)+,D2-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: WDISP_DrawWeatherStatusSummary   (DrawWeatherStatusSummary)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A5/A6/A7/D0/D1/D2/D4/D5/D6/D7
; CALLS:
;   WDISP_DrawWeatherStatusDayEntry, _LVOMove, _LVOSetRast, _LVOText, _LVOTextLength
; READS:
;   GLOB_HANDLE_PREVUEC_FONT, GLOB_REF_GRAPHICS_LIBRARY, DATA_P_TYPE_BSS_LONG_205B, DATA_SCRIPT_CONST_LONG_20B0, DATA_TLIBA1_BSS_WORD_2196, WDISP_WeatherStatusDigitChar, return
; WRITES:
;   (none observed)
; DESC:
;   Clears the status area and draws either day-entry panels or centered
;   fallback summary text.
; NOTES:
;   Day-entry mode is enabled only when DATA_TLIBA1_BSS_WORD_2196 > 0 and the
;   weather digit char is not '0'.
;------------------------------------------------------------------------------
WDISP_DrawWeatherStatusSummary:
    LINK.W  A5,#-12
    MOVEM.L D2/D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  16(A5),D6

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    MOVE.B  DATA_TLIBA1_BSS_WORD_2196,D0
    MOVEQ   #0,D1
    CMP.B   D1,D0
    BLS.S   .LAB_18A6

    MOVE.W  WDISP_WeatherStatusDigitChar,D0
    MOVEQ   #48,D1
    CMP.W   D1,D0
    BEQ.S   .LAB_18A6

    MOVEQ   #0,D4

.LAB_18A5:
    MOVEQ   #3,D0
    CMP.L   D0,D4
    BGE.W   .return

    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   WDISP_DrawWeatherStatusDayEntry

    LEA     16(A7),A7
    ADDQ.L  #1,D4
    BRA.S   .LAB_18A5

.LAB_18A6:
    TST.L   DATA_P_TYPE_BSS_LONG_205B
    BEQ.S   .LAB_18A7

    MOVE.L  DATA_P_TYPE_BSS_LONG_205B,-4(A5)
    BRA.S   .LAB_18A8

.LAB_18A7:
    MOVEA.L DATA_SCRIPT_CONST_LONG_20B0,A0
    MOVE.L  A0,-4(A5)

.LAB_18A8:
    MOVEA.L -4(A5),A0

.LAB_18A9:
    TST.B   (A0)+
    BNE.S   .LAB_18A9

    SUBQ.L  #1,A0
    SUBA.L  -4(A5),A0
    MOVE.L  A0,D5
    MOVEA.L A3,A1
    MOVE.L  D5,D0
    MOVEA.L -4(A5),A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D7,D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .LAB_18AA

    ADDQ.L  #1,D1

.LAB_18AA:
    ASR.L   #1,D1
    MOVEQ   #0,D0
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    MOVE.W  20(A0),D0
    MOVE.L  D6,D2
    SUB.L   D0,D2
    TST.L   D2
    BPL.S   .LAB_18AB

    ADDQ.L  #1,D2

.LAB_18AB:
    ASR.L   #1,D2
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    ADD.L   D0,D2
    MOVEA.L A3,A1
    MOVE.L  D1,D0
    MOVE.L  D2,D1
    JSR     _LVOMove(A6)

    MOVEA.L A3,A1
    MOVE.L  D5,D0
    MOVEA.L -4(A5),A0
    JSR     _LVOText(A6)

.return:
    MOVEM.L (A7)+,D2/D4-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: WDISP_HandleWeatherStatusCommand   (HandleWeatherStatusCommand)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +12: arg_2 (via 16(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A5/A6/A7/D0/D1/D2/D3/D5/D6/D7
; CALLS:
;   TEXTDISP_ResetSelectionAndRefresh, TLIBA3_ClearViewModeRastPort, TLIBA3_BuildDisplayContextForViewMode, WDISP_DrawWeatherStatusOverlay, WDISP_DrawWeatherStatusSummary, TEXTDISP_JMPTBL_ESQIFF_RunCopperRiseTransition, WDISP_JMPTBL_BRUSH_FindBrushByPredicate, WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight, WDISP_JMPTBL_ESQIFF_RenderWeatherStatusBrushSlice, WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples, WDISP_JMPTBL_ESQIFF_RunCopperDropTransition, _LVOSetAPen, _LVOSetDrMd, _LVOSetFont
; READS:
;   GLOB_HANDLE_PREVUEC_FONT, GLOB_REF_GRAPHICS_LIBRARY, GLOB_REF_RASTPORT_2, LAB_18BC, DATA_COMMON_BSS_WORD_1B0D, DATA_COMMON_BSS_WORD_1B0E, DATA_COMMON_BSS_WORD_1B0F, ESQFUNC_PwBrushListHead, DATA_ESQFUNC_STR_I5_1EDD, WDISP_DisplayContextBase, WDISP_WeatherStatusCountdown, WDISP_WeatherStatusBrushIndex, WDISP_WeatherStatusDigitChar, DATA_WDISP_BSS_WORD_22B0, DATA_WDISP_BSS_BYTE_22B2, DATA_WDISP_BSS_BYTE_22B3, DATA_WDISP_BSS_WORD_22B4, DATA_WDISP_BSS_BYTE_22B6, DATA_WDISP_BSS_BYTE_22B7, DATA_WDISP_BSS_WORD_22B8, DATA_WDISP_BSS_BYTE_22BA, DATA_WDISP_BSS_BYTE_22BB, DATA_WDISP_BSS_WORD_22BC, DATA_WDISP_BSS_BYTE_22BE, DATA_WDISP_BSS_BYTE_22BF, DATA_WDISP_BSS_LONG_2380, localRastport
; WRITES:
;   DATA_COMMON_BSS_WORD_1B0D, DATA_COMMON_BSS_WORD_1B0E, DATA_COMMON_BSS_WORD_1B0F, DATA_COMMON_BSS_WORD_1B10, DATA_COMMON_BSS_WORD_1B11, DATA_COMMON_BSS_WORD_1B12, DATA_COMMON_BSS_WORD_1B13, DATA_COMMON_BSS_WORD_1B14, DATA_COMMON_BSS_WORD_1B15, DATA_COMMON_BSS_WORD_1B16, DATA_COMMON_BSS_WORD_1B17, DATA_COMMON_BSS_LONG_1B18, WDISP_DisplayContextBase, WDISP_AccumulatorCaptureActive, DATA_WDISP_BSS_LONG_2380, localRastport
; DESC:
;   Dispatches weather-status commands (notably 48 and 51), renders status
;   content, and updates accumulator capture flags.
; NOTES:
;   Command values other than 48/51 fall back to TEXTDISP_ResetSelectionAndRefresh.
;------------------------------------------------------------------------------
WDISP_HandleWeatherStatusCommand:
    LINK.W  A5,#-12
    MOVEM.L D2/D5-D7,-(A7)

.localRastport = -12

    MOVE.L  8(A5),D7
    MOVEQ   #48,D0
    CMP.L   D0,D7
    BEQ.S   .LAB_18AE

    MOVEQ   #51,D0
    CMP.L   D0,D7
    BNE.W   .LAB_18BC

.LAB_18AE:
    CLR.L   -(A7)
    PEA     4.W
    JSR     TLIBA3_ClearViewModeRastPort(PC)

    MOVEQ   #4,D0
    MOVE.L  D0,(A7)
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    JSR     TLIBA3_BuildDisplayContextForViewMode(PC)

    MOVE.L  D0,WDISP_DisplayContextBase
    JSR     WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(PC)

    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    MOVEQ   #0,D6
    MOVEA.L WDISP_DisplayContextBase,A1
    MOVE.W  4(A1),D6
    MOVEQ   #0,D5
    MOVE.W  2(A1),D5
    MOVE.L  A0,.localRastport(A5)
    JSR     WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples(PC)

    JSR     WDISP_JMPTBL_ESQIFF_RunCopperDropTransition(PC)

    MOVEQ   #0,D0
    MOVE.L  D0,(A7)
    MOVE.L  D0,-(A7)
    PEA     3.W
    JSR     TLIBA3_BuildDisplayContextForViewMode(PC)

    LEA     24(A7),A7
    MOVE.L  D0,WDISP_DisplayContextBase

    MOVEA.L .localRastport(A5),A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L .localRastport(A5),A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L .localRastport(A5),A1
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    JSR     _LVOSetFont(A6)

    MOVEQ   #48,D0
    CMP.L   D0,D7
    BNE.S   .LAB_18AF

    MOVE.L  D6,-(A7)
    MOVE.L  D5,-(A7)
    MOVE.L  .localRastport(A5),-(A7)
    BSR.W   WDISP_DrawWeatherStatusOverlay

    LEA     12(A7),A7
    BRA.S   .LAB_18B0

.LAB_18AF:
    MOVEQ   #51,D0
    CMP.L   D0,D7
    BNE.S   .LAB_18B0

    MOVE.L  D6,-(A7)
    MOVE.L  D5,-(A7)
    MOVE.L  .localRastport(A5),-(A7)
    BSR.W   WDISP_DrawWeatherStatusSummary

    LEA     12(A7),A7

.LAB_18B0:
    MOVEQ   #4,D0
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    JSR     TLIBA3_BuildDisplayContextForViewMode(PC)

    LEA     12(A7),A7
    MOVE.L  D0,WDISP_DisplayContextBase
    MOVE.B  DATA_WDISP_BSS_BYTE_22B2,D0
    MOVEQ   #32,D1
    CMP.B   D1,D0
    BCC.S   .LAB_18B1

    MOVE.B  DATA_WDISP_BSS_BYTE_22B3,D0
    CMP.B   D1,D0
    BCC.S   .LAB_18B1

    MOVE.W  DATA_WDISP_BSS_WORD_22B0,D0
    CMPI.W  #$4000,D0
    BGE.S   .LAB_18B1

    MOVE.W  D0,DATA_COMMON_BSS_WORD_1B0D
    BRA.S   .LAB_18B2

.LAB_18B1:
    MOVEQ   #0,D0
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1B0D

.LAB_18B2:
    MOVE.B  DATA_WDISP_BSS_BYTE_22B6,D2
    CMP.B   D1,D2
    BCC.S   .LAB_18B3

    MOVE.B  DATA_WDISP_BSS_BYTE_22B7,D2
    CMP.B   D1,D2
    BCC.S   .LAB_18B3

    MOVE.W  DATA_WDISP_BSS_WORD_22B4,D2
    CMPI.W  #$4000,D2
    BGE.S   .LAB_18B3

    MOVE.W  D2,DATA_COMMON_BSS_WORD_1B0E
    BRA.S   .LAB_18B4

.LAB_18B3:
    MOVEQ   #0,D2
    MOVE.W  D2,DATA_COMMON_BSS_WORD_1B0E

.LAB_18B4:
    MOVE.B  DATA_WDISP_BSS_BYTE_22BA,D0
    CMP.B   D1,D0
    BCC.S   .LAB_18B5

    MOVE.B  DATA_WDISP_BSS_BYTE_22BB,D0
    CMP.B   D1,D0
    BCC.S   .LAB_18B5

    MOVE.W  DATA_WDISP_BSS_WORD_22B8,D0
    CMPI.W  #16384,D0
    BGE.S   .LAB_18B5

    MOVE.W  D0,DATA_COMMON_BSS_WORD_1B0F
    BRA.S   .LAB_18B6

.LAB_18B5:
    MOVEQ   #0,D0
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1B0F

.LAB_18B6:
    MOVE.B  DATA_WDISP_BSS_BYTE_22BE,D2
    CMP.B   D1,D2
    BCC.S   .LAB_18B7

    MOVE.B  DATA_WDISP_BSS_BYTE_22BF,D2
    CMP.B   D1,D2
    BCC.S   .LAB_18B7

    MOVE.W  DATA_WDISP_BSS_WORD_22BC,D1
    CMPI.W  #16384,D1
    BGE.S   .LAB_18B7

    MOVE.W  D1,DATA_COMMON_BSS_WORD_1B10
    BRA.S   .LAB_18B8

.LAB_18B7:
    MOVEQ   #0,D1
    MOVE.W  D1,DATA_COMMON_BSS_WORD_1B10

.LAB_18B8:
    TST.W   DATA_COMMON_BSS_WORD_1B0D
    BNE.S   .LAB_18B9

    TST.W   DATA_COMMON_BSS_WORD_1B0E
    BNE.S   .LAB_18B9

    TST.W   DATA_COMMON_BSS_WORD_1B0F
    BNE.S   .LAB_18B9

    TST.W   D1
    BEQ.S   .LAB_18BA

.LAB_18B9:
    MOVE.W  #1,WDISP_AccumulatorCaptureActive
    BRA.S   .LAB_18BB

.LAB_18BA:
    MOVEQ   #0,D0
    MOVE.W  D0,WDISP_AccumulatorCaptureActive

.LAB_18BB:
    MOVEQ   #0,D0
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1B11
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1B15
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1B12
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1B16
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1B13
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1B17
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1B14
    MOVE.W  D0,DATA_COMMON_BSS_LONG_1B18
    JSR     TEXTDISP_JMPTBL_ESQIFF_RunCopperRiseTransition(PC)

    BRA.S   .LAB_18BD

.LAB_18BC:
    JSR     TEXTDISP_ResetSelectionAndRefresh(PC)

.LAB_18BD:
    MOVEM.L (A7)+,D2/D5-D7
    UNLK    A5
    RTS

;!======

    ; Dead code.
    MOVEM.L D2-D3,-(A7)

    MOVE.W  WDISP_WeatherStatusDigitChar,D0
    MOVEQ   #48,D1
    CMP.W   D1,D0
    BEQ.S   .return

    MOVE.B  WDISP_WeatherStatusCountdown,D2
    TST.B   D2
    BEQ.S   .return

    MOVE.W  DATA_WDISP_BSS_LONG_2380,D2
    MOVE.L  D2,D3
    SUBQ.W  #1,D3
    MOVE.W  D3,DATA_WDISP_BSS_LONG_2380
    BGT.S   .return

    SUBI.W  #$30,D0
    MOVE.W  D0,DATA_WDISP_BSS_LONG_2380

.return:
    MOVEM.L (A7)+,D2-D3
    RTS

;!======

    ; Dead code.
    LINK.W  A5,#-8
    MOVEM.L D7/A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVE.B  WDISP_WeatherStatusBrushIndex,D0
    SUBQ.B  #1,D0
    BEQ.S   .LAB_18BF

    MOVE.B  WDISP_WeatherStatusBrushIndex,D0
    MOVEQ   #6,D1
    CMP.B   D1,D0
    BLS.S   .LAB_18C0

.LAB_18BF:
    MOVEQ   #0,D0
    BRA.S   .LAB_18C1

.LAB_18C0:
    MOVEQ   #0,D0
    MOVE.B  WDISP_WeatherStatusBrushIndex,D0
    ASL.L   #2,D0
    LEA     DATA_ESQFUNC_STR_I5_1EDD,A0
    ADDA.L  D0,A0
    PEA     ESQFUNC_PwBrushListHead
    MOVE.L  (A0),-(A7)
    JSR     WDISP_JMPTBL_BRUSH_FindBrushByPredicate(PC)

    MOVE.L  D0,(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  D0,-6(A5)
    JSR     WDISP_JMPTBL_ESQIFF_RenderWeatherStatusBrushSlice(PC)

    MOVE.L  D0,D7
    MOVE.L  D7,D0

.LAB_18C1:
    MOVEM.L -16(A5),D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: WDISP_UpdateSelectionPreviewPanel   (UpdateSelectionPreviewPanel)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0/D1/D2
; CALLS:
;   WDISP_JMPTBL_BRUSH_FreeBrushList, WDISP_JMPTBL_ESQIFF_QueueIffBrushLoad, WDISP_JMPTBL_ESQIFF_RenderWeatherStatusBrushSlice, WDISP_JMPTBL_GCOMMAND_ExpandPresetBlock, WDISP_JMPTBL_NEWGRID_ResetRowTable, _LVOSetRast
; READS:
;   GLOB_REF_GRAPHICS_LIBRARY, GLOB_REF_RASTPORT_1, LAB_18C9, WDISP_WeatherStatusBrushListHead, DATA_P_TYPE_BSS_LONG_2059, DATA_TLIBA1_BSS_LONG_2194, DATA_TLIBA1_BSS_LONG_2195, WDISP_WeatherStatusCountdown, WDISP_WeatherStatusDigitChar, DATA_WDISP_BSS_LONG_2380, e8
; WRITES:
;   DATA_TLIBA1_BSS_LONG_2194, DATA_TLIBA1_BSS_LONG_2195
; DESC:
;   Updates/refreshes the selection preview panel brush resources and row table,
;   then returns boolean success as 0/-1 in D0.
; NOTES:
;   Uses SNE/NEG/EXT booleanization pattern on DATA_TLIBA1_BSS_LONG_2195.
;------------------------------------------------------------------------------
WDISP_UpdateSelectionPreviewPanel:
    LINK.W  A5,#-4
    MOVEM.L D2/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2

    MOVEQ   #8,D0
    CMP.L   DATA_TLIBA1_BSS_LONG_2194,D0
    BNE.S   .LAB_18C3

    MOVEQ   #0,D0
    MOVE.L  D0,DATA_TLIBA1_BSS_LONG_2194
    MOVE.L  D0,DATA_TLIBA1_BSS_LONG_2195
    BRA.W   .LAB_18C9

.LAB_18C3:
    LEA     60(A2),A0
    MOVEA.L A0,A1
    MOVEQ   #7,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  4(A0),-4(A5)
    MOVE.L  4(A3),4(A0)
    TST.L   DATA_TLIBA1_BSS_LONG_2194
    BNE.S   .LAB_18C5

    MOVE.L  WDISP_WeatherStatusBrushListHead,-(A7)
    MOVE.L  A2,-(A7)
    JSR     WDISP_JMPTBL_ESQIFF_RenderWeatherStatusBrushSlice(PC)

    ADDQ.W  #8,A7
    EXT.L   D0
    MOVE.L  D0,DATA_TLIBA1_BSS_LONG_2195
    TST.L   D0
    BEQ.S   .LAB_18C4

    MOVEQ   #7,D0
    MOVE.L  D0,DATA_TLIBA1_BSS_LONG_2194

.LAB_18C4:
    TST.L   WDISP_WeatherStatusBrushListHead
    BEQ.S   .LAB_18C6

    MOVEA.L WDISP_WeatherStatusBrushListHead,A0
    ADDA.W  #$e8,A0
    MOVE.L  A0,-(A7)
    JSR     WDISP_JMPTBL_GCOMMAND_ExpandPresetBlock(PC)

    MOVE.L  A2,(A7)
    JSR     WDISP_JMPTBL_NEWGRID_ResetRowTable(PC)

    ADDQ.W  #4,A7
    BRA.S   .LAB_18C6

.LAB_18C5:
    MOVEQ   #7,D0
    CMP.L   DATA_TLIBA1_BSS_LONG_2194,D0
    BNE.S   .LAB_18C6

    MOVE.L  WDISP_WeatherStatusBrushListHead,-(A7)
    MOVE.L  A2,-(A7)
    JSR     WDISP_JMPTBL_ESQIFF_RenderWeatherStatusBrushSlice(PC)

    ADDQ.W  #8,A7
    EXT.L   D0
    MOVE.L  D0,DATA_TLIBA1_BSS_LONG_2195
    MOVEQ   #-1,D1
    MOVE.L  D1,32(A2)

.LAB_18C6:
    TST.L   DATA_TLIBA1_BSS_LONG_2195
    BNE.S   .LAB_18C8

    CLR.L   -(A7)
    PEA     WDISP_WeatherStatusBrushListHead
    JSR     WDISP_JMPTBL_BRUSH_FreeBrushList(PC)

    ADDQ.W  #8,A7
    MOVEQ   #0,D0
    TST.L   D0
    BEQ.S   .LAB_18C7

    MOVE.W  WDISP_WeatherStatusDigitChar,D1
    MOVEQ   #48,D2
    CMP.W   D2,D1
    BEQ.S   .LAB_18C7

    MOVE.B  WDISP_WeatherStatusCountdown,D1
    TST.B   D1
    BEQ.S   .LAB_18C7

    MOVE.W  DATA_WDISP_BSS_LONG_2380,D1
    MOVEQ   #1,D2
    CMP.W   D2,D1
    BGT.S   .LAB_18C7

    TST.L   DATA_P_TYPE_BSS_LONG_2059
    BNE.S   .LAB_18C7

    PEA     2.W
    JSR     WDISP_JMPTBL_ESQIFF_QueueIffBrushLoad(PC)

    ADDQ.W  #4,A7

.LAB_18C7:
    MOVEQ   #8,D0
    MOVE.L  D0,DATA_TLIBA1_BSS_LONG_2194
    MOVEQ   #-1,D0
    MOVE.L  D0,DATA_TLIBA1_BSS_LONG_2195

.LAB_18C8:
    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  -4(A5),4(A0)

.LAB_18C9:
    TST.L   DATA_TLIBA1_BSS_LONG_2195
    SNE     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0

    MOVEM.L (A7)+,D2/A2-A3
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

;------------------------------------------------------------------------------
; FUNC: WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples   (Routine at WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQIFF_RestoreBasePaletteTriples
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples:
    JMP     ESQIFF_RestoreBasePaletteTriples

;------------------------------------------------------------------------------
; FUNC: WDISP_JMPTBL_ESQFUNC_TrimTextToPixelWidthWordBoundary   (Routine at WDISP_JMPTBL_ESQFUNC_TrimTextToPixelWidthWordBoundary)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQFUNC_TrimTextToPixelWidthWordBoundary
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
WDISP_JMPTBL_ESQFUNC_TrimTextToPixelWidthWordBoundary:
    JMP     ESQFUNC_TrimTextToPixelWidthWordBoundary

;------------------------------------------------------------------------------
; FUNC: WDISP_JMPTBL_GCOMMAND_ExpandPresetBlock   (Routine at WDISP_JMPTBL_GCOMMAND_ExpandPresetBlock)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   GCOMMAND_ExpandPresetBlock
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
WDISP_JMPTBL_GCOMMAND_ExpandPresetBlock:
    JMP     GCOMMAND_ExpandPresetBlock

;------------------------------------------------------------------------------
; FUNC: WDISP_JMPTBL_ESQIFF_QueueIffBrushLoad   (Routine at WDISP_JMPTBL_ESQIFF_QueueIffBrushLoad)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQIFF_QueueIffBrushLoad
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
WDISP_JMPTBL_ESQIFF_QueueIffBrushLoad:
    JMP     ESQIFF_QueueIffBrushLoad

;------------------------------------------------------------------------------
; FUNC: WDISP_JMPTBL_ESQIFF_RunCopperDropTransition   (Routine at WDISP_JMPTBL_ESQIFF_RunCopperDropTransition)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQIFF_RunCopperDropTransition
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
WDISP_JMPTBL_ESQIFF_RunCopperDropTransition:
    JMP     ESQIFF_RunCopperDropTransition

;------------------------------------------------------------------------------
; FUNC: WDISP_JMPTBL_BRUSH_FindBrushByPredicate   (Routine at WDISP_JMPTBL_BRUSH_FindBrushByPredicate)
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
WDISP_JMPTBL_BRUSH_FindBrushByPredicate:
    JMP     BRUSH_FindBrushByPredicate

;------------------------------------------------------------------------------
; FUNC: WDISP_JMPTBL_BRUSH_FreeBrushList   (Routine at WDISP_JMPTBL_BRUSH_FreeBrushList)
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
WDISP_JMPTBL_BRUSH_FreeBrushList:
    JMP     BRUSH_FreeBrushList

;------------------------------------------------------------------------------
; FUNC: WDISP_JMPTBL_BRUSH_PlaneMaskForIndex   (Routine at WDISP_JMPTBL_BRUSH_PlaneMaskForIndex)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   BRUSH_PlaneMaskForIndex
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
WDISP_JMPTBL_BRUSH_PlaneMaskForIndex:
    JMP     BRUSH_PlaneMaskForIndex

;------------------------------------------------------------------------------
; FUNC: WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight   (Routine at WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_SetCopperEffect_OnEnableHighlight
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight:
    JMP     ESQ_SetCopperEffect_OnEnableHighlight

;------------------------------------------------------------------------------
; FUNC: WDISP_JMPTBL_ESQIFF_RenderWeatherStatusBrushSlice   (Routine at WDISP_JMPTBL_ESQIFF_RenderWeatherStatusBrushSlice)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQIFF_RenderWeatherStatusBrushSlice
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
WDISP_JMPTBL_ESQIFF_RenderWeatherStatusBrushSlice:
    JMP     ESQIFF_RenderWeatherStatusBrushSlice

;------------------------------------------------------------------------------
; FUNC: WDISP_JMPTBL_BRUSH_SelectBrushSlot   (Routine at WDISP_JMPTBL_BRUSH_SelectBrushSlot)
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
WDISP_JMPTBL_BRUSH_SelectBrushSlot:
    JMP     BRUSH_SelectBrushSlot

;------------------------------------------------------------------------------
; FUNC: WDISP_JMPTBL_NEWGRID_DrawWrappedText   (Routine at WDISP_JMPTBL_NEWGRID_DrawWrappedText)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   NEWGRID_DrawWrappedText
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
WDISP_JMPTBL_NEWGRID_DrawWrappedText:
    JMP     NEWGRID_DrawWrappedText

;------------------------------------------------------------------------------
; FUNC: WDISP_JMPTBL_NEWGRID_ResetRowTable   (Routine at WDISP_JMPTBL_NEWGRID_ResetRowTable)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   NEWGRID_ResetRowTable
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
WDISP_JMPTBL_NEWGRID_ResetRowTable:
    JMP     NEWGRID_ResetRowTable

;!======

    ; Alignment
    MOVEQ   #97,D0
