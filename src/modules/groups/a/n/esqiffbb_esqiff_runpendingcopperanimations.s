    XDEF    _ESQIFF_RunPendingCopperAnimations


;------------------------------------------------------------------------------
; FUNC: _ESQIFF_RunPendingCopperAnimations   (Service all active copper animation countdown lanes)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/D1
; CALLS:
;   _ESQIFF_JMPTBL_ESQ_DecCopperListsPrimary, _ESQIFF_JMPTBL_ESQ_IncCopperListsTowardsTargets, _ESQIFF_JMPTBL_ESQ_NoOp_006A, _ESQIFF_JMPTBL_ESQ_NoOp_0074
; READS:
;   _COPPER_AnimationLane0_Countdown, _COPPER_AnimationLane1_Countdown, _COPPER_AnimationLane2_Countdown, _COPPER_AnimationLane3_Countdown
; WRITES:
;   _COPPER_AnimationLane0_Countdown, _COPPER_AnimationLane1_Countdown, _COPPER_AnimationLane2_Countdown, _COPPER_AnimationLane3_Countdown
; DESC:
;   Services four countdown lanes in sequence, invoking the corresponding copper
;   helper while each lane is non-zero and decrementing per step.
; NOTES:
;   Loops until all lanes (`1B19..1B1C`) reach zero.
;------------------------------------------------------------------------------
_ESQIFF_RunPendingCopperAnimations:
    MOVE.W  _COPPER_AnimationLane0_Countdown,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   .service_lane_1b1a

    JSR     _ESQIFF_JMPTBL_ESQ_NoOp_006A(PC)

    MOVE.W  _COPPER_AnimationLane0_Countdown,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,_COPPER_AnimationLane0_Countdown
    BRA.S   _ESQIFF_RunPendingCopperAnimations

.service_lane_1b1a:
    MOVE.W  _COPPER_AnimationLane1_Countdown,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   .service_lane_1b1b

    JSR     _ESQIFF_JMPTBL_ESQ_NoOp_0074(PC)

    MOVE.W  _COPPER_AnimationLane1_Countdown,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,_COPPER_AnimationLane1_Countdown
    BRA.S   .service_lane_1b1a

.service_lane_1b1b:
    MOVE.W  _COPPER_AnimationLane2_Countdown,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   .service_lane_1b1c

    JSR     _ESQIFF_JMPTBL_ESQ_DecCopperListsPrimary(PC)

    MOVE.W  _COPPER_AnimationLane2_Countdown,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,_COPPER_AnimationLane2_Countdown
    BRA.S   .service_lane_1b1b

.service_lane_1b1c:
    MOVE.W  _COPPER_AnimationLane3_Countdown,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   .return_run_pending_copper_animations

    JSR     _ESQIFF_JMPTBL_ESQ_IncCopperListsTowardsTargets(PC)

    MOVE.W  _COPPER_AnimationLane3_Countdown,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,_COPPER_AnimationLane3_Countdown
    BRA.S   .service_lane_1b1c

.return_run_pending_copper_animations:
    RTS

;!======