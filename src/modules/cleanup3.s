;------------------------------------------------------------------------------
; FUNC: CLEANUP_RenderAlignedStatusScreen   (RenderAlignedStatusScreen??)
; ARGS:
;   stack +4: modeOrFlag?? (word; low word used)
;   stack +8: codeOrIndex?? (word; low word used)
;   stack +12: optionOrFlag?? (word; low word used)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A2/A6
; CALLS:
;   LAB_05C1, LAB_026E, LAB_055F, ESQ_SetCopperEffect_OffDisableHighlight, LAB_026D, _LVOSetRast,
;   LAB_0265, LAB_0273, LAB_0266, _LVOSetAPen, LAB_0268, ESQ_SetCopperEffect_OnEnableHighlight,
;   LAB_037F, LAB_026B, JMP_TBL_APPEND_DATA_AT_NULL_1, LAB_0267, LAB_0269,
;   LAB_026F, CLEANUP_BuildAlignedStatusLine, LAB_0271, LAB_0270, LAB_0272, LAB_0276,
;   _LVORectFill, LAB_026C, LAB_026A
; READS:
;   LAB_234B, LAB_234C, LAB_234D, LAB_234E, LAB_2364-LAB_236E,
;   LAB_2367, LAB_2368, LAB_2369, LAB_2373-LAB_2379, LAB_237A,
;   LAB_2236, LAB_236A, LAB_20ED, LAB_2153, LAB_2157, LAB_2158,
;   LAB_222D, LAB_2230, LAB_227C, LAB_1DDB, LAB_1DDC,
;   GLOB_REF_RASTPORT_2, GLOB_REF_GRAPHICS_LIBRARY,
;   GLOB_STR_ALIGNED_NOW_SHOWING, GLOB_STR_ALIGNED_NEXT_SHOWING,
;   GLOB_STR_ALIGNED_TODAY_AT, GLOB_STR_ALIGNED_TONIGHT_AT,
;   GLOB_STR_ALIGNED_TOMORROW_AT
; WRITES:
;   LAB_2259, LAB_2365, LAB_2366, LAB_2367, LAB_2368, LAB_2369,
;   LAB_236C, LAB_236D, LAB_236E, LAB_2373, LAB_2377
; DESC:
;   Builds and renders the aligned status banner text (now/next and time
;   phrases), updates alignment globals, and draws into rastport 2.
; NOTES:
;   - Uses several template buffers and tables to choose which status line
;     to render based on a code derived from LAB_234D/E.
;------------------------------------------------------------------------------
CLEANUP_RenderAlignedStatusScreen:
LAB_021A:
    LINK.W  A5,#-840
    MOVEM.L D2-D7/A2,-(A7)

    MOVE.W  10(A5),D7
    MOVE.W  14(A5),D6
    MOVE.W  18(A5),D5
    MOVE.W  D7,LAB_2365
    CLR.B   -554(A5)
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_22AB
    MOVE.W  D0,-40(A5)
    MOVEQ   #1,D0
    CMP.W   D0,D7
    BNE.S   .use_secondary_template

    LEA     LAB_234B,A0
    LEA     -554(A5),A1

.copy_template_primary_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_template_primary_loop

    MOVE.W  LAB_234D,-38(A5)
    BRA.S   .backup_template_text

.use_secondary_template:
    LEA     LAB_234C,A0
    LEA     -554(A5),A1

.copy_template_secondary_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_template_secondary_loop

    MOVE.W  LAB_234E,-38(A5)

.backup_template_text:
    LEA     -554(A5),A0
    LEA     -754(A5),A1

.copy_template_backup_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_template_backup_loop

    TST.W   -38(A5)
    BNE.S   .normalize_template_code

    MOVEQ   #48,D0
    MOVE.W  D0,-38(A5)

