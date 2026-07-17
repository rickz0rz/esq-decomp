    SECTION text,CODE
    XDEF    _TESTFN
_TESTFN:
    MOVEM.L D5-D7,-(A7)
    MOVE.W  18(A7),D7
    MOVE.W  22(A7),D6
    MOVE.W  26(A7),D5

L_lab_0560:
    CMP.W   D6,D7
    BGE.S   L_lab_0561

    ADD.W   D5,D7
    BRA.S   L_lab_0560

L_lab_0561:
    CMP.W   D5,D7
    BLE.S   L_return

    SUB.W   D5,D7
    BRA.S   L_lab_0561

L_return:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D5-D7
    RTS
    END
