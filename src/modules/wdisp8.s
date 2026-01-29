LAB_1970:
    LINK.W  A5,#-8
    MOVEM.L D5-D7/A2-A3,-(A7)

    MOVEA.L 36(A7),A3
    MOVE.L  44(A7),D7
    MOVEA.L 48(A7),A2
    MOVEQ   #0,D6

.LAB_1971:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    CMP.L   D0,D6
    BGE.S   .LAB_1974

    TST.B   0(A3,D6.L)
    BEQ.S   .LAB_1974

    MOVEQ   #0,D5

.LAB_1972:
    TST.B   0(A2,D5.L)
    BEQ.S   .LAB_1973

    MOVE.B  0(A3,D6.L),D0
    CMP.B   0(A2,D5.L),D0
    BEQ.S   .LAB_1973

    ADDQ.L  #1,D5
    BRA.S   .LAB_1972

.LAB_1973:
    TST.B   0(A2,D5.L)
    BNE.S   .LAB_1974

    MOVEA.L 12(A5),A0
    MOVE.B  0(A3,D6.L),0(A0,D6.L)
    ADDQ.L  #1,D6
    BRA.S   .LAB_1971

.LAB_1974:
    MOVEA.L 12(A5),A0
    CLR.B   0(A0,D6.L)
    MOVEA.L A3,A0
    ADDA.L  D6,A0
    MOVE.L  A0,D0

    MOVEM.L (A7)+,D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_1975:
    MOVEM.L D7/A3,-(A7)

    MOVEA.L 12(A7),A3
    MOVE.L  16(A7),D7

.LAB_1976:
    MOVEQ   #0,D0
    MOVE.B  (A3),D0
    CMP.L   D7,D0
    BNE.S   .LAB_1977

    MOVE.L  A3,D0
    BRA.S   .return

.LAB_1977:
    MOVE.B  (A3)+,D0
    TST.B   D0
    BNE.S   .LAB_1976

    MOVEQ   #0,D0

.return:
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

LAB_1979:
    MOVEM.L D7/A3,-(A7)

    MOVEA.L 12(A7),A3
    MOVE.L  16(A7),D7
    MOVE.L  D7,-(A7)
    MOVE.L  A3,-(A7)
    BSR.S   LAB_1975

    ADDQ.W  #8,A7

    MOVEM.L (A7)+,D7/A3
    RTS

;!======

    ; Dead code
    MOVEM.L D7/A2-A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVE.L  20(A7),D7
    SUBA.L  A2,A2

LAB_197A:
    TST.B   (A3)
    BEQ.S   .return

    MOVEQ   #0,D0
    MOVE.B  (A3),D0
    CMP.L   D7,D0
    BNE.S   .LAB_197B

    MOVEA.L A3,A2

.LAB_197B:
    ADDQ.L  #1,A3
    BRA.S   LAB_197A

.return:
    MOVE.L  A2,D0
    MOVEM.L (A7)+,D7/A2-A3
    RTS

;!======

LAB_197D:
    LINK.W  A5,#-4
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVEA.L 24(A7),A2

.LAB_197E:
    TST.B   (A3)
    BEQ.S   .LAB_1982

    MOVE.L  A2,-4(A5)

.LAB_197F:
    MOVEA.L -4(A5),A0
    TST.B   (A0)
    BEQ.S   .LAB_1981

    MOVE.B  (A0),D0
    CMP.B   (A3),D0
    BNE.S   .LAB_1980

    MOVE.L  A3,D0
    BRA.S   .return

.LAB_1980:
    ADDQ.L  #1,-4(A5)
    BRA.S   .LAB_197F

.LAB_1981:
    ADDQ.L  #1,A3
    BRA.S   .LAB_197E

.LAB_1982:
    MOVEQ   #0,D0

.return:
    MOVEM.L (A7)+,A2-A3
    UNLK    A5
    RTS

;!======

LAB_1984:
    MOVEM.L A2-A3,-(A7)

    MOVEA.L 12(A7),A3
    MOVEA.L 16(A7),A2
    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.S   LAB_197D

    ADDQ.W  #8,A7

    MOVEM.L (A7)+,A2-A3
    RTS

;!======

LAB_1985:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3

.LAB_1986:
    MOVEQ   #0,D0
    MOVE.B  (A3),D0
    LEA     -1007(A4),A0
    BTST    #3,0(A0,D0.L)
    BEQ.S   .LAB_1987

    ADDQ.L  #1,A3
    BRA.S   .LAB_1986

.LAB_1987:
    MOVE.L  A3,D0
    MOVEA.L (A7)+,A3
    RTS

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000
    MOVEQ   #97,D0