.normalize_template_code:
    MOVE.W  -38(A5),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     LAB_1B5C
    JSR     LAB_05C1(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .maybe_format_alt_time_text

    CLR.B   LAB_2367
    MOVE.W  LAB_2368,D0
    EXT.L   D0
    MOVE.W  LAB_2369,D1
    EXT.L   D1
    CLR.L   -(A7)
    PEA     LAB_2367
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_026E(PC)

    LEA     16(A7),A7
    BRA.S   .dispatch_template_code

.maybe_format_alt_time_text:
    MOVEQ   #79,D0
    CMP.W   -38(A5),D0
    BNE.S   .dispatch_template_code

    CLR.B   LAB_21B0
    MOVE.W  LAB_2368,D0
    EXT.L   D0
    MOVE.W  LAB_2369,D1
    EXT.L   D1
    PEA     1.W
    PEA     LAB_21B0
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_026E(PC)

    LEA     16(A7),A7

.dispatch_template_code:
    MOVEQ   #69,D0
    CMP.W   -38(A5),D0
    BNE.W   .check_code_F

    MOVE.W  LAB_2364,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2236,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-8(A5)
    MOVE.W  LAB_2364,D0
    EXT.L   D0
    ADD.L   D0,D0
    LEA     LAB_236A,A0
    ADDA.L  D0,A0
    MOVE.W  (A0),-42(A5)
    CLR.W   -36(A5)

.scan_entry_loop:
    ADDQ.W  #1,-42(A5)
    MOVE.W  -42(A5),D0
    EXT.L   D0
    PEA     48.W
    PEA     1.W
    MOVE.L  D0,-(A7)
    JSR     LAB_055F(PC)

    LEA     12(A7),A7
    MOVE.W  LAB_2364,D1
    EXT.L   D1
    ADD.L   D1,D1
    LEA     LAB_236A,A0
    ADDA.L  D1,A0
    MOVE.W  D0,-42(A5)
    CMP.W   (A0),D0
    BEQ.S   .apply_entry_selection

    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    MOVEA.L -8(A5),A0
    TST.L   56(A0,D1.L)
    BNE.S   .apply_entry_selection

    MOVE.W  -36(A5),D0
    MOVEQ   #60,D1
    CMP.W   D1,D0
    BGE.S   .apply_entry_selection

    ADDQ.W  #1,-36(A5)
    BRA.S   .scan_entry_loop

.apply_entry_selection:
    MOVE.W  LAB_2364,D0
    EXT.L   D0
    ADD.L   D0,D0
    LEA     LAB_236A,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.W  -42(A5),D0
    MOVE.W  (A1),D1
    CMP.W   D0,D1
    BNE.S   .store_entry_selection

    MOVE.W  LAB_236E,D1
    MOVE.W  LAB_2364,D2
    CMP.W   D2,D1
    BEQ.W   .done

.store_entry_selection:
    MOVE.W  LAB_2364,D1
    EXT.L   D1
    ADD.L   D1,D1
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    MOVE.W  D0,(A1)
    ADDA.L  D1,A0
    MOVE.W  (A0),D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -8(A5),A0
    MOVEA.L 56(A0,D0.L),A0
    LEA     -554(A5),A1

.copy_entry_title_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_entry_title_loop

    MOVE.W  #2,-40(A5)
    BRA.W   .finalize_title_state

.check_code_F:
    MOVEQ   #70,D0
    CMP.W   -38(A5),D0
    BNE.S   .check_code_G

    MOVE.W  LAB_2368,D0
    ADDQ.W  #1,D0
    BEQ.S   .fallback_title_buffer

    MOVE.B  LAB_2367,D0
    TST.B   D0
    BEQ.S   .fallback_title_buffer

    LEA     LAB_2367,A0
    LEA     -554(A5),A1

.copy_buffer_title_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_buffer_title_loop

    BRA.S   .set_title_ready

.fallback_title_buffer:
    TST.L   LAB_1DDB
    BEQ.W   .done

    MOVEA.L LAB_1DDB,A0
    LEA     -554(A5),A1

.copy_fallback_title_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_fallback_title_loop

.set_title_ready:
    MOVE.W  #2,-40(A5)
    BRA.W   .finalize_title_state

.check_code_G:
    MOVEQ   #71,D0
    CMP.W   -38(A5),D0
    BNE.S   .check_code_N

    MOVE.W  LAB_2368,D0
    ADDQ.W  #1,D0
    BEQ.S   .fallback_title_buffer_g

    MOVE.B  LAB_2367,D0
    TST.B   D0
    BEQ.S   .fallback_title_buffer_g

    LEA     LAB_2367,A0
    LEA     -554(A5),A1

.copy_buffer_title_loop_g:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_buffer_title_loop_g

    BRA.S   .set_title_ready_g

.fallback_title_buffer_g:
    TST.L   LAB_1DDC
    BEQ.W   .done

    MOVEA.L LAB_1DDC,A0
    LEA     -554(A5),A1

.copy_fallback_title_loop_g:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_fallback_title_loop_g

.set_title_ready_g:
    MOVE.W  #2,-40(A5)
    BRA.S   .finalize_title_state

.check_code_N:
    MOVEQ   #78,D0
    CMP.W   -38(A5),D0
    BNE.S   .check_code_O

    MOVE.W  LAB_2368,D0
    ADDQ.W  #1,D0
    BEQ.W   .done

    MOVE.B  LAB_2367,D0
    TST.B   D0
    BEQ.W   .done

    LEA     LAB_2367,A0
    LEA     -554(A5),A1

.copy_buffer_title_loop_n:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_buffer_title_loop_n

    MOVE.W  #2,-40(A5)
    BRA.S   .finalize_title_state

.check_code_O:
    MOVEQ   #79,D0
    CMP.W   -38(A5),D0
    BNE.S   .finalize_title_state

    MOVE.W  LAB_2368,D0
    ADDQ.W  #1,D0
    BEQ.W   .done

    MOVE.B  LAB_21B0,D0
    TST.B   D0
    BEQ.W   .done

    LEA     LAB_21B0,A0
    LEA     -554(A5),A1

.copy_alt_title_loop_o:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_alt_title_loop_o

    MOVEQ   #2,D0
    MOVE.W  D0,-40(A5)

.finalize_title_state:
    MOVEQ   #2,D0
    CMP.W   -40(A5),D0
    BEQ.S   .sync_time_defaults

    MOVEQ   #-1,D0
    MOVE.W  D0,LAB_2368
    MOVE.W  D0,LAB_2369

.sync_time_defaults:
    MOVEQ   #53,D0
    CMP.W   D0,D6
    BNE.S   .maybe_refresh_display

    JSR     ESQ_SetCopperEffect_OffDisableHighlight(PC)

.maybe_refresh_display:
    JSR     LAB_026D(PC)

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVEA.L LAB_2216,A2
    MOVEA.L 14(A2),A1
    MOVEQ   #0,D0
    MOVE.B  5(A1),D0
    MOVEQ   #1,D1
    MOVE.L  D1,D2
    ASL.L   D0,D2
    SUBQ.L  #1,D2
    MOVEA.L A0,A1
    MOVE.L  D2,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    TST.W   D7
    BNE.S   .alloc_rastport_primary

    MOVEQ   #1,D0
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_0265(PC)

    LEA     12(A7),A7
    MOVE.L  D0,LAB_2216
    BRA.S   .primary_rastport_ready

.alloc_rastport_primary:
    PEA     1.W
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_0265(PC)

    LEA     12(A7),A7
    MOVE.L  D0,LAB_2216

.primary_rastport_ready:
    TST.W   D5
    BNE.S   .maybe_notify_timing

    MOVE.L  D7,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    JSR     LAB_0273(PC)

    ADDQ.W  #4,A7

.maybe_notify_timing:
    TST.W   D7
    BNE.S   .alloc_rastport_secondary

    PEA     4.W
    CLR.L   -(A7)
    PEA     1.W
    JSR     LAB_0265(PC)

    MOVE.L  D0,LAB_2216
    PEA     2.W
    JSR     LAB_0266(PC)

    LEA     16(A7),A7
    BRA.S   .after_secondary_alloc

.alloc_rastport_secondary:
    PEA     4.W
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_0265(PC)

    MOVE.L  D0,LAB_2216
    PEA     1.W
    JSR     LAB_0266(PC)

    LEA     16(A7),A7

.after_secondary_alloc:
    MOVEQ   #1,D0
    CMP.W   D0,D5
    BNE.S   .maybe_clear_rastport_secondary

    MOVEA.L GLOB_REF_RASTPORT_2,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

.maybe_clear_rastport_secondary:
    JSR     ESQ_NoOp(PC)

    MOVEA.L GLOB_REF_RASTPORT_2,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVE.W  LAB_2364,LAB_236E
    MOVEQ   #48,D0
    CMP.W   -38(A5),D0
    BNE.S   .handle_empty_template

    MOVE.B  -554(A5),D0
    TST.B   D0
    BNE.S   .handle_empty_template

    MOVE.L  D7,D0
    EXT.L   D0
    PEA     3.W
    MOVE.L  D0,-(A7)
    JSR     LAB_0268(PC)

    JSR     ESQ_SetCopperEffect_OnEnableHighlight(PC)

    MOVEQ   #0,D0
    MOVE.B  D0,LAB_2366
    MOVE.W  LAB_2364,D1
    MOVE.W  D1,LAB_2368
    MOVEQ   #-1,D1
    MOVE.W  D1,LAB_2369
    BRA.W   .done

.handle_empty_template:
    MOVE.B  LAB_2377,D0
    MOVEQ   #100,D1
    CMP.B   D1,D0
    BEQ.S   .select_aligned_index

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.W  D1,-36(A5)
    BRA.S   .check_aligned_index_valid

.select_aligned_index:
    MOVEQ   #0,D0
    MOVE.B  LAB_2373,D0
    MOVE.W  D0,-36(A5)

.check_aligned_index_valid:
    MOVE.W  -36(A5),D0
    MOVEQ   #49,D1
    CMP.W   D1,D0
    BGE.S   .reset_alignment_state

    MOVE.B  -554(A5),D1
    TST.B   D1
    BEQ.S   .reset_alignment_state

    MOVEQ   #1,D1
    MOVE.W  LAB_2364,D2
    MOVE.W  D2,LAB_2368
    MOVE.W  D0,LAB_2369
    MOVE.W  D1,-40(A5)
    BRA.S   .prepare_channel_line

.reset_alignment_state:
    MOVE.W  -40(A5),D0
    MOVEQ   #2,D1
    CMP.W   D1,D0
    BEQ.S   .prepare_channel_line

    CLR.B   LAB_2366
    MOVE.W  LAB_2364,D2
    MOVE.W  D2,LAB_2368
    MOVE.W  #(-1),LAB_2369

.prepare_channel_line:
    MOVEQ   #2,D0
    CMP.W   -40(A5),D0
    BEQ.S   .clear_channel_string

    MOVE.W  LAB_2364,D0
    EXT.L   D0
    TST.W   LAB_2153
    BEQ.S   .select_channel_format

    MOVEQ   #1,D1
    BRA.S   .format_channel_string

.select_channel_format:
    MOVEQ   #2,D1

.format_channel_string:
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_037F(PC)

    PEA     LAB_236B
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-12(A5)
    JSR     LAB_026B(PC)

    LEA     16(A7),A7
    LEA     LAB_236B,A0
    LEA     LAB_2259,A1

.copy_channel_string_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_channel_string_loop

    BRA.S   .append_optional_prefix

.clear_channel_string:
    MOVEQ   #0,D0
    MOVE.B  D0,LAB_2259

.append_optional_prefix:
    MOVE.B  -554(A5),D0
    TST.B   D0
    BEQ.S   .append_template_text

    PEA     LAB_2158
    PEA     LAB_2259
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    ADDQ.W  #8,A7

.append_template_text:
    PEA     -554(A5)
    PEA     LAB_2259
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    ADDQ.W  #8,A7
    MOVEQ   #1,D0
    CMP.W   -40(A5),D0
    BNE.W   .check_template_fallback

    MOVE.B  LAB_2377,D0
    MOVEQ   #100,D1
    CMP.B   D1,D0
    BNE.S   .select_now_showing_index

    MOVEQ   #0,D0
    MOVE.B  LAB_2374,D0
    BRA.S   .after_now_showing_index

.select_now_showing_index:
    MOVEQ   #0,D0
    MOVE.B  LAB_2378,D0

.after_now_showing_index:
    TST.L   D0
    BEQ.S   .build_time_phrase

    LEA     GLOB_STR_ALIGNED_NOW_SHOWING,A0
    LEA     LAB_2366,A1

.copy_now_showing_label_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_now_showing_label_loop

    MOVE.B  LAB_2377,D0
    CMP.B   D1,D0
    BNE.S   .select_next_showing_index

    MOVEQ   #0,D0
    MOVE.B  LAB_2375,D0
    BRA.S   .after_next_showing_index

.select_next_showing_index:
    MOVEQ   #0,D0
    MOVE.B  LAB_2379,D0

.after_next_showing_index:
    TST.L   D0
    BEQ.W   .append_alignment_text

    PEA     LAB_2366
    PEA     LAB_2259
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    LEA     GLOB_STR_ALIGNED_NEXT_SHOWING,A0
    LEA     LAB_2366,A1

.copy_next_showing_label_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_next_showing_label_loop

    MOVE.W  -36(A5),D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    PEA     -834(A5)
    JSR     LAB_0269(PC)

    PEA     -834(A5)
    PEA     LAB_2366
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    LEA     20(A7),A7
    BRA.W   .append_alignment_text

.build_time_phrase:
    MOVE.W  -36(A5),D0
    EXT.L   D0
    TST.W   LAB_2153
    BEQ.S   .select_time_table

    MOVEQ   #0,D1
    MOVE.B  LAB_2230,D1
    BRA.S   .format_time_components

.select_time_table:
    MOVEQ   #0,D1
    MOVE.B  LAB_222D,D1

.format_time_components:
    MOVEQ   #0,D2
    MOVE.B  D1,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -34(A5)
    JSR     LAB_0275(PC)

    PEA     -34(A5)
    JSR     LAB_0274(PC)

    LEA     16(A7),A7
    MOVE.W  -18(A5),D0
    MOVE.W  LAB_227C,D1
    CMP.W   D1,D0
    BEQ.S   .check_today_vs_tonight

    LEA     GLOB_STR_ALIGNED_TOMORROW_AT,A0
    LEA     LAB_2366,A1

.copy_tomorrow_label_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_tomorrow_label_loop

    BRA.S   .append_time_string

.check_today_vs_tonight:
    MOVE.W  -26(A5),D0
    MOVEQ   #17,D1
    CMP.W   D1,D0
    BLT.S   .copy_today_label

    CMP.W   D1,D0
    BNE.S   .copy_tonight_label

    MOVE.W  -24(A5),D0
    MOVEQ   #30,D1
    CMP.W   D1,D0
    BGE.S   .copy_tonight_label

.copy_today_label:
    LEA     GLOB_STR_ALIGNED_TODAY_AT,A0
    LEA     LAB_2366,A1

.copy_today_label_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_today_label_loop

    BRA.S   .append_time_string

.copy_tonight_label:
    LEA     GLOB_STR_ALIGNED_TONIGHT_AT,A0
    LEA     LAB_2366,A1

.copy_tonight_label_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_tonight_label_loop

.append_time_string:
    PEA     -34(A5)
    JSR     LAB_0267(PC)

    MOVE.W  -36(A5),D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    PEA     -834(A5)
    JSR     LAB_0269(PC)

    PEA     -834(A5)
    PEA     LAB_2366
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    LEA     16(A7),A7

.append_alignment_text:
    PEA     LAB_2366
    PEA     LAB_2259
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    ADDQ.W  #8,A7
    BRA.S   .maybe_submit_record

.check_template_fallback:
    MOVEQ   #2,D0
    CMP.W   -40(A5),D0
    BEQ.S   .maybe_submit_record

    MOVE.W  -38(A5),D0
    MOVEQ   #48,D1
    CMP.W   D1,D0
    BLE.S   .check_template_range

    MOVEQ   #67,D1
    CMP.W   D1,D0
    BLE.S   .copy_template_label

.check_template_range:
    MOVEQ   #72,D1
    CMP.W   D1,D0
    BLT.S   .maybe_submit_record

    MOVEQ   #77,D1
    CMP.W   D1,D0
    BGT.S   .maybe_submit_record

.copy_template_label:
    LEA     LAB_2157,A0
    LEA     LAB_2366,A1

.copy_template_label_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_template_label_loop

    MOVE.W  -38(A5),D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_20ED,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    PEA     LAB_2366
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    PEA     LAB_2366
    PEA     LAB_2259
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    LEA     16(A7),A7

.maybe_submit_record:
    MOVEQ   #2,D0
    CMP.W   -40(A5),D0
    BNE.S   .prepare_output_record

    MOVE.W  -38(A5),D0
    MOVEQ   #70,D1
    CMP.W   D1,D0
    BEQ.S   .prepare_output_record

    MOVEQ   #71,D1
    CMP.W   D1,D0
    BEQ.S   .prepare_output_record

    MOVEQ   #78,D1
    CMP.W   D1,D0
    BEQ.S   .prepare_output_record

    MOVEQ   #79,D1
    CMP.W   D1,D0
    BNE.S   .render_output_text

.prepare_output_record:
    CLR.L   -(A7)
    JSR     LAB_026F(PC)

    ADDQ.W  #4,A7
    MOVE.W  LAB_2153,D0
    EXT.L   D0
    MOVE.W  LAB_2368,D1
    EXT.L   D1
    MOVE.W  LAB_2369,D2
    EXT.L   D2
    MOVEQ   #2,D3
    CMP.W   -40(A5),D3
    BNE.S   .select_output_mode

    MOVEQ   #1,D3
    BRA.S   .submit_output_record

.select_output_mode:
    MOVEQ   #0,D3

.submit_output_record:
    TST.L   LAB_237A
    SEQ     D4
    NEG.B   D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,-(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_2259
    JSR     CLEANUP_BuildAlignedStatusLine(PC)

    LEA     24(A7),A7
    MOVEQ   #2,D0
    CMP.W   -40(A5),D0
    BNE.S   .render_output_text

    PEA     LAB_2366
    PEA     LAB_2259
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    ADDQ.W  #8,A7

.render_output_text:
    MOVE.B  #$64,LAB_2377
    MOVE.B  #$31,LAB_2373
    CLR.W   LAB_236D

    MOVEA.L GLOB_REF_RASTPORT_2,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVE.W  #1,LAB_236C
    MOVEQ   #0,D0
    MOVEA.L LAB_2216,A0
    MOVE.W  2(A0),D0
    MOVE.L  D0,-(A7)
    PEA     LAB_2259
    JSR     LAB_0271(PC)

    PEA     3.W
    PEA     LAB_2259
    JSR     LAB_0270(PC)

    MOVEA.L GLOB_REF_RASTPORT_2,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    PEA     2.W
    JSR     LAB_0272(PC)

    MOVE.L  D0,-4(A5)

    MOVEA.L D0,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    PEA     2.W
    JSR     LAB_0276(PC)

    MOVEQ   #0,D1
    MOVE.W  D0,D1
    TST.L   D1
    BPL.S   .center_output_rect

    ADDQ.L  #1,D1

.center_output_rect:
    ASR.L   #1,D1
    PEA     2.W
    MOVE.L  D1,56(A7)
    JSR     LAB_0276(PC)

    MOVEQ   #0,D1
    MOVE.W  D0,D1
    SUBQ.L  #1,D1

    MOVE.L  D1,D3
    MOVEA.L -4(A5),A1
    MOVEQ   #0,D0
    MOVE.L  56(A7),D1
    MOVE.L  #703,D2
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVORectFill(A6)

    JSR     ESQ_SetCopperEffect_OnEnableHighlight(PC)

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVEQ   #0,D0
    MOVEA.L LAB_2216,A1
    MOVE.W  2(A1),D0
    SUBQ.L  #1,D0
    MOVEQ   #0,D1
    MOVE.W  4(A1),D1
    SUBQ.L  #1,D1
    PEA     192.W
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D2,-(A7)
    PEA     GLOB_REF_320_240_BITMAP
    JSR     LAB_026C(PC)

    JSR     LAB_026A(PC)

.done:
    MOVEM.L -868(A5),D2-D7/A2
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

;------------------------------------------------------------------------------
; FUNC: LAB_0265   (JumpStub_LAB_183E)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_183E
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_183E.
;------------------------------------------------------------------------------
LAB_0265:
    JMP     LAB_183E

;------------------------------------------------------------------------------
; FUNC: LAB_0266   (JumpStub_LAB_14B1)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_14B1
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_14B1.
;------------------------------------------------------------------------------
LAB_0266:
    JMP     LAB_14B1

;------------------------------------------------------------------------------
; FUNC: LAB_0267   (JumpStub_LAB_0668)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_0668
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_0668.
;------------------------------------------------------------------------------
LAB_0267:
    JMP     LAB_0668

;------------------------------------------------------------------------------
; FUNC: LAB_0268   (JumpStub_LAB_16E3)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_16E3
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_16E3.
;------------------------------------------------------------------------------
LAB_0268:
    JMP     LAB_16E3

;------------------------------------------------------------------------------
; FUNC: LAB_0269   (JumpStub_LAB_16ED)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_16ED
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_16ED.
;------------------------------------------------------------------------------
LAB_0269:
    JMP     LAB_16ED

;------------------------------------------------------------------------------
; FUNC: LAB_026A   (JumpStub_LAB_0A48)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_0A48
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_0A48.
;------------------------------------------------------------------------------
LAB_026A:
    JMP     LAB_0A48

;------------------------------------------------------------------------------
; FUNC: LAB_026B   (JumpStub_LAB_16D3)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_16D3
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_16D3.
;------------------------------------------------------------------------------
LAB_026B:
    JMP     LAB_16D3

;------------------------------------------------------------------------------
; FUNC: LAB_026C   (JumpStub_LAB_1ADA)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_1ADA
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_1ADA.
;------------------------------------------------------------------------------
LAB_026C:
    JMP     LAB_1ADA

;------------------------------------------------------------------------------
; FUNC: LAB_026D   (JumpStub_LAB_0A49)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_0A49
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_0A49.
;------------------------------------------------------------------------------
LAB_026D:
    JMP     LAB_0A49

;------------------------------------------------------------------------------
; FUNC: LAB_026E   (JumpStub_LAB_17A8)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_17A8
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_17A8.
;------------------------------------------------------------------------------
LAB_026E:
    JMP     LAB_17A8

;------------------------------------------------------------------------------
; FUNC: LAB_026F   (JumpStub_LAB_16D9)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_16D9
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_16D9.
;------------------------------------------------------------------------------
LAB_026F:
    JMP     LAB_16D9

;------------------------------------------------------------------------------
; FUNC: LAB_0270   (JumpStub_LAB_16CE)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_16CE
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_16CE.
;------------------------------------------------------------------------------
LAB_0270:
    JMP     LAB_16CE

;------------------------------------------------------------------------------
; FUNC: LAB_0271   (JumpStub_LAB_1755)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_1755
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_1755.
;------------------------------------------------------------------------------
LAB_0271:
    JMP     LAB_1755

;------------------------------------------------------------------------------
; FUNC: LAB_0272   (JumpStub_LAB_183D)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_183D
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_183D.
;------------------------------------------------------------------------------
LAB_0272:
    JMP     LAB_183D

;------------------------------------------------------------------------------
; FUNC: LAB_0273   (JumpStub_LAB_09C2)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_09C2
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_09C2.
;------------------------------------------------------------------------------
LAB_0273:
    JMP     LAB_09C2

;------------------------------------------------------------------------------
; FUNC: LAB_0274   (JumpStub_LAB_0665)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_0665
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_0665.
;------------------------------------------------------------------------------
LAB_0274:
    JMP     LAB_0665

;------------------------------------------------------------------------------
; FUNC: LAB_0275   (JumpStub_LAB_064E)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_064E
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_064E.
;------------------------------------------------------------------------------
LAB_0275:
    JMP     LAB_064E

;------------------------------------------------------------------------------
; FUNC: LAB_0276   (JumpStub_LAB_183B)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_183B
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_183B.
;------------------------------------------------------------------------------
LAB_0276:
    JMP     LAB_183B
