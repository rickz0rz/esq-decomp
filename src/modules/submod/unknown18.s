LAB_19EA:
    MOVEM.L D2-D7,-(A7)

    MOVE.L  28(A7),D7
    MOVE.L  32(A7),D6
    MOVE.L  36(A7),D5

    TST.L   -616(A4)
    BEQ.S   .LAB_19EB

    JSR     LAB_1AD3(PC)

.LAB_19EB:
    CLR.L   -640(A4)
    MOVE.L  D5,D0
    SUBQ.L  #(OFFSET_END),D0
    MOVE.L  D7,D1
    MOVE.L  D6,D2
    MOVE.L  D0,D3
    MOVEA.L LocalDosLibraryDisplacement(A4),A6
    JSR     _LVOSeek(A6)

    MOVE.L  D0,D4
    MOVEQ   #-1,D0
    CMP.L   D0,D4
    BNE.S   .LAB_19EC

    JSR     _LVOIoErr(A6)

    MOVE.L  D0,-640(A4)
    MOVEQ   #22,D0
    MOVE.L  D0,22828(A4)

.LAB_19EC:
    MOVE.L  D5,D0
    CMPI.L  #$2,D0
    BEQ.S   .LAB_19EE

    CMPI.L  #$1,D0
    BEQ.S   .LAB_19ED

    TST.L   D0
    BNE.S   .return

    MOVE.L  D6,D0
    BRA.S   .return

.LAB_19ED:
    MOVE.L  D4,D0
    ADD.L   D6,D0
    BRA.S   .return

.LAB_19EE:
    MOVE.L  D7,D1
    MOVEQ   #0,D2
    MOVEQ   #(OFFSET_CURRENT),D3
    MOVEA.L LocalDosLibraryDisplacement(A4),A6
    JSR     _LVOSeek(A6)

.return:
    MOVEM.L (A7)+,D2-D7
    RTS

;!======

    ; Alignment
    ALIGN_WORD
