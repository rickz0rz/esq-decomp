

; Unreferenced Code
    MOVE.L  D7,-(A7)
    MOVE.W  10(A7),D7

    MOVEQ   #23,D1
    CMP.W   D1,D7
    SGT     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0

    MOVE.L  (A7)+,D7
    RTS

;!======

; Unreferenced Code
    MOVEM.L D5-D7,-(A7)
    MOVE.W  18(A7),D7
    MOVE.W  22(A7),D6

    MOVEQ   #-1,D0
    CMP.W   D0,D6
    BNE.S   .lab_0929

    CMPI.W  #$16e,D7
    BLE.S   .lab_0929

    MOVEQ   #1,D5
    BRA.S   .lab_092B

.lab_0929:
    TST.W   D6
    BNE.S   .lab_092A

    CMPI.W  #$16d,D7
    BLE.S   .lab_092A

    MOVEQ   #1,D5
    BRA.S   .lab_092B

.lab_092A:
    MOVEQ   #0,D5

.lab_092B:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D5-D7
    RTS

;!======

; Unreferenced Code
    MOVE.L  D7,-(A7)
    MOVE.W  10(A7),D7

    TST.W   D7
    SMI     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0

    MOVE.L  (A7)+,D7
    RTS

;!======

; Unreferenced Code
    MOVE.L  D7,-(A7)
    MOVE.W  10(A7),D7

    MOVEQ   #1,D1
    CMP.W   D1,D7
    SLT     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0

    MOVE.L  (A7)+,D7
    RTS

;!======