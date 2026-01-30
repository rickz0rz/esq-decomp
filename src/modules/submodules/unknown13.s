LAB_19C0:
    MOVEM.L D7/A2,-(A7)
    MOVE.L  12(A7),D7
    ADDQ.L  #1,22824(A4)
    MOVEA.L 22820(A4),A0
    SUBQ.L  #1,12(A0)
    BLT.S   .LAB_19C1

    MOVEA.L 4(A0),A1
    LEA     1(A1),A2
    MOVE.L  A2,4(A0)
    MOVE.L  D7,D0
    MOVE.B  D0,(A1)
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    BRA.S   .LAB_19C2

.LAB_19C1:
    MOVE.L  D7,D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  A0,-(A7)
    MOVE.L  D1,-(A7)
    JSR     LAB_1916(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D1

.LAB_19C2:
    MOVEM.L (A7)+,D7/A2
    RTS

;!======

LAB_19C3:
    LINK.W  A5,#0
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVEA.L 20(A7),A2
    CLR.L   22824(A4)
    MOVE.L  A3,22820(A4)
    PEA     16(A5)
    MOVE.L  A2,-(A7)
    PEA     LAB_19C0(PC)
    JSR     WDISP_FormatWithCallback(PC)

    MOVE.L  A3,(A7)
    PEA     -1.W
    JSR     LAB_1916(PC)

    MOVE.L  22824(A4),D0
    MOVEM.L -8(A5),A2-A3
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD
