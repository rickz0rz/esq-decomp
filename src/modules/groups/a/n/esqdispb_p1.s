    XDEF    _ESQDISP_TestWordIsZeroBooleanize


;------------------------------------------------------------------------------
; FUNC: _ESQDISP_TestWordIsZeroBooleanize   (Booleanize word==0 into long 0 or -1)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D7
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Tests a stack-passed word and returns `-1` when it is zero, else returns `0`.
; NOTES:
;   Uses `SEQ` + `NEG` + sign-extension idiom to normalize boolean result.
;------------------------------------------------------------------------------
_ESQDISP_TestWordIsZeroBooleanize:
    MOVE.L  D7,-(A7)
    MOVE.W  10(A7),D7
    TST.W   D7
    SEQ     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D7
    MOVE.L  D7,D0
    MOVE.L  (A7)+,D7
    RTS
