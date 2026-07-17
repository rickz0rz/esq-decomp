    SECTION text,CODE
    XDEF    _TESTFN
_TESTFN:
    MOVEM.L D6-D7,-(A7)
    MOVE.W  14(A7),D7
    MOVE.W  18(A7),D6

    ; If we're over 12 hours, jump.
    MOVEQ   #12,D0
    CMP.W   D0,D7
    BNE.S   L_add12ToHour

    ; If D6 is not 0, jump.
    TST.W   D6
    BNE.S   L_add12ToHour

    ; Return 0 if we're 12 AM.
    MOVEQ   #0,D7
    BRA.S   L_return

L_add12ToHour:
    CMP.W   D0,D7
    BGE.S   L_return

    MOVEQ   #-1,D1
    CMP.W   D1,D6
    BNE.S   L_return

    ADDI.W  #12,D7

L_return:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVEM.L (A7)+,D6-D7
    RTS
    END
