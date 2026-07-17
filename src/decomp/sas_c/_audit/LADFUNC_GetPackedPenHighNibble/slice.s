    SECTION text,CODE
    XDEF    _TESTFN
_TESTFN:
    MOVE.L  D7,-(A7)
    MOVE.B  11(A7),D7
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    ASR.L   #4,D0
    MOVEQ   #15,D1
    AND.L   D1,D0
    MOVE.L  (A7)+,D7
    RTS
    END
