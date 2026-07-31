    XDEF    _NEWGRID_HandleShowtimesState


;------------------------------------------------------------------------------
; FUNC: _NEWGRID_HandleShowtimesState   (Execute one step of showtimes/detail grid state machine)
; ARGS:
;   stack +8: A3 = rastport
;   stack +12: A2 = entry state
; RET:
;   D0: state (_NEWGRID_ShowtimesWorkflowStateLatch)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _NEWGRID_DrawGridEntry, _NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex, _NEWGRID_BuildShowtimesText, _NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer,
;   _NEWGRID_DrawGridFrameVariant3, _NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount, _NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams
; READS:
;   _NEWGRID_ShowtimesWorkflowStateLatch, _GCOMMAND_PpvShowtimesLayoutPen, _GCOMMAND_PpvShowtimesInitialLineIndex, _GCOMMAND_PpvDetailLayoutFlag
; WRITES:
;   _NEWGRID_ShowtimesWorkflowStateLatch, 32(A3)
; DESC:
;   State machine that draws showtimes/details in a grid view.
;------------------------------------------------------------------------------
_NEWGRID_HandleShowtimesState:
    LINK.W  A5,#-132
    MOVEM.L D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  A3,D0
    BNE.S   .state_check

    MOVEQ   #4,D0
    MOVE.L  D0,_NEWGRID_ShowtimesWorkflowStateLatch
    BRA.W   .return_state

.state_check:
    MOVE.L  _NEWGRID_ShowtimesWorkflowStateLatch,D0
    SUBQ.L  #4,D0
    BEQ.S   .state4_begin

    SUBQ.L  #1,D0
    BEQ.W   .state5_reset

    BRA.W   .force_state4

.state4_begin:
    TST.L   (A2)
    BEQ.W   .return_state

    TST.L   4(A2)
    BEQ.W   .return_state

    MOVE.L  _GCOMMAND_PpvShowtimesLayoutPen,-(A7)
    PEA     20.W
    PEA     612.W
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(PC)

    LEA     12(A7),A7
    MOVE.W  20(A2),D7
    MOVEQ   #48,D0
    CMP.W   D0,D7
    BLE.S   .adjust_row

    SUBI.W  #$30,D7

.adjust_row:
    MOVE.B  _GCOMMAND_PpvDetailLayoutFlag,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BNE.S   .draw_entry_mode2

    LEA     60(A3),A0
    MOVE.L  D7,D0
    EXT.L   D0
    PEA     -1.W
    PEA     1.W
    PEA     2.W
    MOVE.L  D0,-(A7)
    MOVE.L  4(A2),-(A7)
    MOVE.L  (A2),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   _NEWGRID_DrawGridEntry

    LEA     28(A7),A7
    BRA.S   .after_draw

.draw_entry_mode2:
    LEA     60(A3),A0
    MOVE.L  D7,D0
    EXT.L   D0
    PEA     -1.W
    PEA     1.W
    PEA     3.W
    MOVE.L  D0,-(A7)
    MOVE.L  4(A2),-(A7)
    MOVE.L  (A2),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   _NEWGRID_DrawGridEntry

    LEA     28(A7),A7

.after_draw:
    MOVE.L  _GCOMMAND_PpvShowtimesInitialLineIndex,-(A7)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex(PC)

    PEA     -130(A5)
    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_BuildShowtimesText

    LEA     60(A3),A0
    PEA     -130(A5)
    MOVE.L  A0,-(A7)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(PC)

    MOVE.L  A3,(A7)
    BSR.W   _NEWGRID_DrawGridFrameVariant3

    LEA     24(A7),A7
    TST.L   D0
    BEQ.S   .store_state

    MOVEQ   #4,D0
    BRA.S   .store_state2

.store_state:
    MOVEQ   #5,D0

.store_state2:
    PEA     2.W
    MOVE.L  D0,_NEWGRID_ShowtimesWorkflowStateLatch
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,32(A3)
    BRA.S   .return_state

.state5_reset:
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_DrawGridFrameVariant3

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .state5_done

    MOVEQ   #4,D0
    BRA.S   .store_state3

.state5_done:
    MOVEQ   #5,D0

.store_state3:
    MOVEQ   #-1,D1
    MOVE.L  D1,32(A3)
    MOVE.L  D0,_NEWGRID_ShowtimesWorkflowStateLatch
    BRA.S   .return_state

.force_state4:
    MOVEQ   #4,D0
    MOVE.L  D0,_NEWGRID_ShowtimesWorkflowStateLatch

.return_state:
    MOVE.L  _NEWGRID_ShowtimesWorkflowStateLatch,D0
    MOVEM.L (A7)+,D7/A2-A3
    UNLK    A5
    RTS

;!======