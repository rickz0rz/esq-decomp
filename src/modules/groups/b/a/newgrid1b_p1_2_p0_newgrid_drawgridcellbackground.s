    XDEF    _NEWGRID_DrawGridCellBackground


;------------------------------------------------------------------------------
; FUNC: _NEWGRID_DrawGridCellBackground   (Draw cell background/frame)
; ARGS:
;   stack +8: A3 = rastport
;   stack +14: D7 = row index
;   stack +18: D6 = column index
;   stack +20: D5 = color selector
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   _NEWGRID_SetRowColor, _LVOSetAPen, _LVORectFill, _NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame, _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight
; READS:
;   _NEWGRID_RowHeightPx, _NEWGRID_ColumnStartXPx, _NEWGRID_ColumnWidthPx, _CONFIG_NewgridPlaceholderBevelFlag
; DESC:
;   Fills a grid cell background and draws its frame based on row/column and
;   clock format flags.
;------------------------------------------------------------------------------
_NEWGRID_DrawGridCellBackground:
    LINK.W  A5,#-20
    MOVEM.L D2-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVE.W  18(A5),D6
    MOVE.L  20(A5),D5
    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVE.W  _NEWGRID_ColumnWidthPx,D1
    MULU    D7,D1
    ADD.L   D1,D0
    MOVE.L  D0,D4
    MOVEQ   #36,D1
    ADD.L   D1,D4
    CLR.L   -8(A5)
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    ADD.L   D1,D0
    MOVE.L  A0,-20(A5)
    MOVEQ   #3,D1
    CMP.L   D1,D0
    BLT.S   .compute_cell_right

    MOVE.L  #695,D0
    BRA.S   .store_bounds

.compute_cell_right:
    MOVE.W  _NEWGRID_ColumnWidthPx,D0
    MULU    D6,D0
    MOVE.L  D4,D1
    ADD.L   D0,D1
    SUBQ.L  #1,D1
    MOVE.L  D1,D0

.store_bounds:
    MOVEQ   #0,D1
    MOVE.W  _NEWGRID_RowHeightPx,D1
    SUBQ.L  #1,D1
    MOVE.L  D0,-12(A5)
    MOVE.L  D1,-16(A5)
    MOVEQ   #0,D0
    NOT.B   D0
    CMP.L   D0,D5
    BEQ.S   .skip_background_fill

    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D5,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_SetRowColor

    LEA     12(A7),A7
    MOVEA.L -20(A5),A1
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVE.L  D4,D0
    MOVEA.L -20(A5),A1
    MOVE.L  -8(A5),D1
    MOVE.L  -12(A5),D2
    MOVE.L  -16(A5),D3
    JSR     _LVORectFill(A6)

.skip_background_fill:
    MOVEQ   #3,D0
    CMP.W   D0,D6
    BNE.S   .draw_normal_frame

    MOVE.B  _CONFIG_NewgridPlaceholderBevelFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .draw_normal_frame

    MOVE.L  -16(A5),-(A7)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  -20(A5),-(A7)
    JSR     _NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame(PC)

    LEA     20(A7),A7
    BRA.S   .done

.draw_normal_frame:
    MOVE.L  -16(A5),-(A7)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  -20(A5),-(A7)
    JSR     _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(PC)

    LEA     20(A7),A7

.done:
    MOVEM.L (A7)+,D2-D7/A3
    UNLK    A5
    RTS

;!======