    XDEF    _SCRIPT3_JMPTBL_CLEANUP_RenderAlignedStatusScreen
    XDEF    _SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh
    XDEF    SCRIPT3_JMPTBL_ESQPARS_ApplyRtcBytesAndPersist
    XDEF    _SCRIPT3_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters
    XDEF    _SCRIPT3_JMPTBL_ESQ_SetCopperEffect_Custom
    XDEF    _SCRIPT3_JMPTBL_GCOMMAND_AdjustBannerCopperOffset
    XDEF    _SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar
    XDEF    _SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit
    XDEF    SCRIPT3_JMPTBL_LOCAVAIL_ComputeFilterOffsetForEntry
    XDEF    SCRIPT3_JMPTBL_LOCAVAIL_SetFilterModeAndResetState
    XDEF    SCRIPT3_JMPTBL_LOCAVAIL_UpdateFilterStateMachine
    XDEF    SCRIPT3_JMPTBL_MATH_DivS32
    XDEF    SCRIPT3_JMPTBL_MATH_Mulu32
    XDEF    _SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt
    XDEF    SCRIPT3_JMPTBL_STRING_CompareN
    XDEF    SCRIPT3_JMPTBL_STRING_CopyPadNul


;------------------------------------------------------------------------------
; FUNC: SCRIPT3_JMPTBL_LOCAVAIL_UpdateFilterStateMachine   (Routine at SCRIPT3_JMPTBL_LOCAVAIL_UpdateFilterStateMachine)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   LOCAVAIL_UpdateFilterStateMachine
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
SCRIPT3_JMPTBL_LOCAVAIL_UpdateFilterStateMachine:
    JMP     LOCAVAIL_UpdateFilterStateMachine

;------------------------------------------------------------------------------
; FUNC: SCRIPT3_JMPTBL_MATH_DivS32   (Routine at SCRIPT3_JMPTBL_MATH_DivS32)
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
SCRIPT3_JMPTBL_MATH_DivS32:
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
; FUNC: SCRIPT3_JMPTBL_STRING_CompareN   (Routine at SCRIPT3_JMPTBL_STRING_CompareN)
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
SCRIPT3_JMPTBL_STRING_CompareN:
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
;   ESQDISP_UpdateStatusMaskAndRefresh
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to ESQDISP_UpdateStatusMaskAndRefresh.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh:
    JMP     ESQDISP_UpdateStatusMaskAndRefresh

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
; FUNC: SCRIPT3_JMPTBL_ESQPARS_ApplyRtcBytesAndPersist   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   ESQPARS_ApplyRtcBytesAndPersist
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to ESQPARS_ApplyRtcBytesAndPersist.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
SCRIPT3_JMPTBL_ESQPARS_ApplyRtcBytesAndPersist:
    JMP     ESQPARS_ApplyRtcBytesAndPersist

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
;   GCOMMAND_AdjustBannerCopperOffset
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to GCOMMAND_AdjustBannerCopperOffset.
;------------------------------------------------------------------------------
_SCRIPT3_JMPTBL_GCOMMAND_AdjustBannerCopperOffset:
    JMP     GCOMMAND_AdjustBannerCopperOffset

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
;   CLEANUP_RenderAlignedStatusScreen
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to CLEANUP_RenderAlignedStatusScreen.
;------------------------------------------------------------------------------
_SCRIPT3_JMPTBL_CLEANUP_RenderAlignedStatusScreen:
    JMP     CLEANUP_RenderAlignedStatusScreen

;------------------------------------------------------------------------------
; FUNC: SCRIPT3_JMPTBL_LOCAVAIL_ComputeFilterOffsetForEntry   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   LOCAVAIL_ComputeFilterOffsetForEntry
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LOCAVAIL_ComputeFilterOffsetForEntry.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
SCRIPT3_JMPTBL_LOCAVAIL_ComputeFilterOffsetForEntry:
    JMP     LOCAVAIL_ComputeFilterOffsetForEntry

;------------------------------------------------------------------------------
; FUNC: SCRIPT3_JMPTBL_MATH_Mulu32   (Routine at SCRIPT3_JMPTBL_MATH_Mulu32)
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
SCRIPT3_JMPTBL_MATH_Mulu32:
    BRA.W   _MATH_Mulu32

;------------------------------------------------------------------------------
; FUNC: SCRIPT3_JMPTBL_LOCAVAIL_SetFilterModeAndResetState   (JumpStub)
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
SCRIPT3_JMPTBL_LOCAVAIL_SetFilterModeAndResetState:
    JMP     _LOCAVAIL_SetFilterModeAndResetState

;------------------------------------------------------------------------------
; FUNC: SCRIPT3_JMPTBL_STRING_CopyPadNul   (JumpStub_STRING_CopyPadNul)
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
SCRIPT3_JMPTBL_STRING_CopyPadNul:
    BRA.W   _STRING_CopyPadNul
