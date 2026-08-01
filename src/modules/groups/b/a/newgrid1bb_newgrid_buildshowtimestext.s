    XDEF    _NEWGRID_BuildShowtimesText


;------------------------------------------------------------------------------
; FUNC: _NEWGRID_BuildShowtimesText   (Build formatted showtimes text for current selection)
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
_NEWGRID_BuildShowtimesText:
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
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
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
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
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
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
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
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
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
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
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