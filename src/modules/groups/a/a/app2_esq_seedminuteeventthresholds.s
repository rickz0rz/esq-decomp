    XDEF    _ESQ_SeedMinuteEventThresholds


;------------------------------------------------------------------------------
; FUNC: _ESQ_SeedMinuteEventThresholds   (SeedMinuteEventThresholdsuncertain)
; ARGS:
;   stack +4: baseMinute
;   stack +8: baseOffset
; RET:
;   (none)
; CLOBBERS:
;   D0-D2
; CALLS:
;   (none)
; READS:
;   (none)
; WRITES:
;   _CLOCK_MinuteTrigger30MinusBase, _CLOCK_MinuteTrigger60MinusBase, _CLOCK_MinuteTriggerBaseOffsetPlus30, _CLOCK_MinuteTriggerBaseOffset
; DESC:
;   Computes minute thresholds based on two base values.
; NOTES:
;   Stores (60-base), (30-base), (baseOffset), (baseOffset+30).
;------------------------------------------------------------------------------
_ESQ_SeedMinuteEventThresholds:
    MOVE.L  4(A7),D0
    MOVE.L  8(A7),D1
    MOVEQ   #60,D2
    SUB.W   D0,D2
    MOVE.W  D2,_CLOCK_MinuteTrigger60MinusBase
    MOVEQ   #30,D2
    SUB.W   D0,D2
    MOVE.W  D2,_CLOCK_MinuteTrigger30MinusBase
    MOVEQ   #0,D2
    ADD.W   D1,D2
    MOVE.W  D2,_CLOCK_MinuteTriggerBaseOffset
    MOVEQ   #30,D2
    ADD.W   D1,D2
    MOVE.W  D2,_CLOCK_MinuteTriggerBaseOffsetPlus30
    RTS

;!======