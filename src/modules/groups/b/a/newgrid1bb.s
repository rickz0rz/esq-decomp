    XDEF    _NEWGRID_AddShowtimeBucketEntry
    XDEF    _NEWGRID_AppendShowtimeBuckets
    XDEF    NEWGRID_BuildShowtimesText
    XDEF    _NEWGRID_HandleShowtimesState
    XDEF    NEWGRID_ProcessShowtimesWorkflow
    XDEF    _NEWGRID_ResetShowtimeBuckets


;------------------------------------------------------------------------------
; FUNC: _NEWGRID_ResetShowtimeBuckets   (Reset showtime buckets)
; ARGS:
;   none
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A1
; CALLS:
;   _PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString
; READS:
;   _NEWGRID_ShowtimeBucketEntryTable
; WRITES:
;   _NEWGRID_ShowtimeBucketCount, _NEWGRID_ShowtimeBucketEntryTable
; DESC:
;   Clears bucket count and reinitializes bucket records.
;------------------------------------------------------------------------------
_NEWGRID_ResetShowtimeBuckets:
    LINK.W  A5,#-8
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D0
    MOVE.L  D0,_NEWGRID_ShowtimeBucketCount
    MOVE.L  D0,D7

.init_loop:
    MOVEQ   #10,D0
    CMP.L   D0,D7
    BGE.S   .return

    MOVE.L  D7,D0
    ASL.L   #3,D0
    LEA     _NEWGRID_ShowtimeBucketEntryTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  #$3100,(A1)
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    ADDA.L  D0,A0
    MOVE.L  4(A0),-(A7)
    CLR.L   -(A7)
    MOVE.L  A1,16(A7)
    JSR     _PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVEA.L 8(A7),A0
    MOVE.L  D0,4(A0)
    ADDQ.L  #1,D7
    BRA.S   .init_loop

.return:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _NEWGRID_AddShowtimeBucketEntry   (Insert showtime bucket entry)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +16: arg_3 (via 20(A5))
; RET:
;   D0: 1 if inserted, 0 if not
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _PARSEINI_JMPTBL_STR_FindCharPtr, _SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt, _PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString
; READS:
;   _NEWGRID_ShowtimeBucketEntryTable, _NEWGRID_ShowtimeBucketPtrTable, _NEWGRID_ShowtimeBucketCount
; WRITES:
;   _NEWGRID_ShowtimeBucketEntryTable, _NEWGRID_ShowtimeBucketPtrTable, _NEWGRID_ShowtimeBucketCount
; DESC:
;   Adds an entry into the sorted bucket list if capacity allows.
; NOTES:
;   Uses insertion-style shifting to keep buckets sorted.
;------------------------------------------------------------------------------
_NEWGRID_AddShowtimeBucketEntry:
    LINK.W  A5,#-28
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    CLR.L   -20(A5)
    PEA     58.W
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STR_FindCharPtr(PC)

    MOVEA.L D0,A0
    LEA     1(A0),A1
    MOVE.L  A1,(A7)
    MOVE.L  A1,-4(A5)
    JSR     _SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D6
    MOVE.L  D7,D0
    ASL.L   #8,D0
    ADD.L   D0,D6
    MOVE.L  _NEWGRID_ShowtimeBucketCount,D0
    MOVEQ   #10,D1
    CMP.L   D1,D0
    BGE.W   .return

    ASL.L   #3,D0
    LEA     _NEWGRID_ShowtimeBucketEntryTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  D6,(A1)
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    ADDA.L  D0,A0
    MOVE.L  4(A0),-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  A1,32(A7)
    JSR     _PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVEA.L 24(A7),A0
    MOVE.L  D0,4(A0)
    MOVE.L  _NEWGRID_ShowtimeBucketCount,D5

.find_insert_pos:
    TST.L   D5
    BLE.S   .check_insert

    MOVE.L  D5,D0
    ASL.L   #2,D0
    LEA     NEWGRID_ShowtimeBucketEntryTablePadLong,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    CMP.L   (A1),D6
    BGE.S   .check_insert

    SUBQ.L  #1,D5
    BRA.S   .find_insert_pos

.check_insert:
    TST.L   D5
    BEQ.S   .shift_needed

    MOVE.L  D5,D0
    ASL.L   #2,D0
    LEA     NEWGRID_ShowtimeBucketEntryTablePadLong,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    CMP.L   (A1),D6
    BEQ.S   .return

.shift_needed:
    MOVE.L  _NEWGRID_ShowtimeBucketCount,D4

.shift_loop:
    CMP.L   D5,D4
    BLE.S   .store_bucket

    MOVE.L  D4,D0
    ASL.L   #2,D0
    LEA     _NEWGRID_ShowtimeBucketPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  D4,D0
    ASL.L   #2,D0
    LEA     NEWGRID_ShowtimeBucketEntryTablePadLong,A1
    ADDA.L  D0,A1
    MOVE.L  (A1),(A0)
    SUBQ.L  #1,D4
    BRA.S   .shift_loop

