LIBRARIES_LOAD_FAILED:
    MOVEM.L D6-D7/A3,-(A7)
    MOVE.L  16(A7),D7
    LEA     -1120(A4),A3

.LAB_19E4:
    MOVE.L  A3,D0
    BEQ.S   .LAB_19E6

    BTST    #2,27(A3)
    BNE.S   .LAB_19E5

    BTST    #1,27(A3)
    BEQ.S   .LAB_19E5

    MOVE.L  4(A3),D0
    SUB.L   16(A3),D0
    MOVE.L  D0,D6
    TST.L   D6
    BEQ.S   .LAB_19E5

    MOVE.L  D6,-(A7)
    MOVE.L  16(A3),-(A7)
    MOVE.L  28(A3),-(A7)
    JSR     LAB_1A34(PC)

    LEA     12(A7),A7

.LAB_19E5:
    MOVEA.L (A3),A3
    BRA.S   .LAB_19E4

.LAB_19E6:
    MOVE.L  D7,-(A7)
    JSR     LAB_1A92(PC)

    ADDQ.W  #4,A7
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======

    ; Alignment
    ALIGN_WORD
