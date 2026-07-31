    XDEF    _TEXTDISP_FilterAndSelectEntry


;------------------------------------------------------------------------------
; FUNC: _TEXTDISP_FilterAndSelectEntry   (Filter/update selection)
; ARGS:
;   stack +8: entryPtr (A3)
;   stack +15: cmdByte (D7)
; RET:
;   D0: nonzero if selection changed
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _UNKNOWN_JMPTBL_ESQ_WildcardMatch, _TEXTDISP_GetGroupEntryCount,
;   _TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode, _TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode, _TEXTDISP_ShouldOpenEditorForEntry,
;   _TEXTDISP_SetSelectionFields, _TEXTDISP_BuildEntryDetailLine, _TEXTDISP_ResetSelectionState
; READS:
;   _TEXTDISP_FilterModeId/_TEXTDISP_FilterCandidateCursor-235C, _TEXTDISP_CandidateIndexList
; WRITES:
;   _TEXTDISP_FilterModeId, _TEXTDISP_FilterCandidateCursor-235C, _TEXTDISP_CandidateIndexList
; DESC:
;   Applies PPV/SBE/SPORTS filters, walks entries for matches, and updates
;   selection state when a match is found.
; NOTES:
;   Uses wildcard match strings in data/script.s.
;------------------------------------------------------------------------------
_TEXTDISP_FilterAndSelectEntry:
    LINK.W  A5,#-36
    MOVEM.L D2/D5-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.B  15(A5),D7
    CLR.L   -20(A5)
    MOVE.L  A3,D0
    BNE.S   .init_pointers

    MOVEQ   #0,D7
    BRA.S   .dispatch_filter

.init_pointers:
    MOVE.L  A3,-30(A5)
    LEA     10(A3),A0
    MOVE.L  A0,-34(A5)
    MOVEA.L -30(A5),A1
    TST.B   (A1)
    BEQ.S   .invalidate_filter

    TST.B   (A0)
    BNE.S   .dispatch_filter

.invalidate_filter:
    MOVEQ   #0,D7

.dispatch_filter:
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    TST.W   D0
    BEQ.W   .default_mode_3

    SUBI.W  #$46,D0
    BEQ.S   .handle_mode_F

    SUBI.W  #18,D0
    BEQ.S   .ensure_filter_ready

    BRA.W   .default_mode_3

.handle_mode_F:
    CLR.W   _TEXTDISP_FilterChannelSlotIndex
    MOVE.B  #$1,_TEXTDISP_FilterModeId
    MOVE.L  -30(A5),-(A7)
    PEA     _SCRIPT_FilterTag_PPV
    JSR     _UNKNOWN_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BEQ.S   .set_match_flags

    MOVE.L  -30(A5),-(A7)
    PEA     _SCRIPT_FilterTag_SBE
    JSR     _UNKNOWN_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BEQ.S   .set_match_flags

    MOVEQ   #0,D0
    BRA.S   .after_match_flags

.set_match_flags:
    MOVEQ   #1,D0

.after_match_flags:
    MOVE.L  -30(A5),-(A7)
    PEA     _SCRIPT_FilterTag_SPORTS
    MOVE.W  D0,_TEXTDISP_FilterPpvSbeMatchFlag
    JSR     _UNKNOWN_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    SEQ     D1
    NEG.B   D1
    EXT.W   D1
    EXT.L   D1
    MOVE.W  D1,_TEXTDISP_FilterSportsMatchFlag

.ensure_filter_ready:
    TST.L   -20(A5)
    BNE.W   .after_dispatch

    MOVE.B  _TEXTDISP_FilterModeId,D0
    MOVEQ   #3,D1
    CMP.B   D1,D0
    BEQ.W   .after_dispatch

    TST.W   _TEXTDISP_FilterChannelSlotIndex
    BNE.W   .advance_cursor_set

    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   _TEXTDISP_GetGroupEntryCount

    ADDQ.W  #4,A7
    MOVEQ   #0,D5
    MOVE.W  D0,D5
    MOVEQ   #0,D6
    MOVE.L  D6,D0
    MOVE.W  D0,_TEXTDISP_FilterMatchCount

.scan_entries_loop:
    CMP.L   D5,D6
    BGE.W   .finish_match_scan

    MOVE.B  _TEXTDISP_FilterModeId,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  D6,-(A7)
    JSR     _TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    MOVEA.L D0,A0
    BTST    #3,27(A0)
    BNE.S   .next_entry

    TST.W   _TEXTDISP_FilterPpvSbeMatchFlag
    BEQ.S   .check_flag_match

    BTST    #4,27(A0)
    BNE.S   .record_match

