    XDEF    _NEWGRID_UpdateSelectionFromInputAlt


;------------------------------------------------------------------------------
; FUNC: _NEWGRID_UpdateSelectionFromInputAlt   (Alternate selection scan with eligibility checks)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
; RET:
;   D0: selection found flag (0/1)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _NEWGRID_ClearMarkersIfSelectable, _NEWGRID_TestEntrySelectable,
;   _NEWGRID_UpdatePresetEntry, _NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex, _NEWGRID2_JMPTBL_ESQ_TestBit1Based, _NEWGRID2_JMPTBL_COI_ProcessEntrySelectionState, _TEXTDISP_JMPTBL_ESQDISP_TestEntryGridEligibility
; READS:
;   _NEWGRID_AltSelectionRowCursor/203A, _TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_PrimaryGroupPresentFlag
; WRITES:
;   _NEWGRID_AltSelectionRowCursor/203A, selection state fields
; DESC:
;   Alternate selection state machine with a jump-table dispatch.
; NOTES:
;   Uses a switch/jumptable for state dispatch.
;------------------------------------------------------------------------------
_NEWGRID_UpdateSelectionFromInputAlt:
    LINK.W  A5,#-16
    MOVEM.L D4-D7/A3,-(A7)
    MOVE.L  8(A5),D7
    MOVEA.L 12(A5),A3
    MOVE.L  16(A5),D6
    MOVEQ   #0,D5
    MOVE.L  D7,D0
    CMPI.L  #$6,D0
    BCC.S   .state_default

    ADD.W   D0,D0
    MOVE.W  .state_jumptable(PC,D0.W),D0
    JMP     .state_jumptable+2(PC,D0.W)

; switch/jumptable
.state_jumptable:
    DC.W    .case_state0-.state_jumptable-2
    DC.W    .case_state1-.state_jumptable-2
    DC.W    .state_default-.state_jumptable-2
    DC.W    .case_state3_or5-.state_jumptable-2
    DC.W    .case_state2-.state_jumptable-2
    DC.W    .case_state3_or5-.state_jumptable-2

.case_state0:
    CLR.L   (_NEWGRID_AltSelectionRowCursor).L
    MOVE.W  22(A3),D0
    MOVE.W  D0,_NEWGRID_AltSelectionEntryCursor
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  D6,-(A7)
    BSR.W   _NEWGRID_ClearMarkersIfSelectable

    ADDQ.W  #8,A7
    BRA.S   .post_state

.case_state1:
    ADDQ.L  #1,_NEWGRID_AltSelectionRowCursor
    MOVE.W  22(A3),_NEWGRID_AltSelectionEntryCursor
    BRA.S   .post_state

.case_state2:
    ADDQ.W  #1,_NEWGRID_AltSelectionEntryCursor
    BRA.S   .post_state

.case_state3_or5:
    MOVEQ   #1,D5
    BRA.S   .post_state

.state_default:
    MOVEQ   #5,D7

.post_state:
    TST.L   D5
    BNE.W   .maybe_clear_state

