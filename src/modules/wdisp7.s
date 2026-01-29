APPEND_DATA_AT_NULL:
    MOVEA.L 8(A7),A1
    MOVEA.L 4(A7),A0
    MOVE.L  A0,D0

.findFirstNullByte:
    TST.B   (A0)+
    BNE.S   .findFirstNullByte

    SUBQ.L  #1,A0

.copyUntilNull:
    MOVE.B  (A1)+,(A0)+
    BNE.S   .copyUntilNull

    RTS

;!======

    ; Alignment
    ALIGN_WORD
