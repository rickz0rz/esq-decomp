    XDEF    _DATETIME_ClassifyValueInRange

;------------------------------------------------------------------------------
; FUNC: _DATETIME_ClassifyValueInRange   (Compare value against struct bounds)
; ARGS:
;   stack +8: A3 = struct pointer
;   stack +12: D7 = value
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A5/A7/D0/D1/D2/D4/D5/D6/D7
; CALLS:
;   none
; READS:
;   A3+8/12/16
; WRITES:
;   -11(A5) (flags)
; DESC:
;   Compares value against two bounds and returns a derived selector.
; NOTES:
;   Switch-like sequence on flags in -11(A5).
;------------------------------------------------------------------------------
_DATETIME_ClassifyValueInRange:
    LINK.W  A5,#-12
    MOVEM.L D2/D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVEQ   #0,D0
    MOVE.B  D0,-11(A5)
    MOVE.L  A3,D1
    BNE.S   .bounds_ready

    MOVEQ   #0,D0
    BRA.W   .return

.bounds_ready:
    MOVE.L  12(A3),D0
    MOVE.L  8(A3),D1
    CMP.L   D0,D1
    BGE.S   .bounds_high_gt_low

    MOVE.B  -11(A5),D2
    MOVE.L  D1,D5
    MOVE.L  D0,D4
    MOVE.B  D2,-11(A5)
    BRA.S   .check_value

.bounds_high_gt_low:
    CMP.L   D0,D1
    BLE.S   .bounds_equal

    BSET    #4,-11(A5)
    MOVE.L  D0,D5
    MOVE.L  D1,D4
    BRA.S   .check_value

.bounds_equal:
    MOVEQ   #0,D0
    BRA.S   .return

.check_value:
    CMP.L   D5,D7
    BGE.S   .value_below_low

    MOVE.B  -11(A5),D0
    MOVE.B  D0,-11(A5)
    BRA.S   .select_case

.value_below_low:
    CMP.L   D4,D7
    BGE.S   .value_above_high

    BSET    #0,-11(A5)
    BRA.S   .select_case

.value_above_high:
    BSET    #1,-11(A5)

.select_case:
    MOVEQ   #0,D0
    MOVE.B  -11(A5),D0
    TST.W   D0
    BEQ.S   .case_flag_0

    SUBQ.W  #1,D0
    BEQ.S   .case_flag_1

    SUBQ.W  #1,D0
    BEQ.S   .case_flag_2

    SUBI.W  #14,D0
    BEQ.S   .case_flag_14

    SUBQ.W  #1,D0
    BEQ.S   .case_flag_15

    SUBQ.W  #1,D0
    BEQ.S   .case_flag_16

    BRA.S   .case_default

.case_flag_0:
    MOVEQ   #0,D6
    BRA.S   .store_result

.case_flag_1:
    MOVEQ   #1,D6
    BRA.S   .store_result

.case_flag_2:
    MOVEQ   #0,D6
    BRA.S   .store_result

.case_flag_14:
    MOVEQ   #1,D6
    BRA.S   .store_result

.case_flag_15:
    MOVEQ   #0,D6
    BRA.S   .store_result

.case_flag_16:
    MOVEQ   #1,D6
    BRA.S   .store_result

.case_default:
    MOVEQ   #0,D6

.store_result:
    MOVE.L  D6,D0

.return:
    MOVEM.L (A7)+,D2/D4-D7/A3
    UNLK    A5
    RTS

;!======