LAB_1A20:
    LINK.W  A5,#-4
    MOVE.L  A3,-(A7)
    MOVEA.L 16(A7),A3

    MOVE.L  A3,D0
    BNE.S   .LAB_1A21

    MOVEQ   #0,D0
    BRA.S   .return

.LAB_1A21:
    MOVE.L  A3,-(A7)
    JSR     LAB_1985(PC)

    MOVEA.L D0,A3
    PEA     -4(A5)
    MOVE.L  A3,-(A7)
    JSR     LAB_1992(PC)

    MOVE.L  -4(A5),D0

.return:
    MOVEA.L -8(A5),A3
    UNLK    A5
    RTS

;!======

LAB_1A23:
    LINK.W  A5,#-4
    MOVE.L  A3,-(A7)
    MOVEA.L 16(A7),A3

    MOVE.L  A3,D0
    BNE.S   .LAB_1A24

    MOVEQ   #0,D0
    BRA.S   .return

.LAB_1A24:
    MOVE.L  A3,-(A7)
    JSR     LAB_1985(PC)

    MOVEA.L D0,A3
    PEA     -4(A5)
    MOVE.L  A3,-(A7)
    JSR     LAB_199A(PC)

    MOVE.L  -4(A5),D0

.return:
    MOVEA.L -8(A5),A3
    UNLK    A5
    RTS

;!======

LAB_1A26:
    MOVEM.L A2-A3/A6,-(A7)
    MOVEA.L 22836(A4),A3

.LAB_1A27:
    MOVE.L  A3,D0
    BEQ.S   .LAB_1A28

    MOVEA.L (A3),A2
    MOVEA.L A3,A1
    MOVE.L  8(A3),D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOFreeMem(A6)

    MOVEA.L A2,A3
    BRA.S   .LAB_1A27

.LAB_1A28:
    SUBA.L  A0,A0
    MOVE.L  A0,22840(A4)
    MOVE.L  A0,22836(A4)
    MOVEM.L (A7)+,A2-A3/A6
    RTS

;!======

LAB_1A29:
    MOVEM.L D7/A2-A3/A6,-(A7)
    MOVE.L  20(A7),D7

    MOVEQ   #12,D0
    ADD.L   D0,D7
    MOVE.L  D7,D0
    MOVEQ   #0,D1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOAllocMem(A6)

    MOVEA.L D0,A3
    MOVE.L  A3,D0
    BNE.S   .LAB_1A2A

    MOVEQ   #0,D0
    BRA.S   .return

.LAB_1A2A:
    MOVE.L  D7,8(A3)
    LEA     22836(A4),A2
    MOVEA.L 4(A2),A0
    MOVE.L  A0,4(A3)
    SUBA.L  A0,A0
    MOVE.L  A0,(A3)
    TST.L   (A2)
    BNE.S   .LAB_1A2B

    MOVE.L  A3,(A2)

.LAB_1A2B:
    TST.L   4(A2)
    BEQ.S   .LAB_1A2C

    MOVEA.L 4(A2),A1
    MOVE.L  A3,(A1)

.LAB_1A2C:
    MOVE.L  A3,4(A2)
    TST.L   -1144(A4)
    BNE.S   .LAB_1A2D

    MOVE.L  A3,-1144(A4)

.LAB_1A2D:
    LEA     12(A3),A0
    MOVE.L  A0,D0

.return:
    MOVEM.L (A7)+,D7/A2-A3/A6
    RTS

;!======

    ; Alignment
    ORI.B   #0,D0
    ORI.B   #0,D0
    ORI.B   #0,D0
    DC.W    $0000
