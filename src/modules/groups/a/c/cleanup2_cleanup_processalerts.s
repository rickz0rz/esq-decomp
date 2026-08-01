    XDEF    _CLEANUP_ProcessAlerts




;------------------------------------------------------------------------------
; FUNC: _CLEANUP_ProcessAlerts   (Process alert/timer/banner state machine)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D2/D7
; CALLS:
;   _GROUP_AC_JMPTBL_ESQFUNC_DrawDiagnosticsScreen, _GROUP_AG_JMPTBL_TEXTDISP_ResetSelectionAndRefresh, _ESQ_TickClockAndFlagEvents,
;   _GROUP_AC_JMPTBL_SCRIPT_ClearCtrlLineIfEnabled, _GROUP_AC_JMPTBL_SCRIPT_UpdateCtrlLineTimeout,
;   _GROUP_AH_JMPTBL_ESQIFF2_ShowAttentionOverlay, _GROUP_AC_JMPTBL_DST_UpdateBannerQueue, _GROUP_AC_JMPTBL_ESQDISP_DrawStatusBanner,
;   _GROUP_AC_JMPTBL_PARSEINI_UpdateClockFromRtc, _GROUP_AC_JMPTBL_DST_RefreshBannerBuffer,
;   _DISPLIB_NormalizeValueByStep, _CLEANUP_DrawGridTimeBanner, _CLEANUP_DrawClockBanner,
;   _GROUP_AC_JMPTBL_ESQFUNC_FreeExtraTitleTextPointers, _GROUP_AC_JMPTBL_SCRIPT_UpdateCtrlStateMachine,
;   _GROUP_AC_JMPTBL_ESQFUNC_DrawEscMenuVersion, _GROUP_AC_JMPTBL_ESQFUNC_DrawMemoryStatusScreen,
;   _LVOSetAPen, _GROUP_AG_JMPTBL_MATH_DivS32
; READS:
;   _CLEANUP_PendingAlertFlag, _CLEANUP_AlertProcessingFlag, _CLEANUP_DiagOverlayAutoRefreshFlag, _Global_UIBusyFlag,
;   _CLEANUP_AlertCooldownTicks, _LOCAVAIL_FilterStep, _LOCAVAIL_FilterCooldownTicks, _CLOCK_DaySlotIndex, _CLOCK_CurrentDayOfWeekIndex,
;   _TEXTDISP_DeferredActionDelayTicks, _BRUSH_PendingAlertCode, _WDISP_WeatherStatusCountdown, _CLEANUP_BannerTickCounter,
;   _TLIBA1_DayEntryModeCounter, _DST_BannerWindowPrimary, _ESQ_AlertType235ModeFlagChar, _ESQ_AlertType4ModeFlagChar, _ED_MenuStateId, _CLOCK_HalfHourSlotIndex,
;   _Global_REF_RASTPORT_1, _Global_REF_GRAPHICS_LIBRARY
; WRITES:
;   _CLEANUP_AlertProcessingFlag, _CLEANUP_AlertCooldownTicks, _LOCAVAIL_FilterStep,
;   _LOCAVAIL_FilterCooldownTicks, _CLEANUP_PendingAlertFlag, _TEXTDISP_DeferredActionDelayTicks, _BRUSH_PendingAlertCode, _WDISP_WeatherStatusCountdown,
;   _CLEANUP_BannerTickCounter, _TLIBA1_DayEntryModeCounter, _ESQDISP_StatusBannerClampGateFlag, _BANNER_ResetPendingFlag,
;   _WDISP_BannerCharRangeStart, _WDISP_BannerCharRangeEnd
; DESC:
;   Processes pending alert state, advances the alert/badge state machine,
;   handles brush alerts, updates banner timers, and redraws the banner/clock.
; NOTES:
;   - Uses _LOCAVAIL_FilterStep as a multi-step alert state (2 → 3 → 4).
;   - Clears the one-shot pending flag (_CLEANUP_PendingAlertFlag) after processing.
;------------------------------------------------------------------------------
; Process pending alert/notification state and update on-screen banners.
_CLEANUP_ProcessAlerts:
    MOVEM.L D2/D7,-(A7)
    TST.W   _CLEANUP_PendingAlertFlag
    BEQ.W   .return_status

    TST.L   _CLEANUP_AlertProcessingFlag
    BNE.W   .return_status

    MOVEQ   #1,D0
    MOVE.L  D0,_CLEANUP_AlertProcessingFlag
    TST.B   _CLEANUP_DiagOverlayAutoRefreshFlag
    BEQ.S   .update_alert_state

    TST.W   _Global_UIBusyFlag
    BNE.S   .update_alert_state

    SUBQ.L  #1,_CLEANUP_AlertCooldownTicks
    BGT.S   .update_alert_state

    JSR     _GROUP_AC_JMPTBL_ESQFUNC_DrawDiagnosticsScreen(PC)

    MOVEQ   #1,D0
    MOVE.L  D0,_CLEANUP_AlertCooldownTicks

