    XDEF    SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_LINE_OR_PAGE
    XDEF    SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR


;------------------------------------------------------------------------------
; FUNC: SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR   (Draw text/cursor label)
; ARGS:
;   (none observed)
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A6/A7/D0/D7
; CALLS:
;   _DISPLIB_DisplayTextAtPosition, _LVOSetAPen, _LVOSetBPen, _LVOSetDrMd
; READS:
;   _Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws either "TEXT" or "CURSOR" label with fixed pens.
; NOTES:
;   Uses D7 as the boolean input.
;------------------------------------------------------------------------------
SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR:
    MOVE.L  D7,-(A7)

    MOVE.L  8(A7),D7
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #6,D0
    JSR     _LVOSetBPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    MOVEQ   #1,D0
    CMP.L   D0,D7
    BNE.S   .setTextToCursor

    LEA     Global_STR_TEXT,A0
    BRA.S   .drawText

.setTextToCursor:
    LEA     Global_STR_CURSOR,A0

.drawText:
    MOVE.L  A0,-(A7)
    PEA     390.W
    PEA     296.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetBPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_LINE_OR_PAGE   (Draw line/page label)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A6/A7/D0
; CALLS:
;   _DISPLIB_DisplayTextAtPosition, _LVOSetAPen, _LVOSetBPen, _LVOSetDrMd
; READS:
;   Global_REF_BOOL_IS_LINE_OR_PAGE, _Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws either "LINE" or "PAGE" label with fixed pens.
; NOTES:
;   Uses Global_REF_BOOL_IS_LINE_OR_PAGE as the selector.
;------------------------------------------------------------------------------
SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_LINE_OR_PAGE:
    LINK.W  A5,#0

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0

    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #6,D0
    JSR     _LVOSetBPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    TST.L   Global_REF_BOOL_IS_LINE_OR_PAGE
    BNE.S   .setTextToPage

    LEA     Global_STR_LINE,A0
    BRA.S   .drawText

.setTextToPage:
    LEA     Global_STR_PAGE,A0

.drawText:
    MOVE.L  A0,-(A7)
    PEA     390.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetBPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    UNLK    A5
    RTS

;!======
