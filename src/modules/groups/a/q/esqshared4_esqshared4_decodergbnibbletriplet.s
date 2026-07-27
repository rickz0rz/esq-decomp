    XDEF    _ESQSHARED4_DecodeRgbNibbleTriplet


;------------------------------------------------------------------------------
; FUNC: _ESQSHARED4_DecodeRgbNibbleTriplet   (Routine at _ESQSHARED4_DecodeRgbNibbleTriplet)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/D1/D2
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
_ESQSHARED4_DecodeRgbNibbleTriplet:
    MOVE.B  (A1)+,D2
    MOVE.B  (A1)+,D1
    MOVE.B  (A1)+,D0
    ANDI.W  #15,D2
    ANDI.W  #15,D1
    ANDI.W  #15,D0
    LSL.W   #8,D2
    LSL.W   #4,D1
    ADD.W   D1,D0
    ADD.W   D2,D0
    RTS

;!======