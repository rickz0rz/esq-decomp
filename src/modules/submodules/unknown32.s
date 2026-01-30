LAB_1A92:
    MOVEM.L D5-D7,-(A7)

    SetOffsetForStack 3
    UseStackLong    MOVE.L,1,D7

    MOVE.L  -1148(A4),D0
    SUBQ.L  #1,D0
    MOVE.L  D0,D6

LAB_1A93:
    TST.W   D6
    BMI.S   LAB_1A95

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #3,D0
    LEA     22492(A4),A0
    MOVE.L  0(A0,D0.L),D5
    TST.B   D5
    BEQ.S   LAB_1A94

    BTST    #4,D5
    BNE.S   LAB_1A94

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #3,D0
    LEA     22492(A4),A0
    MOVE.L  4(A0,D0.L),-(A7)
    JSR     LAB_1A04(PC)

    ADDQ.W  #4,A7

LAB_1A94:
    SUBQ.W  #1,D6
    BRA.S   LAB_1A93

LAB_1A95:
    MOVE.L  D7,-(A7)
    JSR     LAB_1A96(PC)

    ADDQ.W  #4,A7
    MOVEM.L (A7)+,D5-D7
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

WDISP_JMP_TBL_ESQ_ReturnWithStackCode:
LAB_1A96:
    JMP     ESQ_ReturnWithStackCode

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000
