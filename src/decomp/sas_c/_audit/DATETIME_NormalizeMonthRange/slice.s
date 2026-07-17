    SECTION text,CODE
    XDEF    _TESTFN
_TESTFN:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    ; Normalize month range and set overflow flag.
    MOVE.W  8(A3),D0
    MOVEQ   #11,D1
    CMP.W   D1,D0
    BLE.S   L_month_overflow

    MOVEQ   #-1,D1
    BRA.S   L_month_overflow_ready

L_month_overflow:
    MOVEQ   #0,D1

L_month_overflow_ready:
    MOVE.W  D1,18(A3)
    MOVE.W  8(A3),D0
    EXT.L   D0
    MOVEQ   #12,D1
    DIVS    D1,D0
    SWAP    D0
    MOVE.W  D0,8(A3)
    TST.W   D0
    BNE.S   L_return

    MOVE.W  D1,8(A3)

L_return:
    MOVEA.L (A7)+,A3
    RTS
    END
