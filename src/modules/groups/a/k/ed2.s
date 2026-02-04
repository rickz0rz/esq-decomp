;------------------------------------------------------------------------------
; FUNC: ED2_DrawEntryDetailsPanel   (Draw entry details panel??)
; ARGS:
;   (none)
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D2/A0-A3/A6 ??
; CALLS:
;   GROUPB_JMPTBL_MEMORY_AllocateMemory, _LVOSetRast, GROUP_AM_JMPTBL_WDISP_SPrintf,
;   LAB_09AD, LAB_052D, LAB_07C7, GROUP_AI_JMPTBL_STRING_AppendAtNull,
;   GROUPB_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   LAB_21E5, LAB_2231, LAB_2236, LAB_1D32, LAB_1D33, LAB_2216
; WRITES:
;   LAB_1D33, LAB_21E5
; DESC:
;   Formats and draws details for the selected entry, including flags and titles.
; NOTES:
;   Builds a temporary 1000-byte text buffer and frees it before returning.
;------------------------------------------------------------------------------
ED2_DrawEntryDetailsPanel:
    LINK.W  A5,#-148
    MOVEM.L A2-A3,-(A7)
    MOVE.W  LAB_21E5,D0
    MOVE.W  LAB_2231,D1
    CMP.W   D1,D0
    BGE.S   .reset_index

    TST.W   D0
    BPL.S   .select_entry_ptr

.reset_index:
    SUBA.L  A0,A0
    MOVE.L  A0,LAB_1D33
    MOVEQ   #0,D1
    MOVE.W  D1,LAB_21E5
    BRA.S   .have_entry_ptr

.select_entry_ptr:
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     LAB_2236,A0
    ADDA.L  D1,A0
    MOVEA.L (A0),A1
    MOVE.L  A1,LAB_1D33

.have_entry_ptr:
    TST.L   LAB_1D33
    BEQ.W   .return

    TST.L   LAB_1D32
    BEQ.W   .return

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     1000.W
    PEA     374.W
    PEA     GLOB_STR_ED2_C_1
    JSR     GROUPB_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVE.L  D0,-144(A5)
    MOVEA.L A0,A1
    MOVEQ   #2,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    MOVE.W  LAB_21E6,D0
    MOVEQ   #48,D1
    CMP.W   D1,D0
    BGT.S   .clamp_row_index

    MOVEQ   #1,D1
    CMP.W   D1,D0
    BGE.S   .row_index_ready

.clamp_row_index:
    MOVE.W  #1,LAB_21E6

