LAB_1A1D:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7

    MOVEQ   #0,D0
    MOVE.L  D0,-640(A4)
    TST.L   D7
    BMI.S   .LAB_1A1E

    CMP.L   -1148(A4),D7
    BGE.S   .LAB_1A1E

    MOVE.L  D7,D0
    ASL.L   #3,D0
    LEA     22492(A4),A0
    TST.L   0(A0,D0.L)
    BEQ.S   .LAB_1A1E

    MOVE.L  D7,D0
    ASL.L   #3,D0
    LEA     22492(A4),A0
    ADDA.L  D0,A0
    MOVE.L  A0,D0
    BRA.S   .return

.LAB_1A1E:
    MOVEQ   #9,D0
    MOVE.L  D0,22828(A4)
    MOVEQ   #0,D0

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======

    ; Alignment
    ALIGN_WORD
