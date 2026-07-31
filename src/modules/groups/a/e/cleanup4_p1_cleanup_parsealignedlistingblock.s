    XDEF    _CLEANUP_ParseAlignedListingBlock


;------------------------------------------------------------------------------
; FUNC: _CLEANUP_ParseAlignedListingBlock   (Parse aligned listing block into entry tables)
; ARGS:
;   stack +4: dataPtr (char*)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   _COI_CountEscape14BeforeNull, _GROUP_AE_JMPTBL_SCRIPT_BuildTokenIndexMap, _ESQ_WildcardMatch, _GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt, _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString,
;   _CLEANUP_FormatEntryStringTokens, _COI_AllocSubEntryTable, _COI_ClearAnimObjectStrings, _COI_FreeSubEntryTableEntries
; READS:
;   _TEXTDISP_SecondaryGroupCode-_TEXTDISP_SecondaryEntryPtrTable, _ESQIFF_RecordLength, _CTASKS_PrimaryOiWritePendingFlag-_CTASKS_PendingSecondaryOiDiskId,
;   _TEXTDISP_PrimaryEntryPtrTable, _TEXTDISP_SecondaryEntryPtrTable, _TEXTDISP_PrimaryTitlePtrTable, _SCRIPT_StrChannelLabel_TuesdaysFridays
; WRITES:
;   _CTASKS_PrimaryOiWritePendingFlag-_CTASKS_PendingSecondaryOiDiskId
; DESC:
;   Parses an aligned listing block from dataPtr, selecting candidate entries,
;   building entry structs, and allocating subentry tables.
; NOTES:
;   - Uses _COI_CountEscape14BeforeNull to locate delimiter fields.
;------------------------------------------------------------------------------
_CLEANUP_ParseAlignedListingBlock:
    LINK.W  A5,#-128
    MOVEM.L D2-D7/A2-A3/A6,-(A7)
    MOVEA.L 8(A5),A3
    CLR.B   -57(A5)
    MOVEQ   #0,D0
    MOVEQ   #22,D1
    MOVE.B  D1,-97(A5)
    MOVEQ   #23,D2
    MOVE.B  D2,-96(A5)
    MOVE.B  #$3,-95(A5)
    MOVE.B  #$4,-94(A5)
    MOVEQ   #16,D3
    MOVE.B  D3,-93(A5)
    MOVEQ   #5,D4
    MOVE.B  D4,-92(A5)
    MOVE.L  D0,-70(A5)
    MOVE.L  D0,-66(A5)
    MOVE.L  D0,-62(A5)
    MOVEQ   #15,D0
    MOVE.B  D0,-91(A5)
    MOVEQ   #6,D0
    MOVE.B  D0,-90(A5)
    MOVEQ   #20,D0
    MOVE.B  D0,-89(A5)
    MOVE.B  D1,-125(A5)
    MOVE.B  D2,-124(A5)
    MOVE.B  D3,-123(A5)
    MOVE.B  D4,-122(A5)
    MOVE.B  #$f,-121(A5)
    MOVE.B  #$6,-120(A5)
    MOVE.B  D0,-119(A5)
    CLR.W   -32(A5)

.init_slot_table_loop:
    MOVE.W  -32(A5),D0
    MOVEQ   #10,D1
    CMP.W   D1,D0
    BGE.S   .after_slot_init

    MOVE.L  D0,D1
    EXT.L   D1
    ADD.L   D1,D1
    MOVE.W  #(-1),-52(A5,D1.L)
    ADDQ.W  #1,-32(A5)
    BRA.S   .init_slot_table_loop

