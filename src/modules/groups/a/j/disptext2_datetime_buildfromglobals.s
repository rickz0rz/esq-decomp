    XDEF    _DATETIME_BuildFromGlobals

;------------------------------------------------------------------------------
; FUNC: _DATETIME_BuildFromGlobals   (Populate time struct from _DST_PrimaryCountdown)
; ARGS:
;   stack +8: A3 = output struct
; RET:
;   D0: seconds?
; CLOBBERS:
;   A3/A7/D0/D7
; CALLS:
;   _DATETIME_BuildFromBaseDay
; READS:
;   _DST_PrimaryCountdown, _CLOCK_DaySlotIndex
; WRITES:
;   output struct
; DESC:
;   Wrapper that builds a time struct using global base data.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DATETIME_BuildFromGlobals:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVE.W  _DST_PrimaryCountdown,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     54.W
    MOVE.L  A3,-(A7)
    PEA     _CLOCK_DaySlotIndex
    BSR.W   _DATETIME_BuildFromBaseDay

    LEA     16(A7),A7
    MOVE.L  D0,D7
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A3
    RTS

;!======