.store_bucket:
    MOVE.L  D5,D0
    ASL.L   #2,D0
    LEA     _NEWGRID_ShowtimeBucketPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  _NEWGRID_ShowtimeBucketCount,D0
    MOVE.L  D0,D1
    ASL.L   #3,D1
    LEA     _NEWGRID_ShowtimeBucketEntryTable,A1
    ADDA.L  D1,A1
    MOVE.L  A1,(A0)
    ADDQ.L  #1,_NEWGRID_ShowtimeBucketCount
    MOVEQ   #1,D0
    MOVE.L  D0,-20(A5)

.return:
    MOVE.L  -20(A5),D0
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _NEWGRID_AppendShowtimeBuckets   (Append showtime buckets to buffer)
; ARGS:
;   stack +8: A3 = output buffer
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _PARSEINI_JMPTBL_STRING_AppendAtNull
; READS:
;   _NEWGRID_ShowtimeBucketPtrTable, _NEWGRID_ShowtimeBucketCount, _NEWGRID_ShowtimeBucketSeparator
; WRITES:
;   output buffer contents
; DESC:
;   Appends each bucket’s data into the output buffer.
;------------------------------------------------------------------------------
_NEWGRID_AppendShowtimeBuckets:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEA.L _NEWGRID_ShowtimeBucketPtrTable,A0
    MOVE.L  4(A0),-(A7)
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7
    MOVEQ   #1,D7

.append_loop:
    CMP.L   _NEWGRID_ShowtimeBucketCount,D7
    BGE.S   .return

    PEA     _NEWGRID_ShowtimeBucketSeparator
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _NEWGRID_ShowtimeBucketPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  4(A1),(A7)
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    LEA     12(A7),A7
    ADDQ.L  #1,D7
    BRA.S   .append_loop

.return:
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_BuildShowtimesText   (Build formatted showtimes text for current selection)
; ARGS:
;   stack +8: A3 = rastport
;   stack +12: A2 = entry state
;   stack +16: A1 = output buffer
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   _NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer, _TEXTDISP_FormatEntryTimeForIndex, _NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex, _NEWGRID2_JMPTBL_ESQ_TestBit1Based, _NEWGRID2_JMPTBL_COI_ProcessEntrySelectionState, _NEWGRID2_JMPTBL_STR_SkipClass3Chars,
;   _NEWGRID_ResetShowtimeBuckets, _NEWGRID_AddShowtimeBucketEntry,
;   _NEWGRID_AppendShowtimeBuckets, _PARSEINI_JMPTBL_STRING_AppendAtNull
; READS:
;   _TEXTDISP_PrimaryGroupPresentFlag, _TEXTDISP_PrimaryGroupEntryCount, _GCOMMAND_PpvSelectionWindowMinutes, _GCOMMAND_PpvShowtimesRowSpan, _NEWGRID_ShowtimeBucketEntryTable..2339
; WRITES:
;   output buffer contents, _NEWGRID_ShowtimeBucketCount
; DESC:
;   Scans entries and builds a formatted showtimes string.
; NOTES:
;   Performs multiple string comparisons to coalesce matching showtime entries.
;------------------------------------------------------------------------------
NEWGRID_BuildShowtimesText:
    LINK.W  A5,#-108
    MOVEM.L D5-D7/A2-A3/A6,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    TST.L   (A2)
    BEQ.W   .return

    TST.L   4(A2)
    BEQ.W   .return

    MOVEA.L (A2),A0
    BTST    #4,47(A0)
    BEQ.W   .return

    TST.B   _TEXTDISP_PrimaryGroupPresentFlag
    BEQ.W   .return

    TST.L   16(A5)
    BEQ.W   .return

    MOVEA.L 16(A5),A1
    CLR.B   (A1)
    MOVE.W  20(A2),D6
    MOVE.L  D6,D5
    MOVEQ   #48,D0
    CMP.W   D0,D6
    BLE.S   .adjust_row

    SUBI.W  #$30,D6

.adjust_row:
    MOVEA.L 4(A2),A0
    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L 56(A1),A6
    MOVE.L  A6,-54(A5)
    MOVE.L  A6,D0
    BEQ.S   .clear_time_ptr

    TST.B   (A6)
    BEQ.S   .clear_time_ptr

    MOVEQ   #40,D0
    CMP.B   (A6),D0
    BNE.S   .check_time_prefix

    MOVEQ   #58,D0
    CMP.B   3(A6),D0
    BNE.S   .check_time_prefix

    MOVEQ   #8,D0
    BRA.S   .store_time_offset

.check_time_prefix:
    MOVEQ   #0,D0

.store_time_offset:
    ADD.L   D0,-54(A5)
    BRA.S   .fetch_fields

.clear_time_ptr:
    CLR.L   -54(A5)