.check_flag_match:
    TST.W   _TEXTDISP_FilterSportsMatchFlag
    BEQ.S   .check_editor_allowed

    MOVE.L  D0,-(A7)
    BSR.W   _TEXTDISP_ShouldOpenEditorForEntry

    ADDQ.W  #4,A7
    TST.L   D0
    BNE.S   .record_match

.check_editor_allowed:
    MOVEA.L -8(A5),A0
    ADDA.W  #12,A0
    MOVE.L  -30(A5),-(A7)
    MOVE.L  A0,-(A7)
    JSR     _UNKNOWN_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   .next_entry

.record_match:
    MOVE.W  _TEXTDISP_FilterMatchCount,D0
    ADDQ.W  #1,_TEXTDISP_FilterMatchCount
    LEA     _TEXTDISP_CandidateIndexList,A0
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ADDA.L  D1,A0
    MOVE.L  D6,D0
    MOVE.B  D0,(A0)

.next_entry:
    ADDQ.L  #1,D6
    BRA.W   .scan_entries_loop

.finish_match_scan:
    CMPI.W  #0,_TEXTDISP_FilterMatchCount
    BLS.S   .no_matches

    CLR.W   _TEXTDISP_FilterCandidateCursor
    MOVEQ   #1,D0
    CMP.B   _TEXTDISP_FilterModeId,D0
    BNE.S   .set_default_cursor

    MOVEQ   #0,D0
    MOVE.W  _CLOCK_HalfHourSlotIndex,D0
    BRA.S   .store_cursor_base

.set_default_cursor:
    MOVEQ   #1,D0

.store_cursor_base:
    MOVE.W  D0,_TEXTDISP_FilterChannelSlotIndex
    BRA.S   .advance_cursor_set

.no_matches:
    MOVE.W  #$31,_TEXTDISP_FilterChannelSlotIndex

.advance_cursor_set:
    TST.L   -20(A5)
    BNE.W   .advance_mode

    CMPI.W  #$31,_TEXTDISP_FilterChannelSlotIndex
    BCC.W   .advance_mode

.cursor_loop:
    TST.L   -20(A5)
    BNE.W   .advance_channel_index

    MOVE.W  _TEXTDISP_FilterCandidateCursor,D0
    CMP.W   _TEXTDISP_FilterMatchCount,D0
    BCC.W   .advance_channel_index

    LEA     _TEXTDISP_CandidateIndexList,A0
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ADDA.L  D1,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.B  _TEXTDISP_FilterModeId,D1
    EXT.W   D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     _TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.W   .next_cursor_entry

    MOVEQ   #1,D1
    CMP.B   _TEXTDISP_FilterModeId,D1
    BNE.W   .load_entry_for_cursor

    MOVE.W  _CLOCK_HalfHourSlotIndex,D1
    MOVE.W  _TEXTDISP_FilterChannelSlotIndex,D2
    CMP.W   D2,D1
    BNE.W   .load_entry_for_cursor

    MOVEQ   #0,D1
    MOVE.W  D2,D1
    ASL.L   #2,D1
    MOVEA.L D0,A0
    MOVE.L  56(A0,D1.L),-26(A5)
    MOVE.W  D2,-22(A5)

.backtrack_channel:
    MOVE.W  -22(A5),D0
    TST.W   D0
    BLE.S   .ensure_channel_entry

    TST.L   -26(A5)
    BNE.S   .ensure_channel_entry

    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    MOVEA.L -4(A5),A0
    MOVE.L  56(A0,D1.L),-26(A5)
    SUBQ.W  #1,-22(A5)
    BRA.S   .backtrack_channel

.ensure_channel_entry:
    TST.L   -26(A5)
    BEQ.S   .validate_entry

    LEA     _TEXTDISP_CandidateIndexList,A0
    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_FilterCandidateCursor,D0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.B  _TEXTDISP_FilterModeId,D1
    EXT.W   D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     _TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    MOVE.W  -22(A5),D1
    EXT.L   D1
    MOVE.L  _CONFIG_TimeWindowMinutes,(A7)
    PEA     1440.W
    MOVE.L  D1,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-8(A5)
    JSR     _TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow(PC)

    LEA     24(A7),A7
    TST.L   D0
    BNE.S   .validate_entry

    CLR.L   -26(A5)
    BRA.S   .validate_entry

