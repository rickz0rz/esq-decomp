    SECTION text,CODE
    XDEF    _TESTFN
_TESTFN:
    MOVE.L  8(A7),D0
    MOVEA.L 4(A7),A0
    LINK.W  A5,#-12
    MOVEA.L A7,A1

L_digit_loop:
    MOVE.L  D0,D1
    ANDI.W  #7,D1
    ADDI.W  #$30,D1
    MOVE.B  D1,(A1)+
    LSR.L   #3,D0
    BNE.S   L_digit_loop

    MOVE.L  A1,D0

L_emit_loop:
    MOVE.B  -(A1),(A0)+
    CMPA.L  A1,A7
    BNE.S   L_emit_loop

    CLR.B   (A0)
    SUB.L   A7,D0
    UNLK    A5
    RTS
    END
