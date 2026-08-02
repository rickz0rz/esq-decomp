    XDEF    _PARSEINI_ScanLogoDirectory
    XDEF    _PARSEINI_JMPTBL_BRUSH_AllocBrushNode
    XDEF    _PARSEINI_JMPTBL_BRUSH_FreeBrushList
    XDEF    _PARSEINI_JMPTBL_BRUSH_FreeBrushResources
    XDEF    _PARSEINI_JMPTBL_DISKIO2_ParseIniFileFromDisk
    XDEF    _PARSEINI_JMPTBL_DISKIO_ConsumeLineFromWorkBuffer
    XDEF    _PARSEINI_JMPTBL_DISKIO_LoadFileToWorkBuffer
    XDEF    _PARSEINI_JMPTBL_ED1_DrawDiagnosticsScreen
    XDEF    _PARSEINI_JMPTBL_ED1_EnterEscMenu
    XDEF    _PARSEINI_JMPTBL_ED1_ExitEscMenu
    XDEF    _PARSEINI_JMPTBL_ED1_WaitForFlagAndClearBit0
    XDEF    _PARSEINI_JMPTBL_ED1_WaitForFlagAndClearBit1
    XDEF    _PARSEINI_JMPTBL_ESQFUNC_DrawEscMenuVersion
    XDEF    _PARSEINI_JMPTBL_ESQFUNC_RebuildPwBrushListFromTagTableFromTagTable
    XDEF    _PARSEINI_JMPTBL_ESQIFF_HandleBrushIniReloadHotkey
    XDEF    _PARSEINI_JMPTBL_ESQIFF_QueueIffBrushLoad
    XDEF    _PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString
    XDEF    _PARSEINI_JMPTBL_GCOMMAND_FindPathSeparator
    XDEF    _PARSEINI_JMPTBL_GCOMMAND_InitPresetTableFromPalette
    XDEF    _PARSEINI_JMPTBL_GCOMMAND_ValidatePresetTable
    XDEF    _PARSEINI_JMPTBL_HANDLE_OpenWithMode
    XDEF    _PARSEINI_JMPTBL_STREAM_ReadLineWithLimit
    XDEF    _PARSEINI_JMPTBL_STRING_AppendAtNull
    XDEF    _PARSEINI_JMPTBL_STRING_CompareNoCase
    XDEF    _PARSEINI_JMPTBL_STRING_CompareNoCaseN
    XDEF    _PARSEINI_JMPTBL_UNKNOWN36_FinalizeRequest
    XDEF    _PARSEINI_JMPTBL_STR_FindAnyCharPtr
    XDEF    _PARSEINI_JMPTBL_STR_FindCharPtr
    XDEF    _PARSEINI_JMPTBL_WDISP_SPrintf


;------------------------------------------------------------------------------
; FUNC: _PARSEINI_ScanLogoDirectory   (Scan logo directory and build name/path lists)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0-D7/A0-A2
; CALLS:
;   _LVOExecute, _PARSEINI_JMPTBL_HANDLE_OpenWithMode, _PARSEINI_JMPTBL_STREAM_ReadLineWithLimit, _PARSEINI_JMPTBL_GCOMMAND_FindPathSeparator, _SCRIPT_JMPTBL_MEMORY_AllocateMemory
; READS:
;   _Global_STR_LIST_RAM_LOGODIR_TXT_DH2_LOGOS_NOHEAD_QUICK, _PARSEINI_PATH_DF0_COLON_LOGO_DOT_LST/2099/209A/209B strings
; WRITES:
;   local temp buffers and allocated lists at -500/-900(A5)
; DESC:
;   Executes helper commands to list logo directories, reads entries into temp
;   buffers, allocates per-entry strings, and populates two arrays (probably names/paths).
; NOTES:
;   Iterates up to 100 entries per list, trimming CR/LF/commas from lines.
;------------------------------------------------------------------------------
_PARSEINI_ScanLogoDirectory:
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
    LEA     _Global_STR_LIST_RAM_LOGODIR_TXT_DH2_LOGOS_NOHEAD_QUICK,A0
    MOVE.L  A0,D1
    MOVEQ   #0,D2
    MOVE.L  D2,D3
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOExecute(A6)

    PEA     _PARSEINI_STR_RB_LogoListPrimary
    PEA     _PARSEINI_PATH_DF0_COLON_LOGO_DOT_LST
    JSR     _PARSEINI_JMPTBL_HANDLE_OpenWithMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    BNE.S   .after_open_primary

    CLR.L   -96(A5)

