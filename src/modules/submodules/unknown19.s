LAB_19F0:
    MOVEM.L D2-D3/D5-D7/A3,-(A7)

    MOVE.L  28(A7),D7
    MOVEA.L 32(A7),A3
    MOVE.L  36(A7),D6

    TST.L   -616(A4)
    BEQ.S   .LAB_19F1

    JSR     LAB_1AD3(PC)

.LAB_19F1:
    CLR.L   -640(A4)
    MOVE.L  D7,D1
    MOVE.L  A3,D2
    MOVE.L  D6,D3
    MOVEA.L LocalDosLibraryDisplacement(A4),A6
    JSR     _LVORead(A6)

    MOVE.L  D0,D5
    MOVEQ   #-1,D0
    CMP.L   D0,D5
    BNE.S   .return

    JSR     _LVOIoErr(A6)

    MOVE.L  D0,-640(A4)
    MOVEQ   #5,D0
    MOVE.L  D0,22828(A4)

.return:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D2-D3/D5-D7/A3
    RTS

;!======

    ; Alignment
    ORI.B   #0,D0
    ORI.B   #0,D0
    ORI.B   #0,D0
    ORI.B   #0,D0
    ORI.B   #0,D0
    ORI.B   #0,D0
    DC.W    $0000
