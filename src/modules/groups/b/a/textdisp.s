;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_BuildNowShowingStatusLine   (Build aligned "Now Showing" line)
; ARGS:
;   stack +10: mode (word, 1/2)
;   stack +14: groupIndex (word)
;   stack +18: entryIndex (word)
; RET:
;   none
; CLOBBERS:
;   D0-D3/A0-A1
; CALLS:
;   GROUPD_JMPTBL_LAB_0926, GROUPD_JMPTBL_LAB_0923, GROUPD_JMPTBL_LAB_036C,
;   TEXTDISP_FormatEntryTimeForIndex, UNKNOWN7_SkipCharClass3, STRING_AppendAtNull, TEXTDISP_FindControlToken,
;   GROUP_BA_JMPTBL_CLEANUP_BuildAlignedStatusLine, LAB_15AD
; READS:
;   LAB_234D, LAB_2274, LAB_2374/LAB_2377/LAB_2378, LAB_205C
; WRITES:
;   LAB_234D
; DESC:
;   Builds an aligned status string for the current channel/entry (\"Now Showing\"),
;   then hands it to the aligned status line renderer; falls back to external text.
; NOTES:
;   Uses stack buffers for string assembly.
;------------------------------------------------------------------------------
TEXTDISP_BuildNowShowingStatusLine:
LAB_15C5:
    LINK.W  A5,#-216
    MOVEM.L D2-D3/D5-D7,-(A7)
    MOVE.W  10(A5),D7
    MOVE.W  14(A5),D6
    MOVE.W  18(A5),D5
    CLR.L   -196(A5)
    MOVEQ   #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    MOVEM.L D0,-216(A5)
    TST.W   D7
    BNE.S   .after_table_kind

    MOVEQ   #2,D0

.after_table_kind:
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    JSR     GROUPD_JMPTBL_LAB_0926(PC)

    ADDQ.W  #8,A7
    MOVE.L  D6,D1
    EXT.L   D1
    MOVEM.L D0,-4(A5)
    TST.W   D7
    BEQ.S   .use_kind_2

    MOVEQ   #1,D2
    BRA.S   .dispatch_kind

.use_kind_2:
    MOVEQ   #2,D2

.dispatch_kind:
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    JSR     GROUPD_JMPTBL_LAB_0923(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    TST.L   D0
    BEQ.W   .append_external_line

    TST.L   -4(A5)
    BEQ.W   .append_external_line

    MOVE.W  LAB_234D,D1
    BNE.S   .ensure_default_channel

    MOVEQ   #48,D2
    MOVE.W  D2,LAB_234D

.ensure_default_channel:
    CLR.B   -137(A5)
    MOVE.W  LAB_234D,D1
    MOVEQ   #48,D2
    CMP.W   D2,D1
    BLT.S   .check_channel_range_alt

    MOVEQ   #67,D2
    CMP.W   D2,D1
    BLE.S   .check_channel_enabled

.check_channel_range_alt:
    MOVEQ   #72,D2
    CMP.W   D2,D1
    BLT.S   .channel_not_enabled

    MOVEQ   #77,D2
    CMP.W   D2,D1
    BGT.S   .channel_not_enabled

.check_channel_enabled:
    EXT.L   D1
    LEA     GLOB_STR_TEXTDISP_C_3,A0
    ADDA.L  D1,A0
    MOVE.W  LAB_2274,D1
    EXT.L   D1
    MOVEQ   #1,D2
    ASL.L   D1,D2
    MOVEQ   #0,D1
    MOVE.B  (A0),D1
    AND.L   D2,D1
    TST.L   D1
    BEQ.S   .channel_not_enabled

    MOVEQ   #1,D2
    BRA.S   .store_channel_enabled

.channel_not_enabled:
    MOVEQ   #0,D2

.store_channel_enabled:
    MOVE.L  D2,-212(A5)
    BEQ.W   .fallback_channel_line

    TST.W   D5
    BLE.W   .fallback_channel_line

    MOVEQ   #49,D1
    CMP.W   D1,D5
    BGE.W   .fallback_channel_line

    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  LAB_1BBD,-(A7)
    PEA     1440.W
    MOVE.L  D1,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  D0,-(A7)
    JSR     GROUPD_JMPTBL_LAB_036C(PC)

    LEA     20(A7),A7
    TST.L   D0
    BEQ.W   .fallback_channel_line

    MOVE.B  LAB_2377,D0
    MOVEQ   #100,D1
    CMP.B   D1,D0
    BEQ.S   .use_channel_digit

    MOVEQ   #0,D0
    MOVE.B  LAB_2378,D0
    BRA.S   .store_channel_char

.use_channel_digit:
    MOVEQ   #0,D0
    MOVE.B  LAB_2374,D0

.store_channel_char:
    MOVE.L  D0,-200(A5)
    SUBQ.L  #1,D0
    BNE.S   .build_entry_title

    LEA     GLOB_STR_ALIGNED_NOW_SHOWING,A0
    LEA     -188(A5),A1

.copy_now_showing:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_now_showing

    LEA     -188(A5),A0
    MOVE.L  A0,-192(A5)
    BRA.S   .append_center_prefix

.build_entry_title:
    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  -4(A5),-(A7)
    MOVE.L  D0,-(A7)
    PEA     -188(A5)
    JSR     TEXTDISP_FormatEntryTimeForIndex(PC)

    PEA     -188(A5)
    JSR     UNKNOWN7_SkipCharClass3(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-192(A5)

.append_center_prefix:
    LEA     LAB_2134,A0
    LEA     -137(A5),A1

.copy_center_prefix:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_center_prefix

    MOVE.L  -192(A5),-(A7)
    PEA     -137(A5)
    JSR     STRING_AppendAtNull(PC)

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -4(A5),A0
    MOVE.L  56(A0,D0.L),(A7)
    JSR     TEXTDISP_FindControlToken(PC)

    ADDQ.W  #8,A7
    CLR.L   -216(A5)
    MOVE.L  D0,-196(A5)
    BRA.S   .build_program_title

.fallback_channel_line:
    MOVE.W  LAB_234D,D0
    MOVEQ   #48,D1
    CMP.W   D1,D0
    BLE.S   .check_channel_range_primary

    MOVEQ   #67,D1
    CMP.W   D1,D0
    BLE.S   .append_channel_name

.check_channel_range_primary:
    MOVEQ   #72,D1
    CMP.W   D1,D0
    BLT.S   .build_program_title

    MOVEQ   #77,D1
    CMP.W   D1,D0
    BGT.S   .build_program_title

.append_channel_name:
    LEA     LAB_2135,A0
    LEA     -137(A5),A1

.copy_channel_prefix:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_channel_prefix

    MOVE.W  LAB_234D,D0
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     LAB_20ED,A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-(A7)
    PEA     -137(A5)
    JSR     STRING_AppendAtNull(PC)

    PEA     LAB_234B
    JSR     TEXTDISP_FindControlToken(PC)

    LEA     12(A7),A7
    MOVEQ   #0,D1
    MOVE.L  D0,-196(A5)
    MOVE.L  D1,-216(A5)

.build_program_title:
    TST.L   -216(A5)
    BNE.W   .render_output

    MOVEQ   #0,D0
    MOVE.L  D0,-204(A5)
    MOVE.L  D0,-208(A5)

.copy_program_loop:
    MOVEA.L -8(A5),A0
    MOVE.L  -204(A5),D0
    TST.B   1(A0,D0.L)
    BEQ.S   .finalize_program_title

    MOVEQ   #32,D1
    CMP.B   1(A0,D0.L),D1
    BEQ.S   .skip_program_space

    LEA     -188(A5),A1
    ADDA.L  -208(A5),A1
    ADDQ.L  #1,-208(A5)
    MOVE.B  1(A0,D0.L),(A1)

.skip_program_space:
    ADDQ.L  #1,-204(A5)
    BRA.S   .copy_program_loop

.finalize_program_title:
    LEA     -188(A5),A0
    ADDA.L  -208(A5),A0
    MOVEQ   #0,D0
    MOVE.B  D0,(A0)
    MOVE.B  -188(A5),D1
    TST.B   D1
    BEQ.S   .append_time_suffix

    MOVE.B  -137(A5),D1
    TST.B   D1
    BEQ.S   .append_channel_label

    PEA     LAB_2136
    PEA     -137(A5)
    JSR     STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.append_channel_label:
    PEA     LAB_2137
    PEA     -137(A5)
    JSR     STRING_AppendAtNull(PC)

    PEA     -188(A5)
    PEA     -137(A5)
    JSR     STRING_AppendAtNull(PC)

    LEA     16(A7),A7

.append_time_suffix:
    TST.L   -196(A5)
    BEQ.S   .emit_aligned_line

    MOVE.B  -137(A5),D0
    TST.B   D0
    BEQ.S   .append_time_prefix

    PEA     LAB_2138
    PEA     -137(A5)
    JSR     STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.append_time_prefix:
    MOVEQ   #0,D0
    MOVEA.L -196(A5),A0
    MOVE.B  (A0),D0
    MOVE.L  D0,-(A7)
    PEA     LAB_2139
    PEA     -188(A5)
    JSR     WDISP_SPrintf(PC)

    PEA     -188(A5)
    PEA     -137(A5)
    JSR     STRING_AppendAtNull(PC)

    LEA     20(A7),A7

.emit_aligned_line:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    MOVE.L  D5,D2
    EXT.L   D2
    MOVEQ   #0,D3
    MOVE.L  D3,-(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -137(A5)
    JSR     GROUP_BA_JMPTBL_CLEANUP_BuildAlignedStatusLine(PC)

    LEA     24(A7),A7
    BRA.S   .render_output

.append_external_line:
    TST.L   LAB_205C
    BEQ.S   .clear_output

    MOVEA.L LAB_205C,A0
    TST.B   (A0)
    BEQ.S   .clear_output

    LEA     LAB_213A,A0
    LEA     -137(A5),A1

.copy_external_prefix:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_external_prefix

    MOVE.L  LAB_205C,-(A7)
    PEA     -137(A5)
    JSR     STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7
    BRA.S   .render_output

.clear_output:
    CLR.B   -137(A5)

.render_output:
    PEA     -137(A5)
    BSR.W   LAB_15AD

    MOVEM.L -236(A5),D2-D3/D5-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_BuildEntryPairStatusLine   (Build aligned two-part line)
; ARGS:
;   stack +10: mode (word, 1/2)
;   stack +14: groupIndex (word)
;   stack +18: entryIndex (word)
; RET:
;   none
; CLOBBERS:
;   D0-D3/A0-A1
; CALLS:
;   GROUPD_JMPTBL_LAB_0926, GROUPD_JMPTBL_LAB_0923, GROUPD_JMPTBL_LAB_036C,
;   GROUPD_JMPTBL_LAB_0347, STRING_AppendAtNull,
;   GROUP_BA_JMPTBL_CLEANUP_BuildAlignedStatusLine, LAB_15AD
; READS:
;   LAB_213B/LAB_213C/LAB_213D
; DESC:
;   Builds a two-part aligned status string for a given entry and renders it.
; NOTES:
;   Uses two short strings (slots 2/3) when present; skips if empty.
;------------------------------------------------------------------------------
TEXTDISP_BuildEntryPairStatusLine:
LAB_15E4:
    LINK.W  A5,#-148
    MOVEM.L D2-D3/D5-D7,-(A7)
    MOVE.W  10(A5),D7
    MOVE.W  14(A5),D6
    MOVE.W  18(A5),D5
    MOVE.L  D6,D0
    EXT.L   D0
    TST.W   D7
    BEQ.S   .use_kind_2

    MOVEQ   #1,D1
    BRA.S   .dispatch_kind

.use_kind_2:
    MOVEQ   #2,D1

.dispatch_kind:
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     GROUPD_JMPTBL_LAB_0926(PC)

    ADDQ.W  #8,A7
    MOVE.L  D6,D1
    EXT.L   D1
    MOVEM.L D0,-8(A5)
    TST.W   D7
    BEQ.S   .use_kind_1

    MOVEQ   #1,D2
    BRA.S   .dispatch_kind_2

.use_kind_1:
    MOVEQ   #2,D2

.dispatch_kind_2:
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    JSR     GROUPD_JMPTBL_LAB_0923(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.W   .return

    TST.L   -8(A5)
    BEQ.W   .return

    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  LAB_1BBD,-(A7)
    PEA     30.W
    MOVE.L  D1,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  D0,-(A7)
    JSR     GROUPD_JMPTBL_LAB_036C(PC)

    LEA     20(A7),A7
    TST.L   D0
    BEQ.W   .return

    MOVEQ   #1,D0
    CMP.W   D0,D5
    BLT.S   .reject_entry_index

    MOVEQ   #48,D0
    CMP.W   D0,D5
    BLE.S   .build_entry_parts

.reject_entry_index:
    MOVEQ   #-1,D5

.build_entry_parts:
    MOVE.L  D5,D0
    EXT.L   D0
    PEA     2.W
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     GROUPD_JMPTBL_LAB_0347(PC)

    MOVE.L  D5,D1
    EXT.L   D1
    PEA     3.W
    MOVE.L  D1,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  D0,-142(A5)
    JSR     GROUPD_JMPTBL_LAB_0347(PC)

    LEA     24(A7),A7
    MOVE.L  D0,-146(A5)
    TST.L   -142(A5)
    BEQ.S   .clear_prefix

    LEA     LAB_213B,A0
    LEA     -137(A5),A1

.copy_align_prefix:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_align_prefix

    MOVE.L  -142(A5),-(A7)
    PEA     -137(A5)
    JSR     STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7
    BRA.S   .append_second_part

.clear_prefix:
    MOVEQ   #0,D0
    MOVE.B  D0,-137(A5)

.append_second_part:
    TST.L   -146(A5)
    BEQ.S   .emit_status_line

    MOVE.B  -137(A5),D0
    TST.B   D0
    BEQ.S   .append_separator

    PEA     LAB_213C
    PEA     -137(A5)
    JSR     STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.append_separator:
    PEA     LAB_213D
    PEA     -137(A5)
    JSR     STRING_AppendAtNull(PC)

    MOVE.L  -146(A5),(A7)
    PEA     -137(A5)
    JSR     STRING_AppendAtNull(PC)

    LEA     12(A7),A7

.emit_status_line:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    MOVE.L  D5,D2
    EXT.L   D2
    MOVEQ   #0,D3
    MOVE.L  D3,-(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -137(A5)
    JSR     GROUP_BA_JMPTBL_CLEANUP_BuildAlignedStatusLine(PC)

    LEA     24(A7),A7
    TST.B   -137(A5)
    BEQ.S   .return

    PEA     -137(A5)
    BSR.W   LAB_15AD

    ADDQ.W  #4,A7

.return:
    MOVEM.L (A7)+,D2-D3/D5-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_ShouldOpenEditorForEntry   (Entry eligible for editor)
; ARGS:
;   stack +12: entryPtr (A3)
; RET:
;   D0: 1 if eligible, 0 otherwise
; CLOBBERS:
;   D0/D7/A3
; CALLS:
;   TEXTDISP_JMPTBL_NEWGRID_ShouldOpenEditor (NEWGRID_ShouldOpenEditor)
; READS:
;   entry+27, entry+40
; DESC:
;   Returns true when entry flags and editor policy allow opening the editor.
; NOTES:
;   Uses entry flag bits (40/27 offsets).
;------------------------------------------------------------------------------
TEXTDISP_ShouldOpenEditorForEntry:
LAB_15F1:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEQ   #0,D7
    MOVE.L  A3,D0
    BEQ.S   .return

    BTST    #0,40(A3)
    BEQ.S   .not_selectable

    BTST    #3,40(A3)
    BEQ.S   .not_selectable

    MOVE.L  A3,-(A7)
    JSR     TEXTDISP_JMPTBL_NEWGRID_ShouldOpenEditor(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BNE.S   .not_selectable

    BTST    #3,27(A3)
    BNE.S   .not_selectable

    MOVEQ   #1,D0
    BRA.S   .set_result

.not_selectable:
    MOVEQ   #0,D0

.set_result:
    MOVE.L  D0,D7

.return:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_GetGroupEntryCount   (Lookup entry count for group)
; ARGS:
;   stack +12: groupId (long)
; RET:
;   D0: count (word, zero if unsupported)
; CLOBBERS:
;   D0/D6-D7
; READS:
;   LAB_2231, LAB_222F
; DESC:
;   Returns the entry count for group 1 or 2.
; NOTES:
;   Unknown behavior for other group IDs.
;------------------------------------------------------------------------------
TEXTDISP_GetGroupEntryCount:
LAB_15F5:
    MOVEM.L D6-D7,-(A7)
    MOVE.L  12(A7),D7
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    BEQ.S   .use_count_primary

    SUBQ.L  #1,D0
    BEQ.S   .use_count_secondary

    BRA.S   .use_count_zero

.use_count_primary:
    MOVE.W  LAB_2231,D6
    BRA.S   .return

.use_count_secondary:
    MOVE.W  LAB_222F,D6
    BRA.S   .return

.use_count_zero:
    MOVEQ   #0,D6

.return:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_ResetSelectionState   (Reset selection fields)
; ARGS:
;   stack +8: entryPtr (A3)
; RET:
;   none
; CLOBBERS:
;   D0/A3
; WRITES:
;   entry+210, entry+214, entry+218, entry+220
; DESC:
;   Initializes selection state fields to defaults (-1/0) for an entry.
; NOTES:
;   Uses mode=3 and clears pending flags.
;------------------------------------------------------------------------------
TEXTDISP_ResetSelectionState:
LAB_15FA:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    MOVE.L  A3,D0
    BEQ.S   .return

    MOVEQ   #3,D0
    MOVE.L  D0,210(A3)
    MOVEQ   #-1,D0
    MOVE.L  D0,214(A3)
    MOVE.W  #(-1),218(A3)
    CLR.B   220(A3)

.return:
    MOVEA.L (A7)+,A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_SetEntryTextFields   (Populate short/long name fields)
; ARGS:
;   stack +8: entryPtr (A3)
;   stack +12: shortNamePtr (A2)
;   stack +16: longNamePtr
; RET:
;   none
; CLOBBERS:
;   D0/A0-A3
; CALLS:
;   STRING_CopyPadNul
; READS:
;   LAB_1BC7, LAB_2174, GLOB_REF_WORD_HEX_CODE_8E
; WRITES:
;   entry+0..9, entry+10..208, LAB_2362
; DESC:
;   Copies short and long names into the entry struct, padding with NULs.
; NOTES:
;   Selects a base width (LAB_2362) depending on region/flag.
;------------------------------------------------------------------------------
TEXTDISP_SetEntryTextFields:
LAB_15FC:
    LINK.W  A5,#-4
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.B  LAB_1BC7,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .use_hex_code

    MOVEQ   #0,D0
    MOVE.W  LAB_2174,D0
    MOVE.L  D0,LAB_2362
    BRA.S   .after_hex_code

.use_hex_code:
    MOVEQ   #0,D0
    MOVE.W  GLOB_REF_WORD_HEX_CODE_8E,D0
    MOVE.L  D0,LAB_2362

.after_hex_code:
    MOVE.L  A3,D0
    BEQ.S   .return

    MOVEA.L A3,A0
    MOVE.L  A0,-4(A5)
    MOVE.L  A2,D0
    BEQ.S   .copy_short_name

    PEA     9.W
    MOVE.L  A2,-(A7)
    MOVE.L  A0,-(A7)
    JSR     STRING_CopyPadNul(PC)

    LEA     12(A7),A7
    MOVEQ   #0,D0
    MOVEA.L -4(A5),A0
    MOVE.B  D0,9(A0)
    BRA.S   .after_short_name

.copy_short_name:
    CLR.B   (A0)

.after_short_name:
    LEA     10(A3),A1
    MOVE.L  A1,-4(A5)
    MOVE.L  A2,D0
    BEQ.S   .copy_long_name

    PEA     199.W
    MOVE.L  16(A5),-(A7)
    MOVE.L  A1,-(A7)
    JSR     STRING_CopyPadNul(PC)

    LEA     12(A7),A7
    MOVEQ   #0,D0
    MOVEA.L -4(A5),A0
    MOVE.B  D0,199(A0)
    BRA.S   .return

.copy_long_name:
    CLR.B   (A1)

.return:
    MOVEM.L (A7)+,A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_SetSelectionFields   (Update mode/index selection)
; ARGS:
;   stack +20: entryPtr (A3)
;   stack +24: mode (long, 1/2/3)
;   stack +28: displayIndex (long)
;   stack +32: entryIndex (long)
; RET:
;   none
; CLOBBERS:
;   D0-D1/A3
; CALLS:
;   TEXTDISP_GetGroupEntryCount, TEXTDISP_ResetSelectionState
; WRITES:
;   entry+210, entry+214, entry+218, entry+220
; DESC:
;   Sets selection state fields, clamping indices to valid ranges.
; NOTES:
;   Resets state when mode or indices are invalid.
;------------------------------------------------------------------------------
TEXTDISP_SetSelectionFields:
LAB_1603:
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.L  24(A7),D7
    MOVE.L  28(A7),D6
    MOVE.L  32(A7),D5
    MOVE.L  A3,D0
    BEQ.S   .return

    MOVEQ   #1,D0
    CMP.L   D0,D7
    BEQ.S   .use_mode_passed

    MOVEQ   #2,D0
    CMP.L   D0,D7
    BNE.S   .use_mode_default

.use_mode_passed:
    MOVE.L  D7,D0
    BRA.S   .store_mode

.use_mode_default:
    MOVEQ   #3,D0

.store_mode:
    MOVE.L  D0,210(A3)
    MOVE.L  D0,-(A7)
    BSR.W   TEXTDISP_GetGroupEntryCount

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    CMP.L   D1,D6
    BGE.S   .clamp_display_index

    MOVE.L  D6,D0
    BRA.S   .store_display_index

.clamp_display_index:
    MOVEQ   #-1,D0

.store_display_index:
    MOVE.L  D0,214(A3)
    TST.L   D5
    BLE.S   .invalidate_entry_index

    MOVEQ   #49,D1
    CMP.L   D1,D5
    BGE.S   .invalidate_entry_index

    MOVE.L  D5,D1
    BRA.S   .store_entry_index

.invalidate_entry_index:
    MOVEQ   #-1,D1

.store_entry_index:
    MOVE.W  D1,218(A3)
    CLR.B   220(A3)
    MOVEQ   #3,D0
    CMP.L   210(A3),D0
    BEQ.S   .reset_selection

    MOVEQ   #-1,D0
    CMP.L   214(A3),D0
    BEQ.S   .reset_selection

    MOVEQ   #-1,D0
    CMP.W   218(A3),D0
    BNE.S   .return

.reset_selection:
    MOVE.L  A3,-(A7)
    BSR.W   TEXTDISP_ResetSelectionState

    ADDQ.W  #4,A7

.return:
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_SkipControlCodes   (Skip control/alignment bytes)
; ARGS:
;   stack +8: textPtr (A3)
; RET:
;   D0: advanced pointer (or NULL)
; CLOBBERS:
;   D0/A0/A3
; READS:
;   LAB_21A8 (char class table)
; DESC:
;   Skips leading control/alignment bytes and returns the first displayable char.
; NOTES:
;   Treats '@' (0x40) as a special 8-byte prefix.
;------------------------------------------------------------------------------
TEXTDISP_SkipControlCodes:
LAB_160D:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    MOVE.L  A3,D0
    BEQ.S   .return

    MOVEQ   #40,D0
    CMP.B   (A3),D0
    BNE.S   .scan_text

    ADDQ.L  #8,A3

.scan_text:
    MOVEQ   #0,D0
    MOVE.B  (A3),D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #3,(A0)
    BEQ.S   .return

    ADDQ.L  #1,A3
    BRA.S   .scan_text

.return:
    MOVE.L  A3,D0
    MOVEA.L (A7)+,A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_BuildEntryDetailLine   (Build formatted entry detail text)
; ARGS:
;   stack +8: entryPtr (A3)
; RET:
;   none
; CLOBBERS:
;   D0-D7/A0-A2
; CALLS:
;   GROUPD_JMPTBL_LAB_0926, GROUPD_JMPTBL_LAB_0923, TEXTDISP_BuildEntryShortName, TEXTDISP_FormatEntryTimeForIndex,
;   STRING_AppendAtNull, WDISP_SPrintf, GROUPD_JMPTBL_ESQ_FindSubstringCaseFold,
;   UNKNOWN7_FindCharWrapper, TEXTDISP_SkipControlCodes, TEXTDISP_TrimTextToPixelWidth
; READS:
;   entry+210/214/218, LAB_21A8
; DESC:
;   Builds a formatted line for an entry by combining header text, program title,
;   sports delimiters (\"at\"/\"vs\"), and channel info, then appends alignment.
; NOTES:
;   Inserts 0x18 markers around matched delimiters.
;------------------------------------------------------------------------------
TEXTDISP_BuildEntryDetailLine:
LAB_1610:
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
    BSR.W   TEXTDISP_ResetSelectionState

    ADDQ.W  #4,A7
    BRA.W   .return

.build_buffers:
    LEA     10(A3),A0
    MOVE.L  210(A3),-(A7)
    MOVE.L  214(A3),-(A7)
    MOVE.L  A0,-4(A5)
    JSR     GROUPD_JMPTBL_LAB_0926(PC)

    MOVE.L  210(A3),(A7)
    MOVE.L  214(A3),-(A7)
    MOVE.L  D0,-532(A5)
    JSR     GROUPD_JMPTBL_LAB_0923(PC)

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
    LEA     LAB_21A8,A0
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

    LEA     LAB_213E,A1
    MOVEA.L -8(A5),A2

.copy_prefix:
    MOVE.B  (A1)+,(A2)+
    BNE.S   .copy_prefix

    MOVE.L  -12(A5),-(A7)
    MOVE.L  -8(A5),-(A7)
    JSR     STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.select_entry_string:
    MOVE.W  218(A3),D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -532(A5),A0
    MOVE.L  56(A0,D0.L),-(A7)
    BSR.W   TEXTDISP_SkipControlCodes

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
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .mark_match_delimiters

    ADDQ.L  #1,-12(A5)
    BRA.S   .align_entry_tail

.mark_match_delimiters:
    MOVE.L  -12(A5),-(A7)
    PEA     LAB_213F
    PEA     -524(A5)
    JSR     WDISP_SPrintf(PC)

    PEA     LAB_2140
    PEA     -524(A5)
    JSR     GROUPD_JMPTBL_ESQ_FindSubstringCaseFold(PC)

    LEA     20(A7),A7
    MOVE.L  D0,-12(A5)
    TST.L   D0
    BNE.S   .try_match_vs_dot

    PEA     LAB_2141
    PEA     -524(A5)
    JSR     GROUPD_JMPTBL_ESQ_FindSubstringCaseFold(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-12(A5)

.try_match_vs_dot:
    TST.L   D0
    BNE.S   .try_match_vs

    PEA     LAB_2142
    PEA     -524(A5)
    JSR     GROUPD_JMPTBL_ESQ_FindSubstringCaseFold(PC)

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
    LEA     LAB_21A8,A0
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
    JSR     UNKNOWN7_FindCharWrapper(PC)

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
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #3,(A0)
    BNE.S   .backtrack_to_text

.append_title_suffix:
    PEA     -524(A5)
    MOVE.L  -8(A5),-(A7)
    JSR     STRING_AppendAtNull(PC)

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
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #3,(A0)
    BEQ.S   .append_channel_label

    ADDQ.L  #1,-12(A5)
    BRA.S   .skip_control_in_segment

.append_channel_label:
    MOVEA.L -12(A5),A0
    TST.B   (A0)
    BEQ.S   .copy_program_init

    PEA     LAB_2143
    MOVE.L  -8(A5),-(A7)
    JSR     STRING_AppendAtNull(PC)

    MOVE.L  -12(A5),(A7)
    MOVE.L  -8(A5),-(A7)
    JSR     STRING_AppendAtNull(PC)

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

    PEA     GLOB_STR_ALIGNED_CHANNEL_2
    MOVE.L  -8(A5),-(A7)
    JSR     STRING_AppendAtNull(PC)

    PEA     -524(A5)
    MOVE.L  -8(A5),-(A7)
    JSR     STRING_AppendAtNull(PC)

    LEA     16(A7),A7

.append_channel_word:
    PEA     284.W
    MOVE.L  -8(A5),-(A7)
    JSR     TEXTDISP_TrimTextToPixelWidth(PC)

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
;   JMPTBL_ESQ_WildcardMatch_2, TEXTDISP_GetGroupEntryCount,
;   GROUPD_JMPTBL_LAB_0923/0926, TEXTDISP_ShouldOpenEditorForEntry,
;   TEXTDISP_SetSelectionFields, TEXTDISP_BuildEntryDetailLine, TEXTDISP_ResetSelectionState
; READS:
;   LAB_2145/LAB_2358-235C, LAB_2371
; WRITES:
;   LAB_2145, LAB_2358-235C, LAB_2371
; DESC:
;   Applies PPV/SBE/SPORTS filters, walks entries for matches, and updates
;   selection state when a match is found.
; NOTES:
;   Uses wildcard match strings in data/script.s.
;------------------------------------------------------------------------------
TEXTDISP_FilterAndSelectEntry:
LAB_162C:
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
    CLR.W   LAB_2359
    MOVE.B  #$1,LAB_2145
    MOVE.L  -30(A5),-(A7)
    PEA     LAB_2146
    JSR     JMPTBL_ESQ_WildcardMatch_2(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BEQ.S   .set_match_flags

    MOVE.L  -30(A5),-(A7)
    PEA     LAB_2147
    JSR     JMPTBL_ESQ_WildcardMatch_2(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BEQ.S   .set_match_flags

    MOVEQ   #0,D0
    BRA.S   .after_match_flags

.set_match_flags:
    MOVEQ   #1,D0

.after_match_flags:
    MOVE.L  -30(A5),-(A7)
    PEA     LAB_2148
    MOVE.W  D0,LAB_235B
    JSR     JMPTBL_ESQ_WildcardMatch_2(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    SEQ     D1
    NEG.B   D1
    EXT.W   D1
    EXT.L   D1
    MOVE.W  D1,LAB_235C

.ensure_filter_ready:
    TST.L   -20(A5)
    BNE.W   .after_dispatch

    MOVE.B  LAB_2145,D0
    MOVEQ   #3,D1
    CMP.B   D1,D0
    BEQ.W   .after_dispatch

    TST.W   LAB_2359
    BNE.W   .advance_cursor_set

    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   TEXTDISP_GetGroupEntryCount

    ADDQ.W  #4,A7
    MOVEQ   #0,D5
    MOVE.W  D0,D5
    MOVEQ   #0,D6
    MOVE.L  D6,D0
    MOVE.W  D0,LAB_235A

.scan_entries_loop:
    CMP.L   D5,D6
    BGE.W   .finish_match_scan

    MOVE.B  LAB_2145,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  D6,-(A7)
    JSR     GROUPD_JMPTBL_LAB_0923(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    MOVEA.L D0,A0
    BTST    #3,27(A0)
    BNE.S   .next_entry

    TST.W   LAB_235B
    BEQ.S   .check_flag_match

    BTST    #4,27(A0)
    BNE.S   .record_match

.check_flag_match:
    TST.W   LAB_235C
    BEQ.S   .check_editor_allowed

    MOVE.L  D0,-(A7)
    BSR.W   TEXTDISP_ShouldOpenEditorForEntry

    ADDQ.W  #4,A7
    TST.L   D0
    BNE.S   .record_match

.check_editor_allowed:
    MOVEA.L -8(A5),A0
    ADDA.W  #12,A0
    MOVE.L  -30(A5),-(A7)
    MOVE.L  A0,-(A7)
    JSR     JMPTBL_ESQ_WildcardMatch_2(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   .next_entry

.record_match:
    MOVE.W  LAB_235A,D0
    ADDQ.W  #1,LAB_235A
    LEA     LAB_2371,A0
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ADDA.L  D1,A0
    MOVE.L  D6,D0
    MOVE.B  D0,(A0)

.next_entry:
    ADDQ.L  #1,D6
    BRA.W   .scan_entries_loop

.finish_match_scan:
    CMPI.W  #0,LAB_235A
    BLS.S   .no_matches

    CLR.W   LAB_2358
    MOVEQ   #1,D0
    CMP.B   LAB_2145,D0
    BNE.S   .set_default_cursor

    MOVEQ   #0,D0
    MOVE.W  LAB_2270,D0
    BRA.S   .store_cursor_base

.set_default_cursor:
    MOVEQ   #1,D0

.store_cursor_base:
    MOVE.W  D0,LAB_2359
    BRA.S   .advance_cursor_set

.no_matches:
    MOVE.W  #$31,LAB_2359

.advance_cursor_set:
    TST.L   -20(A5)
    BNE.W   .advance_mode

    CMPI.W  #$31,LAB_2359
    BCC.W   .advance_mode

.cursor_loop:
    TST.L   -20(A5)
    BNE.W   .advance_channel_index

    MOVE.W  LAB_2358,D0
    CMP.W   LAB_235A,D0
    BCC.W   .advance_channel_index

    LEA     LAB_2371,A0
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ADDA.L  D1,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.B  LAB_2145,D1
    EXT.W   D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     GROUPD_JMPTBL_LAB_0926(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.W   .next_cursor_entry

    MOVEQ   #1,D1
    CMP.B   LAB_2145,D1
    BNE.W   .load_entry_for_cursor

    MOVE.W  LAB_2270,D1
    MOVE.W  LAB_2359,D2
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

    LEA     LAB_2371,A0
    MOVEQ   #0,D0
    MOVE.W  LAB_2358,D0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.B  LAB_2145,D1
    EXT.W   D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     GROUPD_JMPTBL_LAB_0923(PC)

    MOVE.W  -22(A5),D1
    EXT.L   D1
    MOVE.L  LAB_1BBD,(A7)
    PEA     1440.W
    MOVE.L  D1,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-8(A5)
    JSR     GROUPD_JMPTBL_LAB_036C(PC)

    LEA     24(A7),A7
    TST.L   D0
    BNE.S   .validate_entry

    CLR.L   -26(A5)
    BRA.S   .validate_entry

.load_entry_for_cursor:
    MOVE.W  LAB_2359,D0
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
    BSR.W   TEXTDISP_SkipControlCodes

    ADDQ.W  #4,A7
    MOVE.L  D0,-26(A5)
    TST.W   LAB_235C
    BEQ.S   .check_entry_name_match

    MOVE.W  -22(A5),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     TEXTDISP_JMPTBL_LAB_091A(PC)

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
    JSR     STRING_CompareNoCaseN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.W   .next_cursor_entry

    LEA     LAB_2371,A0
    MOVEQ   #0,D0
    MOVE.W  LAB_2358,D0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.B  LAB_2145,D1
    EXT.W   D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     GROUPD_JMPTBL_LAB_0923(PC)

    MOVEA.L D0,A0
    LEA     28(A0),A1
    MOVE.W  -22(A5),D1
    EXT.L   D1
    MOVE.L  D1,(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  D0,-8(A5)
    JSR     GROUPD_JMPTBL_ESQ_TestBit1Based(PC)

    LEA     12(A7),A7
    ADDQ.L  #1,D0
    BNE.S   .next_cursor_entry

    MOVEQ   #1,D0
    MOVE.L  D0,-20(A5)
    MOVE.B  LAB_2145,D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_2371,A0
    MOVEQ   #0,D1
    MOVE.W  LAB_2358,D1
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
    ADDQ.W  #1,LAB_2358
    BRA.W   .cursor_loop

.advance_channel_index:
    TST.L   -20(A5)
    BNE.W   .advance_cursor_set

    ADDQ.W  #1,LAB_2359
    CLR.W   LAB_2358
    BRA.W   .advance_cursor_set

.advance_mode:
    CMPI.W  #$30,LAB_2359
    BLS.W   .ensure_filter_ready

    CLR.W   LAB_2359
    MOVE.B  LAB_2145,D0
    EXT.W   D0
    SUBQ.W  #1,D0
    BEQ.S   .set_mode_2

    SUBQ.W  #1,D0
    BEQ.S   .set_mode_3

    BRA.S   .set_mode_3

.set_mode_2:
    MOVE.B  #$2,LAB_2145
    BRA.W   .ensure_filter_ready

.set_mode_3:
    MOVE.B  #$3,LAB_2145
    BRA.W   .ensure_filter_ready

.default_mode_3:
    MOVE.B  #$3,LAB_2145

.after_dispatch:
    TST.L   -20(A5)
    BNE.S   .return

    MOVE.L  A3,-(A7)
    BSR.W   TEXTDISP_ResetSelectionState

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
;   LAB_183C, LAB_183E, ESQ_SetCopperEffect_OnEnableHighlight,
;   GROUPD_JMPTBL_LAB_0A49/0A45, MATH_Mulu32, MATH_DivS32,
;   SCRIPT_BeginBannerCharTransition, LAB_1789, TEXTDISP_JMPTBL_LAB_0A48, TEXTDISP_ResetSelectionState
; READS:
;   entry+220, LAB_1BC7, LAB_2362
; WRITES:
;   LAB_2216, LAB_22AA/LAB_22AB, LAB_236C
; DESC:
;   Enables the highlight copper effect, computes bounds, and draws the frame.
; NOTES:
;   Uses banner transitions when in certain region modes.
;------------------------------------------------------------------------------
TEXTDISP_DrawHighlightFrame:
LAB_164D:
    LINK.W  A5,#-32
    MOVEM.L D2-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  A3,D0
    BEQ.W   .return

    TST.B   220(A3)
    BEQ.W   .return

    CLR.L   -(A7)
    PEA     8.W
    JSR     LAB_183C(PC)

    PEA     3.W
    CLR.L   -(A7)
    PEA     8.W
    JSR     LAB_183E(PC)

    MOVE.L  D0,LAB_2216
    JSR     GROUP_BA_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D0
    MOVEA.L LAB_2216,A0
    MOVE.W  4(A0),D0
    MOVEQ   #-22,D1
    ADD.L   LAB_2362,D1
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
    JSR     MATH_Mulu32(PC)

    MOVE.L  D0,-26(A5)
    MOVE.L  -22(A5),D1
    CMP.L   D0,D1
    BLT.S   .clamp_width

    MOVE.L  D0,D1

.clamp_width:
    MOVEQ   #0,D0
    MOVE.W  2(A0),D0
    MOVE.W  #1,LAB_22AA
    CLR.W   LAB_22AB
    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVE.L  D0,-18(A5)
    MOVE.L  D1,-22(A5)
    MOVE.L  A0,-4(A5)
    JSR     GROUPD_JMPTBL_LAB_0A49(PC)

    JSR     GROUPD_JMPTBL_LAB_0A45(PC)

    MOVE.B  LAB_1BC7,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .after_banner

    MOVEA.L LAB_2216,A0
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
    JSR     MATH_DivS32(PC)

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
    JSR     LAB_183E(PC)

    LEA     12(A7),A7
    MOVE.L  D0,LAB_2216
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
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVE.W  #1,LAB_236C
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
    JSR     LAB_1789(PC)

    PEA     3.W
    CLR.L   -(A7)
    PEA     8.W
    JSR     LAB_183E(PC)

    MOVE.L  D0,LAB_2216
    JSR     TEXTDISP_JMPTBL_LAB_0A48(PC)

    MOVE.L  A3,(A7)
    BSR.W   TEXTDISP_ResetSelectionState

    LEA     36(A7),A7

.return:
    MOVEM.L (A7)+,D2-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_HandleScriptCommand   (Dispatch text display command)
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
;   TEXTDISP_SetEntryTextFields, TEXTDISP_FilterAndSelectEntry,
;   TEXTDISP_DrawHighlightFrame, MEMORY_AllocateMemory, MEMORY_DeallocateMemory
; READS:
;   LAB_214B, LAB_2360/2361/2364
; WRITES:
;   LAB_2149/214A/214B/235D
; DESC:
;   Handles a script opcode by updating text display state and SourceCfg data.
; NOTES:
;   Command cases inferred from constants (0x43/0x4A/0x52 etc).
;------------------------------------------------------------------------------
TEXTDISP_HandleScriptCommand:
LAB_1656:
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
    PEA     LAB_214C
    PEA     -200(A5)
    JSR     WDISP_SPrintf(PC)

    MOVE.W  LAB_234D,D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    PEA     LAB_234B
    MOVE.L  A3,-(A7)
    JSR     TEXTDISP_SelectGroupAndEntry(PC)

    LEA     20(A7),A7
    SUBQ.W  #1,D0
    BNE.S   .handle_cmd_C_success

    MOVE.W  LAB_2153,LAB_235D
    MOVE.W  LAB_2364,LAB_2149
    BSR.W   LAB_15A3

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.W  D1,LAB_214A
    BRA.S   .dispatch_update

.handle_cmd_C_success:
    MOVE.W  LAB_2360,D0
    ADDQ.W  #1,D0
    BEQ.S   .handle_cmd_C_try_alt1

    MOVE.W  #1,LAB_235D
    MOVE.W  LAB_2360,LAB_2149
    MOVEQ   #-1,D0
    MOVE.W  D0,LAB_214A
    BRA.S   .dispatch_update

.handle_cmd_C_try_alt1:
    MOVE.W  LAB_2361,D0
    ADDQ.W  #1,D0
    BEQ.S   .handle_cmd_C_try_alt2

    CLR.W   LAB_235D
    MOVE.W  LAB_2361,LAB_2149
    MOVEQ   #-1,D0
    MOVE.W  D0,LAB_214A
    BRA.S   .dispatch_update

.handle_cmd_C_try_alt2:
    MOVEQ   #-1,D0
    MOVE.W  D0,LAB_214A
    MOVE.W  D0,LAB_2149
    MOVE.W  D0,LAB_235D

.dispatch_update:
    MOVE.W  LAB_235D,D0
    EXT.L   D0
    MOVE.W  LAB_2149,D1
    EXT.L   D1
    MOVE.W  LAB_214A,D2
    EXT.L   D2
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   TEXTDISP_BuildNowShowingStatusLine

    BSR.W   LAB_15A2

    LEA     12(A7),A7
    MOVEQ   #0,D5
    BRA.W   .finalize

.handle_cmd_J:
    MOVE.W  LAB_235D,D0
    EXT.L   D0
    MOVE.W  LAB_2149,D1
    EXT.L   D1
    MOVE.W  LAB_214A,D2
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

    TST.L   LAB_214B
    BNE.S   .init_source_cfg

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     732.W
    PEA     1084.W
    PEA     GLOB_STR_TEXTDISP_C_1
    JSR     MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,LAB_214B

.init_source_cfg:
    PEA     LAB_234B
    MOVE.L  A3,-(A7)
    MOVE.L  LAB_214B,-(A7)
    BSR.W   TEXTDISP_SetEntryTextFields

    PEA     70.W
    MOVE.L  LAB_214B,-(A7)
    BSR.W   TEXTDISP_FilterAndSelectEntry

    LEA     20(A7),A7
    TST.L   D0
    BNE.S   .apply_source_cfg

    TST.L   LAB_214B
    BEQ.S   .apply_source_cfg

    MOVEA.L LAB_214B,A0
    ADDA.W  #$dc,A0
    LEA     LAB_214E,A1

.copy_default_cfg:
    MOVE.B  (A1)+,(A0)+
    BNE.S   .copy_default_cfg

.apply_source_cfg:
    MOVE.L  LAB_214B,-(A7)
    BSR.W   TEXTDISP_DrawHighlightFrame

    PEA     88.W
    MOVE.L  LAB_214B,-(A7)
    BSR.W   TEXTDISP_FilterAndSelectEntry

    LEA     12(A7),A7
    MOVEQ   #0,D4

.finalize:
    TST.L   D5
    BEQ.S   .cleanup_if_needed

    MOVE.W  #(-1),LAB_2149
    MOVE.W  #$31,LAB_214A

.cleanup_if_needed:
    TST.L   D4
    BEQ.S   .return

    CLR.L   -(A7)
    CLR.L   -(A7)
    BSR.W   TEXTDISP_FilterAndSelectEntry

    ADDQ.W  #8,A7
    TST.L   LAB_214B
    BEQ.S   .return

    PEA     732.W
    MOVE.L  LAB_214B,-(A7)
    PEA     1106.W
    PEA     GLOB_STR_TEXTDISP_C_2
    JSR     MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    CLR.L   LAB_214B

.return:
    MOVEM.L (A7)+,D2/D4-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_LoadSourceConfig   (Load SourceCfg.ini)
; ARGS:
;   none
; RET:
;   none
; CLOBBERS:
;   D0-D7/A0
; CALLS:
;   PARSEINI_ParseIniBufferAndDispatch
; READS:
;   GLOB_STR_DF0_SOURCECFG_INI_2
; WRITES:
;   LAB_235E, LAB_235F, LAB_2131
; DESC:
;   Clears the SourceCfg table and parses df0:SourceCfg.ini.
; NOTES:
;   Table size is 0x12e entries.
;------------------------------------------------------------------------------
TEXTDISP_LoadSourceConfig:
LAB_1664:
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D7

.clear_table_loop:
    CMPI.L  #$12e,D7
    BGE.S   .return

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_235E,A0
    ADDA.L  D0,A0
    CLR.L   (A0)
    ADDQ.L  #1,D7
    BRA.S   .clear_table_loop

.return:
    CLR.L   LAB_235F
    CLR.B   LAB_2131
    PEA     GLOB_STR_DF0_SOURCECFG_INI_2
    JSR     PARSEINI_ParseIniBufferAndDispatch(PC)

    ADDQ.W  #4,A7
    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_ClearSourceConfig   (Free SourceCfg table)
; ARGS:
;   none
; RET:
;   none
; CLOBBERS:
;   D0-D7/A0-A2
; CALLS:
;   JMPTBL_LAB_0B44_2, MEMORY_DeallocateMemory
; READS:
;   LAB_235E, LAB_235F
; WRITES:
;   LAB_235E, LAB_235F, LAB_2131
; DESC:
;   Frees all SourceCfg entries and resets the table/state.
; NOTES:
;   Each entry is 6 bytes.
;------------------------------------------------------------------------------
TEXTDISP_ClearSourceConfig:
LAB_1667:
    LINK.W  A5,#-8
    MOVEM.L D7/A2,-(A7)
    MOVEQ   #0,D7

.loop_entries:
    CMP.L   LAB_235F,D7
    BGE.S   .return

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_235E,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    TST.L   (A1)
    BEQ.S   .free_entry

    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A2
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  (A1),-(A7)
    CLR.L   -(A7)
    MOVE.L  A2,20(A7)
    JSR     JMPTBL_LAB_0B44_2(PC)

    MOVEA.L 20(A7),A0
    MOVE.L  D0,(A0)
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_235E,A0
    ADDA.L  D0,A0
    PEA     6.W
    MOVE.L  (A0),-(A7)
    PEA     1153.W
    PEA     GLOB_STR_TEXTDISP_C_3
    JSR     MEMORY_DeallocateMemory(PC)

    LEA     24(A7),A7
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_235E,A0
    ADDA.L  D0,A0
    CLR.L   (A0)

.free_entry:
    ADDQ.L  #1,D7
    BRA.S   .loop_entries

.return:
    CLR.L   LAB_235F
    CLR.B   LAB_2131
    MOVEM.L (A7)+,D7/A2
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_ApplySourceConfigToEntry   (Apply SourceCfg flags)
; ARGS:
;   stack +20: entryPtr (A3)
; RET:
;   none
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   STRING_CompareNoCaseN
; READS:
;   LAB_235E, LAB_235F, LAB_2131
; WRITES:
;   entry+40
; DESC:
;   Compares entry name against SourceCfg entries and ORs matching flags.
; NOTES:
;   Clears masked flags before applying matches.
;------------------------------------------------------------------------------
TEXTDISP_ApplySourceConfigToEntry:
LAB_166B:
    MOVEM.L D7/A2-A3/A6,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.L  A3,D0
    BEQ.S   .return

    MOVE.B  LAB_2131,D0
    NOT.B   D0
    AND.B   D0,40(A3)
    MOVEQ   #0,D7

.loop_entries:
    CMP.L   LAB_235F,D7
    BGE.S   .return

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_235E,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A2
    LEA     12(A3),A1
    ADDA.L  D0,A0
    MOVEA.L (A0),A6
    MOVEA.L (A6),A0

.compare_entry_name:
    TST.B   (A0)+
    BNE.S   .compare_entry_name

    SUBQ.L  #1,A0
    SUBA.L  (A6),A0
    MOVE.L  A0,-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  (A2),-(A7)
    JSR     STRING_CompareNoCaseN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .set_entry_flag

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_235E,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.B  4(A1),D0
    OR.B    D0,40(A3)

.set_entry_flag:
    ADDQ.L  #1,D7
    BRA.S   .loop_entries

.return:
    MOVEM.L (A7)+,D7/A2-A3/A6
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_ApplySourceConfigAllEntries   (Apply SourceCfg to all entries)
; ARGS:
;   none
; RET:
;   none
; CLOBBERS:
;   D0-D7
; CALLS:
;   GROUPD_JMPTBL_LAB_0923, TEXTDISP_ApplySourceConfigToEntry
; READS:
;   LAB_2231, LAB_222F
; DESC:
;   Iterates entries across both groups and applies SourceCfg flags.
; NOTES:
;   Uses group IDs 1 and 2.
;------------------------------------------------------------------------------
TEXTDISP_ApplySourceConfigAllEntries:
LAB_1670:
    LINK.W  A5,#-8
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D7

.loop_group1:
    MOVEQ   #0,D0
    MOVE.W  LAB_2231,D0
    CMP.L   D0,D7
    BGE.S   .loop_group1_done

    PEA     1.W
    MOVE.L  D7,-(A7)
    JSR     GROUPD_JMPTBL_LAB_0923(PC)

    MOVE.L  D0,(A7)
    MOVE.L  D0,-8(A5)
    BSR.W   TEXTDISP_ApplySourceConfigToEntry

    ADDQ.W  #8,A7
    ADDQ.L  #1,D7
    BRA.S   .loop_group1

.loop_group1_done:
    MOVEQ   #0,D7

.loop_group2:
    MOVEQ   #0,D0
    MOVE.W  LAB_222F,D0
    CMP.L   D0,D7
    BGE.S   .return

    PEA     2.W
    MOVE.L  D7,-(A7)
    JSR     GROUPD_JMPTBL_LAB_0923(PC)

    MOVE.L  D0,(A7)
    MOVE.L  D0,-8(A5)
    BSR.W   TEXTDISP_ApplySourceConfigToEntry

    ADDQ.W  #8,A7
    ADDQ.L  #1,D7
    BRA.S   .loop_group2

.return:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_AddSourceConfigEntry   (Append SourceCfg entry)
; ARGS:
;   stack +8: namePtr (A3)
;   stack +12: typePtr (A2)
; RET:
;   none
; CLOBBERS:
;   D0/A0-A3
; CALLS:
;   MEMORY_AllocateMemory, JMPTBL_LAB_0B44_2, STRING_CompareNoCase
; READS:
;   LAB_235F, LAB_2133, LAB_2131
; WRITES:
;   LAB_235E, LAB_235F, LAB_2131
; DESC:
;   Allocates a 6-byte SourceCfg entry, stores name/type, and updates flags.
; NOTES:
;   Marks entries matching \"PrevueSports\" with flag 0x08.
;------------------------------------------------------------------------------
TEXTDISP_AddSourceConfigEntry:
LAB_1675:
    LINK.W  A5,#-8
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  LAB_235F,D0
    ASL.L   #2,D0
    LEA     LAB_235E,A0
    ADDA.L  D0,A0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     6.W
    PEA     1229.W
    PEA     GLOB_STR_TEXTDISP_C_4
    MOVE.L  A0,24(A7)
    JSR     MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L 8(A7),A0
    MOVE.L  D0,(A0)
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.S   .return

    ADDQ.L  #1,LAB_235F
    MOVEA.L D0,A0
    MOVE.L  (A0),-(A7)
    MOVE.L  A3,-(A7)
    JSR     JMPTBL_LAB_0B44_2(PC)

    MOVEA.L -4(A5),A0
    MOVE.L  D0,(A0)
    MOVE.L  LAB_2133,(A7)
    MOVE.L  A2,-(A7)
    JSR     STRING_CompareNoCase(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .set_entry_flag

    MOVEQ   #8,D0
    MOVEA.L -4(A5),A0
    MOVE.B  D0,4(A0)

.set_entry_flag:
    MOVE.B  LAB_2131,D0
    MOVEA.L -4(A5),A0
    OR.B    4(A0),D0
    MOVE.B  D0,LAB_2131

.return:
    MOVEM.L (A7)+,A2-A3
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_JMPTBL_NEWGRID_ShouldOpenEditor   (JumpStub)
; ARGS:
;   see NEWGRID_ShouldOpenEditor
; RET:
;   see NEWGRID_ShouldOpenEditor
; DESC:
;   Jump stub to NEWGRID_ShouldOpenEditor.
;------------------------------------------------------------------------------
TEXTDISP_JMPTBL_NEWGRID_ShouldOpenEditor:
LAB_1678:
    JMP     NEWGRID_ShouldOpenEditor

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_JMPTBL_LAB_091A   (JumpStub_LAB_091A)
; ARGS:
;   see LAB_091A
; RET:
;   see LAB_091A
; DESC:
;   Jump stub to LAB_091A.
;------------------------------------------------------------------------------
TEXTDISP_JMPTBL_LAB_091A:
LAB_1679:
    JMP     LAB_091A

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_JMPTBL_LAB_0A48   (JumpStub_LAB_0A48)
; ARGS:
;   see LAB_0A48
; RET:
;   see LAB_0A48
; DESC:
;   Jump stub to LAB_0A48.
;------------------------------------------------------------------------------
TEXTDISP_JMPTBL_LAB_0A48:
LAB_167A:
    JMP     LAB_0A48

GROUP_BA_JMPTBL_CLEANUP_BuildAlignedStatusLine:
    JMP     CLEANUP_BuildAlignedStatusLine

GROUP_BA_JMPTBL_CLEANUP_DrawInsetRectFrame:
    JMP     CLEANUP_DrawInsetRectFrame

;!======

    ; Alignment
    MOVEQ   #97,D0
