LAB_1A8E:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    TST.L   20(A3)
    BEQ.S   .LAB_1A8F

    BTST    #3,27(A3)
    BNE.S   .LAB_1A8F

    MOVEQ   #0,D0
    BRA.S   .LAB_1A91

.LAB_1A8F:
    MOVE.L  -748(A4),-(A7)
    JSR     LAB_19B7(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,4(A3)
    MOVE.L  D0,16(A3)
    TST.L   D0
    BNE.S   .LAB_1A90

    MOVEQ   #12,D0
    MOVE.L  D0,22828(A4)
    MOVEQ   #-1,D0
    BRA.S   .LAB_1A91

.LAB_1A90:
    MOVE.L  -748(A4),20(A3)
    MOVEQ   #-13,D0
    AND.L   D0,24(A3)
    MOVEQ   #0,D0
    MOVE.L  D0,12(A3)
    MOVE.L  D0,8(A3)

.LAB_1A91:
    MOVEA.L (A7)+,A3
    RTS

;!======

    ; Alignment
    ORI.B   #0,D0
    ORI.B   #0,D0
    MOVEQ   #97,D0
