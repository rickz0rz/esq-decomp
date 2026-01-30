LAB_1AA9:
    MOVEM.L D5-D7/A2-A3,-(A7)

    MOVE.L  24(A7),D7
    MOVEA.L 28(A7),A3
    MOVE.L  32(A7),D6

    MOVE.L  D7,-(A7)
    JSR     LAB_1A1D(PC)

    ADDQ.W  #4,A7
    MOVEA.L D0,A2
    MOVE.L  A2,D0
    BNE.S   .LAB_1AAA

    MOVEQ   #-1,D0
    BRA.S   .return

.LAB_1AAA:
    MOVE.L  D6,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  4(A2),-(A7)
    JSR     LAB_19F0(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D5
    TST.L   -640(A4)
    BEQ.S   .LAB_1AAB

    MOVEQ   #-1,D0
    BRA.S   .return

.LAB_1AAB:
    MOVE.L  D5,D0

.return:
    MOVEM.L (A7)+,D5-D7/A2-A3
    RTS

;!======

    DC.W    $0000

;!======

LAB_1AAD:
    MOVEA.L 4(A7),A0
    MOVE.L  A0,(A0)
    ADDQ.L  #4,(A0)
    CLR.L   4(A0)
    MOVE.L  A0,8(A0)
    RTS

;!======

    DC.W    $0000

;!======

LAB_1AAE:
    MOVEA.L 4(A7),A0
    MOVEA.L 8(A7),A1
    MOVE.L  12(A7),D0
    BLE.S   LAB_1AB1

    CMPA.L  A0,A1
    BCS.S   LAB_1AB0

    ADDA.L  D0,A0
    ADDA.L  D0,A1

.LAB_1AAF:
    MOVE.B  -(A0),-(A1)
    SUBQ.L  #1,D0
    BNE.S   .LAB_1AAF

    RTS

;!======

LAB_1AB0:
    MOVE.B  (A0)+,(A1)+
    SUBQ.L  #1,D0
    BNE.S   LAB_1AB0

LAB_1AB1:
    RTS

;!======

    ; Alignment
    ALIGN_WORD
