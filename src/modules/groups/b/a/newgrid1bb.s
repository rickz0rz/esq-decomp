    XDEF    NEWGRID_AddShowtimeBucketEntry
    XDEF    NEWGRID_AppendShowtimeBuckets
    XDEF    NEWGRID_AppendShowtimesForRow
    XDEF    NEWGRID_BuildShowtimesText
    XDEF    NEWGRID_ClearMarkersIfSelectable
    XDEF    NEWGRID_DrawGridFrameVariant4
    XDEF    NEWGRID_DrawShowtimesPrompt
    XDEF    NEWGRID_HandleShowtimesState
    XDEF    NEWGRID_InitSelectionWindowAlt
    XDEF    NEWGRID_ProcessShowtimesWorkflow
    XDEF    NEWGRID_ResetShowtimeBuckets
    XDEF    NEWGRID_TestEntrySelectable
    XDEF    NEWGRID_TestModeFlagActive
    XDEF    NEWGRID_TestPrimeTimeWindow
    XDEF    NEWGRID_UpdateSelectionFromInputAlt

;------------------------------------------------------------------------------
; FUNC: NEWGRID_ResetShowtimeBuckets   (Reset showtime buckets)
; ARGS:
;   none
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A1
; CALLS:
;   PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString
; READS:
;   _NEWGRID_ShowtimeBucketEntryTable
; WRITES:
;   NEWGRID_ShowtimeBucketCount, _NEWGRID_ShowtimeBucketEntryTable
; DESC:
;   Clears bucket count and reinitializes bucket records.
;------------------------------------------------------------------------------
NEWGRID_ResetShowtimeBuckets:
    LINK.W  A5,#-8
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D0
    MOVE.L  D0,NEWGRID_ShowtimeBucketCount
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
    JSR     PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

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
; FUNC: NEWGRID_AddShowtimeBucketEntry   (Insert showtime bucket entry)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +16: arg_3 (via 20(A5))
; RET:
;   D0: 1 if inserted, 0 if not
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   PARSEINI_JMPTBL_STR_FindCharPtr, SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt, PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString
; READS:
;   _NEWGRID_ShowtimeBucketEntryTable, _NEWGRID_ShowtimeBucketPtrTable, NEWGRID_ShowtimeBucketCount
; WRITES:
;   _NEWGRID_ShowtimeBucketEntryTable, _NEWGRID_ShowtimeBucketPtrTable, NEWGRID_ShowtimeBucketCount
; DESC:
;   Adds an entry into the sorted bucket list if capacity allows.
; NOTES:
;   Uses insertion-style shifting to keep buckets sorted.
;------------------------------------------------------------------------------
NEWGRID_AddShowtimeBucketEntry:
    LINK.W  A5,#-28
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    CLR.L   -20(A5)
    PEA     58.W
    MOVE.L  A3,-(A7)
    JSR     PARSEINI_JMPTBL_STR_FindCharPtr(PC)

    MOVEA.L D0,A0
    LEA     1(A0),A1
    MOVE.L  A1,(A7)
    MOVE.L  A1,-4(A5)
    JSR     SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D6
    MOVE.L  D7,D0
    ASL.L   #8,D0
    ADD.L   D0,D6
    MOVE.L  NEWGRID_ShowtimeBucketCount,D0
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
    JSR     PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVEA.L 24(A7),A0
    MOVE.L  D0,4(A0)
    MOVE.L  NEWGRID_ShowtimeBucketCount,D5

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
    MOVE.L  NEWGRID_ShowtimeBucketCount,D4

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
    MOVE.L  NEWGRID_ShowtimeBucketCount,D0
    MOVE.L  D0,D1
    ASL.L   #3,D1
    LEA     _NEWGRID_ShowtimeBucketEntryTable,A1
    ADDA.L  D1,A1
    MOVE.L  A1,(A0)
    ADDQ.L  #1,NEWGRID_ShowtimeBucketCount
    MOVEQ   #1,D0
    MOVE.L  D0,-20(A5)

