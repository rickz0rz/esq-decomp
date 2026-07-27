    XDEF    _DATETIME_NormalizeMonthRange


;------------------------------------------------------------------------------
; FUNC: _DATETIME_NormalizeMonthRange   (Normalize month range and set overflow flag.)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A7/D0/D1
; CALLS:
;   (none)
; READS:
;   8(A3)
; WRITES:
;   8(A3), 18(A3)
; DESC:
;   Sets an overflow flag and wraps month index into 1..12 range.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DATETIME_NormalizeMonthRange:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    ; Normalize month range and set overflow flag.
    MOVE.W  8(A3),D0
    MOVEQ   #11,D1
    CMP.W   D1,D0
    BLE.S   .month_overflow

    MOVEQ   #-1,D1
    BRA.S   .month_overflow_ready

.month_overflow:
    MOVEQ   #0,D1

.month_overflow_ready:
    MOVE.W  D1,18(A3)
    MOVE.W  8(A3),D0
    EXT.L   D0
    MOVEQ   #12,D1
    DIVS    D1,D0
    SWAP    D0
    MOVE.W  D0,8(A3)
    TST.W   D0
    BNE.S   .return

    MOVE.W  D1,8(A3)

.return:
    MOVEA.L (A7)+,A3
    RTS

;!======