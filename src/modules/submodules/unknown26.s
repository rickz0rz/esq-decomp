LAB_1A34:
    MOVEM.L D5-D7/A2-A3,-(A7)
    MOVE.L  24(A7),D7
    MOVEA.L 28(A7),A3
    MOVE.L  32(A7),D6

    MOVE.L  D7,-(A7)
    JSR     LAB_1A1D(PC)

    ADDQ.W  #4,A7
    MOVEA.L D0,A2
    MOVE.L  A2,D0
    BNE.S   .LAB_1A35

    MOVEQ   #-1,D0
    BRA.S   .return

.LAB_1A35:
    BTST    #3,3(A2)
    BEQ.S   .LAB_1A36

    PEA     2.W
    CLR.L   -(A7)
    MOVE.L  D7,-(A7)
    JSR     LAB_19B3(PC)

    LEA     12(A7),A7

.LAB_1A36:
    MOVE.L  D6,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  4(A2),-(A7)
    JSR     LAB_19E7(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D5
    TST.L   -640(A4)
    BEQ.S   .LAB_1A37

    MOVEQ   #-1,D0
    BRA.S   .return

.LAB_1A37:
    MOVE.L  D5,D0

.return:
    MOVEM.L (A7)+,D5-D7/A2-A3
    RTS

;!======

    ; Alignment
    ALIGN_WORD
