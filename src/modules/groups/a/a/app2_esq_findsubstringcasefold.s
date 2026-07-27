    XDEF    _ESQ_FindSubstringCaseFold
    XDEF    _ESQ_WriteDecFixedWidth


;------------------------------------------------------------------------------
; FUNC: _ESQ_FindSubstringCaseFold   (FindSubstringCaseFolduncertain)
; ARGS:
;   stack +4: haystack
;   stack +8: needle
; RET:
;   D0: pointer to match (or 0 if not found)
; CLOBBERS:
;   D0-D2, A0-A3
; CALLS:
;   (none)
; READS:
;   [haystack], [needle]
; WRITES:
;   (none)
; DESC:
;   Searches for needle inside haystack with ASCII case folding.
; NOTES:
;   Case fold uses BCHG #5 (ASCII letter case bit).
;------------------------------------------------------------------------------
_ESQ_FindSubstringCaseFold:
    MOVEA.L 4(A7),A0
    MOVEA.L 8(A7),A1
    MOVEM.L A2-A3,-(A7)

    MOVEQ   #0,D0
    TST.B   (A1)
    BEQ.S   .return

    MOVEA.L A0,A3
    MOVEA.L A1,A2

.search_loop:
    TST.B   (A0)
    BNE.S   .compare_loop

    TST.B   (A2)
    BNE.S   .return

.found:
    MOVE.L  A3,D0

.return:
    MOVEM.L (A7)+,A2-A3
    RTS

.compare_loop:
    TST.B   (A2)
    BEQ.S   .found

    MOVE.B  (A0)+,D1
    CMP.B   (A2),D1
    BNE.S   .try_case_fold

    TST.B   (A2)+
    BRA.S   .search_loop

.try_case_fold:
    BCHG    #5,D1
    CMP.B   (A2),D1
    BNE.S   .reset_search

    TST.B   (A2)+
    BRA.S   .search_loop

.reset_search:
    MOVE.L  A2,D2
    CMPA.L  D2,A1
    BEQ.S   .restart_from_next

    MOVE.L  A0,D1
    SUBI.L  #$1,D1
    MOVEA.L D1,A0

.restart_from_next:
    MOVEA.L A0,A3
    MOVEA.L A1,A2
    BRA.S   .search_loop

;------------------------------------------------------------------------------
; FUNC: _ESQ_WriteDecFixedWidth   (WriteDecFixedWidthuncertain)
; ARGS:
;   stack +4: outBuf
;   stack +8: value
;   stack +12: digits
; RET:
;   (none)
; CLOBBERS:
;   D0-D1, A0
; CALLS:
;   (none)
; READS:
;   (none)
; WRITES:
;   outBuf
; DESC:
;   Writes a fixed-width decimal string into outBuf.
; NOTES:
;   Writes digits right-to-left and terminates with null at outBuf+digits.
;------------------------------------------------------------------------------
_ESQ_WriteDecFixedWidth:
    MOVEA.L 4(A7),A0
    MOVE.L  8(A7),D0
    MOVE.L  12(A7),D1
    ADDA.L  D1,A0
    MOVE.B  #0,(A0)
    SUBQ.W  #1,D1

.emit_digit_loop:
    EXT.L   D0
    DIVS    #10,D0
    SWAP    D0
    MOVE.B  D0,-(A0)
    ADDI.B  #$30,(A0)
    SWAP    D0
    DBF     D1,.emit_digit_loop

    RTS

;!======