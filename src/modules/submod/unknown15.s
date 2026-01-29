LAB_19DC:
    MOVEM.L D4-D7/A2-A3,-(A7)

    MOVEA.L 28(A7),A3
    MOVE.L  32(A7),D7
    MOVEA.L 36(A7),A2

    MOVE.L  A3,D4
    SUBQ.L  #1,D7
    MOVE.L  D7,D6

.LAB_19DD:
    TST.L   D6
    BMI.S   .LAB_19E0

    SUBQ.L  #1,8(A2)
    BLT.S   .LAB_19DE

    MOVEA.L 4(A2),A0
    LEA     1(A0),A1
    MOVE.L  A1,4(A2)
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    BRA.S   .LAB_19DF

.LAB_19DE:
    MOVE.L  A2,-(A7)
    JSR     LAB_1934(PC)

    ADDQ.W  #4,A7

.LAB_19DF:
    MOVE.L  D0,D5
    MOVEQ   #-1,D0
    CMP.L   D0,D5
    BEQ.S   .LAB_19E0

    SUBQ.L  #1,D6
    MOVE.L  D5,D0
    MOVE.B  D0,(A3)+
    MOVEQ   #10,D1
    CMP.L   D1,D5
    BNE.S   .LAB_19DD

.LAB_19E0:
    CLR.B   (A3)
    CMP.L   D7,D6
    BNE.S   .LAB_19E1

    MOVEQ   #0,D0
    BRA.S   .return

.LAB_19E1:
    MOVEA.L D4,A0
    MOVE.L  A0,D0

.return:
    MOVEM.L (A7)+,D4-D7/A2-A3
    RTS

;!======

    ; Alignment
    ALIGN_WORD