.after_slot_init:
    MOVEQ   #0,D0
    MOVE.B  (A3),D0
    MOVEQ   #0,D1
    NOT.B   D1
    AND.L   D1,D0
    ADDQ.L  #1,-66(A5)
    MOVE.B  _TEXTDISP_SecondaryGroupCode,D1
    MOVE.B  D0,-57(A5)
    CMP.B   D0,D1
    BNE.S   .check_service_type_b

    MOVE.B  _TEXTDISP_SecondaryGroupPresentFlag,D1
    SUBQ.B  #1,D1
    BNE.S   .check_service_type_b

    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D5
    MOVE.B  D0,_CTASKS_PendingSecondaryOiDiskId
    MOVEQ   #1,D1
    MOVE.B  D1,_CTASKS_SecondaryOiWritePendingFlag
    BRA.S   .skip_separator

.check_service_type_b:
    MOVE.B  _TEXTDISP_PrimaryGroupCode,D1
    CMP.B   D0,D1
    BNE.S   .invalid_service_type

    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D5
    MOVE.B  D0,_CTASKS_PendingPrimaryOiDiskId
    MOVE.B  #$1,_CTASKS_PrimaryOiWritePendingFlag
    BRA.S   .skip_separator

.invalid_service_type:
    MOVEQ   #1,D0
    BRA.W   .return_status

.skip_separator:
    MOVEQ   #49,D0
    MOVE.L  -66(A5),D1
    CMP.B   0(A3,D1.L),D0
    BNE.S   .parse_field_offsets

    ADDQ.L  #1,-66(A5)

.parse_field_offsets:
    MOVEA.L A3,A0
    MOVE.L  -66(A5),D0
    ADDA.L  D0,A0
    MOVEQ   #0,D1
    MOVE.W  _ESQIFF_RecordLength,D1
    SUB.L   D0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   _COI_CountEscape14BeforeNull

    EXT.L   D0
    MOVEA.L A3,A0
    MOVE.L  -66(A5),D1
    ADDA.L  D1,A0
    MOVEQ   #0,D2
    MOVE.W  _ESQIFF_RecordLength,D2
    SUB.L   D1,D2
    EXT.L   D2
    PEA     1.W
    CLR.L   -(A7)
    MOVE.L  D2,-(A7)
    PEA     -97(A5)
    PEA     9.W
    PEA     -88(A5)
    MOVE.L  A0,-(A7)
    MOVE.L  D0,-62(A5)
    JSR     _GROUP_AE_JMPTBL_SCRIPT_BuildTokenIndexMap(PC)

    LEA     36(A7),A7
    EXT.L   D0
    MOVEQ   #0,D7
    CLR.W   -32(A5)
    MOVE.L  D0,-70(A5)

.scan_candidate_loop:
    CMP.W   D5,D7
    BGE.S   .after_candidate_scan

    CMPI.W  #10,-32(A5)
    BGE.S   .after_candidate_scan

    MOVE.B  _TEXTDISP_SecondaryGroupCode,D0
    MOVE.B  -57(A5),D1
    CMP.B   D0,D1
    BNE.S   .use_alt_entry_table

    MOVE.B  _TEXTDISP_SecondaryGroupPresentFlag,D0
    SUBQ.B  #1,D0
    BNE.S   .use_alt_entry_table

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    BRA.S   .compare_candidate_entry

.use_alt_entry_table:
    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)

.compare_candidate_entry:
    MOVEA.L -4(A5),A0
    ADDA.W  #12,A0
    MOVEA.L A3,A1
    ADDA.L  -66(A5),A1
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   .store_candidate_slot

    MOVE.W  -32(A5),D0
    EXT.L   D0
    ADD.L   D0,D0
    MOVE.W  D7,-52(A5,D0.L)
    ADDQ.W  #1,-32(A5)

.store_candidate_slot:
    ADDQ.W  #1,D7
    BRA.S   .scan_candidate_loop

.after_candidate_scan:
    MOVE.W  -52(A5),D0
    ADDQ.W  #1,D0
    BNE.S   .select_first_entry

    MOVEQ   #2,D0
    BRA.W   .return_status