.after_open_primary:
    PEA     _PARSEINI_STR_RB_LogoListSecondary
    PEA     _PARSEINI_PATH_RAM_COLON_LOGODIR_DOT_TXT
    JSR     _PARSEINI_JMPTBL_HANDLE_OpenWithMode(PC)

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
    JSR     _PARSEINI_JMPTBL_STREAM_ReadLineWithLimit(PC)

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
    JSR     _PARSEINI_JMPTBL_GCOMMAND_FindPathSeparator(PC)

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
    PEA     _Global_STR_PARSEINI_C_4
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
    JSR     _PARSEINI_JMPTBL_STREAM_ReadLineWithLimit(PC)

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
    PEA     _Global_STR_PARSEINI_C_5
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

    LEA     _Global_STR_DELETE_NIL_DH2_LOGOS,A0
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
    JSR     _PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

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
    PEA     _Global_STR_PARSEINI_C_6
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
    PEA     _Global_STR_PARSEINI_C_7
    JSR     _SCRIPT_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    ADDQ.L  #1,D5
    BRA.S   .next_primary_entry_free

.close_primary_handle:
    TST.L   -4(A5)
    BEQ.S   .close_secondary_handle

    MOVE.L  -4(A5),-(A7)
    JSR     _PARSEINI_JMPTBL_UNKNOWN36_FinalizeRequest(PC)

    ADDQ.W  #4,A7

.close_secondary_handle:
    TST.L   -8(A5)
    BEQ.S   .return

    MOVE.L  -8(A5),-(A7)
    JSR     _PARSEINI_JMPTBL_UNKNOWN36_FinalizeRequest(PC)

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
; FUNC: _PARSEINI_JMPTBL_ED1_WaitForFlagAndClearBit0   (JumpStub_ED1_WaitForFlagAndClearBit0)
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
_PARSEINI_JMPTBL_ED1_WaitForFlagAndClearBit0:
    JMP     _ED1_WaitForFlagAndClearBit0

;------------------------------------------------------------------------------
; FUNC: _PARSEINI_JMPTBL_DISKIO2_ParseIniFileFromDisk   (JumpStub)
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
_PARSEINI_JMPTBL_DISKIO2_ParseIniFileFromDisk:
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
; FUNC: _PARSEINI_JMPTBL_HANDLE_OpenWithMode   (JumpStub_HANDLE_OpenWithMode)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _HANDLE_OpenWithMode
; DESC:
;   Jump stub to _HANDLE_OpenWithMode.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_PARSEINI_JMPTBL_HANDLE_OpenWithMode:
    JMP     _HANDLE_OpenWithMode

