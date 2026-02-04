    ; ??
    MOVEQ   #97,D0
    RTS

;!======

    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVE.L  20(A7),D7
    MOVEQ   #0,D6
    MOVE.L  A3,D0
    BEQ.S   LAB_0EF4

LAB_0EF3:
    TST.B   (A3)
    BEQ.S   LAB_0EF4

    MOVE.L  D6,D0
    ADDQ.L  #1,D6
    CMP.L   D7,D0
    BGE.S   LAB_0EF4

    MOVE.B  (A3)+,D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,-(A7)
    BSR.W   LAB_0EFC

    ADDQ.W  #4,A7
    BRA.S   LAB_0EF3

LAB_0EF4:
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======

    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVE.L  20(A7),D7
    MOVE.L  A3,D0
    BEQ.S   LAB_0EF8

    MOVEQ   #0,D6

LAB_0EF5:
    TST.B   (A3)
    BEQ.S   LAB_0EF8

    MOVE.L  D6,D0
    MOVE.L  D7,D1
    JSR     JMPTBL_MATH_DivS32_3(PC)

    TST.L   D1
    BNE.S   LAB_0EF7

    TST.L   D6
    BLE.S   LAB_0EF6

    PEA     LAB_1FDF
    JSR     LAB_0F02(PC)

    ADDQ.W  #4,A7

LAB_0EF6:
    PEA     LAB_1FE0
    JSR     LAB_0F02(PC)

    ADDQ.W  #4,A7

LAB_0EF7:
    MOVE.B  (A3)+,D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,-(A7)
    BSR.W   LAB_0EFC

    ADDQ.W  #4,A7
    ADDQ.L  #1,D6
    BRA.S   LAB_0EF5

LAB_0EF8:
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======

LAB_0EF9:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    MOVE.L  A3,D0
    BEQ.S   LAB_0EFB

LAB_0EFA:
    TST.B   (A3)
    BEQ.S   LAB_0EFB

    MOVE.B  (A3)+,D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,-(A7)
    BSR.W   LAB_0EFC

    ADDQ.W  #4,A7
    BRA.S   LAB_0EFA

LAB_0EFB:
    MOVEA.L (A7)+,A3
    RTS

;!======

LAB_0EFC:
    MOVE.L  D7,-(A7)
    MOVE.B  11(A7),D7
    MOVEQ   #32,D0
    CMP.B   D0,D7
    BCC.S   LAB_0EFD

    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEQ   #64,D1
    ADD.L   D1,D0
    MOVE.L  D0,-(A7)
    PEA     LAB_1FE1
    JSR     LAB_0F02(PC)

    ADDQ.W  #8,A7
    BRA.S   LAB_0F01

LAB_0EFD:
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEQ   #84,D1
    ADD.L   D1,D1
    CMP.L   D1,D0
    BNE.S   LAB_0EFE

    MOVEQ   #34,D7
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D0,-(A7)
    PEA     LAB_1FE2
    JSR     LAB_0F02(PC)

    ADDQ.W  #8,A7
    BRA.S   LAB_0F01

LAB_0EFE:
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEQ   #86,D1
    NOT.B   D1
    CMP.L   D1,D0
    BNE.S   LAB_0EFF

    MOVEQ   #44,D7
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D0,-(A7)
    PEA     LAB_1FE3
    JSR     LAB_0F02(PC)

    ADDQ.W  #8,A7
    BRA.S   LAB_0F01

LAB_0EFF:
    MOVEQ   #126,D0
    CMP.B   D0,D7
    BLS.S   LAB_0F00

    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D0,-(A7)
    PEA     LAB_1FE4
    JSR     LAB_0F02(PC)

    ADDQ.W  #8,A7
    BRA.S   LAB_0F01

LAB_0F00:
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D0,-(A7)
    PEA     LAB_1FE5
    JSR     LAB_0F02(PC)

    ADDQ.W  #8,A7

LAB_0F01:
    MOVE.L  (A7)+,D7
    RTS

;!======

    ; Alignment
    ALIGN_WORD
