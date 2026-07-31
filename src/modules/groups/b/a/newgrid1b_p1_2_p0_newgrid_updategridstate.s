    XDEF    _NEWGRID_UpdateGridState



;------------------------------------------------------------------------------
; FUNC: _NEWGRID_UpdateGridState   (Advance grid state machine)
; ARGS:
;   stack +8: A3 = grid struct
;   stack +12: D7 = key/index
;   stack +18: D6 = row index
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _NEWGRID_UpdatePresetEntry, _NEWGRID_DrawEntryFlagBadge,
;   _NEWGRID_DrawGridFrameAndRows, _NEWGRID2_JMPTBL_ESQ_TestBit1Based, _NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex, _NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount
; READS:
;   _NEWGRID_GridStateFrameLatch
; WRITES:
;   _NEWGRID_GridStateFrameLatch, _NEWGRID_SelectedGridEntryPtr, 32(A3)
; DESC:
;   Updates grid state, resolves the selected entry, and redraws frame content.
; NOTES:
;   State machine uses _NEWGRID_GridStateFrameLatch values 4/5.
;------------------------------------------------------------------------------
_NEWGRID_UpdateGridState:
    LINK.W  A5,#-8
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.W  18(A5),D6
    MOVE.L  A3,D0
    BNE.S   .check_state

    MOVEQ   #4,D0
    MOVE.L  D0,_NEWGRID_GridStateFrameLatch
    BRA.W   .done

.check_state:
    MOVE.L  _NEWGRID_GridStateFrameLatch,D0
    MOVEQ   #5,D1
    CMP.L   D1,D0
    BNE.S   .state_is_five

    MOVEQ   #-1,D1
    MOVE.L  D1,32(A3)
    BRA.W   .update_frame_state

.state_is_five:
    SUBQ.L  #4,D0
    BNE.W   .force_state_4

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D7,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -8(A5)
    PEA     -4(A5)
    BSR.W   _NEWGRID_UpdatePresetEntry

    LEA     16(A7),A7
    MOVE.L  D0,D6
    TST.L   -4(A5)
    BEQ.W   .update_frame_state

    TST.L   -8(A5)
    BEQ.W   .update_frame_state

    MOVEA.L -4(A5),A0
    ADDA.W  #$1c,A0
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _NEWGRID2_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.S   .update_frame_state

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     _NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex(PC)

    MOVE.L  D0,D6
    MOVE.L  -4(A5),(A7)
    BSR.W   _NEWGRID_SelectEntryPen

    LEA     12(A7),A7
    MOVEA.L -8(A5),A0
    MOVEA.L A0,A1
    ADDA.W  D6,A1
    MOVE.L  D0,_NEWGRID_SelectedGridEntryPtr
    BTST    #2,7(A1)
    BEQ.S   .set_entry_mode

    MOVEQ   #5,D0
    MOVE.L  D0,_NEWGRID_SelectedGridEntryPtr

.set_entry_mode:
    LEA     60(A3),A1
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    ASL.L   #2,D1
    ADDA.L  D1,A0
    MOVE.L  _NEWGRID_OverridePenIndex,-(A7)
    MOVE.L  56(A0),-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  A1,-(A7)
    BSR.W   _NEWGRID_DrawEntryFlagBadge

    CLR.L   (A7)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(PC)

    LEA     20(A7),A7
    MOVE.L  D0,32(A3)
    BRA.S   .update_frame_state

.force_state_4:
    MOVEQ   #4,D0
    MOVE.L  D0,_NEWGRID_GridStateFrameLatch

.update_frame_state:
    MOVE.L  _NEWGRID_SelectedGridEntryPtr,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_DrawGridFrameAndRows

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .set_state_4

    MOVEQ   #4,D0
    BRA.S   .store_state

.set_state_4:
    MOVEQ   #5,D0

.store_state:
    MOVE.L  D0,_NEWGRID_GridStateFrameLatch

.done:
    MOVEM.L (A7)+,D6-D7/A3
    UNLK    A5
    RTS

;!======