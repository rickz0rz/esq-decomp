    XDEF    PARSEINI_HandleFontCommand
    XDEF    PARSEINI_ScanLogoDirectory
    XDEF    PARSEINI_TestMemoryAndOpenTopazFont
    XDEF    _PARSEINI_JMPTBL_BRUSH_AllocBrushNode
    XDEF    PARSEINI_JMPTBL_BRUSH_FreeBrushList
    XDEF    PARSEINI_JMPTBL_BRUSH_FreeBrushResources
    XDEF    PARSEINI_JMPTBL_DISKIO2_ParseIniFileFromDisk
    XDEF    _PARSEINI_JMPTBL_DISKIO_ConsumeLineFromWorkBuffer
    XDEF    _PARSEINI_JMPTBL_DISKIO_LoadFileToWorkBuffer
    XDEF    PARSEINI_JMPTBL_ED1_DrawDiagnosticsScreen
    XDEF    PARSEINI_JMPTBL_ED1_EnterEscMenu
    XDEF    PARSEINI_JMPTBL_ED1_ExitEscMenu
    XDEF    PARSEINI_JMPTBL_ED1_WaitForFlagAndClearBit0
    XDEF    PARSEINI_JMPTBL_ED1_WaitForFlagAndClearBit1
    XDEF    PARSEINI_JMPTBL_ESQFUNC_DrawEscMenuVersion
    XDEF    PARSEINI_JMPTBL_ESQFUNC_RebuildPwBrushListFromTagTableFromTagTable
    XDEF    PARSEINI_JMPTBL_ESQIFF_HandleBrushIniReloadHotkey
    XDEF    PARSEINI_JMPTBL_ESQIFF_QueueIffBrushLoad
    XDEF    _PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString
    XDEF    PARSEINI_JMPTBL_GCOMMAND_FindPathSeparator
    XDEF    _PARSEINI_JMPTBL_GCOMMAND_InitPresetTableFromPalette
    XDEF    _PARSEINI_JMPTBL_GCOMMAND_ValidatePresetTable
    XDEF    PARSEINI_JMPTBL_HANDLE_OpenWithMode
    XDEF    PARSEINI_JMPTBL_STREAM_ReadLineWithLimit
    XDEF    PARSEINI_JMPTBL_STRING_AppendAtNull
    XDEF    _PARSEINI_JMPTBL_STRING_CompareNoCase
    XDEF    _PARSEINI_JMPTBL_STRING_CompareNoCaseN
    XDEF    PARSEINI_JMPTBL_UNKNOWN36_FinalizeRequest
    XDEF    _PARSEINI_JMPTBL_STR_FindAnyCharPtr
    XDEF    _PARSEINI_JMPTBL_STR_FindCharPtr
    XDEF    _PARSEINI_JMPTBL_WDISP_SPrintf


;------------------------------------------------------------------------------
; FUNC: TEST_MEMORY_AND_OPEN_TOPAZ_FONT   (Test memory then open Topaz)
; ARGS:
;   stack +8: A3 = pointer to font handle storage
;   stack +12: A2 = TextAttr for desired font
; RET:
;   D0: 0 on success, 1 on failure
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   _LVOCloseFont, _LVOForbid/_LVOPermit, _LVOAllocMem/_LVOFreeMem, _LVOOpenDiskFont
; READS:
;   _Global_HANDLE_TOPAZ_FONT
; WRITES:
;   (A3) font handle
; DESC:
;   Ensures a Topaz font is open, first probing for a small alloc; closes an
;   existing non-Topaz handle, tries to open the requested font, otherwise falls
;   back to the global Topaz handle.
; NOTES:
;   Sets D0=1 when it could not load the desired font.
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
; FUNC: PARSEINI_TestMemoryAndOpenTopazFont   (Routine at PARSEINI_TestMemoryAndOpenTopazFont)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0/D1/D7
; CALLS:
;   _LVOAllocMem, _LVOCloseFont, _LVOForbid, _LVOFreeMem, _LVOOpenDiskFont, _LVOPermit
; READS:
;   AbsExecBase, DesiredMemoryAvailability, _Global_HANDLE_TOPAZ_FONT, _Global_REF_DISKFONT_LIBRARY, Global_REF_GRAPHICS_LIBRARY
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
PARSEINI_TestMemoryAndOpenTopazFont:
    LINK.W  A5,#-8
    MOVEM.L D7/A2-A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2

    MOVEQ   #0,D7
    TST.L   (A3)
    BEQ.S   .return

    MOVEA.L (A3),A0
    MOVEA.L _Global_HANDLE_TOPAZ_FONT,A1
    CMPA.L  A0,A1
    BEQ.S   .testDesiredMemoryAvailability

    MOVEA.L A0,A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOCloseFont(A6)

