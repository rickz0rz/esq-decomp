    XDEF    _ED_FindNextCharInTable


;------------------------------------------------------------------------------
; FUNC: _ED_FindNextCharInTable   (Find next char in tableuncertain)
; ARGS:
;   stack +7: arg_1 (via 11(A5))
;   stack +8: arg_2 (via 12(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A3/A5/A7/D0/D7
; CALLS:
;   _GROUP_AI_JMPTBL_STR_FindCharPtr
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Finds the next non-null byte in a lookup table given a starting char.
; NOTES:
;   If the lookup returns null, it falls back to the table base.
;------------------------------------------------------------------------------
_ED_FindNextCharInTable:
    LINK.W  A5,#-4
    MOVEM.L D7/A3,-(A7)
    MOVE.B  11(A5),D7
    MOVEA.L 12(A5),A3
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    JSR     _GROUP_AI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.S   .use_base_ptr

    ADDQ.L  #1,-4(A5)
    BRA.S   .ensure_nonzero

.use_base_ptr:
    MOVE.L  A3,-4(A5)

.ensure_nonzero:
    MOVEA.L -4(A5),A0
    TST.B   (A0)
    BNE.S   .return_char

    MOVE.L  A3,-4(A5)

.return_char:
    MOVEA.L -4(A5),A0
    MOVE.B  (A0),D0
    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======