    XDEF    _ED2_HandleScrollSpeedSelection


;------------------------------------------------------------------------------
; FUNC: _ED2_HandleScrollSpeedSelection   (Handle scroll speed selectionuncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A7/D0/D1
; CALLS:
;   _ED_DrawESCMenuBottomHelp, _ED_DrawMenuSelectionHighlight, _ED_DrawScrollSpeedMenuText
; READS:
;   _ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED, _ED_EditCursorOffset, _ED_LastKeyCode, _ED_LastMenuInputChar, _ED_StateRingIndex, _ED_StateRingTable, case_adjust_selection_default, return
; WRITES:
;   _ED_LastKeyCode, _ED_LastMenuInputChar, _ED_SavedScrollSpeedIndex, _ESQPARS2_StateIndex, _ED_EditCursorOffset
; DESC:
;   Updates scroll speed/selection state based on menu codes and redraws help.
; NOTES:
;   Special-cases selection codes 13/27 and $9Buncertain to adjust _ED_EditCursorOffset/_ESQPARS2_StateIndex.
;------------------------------------------------------------------------------
_ED2_HandleScrollSpeedSelection:
    MOVE.L  _ED_StateRingIndex,D0
    LSL.L   #2,D0
    ADD.L   _ED_StateRingIndex,D0
    LEA     _ED_StateRingTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.B  (A1),D1
    MOVE.B  D1,_ED_LastKeyCode
    ADDA.L  D0,A0
    MOVE.B  1(A0),_ED_LastMenuInputChar
    MOVEQ   #0,D0
    MOVE.B  _ED_LastKeyCode,D0
    SUBI.W  #13,D0
    BEQ.S   .case_sync_scroll_speed

    SUBI.W  #14,D0
    BEQ.S   .case_sync_scroll_speed

    SUBI.W  #$80,D0
    BEQ.S   .case_adjust_selection_key

    BRA.W   .case_adjust_selection_default

.case_sync_scroll_speed:
    MOVE.L  _ED_EditCursorOffset,D0
    MOVE.L  D0,_ED_SavedScrollSpeedIndex
    TST.L   _ED_EditCursorOffset
    BNE.S   .use_21e8_minus1

    MOVEQ   #0,D0
    MOVE.B  _ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED,D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVE.W  D0,_ESQPARS2_StateIndex
    BRA.S   .after_sync_scroll_speed

.use_21e8_minus1:
    MOVE.L  _ED_EditCursorOffset,D0
    SUBQ.L  #1,D0
    MOVE.W  D0,_ESQPARS2_StateIndex

.after_sync_scroll_speed:
    JSR     _ED_DrawESCMenuBottomHelp(PC)

    BRA.W   .return

.case_adjust_selection_key:
    MOVE.B  _ED_LastMenuInputChar,D0
    MOVEQ   #65,D1
    CMP.B   D1,D0
    BNE.S   .case_increment_selection_key

    SUBQ.L  #1,_ED_EditCursorOffset
    BGE.S   .after_selection_update

    MOVEQ   #8,D0
    MOVE.L  D0,_ED_EditCursorOffset
    BRA.S   .after_selection_update

.case_increment_selection_key:
    ADDQ.L  #1,_ED_EditCursorOffset
    MOVEQ   #1,D0
    CMP.L   _ED_EditCursorOffset,D0
    BNE.S   .case_wrap_selection_key

    MOVEQ   #3,D0
    MOVE.L  D0,_ED_EditCursorOffset
    BRA.S   .after_selection_update

.case_wrap_selection_key:
    MOVEQ   #9,D0
    CMP.L   _ED_EditCursorOffset,D0
    BNE.S   .after_selection_update

    CLR.L   _ED_EditCursorOffset

.after_selection_update:
    PEA     9.W
    JSR     _ED_DrawMenuSelectionHighlight(PC)

    JSR     _ED_DrawScrollSpeedMenuText(PC)

    ADDQ.W  #4,A7
    BRA.S   .return

.case_adjust_selection_default:
    ADDQ.L  #1,_ED_EditCursorOffset
    MOVEQ   #1,D0
    CMP.L   _ED_EditCursorOffset,D0
    BNE.S   .case_wrap_selection_default

    MOVEQ   #3,D0
    MOVE.L  D0,_ED_EditCursorOffset
    BRA.S   .after_default_update

.case_wrap_selection_default:
    MOVEQ   #9,D0
    CMP.L   _ED_EditCursorOffset,D0
    BNE.S   .after_default_update

    CLR.L   _ED_EditCursorOffset

.after_default_update:
    PEA     9.W
    JSR     _ED_DrawMenuSelectionHighlight(PC)

    JSR     _ED_DrawScrollSpeedMenuText(PC)

    ADDQ.W  #4,A7

.return:
    RTS