.update_alert_state:
    MOVEQ   #2,D0
    CMP.L   _LOCAVAIL_FilterStep,D0
    BNE.S   .check_state_three

    MOVE.W  _LOCAVAIL_FilterCooldownTicks,D0
    BGT.S   .after_state_update

    MOVE.L  D0,D1
    ADDI.W  #10,D1
    MOVE.W  D1,_LOCAVAIL_FilterCooldownTicks
    MOVEQ   #3,D0
    MOVE.L  D0,_LOCAVAIL_FilterStep
    BRA.S   .after_state_update

.check_state_three:
    MOVEQ   #3,D0
    CMP.L   _LOCAVAIL_FilterStep,D0
    BNE.S   .after_state_update

    MOVE.W  _LOCAVAIL_FilterCooldownTicks,D0
    BGT.S   .after_state_update

    MOVEQ   #4,D0
    MOVE.L  D0,_LOCAVAIL_FilterStep
    JSR     _GROUP_AG_JMPTBL_TEXTDISP_ResetSelectionAndRefresh(PC)

.after_state_update:
    CLR.W   _CLEANUP_PendingAlertFlag
    PEA     _CLOCK_DaySlotIndex
    JSR     _ESQ_TickClockAndFlagEvents(PC)

    MOVE.L  D0,D7
    EXT.L   D7
    PEA     _CLOCK_CurrentDayOfWeekIndex
    JSR     _ESQ_TickClockAndFlagEvents(PC)

    ADDQ.W  #8,A7
    MOVE.W  _TEXTDISP_DeferredActionDelayTicks,D0
    BLT.S   .update_banner_queue

    MOVEQ   #11,D1
    CMP.W   D1,D0
    BGE.S   .update_banner_queue

    JSR     _GROUP_AC_JMPTBL_SCRIPT_ClearCtrlLineIfEnabled(PC)

    MOVE.W  _TEXTDISP_DeferredActionDelayTicks,D0
    BNE.S   .update_banner_queue

    MOVE.W  #(-1),_TEXTDISP_DeferredActionDelayTicks

.update_banner_queue:
    JSR     _GROUP_AC_JMPTBL_SCRIPT_UpdateCtrlLineTimeout(PC)

    MOVEQ   #1,D0
    CMP.L   _BRUSH_PendingAlertCode,D0   ; brush loader flagged \"category 1\" alert
    BNE.S   .handle_brush_alert_code1

    PEA     3.W
    JSR     _GROUP_AH_JMPTBL_ESQIFF2_ShowAttentionOverlay(PC)

    ADDQ.W  #4,A7
    MOVEQ   #4,D0
    MOVE.L  D0,_BRUSH_PendingAlertCode

