    SECTION text,CODE
    XDEF    _TESTFN
_TESTFN:
    MOVE.L  D7,-(A7)
    MOVE.W  10(A7),D7
    TST.W   D7
    SEQ     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D7
    MOVE.L  D7,D0
    MOVE.L  (A7)+,D7
    RTS
    END
