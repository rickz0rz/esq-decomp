    XDEF    _SCRIPT_DeassertCtrlLineNow


;------------------------------------------------------------------------------
; FUNC: _SCRIPT_DeassertCtrlLineNow   (Deassert CTRL line immediately)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1
; CALLS:
;   _SCRIPT_DeassertCtrlLine
; READS:
;   _SCRIPT_SerialShadowWord
; WRITES:
;   _SCRIPT_CtrlLineAssertedFlag, _SCRIPT_SerialShadowWord, SERDAT
; DESC:
;   Unconditionally deasserts the CTRL/serial output bit.
;------------------------------------------------------------------------------
_SCRIPT_DeassertCtrlLineNow:
    BSR.S   _SCRIPT_DeassertCtrlLine

    RTS

;!======