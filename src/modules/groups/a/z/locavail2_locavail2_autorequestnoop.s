    XDEF    _LOCAVAIL2_AutoRequestNoOp


;------------------------------------------------------------------------------
; FUNC: _LOCAVAIL2_AutoRequestNoOp   (Routine at _LOCAVAIL2_AutoRequestNoOp)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A4/A7/D0
; CALLS:
;   (none)
; READS:
;   _Global_REF_LONG_FILE_SCRATCH
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_LOCAVAIL2_AutoRequestNoOp:
    MOVE.L  A4,-(A7)
    LEA     _Global_REF_LONG_FILE_SCRATCH,A4
    MOVEQ   #0,D0
    MOVEA.L (A7)+,A4
    RTS

;!======