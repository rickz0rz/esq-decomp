REPLACE_LOWER_CASE_LETTER_WITH_SPACE:
    MOVE.L  4(A7),D0

    CMPI.B  #'a',D0
    BLT.S   .return

    CMPI.B  #'z',D0
    BGT.S   .return

    SUBI.B  #' ',D0

.return:
    RTS

;!======

    ; Alignment
    ALIGN_WORD
