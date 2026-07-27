    XDEF    _SCRIPT_GetCtrlLineFlag


;------------------------------------------------------------------------------
; FUNC: _SCRIPT_GetCtrlLineFlag   (GetCtrlLineFlag)
; ARGS:
;   (none)
; RET:
;   D0: _SCRIPT_CtrlLineAssertedFlag (shadow flag)
; CLOBBERS:
;   D0
; CALLS:
;   (none)
; READS:
;   _SCRIPT_CtrlLineAssertedFlag
; WRITES:
;   (none)
; DESC:
;   Returns the cached CTRL line asserted flag.
;------------------------------------------------------------------------------
_SCRIPT_GetCtrlLineFlag:
    MOVE.L  D7,-(A7)
    MOVE.W  _SCRIPT_CtrlLineAssertedFlag,D7
    MOVE.L  D7,D0
    MOVE.L  (A7)+,D7
    RTS

;!======