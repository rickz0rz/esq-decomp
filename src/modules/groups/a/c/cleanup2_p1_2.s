    XDEF    CLEANUP_DrawClockFormatList
    XDEF    CLEANUP_FormatClockFormatEntry


;------------------------------------------------------------------------------
; FUNC: CLEANUP_FormatClockFormatEntry   (FormatClockFormatEntryuncertain)
; ARGS:
;   (none observed)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1/D6-D7/A0-A3
; CALLS:
;   _GROUP_AG_JMPTBL_MATH_DivS32, _GROUP_AG_JMPTBL_MATH_Mulu32
; READS:
;   _CLOCK_FormatVariantCode, _Global_REF_STR_CLOCK_FORMAT
; WRITES:
;   outText buffer (A3)
; DESC:
;   Copies a clock-format string for slotIndex into outText and optionally
;   adjusts two digit positions based on _CLOCK_FormatVariantCode.
; NOTES:
;   - Wraps slotIndex by subtracting 48 until within range.
;------------------------------------------------------------------------------
CLEANUP_FormatClockFormatEntry:
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVE.L  20(A7),D7
    MOVEA.L 24(A7),A3

.wrap_slot_index_loop:
    MOVEQ   #48,D0
    CMP.L   D0,D7
    BLE.S   .slot_index_ready

    SUB.L   D0,D7
    BRA.S   .wrap_slot_index_loop

.slot_index_ready:
    MOVEQ   #0,D0
    MOVE.B  _CLOCK_FormatVariantCode,D0
    MOVEQ   #30,D1
    JSR     _GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVE.L  D1,D6
    MOVE.L  D7,D0
    ASL.L   #2,D0
    MOVEA.L _Global_REF_STR_CLOCK_FORMAT,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVEA.L A3,A2

.copy_format_loop:
    MOVE.B  (A1)+,(A2)+
    BNE.S   .copy_format_loop

    TST.L   D6
    BLE.S   .done

    MOVE.B  3(A3),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVEQ   #10,D1
    JSR     _GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    ADD.L   D0,D6
    MOVE.L  D6,D0
    MOVEQ   #10,D1
    JSR     _GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVEQ   #48,D1
    ADD.L   D1,D0
    MOVE.B  D0,3(A3)
    MOVE.L  D6,D0
    MOVEQ   #10,D1
    JSR     _GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVEQ   #48,D0
    ADD.L   D0,D1
    MOVE.B  D1,4(A3)

.done:
    MOVEM.L (A7)+,D6-D7/A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CLEANUP_DrawClockFormatList   (DrawClockFormatListuncertain)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +85: arg_2 (via 89(A5))
;   stack +116: arg_3 (via 120(A5))
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A1/A5-A6
; CALLS:
;   GROUP_AC_JMPTBL_GCOMMAND_UpdateBannerBounds, _LVOSetAPen, _LVORectFill, _GROUP_AG_JMPTBL_MATH_Mulu32, _BEVEL_DrawBevelFrameWithTopRight,
;   CLEANUP_FormatClockFormatEntry, _LVOTextLength, _LVOMove, _LVOText
; READS:
;   _NEWGRID_ColumnStartXPx, _NEWGRID_ColumnWidthPx, _NEWGRID_MainRastPortPtr, Global_REF_GRAPHICS_LIBRARY
; WRITES:
;   Stack text buffer at -89(A5)
; DESC:
;   Renders a multi-row list of clock-format strings starting at baseSlotIndex
;   into the grid rastport area.
; NOTES:
;   - Draws two rows in a loop, then renders the final row separately.
;------------------------------------------------------------------------------
CLEANUP_DrawClockFormatList:
    LINK.W  A5,#-100
    MOVEM.L D2-D3/D5-D7,-(A7)
    MOVE.L  8(A5),D7
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    PEA     6.W
    PEA     5.W
    MOVE.L  D0,-(A7)
    JSR     GROUP_AC_JMPTBL_GCOMMAND_UpdateBannerBounds(PC)

    LEA     16(A7),A7

    MOVEA.L _NEWGRID_MainRastPortPtr,A1
    MOVEQ   #7,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVEQ   #36,D1

    ADD.L   D1,D0
    MOVEA.L _NEWGRID_MainRastPortPtr,A1
    MOVEQ   #0,D1
    MOVE.L  #695,D2
    MOVEQ   #33,D3
    JSR     _LVORectFill(A6)

    MOVEQ   #0,D6

.row_loop:
    MOVEQ   #2,D0
    CMP.L   D0,D6
    BGE.W   .final_row

    MOVE.L  D7,D0
    ADD.L   D6,D0
    MOVEQ   #48,D1
    CMP.L   D1,D0
    BLE.S   .row_index_no_wrap

    SUB.L   D1,D0
    BRA.S   .row_index_ready

.row_index_no_wrap:
    MOVE.L  D7,D0
    ADD.L   D6,D0

