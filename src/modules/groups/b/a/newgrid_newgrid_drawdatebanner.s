    XDEF    _NEWGRID_DrawDateBanner


;------------------------------------------------------------------------------
; FUNC: _NEWGRID_DrawDateBanner   (Draw date banner line)
; ARGS:
;   stack +8: A3 = base rastport/struct
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   _NEWGRID_JMPTBL_GENERATE_GRID_DATE_STRING, _LVOSetDrMd, _NEWGRID_SetRowColor, _LVOSetAPen,
;   _LVORectFill, _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight, _LVOTextLength, _LVOMove, _LVOText
; READS:
;   _NEWGRID_ColumnStartXPx/232B
; WRITES:
;   52(A3), 32(A3)
; DESC:
;   Builds a date string and draws it centered in the top banner.
; NOTES:
;   Uses raster sub-struct at 60(A3).
;------------------------------------------------------------------------------
_NEWGRID_DrawDateBanner:

.rastport   = -108

    LINK.W  A5,#-116
    MOVEM.L D2-D3/D7/A3,-(A7)

    MOVEA.L 8(A5),A3
    LEA     60(A3),A0
    PEA     -100(A5)
    MOVE.L  A0,.rastport(A5)
    JSR     _NEWGRID_JMPTBL_GENERATE_GRID_DATE_STRING(PC)

    MOVEA.L .rastport(A5),A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    PEA     7.W
    CLR.L   -(A7)
    MOVE.L  A3,-(A7)
    JSR     _NEWGRID_SetRowColor(PC)

    MOVEA.L .rastport(A5),A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    ; Fill in the blue background for behind the date string
    MOVEA.L .rastport(A5),A1
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    MOVE.L  #695,D2
    MOVEQ   #33,D3
    JSR     _LVORectFill(A6)

    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    MOVE.L  D3,(A7)
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  .rastport(A5),-(A7)
    JSR     _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(PC)

    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    PEA     33.W
    PEA     695.W
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  .rastport(A5),-(A7)
    JSR     _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(PC)

    MOVEA.L .rastport(A5),A1
    MOVEQ   #3,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVE.W  _NEWGRID_ColumnWidthPx,D1
    MULU    #3,D1
    LEA     -100(A5),A0
    MOVEA.L A0,A1

.measure_date:
    TST.B   (A1)+
    BNE.S   .measure_date

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  D0,68(A7)
    MOVE.L  D1,72(A7)
    MOVE.L  A1,D0
    MOVEA.L .rastport(A5),A1
    JSR     _LVOTextLength(A6)

    MOVE.L  72(A7),D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .center_date

    ADDQ.L  #1,D1

.center_date:
    ASR.L   #1,D1
    MOVE.L  68(A7),D0
    ADD.L   D1,D0
    MOVE.L  D0,D7
    MOVEQ   #36,D1
    ADD.L   D1,D7
    MOVEA.L .rastport(A5),A1
    MOVEA.L 52(A1),A0
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    MOVEQ   #34,D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .center_date_y

    ADDQ.L  #1,D1

.center_date_y:
    ASR.L   #1,D1
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    ADD.L   D0,D1
    SUBQ.L  #1,D1
    MOVE.L  D7,D0
    JSR     _LVOMove(A6)

    LEA     -100(A5),A0
    MOVEA.L A0,A1

.draw_date:
    TST.B   (A1)+
    BNE.S   .draw_date

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    MOVEA.L .rastport(A5),A1
    JSR     _LVOText(A6)

    MOVEQ   #17,D0
    MOVE.W  D0,52(A3)
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,32(A3)

    MOVEM.L -132(A5),D2-D3/D7/A3
    UNLK    A5
    RTS

;!======