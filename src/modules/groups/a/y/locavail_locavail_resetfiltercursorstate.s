    XDEF    _LOCAVAIL_ResetFilterCursorState


;------------------------------------------------------------------------------
; FUNC: _LOCAVAIL_ResetFilterCursorState   (Reset active filter cursor/class trackers)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A7/D0
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   _LOCAVAIL_FilterStep, _LOCAVAIL_FilterClassId
; DESC:
;   Clears global filter step and sets cursor/class fields to `-1` sentinels.
; NOTES:
;   Leaves mode and allocation pointers unchanged.
;------------------------------------------------------------------------------
_LOCAVAIL_ResetFilterCursorState:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    MOVEQ   #-1,D0
    MOVE.L  D0,8(A3)
    MOVE.L  D0,12(A3)
    MOVE.L  D0,_LOCAVAIL_FilterClassId
    CLR.L   _LOCAVAIL_FilterStep
    MOVEA.L (A7)+,A3
    RTS

;!======