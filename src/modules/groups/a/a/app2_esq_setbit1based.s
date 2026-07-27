    XDEF    _ESQ_SetBit1Based


;------------------------------------------------------------------------------
; FUNC: _ESQ_SetBit1Based   (SetBit1Based)
; ARGS:
;   stack +4: base (byte array)
;   stack +8: bitIndex (1-based)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1, A0
; CALLS:
;   (none)
; READS:
;   [base]
; WRITES:
;   [base]
; DESC:
;   Sets a 1-based bit index in a byte array.
; NOTES:
;   Uses LSR.W so index is masked to 16 bits before byte addressing.
;------------------------------------------------------------------------------
_ESQ_SetBit1Based:
    MOVEA.L 4(A7),A0
    MOVE.L  8(A7),D0
    MOVEQ   #0,D1
    SUBQ.L  #1,D0
    MOVE.B  D0,D1
    ANDI.L  #$7,D1
    LSR.W   #3,D0
    BSET    D1,0(A0,D0.W)
    RTS

;!======