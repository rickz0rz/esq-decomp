    XDEF    _ESQIFF_RunCopperDropTransition

;------------------------------------------------------------------------------
; FUNC: _ESQIFF_RunCopperDropTransition   (RunCopperDropTransition)
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
;   _COPPER_AnimationLane2_Countdown
; DESC:
;   Arms copper drop-transition countdown state and runs pending copper animation
;   servicing immediately.
; NOTES:
;   Writes _COPPER_AnimationLane2_Countdown = 15 before invoking _ESQIFF_RunPendingCopperAnimations.
;------------------------------------------------------------------------------
_ESQIFF_RunCopperDropTransition:
    MOVE.W  #15,_COPPER_AnimationLane2_Countdown
    BSR.W   _ESQIFF_RunPendingCopperAnimations

    RTS

;!======
