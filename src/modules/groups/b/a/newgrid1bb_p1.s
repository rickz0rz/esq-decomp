    XDEF    NEWGRID_AppendShowtimesForRow
    XDEF    NEWGRID_ClearMarkersIfSelectable
    XDEF    NEWGRID_DrawGridFrameVariant4
    XDEF    NEWGRID_DrawShowtimesPrompt
    XDEF    NEWGRID_InitSelectionWindowAlt
    XDEF    NEWGRID_TestEntrySelectable
    XDEF    NEWGRID_TestPrimeTimeWindow
    XDEF    NEWGRID_UpdateSelectionFromInputAlt


;------------------------------------------------------------------------------
; FUNC: NEWGRID_TestEntrySelectable   (Test whether entry is selectable under current mode)
; ARGS:
;   stack +8: A3 = entry header
;   stack +12: A2 = entry data
;   stack +16: D7 = mode selector (0/1)
; RET:
;   D0: 1 if selectable, 0 otherwise
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   NEWGRID2_JMPTBL_ESQDISP_TestEntryBits0And2
; READS:
;   27(A3), 40(A3)
; DESC:
;   Checks entry flags and mode rules to decide if selection is allowed.
;------------------------------------------------------------------------------
NEWGRID_TestEntrySelectable:
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVEA.L 24(A7),A2
    MOVE.L  28(A7),D7
    MOVEQ   #0,D6
    TST.L   D7
    BEQ.S   .check_args

    MOVEQ   #1,D0
    CMP.L   D0,D7
    BNE.S   .return

.check_args:
    MOVE.L  A3,D0
    BEQ.S   .set_false

    MOVE.L  A2,D0
    BEQ.S   .set_false

    BTST    #7,40(A3)
    BEQ.S   .set_false

    TST.L   D7
    BNE.S   .check_mode1

    BTST    #2,27(A3)
    BNE.S   .set_true

