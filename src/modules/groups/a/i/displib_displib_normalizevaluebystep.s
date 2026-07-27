    XDEF    _DISPLIB_NormalizeValueByStep


;------------------------------------------------------------------------------
; FUNC: _DISPLIB_NormalizeValueByStep   (Routine at _DISPLIB_NormalizeValueByStep)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D5/D6/D7
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
_DISPLIB_NormalizeValueByStep:
    MOVEM.L D5-D7,-(A7)
    MOVE.W  18(A7),D7
    MOVE.W  22(A7),D6
    MOVE.W  26(A7),D5

.lab_0560:
    CMP.W   D6,D7
    BGE.S   .lab_0561

    ADD.W   D5,D7
    BRA.S   .lab_0560

.lab_0561:
    CMP.W   D5,D7
    BLE.S   .return

    SUB.W   D5,D7
    BRA.S   .lab_0561

.return:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D5-D7
    RTS

;!======