.fetch_fields:
    MOVE.L  D6,D0
    EXT.L   D0
    PEA     1.W
    MOVE.L  D0,-(A7)
    MOVE.L  (A2),-(A7)
    JSR     _NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    PEA     2.W
    MOVE.L  D1,-(A7)
    MOVE.L  (A2),-(A7)
    MOVE.L  D0,-58(A5)
    JSR     _NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    PEA     6.W
    MOVE.L  D1,-(A7)
    MOVE.L  (A2),-(A7)
    MOVE.L  D0,-62(A5)
    JSR     _NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    PEA     7.W
    MOVE.L  D1,-(A7)
    MOVE.L  (A2),-(A7)
    MOVE.L  D0,-66(A5)
    JSR     _NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    MOVE.L  4(A2),(A7)
    MOVE.L  D1,-(A7)
    PEA     -49(A5)
    MOVE.L  D0,-70(A5)
    JSR     _TEXTDISP_FormatEntryTimeForIndex(PC)

    LEA     56(A7),A7
    MOVE.L  #$264,-16(A5)
    TST.L   -62(A5)
    BEQ.S   .measure_comma_space

    MOVEA.L -62(A5),A0
    TST.B   (A0)
    BEQ.S   .measure_comma_space

    LEA     60(A3),A1

.scan_suffix_end:
    TST.B   (A0)+
    BNE.S   .scan_suffix_end

    SUBQ.L  #1,A0
    SUBA.L  -62(A5),A0
    MOVE.L  A0,D0
    MOVEA.L -62(A5),A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    LEA     60(A3),A0
    MOVE.L  D0,24(A7)
    MOVEA.L A0,A1
    LEA     _Global_STR_SINGLE_SPACE_3,A0
    MOVEQ   #1,D0
    JSR     _LVOTextLength(A6)

    MOVE.L  24(A7),D1
    ADD.L   D0,D1
    SUB.L   D1,-16(A5)

.measure_comma_space:
    LEA     60(A3),A0
    MOVEA.L A0,A1
    LEA     _Global_STR_COMMA_AND_SINGLE_SPACE_1,A0
    MOVEQ   #2,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,-20(A5)
    TST.L   -54(A5)
    BEQ.W   .return

    BSR.W   _NEWGRID_ResetShowtimeBuckets

    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    MOVE.L  12(A2),D1
    CMP.L   D0,D1
    BGT.S   .clamp_start_index

    TST.L   D1
    BPL.S   .clamp_start_done

.clamp_start_index:
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,12(A2)

.clamp_start_done:
    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    MOVE.L  16(A2),D1
    CMP.L   D0,D1
    BGT.S   .clamp_end_index

    TST.L   D1
    BPL.S   .clamp_end_done

.clamp_end_index:
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,16(A2)

.clamp_end_done:
    MOVE.W  22(A2),D0
    EXT.L   D0
    ADD.L   _GCOMMAND_PpvShowtimesRowSpan,D0
    ADDQ.L  #1,D0
    MOVE.W  D0,-8(A5)
    MOVEQ   #97,D1
    CMP.W   D1,D0
    BLE.S   .setup_row_range

    MOVE.W  D1,-8(A5)

.setup_row_range:
    MOVE.W  22(A2),D6

.row_loop:
    CMP.W   -8(A5),D6
    BGE.W   .ensure_showing_at_prefix

    MOVE.L  -16(A5),D0
    TST.L   D0
    BPL.S   .row_check_width

    CMP.W   24(A2),D6
    BGE.W   .ensure_showing_at_prefix

.row_check_width:
    MOVE.L  12(A2),-12(A5)

.col_loop:
    MOVE.L  -12(A5),D0
    CMP.L   16(A2),D0
    BGE.W   .row_next

    MOVE.L  -16(A5),D1
    TST.L   D1
    BPL.S   .col_check_width

    CMP.W   24(A2),D6
    BGE.W   .row_next

.col_check_width:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  -12(A5),-(A7)
    MOVE.L  D0,-(A7)
    PEA     -98(A5)
    PEA     -94(A5)
    BSR.W   _NEWGRID_UpdatePresetEntry

    LEA     16(A7),A7
    MOVE.L  D0,D7
    TST.L   -94(A5)
    BEQ.W   .col_next

    TST.L   -98(A5)
    BEQ.W   .col_next

    MOVEA.L -94(A5),A0
    MOVE.W  46(A0),D0
    BTST    #4,D0
    BEQ.W   .col_next

    MOVE.B  40(A0),D0
    BTST    #7,D0
    BEQ.W   .col_next

    CMP.W   22(A2),D6
    BNE.S   .match_adjust

    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -98(A5),-(A7)
    MOVE.L  A0,-(A7)
    JSR     _NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex(PC)

    MOVE.L  D0,D7
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  _GCOMMAND_PpvSelectionToleranceMinutes,(A7)
    MOVE.L  _GCOMMAND_PpvSelectionWindowMinutes,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -98(A5),-(A7)
    MOVE.L  -94(A5),-(A7)
    JSR     _NEWGRID2_JMPTBL_COI_ProcessEntrySelectionState(PC)

    LEA     28(A7),A7
    TST.L   D0
    BNE.S   .match_adjust

    SUBA.L  A0,A0
    MOVE.L  A0,-98(A5)