.select_first_entry:
    MOVE.B  _TEXTDISP_SecondaryGroupCode,D0
    MOVE.B  -57(A5),D1
    CMP.B   D0,D1
    BNE.S   .select_alt_entry

    MOVE.B  _TEXTDISP_SecondaryGroupPresentFlag,D0
    SUBQ.B  #1,D0
    BNE.S   .select_alt_entry

    MOVE.W  -52(A5),D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    BRA.S   .populate_entry_fields

.select_alt_entry:
    MOVE.W  -52(A5),D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)

.populate_entry_fields:
    MOVE.L  -4(A5),-(A7)
    BSR.W   _COI_ClearAnimObjectStrings

    MOVE.L  -4(A5),(A7)
    BSR.W   _COI_FreeSubEntryTableEntries

    MOVEA.L -4(A5),A0
    MOVE.L  48(A0),-12(A5)
    MOVEA.L A3,A0
    ADDA.L  -66(A5),A0
    ADDA.W  -84(A5),A0
    MOVEA.L -12(A5),A1
    MOVE.L  4(A1),(A7)
    MOVE.L  A0,-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -12(A5),A0
    MOVE.L  D0,4(A0)
    MOVEA.L A3,A1
    ADDA.L  -66(A5),A1
    MOVEA.W -82(A5),A2
    MOVE.L  A2,D0
    MOVE.B  0(A1,D0.W),(A0)
    MOVE.B  1(A1,D0.W),1(A0)
    MOVE.B  2(A1,D0.W),2(A0)
    CLR.B   3(A0)
    ADDA.W  -80(A5),A1
    MOVE.L  12(A0),(A7)
    MOVE.L  A1,-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -12(A5),A0
    MOVE.L  D0,12(A0)
    MOVEA.L A3,A1
    ADDA.L  -66(A5),A1
    ADDA.W  -78(A5),A1
    MOVE.L  20(A0),(A7)
    MOVE.L  A1,-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -12(A5),A0
    MOVE.L  D0,20(A0)
    MOVEA.L A3,A1
    ADDA.L  -66(A5),A1
    ADDA.W  -76(A5),A1
    MOVE.L  8(A0),(A7)
    MOVE.L  A1,-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -12(A5),A0
    MOVE.L  D0,8(A0)
    MOVEA.L A3,A1
    ADDA.L  -66(A5),A1
    ADDA.W  -74(A5),A1
    MOVE.L  16(A0),(A7)
    MOVE.L  A1,-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    LEA     24(A7),A7
    MOVEA.L -12(A5),A0
    MOVE.L  D0,16(A0)
    MOVE.L  -62(A5),D0
    MOVE.W  D0,36(A0)
    MOVEA.L A3,A1
    ADDA.L  -66(A5),A1
    ADDA.W  -88(A5),A1
    TST.B   (A1)
    BEQ.S   .build_title_from_field

    LEA     24(A0),A2
    LEA     28(A0),A6
    MOVE.L  A1,-(A7)
    MOVE.L  A6,-(A7)
    MOVE.L  A2,-(A7)
    BSR.W   _CLEANUP_FormatEntryStringTokens

    LEA     12(A7),A7
    BRA.S   .after_title_format

