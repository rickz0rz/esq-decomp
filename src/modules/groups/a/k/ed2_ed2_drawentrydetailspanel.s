    XDEF    _ED2_DrawEntryDetailsPanel




;------------------------------------------------------------------------------
; FUNC: _ED2_DrawEntryDetailsPanel   (Draw entry details paneluncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0/D1
; CALLS:
;   _ESQIFF_JMPTBL_MEMORY_AllocateMemory, _LVOSetRast, _GROUP_AM_JMPTBL_WDISP_SPrintf,
;   _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines, _DISKIO2_CopyAndSanitizeSlotString, _GROUP_AK_JMPTBL_TEXTDISP_FormatEntryTimeForIndex, _GROUP_AI_JMPTBL_STRING_AppendAtNull,
;   _ESQIFF_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   _ED2_SelectedEntryIndex, _TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_PrimaryTitlePtrTable, _ED2_SelectedEntryDataPtr, _ED2_SelectedEntryTitlePtr, _WDISP_DisplayContextBase
; WRITES:
;   _ED2_SelectedEntryTitlePtr, _ED2_SelectedEntryIndex
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
_ED2_DrawEntryDetailsPanel:

.panelTextBuffer = -120

    LINK.W  A5,#-148
    MOVEM.L A2-A3,-(A7)
    MOVE.W  _ED2_SelectedEntryIndex,D0
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D1
    CMP.W   D1,D0
    BGE.S   .reset_index

    TST.W   D0
    BPL.S   .select_entry_ptr

.reset_index:
    SUBA.L  A0,A0
    MOVE.L  A0,_ED2_SelectedEntryTitlePtr
    MOVEQ   #0,D1
    MOVE.W  D1,_ED2_SelectedEntryIndex
    BRA.S   .have_entry_ptr

.select_entry_ptr:
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     _TEXTDISP_PrimaryTitlePtrTable,A0
    ADDA.L  D1,A0
    MOVEA.L (A0),A1
    MOVE.L  A1,_ED2_SelectedEntryTitlePtr

.have_entry_ptr:
    TST.L   _ED2_SelectedEntryTitlePtr
    BEQ.W   .return

    TST.L   _ED2_SelectedEntryDataPtr
    BEQ.W   .return

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     1000.W
    PEA     374.W
    PEA     _Global_STR_ED2_C_1
    JSR     _ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    MOVE.L  D0,-144(A5)
    MOVEA.L A0,A1
    MOVEQ   #2,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    MOVE.W  _ED2_SelectedFlagByteOffset,D0
    MOVEQ   #48,D1
    CMP.W   D1,D0
    BGT.S   .clamp_row_index

    MOVEQ   #1,D1
    CMP.W   D1,D0
    BGE.S   .row_index_ready

.clamp_row_index:
    MOVE.W  #1,_ED2_SelectedFlagByteOffset

.row_index_ready:
    MOVE.W  _ED2_SelectedEntryIndex,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),_ED2_SelectedEntryTitlePtr
    MOVE.W  _ED2_SelectedEntryIndex,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     _Global_STR_PI_CLU_POS1
    PEA     .panelTextBuffer(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    PEA     90.W
    PEA     .panelTextBuffer(A5)
    MOVE.L  A0,-(A7)
    JSR     _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    LEA     28(A7),A7
    MOVEA.L _ED2_SelectedEntryDataPtr,A0
    MOVEA.L A0,A1
    ADDQ.L  #1,A1
    MOVE.L  A1,D0
    BEQ.S   .use_default_name

    LEA     1(A0),A1                      ; A0+1  = channel text ??
    BRA.S   .name_ptr_ready

.use_default_name:
    LEA     _ED2_STR_NullFallbackChannel,A1

.name_ptr_ready:
    TST.L   _ED2_SelectedEntryTitlePtr
    BEQ.S   .use_default_source

    MOVEA.L _ED2_SelectedEntryTitlePtr,A2
    BRA.S   .source_ptr_ready

.use_default_source:
    LEA     _ED2_STR_NullFallbackSource,A2

.source_ptr_ready:
    LEA     19(A0),A3                     ; A0+19 = call letters ?? (A0+27 is flags byte)
    MOVE.L  A3,D0
    BEQ.S   .use_default_call_letters

    LEA     19(A0),A3
    BRA.S   .call_letters_ready

.use_default_call_letters:
    LEA     _ED2_STR_NullFallbackCallLetters,A3

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
    PEA     _Global_STR_CHAN_SOURCE_CALLLTRS_1
    PEA     .panelTextBuffer(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    PEA     120.W
    PEA     .panelTextBuffer(A5)
    MOVE.L  A0,-(A7)
    JSR     _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    MOVE.W  _ED2_SelectedFlagByteOffset,D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  _ED2_SelectedEntryTitlePtr,-(A7)
    MOVE.L  _ED2_SelectedEntryDataPtr,-(A7)
    MOVE.L  -144(A5),-(A7)
    BSR.W   _DISKIO2_CopyAndSanitizeSlotString

    LEA     44(A7),A7
    MOVE.L  D0,-148(A5)
    BEQ.S   .no_title_buffer

    MOVE.W  _ED2_SelectedFlagByteOffset,D0
    EXT.L   D0
    MOVE.L  _ED2_SelectedEntryTitlePtr,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -140(A5)
    JSR     _GROUP_AK_JMPTBL_TEXTDISP_FormatEntryTimeForIndex(PC)

    LEA     12(A7),A7
    BRA.S   .title_buffer_ready

.no_title_buffer:
    CLR.B   -140(A5)

.title_buffer_ready:
    MOVE.W  _ED2_SelectedFlagByteOffset,D0
    EXT.L   D0
    TST.L   -148(A5)
    BEQ.S   .use_default_title

    MOVEA.L -148(A5),A0
    BRA.S   .title_ptr_ready

.use_default_title:
    LEA     _ED2_STR_NullFallbackTitle,A0

.title_ptr_ready:
    ; Guard candidate: `%s` title text here originates from DISKIO2 sanitize
    ; output / fallback pointer and can be much longer than inline entry fields.
    ; Budget note for .panelTextBuffer (120 bytes incl NUL):
    ; "TS=%d Title='%s' Time=%s" => 30 + len(title)+len(time) with conservative
    ; signed `%d` width (11 chars). This is the top ED2 guard-priority row.
    PEA     -140(A5)
    MOVE.L  A0,-(A7)
    MOVE.L  D0,-(A7)
    PEA     _Global_STR_TS_TITLE_TIME
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
    MOVEA.L _ED2_SelectedEntryTitlePtr,A0
    ADDA.W  _ED2_SelectedFlagByteOffset,A0
    BTST    #0,7(A0)
    BEQ.S   .after_flag0

    PEA     _ED2_STR_NONE_ProgramFlagSummary
    PEA     .panelTextBuffer(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag0:
    MOVEA.L _ED2_SelectedEntryTitlePtr,A0
    ADDA.W  _ED2_SelectedFlagByteOffset,A0
    BTST    #1,7(A0)
    BEQ.S   .after_flag1

    PEA     _ED2_STR_MOVIE
    PEA     .panelTextBuffer(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag1:
    MOVEA.L _ED2_SelectedEntryTitlePtr,A0
    ADDA.W  _ED2_SelectedFlagByteOffset,A0
    BTST    #2,7(A0)
    BEQ.S   .after_flag2

    PEA     _ED2_STR_ALTHILITEPROG
    PEA     .panelTextBuffer(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag2:
    MOVEA.L _ED2_SelectedEntryTitlePtr,A0
    ADDA.W  _ED2_SelectedFlagByteOffset,A0
    BTST    #3,7(A0)
    BEQ.S   .after_flag3

    PEA     _ED2_STR_TAGPROG
    PEA     .panelTextBuffer(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag3:
    MOVEA.L _ED2_SelectedEntryTitlePtr,A0
    ADDA.W  _ED2_SelectedFlagByteOffset,A0
    BTST    #4,7(A0)
    BEQ.S   .after_flag4

    PEA     _ED2_STR_SPORTSPROG
    PEA     .panelTextBuffer(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag4:
    MOVEA.L _ED2_SelectedEntryTitlePtr,A0
    ADDA.W  _ED2_SelectedFlagByteOffset,A0
    BTST    #5,7(A0)
    BEQ.S   .after_flag5

    PEA     _ED2_STR_DVIEW_USED
    PEA     .panelTextBuffer(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag5:
    MOVEA.L _ED2_SelectedEntryTitlePtr,A0
    ADDA.W  _ED2_SelectedFlagByteOffset,A0
    BTST    #6,7(A0)
    BEQ.S   .after_flag6

    PEA     _ED2_STR_REPEATPROG
    PEA     .panelTextBuffer(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag6:
    MOVEA.L _ED2_SelectedEntryTitlePtr,A0
    ADDA.W  _ED2_SelectedFlagByteOffset,A0
    BTST    #7,7(A0)
    BEQ.S   .after_flag7

    PEA     _ED2_STR_PREVDAYSDATA
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
    PEA     _Global_STR_ED2_C_2
    JSR     _ESQIFF_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     28(A7),A7

.return:
    MOVEM.L (A7)+,A2-A3
    UNLK    A5
    RTS

;!======