    XDEF    _ESQ_MainEntryNoOpHook

;------------------------------------------------------------------------------
; FUNC: _ESQ_MainEntryNoOpHook   (Main pre-run no-op hook)
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
;   Reserved pre-run hook; currently no-op.
; NOTES:
;   Called immediately before _ESQ_ParseCommandLineAndRun.
;------------------------------------------------------------------------------
_ESQ_MainEntryNoOpHook:
    RTS

;!======