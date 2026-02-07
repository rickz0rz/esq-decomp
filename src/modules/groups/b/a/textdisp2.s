;------------------------------------------------------------------------------
; FUNC: TEXTDISP_ResetSelectionAndRefresh   (Reset selection + refresh)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0/D1
; CALLS:
;   SCRIPT_UpdateSerialShadowFromCtrlByte, TEXTDISP2_JMPTBL_ESQIFF_PlayNextExternalAssetFrame
; READS:
;   (none)
; WRITES:
;   TEXTDISP_CurrentMatchIndex
; DESC:
;   Resets selection state and triggers a refresh helper.
; NOTES:
;   Uses helper SCRIPT_UpdateSerialShadowFromCtrlByte with constant 3 and clears
;   TEXTDISP_CurrentMatchIndex.
;------------------------------------------------------------------------------
TEXTDISP_ResetSelectionAndRefresh:
    PEA     3.W
    JSR     SCRIPT_UpdateSerialShadowFromCtrlByte(PC)

    MOVE.W  #(-1),TEXTDISP_CurrentMatchIndex
    CLR.L   (A7)
    JSR     TEXTDISP2_JMPTBL_ESQIFF_PlayNextExternalAssetFrame(PC)

    ADDQ.W  #4,A7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_SetRastForMode   (Set rast + palette for mode)
; ARGS:
;   stack +8: modeIndex (word)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D2/D7/A0-A1/A6
; CALLS:
;   WDISP_JMPTBL_ESQIFF_RunCopperDropTransition, TLIBA3_BuildDisplayContextForViewMode, _LVOSetRast
; READS:
;   WDISP_PaletteTriplesRBase-2297, Global_REF_RASTPORT_2, Global_REF_GRAPHICS_LIBRARY
; WRITES:
;   WDISP_DisplayContextBase, WDISP_PaletteTriplesRBase-2297, WDISP_AccumulatorFlushPending
; DESC:
;   Allocates/sets the working rastport and updates palette bytes based on mode.
; NOTES:
;   Mode 0 uses args (3,0,0); nonzero uses (4,0,7).
;------------------------------------------------------------------------------
TEXTDISP_SetRastForMode:
    MOVEM.L D2/D7,-(A7)
    MOVE.W  14(A7),D7
    CLR.W   WDISP_AccumulatorFlushPending
    JSR     WDISP_JMPTBL_ESQIFF_RunCopperDropTransition(PC)

    TST.W   D7
    BNE.S   .mode_nonzero

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    PEA     3.W
    JSR     TLIBA3_BuildDisplayContextForViewMode(PC)

    LEA     12(A7),A7
    MOVE.L  D0,WDISP_DisplayContextBase
    BRA.S   .return

.mode_nonzero:
    PEA     4.W
    CLR.L   -(A7)
    PEA     7.W
    JSR     TLIBA3_BuildDisplayContextForViewMode(PC)

    LEA     12(A7),A7
    MOVE.L  D0,WDISP_DisplayContextBase
    MOVE.L  D7,D1
    MOVEQ   #3,D2
    MULS    D2,D1
    LEA     WDISP_PaletteTriplesRBase,A0
    ADDA.L  D1,A0
    MOVE.B  (A0),WDISP_PaletteTriplesRBase
    MOVE.L  D7,D0
    MULS    D2,D0
    LEA     WDISP_PaletteTriplesGBase,A0
    ADDA.L  D0,A0
    MOVE.B  (A0),WDISP_PaletteTriplesGBase
    MOVE.L  D7,D0
    MULS    D2,D0
    LEA     WDISP_PaletteTriplesBBase,A0
    ADDA.L  D0,A0
    MOVE.B  (A0),WDISP_PaletteTriplesBBase
    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    MOVE.L  D7,D0
    EXT.L   D0
    MOVEA.L A0,A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

.return:
    MOVEM.L (A7)+,D2/D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_DrawNextEntryPreview   (Draw next preview entry)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1/A0-A1