.row_index_ready:
    MOVE.W  LAB_21E5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2236,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),LAB_1D33
    MOVE.W  LAB_21E5,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.W  LAB_2231,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     GLOB_STR_PI_CLU_POS1
    PEA     -120(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    PEA     90.W
    PEA     -120(A5)
    MOVE.L  A0,-(A7)
    JSR     LAB_09AD(PC)

    LEA     28(A7),A7
    MOVEA.L LAB_1D32,A0
    MOVEA.L A0,A1
    ADDQ.L  #1,A1
    MOVE.L  A1,D0
    BEQ.S   .use_default_name

    LEA     1(A0),A1
    BRA.S   .name_ptr_ready

.use_default_name:
    LEA     LAB_1D3B,A1

.name_ptr_ready:
    TST.L   LAB_1D33
    BEQ.S   .use_default_source

    MOVEA.L LAB_1D33,A2
    BRA.S   .source_ptr_ready

.use_default_source:
    LEA     LAB_1D3C,A2

.source_ptr_ready:
    LEA     19(A0),A3
    MOVE.L  A3,D0
    BEQ.S   .use_default_call_letters

    LEA     19(A0),A3
    BRA.S   .call_letters_ready

.use_default_call_letters:
    LEA     LAB_1D3D,A3

.call_letters_ready:
    MOVE.L  A3,-(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  A1,-(A7)
    PEA     GLOB_STR_CHAN_SOURCE_CALLLTRS_1
    PEA     -120(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    PEA     120.W
    PEA     -120(A5)
    MOVE.L  A0,-(A7)
    JSR     LAB_09AD(PC)

    MOVE.W  LAB_21E6,D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  LAB_1D33,-(A7)
    MOVE.L  LAB_1D32,-(A7)
    MOVE.L  -144(A5),-(A7)
    JSR     LAB_052D

    LEA     44(A7),A7
    MOVE.L  D0,-148(A5)
    BEQ.S   .no_title_buffer

    MOVE.W  LAB_21E6,D0
    EXT.L   D0
    MOVE.L  LAB_1D33,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -140(A5)
    JSR     LAB_07C7(PC)

    LEA     12(A7),A7
    BRA.S   .title_buffer_ready

.no_title_buffer:
    CLR.B   -140(A5)

.title_buffer_ready:
    MOVE.W  LAB_21E6,D0
    EXT.L   D0
    TST.L   -148(A5)
    BEQ.S   .use_default_title

    MOVEA.L -148(A5),A0
    BRA.S   .title_ptr_ready

.use_default_title:
    LEA     LAB_1D3F,A0

.title_ptr_ready:
    PEA     -140(A5)
    MOVE.L  A0,-(A7)
    MOVE.L  D0,-(A7)
    PEA     GLOB_STR_TS_TITLE_TIME
    PEA     -120(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    PEA     150.W
    PEA     -120(A5)
    MOVE.L  A0,-(A7)
    JSR     LAB_09AD(PC)

    LEA     32(A7),A7
    CLR.B   -120(A5)
    MOVEA.L LAB_1D33,A0
    ADDA.W  LAB_21E6,A0
    BTST    #0,7(A0)
    BEQ.S   .after_flag0

    PEA     LAB_1D40
    PEA     -120(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag0:
    MOVEA.L LAB_1D33,A0
    ADDA.W  LAB_21E6,A0
    BTST    #1,7(A0)
    BEQ.S   .after_flag1

    PEA     LAB_1D41
    PEA     -120(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag1:
    MOVEA.L LAB_1D33,A0
    ADDA.W  LAB_21E6,A0
    BTST    #2,7(A0)
    BEQ.S   .after_flag2

    PEA     LAB_1D42
    PEA     -120(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag2:
    MOVEA.L LAB_1D33,A0
    ADDA.W  LAB_21E6,A0
    BTST    #3,7(A0)
    BEQ.S   .after_flag3

    PEA     LAB_1D43
    PEA     -120(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag3:
    MOVEA.L LAB_1D33,A0
    ADDA.W  LAB_21E6,A0
    BTST    #4,7(A0)
    BEQ.S   .after_flag4

    PEA     LAB_1D44
    PEA     -120(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag4:
    MOVEA.L LAB_1D33,A0
    ADDA.W  LAB_21E6,A0
    BTST    #5,7(A0)
    BEQ.S   .after_flag5

    PEA     LAB_1D45
    PEA     -120(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag5:
    MOVEA.L LAB_1D33,A0
    ADDA.W  LAB_21E6,A0
    BTST    #6,7(A0)
    BEQ.S   .after_flag6

    PEA     LAB_1D46
    PEA     -120(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag6:
    MOVEA.L LAB_1D33,A0
    ADDA.W  LAB_21E6,A0
    BTST    #7,7(A0)
    BEQ.S   .after_flag7

    PEA     LAB_1D47
    PEA     -120(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag7:
    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    PEA     210.W
    PEA     -120(A5)
    MOVE.L  A0,-(A7)
    JSR     LAB_09AD(PC)

    PEA     1000.W
    MOVE.L  -144(A5),-(A7)
    PEA     427.W
    PEA     GLOB_STR_ED2_C_2
    JSR     GROUPB_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     28(A7),A7

.return:
    MOVEM.L (A7)+,A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED2_DrawEntrySummaryPanel   (Draw entry summary panel??)
; ARGS:
;   (none)
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D2/A0-A3/A6 ??
; CALLS:
;   _LVOSetRast, GROUP_AM_JMPTBL_WDISP_SPrintf, LAB_09AD,
;   GROUP_AI_JMPTBL_STRING_AppendAtNull
; READS:
;   LAB_21E5, LAB_2231, LAB_2233, LAB_1D32, LAB_2216
; WRITES:
;   LAB_1D32, LAB_1D33, LAB_21E5, LAB_21E6
; DESC:
;   Draws summary text and flag strings for the currently selected entry.
; NOTES:
;   Uses flag fields at offsets 27 and 46 in the entry data.
;------------------------------------------------------------------------------
ED2_DrawEntrySummaryPanel:
    LINK.W  A5,#-120
    MOVEM.L D2/A2-A3,-(A7)

    MOVE.W  LAB_21E5,D0
    MOVE.W  LAB_2231,D1
    CMP.W   D1,D0
    BGE.S   .reset_index

    TST.W   D0
    BPL.S   .after_index_check

.reset_index:
    MOVEQ   #0,D2
    MOVE.W  D2,LAB_21E5

.after_index_check:
    TST.W   D1
    BNE.S   .select_entry_ptr

    SUBA.L  A0,A0
    MOVE.L  A0,LAB_1D32
    MOVE.L  A0,LAB_1D33
    BRA.S   .have_entry_ptr

.select_entry_ptr:
    MOVE.W  LAB_21E5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2233,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  A1,LAB_1D32
    CLR.W   LAB_21E6

.have_entry_ptr:
    TST.L   LAB_1D32
    BEQ.W   .return

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVEA.L A0,A1
    MOVEQ   #2,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    MOVE.W  LAB_21E5,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.W  LAB_2231,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     GLOB_STR_CLU_CLU_POS1
    PEA     -120(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    PEA     120.W
    PEA     -120(A5)
    MOVE.L  A0,-(A7)
    JSR     LAB_09AD(PC)

    MOVEA.L LAB_1D32,A0
    MOVEA.L A0,A1
    ADDQ.L  #1,A1
    LEA     12(A0),A2
    LEA     19(A0),A3
    MOVE.L  A3,(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  A1,-(A7)
    PEA     GLOB_STR_CHAN_SOURCE_CALLLTRS_2
    PEA     -120(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    PEA     150.W
    PEA     -120(A5)
    MOVE.L  A0,-(A7)
    JSR     LAB_09AD(PC)

    LEA     56(A7),A7
    CLR.B   -120(A5)
    MOVEA.L LAB_1D32,A0
    MOVE.B  27(A0),D0
    BTST    #0,D0
    BEQ.S   .after_flag0

    PEA     LAB_1D4B
    PEA     -120(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag0:
    MOVEA.L LAB_1D32,A0
    MOVE.B  27(A0),D0
    BTST    #1,D0
    BEQ.S   .after_flag1

    PEA     LAB_1D4C
    PEA     -120(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag1:
    MOVEA.L LAB_1D32,A0
    MOVE.B  27(A0),D0
    BTST    #2,D0
    BEQ.S   .after_flag2

    PEA     LAB_1D4D
    PEA     -120(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag2:
    MOVEA.L LAB_1D32,A0
    MOVE.B  27(A0),D0
    BTST    #3,D0
    BEQ.S   .after_flag3

    PEA     LAB_1D4E
    PEA     -120(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag3:
    MOVEA.L LAB_1D32,A0
    MOVE.B  27(A0),D0
    BTST    #4,D0
    BEQ.S   .after_flag4

    PEA     LAB_1D4F
    PEA     -120(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag4:
    MOVEA.L LAB_1D32,A0
    MOVE.B  27(A0),D0
    BTST    #5,D0
    BEQ.S   .after_flag5

    PEA     LAB_1D50
    PEA     -120(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag5:
    MOVEA.L LAB_1D32,A0
    MOVE.B  27(A0),D0
    BTST    #6,D0
    BEQ.S   .after_flag6

    PEA     LAB_1D51
    PEA     -120(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag6:
    MOVEA.L LAB_1D32,A0
    MOVE.B  27(A0),D0
    BTST    #7,D0
    BEQ.S   .after_flag7

    PEA     LAB_1D52
    PEA     -120(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag7:
    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    PEA     180.W
    PEA     -120(A5)
    MOVE.L  A0,-(A7)
    JSR     LAB_09AD(PC)

    LEA     12(A7),A7
    CLR.B   -120(A5)
    MOVEA.L LAB_1D32,A0
    MOVE.W  46(A0),D0
    BTST    #0,D0
    BEQ.S   .after_word_flag0

    PEA     LAB_1D53
    PEA     -120(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_word_flag0:
    MOVEA.L LAB_1D32,A0
    MOVE.W  46(A0),D0
    BTST    #1,D0
    BEQ.S   .after_word_flag1

    PEA     LAB_1D54
    PEA     -120(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_word_flag1:
    MOVEA.L LAB_1D32,A0
    MOVE.W  46(A0),D0
    BTST    #2,D0
    BEQ.S   .after_word_flag2

    PEA     LAB_1D55
    PEA     -120(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_word_flag2:
    MOVEA.L LAB_1D32,A0
    MOVE.W  46(A0),D0
    BTST    #3,D0
    BEQ.S   .after_word_flag3

    PEA     LAB_1D56
    PEA     -120(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_word_flag3:
    MOVEA.L LAB_1D32,A0
    MOVE.W  46(A0),D0
    BTST    #4,D0
    BEQ.S   .after_word_flag4

    PEA     LAB_1D57
    PEA     -120(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_word_flag4:
    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    PEA     210.W
    PEA     -120(A5)
    MOVE.L  A0,-(A7)
    JSR     LAB_09AD(PC)

    LEA     12(A7),A7

.return:
    MOVEM.L (A7)+,D2/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED2_HandleMenuActions   (Handle ESC menu actions??)
; ARGS:
;   (none)
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D7/A0-A3/A6 ??
; CALLS:
;   ED1_DrawStatusLine1, ED1_DrawStatusLine2, ED2_DrawEntrySummaryPanel,
;   ED2_DrawEntryDetailsPanel, DST_FormatBannerDateTime, DST_JMPTBL_FormatToBuffer,
;   GROUPB_JMPTBL_UNKNOWN2B_OpenFileWithAccessMode, _LVORead, _LVOClose,
;   GROUP_AK_JMPTBL_GCOMMAND_GetBannerChar, GROUPB_JMPTBL_SCRIPT_BeginBannerCharTransition,
;   GROUP_AK_JMPTBL_ESQ_SetCopperEffect_Custom, GROUPB_JMPTBL_LAB_0A97,
;   ESQ_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight, LAB_07C4, LAB_07C5,
;   LAB_07C9, LAB_07CA, LAB_07CB, LAB_07D2, LAB_09A7, LAB_0969, LAB_095F,
;   GROUP_AK_JMPTBL_PARSEINI_ParseConfigBuffer
; READS:
;   LAB_231C, LAB_231D, LAB_21E5, LAB_21E6, LAB_1D32, LAB_1D33, LAB_2231,
;   LAB_2233, LAB_2236, LAB_224A, LAB_227F, LAB_229B, LAB_229C, LAB_229D,
;   LAB_2380, LAB_1DEC, LAB_1DD9, LAB_2059
; WRITES:
;   LAB_21ED, LAB_21E5, LAB_21E6, LAB_1FA5, LAB_1D13, LAB_1DE4, LAB_1DEF,
;   LAB_1B05, LAB_1F45, LAB_1FE9, LAB_1DDE, LAB_1DDF, LAB_22AA, LAB_2346,
;   LAB_2266
; DESC:
;   Dispatches ESC menu selections to a large set of diagnostic and UI actions.
; NOTES:
;   Switch-like chain on LAB_231D-selected index; ends by restoring rastport state.
;------------------------------------------------------------------------------
ED2_HandleMenuActions:
    LINK.W  A5,#-120
    MOVEM.L D2-D7,-(A7)

    MOVE.L  LAB_231C,D0
    LSL.L   #2,D0           ; multiply by 4
    ADD.L   LAB_231C,D0
    LEA     LAB_231D,A0
    ADDA.L  D0,A0
    MOVE.B  (A0),D0
    MOVE.B  D0,LAB_21ED
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    SUBQ.W  #2,D1
    BEQ.W   .case_draw_status_line1

    SUBQ.W  #1,D1
    BEQ.W   .case_rebuild_display

    SUBQ.W  #1,D1
    BEQ.W   .case_decrement_status_index

    SUBQ.W  #1,D1
    BEQ.W   .case_increment_status_index

    SUBQ.W  #2,D1
    BEQ.W   .case_refresh_rastports

    SUBQ.W  #1,D1
    BEQ.W   .case_prev_summary_entry

    SUBQ.W  #2,D1
    BEQ.W   .case_prev_detail_row

    SUBQ.W  #5,D1
    BEQ.W   .case_reset_defaults

    SUBQ.W  #4,D1
    BEQ.W   .case_set_1f45_200

    SUBQ.W  #2,D1
    BEQ.W   .case_dump_runtime_vars

    SUBQ.W  #3,D1
    BEQ.W   .case_toggle_1ba2

    SUBQ.W  #3,D1
    BEQ.W   .case_enter_esc_menu

    SUBI.W  #16,D1
    BEQ.W   .case_banner_char_next

    SUBQ.W  #2,D1
    BEQ.W   .case_banner_char_prev

    SUBQ.W  #2,D1
    BEQ.W   .case_call_07c5

    SUBI.W  #14,D1
    BEQ.W   .case_banner_char_code8e

    SUBQ.W  #4,D1
    BEQ.W   .case_start_transition_2

    SUBQ.W  #3,D1
    BEQ.W   .case_call_0539

    SUBQ.W  #3,D1
    BEQ.W   .case_call_0a7c

    SUBQ.W  #2,D1
    BEQ.W   .case_clear_pending_flag

    SUBQ.W  #2,D1
    BEQ.W   .case_call_07cb

    SUBQ.W  #1,D1
    BEQ.W   .case_wait_clear_bit1

    SUBQ.W  #1,D1
    BEQ.W   .case_copy_gfx_to_work

    SUBQ.W  #1,D1
    BEQ.W   .case_show_status_message

    SUBQ.W  #3,D1
    BEQ.W   .restore_display_state

    SUBQ.W  #1,D1
    BEQ.W   .case_wait_clear_bit0

    SUBQ.W  #1,D1
    BEQ.W   .case_set_1f45_100

    SUBQ.W  #1,D1
    BEQ.W   .case_start_transition_3

    SUBQ.W  #8,D1
    BEQ.W   .case_set_mode_18

    SUBQ.W  #7,D1
    BEQ.W   .case_draw_color_bars

    SUBQ.W  #2,D1
    BEQ.W   .case_call_07ca

    SUBQ.W  #1,D1
    BEQ.W   .case_draw_status_line2

    SUBQ.W  #1,D1
    BEQ.W   .case_call_09b0

    SUBQ.W  #1,D1
    BEQ.W   .case_next_summary_entry

    SUBQ.W  #2,D1
    BEQ.W   .case_next_detail_row

    SUBQ.W  #1,D1
    BEQ.W   .case_read_clockcmd_file

    SUBQ.W  #1,D1
    BEQ.W   .case_render_aligned_status_short

    SUBQ.W  #2,D1
    BEQ.W   .case_enable_highlight

    SUBQ.W  #2,D1
    BEQ.W   .case_parse_gradient_ini

    SUBQ.W  #1,D1
    BEQ.W   .restore_display_state

    SUBQ.W  #1,D1
    BEQ.W   .case_render_aligned_status_full

    SUBQ.W  #1,D1
    BEQ.W   .case_clear_1f45

    SUBQ.W  #5,D1
    BEQ.W   .case_set_copper_custom

    SUBQ.W  #1,D1
    BEQ.W   .case_clear_22aa

    SUBQ.W  #1,D1
    BEQ.W   .case_adjust_2266

    SUBI.W  #$26,D1
    BEQ.W   .case_call_0484

    SUBQ.W  #1,D1
    BEQ.W   .case_toggle_1def

    SUBI.W  #$3e,D1
    BEQ.S   .case_toggle_1fa5

    SUBQ.W  #6,D1
    BEQ.W   .case_set_1de4

    SUBQ.W  #2,D1
    BEQ.W   .case_format_debug_strings

    SUBI.W  #$17,D1
    BEQ.S   .case_format_banner_datetime

    BRA.W   .restore_display_state

.case_toggle_1fa5:
    TST.W   LAB_1FA5
    SEQ     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVE.W  D0,LAB_1FA5
    BRA.W   .restore_display_state

.case_format_banner_datetime:
    PEA     LAB_223A
    PEA     LAB_1D58
    JSR     DST_FormatBannerDateTime(PC)

    PEA     LAB_2274
    PEA     LAB_1D59
    JSR     DST_FormatBannerDateTime(PC)

    LEA     16(A7),A7
    BRA.W   .restore_display_state

.case_draw_status_line2:
    BSR.W   ED1_DrawStatusLine2

    BRA.W   .restore_display_state

.case_next_summary_entry:
    MOVE.W  LAB_21E5,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_21E5
    BSR.W   ED2_DrawEntrySummaryPanel

    BRA.W   .restore_display_state

.case_prev_summary_entry:
    MOVE.W  LAB_21E5,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,LAB_21E5
    BSR.W   ED2_DrawEntrySummaryPanel

    BRA.W   .restore_display_state

.case_next_detail_row:
    MOVE.W  LAB_21E6,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_21E6
    BSR.W   ED2_DrawEntryDetailsPanel

    BRA.W   .restore_display_state

.case_prev_detail_row:
    MOVE.W  LAB_21E6,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,LAB_21E6
    BSR.W   ED2_DrawEntryDetailsPanel

    BRA.W   .restore_display_state

.case_read_clockcmd_file:
    MOVEQ   #0,D6
    CLR.L   -118(A5)
    PEA     (MODE_OLDFILE).W
    PEA     GLOB_STR_DF0_CLOCK_CMD
    JSR     GROUPB_JMPTBL_UNKNOWN2B_OpenFileWithAccessMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D6
    TST.L   D6
    BEQ.W   .restore_display_state

    MOVE.L  D6,D1
    LEA     -105(A5),A0
    MOVE.L  A0,D2
    MOVEQ   #50,D3
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVORead(A6)

    MOVE.L  D0,D4
    MOVEQ   #11,D0
    CMP.L   D0,D4
    BLT.S   .close_file

    MOVEQ   #0,D5

.scan_buffer_loop:
    CMP.L   D4,D5
    BGE.S   .close_file

    MOVE.L  -118(A5),D0
    TST.L   D0
    BEQ.S   .state_wait_u

    SUBQ.L  #1,D0
    BEQ.S   .state_wait_aa

    SUBQ.L  #1,D0
    BEQ.S   .state_wait_k

    SUBQ.L  #1,D0
    BEQ.S   .state_process_match

    BRA.S   .state_advance

.state_wait_u:
    MOVEQ   #85,D0
    CMP.B   -105(A5,D5.L),D0
    BNE.S   .state_advance

    ADDQ.L  #1,-118(A5)
    BRA.S   .state_advance

.state_wait_aa:
    CMPI.B  #$AA,-105(A5,D5.L)
    BNE.S   .state_reset1

    ADDQ.L  #1,-118(A5)
    BRA.S   .state_advance

.state_reset1:
    CLR.L   -118(A5)
    BRA.S   .state_advance

.state_wait_k:
    MOVEQ   #75,D0
    CMP.B   -105(A5,D5.L),D0
    BNE.S   .state_reset2

    ADDQ.L  #1,-118(A5)
    BRA.S   .state_advance

.state_reset2:
    CLR.L   -118(A5)
    BRA.S   .state_advance

.state_process_match:
    LEA     -105(A5),A0
    ADDA.L  D5,A0
    MOVE.L  A0,-(A7)
    JSR     LAB_07C9(PC)

    ADDQ.W  #4,A7
    MOVE.L  D4,D5

.state_advance:
    ADDQ.L  #1,D5
    BRA.S   .scan_buffer_loop

.close_file:
    MOVE.L  D6,D1
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOClose(A6)

    BRA.W   .restore_display_state

.case_call_07c5:
    JSR     LAB_07C5(PC)

    BRA.W   .restore_display_state

.case_set_mode_18:
    MOVE.B  #$18,LAB_1D13

    BRA.W   .restore_display_state

.case_draw_status_line1:
    BSR.W   ED1_DrawStatusLine1

    BRA.W   .restore_display_state

.case_decrement_status_index:
    TST.W   LAB_1F40
    BEQ.S   .after_status_index_dec

    MOVE.W  LAB_1F40,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,LAB_1F40

.after_status_index_dec:
    BSR.W   ED1_DrawStatusLine1

    BRA.W   .restore_display_state

.case_increment_status_index:
    MOVE.W  LAB_1F40,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_1F40
    BSR.W   ED1_DrawStatusLine1

    BRA.W   .restore_display_state

.case_refresh_rastports:
    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVE.L  A0,-(A7)
    JSR     LAB_07D2(PC)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  #GLOB_REF_696_400_BITMAP,4(A0)
    MOVE.L  GLOB_REF_RASTPORT_1,(A7)
    JSR     LAB_07D2(PC)

    ADDQ.W  #4,A7
    BRA.W   .restore_display_state

.case_call_0484:
    CLR.L   -(A7)
    JSR     LAB_0484(PC)

    ADDQ.W  #4,A7
    BRA.W   .restore_display_state

.case_set_1de4:
    MOVE.W  #1,LAB_1DE4
    BRA.W   .restore_display_state

.case_format_debug_strings:
    PEA     LAB_1D5B
    JSR     DST_JMPTBL_FormatToBuffer(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D0
    MOVE.W  LAB_2231,D0
    TST.B   LAB_224A
    BEQ.S   .select_bool_string

    LEA     GLOB_STR_TRUE_1,A0
    BRA.S   .bool_string_ready

.select_bool_string:
    LEA     GLOB_STR_FALSE_1,A0

.bool_string_ready:
    MOVEQ   #0,D1
    MOVE.B  LAB_2238,D1
    MOVEQ   #0,D2
    MOVE.B  LAB_2230,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_1D5C
    JSR     DST_JMPTBL_FormatToBuffer(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D7

.dump_entry_loop:
    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.W  LAB_2231,D1
    CMP.L   D1,D0
    BGE.S   .after_dump_entries

    CLR.W   LAB_2363
    MOVE.B  D7,D0
    EXT.W   D0
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     LAB_2233,A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-4(A5)
    MOVE.B  D7,D0
    EXT.W   D0
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     LAB_2236,A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-8(A5)
    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     LAB_0439(PC)

    JSR     LAB_097E(PC)

    ADDQ.W  #8,A7
    ADDQ.B  #1,D7
    BRA.S   .dump_entry_loop

.after_dump_entries:
    PEA     LAB_1D5F
    JSR     DST_JMPTBL_FormatToBuffer(PC)

    ADDQ.W  #4,A7
    BRA.W   .restore_display_state

.case_toggle_1def:
    MOVE.B  LAB_1DEF,D0
    NOT.B   D0
    MOVE.B  D0,LAB_1DEF
    BRA.W   .restore_display_state

.case_dump_runtime_vars:
    MOVEQ   #0,D0
    MOVE.B  LAB_229C,D0
    MOVE.L  D0,-(A7)
    PEA     LAB_1D60
    JSR     DST_JMPTBL_FormatToBuffer(PC)

    MOVEQ   #0,D0
    MOVE.B  LAB_227F,D0
    MOVE.L  D0,(A7)
    PEA     LAB_1D61
    JSR     DST_JMPTBL_FormatToBuffer(PC)

    MOVE.W  LAB_229D,D0
    EXT.L   D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVE.W  LAB_229D,D1
    EXT.L   D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_1D62
    JSR     DST_JMPTBL_FormatToBuffer(PC)

    MOVE.W  LAB_2380,D0
    EXT.L   D0
    MOVE.W  LAB_2380,D1
    EXT.L   D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_1D63
    JSR     DST_JMPTBL_FormatToBuffer(PC)

    MOVE.L  LAB_1DEC,(A7)
    PEA     LAB_1D64
    JSR     DST_JMPTBL_FormatToBuffer(PC)

    MOVE.L  LAB_1DD9,(A7)
    PEA     LAB_1D65
    JSR     DST_JMPTBL_FormatToBuffer(PC)

    PEA     LAB_2245
    PEA     LAB_1D66
    JSR     DST_JMPTBL_FormatToBuffer(PC)

    MOVEQ   #0,D0
    MOVE.B  LAB_229B,D0
    MOVE.L  D0,(A7)
    PEA     LAB_1D67
    JSR     DST_JMPTBL_FormatToBuffer(PC)

    MOVE.L  LAB_2059,(A7)
    PEA     LAB_1D68
    JSR     DST_JMPTBL_FormatToBuffer(PC)

    LEA     52(A7),A7
    BRA.W   .restore_display_state

.case_reset_defaults:
    MOVE.B  #$3c,LAB_227F
    MOVE.B  #$1,LAB_229B
    MOVE.B  #$2,LAB_229C
    MOVE.W  #$32,LAB_229D
    CLR.W   LAB_2380
    BRA.W   .restore_display_state

.case_toggle_1ba2:
    MOVE.B  LAB_1BA2,D0
    TST.B   D0
    BEQ.S   .toggle_1ba2_restore

    MOVE.B  D0,LAB_21E7
    CLR.B   LAB_1BA2
    BRA.S   .toggle_1ba2_done

.toggle_1ba2_restore:
    MOVE.B  LAB_21E7,D1
    MOVE.B  D1,LAB_1BA2

.toggle_1ba2_done:
    MOVE.B  LAB_1BA2,D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #60,D1
    JSR     GROUPB_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  D0,LAB_1BCA
    BRA.W   .restore_display_state

.case_enter_esc_menu:
    JSR     ED1_EnterEscMenu(PC)

    BRA.W   .restore_display_state

.case_banner_char_prev:
    JSR     GROUP_AK_JMPTBL_GCOMMAND_GetBannerChar(PC)

    SUBQ.W  #1,D0
    EXT.L   D0
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    JSR     GROUPB_JMPTBL_SCRIPT_BeginBannerCharTransition(PC)

    ADDQ.W  #8,A7
    BRA.W   .restore_display_state

.case_banner_char_next:
    JSR     GROUP_AK_JMPTBL_GCOMMAND_GetBannerChar(PC)

    ADDQ.W  #1,D0
    EXT.L   D0
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    JSR     GROUPB_JMPTBL_SCRIPT_BeginBannerCharTransition(PC)

    ADDQ.W  #8,A7
    BRA.W   .restore_display_state

.case_banner_char_code8e:
    MOVE.W  GLOB_REF_WORD_HEX_CODE_8E,D0
    EXT.L   D0
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    JSR     GROUPB_JMPTBL_SCRIPT_BeginBannerCharTransition(PC)

    ADDQ.W  #8,A7
    BRA.W   .restore_display_state

.case_set_copper_custom:
    MOVE.B  #$1f,LAB_1B05
    JSR     GROUP_AK_JMPTBL_ESQ_SetCopperEffect_Custom(PC)

    BRA.W   .restore_display_state

.case_rebuild_display:
    PEA     4.W
    CLR.L   -(A7)
    PEA     3.W
    JSR     GROUPB_JMPTBL_LAB_0A97(PC)

    MOVE.L  D0,LAB_2216
    JSR     ED_InitRastport2Pens(PC)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVEA.L LAB_2216,A0
    MOVE.W  2(A0),D0
    MOVEQ   #0,D1
    MOVE.W  4(A0),D1
    MOVE.L  D0,D2
    MOVE.L  D1,D3
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVEQ   #20,D1
    JSR     _LVORectFill(A6)

    JSR     ESQ_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(PC)

    LEA     12(A7),A7
    MOVE.W  #1,LAB_1DF3
    BRA.W   .restore_display_state

.case_start_transition_2:
    TST.L   LAB_1FE7
    BNE.W   .restore_display_state

    MOVEQ   #2,D0
    MOVE.L  D0,LAB_1FE9
    PEA     3.W
    JSR     LAB_07C4(PC)

    ADDQ.W  #4,A7
    MOVE.W  #3,LAB_1DDE
    MOVE.W  #1,LAB_1DDF
    BRA.W   .restore_display_state

.case_start_transition_3:
    TST.L   LAB_1FE7
    BNE.W   .restore_display_state

    MOVEQ   #3,D0
    MOVE.L  D0,LAB_1FE9
    MOVE.L  D0,-(A7)
    JSR     LAB_07C4(PC)

    ADDQ.W  #4,A7
    MOVE.W  #3,LAB_1DDE
    MOVE.W  #1,LAB_1DDF
    BRA.W   .restore_display_state

.case_wait_clear_bit0:
    JSR     ED1_WaitForFlagAndClearBit0(PC)

    BRA.W   .restore_display_state

.case_wait_clear_bit1:
    JSR     ED1_WaitForFlagAndClearBit1(PC)

    BRA.W   .restore_display_state

.case_copy_gfx_to_work:
    JSR     GROUP_AK_JMPTBL_GCOMMAND_CopyGfxToWorkIfAvailable(PC)

    BRA.W   .restore_display_state

.case_draw_color_bars:
    JSR     ED_InitRastport2Pens(PC)

    MOVEQ   #0,D7

.color_bar_loop:
    MOVEQ   #32,D0
    CMP.B   D0,D7
    BGE.W   .restore_display_state

    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D1
    LSL.L   #4,D1
    SUB.L   D0,D1
    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D2
    LSL.L   #4,D2
    SUB.L   D0,D2
    MOVEQ   #15,D0
    ADD.L   D0,D2
    MOVE.L  D1,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #120,D1
    MOVEQ   #100,D3
    ADD.L   D3,D3
    JSR     _LVORectFill(A6)

    ADDQ.B  #1,D7
    BRA.S   .color_bar_loop

.case_clear_22aa:
    PEA     31.W
    CLR.L   -(A7)
    JSR     LAB_0AA2(PC)

    ADDQ.W  #8,A7
    CLR.W   LAB_22AA
    BRA.W   .restore_display_state

.case_call_0539:
    JSR     LAB_0539(PC)

    BRA.W   .restore_display_state

.case_call_07ca:
    JSR     LAB_07CA(PC)

    BRA.W   .restore_display_state

.case_render_aligned_status_short:
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    PEA     1.W
    JSR     GROUP_AK_JMPTBL_CLEANUP_RenderAlignedStatusScreen(PC)

    LEA     12(A7),A7
    BRA.W   .restore_display_state

.case_clear_pending_flag:
    CLR.W   LAB_2346
    BRA.W   .restore_display_state

.case_render_aligned_status_full:
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    JSR     GROUP_AK_JMPTBL_CLEANUP_RenderAlignedStatusScreen(PC)

    LEA     12(A7),A7
    BRA.W   .restore_display_state

.case_call_0a7c:
    PEA     1.W
    JSR     LAB_0A7C(PC)

    ADDQ.W  #4,A7
    BRA.W   .restore_display_state

.case_call_09b0:
    JSR     LAB_09B0(PC)

    BRA.W   .restore_display_state

.case_clear_1f45:
    CLR.W   LAB_1F45
    BRA.W   .restore_display_state

.case_set_1f45_100:
    MOVE.W  #$100,LAB_1F45
    BRA.W   .restore_display_state

.case_set_1f45_200:
    MOVE.W  #$200,LAB_1F45
    BRA.W   .restore_display_state

.case_adjust_2266:
    JSR     LAB_0969(PC)

    MOVE.W  LAB_2266,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_095F(PC)

    ADDQ.W  #4,A7
    MOVE.W  D0,LAB_2266
    BRA.S   .restore_display_state

.case_show_status_message:
    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  #GLOB_REF_696_400_BITMAP,4(A0)
    MOVE.L  LAB_2267,-(A7)
    PEA     LAB_1D69
    PEA     -50(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -50(A5)
    PEA     232.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     28(A7),A7

    BRA.S   .restore_display_state

.case_enable_highlight:
    JSR     ESQ_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(PC)

    CLR.L   -(A7)
    JSR     LAB_09A7(PC)

    PEA     1.W
    JSR     LAB_07C4(PC)

    ADDQ.W  #8,A7
    BRA.S   .restore_display_state

.case_call_07cb:
    JSR     LAB_07CB(PC)

    BRA.S   .restore_display_state

.case_parse_gradient_ini:
    PEA     GLOB_STR_DF0_GRADIENT_INI_1
    JSR     GROUP_AK_JMPTBL_PARSEINI_ParseConfigBuffer(PC)

    ADDQ.W  #4,A7

.restore_display_state:
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  #GLOB_REF_696_400_BITMAP,4(A0)
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    JSR     _LVOSetBPen(A6)

    MOVEM.L (A7)+,D2-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED2_HandleDiagnosticsMenuActions   (Handle diagnostics menu actions??)
; ARGS:
;   (none)
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D1/A0-A1 ??
; CALLS:
;   LAB_07D2, LAB_06CA, ED_DrawDiagnosticModeText, GROUPB_JMPTBL_MATH_Mulu32,
;   DISPLIB_DisplayTextAtPosition, LAB_07C4, GROUP_AK_JMPTBL_ESQ_SetCopperEffect_AllOn,
;   GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight,
;   ESQ_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight,
;   GROUP_AK_JMPTBL_ESQ_SetCopperEffect_Default,
;   ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit5Mask,
;   GROUP_AK_JMPTBL_SCRIPT_AssertCtrlLineNow,
;   GROUP_AK_JMPTBL_SCRIPT_DeassertCtrlLineNow,
;   ED_DrawESCMenuBottomHelp
; READS:
;   LAB_231C, LAB_231D, LAB_1DF0, LAB_1BC4, LAB_1DD7, LAB_1DCD, LAB_1DD6,
;   LAB_226A ??
; WRITES:
;   LAB_21ED, LAB_1DF0, LAB_1DF1, GLOB_WORD_MAX_VALUE, LAB_2283, LAB_2287,
;   DATACErrs, LAB_2285, LAB_2349, LAB_2348, LAB_2347, LAB_1BC4, LAB_1DD7,
;   LAB_1DCD, LAB_21FB, LAB_21EB, LAB_1DD6, LAB_226A, LAB_2252 ??
; DESC:
;   Handles diagnostic/special menu selections, toggling flags, counters, and
;   invoking test patterns or copper effects.
; NOTES:
;   Uses a switch-like chain on LAB_231D selection.
;------------------------------------------------------------------------------
ED2_HandleDiagnosticsMenuActions:
    MOVE.L  LAB_231C,D0
    LSL.L   #2,D0
    ADD.L   LAB_231C,D0
    LEA     LAB_231D,A0
    ADDA.L  D0,A0
    MOVE.B  (A0),D0
    MOVE.B  D0,LAB_21ED
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    SUBQ.W  #1,D1
    BEQ.W   .case_toggle_1df0_low3

    SUBQ.W  #2,D1
    BEQ.W   .case_set_1df1_bit0

    SUBQ.W  #3,D1
    BEQ.W   .case_set_1df1_bit1

    SUBQ.W  #1,D1
    BEQ.W   .case_refresh_rastport_1

    SUBQ.W  #6,D1
    BEQ.W   .case_set_1df1_bit2

    SUBQ.W  #5,D1
    BEQ.W   .case_clear_error_counters

    SUBI.W  #15,D1
    BEQ.W   .case_adjust_1bc4

    SUBQ.W  #2,D1
    BEQ.W   .case_cycle_1dcd_digit

    SUBQ.W  #1,D1
    BEQ.W   .case_adjust_1dd6

    SUBQ.W  #4,D1
    BEQ.W   .case_assert_ctrl_line

    SUBQ.W  #1,D1
    BEQ.W   .case_deassert_ctrl_line

    SUBQ.W  #8,D1
    BEQ.W   .case_transition_0

    SUBQ.W  #1,D1
    BEQ.W   .case_transition_1

    SUBQ.W  #1,D1
    BEQ.W   .case_transition_2

    SUBQ.W  #1,D1
    BEQ.W   .case_transition_3

    SUBQ.W  #1,D1
    BEQ.W   .case_copper_all_on

    SUBQ.W  #1,D1
    BEQ.W   .case_copper_all_off

    SUBQ.W  #1,D1
    BEQ.W   .case_copper_on_highlight

    SUBQ.W  #1,D1
    BEQ.W   .case_copper_default

    SUBQ.W  #1,D1
    BEQ.W   .case_show_ciab_bit5

    SUBQ.W  #7,D1
    BEQ.W   .case_adjust_1dd7

    SUBQ.W  #3,D1
    BEQ.W   .case_increment_226a

    SUBI.W  #$20,D1
    BEQ.W   .case_toggle_226a

    BRA.W   .case_default_help

.case_toggle_1df0_low3:
    MOVEQ   #7,D0
    AND.L   LAB_1DF0,D0
    SUBQ.L  #7,D0
    BNE.S   .set_1df0_low3

    MOVEQ   #-8,D0
    AND.L   D0,LAB_1DF0
    BRA.W   .return

.set_1df0_low3:
    MOVEQ   #7,D0
    OR.L    D0,LAB_1DF0
    BRA.W   .return

.case_set_1df1_bit0:
    MOVEQ   #-8,D0
    AND.L   D0,LAB_1DF0
    BSET    #0,LAB_1DF1
    BRA.W   .return

.case_set_1df1_bit1:
    MOVEQ   #-8,D0
    AND.L   D0,LAB_1DF0
    BSET    #1,LAB_1DF1
    BRA.W   .return

.case_refresh_rastport_1:
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     LAB_07D2(PC)

    ADDQ.W  #4,A7
    BRA.W   .return

.case_set_1df1_bit2:
    MOVEQ   #-8,D0
    AND.L   D0,LAB_1DF0
    BSET    #2,LAB_1DF1
    BRA.W   .return

.case_clear_error_counters:
    MOVEQ   #0,D0
    MOVE.W  D0,GLOB_WORD_MAX_VALUE
    MOVE.W  D0,LAB_2283
    MOVE.W  D0,LAB_2287
    MOVE.W  D0,DATACErrs
    MOVE.W  D0,LAB_2285
    MOVE.W  D0,LAB_2349
    MOVE.W  D0,LAB_2348
    MOVE.W  D0,LAB_2347
    BRA.W   .return

.case_adjust_1bc4:
    MOVE.B  LAB_1BC4,D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    PEA     LAB_1D6B
    MOVE.L  D1,-(A7)
    JSR     LAB_06CA(PC)

    MOVE.B  D0,LAB_1BC4
    JSR     ED_DrawDiagnosticModeText(PC)

    ADDQ.W  #8,A7
    BRA.W   .return

.case_adjust_1dd7:
    MOVEQ   #0,D0
    MOVE.B  LAB_1DD7,D0
    PEA     LAB_1D6C
    MOVE.L  D0,-(A7)
    JSR     LAB_06CA(PC)

    MOVE.B  D0,LAB_1DD7
    JSR     ED_DrawDiagnosticModeText(PC)

    ADDQ.W  #8,A7
    BRA.W   .return

.case_cycle_1dcd_digit:
    MOVE.B  LAB_1DCD,D0
    MOVE.L  D0,D1
    SUBQ.B  #1,D1
    MOVE.B  D1,LAB_1DCD
    MOVEQ   #51,D0
    CMP.B   D0,D1
    BCC.S   .after_cycle_1dcd

    MOVEQ   #54,D0
    MOVE.B  D0,LAB_1DCD

.after_cycle_1dcd:
    MOVEQ   #0,D0
    MOVE.B  LAB_1DCD,D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVE.L  D0,LAB_21FB
    MOVEQ   #40,D1
    JSR     GROUPB_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  D0,LAB_21EB
    JSR     ED_DrawDiagnosticModeText(PC)

    BRA.W   .return

.case_adjust_1dd6:
    MOVEQ   #0,D0
    MOVE.B  LAB_1DD6,D0
    PEA     LAB_1D6D
    MOVE.L  D0,-(A7)
    JSR     LAB_06CA(PC)

    MOVE.B  D0,LAB_1DD6
    JSR     ED_DrawDiagnosticModeText(PC)

    ADDQ.W  #8,A7
    BRA.W   .return

.case_toggle_226a:
    MOVE.W  LAB_226A,D0
    SUBQ.W  #1,D0
    BNE.S   .case_set_226a_one

    CLR.W   LAB_226A
    BRA.W   .return

.case_set_226a_one:
    MOVE.W  #1,LAB_226A
    BRA.W   .return

.case_increment_226a:
    MOVE.W  LAB_226A,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_226A
    BRA.W   .return

.case_transition_0:
    PEA     LAB_1D6E
    PEA     360.W
    PEA     175.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    CLR.L   (A7)
    JSR     LAB_07C4(PC)

    LEA     16(A7),A7
    BRA.W   .return

.case_transition_1:
    PEA     LAB_1D6F
    PEA     360.W
    PEA     175.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     1.W
    JSR     LAB_07C4(PC)

    LEA     20(A7),A7
    BRA.W   .return

.case_transition_2:
    PEA     LAB_1D70
    PEA     360.W
    PEA     175.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     2.W
    JSR     LAB_07C4(PC)

    LEA     20(A7),A7
    BRA.W   .return

.case_transition_3:
    PEA     LAB_1D71
    PEA     360.W
    PEA     175.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     3.W
    JSR     LAB_07C4(PC)

    LEA     20(A7),A7
    BRA.W   .return

.case_copper_all_on:
    PEA     LAB_1D72
    PEA     390.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    JSR     GROUP_AK_JMPTBL_ESQ_SetCopperEffect_AllOn(PC)

    LEA     16(A7),A7
    BRA.W   .return

.case_copper_all_off:
    PEA     LAB_1D73
    PEA     390.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    JSR     GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight(PC)

    LEA     16(A7),A7
    BRA.W   .return

.case_copper_on_highlight:
    PEA     LAB_1D74
    PEA     390.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    JSR     ESQ_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(PC)

    LEA     16(A7),A7
    BRA.W   .return

.case_copper_default:
    PEA     LAB_1D75
    PEA     390.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    JSR     GROUP_AK_JMPTBL_ESQ_SetCopperEffect_Default(PC)

    LEA     16(A7),A7
    BRA.W   .return

.case_show_ciab_bit5:
    PEA     LAB_1D76
    PEA     270.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    JSR     ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit5Mask(PC)

    LEA     16(A7),A7
    TST.B   D0
    BNE.S   .show_ciab_bit5_set

    PEA     LAB_1D77
    PEA     270.W
    PEA     235.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    BRA.S   .return

.show_ciab_bit5_set:
    PEA     LAB_1D78
    PEA     270.W
    PEA     235.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    BRA.S   .return

.case_assert_ctrl_line:
    PEA     LAB_1D79
    PEA     270.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    JSR     GROUP_AK_JMPTBL_SCRIPT_AssertCtrlLineNow(PC)

    LEA     16(A7),A7
    BRA.S   .return

.case_deassert_ctrl_line:
    PEA     LAB_1D7A
    PEA     270.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    JSR     GROUP_AK_JMPTBL_SCRIPT_DeassertCtrlLineNow(PC)

    LEA     16(A7),A7
    BRA.S   .return

.case_default_help:
    JSR     ED_DrawESCMenuBottomHelp(PC)

    CLR.W   LAB_2252

.return:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED2_HandleScrollSpeedSelection   (Handle scroll speed selection??)
; ARGS:
;   (none)
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D1/A0-A1 ??
; CALLS:
;   ED_DrawESCMenuBottomHelp, ED_DrawMenuSelectionHighlight, ED_DrawScrollSpeedMenuText
; READS:
;   LAB_231C, LAB_231D, LAB_21E8, GLOB_STR_SATELLITE_DELIVERED_SCROLL_SPEED ??
; WRITES:
;   LAB_21ED, LAB_21FA, LAB_21E2, LAB_1F40, LAB_21E8
; DESC:
;   Updates scroll speed/selection state based on menu codes and redraws help.
; NOTES:
;   Special-cases selection codes 13/27 and $9B?? to adjust LAB_21E8/LAB_1F40.
;------------------------------------------------------------------------------
ED2_HandleScrollSpeedSelection:
    MOVE.L  LAB_231C,D0
    LSL.L   #2,D0
    ADD.L   LAB_231C,D0
    LEA     LAB_231D,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.B  (A1),D1
    MOVE.B  D1,LAB_21ED
    ADDA.L  D0,A0
    MOVE.B  1(A0),LAB_21FA
    MOVEQ   #0,D0
    MOVE.B  LAB_21ED,D0
    SUBI.W  #13,D0
    BEQ.S   .case_sync_scroll_speed

    SUBI.W  #14,D0
    BEQ.S   .case_sync_scroll_speed

    SUBI.W  #$80,D0
    BEQ.S   .case_adjust_selection_key

    BRA.W   .case_adjust_selection_default

.case_sync_scroll_speed:
    MOVE.L  LAB_21E8,D0
    MOVE.L  D0,LAB_21E2
    TST.L   LAB_21E8
    BNE.S   .use_21e8_minus1

    MOVEQ   #0,D0
    MOVE.B  GLOB_STR_SATELLITE_DELIVERED_SCROLL_SPEED,D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVE.W  D0,LAB_1F40
    BRA.S   .after_sync_scroll_speed

.use_21e8_minus1:
    MOVE.L  LAB_21E8,D0
    SUBQ.L  #1,D0
    MOVE.W  D0,LAB_1F40

.after_sync_scroll_speed:
    JSR     ED_DrawESCMenuBottomHelp(PC)

    BRA.W   .return

.case_adjust_selection_key:
    MOVE.B  LAB_21FA,D0
    MOVEQ   #65,D1
    CMP.B   D1,D0
    BNE.S   .case_increment_selection_key

    SUBQ.L  #1,LAB_21E8
    BGE.S   .after_selection_update

    MOVEQ   #8,D0
    MOVE.L  D0,LAB_21E8
    BRA.S   .after_selection_update

.case_increment_selection_key:
    ADDQ.L  #1,LAB_21E8
    MOVEQ   #1,D0
    CMP.L   LAB_21E8,D0
    BNE.S   .case_wrap_selection_key

    MOVEQ   #3,D0
    MOVE.L  D0,LAB_21E8
    BRA.S   .after_selection_update

.case_wrap_selection_key:
    MOVEQ   #9,D0
    CMP.L   LAB_21E8,D0
    BNE.S   .after_selection_update

    CLR.L   LAB_21E8

.after_selection_update:
    PEA     9.W
    JSR     ED_DrawMenuSelectionHighlight(PC)

    JSR     ED_DrawScrollSpeedMenuText(PC)

    ADDQ.W  #4,A7
    BRA.S   .return

.case_adjust_selection_default:
    ADDQ.L  #1,LAB_21E8
    MOVEQ   #1,D0
    CMP.L   LAB_21E8,D0
    BNE.S   .case_wrap_selection_default

    MOVEQ   #3,D0
    MOVE.L  D0,LAB_21E8
    BRA.S   .after_default_update

.case_wrap_selection_default:
    MOVEQ   #9,D0
    CMP.L   LAB_21E8,D0
    BNE.S   .after_default_update

    CLR.L   LAB_21E8

.after_default_update:
    PEA     9.W
    JSR     ED_DrawMenuSelectionHighlight(PC)

    JSR     ED_DrawScrollSpeedMenuText(PC)

    ADDQ.W  #4,A7

.return:
    RTS
