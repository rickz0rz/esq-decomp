    XDEF    _SCRIPT_AssertCtrlLineNow



;------------------------------------------------------------------------------
; FUNC: _SCRIPT_AssertCtrlLineNow   (Assert CTRL line immediately)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1
; CALLS:
;   _SCRIPT_AssertCtrlLine
; READS:
;   _SCRIPT_SerialShadowWord
; WRITES:
;   _SCRIPT_CtrlLineAssertedFlag, _SCRIPT_SerialShadowWord, SERDAT
; DESC:
;   Unconditionally asserts the CTRL/serial output bit.
;------------------------------------------------------------------------------
_SCRIPT_AssertCtrlLineNow:
    BSR.S   _SCRIPT_AssertCtrlLine

    RTS

;!======