.match_adjust:
    TST.L   -98(A5)
    BEQ.W   .col_next

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -98(A5),A0
    ADDA.L  D0,A0
    TST.L   56(A0)
    BEQ.W   .col_next

    MOVEA.L -98(A5),A0
    ADDA.W  D7,A0
    MOVEQ   #-96,D0
    AND.B   7(A0),D0
    TST.B   D0
    BNE.W   .col_next

    MOVEA.L -94(A5),A0
    ADDA.W  #$1c,A0
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _NEWGRID2_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.W   .col_next

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -98(A5),A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L A0,A6
    ADDA.L  D0,A6
    MOVEA.L 56(A6),A6
    MOVEQ   #40,D1
    CMP.B   (A6),D1
    BNE.S   .time_prefix_check

    ADDA.L  D0,A0
    MOVEA.L 56(A0),A6
    ADDQ.L  #3,A6
    MOVEQ   #58,D0
    CMP.B   (A6),D0
    BNE.S   .time_prefix_check

    MOVEQ   #8,D0
    BRA.S   .time_prefix_done

.time_prefix_check:
    MOVEQ   #0,D0

.time_prefix_done:
    MOVEA.L 56(A1),A0
    ADDA.L  D0,A0
    MOVE.L  D7,D0
    EXT.L   D0
    PEA     1.W
    MOVE.L  D0,-(A7)
    MOVE.L  -94(A5),-(A7)
    MOVE.L  A0,-74(A5)
    JSR     _NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    MOVE.L  D7,D1
    EXT.L   D1
    PEA     2.W
    MOVE.L  D1,-(A7)
    MOVE.L  -94(A5),-(A7)
    MOVE.L  D0,-78(A5)
    JSR     _NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    MOVE.L  D7,D1
    EXT.L   D1
    PEA     6.W
    MOVE.L  D1,-(A7)
    MOVE.L  -94(A5),-(A7)
    MOVE.L  D0,-82(A5)
    JSR     _NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    MOVE.L  D7,D1
    EXT.L   D1
    PEA     7.W
    MOVE.L  D1,-(A7)
    MOVE.L  -94(A5),-(A7)
    MOVE.L  D0,-86(A5)
    JSR     _NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    LEA     48(A7),A7
    MOVE.L  D0,-90(A5)
    TST.L   -74(A5)
    BEQ.W   .col_next

    MOVEA.L -54(A5),A0
    MOVEA.L -74(A5),A1
    CMPA.L  A0,A1
    BEQ.W   .col_next

.compare_title:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.W   .col_next

    TST.B   D0
    BNE.S   .compare_title

    BNE.W   .col_next

    MOVEA.L -58(A5),A0
    MOVEA.L -78(A5),A1
    CMPA.L  A0,A1
    BEQ.S   .compare_subtitle

    MOVE.L  A0,D0
    BEQ.W   .col_next

    MOVE.L  A1,D0
    BEQ.W   .col_next

.compare_title_loop:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.W   .col_next

    TST.B   D0
    BNE.S   .compare_title_loop

    BNE.W   .col_next

.compare_subtitle:
    MOVEA.L -62(A5),A0
    MOVEA.L -82(A5),A1
    CMPA.L  A0,A1
    BEQ.S   .compare_genre

    MOVE.L  A0,D0
    BEQ.W   .col_next

    MOVE.L  A1,D0
    BEQ.W   .col_next

.compare_subtitle_loop:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.W   .col_next

    TST.B   D0
    BNE.S   .compare_subtitle_loop

    BNE.W   .col_next

.compare_genre:
    MOVEA.L -66(A5),A0
    MOVEA.L -86(A5),A1
    CMPA.L  A0,A1
    BEQ.S   .compare_rating

    MOVE.L  A0,D0
    BEQ.W   .col_next

    MOVE.L  A1,D0
    BEQ.W   .col_next

.compare_genre_loop:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.W   .col_next

    TST.B   D0
    BNE.S   .compare_genre_loop

    BNE.W   .col_next

.compare_rating:
    MOVEA.L -70(A5),A0
    MOVEA.L -90(A5),A1
    CMPA.L  A0,A1
    BEQ.S   .mark_and_append

    MOVE.L  A0,D0
    BEQ.W   .col_next

    MOVE.L  A1,D0
    BEQ.W   .col_next

.compare_rating_loop:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.W   .col_next

    TST.B   D0
    BNE.S   .compare_rating_loop

    BNE.W   .col_next

.mark_and_append:
    MOVEA.L -98(A5),A0
    ADDA.W  D7,A0
    BSET    #5,7(A0)
    MOVE.L  -16(A5),D0
    TST.L   D0
    BLE.W   .col_next

    MOVEA.L 16(A5),A0
    TST.B   (A0)
    BNE.S   .append_entry_text

    LEA     _Global_STR_SHOWTIMES_AND_SINGLE_SPACE,A0
    MOVEA.L 16(A5),A1

