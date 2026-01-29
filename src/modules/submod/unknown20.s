LAB_19F3:
    MOVEM.L D2/D6-D7/A3,-(A7)

    MOVEA.L 20(A7),A3
    MOVE.L  24(A7),D7

    TST.L   -616(A4)
    BEQ.S   .LAB_19F4

    JSR     LAB_1AD3(PC)

.LAB_19F4:
    CLR.L   -640(A4)
    MOVE.L  A3,D1
    MOVE.L  D7,D2
    MOVEA.L LocalDosLibraryDisplacement(A4),A6
    JSR     _LVOOpen(A6)

    MOVE.L  D0,D6
    TST.L   D6
    BNE.S   .LAB_19F5

    JSR     _LVOIoErr(A6)

    MOVE.L  D0,-640(A4)
    MOVEQ   #2,D0
    MOVE.L  D0,22828(A4)
    MOVEQ   #-1,D0
    BRA.S   .return

.LAB_19F5:
    MOVE.L  D6,D0

.return:
    MOVEM.L (A7)+,D2/D6-D7/A3
    RTS

;!======

    ; Alignment
    ALIGN_WORD
