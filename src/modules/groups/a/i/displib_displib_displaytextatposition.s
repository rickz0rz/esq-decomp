    XDEF    _DISPLIB_DisplayTextAtPosition


;------------------------------------------------------------------------------
; FUNC: _DISPLIB_DisplayTextAtPosition   (Routine at _DISPLIB_DisplayTextAtPosition)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A6/A7/D0/D1/D6/D7
; CALLS:
;   _LVOMove, _LVOText
; READS:
;   Global_REF_GRAPHICS_LIBRARY
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_DISPLIB_DisplayTextAtPosition:
    LINK.W  A5,#-4
    MOVEM.L D6-D7/A2-A3,-(A7)

    ; Copy additional parameters from the stack
    MOVEA.L 28(A7),A3   ; RastPort
    MOVE.L  32(A7),D7   ; X
    MOVE.L  36(A7),D6   ; Y
    MOVEA.L 40(A7),A2   ; String

    ; Check to see if A2 (our target string) is an empty address.
    ; If it is, jump to the end.
    MOVE.L  A2,D0
    BEQ.S   .return

    MOVEA.L A3,A1   ; RastPort
    MOVE.L  D7,D0   ; X (short)
    MOVE.L  D6,D1   ; Y (short)
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVEA.L A2,A0

; Count the number of characters in the string by testing each
; character, and then subtracting the address of the null character
; from the starting address of the string (minus 1)
.currentCharacterIsNotNull:
    TST.B   (A0)+
    BNE.S   .currentCharacterIsNotNull

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    MOVE.L  A0,16(A7)

    MOVEA.L A3,A1       ; RastPort
    MOVEA.L A2,A0       ; String
    MOVE.L  16(A7),D0   ; Number of characters in the string
    JSR     _LVOText(A6)

.return:
    MOVEM.L (A7)+,D6-D7/A2-A3
    UNLK    A5
    RTS

;!======