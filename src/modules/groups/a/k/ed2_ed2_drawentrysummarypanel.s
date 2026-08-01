    XDEF    _ED2_DrawEntrySummaryPanel


;------------------------------------------------------------------------------
; FUNC: _ED2_DrawEntrySummaryPanel   (Draw entry summary paneluncertain)
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
;   _ED2_SelectedEntryIndex, _TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_PrimaryEntryPtrTable, _ED2_SelectedEntryDataPtr, _WDISP_DisplayContextBase
; WRITES:
;   _ED2_SelectedEntryDataPtr, _ED2_SelectedEntryTitlePtr, _ED2_SelectedEntryIndex, _ED2_SelectedFlagByteOffset
; DESC:
;   Draws summary text and flag strings for the currently selected entry.
; NOTES:
;   Uses flag fields at offsets 27 and 46 in the entry data.
;   Local panel-text buffer at -120(A5) has 120 bytes; %s fields come from
;   entry pointers and rely on upstream data staying bounded.
;   Entry-field `%s` sources are likely fixed-width struct slots (+1/+12/+19),
;   but no explicit clamp occurs before _WDISP_SPrintf.
;------------------------------------------------------------------------------
_ED2_DrawEntrySummaryPanel:

.panelTextBuffer = -120

    LINK.W  A5,#-120
    MOVEM.L D2/A2-A3,-(A7)

    MOVE.W  _ED2_SelectedEntryIndex,D0
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D1
    CMP.W   D1,D0
    BGE.S   .reset_index

    TST.W   D0
    BPL.S   .after_index_check

.reset_index:
    MOVEQ   #0,D2
    MOVE.W  D2,_ED2_SelectedEntryIndex

.after_index_check:
    TST.W   D1
    BNE.S   .select_entry_ptr

    SUBA.L  A0,A0
    MOVE.L  A0,_ED2_SelectedEntryDataPtr
    MOVE.L  A0,_ED2_SelectedEntryTitlePtr
    BRA.S   .have_entry_ptr

.select_entry_ptr:
    MOVE.W  _ED2_SelectedEntryIndex,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  A1,_ED2_SelectedEntryDataPtr
    CLR.W   _ED2_SelectedFlagByteOffset

.have_entry_ptr:
    TST.L   _ED2_SelectedEntryDataPtr
    BEQ.W   .return

    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    MOVEA.L A0,A1
    MOVEQ   #2,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    MOVE.W  _ED2_SelectedEntryIndex,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     _Global_STR_CLU_CLU_POS1
    PEA     .panelTextBuffer(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    PEA     120.W
    PEA     .panelTextBuffer(A5)
    MOVE.L  A0,-(A7)
    JSR     _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    MOVEA.L _ED2_SelectedEntryDataPtr,A0
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
    PEA     _Global_STR_CHAN_SOURCE_CALLLTRS_2
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
    MOVEA.L _ED2_SelectedEntryDataPtr,A0
    MOVE.B  27(A0),D0
    BTST    #0,D0
    BEQ.S   .after_flag0

    PEA     _ED2_STR_NONE_SourceFlagSummary
    PEA     .panelTextBuffer(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag0:
    MOVEA.L _ED2_SelectedEntryDataPtr,A0
    MOVE.B  27(A0),D0
    BTST    #1,D0
    BEQ.S   .after_flag1

    PEA     _ED2_STR_HILITESRC
    PEA     .panelTextBuffer(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag1:
    MOVEA.L _ED2_SelectedEntryDataPtr,A0
    MOVE.B  27(A0),D0
    BTST    #2,D0
    BEQ.S   .after_flag2

    PEA     _ED2_STR_SUMBYSRC
    PEA     .panelTextBuffer(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag2:
    MOVEA.L _ED2_SelectedEntryDataPtr,A0
    MOVE.B  27(A0),D0
    BTST    #3,D0
    BEQ.S   .after_flag3

    PEA     _ED2_STR_VIDEO_TAG_DISABLE
    PEA     -120(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag3:
    MOVEA.L _ED2_SelectedEntryDataPtr,A0
    MOVE.B  27(A0),D0
    BTST    #4,D0
    BEQ.S   .after_flag4

    PEA     _ED2_STR_CAF_PPVSRC
    PEA     -120(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag4:
    MOVEA.L _ED2_SelectedEntryDataPtr,A0
    MOVE.B  27(A0),D0
    BTST    #5,D0
    BEQ.S   .after_flag5

    PEA     _ED2_STR_DITTO
    PEA     -120(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag5:
    MOVEA.L _ED2_SelectedEntryDataPtr,A0
    MOVE.B  27(A0),D0
    BTST    #6,D0
    BEQ.S   .after_flag6

    PEA     _ED2_STR_ALTHILITESRC
    PEA     -120(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_flag6:
    MOVEA.L _ED2_SelectedEntryDataPtr,A0
    MOVE.B  27(A0),D0
    BTST    #7,D0
    BEQ.S   .after_flag7

    PEA     _ED2_STR_STEREO
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
    MOVEA.L _ED2_SelectedEntryDataPtr,A0
    MOVE.W  46(A0),D0
    BTST    #0,D0
    BEQ.S   .after_word_flag0

    PEA     _ED2_STR_GRID
    PEA     -120(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_word_flag0:
    MOVEA.L _ED2_SelectedEntryDataPtr,A0
    MOVE.W  46(A0),D0
    BTST    #1,D0
    BEQ.S   .after_word_flag1

    PEA     _ED2_STR_MR
    PEA     -120(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_word_flag1:
    MOVEA.L _ED2_SelectedEntryDataPtr,A0
    MOVE.W  46(A0),D0
    BTST    #2,D0
    BEQ.S   .after_word_flag2

    PEA     _ED2_STR_DNICHE
    PEA     -120(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_word_flag2:
    MOVEA.L _ED2_SelectedEntryDataPtr,A0
    MOVE.W  46(A0),D0
    BTST    #3,D0
    BEQ.S   .after_word_flag3

    PEA     _ED2_STR_DMPLEX
    PEA     -120(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_word_flag3:
    MOVEA.L _ED2_SelectedEntryDataPtr,A0
    MOVE.W  46(A0),D0
    BTST    #4,D0
    BEQ.S   .after_word_flag4

    PEA     _ED2_STR_CF2_DPPV
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