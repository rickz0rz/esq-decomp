    SECTION text,CODE
    XDEF    _TESTFN
    XREF    WDISP_CharClassTable
_TESTFN:
    MOVE.L  D7,-(A7)
    MOVE.B  11(A7),D7
    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    LEA     WDISP_CharClassTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #2,(A1)
    BEQ.S   L_check_alpha

    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    BRA.S   L_return

L_check_alpha:
    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #7,(A1)
    BEQ.S   L_return_zero

    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    ADDA.L  D0,A0
    BTST    #1,(A0)
    BEQ.S   L_alpha_offset

    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   L_apply_alpha_bias

L_alpha_offset:
    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0

L_apply_alpha_bias:
    MOVEQ   #55,D1
    SUB.L   D1,D0
    BRA.S   L_return

L_return_zero:
    MOVEQ   #0,D0

L_return:
    MOVE.L  (A7)+,D7
    RTS
    END
