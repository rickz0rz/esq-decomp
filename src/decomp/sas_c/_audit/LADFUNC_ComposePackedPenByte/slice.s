    SECTION text,CODE
    XDEF    _TESTFN
_TESTFN:
    MOVEM.L D2/D6-D7,-(A7)
    MOVE.B  19(A7),D7
    MOVE.B  23(A7),D6
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEQ   #15,D1
    AND.L   D1,D0
    ASL.L   #4,D0
    MOVEQ   #0,D2
    MOVE.B  D6,D2
    AND.L   D1,D2
    OR.L    D2,D0
    MOVEM.L (A7)+,D2/D6-D7
    RTS
    END
