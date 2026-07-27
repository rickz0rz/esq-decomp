    XDEF    _COI_CountEscape14BeforeNull


;------------------------------------------------------------------------------
; FUNC: _COI_CountEscape14BeforeNull   (CountEscape14BeforeNulluncertain)
; ARGS:
;   stack +4: bufPtr (A3)
;   stack +8: maxLen (D7)
; RET:
;   D0: count of $14 bytes before NUL/limit
; CLOBBERS:
;   D0/D4-D7/A3
; CALLS:
;   (none)
; READS:
;   A3 buffer bytes
; WRITES:
;   (none)
; DESC:
;   Scans a byte buffer until NUL or maxLen, counting $14 bytes and skipping the
;   following byte each time a $14 is seen.
; NOTES:
;   Stops when a 0 byte is encountered or when index reaches maxLen.
;------------------------------------------------------------------------------
_COI_CountEscape14BeforeNull:
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 24(A7),A3
    MOVE.L  28(A7),D7
    MOVEQ   #0,D5
    MOVEQ   #0,D6
    MOVE.L  D6,D4

.scan_loop:
    TST.W   D5
    BNE.S   .done

    MOVE.L  D6,D0
    EXT.L   D0
    CMP.L   D7,D0
    BGE.S   .done

    MOVEQ   #0,D0
    MOVE.B  0(A3,D6.W),D0
    TST.W   D0
    BEQ.S   .found_null

    SUBI.W  #20,D0
    BEQ.S   .found_escape

    BRA.S   .advance

.found_null:
    MOVEQ   #1,D5
    BRA.S   .advance

.found_escape:
    ADDQ.W  #1,D4
    ADDQ.W  #1,D6

.advance:
    ADDQ.W  #1,D6
    BRA.S   .scan_loop

.done:
    MOVE.L  D4,D0
    MOVEM.L (A7)+,D4-D7/A3
    RTS

;!======