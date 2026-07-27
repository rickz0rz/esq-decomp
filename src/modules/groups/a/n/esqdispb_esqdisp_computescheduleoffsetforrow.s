    XDEF    _ESQDISP_ComputeScheduleOffsetForRow


;------------------------------------------------------------------------------
; FUNC: _ESQDISP_ComputeScheduleOffsetForRow   (Compute schedule offset for row/time)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Builds a time/row-derived schedule offset and normalizes it for display-grid
;   stepping.
; NOTES:
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
; FUNC: _ESQDISP_ComputeScheduleOffsetForRow   (Compute schedule offset for row/time)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D1/D5/D6/D7
; CALLS:
;   _DST_BuildBannerTimeWord, _DISPLIB_NormalizeValueByStep
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Builds a packed time word from (row, slot), folds it with row index, then
;   normalizes via _DISPLIB_NormalizeValueByStep(value, 1, 48).
; NOTES:
;   Returns normalized offset in D0.
;------------------------------------------------------------------------------
_ESQDISP_ComputeScheduleOffsetForRow:
    MOVEM.L D5-D7,-(A7)
    MOVE.W  18(A7),D7
    MOVE.B  23(A7),D6
    MOVE.L  D7,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  D6,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     _DST_BuildBannerTimeWord(PC)

    MOVE.L  D0,D1
    EXT.L   D1
    ADD.L   D1,D1
    MOVE.L  D7,D0
    EXT.L   D0
    ADD.L   D1,D0
    MOVE.L  D0,D5
    MOVE.L  D5,D0
    EXT.L   D0
    PEA     48.W
    PEA     1.W
    MOVE.L  D0,-(A7)
    JSR     _DISPLIB_NormalizeValueByStep(PC)

    LEA     20(A7),A7
    MOVE.L  D0,D5
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D5-D7
    RTS

;!======