    XDEF    _TESTFN
    SECTION text,CODE
_TESTFN:
    MOVEM.L D2,-(A7)          ; preserve callee-saved D2 (the raw regargs body clobbers it)
    MOVE.L  8(A7),A1          ; stdargs src pointer (stack shifted by the MOVEM push)
    MOVE.B  (A1)+,D2
    MOVE.B  (A1)+,D1
    MOVE.B  (A1)+,D0
    ANDI.W  #15,D2
    ANDI.W  #15,D1
    ANDI.W  #15,D0
    LSL.W   #8,D2
    LSL.W   #4,D1
    ADD.W   D1,D0
    ADD.W   D2,D0
    MOVEM.L (A7)+,D2
    RTS
    END
