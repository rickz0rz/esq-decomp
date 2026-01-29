LAB_19B7:
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVE.L  20(A7),D7
    TST.L   D7
    BGT.S   LAB_19B8

    MOVEQ   #0,D0
    BRA.W   LAB_19BF

LAB_19B8:
    MOVEQ   #8,D0
    CMP.L   D0,D7
    BCC.S   LAB_19B9

    MOVE.L  D0,D7

LAB_19B9:
    MOVE.L  D7,D0
    ADDQ.L  #3,D0
    MOVE.L  D0,D7
    ANDI.W  #$fffc,D7
    LEA     -1132(A4),A2
    MOVEA.L (A2),A3

LAB_19BA:
    MOVE.L  A3,D0
    BEQ.S   LAB_19BD

    MOVE.L  4(A3),D0
    CMP.L   D7,D0
    BLT.S   LAB_19BC

    CMP.L   D7,D0
    BNE.S   LAB_19BB

    MOVEA.L (A3),A0
    MOVE.L  A0,(A2)
    SUB.L   D7,-1128(A4)
    MOVE.L  A3,D0
    BRA.S   LAB_19BF

LAB_19BB:
    MOVE.L  4(A3),D0
    SUB.L   D7,D0
    MOVEQ   #8,D1
    CMP.L   D1,D0
    BCS.S   LAB_19BC

    MOVEA.L A3,A0
    ADDA.L  D7,A0
    MOVE.L  A0,(A2)
    MOVEA.L A0,A2
    MOVE.L  (A3),(A2)
    MOVE.L  D0,4(A2)
    SUB.L   D7,-1128(A4)
    MOVE.L  A3,D0
    BRA.S   LAB_19BF

LAB_19BC:
    MOVEA.L A3,A2
    MOVEA.L (A3),A3
    BRA.S   LAB_19BA

LAB_19BD:
    MOVE.L  D7,D0
    MOVE.L  -1012(A4),D1
    ADD.L   D1,D0
    SUBQ.L  #1,D0
    JSR     LAB_1A07(PC)

    MOVE.L  -1012(A4),D1
    JSR     LAB_1A06(PC)

    MOVE.L  D0,D6
    ADDQ.L  #8,D6
    MOVE.L  D6,D0
    ADDQ.L  #3,D0
    MOVE.L  D0,D6
    ANDI.W  #$fffc,D6
    MOVE.L  D6,-(A7)
    JSR     LAB_1A29(PC)

    ADDQ.W  #4,A7
    MOVEA.L D0,A3
    MOVE.L  A3,D0
    BEQ.S   LAB_19BE

    MOVE.L  D6,-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_1A9D(PC)

    MOVE.L  D7,(A7)
    BSR.W   LAB_19B7

    ADDQ.W  #8,A7
    BRA.S   LAB_19BF

LAB_19BE:
    MOVEQ   #0,D0

LAB_19BF:
    MOVEM.L (A7)+,D6-D7/A2-A3
    RTS

;!======

    ; Alignment
    ORI.B   #0,D0
    ORI.B   #0,D0
    MOVEQ   #97,D0