.copy_showtimes_prefix:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_showtimes_prefix

    PEA     -49(A5)
    JSR     _NEWGRID2_JMPTBL_STR_SkipClass3Chars(PC)

    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-28(A5)
    BSR.W   _NEWGRID_AddShowtimeBucketEntry

    ADDQ.W  #8,A7
    LEA     60(A3),A0
    LEA     _Global_STR_SHOWTIMES_AND_SINGLE_SPACE,A1
    MOVEA.L A1,A6

.measure_showtimes_prefix:
    TST.B   (A6)+
    BNE.S   .measure_showtimes_prefix

    SUBQ.L  #1,A6
    SUBA.L  A1,A6
    MOVEA.L A0,A1
    MOVE.L  A6,D0
    LEA     _Global_STR_SHOWTIMES_AND_SINGLE_SPACE,A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    SUB.L   D0,-16(A5)
    LEA     60(A3),A0
    MOVEA.L -28(A5),A1

.measure_entry_text:
    TST.B   (A1)+
    BNE.S   .measure_entry_text

    SUBQ.L  #1,A1
    SUBA.L  -28(A5),A1
    MOVE.L  A1,28(A7)
    MOVEA.L A0,A1
    MOVEA.L -28(A5),A0
    MOVE.L  28(A7),D0
    JSR     _LVOTextLength(A6)

    SUB.L   D0,-16(A5)

.append_entry_text:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  -98(A5),-(A7)
    MOVE.L  D0,-(A7)
    PEA     -49(A5)
    JSR     _TEXTDISP_FormatEntryTimeForIndex(PC)

    PEA     -49(A5)
    JSR     _NEWGRID2_JMPTBL_STR_SkipClass3Chars(PC)

    LEA     16(A7),A7
    LEA     60(A3),A0
    MOVEA.L D0,A1

.measure_entry_text2:
    TST.B   (A1)+
    BNE.S   .measure_entry_text2

    SUBQ.L  #1,A1
    SUBA.L  D0,A1
    MOVE.L  D0,-28(A5)
    MOVE.L  A1,28(A7)
    MOVEA.L A0,A1
    MOVEA.L D0,A0
    MOVE.L  28(A7),D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  -20(A5),D1
    ADD.L   D0,D1
    MOVEM.L D1,-24(A5)
    MOVE.L  -16(A5),D0
    CMP.L   D1,D0
    BLT.S   .measure_showtime_text

    MOVEQ   #48,D0
    CMP.W   D0,D6
    BLE.S   .append_showtime_entry

    MOVE.L  D7,D0
    EXT.L   D0
    MOVEQ   #48,D1
    ADD.L   D1,D0
    BRA.S   .append_showtime_entry2

.append_showtime_entry:
    MOVE.L  D7,D0
    EXT.L   D0

.append_showtime_entry2:
    MOVE.L  D0,-(A7)
    MOVE.L  -28(A5),-(A7)
    BSR.W   _NEWGRID_AddShowtimeBucketEntry

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .col_next

.measure_showtime_text:
    LEA     60(A3),A0
    MOVEA.L -28(A5),A1

.measure_showtime_text2:
    TST.B   (A1)+
    BNE.S   .measure_showtime_text2

    SUBQ.L  #1,A1
    SUBA.L  -28(A5),A1
    MOVE.L  A1,28(A7)
    MOVEA.L A0,A1
    MOVEA.L -28(A5),A0
    MOVE.L  28(A7),D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  -20(A5),D1
    ADD.L   D0,D1
    SUB.L   D1,-16(A5)

.col_next:
    ADDQ.L  #1,-12(A5)
    BRA.W   .col_loop

.row_next:
    ADDQ.W  #1,D6
    BRA.W   .row_loop

.ensure_showing_at_prefix:
    MOVEA.L 16(A5),A0
    TST.B   (A0)
    BNE.S   .append_showing_at

    LEA     _Global_STR_SHOWING_AT_AND_SINGLE_SPACE,A0
    MOVEA.L 16(A5),A1

.copy_showing_at_prefix:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_showing_at_prefix

    PEA     -49(A5)
    JSR     _NEWGRID2_JMPTBL_STR_SkipClass3Chars(PC)

    MOVE.L  D0,(A7)
    MOVE.L  16(A5),-(A7)
    MOVE.L  D0,-28(A5)
    JSR     _PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7
    BRA.S   .append_genre

.append_showing_at:
    MOVE.L  A0,-(A7)
    BSR.W   _NEWGRID_AppendShowtimeBuckets

    ADDQ.W  #4,A7

.append_genre:
    TST.L   -62(A5)
    BEQ.S   .return

    MOVEA.L -62(A5),A0
    TST.B   (A0)
    BEQ.S   .return

    PEA     _NEWGRID_ShowtimeGenreSpacer
    MOVE.L  16(A5),-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    MOVE.L  -62(A5),(A7)
    MOVE.L  16(A5),-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    LEA     12(A7),A7

