    XDEF    _ESQ_MainExitNoOpHook

;------------------------------------------------------------------------------
; FUNC: _ESQ_MainExitNoOpHook   (Main shutdown no-op hook)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   none
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Reserved shutdown hook; currently no-op.
; NOTES:
;   Called after cleanup and dos.library close.
;------------------------------------------------------------------------------
_ESQ_MainExitNoOpHook:
    RTS

;!======