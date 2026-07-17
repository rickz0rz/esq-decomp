    SECTION text,CODE
    XDEF    _TESTFN
_TESTFN:
    MOVEM.L D2/D6-D7,-(A7)
    MOVE.B  19(A7),D7
    MOVE.B  23(A7),D6
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEQ   #120,D1
    ADD.L   D1,D1
    AND.L   D1,D0
    MOVEQ   #0,D1
    MOVE.B  D6,D1
    MOVEQ   #15,D2
    AND.L   D2,D1
    OR.L    D1,D0
    MOVEM.L (A7)+,D2/D6-D7
    RTS
    END