; CALLS:
;   MATH_DivS32, TEXTDISP2_JMPTBL_LADFUNC_DrawEntryPreview
; READS:
;   LADFUNC_EntryPtrTable, LADFUNC_EntryCount
; WRITES:
;   LADFUNC_EntryCount
; DESC:
;   Advances the entry index until a valid slot is found, then draws a preview.
; NOTES:
;   Wraps via division by 46.
;------------------------------------------------------------------------------
TEXTDISP_DrawNextEntryPreview:
.loop:
    MOVE.W  LADFUNC_EntryCount,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LADFUNC_EntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVEQ   #1,D0
    CMP.W   4(A1),D0
    BEQ.S   .found_entry

    MOVE.W  LADFUNC_EntryCount,D0
    EXT.L   D0
    ADDQ.L  #1,D0
    MOVEQ   #46,D1
    JSR     MATH_DivS32(PC)

    MOVE.W  D1,LADFUNC_EntryCount
    BRA.S   .loop

.found_entry:
    MOVE.W  LADFUNC_EntryCount,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     TEXTDISP2_JMPTBL_LADFUNC_DrawEntryPreview(PC)

    ADDQ.W  #4,A7
    MOVE.W  LADFUNC_EntryCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LADFUNC_EntryCount
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
;   TEXTDISP2_JMPTBL_ESQIFF_PlayNextExternalAssetFrame, TEXTDISP_DrawNextEntryPreview, TEXTDISP_ResetSelectionAndRefresh
; READS:
;   LOCAVAIL_FilterModeFlag/1FE8/1FE9, ED_DiagGraphModeChar, WDISP_HighlightActive
; WRITES:
;   (none)
; DESC:
;   Chooses between refresh/preview paths based on mode flags and highlight state.
; NOTES:
;   Uses ED_DiagGraphModeChar == 'N' (78) gate.
;------------------------------------------------------------------------------
TEXTDISP_UpdateHighlightOrPreview:
    MOVEM.L D2/D7,-(A7)
    MOVEQ   #1,D0
    CMP.L   LOCAVAIL_FilterModeFlag,D0
    BNE.S   .mode_not_one

    MOVE.L  LOCAVAIL_FilterClassId,D1
    MOVEQ   #-1,D2
    CMP.L   D2,D1
    BNE.S   .mode_index_selected

    MOVE.L  LOCAVAIL_FilterPrevClassId,D1

.mode_index_selected:
    MOVE.L  D1,D7
    MOVE.B  ED_DiagGraphModeChar,D1
    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .check_highlight_for_mode3

    MOVEQ   #2,D1
    CMP.L   D1,D7
    BNE.S   .check_highlight_for_mode3

    MOVE.L  D0,-(A7)
    JSR     TEXTDISP2_JMPTBL_ESQIFF_PlayNextExternalAssetFrame(PC)

    ADDQ.W  #4,A7
    BRA.S   .return

.check_highlight_for_mode3:
    MOVE.W  WDISP_HighlightActive,D1
    SUBQ.W  #1,D1
    BNE.S   .do_reset_selection

    MOVEQ   #3,D1
    CMP.L   D1,D7
    BNE.S   .do_reset_selection

    BSR.W   TEXTDISP_DrawNextEntryPreview

    BRA.S   .return

.do_reset_selection:
    BSR.W   TEXTDISP_ResetSelectionAndRefresh

    BRA.S   .return

.mode_not_one:
    MOVE.B  ED_DiagGraphModeChar,D1
    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .mode_char_is_n

    MOVE.L  D0,-(A7)
    JSR     TEXTDISP2_JMPTBL_ESQIFF_PlayNextExternalAssetFrame(PC)

    ADDQ.W  #4,A7
    BRA.S   .return

.mode_char_is_n:
    MOVE.W  WDISP_HighlightActive,D1
    SUBQ.W  #1,D1
    BNE.S   .do_reset_selection_alt

    BSR.W   TEXTDISP_DrawNextEntryPreview

    BRA.S   .return