.return:
    MOVE.L  -20(A5),D0
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_AppendShowtimeBuckets   (Append showtime buckets to buffer)
; ARGS:
;   stack +8: A3 = output buffer
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   PARSEINI_JMPTBL_STRING_AppendAtNull
; READS:
;   _NEWGRID_ShowtimeBucketPtrTable, NEWGRID_ShowtimeBucketCount, NEWGRID_ShowtimeBucketSeparator
; WRITES:
;   output buffer contents
; DESC:
;   Appends each bucket’s data into the output buffer.
;------------------------------------------------------------------------------
NEWGRID_AppendShowtimeBuckets:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEA.L _NEWGRID_ShowtimeBucketPtrTable,A0
    MOVE.L  4(A0),-(A7)
    MOVE.L  A3,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7
    MOVEQ   #1,D7

.append_loop:
    CMP.L   NEWGRID_ShowtimeBucketCount,D7
    BGE.S   .return

    PEA     NEWGRID_ShowtimeBucketSeparator
    MOVE.L  A3,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _NEWGRID_ShowtimeBucketPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  4(A1),(A7)
    MOVE.L  A3,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

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
;   NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer, TEXTDISP_FormatEntryTimeForIndex, NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex, NEWGRID2_JMPTBL_ESQ_TestBit1Based, NEWGRID2_JMPTBL_COI_ProcessEntrySelectionState, NEWGRID2_JMPTBL_STR_SkipClass3Chars,
;   NEWGRID_ResetShowtimeBuckets, NEWGRID_AddShowtimeBucketEntry,
;   NEWGRID_AppendShowtimeBuckets, PARSEINI_JMPTBL_STRING_AppendAtNull
; READS:
;   TEXTDISP_PrimaryGroupPresentFlag, TEXTDISP_PrimaryGroupEntryCount, GCOMMAND_PpvSelectionWindowMinutes, GCOMMAND_PpvShowtimesRowSpan, _NEWGRID_ShowtimeBucketEntryTable..2339
; WRITES:
;   output buffer contents, NEWGRID_ShowtimeBucketCount
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

    TST.B   TEXTDISP_PrimaryGroupPresentFlag
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
    JSR     NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    PEA     2.W
    MOVE.L  D1,-(A7)
    MOVE.L  (A2),-(A7)
    MOVE.L  D0,-58(A5)
    JSR     NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    PEA     6.W
    MOVE.L  D1,-(A7)
    MOVE.L  (A2),-(A7)
    MOVE.L  D0,-62(A5)
    JSR     NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    PEA     7.W
    MOVE.L  D1,-(A7)
    MOVE.L  (A2),-(A7)
    MOVE.L  D0,-66(A5)
    JSR     NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    MOVE.L  4(A2),(A7)
    MOVE.L  D1,-(A7)
    PEA     -49(A5)
    MOVE.L  D0,-70(A5)
    JSR     TEXTDISP_FormatEntryTimeForIndex(PC)

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
    LEA     Global_STR_SINGLE_SPACE_3,A0
    MOVEQ   #1,D0
    JSR     _LVOTextLength(A6)

    MOVE.L  24(A7),D1
    ADD.L   D0,D1
    SUB.L   D1,-16(A5)

