LAB_1949:
    MOVEM.L D2/A2-A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVEA.L A3,A2

.LAB_194A:
    TST.B   (A2)
    BEQ.S   .return

    MOVEQ   #0,D0
    MOVE.B  (A2),D0
    LEA     -1007(A4),A0
    BTST    #1,0(A0,D0.L)
    BEQ.S   .LAB_194B

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #32,D2
    SUB.L   D2,D1
    BRA.S   .LAB_194C

.LAB_194B:
    MOVEQ   #0,D1
    MOVE.B  D0,D1

.LAB_194C:
    MOVE.B  D1,(A2)
    ADDQ.L  #1,A2
    BRA.S   .LAB_194A

.return:
    MOVE.L  A3,D0
    MOVEM.L (A7)+,D2/A2-A3
    RTS

;!======

    ; Alignment
    ALIGN_WORD
