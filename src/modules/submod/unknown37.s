LAB_1ACC:
    MOVEM.L D7/A3,-(A7)

    MOVE.L  12(A7),D7
    MOVE.L  D7,-(A7)
    JSR     LAB_1A1D(PC)

    ADDQ.W  #4,A7
    MOVEA.L D0,A3
    MOVE.L  A3,D0
    BNE.S   .LAB_1ACD

    MOVEQ   #-1,D0
    BRA.S   .return

.LAB_1ACD:
    BTST    #4,3(A3)
    BEQ.S   .LAB_1ACF

    MOVEQ   #0,D0
    MOVE.L  D0,(A3)
    BRA.S   .return

.LAB_1ACF:
    MOVE.L  4(A3),-(A7)
    JSR     LAB_1A04(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D0
    MOVE.L  D0,(A3)
    TST.L   -640(A4)
    BEQ.S   .LAB_1AD1

    MOVEQ   #-1,D0
    BRA.S   .return

.LAB_1AD1:
    MOVEQ   #0,D0

.return:
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

    ; Alignment?
    ORI.B   #0,D0
    DC.W    $0000
    MOVEQ   #97,D0
