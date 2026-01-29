; Fill in a ClockData struct with the date and time calculated from
; a provided ULONG of the number of seconds from Amiga epoch
POPULATE_CLOCKDATA_FROM_SECS:
    MOVE.L  A6,-(A7)

    MOVEA.L GLOB_REF_UTILITY_LIBRARY,A6
    MOVEM.L 8(A7),D0/A0
    JSR     _LVOAmiga2Date(A6)

    MOVEA.L (A7)+,A6
    RTS

;!======

    ; Alignment
    ALIGN_WORD
