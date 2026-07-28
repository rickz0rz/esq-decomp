    XDEF    _NEWGRID_HandleAltGridState


;------------------------------------------------------------------------------
; FUNC: _NEWGRID_HandleAltGridState   (Handle alternate grid state)
; ARGS:
;   stack +8: A3 = rastport
;   stack +12: D7 = entry index
;   stack +18: D6 = selector
; RET:
;   D0: state (_NEWGRID_AltGridStateLatch)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _NEWGRID_DrawGridEntry, _NEWGRID_DrawGridFrameAlt, _NEWGRID_DrawGridCell,
;   _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode, _NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode, _NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex, _NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex, _NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams, _NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount
; READS:
;   _NEWGRID_ShowtimeEntryVariantFlag, _CLOCK_DaySlotIndex
; WRITES:
;   _NEWGRID_AltGridStateLatch, 32(A3)
; DESC:
;   State machine that draws a single grid entry and updates the frame.
; NOTES:
;   Uses _NEWGRID_AltGridStateLatch values 4/5.
;------------------------------------------------------------------------------
_NEWGRID_HandleAltGridState:
    LINK.W  A5,#-8
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.W  18(A5),D6
    MOVE.L  A3,D0
    BNE.S   .state_dispatch_check

    MOVEQ   #4,D0
    MOVE.L  D0,_NEWGRID_AltGridStateLatch
    BRA.W   .return_state

.state_dispatch_check:
    MOVE.L  _NEWGRID_AltGridStateLatch,D0
    SUBQ.L  #4,D0
    BEQ.S   .state4_begin

    SUBQ.L  #1,D0
    BEQ.W   .state5_frame_only

    BRA.W   .force_state4

.state4_begin:
    PEA     1.W
    MOVE.L  D7,-(A7)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    PEA     1.W
    MOVE.L  D7,-(A7)
    MOVE.L  D0,-4(A5)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-8(A5)
    TST.L   D0
    BEQ.S   .have_entry_ptrs

    MOVEQ   #1,D1
    CMP.W   D1,D6
    BEQ.S   .use_alt_entry_table

    PEA     _CLOCK_DaySlotIndex
    JSR     _NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(PC)

    ADDQ.W  #4,A7
    SUBQ.W  #1,D0
    BNE.S   .have_entry_ptrs

.use_alt_entry_table:
    MOVE.L  -8(A5),-(A7)
    JSR     _NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex(PC)

    MOVE.L  D0,D7
    PEA     2.W
    MOVE.L  D7,-(A7)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    PEA     2.W
    MOVE.L  D7,-(A7)
    MOVE.L  D0,-4(A5)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

    LEA     20(A7),A7
    MOVE.L  D0,-8(A5)

.have_entry_ptrs:
    TST.L   -4(A5)
    BEQ.W   .return_state

    TST.L   -8(A5)
    BEQ.W   .return_state

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -8(A5),A0
    TST.L   56(A0,D0.L)
    BEQ.W   .return_state

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L 56(A0,D0.L),A0
    TST.B   (A0)
    BEQ.W   .return_state

    MOVE.W  _NEWGRID_ColumnWidthPx,D0
    MULU    #3,D0
    MOVEQ   #12,D1
    SUB.L   D1,D0
    PEA     1.W
    PEA     20.W
    MOVE.L  D0,-(A7)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(PC)

    LEA     12(A7),A7
    TST.W   _NEWGRID_ShowtimeEntryVariantFlag
    BEQ.S   .draw_entry_mode2

    LEA     60(A3),A0
    MOVE.L  D6,D0
    EXT.L   D0
    PEA     4.W
    PEA     1.W
    PEA     2.W
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   _NEWGRID_DrawGridEntry

    LEA     28(A7),A7
    BRA.S   .after_entry_draw

.draw_entry_mode2:
    LEA     60(A3),A0
    MOVE.L  D6,D0
    EXT.L   D0
    PEA     4.W
    PEA     1.W
    PEA     3.W
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   _NEWGRID_DrawGridEntry

    LEA     28(A7),A7

.after_entry_draw:
    PEA     2.W
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(PC)

    MOVE.L  D0,32(A3)
    MOVE.L  A3,(A7)
    BSR.W   _NEWGRID_DrawGridFrameAlt

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .set_state5_after_draw

    MOVEQ   #4,D0
    BRA.S   .store_state_and_linecount

.set_state5_after_draw:
    MOVEQ   #5,D0

.store_state_and_linecount:
    LEA     60(A3),A0
    MOVE.L  D0,_NEWGRID_AltGridStateLatch
    SUBQ.L  #4,D0
    BNE.S   .set_draw_flag

    MOVEQ   #1,D0
    BRA.S   .draw_cell

.set_draw_flag:
    MOVEQ   #0,D0

.draw_cell:
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   _NEWGRID_DrawGridCell

    LEA     12(A7),A7
    BRA.S   .return_state

.state5_frame_only:
    MOVEQ   #-1,D0
    MOVE.L  D0,32(A3)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_DrawGridFrameAlt

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .state5_keep_state5

    MOVEQ   #4,D0
    BRA.S   .state5_store_state_and_reset_linecount

.state5_keep_state5:
    MOVEQ   #5,D0

.state5_store_state_and_reset_linecount:
    MOVE.L  D0,_NEWGRID_AltGridStateLatch
    BRA.S   .return_state

.force_state4:
    MOVEQ   #4,D0
    MOVE.L  D0,_NEWGRID_AltGridStateLatch

.return_state:
    MOVE.L  _NEWGRID_AltGridStateLatch,D0
    MOVEM.L (A7)+,D6-D7/A3
    UNLK    A5
    RTS

;!======