.do_reset_selection_alt:
    BSR.W   TEXTDISP_ResetSelectionAndRefresh

.return:
    MOVEM.L (A7)+,D2/D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_InitRastAndResetFlag   (Init rast + reset flag)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1/A0
; CALLS:
;   TLIBA3_BuildDisplayContextForViewMode, WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples
; READS:
;   (none)
; WRITES:
;   WDISP_DisplayContextBase, WDISP_AccumulatorFlushPending
; DESC:
;   Allocates/sets the working rastport then resets WDISP_AccumulatorFlushPending.
; NOTES:
;   Unlabeled entry in original binary; added for documentation.
;------------------------------------------------------------------------------
    PEA     3.W
    CLR.L   -(A7)
    PEA     4.W
    JSR     TLIBA3_BuildDisplayContextForViewMode(PC)

    MOVE.L  D0,WDISP_DisplayContextBase
    JSR     WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples(PC)

    LEA     12(A7),A7
    CLR.W   WDISP_AccumulatorFlushPending
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_TickDisplayState   (Tick display/control state)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D2
; CALLS:
;   TEXTDISP2_JMPTBL_LOCAVAIL_GetFilterWindowHalfSpan, SCRIPT_AssertCtrlLineIfEnabled, TEXTDISP_UpdateHighlightOrPreview,
;   TEXTDISP_ResetSelectionAndRefresh, TEXTDISP2_JMPTBL_ESQIFF_RunPendingCopperAnimations
; READS:
;   DATA_ESQ_BSS_WORD_1DF4, Global_UIBusyFlag, SCRIPT_RuntimeMode, TEXTDISP_DeferredActionCountdown, TEXTDISP_DeferredActionArmed, LOCAVAIL_FilterPrevClassId, Global_RefreshTickCounter
; WRITES:
;   DATA_WDISP_BSS_LONG_2363, DATA_WDISP_BSS_WORD_22A5, TEXTDISP_DeferredActionArmed, TEXTDISP_DeferredActionCountdown, Global_RefreshTickCounter
; DESC:
;   Updates internal display/control counters and triggers refresh/preview steps.
; NOTES:
;   Uses Global_RefreshTickCounter as a timer for periodic refresh.
;------------------------------------------------------------------------------
TEXTDISP_TickDisplayState:
    MOVE.L  D2,-(A7)
    MOVEQ   #0,D0
    MOVE.W  D0,DATA_WDISP_BSS_LONG_2363
    TST.W   DATA_ESQ_BSS_WORD_1DF4
    BNE.W   .return

    TST.W   Global_UIBusyFlag
    BNE.W   .tick_refresh_timer

    MOVE.W  SCRIPT_RuntimeMode,D1
    SUBQ.W  #2,D1
    BEQ.S   .tick_refresh_timer

    MOVE.W  TEXTDISP_DeferredActionCountdown,D1
    BEQ.S   .handle_refresh_timer

    MOVE.W  TEXTDISP_DeferredActionArmed,D2
    BEQ.S   .handle_refresh_timer

    MOVE.W  D0,TEXTDISP_DeferredActionArmed
    MOVE.W  TEXTDISP_DeferredActionCountdown,D0
    SUBQ.W  #3,D0
    BEQ.S   .assert_ctrl_and_refresh

    MOVE.W  TEXTDISP_DeferredActionCountdown,D0
    SUBQ.W  #2,D0
    BNE.S   .clear_pending_mode

.assert_ctrl_and_refresh:
    JSR     TEXTDISP2_JMPTBL_LOCAVAIL_GetFilterWindowHalfSpan(PC)

    MOVE.W  D0,DATA_WDISP_BSS_WORD_22A5
    JSR     SCRIPT_AssertCtrlLineIfEnabled(PC)

    BSR.W   TEXTDISP_UpdateHighlightOrPreview

    BRA.S   .decrement_delay_counter

.clear_pending_mode:
    MOVEQ   #-1,D0
    CMP.L   LOCAVAIL_FilterPrevClassId,D0
    BEQ.S   .decrement_delay_counter

    MOVE.L  D0,LOCAVAIL_FilterPrevClassId