.testDesiredMemoryAvailability:
    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    MOVE.L  #DesiredMemoryAvailability,D0
    MOVEQ   #1,D1
    JSR     _LVOAllocMem(A6)

    MOVE.L  D0,-4(A5)
    BEQ.S   .openTopazFont

    MOVEA.L D0,A1
    MOVE.L  #DesiredMemoryAvailability,D0
    JSR     _LVOFreeMem(A6)

.openTopazFont:
    JSR     _LVOPermit(A6)

    MOVEA.L A2,A0
    MOVEA.L _Global_REF_DISKFONT_LIBRARY,A6
    JSR     _LVOOpenDiskFont(A6)

    MOVE.L  D0,(A3)
    BNE.S   .couldNotLoadTopazFont

    MOVE.L  _Global_HANDLE_TOPAZ_FONT,(A3)
    BRA.S   .return

.couldNotLoadTopazFont:
    MOVEQ   #1,D7

.return:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A2-A3
    UNLK    A5
    RTS

;!======

; we're doing a bunch of font stuff in here!
;------------------------------------------------------------------------------
; FUNC: PARSEINI_HandleFontCommand   (Parse font/control command dispatcher)
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
PARSEINI_HandleFontCommand:
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
    PEA     Global_STR_PERCENT_S_2
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
    JSR     PARSEINI_JMPTBL_ED1_WaitForFlagAndClearBit0(PC)

    BRA.W   .return

.cmd_scan_logos_and_clear_flag1:
    MOVE.B  _CONFIG_ParseiniLogoScanEnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .after_optional_logo_scan

    BSR.W   PARSEINI_ScanLogoDirectory

.after_optional_logo_scan:
    JSR     PARSEINI_JMPTBL_ED1_WaitForFlagAndClearBit1(PC)

    BRA.W   .return

.cmd_call_lab_09DB:
    JSR     PARSEINI_JMPTBL_ESQFUNC_RebuildPwBrushListFromTagTableFromTagTable(PC)

    BRA.W   .return

.cmd_set_h26f_font:
    PEA     _Global_STRUCT_TEXTATTR_H26F_FONT
    PEA     _Global_HANDLE_H26F_FONT
    BSR.W   PARSEINI_TestMemoryAndOpenTopazFont

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
    BSR.W   PARSEINI_TestMemoryAndOpenTopazFont

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
    JSR     SCRIPT3_JMPTBL_MATH_Mulu32(PC)

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
    BSR.W   TLIBA3_SetFontForAllViewModes

    ADDQ.W  #4,A7
    BRA.W   .return

.cmd_set_prevue_font:
    PEA     _Global_STRUCT_TEXTATTR_PREVUE_FONT
    PEA     _Global_HANDLE_PREVUE_FONT
    BSR.W   PARSEINI_TestMemoryAndOpenTopazFont

    ADDQ.W  #8,A7
    TST.W   D0
    BRA.W   .return

.cmd_parse_ini_from_disk:
    JSR     PARSEINI_JMPTBL_DISKIO2_ParseIniFileFromDisk(PC)

    BRA.W   .return

.cmd_call_lab_0A93:
    PEA     97.W
    JSR     PARSEINI_JMPTBL_ESQIFF_HandleBrushIniReloadHotkey(PC)

    ADDQ.W  #4,A7
    BRA.W   .return

