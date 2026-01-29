LAB_1AB2:
    LINK.W  A5,#-8
    MOVEM.L A2-A3,-(A7)
    LEA     -1120(A4),A3

LAB_1AB3:
    MOVE.L  A3,D0
    BEQ.S   LAB_1AB4

    TST.L   24(A3)
    BEQ.S   LAB_1AB4

    MOVEA.L A3,A2
    MOVEA.L (A3),A3
    BRA.S   LAB_1AB3

LAB_1AB4:
    MOVE.L  A3,D0
    BNE.S   LAB_1AB7

    PEA     34.W
    JSR     LAB_19B7(PC)

    ADDQ.W  #4,A7
    MOVEA.L D0,A3
    TST.L   D0
    BNE.S   LAB_1AB5

    MOVEQ   #0,D0
    BRA.S   LAB_1AB8

LAB_1AB5:
    MOVE.L  A3,(A2)
    MOVEQ   #33,D0
    MOVEQ   #0,D1
    MOVEA.L A3,A0

LAB_1AB6:
    MOVE.B  D1,(A0)+
    DBF     D0,LAB_1AB6

LAB_1AB7:
    MOVE.L  A3,-(A7)
    MOVE.L  12(A5),-(A7)
    MOVE.L  8(A5),-(A7)
    JSR     LAB_19C4(PC)

LAB_1AB8:
    MOVEM.L -16(A5),A2-A3
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD
