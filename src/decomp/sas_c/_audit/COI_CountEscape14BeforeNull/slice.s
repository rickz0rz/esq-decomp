    SECTION text,CODE
    XDEF    _TESTFN
_TESTFN:
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 24(A7),A3
    MOVE.L  28(A7),D7
    MOVEQ   #0,D5
    MOVEQ   #0,D6
    MOVE.L  D6,D4

L_scan_loop:
    TST.W   D5
    BNE.S   L_done

    MOVE.L  D6,D0
    EXT.L   D0
    CMP.L   D7,D0
    BGE.S   L_done

    MOVEQ   #0,D0
    MOVE.B  0(A3,D6.W),D0
    TST.W   D0
    BEQ.S   L_found_null

    SUBI.W  #20,D0
    BEQ.S   L_found_escape

    BRA.S   L_advance

L_found_null:
    MOVEQ   #1,D5
    BRA.S   L_advance

L_found_escape:
    ADDQ.W  #1,D4
    ADDQ.W  #1,D6

L_advance:
    ADDQ.W  #1,D6
    BRA.S   L_scan_loop

L_done:
    MOVE.L  D4,D0
    MOVEM.L (A7)+,D4-D7/A3
    RTS
    END
