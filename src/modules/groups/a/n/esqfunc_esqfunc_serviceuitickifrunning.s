    XDEF    _ESQFUNC_ServiceUiTickIfRunning


;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_ServiceUiTickIfRunning   (Gate UI frame service by run flag)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ESQFUNC_JMPTBL_CLEANUP_ProcessAlerts, _ESQFUNC_JMPTBL_TEXTDISP_TickDisplayState, _ESQDISP_ProcessGridMessagesIfIdle, _ESQFUNC_ProcessUiFrameTick
; READS:
;   _ESQ_MainLoopUiTickEnabledFlag, _CLEANUP_PendingAlertFlag
; WRITES:
;   (none observed)
; DESC:
;   Calls _ESQFUNC_ProcessUiFrameTick only while the main run flag is enabled.
; NOTES:
;   This is the main idle-loop UI tick gate used by _ESQ_MainInitAndRun.
;------------------------------------------------------------------------------
_ESQFUNC_ServiceUiTickIfRunning:
    TST.W   _ESQ_MainLoopUiTickEnabledFlag
    BEQ.S   .return

    BSR.W   _ESQFUNC_ProcessUiFrameTick

.return:
    RTS

;!======