.check_mode1:
    MOVEQ   #1,D0
    CMP.L   D0,D7
    BNE.S   .set_false

    MOVE.L  A3,-(A7)
    JSR     NEWGRID2_JMPTBL_ESQDISP_TestEntryBits0And2(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .set_false

.set_true:
    MOVEQ   #1,D1
    BRA.S   .store_result

.set_false:
    MOVEQ   #0,D1

.store_result:
    MOVE.L  D1,D6

.return:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7/A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_ClearMarkersIfSelectable   (Clear markers if selectable)
; ARGS:
;   (none observed)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0
; CALLS:
;   _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode, _NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode, NEWGRID_TestEntrySelectable
; READS:
;   _TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_SecondaryGroupEntryCount, _TEXTDISP_PrimaryGroupPresentFlag, _TEXTDISP_SecondaryGroupPresentFlag
; WRITES:
;   entry flag bytes (bit #5 cleared)
; DESC:
;   Clears marker bits for entries that pass selection checks.
;------------------------------------------------------------------------------
NEWGRID_ClearMarkersIfSelectable:
    LINK.W  A5,#-16
    MOVEM.L D4-D7,-(A7)
    MOVE.L  8(A5),D7
    MOVE.W  14(A5),D6
    MOVEQ   #1,D0
    CMP.W   D0,D6
    BLE.S   .list1_done

    MOVEQ   #0,D5

.list1_loop:
    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    CMP.L   D0,D5
    BGE.S   .list1_done

    TST.B   _TEXTDISP_PrimaryGroupPresentFlag
    BEQ.S   .list1_done

    PEA     1.W
    MOVE.L  D5,-(A7)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    PEA     1.W
    MOVE.L  D5,-(A7)
    MOVE.L  D0,-4(A5)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

    MOVE.L  D7,(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  D0,-8(A5)
    BSR.W   NEWGRID_TestEntrySelectable

    LEA     24(A7),A7
    TST.L   D0
    BEQ.S   .list1_next

    MOVEQ   #1,D4

.list1_clear_flags:
    MOVEQ   #49,D0
    CMP.L   D0,D4
    BGE.S   .list1_next

    MOVEA.L -8(A5),A0
    BCLR    #5,7(A0,D4.L)
    ADDQ.L  #1,D4
    BRA.S   .list1_clear_flags

.list1_next:
    ADDQ.L  #1,D5
    BRA.S   .list1_loop

.list1_done:
    MOVEQ   #0,D5

.list2_loop:
    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D0
    CMP.L   D0,D5
    BGE.S   .return

    TST.B   _TEXTDISP_SecondaryGroupPresentFlag
    BEQ.S   .return

    PEA     2.W
    MOVE.L  D5,-(A7)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    PEA     2.W
    MOVE.L  D5,-(A7)
    MOVE.L  D0,-4(A5)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

    MOVE.L  D7,(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  D0,-8(A5)
    BSR.W   NEWGRID_TestEntrySelectable

    LEA     24(A7),A7
    TST.L   D0
    BEQ.S   .list2_next

    MOVEQ   #1,D4

.list2_clear_flags:
    MOVEQ   #49,D0
    CMP.L   D0,D4
    BGE.S   .list2_next

    MOVEA.L -8(A5),A0
    BCLR    #5,7(A0,D4.L)
    ADDQ.L  #1,D4
    BRA.S   .list2_clear_flags

.list2_next:
    ADDQ.L  #1,D5
    BRA.S   .list2_loop

.return:
    MOVEM.L (A7)+,D4-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_InitSelectionWindowAlt   (Init selection window alt)
; ARGS:
;   (none observed)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex
; READS:
;   _CLOCK_DaySlotIndex, _CONFIG_NewgridWindowSpanHalfHoursPrimary, _CONFIG_NewgridWindowSpanHalfHoursAlt
; WRITES:
;   0(A3)..24(A3)
; DESC:
;   Initializes selection bounds using an alternate mode offset.
;------------------------------------------------------------------------------
NEWGRID_InitSelectionWindowAlt:
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.W  26(A7),D7
    MOVE.L  28(A7),D6
    MOVE.L  A3,D0
    BEQ.S   .return

    SUBA.L  A0,A0
    MOVE.L  A0,(A3)
    MOVE.L  A0,4(A3)
    CLR.L   8(A3)
    MOVE.W  D7,20(A3)
    MOVEQ   #48,D0
    CMP.W   D0,D7
    BGE.S   .compute_bounds

    MOVEQ   #1,D0
    CMP.W   D0,D7
    BEQ.S   .adjust_row

    PEA     _CLOCK_DaySlotIndex
    JSR     _NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(PC)

    ADDQ.W  #4,A7
    SUBQ.W  #1,D0
    BNE.S   .compute_bounds

.adjust_row:
    MOVEQ   #48,D0
    ADD.W   D0,20(A3)

.compute_bounds:
    MOVE.W  20(A3),D0
    MOVE.W  D0,22(A3)
    TST.L   D6
    BNE.S   .mode_offset

    MOVE.B  _CONFIG_NewgridWindowSpanHalfHoursPrimary,D0
    EXT.W   D0
    EXT.L   D0
    BRA.S   .mode_offset_done

.mode_offset:
    MOVE.B  _CONFIG_NewgridWindowSpanHalfHoursAlt,D0
    EXT.W   D0
    EXT.L   D0

.mode_offset_done:
    MOVE.L  D0,D5
    MOVE.W  20(A3),D0
    EXT.L   D0
    ADD.L   D5,D0
    MOVE.W  D0,24(A3)
    MOVEQ   #96,D1
    CMP.W   D1,D0
    BLE.S   .clamp_end

    MOVE.W  D1,24(A3)

.clamp_end:
    ADDQ.W  #1,24(A3)

.return:
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_UpdateSelectionFromInputAlt   (Alternate selection scan with eligibility checks)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
; RET:
;   D0: selection found flag (0/1)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   NEWGRID_ClearMarkersIfSelectable, NEWGRID_TestEntrySelectable,
;   NEWGRID_UpdatePresetEntry, NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex, NEWGRID2_JMPTBL_ESQ_TestBit1Based, NEWGRID2_JMPTBL_COI_ProcessEntrySelectionState, TEXTDISP_JMPTBL_ESQDISP_TestEntryGridEligibility
; READS:
;   NEWGRID_AltSelectionRowCursor/203A, _TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_PrimaryGroupPresentFlag
; WRITES:
;   NEWGRID_AltSelectionRowCursor/203A, selection state fields
; DESC:
;   Alternate selection state machine with a jump-table dispatch.
; NOTES:
;   Uses a switch/jumptable for state dispatch.
;------------------------------------------------------------------------------
NEWGRID_UpdateSelectionFromInputAlt:
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
    CLR.L   (NEWGRID_AltSelectionRowCursor).L
    MOVE.W  22(A3),D0
    MOVE.W  D0,NEWGRID_AltSelectionEntryCursor
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  D6,-(A7)
    BSR.W   NEWGRID_ClearMarkersIfSelectable

    ADDQ.W  #8,A7
    BRA.S   .post_state

.case_state1:
    ADDQ.L  #1,NEWGRID_AltSelectionRowCursor
    MOVE.W  22(A3),NEWGRID_AltSelectionEntryCursor
    BRA.S   .post_state

.case_state2:
    ADDQ.W  #1,NEWGRID_AltSelectionEntryCursor
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
    MOVE.L  NEWGRID_AltSelectionRowCursor,D1
    CMP.L   D0,D1
    BGE.W   .finalize_selection

    TST.B   _TEXTDISP_PrimaryGroupPresentFlag
    BEQ.W   .finalize_selection

    MOVEQ   #5,D0
    CMP.L   D0,D7
    BEQ.W   .finalize_selection

    MOVE.W  NEWGRID_AltSelectionEntryCursor,D0
    EXT.L   D0
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -8(A5)
    PEA     -4(A5)
    BSR.W   NEWGRID_UpdatePresetEntry

    MOVE.L  D6,(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    BSR.W   NEWGRID_TestEntrySelectable

    LEA     24(A7),A7
    TST.L   D0
    BEQ.W   .scan_reset

.entry_loop:
    TST.L   D5
    BNE.W   .scan_reset

    MOVE.W  NEWGRID_AltSelectionEntryCursor,D0
    TST.W   D0
    BLE.W   .scan_reset

    CMP.W   24(A3),D0
    BGE.W   .scan_reset

    MOVEQ   #49,D1
    CMP.W   D1,D0
    BNE.S   .adjust_index

    EXT.L   D0
    MOVE.L  NEWGRID_AltSelectionRowCursor,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -8(A5)
    PEA     -4(A5)
    BSR.W   NEWGRID_UpdatePresetEntry

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

    MOVE.W  NEWGRID_AltSelectionEntryCursor,D0
    CMP.W   22(A3),D0
    BNE.S   .check_flags

    MOVE.L  D4,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex(PC)

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
    JSR     NEWGRID2_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.S   .set_found_false

    MOVEA.L -8(A5),A0
    MOVEA.L A0,A1
    ADDA.W  D4,A1
    BTST    #5,7(A1)
    BNE.S   .set_found_false

    MOVEA.L A0,A1
    ADDA.W  NEWGRID_AltSelectionEntryCursor,A1
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
    JSR     NEWGRID2_JMPTBL_COI_ProcessEntrySelectionState(PC)

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
    JSR     TEXTDISP_JMPTBL_ESQDISP_TestEntryGridEligibility(PC)

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

    ADDQ.W  #1,NEWGRID_AltSelectionEntryCursor
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
    MOVE.W  22(A3),NEWGRID_AltSelectionEntryCursor
    ADDQ.L  #1,NEWGRID_AltSelectionRowCursor
    BRA.W   .scan_loop

.finalize_selection:
    TST.L   D5
    BEQ.S   .maybe_clear_state

    MOVEQ   #5,D0
    CMP.L   D0,D7
    BEQ.S   .maybe_clear_state

    MOVE.L  -4(A5),(A3)
    MOVE.L  -8(A5),4(A3)
    MOVE.L  NEWGRID_AltSelectionRowCursor,8(A3)
    CMPI.W  #'0',NEWGRID_AltSelectionEntryCursor
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

;------------------------------------------------------------------------------
; FUNC: NEWGRID_AppendShowtimesForRow   (Append deduplicated showtimes for active row)
; ARGS:
;   stack +12: A3 = selection state
;   stack +16: A2 = output buffer
;   stack +20: D7 = mode selector
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   _NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer, TEXTDISP_JMPTBL_ESQDISP_TestEntryGridEligibility, _TEXTDISP_FormatEntryTimeForIndex, NEWGRID2_JMPTBL_ESQ_TestBit1Based, NEWGRID_UpdatePresetEntry, _NEWGRID2_JMPTBL_STR_SkipClass3Chars,
;   PARSEINI_JMPTBL_STRING_AppendAtNull
; READS:
;   _CONFIG_TimeWindowMinutes, NEWGRID_ShowtimeListSeparator
; WRITES:
;   output buffer contents
; DESC:
;   Scans rows and appends matching showtime strings into the buffer.
; NOTES:
;   Performs multiple field comparisons to coalesce identical showtimes.
;------------------------------------------------------------------------------
NEWGRID_AppendShowtimesForRow:
    LINK.W  A5,#-84
    MOVEM.L D5-D7/A2-A3/A6,-(A7)
    MOVEA.L 12(A5),A3
    MOVEA.L 16(A5),A2
    MOVE.L  20(A5),D7
    CLR.B   (A2)
    MOVE.W  20(A3),D5
    TST.L   (A3)
    BEQ.W   .return

    TST.L   4(A3)
    BEQ.W   .return

    MOVE.L  A2,D0
    BEQ.W   .return

    TST.W   D5
    BLE.W   .return

    MOVEQ   #97,D0
    CMP.W   D0,D5
    BGE.W   .return

    MOVEQ   #48,D0
    CMP.W   D0,D5
    BLE.S   .adjust_row_index

    SUBI.W  #$30,D5

.adjust_row_index:
    MOVEA.L 4(A3),A0
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L 56(A1),A6
    MOVE.L  A6,-36(A5)
    MOVE.L  A6,D0
    BEQ.W   .return

    TST.B   (A6)
    BEQ.W   .return

    MOVEQ   #40,D0
    CMP.B   (A6),D0
    BNE.S   .time_prefix_default

    MOVEQ   #58,D0
    CMP.B   3(A6),D0
    BNE.S   .time_prefix_default

    MOVEQ   #8,D0
    BRA.S   .time_prefix_done

.time_prefix_default:
    MOVEQ   #0,D0

.time_prefix_done:
    ADD.L   D0,-36(A5)
    MOVE.L  D5,D0
    EXT.L   D0
    PEA     1.W
    MOVE.L  D0,-(A7)
    MOVE.L  (A3),-(A7)
    JSR     _NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    MOVE.L  D5,D1
    EXT.L   D1
    PEA     2.W
    MOVE.L  D1,-(A7)
    MOVE.L  (A3),-(A7)
    MOVE.L  D0,-40(A5)
    JSR     _NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    MOVE.L  D5,D1
    EXT.L   D1
    PEA     6.W
    MOVE.L  D1,-(A7)
    MOVE.L  (A3),-(A7)
    MOVE.L  D0,-44(A5)
    JSR     _NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    MOVE.L  D5,D1
    EXT.L   D1
    PEA     7.W
    MOVE.L  D1,-(A7)
    MOVE.L  (A3),-(A7)
    MOVE.L  D0,-48(A5)
    JSR     _NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    LEA     48(A7),A7
    MOVE.L  D0,-52(A5)
    MOVEQ   #1,D0
    CMP.L   D0,D7
    BNE.S   .mode_flag_check

    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  4(A3),-(A7)
    JSR     TEXTDISP_JMPTBL_ESQDISP_TestEntryGridEligibility(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .mode_flag_check

    MOVEQ   #1,D1
    BRA.S   .mode_flag_store

.mode_flag_check:
    MOVEQ   #0,D1

.mode_flag_store:
    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  4(A3),-(A7)
    MOVE.L  D0,-(A7)
    PEA     -31(A5)
    MOVE.B  D1,-53(A5)
    JSR     _TEXTDISP_FormatEntryTimeForIndex(PC)

    LEA     12(A7),A7
    MOVE.L  (A3),-80(A5)
    MOVE.L  4(A3),-84(A5)
    MOVEQ   #32,D0
    ADD.W   20(A3),D0
    MOVEM.W D0,-6(A5)
    MOVEQ   #96,D1
    CMP.W   D1,D0
    BLE.S   .compute_bounds

    MOVE.W  D1,-6(A5)

.compute_bounds:
    ADDQ.W  #1,-6(A5)
    MOVE.W  20(A3),D5
    ADDQ.W  #1,D5

.row_loop:
    CMP.W   -6(A5),D5
    BGE.W   .post_loop

    MOVEQ   #49,D0
    CMP.W   D0,D5
    BNE.S   .row_fetch_entry

    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  8(A3),-(A7)
    MOVE.L  D0,-(A7)
    PEA     -84(A5)
    PEA     -80(A5)
    BSR.W   NEWGRID_UpdatePresetEntry

    LEA     16(A7),A7

.row_fetch_entry:
    MOVEQ   #48,D0
    CMP.W   D0,D5
    BLE.S   .row_direct_index

    MOVE.L  D5,D0
    EXT.L   D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    BRA.S   .row_index_ready

.row_direct_index:
    MOVE.L  D5,D0
    EXT.L   D0

.row_index_ready:
    MOVE.L  D0,D6
    TST.L   -80(A5)
    BEQ.W   .row_next

    TST.L   -84(A5)
    BEQ.W   .row_next

    MOVEA.L -80(A5),A0
    ADDA.W  #$1c,A0
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     NEWGRID2_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.W   .row_next

    MOVEA.L -84(A5),A0
    MOVEA.L A0,A1
    ADDA.W  D6,A1
    BTST    #5,7(A1)
    BNE.W   .row_next

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    TST.L   56(A1)
    BEQ.W   .row_next

    MOVEA.L A0,A1
    ADDA.W  D6,A1
    BTST    #7,7(A1)
    BNE.W   .row_next

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L 56(A1),A6
    MOVE.L  A6,-58(A5)
    MOVE.L  A6,D0
    BEQ.S   .fetch_row_fields

    TST.B   (A6)
    BEQ.S   .fetch_row_fields

    MOVEQ   #40,D0
    CMP.B   (A6),D0
    BNE.S   .time_prefix_check2

    MOVEQ   #58,D0
    CMP.B   3(A6),D0
    BNE.S   .time_prefix_check2

    MOVEQ   #8,D0
    BRA.S   .time_prefix_done2

.time_prefix_check2:
    MOVEQ   #0,D0

.time_prefix_done2:
    ADD.L   D0,-58(A5)

.fetch_row_fields:
    MOVE.L  D6,D0
    EXT.L   D0
    PEA     1.W
    MOVE.L  D0,-(A7)
    MOVE.L  -80(A5),-(A7)
    JSR     _NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    PEA     2.W
    MOVE.L  D1,-(A7)
    MOVE.L  -80(A5),-(A7)
    MOVE.L  D0,-62(A5)
    JSR     _NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    PEA     6.W
    MOVE.L  D1,-(A7)
    MOVE.L  -80(A5),-(A7)
    MOVE.L  D0,-66(A5)
    JSR     _NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    PEA     7.W
    MOVE.L  D1,-(A7)
    MOVE.L  -80(A5),-(A7)
    MOVE.L  D0,-70(A5)
    JSR     _NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    LEA     48(A7),A7
    MOVE.L  D0,-74(A5)
    MOVEQ   #1,D0
    CMP.L   D0,D7
    BNE.S   .mode_flag2_false

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -84(A5),-(A7)
    JSR     TEXTDISP_JMPTBL_ESQDISP_TestEntryGridEligibility(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .mode_flag2_false

    MOVEQ   #1,D1
    BRA.S   .mode_flag2_store

.mode_flag2_false:
    MOVEQ   #0,D1

.mode_flag2_store:
    MOVE.B  D1,-75(A5)
    TST.L   -58(A5)
    BEQ.W   .row_next

    MOVEA.L -36(A5),A0
    MOVEA.L -58(A5),A1
    CMPA.L  A0,A1
    BEQ.W   .row_next

.compare_title_loop:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.W   .row_next

    TST.B   D0
    BNE.S   .compare_title_loop

    BNE.W   .row_next

    MOVE.B  -53(A5),D0
    CMP.B   D1,D0
    BNE.W   .row_next

    MOVEA.L -40(A5),A0
    MOVEA.L -62(A5),A1
    CMPA.L  A0,A1
    BEQ.S   .compare_field2_loop

    MOVE.L  A0,D0
    BEQ.W   .row_next

    MOVE.L  A1,D0
    BEQ.W   .row_next

.compare_field1_loop:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.W   .row_next

    TST.B   D0
    BNE.S   .compare_field1_loop

    BNE.W   .row_next

.compare_field2_loop:
    MOVEA.L -44(A5),A0
    MOVEA.L -66(A5),A1
    CMPA.L  A0,A1
    BEQ.S   .compare_field4

    MOVE.L  A0,D0
    BEQ.W   .row_next

    MOVE.L  A1,D0
    BEQ.W   .row_next

.compare_field3_loop:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.W   .row_next

    TST.B   D0
    BNE.S   .compare_field3_loop

    BNE.W   .row_next

.compare_field4:
    MOVEA.L -48(A5),A0
    MOVEA.L -70(A5),A1
    CMPA.L  A0,A1
    BEQ.S   .compare_field4_done

    MOVE.L  A0,D0
    BEQ.W   .row_next

    MOVE.L  A1,D0
    BEQ.W   .row_next

.compare_field4_loop2:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.W   .row_next

    TST.B   D0
    BNE.S   .compare_field4_loop2

    BNE.W   .row_next

.compare_field4_done:
    MOVEA.L -52(A5),A0
    MOVEA.L -74(A5),A1
    CMPA.L  A0,A1
    BEQ.S   .append_prefix_check

    MOVE.L  A0,D0
    BEQ.S   .row_next

    MOVE.L  A1,D0
    BEQ.S   .row_next

.compare_field4_loop:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.S   .row_next

    TST.B   D0
    BNE.S   .compare_field4_loop

    BNE.S   .row_next

.append_prefix_check:
    TST.B   (A2)
    BNE.S   .append_showtime

    LEA     Global_STR_SHOWTIMES_AND_SINGLE_SPACE,A0
    MOVEA.L A2,A1

.copy_showtimes_prefix:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_showtimes_prefix

    PEA     -31(A5)
    JSR     _NEWGRID2_JMPTBL_STR_SkipClass3Chars(PC)

    MOVE.L  D0,(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  D0,-10(A5)
    JSR     PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.append_showtime:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  -84(A5),-(A7)
    MOVE.L  D0,-(A7)
    PEA     -31(A5)
    JSR     _TEXTDISP_FormatEntryTimeForIndex(PC)

    PEA     -31(A5)
    JSR     _NEWGRID2_JMPTBL_STR_SkipClass3Chars(PC)

    PEA     NEWGRID_ShowtimeListSeparator
    MOVE.L  A2,-(A7)
    MOVE.L  D0,-10(A5)
    JSR     PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    MOVE.L  -10(A5),(A7)
    MOVE.L  A2,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    LEA     28(A7),A7
    MOVEA.L -84(A5),A0
    ADDA.W  D6,A0
    BSET    #5,7(A0)

.row_next:
    ADDQ.W  #1,D5
    BRA.W   .row_loop

.post_loop:
    TST.B   (A2)
    BNE.S   .return

    LEA     Global_STR_SHOWING_AT_AND_SINGLE_SPACE,A0
    MOVEA.L A2,A1

.copy_showing_at_prefix:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_showing_at_prefix

    PEA     -31(A5)
    JSR     _NEWGRID2_JMPTBL_STR_SkipClass3Chars(PC)

    MOVE.L  D0,(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  D0,-10(A5)
    JSR     PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.return:
    MOVEM.L (A7)+,D5-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_DrawShowtimesPrompt   (Build and render centered showtimes prompt text)
; ARGS:
;   stack +8: A3 = rastport
;   stack +12: A2 = output buffer
;   stack +16: D7 = mode selector
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   _NEWGRID2_JMPTBL_STR_SkipClass3Chars, NEWGRID2_JMPTBL_STRING_AppendN, PARSEINI_JMPTBL_STRING_AppendAtNull,
;   _NEWGRID_DrawGridFrame, _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight, _LVOSetAPen, _LVOSetDrMd,
;   _LVOTextLength, _LVOMove, _LVOText, _NEWGRID_ValidateSelectionCode
; READS:
;   SCRIPT_PtrSportsOnPrefix, SCRIPT_PtrSummaryOfPrefix, SCRIPT_PtrChannelSuffix, _NEWGRID_RowHeightPx, _NEWGRID_ColumnStartXPx, _NEWGRID_ColumnWidthPx
; WRITES:
;   output buffer contents, 32(A3), 52(A3)
; DESC:
;   Builds a prompt string and centers it inside a grid frame.
;------------------------------------------------------------------------------
NEWGRID_DrawShowtimesPrompt:
    LINK.W  A5,#-168
    MOVEM.L D2/D7/A2-A3/A6,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  16(A5),D7
    MOVE.L  A2,D0
    BEQ.W   .return

    LEA     19(A2),A0
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-4(A5)
    JSR     _NEWGRID2_JMPTBL_STR_SkipClass3Chars(PC)

    LEA     1(A2),A0
    MOVE.L  A0,(A7)
    MOVE.L  D0,-4(A5)
    MOVE.L  A0,-8(A5)
    JSR     _NEWGRID2_JMPTBL_STR_SkipClass3Chars(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,-8(A5)
    TST.L   D7
    BNE.S   .copy_prompt_b

    MOVEA.L SCRIPT_PtrSummaryOfPrefix,A0
    LEA     -136(A5),A1

.copy_prompt_a:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_prompt_a

    BRA.S   .prompt_done

.copy_prompt_b:
    MOVEA.L SCRIPT_PtrSportsOnPrefix,A0
    LEA     -136(A5),A1

.copy_prompt_b_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_prompt_b_loop

.prompt_done:
    MOVEA.L -4(A5),A0

.measure_prompt:
    TST.B   (A0)+
    BNE.S   .measure_prompt

    SUBQ.L  #1,A0
    SUBA.L  -4(A5),A0
    MOVE.L  A0,-(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     -136(A5)
    JSR     NEWGRID2_JMPTBL_STRING_AppendN(PC)

    LEA     12(A7),A7
    TST.L   -8(A5)
    BEQ.S   .draw_frame

    MOVEA.L -8(A5),A0
    TST.B   (A0)
    BEQ.S   .draw_frame

    MOVE.L  SCRIPT_PtrChannelSuffix,-(A7)
    PEA     -136(A5)
    JSR     PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7
    TST.W   _Global_WORD_SELECT_CODE_IS_RAVESC
    BEQ.S   .append_suffix

    MOVEA.L -8(A5),A0
    LEA     -146(A5),A1

.copy_suffix:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_suffix

    CLR.B   -144(A5)
    PEA     -146(A5)
    PEA     -136(A5)
    JSR     PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    PEA     NEWGRID_ShowtimeRangeDash
    PEA     -136(A5)
    JSR     PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    MOVEA.L -8(A5),A0
    ADDQ.L  #2,A0
    MOVE.L  A0,(A7)
    PEA     -136(A5)
    JSR     PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    LEA     20(A7),A7
    BRA.S   .draw_frame

.append_suffix:
    MOVE.L  -8(A5),-(A7)
    PEA     -136(A5)
    JSR     PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.draw_frame:
    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVEQ   #6,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    ADDQ.L  #3,D0
    MOVE.L  D0,-(A7)
    MOVEQ   #6,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    PEA     7.W
    MOVE.L  A3,-(A7)
    JSR     _NEWGRID_DrawGridFrame(PC)

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
    LEA     -136(A5),A6
    MOVE.L  A0,80(A7)
    MOVEA.L A6,A0

.measure_text:
    TST.B   (A0)+
    BNE.S   .measure_text

    SUBQ.L  #1,A0
    SUBA.L  A6,A0
    MOVE.L  D0,84(A7)
    MOVE.L  D1,88(A7)
    MOVE.L  A0,96(A7)
    MOVEA.L A6,A0
    MOVE.L  96(A7),D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  88(A7),D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .center_x

    ADDQ.L  #1,D1

.center_x:
    ASR.L   #1,D1
    MOVE.L  84(A7),D0
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
    MOVEA.L 80(A7),A1
    JSR     _LVOMove(A6)

    LEA     60(A3),A0
    LEA     -136(A5),A1
    MOVEA.L A1,A6

.draw_text:
    TST.B   (A6)+
    BNE.S   .draw_text

    SUBQ.L  #1,A6
    SUBA.L  A1,A6
    MOVEA.L A0,A1
    MOVE.L  A6,D0
    LEA     -136(A5),A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOText(A6)

    MOVEQ   #17,D0
    MOVE.W  D0,52(A3)
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,32(A3)
    PEA     67.W
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_ValidateSelectionCode

    LEA     68(A7),A7

.return:
    MOVEM.L (A7)+,D2/D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_DrawGridFrameVariant4   (Draw grid frame variant)
; ARGS:
;   stack +8: A3 = rastport
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   _NEWGRID_SetRowColor, _LVOSetAPen, _LVORectFill, _NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast, _NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines,
;   _NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevel, _NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected, _NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine, _NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel
; READS:
;   _NEWGRID_RowHeightPx, _DISPTEXT_ControlMarkerXOffsetPx
; WRITES:
;   52(A3)
; DESC:
;   Draws a grid frame with row separators using another variant.
; NOTES:
;   Uses rounding before ASR to keep centering stable for negative values.
;------------------------------------------------------------------------------
NEWGRID_DrawGridFrameVariant4:
    LINK.W  A5,#-20
    MOVEM.L D2-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    LEA     60(A3),A0
    PEA     6.W
    CLR.L   -(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  A0,-20(A5)
    BSR.W   _NEWGRID_SetRowColor

    LEA     12(A7),A7
    MOVEA.L -20(A5),A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    ADDQ.L  #3,D0
    MOVE.L  D0,D3
    MOVEA.L -20(A5),A1
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    MOVE.L  #695,D2
    JSR     _LVORectFill(A6)

    MOVEQ   #42,D6
    MOVEQ   #0,D7
    MOVE.L  D7,D4

.row_loop:
    MOVEQ   #2,D0
    CMP.L   D0,D7
    BGE.W   .after_rows

    JSR     _NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

    TST.L   D0
    BNE.W   .after_rows

    MOVE.L  D4,D5
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines(PC)

    TST.L   D0
    BEQ.S   .alt_path

    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    SUBQ.L  #1,D0
    MOVE.L  D0,-(A7)
    PEA     695.W
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  -20(A5),-(A7)
    JSR     _NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevel(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    TST.L   D0
    BPL.S   .half_width_round

    ADDQ.L  #1,D0

.half_width_round:
    ASR.L   #1,D0
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    SUB.L   D1,D0
    SUBQ.L  #4,D0
    TST.L   D0
    BPL.S   .half_width_adjust

    ADDQ.L  #1,D0

.half_width_adjust:
    ASR.L   #1,D0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    ADD.L   D1,D0
    ADDQ.L  #3,D0
    ADD.L   D0,D5
    BRA.S   .draw_row

.alt_path:
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected(PC)

    TST.L   D0
    BEQ.S   .default_path

    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    MOVE.L  D0,D1
    TST.L   D1
    BPL.S   .alt_half_width_round

    ADDQ.L  #1,D1

.alt_half_width_round:
    ASR.L   #1,D1
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D2
    MOVE.W  26(A0),D2
    SUB.L   D2,D1
    SUBQ.L  #4,D1
    TST.L   D1
    BPL.S   .alt_half_width_adjust

    ADDQ.L  #1,D1

.alt_half_width_adjust:
    ASR.L   #1,D1
    MOVEQ   #0,D2
    MOVE.W  26(A0),D2
    ADD.L   D2,D1
    SUBQ.L  #1,D1
    ADD.L   D1,D5
    BRA.S   .draw_row

.default_path:
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    TST.L   D0
    BPL.S   .default_half_width_round

    ADDQ.L  #1,D0

.default_half_width_round:
    ASR.L   #1,D0
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    SUB.L   D1,D0
    TST.L   D0
    BPL.S   .default_half_width_adjust

    ADDQ.L  #1,D0

.default_half_width_adjust:
    ASR.L   #1,D0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    ADD.L   D1,D0
    SUBQ.L  #1,D0
    ADD.L   D0,D5

.draw_row:
    MOVE.L  D5,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  -20(A5),-(A7)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine(PC)

    LEA     12(A7),A7
    ADDQ.L  #1,D7
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    TST.L   D0
    BPL.S   .advance_row

    ADDQ.L  #1,D0

.advance_row:
    ASR.L   #1,D0
    ADD.L   _DISPTEXT_ControlMarkerXOffsetPx,D0
    ADD.L   D0,D4
    BRA.W   .row_loop

.after_rows:
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

    TST.L   D0
    BEQ.S   .draw_bottom_bevel

    MOVE.L  D4,D0
    SUBQ.L  #1,D0
    MOVE.L  D0,-(A7)
    PEA     695.W
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  -20(A5),-(A7)
    JSR     _NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel(PC)

    LEA     20(A7),A7

.draw_bottom_bevel:
    MOVE.L  D4,D0
    TST.L   D0
    BPL.S   .return

    ADDQ.L  #1,D0

.return:
    ASR.L   #1,D0
    MOVE.W  D0,52(A3)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

    MOVEM.L (A7)+,D2-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_TestPrimeTimeWindow   (Test primetime-window gate for row/index)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
; RET:
;   D0: 1 if in window, 0 otherwise
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   none
; READS:
;   48(A3)
; DESC:
;   Checks an entry flag and applies a time window test.
; NOTES:
;   Treats 'N'/'P' as mode hints and applies 18..22 window for 'P'.
;------------------------------------------------------------------------------
NEWGRID_TestPrimeTimeWindow:
    LINK.W  A5,#-8
    MOVEM.L D5-D7/A3,-(A7)
    MOVE.L  8(A5),D7
    MOVEA.L 12(A5),A3
    MOVEQ   #0,D5
    MOVE.L  A3,D0
    BEQ.S   .return

    MOVEA.L 48(A3),A0
    MOVE.L  A0,-4(A5)
    MOVE.L  A0,D0
    BEQ.S   .return

    MOVE.L  A0,D0
    BEQ.S   .return

    MOVE.B  1(A0),D6
    MOVE.B  D6,D0
    EXT.W   D0
    SUBI.W  #'N',D0 ; Does it equal 'N'?
    BEQ.S   .equalsN

    SUBQ.W  #('P'-'N'),D0 ; Does it equal 'P'?
    BEQ.S   .equalsP

    SUBI.W  #('n'-'P'),D0 ; Does it equal 'n'?
    BEQ.S   .equalsN

    SUBQ.W  #('p'-'n'),D0 ; Does it equal 'p'?
    BEQ.S   .equalsP

    BRA.S   .equalsNeither

.equalsN:
    MOVEQ   #0,D5
    BRA.S   .return

.equalsP:
    ; Is D7 less than 18?
    MOVEQ   #18,D0
    CMP.L   D0,D7
    BLE.S   .return

    ; Is D7 greater than 22?
    MOVEQ   #22,D0
    CMP.L   D0,D7
    BGE.S   .return

    ; If it's between 18 and 22 put 1 in D5 and return.
    MOVEQ   #1,D5
    BRA.S   .return

.equalsNeither:
    MOVEQ   #1,D5

.return:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D5-D7/A3
    UNLK    A5
    RTS
