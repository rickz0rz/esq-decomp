LAB_1A97:
    MOVEA.L 4(A7),A0
    MOVEA.L 8(A7),A1
    MOVEM.L A2-A3,-(A7)
    BRA.S   LAB_1A99

LAB_1A98:
    CMPI.B  #0,(A2)
    BEQ.S   LAB_1A9B

    ADDQ.L  #1,A0
    CMPI.B  #0,(A0)
    BEQ.S   LAB_1A9B

LAB_1A99:
    MOVEA.L A0,A2
    MOVEA.L A1,A3

LAB_1A9A:
    CMPI.B  #0,(A3)
    BEQ.S   LAB_1A9C

    CMPM.B  (A2)+,(A3)+
    BNE.S   LAB_1A98

    BRA.S   LAB_1A9A

LAB_1A9B:
    MOVEQ   #0,D0
    MOVEM.L (A7)+,A2-A3
    RTS

;!======

LAB_1A9C:
    MOVE.L  A0,D0
    MOVEM.L (A7)+,A2-A3
    RTS

;!======

LAB_1A9D:
    LINK.W  A5,#-24
    MOVEM.L D7/A2-A3/A6,-(A7)
    MOVE.L  52(A7),D7
    TST.L   D7
    BGT.S   LAB_1A9E

    MOVEQ   #-1,D0
    BRA.W   LAB_1AA8

LAB_1A9E:
    MOVEQ   #8,D0
    CMP.L   D0,D7
    BCC.S   LAB_1A9F

    MOVE.L  D0,D7

LAB_1A9F:
    MOVE.L  D7,D0
    ADDQ.L  #3,D0
    MOVE.L  D0,D7
    ANDI.W  #$fffc,D7
    MOVEA.L 8(A5),A2
    MOVE.L  8(A5),D0
    ADD.L   D7,D0
    ADD.L   D7,-1128(A4)
    LEA     -1132(A4),A0
    MOVEA.L (A0),A3
    MOVE.L  D0,-16(A5)
    MOVE.L  A0,-12(A5)

LAB_1AA0:
    MOVE.L  A3,D0
    BEQ.W   LAB_1AA7

    MOVEA.L A3,A0
    MOVE.L  4(A3),D0
    ADDA.L  D0,A0
    MOVE.L  A0,-20(A5)
    MOVEA.L -16(A5),A1
    CMPA.L  A1,A3
    BLS.S   LAB_1AA1

    MOVE.L  A3,(A2)
    MOVE.L  D7,4(A2)
    MOVEA.L -12(A5),A6
    MOVE.L  A2,(A6)
    MOVEQ   #0,D0
    BRA.S   LAB_1AA8

LAB_1AA1:
    CMPA.L  A1,A3
    BNE.S   LAB_1AA2

    MOVEA.L (A3),A6
    MOVE.L  A6,(A2)
    MOVE.L  4(A3),D0
    MOVE.L  D0,D1
    ADD.L   D7,D1
    MOVE.L  D1,4(A2)
    MOVEA.L -12(A5),A6
    MOVE.L  A2,(A6)
    MOVEQ   #0,D0
    BRA.S   LAB_1AA8

LAB_1AA2:
    CMPA.L  A0,A2
    BCC.S   LAB_1AA3

    SUB.L   D7,-1128(A4)
    MOVEQ   #-1,D0
    BRA.S   LAB_1AA8

LAB_1AA3:
    CMPA.L  A0,A2
    BNE.S   LAB_1AA6

    TST.L   (A3)
    BEQ.S   LAB_1AA4

    MOVEA.L (A3),A0
    CMPA.L  A0,A1
    BLS.S   LAB_1AA4

    SUB.L   D7,-1128(A4)
    MOVEQ   #-1,D0
    BRA.S   LAB_1AA8

LAB_1AA4:
    ADD.L   D7,4(A3)
    TST.L   (A3)
    BEQ.S   LAB_1AA5

    CMPA.L  (A3),A1
    BNE.S   LAB_1AA5

    MOVE.L  4(A1),D0
    ADD.L   D0,4(A3)
    MOVE.L  (A1),(A3)

LAB_1AA5:
    MOVEQ   #0,D0
    BRA.S   LAB_1AA8

LAB_1AA6:
    MOVE.L  A3,-12(A5)
    MOVE.L  -20(A5),-24(A5)
    MOVEA.L (A3),A3
    BRA.W   LAB_1AA0

LAB_1AA7:
    MOVEA.L -12(A5),A0
    MOVE.L  A2,(A0)
    CLR.L   (A2)
    MOVE.L  D7,4(A2)
    MOVEQ   #0,D0

LAB_1AA8:
    MOVEM.L (A7)+,D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

    ; Alignment
    ORI.B   #0,D0
    ORI.B   #0,D0
    MOVEQ   #97,D0