.cmd_parse_gradient_ini:
    ; Loads/parses gradient.ini into _GCOMMAND_GradientPresetTable staging data.
    ; No direct runtime consumer of this table is confirmed in named-symbol paths yet.
    PEA     Global_STR_DF0_GRADIENT_INI_3
    BSR.W   _PARSEINI_ParseIniBufferAndDispatch

    ADDQ.W  #4,A7
    BRA.W   .return

.cmd_parse_banner_ini:
    PEA     Global_STR_DF0_BANNER_INI_2
    JSR     _SCRIPT_CheckPathExists(PC)

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.W   .return

.wait_banner_ready:
    TST.W   _CTASKS_IffTaskDoneFlag
    BEQ.S   .wait_banner_ready

    CLR.L   -(A7)
    PEA     _WDISP_WeatherStatusBrushListHead
    JSR     PARSEINI_JMPTBL_BRUSH_FreeBrushList(PC)

    PEA     _PARSEINI_BannerBrushResourceHead
    JSR     PARSEINI_JMPTBL_BRUSH_FreeBrushResources(PC)

    PEA     Global_STR_DF0_BANNER_INI_3

    BSR.W   _PARSEINI_ParseIniBufferAndDispatch

    PEA     1.W
    JSR     PARSEINI_JMPTBL_ESQIFF_QueueIffBrushLoad(PC)

    LEA     20(A7),A7
    BRA.S   .return

.cmd_parse_default_ini:
    PEA     Global_STR_DF0_DEFAULT_INI_2
    BSR.W   _PARSEINI_ParseIniBufferAndDispatch

    ADDQ.W  #4,A7
    BRA.S   .return

.cmd_parse_sourcecfg_ini:
    PEA     Global_STR_DF0_SOURCECFG_INI_1
    BSR.W   _PARSEINI_ParseIniBufferAndDispatch

    JSR     TEXTDISP_ApplySourceConfigAllEntries(PC)

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
    JSR     PARSEINI_JMPTBL_ED1_EnterEscMenu(PC)

    JSR     PARSEINI_JMPTBL_ED1_ExitEscMenu(PC)

    BRA.S   .return

.cmd_draw_diagnostics:
    JSR     PARSEINI_JMPTBL_ED1_EnterEscMenu(PC)

    JSR     PARSEINI_JMPTBL_ED1_DrawDiagnosticsScreen(PC)

    BRA.S   .return

.cmd_draw_version:
    JSR     PARSEINI_JMPTBL_ED1_EnterEscMenu(PC)

    JSR     PARSEINI_JMPTBL_ESQFUNC_DrawEscMenuVersion(PC)

.return:
    MOVEM.L (A7)+,D2-D3/D6-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARSEINI_ScanLogoDirectory   (Scan logo directory and build name/path lists)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0-D7/A0-A2
; CALLS:
;   _LVOExecute, PARSEINI_JMPTBL_HANDLE_OpenWithMode, PARSEINI_JMPTBL_STREAM_ReadLineWithLimit, PARSEINI_JMPTBL_GCOMMAND_FindPathSeparator, _SCRIPT_JMPTBL_MEMORY_AllocateMemory
; READS:
;   Global_STR_LIST_RAM_LOGODIR_TXT_DH2_LOGOS_NOHEAD_QUICK, PARSEINI_PATH_DF0_COLON_LOGO_DOT_LST/2099/209A/209B strings
; WRITES:
;   local temp buffers and allocated lists at -500/-900(A5)
; DESC:
;   Executes helper commands to list logo directories, reads entries into temp
;   buffers, allocates per-entry strings, and populates two arrays (probably names/paths).
; NOTES:
;   Iterates up to 100 entries per list, trimming CR/LF/commas from lines.
;------------------------------------------------------------------------------
PARSEINI_ScanLogoDirectory:
    LINK.W  A5,#-960
    MOVEM.L D2-D3/D5-D7/A2,-(A7)

    LEA     -88(A5),A0
    MOVEQ   #0,D6
    MOVE.L  A0,-100(A5)
    MOVE.L  A0,-96(A5)

