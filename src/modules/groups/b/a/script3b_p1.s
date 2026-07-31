    XDEF    _SCRIPT3_JMPTBL_CLEANUP_RenderAlignedStatusScreen
    XDEF    _SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh
    XDEF    _SCRIPT3_JMPTBL_ESQPARS_ApplyRtcBytesAndPersist
    XDEF    _SCRIPT3_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters
    XDEF    _SCRIPT3_JMPTBL_ESQ_SetCopperEffect_Custom
    XDEF    _SCRIPT3_JMPTBL_GCOMMAND_AdjustBannerCopperOffset
    XDEF    _SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar
    XDEF    _SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit
    XDEF    _SCRIPT3_JMPTBL_LOCAVAIL_ComputeFilterOffsetForEntry
    XDEF    _SCRIPT3_JMPTBL_LOCAVAIL_SetFilterModeAndResetState
    XDEF    _SCRIPT3_JMPTBL_LOCAVAIL_UpdateFilterStateMachine
    XDEF    _SCRIPT3_JMPTBL_MATH_DivS32
    XDEF    _SCRIPT3_JMPTBL_MATH_Mulu32
    XDEF    _SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt
    XDEF    _SCRIPT3_JMPTBL_STRING_CompareN
    XDEF    _SCRIPT3_JMPTBL_STRING_CopyPadNul


;------------------------------------------------------------------------------
; FUNC: _SCRIPT3_JMPTBL_LOCAVAIL_UpdateFilterStateMachine   (Routine at _SCRIPT3_JMPTBL_LOCAVAIL_UpdateFilterStateMachine)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _LOCAVAIL_UpdateFilterStateMachine
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_SCRIPT3_JMPTBL_LOCAVAIL_UpdateFilterStateMachine:
    JMP     _LOCAVAIL_UpdateFilterStateMachine

;------------------------------------------------------------------------------
; FUNC: _SCRIPT3_JMPTBL_MATH_DivS32   (Routine at _SCRIPT3_JMPTBL_MATH_DivS32)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _MATH_DivS32
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_SCRIPT3_JMPTBL_MATH_DivS32:
    BRA.W   _MATH_DivS32

;------------------------------------------------------------------------------
; FUNC: _SCRIPT3_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   _ESQSHARED_ApplyProgramTitleTextFilters
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _ESQSHARED_ApplyProgramTitleTextFilters.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_SCRIPT3_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters:
    JMP     _ESQSHARED_ApplyProgramTitleTextFilters

;------------------------------------------------------------------------------
; FUNC: _SCRIPT3_JMPTBL_STRING_CompareN   (Routine at _SCRIPT3_JMPTBL_STRING_CompareN)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   STRING_CompareN
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_SCRIPT3_JMPTBL_STRING_CompareN:
    BRA.W   STRING_CompareN

;------------------------------------------------------------------------------
; FUNC: _SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   _ESQDISP_UpdateStatusMaskAndRefresh
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _ESQDISP_UpdateStatusMaskAndRefresh.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh:
    JMP     _ESQDISP_UpdateStatusMaskAndRefresh

;------------------------------------------------------------------------------
; FUNC: _SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar   (JumpStub_GCOMMAND_GetBannerChar)
; ARGS:
;   (none)
; RET:
;   D0: banner char (see _GCOMMAND_GetBannerChar)
; CLOBBERS:
;   (none)
; CALLS:
;   _GCOMMAND_GetBannerChar
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _GCOMMAND_GetBannerChar.
;------------------------------------------------------------------------------
_SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar:
    JMP     _GCOMMAND_GetBannerChar

;------------------------------------------------------------------------------
; FUNC: _SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit   (JumpStub_LADFUNC_ParseHexDigit)
; ARGS:
;   (none)
; RET:
;   D0: parsed digit (see _LADFUNC_ParseHexDigit)
; CLOBBERS:
;   (none)
; CALLS:
;   _LADFUNC_ParseHexDigit
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _LADFUNC_ParseHexDigit.
;------------------------------------------------------------------------------
_SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit:
    JMP     _LADFUNC_ParseHexDigit