.measure_comma_space:
    LEA     60(A3),A0
    MOVEA.L A0,A1
    LEA     Global_STR_COMMA_AND_SINGLE_SPACE_1,A0
    MOVEQ   #2,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,-20(A5)
    TST.L   -54(A5)
    BEQ.W   .return

    BSR.W   NEWGRID_ResetShowtimeBuckets

    MOVEQ   #0,D0
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
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
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
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
    ADD.L   GCOMMAND_PpvShowtimesRowSpan,D0
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
    BSR.W   NEWGRID_UpdatePresetEntry

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
    JSR     NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex(PC)

    MOVE.L  D0,D7
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  GCOMMAND_PpvSelectionToleranceMinutes,(A7)
    MOVE.L  GCOMMAND_PpvSelectionWindowMinutes,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -98(A5),-(A7)
    MOVE.L  -94(A5),-(A7)
    JSR     NEWGRID2_JMPTBL_COI_ProcessEntrySelectionState(PC)

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
    JSR     NEWGRID2_JMPTBL_ESQ_TestBit1Based(PC)

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
    JSR     NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    MOVE.L  D7,D1
    EXT.L   D1
    PEA     2.W
    MOVE.L  D1,-(A7)
    MOVE.L  -94(A5),-(A7)
    MOVE.L  D0,-78(A5)
    JSR     NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    MOVE.L  D7,D1
    EXT.L   D1
    PEA     6.W
    MOVE.L  D1,-(A7)
    MOVE.L  -94(A5),-(A7)
    MOVE.L  D0,-82(A5)
    JSR     NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    MOVE.L  D7,D1
    EXT.L   D1
    PEA     7.W
    MOVE.L  D1,-(A7)
    MOVE.L  -94(A5),-(A7)
    MOVE.L  D0,-86(A5)
    JSR     NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

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

    LEA     Global_STR_SHOWTIMES_AND_SINGLE_SPACE,A0
    MOVEA.L 16(A5),A1

.copy_showtimes_prefix:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_showtimes_prefix

    PEA     -49(A5)
    JSR     NEWGRID2_JMPTBL_STR_SkipClass3Chars(PC)

    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-28(A5)
    BSR.W   NEWGRID_AddShowtimeBucketEntry

    ADDQ.W  #8,A7
    LEA     60(A3),A0
    LEA     Global_STR_SHOWTIMES_AND_SINGLE_SPACE,A1
    MOVEA.L A1,A6

.measure_showtimes_prefix:
    TST.B   (A6)+
    BNE.S   .measure_showtimes_prefix

    SUBQ.L  #1,A6
    SUBA.L  A1,A6
    MOVEA.L A0,A1
    MOVE.L  A6,D0
    LEA     Global_STR_SHOWTIMES_AND_SINGLE_SPACE,A0
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
    JSR     TEXTDISP_FormatEntryTimeForIndex(PC)

    PEA     -49(A5)
    JSR     NEWGRID2_JMPTBL_STR_SkipClass3Chars(PC)

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
    BSR.W   NEWGRID_AddShowtimeBucketEntry

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

    LEA     Global_STR_SHOWING_AT_AND_SINGLE_SPACE,A0
    MOVEA.L 16(A5),A1

.copy_showing_at_prefix:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_showing_at_prefix

    PEA     -49(A5)
    JSR     NEWGRID2_JMPTBL_STR_SkipClass3Chars(PC)

    MOVE.L  D0,(A7)
    MOVE.L  16(A5),-(A7)
    MOVE.L  D0,-28(A5)
    JSR     PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7
    BRA.S   .append_genre

.append_showing_at:
    MOVE.L  A0,-(A7)
    BSR.W   NEWGRID_AppendShowtimeBuckets

    ADDQ.W  #4,A7

.append_genre:
    TST.L   -62(A5)
    BEQ.S   .return

    MOVEA.L -62(A5),A0
    TST.B   (A0)
    BEQ.S   .return

    PEA     NEWGRID_ShowtimeGenreSpacer
    MOVE.L  16(A5),-(A7)
    JSR     PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    MOVE.L  -62(A5),(A7)
    MOVE.L  16(A5),-(A7)
    JSR     PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    LEA     12(A7),A7

.return:
    MOVEM.L (A7)+,D5-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_HandleShowtimesState   (Execute one step of showtimes/detail grid state machine)
