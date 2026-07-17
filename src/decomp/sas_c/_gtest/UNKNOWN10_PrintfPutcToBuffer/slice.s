    SECTION text,CODE
    XDEF    _TESTFN
    XREF    Global_PrintfByteCount
    XREF    Global_PrintfBufferPtr
_TESTFN:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7
    ADDQ.L  #1,Global_PrintfByteCount(A4)
    MOVE.L  D7,D0
    MOVEA.L Global_PrintfBufferPtr(A4),A0
    MOVE.B  D0,(A0)+
    MOVE.L  A0,Global_PrintfBufferPtr(A4)
    MOVE.L  (A7)+,D7
    RTS
    END
