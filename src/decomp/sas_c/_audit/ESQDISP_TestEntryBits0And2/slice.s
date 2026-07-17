    SECTION text,CODE
    XDEF    _TESTFN
_TESTFN:
;------------------------------------------------------------------------------
; FUNC: ESQDISP_TestEntryBits0And2_Core   (Test entry flags bit0 and bit2)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A7/D0/D7
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Returns 1 only when both bit0 and bit2 are set in entry status byte +40.
; NOTES:
;   Returns 0 for NULL entry pointers.
;------------------------------------------------------------------------------
ESQDISP_TestEntryBits0And2_Core:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3

    MOVEQ   #0,D7
    MOVE.L  A3,D0
    BEQ.S   L_return

    BTST    #0,40(A3)
    BEQ.S   L_bits_not_set

    BTST    #2,40(A3)
    BEQ.S   L_bits_not_set

    MOVEQ   #1,D0
    BRA.S   L_store_result

L_bits_not_set:
    MOVEQ   #0,D0

L_store_result:
    MOVE.L  D0,D7

L_return:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A3
    RTS
    END
