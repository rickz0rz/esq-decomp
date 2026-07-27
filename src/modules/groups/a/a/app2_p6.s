    XDEF    _ESQ_FormatTimeStamp


;------------------------------------------------------------------------------
; FUNC: _ESQ_FormatTimeStamp   (FormatTimeStampuncertain)
; ARGS:
;   stack +4: outBuf (expects at least 12 bytes)
;   stack +8: timePtr (struct with time fields)
; RET:
;   (none)
; CLOBBERS:
;   D0-D2, A0-A1
; CALLS:
;   (none)
; READS:
;   8(A1), 10(A1), 12(A1), 18(A1)
; WRITES:
;   outBuf (null-terminated string)
; DESC:
;   Formats "hh:mm:ss AM/PM" into the output buffer.
; NOTES:
;   Writes the string backward from outBuf+$0B. Uses 18(A1) sign for AM/PM.
;------------------------------------------------------------------------------
_ESQ_FormatTimeStamp:
    MOVEA.L 4(A7),A0
    MOVEA.L 8(A7),A1
    MOVE.L  D2,-(A7)
    ADDA.L  #$b,A0
    MOVE.B  #0,(A0)
    MOVE.B  #'M',-(A0)
    TST.W   18(A1)
    BPL.S   .set_am

    MOVE.B  #'P',-(A0)
    BRA.S   .after_ampm

.set_am:
    MOVE.B  #'A',-(A0)

.after_ampm:
    MOVE.B  #' ',-(A0)
    MOVE.W  12(A1),D2
    EXT.L   D2
    DIVS    #10,D2
    SWAP    D2
    ADDI.B  #'0',D2
    MOVE.B  D2,-(A0)
    SWAP    D2
    ADDI.B  #'0',D2
    MOVE.B  D2,-(A0)
    MOVE.B  #':',-(A0)
    MOVE.W  10(A1),D1
    EXT.L   D1
    DIVS    #10,D1
    SWAP    D1
    ADDI.B  #'0',D1
    MOVE.B  D1,-(A0)
    SWAP    D1
    ADDI.B  #'0',D1
    MOVE.B  D1,-(A0)
    MOVE.B  #':',-(A0)
    MOVE.W  8(A1),D0
    EXT.L   D0
    DIVS    #10,D0
    SWAP    D0
    ADDI.B  #'0',D0
    MOVE.B  D0,-(A0)
    SWAP    D0
    TST.B   D0
    BEQ.S   .leading_space

    ADDI.B  #'0',D0
    BRA.S   .return

.leading_space:
    MOVE.B  #' ',D0

.return:
    MOVE.B  D0,-(A0)
    MOVE.L  (A7)+,D2
    RTS

;!======