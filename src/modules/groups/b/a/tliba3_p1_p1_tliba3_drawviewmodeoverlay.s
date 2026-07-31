    XDEF    _TLIBA3_DrawViewModeOverlay


;------------------------------------------------------------------------------
; FUNC: _TLIBA3_DrawViewModeOverlay   (_TLIBA3_DrawViewModeOverlay)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +84: arg_2 (via 88(A5))
;   stack +96: arg_3 (via 100(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A6/A7/D0/D1/D5/D6/D7
; CALLS:
;   _TLIBA3_DrawCenteredWrappedTextLines, _TLIBA3_DrawViewModeGuides, _MATH_Mulu32, _WDISP_SPrintf, _LVOSetAPen, _LVOSetBPen, _LVOSetDrMd, _LVOSetFont, _LVOSetRast
; READS:
;   _Global_HANDLE_PREVUEC_FONT, Global_REF_GRAPHICS_LIBRARY, _TLIBA1_FMT_VIEWMODE_PCT_LD, _TLIBA3_VmArrayRuntimeTable
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_TLIBA3_DrawViewModeOverlay:
    LINK.W  A5,#-88
    MOVEM.L D5-D7,-(A7)
    MOVE.L  8(A5),D7

    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     _MATH_Mulu32(PC)

    LEA     _TLIBA3_VmArrayRuntimeTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEQ   #0,D6
    MOVE.W  2(A1),D6
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEQ   #0,D5
    MOVE.W  4(A1),D5
    ADDA.L  D0,A0
    LEA     10(A0),A1
    MOVEA.L _Global_HANDLE_PREVUEC_FONT,A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     _MATH_Mulu32(PC)

    LEA     _TLIBA3_VmArrayRuntimeTable,A0
    ADDA.L  D0,A0
    LEA     10(A0),A1
    MOVEQ   #0,D0
    JSR     _LVOSetRast(A6)

    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     _MATH_Mulu32(PC)

    LEA     _TLIBA3_VmArrayRuntimeTable,A0
    ADDA.L  D0,A0
    LEA     10(A0),A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     _MATH_Mulu32(PC)

    LEA     _TLIBA3_VmArrayRuntimeTable,A0
    ADDA.L  D0,A0
    LEA     10(A0),A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     _MATH_Mulu32(PC)

    LEA     _TLIBA3_VmArrayRuntimeTable,A0
    ADDA.L  D0,A0
    LEA     10(A0),A1
    MOVEQ   #0,D0
    JSR     _LVOSetBPen(A6)

    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     _MATH_Mulu32(PC)

    LEA     _TLIBA3_VmArrayRuntimeTable,A0
    ADDA.L  D0,A0
    LEA     10(A0),A1
    MOVE.L  A1,-(A7)
    BSR.W   _TLIBA3_DrawViewModeGuides

    MOVE.L  D7,(A7)
    PEA     _TLIBA1_FMT_VIEWMODE_PCT_LD
    PEA     -88(A5)
    JSR     _WDISP_SPrintf(PC)

    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     _MATH_Mulu32(PC)

    LEA     _TLIBA3_VmArrayRuntimeTable,A0
    ADDA.L  D0,A0
    LEA     10(A0),A1
    PEA     90.W
    PEA     -88(A5)
    MOVE.L  A1,-(A7)
    BSR.W   _TLIBA3_DrawCenteredWrappedTextLines

    MOVEM.L -100(A5),D5-D7
    UNLK    A5
    RTS

;!======