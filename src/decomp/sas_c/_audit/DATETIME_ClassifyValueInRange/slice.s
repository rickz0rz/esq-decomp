    SECTION text,CODE
    XDEF    _TESTFN
_TESTFN:
    LINK.W  A5,#-12
    MOVEM.L D2/D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVEQ   #0,D0
    MOVE.B  D0,-11(A5)
    MOVE.L  A3,D1
    BNE.S   L_bounds_ready

    MOVEQ   #0,D0
    BRA.W   L_return

L_bounds_ready:
    MOVE.L  12(A3),D0
    MOVE.L  8(A3),D1
    CMP.L   D0,D1
    BGE.S   L_bounds_high_gt_low

    MOVE.B  -11(A5),D2
    MOVE.L  D1,D5
    MOVE.L  D0,D4
    MOVE.B  D2,-11(A5)
    BRA.S   L_check_value

L_bounds_high_gt_low:
    CMP.L   D0,D1
    BLE.S   L_bounds_equal

    BSET    #4,-11(A5)
    MOVE.L  D0,D5
    MOVE.L  D1,D4
    BRA.S   L_check_value

L_bounds_equal:
    MOVEQ   #0,D0
    BRA.S   L_return

L_check_value:
    CMP.L   D5,D7
    BGE.S   L_value_below_low

    MOVE.B  -11(A5),D0
    MOVE.B  D0,-11(A5)
    BRA.S   L_select_case

L_value_below_low:
    CMP.L   D4,D7
    BGE.S   L_value_above_high

    BSET    #0,-11(A5)
    BRA.S   L_select_case

L_value_above_high:
    BSET    #1,-11(A5)

L_select_case:
    MOVEQ   #0,D0
    MOVE.B  -11(A5),D0
    TST.W   D0
    BEQ.S   L_case_flag_0

    SUBQ.W  #1,D0
    BEQ.S   L_case_flag_1

    SUBQ.W  #1,D0
    BEQ.S   L_case_flag_2

    SUBI.W  #14,D0
    BEQ.S   L_case_flag_14

    SUBQ.W  #1,D0
    BEQ.S   L_case_flag_15

    SUBQ.W  #1,D0
    BEQ.S   L_case_flag_16

    BRA.S   L_case_default

L_case_flag_0:
    MOVEQ   #0,D6
    BRA.S   L_store_result

L_case_flag_1:
    MOVEQ   #1,D6
    BRA.S   L_store_result

L_case_flag_2:
    MOVEQ   #0,D6
    BRA.S   L_store_result

L_case_flag_14:
    MOVEQ   #1,D6
    BRA.S   L_store_result

L_case_flag_15:
    MOVEQ   #0,D6
    BRA.S   L_store_result

L_case_flag_16:
    MOVEQ   #1,D6
    BRA.S   L_store_result

L_case_default:
    MOVEQ   #0,D6

L_store_result:
    MOVE.L  D6,D0

L_return:
    MOVEM.L (A7)+,D2/D4-D7/A3
    UNLK    A5
    RTS
    END