;------------------------------------------------------------------------------
; FUNC: _PARSEINI_JMPTBL_ESQIFF_QueueIffBrushLoad   (JumpStub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ESQIFF_QueueIffBrushLoad
; DESC:
;   Jump stub to _ESQIFF_QueueIffBrushLoad.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_PARSEINI_JMPTBL_ESQIFF_QueueIffBrushLoad:
    JMP     _ESQIFF_QueueIffBrushLoad

;------------------------------------------------------------------------------
; FUNC: _PARSEINI_JMPTBL_ESQIFF_HandleBrushIniReloadHotkey   (JumpStub)
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
_PARSEINI_JMPTBL_ESQIFF_HandleBrushIniReloadHotkey:
    JMP     _ESQIFF_HandleBrushIniReloadHotkey

;------------------------------------------------------------------------------
; FUNC: _PARSEINI_JMPTBL_BRUSH_FreeBrushResources   (JumpStub_BRUSH_FreeBrushResources)
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
_PARSEINI_JMPTBL_BRUSH_FreeBrushResources:
    JMP     _BRUSH_FreeBrushResources

;------------------------------------------------------------------------------
; FUNC: _PARSEINI_JMPTBL_ESQFUNC_RebuildPwBrushListFromTagTableFromTagTable   (JumpStub)
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
_PARSEINI_JMPTBL_ESQFUNC_RebuildPwBrushListFromTagTableFromTagTable:
    JMP     _ESQFUNC_RebuildPwBrushListFromTagTable

;------------------------------------------------------------------------------
; FUNC: _PARSEINI_JMPTBL_GCOMMAND_FindPathSeparator   (JumpStub_GCOMMAND_FindPathSeparator)
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
_PARSEINI_JMPTBL_GCOMMAND_FindPathSeparator:
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
; FUNC: _PARSEINI_JMPTBL_ED1_DrawDiagnosticsScreen   (JumpStub_ED1_DrawDiagnosticsScreen)
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
_PARSEINI_JMPTBL_ED1_DrawDiagnosticsScreen:
    JMP     _ED1_DrawDiagnosticsScreen

;------------------------------------------------------------------------------
; FUNC: _PARSEINI_JMPTBL_BRUSH_FreeBrushList   (JumpStub_BRUSH_FreeBrushList)
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
_PARSEINI_JMPTBL_BRUSH_FreeBrushList:
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
;   _GCOMMAND_ValidatePresetTable
; DESC:
;   Jump stub to _GCOMMAND_ValidatePresetTable.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_PARSEINI_JMPTBL_GCOMMAND_ValidatePresetTable:
    JMP     _GCOMMAND_ValidatePresetTable

;------------------------------------------------------------------------------
; FUNC: _PARSEINI_JMPTBL_BRUSH_AllocBrushNode   (JumpStub_BRUSH_AllocBrushNode)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _BRUSH_AllocBrushNode
; DESC:
;   Jump stub to _BRUSH_AllocBrushNode.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_PARSEINI_JMPTBL_BRUSH_AllocBrushNode:
    JMP     _BRUSH_AllocBrushNode

;------------------------------------------------------------------------------
; FUNC: _PARSEINI_JMPTBL_UNKNOWN36_FinalizeRequest   (JumpStub_UNKNOWN36_FinalizeRequest)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _UNKNOWN36_FinalizeRequest
; DESC:
;   Jump stub to _UNKNOWN36_FinalizeRequest.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_PARSEINI_JMPTBL_UNKNOWN36_FinalizeRequest:
    JMP     _UNKNOWN36_FinalizeRequest

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
; FUNC: _PARSEINI_JMPTBL_STRING_AppendAtNull   (JumpStub_STRING_AppendAtNull)
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
_PARSEINI_JMPTBL_STRING_AppendAtNull:
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
; FUNC: _PARSEINI_JMPTBL_ED1_WaitForFlagAndClearBit1   (JumpStub_ED1_WaitForFlagAndClearBit1)
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
_PARSEINI_JMPTBL_ED1_WaitForFlagAndClearBit1:
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
; FUNC: _PARSEINI_JMPTBL_STREAM_ReadLineWithLimit   (JumpStub_STREAM_ReadLineWithLimit)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _STREAM_ReadLineWithLimit
; DESC:
;   Jump stub to _STREAM_ReadLineWithLimit.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_PARSEINI_JMPTBL_STREAM_ReadLineWithLimit:
    JMP     _STREAM_ReadLineWithLimit

;------------------------------------------------------------------------------
; FUNC: _PARSEINI_JMPTBL_STR_FindAnyCharPtr   (JumpStub_STR_FindAnyCharPtr)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _STR_FindAnyCharPtr
; DESC:
;   Jump stub to _STR_FindAnyCharPtr.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_PARSEINI_JMPTBL_STR_FindAnyCharPtr:
    JMP     _STR_FindAnyCharPtr

;------------------------------------------------------------------------------
; FUNC: _PARSEINI_JMPTBL_ED1_ExitEscMenu   (JumpStub_ED1_ExitEscMenu)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ED1_ExitEscMenu
; DESC:
;   Jump stub to _ED1_ExitEscMenu.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_PARSEINI_JMPTBL_ED1_ExitEscMenu:
    JMP     _ED1_ExitEscMenu

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
; FUNC: _PARSEINI_JMPTBL_ED1_EnterEscMenu   (JumpStub_ED1_EnterEscMenu)
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
_PARSEINI_JMPTBL_ED1_EnterEscMenu:
    JMP     _ED1_EnterEscMenu

;------------------------------------------------------------------------------
; FUNC: _PARSEINI_JMPTBL_ESQFUNC_DrawEscMenuVersion   (JumpStub_ESQFUNC_DrawEscMenuVersion)
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
_PARSEINI_JMPTBL_ESQFUNC_DrawEscMenuVersion:
    JMP     _ESQFUNC_DrawEscMenuVersion

    RTS

;!======

    ; Alignment
    ALIGN_WORD