; ARGS:
;   stack +8: A3 = rastport
;   stack +12: A2 = entry state
; RET:
;   D0: state (NEWGRID_ShowtimesWorkflowStateLatch)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   NEWGRID_DrawGridEntry, NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex, NEWGRID_BuildShowtimesText, NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer,
;   NEWGRID_DrawGridFrameVariant3, NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount, NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams
; READS:
;   NEWGRID_ShowtimesWorkflowStateLatch, GCOMMAND_PpvShowtimesLayoutPen, GCOMMAND_PpvShowtimesInitialLineIndex, GCOMMAND_PpvDetailLayoutFlag
; WRITES:
;   NEWGRID_ShowtimesWorkflowStateLatch, 32(A3)
; DESC:
;   State machine that draws showtimes/details in a grid view.
;------------------------------------------------------------------------------
NEWGRID_HandleShowtimesState:
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

    MOVE.L  GCOMMAND_PpvShowtimesLayoutPen,-(A7)
    PEA     20.W
    PEA     612.W
    JSR     NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(PC)

    LEA     12(A7),A7
    MOVE.W  20(A2),D7
    MOVEQ   #48,D0
    CMP.W   D0,D7
    BLE.S   .adjust_row

    SUBI.W  #$30,D7

.adjust_row:
    MOVE.B  GCOMMAND_PpvDetailLayoutFlag,D0
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
    BSR.W   NEWGRID_DrawGridEntry

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
    BSR.W   NEWGRID_DrawGridEntry

    LEA     28(A7),A7

.after_draw:
    MOVE.L  GCOMMAND_PpvShowtimesInitialLineIndex,-(A7)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex(PC)

    PEA     -130(A5)
    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_BuildShowtimesText

    LEA     60(A3),A0
    PEA     -130(A5)
    MOVE.L  A0,-(A7)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(PC)

    MOVE.L  A3,(A7)
    BSR.W   NEWGRID_DrawGridFrameVariant3

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
    JSR     NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,32(A3)
    BRA.S   .return_state

.state5_reset:
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_DrawGridFrameVariant3

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
;   D0: state (NEWGRID_ShowtimesWorkflowState)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   NEWGRID_HandleGridEditorState, NEWGRID_UpdateGridState,
;   NEWGRID_HandleShowtimesState, NEWGRID_InitSelectionWindow,
;   NEWGRID_UpdateSelectionFromInput, NEWGRID_DrawGridMessageAlt,
;   NEWGRID_ClearEntryMarkerBits, NEWGRID_ValidateSelectionCode,
;   _NEWGRID_GetGridModeIndex, NEWGRID_ComputeColumnIndex
; READS:
;   NEWGRID_ShowtimesWorkflowState/2038, NEWGRID_ShowtimesSelectionContextPtr, GCOMMAND_DigitalPpvEnabledFlag, GCOMMAND_PpvShowtimesWorkflowMode, GCOMMAND_PPVListingsTemplatePtr, GCOMMAND_PpvEditorLayoutPen, GCOMMAND_PpvEditorRowPen
; WRITES:
;   NEWGRID_ShowtimesWorkflowState/2038
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

    MOVE.L  NEWGRID_ShowtimesWorkflowState,D0
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
    BSR.W   NEWGRID_HandleGridEditorState

    LEA     16(A7),A7
    MOVE.L  D0,NEWGRID_ShowtimesWorkflowState
    BRA.S   .legacy_nullctx_reinit_selection_and_clear

