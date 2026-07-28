    XDEF    _NEWGRID_HandleDetailGridState


;------------------------------------------------------------------------------
; FUNC: _NEWGRID_HandleDetailGridState   (Handle detailed grid state)
; ARGS:
;   stack +8: A3 = rastport
;   stack +12: D7 = entry index
;   stack +18: D6 = selector
; RET:
;   D0: state (NEWGRID_DetailGridStateLatch)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   NEWGRID_UpdatePresetEntry, _NEWGRID_DrawGridEntry,
;   _NEWGRID_DrawGridFrameVariant2, _NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams, NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex, _NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer, _NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount
; READS:
;   _GCOMMAND_MplexDetailLayoutPen, _GCOMMAND_MplexDetailLayoutFlag, _GCOMMAND_MplexDetailInitialLineIndex
; WRITES:
;   NEWGRID_DetailGridStateLatch, 32(A3)
; DESC:
;   State machine that formats entry text and redraws the detailed grid view.
; NOTES:
;   Uses NEWGRID_DetailGridStateLatch values 4/5.
;------------------------------------------------------------------------------
_NEWGRID_HandleDetailGridState:
    LINK.W  A5,#-60
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.W  18(A5),D6
    SUBA.L  A0,A0
    MOVE.L  A0,-4(A5)
    MOVE.L  A0,-8(A5)
    MOVE.L  A3,D0
    BNE.S   .state_dispatch_check

    MOVEQ   #4,D0
    MOVE.L  D0,NEWGRID_DetailGridStateLatch
    BRA.W   .return_state

.state_dispatch_check:
    MOVE.L  NEWGRID_DetailGridStateLatch,D0
    SUBQ.L  #4,D0
    BEQ.S   .state4_begin

    SUBQ.L  #1,D0
    BEQ.W   .state5_frame_only

    BRA.W   .force_state4

.state4_begin:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D7,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -8(A5)
    PEA     -4(A5)
    BSR.W   NEWGRID_UpdatePresetEntry

    LEA     16(A7),A7
    MOVE.L  D0,D6
    TST.L   -4(A5)
    BEQ.W   .return_state

    TST.L   -8(A5)
    BEQ.W   .return_state

    MOVE.L  _GCOMMAND_MplexDetailLayoutPen,-(A7)
    PEA     20.W
    PEA     612.W
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(PC)

    LEA     12(A7),A7
    MOVE.B  _GCOMMAND_MplexDetailLayoutFlag,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BNE.S   .draw_entry_mode2

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
    BRA.S   .after_draw

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

.after_draw:
    MOVE.L  _GCOMMAND_MplexDetailInitialLineIndex,-(A7)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex(PC)

    MOVEA.L -4(A5),A0
    MOVEA.L A0,A1
    ADDA.W  #19,A1
    LEA     1(A0),A2
    MOVE.L  A2,(A7)
    MOVE.L  A1,-(A7)
    PEA     NEWGRID_ChannelRowFmt
    PEA     -58(A5)
    JSR     _PARSEINI_JMPTBL_WDISP_SPrintf(PC)

    LEA     60(A3),A0
    PEA     -58(A5)
    MOVE.L  A0,-(A7)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(PC)

    MOVE.L  A3,(A7)
    BSR.W   _NEWGRID_DrawGridFrameVariant2

    LEA     24(A7),A7
    TST.L   D0
    BEQ.S   .set_state5_after_draw

    MOVEQ   #4,D0
    BRA.S   .store_state_and_linecount

.set_state5_after_draw:
    MOVEQ   #5,D0

.store_state_and_linecount:
    PEA     2.W
    MOVE.L  D0,NEWGRID_DetailGridStateLatch
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,32(A3)
    BRA.S   .return_state

.state5_frame_only:
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_DrawGridFrameVariant2

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .state5_keep_state5

    MOVEQ   #4,D0
    BRA.S   .state5_store_state_and_reset_linecount

.state5_keep_state5:
    MOVEQ   #5,D0

.state5_store_state_and_reset_linecount:
    MOVEQ   #-1,D1
    MOVE.L  D1,32(A3)
    MOVE.L  D0,NEWGRID_DetailGridStateLatch
    BRA.S   .return_state

.force_state4:
    MOVEQ   #4,D0
    MOVE.L  D0,NEWGRID_DetailGridStateLatch

.return_state:
    MOVE.L  NEWGRID_DetailGridStateLatch,D0
    MOVEM.L (A7)+,D6-D7/A2-A3
    UNLK    A5
    RTS

;!======