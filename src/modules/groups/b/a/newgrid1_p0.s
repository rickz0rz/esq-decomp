    XDEF    _NEWGRID_SetRowColor



;------------------------------------------------------------------------------
; FUNC: _NEWGRID_SetRowColor   (Set row color slot)
; ARGS:
;   stack +8: A3 = grid struct
;   stack +12: D7 = selector (0..3)
;   stack +16: D6 = color index (0..16) or -1
; RET:
;   D0: selected pen index
; CLOBBERS:
;   D0-D7/A3
; CALLS:
;   none
; READS:
;   none
; WRITES:
;   55(A3, row)
; DESC:
;   Maps selector to a pen index and updates row color if D6 is in range.
; NOTES:
;   Out-of-range color defaults to 7.
;------------------------------------------------------------------------------
_NEWGRID_SetRowColor:
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.W  26(A7),D7
    MOVE.L  28(A7),D6
    MOVE.L  D7,D0
    ADDQ.W  #1,D0
    BEQ.S   .case_pen7

    SUBQ.W  #1,D0
    BEQ.S   .case_pen4

    SUBQ.W  #1,D0
    BEQ.S   .case_pen5

    SUBQ.W  #1,D0
    BEQ.S   .case_pen6

    BRA.S   .use_default_pen

.case_pen7:
    MOVEQ   #7,D5
    BRA.S   .apply_pen_and_slot_index

.case_pen4:
    MOVEQ   #4,D5
    BRA.S   .apply_pen_and_slot_index

.case_pen5:
    MOVEQ   #5,D5
    BRA.S   .apply_pen_and_slot_index

.case_pen6:
    MOVEQ   #6,D5
    BRA.S   .apply_pen_and_slot_index

.use_default_pen:
    MOVEQ   #4,D5

.apply_pen_and_slot_index:
    MOVE.L  D5,D0
    SUBQ.L  #4,D0
    MOVE.L  D0,D7
    TST.L   D6
    BMI.S   .set_default_color_value

    MOVEQ   #16,D0
    CMP.L   D0,D6
    BGT.S   .set_default_color_value

    MOVE.L  D6,D0
    MOVE.B  D0,55(A3,D7.W)
    BRA.S   .return_pen

.set_default_color_value:
    MOVE.B  #$7,55(A3,D7.W)

.return_pen:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======