.legacy_nullctx_route_by_editor_gate:
    MOVE.L  NEWGRID_ShowtimesSelectionContextPtr,-(A7)
    JSR     NEWGRID_ShouldOpenEditor(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .legacy_nullctx_run_showtimes_state

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_UpdateGridState

    LEA     12(A7),A7
    MOVE.L  D0,NEWGRID_ShowtimesWorkflowState
    BRA.S   .legacy_nullctx_reinit_selection_and_clear

.legacy_nullctx_run_showtimes_state:
    CLR.L   -(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_HandleShowtimesState

    ADDQ.W  #8,A7
    MOVE.L  D0,NEWGRID_ShowtimesWorkflowState

.legacy_nullctx_reinit_selection_and_clear:
    CLR.L   -(A7)
    PEA     NEWGRID_ShowtimesSelectionContextPtr
    BSR.W   NEWGRID_InitSelectionWindow

    ADDQ.W  #8,A7
    MOVEQ   #0,D0
    MOVE.L  D0,NEWGRID_ShowtimesWorkflowState
    BRA.W   .return_state

.dispatch_workflow_state:
    MOVE.L  NEWGRID_ShowtimesWorkflowState,D0
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
    PEA     NEWGRID_ShowtimesSelectionContextPtr
    BSR.W   NEWGRID_InitSelectionWindow

    PEA     NEWGRID_ShowtimesSelectionContextPtr
    MOVE.L  NEWGRID_ShowtimesWorkflowState,-(A7)
    BSR.W   NEWGRID_UpdateSelectionFromInput

    LEA     16(A7),A7
    TST.L   D0
    BEQ.W   .return_state

    MOVEQ   #1,D0
    MOVE.L  D0,NEWGRID_ShowtimesWorkflowState

.case_state1:
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_DrawGridMessageAlt

    ADDQ.W  #4,A7
    CLR.L   NEWGRID_ShowtimesColumnAdjust
    MOVEQ   #2,D0
    MOVE.L  D0,NEWGRID_ShowtimesWorkflowState
    BRA.W   .return_state

.case_state2:
    MOVE.B  GCOMMAND_PpvShowtimesWorkflowMode,D0
    MOVEQ   #66,D1
    CMP.B   D1,D0
    BEQ.S   .case2_handle

    MOVEQ   #70,D1
    CMP.B   D1,D0
    BNE.S   .case2_force_state3

.case2_handle:
    MOVE.L  GCOMMAND_PPVListingsTemplatePtr,-(A7)
    MOVE.L  GCOMMAND_PpvEditorRowPen,-(A7)
    MOVE.L  GCOMMAND_PpvEditorLayoutPen,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_HandleGridEditorState

    LEA     16(A7),A7
    MOVE.L  D0,NEWGRID_ShowtimesWorkflowState
    SUBQ.L  #5,D0
    BNE.S   .case2_done

    MOVEQ   #2,D0
    MOVE.L  D0,NEWGRID_ShowtimesWorkflowState
    BRA.W   .return_state

.case2_done:
    MOVEQ   #3,D0
    MOVE.L  D0,NEWGRID_ShowtimesWorkflowState
    BRA.W   .return_state

.case2_force_state3:
    MOVEQ   #3,D0
    MOVE.L  D0,NEWGRID_ShowtimesWorkflowState

.case_state3_or4:
    PEA     NEWGRID_ShowtimesSelectionContextPtr
    MOVE.L  NEWGRID_ShowtimesWorkflowState,-(A7)
    BSR.W   NEWGRID_UpdateSelectionFromInput

    ADDQ.W  #8,A7
    MOVEQ   #1,D6

.case_state5:
    TST.L   NEWGRID_ShowtimesSelectionContextPtr
    BEQ.W   .case5_no_entry

    MOVE.L  NEWGRID_ShowtimesSelectionContextPtr,-(A7)
    JSR     NEWGRID_ShouldOpenEditor(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .case5_update

    MOVE.W  NEWGRID_ShowtimesWorkflowArgWord,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  NEWGRID_ShowtimesWorkflowArgLong,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_UpdateGridState

    LEA     12(A7),A7
    MOVE.L  D0,NEWGRID_ShowtimesWorkflowState
    BRA.S   .case5_post

.case5_update:
    PEA     NEWGRID_ShowtimesSelectionContextPtr
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_HandleShowtimesState

    ADDQ.W  #8,A7
    MOVE.L  D0,NEWGRID_ShowtimesWorkflowState

.case5_post:
    MOVE.B  GCOMMAND_DigitalPpvEnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.W   .return_state

    TST.L   D6
    BEQ.S   .update_column_adjust

    CMPI.L  #$1,NEWGRID_ShowtimesColumnAdjust
    BGE.S   .update_column_adjust

    PEA     53.W
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_ValidateSelectionCode

    BSR.W   _NEWGRID_GetGridModeIndex

    ADDQ.W  #8,A7
    MOVE.L  D0,NEWGRID_ShowtimesColumnAdjust

.update_column_adjust:
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_ComputeColumnIndex

    ADDQ.W  #4,A7
    SUB.L   D0,NEWGRID_ShowtimesColumnAdjust
    BRA.S   .return_state

.case5_no_entry:
    MOVEQ   #7,D0
    MOVE.L  D0,NEWGRID_ShowtimesWorkflowState

.case_state6:
    MOVE.B  GCOMMAND_PpvShowtimesWorkflowMode,D0
    MOVEQ   #66,D1
    CMP.B   D1,D0
    BEQ.S   .case6_handle

    MOVEQ   #76,D1
    CMP.B   D1,D0
    BNE.S   .case6_clear_state

.case6_handle:
    MOVE.L  GCOMMAND_PPVListingsTemplatePtr,-(A7)
    MOVE.L  GCOMMAND_PpvEditorRowPen,-(A7)
    MOVE.L  GCOMMAND_PpvEditorLayoutPen,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_HandleGridEditorState

    LEA     16(A7),A7
    MOVE.L  D0,NEWGRID_ShowtimesWorkflowState
    SUBQ.L  #5,D0
    BNE.S   .case6_done

    MOVEQ   #7,D0
    MOVE.L  D0,NEWGRID_ShowtimesWorkflowState
    BRA.S   .return_state

.case6_done:
    MOVEQ   #0,D0
    MOVE.L  D0,NEWGRID_ShowtimesWorkflowState
    BRA.S   .return_state

.case6_clear_state:
    CLR.L   NEWGRID_ShowtimesWorkflowState
    BRA.S   .return_state

.clear_workflow_state:
    CLR.L   NEWGRID_ShowtimesWorkflowState

.return_state:
    TST.L   NEWGRID_ShowtimesWorkflowState
    BNE.S   .maybe_clear_markers

    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   NEWGRID_ClearEntryMarkerBits

    ADDQ.W  #4,A7

.maybe_clear_markers:
    MOVE.L  NEWGRID_ShowtimesWorkflowState,D0
    MOVEM.L (A7)+,D6-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_TestModeFlagActive   (Test mode-specific gate flag)
; ARGS:
;   stack +8: D7 = mode selector (0/1)
; RET:
;   D0: 1 if flag set, 0 otherwise
; CLOBBERS:
;   D0-D7
; CALLS:
;   none
; READS:
;   CONFIG_NewgridSelectionCode34PrimaryEnabledFlag, CONFIG_NewgridSelectionCode34AltEnabledFlag
; DESC:
;   Returns whether the corresponding global flag is set for the mode.
;------------------------------------------------------------------------------
NEWGRID_TestModeFlagActive:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7
    TST.L   D7
    BNE.S   .check_mode1

    MOVE.B  CONFIG_NewgridSelectionCode34PrimaryEnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BEQ.S   .return_true

.check_mode1:
    MOVEQ   #1,D0
    CMP.L   D0,D7
    BNE.S   .return_false

    MOVE.B  CONFIG_NewgridSelectionCode34AltEnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BEQ.S   .return_true

.return_false:
    MOVEQ   #0,D0
    BRA.S   .return

.return_true:
    MOVEQ   #1,D0

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======

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
;   NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode, NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode, NEWGRID_TestEntrySelectable
; READS:
;   TEXTDISP_PrimaryGroupEntryCount, TEXTDISP_SecondaryGroupEntryCount, TEXTDISP_PrimaryGroupPresentFlag, TEXTDISP_SecondaryGroupPresentFlag
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
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
    CMP.L   D0,D5
    BGE.S   .list1_done

    TST.B   TEXTDISP_PrimaryGroupPresentFlag
    BEQ.S   .list1_done

    PEA     1.W
    MOVE.L  D5,-(A7)
    JSR     NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    PEA     1.W
    MOVE.L  D5,-(A7)
    MOVE.L  D0,-4(A5)
    JSR     NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

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
    MOVE.W  TEXTDISP_SecondaryGroupEntryCount,D0
    CMP.L   D0,D5
    BGE.S   .return

    TST.B   TEXTDISP_SecondaryGroupPresentFlag
    BEQ.S   .return

    PEA     2.W
    MOVE.L  D5,-(A7)
    JSR     NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    PEA     2.W
    MOVE.L  D5,-(A7)
    MOVE.L  D0,-4(A5)
    JSR     NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

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
;   NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex
; READS:
;   CLOCK_DaySlotIndex, CONFIG_NewgridWindowSpanHalfHoursPrimary, CONFIG_NewgridWindowSpanHalfHoursAlt
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

    PEA     CLOCK_DaySlotIndex
    JSR     NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(PC)

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

    MOVE.B  CONFIG_NewgridWindowSpanHalfHoursPrimary,D0
    EXT.W   D0
    EXT.L   D0
    BRA.S   .mode_offset_done

.mode_offset:
    MOVE.B  CONFIG_NewgridWindowSpanHalfHoursAlt,D0
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
;   NEWGRID_AltSelectionRowCursor/203A, TEXTDISP_PrimaryGroupEntryCount, TEXTDISP_PrimaryGroupPresentFlag
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
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
    MOVE.L  NEWGRID_AltSelectionRowCursor,D1
    CMP.L   D0,D1
    BGE.W   .finalize_selection

    TST.B   TEXTDISP_PrimaryGroupPresentFlag
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
    MOVE.L  CONFIG_TimeWindowMinutes,-(A7)
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
;   NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer, TEXTDISP_JMPTBL_ESQDISP_TestEntryGridEligibility, TEXTDISP_FormatEntryTimeForIndex, NEWGRID2_JMPTBL_ESQ_TestBit1Based, NEWGRID_UpdatePresetEntry, NEWGRID2_JMPTBL_STR_SkipClass3Chars,
;   PARSEINI_JMPTBL_STRING_AppendAtNull
; READS:
;   CONFIG_TimeWindowMinutes, NEWGRID_ShowtimeListSeparator
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
    JSR     NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    MOVE.L  D5,D1
    EXT.L   D1
    PEA     2.W
    MOVE.L  D1,-(A7)
    MOVE.L  (A3),-(A7)
    MOVE.L  D0,-40(A5)
    JSR     NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    MOVE.L  D5,D1
    EXT.L   D1
    PEA     6.W
    MOVE.L  D1,-(A7)
    MOVE.L  (A3),-(A7)
    MOVE.L  D0,-44(A5)
    JSR     NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    MOVE.L  D5,D1
    EXT.L   D1
    PEA     7.W
    MOVE.L  D1,-(A7)
    MOVE.L  (A3),-(A7)
    MOVE.L  D0,-48(A5)
    JSR     NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

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
    JSR     TEXTDISP_FormatEntryTimeForIndex(PC)

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
    JSR     NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    PEA     2.W
    MOVE.L  D1,-(A7)
    MOVE.L  -80(A5),-(A7)
    MOVE.L  D0,-62(A5)
    JSR     NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    PEA     6.W
    MOVE.L  D1,-(A7)
    MOVE.L  -80(A5),-(A7)
    MOVE.L  D0,-66(A5)
    JSR     NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    PEA     7.W
    MOVE.L  D1,-(A7)
    MOVE.L  -80(A5),-(A7)
    MOVE.L  D0,-70(A5)
    JSR     NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

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
    JSR     NEWGRID2_JMPTBL_STR_SkipClass3Chars(PC)

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
    JSR     TEXTDISP_FormatEntryTimeForIndex(PC)

    PEA     -31(A5)
    JSR     NEWGRID2_JMPTBL_STR_SkipClass3Chars(PC)

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
    JSR     NEWGRID2_JMPTBL_STR_SkipClass3Chars(PC)

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
;   NEWGRID2_JMPTBL_STR_SkipClass3Chars, NEWGRID2_JMPTBL_STRING_AppendN, PARSEINI_JMPTBL_STRING_AppendAtNull,
;   NEWGRID_DrawGridFrame, NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight, _LVOSetAPen, _LVOSetDrMd,
;   _LVOTextLength, _LVOMove, _LVOText, NEWGRID_ValidateSelectionCode
; READS:
;   SCRIPT_PtrSportsOnPrefix, SCRIPT_PtrSummaryOfPrefix, SCRIPT_PtrChannelSuffix, NEWGRID_RowHeightPx, NEWGRID_ColumnStartXPx, NEWGRID_ColumnWidthPx
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
    JSR     NEWGRID2_JMPTBL_STR_SkipClass3Chars(PC)

    LEA     1(A2),A0
    MOVE.L  A0,(A7)
    MOVE.L  D0,-4(A5)
    MOVE.L  A0,-8(A5)
    JSR     NEWGRID2_JMPTBL_STR_SkipClass3Chars(PC)

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
    TST.W   Global_WORD_SELECT_CODE_IS_RAVESC
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
    MOVE.W  NEWGRID_RowHeightPx,D0
    ADDQ.L  #3,D0
    MOVE.L  D0,-(A7)
    MOVEQ   #6,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    PEA     7.W
    MOVE.L  A3,-(A7)
    JSR     NEWGRID_DrawGridFrame(PC)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  NEWGRID_ColumnStartXPx,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    PEA     33.W
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(PC)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  NEWGRID_ColumnStartXPx,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    PEA     33.W
    PEA     695.W
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(PC)

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
    MOVE.W  NEWGRID_ColumnStartXPx,D0
    MOVE.W  NEWGRID_ColumnWidthPx,D1
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
    BSR.W   NEWGRID_ValidateSelectionCode

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
;   NEWGRID_SetRowColor, _LVOSetAPen, _LVORectFill, NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast, NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines,
;   NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevel, NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected, NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine, NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel
; READS:
;   NEWGRID_RowHeightPx, DISPTEXT_ControlMarkerXOffsetPx
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
    BSR.W   NEWGRID_SetRowColor

    LEA     12(A7),A7
    MOVEA.L -20(A5),A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVE.W  NEWGRID_RowHeightPx,D0
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

    JSR     NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

    TST.L   D0
    BNE.W   .after_rows

    MOVE.L  D4,D5
    JSR     NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines(PC)

    TST.L   D0
    BEQ.S   .alt_path

    MOVEQ   #0,D0
    MOVE.W  NEWGRID_RowHeightPx,D0
    SUBQ.L  #1,D0
    MOVE.L  D0,-(A7)
    PEA     695.W
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  -20(A5),-(A7)
    JSR     NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevel(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D0
    MOVE.W  NEWGRID_RowHeightPx,D0
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
    JSR     NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected(PC)

    TST.L   D0
    BEQ.S   .default_path

    MOVEQ   #0,D0
    MOVE.W  NEWGRID_RowHeightPx,D0
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
    MOVE.W  NEWGRID_RowHeightPx,D0
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
    JSR     NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine(PC)

    LEA     12(A7),A7
    ADDQ.L  #1,D7
    MOVEQ   #0,D0
    MOVE.W  NEWGRID_RowHeightPx,D0
    TST.L   D0
    BPL.S   .advance_row

    ADDQ.L  #1,D0

.advance_row:
    ASR.L   #1,D0
    ADD.L   DISPTEXT_ControlMarkerXOffsetPx,D0
    ADD.L   D0,D4
    BRA.W   .row_loop

.after_rows:
    JSR     NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

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
    JSR     NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel(PC)

    LEA     20(A7),A7

.draw_bottom_bevel:
    MOVE.L  D4,D0
    TST.L   D0
    BPL.S   .return

    ADDQ.L  #1,D0

.return:
    ASR.L   #1,D0
    MOVE.W  D0,52(A3)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

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
