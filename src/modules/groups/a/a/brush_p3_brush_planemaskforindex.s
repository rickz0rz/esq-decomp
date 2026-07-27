    XDEF    _BRUSH_PlaneMaskForIndex


; Convert a plane index (0-8) into the corresponding bitmask.
;------------------------------------------------------------------------------
; FUNC: _BRUSH_PlaneMaskForIndex   (Routine at _BRUSH_PlaneMaskForIndex)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D7
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_BRUSH_PlaneMaskForIndex:
    MOVE.L  D7,-(A7)

    MOVE.L  8(A7),D7
    TST.L   D7
    BLE.S   .planemask_invalid_index

    MOVEQ   #9,D0
    CMP.L   D0,D7
    BGE.S   .planemask_invalid_index

    MOVEQ   #1,D0
    ASL.L   D7,D0
    BRA.S   .planemask_return

.planemask_invalid_index:
    MOVEQ   #0,D0

.planemask_return:
    MOVE.L  (A7)+,D7
    RTS

;!======