;------------------------------------------------------------------------------
; FUNC: _SCRIPT3_JMPTBL_ESQPARS_ApplyRtcBytesAndPersist   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   _ESQPARS_ApplyRtcBytesAndPersist
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _ESQPARS_ApplyRtcBytesAndPersist.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_SCRIPT3_JMPTBL_ESQPARS_ApplyRtcBytesAndPersist:
    JMP     _ESQPARS_ApplyRtcBytesAndPersist

;------------------------------------------------------------------------------
; FUNC: _SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt   (JumpStub_PARSE_ReadSignedLongSkipClass3_Alt)
; ARGS:
;   (none)
; RET:
;   D0: parsed value (see _PARSE_ReadSignedLongSkipClass3_Alt)
; CLOBBERS:
;   (none)
; CALLS:
;   _PARSE_ReadSignedLongSkipClass3_Alt
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _PARSE_ReadSignedLongSkipClass3_Alt.
;------------------------------------------------------------------------------
_SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt:
    BRA.W   _PARSE_ReadSignedLongSkipClass3_Alt

;------------------------------------------------------------------------------
; FUNC: _SCRIPT3_JMPTBL_GCOMMAND_AdjustBannerCopperOffset   (JumpStub_GCOMMAND_AdjustBannerCopperOffset)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _GCOMMAND_AdjustBannerCopperOffset
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _GCOMMAND_AdjustBannerCopperOffset.
;------------------------------------------------------------------------------
_SCRIPT3_JMPTBL_GCOMMAND_AdjustBannerCopperOffset:
    JMP     _GCOMMAND_AdjustBannerCopperOffset

;------------------------------------------------------------------------------
; FUNC: _SCRIPT3_JMPTBL_ESQ_SetCopperEffect_Custom   (JumpStub_ESQ_SetCopperEffect_Custom)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _ESQ_SetCopperEffect_Custom
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _ESQ_SetCopperEffect_Custom.
;------------------------------------------------------------------------------
_SCRIPT3_JMPTBL_ESQ_SetCopperEffect_Custom:
    JMP     _ESQ_SetCopperEffect_Custom

;------------------------------------------------------------------------------
; FUNC: _SCRIPT3_JMPTBL_CLEANUP_RenderAlignedStatusScreen   (JumpStub_CLEANUP_RenderAlignedStatusScreen)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _CLEANUP_RenderAlignedStatusScreen
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _CLEANUP_RenderAlignedStatusScreen.
;------------------------------------------------------------------------------
_SCRIPT3_JMPTBL_CLEANUP_RenderAlignedStatusScreen:
    JMP     _CLEANUP_RenderAlignedStatusScreen

;------------------------------------------------------------------------------
; FUNC: _SCRIPT3_JMPTBL_LOCAVAIL_ComputeFilterOffsetForEntry   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   _LOCAVAIL_ComputeFilterOffsetForEntry
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _LOCAVAIL_ComputeFilterOffsetForEntry.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_SCRIPT3_JMPTBL_LOCAVAIL_ComputeFilterOffsetForEntry:
    JMP     _LOCAVAIL_ComputeFilterOffsetForEntry

;------------------------------------------------------------------------------
; FUNC: _SCRIPT3_JMPTBL_MATH_Mulu32   (Routine at _SCRIPT3_JMPTBL_MATH_Mulu32)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _MATH_Mulu32
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_SCRIPT3_JMPTBL_MATH_Mulu32:
    BRA.W   _MATH_Mulu32

;------------------------------------------------------------------------------
; FUNC: _SCRIPT3_JMPTBL_LOCAVAIL_SetFilterModeAndResetState   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   _LOCAVAIL_SetFilterModeAndResetState
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _LOCAVAIL_SetFilterModeAndResetState.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_SCRIPT3_JMPTBL_LOCAVAIL_SetFilterModeAndResetState:
    JMP     _LOCAVAIL_SetFilterModeAndResetState

;------------------------------------------------------------------------------
; FUNC: _SCRIPT3_JMPTBL_STRING_CopyPadNul   (JumpStub_STRING_CopyPadNul)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   _STRING_CopyPadNul
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _STRING_CopyPadNul.
;------------------------------------------------------------------------------
_SCRIPT3_JMPTBL_STRING_CopyPadNul:
    BRA.W   _STRING_CopyPadNul
