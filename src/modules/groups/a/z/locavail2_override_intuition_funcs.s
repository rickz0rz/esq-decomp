    XDEF    _OVERRIDE_INTUITION_FUNCS


;------------------------------------------------------------------------------
; FUNC: _OVERRIDE_INTUITION_FUNCS   (Routine at _OVERRIDE_INTUITION_FUNCS)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A6/A7/D0
; CALLS:
;   _LVOSetFunction
; READS:
;   AbsExecBase, _Global_REF_INTUITION_LIBRARY, _LOCAVAIL2_AutoRequestNoOp, _LOCAVAIL2_DisplayAlertDelayAndReboot, _LVOAutoRequest, _LVODisplayAlert
; WRITES:
;   _Global_REF_BACKED_UP_INTUITION_AUTOREQUEST, _Global_REF_BACKED_UP_INTUITION_DISPLAYALERT
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_OVERRIDE_INTUITION_FUNCS:
    MOVE.L  A2,-(A7)

    ; overriding the AutoRequest function in intuition.library
    ; to point to _LOCAVAIL2_AutoRequestNoOp(PC) storing the old version in _Global_REF_BACKED_UP_INTUITION_AUTOREQUEST
    MOVEA.L _Global_REF_INTUITION_LIBRARY,A1
    MOVEA.W #_LVOAutoRequest,A0
    LEA     _LOCAVAIL2_AutoRequestNoOp(PC),A2
    MOVE.L  A2,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOSetFunction(A6)

    MOVE.L  D0,_Global_REF_BACKED_UP_INTUITION_AUTOREQUEST

    ; overriding the ItemAddress function in intuition.library
    ; to point to _LOCAVAIL2_DisplayAlertDelayAndReboot(PC) storing the old version in _Global_REF_BACKED_UP_INTUITION_DISPLAYALERT
    MOVEA.L _Global_REF_INTUITION_LIBRARY,A1
    MOVEA.W #_LVODisplayAlert,A0
    LEA     _LOCAVAIL2_DisplayAlertDelayAndReboot(PC),A2
    MOVE.L  A2,D0
    JSR     _LVOSetFunction(A6)

    MOVE.L  D0,_Global_REF_BACKED_UP_INTUITION_DISPLAYALERT

    MOVEA.L (A7)+,A2
    RTS

;!======