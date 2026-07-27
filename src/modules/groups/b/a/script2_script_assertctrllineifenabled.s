    XDEF    _SCRIPT_AssertCtrlLineIfEnabled


;------------------------------------------------------------------------------
; FUNC: _SCRIPT_AssertCtrlLineIfEnabled   (AssertCtrlLineIfEnabled)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1
; CALLS:
;   _SCRIPT_AssertCtrlLine
; READS:
;   _SCRIPT_CtrlInterfaceEnabledFlag
; WRITES:
;   _SCRIPT_CtrlLineAssertedFlag, _SCRIPT_SerialShadowWord, SERDAT
; DESC:
;   Asserts the CTRL/serial output bit when the control interface is enabled.
; NOTES:
;   _SCRIPT_CtrlInterfaceEnabledFlag acts as an enable gate.
;------------------------------------------------------------------------------
_SCRIPT_AssertCtrlLineIfEnabled:
    TST.W   _SCRIPT_CtrlInterfaceEnabledFlag
    BEQ.S   .return_status

    BSR.S   _SCRIPT_AssertCtrlLine

.return_status:
    RTS

;!======