    XDEF    _TLIBA3_DrawViewModeGuides



;------------------------------------------------------------------------------
; FUNC: _TLIBA3_DrawViewModeGuides   (_TLIBA3_DrawViewModeGuides)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A6/A7/D0
; CALLS:
;   _TLIBA3_DrawVerticalScaleTicks, _TLIBA3_DrawHorizontalScaleTicks, _TLIBA3_DrawOuterFrameBorder, _TLIBA3_DrawInnerFrameBorder, _LVOSetAPen, _LVOSetDrMd, _LVOSetFont
; READS:
;   _Global_HANDLE_PREVUEC_FONT, _Global_HANDLE_TOPAZ_FONT, Global_REF_GRAPHICS_LIBRARY
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_TLIBA3_DrawViewModeGuides:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    MOVEA.L A3,A1
    MOVEA.L _Global_HANDLE_TOPAZ_FONT,A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    MOVEA.L A3,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L 4(A3),A0
    MOVEQ   #0,D0
    MOVE.W  (A0),D0
    ASL.L   #3,D0
    TST.L   D0
    BPL.S   .lab_1838

    ADDQ.L  #1,D0

.lab_1838:
    ASR.L   #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _TLIBA3_DrawVerticalScaleTicks

    MOVEA.L 4(A3),A0
    MOVEQ   #0,D0
    MOVE.W  2(A0),D0
    TST.L   D0
    BPL.S   .lab_1839

    ADDQ.L  #1,D0

.lab_1839:
    ASR.L   #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _TLIBA3_DrawHorizontalScaleTicks

    MOVE.L  A3,(A7)
    BSR.W   _TLIBA3_DrawOuterFrameBorder

    MOVE.L  A3,(A7)
    BSR.W   _TLIBA3_DrawInnerFrameBorder

    LEA     12(A7),A7
    MOVEA.L A3,A1
    MOVEA.L _Global_HANDLE_PREVUEC_FONT,A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    MOVEA.L (A7)+,A3
    RTS

;!======