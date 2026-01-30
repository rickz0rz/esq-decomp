LAB_1ADA:
    MOVEM.L D2-D6/A6,-(A7)

    MOVEA.L -22440(A4),A6
    MOVEA.L 28(A7),A0
    MOVEM.L 32(A7),D0-D1
    MOVEA.L 40(A7),A1
    MOVEM.L 44(A7),D2-D6
    JSR     -606(A6)            ; I think this may be BltBitMapRastPort in Graphics.library

    MOVEM.L (A7)+,D2-D6/A6
    RTS

;!======

    ; Alignment
    ORI.B   #0,D0
    ORI.B   #0,D0
    MOVEQ   #97,D0
