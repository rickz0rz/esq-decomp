    XDEF    _PARSEINI_HandleFontCommand


; we're doing a bunch of font stuff in here!
;------------------------------------------------------------------------------
; FUNC: _PARSEINI_HandleFontCommand   (Parse font/control command dispatcher)
; ARGS:
;   stack +8: A3 = command string pointer
; RET:
;   D0: result/status
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   _PARSEINI_JMPTBL_WDISP_SPrintf, _LVOExecute, TEST_MEMORY_AND_OPEN_TOPAZ_FONT, LAB_1429
; READS:
;   Global_REF_DOS_LIBRARY_2, _Global_HANDLE_TOPAZ_FONT
; WRITES:
;   (font handles via TEST_MEMORY_AND_OPEN_TOPAZ_FONT)
; DESC:
;   Parses a command string starting with '3' '2' ... handling subcommands to
;   execute shell commands or open fonts depending on the trailing byte.
; NOTES:
;   Matches subcodes 0x34–0x38 etc.; returns early on non-matching prefixes.
;------------------------------------------------------------------------------
_PARSEINI_HandleFontCommand:
    LINK.W  A5,#-88
    MOVEM.L D2-D3/D6-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.B  (A3)+,D7
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    SUBI.W  #$33,D0
    BNE.W   .return

    MOVE.B  (A3)+,D7
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    SUBI.W  #$32,D0
    BEQ.S   .handle_32_execute

    SUBQ.W  #1,D0
    BEQ.S   .handle_33_subcommands

    SUBQ.W  #1,D0
    BEQ.W   .handle_34_subcommands

    BRA.W   .return

.handle_32_execute:
    MOVE.L  A3,-(A7)
    PEA     _Global_STR_PERCENT_S_2
    PEA     -80(A5)
    JSR     _PARSEINI_JMPTBL_WDISP_SPrintf(PC)

    LEA     12(A7),A7
    LEA     -80(A5),A0
    MOVE.L  A0,D1
    MOVEQ   #0,D2
    MOVE.L  D2,D3
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOExecute(A6)

    BRA.W   .return

.handle_33_subcommands:
    MOVE.B  (A3)+,D7
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    SUBI.W  #$34,D0
    BEQ.S   .cmd_wait_clear_flag0

    SUBQ.W  #1,D0
    BEQ.S   .cmd_scan_logos_and_clear_flag1

    SUBQ.W  #1,D0
    BEQ.S   .cmd_call_lab_09DB

    SUBQ.W  #1,D0
    BEQ.S   .cmd_set_h26f_font

    SUBQ.W  #1,D0
    BEQ.W   .cmd_set_prevuec_font

    SUBQ.W  #1,D0
    BEQ.W   .cmd_set_prevue_font

    SUBI.W  #$18,D0
    BEQ.W   .cmd_parse_ini_from_disk

    SUBI.W  #16,D0
    BEQ.W   .cmd_call_lab_0A93

    SUBQ.W  #1,D0
    BEQ.W   .cmd_parse_gradient_ini

    SUBQ.W  #1,D0
    BEQ.W   .cmd_parse_banner_ini

    SUBQ.W  #1,D0
    BEQ.W   .cmd_parse_default_ini

    SUBI.W  #15,D0
    BEQ.W   .cmd_parse_sourcecfg_ini

    BRA.W   .return

.cmd_wait_clear_flag0:
    JSR     _PARSEINI_JMPTBL_ED1_WaitForFlagAndClearBit0(PC)

    BRA.W   .return

.cmd_scan_logos_and_clear_flag1:
    MOVE.B  _CONFIG_ParseiniLogoScanEnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .after_optional_logo_scan

    BSR.W   _PARSEINI_ScanLogoDirectory

.after_optional_logo_scan:
    JSR     _PARSEINI_JMPTBL_ED1_WaitForFlagAndClearBit1(PC)

    BRA.W   .return

.cmd_call_lab_09DB:
    JSR     _PARSEINI_JMPTBL_ESQFUNC_RebuildPwBrushListFromTagTableFromTagTable(PC)

    BRA.W   .return

.cmd_set_h26f_font:
    PEA     _Global_STRUCT_TEXTATTR_H26F_FONT
    PEA     _Global_HANDLE_H26F_FONT
    BSR.W   _PARSEINI_TestMemoryAndOpenTopazFont

    ADDQ.W  #8,A7
    TST.W   D0
    BEQ.W   .return

    TST.W   _Global_UIBusyFlag
    BEQ.W   .return

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEA.L _Global_HANDLE_H26F_FONT,A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    BRA.W   .return

.cmd_set_prevuec_font:
    PEA     _Global_STRUCT_TEXTATTR_PREVUEC_FONT
    PEA     _Global_HANDLE_PREVUEC_FONT
    BSR.W   _PARSEINI_TestMemoryAndOpenTopazFont

    ADDQ.W  #8,A7
    TST.W   D0
    BEQ.W   .return

    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0

    MOVEA.L A0,A1
    MOVEA.L _Global_HANDLE_PREVUEC_FONT,A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEA.L _Global_HANDLE_PREVUEC_FONT,A0
    JSR     _LVOSetFont(A6)

    MOVEA.L _Global_REF_RASTPORT_2,A1
    MOVEA.L _Global_HANDLE_PREVUEC_FONT,A0
    JSR     _LVOSetFont(A6)

    MOVEA.L _NEWGRID_MainRastPortPtr,A1
    MOVEA.L _Global_HANDLE_PREVUEC_FONT,A0
    JSR     _LVOSetFont(A6)

    MOVEA.L _NEWGRID_HeaderRastPortPtr,A1
    MOVEA.L _Global_HANDLE_PREVUEC_FONT,A0
    JSR     _LVOSetFont(A6)

    MOVEQ   #0,D6