.handle_brush_alert_code1:
    MOVEQ   #2,D0
    CMP.L   _BRUSH_PendingAlertCode,D0   ; same, but for wider-than-allowed brushes
    BNE.S   .handle_brush_alert_code2

    PEA     4.W
    JSR     _GROUP_AH_JMPTBL_ESQIFF2_ShowAttentionOverlay(PC)

    ADDQ.W  #4,A7
    MOVEQ   #4,D0
    MOVE.L  D0,_BRUSH_PendingAlertCode

.handle_brush_alert_code2:
    MOVEQ   #3,D0
    CMP.L   _BRUSH_PendingAlertCode,D0   ; or for taller-than-allowed brushes
    BNE.S   .handle_brush_alert_code3

    PEA     5.W
    JSR     _GROUP_AH_JMPTBL_ESQIFF2_ShowAttentionOverlay(PC)

    ADDQ.W  #4,A7
    MOVEQ   #4,D0
    MOVE.L  D0,_BRUSH_PendingAlertCode

.handle_brush_alert_code3:
    TST.L   D7
    BEQ.S   .after_banner_poll

    MOVE.B  _WDISP_WeatherStatusCountdown,D0
    MOVEQ   #0,D1
    CMP.B   D1,D0
    BLS.S   .decrement_banner_counter

    SUBQ.B  #1,D0
    MOVE.B  D0,_WDISP_WeatherStatusCountdown

.decrement_banner_counter:
    SUBQ.L  #1,_CLEANUP_BannerTickCounter
    BNE.S   .poll_banner_event

    MOVEQ   #60,D0
    MOVE.L  D0,_CLEANUP_BannerTickCounter
    MOVE.B  _TLIBA1_DayEntryModeCounter,D0
    CMP.B   D1,D0
    BLS.S   .poll_banner_event

    SUBQ.B  #1,D0
    MOVE.B  D0,_TLIBA1_DayEntryModeCounter

