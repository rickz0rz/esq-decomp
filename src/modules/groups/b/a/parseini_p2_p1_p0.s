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
