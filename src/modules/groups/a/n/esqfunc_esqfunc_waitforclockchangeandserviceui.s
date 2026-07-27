    XDEF    _ESQFUNC_WaitForClockChangeAndServiceUi


;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_WaitForClockChangeAndServiceUi   (Poll clock change while servicing UI tick)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ESQFUNC_JMPTBL_PARSEINI_MonitorClockChange, _ESQFUNC_ServiceUiTickIfRunning
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Repeatedly polls clock-change monitor and services one UI tick until a
;   clock-change event is reported.
; NOTES:
;   Blocks caller until _ESQFUNC_JMPTBL_PARSEINI_MonitorClockChange returns non-zero.
;------------------------------------------------------------------------------
_ESQFUNC_WaitForClockChangeAndServiceUi:
    JSR     _ESQFUNC_JMPTBL_PARSEINI_MonitorClockChange(PC)

    TST.W   D0
    BNE.S   .return

    BSR.W   _ESQFUNC_ServiceUiTickIfRunning

    BRA.S   _ESQFUNC_WaitForClockChangeAndServiceUi

.return:
    RTS

;!======