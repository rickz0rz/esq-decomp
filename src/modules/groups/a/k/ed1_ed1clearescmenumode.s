    XDEF    _ED1_ClearEscMenuMode

;------------------------------------------------------------------------------
; FUNC: _ED1_ClearEscMenuMode   (Clear ESC menu mode flag)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   none
; READS:
;   (none)
; WRITES:
;   _ED_MenuStateId
; DESC:
;   Clears the current ESC menu mode/state byte.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_ED1_ClearEscMenuMode:
    CLR.B   _ED_MenuStateId
    RTS

;!======