.return:
    MOVEM.L (A7)+,D5-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _NEWGRID_HandleShowtimesState   (Execute one step of showtimes/detail grid state machine)
; ARGS:
;   stack +8: A3 = rastport
;   stack +12: A2 = entry state
; RET:
;   D0: state (NEWGRID_ShowtimesWorkflowStateLatch)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _NEWGRID_DrawGridEntry, NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex, NEWGRID_BuildShowtimesText, _NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer,
;   _NEWGRID_DrawGridFrameVariant3, _NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount, _NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams
; READS:
;   NEWGRID_ShowtimesWorkflowStateLatch, _GCOMMAND_PpvShowtimesLayoutPen, _GCOMMAND_PpvShowtimesInitialLineIndex, _GCOMMAND_PpvDetailLayoutFlag
; WRITES:
;   NEWGRID_ShowtimesWorkflowStateLatch, 32(A3)
; DESC:
;   State machine that draws showtimes/details in a grid view.
;------------------------------------------------------------------------------
_NEWGRID_HandleShowtimesState:
    LINK.W  A5,#-132
    MOVEM.L D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  A3,D0
    BNE.S   .state_check

    MOVEQ   #4,D0
    MOVE.L  D0,NEWGRID_ShowtimesWorkflowStateLatch
    BRA.W   .return_state

.state_check:
    MOVE.L  NEWGRID_ShowtimesWorkflowStateLatch,D0
    SUBQ.L  #4,D0
    BEQ.S   .state4_begin

    SUBQ.L  #1,D0
    BEQ.W   .state5_reset

    BRA.W   .force_state4

.state4_begin:
    TST.L   (A2)
    BEQ.W   .return_state

    TST.L   4(A2)
    BEQ.W   .return_state

    MOVE.L  _GCOMMAND_PpvShowtimesLayoutPen,-(A7)
    PEA     20.W
    PEA     612.W
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(PC)

    LEA     12(A7),A7
    MOVE.W  20(A2),D7
    MOVEQ   #48,D0
    CMP.W   D0,D7
    BLE.S   .adjust_row

    SUBI.W  #$30,D7

.adjust_row:
    MOVE.B  _GCOMMAND_PpvDetailLayoutFlag,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BNE.S   .draw_entry_mode2

    LEA     60(A3),A0
    MOVE.L  D7,D0
    EXT.L   D0
    PEA     -1.W
    PEA     1.W
    PEA     2.W
    MOVE.L  D0,-(A7)
    MOVE.L  4(A2),-(A7)
    MOVE.L  (A2),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   _NEWGRID_DrawGridEntry

    LEA     28(A7),A7
    BRA.S   .after_draw

.draw_entry_mode2:
    LEA     60(A3),A0
    MOVE.L  D7,D0
    EXT.L   D0
    PEA     -1.W
    PEA     1.W
    PEA     3.W
    MOVE.L  D0,-(A7)
    MOVE.L  4(A2),-(A7)
    MOVE.L  (A2),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   _NEWGRID_DrawGridEntry

    LEA     28(A7),A7

.after_draw:
    MOVE.L  _GCOMMAND_PpvShowtimesInitialLineIndex,-(A7)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex(PC)

    PEA     -130(A5)
    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_BuildShowtimesText

    LEA     60(A3),A0
    PEA     -130(A5)
    MOVE.L  A0,-(A7)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(PC)

    MOVE.L  A3,(A7)
    BSR.W   _NEWGRID_DrawGridFrameVariant3

    LEA     24(A7),A7
    TST.L   D0
    BEQ.S   .store_state

    MOVEQ   #4,D0
    BRA.S   .store_state2

.store_state:
    MOVEQ   #5,D0

.store_state2:
    PEA     2.W
    MOVE.L  D0,NEWGRID_ShowtimesWorkflowStateLatch
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,32(A3)
    BRA.S   .return_state

.state5_reset:
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_DrawGridFrameVariant3

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .state5_done

    MOVEQ   #4,D0
    BRA.S   .store_state3

.state5_done:
    MOVEQ   #5,D0

.store_state3:
    MOVEQ   #-1,D1
    MOVE.L  D1,32(A3)
    MOVE.L  D0,NEWGRID_ShowtimesWorkflowStateLatch
    BRA.S   .return_state

.force_state4:
    MOVEQ   #4,D0
    MOVE.L  D0,NEWGRID_ShowtimesWorkflowStateLatch

.return_state:
    MOVE.L  NEWGRID_ShowtimesWorkflowStateLatch,D0
    MOVEM.L (A7)+,D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_ProcessShowtimesWorkflow   (Top-level showtimes workflow dispatcher)