.build_title_from_field:
    MOVE.L  24(A0),-(A7)
    CLR.L   -(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -12(A5),A0
    MOVE.L  D0,24(A0)
    MOVE.L  28(A0),(A7)
    PEA     _CLOCK_STR_MISSING_TITLE_TEMPLATE
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    LEA     12(A7),A7
    MOVEA.L -12(A5),A0
    MOVE.L  D0,28(A0)

.after_title_format:
    MOVEA.L A3,A0
    ADDA.L  -66(A5),A0
    ADDA.W  -86(A5),A0
    TST.B   (A0)
    BEQ.S   .set_missing_extra

    MOVE.L  A0,-(A7)
    JSR     _GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVEA.L -12(A5),A0
    MOVE.L  D0,32(A0)
    BRA.S   .advance_entry_offset

.set_missing_extra:
    MOVEQ   #-1,D0
    MOVEA.L -12(A5),A0
    MOVE.L  D0,32(A0)

.advance_entry_offset:
    MOVE.W  -74(A5),D0
    EXT.L   D0
    ADD.L   D0,-66(A5)
    TST.L   16(A0)
    BEQ.S   .alloc_subentry_table

    MOVEA.L -12(A5),A1
    MOVEA.L 16(A1),A0

.count_entry_text_loop:
    TST.B   (A0)+
    BNE.S   .count_entry_text_loop

    SUBQ.L  #1,A0
    SUBA.L  16(A1),A0
    MOVE.L  A0,D0
    ADD.L   D0,-66(A5)

.alloc_subentry_table:
    ADDQ.L  #1,-66(A5)
    MOVE.L  -4(A5),-(A7)
    BSR.W   _COI_AllocSubEntryTable

    ADDQ.W  #4,A7
    MOVEQ   #0,D6

.subentry_loop:
    MOVEA.L -12(A5),A0
    CMP.W   36(A0),D6
    BGE.W   .begin_merge

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -12(A5),A1
    MOVEA.L 38(A1),A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-20(A5)
    MOVEQ   #0,D0
    MOVE.L  -66(A5),D1
    MOVE.B  0(A3,D1.L),D0
    MOVEA.L -20(A5),A0
    MOVE.W  D0,(A0)
    ADDQ.L  #1,-66(A5)
    MOVEA.L A3,A1
    MOVE.L  -66(A5),D0
    ADDA.L  D0,A1
    MOVEQ   #0,D1
    MOVE.W  _ESQIFF_RecordLength,D1
    SUB.L   D0,D1
    EXT.L   D1
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    PEA     -125(A5)
    PEA     7.W
    PEA     -116(A5)
    MOVE.L  A1,-(A7)
    JSR     _GROUP_AE_JMPTBL_SCRIPT_BuildTokenIndexMap(PC)

    LEA     28(A7),A7
    MOVE.W  -112(A5),D0
    ADDQ.W  #1,D0
    BNE.S   .select_subentry_title

    MOVEA.L -12(A5),A1
    MOVEA.L 12(A1),A0
    BRA.S   .store_subentry_title

.select_subentry_title:
    MOVEA.L A3,A0
    ADDA.L  -66(A5),A0
    ADDA.W  -112(A5),A0

.store_subentry_title:
    MOVEA.L -20(A5),A1
    MOVE.L  6(A1),-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-56(A5)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVEA.L -20(A5),A0
    MOVE.L  D0,6(A0)
    MOVE.W  -110(A5),D0
    ADDQ.W  #1,D0
    BNE.S   .select_subentry_desc

    MOVEA.L -12(A5),A2
    MOVEA.L 20(A2),A1
    BRA.S   .store_subentry_desc

.select_subentry_desc:
    MOVEA.L A3,A1
    ADDA.L  -66(A5),A1
    ADDA.W  -110(A5),A1

.store_subentry_desc:
    MOVE.L  14(A0),-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A1,-56(A5)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVEA.L -20(A5),A0
    MOVE.L  D0,14(A0)
    MOVE.W  -108(A5),D0
    ADDQ.W  #1,D0
    BNE.S   .select_subentry_alt

    MOVEA.L -12(A5),A2
    MOVEA.L 8(A2),A1
    BRA.S   .store_subentry_alt

.select_subentry_alt:
    MOVEA.L A3,A1
    ADDA.L  -66(A5),A1
    ADDA.W  -108(A5),A1

.store_subentry_alt:
    MOVE.L  2(A0),-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A1,-56(A5)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVEA.L -20(A5),A0
    MOVE.L  D0,2(A0)
    MOVE.W  -106(A5),D0
    ADDQ.W  #1,D0
    BNE.S   .select_subentry_more

    MOVEA.L -12(A5),A2
    MOVEA.L 16(A2),A1
    BRA.S   .store_subentry_more

.select_subentry_more:
    MOVEA.L A3,A1
    ADDA.L  -66(A5),A1
    ADDA.W  -106(A5),A1

.store_subentry_more:
    MOVE.L  10(A0),-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A1,-56(A5)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVEA.L -20(A5),A0
    MOVE.L  D0,10(A0)
    MOVE.W  -116(A5),D0
    ADDQ.W  #1,D0
    BNE.S   .format_subentry_extra

    MOVE.L  18(A0),-(A7)
    MOVEA.L -12(A5),A1
    MOVE.L  24(A1),-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -20(A5),A0
    MOVE.L  D0,18(A0)
    MOVE.L  22(A0),(A7)
    MOVEA.L -12(A5),A1
    MOVE.L  28(A1),-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    LEA     12(A7),A7
    MOVEA.L -20(A5),A0
    MOVE.L  D0,22(A0)
    BRA.S   .store_subentry_extra

.format_subentry_extra:
    LEA     18(A0),A1
    LEA     22(A0),A2
    MOVEA.L A3,A0
    ADDA.L  -66(A5),A0
    ADDA.W  -116(A5),A0
    MOVE.L  A0,-(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  A1,-(A7)
    BSR.W   _CLEANUP_FormatEntryStringTokens

    LEA     12(A7),A7

.store_subentry_extra:
    MOVE.W  -114(A5),D0
    ADDQ.W  #1,D0
    BNE.S   .load_subentry_icon

    MOVEA.L -12(A5),A0
    MOVEA.L -20(A5),A1
    MOVE.L  32(A0),26(A1)
    BRA.S   .advance_subentry_offset

.load_subentry_icon:
    MOVEA.L A3,A0
    ADDA.L  -66(A5),A0
    ADDA.W  -114(A5),A0
    MOVE.L  A0,-(A7)
    JSR     _GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVEA.L -20(A5),A0
    MOVE.L  D0,26(A0)

.advance_subentry_offset:
    MOVE.W  -104(A5),D0
    EXT.L   D0
    ADD.L   D0,-66(A5)
    ADDQ.W  #1,D6
    BRA.W   .subentry_loop

.begin_merge:
    MOVE.W  #1,-32(A5)

.merge_candidate_loop:
    MOVE.W  -32(A5),D0
    EXT.L   D0
    ADD.L   D0,D0
    MOVEQ   #-1,D1
    CMP.W   -52(A5,D0.L),D1
    BEQ.W   .return_success

    MOVE.W  -32(A5),D0
    MOVEQ   #10,D1
    CMP.W   D1,D0
    BGE.W   .return_success

    MOVE.B  _TEXTDISP_SecondaryGroupCode,D1
    MOVE.B  -57(A5),D2
    CMP.B   D1,D2
    BNE.S   .select_merge_table

    MOVE.B  _TEXTDISP_SecondaryGroupPresentFlag,D1
    SUBQ.B  #1,D1
    BNE.S   .select_merge_table

    MOVE.L  D0,D1
    EXT.L   D1
    ADD.L   D1,D1
    MOVE.W  -52(A5,D1.L),D2
    EXT.L   D2
    ASL.L   #2,D2
    LEA     _TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D2,A0
    MOVE.L  (A0),-8(A5)
    BRA.S   .merge_entry_copy

.select_merge_table:
    MOVE.L  D0,D1
    EXT.L   D1
    ADD.L   D1,D1
    MOVE.W  -52(A5,D1.L),D2
    EXT.L   D2
    ASL.L   #2,D2
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D2,A0
    MOVE.L  (A0),-8(A5)

.merge_entry_copy:
    MOVEA.L -4(A5),A0
    MOVE.L  48(A0),-12(A5)
    MOVEA.L -8(A5),A0
    MOVE.L  48(A0),-16(A5)
    ADDQ.W  #1,-32(A5)
    MOVE.L  A0,-(A7)
    BSR.W   _COI_ClearAnimObjectStrings

    MOVE.L  -8(A5),(A7)
    BSR.W   _COI_FreeSubEntryTableEntries

    MOVEA.L -16(A5),A0
    MOVE.L  4(A0),(A7)
    MOVEA.L -12(A5),A1
    MOVE.L  4(A1),-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -16(A5),A0
    MOVE.L  D0,4(A0)
    MOVEA.L -12(A5),A0
    MOVEA.L -16(A5),A1
    MOVE.B  (A0),(A1)
    MOVE.B  1(A0),1(A1)
    MOVE.B  2(A0),2(A1)
    MOVE.B  3(A0),3(A1)
    MOVE.L  12(A1),(A7)
    MOVE.L  12(A0),-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -16(A5),A0
    MOVE.L  D0,12(A0)
    MOVE.L  20(A0),(A7)
    MOVEA.L -12(A5),A0
    MOVE.L  20(A0),-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -16(A5),A0
    MOVE.L  D0,20(A0)
    MOVE.L  8(A0),(A7)
    MOVEA.L -12(A5),A0
    MOVE.L  8(A0),-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -16(A5),A0
    MOVE.L  D0,8(A0)
    MOVE.L  16(A0),(A7)
    MOVEA.L -12(A5),A0
    MOVE.L  16(A0),-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -16(A5),A0
    MOVE.L  D0,16(A0)
    MOVEA.L -12(A5),A0
    MOVEA.L -16(A5),A1
    MOVE.W  36(A0),36(A1)
    MOVE.L  24(A1),(A7)
    MOVE.L  24(A0),-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -16(A5),A0
    MOVE.L  D0,24(A0)
    MOVE.L  28(A0),(A7)
    MOVEA.L -12(A5),A0
    MOVE.L  28(A0),-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -16(A5),A0
    MOVE.L  D0,28(A0)
    MOVEA.L -12(A5),A0
    MOVEA.L -16(A5),A1
    MOVE.L  32(A0),32(A1)
    MOVE.L  -8(A5),(A7)
    BSR.W   _COI_AllocSubEntryTable

    LEA     32(A7),A7
    MOVEQ   #0,D7

.merge_subentry_loop:
    MOVEA.L -12(A5),A0
    CMP.W   36(A0),D7
    BGE.W   .merge_candidate_loop

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -12(A5),A1
    MOVEA.L 38(A1),A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-20(A5)
    MOVEA.L -16(A5),A1
    MOVEA.L 38(A1),A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-24(A5)
    MOVEA.L -20(A5),A0
    MOVEA.L -24(A5),A1
    MOVE.W  (A0),(A1)
    MOVE.L  6(A1),-(A7)
    MOVE.L  6(A0),-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -24(A5),A0
    MOVE.L  D0,6(A0)
    MOVE.L  14(A0),(A7)
    MOVEA.L -20(A5),A0
    MOVE.L  14(A0),-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -24(A5),A0
    MOVE.L  D0,14(A0)
    MOVE.L  2(A0),(A7)
    MOVEA.L -20(A5),A0
    MOVE.L  2(A0),-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -24(A5),A0
    MOVE.L  D0,2(A0)
    MOVE.L  10(A0),(A7)
    MOVEA.L -20(A5),A0
    MOVE.L  10(A0),-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -24(A5),A0
    MOVE.L  D0,10(A0)
    MOVE.L  18(A0),(A7)
    MOVEA.L -20(A5),A0
    MOVE.L  18(A0),-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -24(A5),A0
    MOVE.L  D0,18(A0)
    MOVE.L  22(A0),(A7)
    MOVEA.L -20(A5),A0
    MOVE.L  22(A0),-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    LEA     28(A7),A7
    MOVEA.L -24(A5),A0
    MOVE.L  D0,22(A0)
    MOVEA.L -20(A5),A0
    MOVEA.L -24(A5),A1
    MOVE.L  26(A0),26(A1)
    ADDQ.W  #1,D7
    BRA.W   .merge_subentry_loop

.return_success:
    MOVEQ   #0,D0

.return_status:
    MOVEM.L (A7)+,D2-D7/A2-A3/A6
    UNLK    A5
    RTS
