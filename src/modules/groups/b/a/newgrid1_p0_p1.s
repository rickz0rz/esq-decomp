    XDEF    _NEWGRID_DrawGridCell


;------------------------------------------------------------------------------
; FUNC: _NEWGRID_DrawGridCell   (Draw cell background and text)
; ARGS:
;   stack +8: A3 = rastport
;   stack +12: A2 = cell struct
;   stack +16: D7 = row index
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _NEWGRID2_JMPTBL_STR_SkipClass3Chars, _NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame, _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight, _NEWGRID_DrawGridCellText
; READS:
;   _NEWGRID_ColumnStartXPx, _NEWGRID_RowHeightPx
; WRITES:
;   none
; DESC:
;   Draws the cell background (highlight or normal) and renders its labels.
; NOTES:
;   Uses two string pointers from the cell struct (1(A2), 19(A2)).
;------------------------------------------------------------------------------
_NEWGRID_DrawGridCell:
    LINK.W  A5,#-8
    MOVEM.L D2/D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  16(A5),D7
    LEA     1(A2),A0
    LEA     19(A2),A1
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-4(A5)
    MOVE.L  A1,-8(A5)
    JSR     _NEWGRID2_JMPTBL_STR_SkipClass3Chars(PC)

    MOVE.L  -8(A5),(A7)
    MOVE.L  D0,-4(A5)
    JSR     _NEWGRID2_JMPTBL_STR_SkipClass3Chars(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,-8(A5)
    ; choose frame style based on row flag
    TST.L   D7
    BNE.S   .draw_alternate_frame

    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    MOVEQ   #0,D1
    MOVE.W  _NEWGRID_RowHeightPx,D1
    SUBQ.L  #1,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  A3,-(A7)
    JSR     _NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame(PC)

    LEA     20(A7),A7
    BRA.S   .draw_cell_text

.draw_alternate_frame:
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    MOVEQ   #0,D1
    MOVE.W  _NEWGRID_RowHeightPx,D1
    SUBQ.L  #1,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  A3,-(A7)
    JSR     _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(PC)

    LEA     20(A7),A7

.draw_cell_text:
    MOVE.L  D7,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_DrawGridCellText

    MOVEM.L -24(A5),D2/D7/A2-A3
    UNLK    A5
    RTS

;!======