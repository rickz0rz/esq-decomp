    XDEF    _ED1_ExitEscMenu

;------------------------------------------------------------------------------
; FUNC: _ED1_ExitEscMenu   (Restore main UI after ESC menu)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A6/A7/D0/D1/D2
; CALLS:
;   _LVOInitBitMap, _LVOSetFont, _ED1_JMPTBL_GCOMMAND_ResetHighlightMessages,
;   _GROUP_AM_JMPTBL_SCRIPT_PrimeBannerTransitionFromHexCode, _ESQFUNC_JMPTBL_LADFUNC_UpdateHighlightState, _ESQFUNC_UpdateDiskWarningAndRefreshTick, _ED1_ClearEscMenuMode, _ESQFUNC_UpdateRefreshModeState,
;   _ED1_JMPTBL_NEWGRID_DrawTopBorderLine, _ED1_JMPTBL_LADFUNC_SaveTextAdsToFile,
;   _ED1_WaitForFlagAndClearBit0, _ED1_JMPTBL_GCOMMAND_SeedBannerFromPrefs,
;   _ED_DrawBottomHelpBarBackground, _ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode, _ESQIFF_RunCopperRiseTransition
; READS:
;   _ED_SaveTextAdsOnExitFlag, _ED_SavedDiagGraphModeChar, _ED_DiagGraphModeChar, _SCRIPT_RuntimeMode
; WRITES:
;   _ED_DiagnosticsScreenActive, _SCRIPT_StatusRefreshHoldFlag, _ESQPARS2_EdDiagResetScratchFlag, _LOCAVAIL_FilterPrevClassId, _ESQIFF_GAdsBrushListCount, _SCRIPT_RuntimeMode,
;   _CTRL_BufferedByteCount, _CTRL_HPreviousSample, _CTRL_H, _Global_UIBusyFlag, _ESQPARS2_ReadModeFlags
; DESC:
;   Resets display state, refreshes banner data, and restores main screen state.
; NOTES:
;   Uses _ED_DiagGraphModeChar/_ED_SavedDiagGraphModeChar comparisons to decide whether to wait/clear flags.
;------------------------------------------------------------------------------
_ED1_ExitEscMenu:
    MOVE.L  D2,-(A7)

    CLR.W   _COI_AttentionOverlayBusyFlag

    LEA     _Global_REF_696_400_BITMAP,A0
    MOVEQ   #3,D0
    MOVE.L  #696,D1
    MOVE.L  #400,D2
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitBitMap(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1          ; rastport
    MOVEA.L _Global_HANDLE_PREVUEC_FONT,A0     ; font
    JSR     _LVOSetFont(A6)

    JSR     _ED1_JMPTBL_GCOMMAND_ResetHighlightMessages(PC)

    MOVEQ   #0,D0
    MOVE.W  D0,_ED_DiagnosticsScreenActive
    MOVE.W  D0,_SCRIPT_StatusRefreshHoldFlag
    JSR     _GROUP_AM_JMPTBL_SCRIPT_PrimeBannerTransitionFromHexCode(PC)

    CLR.W   _ESQPARS2_EdDiagResetScratchFlag
    JSR     _ESQFUNC_JMPTBL_LADFUNC_UpdateHighlightState(PC)

    JSR     _ESQFUNC_UpdateDiskWarningAndRefreshTick(PC)

    BSR.W   _ED1_ClearEscMenuMode

    MOVEQ   #1,D0
    MOVE.L  D0,_NEWGRID_RefreshStateFlag
    MOVE.L  _NEWGRID_LastRefreshRequest,-(A7)
    MOVE.L  _NEWGRID_MessagePumpSuspendFlag,-(A7)
    JSR     _ESQFUNC_UpdateRefreshModeState(PC)

    JSR     _ED1_JMPTBL_NEWGRID_DrawTopBorderLine(PC)

    ADDQ.W  #8,A7
    MOVEQ   #1,D0
    CMP.L   _ED_SaveTextAdsOnExitFlag,D0
    BNE.S   .after_optional_refresh

    JSR     _ED1_JMPTBL_LADFUNC_SaveTextAdsToFile(PC)

.after_optional_refresh:
    MOVEQ   #-1,D0
    MOVE.L  D0,_LOCAVAIL_FilterPrevClassId
    MOVE.B  _ED_SavedDiagGraphModeChar,D0
    MOVE.B  _ED_DiagGraphModeChar,D1
    CMP.B   D1,D0
    BEQ.S   .after_mode_transition

    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .check_mode_transition

    CMP.B   D2,D0
    BNE.S   .check_mode_transition

    BSR.W   _ED1_WaitForFlagAndClearBit0

.check_mode_transition:
    MOVE.B  _ED_DiagGraphModeChar,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BNE.S   .after_mode_transition

    MOVE.B  _ED_SavedDiagGraphModeChar,D0
    CMP.B   D1,D0
    BEQ.S   .after_mode_transition

    CLR.L   -(A7)
    PEA     _ESQIFF_GAdsBrushListHead
    JSR     _ESQIFF_JMPTBL_BRUSH_FreeBrushList(PC)

    ADDQ.W  #8,A7
    CLR.L   _ESQIFF_GAdsBrushListCount

.after_mode_transition:
    MOVE.W  _SCRIPT_RuntimeMode,D0
    BEQ.S   .after_pending_flag

    MOVE.W  #3,_SCRIPT_RuntimeMode

.after_pending_flag:
    MOVEQ   #0,D0
    MOVE.W  D0,_CTRL_BufferedByteCount
    MOVE.W  D0,_CTRL_HPreviousSample
    MOVE.W  D0,_CTRL_H
    MOVE.W  D0,_Global_UIBusyFlag
    JSR     _ED1_JMPTBL_GCOMMAND_SeedBannerFromPrefs(PC)

    JSR     _ED_DrawBottomHelpBarBackground(PC)

    PEA     1.W
    JSR     _ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode(PC)

    JSR     _ESQIFF_RunCopperRiseTransition(PC)

    ADDQ.W  #4,A7
    CLR.W   _ESQPARS2_ReadModeFlags

    MOVE.L  (A7)+,D2
    RTS

;!======