.poll_banner_event:
    PEA     _DST_BannerWindowPrimary
    JSR     _GROUP_AC_JMPTBL_DST_UpdateBannerQueue(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .after_banner_poll

    PEA     1.W
    JSR     _GROUP_AC_JMPTBL_ESQDISP_DrawStatusBanner(PC)

    ADDQ.W  #4,A7

.after_banner_poll:
    MOVE.B  _ESQ_AlertType235ModeFlagChar,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .handle_alert_type2

    MOVEQ   #2,D0
    CMP.L   D0,D7
    BNE.S   .handle_alert_type2

    CLR.W   _ESQDISP_StatusBannerClampGateFlag
    CLR.L   -(A7)
    JSR     _GROUP_AC_JMPTBL_ESQDISP_DrawStatusBanner(PC)

    ADDQ.W  #4,A7
    MOVE.W  #1,_ESQDISP_StatusBannerClampGateFlag

.handle_alert_type2:
    MOVE.B  _ESQ_AlertType235ModeFlagChar,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .check_alert_type5_or_type2

    MOVEQ   #5,D2
    CMP.L   D2,D7
    BEQ.S   .handle_alert_type5_or_type2

.check_alert_type5_or_type2:
    CMP.B   D1,D0
    BEQ.S   .init_alert_counters

    MOVEQ   #2,D0
    CMP.L   D0,D7
    BNE.S   .init_alert_counters

.handle_alert_type5_or_type2:
    JSR     _GROUP_AC_JMPTBL_PARSEINI_UpdateClockFromRtc(PC)

    JSR     _GROUP_AC_JMPTBL_DST_RefreshBannerBuffer(PC)

    CLR.L   -(A7)
    JSR     _GROUP_AC_JMPTBL_ESQDISP_DrawStatusBanner(PC)

    ADDQ.W  #4,A7

.init_alert_counters:
    MOVE.B  _ESQ_AlertType235ModeFlagChar,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .advance_alert_counters

    MOVEQ   #3,D0
    CMP.L   D0,D7
    BNE.S   .advance_alert_counters

    MOVEQ   #1,D0
    MOVE.W  D0,_BANNER_ResetPendingFlag
    MOVE.W  _CLOCK_HalfHourSlotIndex,D1
    ADDQ.W  #1,D1
    EXT.L   D1
    PEA     48.W
    PEA     1.W
    MOVE.L  D1,-(A7)
    JSR     _DISPLIB_NormalizeValueByStep(PC)

    MOVE.W  D0,_WDISP_BannerCharRangeStart
    MOVE.W  _CLOCK_HalfHourSlotIndex,D0
    ADDQ.W  #2,D0
    EXT.L   D0
    PEA     48.W
    PEA     1.W
    MOVE.L  D0,-(A7)
    JSR     _DISPLIB_NormalizeValueByStep(PC)

    LEA     24(A7),A7
    MOVE.W  D0,_WDISP_BannerCharRangeEnd

.advance_alert_counters:
    MOVE.B  _ESQ_AlertType4ModeFlagChar,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .draw_banner

    MOVEQ   #4,D0
    CMP.L   D0,D7
    BNE.S   .draw_banner

    MOVE.W  _WDISP_BannerCharRangeStart,D0
    MOVE.L  D0,D1
    ADDQ.W  #1,D1
    MOVE.W  D1,_WDISP_BannerCharRangeStart
    EXT.L   D1
    PEA     48.W
    PEA     1.W
    MOVE.L  D1,-(A7)
    JSR     _DISPLIB_NormalizeValueByStep(PC)

    LEA     12(A7),A7
    MOVE.W  D0,_WDISP_BannerCharRangeStart
    MOVE.W  _WDISP_BannerCharRangeEnd,D0
    MOVE.L  D0,D1
    ADDQ.W  #1,D1
    MOVE.W  D1,_WDISP_BannerCharRangeEnd
    EXT.L   D1
    PEA     48.W
    PEA     1.W
    MOVE.L  D1,-(A7)
    JSR     _DISPLIB_NormalizeValueByStep(PC)

    LEA     12(A7),A7
    MOVE.W  D0,_WDISP_BannerCharRangeEnd

.draw_banner:
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    TST.W   _Global_UIBusyFlag
    BEQ.S   .draw_clock_banner

    BSR.W   _CLEANUP_DrawGridTimeBanner

    BRA.S   .after_banner_draw

.draw_clock_banner:
    BSR.W   _CLEANUP_DrawClockBanner

.after_banner_draw:
    MOVEQ   #2,D0
    CMP.L   D0,D7
    BNE.S   .update_grid_flash

    MOVEQ   #0,D1
    MOVE.W  _CLOCK_HalfHourSlotIndex,D1
    MOVE.L  D1,D0
    MOVEQ   #2,D1
    JSR     _GROUP_AG_JMPTBL_MATH_DivS32(PC)

    SUBQ.L  #1,D1
    BNE.S   .maybe_clear_brush_alert

    CLR.L   _BRUSH_PendingAlertCode

.maybe_clear_brush_alert:
    MOVE.W  _WDISP_BannerCharRangeStart,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     _GROUP_AC_JMPTBL_ESQFUNC_FreeExtraTitleTextPointers(PC)

    ADDQ.W  #4,A7

.update_grid_flash:
    JSR     _GROUP_AC_JMPTBL_SCRIPT_UpdateCtrlStateMachine(PC)

    MOVE.B  _ED_MenuStateId,D0
    SUBQ.B  #8,D0
    BNE.S   .check_grid_flash_alt

    JSR     _GROUP_AC_JMPTBL_ESQFUNC_DrawEscMenuVersion(PC)

    BRA.S   .finish

.check_grid_flash_alt:
    MOVE.B  _ED_MenuStateId,D0
    SUBQ.B  #7,D0
    BNE.S   .finish

    JSR     _GROUP_AC_JMPTBL_ESQFUNC_DrawMemoryStatusScreen(PC)

.finish:
    CLR.L   _CLEANUP_AlertProcessingFlag

.return_status:
    MOVEM.L (A7)+,D2/D7
    RTS

;!======