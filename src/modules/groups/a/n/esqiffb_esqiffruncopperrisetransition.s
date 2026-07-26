    XDEF    _ESQIFF_RunCopperRiseTransition

;------------------------------------------------------------------------------
; FUNC: _ESQIFF_RunCopperRiseTransition   (RunCopperRiseTransition)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ESQIFF_RunPendingCopperAnimations
; READS:
;   (none observed)
; WRITES:
;   _COPPER_AnimationLane3_Countdown
; DESC:
;   Arms copper rise-transition countdown state and runs pending copper animation
;   servicing immediately.
; NOTES:
;   Writes _COPPER_AnimationLane3_Countdown = 15 before invoking _ESQIFF_RunPendingCopperAnimations.
;------------------------------------------------------------------------------
_ESQIFF_RunCopperRiseTransition:
    MOVE.W  #15,_COPPER_AnimationLane3_Countdown
    BSR.W   _ESQIFF_RunPendingCopperAnimations

    RTS

;!======
