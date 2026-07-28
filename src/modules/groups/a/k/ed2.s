    XDEF    ED2_DrawEntryDetailsPanel
    XDEF    ED2_DrawEntrySummaryPanel
    XDEF    ED2_HandleMenuActions


;------------------------------------------------------------------------------
; FUNC: ED2_DrawEntryDetailsPanel   (Draw entry details paneluncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0/D1
; CALLS:
;   _ESQIFF_JMPTBL_MEMORY_AllocateMemory, _LVOSetRast, _GROUP_AM_JMPTBL_WDISP_SPrintf,
;   _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines, _DISKIO2_CopyAndSanitizeSlotString, GROUP_AK_JMPTBL_TEXTDISP_FormatEntryTimeForIndex, _GROUP_AI_JMPTBL_STRING_AppendAtNull,
;   _ESQIFF_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   ED2_SelectedEntryIndex, _TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_PrimaryTitlePtrTable, ED2_SelectedEntryDataPtr, ED2_SelectedEntryTitlePtr, _WDISP_DisplayContextBase
; WRITES:
;   ED2_SelectedEntryTitlePtr, ED2_SelectedEntryIndex
; DESC:
;   Formats and draws details for the selected entry, including flags and titles.
; NOTES:
;   Builds a temporary 1000-byte text buffer and frees it before returning.
;   Local panel-text buffer at -120(A5) has 120 bytes; it is shared by
;   _WDISP_SPrintf and _STRING_AppendAtNull calls.
;   `%s` arguments come from mixed sources (entry struct fields, title pointer
;   tables, and sanitized slot text), so this is one of the higher-risk format
;   paths when string content/lengths are modified.
;------------------------------------------------------------------------------
ED2_DrawEntryDetailsPanel:

.panelTextBuffer = -120

    LINK.W  A5,#-148
    MOVEM.L A2-A3,-(A7)
    MOVE.W  ED2_SelectedEntryIndex,D0
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D1
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
    LEA     _TEXTDISP_PrimaryTitlePtrTable,A0
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
    JSR     _ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
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
    LEA     _TEXTDISP_PrimaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),ED2_SelectedEntryTitlePtr
    MOVE.W  ED2_SelectedEntryIndex,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     Global_STR_PI_CLU_POS1
    PEA     .panelTextBuffer(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    PEA     90.W
    PEA     .panelTextBuffer(A5)
    MOVE.L  A0,-(A7)
    JSR     _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    LEA     28(A7),A7
    MOVEA.L ED2_SelectedEntryDataPtr,A0
    MOVEA.L A0,A1
    ADDQ.L  #1,A1
    MOVE.L  A1,D0
    BEQ.S   .use_default_name

    LEA     1(A0),A1                      ; A0+1  = channel text ??
    BRA.S   .name_ptr_ready

.use_default_name:
    LEA     ED2_STR_NullFallbackChannel,A1

.name_ptr_ready:
    TST.L   ED2_SelectedEntryTitlePtr
    BEQ.S   .use_default_source

    MOVEA.L ED2_SelectedEntryTitlePtr,A2
    BRA.S   .source_ptr_ready

.use_default_source:
    LEA     ED2_STR_NullFallbackSource,A2

.source_ptr_ready:
    LEA     19(A0),A3                     ; A0+19 = call letters ?? (A0+27 is flags byte)
    MOVE.L  A3,D0
    BEQ.S   .use_default_call_letters

    LEA     19(A0),A3
    BRA.S   .call_letters_ready

.use_default_call_letters:
    LEA     ED2_STR_NullFallbackCallLetters,A3

.call_letters_ready:
    ; Guard candidate (no behavior change in this pass): if Section 1 string
    ; edits expand source/title text, pre-clamp each `%s` input before this
    ; formatter so the 120-byte destination cannot be exceeded.
    ; Budget note for .panelTextBuffer (120 bytes incl NUL):
    ; "Chan=%s Source=%s CallLtrs=%s" => 24 + len(chan)+len(source)+len(callltrs).
    ; Safe only while combined `%s` payload stays <= 96 bytes.
    MOVE.L  A3,-(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  A1,-(A7)
    PEA     Global_STR_CHAN_SOURCE_CALLLTRS_1
    PEA     .panelTextBuffer(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    PEA     120.W
    PEA     .panelTextBuffer(A5)
    MOVE.L  A0,-(A7)
    JSR     _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    MOVE.W  ED2_SelectedFlagByteOffset,D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  ED2_SelectedEntryTitlePtr,-(A7)
    MOVE.L  ED2_SelectedEntryDataPtr,-(A7)
    MOVE.L  -144(A5),-(A7)
    BSR.W   _DISKIO2_CopyAndSanitizeSlotString

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
    LEA     ED2_STR_NullFallbackTitle,A0

.title_ptr_ready:
    ; Guard candidate: `%s` title text here originates from DISKIO2 sanitize
    ; output / fallback pointer and can be much longer than inline entry fields.
    ; Budget note for .panelTextBuffer (120 bytes incl NUL):
    ; "TS=%d Title='%s' Time=%s" => 30 + len(title)+len(time) with conservative
    ; signed `%d` width (11 chars). This is the top ED2 guard-priority row.
    PEA     -140(A5)
    MOVE.L  A0,-(A7)
    MOVE.L  D0,-(A7)
    PEA     Global_STR_TS_TITLE_TIME
    PEA     .panelTextBuffer(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    PEA     150.W
    PEA     .panelTextBuffer(A5)
    MOVE.L  A0,-(A7)
    JSR     _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    LEA     32(A7),A7
    CLR.B   .panelTextBuffer(A5)
    MOVEA.L ED2_SelectedEntryTitlePtr,A0
    ADDA.W  ED2_SelectedFlagByteOffset,A0
    BTST    #0,7(A0)
    BEQ.S   .after_flag0

    PEA     ED2_STR_NONE_ProgramFlagSummary
    PEA     .panelTextBuffer(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag0:
    MOVEA.L ED2_SelectedEntryTitlePtr,A0
    ADDA.W  ED2_SelectedFlagByteOffset,A0
    BTST    #1,7(A0)
    BEQ.S   .after_flag1

    PEA     ED2_STR_MOVIE
    PEA     .panelTextBuffer(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag1:
    MOVEA.L ED2_SelectedEntryTitlePtr,A0
    ADDA.W  ED2_SelectedFlagByteOffset,A0
    BTST    #2,7(A0)
    BEQ.S   .after_flag2

    PEA     ED2_STR_ALTHILITEPROG
    PEA     .panelTextBuffer(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag2:
    MOVEA.L ED2_SelectedEntryTitlePtr,A0
    ADDA.W  ED2_SelectedFlagByteOffset,A0
    BTST    #3,7(A0)
    BEQ.S   .after_flag3

    PEA     ED2_STR_TAGPROG
    PEA     .panelTextBuffer(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag3:
    MOVEA.L ED2_SelectedEntryTitlePtr,A0
    ADDA.W  ED2_SelectedFlagByteOffset,A0
    BTST    #4,7(A0)
    BEQ.S   .after_flag4

    PEA     ED2_STR_SPORTSPROG
    PEA     .panelTextBuffer(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag4:
    MOVEA.L ED2_SelectedEntryTitlePtr,A0
    ADDA.W  ED2_SelectedFlagByteOffset,A0
    BTST    #5,7(A0)
    BEQ.S   .after_flag5

    PEA     ED2_STR_DVIEW_USED
    PEA     .panelTextBuffer(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag5:
    MOVEA.L ED2_SelectedEntryTitlePtr,A0
    ADDA.W  ED2_SelectedFlagByteOffset,A0
    BTST    #6,7(A0)
    BEQ.S   .after_flag6

    PEA     ED2_STR_REPEATPROG
    PEA     .panelTextBuffer(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag6:
    MOVEA.L ED2_SelectedEntryTitlePtr,A0
    ADDA.W  ED2_SelectedFlagByteOffset,A0
    BTST    #7,7(A0)
    BEQ.S   .after_flag7

    PEA     ED2_STR_PREVDAYSDATA
    PEA     .panelTextBuffer(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag7:
    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    PEA     210.W
    PEA     .panelTextBuffer(A5)
    MOVE.L  A0,-(A7)
    JSR     _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    PEA     1000.W
    MOVE.L  -144(A5),-(A7)
    PEA     427.W
    PEA     Global_STR_ED2_C_2
    JSR     _ESQIFF_JMPTBL_MEMORY_DeallocateMemory(PC)

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
;   _LVOSetRast, _GROUP_AM_JMPTBL_WDISP_SPrintf, _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines,
;   _GROUP_AI_JMPTBL_STRING_AppendAtNull
; READS:
;   ED2_SelectedEntryIndex, _TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_PrimaryEntryPtrTable, ED2_SelectedEntryDataPtr, _WDISP_DisplayContextBase
; WRITES:
;   ED2_SelectedEntryDataPtr, ED2_SelectedEntryTitlePtr, ED2_SelectedEntryIndex, ED2_SelectedFlagByteOffset
; DESC:
;   Draws summary text and flag strings for the currently selected entry.
; NOTES:
;   Uses flag fields at offsets 27 and 46 in the entry data.
;   Local panel-text buffer at -120(A5) has 120 bytes; %s fields come from
;   entry pointers and rely on upstream data staying bounded.
;   Entry-field `%s` sources are likely fixed-width struct slots (+1/+12/+19),
;   but no explicit clamp occurs before _WDISP_SPrintf.
;------------------------------------------------------------------------------
ED2_DrawEntrySummaryPanel:

.panelTextBuffer = -120

    LINK.W  A5,#-120
    MOVEM.L D2/A2-A3,-(A7)

    MOVE.W  ED2_SelectedEntryIndex,D0
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D1
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
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  A1,ED2_SelectedEntryDataPtr
    CLR.W   ED2_SelectedFlagByteOffset

.have_entry_ptr:
    TST.L   ED2_SelectedEntryDataPtr
    BEQ.W   .return

    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    MOVEA.L A0,A1
    MOVEQ   #2,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    MOVE.W  ED2_SelectedEntryIndex,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     Global_STR_CLU_CLU_POS1
    PEA     .panelTextBuffer(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    PEA     120.W
    PEA     .panelTextBuffer(A5)
    MOVE.L  A0,-(A7)
    JSR     _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    MOVEA.L ED2_SelectedEntryDataPtr,A0
    MOVEA.L A0,A1
    ADDQ.L  #1,A1                         ; A0+1  = channel text ??
    LEA     12(A0),A2                     ; A0+12 = source text ??
    LEA     19(A0),A3                     ; A0+19 = call letters ?? (A0+27 flags)
    ; Guard candidate: clamp these three `%s` fields (or replace with bounded
    ; copy step) if entry layout/field sizes are changed in future data edits.
    ; Budget note for .panelTextBuffer (120 bytes incl NUL):
    ; "Chan=%s Source=%s CallLtrs=%s" => 24 + len(chan)+len(source)+len(callltrs),
    ; so combined `%s` payload must stay <= 96 bytes.
    MOVE.L  A3,(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  A1,-(A7)
    PEA     Global_STR_CHAN_SOURCE_CALLLTRS_2
    PEA     .panelTextBuffer(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    PEA     150.W
    PEA     .panelTextBuffer(A5)
    MOVE.L  A0,-(A7)
    JSR     _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    LEA     56(A7),A7
    CLR.B   .panelTextBuffer(A5)
    MOVEA.L ED2_SelectedEntryDataPtr,A0
    MOVE.B  27(A0),D0
    BTST    #0,D0
    BEQ.S   .after_flag0

    PEA     ED2_STR_NONE_SourceFlagSummary
    PEA     .panelTextBuffer(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag0:
    MOVEA.L ED2_SelectedEntryDataPtr,A0
    MOVE.B  27(A0),D0
    BTST    #1,D0
    BEQ.S   .after_flag1

    PEA     ED2_STR_HILITESRC
    PEA     .panelTextBuffer(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag1:
    MOVEA.L ED2_SelectedEntryDataPtr,A0
    MOVE.B  27(A0),D0
    BTST    #2,D0
    BEQ.S   .after_flag2

    PEA     ED2_STR_SUMBYSRC
    PEA     .panelTextBuffer(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag2:
    MOVEA.L ED2_SelectedEntryDataPtr,A0
    MOVE.B  27(A0),D0
    BTST    #3,D0
    BEQ.S   .after_flag3

    PEA     ED2_STR_VIDEO_TAG_DISABLE
    PEA     -120(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag3:
    MOVEA.L ED2_SelectedEntryDataPtr,A0
    MOVE.B  27(A0),D0
    BTST    #4,D0
    BEQ.S   .after_flag4

    PEA     ED2_STR_CAF_PPVSRC
    PEA     -120(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag4:
    MOVEA.L ED2_SelectedEntryDataPtr,A0
    MOVE.B  27(A0),D0
    BTST    #5,D0
    BEQ.S   .after_flag5

    PEA     ED2_STR_DITTO
    PEA     -120(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag5:
    MOVEA.L ED2_SelectedEntryDataPtr,A0
    MOVE.B  27(A0),D0
    BTST    #6,D0
    BEQ.S   .after_flag6

    PEA     ED2_STR_ALTHILITESRC
    PEA     -120(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag6:
    MOVEA.L ED2_SelectedEntryDataPtr,A0
    MOVE.B  27(A0),D0
    BTST    #7,D0
    BEQ.S   .after_flag7

    PEA     ED2_STR_STEREO
    PEA     -120(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag7:
    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    PEA     180.W
    PEA     -120(A5)
    MOVE.L  A0,-(A7)
    JSR     _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    LEA     12(A7),A7
    CLR.B   -120(A5)
    MOVEA.L ED2_SelectedEntryDataPtr,A0
    MOVE.W  46(A0),D0
    BTST    #0,D0
    BEQ.S   .after_word_flag0

    PEA     ED2_STR_GRID
    PEA     -120(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_word_flag0:
    MOVEA.L ED2_SelectedEntryDataPtr,A0
    MOVE.W  46(A0),D0
    BTST    #1,D0
    BEQ.S   .after_word_flag1

    PEA     ED2_STR_MR
    PEA     -120(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_word_flag1:
    MOVEA.L ED2_SelectedEntryDataPtr,A0
    MOVE.W  46(A0),D0
    BTST    #2,D0
    BEQ.S   .after_word_flag2

    PEA     ED2_STR_DNICHE
    PEA     -120(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_word_flag2:
    MOVEA.L ED2_SelectedEntryDataPtr,A0
    MOVE.W  46(A0),D0
    BTST    #3,D0
    BEQ.S   .after_word_flag3

    PEA     ED2_STR_DMPLEX
    PEA     -120(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_word_flag3:
    MOVEA.L ED2_SelectedEntryDataPtr,A0
    MOVE.W  46(A0),D0
    BTST    #4,D0
    BEQ.S   .after_word_flag4

    PEA     ED2_STR_CF2_DPPV
    PEA     -120(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_word_flag4:
    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    PEA     210.W
    PEA     -120(A5)
    MOVE.L  A0,-(A7)
    JSR     _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

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
;   _ED1_DrawStatusLine1, _ED1_DrawStatusLine2, ED2_DrawEntrySummaryPanel,
;   ED2_DrawEntryDetailsPanel, _DST_FormatBannerDateTime, _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer,
;   _ESQIFF_JMPTBL_DOS_OpenFileWithMode, _LVORead, _LVOClose,
;   GROUP_AK_JMPTBL_GCOMMAND_GetBannerChar, ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition,
;   GROUP_AK_JMPTBL_ESQ_SetCopperEffect_Custom, ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode,
;   _GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight, _GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte, GROUP_AK_JMPTBL_TLIBA3_SelectNextViewMode,
;   GROUP_AK_JMPTBL_ESQPARS_ApplyRtcBytesAndPersist, GROUP_AK_JMPTBL_PARSEINI_WriteErrorLogEntry, GROUP_AK_JMPTBL_PARSEINI_ScanLogoDirectory, _GROUP_AK_JMPTBL_TLIBA3_DrawViewModeGuides, ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode, _ESQFUNC_UpdateDiskWarningAndRefreshTick, _ESQDISP_TestWordIsZeroBooleanize,
;   _GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch
; READS:
;   _ED_StateRingIndex, _ED_StateRingTable, ED2_SelectedEntryIndex, ED2_SelectedFlagByteOffset, ED2_SelectedEntryDataPtr, ED2_SelectedEntryTitlePtr, _TEXTDISP_PrimaryGroupEntryCount,
;   _TEXTDISP_PrimaryEntryPtrTable, _TEXTDISP_PrimaryTitlePtrTable, _TEXTDISP_PrimaryGroupPresentFlag, _WDISP_WeatherStatusCountdown, WDISP_WeatherStatusColorCode, _WDISP_WeatherStatusBrushIndex, _WDISP_WeatherStatusDigitChar,
;   WDISP_WeatherCycleOffsetCount, _WDISP_WeatherStatusOverlayTextPtr, _WDISP_WeatherStatusTextPtr, _P_TYPE_WeatherBrushRefreshPendingFlag
; WRITES:
;   _ED_LastKeyCode, ED2_SelectedEntryIndex, ED2_SelectedFlagByteOffset, GCOMMAND_BannerRowFallbackOnFirstRowFlag, _ED_MenuStateId, ESQ_ShutdownRequestedFlag, CLEANUP_DiagOverlayAutoRefreshFlag,
;   HIGHLIGHT_CustomValue, _ESQPARS2_ReadModeFlags, LOCAVAIL_FilterPrevClassId, _TEXTDISP_DeferredActionCountdown, _TEXTDISP_DeferredActionArmed, _WDISP_AccumulatorCaptureActive, _SCRIPT_RuntimeMode,
;   _PARSEINI_CtrlHChangeGateFlag
; DESC:
;   Dispatches ESC menu selections to a large set of diagnostic and UI actions.
; NOTES:
;   Switch-like chain on _ED_StateRingTable-selected index; ends by restoring rastport state.
;   case_show_status_message uses a 50-byte local printf target (-50(A5)).
;------------------------------------------------------------------------------
ED2_HandleMenuActions:

.statusLineBuffer = -50

    LINK.W  A5,#-120
    MOVEM.L D2-D7,-(A7)

    MOVE.L  _ED_StateRingIndex,D0
    LSL.L   #2,D0           ; multiply by 4
    ADD.L   _ED_StateRingIndex,D0
    LEA     _ED_StateRingTable,A0
    ADDA.L  D0,A0
    MOVE.B  (A0),D0
    MOVE.B  D0,_ED_LastKeyCode
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
    TST.W   GCOMMAND_BannerRowFallbackOnFirstRowFlag
    SEQ     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVE.W  D0,GCOMMAND_BannerRowFallbackOnFirstRowFlag
    BRA.W   .restore_display_state

.case_format_banner_datetime:
    PEA     _CLOCK_DaySlotIndex
    PEA     ED2_STR_CTIME
    JSR     _DST_FormatBannerDateTime(PC)

    PEA     _CLOCK_CurrentDayOfWeekIndex
    PEA     ED2_STR_BTIME
    JSR     _DST_FormatBannerDateTime(PC)

    LEA     16(A7),A7
    BRA.W   .restore_display_state

.case_draw_status_line2:
    BSR.W   _ED1_DrawStatusLine2

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
    JSR     _ESQIFF_JMPTBL_DOS_OpenFileWithMode(PC)

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
    MOVE.B  #$18,_ED_MenuStateId

    BRA.W   .restore_display_state

.case_draw_status_line1:
    BSR.W   _ED1_DrawStatusLine1

    BRA.W   .restore_display_state

.case_decrement_status_index:
    TST.W   _ESQPARS2_StateIndex
    BEQ.S   .after_status_index_dec

    MOVE.W  _ESQPARS2_StateIndex,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,_ESQPARS2_StateIndex

.after_status_index_dec:
    BSR.W   _ED1_DrawStatusLine1

    BRA.W   .restore_display_state

.case_increment_status_index:
    MOVE.W  _ESQPARS2_StateIndex,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQPARS2_StateIndex
    BSR.W   _ED1_DrawStatusLine1

    BRA.W   .restore_display_state

.case_refresh_rastports:
    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    MOVE.L  A0,-(A7)
    JSR     _GROUP_AK_JMPTBL_TLIBA3_DrawViewModeGuides(PC)

    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.L  #_Global_REF_696_400_BITMAP,4(A0)
    MOVE.L  _Global_REF_RASTPORT_1,(A7)
    JSR     _GROUP_AK_JMPTBL_TLIBA3_DrawViewModeGuides(PC)

    ADDQ.W  #4,A7
    BRA.W   .restore_display_state

.case_call_0484:
    CLR.L   -(A7)
    JSR     _DISKIO2_RunDiskSyncWorkflow(PC)

    ADDQ.W  #4,A7
    BRA.W   .restore_display_state

.case_set_1de4:
    MOVE.W  #1,ESQ_ShutdownRequestedFlag
    BRA.W   .restore_display_state

.case_format_debug_strings:
    PEA     ED2_STR_ED_DOT_C_COLON_SHORT_DUMP_OF_CLU
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    TST.B   _TEXTDISP_PrimaryGroupPresentFlag
    BEQ.S   .select_bool_string

    LEA     Global_STR_TRUE_1,A0
    BRA.S   .bool_string_ready

.select_bool_string:
    LEA     Global_STR_FALSE_1,A0

.bool_string_ready:
    MOVEQ   #0,D1
    MOVE.B  _TEXTDISP_PrimaryGroupHeaderCode,D1
    MOVEQ   #0,D2
    MOVE.B  _TEXTDISP_PrimaryGroupCode,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D0,-(A7)
    PEA     ED2_FMT_CLU_POS1_PCT_LD_CURCLU_PCT_S_JDCLU1_
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D7

.dump_entry_loop:
    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D1
    CMP.L   D1,D0
    BGE.S   .after_dump_entries

    CLR.W   ESQ_GlobalTickCounter
    MOVE.B  D7,D0
    EXT.W   D0
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-4(A5)
    MOVE.B  D7,D0
    EXT.W   D0
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     _TEXTDISP_PrimaryTitlePtrTable,A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-8(A5)
    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     DISKIO1_DumpProgramSourceRecordVerbose(PC)

    JSR     _ESQFUNC_ServiceUiTickIfRunning(PC)

    ADDQ.W  #8,A7
    ADDQ.B  #1,D7
    BRA.S   .dump_entry_loop

.after_dump_entries:
    PEA     ED2_STR_ED_DOT_C_COLON_END_OF_DUMP_OF_CLU
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7
    BRA.W   .restore_display_state

.case_toggle_1def:
    MOVE.B  CLEANUP_DiagOverlayAutoRefreshFlag,D0
    NOT.B   D0
    MOVE.B  D0,CLEANUP_DiagOverlayAutoRefreshFlag
    BRA.W   .restore_display_state

.case_dump_runtime_vars:
    MOVEQ   #0,D0
    MOVE.B  _WDISP_WeatherStatusBrushIndex,D0
    MOVE.L  D0,-(A7)
    PEA     ED2_FMT_WICON_PCT_LD
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.B  _WDISP_WeatherStatusCountdown,D0
    MOVE.L  D0,(A7)
    PEA     ED2_FMT_W_MIN_PCT_LD_MINUTES
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVE.W  _WDISP_WeatherStatusDigitChar,D0
    EXT.L   D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVE.W  _WDISP_WeatherStatusDigitChar,D1
    EXT.L   D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    PEA     ED2_FMT_WDCNT_EVERY_PCT_LD_TIMES_PCT_LD
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVE.W  WDISP_WeatherCycleOffsetCount,D0
    EXT.L   D0
    MOVE.W  WDISP_WeatherCycleOffsetCount,D1
    EXT.L   D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    PEA     ED2_FMT_CWCNT_PCT_LD_TIMES_FROM_NOW_PCT_LD
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVE.L  _WDISP_WeatherStatusOverlayTextPtr,(A7)
    PEA     ED2_FMT_WDATA_PCT_08LX
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVE.L  _WDISP_WeatherStatusTextPtr,(A7)
    PEA     ED2_FMT_WCITY_PCT_S
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    PEA     _WDISP_WeatherStatusLabelBuffer
    PEA     ED2_FMT_WEATHER_ID_PCT_S
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.B  WDISP_WeatherStatusColorCode,D0
    MOVE.L  D0,(A7)
    PEA     ED2_FMT_CWCOLOR_PCT_LD
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVE.L  _P_TYPE_WeatherBrushRefreshPendingFlag,(A7)
    PEA     ED2_FMT_BANNER_FOR_WEATHER_PCT_D
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     52(A7),A7
    BRA.W   .restore_display_state

.case_reset_defaults:
    MOVE.B  #$3c,_WDISP_WeatherStatusCountdown
    MOVE.B  #$1,WDISP_WeatherStatusColorCode
    MOVE.B  #$2,_WDISP_WeatherStatusBrushIndex
    MOVE.W  #$32,_WDISP_WeatherStatusDigitChar
    CLR.W   WDISP_WeatherCycleOffsetCount
    BRA.W   .restore_display_state

.case_toggle_1ba2:
    MOVE.B  CONFIG_RefreshIntervalMinutes,D0
    TST.B   D0
    BEQ.S   .toggle_1ba2_restore

    MOVE.B  D0,ED_SavedCtasksIntervalByte
    CLR.B   CONFIG_RefreshIntervalMinutes
    BRA.S   .toggle_1ba2_done

.toggle_1ba2_restore:
    MOVE.B  ED_SavedCtasksIntervalByte,D1
    MOVE.B  D1,CONFIG_RefreshIntervalMinutes

.toggle_1ba2_done:
    MOVE.B  CONFIG_RefreshIntervalMinutes,D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #60,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  D0,_CONFIG_RefreshIntervalSeconds
    BRA.W   .restore_display_state

.case_enter_esc_menu:
    JSR     _ED1_EnterEscMenu(PC)

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
    MOVE.W  _CONFIG_BannerCopperHeadByte,D0
    EXT.L   D0
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition(PC)

    ADDQ.W  #8,A7
    BRA.W   .restore_display_state

.case_set_copper_custom:
    MOVE.B  #$1f,HIGHLIGHT_CustomValue
    JSR     GROUP_AK_JMPTBL_ESQ_SetCopperEffect_Custom(PC)

    BRA.W   .restore_display_state

.case_rebuild_display:
    PEA     4.W
    CLR.L   -(A7)
    PEA     3.W
    JSR     ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(PC)

    MOVE.L  D0,_WDISP_DisplayContextBase
    JSR     _ED_InitRastport2Pens(PC)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVEA.L _WDISP_DisplayContextBase,A0
    MOVE.W  2(A0),D0
    MOVEQ   #0,D1
    MOVE.W  4(A0),D1
    MOVE.L  D0,D2
    MOVE.L  D1,D3
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVEQ   #20,D1
    JSR     _LVORectFill(A6)

    JSR     _GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(PC)

    LEA     12(A7),A7
    MOVE.W  #1,SCRIPT_StatusRefreshHoldFlag
    BRA.W   .restore_display_state

.case_start_transition_2:
    TST.L   _LOCAVAIL_FilterStep
    BNE.W   .restore_display_state

    MOVEQ   #2,D0
    MOVE.L  D0,LOCAVAIL_FilterPrevClassId
    PEA     3.W
    JSR     _GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte(PC)

    ADDQ.W  #4,A7
    MOVE.W  #3,_TEXTDISP_DeferredActionCountdown
    MOVE.W  #1,_TEXTDISP_DeferredActionArmed
    BRA.W   .restore_display_state

.case_start_transition_3:
    TST.L   _LOCAVAIL_FilterStep
    BNE.W   .restore_display_state

    MOVEQ   #3,D0
    MOVE.L  D0,LOCAVAIL_FilterPrevClassId
    MOVE.L  D0,-(A7)
    JSR     _GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte(PC)

    ADDQ.W  #4,A7
    MOVE.W  #3,_TEXTDISP_DeferredActionCountdown
    MOVE.W  #1,_TEXTDISP_DeferredActionArmed
    BRA.W   .restore_display_state

.case_wait_clear_bit0:
    JSR     _ED1_WaitForFlagAndClearBit0(PC)

    BRA.W   .restore_display_state

.case_wait_clear_bit1:
    JSR     _ED1_WaitForFlagAndClearBit1(PC)

    BRA.W   .restore_display_state

.case_copy_gfx_to_work:
    JSR     GROUP_AK_JMPTBL_GCOMMAND_CopyGfxToWorkIfAvailable(PC)

    BRA.W   .restore_display_state

.case_draw_color_bars:
    JSR     _ED_InitRastport2Pens(PC)

    MOVEQ   #0,D7

.color_bar_loop:
    MOVEQ   #32,D0
    CMP.B   D0,D7
    BGE.W   .restore_display_state

    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L _Global_REF_RASTPORT_1,A1
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
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #120,D1
    MOVEQ   #100,D3
    ADD.L   D3,D3
    JSR     _LVORectFill(A6)

    ADDQ.B  #1,D7
    BRA.S   .color_bar_loop

.case_clear_22aa:
    PEA     31.W
    CLR.L   -(A7)
    JSR     _ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd(PC)

    ADDQ.W  #8,A7
    CLR.W   _WDISP_AccumulatorCaptureActive
    BRA.W   .restore_display_state

.case_call_0539:
    JSR     _DISKIO2_ReloadDataFilesAndRebuildIndex(PC)

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
    CLR.W   _SCRIPT_RuntimeMode
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
    CLR.W   _ESQPARS2_ReadModeFlags
    BRA.W   .restore_display_state

.case_set_1f45_100:
    MOVE.W  #$100,_ESQPARS2_ReadModeFlags
    BRA.W   .restore_display_state

.case_set_1f45_200:
    MOVE.W  #$200,_ESQPARS2_ReadModeFlags
    BRA.W   .restore_display_state

.case_adjust_2266:
    JSR     _ESQFUNC_UpdateDiskWarningAndRefreshTick(PC)

    MOVE.W  _PARSEINI_CtrlHChangeGateFlag,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     _ESQDISP_TestWordIsZeroBooleanize(PC)

    ADDQ.W  #4,A7
    MOVE.W  D0,_PARSEINI_CtrlHChangeGateFlag
    BRA.S   .restore_display_state

.case_show_status_message:
    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.L  #_Global_REF_696_400_BITMAP,4(A0)
    MOVE.L  ESQSHARED_BannerRowScratchRasterBase0,-(A7)
    PEA     ED2_FMT_BITPLANE1_PCT_8LX
    PEA     .statusLineBuffer(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     .statusLineBuffer(A5)
    PEA     232.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     28(A7),A7

    BRA.S   .restore_display_state

.case_enable_highlight:
    JSR     _GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(PC)

    CLR.L   -(A7)
    JSR     ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode(PC)

    PEA     1.W
    JSR     _GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte(PC)

    ADDQ.W  #8,A7
    BRA.S   .restore_display_state

.case_call_07cb:
    JSR     GROUP_AK_JMPTBL_PARSEINI_ScanLogoDirectory(PC)

    BRA.S   .restore_display_state

.case_parse_gradient_ini:
    PEA     Global_STR_DF0_GRADIENT_INI_1
    JSR     _GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch(PC)

    ADDQ.W  #4,A7

.restore_display_state:
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.L  #_Global_REF_696_400_BITMAP,4(A0)
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    JSR     _LVOSetBPen(A6)

    MOVEM.L (A7)+,D2-D7
    UNLK    A5
    RTS

;!======