    XDEF    _SCRIPT_WriteCtrlShadowToSerdat

;------------------------------------------------------------------------------
; FUNC: _SCRIPT_WriteCtrlShadowToSerdat   (WriteCtrlShadowToSerdat)
; ARGS:
;   stack +10: dataWord (low byte used)
; RET:
;   D0: none
; CLOBBERS:
;   D7
; CALLS:
;   (none)
; READS:
;   (none)
; WRITES:
;   SERDAT, _SCRIPT_SerialShadowWord
; DESC:
;   Writes a byte to SERDAT with bit8 set and mirrors it into _SCRIPT_SerialShadowWord.
; NOTES:
;   Uses only the low byte of the provided word.
;------------------------------------------------------------------------------
_SCRIPT_WriteCtrlShadowToSerdat:
    MOVE.L  D7,-(A7)
    MOVE.W  10(A7),D7
    ANDI.W  #$ff,D7
    BSET    #8,D7
    MOVE.W  D7,SERDAT
    MOVE.W  D7,_SCRIPT_SerialShadowWord
    MOVE.L  (A7)+,D7
    RTS

;!======
