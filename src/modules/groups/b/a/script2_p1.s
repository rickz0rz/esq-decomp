    XDEF    SCRIPT_AssertCtrlLineNow
    XDEF    SCRIPT_DeassertCtrlLineNow


;------------------------------------------------------------------------------
; FUNC: SCRIPT_AssertCtrlLineNow   (Assert CTRL line immediately)
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
SCRIPT_AssertCtrlLineNow:
    BSR.S   _SCRIPT_AssertCtrlLine

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_DeassertCtrlLineNow   (Deassert CTRL line immediately)
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
SCRIPT_DeassertCtrlLineNow:
    BSR.S   _SCRIPT_DeassertCtrlLine

    RTS

;!======