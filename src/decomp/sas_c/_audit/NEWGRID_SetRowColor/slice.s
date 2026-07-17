    SECTION text,CODE
    XDEF    _TESTFN
_TESTFN:
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.W  26(A7),D7
    MOVE.L  28(A7),D6
    MOVE.L  D7,D0
    ADDQ.W  #1,D0
    BEQ.S   L_case_pen7

    SUBQ.W  #1,D0
    BEQ.S   L_case_pen4

    SUBQ.W  #1,D0
    BEQ.S   L_case_pen5

    SUBQ.W  #1,D0
    BEQ.S   L_case_pen6

    BRA.S   L_use_default_pen

L_case_pen7:
    MOVEQ   #7,D5
    BRA.S   L_apply_pen_and_slot_index

L_case_pen4:
    MOVEQ   #4,D5
    BRA.S   L_apply_pen_and_slot_index

L_case_pen5:
    MOVEQ   #5,D5
    BRA.S   L_apply_pen_and_slot_index

L_case_pen6:
    MOVEQ   #6,D5
    BRA.S   L_apply_pen_and_slot_index

L_use_default_pen:
    MOVEQ   #4,D5

L_apply_pen_and_slot_index:
    MOVE.L  D5,D0
    SUBQ.L  #4,D0
    MOVE.L  D0,D7
    TST.L   D6
    BMI.S   L_set_default_color_value

    MOVEQ   #16,D0
    CMP.L   D0,D6
    BGT.S   L_set_default_color_value

    MOVE.L  D6,D0
    MOVE.B  D0,55(A3,D7.W)
    BRA.S   L_return_pen

L_set_default_color_value:
    MOVE.B  #$7,55(A3,D7.W)

L_return_pen:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D5-D7/A3
    RTS
    END
