    XDEF    _SCRIPT_ClearCtrlLineIfEnabled


;------------------------------------------------------------------------------
; FUNC: _SCRIPT_ClearCtrlLineIfEnabled   (ClearCtrlLineIfEnabled)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0/D1
; CALLS:
;   _SCRIPT_DeassertCtrlLine
; READS:
;   _SCRIPT_CtrlInterfaceEnabledFlag
; WRITES:
;   _SCRIPT_CtrlLineAssertedFlag, _SCRIPT_SerialShadowWord (via _SCRIPT_DeassertCtrlLine)
; DESC:
;   Clears the CTRL/serial output bit when the control interface is enabled.
; NOTES:
;   _SCRIPT_DeassertCtrlLine updates _SCRIPT_SerialShadowWord and sends SERDAT.
;------------------------------------------------------------------------------
_SCRIPT_ClearCtrlLineIfEnabled:
    TST.W   _SCRIPT_CtrlInterfaceEnabledFlag
    BEQ.S   .return_status

    BSR.S   _SCRIPT_DeassertCtrlLine

.return_status:
    RTS

;!======