; ARGS:
;   stack +8: A3 = rastport
;   stack +14: D7 = row index
; RET:
;   D0: state (_NEWGRID_ShowtimesWorkflowState)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _NEWGRID_HandleGridEditorState, _NEWGRID_UpdateGridState,
;   _NEWGRID_HandleShowtimesState, _NEWGRID_InitSelectionWindow,
;   _NEWGRID_UpdateSelectionFromInput, _NEWGRID_DrawGridMessageAlt,
;   _NEWGRID_ClearEntryMarkerBits, _NEWGRID_ValidateSelectionCode,
;   _NEWGRID_GetGridModeIndex, _NEWGRID_ComputeColumnIndex
; READS:
;   _NEWGRID_ShowtimesWorkflowState/2038, _NEWGRID_ShowtimesSelectionContextPtr, _GCOMMAND_DigitalPpvEnabledFlag, _GCOMMAND_PpvShowtimesWorkflowMode, _GCOMMAND_PPVListingsTemplatePtr, _GCOMMAND_PpvEditorLayoutPen, _GCOMMAND_PpvEditorRowPen
; WRITES:
;   _NEWGRID_ShowtimesWorkflowState/2038
; DESC:
;   Multi-state handler for showtimes selection and detail views.
; NOTES:
;   Uses a switch/jumptable for state dispatch.
;------------------------------------------------------------------------------
NEWGRID_ProcessShowtimesWorkflow:
    LINK.W  A5,#-4
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVEQ   #0,D6
    MOVE.L  A3,D0
    BNE.W   .dispatch_workflow_state

    MOVE.L  _NEWGRID_ShowtimesWorkflowState,D0
    SUBQ.L  #2,D0
    BEQ.S   .legacy_nullctx_editor_reset

    SUBQ.L  #3,D0
    BEQ.S   .legacy_nullctx_route_by_editor_gate

    SUBQ.L  #2,D0
    BNE.S   .legacy_nullctx_reinit_selection_and_clear

.legacy_nullctx_editor_reset:
    CLR.L   -(A7)
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_HandleGridEditorState

    LEA     16(A7),A7
    MOVE.L  D0,_NEWGRID_ShowtimesWorkflowState
    BRA.S   .legacy_nullctx_reinit_selection_and_clear