.decrement_delay_counter:
    MOVE.W  TEXTDISP_DeferredActionCountdown,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   .handle_refresh_timer

    SUBQ.W  #1,D0
    MOVE.W  D0,TEXTDISP_DeferredActionCountdown

.handle_refresh_timer:
    MOVE.W  Global_RefreshTickCounter,D0
    CMPI.W  #$b4,D0
    BLT.S   .dispatch_update

    CLR.W   Global_RefreshTickCounter
    BSR.W   TEXTDISP_ResetSelectionAndRefresh

    BRA.S   .dispatch_update

.tick_refresh_timer:
    MOVE.W  Global_RefreshTickCounter,D0
    ADDQ.W  #1,D0
    BEQ.S   .dispatch_update

    CLR.W   Global_RefreshTickCounter

.dispatch_update:
    JSR     TEXTDISP2_JMPTBL_ESQIFF_RunPendingCopperAnimations(PC)

.return:
    MOVE.L  (A7)+,D2
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP2_JMPTBL_LOCAVAIL_GetFilterWindowHalfSpan   (JumpStub)
; ARGS:
;   see LOCAVAIL_GetFilterWindowHalfSpan)
; RET:
;   see LOCAVAIL_GetFilterWindowHalfSpan)
; CLOBBERS:
;   see LOCAVAIL_GetFilterWindowHalfSpan)
; CALLS:
;   LOCAVAIL_GetFilterWindowHalfSpan
; DESC:
;   Jump stub to LOCAVAIL_GetFilterWindowHalfSpan.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
TEXTDISP2_JMPTBL_LOCAVAIL_GetFilterWindowHalfSpan:
    JMP     LOCAVAIL_GetFilterWindowHalfSpan

;------------------------------------------------------------------------------
; FUNC: TEXTDISP2_JMPTBL_LADFUNC_DrawEntryPreview   (JumpStub_LADFUNC_DrawEntryPreview)
; ARGS:
;   see LADFUNC_DrawEntryPreview)
; RET:
;   see LADFUNC_DrawEntryPreview)
; CLOBBERS:
;   see LADFUNC_DrawEntryPreview)
; CALLS:
;   LADFUNC_DrawEntryPreview
; DESC:
;   Jump stub to LADFUNC_DrawEntryPreview.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
TEXTDISP2_JMPTBL_LADFUNC_DrawEntryPreview:
    JMP     LADFUNC_DrawEntryPreview

;------------------------------------------------------------------------------
; FUNC: TEXTDISP2_JMPTBL_ESQIFF_RunPendingCopperAnimations   (JumpStub)
; ARGS:
;   see ESQIFF_RunPendingCopperAnimations)
; RET:
;   see ESQIFF_RunPendingCopperAnimations)
; CLOBBERS:
;   see ESQIFF_RunPendingCopperAnimations)
; CALLS:
;   ESQIFF_RunPendingCopperAnimations
; DESC:
;   Jump stub to ESQIFF_RunPendingCopperAnimations.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
TEXTDISP2_JMPTBL_ESQIFF_RunPendingCopperAnimations:
    JMP     ESQIFF_RunPendingCopperAnimations

;------------------------------------------------------------------------------
; FUNC: TEXTDISP2_JMPTBL_ESQIFF_PlayNextExternalAssetFrame   (JumpStub)
; ARGS:
;   see ESQIFF_PlayNextExternalAssetFrame)
; RET:
;   see ESQIFF_PlayNextExternalAssetFrame)
; CLOBBERS:
;   see ESQIFF_PlayNextExternalAssetFrame)
; CALLS:
;   ESQIFF_PlayNextExternalAssetFrame
; DESC:
;   Jump stub to ESQIFF_PlayNextExternalAssetFrame.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
TEXTDISP2_JMPTBL_ESQIFF_PlayNextExternalAssetFrame:
    JMP     ESQIFF_PlayNextExternalAssetFrame
