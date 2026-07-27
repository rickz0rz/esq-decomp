    XDEF    _ESQ_DecColorStep


;------------------------------------------------------------------------------
; FUNC: _ESQ_DecColorStep   (DecColorStepuncertain)
; ARGS:
;   D0.w: color value (packed nibbles, likely RGB)
; RET:
;   D0.w: color value with each non-zero component decremented by 1
; CLOBBERS:
;   D0-D2
; CALLS:
;   (none)
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Decrements each non-zero 4-bit color component by one step.
; NOTES:
;   Assumes packed 0RGB format; component layout is inferred.
;------------------------------------------------------------------------------
_ESQ_DecColorStep:
    MOVE.W  D0,D1
    MOVE.W  D0,D2
    ANDI.W  #$f00,D1
    ANDI.W  #$f0,D2
    ANDI.W  #15,D0
    TST.W   D1
    BEQ.S   .green_check

    SUBI.W  #$100,D1

.green_check:
    TST.W   D2
    BEQ.S   .blue_check

    SUBI.W  #16,D2

.blue_check:
    TST.W   D0
    BEQ.S   .combine_components

    SUBI.W  #1,D0

.combine_components:
    ADD.W   D1,D0
    ADD.W   D2,D0
    RTS

;!======