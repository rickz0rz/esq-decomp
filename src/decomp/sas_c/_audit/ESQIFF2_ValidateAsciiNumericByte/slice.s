    SECTION text,CODE
    XDEF    _TESTFN
_TESTFN:
    MOVE.L  D7,-(A7)
    MOVE.B  11(A7),D7

    MOVEQ   #1,D0
    CMP.B   D0,D7
    BLT.S   L_return

    MOVEQ   #48,D1
    CMP.B   D1,D7
    BGT.S   L_return

    MOVE.L  D7,D0

L_return:
    MOVE.L  (A7)+,D7
    RTS
    END
