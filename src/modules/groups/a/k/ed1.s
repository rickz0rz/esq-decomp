;------------------------------------------------------------------------------
; FUNC: ED1_HandleEscMenuInput   (Handle ESC menu command selectionuncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A1/A6/A7/D0/D1/D6/D7
; CALLS:
;   ED_GetEscMenuActionCode, ED_DrawAdNumberPrompt, ED_DrawDiagnosticModeHelpText, ED_DrawMenuSelectionHighlight, ED_DrawScrollSpeedMenuText, ED_DrawBottomHelpBarBackground, ED_DrawEscMainMenuText,
;   ED1_DrawDiagnosticsScreen, ED_DrawSpecialFunctionsMenu,
;   DISPLIB_DisplayTextAtPosition, _LVOSetAPen
; READS:
;   ED_DiagTextModeChar, ED_SavedScrollSpeedIndex, ED_EditCursorOffset
; WRITES:
;   ED_MenuStateId, ED_EditCursorOffset, DATA_ESQ_BSS_WORD_1DE4
; DESC:
;   Dispatches ESC-menu commands, updates selection state, and shows errors.
; NOTES:
;   Uses a switch/jumptable; D6 nonzero triggers an error prompt.
;------------------------------------------------------------------------------
ED1_HandleEscMenuInput:
    MOVEM.L D6-D7,-(A7)
    JSR     ED_GetEscMenuActionCode(PC)

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
    BSR.W   *+(ED1_EnterEscMenu_AfterVersionText-.dispatch_table+2)

    BRA.W   .done

.case_set_mode_2:
    MOVE.B  ED_DiagTextModeChar,D0
    MOVEQ   #76,D1
    CMP.B   D1,D0
    BNE.S   .case_mode_2_unavailable

    JSR     ED_DrawAdNumberPrompt(PC)

    MOVE.B  #$2,ED_MenuStateId
    BRA.W   .done

.case_mode_2_unavailable:
    MOVEQ   #1,D6
    BRA.W   .done

.case_set_mode_3:
    MOVE.B  ED_DiagTextModeChar,D0
    MOVEQ   #76,D1
    CMP.B   D1,D0
    BNE.S   .case_mode_3_unavailable

    JSR     ED_DrawAdNumberPrompt(PC)

    MOVE.B  #$3,ED_MenuStateId
    BRA.W   .done

.case_mode_3_unavailable:
    MOVEQ   #1,D6
    BRA.W   .done

.case_mode_6:
    MOVE.B  #$6,ED_MenuStateId
    JSR     ED_DrawDiagnosticModeHelpText(PC)

    MOVE.L  ED_SavedScrollSpeedIndex,ED_EditCursorOffset
    PEA     9.W
    JSR     ED_DrawMenuSelectionHighlight(PC)

    JSR     ED_DrawScrollSpeedMenuText(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D6
    BRA.S   .done

.case_diagnostics:
    BSR.W   ED1_DrawDiagnosticsScreen

    BRA.S   .done

.case_special_functions:
    MOVE.B  #$a,ED_MenuStateId
    JSR     ED_DrawDiagnosticModeHelpText(PC)

    CLR.L   ED_EditCursorOffset
    PEA     4.W
    JSR     ED_DrawMenuSelectionHighlight(PC)

    JSR     ED_DrawSpecialFunctionsMenu(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D6
    BRA.S   .done

.case_mode_8:
    MOVE.B  #$8,ED_MenuStateId
    JSR     ED_DrawBottomHelpBarBackground(PC)

    BRA.S   .done

.case_set_flag:
    MOVE.W  #1,DATA_ESQ_BSS_WORD_1DE4
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
    ADD.L   D0,ED_EditCursorOffset
    MOVE.L  ED_EditCursorOffset,D0
    MOVEQ   #6,D1
    JSR     ESQIFF_JMPTBL_MATH_DivS32(PC)

    MOVE.L  D1,ED_EditCursorOffset
    JSR     ED_DrawEscMainMenuText(PC)

.done:
    TST.B   D6
    BEQ.S   .return

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #4,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVE.B  D6,D0
    EXT.W   D0
    SUBQ.W  #1,D0
    BNE.S   .draw_error

    PEA     DATA_ED2_STR_LOCAL_EDIT_NOT_AVAILABLE_1D29
    PEA     270.W
    PEA     145.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7

.draw_error:
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

.return:
    MOVEM.L (A7)+,D6-D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED1_UpdateEscMenuSelection   (Update ESC menu selection stateuncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/D0/D1
; CALLS:
;   ED_DrawESCMenuBottomHelp
; READS:
;   ED_StateRingIndex, ED_StateRingTable
; WRITES:
;   ED_LastKeyCode, ED_DiagnosticsScreenActive
; DESC:
;   Loads a menu selection value from table and refreshes bottom help.
; NOTES:
;   Clears ED_DiagnosticsScreenActive when selection is not the first entry.
;------------------------------------------------------------------------------
ED1_UpdateEscMenuSelection:
    MOVE.L  ED_StateRingIndex,D0
    LSL.L   #2,D0
    ADD.L   ED_StateRingIndex,D0
    LEA     ED_StateRingTable,A0
    ADDA.L  D0,A0
    MOVE.B  (A0),D0
    MOVE.B  D0,ED_LastKeyCode
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    SUBI.W  #$31,D1
    BEQ.S   .return

    JSR     ED_DrawESCMenuBottomHelp(PC)

    CLR.W   ED_DiagnosticsScreenActive

.return:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED1_EnterEscMenu   (Initialize ESC menu screen/state)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A6/A7/D0/D1/D2/D7
; CALLS:
;   _LVOSetFont, _LVOInitBitMap, _LVOSetRast, _LVOSetDrMd, _LVODisable, _LVOEnable,
;   GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte, GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight,
;   ED1_JMPTBL_GCOMMAND_SeedBannerDefaults, ED_DrawESCMenuBottomHelp,
;   GROUP_AM_JMPTBL_WDISP_SPrintf, ED1_JMPTBL_CLEANUP_DrawDateTimeBannerRow,
;   DISPLIB_DisplayTextAtPosition, ESQIFF_RunCopperDropTransition, ESQIFF_RunCopperRiseTransition
; READS:
;   DATA_ESQ_TAG_36_1DCB, ED_DiagScrollSpeedChar, DATA_KYBD_BSS_BYTE_1FB8, ED_DiagGraphModeChar, ED_SaveTextAdsOnExitFlag
; WRITES:
;   Global_UIBusyFlag, ED_SavedDiagGraphModeChar, ED_SaveTextAdsOnExitFlag, DATA_WDISP_BSS_LONG_21FD, ED_TextLimit, ED_BlockOffset,
;   Global_REF_LONG_CURRENT_EDITING_AD_NUMBER, WDISP_PaletteTriplesRBase
; DESC:
;   Prepares the ESC menu UI, computes layout values, and draws the version row.
; NOTES:
;   Copies 24 bytes from DATA_KYBD_BSS_BYTE_1FB8 into WDISP_PaletteTriplesRBase.
;------------------------------------------------------------------------------
ED1_EnterEscMenu:
    LINK.W  A5,#-48
    MOVEM.L D2/D7,-(A7)

    MOVE.W  #1,Global_UIBusyFlag
    MOVE.B  ED_DiagGraphModeChar,D0
    MOVE.B  D0,ED_SavedDiagGraphModeChar
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEA.L Global_HANDLE_H26F_FONT,A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    LEA     Global_REF_696_400_BITMAP,A0
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVE.L  A0,4(A1)
    MOVEQ   #3,D0
    MOVE.L  #696,D1
    MOVE.L  #509,D2
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitBitMap(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    JSR     _LVOSetRast(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    JSR     ESQIFF_RunCopperDropTransition(PC)

    MOVEQ   #0,D7

.copy_template_loop:
    MOVEQ   #24,D0
    CMP.L   D0,D7
    BGE.S   .after_copy_template

    LEA     WDISP_PaletteTriplesRBase,A0
    ADDA.L  D7,A0
    LEA     DATA_KYBD_BSS_BYTE_1FB8,A1
    ADDA.L  D7,A1
    MOVE.B  (A1),(A0)
    ADDQ.L  #1,D7
    BRA.S   .copy_template_loop

.after_copy_template:
    MOVEA.L AbsExecBase,A6
    JSR     _LVODisable(A6)

    MOVE.W  #$100,ESQPARS2_ReadModeFlags
    CLR.W   DATA_WDISP_BSS_WORD_226D
    PEA     3.W
    JSR     GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte(PC)

    JSR     GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight(PC)

    CLR.L   ED_SaveTextAdsOnExitFlag
    JSR     ED1_JMPTBL_GCOMMAND_SeedBannerDefaults(PC)

    ADDQ.W  #4,A7
    MOVEA.L AbsExecBase,A6
    JSR     _LVOEnable(A6)

    MOVEQ   #0,D0
    MOVE.B  DATA_ESQ_TAG_36_1DCB,D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVEQ   #10,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    MOVEQ   #0,D1
    MOVE.B  DATA_ESQ_TAG_36_1DCB+1,D1
    ADD.L   D1,D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVE.L  D0,DATA_WDISP_BSS_LONG_21FD
    MOVEQ   #0,D0
    MOVE.B  ED_DiagScrollSpeedChar,D0
    SUB.L   D1,D0
    MOVE.L  D0,ED_TextLimit
    MOVEQ   #6,D1
    CMP.L   D1,D0
    BLE.S   .clamp_minor_version

    MOVE.L  D1,ED_TextLimit
    MOVE.B  #$36,ED_DiagScrollSpeedChar

.clamp_minor_version:
    MOVE.L  ED_TextLimit,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  D0,ED_BlockOffset
    MOVEQ   #1,D0
    MOVE.L  D0,Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
    JSR     ED_DrawESCMenuBottomHelp(PC)

    MOVE.L  Global_LONG_PATCH_VERSION_NUMBER,-(A7)
    PEA     Global_STR_NINE_POINT_ZERO
    PEA     Global_STR_VER_PERCENT_S_PERCENT_L_D
    PEA     -41(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    JSR     ED1_JMPTBL_CLEANUP_DrawDateTimeBannerRow(PC)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #3,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
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
    PEA     -41(A5)
    MOVE.L  D1,-(A7)
    PEA     280.W
    MOVE.L  A1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    JSR     ESQIFF_RunCopperRiseTransition(PC)

;------------------------------------------------------------------------------
; FUNC: ED1_EnterEscMenu_AfterVersionText   (Routine at ED1_EnterEscMenu_AfterVersionText)
; ARGS:
;   stack +52: arg_1 (via 56(A5))
; RET:
;   D0: none observed
; CLOBBERS:
;   D2
; CALLS:
;   ED1_JMPTBL_LOCAVAIL_ResetFilterCursorState
; READS:
;   LOCAVAIL_PrimaryFilterState
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ED1_EnterEscMenu_AfterVersionText:
    PEA     LOCAVAIL_PrimaryFilterState
    JSR     ED1_JMPTBL_LOCAVAIL_ResetFilterCursorState(PC)

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
;   GROUP_AM_JMPTBL_SCRIPT_PrimeBannerTransitionFromHexCode, ESQFUNC_JMPTBL_LADFUNC_UpdateHighlightState, ESQFUNC_UpdateDiskWarningAndRefreshTick, ED1_ClearEscMenuMode, ESQFUNC_UpdateRefreshModeState,
;   ED1_JMPTBL_NEWGRID_DrawTopBorderLine, ED1_JMPTBL_LADFUNC_SaveTextAdsToFile,
;   ED1_WaitForFlagAndClearBit0, ED1_JMPTBL_GCOMMAND_SeedBannerFromPrefs,
;   ED_DrawBottomHelpBarBackground, ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode, ESQIFF_RunCopperRiseTransition
; READS:
;   ED_SaveTextAdsOnExitFlag, ED_SavedDiagGraphModeChar, ED_DiagGraphModeChar, SCRIPT_RuntimeMode
; WRITES:
;   ED_DiagnosticsScreenActive, DATA_ESQ_BSS_WORD_1DF3, DATA_ESQPARS2_BSS_WORD_1F3C, LOCAVAIL_FilterPrevClassId, ESQIFF_GAdsBrushListCount, SCRIPT_RuntimeMode,
;   DATA_WDISP_BSS_WORD_2284, CTRL_HPreviousSample, CTRL_H, Global_UIBusyFlag, ESQPARS2_ReadModeFlags
; DESC:
;   Resets display state, refreshes banner data, and restores main screen state.
; NOTES:
;   Uses ED_DiagGraphModeChar/ED_SavedDiagGraphModeChar comparisons to decide whether to wait/clear flags.
;------------------------------------------------------------------------------
ED1_ExitEscMenu:
    MOVE.L  D2,-(A7)

    CLR.W   DATA_COI_BSS_WORD_1B85

    LEA     Global_REF_696_400_BITMAP,A0
    MOVEQ   #3,D0
    MOVE.L  #696,D1
    MOVE.L  #400,D2
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitBitMap(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1          ; rastport
    MOVEA.L Global_HANDLE_PREVUEC_FONT,A0     ; font
    JSR     _LVOSetFont(A6)

    JSR     ED1_JMPTBL_GCOMMAND_ResetHighlightMessages(PC)

    MOVEQ   #0,D0
    MOVE.W  D0,ED_DiagnosticsScreenActive
    MOVE.W  D0,DATA_ESQ_BSS_WORD_1DF3
    JSR     GROUP_AM_JMPTBL_SCRIPT_PrimeBannerTransitionFromHexCode(PC)

    CLR.W   DATA_ESQPARS2_BSS_WORD_1F3C
    JSR     ESQFUNC_JMPTBL_LADFUNC_UpdateHighlightState(PC)

    JSR     ESQFUNC_UpdateDiskWarningAndRefreshTick(PC)

    BSR.W   ED1_ClearEscMenuMode

    MOVEQ   #1,D0
    MOVE.L  D0,NEWGRID_RefreshStateFlag
    MOVE.L  DATA_WDISP_BSS_LONG_2262,-(A7)
    MOVE.L  DATA_WDISP_BSS_LONG_2260,-(A7)
    JSR     ESQFUNC_UpdateRefreshModeState(PC)

    JSR     ED1_JMPTBL_NEWGRID_DrawTopBorderLine(PC)

    ADDQ.W  #8,A7
    MOVEQ   #1,D0
    CMP.L   ED_SaveTextAdsOnExitFlag,D0
    BNE.S   .after_optional_refresh

    JSR     ED1_JMPTBL_LADFUNC_SaveTextAdsToFile(PC)

.after_optional_refresh:
    MOVEQ   #-1,D0
    MOVE.L  D0,LOCAVAIL_FilterPrevClassId
    MOVE.B  ED_SavedDiagGraphModeChar,D0
    MOVE.B  ED_DiagGraphModeChar,D1
    CMP.B   D1,D0
    BEQ.S   .after_mode_transition

    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .check_mode_transition

    CMP.B   D2,D0
    BNE.S   .check_mode_transition

    BSR.W   ED1_WaitForFlagAndClearBit0

.check_mode_transition:
    MOVE.B  ED_DiagGraphModeChar,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BNE.S   .after_mode_transition

    MOVE.B  ED_SavedDiagGraphModeChar,D0
    CMP.B   D1,D0
    BEQ.S   .after_mode_transition

    CLR.L   -(A7)
    PEA     ESQIFF_GAdsBrushListHead
    JSR     ESQIFF_JMPTBL_BRUSH_FreeBrushList(PC)

    ADDQ.W  #8,A7
    CLR.L   ESQIFF_GAdsBrushListCount

.after_mode_transition:
    MOVE.W  SCRIPT_RuntimeMode,D0
    BEQ.S   .after_pending_flag

    MOVE.W  #3,SCRIPT_RuntimeMode

.after_pending_flag:
    MOVEQ   #0,D0
    MOVE.W  D0,DATA_WDISP_BSS_WORD_2284
    MOVE.W  D0,CTRL_HPreviousSample
    MOVE.W  D0,CTRL_H
    MOVE.W  D0,Global_UIBusyFlag
    JSR     ED1_JMPTBL_GCOMMAND_SeedBannerFromPrefs(PC)

    JSR     ED_DrawBottomHelpBarBackground(PC)

    PEA     1.W
    JSR     ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode(PC)

    JSR     ESQIFF_RunCopperRiseTransition(PC)

    ADDQ.W  #4,A7
    CLR.W   ESQPARS2_ReadModeFlags

    MOVE.L  (A7)+,D2
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED1_DrawDiagnosticsScreen   (Render diagnostic mode screen)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A1/A6/A7/D0
; CALLS:
;   ED_DrawBottomHelpBarBackground, DISPLIB_DisplayTextAtPosition, GROUP_AM_JMPTBL_WDISP_SPrintf,
;   DISKIO_QueryDiskUsagePercentAndSetBufferSize, DISKIO_QueryVolumeSoftErrorCount, ED_DrawDiagnosticModeText, _LVOSetAPen
; READS:
;   Global_REF_BAUD_RATE, DATA_ED2_BSS_WORD_1D2E, DATA_ED2_BSS_WORD_1D2F, DATA_WDISP_BSS_LONG_2245
; WRITES:
;   ED_MenuStateId, ED_DiagnosticsScreenActive
; DESC:
;   Draws diagnostic-mode text blocks and prompts on the ESC menu screen.
; NOTES:
;   Uses local printf buffer at -41(A5).
;------------------------------------------------------------------------------
ED1_DrawDiagnosticsScreen:

.printfResult   = -41

    LINK.W  A5,#-48

    MOVE.B  #$7,ED_MenuStateId
    MOVE.W  #1,ED_DiagnosticsScreenActive

    JSR     ED_DrawBottomHelpBarBackground(PC)

    PEA     Global_PTR_STR_SELECT_CODE
    PEA     360.W
    PEA     90.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     DATA_WDISP_BSS_LONG_2245    ; I have no idea what this text is...
    PEA     360.W
    PEA     210.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    MOVE.L  Global_REF_BAUD_RATE,(A7)
    PEA     Global_STR_BAUD_RATE_DIAGNOSTIC_MODE
    PEA     .printfResult(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     .printfResult(A5)
    PEA     360.W
    PEA     410.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     DATA_ED2_BSS_WORD_1D2E
    JSR     DISKIO_QueryDiskUsagePercentAndSetBufferSize(PC)

    PEA     DATA_ED2_BSS_WORD_1D2F
    MOVE.L  D0,64(A7)
    JSR     DISKIO_QueryVolumeSoftErrorCount(PC)

    MOVE.L  D0,(A7)
    MOVE.L  64(A7),-(A7)
    PEA     Global_STR_DISK_0_IS_VAR_FULL_WITH_VAR_ERRORS
    PEA     .printfResult(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    LEA     76(A7),A7
    PEA     .printfResult(A5)
    PEA     88.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    JSR     ED_DrawDiagnosticModeText(PC)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #6,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    PEA     Global_STR_PUSH_ANY_KEY_TO_CONTINUE_2
    PEA     390.W
    PEA     175.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED1_ClearEscMenuMode   (Clear ESC menu mode flag)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   none
; READS:
;   (none)
; WRITES:
;   ED_MenuStateId
; DESC:
;   Clears the current ESC menu mode/state byte.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
ED1_ClearEscMenuMode:
    CLR.B   ED_MenuStateId
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED1_WaitForFlagAndClearBit1   (Wait for flag and clear bit 1)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0
; CALLS:
;   ESQIFF_ReloadExternalAssetCatalogBuffers
; READS:
;   CTASKS_IffTaskDoneFlag, ESQIFF_ExternalAssetFlags
; WRITES:
;   LADFUNC_EntryCount, ESQIFF_ExternalAssetFlags
; DESC:
;   Busy-waits for CTASKS_IffTaskDoneFlag then clears bit 1 in ESQIFF_ExternalAssetFlags and signals.
; NOTES:
;   Passes 0 to ESQIFF_ReloadExternalAssetCatalogBuffers.
;------------------------------------------------------------------------------
ED1_WaitForFlagAndClearBit1:
.wait_flag:
    TST.W   CTASKS_IffTaskDoneFlag
    BEQ.S   .wait_flag

    MOVE.W  #$2e,LADFUNC_EntryCount
    MOVE.W  ESQIFF_ExternalAssetFlags,D0
    ANDI.W  #$fffd,D0
    MOVE.W  D0,ESQIFF_ExternalAssetFlags
    CLR.L   -(A7)
    JSR     ESQIFF_ReloadExternalAssetCatalogBuffers(PC)

    ADDQ.W  #4,A7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED1_WaitForFlagAndClearBit0   (Wait for flag and clear bit 0)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0
; CALLS:
;   ESQIFF_ReloadExternalAssetCatalogBuffers
; READS:
;   CTASKS_IffTaskDoneFlag, ESQIFF_ExternalAssetFlags
; WRITES:
;   LADFUNC_EntryCount, ESQIFF_ExternalAssetFlags
; DESC:
;   Busy-waits for CTASKS_IffTaskDoneFlag then clears bit 0 in ESQIFF_ExternalAssetFlags and signals.
; NOTES:
;   Passes 1 to ESQIFF_ReloadExternalAssetCatalogBuffers.
;------------------------------------------------------------------------------
ED1_WaitForFlagAndClearBit0:
.wait_flag:
    TST.W   CTASKS_IffTaskDoneFlag

    BEQ.S   .wait_flag

    MOVE.W  #$2e,LADFUNC_EntryCount
    MOVE.W  ESQIFF_ExternalAssetFlags,D0
    ANDI.W  #$fffe,D0
    MOVE.W  D0,ESQIFF_ExternalAssetFlags
    PEA     1.W
    JSR     ESQIFF_ReloadExternalAssetCatalogBuffers(PC)

    ADDQ.W  #4,A7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED1_JMPTBL_NEWGRID_DrawTopBorderLine   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   NEWGRID_DrawTopBorderLine
; DESC:
;   Jump stub to NEWGRID_DrawTopBorderLine.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
ED1_JMPTBL_NEWGRID_DrawTopBorderLine:
    JMP     NEWGRID_DrawTopBorderLine

;------------------------------------------------------------------------------
; FUNC: ED1_JMPTBL_LOCAVAIL_ResetFilterCursorState   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   LOCAVAIL_ResetFilterCursorState
; DESC:
;   Jump stub to LOCAVAIL_ResetFilterCursorState.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
ED1_JMPTBL_LOCAVAIL_ResetFilterCursorState:
    JMP     LOCAVAIL_ResetFilterCursorState

;!======

    ; Alignment
    ORI.B   #0,D0
    ORI.B   #0,D0
    ORI.B   #0,D0
    ORI.B   #0,D0
    ORI.B   #0,D0
    ORI.B   #0,D0

;!======

;------------------------------------------------------------------------------
; FUNC: ED1_JMPTBL_GCOMMAND_ResetHighlightMessages   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   GCOMMAND_ResetHighlightMessages
; DESC:
;   Jump stub to GCOMMAND_ResetHighlightMessages.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
ED1_JMPTBL_GCOMMAND_ResetHighlightMessages:
    JMP     GCOMMAND_ResetHighlightMessages

;------------------------------------------------------------------------------
; FUNC: ED1_JMPTBL_LADFUNC_MergeHighLowNibbles   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   LADFUNC_SetPackedPenLowNibble
; DESC:
;   Jump stub to LADFUNC_SetPackedPenLowNibble.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
ED1_JMPTBL_LADFUNC_MergeHighLowNibbles:
    JMP     LADFUNC_SetPackedPenLowNibble

;------------------------------------------------------------------------------
; FUNC: ED1_JMPTBL_LADFUNC_SaveTextAdsToFile   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   LADFUNC_SaveTextAdsToFile
; DESC:
;   Jump stub to LADFUNC_SaveTextAdsToFile.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
ED1_JMPTBL_LADFUNC_SaveTextAdsToFile:
    JMP     LADFUNC_SaveTextAdsToFile

;------------------------------------------------------------------------------
; FUNC: ED1_JMPTBL_ESQ_ColdReboot   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_ColdReboot
; DESC:
;   Jump stub to ESQ_ColdReboot.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
ED1_JMPTBL_ESQ_ColdReboot:
    JMP     ESQ_ColdReboot

;------------------------------------------------------------------------------
; FUNC: ED1_JMPTBL_ESQSHARED4_LoadDefaultPaletteToCopper_NoOp   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQSHARED4_LoadDefaultPaletteToCopper_NoOp
; DESC:
;   Jump stub to ESQSHARED4_LoadDefaultPaletteToCopper_NoOp.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
ED1_JMPTBL_ESQSHARED4_LoadDefaultPaletteToCopper_NoOp:
    JMP     ESQSHARED4_LoadDefaultPaletteToCopper_NoOp

;------------------------------------------------------------------------------
; FUNC: ED1_JMPTBL_GCOMMAND_SeedBannerDefaults   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   GCOMMAND_SeedBannerDefaults
; DESC:
;   Jump stub to GCOMMAND_SeedBannerDefaults.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
ED1_JMPTBL_GCOMMAND_SeedBannerDefaults:
    JMP     GCOMMAND_SeedBannerDefaults

;------------------------------------------------------------------------------
; FUNC: ED1_JMPTBL_MEM_Move   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   MEM_Move
; DESC:
;   Jump stub to MEM_Move.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
ED1_JMPTBL_MEM_Move:
    JMP     MEM_Move

;------------------------------------------------------------------------------
; FUNC: ED1_JMPTBL_GCOMMAND_SeedBannerFromPrefs   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   GCOMMAND_SeedBannerFromPrefs
; DESC:
;   Jump stub to GCOMMAND_SeedBannerFromPrefs.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
ED1_JMPTBL_GCOMMAND_SeedBannerFromPrefs:
    JMP     GCOMMAND_SeedBannerFromPrefs

;------------------------------------------------------------------------------
; FUNC: ED1_JMPTBL_CLEANUP_DrawDateTimeBannerRow   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   CLEANUP_DrawDateTimeBannerRow
; DESC:
;   Jump stub to CLEANUP_DrawDateTimeBannerRow.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
ED1_JMPTBL_CLEANUP_DrawDateTimeBannerRow:
    JMP     CLEANUP_DrawDateTimeBannerRow

;------------------------------------------------------------------------------
; FUNC: ED1_JMPTBL_LADFUNC_PackNibblesToByte   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   LADFUNC_SetPackedPenHighNibble
; DESC:
;   Jump stub to LADFUNC_SetPackedPenHighNibble.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
ED1_JMPTBL_LADFUNC_PackNibblesToByte:
    JMP     LADFUNC_SetPackedPenHighNibble

;!======
; The below content should belong in another file... need to determine what it is.
;!======

;------------------------------------------------------------------------------
; FUNC: ED1_DrawStatusLine1   (Render status line 1uncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A7/D0
; CALLS:
;   GROUP_AM_JMPTBL_WDISP_SPrintf, ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines
; READS:
;   ESQPARS2_StateIndex, WDISP_DisplayContextBase
; WRITES:
;   (none observed)
; DESC:
;   Formats and draws a status string in rastport 2.
; NOTES:
;   Uses local printf buffer at -41(A5).
;------------------------------------------------------------------------------
ED1_DrawStatusLine1:
    LINK.W  A5,#-44

    MOVE.W  ESQPARS2_StateIndex,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     DATA_ED2_FMT_SCRSPD_PCT_D_1D34
    PEA     -41(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    PEA     210.W
    PEA     -41(A5)
    MOVE.L  A0,-(A7)
    JSR     ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED1_DrawStatusLine2   (Render status line 2uncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A6/A7/D0/D1/D2
; CALLS:
;   GROUP_AM_JMPTBL_WDISP_SPrintf, ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines, _LVOSetRast
; READS:
;   WDISP_DisplayContextBase, DATA_CTASKS_BSS_BYTE_1BA4/1BA5/1BAD/1BB7/1BBD/1BBE/1BC9
; WRITES:
;   (none observed)
; DESC:
;   Formats and draws a multi-line status block in rastport 2.
; NOTES:
;   Uses local printf buffer at -51(A5).
;------------------------------------------------------------------------------
ED1_DrawStatusLine2:
    LINK.W  A5,#-52
    MOVE.L  D2,-(A7)
    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    MOVEA.L A0,A1
    MOVEQ   #2,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    MOVE.B  DATA_CTASKS_BSS_BYTE_1BA4,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.B  DATA_CTASKS_CONST_BYTE_1BA5,D1
    EXT.W   D1
    EXT.L   D1
    MOVE.B  DATA_CTASKS_BSS_BYTE_1BAD,D2
    EXT.W   D2
    EXT.L   D2
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     DATA_ED2_FMT_MR_PCT_D_SBS_PCT_D_SPORT_PCT_D_1D35
    PEA     -51(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    PEA     120.W
    PEA     -51(A5)
    MOVE.L  A0,-(A7)
    JSR     ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    MOVE.B  DATA_CTASKS_STR_Y_1BB7,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  CONFIG_TimeWindowMinutes,(A7)
    MOVE.L  DATA_CTASKS_CONST_LONG_1BBE,-(A7)
    MOVE.L  D0,-(A7)
    PEA     DATA_ED2_FMT_CYCLE_PCT_C_CYCLEFREQ_PCT_D_AFTRORDR_1D36
    PEA     -51(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    PEA     150.W
    PEA     -51(A5)
    MOVE.L  A0,-(A7)
    JSR     ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    MOVE.B  DATA_CTASKS_STR_1_1BC9,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    PEA     Global_STR_CLOCKCMD_EQUALS_PCT_C
    PEA     -51(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    LEA     68(A7),A7
    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    PEA     180.W
    PEA     -51(A5)
    MOVE.L  A0,-(A7)
    JSR     ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    MOVE.L  -56(A5),D2
    UNLK    A5
    RTS
