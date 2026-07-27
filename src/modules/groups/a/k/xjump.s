    XDEF    GROUP_AK_JMPTBL_CLEANUP_RenderAlignedStatusScreen
    XDEF    GROUP_AK_JMPTBL_ESQPARS_ApplyRtcBytesAndPersist
    XDEF    GROUP_AK_JMPTBL_ESQ_SetCopperEffect_Custom
    XDEF    _GROUP_AK_JMPTBL_ESQ_SetCopperEffect_Default
    XDEF    GROUP_AK_JMPTBL_GCOMMAND_GetBannerChar
    XDEF    _GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch
    XDEF    GROUP_AK_JMPTBL_PARSEINI_ScanLogoDirectory
    XDEF    GROUP_AK_JMPTBL_PARSEINI_WriteErrorLogEntry
    XDEF    _GROUP_AK_JMPTBL_SCRIPT_DeassertCtrlLineNow
    XDEF    _GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte
    XDEF    GROUP_AK_JMPTBL_TEXTDISP_FormatEntryTimeForIndex
    XDEF    GROUP_AK_JMPTBL_TLIBA3_SelectNextViewMode

;------------------------------------------------------------------------------
; FUNC: _GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte   (JumpStub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _SCRIPT_UpdateSerialShadowFromCtrlByte
; DESC:
;   Jump stub to _SCRIPT_UpdateSerialShadowFromCtrlByte.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte:
    JMP     _SCRIPT_UpdateSerialShadowFromCtrlByte

;------------------------------------------------------------------------------
; FUNC: GROUP_AK_JMPTBL_TLIBA3_SelectNextViewMode   (JumpStub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _TLIBA3_SelectNextViewMode
; DESC:
;   Jump stub to _TLIBA3_SelectNextViewMode.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AK_JMPTBL_TLIBA3_SelectNextViewMode:
    JMP     _TLIBA3_SelectNextViewMode

;------------------------------------------------------------------------------
; FUNC: _GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch   (JumpStub_PARSEINI_ParseIniBufferAndDispatch)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   PARSEINI_ParseIniBufferAndDispatch
; DESC:
;   Jump stub to PARSEINI_ParseIniBufferAndDispatch.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch:
    JMP     PARSEINI_ParseIniBufferAndDispatch

;------------------------------------------------------------------------------
; FUNC: GROUP_AK_JMPTBL_TEXTDISP_FormatEntryTimeForIndex   (JumpStub_TEXTDISP_FormatEntryTimeForIndex)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   TEXTDISP_FormatEntryTimeForIndex
; DESC:
;   Jump stub to TEXTDISP_FormatEntryTimeForIndex.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AK_JMPTBL_TEXTDISP_FormatEntryTimeForIndex:
    JMP     TEXTDISP_FormatEntryTimeForIndex

;------------------------------------------------------------------------------
; FUNC: GROUP_AK_JMPTBL_GCOMMAND_GetBannerChar   (JumpStub_GCOMMAND_GetBannerChar)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _GCOMMAND_GetBannerChar
; DESC:
;   Jump stub to _GCOMMAND_GetBannerChar.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AK_JMPTBL_GCOMMAND_GetBannerChar:
    JMP     _GCOMMAND_GetBannerChar

;------------------------------------------------------------------------------
; FUNC: GROUP_AK_JMPTBL_ESQPARS_ApplyRtcBytesAndPersist   (JumpStub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQPARS_ApplyRtcBytesAndPersist
; DESC:
;   Jump stub to ESQPARS_ApplyRtcBytesAndPersist.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AK_JMPTBL_ESQPARS_ApplyRtcBytesAndPersist:
    BRA.W   ESQPARS_ApplyRtcBytesAndPersist

;------------------------------------------------------------------------------
; FUNC: GROUP_AK_JMPTBL_PARSEINI_WriteErrorLogEntry   (JumpStub_PARSEINI_WriteErrorLogEntry)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _PARSEINI_WriteErrorLogEntry
; DESC:
;   Jump stub to _PARSEINI_WriteErrorLogEntry.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AK_JMPTBL_PARSEINI_WriteErrorLogEntry:
    JMP     _PARSEINI_WriteErrorLogEntry

;------------------------------------------------------------------------------
; FUNC: GROUP_AK_JMPTBL_PARSEINI_ScanLogoDirectory   (JumpStub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   PARSEINI_ScanLogoDirectory
; DESC:
;   Jump stub to PARSEINI_ScanLogoDirectory.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AK_JMPTBL_PARSEINI_ScanLogoDirectory:
    JMP     PARSEINI_ScanLogoDirectory

;------------------------------------------------------------------------------
; FUNC: _GROUP_AK_JMPTBL_SCRIPT_DeassertCtrlLineNow   (JumpStub_SCRIPT_DeassertCtrlLineNow)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   SCRIPT_DeassertCtrlLineNow
; DESC:
;   Jump stub to SCRIPT_DeassertCtrlLineNow.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_GROUP_AK_JMPTBL_SCRIPT_DeassertCtrlLineNow:
    JMP     SCRIPT_DeassertCtrlLineNow

;------------------------------------------------------------------------------
; FUNC: _GROUP_AK_JMPTBL_ESQ_SetCopperEffect_Default   (JumpStub_ESQ_SetCopperEffect_Default)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ESQ_SetCopperEffect_Default
; DESC:
;   Jump stub to _ESQ_SetCopperEffect_Default.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_GROUP_AK_JMPTBL_ESQ_SetCopperEffect_Default:
    JMP     _ESQ_SetCopperEffect_Default

;------------------------------------------------------------------------------
; FUNC: GROUP_AK_JMPTBL_ESQ_SetCopperEffect_Custom   (JumpStub_ESQ_SetCopperEffect_Custom)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ESQ_SetCopperEffect_Custom
; DESC:
;   Jump stub to _ESQ_SetCopperEffect_Custom.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AK_JMPTBL_ESQ_SetCopperEffect_Custom:
    JMP     _ESQ_SetCopperEffect_Custom

;------------------------------------------------------------------------------
; FUNC: GROUP_AK_JMPTBL_CLEANUP_RenderAlignedStatusScreen   (JumpStub_CLEANUP_RenderAlignedStatusScreen)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   CLEANUP_RenderAlignedStatusScreen
; DESC:
;   Jump stub to CLEANUP_RenderAlignedStatusScreen.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AK_JMPTBL_CLEANUP_RenderAlignedStatusScreen:
    JMP     CLEANUP_RenderAlignedStatusScreen

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000
