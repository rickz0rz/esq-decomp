    XDEF    _NEWGRID_AppendShowtimesForRow


;------------------------------------------------------------------------------
; FUNC: _NEWGRID_AppendShowtimesForRow   (Append deduplicated showtimes for active row)
; ARGS:
;   stack +12: A3 = selection state
;   stack +16: A2 = output buffer
;   stack +20: D7 = mode selector
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   _NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer, _TEXTDISP_JMPTBL_ESQDISP_TestEntryGridEligibility, _TEXTDISP_FormatEntryTimeForIndex, _NEWGRID2_JMPTBL_ESQ_TestBit1Based, _NEWGRID_UpdatePresetEntry, _NEWGRID2_JMPTBL_STR_SkipClass3Chars,
;   _PARSEINI_JMPTBL_STRING_AppendAtNull
; READS:
;   _CONFIG_TimeWindowMinutes, _NEWGRID_ShowtimeListSeparator
; WRITES:
;   output buffer contents
; DESC:
;   Scans rows and appends matching showtime strings into the buffer.
; NOTES:
;   Performs multiple field comparisons to coalesce identical showtimes.
;------------------------------------------------------------------------------
_NEWGRID_AppendShowtimesForRow:
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
    JSR     _TEXTDISP_JMPTBL_ESQDISP_TestEntryGridEligibility(PC)

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
    BSR.W   _NEWGRID_UpdatePresetEntry

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
    JSR     _NEWGRID2_JMPTBL_ESQ_TestBit1Based(PC)

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
    JSR     _TEXTDISP_JMPTBL_ESQDISP_TestEntryGridEligibility(PC)

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

    LEA     _Global_STR_SHOWTIMES_AND_SINGLE_SPACE,A0
    MOVEA.L A2,A1

.copy_showtimes_prefix:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_showtimes_prefix

    PEA     -31(A5)
    JSR     _NEWGRID2_JMPTBL_STR_SkipClass3Chars(PC)

    MOVE.L  D0,(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  D0,-10(A5)
    JSR     _PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

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

    PEA     _NEWGRID_ShowtimeListSeparator
    MOVE.L  A2,-(A7)
    MOVE.L  D0,-10(A5)
    JSR     _PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    MOVE.L  -10(A5),(A7)
    MOVE.L  A2,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

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

    LEA     _Global_STR_SHOWING_AT_AND_SINGLE_SPACE,A0
    MOVEA.L A2,A1

.copy_showing_at_prefix:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_showing_at_prefix

    PEA     -31(A5)
    JSR     _NEWGRID2_JMPTBL_STR_SkipClass3Chars(PC)

    MOVE.L  D0,(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  D0,-10(A5)
    JSR     _PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.return:
    MOVEM.L (A7)+,D5-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======