.prevec_font_rastport_loop:
    MOVEQ   #4,D0
    CMP.L   D0,D6
    BGE.S   .after_prevuec_font_loop

    MOVE.L  D6,D0
    MOVEQ   #80,D1
    ADD.L   D1,D1
    JSR     _SCRIPT3_JMPTBL_MATH_Mulu32(PC)

    LEA     _GCOMMAND_HighlightMessageSlotTable,A0
    ADDA.L  D0,A0
    LEA     60(A0),A1
    MOVEA.L _Global_HANDLE_PREVUEC_FONT,A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    ADDQ.L  #1,D6
    BRA.S   .prevec_font_rastport_loop

.after_prevuec_font_loop:
    MOVE.L  _Global_HANDLE_PREVUEC_FONT,-(A7)
    BSR.W   _TLIBA3_SetFontForAllViewModes

    ADDQ.W  #4,A7
    BRA.W   .return

.cmd_set_prevue_font:
    PEA     _Global_STRUCT_TEXTATTR_PREVUE_FONT
    PEA     _Global_HANDLE_PREVUE_FONT
    BSR.W   _PARSEINI_TestMemoryAndOpenTopazFont

    ADDQ.W  #8,A7
    TST.W   D0
    BRA.W   .return

.cmd_parse_ini_from_disk:
    JSR     _PARSEINI_JMPTBL_DISKIO2_ParseIniFileFromDisk(PC)

    BRA.W   .return

.cmd_call_lab_0A93:
    PEA     97.W
    JSR     _PARSEINI_JMPTBL_ESQIFF_HandleBrushIniReloadHotkey(PC)

    ADDQ.W  #4,A7
    BRA.W   .return

.cmd_parse_gradient_ini:
    ; Loads/parses gradient.ini into _GCOMMAND_GradientPresetTable staging data.
    ; No direct runtime consumer of this table is confirmed in named-symbol paths yet.
    PEA     _Global_STR_DF0_GRADIENT_INI_3
    BSR.W   _PARSEINI_ParseIniBufferAndDispatch

    ADDQ.W  #4,A7
    BRA.W   .return

.cmd_parse_banner_ini:
    PEA     _Global_STR_DF0_BANNER_INI_2
    JSR     _SCRIPT_CheckPathExists(PC)

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.W   .return

.wait_banner_ready:
    TST.W   _CTASKS_IffTaskDoneFlag
    BEQ.S   .wait_banner_ready

    CLR.L   -(A7)
    PEA     _WDISP_WeatherStatusBrushListHead
    JSR     _PARSEINI_JMPTBL_BRUSH_FreeBrushList(PC)

    PEA     _PARSEINI_BannerBrushResourceHead
    JSR     _PARSEINI_JMPTBL_BRUSH_FreeBrushResources(PC)

    PEA     _Global_STR_DF0_BANNER_INI_3

    BSR.W   _PARSEINI_ParseIniBufferAndDispatch

    PEA     1.W
    JSR     _PARSEINI_JMPTBL_ESQIFF_QueueIffBrushLoad(PC)

    LEA     20(A7),A7
    BRA.S   .return

.cmd_parse_default_ini:
    PEA     _Global_STR_DF0_DEFAULT_INI_2
    BSR.W   _PARSEINI_ParseIniBufferAndDispatch

    ADDQ.W  #4,A7
    BRA.S   .return

.cmd_parse_sourcecfg_ini:
    PEA     _Global_STR_DF0_SOURCECFG_INI_1
    BSR.W   _PARSEINI_ParseIniBufferAndDispatch

    JSR     _TEXTDISP_ApplySourceConfigAllEntries(PC)

    ADDQ.W  #4,A7

    BRA.S   .return

.handle_34_subcommands:
    MOVE.B  (A3)+,D7
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    SUBI.W  #$30,D0
    BEQ.S   .cmd_show_then_exit_esc_menu

    SUBQ.W  #1,D0
    BEQ.S   .cmd_draw_diagnostics

    SUBQ.W  #1,D0
    BEQ.S   .cmd_draw_version

    BRA.S   .return

.cmd_show_then_exit_esc_menu:
    JSR     _PARSEINI_JMPTBL_ED1_EnterEscMenu(PC)

    JSR     _PARSEINI_JMPTBL_ED1_ExitEscMenu(PC)

    BRA.S   .return

.cmd_draw_diagnostics:
    JSR     _PARSEINI_JMPTBL_ED1_EnterEscMenu(PC)

    JSR     _PARSEINI_JMPTBL_ED1_DrawDiagnosticsScreen(PC)

    BRA.S   .return

.cmd_draw_version:
    JSR     _PARSEINI_JMPTBL_ED1_EnterEscMenu(PC)

    JSR     _PARSEINI_JMPTBL_ESQFUNC_DrawEscMenuVersion(PC)

.return:
    MOVEM.L (A7)+,D2-D3/D6-D7/A3
    UNLK    A5
    RTS

;!======