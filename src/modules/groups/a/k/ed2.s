;------------------------------------------------------------------------------
; FUNC: ED2_DrawEntryDetailsPanel   (Draw entry details paneluncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0/D1
; CALLS:
;   ESQIFF_JMPTBL_MEMORY_AllocateMemory, _LVOSetRast, GROUP_AM_JMPTBL_WDISP_SPrintf,
;   ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines, DISKIO2_CopyAndSanitizeSlotString, GROUP_AK_JMPTBL_TEXTDISP_FormatEntryTimeForIndex, GROUP_AI_JMPTBL_STRING_AppendAtNull,
;   ESQIFF_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   ED2_SelectedEntryIndex, TEXTDISP_PrimaryGroupEntryCount, TEXTDISP_PrimaryTitlePtrTable, ED2_SelectedEntryDataPtr, ED2_SelectedEntryTitlePtr, WDISP_DisplayContextBase
; WRITES:
;   ED2_SelectedEntryTitlePtr, ED2_SelectedEntryIndex
; DESC:
;   Formats and draws details for the selected entry, including flags and titles.
; NOTES:
;   Builds a temporary 1000-byte text buffer and frees it before returning.
;------------------------------------------------------------------------------
ED2_DrawEntryDetailsPanel:
    LINK.W  A5,#-148
    MOVEM.L A2-A3,-(A7)
    MOVE.W  ED2_SelectedEntryIndex,D0
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D1
    CMP.W   D1,D0
    BGE.S   .reset_index

    TST.W   D0
    BPL.S   .select_entry_ptr

.reset_index:
    SUBA.L  A0,A0
    MOVE.L  A0,ED2_SelectedEntryTitlePtr
    MOVEQ   #0,D1
    MOVE.W  D1,ED2_SelectedEntryIndex
    BRA.S   .have_entry_ptr

.select_entry_ptr:
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     TEXTDISP_PrimaryTitlePtrTable,A0
    ADDA.L  D1,A0
    MOVEA.L (A0),A1
    MOVE.L  A1,ED2_SelectedEntryTitlePtr

.have_entry_ptr:
    TST.L   ED2_SelectedEntryTitlePtr
    BEQ.W   .return

    TST.L   ED2_SelectedEntryDataPtr
    BEQ.W   .return

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     1000.W
    PEA     374.W
    PEA     Global_STR_ED2_C_1
    JSR     ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    MOVE.L  D0,-144(A5)
    MOVEA.L A0,A1
    MOVEQ   #2,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    MOVE.W  ED2_SelectedFlagByteOffset,D0
    MOVEQ   #48,D1
    CMP.W   D1,D0
    BGT.S   .clamp_row_index

    MOVEQ   #1,D1
    CMP.W   D1,D0
    BGE.S   .row_index_ready

.clamp_row_index:
    MOVE.W  #1,ED2_SelectedFlagByteOffset

.row_index_ready:
    MOVE.W  ED2_SelectedEntryIndex,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     TEXTDISP_PrimaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),ED2_SelectedEntryTitlePtr
    MOVE.W  ED2_SelectedEntryIndex,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     Global_STR_PI_CLU_POS1
    PEA     -120(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    PEA     90.W
    PEA     -120(A5)
    MOVE.L  A0,-(A7)
    JSR     ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    LEA     28(A7),A7
    MOVEA.L ED2_SelectedEntryDataPtr,A0
    MOVEA.L A0,A1
    ADDQ.L  #1,A1
    MOVE.L  A1,D0
    BEQ.S   .use_default_name

    LEA     1(A0),A1
    BRA.S   .name_ptr_ready

.use_default_name:
    LEA     DATA_ED2_TAG_NULL_1D3B,A1

.name_ptr_ready:
    TST.L   ED2_SelectedEntryTitlePtr
    BEQ.S   .use_default_source

    MOVEA.L ED2_SelectedEntryTitlePtr,A2
    BRA.S   .source_ptr_ready

.use_default_source:
    LEA     DATA_ED2_TAG_NULL_1D3C,A2

.source_ptr_ready:
    LEA     19(A0),A3
    MOVE.L  A3,D0
    BEQ.S   .use_default_call_letters

    LEA     19(A0),A3
    BRA.S   .call_letters_ready

.use_default_call_letters:
    LEA     DATA_ED2_TAG_NULL_1D3D,A3

.call_letters_ready:
    MOVE.L  A3,-(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  A1,-(A7)
    PEA     Global_STR_CHAN_SOURCE_CALLLTRS_1
    PEA     -120(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    PEA     120.W
    PEA     -120(A5)
    MOVE.L  A0,-(A7)
    JSR     ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    MOVE.W  ED2_SelectedFlagByteOffset,D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  ED2_SelectedEntryTitlePtr,-(A7)
    MOVE.L  ED2_SelectedEntryDataPtr,-(A7)
    MOVE.L  -144(A5),-(A7)
    JSR     DISKIO2_CopyAndSanitizeSlotString

    LEA     44(A7),A7
    MOVE.L  D0,-148(A5)
    BEQ.S   .no_title_buffer

    MOVE.W  ED2_SelectedFlagByteOffset,D0
    EXT.L   D0
    MOVE.L  ED2_SelectedEntryTitlePtr,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -140(A5)
    JSR     GROUP_AK_JMPTBL_TEXTDISP_FormatEntryTimeForIndex(PC)

    LEA     12(A7),A7
    BRA.S   .title_buffer_ready

.no_title_buffer:
    CLR.B   -140(A5)

.title_buffer_ready:
    MOVE.W  ED2_SelectedFlagByteOffset,D0
    EXT.L   D0
    TST.L   -148(A5)
    BEQ.S   .use_default_title

    MOVEA.L -148(A5),A0
    BRA.S   .title_ptr_ready

.use_default_title:
    LEA     DATA_ED2_TAG_NULL_1D3F,A0

.title_ptr_ready:
    PEA     -140(A5)
    MOVE.L  A0,-(A7)
    MOVE.L  D0,-(A7)
    PEA     Global_STR_TS_TITLE_TIME
    PEA     -120(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    PEA     150.W
    PEA     -120(A5)
    MOVE.L  A0,-(A7)
    JSR     ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    LEA     32(A7),A7
    CLR.B   -120(A5)
    MOVEA.L ED2_SelectedEntryTitlePtr,A0
    ADDA.W  ED2_SelectedFlagByteOffset,A0
    BTST    #0,7(A0)
    BEQ.S   .after_flag0

    PEA     DATA_ED2_STR_NONE_1D40
    PEA     -120(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag0:
    MOVEA.L ED2_SelectedEntryTitlePtr,A0
    ADDA.W  ED2_SelectedFlagByteOffset,A0
    BTST    #1,7(A0)
    BEQ.S   .after_flag1

    PEA     DATA_ED2_STR_MOVIE_1D41
    PEA     -120(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag1:
    MOVEA.L ED2_SelectedEntryTitlePtr,A0
    ADDA.W  ED2_SelectedFlagByteOffset,A0
    BTST    #2,7(A0)
    BEQ.S   .after_flag2

    PEA     DATA_ED2_STR_ALTHILITEPROG_1D42
    PEA     -120(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag2:
    MOVEA.L ED2_SelectedEntryTitlePtr,A0
    ADDA.W  ED2_SelectedFlagByteOffset,A0
    BTST    #3,7(A0)
    BEQ.S   .after_flag3

    PEA     DATA_ED2_STR_TAGPROG_1D43
    PEA     -120(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag3:
    MOVEA.L ED2_SelectedEntryTitlePtr,A0
    ADDA.W  ED2_SelectedFlagByteOffset,A0
    BTST    #4,7(A0)
    BEQ.S   .after_flag4

    PEA     DATA_ED2_STR_SPORTSPROG_1D44
    PEA     -120(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag4:
    MOVEA.L ED2_SelectedEntryTitlePtr,A0
    ADDA.W  ED2_SelectedFlagByteOffset,A0
    BTST    #5,7(A0)
    BEQ.S   .after_flag5

    PEA     DATA_ED2_STR_DVIEW_USED_1D45
    PEA     -120(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag5:
    MOVEA.L ED2_SelectedEntryTitlePtr,A0
    ADDA.W  ED2_SelectedFlagByteOffset,A0
    BTST    #6,7(A0)
    BEQ.S   .after_flag6

    PEA     DATA_ED2_STR_REPEATPROG_1D46
    PEA     -120(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag6:
    MOVEA.L ED2_SelectedEntryTitlePtr,A0
    ADDA.W  ED2_SelectedFlagByteOffset,A0
    BTST    #7,7(A0)
    BEQ.S   .after_flag7

    PEA     DATA_ED2_STR_PREVDAYSDATA_1D47
    PEA     -120(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag7:
    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    PEA     210.W
    PEA     -120(A5)
    MOVE.L  A0,-(A7)
    JSR     ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    PEA     1000.W
    MOVE.L  -144(A5),-(A7)
    PEA     427.W
    PEA     Global_STR_ED2_C_2
    JSR     ESQIFF_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     28(A7),A7

.return:
    MOVEM.L (A7)+,A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED2_DrawEntrySummaryPanel   (Draw entry summary paneluncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0/D1/D2
; CALLS:
;   _LVOSetRast, GROUP_AM_JMPTBL_WDISP_SPrintf, ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines,
;   GROUP_AI_JMPTBL_STRING_AppendAtNull
; READS:
;   ED2_SelectedEntryIndex, TEXTDISP_PrimaryGroupEntryCount, TEXTDISP_PrimaryEntryPtrTable, ED2_SelectedEntryDataPtr, WDISP_DisplayContextBase
; WRITES:
;   ED2_SelectedEntryDataPtr, ED2_SelectedEntryTitlePtr, ED2_SelectedEntryIndex, ED2_SelectedFlagByteOffset
; DESC:
;   Draws summary text and flag strings for the currently selected entry.
; NOTES:
;   Uses flag fields at offsets 27 and 46 in the entry data.
;------------------------------------------------------------------------------
ED2_DrawEntrySummaryPanel:
    LINK.W  A5,#-120
    MOVEM.L D2/A2-A3,-(A7)

    MOVE.W  ED2_SelectedEntryIndex,D0
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D1
    CMP.W   D1,D0
    BGE.S   .reset_index

    TST.W   D0
    BPL.S   .after_index_check

.reset_index:
    MOVEQ   #0,D2
    MOVE.W  D2,ED2_SelectedEntryIndex

.after_index_check:
    TST.W   D1
    BNE.S   .select_entry_ptr

    SUBA.L  A0,A0
    MOVE.L  A0,ED2_SelectedEntryDataPtr
    MOVE.L  A0,ED2_SelectedEntryTitlePtr
    BRA.S   .have_entry_ptr

.select_entry_ptr:
    MOVE.W  ED2_SelectedEntryIndex,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  A1,ED2_SelectedEntryDataPtr
    CLR.W   ED2_SelectedFlagByteOffset

.have_entry_ptr:
    TST.L   ED2_SelectedEntryDataPtr
    BEQ.W   .return

    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    MOVEA.L A0,A1
    MOVEQ   #2,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    MOVE.W  ED2_SelectedEntryIndex,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     Global_STR_CLU_CLU_POS1
    PEA     -120(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    PEA     120.W
    PEA     -120(A5)
    MOVE.L  A0,-(A7)
    JSR     ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    MOVEA.L ED2_SelectedEntryDataPtr,A0
    MOVEA.L A0,A1
    ADDQ.L  #1,A1
    LEA     12(A0),A2
    LEA     19(A0),A3
    MOVE.L  A3,(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  A1,-(A7)
    PEA     Global_STR_CHAN_SOURCE_CALLLTRS_2
    PEA     -120(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    PEA     150.W
    PEA     -120(A5)
    MOVE.L  A0,-(A7)
    JSR     ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    LEA     56(A7),A7
    CLR.B   -120(A5)
    MOVEA.L ED2_SelectedEntryDataPtr,A0
    MOVE.B  27(A0),D0
    BTST    #0,D0
    BEQ.S   .after_flag0

    PEA     DATA_ED2_STR_NONE_1D4B
    PEA     -120(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag0:
    MOVEA.L ED2_SelectedEntryDataPtr,A0
    MOVE.B  27(A0),D0
    BTST    #1,D0
    BEQ.S   .after_flag1

    PEA     DATA_ED2_STR_HILITESRC_1D4C
    PEA     -120(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag1:
    MOVEA.L ED2_SelectedEntryDataPtr,A0
    MOVE.B  27(A0),D0
    BTST    #2,D0
    BEQ.S   .after_flag2

    PEA     DATA_ED2_STR_SUMBYSRC_1D4D
    PEA     -120(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag2:
    MOVEA.L ED2_SelectedEntryDataPtr,A0
    MOVE.B  27(A0),D0
    BTST    #3,D0
    BEQ.S   .after_flag3

    PEA     DATA_ED2_STR_VIDEO_TAG_DISABLE_1D4E
    PEA     -120(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag3:
    MOVEA.L ED2_SelectedEntryDataPtr,A0
    MOVE.B  27(A0),D0
    BTST    #4,D0
    BEQ.S   .after_flag4

    PEA     DATA_ED2_STR_CAF_PPVSRC_1D4F
    PEA     -120(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag4:
    MOVEA.L ED2_SelectedEntryDataPtr,A0
    MOVE.B  27(A0),D0
    BTST    #5,D0
    BEQ.S   .after_flag5

    PEA     DATA_ED2_STR_DITTO_1D50
    PEA     -120(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag5:
    MOVEA.L ED2_SelectedEntryDataPtr,A0
    MOVE.B  27(A0),D0
    BTST    #6,D0
    BEQ.S   .after_flag6

    PEA     DATA_ED2_STR_ALTHILITESRC_1D51
    PEA     -120(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag6:
    MOVEA.L ED2_SelectedEntryDataPtr,A0
    MOVE.B  27(A0),D0
    BTST    #7,D0
    BEQ.S   .after_flag7

    PEA     DATA_ED2_STR_STEREO_1D52
    PEA     -120(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag7:
    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    PEA     180.W
    PEA     -120(A5)
    MOVE.L  A0,-(A7)
    JSR     ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    LEA     12(A7),A7
    CLR.B   -120(A5)
    MOVEA.L ED2_SelectedEntryDataPtr,A0
    MOVE.W  46(A0),D0
    BTST    #0,D0
    BEQ.S   .after_word_flag0

    PEA     DATA_ED2_STR_GRID_1D53
    PEA     -120(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_word_flag0:
    MOVEA.L ED2_SelectedEntryDataPtr,A0
    MOVE.W  46(A0),D0
    BTST    #1,D0
    BEQ.S   .after_word_flag1

    PEA     DATA_ED2_STR_MR_1D54
    PEA     -120(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_word_flag1:
    MOVEA.L ED2_SelectedEntryDataPtr,A0
    MOVE.W  46(A0),D0
    BTST    #2,D0
    BEQ.S   .after_word_flag2

    PEA     DATA_ED2_STR_DNICHE_1D55
    PEA     -120(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_word_flag2:
    MOVEA.L ED2_SelectedEntryDataPtr,A0
    MOVE.W  46(A0),D0
    BTST    #3,D0
    BEQ.S   .after_word_flag3

    PEA     DATA_ED2_STR_DMPLEX_1D56
    PEA     -120(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_word_flag3:
    MOVEA.L ED2_SelectedEntryDataPtr,A0
    MOVE.W  46(A0),D0
    BTST    #4,D0
    BEQ.S   .after_word_flag4

    PEA     DATA_ED2_STR_CF2_DPPV_1D57
    PEA     -120(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_word_flag4:
    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    PEA     210.W
    PEA     -120(A5)
    MOVE.L  A0,-(A7)
    JSR     ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    LEA     12(A7),A7

.return:
    MOVEM.L (A7)+,D2/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED2_HandleMenuActions   (Handle ESC menu actionsuncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A6/A7/D0/D1/D2/D3/D4/D5/D6/D7
; CALLS:
;   ED1_DrawStatusLine1, ED1_DrawStatusLine2, ED2_DrawEntrySummaryPanel,
;   ED2_DrawEntryDetailsPanel, DST_FormatBannerDateTime, GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer,
;   ESQIFF_JMPTBL_UNKNOWN2B_OpenFileWithAccessMode, _LVORead, _LVOClose,
;   GROUP_AK_JMPTBL_GCOMMAND_GetBannerChar, ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition,
;   GROUP_AK_JMPTBL_ESQ_SetCopperEffect_Custom, ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode,
;   GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight, GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte, GROUP_AK_JMPTBL_TLIBA3_SelectNextViewMode,
;   GROUP_AK_JMPTBL_ESQPARS_ApplyRtcBytesAndPersist, GROUP_AK_JMPTBL_PARSEINI_WriteErrorLogEntry, GROUP_AK_JMPTBL_PARSEINI_ScanLogoDirectory, GROUP_AK_JMPTBL_TLIBA3_DrawViewModeGuides, ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode, ESQFUNC_UpdateDiskWarningAndRefreshTick, ESQDISP_TestWordIsZeroBooleanize,
;   GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch
; READS:
;   ED_StateRingIndex, ED_StateRingTable, ED2_SelectedEntryIndex, ED2_SelectedFlagByteOffset, ED2_SelectedEntryDataPtr, ED2_SelectedEntryTitlePtr, TEXTDISP_PrimaryGroupEntryCount,
;   TEXTDISP_PrimaryEntryPtrTable, TEXTDISP_PrimaryTitlePtrTable, TEXTDISP_PrimaryGroupPresentFlag, WDISP_WeatherStatusCountdown, DATA_WDISP_BSS_BYTE_229B, WDISP_WeatherStatusBrushIndex, WDISP_WeatherStatusDigitChar,
;   DATA_WDISP_BSS_LONG_2380, WDISP_WeatherStatusOverlayTextPtr, WDISP_WeatherStatusTextPtr, DATA_P_TYPE_BSS_LONG_2059
; WRITES:
;   ED_LastKeyCode, ED2_SelectedEntryIndex, ED2_SelectedFlagByteOffset, DATA_GCOMMAND_BSS_WORD_1FA5, ED_MenuStateId, DATA_ESQ_BSS_WORD_1DE4, DATA_ESQ_BSS_BYTE_1DEF,
;   DATA_COMMON_STR_VALUE_1B05, ESQPARS2_ReadModeFlags, LOCAVAIL_FilterPrevClassId, TEXTDISP_DeferredActionCountdown, TEXTDISP_DeferredActionArmed, WDISP_AccumulatorCaptureActive, SCRIPT_RuntimeMode,
;   DATA_WDISP_BSS_WORD_2266
; DESC:
;   Dispatches ESC menu selections to a large set of diagnostic and UI actions.
; NOTES:
;   Switch-like chain on ED_StateRingTable-selected index; ends by restoring rastport state.
;------------------------------------------------------------------------------
ED2_HandleMenuActions:
    LINK.W  A5,#-120
    MOVEM.L D2-D7,-(A7)

    MOVE.L  ED_StateRingIndex,D0
    LSL.L   #2,D0           ; multiply by 4
    ADD.L   ED_StateRingIndex,D0
    LEA     ED_StateRingTable,A0
    ADDA.L  D0,A0
    MOVE.B  (A0),D0
    MOVE.B  D0,ED_LastKeyCode
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
    TST.W   DATA_GCOMMAND_BSS_WORD_1FA5
    SEQ     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVE.W  D0,DATA_GCOMMAND_BSS_WORD_1FA5
    BRA.W   .restore_display_state

.case_format_banner_datetime:
    PEA     CLOCK_DaySlotIndex
    PEA     DATA_ED2_STR_CTIME_1D58
    JSR     DST_FormatBannerDateTime(PC)

    PEA     CLOCK_CurrentDayOfWeekIndex
    PEA     DATA_ED2_STR_BTIME_1D59
    JSR     DST_FormatBannerDateTime(PC)

    LEA     16(A7),A7
    BRA.W   .restore_display_state

.case_draw_status_line2:
    BSR.W   ED1_DrawStatusLine2

    BRA.W   .restore_display_state

.case_next_summary_entry:
    MOVE.W  ED2_SelectedEntryIndex,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ED2_SelectedEntryIndex
    BSR.W   ED2_DrawEntrySummaryPanel

    BRA.W   .restore_display_state

.case_prev_summary_entry:
    MOVE.W  ED2_SelectedEntryIndex,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,ED2_SelectedEntryIndex
    BSR.W   ED2_DrawEntrySummaryPanel

    BRA.W   .restore_display_state

.case_next_detail_row:
    MOVE.W  ED2_SelectedFlagByteOffset,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ED2_SelectedFlagByteOffset
    BSR.W   ED2_DrawEntryDetailsPanel

    BRA.W   .restore_display_state

.case_prev_detail_row:
    MOVE.W  ED2_SelectedFlagByteOffset,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,ED2_SelectedFlagByteOffset
    BSR.W   ED2_DrawEntryDetailsPanel

    BRA.W   .restore_display_state

.case_read_clockcmd_file:
    MOVEQ   #0,D6
    CLR.L   -118(A5)
    PEA     (MODE_OLDFILE).W
    PEA     Global_STR_DF0_CLOCK_CMD
    JSR     ESQIFF_JMPTBL_UNKNOWN2B_OpenFileWithAccessMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D6
    TST.L   D6
    BEQ.W   .restore_display_state

    MOVE.L  D6,D1
    LEA     -105(A5),A0
    MOVE.L  A0,D2
    MOVEQ   #50,D3
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
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
    JSR     GROUP_AK_JMPTBL_ESQPARS_ApplyRtcBytesAndPersist(PC)

    ADDQ.W  #4,A7
    MOVE.L  D4,D5

.state_advance:
    ADDQ.L  #1,D5
    BRA.S   .scan_buffer_loop

.close_file:
    MOVE.L  D6,D1
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOClose(A6)

    BRA.W   .restore_display_state

.case_call_07c5:
    JSR     GROUP_AK_JMPTBL_TLIBA3_SelectNextViewMode(PC)

    BRA.W   .restore_display_state

.case_set_mode_18:
    MOVE.B  #$18,ED_MenuStateId

    BRA.W   .restore_display_state

.case_draw_status_line1:
    BSR.W   ED1_DrawStatusLine1

    BRA.W   .restore_display_state

.case_decrement_status_index:
    TST.W   ESQPARS2_StateIndex
    BEQ.S   .after_status_index_dec

    MOVE.W  ESQPARS2_StateIndex,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,ESQPARS2_StateIndex

.after_status_index_dec:
    BSR.W   ED1_DrawStatusLine1

    BRA.W   .restore_display_state

.case_increment_status_index:
    MOVE.W  ESQPARS2_StateIndex,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQPARS2_StateIndex
    BSR.W   ED1_DrawStatusLine1

    BRA.W   .restore_display_state

.case_refresh_rastports:
    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    MOVE.L  A0,-(A7)
    JSR     GROUP_AK_JMPTBL_TLIBA3_DrawViewModeGuides(PC)

    MOVEA.L Global_REF_RASTPORT_1,A0
    MOVE.L  #Global_REF_696_400_BITMAP,4(A0)
    MOVE.L  Global_REF_RASTPORT_1,(A7)
    JSR     GROUP_AK_JMPTBL_TLIBA3_DrawViewModeGuides(PC)

    ADDQ.W  #4,A7
    BRA.W   .restore_display_state

.case_call_0484:
    CLR.L   -(A7)
    JSR     DISKIO2_RunDiskSyncWorkflow(PC)

    ADDQ.W  #4,A7
    BRA.W   .restore_display_state

.case_set_1de4:
    MOVE.W  #1,DATA_ESQ_BSS_WORD_1DE4
    BRA.W   .restore_display_state

.case_format_debug_strings:
    PEA     DATA_ED2_STR_ED_DOT_C_COLON_SHORT_DUMP_OF_CLU_1D5B
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D0
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
    TST.B   TEXTDISP_PrimaryGroupPresentFlag
    BEQ.S   .select_bool_string

    LEA     Global_STR_TRUE_1,A0
    BRA.S   .bool_string_ready

.select_bool_string:
    LEA     Global_STR_FALSE_1,A0

.bool_string_ready:
    MOVEQ   #0,D1
    MOVE.B  TEXTDISP_PrimaryGroupHeaderCode,D1
    MOVEQ   #0,D2
    MOVE.B  TEXTDISP_PrimaryGroupCode,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D0,-(A7)
    PEA     DATA_ED2_FMT_CLU_POS1_PCT_LD_CURCLU_PCT_S_JDCLU1__1D5C
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D7

.dump_entry_loop:
    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D1
    CMP.L   D1,D0
    BGE.S   .after_dump_entries

    CLR.W   DATA_WDISP_BSS_LONG_2363
    MOVE.B  D7,D0
    EXT.W   D0
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-4(A5)
    MOVE.B  D7,D0
    EXT.W   D0
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     TEXTDISP_PrimaryTitlePtrTable,A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-8(A5)
    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     DISKIO1_DumpProgramSourceRecordVerbose(PC)

    JSR     ESQFUNC_ServiceUiTickIfRunning(PC)

    ADDQ.W  #8,A7
    ADDQ.B  #1,D7
    BRA.S   .dump_entry_loop

.after_dump_entries:
    PEA     DATA_ED2_STR_ED_DOT_C_COLON_END_OF_DUMP_OF_CLU_1D5F
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7
    BRA.W   .restore_display_state

.case_toggle_1def:
    MOVE.B  DATA_ESQ_BSS_BYTE_1DEF,D0
    NOT.B   D0
    MOVE.B  D0,DATA_ESQ_BSS_BYTE_1DEF
    BRA.W   .restore_display_state

.case_dump_runtime_vars:
    MOVEQ   #0,D0
    MOVE.B  WDISP_WeatherStatusBrushIndex,D0
    MOVE.L  D0,-(A7)
    PEA     DATA_ED2_FMT_WICON_PCT_LD_1D60
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.B  WDISP_WeatherStatusCountdown,D0
    MOVE.L  D0,(A7)
    PEA     DATA_ED2_FMT_W_MIN_PCT_LD_MINUTES_1D61
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVE.W  WDISP_WeatherStatusDigitChar,D0
    EXT.L   D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVE.W  WDISP_WeatherStatusDigitChar,D1
    EXT.L   D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    PEA     DATA_ED2_FMT_WDCNT_EVERY_PCT_LD_TIMES_PCT_LD_1D62
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVE.W  DATA_WDISP_BSS_LONG_2380,D0
    EXT.L   D0
    MOVE.W  DATA_WDISP_BSS_LONG_2380,D1
    EXT.L   D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    PEA     DATA_ED2_FMT_CWCNT_PCT_LD_TIMES_FROM_NOW_PCT_LD_1D63
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVE.L  WDISP_WeatherStatusOverlayTextPtr,(A7)
    PEA     DATA_ED2_FMT_WDATA_PCT_08LX_1D64
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVE.L  WDISP_WeatherStatusTextPtr,(A7)
    PEA     DATA_ED2_FMT_WCITY_PCT_S_1D65
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    PEA     DATA_WDISP_BSS_LONG_2245
    PEA     DATA_ED2_FMT_WEATHER_ID_PCT_S_1D66
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.B  DATA_WDISP_BSS_BYTE_229B,D0
    MOVE.L  D0,(A7)
    PEA     DATA_ED2_FMT_CWCOLOR_PCT_LD_1D67
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVE.L  DATA_P_TYPE_BSS_LONG_2059,(A7)
    PEA     DATA_ED2_FMT_BANNER_FOR_WEATHER_PCT_D_1D68
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     52(A7),A7
    BRA.W   .restore_display_state

.case_reset_defaults:
    MOVE.B  #$3c,WDISP_WeatherStatusCountdown
    MOVE.B  #$1,DATA_WDISP_BSS_BYTE_229B
    MOVE.B  #$2,WDISP_WeatherStatusBrushIndex
    MOVE.W  #$32,WDISP_WeatherStatusDigitChar
    CLR.W   DATA_WDISP_BSS_LONG_2380
    BRA.W   .restore_display_state

.case_toggle_1ba2:
    MOVE.B  DATA_CTASKS_CONST_BYTE_1BA2,D0
    TST.B   D0
    BEQ.S   .toggle_1ba2_restore

    MOVE.B  D0,DATA_WDISP_BSS_LONG_21E7
    CLR.B   DATA_CTASKS_CONST_BYTE_1BA2
    BRA.S   .toggle_1ba2_done

.toggle_1ba2_restore:
    MOVE.B  DATA_WDISP_BSS_LONG_21E7,D1
    MOVE.B  D1,DATA_CTASKS_CONST_BYTE_1BA2

.toggle_1ba2_done:
    MOVE.B  DATA_CTASKS_CONST_BYTE_1BA2,D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #60,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  D0,DATA_CTASKS_CONST_LONG_1BCA
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
    JSR     ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition(PC)

    ADDQ.W  #8,A7
    BRA.W   .restore_display_state

.case_banner_char_next:
    JSR     GROUP_AK_JMPTBL_GCOMMAND_GetBannerChar(PC)

    ADDQ.W  #1,D0
    EXT.L   D0
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition(PC)

    ADDQ.W  #8,A7
    BRA.W   .restore_display_state

.case_banner_char_code8e:
    MOVE.W  Global_REF_WORD_HEX_CODE_8E,D0
    EXT.L   D0
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition(PC)

    ADDQ.W  #8,A7
    BRA.W   .restore_display_state

.case_set_copper_custom:
    MOVE.B  #$1f,DATA_COMMON_STR_VALUE_1B05
    JSR     GROUP_AK_JMPTBL_ESQ_SetCopperEffect_Custom(PC)

    BRA.W   .restore_display_state

.case_rebuild_display:
    PEA     4.W
    CLR.L   -(A7)
    PEA     3.W
    JSR     ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(PC)

    MOVE.L  D0,WDISP_DisplayContextBase
    JSR     ED_InitRastport2Pens(PC)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVEA.L WDISP_DisplayContextBase,A0
    MOVE.W  2(A0),D0
    MOVEQ   #0,D1
    MOVE.W  4(A0),D1
    MOVE.L  D0,D2
    MOVE.L  D1,D3
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVEQ   #20,D1
    JSR     _LVORectFill(A6)

    JSR     GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(PC)

    LEA     12(A7),A7
    MOVE.W  #1,DATA_ESQ_BSS_WORD_1DF3
    BRA.W   .restore_display_state

.case_start_transition_2:
    TST.L   LOCAVAIL_FilterStep
    BNE.W   .restore_display_state

    MOVEQ   #2,D0
    MOVE.L  D0,LOCAVAIL_FilterPrevClassId
    PEA     3.W
    JSR     GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte(PC)

    ADDQ.W  #4,A7
    MOVE.W  #3,TEXTDISP_DeferredActionCountdown
    MOVE.W  #1,TEXTDISP_DeferredActionArmed
    BRA.W   .restore_display_state

.case_start_transition_3:
    TST.L   LOCAVAIL_FilterStep
    BNE.W   .restore_display_state

    MOVEQ   #3,D0
    MOVE.L  D0,LOCAVAIL_FilterPrevClassId
    MOVE.L  D0,-(A7)
    JSR     GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte(PC)

    ADDQ.W  #4,A7
    MOVE.W  #3,TEXTDISP_DeferredActionCountdown
    MOVE.W  #1,TEXTDISP_DeferredActionArmed
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
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
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
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #120,D1
    MOVEQ   #100,D3
    ADD.L   D3,D3
    JSR     _LVORectFill(A6)

    ADDQ.B  #1,D7
    BRA.S   .color_bar_loop

.case_clear_22aa:
    PEA     31.W
    CLR.L   -(A7)
    JSR     ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd(PC)

    ADDQ.W  #8,A7
    CLR.W   WDISP_AccumulatorCaptureActive
    BRA.W   .restore_display_state

.case_call_0539:
    JSR     DISKIO2_ReloadDataFilesAndRebuildIndex(PC)

    BRA.W   .restore_display_state

.case_call_07ca:
    JSR     GROUP_AK_JMPTBL_PARSEINI_WriteErrorLogEntry(PC)

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
    CLR.W   SCRIPT_RuntimeMode
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
    JSR     ESQIFF_PlayNextExternalAssetFrame(PC)

    ADDQ.W  #4,A7
    BRA.W   .restore_display_state

.case_call_09b0:
    JSR     ESQFUNC_JMPTBL_TEXTDISP_ResetSelectionAndRefresh(PC)

    BRA.W   .restore_display_state

.case_clear_1f45:
    CLR.W   ESQPARS2_ReadModeFlags
    BRA.W   .restore_display_state

.case_set_1f45_100:
    MOVE.W  #$100,ESQPARS2_ReadModeFlags
    BRA.W   .restore_display_state

.case_set_1f45_200:
    MOVE.W  #$200,ESQPARS2_ReadModeFlags
    BRA.W   .restore_display_state

.case_adjust_2266:
    JSR     ESQFUNC_UpdateDiskWarningAndRefreshTick(PC)

    MOVE.W  DATA_WDISP_BSS_WORD_2266,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     ESQDISP_TestWordIsZeroBooleanize(PC)

    ADDQ.W  #4,A7
    MOVE.W  D0,DATA_WDISP_BSS_WORD_2266
    BRA.S   .restore_display_state

.case_show_status_message:
    MOVEA.L Global_REF_RASTPORT_1,A0
    MOVE.L  #Global_REF_696_400_BITMAP,4(A0)
    MOVE.L  DATA_WDISP_BSS_LONG_2267,-(A7)
    PEA     DATA_ED2_FMT_BITPLANE1_PCT_8LX_1D69
    PEA     -50(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -50(A5)
    PEA     232.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     28(A7),A7

    BRA.S   .restore_display_state

.case_enable_highlight:
    JSR     GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(PC)

    CLR.L   -(A7)
    JSR     ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode(PC)

    PEA     1.W
    JSR     GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte(PC)

    ADDQ.W  #8,A7
    BRA.S   .restore_display_state

.case_call_07cb:
    JSR     GROUP_AK_JMPTBL_PARSEINI_ScanLogoDirectory(PC)

    BRA.S   .restore_display_state

.case_parse_gradient_ini:
    PEA     Global_STR_DF0_GRADIENT_INI_1
    JSR     GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch(PC)

    ADDQ.W  #4,A7

.restore_display_state:
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A0
    MOVE.L  #Global_REF_696_400_BITMAP,4(A0)
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    JSR     _LVOSetBPen(A6)

    MOVEM.L (A7)+,D2-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED2_HandleDiagnosticsMenuActions   (Handle diagnostics menu actionsuncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A7/D0/D1
; CALLS:
;   GROUP_AK_JMPTBL_TLIBA3_DrawViewModeGuides, ED_FindNextCharInTable, ED_DrawDiagnosticModeText, ESQIFF_JMPTBL_MATH_Mulu32,
;   DISPLIB_DisplayTextAtPosition, GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte, GROUP_AK_JMPTBL_ESQ_SetCopperEffect_AllOn,
;   GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight,
;   GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight,
;   GROUP_AK_JMPTBL_ESQ_SetCopperEffect_Default,
;   ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit5Mask,
;   GROUP_AK_JMPTBL_SCRIPT_AssertCtrlLineNow,
;   GROUP_AK_JMPTBL_SCRIPT_DeassertCtrlLineNow,
;   ED_DrawESCMenuBottomHelp
; READS:
;   Global_REF_RASTPORT_1, ED_DiagTextModeChar, DATA_ED2_TAG_NRLS_1D6B, DATA_ED2_STR_NYYLLZ_1D6C, DATA_ED2_TAG_NYLRS_1D6D, DATA_ED2_STR_SILENCE_1D6E, DATA_ED2_STR_LEFT_1D6F, DATA_ED2_STR_RIGHT_1D70, DATA_ED2_STR_BACKGROUND_1D71, DATA_ED2_STR_EXT_DOT_VIDEO_ONLY_1D72, DATA_ED2_STR_COMPUTER_ONLY_1D73, DATA_ED2_STR_OVERLAY_EXT_DOT_VIDEO_1D74, DATA_ED2_STR_NEGATIVE_VIDEO_1D75, DATA_ED2_STR_VIDEO_SWITCH_1D76, DATA_ED2_STR_OPEN_1D77, DATA_ED2_STR_CLOSED_1D78, DATA_ED2_STR_START_TAPE_VIDEO_1D79, DATA_ED2_STR_STOP_1D7A, ED_DiagScrollSpeedChar, ED_DiagGraphModeChar, ED_DiagVinModeChar, ED_DiagAvailMemMask, ED_DiagnosticsViewMode, ED_StateRingIndex, ED_StateRingTable, case_adjust_1bc4, case_adjust_1dd6, case_adjust_1dd7, case_assert_ctrl_line, case_clear_error_counters, case_copper_all_off, case_copper_all_on, case_copper_default, case_copper_on_highlight, case_cycle_1dcd_digit, case_deassert_ctrl_line, case_default_help, case_increment_226a, case_refresh_rastport_1, case_set_1df1_bit0, case_set_1df1_bit1, case_set_1df1_bit2, case_show_ciab_bit5, case_toggle_1df0_low3, case_toggle_226a, case_transition_0, case_transition_1, case_transition_2, case_transition_3, return
; WRITES:
;   DATACErrs, Global_WORD_MAX_VALUE, ED_DiagTextModeChar, ED_DiagScrollSpeedChar, ED_DiagGraphModeChar, ED_DiagVinModeChar, ED_DiagAvailMemMask, DATA_ESQ_BSS_BYTE_1DF1, ED_BlockOffset, ED_LastKeyCode, ED_TextLimit, ED_DiagnosticsScreenActive, ED_DiagnosticsViewMode, CTRL_HDeltaMax, ESQIFF_ParseAttemptCount, ESQIFF_LineErrorCount, DATA_WDISP_BSS_WORD_2347, DATA_WDISP_BSS_WORD_2348, DATA_WDISP_BSS_WORD_2349
; DESC:
;   Handles diagnostic/special menu selections, toggling flags, counters, and
;   invoking test patterns or copper effects.
; NOTES:
;   Uses a switch-like chain on ED_StateRingTable selection.
;------------------------------------------------------------------------------
ED2_HandleDiagnosticsMenuActions:
    MOVE.L  ED_StateRingIndex,D0
    LSL.L   #2,D0
    ADD.L   ED_StateRingIndex,D0
    LEA     ED_StateRingTable,A0
    ADDA.L  D0,A0
    MOVE.B  (A0),D0
    MOVE.B  D0,ED_LastKeyCode
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
    AND.L   ED_DiagAvailMemMask,D0
    SUBQ.L  #7,D0
    BNE.S   .set_1df0_low3

    MOVEQ   #-8,D0
    AND.L   D0,ED_DiagAvailMemMask
    BRA.W   .return

.set_1df0_low3:
    MOVEQ   #7,D0
    OR.L    D0,ED_DiagAvailMemMask
    BRA.W   .return

.case_set_1df1_bit0:
    MOVEQ   #-8,D0
    AND.L   D0,ED_DiagAvailMemMask
    BSET    #0,DATA_ESQ_BSS_BYTE_1DF1
    BRA.W   .return

.case_set_1df1_bit1:
    MOVEQ   #-8,D0
    AND.L   D0,ED_DiagAvailMemMask
    BSET    #1,DATA_ESQ_BSS_BYTE_1DF1
    BRA.W   .return

.case_refresh_rastport_1:
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     GROUP_AK_JMPTBL_TLIBA3_DrawViewModeGuides(PC)

    ADDQ.W  #4,A7
    BRA.W   .return

.case_set_1df1_bit2:
    MOVEQ   #-8,D0
    AND.L   D0,ED_DiagAvailMemMask
    BSET    #2,DATA_ESQ_BSS_BYTE_1DF1
    BRA.W   .return

.case_clear_error_counters:
    MOVEQ   #0,D0
    MOVE.W  D0,Global_WORD_MAX_VALUE
    MOVE.W  D0,CTRL_HDeltaMax
    MOVE.W  D0,ESQIFF_LineErrorCount
    MOVE.W  D0,DATACErrs
    MOVE.W  D0,ESQIFF_ParseAttemptCount
    MOVE.W  D0,DATA_WDISP_BSS_WORD_2349
    MOVE.W  D0,DATA_WDISP_BSS_WORD_2348
    MOVE.W  D0,DATA_WDISP_BSS_WORD_2347
    BRA.W   .return

.case_adjust_1bc4:
    MOVE.B  ED_DiagTextModeChar,D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    PEA     DATA_ED2_TAG_NRLS_1D6B
    MOVE.L  D1,-(A7)
    JSR     ED_FindNextCharInTable(PC)

    MOVE.B  D0,ED_DiagTextModeChar
    JSR     ED_DrawDiagnosticModeText(PC)

    ADDQ.W  #8,A7
    BRA.W   .return

.case_adjust_1dd7:
    MOVEQ   #0,D0
    MOVE.B  ED_DiagVinModeChar,D0
    PEA     DATA_ED2_STR_NYYLLZ_1D6C
    MOVE.L  D0,-(A7)
    JSR     ED_FindNextCharInTable(PC)

    MOVE.B  D0,ED_DiagVinModeChar
    JSR     ED_DrawDiagnosticModeText(PC)

    ADDQ.W  #8,A7
    BRA.W   .return

.case_cycle_1dcd_digit:
    MOVE.B  ED_DiagScrollSpeedChar,D0
    MOVE.L  D0,D1
    SUBQ.B  #1,D1
    MOVE.B  D1,ED_DiagScrollSpeedChar
    MOVEQ   #51,D0
    CMP.B   D0,D1
    BCC.S   .after_cycle_1dcd

    MOVEQ   #54,D0
    MOVE.B  D0,ED_DiagScrollSpeedChar

.after_cycle_1dcd:
    MOVEQ   #0,D0
    MOVE.B  ED_DiagScrollSpeedChar,D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVE.L  D0,ED_TextLimit
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  D0,ED_BlockOffset
    JSR     ED_DrawDiagnosticModeText(PC)

    BRA.W   .return

.case_adjust_1dd6:
    MOVEQ   #0,D0
    MOVE.B  ED_DiagGraphModeChar,D0
    PEA     DATA_ED2_TAG_NYLRS_1D6D
    MOVE.L  D0,-(A7)
    JSR     ED_FindNextCharInTable(PC)

    MOVE.B  D0,ED_DiagGraphModeChar
    JSR     ED_DrawDiagnosticModeText(PC)

    ADDQ.W  #8,A7
    BRA.W   .return

.case_toggle_226a:
    MOVE.W  ED_DiagnosticsViewMode,D0
    SUBQ.W  #1,D0
    BNE.S   .case_set_226a_one

    CLR.W   ED_DiagnosticsViewMode
    BRA.W   .return

.case_set_226a_one:
    MOVE.W  #1,ED_DiagnosticsViewMode
    BRA.W   .return

.case_increment_226a:
    MOVE.W  ED_DiagnosticsViewMode,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ED_DiagnosticsViewMode
    BRA.W   .return

.case_transition_0:
    PEA     DATA_ED2_STR_SILENCE_1D6E
    PEA     360.W
    PEA     175.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    CLR.L   (A7)
    JSR     GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte(PC)

    LEA     16(A7),A7
    BRA.W   .return

.case_transition_1:
    PEA     DATA_ED2_STR_LEFT_1D6F
    PEA     360.W
    PEA     175.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     1.W
    JSR     GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte(PC)

    LEA     20(A7),A7
    BRA.W   .return

.case_transition_2:
    PEA     DATA_ED2_STR_RIGHT_1D70
    PEA     360.W
    PEA     175.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     2.W
    JSR     GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte(PC)

    LEA     20(A7),A7
    BRA.W   .return

.case_transition_3:
    PEA     DATA_ED2_STR_BACKGROUND_1D71
    PEA     360.W
    PEA     175.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     3.W
    JSR     GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte(PC)

    LEA     20(A7),A7
    BRA.W   .return

.case_copper_all_on:
    PEA     DATA_ED2_STR_EXT_DOT_VIDEO_ONLY_1D72
    PEA     390.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    JSR     GROUP_AK_JMPTBL_ESQ_SetCopperEffect_AllOn(PC)

    LEA     16(A7),A7
    BRA.W   .return

.case_copper_all_off:
    PEA     DATA_ED2_STR_COMPUTER_ONLY_1D73
    PEA     390.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    JSR     GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight(PC)

    LEA     16(A7),A7
    BRA.W   .return

.case_copper_on_highlight:
    PEA     DATA_ED2_STR_OVERLAY_EXT_DOT_VIDEO_1D74
    PEA     390.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    JSR     GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(PC)

    LEA     16(A7),A7
    BRA.W   .return

.case_copper_default:
    PEA     DATA_ED2_STR_NEGATIVE_VIDEO_1D75
    PEA     390.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    JSR     GROUP_AK_JMPTBL_ESQ_SetCopperEffect_Default(PC)

    LEA     16(A7),A7
    BRA.W   .return

.case_show_ciab_bit5:
    PEA     DATA_ED2_STR_VIDEO_SWITCH_1D76
    PEA     270.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    JSR     ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit5Mask(PC)

    LEA     16(A7),A7
    TST.B   D0
    BNE.S   .show_ciab_bit5_set

    PEA     DATA_ED2_STR_OPEN_1D77
    PEA     270.W
    PEA     235.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    BRA.S   .return

.show_ciab_bit5_set:
    PEA     DATA_ED2_STR_CLOSED_1D78
    PEA     270.W
    PEA     235.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    BRA.S   .return

.case_assert_ctrl_line:
    PEA     DATA_ED2_STR_START_TAPE_VIDEO_1D79
    PEA     270.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    JSR     GROUP_AK_JMPTBL_SCRIPT_AssertCtrlLineNow(PC)

    LEA     16(A7),A7
    BRA.S   .return

.case_deassert_ctrl_line:
    PEA     DATA_ED2_STR_STOP_1D7A
    PEA     270.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    JSR     GROUP_AK_JMPTBL_SCRIPT_DeassertCtrlLineNow(PC)

    LEA     16(A7),A7
    BRA.S   .return

.case_default_help:
    JSR     ED_DrawESCMenuBottomHelp(PC)

    CLR.W   ED_DiagnosticsScreenActive

.return:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED2_HandleScrollSpeedSelection   (Handle scroll speed selectionuncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A7/D0/D1
; CALLS:
;   ED_DrawESCMenuBottomHelp, ED_DrawMenuSelectionHighlight, ED_DrawScrollSpeedMenuText
; READS:
;   Global_STR_SATELLITE_DELIVERED_SCROLL_SPEED, ED_EditCursorOffset, ED_LastKeyCode, ED_LastMenuInputChar, ED_StateRingIndex, ED_StateRingTable, case_adjust_selection_default, return
; WRITES:
;   ED_LastKeyCode, ED_LastMenuInputChar, ED_SavedScrollSpeedIndex, ESQPARS2_StateIndex, ED_EditCursorOffset
; DESC:
;   Updates scroll speed/selection state based on menu codes and redraws help.
; NOTES:
;   Special-cases selection codes 13/27 and $9Buncertain to adjust ED_EditCursorOffset/ESQPARS2_StateIndex.
;------------------------------------------------------------------------------
ED2_HandleScrollSpeedSelection:
    MOVE.L  ED_StateRingIndex,D0
    LSL.L   #2,D0
    ADD.L   ED_StateRingIndex,D0
    LEA     ED_StateRingTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.B  (A1),D1
    MOVE.B  D1,ED_LastKeyCode
    ADDA.L  D0,A0
    MOVE.B  1(A0),ED_LastMenuInputChar
    MOVEQ   #0,D0
    MOVE.B  ED_LastKeyCode,D0
    SUBI.W  #13,D0
    BEQ.S   .case_sync_scroll_speed

    SUBI.W  #14,D0
    BEQ.S   .case_sync_scroll_speed

    SUBI.W  #$80,D0
    BEQ.S   .case_adjust_selection_key

    BRA.W   .case_adjust_selection_default

.case_sync_scroll_speed:
    MOVE.L  ED_EditCursorOffset,D0
    MOVE.L  D0,ED_SavedScrollSpeedIndex
    TST.L   ED_EditCursorOffset
    BNE.S   .use_21e8_minus1

    MOVEQ   #0,D0
    MOVE.B  Global_STR_SATELLITE_DELIVERED_SCROLL_SPEED,D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVE.W  D0,ESQPARS2_StateIndex
    BRA.S   .after_sync_scroll_speed

.use_21e8_minus1:
    MOVE.L  ED_EditCursorOffset,D0
    SUBQ.L  #1,D0
    MOVE.W  D0,ESQPARS2_StateIndex

.after_sync_scroll_speed:
    JSR     ED_DrawESCMenuBottomHelp(PC)

    BRA.W   .return

.case_adjust_selection_key:
    MOVE.B  ED_LastMenuInputChar,D0
    MOVEQ   #65,D1
    CMP.B   D1,D0
    BNE.S   .case_increment_selection_key

    SUBQ.L  #1,ED_EditCursorOffset
    BGE.S   .after_selection_update

    MOVEQ   #8,D0
    MOVE.L  D0,ED_EditCursorOffset
    BRA.S   .after_selection_update

.case_increment_selection_key:
    ADDQ.L  #1,ED_EditCursorOffset
    MOVEQ   #1,D0
    CMP.L   ED_EditCursorOffset,D0
    BNE.S   .case_wrap_selection_key

    MOVEQ   #3,D0
    MOVE.L  D0,ED_EditCursorOffset
    BRA.S   .after_selection_update

.case_wrap_selection_key:
    MOVEQ   #9,D0
    CMP.L   ED_EditCursorOffset,D0
    BNE.S   .after_selection_update

    CLR.L   ED_EditCursorOffset

.after_selection_update:
    PEA     9.W
    JSR     ED_DrawMenuSelectionHighlight(PC)

    JSR     ED_DrawScrollSpeedMenuText(PC)

    ADDQ.W  #4,A7
    BRA.S   .return

.case_adjust_selection_default:
    ADDQ.L  #1,ED_EditCursorOffset
    MOVEQ   #1,D0
    CMP.L   ED_EditCursorOffset,D0
    BNE.S   .case_wrap_selection_default

    MOVEQ   #3,D0
    MOVE.L  D0,ED_EditCursorOffset
    BRA.S   .after_default_update

.case_wrap_selection_default:
    MOVEQ   #9,D0
    CMP.L   ED_EditCursorOffset,D0
    BNE.S   .after_default_update

    CLR.L   ED_EditCursorOffset

.after_default_update:
    PEA     9.W
    JSR     ED_DrawMenuSelectionHighlight(PC)

    JSR     ED_DrawScrollSpeedMenuText(PC)

    ADDQ.W  #4,A7

.return:
    RTS