.row_index_ready:
    MOVE.L  D0,D5
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVEQ   #0,D1
    MOVE.W  _NEWGRID_ColumnWidthPx,D1
    MOVE.L  D0,20(A7)
    MOVE.L  D6,D0
    JSR     _GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  20(A7),D1
    ADD.L   D0,D1
    MOVEQ   #36,D0
    ADD.L   D0,D1
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVEQ   #0,D2
    MOVE.W  _NEWGRID_ColumnWidthPx,D2
    MOVE.L  D0,24(A7)
    MOVE.L  D6,D0
    MOVE.L  D1,20(A7)
    MOVE.L  D2,D1
    JSR     _GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  24(A7),D1
    ADD.L   D0,D1
    MOVEQ   #0,D0
    MOVE.W  D2,D0
    ADD.L   D0,D1
    MOVEQ   #35,D0
    ADD.L   D0,D1
    PEA     33.W
    MOVE.L  D1,-(A7)
    CLR.L   -(A7)
    MOVE.L  32(A7),-(A7)
    MOVE.L  _NEWGRID_MainRastPortPtr,-(A7)
    JSR     _BEVEL_DrawBevelFrameWithTopRight(PC)

    PEA     -89(A5)
    MOVE.L  D5,-(A7)
    BSR.W   CLEANUP_FormatClockFormatEntry

    LEA     28(A7),A7
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVEQ   #0,D1
    MOVE.W  _NEWGRID_ColumnWidthPx,D1
    MOVE.L  D0,20(A7)
    MOVE.L  D6,D0
    JSR     _GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  20(A7),D1
    ADD.L   D0,D1
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnWidthPx,D0
    LEA     -89(A5),A0
    MOVEA.L A0,A1

.measure_row_text_loop:
    TST.B   (A1)+
    BNE.S   .measure_row_text_loop

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  D0,24(A7)
    MOVE.L  D1,20(A7)
    MOVE.L  A1,D0
    MOVEA.L _NEWGRID_MainRastPortPtr,A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  24(A7),D1
    SUB.L   D0,D1
    SUBQ.L  #8,D1
    TST.L   D1
    BPL.S   .center_row_text_x

    ADDQ.L  #1,D1

.center_row_text_x:
    ASR.L   #1,D1
    MOVE.L  20(A7),D0
    ADD.L   D1,D0
    MOVEQ   #42,D1
    ADD.L   D1,D0
    MOVEA.L _NEWGRID_MainRastPortPtr,A1
    MOVEA.L 52(A1),A0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    MOVEQ   #34,D2
    SUB.L   D1,D2
    TST.L   D2
    BPL.S   .center_row_text_y

    ADDQ.L  #1,D2

.center_row_text_y:
    ASR.L   #1,D2
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    ADD.L   D1,D2
    SUBQ.L  #1,D2
    MOVE.L  D2,D1
    JSR     _LVOMove(A6)

    MOVEA.L _NEWGRID_MainRastPortPtr,A1
    MOVEQ   #3,D0
    JSR     _LVOSetAPen(A6)

    LEA     -89(A5),A0
    MOVEA.L A0,A1

.draw_row_text_loop:
    TST.B   (A1)+
    BNE.S   .draw_row_text_loop

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    MOVEA.L _NEWGRID_MainRastPortPtr,A1
    JSR     _LVOText(A6)

    ADDQ.L  #1,D6
    BRA.W   .row_loop

.final_row:
    MOVEQ   #2,D6
    MOVE.L  D7,D0
    ADD.L   D6,D0
    MOVEQ   #48,D1
    CMP.L   D1,D0
    BLE.S   .final_index_no_wrap

    SUB.L   D1,D0
    BRA.S   .final_index_ready

.final_index_no_wrap:
    MOVE.L  D7,D0
    ADD.L   D6,D0

.final_index_ready:
    MOVE.L  D0,D5
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVEQ   #0,D1
    MOVE.W  _NEWGRID_ColumnWidthPx,D1
    MOVE.L  D0,20(A7)
    MOVE.L  D6,D0
    JSR     _GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  20(A7),D1
    ADD.L   D0,D1
    MOVEQ   #36,D0
    ADD.L   D0,D1
    PEA     33.W
    PEA     695.W
    CLR.L   -(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  _NEWGRID_MainRastPortPtr,-(A7)
    JSR     _BEVEL_DrawBevelFrameWithTopRight(PC)

    PEA     -89(A5)
    MOVE.L  D5,-(A7)
    BSR.W   CLEANUP_FormatClockFormatEntry

    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVEQ   #0,D1
    MOVE.W  _NEWGRID_ColumnWidthPx,D1
    MOVE.L  D0,48(A7)
    MOVE.L  D6,D0
    JSR     _GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  48(A7),D1
    ADD.L   D0,D1
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnWidthPx,D0
    LEA     -89(A5),A0
    MOVEA.L A0,A1

.measure_final_text_loop:
    TST.B   (A1)+
    BNE.S   .measure_final_text_loop

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  D0,52(A7)
    MOVE.L  D1,48(A7)
    MOVE.L  A1,D0
    MOVEA.L _NEWGRID_MainRastPortPtr,A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  52(A7),D1
    SUB.L   D0,D1
    SUBQ.L  #8,D1
    TST.L   D1
    BPL.S   .center_final_text_x

    ADDQ.L  #1,D1

.center_final_text_x:
    ASR.L   #1,D1
    MOVE.L  48(A7),D0
    ADD.L   D1,D0
    MOVEQ   #42,D1
    ADD.L   D1,D0
    MOVEA.L _NEWGRID_MainRastPortPtr,A1
    MOVEA.L 52(A1),A0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    MOVEQ   #34,D2
    SUB.L   D1,D2
    TST.L   D2
    BPL.S   .center_final_text_y

    ADDQ.L  #1,D2

.center_final_text_y:
    ASR.L   #1,D2
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    ADD.L   D1,D2
    SUBQ.L  #1,D2
    MOVE.L  D2,D1
    JSR     _LVOMove(A6)

    MOVEA.L _NEWGRID_MainRastPortPtr,A1
    MOVEQ   #3,D0
    JSR     _LVOSetAPen(A6)

    LEA     -89(A5),A0
    MOVEA.L A0,A1

.draw_final_text_loop:
    TST.B   (A1)+
    BNE.S   .draw_final_text_loop

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    MOVEA.L _NEWGRID_MainRastPortPtr,A1
    JSR     _LVOText(A6)

    MOVEM.L -120(A5),D2-D3/D5-D7
    UNLK    A5
    RTS

;!======