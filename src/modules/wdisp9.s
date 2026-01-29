LAB_1988:
    MOVE.L  8(A7),D0
    MOVEA.L 4(A7),A0
    LINK.W  A5,#-12
    MOVEA.L A7,A1

.LAB_1989:
    MOVEQ   #10,D1
    JSR     LAB_1A0A(PC)

    ADDI.W  #$30,D1
    MOVE.B  D1,(A1)+
    TST.L   D0
    BNE.S   .LAB_1989

    MOVE.L  A1,D0

.LAB_198A:
    MOVE.B  -(A1),(A0)+
    CMPA.L  A1,A7
    BNE.S   .LAB_198A

    CLR.B   (A0)
    SUB.L   A7,D0
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD
