    SECTION text,CODE
    XDEF    _TESTFN
_TESTFN:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEQ   #0,D7
    MOVE.L  A3,D0
    BEQ.S   L_return_136E

    MOVEQ   #20,D0
    CMP.B   (A3),D0
    BNE.S   L_return_136E

    TST.B   1(A3)
    BEQ.S   L_return_136E

    MOVE.B  1(A3),D7

L_return_136E:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A3
    RTS
    END
