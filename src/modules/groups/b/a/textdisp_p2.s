    XDEF    _TEXTDISP_BuildEntryDetailLine




;------------------------------------------------------------------------------
; FUNC: _TEXTDISP_BuildEntryDetailLine   (Build formatted entry detail text)
; ARGS:
;   stack +8: entryPtr (A3)
; RET:
;   none
; CLOBBERS:
;   D0-D7/A0-A2
; CALLS:
;   _TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode, _TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode, _TEXTDISP_BuildEntryShortName, _TEXTDISP_FormatEntryTimeForIndex,
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
_TEXTDISP_BuildEntryDetailLine:
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
    JSR     _TEXTDISP_BuildEntryShortName(PC)

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

    LEA     _SCRIPT_AlignedPrefixEmptyF,A1
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
    PEA     _SCRIPT_AlignedStringFormat
    ; Copies selected/trimmed entry substring into the 512-byte work buffer.
    ; Budget note for -524(A5): format is align-prefix + `%s`; practical risk is
    ; low with normal entry text, but formatter-side bounds are not enforced.
    PEA     -524(A5)
    JSR     _WDISP_SPrintf(PC)

    PEA     _SCRIPT_StrAtSeparator
    PEA     -524(A5)
    JSR     _TLIBA1_JMPTBL_ESQ_FindSubstringCaseFold(PC)

    LEA     20(A7),A7
    MOVE.L  D0,-12(A5)
    TST.L   D0
    BNE.S   .try_match_vs_dot

    PEA     _SCRIPT_StrVsDotSeparator
    PEA     -524(A5)
    JSR     _TLIBA1_JMPTBL_ESQ_FindSubstringCaseFold(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-12(A5)

.try_match_vs_dot:
    TST.L   D0
    BNE.S   .try_match_vs

    PEA     _SCRIPT_StrVsSeparator
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
    JSR     _TEXTDISP_FormatEntryTimeForIndex(PC)

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

    PEA     _SCRIPT_AlignedPrefixEmptyG
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

    PEA     _Global_STR_ALIGNED_CHANNEL_2
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