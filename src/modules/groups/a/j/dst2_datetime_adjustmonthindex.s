    XDEF    _DATETIME_AdjustMonthIndex


;------------------------------------------------------------------------------
; FUNC: _DATETIME_AdjustMonthIndex   (Adjust month index with optional +12 offset.)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A7/D0/D1
; CALLS:
;   _GROUP_AG_JMPTBL_MATH_DivS32
; READS:
;   8(A3), 18(A3)
; WRITES:
;   8(A3)
; DESC:
;   Adds 12 months when a flag is set and writes back the result.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DATETIME_AdjustMonthIndex:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    ; Adjust month index with optional +12 offset flag.
    MOVE.W  8(A3),D0
    EXT.L   D0
    MOVEQ   #12,D1
    JSR     _GROUP_AG_JMPTBL_MATH_DivS32(PC)

    TST.W   18(A3)
    BEQ.S   .month_offset_zero

    MOVEQ   #12,D0
    BRA.S   .month_offset_ready

.month_offset_zero:
    MOVEQ   #0,D0

.month_offset_ready:
    ADD.L   D0,D1
    MOVE.W  D1,8(A3)
    MOVE.L  D1,D0
    MOVEA.L (A7)+,A3
    RTS

;!======