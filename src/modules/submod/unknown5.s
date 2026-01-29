LAB_194E:
    LINK.W  A5,#-4
    MOVEM.L D6-D7/A2-A3,-(A7)

    MOVEA.L 28(A7),A3
    MOVEA.L 32(A7),A2
    MOVE.L  36(A7),D7

.LAB_194F:
    TST.L   D7
    BEQ.S   .LAB_1951

    TST.B   (A3)
    BEQ.S   .LAB_1951

    TST.B   (A2)
    BEQ.S   .LAB_1951

    MOVEQ   #0,D0
    MOVE.B  (A3)+,D0
    MOVE.L  D0,-(A7)
    JSR     REPLACE_LOWER_CASE_LETTER_WITH_SPACE(PC)

    MOVEQ   #0,D1
    MOVE.B  (A2)+,D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,20(A7)
    JSR     REPLACE_LOWER_CASE_LETTER_WITH_SPACE(PC)

    ADDQ.W  #4,A7
    MOVE.L  16(A7),D1
    SUB.L   D0,D1
    MOVE.L  D1,D6
    TST.L   D6
    BEQ.S   .LAB_1950

    MOVE.L  D6,D0
    BRA.S   .return

.LAB_1950:
    SUBQ.L  #1,D7
    BRA.S   .LAB_194F

.LAB_1951:
    TST.L   D7
    BEQ.S   .LAB_1953

    TST.B   (A3)
    BEQ.S   .LAB_1952

    MOVEQ   #1,D0

    BRA.S   .return

.LAB_1952:
    TST.B   (A2)
    BEQ.S   .LAB_1953

    MOVEQ   #-1,D0
    BRA.S   .return

.LAB_1953:
    MOVEQ   #0,D0

.return:
    MOVEM.L (A7)+,D6-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_1955:
    MOVEA.L 8(A7),A1
    MOVEA.L 4(A7),A0
    MOVE.L  12(A7),D0
    MOVE.L  A0,D1
    BRA.S   .LAB_1957

.LAB_1956:
    MOVE.B  (A1)+,(A0)+
    BEQ.S   .LAB_1959

.LAB_1957:
    SUBQ.L  #1,D0
    BCC.S   .LAB_1956

    BRA.S   .return

.LAB_1958:
    CLR.B   (A0)+

.LAB_1959:
    SUBQ.L  #1,D0
    BCC.S   .LAB_1958

.return:
    MOVE.L  D1,D0
    RTS

;!======

LAB_195B:
    MOVEM.L D6-D7/A2-A3,-(A7)

    SetOffsetForStack 4

    MOVEA.L .stackOffsetBytes+4(A7),A3
    MOVEA.L .stackOffsetBytes+8(A7),A2
    MOVE.L  .stackOffsetBytes+12(A7),D7

.LAB_195C:
    TST.L   D7
    BEQ.S   .LAB_195E

    TST.B   (A3)
    BEQ.S   .LAB_195E

    TST.B   (A2)
    BEQ.S   .LAB_195E

    MOVEQ   #0,D0
    MOVE.B  (A3)+,D0
    MOVEQ   #0,D1
    MOVE.B  (A2)+,D1
    SUB.L   D1,D0
    MOVE.L  D0,D6
    TST.L   D6
    BEQ.S   .LAB_195D

    MOVE.L  D6,D0
    BRA.S   .return

.LAB_195D:
    SUBQ.L  #1,D7
    BRA.S   .LAB_195C

.LAB_195E:
    TST.L   D7
    BEQ.S   .LAB_1960

    TST.B   (A3)
    BEQ.S   .LAB_195F

    MOVEQ   #1,D0
    BRA.S   .return

.LAB_195F:
    TST.B   (A2)
    BEQ.S   .LAB_1960

    MOVEQ   #-1,D0
    BRA.S   .return

.LAB_1960:
    MOVEQ   #0,D0

.return:
    MOVEM.L (A7)+,D6-D7/A2-A3
    RTS

;!======

LAB_1962:
    LINK.W  A5,#-8
    MOVEM.L D6-D7/A2-A3,-(A7)

    SetOffsetForStackAfterLink 8,4

    MOVEA.L .stackOffsetBytes+4(A7),A3
    MOVEA.L .stackOffsetBytes+8(A7),A2
    MOVE.L  .stackOffsetBytes+12(A7),D7
    MOVEA.L A2,A0

.LAB_1963:
    TST.B   (A0)+
    BNE.S   .LAB_1963

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    MOVE.L  A0,D6
    MOVEA.L A3,A0

.LAB_1964:
    TST.B   (A0)+
    BNE.S   .LAB_1964

    SUBQ.L  #1,A0
    SUBA.L  A3,A0
    MOVE.L  A0,D0
    MOVEA.L A3,A1
    ADDA.L  D0,A1
    MOVE.L  A1,-8(A5)
    CMP.L   D7,D6
    BLS.S   .LAB_1965

    MOVE.L  D7,D6

.LAB_1965:
    MOVE.L  D6,D0
    MOVEA.L A2,A0
    BRA.S   .LAB_1967

.LAB_1966:
    MOVE.B  (A0)+,(A1)+

.LAB_1967:
    SUBQ.L  #1,D0
    BCC.S   .LAB_1966

    MOVEA.L -8(A5),A0
    CLR.B   0(A0,D6.L)
    MOVE.L  A3,D0

    MOVEM.L (A7)+,D6-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_1968:
    MOVEA.L 4(A7),A0
    MOVEA.L 8(A7),A1
    MOVEQ   #0,D0
    MOVEQ   #0,D1

.LAB_1969:
    MOVE.B  (A0)+,D0
    MOVE.B  (A1)+,D1
    CMPI.B  #$61,D0
    BLT.S   .LAB_196A

    CMPI.B  #$7a,D0
    BGT.S   .LAB_196A

    SUBI.B  #$20,D0

.LAB_196A:
    CMPI.B  #$61,D1
    BLT.S   .LAB_196B

    CMPI.B  #$7a,D1
    BGT.S   .LAB_196B

    SUBI.B  #$20,D1

.LAB_196B:
    SUB.L   D1,D0
    BNE.S   .return

    TST.B   D1
    BNE.S   .LAB_1969

.return:
    RTS

;!======

    ; Alignment
    ALIGN_WORD
