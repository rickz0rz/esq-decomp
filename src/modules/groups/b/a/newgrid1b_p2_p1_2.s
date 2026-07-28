    XDEF    NEWGRID_DrawEmptyGridMessage



;------------------------------------------------------------------------------
; FUNC: NEWGRID_DrawEmptyGridMessage   (Draw empty grid message)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +14: arg_2 (via 18(A5))
;   stack +124: arg_3 (via 128(A5))
;   stack +155: arg_4 (via 159(A5))
;   stack +188: arg_5 (via 192(A5))
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   _NEWGRID_DrawGridFrame, _NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry, PARSEINI_JMPTBL_STRING_AppendAtNull,
;   _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight, _LVOSetAPen, _LVOSetDrMd, _LVOTextLength, _LVOMove, _LVOText,
;   _NEWGRID_ValidateSelectionCode
; READS:
;   SCRIPT_PtrMovieSummaryForPrefix, _NEWGRID_RowHeightPx, _NEWGRID_ColumnStartXPx, _NEWGRID_ColumnWidthPx
; DESC:
;   Builds and draws the "no data" banner centered in the grid area.
;------------------------------------------------------------------------------
NEWGRID_DrawEmptyGridMessage:
    LINK.W  A5,#-172
    MOVEM.L D2/D7/A2-A3/A6,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  18(A5),D7
    PEA     33.W
    MOVEQ   #6,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    PEA     7.W
    MOVE.L  A3,-(A7)
    JSR     _NEWGRID_DrawGridFrame(PC)

    MOVEA.L SCRIPT_PtrMovieSummaryForPrefix,A0
    LEA     -128(A5),A1

.copy_prefix_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_prefix_loop

    MOVE.L  D7,D0
    EXT.L   D0
    PEA     -159(A5)
    MOVE.L  D0,-(A7)
    JSR     _NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry(PC)

    PEA     -159(A5)
    PEA     -128(A5)
    JSR     PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    PEA     33.W
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(PC)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    PEA     33.W
    PEA     695.W
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(PC)

    LEA     76(A7),A7
    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVEQ   #3,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVE.W  _NEWGRID_ColumnWidthPx,D1
    MULU    #3,D1
    LEA     60(A3),A1
    LEA     -128(A5),A2
    MOVEA.L A2,A6

.measure_message:
    TST.B   (A6)+
    BNE.S   .measure_message

    SUBQ.L  #1,A6
    SUBA.L  A2,A6
    MOVE.L  D0,24(A7)
    MOVE.L  D1,28(A7)
    MOVE.L  A0,20(A7)
    MOVEA.L A2,A0
    MOVE.L  A6,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  28(A7),D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .center_x

    ADDQ.L  #1,D1

.center_x:
    ASR.L   #1,D1
    MOVE.L  24(A7),D0
    ADD.L   D1,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    MOVEQ   #34,D2
    SUB.L   D1,D2
    TST.L   D2
    BPL.S   .center_y

    ADDQ.L  #1,D2

.center_y:
    ASR.L   #1,D2
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    ADD.L   D1,D2
    SUBQ.L  #1,D2
    MOVE.L  D2,D1
    MOVEA.L 20(A7),A1
    JSR     _LVOMove(A6)

    LEA     60(A3),A0
    MOVEA.L A2,A1

.draw_text_loop:
    TST.B   (A1)+
    BNE.S   .draw_text_loop

    SUBQ.L  #1,A1
    SUBA.L  A2,A1
    MOVE.L  A1,24(A7)
    MOVEA.L A0,A1
    MOVEA.L A2,A0
    MOVE.L  24(A7),D0
    JSR     _LVOText(A6)

    MOVEQ   #17,D0
    MOVE.W  D0,52(A3)
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,32(A3)
    PEA     65.W
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_ValidateSelectionCode

    MOVEM.L -192(A5),D2/D7/A2-A3/A6
    UNLK    A5
    RTS

;!======