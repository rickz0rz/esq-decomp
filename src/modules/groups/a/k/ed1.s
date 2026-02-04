;------------------------------------------------------------------------------
; FUNC: ED1_HandleEscMenuInput   (Handle ESC menu command selection??)
; ARGS:
;   (none)
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D7/A0-A1/A6 ??
; CALLS:
;   ED_GetEscMenuActionCode, ED_DrawAdNumberPrompt, ED_DrawDiagnosticModeHelpText, ED_DrawMenuSelectionHighlight, ED_DrawScrollSpeedMenuText, ED_DrawBottomHelpBarBackground, ED_DrawEscMainMenuText,
;   ED1_DrawDiagnosticsScreen, ED_DrawSpecialFunctionsMenu,
;   DISPLIB_DisplayTextAtPosition, _LVOSetAPen
; READS:
;   LAB_1BC4, LAB_21E2, LAB_21E8
; WRITES:
;   LAB_1D13, LAB_21E8, LAB_1DE4
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
    MOVE.B  LAB_1BC4,D0
    MOVEQ   #76,D1
    CMP.B   D1,D0
    BNE.S   .case_mode_2_unavailable

    JSR     ED_DrawAdNumberPrompt(PC)

    MOVE.B  #$2,LAB_1D13
    BRA.W   .done

.case_mode_2_unavailable:
    MOVEQ   #1,D6
    BRA.W   .done

.case_set_mode_3:
    MOVE.B  LAB_1BC4,D0
    MOVEQ   #76,D1
    CMP.B   D1,D0
    BNE.S   .case_mode_3_unavailable

    JSR     ED_DrawAdNumberPrompt(PC)

    MOVE.B  #$3,LAB_1D13
    BRA.W   .done

.case_mode_3_unavailable:
    MOVEQ   #1,D6
    BRA.W   .done

