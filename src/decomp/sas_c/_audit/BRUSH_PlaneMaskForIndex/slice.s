    SECTION text,CODE
    XDEF    _TESTFN
_TESTFN:
    MOVE.L  D7,-(A7)

    MOVE.L  8(A7),D7
    TST.L   D7
    BLE.S   L_planemask_invalid_index

    MOVEQ   #9,D0
    CMP.L   D0,D7
    BGE.S   L_planemask_invalid_index

    MOVEQ   #1,D0
    ASL.L   D7,D0
    BRA.S   L_planemask_return

L_planemask_invalid_index:
    MOVEQ   #0,D0

L_planemask_return:
    MOVE.L  (A7)+,D7
    RTS
    END
