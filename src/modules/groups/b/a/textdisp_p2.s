    XDEF    TEXTDISP_BuildEntryDetailLine
    XDEF    TEXTDISP_DrawHighlightFrame
    XDEF    TEXTDISP_FilterAndSelectEntry
    XDEF    _TEXTDISP_HandleScriptCommand



;------------------------------------------------------------------------------
; FUNC: TEXTDISP_BuildEntryDetailLine   (Build formatted entry detail text)
; ARGS:
;   stack +8: entryPtr (A3)
; RET:
;   none
; CLOBBERS:
;   D0-D7/A0-A2
; CALLS:
;   _TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode, _TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode, TEXTDISP_BuildEntryShortName, TEXTDISP_FormatEntryTimeForIndex,
;   _STRING_AppendAtNull, _WDISP_SPrintf, _TLIBA1_JMPTBL_ESQ_FindSubstringCaseFold,
;   _STR_FindCharPtr, _TEXTDISP_SkipControlCodes, _TEXTDISP_TrimTextToPixelWidth
; READS:
;   entry+210/214/218, _WDISP_CharClassTable
; DESC:
;   Builds a formatted line for an entry by combining header text, program title,
;   sports delimiters (\"at\"/\"vs\"), and channel info, then appends alignment.
; NOTES:
;   Inserts 0x18 markers around matched delimiters.
;   -524(A5) is the large text scratch buffer (~512 bytes before -12(A5) temp slots);
;   _WDISP_SPrintf("%s") depends on upstream trimming/selection to stay bounded.
;------------------------------------------------------------------------------
TEXTDISP_BuildEntryDetailLine:
    LINK.W  A5,#-540
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  A3,D0
    BEQ.W   .return

    MOVEQ   #3,D0
    CMP.L   210(A3),D0
    BEQ.S   .reset_if_invalid

    MOVEQ   #-1,D0
    CMP.L   214(A3),D0
    BEQ.S   .reset_if_invalid

    MOVEQ   #-1,D0
    CMP.W   218(A3),D0
    BNE.S   .build_buffers

.reset_if_invalid:
    MOVE.L  A3,-(A7)
    BSR.W   _TEXTDISP_ResetSelectionState

    ADDQ.W  #4,A7
    BRA.W   .return

.build_buffers:
    LEA     10(A3),A0
    MOVE.L  210(A3),-(A7)
    MOVE.L  214(A3),-(A7)
    MOVE.L  A0,-4(A5)
    JSR     _TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

    MOVE.L  210(A3),(A7)
    MOVE.L  214(A3),-(A7)
    MOVE.L  D0,-532(A5)
    JSR     _TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    LEA     220(A3),A0
    CLR.B   (A0)
    PEA     -524(A5)
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-528(A5)
    MOVE.L  A0,-8(A5)
    JSR     TEXTDISP_BuildEntryShortName(PC)

    LEA     20(A7),A7
    LEA     -524(A5),A0
    MOVE.L  A0,-12(A5)

.skip_control_prefix:
    MOVEQ   #0,D0
    MOVEA.L -12(A5),A0
    MOVE.B  (A0),D0
    LEA     _WDISP_CharClassTable,A0
    ADDA.L  D0,A0
    BTST    #3,(A0)
    BNE.S   .skip_control_prefix_loop

    MOVEQ   #24,D1
    CMP.B   D1,D0
    BEQ.S   .skip_control_prefix_loop

    MOVEQ   #25,D1
    CMP.B   D1,D0
    BNE.S   .maybe_add_prefix

.skip_control_prefix_loop:
    ADDQ.L  #1,-12(A5)
    BRA.S   .skip_control_prefix

.maybe_add_prefix:
    MOVEA.L -12(A5),A0
    TST.B   (A0)
    BEQ.S   .select_entry_string

    LEA     SCRIPT_AlignedPrefixEmptyF,A1
    MOVEA.L -8(A5),A2

.copy_prefix:
    MOVE.B  (A1)+,(A2)+
    BNE.S   .copy_prefix

    MOVE.L  -12(A5),-(A7)
    MOVE.L  -8(A5),-(A7)
    JSR     _STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.select_entry_string:
    MOVE.W  218(A3),D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -532(A5),A0
    MOVE.L  56(A0,D0.L),-(A7)
    BSR.W   _TEXTDISP_SkipControlCodes

    ADDQ.W  #4,A7
    MOVE.L  D0,-12(A5)
    BEQ.W   .append_channel_segment

    MOVEA.L D0,A0
    TST.B   (A0)
    BEQ.W   .append_channel_segment

    MOVEA.L -4(A5),A0

.calc_title_len:
    TST.B   (A0)+
    BNE.S   .calc_title_len

    SUBQ.L  #1,A0
    SUBA.L  -4(A5),A0
    MOVE.L  A0,D7
    MOVEA.L D0,A0

.calc_entry_len:
    TST.B   (A0)+
    BNE.S   .calc_entry_len

    SUBQ.L  #1,A0
    SUBA.L  D0,A0
    CMPA.L  D7,A0
    BLT.S   .align_entry_tail

    ADD.L   D7,-12(A5)

.align_entry_tail:
    MOVEQ   #0,D0
    MOVEA.L -12(A5),A0
    MOVE.B  (A0),D0
    LEA     _WDISP_CharClassTable,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .mark_match_delimiters

    ADDQ.L  #1,-12(A5)
    BRA.S   .align_entry_tail

.mark_match_delimiters:
    MOVE.L  -12(A5),-(A7)
    PEA     SCRIPT_AlignedStringFormat
    ; Copies selected/trimmed entry substring into the 512-byte work buffer.
    ; Budget note for -524(A5): format is align-prefix + `%s`; practical risk is
    ; low with normal entry text, but formatter-side bounds are not enforced.
    PEA     -524(A5)
    JSR     _WDISP_SPrintf(PC)

    PEA     SCRIPT_StrAtSeparator
    PEA     -524(A5)
    JSR     _TLIBA1_JMPTBL_ESQ_FindSubstringCaseFold(PC)

    LEA     20(A7),A7
    MOVE.L  D0,-12(A5)
    TST.L   D0
    BNE.S   .try_match_vs_dot

    PEA     SCRIPT_StrVsDotSeparator
    PEA     -524(A5)
    JSR     _TLIBA1_JMPTBL_ESQ_FindSubstringCaseFold(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-12(A5)

.try_match_vs_dot:
    TST.L   D0
    BNE.S   .try_match_vs

    PEA     SCRIPT_StrVsSeparator
    PEA     -524(A5)
    JSR     _TLIBA1_JMPTBL_ESQ_FindSubstringCaseFold(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-12(A5)

.try_match_vs:
    TST.L   D0
    BEQ.S   .reset_scan_ptr

    MOVEA.L D0,A0
    MOVE.B  #$18,(A0)

.mark_match_span:
    ADDQ.L  #1,-12(A5)
    MOVEQ   #0,D0
    MOVEA.L -12(A5),A0
    MOVE.B  (A0),D0
    LEA     _WDISP_CharClassTable,A0
    ADDA.L  D0,A0
    BTST    #3,(A0)
    BEQ.S   .mark_match_span

    MOVEA.L -12(A5),A0
    MOVE.B  #$18,(A0)
    BRA.S   .truncate_at_control

.reset_scan_ptr:
    LEA     -524(A5),A0
    MOVE.L  A0,-12(A5)

.truncate_at_control:
    PEA     40.W
    MOVE.L  A0,-(A7)
    JSR     _STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-12(A5)
    BEQ.S   .append_title_suffix

.backtrack_to_text:
    MOVEA.L -12(A5),A0
    CLR.B   (A0)
    SUBQ.L  #1,-12(A5)
    MOVEQ   #0,D0
    MOVEA.L -12(A5),A0
    MOVE.B  (A0),D0
    LEA     _WDISP_CharClassTable,A0
    ADDA.L  D0,A0
    BTST    #3,(A0)
    BNE.S   .backtrack_to_text

.append_title_suffix:
    PEA     -524(A5)
    MOVE.L  -8(A5),-(A7)
    JSR     _STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.append_channel_segment:
    MOVE.W  218(A3),D0
    EXT.L   D0
    MOVE.L  -532(A5),-(A7)
    MOVE.L  D0,-(A7)
    PEA     -524(A5)
    JSR     TEXTDISP_FormatEntryTimeForIndex(PC)

    LEA     12(A7),A7
    LEA     -524(A5),A0
    MOVE.L  A0,-12(A5)

.skip_control_in_segment:
    MOVEQ   #0,D0
    MOVEA.L -12(A5),A0
    MOVE.B  (A0),D0
    LEA     _WDISP_CharClassTable,A0
    ADDA.L  D0,A0
    BTST    #3,(A0)
    BEQ.S   .append_channel_label

    ADDQ.L  #1,-12(A5)
    BRA.S   .skip_control_in_segment

.append_channel_label:
    MOVEA.L -12(A5),A0
    TST.B   (A0)
    BEQ.S   .copy_program_init

    PEA     SCRIPT_AlignedPrefixEmptyG
    MOVE.L  -8(A5),-(A7)
    JSR     _STRING_AppendAtNull(PC)

    MOVE.L  -12(A5),(A7)
    MOVE.L  -8(A5),-(A7)
    JSR     _STRING_AppendAtNull(PC)

    LEA     12(A7),A7

.copy_program_init:
    MOVEQ   #0,D6
    MOVE.L  D6,D7

.copy_program_loop:
    MOVEA.L -528(A5),A0
    TST.B   1(A0,D7.L)
    BEQ.S   .finalize_program

    MOVEQ   #32,D0
    CMP.B   1(A0,D7.L),D0
    BEQ.S   .skip_program_space

    LEA     -524(A5),A1
    ADDA.L  D6,A1
    ADDQ.L  #1,D6
    MOVE.B  1(A0,D7.L),(A1)

.skip_program_space:
    ADDQ.L  #1,D7
    BRA.S   .copy_program_loop

.finalize_program:
    LEA     -524(A5),A0
    ADDA.L  D6,A0
    MOVEQ   #0,D0
    MOVE.B  D0,(A0)
    MOVE.B  -524(A5),D1
    TST.B   D1
    BEQ.S   .append_channel_word

    PEA     Global_STR_ALIGNED_CHANNEL_2
    MOVE.L  -8(A5),-(A7)
    JSR     _STRING_AppendAtNull(PC)

    PEA     -524(A5)
    MOVE.L  -8(A5),-(A7)
    JSR     _STRING_AppendAtNull(PC)

    LEA     16(A7),A7

.append_channel_word:
    PEA     284.W
    MOVE.L  -8(A5),-(A7)
    JSR     _TEXTDISP_TrimTextToPixelWidth(PC)

    ADDQ.W  #8,A7

.return:
    MOVEM.L (A7)+,D6-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_FilterAndSelectEntry   (Filter/update selection)
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
;   TEXTDISP_SetSelectionFields, TEXTDISP_BuildEntryDetailLine, _TEXTDISP_ResetSelectionState
; READS:
;   TEXTDISP_FilterModeId/TEXTDISP_FilterCandidateCursor-235C, _TEXTDISP_CandidateIndexList
; WRITES:
;   TEXTDISP_FilterModeId, TEXTDISP_FilterCandidateCursor-235C, _TEXTDISP_CandidateIndexList
; DESC:
;   Applies PPV/SBE/SPORTS filters, walks entries for matches, and updates
;   selection state when a match is found.
; NOTES:
;   Uses wildcard match strings in data/script.s.
;------------------------------------------------------------------------------
TEXTDISP_FilterAndSelectEntry:
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
    CLR.W   TEXTDISP_FilterChannelSlotIndex
    MOVE.B  #$1,TEXTDISP_FilterModeId
    MOVE.L  -30(A5),-(A7)
    PEA     SCRIPT_FilterTag_PPV
    JSR     _UNKNOWN_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BEQ.S   .set_match_flags

    MOVE.L  -30(A5),-(A7)
    PEA     SCRIPT_FilterTag_SBE
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
    PEA     SCRIPT_FilterTag_SPORTS
    MOVE.W  D0,TEXTDISP_FilterPpvSbeMatchFlag
    JSR     _UNKNOWN_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    SEQ     D1
    NEG.B   D1
    EXT.W   D1
    EXT.L   D1
    MOVE.W  D1,TEXTDISP_FilterSportsMatchFlag

.ensure_filter_ready:
    TST.L   -20(A5)
    BNE.W   .after_dispatch

    MOVE.B  TEXTDISP_FilterModeId,D0
    MOVEQ   #3,D1
    CMP.B   D1,D0
    BEQ.W   .after_dispatch

    TST.W   TEXTDISP_FilterChannelSlotIndex
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
    MOVE.W  D0,TEXTDISP_FilterMatchCount

.scan_entries_loop:
    CMP.L   D5,D6
    BGE.W   .finish_match_scan

    MOVE.B  TEXTDISP_FilterModeId,D0
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

    TST.W   TEXTDISP_FilterPpvSbeMatchFlag
    BEQ.S   .check_flag_match

    BTST    #4,27(A0)
    BNE.S   .record_match

.check_flag_match:
    TST.W   TEXTDISP_FilterSportsMatchFlag
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
    MOVE.W  TEXTDISP_FilterMatchCount,D0
    ADDQ.W  #1,TEXTDISP_FilterMatchCount
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
    CMPI.W  #0,TEXTDISP_FilterMatchCount
    BLS.S   .no_matches

    CLR.W   TEXTDISP_FilterCandidateCursor
    MOVEQ   #1,D0
    CMP.B   TEXTDISP_FilterModeId,D0
    BNE.S   .set_default_cursor

    MOVEQ   #0,D0
    MOVE.W  _CLOCK_HalfHourSlotIndex,D0
    BRA.S   .store_cursor_base

.set_default_cursor:
    MOVEQ   #1,D0

.store_cursor_base:
    MOVE.W  D0,TEXTDISP_FilterChannelSlotIndex
    BRA.S   .advance_cursor_set

.no_matches:
    MOVE.W  #$31,TEXTDISP_FilterChannelSlotIndex

.advance_cursor_set:
    TST.L   -20(A5)
    BNE.W   .advance_mode

    CMPI.W  #$31,TEXTDISP_FilterChannelSlotIndex
    BCC.W   .advance_mode

.cursor_loop:
    TST.L   -20(A5)
    BNE.W   .advance_channel_index

    MOVE.W  TEXTDISP_FilterCandidateCursor,D0
    CMP.W   TEXTDISP_FilterMatchCount,D0
    BCC.W   .advance_channel_index

    LEA     _TEXTDISP_CandidateIndexList,A0
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ADDA.L  D1,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.B  TEXTDISP_FilterModeId,D1
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
    CMP.B   TEXTDISP_FilterModeId,D1
    BNE.W   .load_entry_for_cursor

    MOVE.W  _CLOCK_HalfHourSlotIndex,D1
    MOVE.W  TEXTDISP_FilterChannelSlotIndex,D2
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
    MOVE.W  TEXTDISP_FilterCandidateCursor,D0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.B  TEXTDISP_FilterModeId,D1
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
    JSR     TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow(PC)

    LEA     24(A7),A7
    TST.L   D0
    BNE.S   .validate_entry

    CLR.L   -26(A5)
    BRA.S   .validate_entry

.load_entry_for_cursor:
    MOVE.W  TEXTDISP_FilterChannelSlotIndex,D0
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
    TST.W   TEXTDISP_FilterSportsMatchFlag
    BEQ.S   .check_entry_name_match

    MOVE.W  -22(A5),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     TEXTDISP_JMPTBL_ESQDISP_TestEntryGridEligibility(PC)

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
    MOVE.W  TEXTDISP_FilterCandidateCursor,D0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.B  TEXTDISP_FilterModeId,D1
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
    MOVE.B  TEXTDISP_FilterModeId,D0
    EXT.W   D0
    EXT.L   D0
    LEA     _TEXTDISP_CandidateIndexList,A0
    MOVEQ   #0,D1
    MOVE.W  TEXTDISP_FilterCandidateCursor,D1
    ADDA.L  D1,A0
    MOVEQ   #0,D1
    MOVE.B  (A0),D1
    MOVE.W  -22(A5),D2
    EXT.L   D2
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   TEXTDISP_SetSelectionFields

    MOVE.L  A3,(A7)
    BSR.W   TEXTDISP_BuildEntryDetailLine

    LEA     16(A7),A7

.next_cursor_entry:
    ADDQ.W  #1,TEXTDISP_FilterCandidateCursor
    BRA.W   .cursor_loop

.advance_channel_index:
    TST.L   -20(A5)
    BNE.W   .advance_cursor_set

    ADDQ.W  #1,TEXTDISP_FilterChannelSlotIndex
    CLR.W   TEXTDISP_FilterCandidateCursor
    BRA.W   .advance_cursor_set

.advance_mode:
    CMPI.W  #$30,TEXTDISP_FilterChannelSlotIndex
    BLS.W   .ensure_filter_ready

    CLR.W   TEXTDISP_FilterChannelSlotIndex
    MOVE.B  TEXTDISP_FilterModeId,D0
    EXT.W   D0
    SUBQ.W  #1,D0
    BEQ.S   .set_mode_2

    SUBQ.W  #1,D0
    BEQ.S   .set_mode_3

    BRA.S   .set_mode_3

.set_mode_2:
    MOVE.B  #$2,TEXTDISP_FilterModeId
    BRA.W   .ensure_filter_ready

.set_mode_3:
    MOVE.B  #$3,TEXTDISP_FilterModeId
    BRA.W   .ensure_filter_ready

.default_mode_3:
    MOVE.B  #$3,TEXTDISP_FilterModeId

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

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_DrawHighlightFrame   (Draw highlight overlay)
; ARGS:
;   stack +8: entryPtr (A3)
; RET:
;   none
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _TLIBA3_ClearViewModeRastPort, _TLIBA3_BuildDisplayContextForViewMode, _ESQ_SetCopperEffect_OnEnableHighlight,
;   _WDISP_JMPTBL_ESQIFF_RunCopperDropTransition/0A45, _MATH_Mulu32, _MATH_DivS32,
;   SCRIPT_BeginBannerCharTransition, TLIBA1_DrawFormattedTextBlock, _TEXTDISP_JMPTBL_ESQIFF_RunCopperRiseTransition, _TEXTDISP_ResetSelectionState
; READS:
;   entry+220, _CONFIG_LRBN_FlagChar, _TEXTDISP_EntryTextBaseWidthPx
; WRITES:
;   _WDISP_DisplayContextBase, _WDISP_AccumulatorCaptureActive/_WDISP_AccumulatorFlushPending, TEXTDISP_LinePenOverrideEnabledFlag
; DESC:
;   Enables the highlight copper effect, computes bounds, and draws the frame.
; NOTES:
;   Uses banner transitions when in certain region modes.
;------------------------------------------------------------------------------
TEXTDISP_DrawHighlightFrame:
    LINK.W  A5,#-32
    MOVEM.L D2-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  A3,D0
    BEQ.W   .return

    TST.B   220(A3)
    BEQ.W   .return

    CLR.L   -(A7)
    PEA     8.W
    JSR     _TLIBA3_ClearViewModeRastPort(PC)

    PEA     3.W
    CLR.L   -(A7)
    PEA     8.W
    JSR     _TLIBA3_BuildDisplayContextForViewMode(PC)

    MOVE.L  D0,_WDISP_DisplayContextBase
    JSR     _WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D0
    MOVEA.L _WDISP_DisplayContextBase,A0
    MOVE.W  4(A0),D0
    MOVEQ   #-22,D1
    ADD.L   _TEXTDISP_EntryTextBaseWidthPx,D1
    MOVE.W  (A0),D2
    MOVE.L  D0,-22(A5)
    MOVE.L  D1,-26(A5)
    BTST    #2,D2
    BEQ.S   .select_grid_cols

    MOVEQ   #2,D0
    BRA.S   .calc_grid_width

.select_grid_cols:
    MOVEQ   #1,D0

.calc_grid_width:
    JSR     _MATH_Mulu32(PC)

    MOVE.L  D0,-26(A5)
    MOVE.L  -22(A5),D1
    CMP.L   D0,D1
    BLT.S   .clamp_width

    MOVE.L  D0,D1

.clamp_width:
    MOVEQ   #0,D0
    MOVE.W  2(A0),D0
    MOVE.W  #1,_WDISP_AccumulatorCaptureActive
    CLR.W   _WDISP_AccumulatorFlushPending
    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    MOVE.L  D0,-18(A5)
    MOVE.L  D1,-22(A5)
    MOVE.L  A0,-4(A5)
    JSR     _WDISP_JMPTBL_ESQIFF_RunCopperDropTransition(PC)

    JSR     _WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples(PC)

    MOVE.B  _CONFIG_LRBN_FlagChar,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .after_banner

    MOVEA.L _WDISP_DisplayContextBase,A0
    MOVE.W  (A0),D0
    BTST    #2,D0
    BEQ.S   .use_cols_2

    MOVEQ   #2,D0
    BRA.S   .after_cols

.use_cols_2:
    MOVEQ   #1,D0

.after_cols:
    MOVE.L  D0,28(A7)
    MOVE.L  -22(A5),D0
    MOVE.L  28(A7),D1
    JSR     _MATH_DivS32(PC)

    MOVE.L  D0,D7
    ADDI.W  #22,D7
    MOVE.L  D7,D0
    EXT.L   D0
    PEA     500.W
    MOVE.L  D0,-(A7)
    JSR     SCRIPT_BeginBannerCharTransition(PC)

    ADDQ.W  #8,A7

.after_banner:
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    PEA     3.W
    JSR     _TLIBA3_BuildDisplayContextForViewMode(PC)

    LEA     12(A7),A7
    MOVE.L  D0,_WDISP_DisplayContextBase
    MOVE.L  #$fffffee4,D0
    ADD.L   -18(A5),D0
    TST.L   D0
    BPL.S   .calc_rect

    ADDQ.L  #1,D0

.calc_rect:
    ASR.L   #1,D0
    MOVE.L  D0,D6
    MOVEQ   #0,D4
    MOVE.L  D6,D5
    ADDI.W  #$11b,D5
    MOVE.L  -22(A5),D0
    SUBQ.L  #1,D0
    MOVE.W  D0,-14(A5)
    MOVEA.L -4(A5),A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVE.W  #1,TEXTDISP_LinePenOverrideEnabledFlag
    LEA     220(A3),A0
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D4,D1
    EXT.L   D1
    MOVE.L  D5,D2
    EXT.L   D2
    MOVE.W  -14(A5),D3
    EXT.L   D3
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     TLIBA1_DrawFormattedTextBlock(PC)

    PEA     3.W
    CLR.L   -(A7)
    PEA     8.W
    JSR     _TLIBA3_BuildDisplayContextForViewMode(PC)

    MOVE.L  D0,_WDISP_DisplayContextBase
    JSR     _TEXTDISP_JMPTBL_ESQIFF_RunCopperRiseTransition(PC)

    MOVE.L  A3,(A7)
    BSR.W   _TEXTDISP_ResetSelectionState

    LEA     36(A7),A7

.return:
    MOVEM.L (A7)+,D2-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _TEXTDISP_HandleScriptCommand   (Dispatch text display command)
; ARGS:
;   stack +11: cmdChar (D7)
;   stack +15: modeChar (D6)
;   stack +16: argPtr (A3)
; RET:
;   none
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   TEXTDISP_BuildNowShowingStatusLine, TEXTDISP_BuildEntryPairStatusLine,
;   _TEXTDISP_SetEntryTextFields, TEXTDISP_FilterAndSelectEntry,
;   TEXTDISP_DrawHighlightFrame, _MEMORY_AllocateMemory, _MEMORY_DeallocateMemory
; READS:
;   TEXTDISP_CommandBufferPtr, TEXTDISP_PrimaryFirstMatchIndex/2361/2364
; WRITES:
;   TEXTDISP_LastDispatchMatchIndex/214A/214B/235D
; DESC:
;   Handles a script opcode by updating text display state and SourceCfg data.
; NOTES:
;   Command cases inferred from constants (0x43/0x4A/0x52 etc).
;   case 'C' uses -200(A5) as a command scratch buffer for "xx%s".
;------------------------------------------------------------------------------
_TEXTDISP_HandleScriptCommand:

.commandScratchBuffer = -200

    LINK.W  A5,#-208
    MOVEM.L D2/D4-D7/A3,-(A7)
    MOVE.B  11(A5),D7
    MOVE.B  15(A5),D6
    MOVEA.L 16(A5),A3
    MOVEQ   #1,D5
    MOVEQ   #1,D4
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    ADDQ.W  #1,D0
    BEQ.W   .finalize

    SUBI.W  #$43,D0
    BEQ.S   .handle_cmd_C

    SUBQ.W  #7,D0
    BEQ.W   .handle_cmd_J

    SUBI.W  #10,D0
    BEQ.W   .handle_cmd_source_cfg

    BRA.W   .finalize

.handle_cmd_C:
    MOVE.L  A3,-(A7)
    PEA     TEXTDISP_CommandPrefixFormat
    ; 200-byte local target; source text comes from script argument pointer.
    ; Provenance: A3 is typically _SCRIPT_CommandTextPtr (legacy _SCRIPT_CommandTextPtr), populated from
    ; SCRIPT_CTRL_CMD_BUFFER payload bytes in SCRIPT_HandleBrushCommand.
    ; Budget note for .commandScratchBuffer (200 bytes incl NUL):
    ; "xx%s" => 3 + len(arg), so payload must stay <= 197 bytes.
    ; CTRL packet path enforces SCRIPT_CTRL_READ_INDEX <= 198 before dispatch.
    PEA     .commandScratchBuffer(A5)
    JSR     _WDISP_SPrintf(PC)

    MOVE.W  _TEXTDISP_PrimaryChannelCode,D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    PEA     _TEXTDISP_PrimarySearchText
    MOVE.L  A3,-(A7)
    JSR     _TEXTDISP_SelectGroupAndEntry(PC)

    LEA     20(A7),A7
    SUBQ.W  #1,D0
    BNE.S   .handle_cmd_C_success

    MOVE.W  _TEXTDISP_ActiveGroupId,TEXTDISP_StatusGroupId
    MOVE.W  _TEXTDISP_CurrentMatchIndex,TEXTDISP_LastDispatchMatchIndex
    BSR.W   _SCRIPT_GetBannerCharOrFallback

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.W  D1,TEXTDISP_LastDispatchGroupId
    BRA.S   .dispatch_update

.handle_cmd_C_success:
    MOVE.W  TEXTDISP_PrimaryFirstMatchIndex,D0
    ADDQ.W  #1,D0
    BEQ.S   .handle_cmd_C_try_alt1

    MOVE.W  #1,TEXTDISP_StatusGroupId
    MOVE.W  TEXTDISP_PrimaryFirstMatchIndex,TEXTDISP_LastDispatchMatchIndex
    MOVEQ   #-1,D0
    MOVE.W  D0,TEXTDISP_LastDispatchGroupId
    BRA.S   .dispatch_update

.handle_cmd_C_try_alt1:
    MOVE.W  TEXTDISP_SecondaryFirstMatchIndex,D0
    ADDQ.W  #1,D0
    BEQ.S   .handle_cmd_C_try_alt2

    CLR.W   TEXTDISP_StatusGroupId
    MOVE.W  TEXTDISP_SecondaryFirstMatchIndex,TEXTDISP_LastDispatchMatchIndex
    MOVEQ   #-1,D0
    MOVE.W  D0,TEXTDISP_LastDispatchGroupId
    BRA.S   .dispatch_update

.handle_cmd_C_try_alt2:
    MOVEQ   #-1,D0
    MOVE.W  D0,TEXTDISP_LastDispatchGroupId
    MOVE.W  D0,TEXTDISP_LastDispatchMatchIndex
    MOVE.W  D0,TEXTDISP_StatusGroupId

.dispatch_update:
    MOVE.W  TEXTDISP_StatusGroupId,D0
    EXT.L   D0
    MOVE.W  TEXTDISP_LastDispatchMatchIndex,D1
    EXT.L   D1
    MOVE.W  TEXTDISP_LastDispatchGroupId,D2
    EXT.L   D2
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   TEXTDISP_BuildNowShowingStatusLine

    BSR.W   _SCRIPT_ResetBannerCharDefaults

    LEA     12(A7),A7
    MOVEQ   #0,D5
    BRA.W   .finalize

.handle_cmd_J:
    MOVE.W  TEXTDISP_StatusGroupId,D0
    EXT.L   D0
    MOVE.W  TEXTDISP_LastDispatchMatchIndex,D1
    EXT.L   D1
    MOVE.W  TEXTDISP_LastDispatchGroupId,D2
    EXT.L   D2
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   TEXTDISP_BuildEntryPairStatusLine

    LEA     12(A7),A7
    MOVEQ   #0,D5
    BRA.W   .finalize

.handle_cmd_source_cfg:
    MOVEQ   #70,D0
    CMP.B   D0,D7
    BNE.S   .apply_source_cfg

    TST.L   TEXTDISP_CommandBufferPtr
    BNE.S   .init_source_cfg

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     732.W
    PEA     1084.W
    PEA     Global_STR_TEXTDISP_C_1
    JSR     _MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,TEXTDISP_CommandBufferPtr

.init_source_cfg:
    PEA     _TEXTDISP_PrimarySearchText
    MOVE.L  A3,-(A7)
    MOVE.L  TEXTDISP_CommandBufferPtr,-(A7)
    BSR.W   _TEXTDISP_SetEntryTextFields

    PEA     70.W
    MOVE.L  TEXTDISP_CommandBufferPtr,-(A7)
    BSR.W   TEXTDISP_FilterAndSelectEntry

    LEA     20(A7),A7
    TST.L   D0
    BNE.S   .apply_source_cfg

    TST.L   TEXTDISP_CommandBufferPtr
    BEQ.S   .apply_source_cfg

    MOVEA.L TEXTDISP_CommandBufferPtr,A0
    ADDA.W  #$dc,A0
    LEA     TEXTDISP_DefaultSpacePad,A1

.copy_default_cfg:
    MOVE.B  (A1)+,(A0)+
    BNE.S   .copy_default_cfg

.apply_source_cfg:
    MOVE.L  TEXTDISP_CommandBufferPtr,-(A7)
    BSR.W   TEXTDISP_DrawHighlightFrame

    PEA     88.W
    MOVE.L  TEXTDISP_CommandBufferPtr,-(A7)
    BSR.W   TEXTDISP_FilterAndSelectEntry

    LEA     12(A7),A7
    MOVEQ   #0,D4

.finalize:
    TST.L   D5
    BEQ.S   .cleanup_if_needed

    MOVE.W  #(-1),TEXTDISP_LastDispatchMatchIndex
    MOVE.W  #$31,TEXTDISP_LastDispatchGroupId

.cleanup_if_needed:
    TST.L   D4
    BEQ.S   .return

    CLR.L   -(A7)
    CLR.L   -(A7)
    BSR.W   TEXTDISP_FilterAndSelectEntry

    ADDQ.W  #8,A7
    TST.L   TEXTDISP_CommandBufferPtr
    BEQ.S   .return

    PEA     732.W
    MOVE.L  TEXTDISP_CommandBufferPtr,-(A7)
    PEA     1106.W
    PEA     Global_STR_TEXTDISP_C_2
    JSR     _MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    CLR.L   TEXTDISP_CommandBufferPtr

.return:
    MOVEM.L (A7)+,D2/D4-D7/A3
    UNLK    A5
    RTS

;!======