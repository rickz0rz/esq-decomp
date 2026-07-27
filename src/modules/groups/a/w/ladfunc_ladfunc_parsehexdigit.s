    XDEF    _LADFUNC_ParseHexDigit


;------------------------------------------------------------------------------
; FUNC: _LADFUNC_ParseHexDigit   (Parse hex digituncertain)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A7/D0/D1/D7
; CALLS:
;   (none)
; READS:
;   _WDISP_CharClassTable
; WRITES:
;   (none)
; DESC:
;   Converts an ASCII hex digit into a numeric value.
; NOTES:
;   Uses _WDISP_CharClassTable flags to classify digits/letters.
;------------------------------------------------------------------------------
_LADFUNC_ParseHexDigit:
    MOVE.L  D7,-(A7)
    MOVE.B  11(A7),D7
    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    LEA     _WDISP_CharClassTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #2,(A1)
    BEQ.S   .check_alpha

    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    BRA.S   .return

.check_alpha:
    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #7,(A1)
    BEQ.S   .return_zero

    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    ADDA.L  D0,A0
    BTST    #1,(A0)
    BEQ.S   .alpha_offset

    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .apply_alpha_bias

.alpha_offset:
    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0

.apply_alpha_bias:
    MOVEQ   #55,D1
    SUB.L   D1,D0
    BRA.S   .return

.return_zero:
    MOVEQ   #0,D0

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======