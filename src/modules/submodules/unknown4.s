    XDEF    STRING_ToUpperInPlace

;------------------------------------------------------------------------------
; FUNC: STRING_ToUpperInPlace   (Convert ASCII string to uppercase in place.)
; ARGS:
;   stack +16: A3 = string pointer
; RET:
;   D0: original string pointer
; CLOBBERS:
;   D0-D2/A0-A3
; READS:
;   Global_CharClassTable
; DESC:
;   Walks the string and maps lowercase letters to uppercase.
; NOTES:
;   Uses Global_CharClassTable to decide if a byte is lowercase.
;------------------------------------------------------------------------------
STRING_ToUpperInPlace:
    MOVEM.L D2/A2-A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVEA.L A3,A2

.loop:
    TST.B   (A2)
    BEQ.S   .done

    MOVEQ   #0,D0
    MOVE.B  (A2),D0
    LEA     Global_CharClassTable(A4),A0
    BTST    #1,0(A0,D0.L)
    BEQ.S   .keep_char

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #32,D2
    SUB.L   D2,D1
    BRA.S   .store_char

.keep_char:
    MOVEQ   #0,D1
    MOVE.B  D0,D1

.store_char:
    MOVE.B  D1,(A2)
    ADDQ.L  #1,A2
    BRA.S   .loop

.done:
    MOVE.L  A3,D0
    MOVEM.L (A7)+,D2/A2-A3
    RTS

;!======

    ; Alignment
    ALIGN_WORD