.scan_loop:
    TST.L   D5
    BNE.W   .finalize_selection

    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    MOVE.L  _NEWGRID_AltSelectionRowCursor,D1
    CMP.L   D0,D1
    BGE.W   .finalize_selection

    TST.B   _TEXTDISP_PrimaryGroupPresentFlag
    BEQ.W   .finalize_selection

    MOVEQ   #5,D0
    CMP.L   D0,D7
    BEQ.W   .finalize_selection

    MOVE.W  _NEWGRID_AltSelectionEntryCursor,D0
    EXT.L   D0
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -8(A5)
    PEA     -4(A5)
    BSR.W   _NEWGRID_UpdatePresetEntry

    MOVE.L  D6,(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    BSR.W   _NEWGRID_TestEntrySelectable

    LEA     24(A7),A7
    TST.L   D0
    BEQ.W   .scan_reset

.entry_loop:
    TST.L   D5
    BNE.W   .scan_reset

    MOVE.W  _NEWGRID_AltSelectionEntryCursor,D0
    TST.W   D0
    BLE.W   .scan_reset

    CMP.W   24(A3),D0
    BGE.W   .scan_reset

    MOVEQ   #49,D1
    CMP.W   D1,D0
    BNE.S   .adjust_index

    EXT.L   D0
    MOVE.L  _NEWGRID_AltSelectionRowCursor,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -8(A5)
    PEA     -4(A5)
    BSR.W   _NEWGRID_UpdatePresetEntry

    LEA     16(A7),A7
    MOVE.L  D0,D4
    BRA.S   .after_adjust

.adjust_index:
    MOVE.L  D0,D4
    MOVEQ   #48,D1
    CMP.W   D1,D4
    BLE.S   .after_adjust

    SUBI.W  #$30,D4

.after_adjust:
    TST.L   -4(A5)
    BEQ.W   .entry_loop_next

    TST.L   -8(A5)
    BEQ.W   .entry_loop_next

    MOVE.W  _NEWGRID_AltSelectionEntryCursor,D0
    CMP.W   22(A3),D0
    BNE.S   .check_flags

    MOVE.L  D4,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     _NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D4

.check_flags:
    TST.W   D4
    BLE.W   .set_found_false

    MOVEA.L -4(A5),A0
    ADDA.W  #$1c,A0
    MOVE.L  D4,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _NEWGRID2_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.S   .set_found_false

    MOVEA.L -8(A5),A0
    MOVEA.L A0,A1
    ADDA.W  D4,A1
    BTST    #5,7(A1)
    BNE.S   .set_found_false

    MOVEA.L A0,A1
    ADDA.W  _NEWGRID_AltSelectionEntryCursor,A1
    BTST    #7,7(A1)
    BNE.S   .set_found_false

    MOVE.L  D4,D0
    EXT.L   D0
    ASL.L   #2,D0
    ADDA.L  D0,A0
    TST.L   56(A0)
    BEQ.S   .set_found_false

    MOVE.L  D4,D0
    EXT.L   D0
    MOVE.L  _CONFIG_TimeWindowMinutes,-(A7)
    PEA     1440.W
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     _NEWGRID2_JMPTBL_COI_ProcessEntrySelectionState(PC)

    LEA     20(A7),A7
    TST.L   D0
    BEQ.S   .set_found_false

    MOVEQ   #1,D0
    CMP.L   D0,D6
    BNE.S   .mark_match

    MOVE.L  D4,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    JSR     _TEXTDISP_JMPTBL_ESQDISP_TestEntryGridEligibility(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .set_found_false

.mark_match:
    MOVEQ   #1,D1
    BRA.S   .store_found

.set_found_false:
    MOVEQ   #0,D1

.store_found:
    MOVE.L  D1,D5

.entry_loop_next:
    TST.L   D5
    BNE.W   .entry_loop

    ADDQ.W  #1,_NEWGRID_AltSelectionEntryCursor
    BRA.W   .entry_loop

.scan_reset:
    TST.L   D5
    BNE.W   .scan_loop

    MOVEQ   #4,D0
    CMP.L   D0,D7
    BNE.S   .advance_row

    MOVEQ   #5,D7
    BRA.W   .scan_loop

.advance_row:
    MOVE.W  22(A3),_NEWGRID_AltSelectionEntryCursor
    ADDQ.L  #1,_NEWGRID_AltSelectionRowCursor
    BRA.W   .scan_loop

.finalize_selection:
    TST.L   D5
    BEQ.S   .maybe_clear_state

    MOVEQ   #5,D0
    CMP.L   D0,D7
    BEQ.S   .maybe_clear_state

    MOVE.L  -4(A5),(A3)
    MOVE.L  -8(A5),4(A3)
    MOVE.L  _NEWGRID_AltSelectionRowCursor,8(A3)
    CMPI.W  #'0',_NEWGRID_AltSelectionEntryCursor
    BLE.S   .set_offset_flag

    MOVEQ   #49,D0
    CMP.W   D0,D4
    BGE.S   .set_offset_flag

    MOVEQ   #48,D0
    BRA.S   .apply_offset

.set_offset_flag:
    MOVEQ   #0,D0

.apply_offset:
    MOVE.L  D4,D1
    EXT.L   D1
    ADD.L   D0,D1
    MOVE.W  D1,20(A3)
    MOVEA.L -8(A5),A0
    ADDA.W  D4,A0
    BSET    #5,7(A0)

.maybe_clear_state:
    TST.L   D5
    BNE.S   .return

    SUBA.L  A0,A0
    MOVE.L  A0,(A3)
    MOVE.L  A0,4(A3)

.return:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======