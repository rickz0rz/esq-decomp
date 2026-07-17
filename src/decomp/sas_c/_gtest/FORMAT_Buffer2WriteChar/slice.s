    SECTION text,CODE
    XDEF    _TESTFN
    XREF    Global_FormatByteCount2
    XREF    Global_FormatBufferPtr2
_TESTFN:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7
    ADDQ.L  #1,Global_FormatByteCount2(A4)
    MOVE.L  D7,D0
    MOVEA.L Global_FormatBufferPtr2(A4),A0
    MOVE.B  D0,(A0)+
    MOVE.L  A0,Global_FormatBufferPtr2(A4)
    MOVE.L  (A7)+,D7
    RTS
    END
