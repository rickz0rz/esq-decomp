    SECTION text,CODE
    XDEF    _TESTFN
_TESTFN:
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
    RTS
    END
