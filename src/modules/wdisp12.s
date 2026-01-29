LAB_19B3:
    MOVEM.L D4-D7/A3,-(A7)
    MOVE.L  24(A7),D7
    MOVE.L  28(A7),D6
    MOVE.L  32(A7),D5
    MOVE.L  D7,-(A7)
    JSR     LAB_1A1D(PC)

    ADDQ.W  #4,A7
    MOVEA.L D0,A3
    MOVE.L  A3,D0
    BNE.S   .LAB_19B4

    MOVEQ   #-1,D0
    BRA.S   .return

.LAB_19B4:
    MOVE.L  D5,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  4(A3),-(A7)
    JSR     LAB_19EA(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D4
    TST.L   -640(A4)
    BEQ.S   .LAB_19B5

    MOVEQ   #-1,D0
    BRA.S   .return

.LAB_19B5:
    MOVE.L  D4,D0

.return:
    MOVEM.L (A7)+,D4-D7/A3
    RTS

;!======

    ; Alignment
    ALIGN_WORD
