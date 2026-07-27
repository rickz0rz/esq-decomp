    XDEF    _ESQ_TerminateAfterSecondQuote


;------------------------------------------------------------------------------
; FUNC: _ESQ_TerminateAfterSecondQuote   (TerminateAfterSecondQuoteuncertain)
; ARGS:
;   stack +4: textPtr
; RET:
;   (none)
; CLOBBERS:
;   D0-D2, A0
; CALLS:
;   (none)
; READS:
;   [textPtr]
; WRITES:
;   [textPtr] (writes a null byte)
; DESC:
;   Scans for the second double-quote and writes a terminator after it.
; NOTES:
;   No callers found via static search; may be reached via computed jump.
;------------------------------------------------------------------------------
_ESQ_TerminateAfterSecondQuote:
    MOVEA.L 4(A7),A0
    MOVE.L  D2,-(A7)
    MOVEQ   #0,D0
    MOVE.W  D0,D1
    MOVEQ   #34,D2

.find_first_quote:
    MOVE.B  (A0)+,D1
    BEQ.S   .return

    CMP.B   D2,D1
    BNE.S   .find_first_quote

.find_second_quote:
    MOVE.B  (A0)+,D1
    BEQ.S   .return

    CMP.B   D2,D1
    BNE.S   .find_second_quote

    MOVE.B  D0,(A0)

.return:
    MOVE.L  (A7)+,D2
    RTS

;!======