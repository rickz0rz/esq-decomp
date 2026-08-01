    XDEF    _ED_DrawMenuSelectionHighlight



;------------------------------------------------------------------------------
; FUNC: _ED_DrawMenuSelectionHighlight   (Draw ESC menu selection highlightuncertain)
; ARGS:
;   (none observed)
; RET:
;   (none)
; CLOBBERS:
;   A1/A6/A7/D0/D1/D2/D3/D7
; CALLS:
;   _ESQIFF_JMPTBL_MATH_Mulu32, _LVOSetAPen, _LVORectFill
; READS:
;   _ED_EditCursorOffset, _Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws the selection highlight bar for the ESC menu.
; NOTES:
;   Uses _ED_EditCursorOffset to optionally draw the current selection marker.
;------------------------------------------------------------------------------
_ED_DrawMenuSelectionHighlight:
    MOVEM.L D2-D3/D7,-(A7)

    MOVE.L  16(A7),D7
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVE.L  D7,D0
    MOVEQ   #30,D1
    JSR     _ESQIFF_JMPTBL_MATH_Mulu32(PC)

    MOVEQ   #67,D1
    ADD.L   D1,D0
    MOVE.L  D0,D3
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVEQ   #68,D1
    MOVE.L  #640,D2
    JSR     _LVORectFill(A6)

    CMPI.L  #$ffffffff,_ED_EditCursorOffset
    BLE.S   .after_optional_marker

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #6,D0
    JSR     _LVOSetAPen(A6)

    MOVE.L  _ED_EditCursorOffset,D0
    MOVEQ   #30,D1
    JSR     _ESQIFF_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  D0,D1
    MOVEQ   #68,D2
    ADD.L   D2,D1
    MOVEQ   #97,D2
    ADD.L   D2,D0
    MOVE.L  D0,D3
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVE.L  #640,D2
    JSR     _LVORectFill(A6)

.after_optional_marker:
    MOVEM.L (A7)+,D2-D3/D7
    RTS

;!======