.load_entry_for_cursor:
    MOVE.W  _TEXTDISP_FilterChannelSlotIndex,D0
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    MOVEA.L -4(A5),A0
    MOVEA.L 56(A0,D1.L),A0
    MOVE.W  D0,-22(A5)
    MOVE.L  A0,-26(A5)

.validate_entry:
    TST.L   -26(A5)
    BEQ.W   .next_cursor_entry

    MOVE.L  -26(A5),-(A7)
    BSR.W   _TEXTDISP_SkipControlCodes

    ADDQ.W  #4,A7
    MOVE.L  D0,-26(A5)
    TST.W   _TEXTDISP_FilterSportsMatchFlag
    BEQ.S   .check_entry_name_match

    MOVE.W  -22(A5),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     _TEXTDISP_JMPTBL_ESQDISP_TestEntryGridEligibility(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.W   .next_cursor_entry

.check_entry_name_match:
    MOVEA.L -34(A5),A0

.compare_entry_names:
    TST.B   (A0)+
    BNE.S   .compare_entry_names

    SUBQ.L  #1,A0
    SUBA.L  -34(A5),A0
    MOVE.L  A0,-(A7)
    MOVE.L  -26(A5),-(A7)
    MOVE.L  -34(A5),-(A7)
    JSR     _STRING_CompareNoCaseN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.W   .next_cursor_entry

    LEA     _TEXTDISP_CandidateIndexList,A0
    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_FilterCandidateCursor,D0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.B  _TEXTDISP_FilterModeId,D1
    EXT.W   D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     _TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    MOVEA.L D0,A0
    LEA     28(A0),A1
    MOVE.W  -22(A5),D1
    EXT.L   D1
    MOVE.L  D1,(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  D0,-8(A5)
    JSR     _TLIBA2_JMPTBL_ESQ_TestBit1Based(PC)

    LEA     12(A7),A7
    ADDQ.L  #1,D0
    BNE.S   .next_cursor_entry

    MOVEQ   #1,D0
    MOVE.L  D0,-20(A5)
    MOVE.B  _TEXTDISP_FilterModeId,D0
    EXT.W   D0
    EXT.L   D0
    LEA     _TEXTDISP_CandidateIndexList,A0
    MOVEQ   #0,D1
    MOVE.W  _TEXTDISP_FilterCandidateCursor,D1
    ADDA.L  D1,A0
    MOVEQ   #0,D1
    MOVE.B  (A0),D1
    MOVE.W  -22(A5),D2
    EXT.L   D2
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _TEXTDISP_SetSelectionFields

    MOVE.L  A3,(A7)
    BSR.W   _TEXTDISP_BuildEntryDetailLine

    LEA     16(A7),A7

.next_cursor_entry:
    ADDQ.W  #1,_TEXTDISP_FilterCandidateCursor
    BRA.W   .cursor_loop

.advance_channel_index:
    TST.L   -20(A5)
    BNE.W   .advance_cursor_set

    ADDQ.W  #1,_TEXTDISP_FilterChannelSlotIndex
    CLR.W   _TEXTDISP_FilterCandidateCursor
    BRA.W   .advance_cursor_set

.advance_mode:
    CMPI.W  #$30,_TEXTDISP_FilterChannelSlotIndex
    BLS.W   .ensure_filter_ready

    CLR.W   _TEXTDISP_FilterChannelSlotIndex
    MOVE.B  _TEXTDISP_FilterModeId,D0
    EXT.W   D0
    SUBQ.W  #1,D0
    BEQ.S   .set_mode_2

    SUBQ.W  #1,D0
    BEQ.S   .set_mode_3

    BRA.S   .set_mode_3

.set_mode_2:
    MOVE.B  #$2,_TEXTDISP_FilterModeId
    BRA.W   .ensure_filter_ready

.set_mode_3:
    MOVE.B  #$3,_TEXTDISP_FilterModeId
    BRA.W   .ensure_filter_ready

.default_mode_3:
    MOVE.B  #$3,_TEXTDISP_FilterModeId

.after_dispatch:
    TST.L   -20(A5)
    BNE.S   .return

    MOVE.L  A3,-(A7)
    BSR.W   _TEXTDISP_ResetSelectionState

    ADDQ.W  #4,A7

.return:
    MOVE.L  -20(A5),D0
    MOVEM.L (A7)+,D2/D5-D7/A3
    UNLK    A5
    RTS

;!======