.clear_entry_tables_loop:
    MOVEQ   #100,D0
    CMP.L   D0,D6
    BGE.S   .exec_list_command

    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     -500(A5),A0
    ADDA.L  D0,A0
    SUBA.L  A1,A1
    MOVE.L  A1,(A0)
    LEA     -900(A5),A0
    ADDA.L  D0,A0
    MOVE.L  A1,(A0)
    ADDQ.L  #1,D6
    BRA.S   .clear_entry_tables_loop

.exec_list_command:
    LEA     Global_STR_LIST_RAM_LOGODIR_TXT_DH2_LOGOS_NOHEAD_QUICK,A0
    MOVE.L  A0,D1
    MOVEQ   #0,D2
    MOVE.L  D2,D3
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOExecute(A6)

    PEA     PARSEINI_STR_RB_LogoListPrimary
    PEA     PARSEINI_PATH_DF0_COLON_LOGO_DOT_LST
    JSR     PARSEINI_JMPTBL_HANDLE_OpenWithMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    BNE.S   .after_open_primary

    CLR.L   -96(A5)

.after_open_primary:
    PEA     PARSEINI_STR_RB_LogoListSecondary
    PEA     PARSEINI_PATH_RAM_COLON_LOGODIR_DOT_TXT
    JSR     PARSEINI_JMPTBL_HANDLE_OpenWithMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    BNE.S   .after_open_secondary

    CLR.L   -100(A5)

.after_open_secondary:
    MOVEQ   #0,D5

.read_primary_list_loop:
    TST.L   -96(A5)
    BEQ.W   .read_secondary_list_loop

    MOVEQ   #100,D0
    CMP.L   D0,D5
    BGE.W   .read_secondary_list_loop

    MOVE.L  -4(A5),-(A7)
    PEA     99.W
    PEA     -88(A5)
    JSR     PARSEINI_JMPTBL_STREAM_ReadLineWithLimit(PC)

    LEA     12(A7),A7
    LEA     -88(A5),A0
    MOVEA.L A0,A1

.primary_line_len_loop:
    TST.B   (A1)+
    BNE.S   .primary_line_len_loop

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D7
    MOVEQ   #0,D6
    MOVE.L  D0,-96(A5)

.primary_sanitize_loop:
    CMP.L   D7,D6
    BGE.S   .primary_alloc_and_store

    MOVEQ   #10,D0
    CMP.B   -88(A5,D6.L),D0
    BEQ.S   .primary_clear_char

    MOVEQ   #13,D0
    CMP.B   -88(A5,D6.L),D0
    BEQ.S   .primary_clear_char

    MOVEQ   #44,D0
    CMP.B   -88(A5,D6.L),D0
    BNE.S   .primary_next_char

.primary_clear_char:
    CLR.B   -88(A5,D6.L)

.primary_next_char:
    ADDQ.L  #1,D6
    BRA.S   .primary_sanitize_loop

.primary_alloc_and_store:
    PEA     -88(A5)
    JSR     PARSEINI_JMPTBL_GCOMMAND_FindPathSeparator(PC)

    MOVE.L  D5,D1
    ASL.L   #2,D1
    LEA     -500(A5),A0
    ADDA.L  D1,A0
    MOVEA.L D0,A1

.primary_strlen_loop:
    TST.B   (A1)+
    BNE.S   .primary_strlen_loop

    SUBQ.L  #1,A1
    SUBA.L  D0,A1
    MOVE.L  A1,D1
    ADDQ.L  #1,D1
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),(A7)
    MOVE.L  D1,-(A7)
    PEA     1263.W
    PEA     Global_STR_PARSEINI_C_4
    MOVE.L  D0,-92(A5)
    MOVE.L  A0,40(A7)
    JSR     _SCRIPT_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L 24(A7),A0
    MOVE.L  D0,(A0)
    MOVE.L  D5,D0
    ASL.L   #2,D0
    LEA     -500(A5),A0
    ADDA.L  D0,A0
    MOVEA.L -92(A5),A1
    MOVEA.L (A0),A2

.primary_copy_string_loop:
    MOVE.B  (A1)+,(A2)+
    BNE.S   .primary_copy_string_loop

    ADDQ.L  #1,D5
    BRA.W   .read_primary_list_loop

.read_secondary_list_loop:
    MOVEQ   #0,D5

