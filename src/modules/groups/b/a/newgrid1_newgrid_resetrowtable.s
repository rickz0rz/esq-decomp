    XDEF    _NEWGRID_ResetRowTable



;------------------------------------------------------------------------------
; FUNC: _NEWGRID_ResetRowTable   (Initialize row indices and slots)
; ARGS:
;   stack +8: A3 = grid struct
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A3
; CALLS:
;   none
; READS:
;   none
; WRITES:
;   55(A3) and 36(A3, index)
; DESC:
;   Initializes four row entries and clears associated slot values.
; NOTES:
;   DBF runs (D0+1) iterations (5 entries incl. zero).
;------------------------------------------------------------------------------
_NEWGRID_ResetRowTable:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEQ   #0,D7

.init_row_slots_loop:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.S   .return_row_table

    MOVE.L  D7,D1
    ADDQ.L  #4,D1
    MOVE.B  D1,55(A3,D7.L)
    MOVE.L  D7,D1
    ASL.L   #2,D1
    CLR.L   36(A3,D1.L)
    ADDQ.L  #1,D7
    BRA.S   .init_row_slots_loop

.return_row_table:
    MOVEM.L (A7)+,D7/A3
    RTS

;!======