    XDEF    _ESQ_TickGlobalCounters



;------------------------------------------------------------------------------
; FUNC: _ESQ_TickGlobalCounters
; ARGS:
;   (none)
; RET:
;   D0: 0
; CLOBBERS:
;   D0-D1, A0-A1
; CALLS:
;   _ESQ_ColdReboot, _ESQSHARED4_TickCopperAndBannerTransitions, _ESQIFF_ServicePendingCopperPaletteMoves
; READS:
;   _ESQ_GlobalTickCounter, _ESQ_TickModulo60Counter, _LOCAVAIL_FilterCooldownTicks, _Global_RefreshTickCounter, _TEXTDISP_DeferredActionDelayTicks, _WDISP_AccumulatorCaptureActive, _WDISP_AccumulatorFlushPending
; WRITES:
;   _ESQ_GlobalTickCounter, _ESQ_TickModulo60Counter, _CLEANUP_PendingAlertFlag, _LOCAVAIL_FilterCooldownTicks, _Global_RefreshTickCounter, _TEXTDISP_DeferredActionDelayTicks, _TEXTDISP_DeferredActionArmed,
;   _ACCUMULATOR_Row0_Sum.._ACCUMULATOR_Row3_SaturateFlag
; DESC:
;   Increments global timing counters, performs periodic resets, and updates
;   accumulator fields with saturation flags.
; NOTES:
;   Triggers _ESQ_ColdReboot when _ESQ_GlobalTickCounter reaches $5460.
;------------------------------------------------------------------------------
_ESQ_TickGlobalCounters:
    MOVE.W  _ESQ_GlobalTickCounter,D0
    ADDQ.W  #1,D0
    CMPI.W  #$5460,D0
    BNE.S   .after_reboot_check

    BSR.W   _ESQ_ColdReboot

.after_reboot_check:
    MOVE.W  D0,_ESQ_GlobalTickCounter
    JSR     _ESQSHARED4_TickCopperAndBannerTransitions

    MOVE.W  _ESQ_TickModulo60Counter,D0
    ADDQ.W  #1,D0
    MOVEQ   #60,D1
    CMP.W   D1,D0
    BNE.W   .store_tick_counter

    MOVE.W  D0,_CLEANUP_PendingAlertFlag
    MOVE.W  _LOCAVAIL_FilterCooldownTicks,D0
    BMI.W   .after_decrement_2325

    SUBQ.W  #1,D0
    MOVE.W  D0,_LOCAVAIL_FilterCooldownTicks

.after_decrement_2325:
    MOVE.W  _Global_RefreshTickCounter,D0
    BMI.W   .after_increment_234A

    ADDQ.W  #1,D0
    MOVE.W  D0,_Global_RefreshTickCounter

.after_increment_234A:
    MOVE.W  _TEXTDISP_DeferredActionDelayTicks,D0
    BMI.W   .after_decay_22A5

    BEQ.W   .after_decay_22A5

    SUBQ.W  #1,D0
    MOVE.W  D0,_TEXTDISP_DeferredActionDelayTicks
    BNE.W   .after_decay_22A5

    MOVE.W  #1,_TEXTDISP_DeferredActionArmed

.after_decay_22A5:
    LEA     _CLOCK_DaySlotIndexPtr,A0
    MOVEA.L (A0),A1
    MOVE.W  12(A1),D1
    ADDQ.W  #1,D1
    MOVE.W  D1,12(A1)
    LEA     _CLOCK_CurrentDayOfWeekIndexPtr,A0
    MOVEA.L (A0),A1
    MOVE.W  12(A1),D1
    ADDQ.W  #1,D1
    MOVE.W  D1,12(A1)
    MOVEQ   #0,D0

.store_tick_counter:
    MOVE.W  D0,_ESQ_TickModulo60Counter
    TST.W   _WDISP_AccumulatorCaptureActive
    BEQ.W   .after_accumulators

    MOVE.W  _ACCUMULATOR_Row0_CaptureValue,D0
    BEQ.S   .after_accum_1b11

    MOVE.W  _ACCUMULATOR_Row0_Sum,D1
    ADD.W   D0,D1
    CMPI.W  #$4000,D1
    BLT.S   .after_accum_1b11_saturate

    MOVE.W  #1,_ACCUMULATOR_Row0_SaturateFlag
    MOVEQ   #0,D1

.after_accum_1b11_saturate:
    MOVE.W  D1,_ACCUMULATOR_Row0_Sum

.after_accum_1b11:
    MOVE.W  _ACCUMULATOR_Row1_CaptureValue,D0
    BEQ.S   .after_accum_1b12

    MOVE.W  _ACCUMULATOR_Row1_Sum,D1
    ADD.W   D0,D1
    CMPI.W  #$4000,D1
    BLT.S   .after_accum_1b12_saturate

    MOVE.W  #1,_ACCUMULATOR_Row1_SaturateFlag
    MOVEQ   #0,D1

.after_accum_1b12_saturate:
    MOVE.W  D1,_ACCUMULATOR_Row1_Sum

.after_accum_1b12:
    MOVE.W  _ACCUMULATOR_Row2_CaptureValue,D0
    BEQ.S   .after_accum_1b13

    MOVE.W  _ACCUMULATOR_Row2_Sum,D1
    ADD.W   D0,D1
    CMPI.W  #$4000,D1
    BLT.S   .after_accum_1b13_saturate

    MOVE.W  #1,_ACCUMULATOR_Row2_SaturateFlag
    MOVEQ   #0,D1

.after_accum_1b13_saturate:
    MOVE.W  D1,_ACCUMULATOR_Row2_Sum

.after_accum_1b13:
    MOVE.W  _ACCUMULATOR_Row3_CaptureValue,D0
    BEQ.S   .after_accumulators

    MOVE.W  _ACCUMULATOR_Row3_Sum,D1
    ADD.W   D0,D1
    CMPI.W  #$4000,D1
    BLT.S   .after_accum_1b14_saturate

    MOVE.W  #1,_ACCUMULATOR_Row3_SaturateFlag
    MOVEQ   #0,D1

.after_accum_1b14_saturate:
    MOVE.W  D1,_ACCUMULATOR_Row3_Sum

.after_accumulators:
    TST.W   _WDISP_AccumulatorFlushPending
    BEQ.W   .return

    JSR     _ESQIFF_ServicePendingCopperPaletteMoves

.return:
    MOVEQ   #0,D0
    RTS

;!======