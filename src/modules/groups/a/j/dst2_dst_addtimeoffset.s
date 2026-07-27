    XDEF    _DST_AddTimeOffset


;------------------------------------------------------------------------------
; FUNC: _DST_AddTimeOffset   (Add time offset and store seconds.)
; ARGS:
;   (none observed)
; RET:
;   D0: none
; CLOBBERS:
;   A3/A7/D0/D1/D5/D6/D7
; CALLS:
;   _DATETIME_NormalizeStructToSeconds, _DATETIME_SecondsToStruct
; READS:
;   e10
; WRITES:
;   (none observed)
; DESC:
;   Computes a seconds offset from hours/minutes and stores it via _DATETIME_SecondsToStruct.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DST_AddTimeOffset:
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.W  26(A7),D7
    MOVE.W  30(A7),D6
    MOVE.L  A3,-(A7)
    BSR.W   _DATETIME_NormalizeStructToSeconds

    ADDQ.W  #4,A7
    MOVE.L  D0,D5
    MOVE.L  D7,D0
    MULS    #$e10,D0
    MOVE.L  D6,D1
    MULS    #$3c,D1
    ADD.L   D1,D0
    ADD.L   D0,D5
    MOVE.L  A3,-(A7)
    MOVE.L  D5,-(A7)
    BSR.W   _DATETIME_SecondsToStruct

    ADDQ.W  #8,A7
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======