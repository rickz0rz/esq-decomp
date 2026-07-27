    XDEF    _SCRIPT_DeassertCtrlLine


;------------------------------------------------------------------------------
; FUNC: _SCRIPT_DeassertCtrlLine   (DeassertCtrlLine)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1
; CALLS:
;   _SCRIPT_WriteCtrlShadowToSerdat
; READS:
;   _SCRIPT_SerialShadowWord
; WRITES:
;   _SCRIPT_CtrlLineAssertedFlag, _SCRIPT_SerialShadowWord, SERDAT
; DESC:
;   Clears the CTRL/serial output bit in the shadow register and pushes it to
;   the serial data register.
; NOTES:
;   _SCRIPT_CtrlLineAssertedFlag appears to mirror the asserted/deasserted state.
;------------------------------------------------------------------------------
_SCRIPT_DeassertCtrlLine:
    CLR.W   _SCRIPT_CtrlLineAssertedFlag
    MOVE.W  _SCRIPT_SerialShadowWord,D0
    MOVE.L  D0,D1
    ANDI.W  #$ffdf,D1
    MOVE.W  D1,_SCRIPT_SerialShadowWord
    MOVEQ   #0,D0
    MOVE.W  D1,D0
    MOVE.L  D0,-(A7)
    BSR.W   _SCRIPT_WriteCtrlShadowToSerdat

    ADDQ.W  #4,A7
    RTS

;!======