.secondary_list_loop:
    TST.L   -100(A5)
    BEQ.W   .compare_lists_loop

    MOVEQ   #100,D0
    CMP.L   D0,D5
    BGE.W   .compare_lists_loop

    MOVE.L  -8(A5),-(A7)
    PEA     99.W
    PEA     -88(A5)
    JSR     PARSEINI_JMPTBL_STREAM_ReadLineWithLimit(PC)

    LEA     12(A7),A7
    LEA     -88(A5),A0
    MOVEA.L A0,A1

.secondary_strlen_loop:
    TST.B   (A1)+
    BNE.S   .secondary_strlen_loop

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D7
    MOVEQ   #0,D6
    MOVE.L  D0,-100(A5)

.secondary_sanitize_loop:
    CMP.L   D7,D6
    BGE.S   .secondary_alloc_and_store

    MOVEQ   #10,D0
    CMP.B   -88(A5,D6.L),D0
    BEQ.S   .secondary_clear_char

    MOVEQ   #13,D0
    CMP.B   -88(A5,D6.L),D0
    BNE.S   .secondary_next_char

.secondary_clear_char:
    CLR.B   -88(A5,D6.L)

.secondary_next_char:
    ADDQ.L  #1,D6
    BRA.S   .secondary_sanitize_loop

.secondary_alloc_and_store:
    MOVE.L  D5,D0
    ASL.L   #2,D0
    LEA     -900(A5),A0
    ADDA.L  D0,A0
    LEA     -88(A5),A1
    MOVEA.L A1,A2

.secondary_strlen_alloc_loop:
    TST.B   (A2)+
    BNE.S   .secondary_strlen_alloc_loop

    SUBQ.L  #1,A2
    SUBA.L  A1,A2
    MOVE.L  A2,D0
    ADDQ.L  #1,D0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D0,-(A7)
    PEA     1287.W
    PEA     Global_STR_PARSEINI_C_5
    MOVE.L  A0,40(A7)
    JSR     _SCRIPT_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L 24(A7),A0
    MOVE.L  D0,(A0)
    MOVE.L  D5,D0
    ASL.L   #2,D0
    LEA     -900(A5),A0
    ADDA.L  D0,A0
    LEA     -88(A5),A1
    MOVEA.L (A0),A2

.secondary_copy_string_loop:
    MOVE.B  (A1)+,(A2)+
    BNE.S   .secondary_copy_string_loop

    ADDQ.L  #1,D5
    BRA.W   .secondary_list_loop

.compare_lists_loop:
    MOVEQ   #0,D6

.next_secondary_entry:
    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     -900(A5),A0
    ADDA.L  D0,A0
    TST.L   (A0)
    BEQ.W   .free_primary_entries_loop

    MOVEQ   #0,D5
    CLR.L   -916(A5)

.scan_primary_for_match:
    MOVE.L  D5,D0
    ASL.L   #2,D0
    LEA     -500(A5),A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    TST.L   (A1)
    BEQ.S   .if_no_match_delete

    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     -900(A5),A1
    ADDA.L  D0,A1
    MOVE.L  D5,D0
    ASL.L   #2,D0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    MOVE.L  (A1),-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .primary_match_next

    MOVEQ   #1,D0
    MOVE.L  D0,-916(A5)

.primary_match_next:
    ADDQ.L  #1,D5
    BRA.S   .scan_primary_for_match

.if_no_match_delete:
    TST.L   -916(A5)
    BNE.S   .free_secondary_entry

    LEA     Global_STR_DELETE_NIL_DH2_LOGOS,A0
    LEA     -956(A5),A1
    MOVEQ   #5,D0

.build_delete_cmd_copy_loop:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.build_delete_cmd_copy_loop

    CLR.B   (A1)
    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     -900(A5),A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    PEA     -956(A5)
    JSR     PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7
    LEA     -956(A5),A0
    MOVE.L  A0,D1
    MOVEQ   #0,D2
    MOVE.L  D2,D3
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOExecute(A6)

.free_secondary_entry:
    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     -900(A5),A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    ADDA.L  D0,A0
    MOVEA.L (A0),A2