.case_mode_6:
    MOVE.B  #$6,LAB_1D13
    JSR     ED_DrawDiagnosticModeHelpText(PC)

    MOVE.L  LAB_21E2,LAB_21E8
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
    MOVE.B  #$a,LAB_1D13
    JSR     ED_DrawDiagnosticModeHelpText(PC)

    CLR.L   LAB_21E8
    PEA     4.W
    JSR     ED_DrawMenuSelectionHighlight(PC)

    JSR     ED_DrawSpecialFunctionsMenu(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D6
    BRA.S   .done

.case_mode_8:
    MOVE.B  #$8,LAB_1D13
    JSR     ED_DrawBottomHelpBarBackground(PC)

    BRA.S   .done

.case_set_flag:
    MOVE.W  #1,LAB_1DE4
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
    ADD.L   D0,LAB_21E8
    MOVE.L  LAB_21E8,D0
    MOVEQ   #6,D1
    JSR     GROUPB_JMPTBL_MATH_DivS32(PC)

    MOVE.L  D1,LAB_21E8
    JSR     ED_DrawEscMainMenuText(PC)

.done:
    TST.B   D6
    BEQ.S   .return

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #4,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVE.B  D6,D0
    EXT.W   D0
    SUBQ.W  #1,D0
    BNE.S   .draw_error

    PEA     LAB_1D29
    PEA     270.W
    PEA     145.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7

.draw_error:
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

.return:
    MOVEM.L (A7)+,D6-D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED1_UpdateEscMenuSelection   (Update ESC menu selection state??)
; ARGS:
;   (none)
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D1/A0 ??
; CALLS:
;   ED_DrawESCMenuBottomHelp
; READS:
;   LAB_231C, LAB_231D
; WRITES:
;   LAB_21ED, LAB_2252
; DESC:
;   Loads a menu selection value from table and refreshes bottom help.
; NOTES:
;   Clears LAB_2252 when selection is not the first entry.
;------------------------------------------------------------------------------
ED1_UpdateEscMenuSelection:
    MOVE.L  LAB_231C,D0
    LSL.L   #2,D0
    ADD.L   LAB_231C,D0
    LEA     LAB_231D,A0
    ADDA.L  D0,A0
    MOVE.B  (A0),D0
    MOVE.B  D0,LAB_21ED
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    SUBI.W  #$31,D1
    BEQ.S   .return

    JSR     ED_DrawESCMenuBottomHelp(PC)

    CLR.W   LAB_2252

.return:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED1_EnterEscMenu   (Initialize ESC menu screen/state)
; ARGS:
;   (none)
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D7/A0-A3/A6 ??
; CALLS:
;   _LVOSetFont, _LVOInitBitMap, _LVOSetRast, _LVOSetDrMd, _LVODisable, _LVOEnable,
;   LAB_07C4, GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight,
;   ED1_JMPTBL_GCOMMAND_SeedBannerDefaults, ED_DrawESCMenuBottomHelp,
;   GROUP_AM_JMPTBL_WDISP_SPrintf, GROUP_AK_JMPTBL_CLEANUP_DrawDateTimeBannerRow,
;   DISPLIB_DisplayTextAtPosition, LAB_0A49, LAB_0A48
; READS:
;   LAB_1DCB, LAB_1DCD, LAB_1FB8, LAB_1DD6, LAB_21E4
; WRITES:
;   LAB_2263, LAB_21E3, LAB_21E4, LAB_21FD, LAB_21FB, LAB_21EB,
;   GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER, LAB_2295
; DESC:
;   Prepares the ESC menu UI, computes layout values, and draws the version row.
; NOTES:
;   Copies 24 bytes from LAB_1FB8 into LAB_2295.
;------------------------------------------------------------------------------
ED1_EnterEscMenu:
    LINK.W  A5,#-48
    MOVEM.L D2/D7,-(A7)

    MOVE.W  #1,LAB_2263
    MOVE.B  LAB_1DD6,D0
    MOVE.B  D0,LAB_21E3
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEA.L GLOB_HANDLE_H26F_FONT,A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    LEA     GLOB_REF_696_400_BITMAP,A0
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVE.L  A0,4(A1)
    MOVEQ   #3,D0
    MOVE.L  #696,D1
    MOVE.L  #509,D2
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitBitMap(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    JSR     _LVOSetRast(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    JSR     LAB_0A49(PC)

    MOVEQ   #0,D7

.copy_template_loop:
    MOVEQ   #24,D0
    CMP.L   D0,D7
    BGE.S   .after_copy_template

    LEA     LAB_2295,A0
    ADDA.L  D7,A0
    LEA     LAB_1FB8,A1
    ADDA.L  D7,A1
    MOVE.B  (A1),(A0)
    ADDQ.L  #1,D7
    BRA.S   .copy_template_loop

.after_copy_template:
    MOVEA.L AbsExecBase,A6
    JSR     _LVODisable(A6)

    MOVE.W  #$100,LAB_1F45
    CLR.W   LAB_226D
    PEA     3.W
    JSR     LAB_07C4(PC)

    JSR     GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight(PC)

    CLR.L   LAB_21E4
    JSR     ED1_JMPTBL_GCOMMAND_SeedBannerDefaults(PC)

    ADDQ.W  #4,A7
    MOVEA.L AbsExecBase,A6
    JSR     _LVOEnable(A6)

    MOVEQ   #0,D0
    MOVE.B  LAB_1DCB,D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVEQ   #10,D1
    JSR     GROUPB_JMPTBL_MATH_Mulu32(PC)

    MOVEQ   #0,D1
    MOVE.B  LAB_1DCB+1,D1
    ADD.L   D1,D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVE.L  D0,LAB_21FD
    MOVEQ   #0,D0
    MOVE.B  LAB_1DCD,D0
    SUB.L   D1,D0
    MOVE.L  D0,LAB_21FB
    MOVEQ   #6,D1
    CMP.L   D1,D0
    BLE.S   .clamp_minor_version

    MOVE.L  D1,LAB_21FB
    MOVE.B  #$36,LAB_1DCD

.clamp_minor_version:
    MOVE.L  LAB_21FB,D0
    MOVEQ   #40,D1
    JSR     GROUPB_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  D0,LAB_21EB
    MOVEQ   #1,D0
    MOVE.L  D0,GLOB_REF_LONG_CURRENT_EDITING_AD_NUMBER
    JSR     ED_DrawESCMenuBottomHelp(PC)

    MOVE.L  GLOB_LONG_PATCH_VERSION_NUMBER,-(A7)
    PEA     GLOB_STR_NINE_POINT_ZERO
    PEA     GLOB_STR_VER_PERCENT_S_PERCENT_L_D
    PEA     -41(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    JSR     GROUP_AK_JMPTBL_CLEANUP_DrawDateTimeBannerRow(PC)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #3,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
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

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    JSR     LAB_0A48(PC)

ED1_EnterEscMenu_AfterVersionText:
LAB_0712_033E:
    PEA     LAB_2321
    JSR     GROUP_AK_JMPTBL_LAB_0F12(PC)

    MOVEM.L -56(A5),D2/D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED1_ExitEscMenu   (Restore main UI after ESC menu)
; ARGS:
;   (none)
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D2/A0-A3/A6 ??
; CALLS:
;   _LVOInitBitMap, _LVOSetFont, GROUP_AK_JMPTBL_GCOMMAND_ResetHighlightMessages,
;   ESQ_JMPTBL_LAB_14E2, LAB_09B7, LAB_0969, ED1_ClearEscMenuMode, LAB_098A,
;   GROUP_AK_JMPTBL_DRAW_FILLED_RECT_0_0_TO_695_1_PEN_7, GROUP_AK_JMPTBL_LAB_0E48,
;   ED1_WaitForFlagAndClearBit0, GROUP_AK_JMPTBL_GCOMMAND_SeedBannerFromPrefs,
;   ED_DrawBottomHelpBarBackground, LAB_09A7, LAB_0A48
; READS:
;   LAB_21E4, LAB_21E3, LAB_1DD6, LAB_2346
; WRITES:
;   LAB_2252, LAB_1DF3, LAB_1F3C, LAB_1FE9, LAB_1B27, LAB_2346,
;   LAB_2284, LAB_2282, CTRL_H, LAB_2263, LAB_1F45
; DESC:
;   Resets display state, refreshes banner data, and restores main screen state.
; NOTES:
;   Uses LAB_1DD6/LAB_21E3 comparisons to decide whether to wait/clear flags.
;------------------------------------------------------------------------------
ED1_ExitEscMenu:
    MOVE.L  D2,-(A7)

    CLR.W   LAB_1B85

    LEA     GLOB_REF_696_400_BITMAP,A0
    MOVEQ   #3,D0
    MOVE.L  #696,D1
    MOVE.L  #400,D2
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitBitMap(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1          ; rastport
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0     ; font
    JSR     _LVOSetFont(A6)

    JSR     GROUP_AK_JMPTBL_GCOMMAND_ResetHighlightMessages(PC)

    MOVEQ   #0,D0
    MOVE.W  D0,LAB_2252
    MOVE.W  D0,LAB_1DF3
    JSR     ESQ_JMPTBL_LAB_14E2(PC)

    CLR.W   LAB_1F3C
    JSR     LAB_09B7(PC)

    JSR     LAB_0969(PC)

    BSR.W   ED1_ClearEscMenuMode

    MOVEQ   #1,D0
    MOVE.L  D0,LAB_225F
    MOVE.L  LAB_2262,-(A7)
    MOVE.L  LAB_2260,-(A7)
    JSR     LAB_098A(PC)

    JSR     GROUP_AK_JMPTBL_DRAW_FILLED_RECT_0_0_TO_695_1_PEN_7(PC)

    ADDQ.W  #8,A7
    MOVEQ   #1,D0
    CMP.L   LAB_21E4,D0
    BNE.S   .after_optional_refresh

    JSR     GROUP_AK_JMPTBL_LAB_0E48(PC)

.after_optional_refresh:
    MOVEQ   #-1,D0
    MOVE.L  D0,LAB_1FE9
    MOVE.B  LAB_21E3,D0
    MOVE.B  LAB_1DD6,D1
    CMP.B   D1,D0
    BEQ.S   .after_mode_transition

    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .check_mode_transition

    CMP.B   D2,D0
    BNE.S   .check_mode_transition

    BSR.W   ED1_WaitForFlagAndClearBit0

.check_mode_transition:
    MOVE.B  LAB_1DD6,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BNE.S   .after_mode_transition

    MOVE.B  LAB_21E3,D0
    CMP.B   D1,D0
    BEQ.S   .after_mode_transition

    CLR.L   -(A7)
    PEA     LAB_1ED2
    JSR     LAB_0AA4(PC)

    ADDQ.W  #8,A7
    CLR.L   LAB_1B27

.after_mode_transition:
    MOVE.W  LAB_2346,D0
    BEQ.S   .after_pending_flag

    MOVE.W  #3,LAB_2346

.after_pending_flag:
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_2284
    MOVE.W  D0,LAB_2282
    MOVE.W  D0,CTRL_H
    MOVE.W  D0,LAB_2263
    JSR     GROUP_AK_JMPTBL_GCOMMAND_SeedBannerFromPrefs(PC)

    JSR     ED_DrawBottomHelpBarBackground(PC)

    PEA     1.W
    JSR     LAB_09A7(PC)

    JSR     LAB_0A48(PC)

    ADDQ.W  #4,A7
    CLR.W   LAB_1F45

    MOVE.L  (A7)+,D2
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED1_DrawDiagnosticsScreen   (Render diagnostic mode screen)
; ARGS:
;   (none)
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D2/A0-A1/A6 ??
; CALLS:
;   ED_DrawBottomHelpBarBackground, DISPLIB_DisplayTextAtPosition, GROUP_AM_JMPTBL_WDISP_SPrintf,
;   LAB_03C0, LAB_03C4, ED_DrawDiagnosticModeText, _LVOSetAPen
; READS:
;   GLOB_REF_BAUD_RATE, LAB_1D2E, LAB_1D2F, LAB_2245
; WRITES:
;   LAB_1D13, LAB_2252
; DESC:
;   Draws diagnostic-mode text blocks and prompts on the ESC menu screen.
; NOTES:
;   Uses local printf buffer at -41(A5).
;------------------------------------------------------------------------------
ED1_DrawDiagnosticsScreen:

.printfResult   = -41

    LINK.W  A5,#-48

    MOVE.B  #$7,LAB_1D13
    MOVE.W  #1,LAB_2252

    JSR     ED_DrawBottomHelpBarBackground(PC)

    PEA     GLOB_PTR_STR_SELECT_CODE
    PEA     360.W
    PEA     90.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     LAB_2245    ; I have no idea what this text is...
    PEA     360.W
    PEA     210.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    MOVE.L  GLOB_REF_BAUD_RATE,(A7)
    PEA     GLOB_STR_BAUD_RATE_DIAGNOSTIC_MODE
    PEA     .printfResult(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     .printfResult(A5)
    PEA     360.W
    PEA     410.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     LAB_1D2E
    JSR     LAB_03C0(PC)

    PEA     LAB_1D2F
    MOVE.L  D0,64(A7)
    JSR     LAB_03C4(PC)

    MOVE.L  D0,(A7)
    MOVE.L  64(A7),-(A7)
    PEA     GLOB_STR_DISK_0_IS_VAR_FULL_WITH_VAR_ERRORS
    PEA     .printfResult(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    LEA     76(A7),A7
    PEA     .printfResult(A5)
    PEA     88.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    JSR     ED_DrawDiagnosticModeText(PC)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #6,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    PEA     GLOB_STR_PUSH_ANY_KEY_TO_CONTINUE_2
    PEA     390.W
    PEA     175.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED1_ClearEscMenuMode   (Clear ESC menu mode flag)
; ARGS:
;   (none)
; RET:
;   D0: ??
; CLOBBERS:
;   D0 ??
; CALLS:
;   none
; READS:
;   (none)
; WRITES:
;   LAB_1D13
; DESC:
;   Clears the current ESC menu mode/state byte.
; NOTES:
;   ??
;------------------------------------------------------------------------------
ED1_ClearEscMenuMode:
    CLR.B   LAB_1D13
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED1_WaitForFlagAndClearBit1   (Wait for flag and clear bit 1)
; ARGS:
;   (none)
; RET:
;   D0: ??
; CLOBBERS:
;   D0/A7 ??
; CALLS:
;   LAB_0A0B
; READS:
;   LAB_1B83, LAB_22A9
; WRITES:
;   LAB_2265, LAB_22A9
; DESC:
;   Busy-waits for LAB_1B83 then clears bit 1 in LAB_22A9 and signals.
; NOTES:
;   Passes 0 to LAB_0A0B.
;------------------------------------------------------------------------------
ED1_WaitForFlagAndClearBit1:
.wait_flag:
    TST.W   LAB_1B83
    BEQ.S   .wait_flag

    MOVE.W  #$2e,LAB_2265
    MOVE.W  LAB_22A9,D0
    ANDI.W  #$fffd,D0
    MOVE.W  D0,LAB_22A9
    CLR.L   -(A7)
    JSR     LAB_0A0B(PC)

    ADDQ.W  #4,A7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED1_WaitForFlagAndClearBit0   (Wait for flag and clear bit 0)
; ARGS:
;   (none)
; RET:
;   D0: ??
; CLOBBERS:
;   D0/A7 ??
; CALLS:
;   LAB_0A0B
; READS:
;   LAB_1B83, LAB_22A9
; WRITES:
;   LAB_2265, LAB_22A9
; DESC:
;   Busy-waits for LAB_1B83 then clears bit 0 in LAB_22A9 and signals.
; NOTES:
;   Passes 1 to LAB_0A0B.
;------------------------------------------------------------------------------
ED1_WaitForFlagAndClearBit0:
.wait_flag:
    TST.W   LAB_1B83

    BEQ.S   .wait_flag

    MOVE.W  #$2e,LAB_2265
    MOVE.W  LAB_22A9,D0
    ANDI.W  #$fffe,D0
    MOVE.W  D0,LAB_22A9
    PEA     1.W
    JSR     LAB_0A0B(PC)

    ADDQ.W  #4,A7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: GROUP_AK_JMPTBL_DRAW_FILLED_RECT_0_0_TO_695_1_PEN_7   (Jump stub)
; ARGS:
;   ?? (see DRAW_FILLED_RECT_0_0_TO_695_1_PEN_7)
; RET:
;   ?? (see DRAW_FILLED_RECT_0_0_TO_695_1_PEN_7)
; CLOBBERS:
;   ?? (see DRAW_FILLED_RECT_0_0_TO_695_1_PEN_7)
; CALLS:
;   DRAW_FILLED_RECT_0_0_TO_695_1_PEN_7
; DESC:
;   Jump stub to DRAW_FILLED_RECT_0_0_TO_695_1_PEN_7.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AK_JMPTBL_DRAW_FILLED_RECT_0_0_TO_695_1_PEN_7:
    JMP     DRAW_FILLED_RECT_0_0_TO_695_1_PEN_7

;------------------------------------------------------------------------------
; FUNC: GROUP_AK_JMPTBL_LAB_0F12   (Jump stub)
; ARGS:
;   ?? (see LAB_0F12)
; RET:
;   ?? (see LAB_0F12)
; CLOBBERS:
;   ?? (see LAB_0F12)
; CALLS:
;   LAB_0F12
; DESC:
;   Jump stub to LAB_0F12.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AK_JMPTBL_LAB_0F12:
    JMP     LAB_0F12

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
; FUNC: GROUP_AK_JMPTBL_GCOMMAND_ResetHighlightMessages   (Jump stub)
; ARGS:
;   ?? (see GCOMMAND_ResetHighlightMessages)
; RET:
;   ?? (see GCOMMAND_ResetHighlightMessages)
; CLOBBERS:
;   ?? (see GCOMMAND_ResetHighlightMessages)
; CALLS:
;   GCOMMAND_ResetHighlightMessages
; DESC:
;   Jump stub to GCOMMAND_ResetHighlightMessages.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AK_JMPTBL_GCOMMAND_ResetHighlightMessages:
    JMP     GCOMMAND_ResetHighlightMessages

;------------------------------------------------------------------------------
; FUNC: GROUP_AK_JMPTBL_LAB_0EE7   (Jump stub)
; ARGS:
;   ?? (see LAB_0EE7)
; RET:
;   ?? (see LAB_0EE7)
; CLOBBERS:
;   ?? (see LAB_0EE7)
; CALLS:
;   LAB_0EE7
; DESC:
;   Jump stub to LAB_0EE7.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AK_JMPTBL_LAB_0EE7:
    JMP     LAB_0EE7

;------------------------------------------------------------------------------
; FUNC: GROUP_AK_JMPTBL_LAB_0E48   (Jump stub)
; ARGS:
;   ?? (see LAB_0E48)
; RET:
;   ?? (see LAB_0E48)
; CLOBBERS:
;   ?? (see LAB_0E48)
; CALLS:
;   LAB_0E48
; DESC:
;   Jump stub to LAB_0E48.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AK_JMPTBL_LAB_0E48:
    JMP     LAB_0E48

;------------------------------------------------------------------------------
; FUNC: GROUP_AK_JMPTBL_ESQ_ColdReboot   (Jump stub)
; ARGS:
;   ?? (see ESQ_ColdReboot)
; RET:
;   ?? (see ESQ_ColdReboot)
; CLOBBERS:
;   ?? (see ESQ_ColdReboot)
; CALLS:
;   ESQ_ColdReboot
; DESC:
;   Jump stub to ESQ_ColdReboot.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AK_JMPTBL_ESQ_ColdReboot:
    JMP     ESQ_ColdReboot

;------------------------------------------------------------------------------
; FUNC: GROUP_AK_JMPTBL_LAB_0CA7   (Jump stub)
; ARGS:
;   ?? (see LAB_0CA7)
; RET:
;   ?? (see LAB_0CA7)
; CLOBBERS:
;   ?? (see LAB_0CA7)
; CALLS:
;   LAB_0CA7
; DESC:
;   Jump stub to LAB_0CA7.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AK_JMPTBL_LAB_0CA7:
    JMP     LAB_0CA7

;------------------------------------------------------------------------------
; FUNC: ED1_JMPTBL_GCOMMAND_SeedBannerDefaults   (Jump stub)
; ARGS:
;   ?? (see GCOMMAND_SeedBannerDefaults)
; RET:
;   ?? (see GCOMMAND_SeedBannerDefaults)
; CLOBBERS:
;   ?? (see GCOMMAND_SeedBannerDefaults)
; CALLS:
;   GCOMMAND_SeedBannerDefaults
; DESC:
;   Jump stub to GCOMMAND_SeedBannerDefaults.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
ED1_JMPTBL_GCOMMAND_SeedBannerDefaults:
LAB_0723:
    JMP     GCOMMAND_SeedBannerDefaults

;------------------------------------------------------------------------------
; FUNC: ED1_JMPTBL_MEM_Move   (Jump stub)
; ARGS:
;   ?? (see MEM_Move)
; RET:
;   ?? (see MEM_Move)
; CLOBBERS:
;   ?? (see MEM_Move)
; CALLS:
;   MEM_Move
; DESC:
;   Jump stub to MEM_Move.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
ED1_JMPTBL_MEM_Move:
LAB_0724:
    JMP     MEM_Move

;------------------------------------------------------------------------------
; FUNC: GROUP_AK_JMPTBL_GCOMMAND_SeedBannerFromPrefs   (Jump stub)
; ARGS:
;   ?? (see GCOMMAND_SeedBannerFromPrefs)
; RET:
;   ?? (see GCOMMAND_SeedBannerFromPrefs)
; CLOBBERS:
;   ?? (see GCOMMAND_SeedBannerFromPrefs)
; CALLS:
;   GCOMMAND_SeedBannerFromPrefs
; DESC:
;   Jump stub to GCOMMAND_SeedBannerFromPrefs.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AK_JMPTBL_GCOMMAND_SeedBannerFromPrefs:
    JMP     GCOMMAND_SeedBannerFromPrefs

;------------------------------------------------------------------------------
; FUNC: GROUP_AK_JMPTBL_CLEANUP_DrawDateTimeBannerRow   (Jump stub)
; ARGS:
;   ?? (see CLEANUP_DrawDateTimeBannerRow)
; RET:
;   ?? (see CLEANUP_DrawDateTimeBannerRow)
; CLOBBERS:
;   ?? (see CLEANUP_DrawDateTimeBannerRow)
; CALLS:
;   CLEANUP_DrawDateTimeBannerRow
; DESC:
;   Jump stub to CLEANUP_DrawDateTimeBannerRow.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AK_JMPTBL_CLEANUP_DrawDateTimeBannerRow:
    JMP     CLEANUP_DrawDateTimeBannerRow

;------------------------------------------------------------------------------
; FUNC: ED1_JMPTBL_LAB_0EE6   (Jump stub)
; ARGS:
;   ?? (see LAB_0EE6)
; RET:
;   ?? (see LAB_0EE6)
; CLOBBERS:
;   ?? (see LAB_0EE6)
; CALLS:
;   LAB_0EE6
; DESC:
;   Jump stub to LAB_0EE6.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
ED1_JMPTBL_LAB_0EE6:
LAB_0727:
    JMP     LAB_0EE6

;!======
; The below content should belong in another file... need to determine what it is.
;!======

;------------------------------------------------------------------------------
; FUNC: ED1_DrawStatusLine1   (Render status line 1??)
; ARGS:
;   (none)
; RET:
;   D0: ??
; CLOBBERS:
;   D0/A0-A1/A6 ??
; CALLS:
;   GROUP_AM_JMPTBL_WDISP_SPrintf, LAB_09AD
; READS:
;   LAB_1F40, LAB_2216
; WRITES:
;   ??
; DESC:
;   Formats and draws a status string in rastport 2.
; NOTES:
;   Uses local printf buffer at -41(A5).
;------------------------------------------------------------------------------
ED1_DrawStatusLine1:
    LINK.W  A5,#-44

    MOVE.W  LAB_1F40,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     LAB_1D34
    PEA     -41(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    PEA     210.W
    PEA     -41(A5)
    MOVE.L  A0,-(A7)
    JSR     LAB_09AD(PC)

    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED1_DrawStatusLine2   (Render status line 2??)
; ARGS:
;   (none)
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D2/A0-A1/A6 ??
; CALLS:
;   GROUP_AM_JMPTBL_WDISP_SPrintf, LAB_09AD, _LVOSetRast
; READS:
;   LAB_2216, LAB_1BA4/1BA5/1BAD/1BB7/1BBD/1BBE/1BC9
; WRITES:
;   ??
; DESC:
;   Formats and draws a multi-line status block in rastport 2.
; NOTES:
;   Uses local printf buffer at -51(A5).
;------------------------------------------------------------------------------
ED1_DrawStatusLine2:
    LINK.W  A5,#-52
    MOVE.L  D2,-(A7)
    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVEA.L A0,A1
    MOVEQ   #2,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    MOVE.B  LAB_1BA4,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.B  LAB_1BA5,D1
    EXT.W   D1
    EXT.L   D1
    MOVE.B  LAB_1BAD,D2
    EXT.W   D2
    EXT.L   D2
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_1D35
    PEA     -51(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    PEA     120.W
    PEA     -51(A5)
    MOVE.L  A0,-(A7)
    JSR     LAB_09AD(PC)

    MOVE.B  LAB_1BB7,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  LAB_1BBD,(A7)
    MOVE.L  LAB_1BBE,-(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_1D36
    PEA     -51(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    PEA     150.W
    PEA     -51(A5)
    MOVE.L  A0,-(A7)
    JSR     LAB_09AD(PC)

    MOVE.B  LAB_1BC9,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    PEA     GLOB_STR_CLOCKCMD_EQUALS_PCT_C
    PEA     -51(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    LEA     68(A7),A7
    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    PEA     180.W
    PEA     -51(A5)
    MOVE.L  A0,-(A7)
    JSR     LAB_09AD(PC)

    MOVE.L  -56(A5),D2
    UNLK    A5
    RTS
