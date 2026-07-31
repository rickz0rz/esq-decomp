    XDEF    _GROUP_AC_JMPTBL_DST_RefreshBannerBuffer
    XDEF    _GROUP_AC_JMPTBL_DST_UpdateBannerQueue
    XDEF    _GROUP_AC_JMPTBL_ESQDISP_DrawStatusBanner
    XDEF    _GROUP_AC_JMPTBL_ESQFUNC_DrawDiagnosticsScreen
    XDEF    _GROUP_AC_JMPTBL_ESQFUNC_DrawEscMenuVersion
    XDEF    _GROUP_AC_JMPTBL_ESQFUNC_DrawMemoryStatusScreen
    XDEF    _GROUP_AC_JMPTBL_ESQFUNC_FreeExtraTitleTextPointers
    XDEF    _GROUP_AC_JMPTBL_GCOMMAND_UpdateBannerBounds
    XDEF    _GROUP_AC_JMPTBL_PARSEINI_AdjustHoursTo24HrFormat
    XDEF    _GROUP_AC_JMPTBL_PARSEINI_UpdateClockFromRtc
    XDEF    _GROUP_AC_JMPTBL_SCRIPT_ClearCtrlLineIfEnabled
    XDEF    _GROUP_AC_JMPTBL_SCRIPT_UpdateCtrlLineTimeout
    XDEF    _GROUP_AC_JMPTBL_SCRIPT_UpdateCtrlStateMachine

;------------------------------------------------------------------------------
; FUNC: _GROUP_AC_JMPTBL_PARSEINI_UpdateClockFromRtc   (JumpStub_PARSEINI_UpdateClockFromRtc)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   PARSEINI_UpdateClockFromRtc
; DESC:
;   Jump stub to PARSEINI_UpdateClockFromRtc.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_GROUP_AC_JMPTBL_PARSEINI_UpdateClockFromRtc:
    JMP     PARSEINI_UpdateClockFromRtc

;------------------------------------------------------------------------------
; FUNC: _GROUP_AC_JMPTBL_ESQFUNC_DrawDiagnosticsScreen   (JumpStub_ESQFUNC_DrawDiagnosticsScreen)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ESQFUNC_DrawDiagnosticsScreen
; DESC:
;   Jump stub to _ESQFUNC_DrawDiagnosticsScreen.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_GROUP_AC_JMPTBL_ESQFUNC_DrawDiagnosticsScreen:
    JMP     _ESQFUNC_DrawDiagnosticsScreen

;------------------------------------------------------------------------------
; FUNC: _GROUP_AC_JMPTBL_ESQFUNC_DrawMemoryStatusScreen   (JumpStub_ESQFUNC_DrawMemoryStatusScreen)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ESQFUNC_DrawMemoryStatusScreen
; DESC:
;   Jump stub to _ESQFUNC_DrawMemoryStatusScreen.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_GROUP_AC_JMPTBL_ESQFUNC_DrawMemoryStatusScreen:
    JMP     _ESQFUNC_DrawMemoryStatusScreen

;------------------------------------------------------------------------------
; FUNC: _GROUP_AC_JMPTBL_SCRIPT_UpdateCtrlStateMachine   (JumpStub_SCRIPT_UpdateCtrlStateMachine)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   SCRIPT_UpdateCtrlStateMachine
; DESC:
;   Jump stub to SCRIPT_UpdateCtrlStateMachine.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_GROUP_AC_JMPTBL_SCRIPT_UpdateCtrlStateMachine:
    JMP     SCRIPT_UpdateCtrlStateMachine

;------------------------------------------------------------------------------
; FUNC: _GROUP_AC_JMPTBL_GCOMMAND_UpdateBannerBounds   (JumpStub_GCOMMAND_UpdateBannerBounds)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   GCOMMAND_UpdateBannerBounds
; DESC:
;   Jump stub to GCOMMAND_UpdateBannerBounds.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_GROUP_AC_JMPTBL_GCOMMAND_UpdateBannerBounds:
    JMP     GCOMMAND_UpdateBannerBounds