.secondary_strlen_for_free:
    TST.B   (A2)+
    BNE.S   .secondary_strlen_for_free

    SUBQ.L  #1,A2
    SUBA.L  (A0),A2
    MOVE.L  A2,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  (A1),-(A7)
    PEA     1323.W
    PEA     Global_STR_PARSEINI_C_6
    JSR     _SCRIPT_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    ADDQ.L  #1,D6
    BRA.W   .next_secondary_entry

.free_primary_entries_loop:
    MOVEQ   #0,D5

.next_primary_entry_free:
    MOVE.L  D5,D0
    ASL.L   #2,D0
    LEA     -500(A5),A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    TST.L   (A1)
    BEQ.S   .close_primary_handle

    MOVE.L  D5,D0
    ASL.L   #2,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    ADDA.L  D0,A0
    MOVEA.L (A0),A2

.primary_strlen_for_free:
    TST.B   (A2)+
    BNE.S   .primary_strlen_for_free

    SUBQ.L  #1,A2
    SUBA.L  (A0),A2
    MOVE.L  A2,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  (A1),-(A7)
    PEA     1329.W
    PEA     Global_STR_PARSEINI_C_7
    JSR     _SCRIPT_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    ADDQ.L  #1,D5
    BRA.S   .next_primary_entry_free

.close_primary_handle:
    TST.L   -4(A5)
    BEQ.S   .close_secondary_handle

    MOVE.L  -4(A5),-(A7)
    JSR     PARSEINI_JMPTBL_UNKNOWN36_FinalizeRequest(PC)

    ADDQ.W  #4,A7

.close_secondary_handle:
    TST.L   -8(A5)
    BEQ.S   .return

    MOVE.L  -8(A5),-(A7)
    JSR     PARSEINI_JMPTBL_UNKNOWN36_FinalizeRequest(PC)

    ADDQ.W  #4,A7

