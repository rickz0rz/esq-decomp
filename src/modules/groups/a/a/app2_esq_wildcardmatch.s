    XDEF    _ESQ_WildcardMatch


;------------------------------------------------------------------------------
; FUNC: _ESQ_WildcardMatch   (WildcardMatchuncertain)
; ARGS:
;   stack +4: str
;   stack +8: pattern
; RET:
;   D0.b: 0 if match, 1 if mismatch
; CLOBBERS:
;   D0-D1, A0-A1
; CALLS:
;   (none)
; READS:
;   [str], [pattern]
; WRITES:
;   (none)
; DESC:
;   Compares a string against a pattern supporting '*' and '?' wildcards.
; NOTES:
;   Returns mismatch on null pointers. '*' short-circuits to match.
;------------------------------------------------------------------------------
_ESQ_WildcardMatch:
    MOVEA.L 4(A7),A0
    MOVEA.L 8(A7),A1
    CMPA.L  #0,A0
    BEQ.S   .mismatch

    CMPA.L  #0,A1
    BEQ.S   .mismatch

    MOVEQ   #0,D0

.match_loop:
    MOVE.B  (A0)+,D0
    MOVE.B  (A1)+,D1
    CMPI.B  #'*',D1
    BEQ.S   .match

    TST.B   D0
    BEQ.S   .check_end

    CMPI.B  #'?',D1
    BEQ.S   .match_loop

    SUB.B   D1,D0
    BEQ.S   .match_loop

.mismatch:
    MOVE.B  #$1,D0
    RTS

.check_end:
    TST.B   D1
    BNE.S   .mismatch

.match:
    MOVE.B  #0,D0
    RTS

;!======