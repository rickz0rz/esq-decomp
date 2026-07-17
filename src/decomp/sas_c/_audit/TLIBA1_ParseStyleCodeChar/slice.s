    SECTION text,CODE
    XDEF    _TESTFN
_TESTFN:
    MOVE.L  D7,-(A7)
    MOVE.B  11(A7),D7
    MOVEQ   #88,D0
    CMP.B   D0,D7
    BNE.S   L_if_ne_176D

    MOVEQ   #-1,D7
    BRA.S   L_return_1770

L_if_ne_176D:
    MOVEQ   #49,D0
    CMP.B   D0,D7
    BCS.S   L_if_cs_176E

    MOVEQ   #55,D0
    CMP.B   D0,D7
    BLS.S   L_if_ls_176F

L_if_cs_176E:
    MOVEQ   #0,D7
    BRA.S   L_return_1770

L_if_ls_176F:
    SUBI.B  #$30,D7

L_return_1770:
    MOVE.L  D7,D0
    MOVE.L  (A7)+,D7
    RTS
    END
