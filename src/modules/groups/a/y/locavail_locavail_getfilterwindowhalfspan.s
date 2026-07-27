    XDEF    _LOCAVAIL_GetFilterWindowHalfSpan


;------------------------------------------------------------------------------
; FUNC: _LOCAVAIL_GetFilterWindowHalfSpan   (Routine at _LOCAVAIL_GetFilterWindowHalfSpan)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D7
; CALLS:
;   (none)
; READS:
;   _LOCAVAIL_FilterModeFlag, _LOCAVAIL_FilterWindowHalfSpan
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_LOCAVAIL_GetFilterWindowHalfSpan:
    MOVE.L  D7,-(A7)
    MOVEQ   #1,D0
    CMP.L   _LOCAVAIL_FilterModeFlag,D0
    BNE.S   .lab_0F7B

    MOVE.W  _LOCAVAIL_FilterWindowHalfSpan,D0
    BLE.S   .lab_0F79

    EXT.L   D0
    BRA.S   .lab_0F7A

.lab_0F79:
    MOVEQ   #30,D0

.lab_0F7A:
    MOVE.L  D0,D7
    BRA.S   .lab_0F7C

.lab_0F7B:
    MOVEQ   #30,D7

.lab_0F7C:
    ASR.W   #1,D7
    ADDQ.W  #1,D7
    MOVE.L  D7,D0
    MOVE.L  (A7)+,D7
    RTS

;!======