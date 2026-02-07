;------------------------------------------------------------------------------
; FUNC: CLOCK_ConvertAmigaSecondsToClockData
; ARGS:
;   stack +8: D0 = seconds since Amiga epoch
;   stack +12: A0 = ClockData struct pointer
; RET:
;   D0: result/status from _LVOAmiga2Date
; CLOBBERS:
;   D0/A0/A6
; CALLS:
;   _LVOAmiga2Date (Utility.library)
; DESC:
;   Wrapper around Utility.library Amiga2Date; fills ClockData fields.
;------------------------------------------------------------------------------
CLOCK_ConvertAmigaSecondsToClockData:
    MOVE.L  A6,-(A7)

    MOVEA.L Global_REF_UTILITY_LIBRARY,A6
    MOVEM.L 8(A7),D0/A0
    JSR     _LVOAmiga2Date(A6)

    MOVEA.L (A7)+,A6
    RTS

;!======

    ; Alignment
    ALIGN_WORD
