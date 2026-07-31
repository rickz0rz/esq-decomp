    XDEF    TEXTDISP_DrawNextEntryPreview
    XDEF    TEXTDISP_UpdateHighlightOrPreview



;------------------------------------------------------------------------------
; FUNC: TEXTDISP_DrawNextEntryPreview   (Draw next preview entry)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1/A0-A1
; CALLS:
;   _MATH_DivS32, TEXTDISP2_JMPTBL_LADFUNC_DrawEntryPreview
; READS:
;   _LADFUNC_EntryPtrTable, _LADFUNC_EntryCount
; WRITES:
;   _LADFUNC_EntryCount
; DESC:
;   Advances the entry index until a valid slot is found, then draws a preview.
; NOTES:
;   Wraps via division by 46.
;------------------------------------------------------------------------------
TEXTDISP_DrawNextEntryPreview:
.loop:
    MOVE.W  _LADFUNC_EntryCount,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _LADFUNC_EntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVEQ   #1,D0
    CMP.W   4(A1),D0
    BEQ.S   .found_entry

    MOVE.W  _LADFUNC_EntryCount,D0
    EXT.L   D0
    ADDQ.L  #1,D0
    MOVEQ   #46,D1
    JSR     _MATH_DivS32(PC)

    MOVE.W  D1,_LADFUNC_EntryCount
    BRA.S   .loop

.found_entry:
    MOVE.W  _LADFUNC_EntryCount,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     TEXTDISP2_JMPTBL_LADFUNC_DrawEntryPreview(PC)

    ADDQ.W  #4,A7
    MOVE.W  _LADFUNC_EntryCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_LADFUNC_EntryCount
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_UpdateHighlightOrPreview   (Update highlight/preview)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D2/D7
; CALLS:
;   _TEXTDISP2_JMPTBL_ESQIFF_PlayNextExternalAssetFrame, TEXTDISP_DrawNextEntryPreview, _TEXTDISP_ResetSelectionAndRefresh
; READS:
;   _LOCAVAIL_FilterModeFlag/1FE8/1FE9, _ED_DiagGraphModeChar, _WDISP_HighlightActive
; WRITES:
;   (none)
; DESC:
;   Chooses between refresh/preview paths based on mode flags and highlight state.
; NOTES:
;   Uses _ED_DiagGraphModeChar == 'N' (78) gate.
;------------------------------------------------------------------------------
TEXTDISP_UpdateHighlightOrPreview:
    MOVEM.L D2/D7,-(A7)
    MOVEQ   #1,D0
    CMP.L   _LOCAVAIL_FilterModeFlag,D0
    BNE.S   .mode_not_one

    MOVE.L  _LOCAVAIL_FilterClassId,D1
    MOVEQ   #-1,D2
    CMP.L   D2,D1
    BNE.S   .mode_index_selected

    MOVE.L  _LOCAVAIL_FilterPrevClassId,D1

.mode_index_selected:
    MOVE.L  D1,D7
    MOVE.B  _ED_DiagGraphModeChar,D1
    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .check_highlight_for_mode3

    MOVEQ   #2,D1
    CMP.L   D1,D7
    BNE.S   .check_highlight_for_mode3

    MOVE.L  D0,-(A7)
    JSR     _TEXTDISP2_JMPTBL_ESQIFF_PlayNextExternalAssetFrame(PC)

    ADDQ.W  #4,A7
    BRA.S   .return

.check_highlight_for_mode3:
    MOVE.W  _WDISP_HighlightActive,D1
    SUBQ.W  #1,D1
    BNE.S   .do_reset_selection

    MOVEQ   #3,D1
    CMP.L   D1,D7
    BNE.S   .do_reset_selection

    BSR.W   TEXTDISP_DrawNextEntryPreview

    BRA.S   .return

.do_reset_selection:
    BSR.W   _TEXTDISP_ResetSelectionAndRefresh

    BRA.S   .return

.mode_not_one:
    MOVE.B  _ED_DiagGraphModeChar,D1
    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .mode_char_is_n

    MOVE.L  D0,-(A7)
    JSR     _TEXTDISP2_JMPTBL_ESQIFF_PlayNextExternalAssetFrame(PC)

    ADDQ.W  #4,A7
    BRA.S   .return

.mode_char_is_n:
    MOVE.W  _WDISP_HighlightActive,D1
    SUBQ.W  #1,D1
    BNE.S   .do_reset_selection_alt

    BSR.W   TEXTDISP_DrawNextEntryPreview

    BRA.S   .return

.do_reset_selection_alt:
    BSR.W   _TEXTDISP_ResetSelectionAndRefresh

.return:
    MOVEM.L (A7)+,D2/D7
    RTS

;!======