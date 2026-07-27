    XDEF    _TEXTDISP_BuildMatchIndexList


;------------------------------------------------------------------------------
; FUNC: _TEXTDISP_BuildMatchIndexList   (Build list of matching entries)
; ARGS:
;   stack +8: patternPtr
;   stack +14: cmdChar (word)
; RET:
;   D0: match count
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _UNKNOWN_JMPTBL_ESQ_WildcardMatch, _TEXTDISP_ShouldOpenEditorForEntry
; READS:
;   _TEXTDISP_ActiveGroupId, _TEXTDISP_PrimaryGroupEntryCount/222F, _TEXTDISP_PrimaryEntryPtrTable/2235/2236/2237, _TEXTDISP_Tag_PPV, _TEXTDISP_Tag_SBE, _TEXTDISP_Tag_SPORTS, _TEXTDISP_Tag_SPT_Filter
; WRITES:
;   _TEXTDISP_SbeFilterActiveFlag, _TEXTDISP_FindModeActiveFlag, _TEXTDISP_CandidateIndexList
; DESC:
;   Filters entries by wildcard pattern and flags, storing matches in _TEXTDISP_CandidateIndexList.
; NOTES:
;   If pattern starts with FIND1, switches to a \"find\" mode.
;------------------------------------------------------------------------------
_TEXTDISP_BuildMatchIndexList:
    LINK.W  A5,#-20
    MOVEM.L D4-D7/A2-A3,-(A7)
    MOVE.W  14(A5),D7
    MOVEQ   #0,D5
    TST.L   8(A5)
    BEQ.W   .return

    MOVE.L  8(A5),-(A7)
    PEA     _TEXTDISP_Tag_PPV
    JSR     _UNKNOWN_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   .check_sbe_pattern

    MOVEQ   #1,D4
    BRA.S   .check_sports_pattern

.check_sbe_pattern:
    MOVE.L  8(A5),-(A7)
    PEA     _TEXTDISP_Tag_SBE
    JSR     _UNKNOWN_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   .set_pattern_flag

    MOVEQ   #1,D0
    MOVE.W  D0,_TEXTDISP_SbeFilterActiveFlag
    MOVE.L  D0,D4
    BRA.S   .check_sports_pattern

.set_pattern_flag:
    MOVEQ   #0,D4

.check_sports_pattern:
    MOVE.L  8(A5),-(A7)
    PEA     _TEXTDISP_Tag_SPORTS
    JSR     _UNKNOWN_JMPTBL_ESQ_WildcardMatch(PC)

    TST.B   D0
    SEQ     D1
    NEG.B   D1
    EXT.W   D1
    EXT.L   D1
    MOVE.L  8(A5),(A7)
    PEA     _TEXTDISP_Tag_SPT_Filter
    MOVE.W  D1,-16(A5)
    JSR     _UNKNOWN_JMPTBL_ESQ_WildcardMatch(PC)

    LEA     12(A7),A7
    TST.B   D0
    BNE.S   .ensure_filter_pattern

    LEA     _Global_STR_ASTERISK_2,A0
    MOVE.L  A0,8(A5)

.ensure_filter_pattern:
    LEA     _TEXTDISP_Tag_FIND1,A0
    MOVEA.L 8(A5),A1

.compare_find_prefix:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.S   .set_find_mode_flag

    TST.B   D0
    BNE.S   .compare_find_prefix

    BNE.S   .set_find_mode_flag

    MOVEQ   #1,D0
    MOVE.W  D0,_TEXTDISP_FindModeActiveFlag
    MOVE.L  #_Global_STR_ASTERISK_3,8(A5)
    BRA.S   .init_scan

.set_find_mode_flag:
    MOVEQ   #0,D0
    MOVE.W  D0,_TEXTDISP_FindModeActiveFlag

.init_scan:
    MOVEQ   #0,D5
    MOVE.W  _TEXTDISP_ActiveGroupId,D0
    SUBQ.W  #1,D0
    BNE.S   .set_group2_count

    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    MOVE.L  D0,-20(A5)
    BRA.S   .init_index

.set_group2_count:
    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D0
    MOVE.L  D0,-20(A5)

.init_index:
    MOVEQ   #0,D6

.entry_loop:
    MOVE.L  D6,D0
    EXT.L   D0
    CMP.L   -20(A5),D0
    BGE.W   .return

    MOVE.W  _TEXTDISP_ActiveGroupId,D0
    SUBQ.W  #1,D0
    BNE.S   .load_group2_entry

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A3
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A2
    BRA.S   .check_entry_filters

.load_group2_entry:
    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_SecondaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A3
    LEA     _TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A2

.check_entry_filters:
    BTST    #3,27(A2)
    BNE.S   .next_entry

    MOVEQ   #69,D0
    CMP.W   D0,D7
    BNE.S   .check_cmd_E

    BTST    #7,40(A2)
    BEQ.S   .next_entry

.check_cmd_E:
    TST.W   D4
    BEQ.S   .check_editor_flag

    BTST    #4,27(A2)
    BNE.S   .record_match

.check_editor_flag:
    TST.W   -16(A5)
    BEQ.S   .match_wildcard

    MOVE.L  A2,-(A7)
    JSR     _TEXTDISP_ShouldOpenEditorForEntry(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BNE.S   .record_match

.match_wildcard:
    MOVE.L  8(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     _UNKNOWN_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   .next_entry

.record_match:
    LEA     _TEXTDISP_CandidateIndexList,A0
    ADDA.W  D5,A0
    MOVE.L  D6,D0
    MOVE.B  D0,(A0)
    ADDQ.W  #1,D5

.next_entry:
    ADDQ.W  #1,D6
    BRA.W   .entry_loop

.return:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D4-D7/A2-A3
    UNLK    A5
    RTS

;!======