    XDEF    _SCRIPT_UpdateSerialShadowFromCtrlByte


;------------------------------------------------------------------------------
; FUNC: _SCRIPT_UpdateSerialShadowFromCtrlByte   (Latch low control bits and write serial word)
; ARGS:
;   stack +8: ctrlByte (u8)
; RET:
;   D0: none
; CLOBBERS:
;   A7/D0/D1/D7
; CALLS:
;   _SCRIPT_WriteCtrlShadowToSerdat
; READS:
;   _SCRIPT_SerialShadowWord
; WRITES:
;   _SCRIPT_SerialShadowWord, _SCRIPT_SerialInputLatch
; DESC:
;   Stores ctrlByte in _SCRIPT_SerialInputLatch, merges low 2 bits into the
;   serial shadow word, then writes the updated word to serial hardware.
; NOTES:
;   Preserves non-control bits with mask $FC.
;------------------------------------------------------------------------------
_SCRIPT_UpdateSerialShadowFromCtrlByte:
    MOVE.L  D7,-(A7)

    MOVE.B  11(A7),D7
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.W  D0,_SCRIPT_SerialInputLatch
    ANDI.B  #$3,D7
    MOVEQ   #0,D0
    MOVE.W  _SCRIPT_SerialShadowWord,D0
    MOVEQ   #126,D1
    ADD.L   D1,D1
    AND.L   D1,D0
    OR.B    D0,D7
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.W  D0,_SCRIPT_SerialShadowWord
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,-(A7)
    BSR.W   _SCRIPT_WriteCtrlShadowToSerdat

    ADDQ.W  #4,A7

    MOVE.L  (A7)+,D7
    RTS

;!======