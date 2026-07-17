    SECTION text,CODE
    XDEF    _TESTFN
_TESTFN:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7/A3
    RTS
    END
