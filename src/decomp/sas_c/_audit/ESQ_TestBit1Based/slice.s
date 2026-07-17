    SECTION text,CODE
    XDEF    _TESTFN
_TESTFN:
    MOVEA.L 4(A7),A0
    MOVE.L  8(A7),D0
    MOVEQ   #0,D1
    SUBQ.L  #1,D0
    MOVE.B  D0,D1
    ANDI.L  #$7,D1
    LSR.W   #3,D0
    BTST    D1,0(A0,D0.W)
    SNE     D0
    EXT.W   D0
    EXT.L   D0
    RTS
    END
