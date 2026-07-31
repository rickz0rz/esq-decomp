    XDEF    ED1_ExitEscMenu
    XDEF    ED1_HandleEscMenuInput
    XDEF    _ED1_EnterEscMenu
    XDEF    _ED1_EnterEscMenu_AfterVersionText
    XDEF    _ED1_UpdateEscMenuSelection

;------------------------------------------------------------------------------
; FUNC: ED1_HandleEscMenuInput   (Handle ESC menu command selectionuncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A1/A6/A7/D0/D1/D6/D7
; CALLS:
;   _ED_GetEscMenuActionCode, ED_DrawAdNumberPrompt, _ED_DrawDiagnosticModeHelpText, _ED_DrawMenuSelectionHighlight, _ED_DrawScrollSpeedMenuText, _ED_DrawBottomHelpBarBackground, ED_DrawEscMainMenuText,
;   _ED1_DrawDiagnosticsScreen, _ED_DrawSpecialFunctionsMenu,
;   _DISPLIB_DisplayTextAtPosition, _LVOSetAPen
; READS:
;   _ED_DiagTextModeChar, _ED_SavedScrollSpeedIndex, _ED_EditCursorOffset
; WRITES:
;   _ED_MenuStateId, _ED_EditCursorOffset, _ESQ_ShutdownRequestedFlag
; DESC:
;   Dispatches ESC-menu commands, updates selection state, and shows errors.
; NOTES:
;   Uses a switch/jumptable; D6 nonzero triggers an error prompt.
;------------------------------------------------------------------------------
ED1_HandleEscMenuInput:
    MOVEM.L D6-D7,-(A7)
    JSR     _ED_GetEscMenuActionCode(PC)

    MOVE.L  D0,D7
    MOVEQ   #0,D6
    MOVE.B  D7,D0
    EXT.W   D0
    CMPI.W  #9,D0
    BCC.W   .adjust_selection

    ADD.W   D0,D0
    MOVE.W  .dispatch_table(PC,D0.W),D0
    JMP     .dispatch_table+2(PC,D0.W)

; switch/jumptable
.dispatch_table:
    DC.W    .case_show_version-.dispatch_table-2
    DC.W    .case_set_mode_2-.dispatch_table-2
    DC.W    .case_set_mode_3-.dispatch_table-2
	DC.W    .case_mode_6-.dispatch_table-2
    DC.W    .case_diagnostics-.dispatch_table-2
    DC.W    .case_special_functions-.dispatch_table-2
	DC.W    .case_mode_8-.dispatch_table-2
    DC.W    .case_adjust_selection-.dispatch_table-2
    DC.W    .case_set_flag-.dispatch_table-2

.case_show_version:
    BSR.W   *+(_ED1_EnterEscMenu_AfterVersionText-.dispatch_table+2)

    BRA.W   .done

.case_set_mode_2:
    MOVE.B  _ED_DiagTextModeChar,D0
    MOVEQ   #76,D1
    CMP.B   D1,D0
    BNE.S   .case_mode_2_unavailable

    JSR     ED_DrawAdNumberPrompt(PC)

    MOVE.B  #$2,_ED_MenuStateId
    BRA.W   .done

.case_mode_2_unavailable:
    MOVEQ   #1,D6
    BRA.W   .done

.case_set_mode_3:
    MOVE.B  _ED_DiagTextModeChar,D0
    MOVEQ   #76,D1
    CMP.B   D1,D0
    BNE.S   .case_mode_3_unavailable

    JSR     ED_DrawAdNumberPrompt(PC)

    MOVE.B  #$3,_ED_MenuStateId
    BRA.W   .done

.case_mode_3_unavailable:
    MOVEQ   #1,D6
    BRA.W   .done

.case_mode_6:
    MOVE.B  #$6,_ED_MenuStateId
    JSR     _ED_DrawDiagnosticModeHelpText(PC)

    MOVE.L  _ED_SavedScrollSpeedIndex,_ED_EditCursorOffset
    PEA     9.W
    JSR     _ED_DrawMenuSelectionHighlight(PC)

    JSR     _ED_DrawScrollSpeedMenuText(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D6
    BRA.S   .done

.case_diagnostics:
    BSR.W   _ED1_DrawDiagnosticsScreen

    BRA.S   .done

.case_special_functions:
    MOVE.B  #$a,_ED_MenuStateId
    JSR     _ED_DrawDiagnosticModeHelpText(PC)

    CLR.L   _ED_EditCursorOffset
    PEA     4.W
    JSR     _ED_DrawMenuSelectionHighlight(PC)

    JSR     _ED_DrawSpecialFunctionsMenu(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D6
    BRA.S   .done

.case_mode_8:
    MOVE.B  #$8,_ED_MenuStateId
    JSR     _ED_DrawBottomHelpBarBackground(PC)

    BRA.S   .done

.case_set_flag:
    MOVE.W  #1,_ESQ_ShutdownRequestedFlag
    BRA.S   .done

.case_adjust_selection:
.adjust_selection:
    MOVEQ   #9,D0
    CMP.B   D0,D7
    BNE.S   .adjust_step_small

    MOVEQ   #5,D0
    BRA.S   .adjust_apply

.adjust_step_small:
    MOVEQ   #1,D0

.adjust_apply:
    ADD.L   D0,_ED_EditCursorOffset
    MOVE.L  _ED_EditCursorOffset,D0
    MOVEQ   #6,D1
    JSR     ESQIFF_JMPTBL_MATH_DivS32(PC)

    MOVE.L  D1,_ED_EditCursorOffset
    JSR     ED_DrawEscMainMenuText(PC)

.done:
    TST.B   D6
    BEQ.S   .return

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #4,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVE.B  D6,D0
    EXT.W   D0
    SUBQ.W  #1,D0
    BNE.S   .draw_error

    PEA     ED2_STR_LOCAL_EDIT_NOT_AVAILABLE
    PEA     270.W
    PEA     145.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7

.draw_error:
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

.return:
    MOVEM.L (A7)+,D6-D7
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: _ED1_UpdateEscMenuSelection   (Update ESC menu selection stateuncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/D0/D1
; CALLS:
;   _ED_DrawESCMenuBottomHelp
; READS:
;   _ED_StateRingIndex, _ED_StateRingTable
; WRITES:
;   _ED_LastKeyCode, _ED_DiagnosticsScreenActive
; DESC:
;   Loads a menu selection value from table and refreshes bottom help.
; NOTES:
;   Clears _ED_DiagnosticsScreenActive when selection is not the first entry.
;------------------------------------------------------------------------------
_ED1_UpdateEscMenuSelection:
    MOVE.L  _ED_StateRingIndex,D0
    LSL.L   #2,D0
    ADD.L   _ED_StateRingIndex,D0
    LEA     _ED_StateRingTable,A0
    ADDA.L  D0,A0
    MOVE.B  (A0),D0
    MOVE.B  D0,_ED_LastKeyCode
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    SUBI.W  #$31,D1
    BEQ.S   .return

    JSR     _ED_DrawESCMenuBottomHelp(PC)

    CLR.W   _ED_DiagnosticsScreenActive

.return:
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: _ED1_EnterEscMenu   (Initialize ESC menu screen/state)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A6/A7/D0/D1/D2/D7
; CALLS:
;   _LVOSetFont, _LVOInitBitMap, _LVOSetRast, _LVOSetDrMd, _LVODisable, _LVOEnable,
;   _GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte, _GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight,
;   _ED1_JMPTBL_GCOMMAND_SeedBannerDefaults, _ED_DrawESCMenuBottomHelp,
;   _GROUP_AM_JMPTBL_WDISP_SPrintf, _ED1_JMPTBL_CLEANUP_DrawDateTimeBannerRow,
;   _DISPLIB_DisplayTextAtPosition, _ESQIFF_RunCopperDropTransition, _ESQIFF_RunCopperRiseTransition
; READS:
;   _ESQ_TAG_36, _ED_DiagScrollSpeedChar, _KYBD_CustomPaletteTriplesRBase, _ED_DiagGraphModeChar, _ED_SaveTextAdsOnExitFlag
; WRITES:
;   _Global_UIBusyFlag, _ED_SavedDiagGraphModeChar, _ED_SaveTextAdsOnExitFlag, _ED_MaxAdNumber, _ED_TextLimit, _ED_BlockOffset,
;   _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER, _WDISP_PaletteTriplesRBase
; DESC:
;   Prepares the ESC menu UI, computes layout values, and draws the version row.
; NOTES:
;   Copies 24 bytes from _KYBD_CustomPaletteTriplesRBase into _WDISP_PaletteTriplesRBase.
;   Local version buffer is 41 bytes (-41(A5)..-1(A5)); _WDISP_SPrintf has no
;   destination-length parameter, so format/string edits must keep headroom.
;------------------------------------------------------------------------------
_ED1_EnterEscMenu:

.versionBanner   = -41

    LINK.W  A5,#-48
    MOVEM.L D2/D7,-(A7)

    MOVE.W  #1,_Global_UIBusyFlag
    MOVE.B  _ED_DiagGraphModeChar,D0
    MOVE.B  D0,_ED_SavedDiagGraphModeChar
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEA.L _Global_HANDLE_H26F_FONT,A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    LEA     _Global_REF_696_400_BITMAP,A0
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVE.L  A0,4(A1)
    MOVEQ   #3,D0
    MOVE.L  #696,D1
    MOVE.L  #509,D2
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitBitMap(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    JSR     _LVOSetRast(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    JSR     _ESQIFF_RunCopperDropTransition(PC)

    MOVEQ   #0,D7

.copy_template_loop:
    MOVEQ   #24,D0
    CMP.L   D0,D7
    BGE.S   .after_copy_template

    LEA     _WDISP_PaletteTriplesRBase,A0
    ADDA.L  D7,A0
    LEA     _KYBD_CustomPaletteTriplesRBase,A1
    ADDA.L  D7,A1
    MOVE.B  (A1),(A0)
    ADDQ.L  #1,D7
    BRA.S   .copy_template_loop

.after_copy_template:
    MOVEA.L AbsExecBase,A6
    JSR     _LVODisable(A6)

    MOVE.W  #$100,_ESQPARS2_ReadModeFlags
    CLR.W   _ESQSHARED_BannerColorModeWord
    PEA     3.W
    JSR     _GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte(PC)

    JSR     _GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight(PC)

    CLR.L   _ED_SaveTextAdsOnExitFlag
    JSR     _ED1_JMPTBL_GCOMMAND_SeedBannerDefaults(PC)

    ADDQ.W  #4,A7
    MOVEA.L AbsExecBase,A6
    JSR     _LVOEnable(A6)

    MOVEQ   #0,D0
    MOVE.B  _ESQ_TAG_36,D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVEQ   #10,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    MOVEQ   #0,D1
    MOVE.B  _ESQ_TAG_36+1,D1
    ADD.L   D1,D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVE.L  D0,_ED_MaxAdNumber
    MOVEQ   #0,D0
    MOVE.B  _ED_DiagScrollSpeedChar,D0
    SUB.L   D1,D0
    MOVE.L  D0,_ED_TextLimit
    MOVEQ   #6,D1
    CMP.L   D1,D0
    BLE.S   .clamp_minor_version

    MOVE.L  D1,_ED_TextLimit
    MOVE.B  #$36,_ED_DiagScrollSpeedChar

.clamp_minor_version:
    MOVE.L  _ED_TextLimit,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  D0,_ED_BlockOffset
    MOVEQ   #1,D0
    MOVE.L  D0,_Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
    JSR     _ED_DrawESCMenuBottomHelp(PC)

    ; 41-byte local buffer, reused for centered version row text.
    MOVE.L  _Global_LONG_PATCH_VERSION_NUMBER,-(A7)
    PEA     _Global_STR_NINE_POINT_ZERO
    PEA     _Global_STR_VER_PERCENT_S_PERCENT_L_D
    PEA     .versionBanner(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    JSR     _ED1_JMPTBL_CLEANUP_DrawDateTimeBannerRow(PC)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #3,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEA.L 52(A1),A0
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    MOVEQ   #34,D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .center_version_text

    ADDQ.L  #1,D1

.center_version_text:
    ASR.L   #1,D1
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    ADD.L   D0,D1
    MOVEQ   #33,D0
    ADD.L   D0,D1
    PEA     .versionBanner(A5)
    MOVE.L  D1,-(A7)
    PEA     280.W
    MOVE.L  A1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    JSR     _ESQIFF_RunCopperRiseTransition(PC)

;------------------------------------------------------------------------------
; FUNC: _ED1_EnterEscMenu_AfterVersionText   (Routine at _ED1_EnterEscMenu_AfterVersionText)
; ARGS:
;   stack +52: arg_1 (via 56(A5))
; RET:
;   D0: none observed
; CLOBBERS:
;   D2
; CALLS:
;   _ED1_JMPTBL_LOCAVAIL_ResetFilterCursorState
; READS:
;   _LOCAVAIL_PrimaryFilterState
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_ED1_EnterEscMenu_AfterVersionText:
    PEA     _LOCAVAIL_PrimaryFilterState
    JSR     _ED1_JMPTBL_LOCAVAIL_ResetFilterCursorState(PC)

    MOVEM.L -56(A5),D2/D7
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: ED1_ExitEscMenu   (Restore main UI after ESC menu)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A6/A7/D0/D1/D2
; CALLS:
;   _LVOInitBitMap, _LVOSetFont, ED1_JMPTBL_GCOMMAND_ResetHighlightMessages,
;   _GROUP_AM_JMPTBL_SCRIPT_PrimeBannerTransitionFromHexCode, _ESQFUNC_JMPTBL_LADFUNC_UpdateHighlightState, _ESQFUNC_UpdateDiskWarningAndRefreshTick, _ED1_ClearEscMenuMode, _ESQFUNC_UpdateRefreshModeState,
;   ED1_JMPTBL_NEWGRID_DrawTopBorderLine, ED1_JMPTBL_LADFUNC_SaveTextAdsToFile,
;   _ED1_WaitForFlagAndClearBit0, ED1_JMPTBL_GCOMMAND_SeedBannerFromPrefs,
;   _ED_DrawBottomHelpBarBackground, _ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode, _ESQIFF_RunCopperRiseTransition
; READS:
;   _ED_SaveTextAdsOnExitFlag, _ED_SavedDiagGraphModeChar, _ED_DiagGraphModeChar, _SCRIPT_RuntimeMode
; WRITES:
;   _ED_DiagnosticsScreenActive, _SCRIPT_StatusRefreshHoldFlag, ESQPARS2_EdDiagResetScratchFlag, _LOCAVAIL_FilterPrevClassId, _ESQIFF_GAdsBrushListCount, _SCRIPT_RuntimeMode,
;   _CTRL_BufferedByteCount, _CTRL_HPreviousSample, _CTRL_H, _Global_UIBusyFlag, _ESQPARS2_ReadModeFlags
; DESC:
;   Resets display state, refreshes banner data, and restores main screen state.
; NOTES:
;   Uses _ED_DiagGraphModeChar/_ED_SavedDiagGraphModeChar comparisons to decide whether to wait/clear flags.
;------------------------------------------------------------------------------
ED1_ExitEscMenu:
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

    JSR     ED1_JMPTBL_GCOMMAND_ResetHighlightMessages(PC)

    MOVEQ   #0,D0
    MOVE.W  D0,_ED_DiagnosticsScreenActive
    MOVE.W  D0,_SCRIPT_StatusRefreshHoldFlag
    JSR     _GROUP_AM_JMPTBL_SCRIPT_PrimeBannerTransitionFromHexCode(PC)

    CLR.W   ESQPARS2_EdDiagResetScratchFlag
    JSR     _ESQFUNC_JMPTBL_LADFUNC_UpdateHighlightState(PC)

    JSR     _ESQFUNC_UpdateDiskWarningAndRefreshTick(PC)

    BSR.W   _ED1_ClearEscMenuMode

    MOVEQ   #1,D0
    MOVE.L  D0,_NEWGRID_RefreshStateFlag
    MOVE.L  NEWGRID_LastRefreshRequest,-(A7)
    MOVE.L  _NEWGRID_MessagePumpSuspendFlag,-(A7)
    JSR     _ESQFUNC_UpdateRefreshModeState(PC)

    JSR     ED1_JMPTBL_NEWGRID_DrawTopBorderLine(PC)

    ADDQ.W  #8,A7
    MOVEQ   #1,D0
    CMP.L   _ED_SaveTextAdsOnExitFlag,D0
    BNE.S   .after_optional_refresh

    JSR     ED1_JMPTBL_LADFUNC_SaveTextAdsToFile(PC)

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
    JSR     ED1_JMPTBL_GCOMMAND_SeedBannerFromPrefs(PC)

    JSR     _ED_DrawBottomHelpBarBackground(PC)

    PEA     1.W
    JSR     _ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode(PC)

    JSR     _ESQIFF_RunCopperRiseTransition(PC)

    ADDQ.W  #4,A7
    CLR.W   _ESQPARS2_ReadModeFlags

    MOVE.L  (A7)+,D2
    RTS

;!======