;------------------------------------------------------------------------------
; FUNC: _GROUP_AC_JMPTBL_SCRIPT_UpdateCtrlLineTimeout   (JumpStub_SCRIPT_UpdateCtrlLineTimeout)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _SCRIPT_PollHandshakeAndApplyTimeout
; DESC:
;   Jump stub to _SCRIPT_PollHandshakeAndApplyTimeout.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_GROUP_AC_JMPTBL_SCRIPT_UpdateCtrlLineTimeout:
    JMP     _SCRIPT_PollHandshakeAndApplyTimeout

;------------------------------------------------------------------------------
; FUNC: _GROUP_AC_JMPTBL_SCRIPT_ClearCtrlLineIfEnabled   (JumpStub_SCRIPT_ClearCtrlLineIfEnabled)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _SCRIPT_ClearCtrlLineIfEnabled
; DESC:
;   Jump stub to _SCRIPT_ClearCtrlLineIfEnabled.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_GROUP_AC_JMPTBL_SCRIPT_ClearCtrlLineIfEnabled:
    JMP     _SCRIPT_ClearCtrlLineIfEnabled

;------------------------------------------------------------------------------
; FUNC: _GROUP_AC_JMPTBL_ESQFUNC_FreeExtraTitleTextPointers   (JumpStub_ESQFUNC_FreeExtraTitleTextPointers)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ESQFUNC_FreeExtraTitleTextPointers
; DESC:
;   Jump stub to _ESQFUNC_FreeExtraTitleTextPointers.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_GROUP_AC_JMPTBL_ESQFUNC_FreeExtraTitleTextPointers:
    JMP     _ESQFUNC_FreeExtraTitleTextPointers

;------------------------------------------------------------------------------
; FUNC: _GROUP_AC_JMPTBL_ESQDISP_DrawStatusBanner   (JumpStub_ESQDISP_DrawStatusBanner)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQDISP_DrawStatusBanner
; DESC:
;   Jump stub to ESQDISP_DrawStatusBanner.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_GROUP_AC_JMPTBL_ESQDISP_DrawStatusBanner:
    JMP     ESQDISP_DrawStatusBanner

;------------------------------------------------------------------------------
; FUNC: _GROUP_AC_JMPTBL_DST_UpdateBannerQueue   (JumpStub_DST_UpdateBannerQueue)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   DST_UpdateBannerQueue
; DESC:
;   Jump stub to DST_UpdateBannerQueue.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_GROUP_AC_JMPTBL_DST_UpdateBannerQueue:
    JMP     DST_UpdateBannerQueue

;------------------------------------------------------------------------------
; FUNC: _GROUP_AC_JMPTBL_DST_RefreshBannerBuffer   (JumpStub_DST_RefreshBannerBuffer)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _DST_RefreshBannerBuffer
; DESC:
;   Jump stub to _DST_RefreshBannerBuffer.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_GROUP_AC_JMPTBL_DST_RefreshBannerBuffer:
    JMP     _DST_RefreshBannerBuffer

;------------------------------------------------------------------------------
; FUNC: _GROUP_AC_JMPTBL_ESQFUNC_DrawEscMenuVersion   (JumpStub_ESQFUNC_DrawEscMenuVersion)
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
_GROUP_AC_JMPTBL_ESQFUNC_DrawEscMenuVersion:
    JMP     _ESQFUNC_DrawEscMenuVersion

;------------------------------------------------------------------------------
; FUNC: _GROUP_AC_JMPTBL_PARSEINI_AdjustHoursTo24HrFormat   (JumpStub_PARSEINI_AdjustHoursTo24HrFormat)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   _PARSEINI_AdjustHoursTo24HrFormat
; DESC:
;   Jump stub to _PARSEINI_AdjustHoursTo24HrFormat.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_GROUP_AC_JMPTBL_PARSEINI_AdjustHoursTo24HrFormat:
    JMP     _PARSEINI_AdjustHoursTo24HrFormat

;!======

    ; Alignment
    MOVEQ   #97,D0