.return:
    MOVEM.L (A7)+,D2-D3/D5-D7/A2
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _PARSEINI_JMPTBL_STRING_CompareNoCase   (JumpStub_STRING_CompareNoCase)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _STRING_CompareNoCase
; DESC:
;   Jump stub to _STRING_CompareNoCase (string compare/parse helper).
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_PARSEINI_JMPTBL_STRING_CompareNoCase:
    JMP     _STRING_CompareNoCase

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_ED1_WaitForFlagAndClearBit0   (JumpStub_ED1_WaitForFlagAndClearBit0)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ED1_WaitForFlagAndClearBit0
; DESC:
;   Jump stub to _ED1_WaitForFlagAndClearBit0.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_ED1_WaitForFlagAndClearBit0:
    JMP     _ED1_WaitForFlagAndClearBit0

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_DISKIO2_ParseIniFileFromDisk   (JumpStub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _DISKIO2_ParseIniFileFromDisk
; DESC:
;   Jump stub to _DISKIO2_ParseIniFileFromDisk (Parse INI file from disk).
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_DISKIO2_ParseIniFileFromDisk:
    JMP     _DISKIO2_ParseIniFileFromDisk

;------------------------------------------------------------------------------
; FUNC: _PARSEINI_JMPTBL_STR_FindCharPtr   (JumpStub_STR_FindCharPtr)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _STR_FindCharPtr
; DESC:
;   Jump stub to _STR_FindCharPtr.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_PARSEINI_JMPTBL_STR_FindCharPtr:
    JMP     _STR_FindCharPtr

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_HANDLE_OpenWithMode   (JumpStub_HANDLE_OpenWithMode)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   HANDLE_OpenWithMode
; DESC:
;   Jump stub to HANDLE_OpenWithMode.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_HANDLE_OpenWithMode:
    JMP     HANDLE_OpenWithMode

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_ESQIFF_QueueIffBrushLoad   (JumpStub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQIFF_QueueIffBrushLoad
; DESC:
;   Jump stub to ESQIFF_QueueIffBrushLoad.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_ESQIFF_QueueIffBrushLoad:
    JMP     ESQIFF_QueueIffBrushLoad

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_ESQIFF_HandleBrushIniReloadHotkey   (JumpStub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ESQIFF_HandleBrushIniReloadHotkey
; DESC:
;   Jump stub to _ESQIFF_HandleBrushIniReloadHotkey.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_ESQIFF_HandleBrushIniReloadHotkey:
    JMP     _ESQIFF_HandleBrushIniReloadHotkey

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_BRUSH_FreeBrushResources   (JumpStub_BRUSH_FreeBrushResources)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _BRUSH_FreeBrushResources
; DESC:
;   Jump stub to _BRUSH_FreeBrushResources.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_BRUSH_FreeBrushResources:
    JMP     _BRUSH_FreeBrushResources

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_ESQFUNC_RebuildPwBrushListFromTagTableFromTagTable   (JumpStub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ESQFUNC_RebuildPwBrushListFromTagTable
; DESC:
;   Jump stub to _ESQFUNC_RebuildPwBrushListFromTagTable.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_ESQFUNC_RebuildPwBrushListFromTagTableFromTagTable:
    JMP     _ESQFUNC_RebuildPwBrushListFromTagTable

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_GCOMMAND_FindPathSeparator   (JumpStub_GCOMMAND_FindPathSeparator)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _GCOMMAND_FindPathSeparator
; DESC:
;   Jump stub to _GCOMMAND_FindPathSeparator.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_GCOMMAND_FindPathSeparator:
    JMP     _GCOMMAND_FindPathSeparator

;------------------------------------------------------------------------------
; FUNC: _PARSEINI_JMPTBL_DISKIO_ConsumeLineFromWorkBuffer   (JumpStub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _DISKIO_ConsumeLineFromWorkBuffer
; DESC:
;   Jump stub to _DISKIO_ConsumeLineFromWorkBuffer.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_PARSEINI_JMPTBL_DISKIO_ConsumeLineFromWorkBuffer:
    JMP     _DISKIO_ConsumeLineFromWorkBuffer

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_ED1_DrawDiagnosticsScreen   (JumpStub_ED1_DrawDiagnosticsScreen)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ED1_DrawDiagnosticsScreen
; DESC:
;   Jump stub to _ED1_DrawDiagnosticsScreen.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_ED1_DrawDiagnosticsScreen:
    JMP     _ED1_DrawDiagnosticsScreen

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_BRUSH_FreeBrushList   (JumpStub_BRUSH_FreeBrushList)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _BRUSH_FreeBrushList
; DESC:
;   Jump stub to _BRUSH_FreeBrushList.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_BRUSH_FreeBrushList:
    JMP     _BRUSH_FreeBrushList

;------------------------------------------------------------------------------
; FUNC: _PARSEINI_JMPTBL_GCOMMAND_ValidatePresetTable   (JumpStub_GCOMMAND_ValidatePresetTable)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   GCOMMAND_ValidatePresetTable
; DESC:
;   Jump stub to GCOMMAND_ValidatePresetTable.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_PARSEINI_JMPTBL_GCOMMAND_ValidatePresetTable:
    JMP     GCOMMAND_ValidatePresetTable

;------------------------------------------------------------------------------
; FUNC: _PARSEINI_JMPTBL_BRUSH_AllocBrushNode   (JumpStub_BRUSH_AllocBrushNode)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   BRUSH_AllocBrushNode
; DESC:
;   Jump stub to BRUSH_AllocBrushNode.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_PARSEINI_JMPTBL_BRUSH_AllocBrushNode:
    JMP     BRUSH_AllocBrushNode

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_UNKNOWN36_FinalizeRequest   (JumpStub_UNKNOWN36_FinalizeRequest)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   UNKNOWN36_FinalizeRequest
; DESC:
;   Jump stub to UNKNOWN36_FinalizeRequest.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_UNKNOWN36_FinalizeRequest:
    JMP     UNKNOWN36_FinalizeRequest

;------------------------------------------------------------------------------
; FUNC: _PARSEINI_JMPTBL_GCOMMAND_InitPresetTableFromPalette   (JumpStub_GCOMMAND_InitPresetTableFromPalette)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _GCOMMAND_InitPresetTableFromPalette
; DESC:
;   Jump stub to _GCOMMAND_InitPresetTableFromPalette.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_PARSEINI_JMPTBL_GCOMMAND_InitPresetTableFromPalette:
    JMP     _GCOMMAND_InitPresetTableFromPalette

;------------------------------------------------------------------------------
; FUNC: _PARSEINI_JMPTBL_STRING_CompareNoCaseN   (JumpStub_STRING_CompareNoCaseN)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _STRING_CompareNoCaseN
; DESC:
;   Jump stub to _STRING_CompareNoCaseN.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_PARSEINI_JMPTBL_STRING_CompareNoCaseN:
    JMP     _STRING_CompareNoCaseN

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_STRING_AppendAtNull   (JumpStub_STRING_AppendAtNull)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _STRING_AppendAtNull
; DESC:
;   Jump stub to _STRING_AppendAtNull.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_STRING_AppendAtNull:
    JMP     _STRING_AppendAtNull

;------------------------------------------------------------------------------
; FUNC: _PARSEINI_JMPTBL_DISKIO_LoadFileToWorkBuffer   (JumpStub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _DISKIO_LoadFileToWorkBuffer
; DESC:
;   Jump stub to _DISKIO_LoadFileToWorkBuffer.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_PARSEINI_JMPTBL_DISKIO_LoadFileToWorkBuffer:
    JMP     _DISKIO_LoadFileToWorkBuffer

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_ED1_WaitForFlagAndClearBit1   (JumpStub_ED1_WaitForFlagAndClearBit1)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ED1_WaitForFlagAndClearBit1
; DESC:
;   Jump stub to _ED1_WaitForFlagAndClearBit1.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_ED1_WaitForFlagAndClearBit1:
    JMP     _ED1_WaitForFlagAndClearBit1

;------------------------------------------------------------------------------
; FUNC: _PARSEINI_JMPTBL_WDISP_SPrintf   (JumpStub_WDISP_SPrintf)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _WDISP_SPrintf
; DESC:
;   Jump stub to _WDISP_SPrintf.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_PARSEINI_JMPTBL_WDISP_SPrintf:
    JMP     _WDISP_SPrintf

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_STREAM_ReadLineWithLimit   (JumpStub_STREAM_ReadLineWithLimit)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   STREAM_ReadLineWithLimit
; DESC:
;   Jump stub to STREAM_ReadLineWithLimit.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_STREAM_ReadLineWithLimit:
    JMP     STREAM_ReadLineWithLimit

;------------------------------------------------------------------------------
; FUNC: _PARSEINI_JMPTBL_STR_FindAnyCharPtr   (JumpStub_STR_FindAnyCharPtr)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   STR_FindAnyCharPtr
; DESC:
;   Jump stub to STR_FindAnyCharPtr.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_PARSEINI_JMPTBL_STR_FindAnyCharPtr:
    JMP     STR_FindAnyCharPtr

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_ED1_ExitEscMenu   (JumpStub_ED1_ExitEscMenu)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ED1_ExitEscMenu
; DESC:
;   Jump stub to ED1_ExitEscMenu.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_ED1_ExitEscMenu:
    JMP     ED1_ExitEscMenu

;------------------------------------------------------------------------------
; FUNC: _PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString   (JumpStub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ESQPARS_ReplaceOwnedString
; DESC:
;   Jump stub to _ESQPARS_ReplaceOwnedString.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString:
    JMP     _ESQPARS_ReplaceOwnedString

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_ED1_EnterEscMenu   (JumpStub_ED1_EnterEscMenu)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ED1_EnterEscMenu
; DESC:
;   Jump stub to _ED1_EnterEscMenu.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_ED1_EnterEscMenu:
    JMP     _ED1_EnterEscMenu

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_ESQFUNC_DrawEscMenuVersion   (JumpStub_ESQFUNC_DrawEscMenuVersion)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ESQFUNC_DrawEscMenuVersion
; DESC:
;   Jump stub to _ESQFUNC_DrawEscMenuVersion.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_ESQFUNC_DrawEscMenuVersion:
    JMP     _ESQFUNC_DrawEscMenuVersion

    RTS

;!======

    ; Alignment
    ALIGN_WORD
