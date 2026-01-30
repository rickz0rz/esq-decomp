LAB_1AD3:
    MOVE.L  D7,-(A7)

    MOVEQ   #0,D0
    MOVE.L  #$3000,D1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOSetSignal(A6)

    MOVE.L  D0,D7
    ANDI.L  #$3000,D7
    TST.L   D7
    BEQ.S   .LAB_1AD9

    TST.L   -616(A4)
    BEQ.S   .LAB_1AD9

    MOVEA.L -616(A4),A0
    JSR     (A0)

    TST.L   D0
    BNE.S   .LAB_1AD8

    BRA.S   .LAB_1AD9

.LAB_1AD8:
    CLR.L   -616(A4)
    PEA     20.W
    JSR     LAB_1A92(PC)

    ADDQ.W  #4,A7

.LAB_1AD9:
    MOVE.L  (A7)+,D7
    RTS

;!======

    ; Unreachable code?
    BSR.S   LAB_1AD3
    RTS

    ; Alignment?
    DC.W    $0000