.legacy_nullctx_route_by_editor_gate:
    MOVE.L  _NEWGRID_ShowtimesSelectionContextPtr,-(A7)
    JSR     _NEWGRID_ShouldOpenEditor(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .legacy_nullctx_run_showtimes_state

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_UpdateGridState

    LEA     12(A7),A7
    MOVE.L  D0,_NEWGRID_ShowtimesWorkflowState
    BRA.S   .legacy_nullctx_reinit_selection_and_clear

.legacy_nullctx_run_showtimes_state:
    CLR.L   -(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_HandleShowtimesState

    ADDQ.W  #8,A7
    MOVE.L  D0,_NEWGRID_ShowtimesWorkflowState

.legacy_nullctx_reinit_selection_and_clear:
    CLR.L   -(A7)
    PEA     _NEWGRID_ShowtimesSelectionContextPtr
    BSR.W   _NEWGRID_InitSelectionWindow

    ADDQ.W  #8,A7
    MOVEQ   #0,D0
    MOVE.L  D0,_NEWGRID_ShowtimesWorkflowState
    BRA.W   .return_state

.dispatch_workflow_state:
    MOVE.L  _NEWGRID_ShowtimesWorkflowState,D0
    CMPI.L  #$8,D0
    BCC.W   .clear_workflow_state

    ADD.W   D0,D0
    MOVE.W  .state_jumptable(PC,D0.W),D0
    JMP     .state_jumptable+2(PC,D0.W)

; switch/jumptable
.state_jumptable:
    DC.W    .case_state0-.state_jumptable-2
    DC.W    .case_state1-.state_jumptable-2
    DC.W    .case_state2-.state_jumptable-2
    DC.W    .case_state3_or4-.state_jumptable-2
    DC.W    .case_state3_or4-.state_jumptable-2
    DC.W    .case_state5-.state_jumptable-2
    DC.W    .clear_workflow_state-.state_jumptable-2
    DC.W    .case_state6-.state_jumptable-2

.case_state0:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     _NEWGRID_ShowtimesSelectionContextPtr
    BSR.W   _NEWGRID_InitSelectionWindow

    PEA     _NEWGRID_ShowtimesSelectionContextPtr
    MOVE.L  _NEWGRID_ShowtimesWorkflowState,-(A7)
    BSR.W   _NEWGRID_UpdateSelectionFromInput

    LEA     16(A7),A7
    TST.L   D0
    BEQ.W   .return_state

    MOVEQ   #1,D0
    MOVE.L  D0,_NEWGRID_ShowtimesWorkflowState

.case_state1:
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_DrawGridMessageAlt

    ADDQ.W  #4,A7
    CLR.L   _NEWGRID_ShowtimesColumnAdjust
    MOVEQ   #2,D0
    MOVE.L  D0,_NEWGRID_ShowtimesWorkflowState
    BRA.W   .return_state

.case_state2:
    MOVE.B  _GCOMMAND_PpvShowtimesWorkflowMode,D0
    MOVEQ   #66,D1
    CMP.B   D1,D0
    BEQ.S   .case2_handle

    MOVEQ   #70,D1
    CMP.B   D1,D0
    BNE.S   .case2_force_state3

.case2_handle:
    MOVE.L  _GCOMMAND_PPVListingsTemplatePtr,-(A7)
    MOVE.L  _GCOMMAND_PpvEditorRowPen,-(A7)
    MOVE.L  _GCOMMAND_PpvEditorLayoutPen,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_HandleGridEditorState

    LEA     16(A7),A7
    MOVE.L  D0,_NEWGRID_ShowtimesWorkflowState
    SUBQ.L  #5,D0
    BNE.S   .case2_done

    MOVEQ   #2,D0
    MOVE.L  D0,_NEWGRID_ShowtimesWorkflowState
    BRA.W   .return_state

.case2_done:
    MOVEQ   #3,D0
    MOVE.L  D0,_NEWGRID_ShowtimesWorkflowState
    BRA.W   .return_state

.case2_force_state3:
    MOVEQ   #3,D0
    MOVE.L  D0,_NEWGRID_ShowtimesWorkflowState

.case_state3_or4:
    PEA     _NEWGRID_ShowtimesSelectionContextPtr
    MOVE.L  _NEWGRID_ShowtimesWorkflowState,-(A7)
    BSR.W   _NEWGRID_UpdateSelectionFromInput

    ADDQ.W  #8,A7
    MOVEQ   #1,D6

.case_state5:
    TST.L   _NEWGRID_ShowtimesSelectionContextPtr
    BEQ.W   .case5_no_entry

    MOVE.L  _NEWGRID_ShowtimesSelectionContextPtr,-(A7)
    JSR     _NEWGRID_ShouldOpenEditor(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .case5_update

    MOVE.W  _NEWGRID_ShowtimesWorkflowArgWord,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  _NEWGRID_ShowtimesWorkflowArgLong,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_UpdateGridState

    LEA     12(A7),A7
    MOVE.L  D0,_NEWGRID_ShowtimesWorkflowState
    BRA.S   .case5_post

.case5_update:
    PEA     _NEWGRID_ShowtimesSelectionContextPtr
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_HandleShowtimesState

    ADDQ.W  #8,A7
    MOVE.L  D0,_NEWGRID_ShowtimesWorkflowState

.case5_post:
    MOVE.B  _GCOMMAND_DigitalPpvEnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.W   .return_state

    TST.L   D6
    BEQ.S   .update_column_adjust

    CMPI.L  #$1,_NEWGRID_ShowtimesColumnAdjust
    BGE.S   .update_column_adjust

    PEA     53.W
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_ValidateSelectionCode

    BSR.W   _NEWGRID_GetGridModeIndex

    ADDQ.W  #8,A7
    MOVE.L  D0,_NEWGRID_ShowtimesColumnAdjust

.update_column_adjust:
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_ComputeColumnIndex

    ADDQ.W  #4,A7
    SUB.L   D0,_NEWGRID_ShowtimesColumnAdjust
    BRA.S   .return_state

.case5_no_entry:
    MOVEQ   #7,D0
    MOVE.L  D0,_NEWGRID_ShowtimesWorkflowState

.case_state6:
    MOVE.B  _GCOMMAND_PpvShowtimesWorkflowMode,D0
    MOVEQ   #66,D1
    CMP.B   D1,D0
    BEQ.S   .case6_handle

    MOVEQ   #76,D1
    CMP.B   D1,D0
    BNE.S   .case6_clear_state

.case6_handle:
    MOVE.L  _GCOMMAND_PPVListingsTemplatePtr,-(A7)
    MOVE.L  _GCOMMAND_PpvEditorRowPen,-(A7)
    MOVE.L  _GCOMMAND_PpvEditorLayoutPen,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_HandleGridEditorState

    LEA     16(A7),A7
    MOVE.L  D0,_NEWGRID_ShowtimesWorkflowState
    SUBQ.L  #5,D0
    BNE.S   .case6_done

    MOVEQ   #7,D0
    MOVE.L  D0,_NEWGRID_ShowtimesWorkflowState
    BRA.S   .return_state

.case6_done:
    MOVEQ   #0,D0
    MOVE.L  D0,_NEWGRID_ShowtimesWorkflowState
    BRA.S   .return_state

.case6_clear_state:
    CLR.L   _NEWGRID_ShowtimesWorkflowState
    BRA.S   .return_state

.clear_workflow_state:
    CLR.L   _NEWGRID_ShowtimesWorkflowState

.return_state:
    TST.L   _NEWGRID_ShowtimesWorkflowState
    BNE.S   .maybe_clear_markers

    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   _NEWGRID_ClearEntryMarkerBits

    ADDQ.W  #4,A7

.maybe_clear_markers:
    MOVE.L  _NEWGRID_ShowtimesWorkflowState,D0
    MOVEM.L (A7)+,D6-D7/A3
    UNLK    A5
    RTS

;!======