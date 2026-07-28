    XDEF    ESQ_TickGlobalCounters


;------------------------------------------------------------------------------
; FUNC: ESQ_TickGlobalCounters
; ARGS:
;   (none)
; RET:
;   D0: 0
; CLOBBERS:
;   D0-D1, A0-A1
; CALLS:
;   ESQ_ColdReboot, ESQSHARED4_TickCopperAndBannerTransitions, _ESQIFF_ServicePendingCopperPaletteMoves
; READS:
;   ESQ_GlobalTickCounter, ESQ_TickModulo60Counter, LOCAVAIL_FilterCooldownTicks, _Global_RefreshTickCounter, TEXTDISP_DeferredActionDelayTicks, WDISP_AccumulatorCaptureActive, _WDISP_AccumulatorFlushPending
; WRITES:
;   ESQ_GlobalTickCounter, ESQ_TickModulo60Counter, CLEANUP_PendingAlertFlag, LOCAVAIL_FilterCooldownTicks, _Global_RefreshTickCounter, TEXTDISP_DeferredActionDelayTicks, _TEXTDISP_DeferredActionArmed,
;   ACCUMULATOR_Row0_Sum.._ACCUMULATOR_Row3_SaturateFlag
; DESC:
;   Increments global timing counters, performs periodic resets, and updates
;   accumulator fields with saturation flags.
; NOTES:
;   Triggers ESQ_ColdReboot when ESQ_GlobalTickCounter reaches $5460.
;------------------------------------------------------------------------------
ESQ_TickGlobalCounters:
    MOVE.W  ESQ_GlobalTickCounter,D0
    ADDQ.W  #1,D0
    CMPI.W  #$5460,D0
    BNE.S   .after_reboot_check

    BSR.W   ESQ_ColdReboot

.after_reboot_check:
    MOVE.W  D0,ESQ_GlobalTickCounter
    JSR     ESQSHARED4_TickCopperAndBannerTransitions

    MOVE.W  ESQ_TickModulo60Counter,D0
    ADDQ.W  #1,D0
    MOVEQ   #60,D1
    CMP.W   D1,D0
    BNE.W   .store_tick_counter

    MOVE.W  D0,CLEANUP_PendingAlertFlag
    MOVE.W  LOCAVAIL_FilterCooldownTicks,D0
    BMI.W   .after_decrement_2325

    SUBQ.W  #1,D0
    MOVE.W  D0,LOCAVAIL_FilterCooldownTicks

.after_decrement_2325:
    MOVE.W  _Global_RefreshTickCounter,D0
    BMI.W   .after_increment_234A

    ADDQ.W  #1,D0
    MOVE.W  D0,_Global_RefreshTickCounter

.after_increment_234A:
    MOVE.W  TEXTDISP_DeferredActionDelayTicks,D0
    BMI.W   .after_decay_22A5

    BEQ.W   .after_decay_22A5

    SUBQ.W  #1,D0
    MOVE.W  D0,TEXTDISP_DeferredActionDelayTicks
    BNE.W   .after_decay_22A5

    MOVE.W  #1,_TEXTDISP_DeferredActionArmed

.after_decay_22A5:
    LEA     CLOCK_DaySlotIndexPtr,A0
    MOVEA.L (A0),A1
    MOVE.W  12(A1),D1
    ADDQ.W  #1,D1
    MOVE.W  D1,12(A1)
    LEA     CLOCK_CurrentDayOfWeekIndexPtr,A0
    MOVEA.L (A0),A1
    MOVE.W  12(A1),D1
    ADDQ.W  #1,D1
    MOVE.W  D1,12(A1)
    MOVEQ   #0,D0

.store_tick_counter:
    MOVE.W  D0,ESQ_TickModulo60Counter
    TST.W   WDISP_AccumulatorCaptureActive
    BEQ.W   .after_accumulators

    MOVE.W  ACCUMULATOR_Row0_CaptureValue,D0
    BEQ.S   .after_accum_1b11

    MOVE.W  ACCUMULATOR_Row0_Sum,D1
    ADD.W   D0,D1
    CMPI.W  #$4000,D1
    BLT.S   .after_accum_1b11_saturate

    MOVE.W  #1,_ACCUMULATOR_Row0_SaturateFlag
    MOVEQ   #0,D1

.after_accum_1b11_saturate:
    MOVE.W  D1,ACCUMULATOR_Row0_Sum

.after_accum_1b11:
    MOVE.W  ACCUMULATOR_Row1_CaptureValue,D0
    BEQ.S   .after_accum_1b12

    MOVE.W  ACCUMULATOR_Row1_Sum,D1
    ADD.W   D0,D1
    CMPI.W  #$4000,D1
    BLT.S   .after_accum_1b12_saturate

    MOVE.W  #1,_ACCUMULATOR_Row1_SaturateFlag
    MOVEQ   #0,D1

.after_accum_1b12_saturate:
    MOVE.W  D1,ACCUMULATOR_Row1_Sum

.after_accum_1b12:
    MOVE.W  ACCUMULATOR_Row2_CaptureValue,D0
    BEQ.S   .after_accum_1b13

    MOVE.W  ACCUMULATOR_Row2_Sum,D1
    ADD.W   D0,D1
    CMPI.W  #$4000,D1
    BLT.S   .after_accum_1b13_saturate

    MOVE.W  #1,_ACCUMULATOR_Row2_SaturateFlag
    MOVEQ   #0,D1

.after_accum_1b13_saturate:
    MOVE.W  D1,ACCUMULATOR_Row2_Sum

.after_accum_1b13:
    MOVE.W  ACCUMULATOR_Row3_CaptureValue,D0
    BEQ.S   .after_accumulators

    MOVE.W  ACCUMULATOR_Row3_Sum,D1
    ADD.W   D0,D1
    CMPI.W  #$4000,D1
    BLT.S   .after_accum_1b14_saturate

    MOVE.W  #1,_ACCUMULATOR_Row3_SaturateFlag
    MOVEQ   #0,D1

.after_accum_1b14_saturate:
    MOVE.W  D1,ACCUMULATOR_Row3_Sum

.after_accumulators:
    TST.W   _WDISP_AccumulatorFlushPending
    BEQ.W   .return

    JSR     _ESQIFF_ServicePendingCopperPaletteMoves

.return:
    MOVEQ   #0,D0
    RTS

;!======