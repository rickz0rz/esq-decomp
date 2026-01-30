;------------------------------------------------------------------------------
; FUNC: CLEANUP_ProcessAlerts   (ProcessAlerts??)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D2/D7
; CALLS:
;   CLEANUP_JMP_TBL_ESQFUNC_DrawDiagnosticsScreen, LAB_0464, LAB_007B,
;   CLEANUP_JMP_TBL_SCRIPT_ClearCtrlLineIfEnabled, CLEANUP_JMP_TBL_SCRIPT_UpdateCtrlLineTimeout,
;   LAB_0546, CLEANUP_JMP_TBL_DST_UpdateBannerQueue, CLEANUP_JMP_TBL_ESQDISP_DrawStatusBanner,
;   CLEANUP_JMP_TBL_PARSEINI_UpdateClockFromRtc, CLEANUP_JMP_TBL_DST_RefreshBannerBuffer,
;   LAB_055F, CLEANUP_DrawGridTimeBanner, CLEANUP_DrawClockBanner,
;   CLEANUP_JMP_TBL_ESQFUNC_PruneEntryTextPointers, CLEANUP_JMP_TBL_SCRIPT_UpdateCtrlStateMachine,
;   CLEANUP_JMP_TBL_DRAW_ESC_MENU_VERSION_SCREEN, CLEANUP_JMP_TBL_ESQFUNC_DrawMemoryStatusScreen,
;   _LVOSetAPen, JMP_TBL_LAB_1A07_1
; READS:
;   LAB_2264, CLEANUP_AlertProcessingFlag, LAB_1DEF, LAB_2263,
;   CLEANUP_AlertCooldownTicks, LAB_1FE7, LAB_2325, LAB_223A, LAB_2274,
;   LAB_22A5, BRUSH_PendingAlertCode, LAB_227F, CLEANUP_BannerTickCounter,
;   LAB_2196, LAB_21DF, LAB_1DD5, LAB_1DD4, LAB_1D13, LAB_2270,
;   GLOB_REF_RASTPORT_1, GLOB_REF_GRAPHICS_LIBRARY
; WRITES:
;   CLEANUP_AlertProcessingFlag, CLEANUP_AlertCooldownTicks, LAB_1FE7,
;   LAB_2325, LAB_2264, LAB_22A5, BRUSH_PendingAlertCode, LAB_227F,
;   CLEANUP_BannerTickCounter, LAB_2196, LAB_1E85, LAB_1B08,
;   LAB_226F, LAB_2280
; DESC:
;   Processes pending alert state, advances the alert/badge state machine,
;   handles brush alerts, updates banner timers, and redraws the banner/clock.
; NOTES:
;   - Uses LAB_1FE7 as a multi-step alert state (2 → 3 → 4).
;   - Clears the one-shot pending flag (LAB_2264) after processing.
;------------------------------------------------------------------------------
; Process pending alert/notification state and update on-screen banners.
CLEANUP_ProcessAlerts:
    MOVEM.L D2/D7,-(A7)
    TST.W   LAB_2264
    BEQ.W   .return_status

    TST.L   CLEANUP_AlertProcessingFlag
    BNE.W   .return_status

    MOVEQ   #1,D0
    MOVE.L  D0,CLEANUP_AlertProcessingFlag
    TST.B   LAB_1DEF
    BEQ.S   .update_alert_state

    TST.W   LAB_2263
    BNE.S   .update_alert_state

    SUBQ.L  #1,CLEANUP_AlertCooldownTicks
    BGT.S   .update_alert_state

    JSR     CLEANUP_JMP_TBL_ESQFUNC_DrawDiagnosticsScreen(PC)

    MOVEQ   #1,D0
    MOVE.L  D0,CLEANUP_AlertCooldownTicks

.update_alert_state:
    MOVEQ   #2,D0
    CMP.L   LAB_1FE7,D0
    BNE.S   .check_state_three

    MOVE.W  LAB_2325,D0
    BGT.S   .after_state_update

    MOVE.L  D0,D1
    ADDI.W  #10,D1
    MOVE.W  D1,LAB_2325
    MOVEQ   #3,D0
    MOVE.L  D0,LAB_1FE7
    BRA.S   .after_state_update

.check_state_three:
    MOVEQ   #3,D0
    CMP.L   LAB_1FE7,D0
    BNE.S   .after_state_update

    MOVE.W  LAB_2325,D0
    BGT.S   .after_state_update

    MOVEQ   #4,D0
    MOVE.L  D0,LAB_1FE7
    JSR     LAB_0464(PC)

.after_state_update:
    CLR.W   LAB_2264
    PEA     LAB_223A
    JSR     LAB_007B(PC)

    MOVE.L  D0,D7
    EXT.L   D7
    PEA     LAB_2274
    JSR     LAB_007B(PC)

    ADDQ.W  #8,A7
    MOVE.W  LAB_22A5,D0
    BLT.S   .update_banner_queue

    MOVEQ   #11,D1
    CMP.W   D1,D0
    BGE.S   .update_banner_queue

    JSR     CLEANUP_JMP_TBL_SCRIPT_ClearCtrlLineIfEnabled(PC)

    MOVE.W  LAB_22A5,D0
    BNE.S   .update_banner_queue

    MOVE.W  #(-1),LAB_22A5

.update_banner_queue:
    JSR     CLEANUP_JMP_TBL_SCRIPT_UpdateCtrlLineTimeout(PC)

    MOVEQ   #1,D0
    CMP.L   BRUSH_PendingAlertCode,D0   ; brush loader flagged \"category 1\" alert
    BNE.S   .handle_brush_alert_code1

    PEA     3.W
    JSR     LAB_0546(PC)

    ADDQ.W  #4,A7
    MOVEQ   #4,D0
    MOVE.L  D0,BRUSH_PendingAlertCode

.handle_brush_alert_code1:
    MOVEQ   #2,D0
    CMP.L   BRUSH_PendingAlertCode,D0   ; same, but for wider-than-allowed brushes
    BNE.S   .handle_brush_alert_code2

    PEA     4.W
    JSR     LAB_0546(PC)

    ADDQ.W  #4,A7
    MOVEQ   #4,D0
    MOVE.L  D0,BRUSH_PendingAlertCode

.handle_brush_alert_code2:
    MOVEQ   #3,D0
    CMP.L   BRUSH_PendingAlertCode,D0   ; or for taller-than-allowed brushes
    BNE.S   .handle_brush_alert_code3

    PEA     5.W
    JSR     LAB_0546(PC)

    ADDQ.W  #4,A7
    MOVEQ   #4,D0
    MOVE.L  D0,BRUSH_PendingAlertCode

.handle_brush_alert_code3:
    TST.L   D7
    BEQ.S   .after_banner_poll

    MOVE.B  LAB_227F,D0
    MOVEQ   #0,D1
    CMP.B   D1,D0
    BLS.S   .decrement_banner_counter

    SUBQ.B  #1,D0
    MOVE.B  D0,LAB_227F

.decrement_banner_counter:
    SUBQ.L  #1,CLEANUP_BannerTickCounter
    BNE.S   .poll_banner_event

    MOVEQ   #60,D0
    MOVE.L  D0,CLEANUP_BannerTickCounter
    MOVE.B  LAB_2196,D0
    CMP.B   D1,D0
    BLS.S   .poll_banner_event

    SUBQ.B  #1,D0
    MOVE.B  D0,LAB_2196

.poll_banner_event:
    PEA     LAB_21DF
    JSR     CLEANUP_JMP_TBL_DST_UpdateBannerQueue(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .after_banner_poll

    PEA     1.W
    JSR     CLEANUP_JMP_TBL_ESQDISP_DrawStatusBanner(PC)

    ADDQ.W  #4,A7

.after_banner_poll:
    MOVE.B  LAB_1DD5,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .handle_alert_type2

    MOVEQ   #2,D0
    CMP.L   D0,D7
    BNE.S   .handle_alert_type2

    CLR.W   LAB_1E85
    CLR.L   -(A7)
    JSR     CLEANUP_JMP_TBL_ESQDISP_DrawStatusBanner(PC)

    ADDQ.W  #4,A7
    MOVE.W  #1,LAB_1E85

.handle_alert_type2:
    MOVE.B  LAB_1DD5,D0
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
    JSR     CLEANUP_JMP_TBL_PARSEINI_UpdateClockFromRtc(PC)

    JSR     CLEANUP_JMP_TBL_DST_RefreshBannerBuffer(PC)

    CLR.L   -(A7)
    JSR     CLEANUP_JMP_TBL_ESQDISP_DrawStatusBanner(PC)

    ADDQ.W  #4,A7

.init_alert_counters:
    MOVE.B  LAB_1DD5,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .advance_alert_counters

    MOVEQ   #3,D0
    CMP.L   D0,D7
    BNE.S   .advance_alert_counters

    MOVEQ   #1,D0
    MOVE.W  D0,LAB_1B08
    MOVE.W  LAB_2270,D1
    ADDQ.W  #1,D1
    EXT.L   D1
    PEA     48.W
    PEA     1.W
    MOVE.L  D1,-(A7)
    JSR     LAB_055F(PC)

    MOVE.W  D0,LAB_226F
    MOVE.W  LAB_2270,D0
    ADDQ.W  #2,D0
    EXT.L   D0
    PEA     48.W
    PEA     1.W
    MOVE.L  D0,-(A7)
    JSR     LAB_055F(PC)

    LEA     24(A7),A7
    MOVE.W  D0,LAB_2280

.advance_alert_counters:
    MOVE.B  LAB_1DD4,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .draw_banner

    MOVEQ   #4,D0
    CMP.L   D0,D7
    BNE.S   .draw_banner

    MOVE.W  LAB_226F,D0
    MOVE.L  D0,D1
    ADDQ.W  #1,D1
    MOVE.W  D1,LAB_226F
    EXT.L   D1
    PEA     48.W
    PEA     1.W
    MOVE.L  D1,-(A7)
    JSR     LAB_055F(PC)

    LEA     12(A7),A7
    MOVE.W  D0,LAB_226F
    MOVE.W  LAB_2280,D0
    MOVE.L  D0,D1
    ADDQ.W  #1,D1
    MOVE.W  D1,LAB_2280
    EXT.L   D1
    PEA     48.W
    PEA     1.W
    MOVE.L  D1,-(A7)
    JSR     LAB_055F(PC)

    LEA     12(A7),A7
    MOVE.W  D0,LAB_2280

.draw_banner:
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    TST.W   LAB_2263
    BEQ.S   .draw_clock_banner

    BSR.W   CLEANUP_DrawGridTimeBanner

    BRA.S   .after_banner_draw

.draw_clock_banner:
    BSR.W   CLEANUP_DrawClockBanner

.after_banner_draw:
    MOVEQ   #2,D0
    CMP.L   D0,D7
    BNE.S   .update_grid_flash

    MOVEQ   #0,D1
    MOVE.W  LAB_2270,D1
    MOVE.L  D1,D0
    MOVEQ   #2,D1
    JSR     JMP_TBL_LAB_1A07_1(PC)

    SUBQ.L  #1,D1
    BNE.S   .maybe_clear_brush_alert

    CLR.L   BRUSH_PendingAlertCode

.maybe_clear_brush_alert:
    MOVE.W  LAB_226F,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     CLEANUP_JMP_TBL_ESQFUNC_PruneEntryTextPointers(PC)

    ADDQ.W  #4,A7

.update_grid_flash:
    JSR     CLEANUP_JMP_TBL_SCRIPT_UpdateCtrlStateMachine(PC)

    MOVE.B  LAB_1D13,D0
    SUBQ.B  #8,D0
    BNE.S   .check_grid_flash_alt

    JSR     CLEANUP_JMP_TBL_DRAW_ESC_MENU_VERSION_SCREEN(PC)

    BRA.S   .finish

.check_grid_flash_alt:
    MOVE.B  LAB_1D13,D0
    SUBQ.B  #7,D0
    BNE.S   .finish

    JSR     CLEANUP_JMP_TBL_ESQFUNC_DrawMemoryStatusScreen(PC)

.finish:
    CLR.L   CLEANUP_AlertProcessingFlag

.return_status:
    MOVEM.L (A7)+,D2/D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CLEANUP_DrawClockBanner   (DrawClockBanner)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D3/A0-A1/A5-A6
; CALLS:
;   JMP_TBL_ADJUST_HOURS_TO_24_HR_FMT, GROUPA_JMP_TBL_WDISP_SPrintf, _LVOSetAPen,
;   _LVORectFill, _LVOMove, _LVOText, BEVEL_DrawBevelFrameWithTopRight, LAB_026C
; READS:
;   LAB_2263, GLOB_REF_STR_USE_24_HR_CLOCK, GLOB_WORD_CURRENT_HOUR,
;   GLOB_WORD_USE_24_HR_FMT, GLOB_WORD_CURRENT_MINUTE, GLOB_WORD_CURRENT_SECOND,
;   GLOB_STR_EXTRA_TIME_FORMAT, GLOB_STR_GRID_TIME_FORMAT,
;   GLOB_REF_GRID_RASTPORT_MAYBE_1, LAB_232A, GLOB_REF_GRAPHICS_LIBRARY
; WRITES:
;   Stack buffer at -10(A5)
; DESC:
;   Formats the current time string and renders it into the top banner area.
; NOTES:
;   - Centers the rendered time based on the font metrics.
;------------------------------------------------------------------------------
; Render the top-of-screen clock/banner text.
CLEANUP_DrawClockBanner:
LAB_01E3:
    LINK.W  A5,#-12
    MOVEM.L D2-D3,-(A7)
    TST.W   LAB_2263
    BNE.W   .done

    MOVE.B  GLOB_REF_STR_USE_24_HR_CLOCK,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .format_grid_time

    MOVE.W  GLOB_WORD_CURRENT_HOUR,D0
    EXT.L   D0
    MOVE.W  GLOB_WORD_USE_24_HR_FMT,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     JMP_TBL_ADJUST_HOURS_TO_24_HR_FMT(PC)

    MOVE.W  GLOB_WORD_CURRENT_MINUTE,D1
    EXT.L   D1
    MOVE.W  GLOB_WORD_CURRENT_SECOND,D2
    EXT.L   D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     GLOB_STR_EXTRA_TIME_FORMAT
    PEA     -10(A5)
    JSR     GROUPA_JMP_TBL_WDISP_SPrintf(PC)

    LEA     24(A7),A7
    BRA.S   .draw_banner

.format_grid_time:
    MOVE.W  GLOB_WORD_CURRENT_HOUR,D0
    EXT.L   D0
    MOVE.W  GLOB_WORD_CURRENT_MINUTE,D1
    EXT.L   D1
    MOVE.W  GLOB_WORD_CURRENT_SECOND,D2
    EXT.L   D2
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     GLOB_STR_GRID_TIME_FORMAT
    PEA     -10(A5)
    JSR     GROUPA_JMP_TBL_WDISP_SPrintf(PC)

    LEA     20(A7),A7

.draw_banner:
    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    MOVEQ   #7,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    MOVEQ   #35,D2
    MOVEQ   #33,D3
    JSR     _LVORectFill(A6)

    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    MOVEQ   #7,D0
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    ADD.L   D2,D0
    MOVE.L  D0,D2
    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    MOVEQ   #36,D0
    MOVEQ   #0,D1
    JSR     _LVORectFill(A6)

    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    MOVE.L  D3,-(A7)
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  GLOB_REF_GRID_RASTPORT_MAYBE_1,-(A7)
    JSR     BEVEL_DrawBevelFrameWithTopRight(PC)

    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    MOVEA.L 52(A1),A0
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    MOVEQ   #34,D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .center_text_y

    ADDQ.L  #1,D1

.center_text_y:
    ASR.L   #1,D1
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    ADD.L   D0,D1
    SUBQ.L  #1,D1
    MOVEQ   #44,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    LEA     -10(A5),A0

    MOVEA.L A0,A1

.measure_text_loop:
    TST.B   (A1)+
    BNE.S   .measure_text_loop

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    JSR     _LVOText(A6)

    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    PEA     192.W
    MOVEQ   #34,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    MOVEQ   #0,D2
    MOVE.L  D2,-(A7)
    MOVE.L  GLOB_REF_GRID_RASTPORT_MAYBE_1,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D2,-(A7)
    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A0
    MOVE.L  4(A0),-(A7)
    JSR     LAB_026C(PC)

.done:
    MOVEM.L -20(A5),D2-D3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CLEANUP_FormatClockFormatEntry   (FormatClockFormatEntry??)
; ARGS:
;   stack +4: slotIndex (0..48?) ??
;   stack +8: outText (char*)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1/D6-D7/A0-A3
; CALLS:
;   JMP_TBL_LAB_1A07_1, GROUPA_JMP_TBL_LAB_1A06
; READS:
;   LAB_1DD8, GLOB_REF_STR_CLOCK_FORMAT
; WRITES:
;   outText buffer (A3)
; DESC:
;   Copies a clock-format string for slotIndex into outText and optionally
;   adjusts two digit positions based on LAB_1DD8.
; NOTES:
;   - Wraps slotIndex by subtracting 48 until within range.
;------------------------------------------------------------------------------
CLEANUP_FormatClockFormatEntry:
LAB_01E9:
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVE.L  20(A7),D7
    MOVEA.L 24(A7),A3

.wrap_slot_index_loop:
    MOVEQ   #48,D0
    CMP.L   D0,D7
    BLE.S   .slot_index_ready

    SUB.L   D0,D7
    BRA.S   .wrap_slot_index_loop

.slot_index_ready:
    MOVEQ   #0,D0
    MOVE.B  LAB_1DD8,D0
    MOVEQ   #30,D1
    JSR     JMP_TBL_LAB_1A07_1(PC)

    MOVE.L  D1,D6
    MOVE.L  D7,D0
    ASL.L   #2,D0
    MOVEA.L GLOB_REF_STR_CLOCK_FORMAT,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVEA.L A3,A2

.copy_format_loop:
    MOVE.B  (A1)+,(A2)+
    BNE.S   .copy_format_loop

    TST.L   D6
    BLE.S   .done

    MOVE.B  3(A3),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVEQ   #10,D1
    JSR     GROUPA_JMP_TBL_LAB_1A06(PC)

    ADD.L   D0,D6
    MOVE.L  D6,D0
    MOVEQ   #10,D1
    JSR     JMP_TBL_LAB_1A07_1(PC)

    MOVEQ   #48,D1
    ADD.L   D1,D0
    MOVE.B  D0,3(A3)
    MOVE.L  D6,D0
    MOVEQ   #10,D1
    JSR     JMP_TBL_LAB_1A07_1(PC)

    MOVEQ   #48,D0
    ADD.L   D0,D1
    MOVE.B  D1,4(A3)

.done:
    MOVEM.L (A7)+,D6-D7/A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CLEANUP_DrawClockFormatList   (DrawClockFormatList??)
; ARGS:
;   stack +4: baseSlotIndex ??
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A1/A5-A6
; CALLS:
;   LAB_0211, _LVOSetAPen, _LVORectFill, GROUPA_JMP_TBL_LAB_1A06, BEVEL_DrawBevelFrameWithTopRight,
;   CLEANUP_FormatClockFormatEntry, _LVOTextLength, _LVOMove, _LVOText
; READS:
;   LAB_232A, LAB_232B, GLOB_REF_GRID_RASTPORT_MAYBE_1, GLOB_REF_GRAPHICS_LIBRARY
; WRITES:
;   Stack text buffer at -89(A5)
; DESC:
;   Renders a multi-row list of clock-format strings starting at baseSlotIndex
;   into the grid rastport area.
; NOTES:
;   - Draws two rows in a loop, then renders the final row separately.
;------------------------------------------------------------------------------
CLEANUP_DrawClockFormatList:
LAB_01EE:
    LINK.W  A5,#-100
    MOVEM.L D2-D3/D5-D7,-(A7)
    MOVE.L  8(A5),D7
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    PEA     6.W
    PEA     5.W
    MOVE.L  D0,-(A7)
    JSR     LAB_0211(PC)

    LEA     16(A7),A7

    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    MOVEQ   #7,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #36,D1

    ADD.L   D1,D0
    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    MOVEQ   #0,D1
    MOVE.L  #695,D2
    MOVEQ   #33,D3
    JSR     _LVORectFill(A6)

    MOVEQ   #0,D6

.row_loop:
    MOVEQ   #2,D0
    CMP.L   D0,D6
    BGE.W   .final_row

    MOVE.L  D7,D0
    ADD.L   D6,D0
    MOVEQ   #48,D1
    CMP.L   D1,D0
    BLE.S   .row_index_no_wrap

    SUB.L   D1,D0
    BRA.S   .row_index_ready

.row_index_no_wrap:
    MOVE.L  D7,D0
    ADD.L   D6,D0

.row_index_ready:
    MOVE.L  D0,D5
    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #0,D1
    MOVE.W  LAB_232B,D1
    MOVE.L  D0,20(A7)
    MOVE.L  D6,D0
    JSR     GROUPA_JMP_TBL_LAB_1A06(PC)

    MOVE.L  20(A7),D1
    ADD.L   D0,D1
    MOVEQ   #36,D0
    ADD.L   D0,D1
    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #0,D2
    MOVE.W  LAB_232B,D2
    MOVE.L  D0,24(A7)
    MOVE.L  D6,D0
    MOVE.L  D1,20(A7)
    MOVE.L  D2,D1
    JSR     GROUPA_JMP_TBL_LAB_1A06(PC)

    MOVE.L  24(A7),D1
    ADD.L   D0,D1
    MOVEQ   #0,D0
    MOVE.W  D2,D0
    ADD.L   D0,D1
    MOVEQ   #35,D0
    ADD.L   D0,D1
    PEA     33.W
    MOVE.L  D1,-(A7)
    CLR.L   -(A7)
    MOVE.L  32(A7),-(A7)
    MOVE.L  GLOB_REF_GRID_RASTPORT_MAYBE_1,-(A7)
    JSR     BEVEL_DrawBevelFrameWithTopRight(PC)

    PEA     -89(A5)
    MOVE.L  D5,-(A7)
    BSR.W   CLEANUP_FormatClockFormatEntry

    LEA     28(A7),A7
    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #0,D1
    MOVE.W  LAB_232B,D1
    MOVE.L  D0,20(A7)
    MOVE.L  D6,D0
    JSR     GROUPA_JMP_TBL_LAB_1A06(PC)

    MOVE.L  20(A7),D1
    ADD.L   D0,D1
    MOVEQ   #0,D0
    MOVE.W  LAB_232B,D0
    LEA     -89(A5),A0
    MOVEA.L A0,A1

.measure_row_text_loop:
    TST.B   (A1)+
    BNE.S   .measure_row_text_loop

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  D0,24(A7)
    MOVE.L  D1,20(A7)
    MOVE.L  A1,D0
    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  24(A7),D1
    SUB.L   D0,D1
    SUBQ.L  #8,D1
    TST.L   D1
    BPL.S   .center_row_text_x

    ADDQ.L  #1,D1

.center_row_text_x:
    ASR.L   #1,D1
    MOVE.L  20(A7),D0
    ADD.L   D1,D0
    MOVEQ   #42,D1
    ADD.L   D1,D0
    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    MOVEA.L 52(A1),A0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    MOVEQ   #34,D2
    SUB.L   D1,D2
    TST.L   D2
    BPL.S   .center_row_text_y

    ADDQ.L  #1,D2

.center_row_text_y:
    ASR.L   #1,D2
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    ADD.L   D1,D2
    SUBQ.L  #1,D2
    MOVE.L  D2,D1
    JSR     _LVOMove(A6)

    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    MOVEQ   #3,D0
    JSR     _LVOSetAPen(A6)

    LEA     -89(A5),A0
    MOVEA.L A0,A1

.draw_row_text_loop:
    TST.B   (A1)+
    BNE.S   .draw_row_text_loop

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    JSR     _LVOText(A6)

    ADDQ.L  #1,D6
    BRA.W   .row_loop

.final_row:
    MOVEQ   #2,D6
    MOVE.L  D7,D0
    ADD.L   D6,D0
    MOVEQ   #48,D1
    CMP.L   D1,D0
    BLE.S   .final_index_no_wrap

    SUB.L   D1,D0
    BRA.S   .final_index_ready

.final_index_no_wrap:
    MOVE.L  D7,D0
    ADD.L   D6,D0

.final_index_ready:
    MOVE.L  D0,D5
    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #0,D1
    MOVE.W  LAB_232B,D1
    MOVE.L  D0,20(A7)
    MOVE.L  D6,D0
    JSR     GROUPA_JMP_TBL_LAB_1A06(PC)

    MOVE.L  20(A7),D1
    ADD.L   D0,D1
    MOVEQ   #36,D0
    ADD.L   D0,D1
    PEA     33.W
    PEA     695.W
    CLR.L   -(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  GLOB_REF_GRID_RASTPORT_MAYBE_1,-(A7)
    JSR     BEVEL_DrawBevelFrameWithTopRight(PC)

    PEA     -89(A5)
    MOVE.L  D5,-(A7)
    BSR.W   CLEANUP_FormatClockFormatEntry

    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #0,D1
    MOVE.W  LAB_232B,D1
    MOVE.L  D0,48(A7)
    MOVE.L  D6,D0
    JSR     GROUPA_JMP_TBL_LAB_1A06(PC)

    MOVE.L  48(A7),D1
    ADD.L   D0,D1
    MOVEQ   #0,D0
    MOVE.W  LAB_232B,D0
    LEA     -89(A5),A0
    MOVEA.L A0,A1

.measure_final_text_loop:
    TST.B   (A1)+
    BNE.S   .measure_final_text_loop

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  D0,52(A7)
    MOVE.L  D1,48(A7)
    MOVE.L  A1,D0
    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  52(A7),D1
    SUB.L   D0,D1
    SUBQ.L  #8,D1
    TST.L   D1
    BPL.S   .center_final_text_x

    ADDQ.L  #1,D1

.center_final_text_x:
    ASR.L   #1,D1
    MOVE.L  48(A7),D0
    ADD.L   D1,D0
    MOVEQ   #42,D1
    ADD.L   D1,D0
    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    MOVEA.L 52(A1),A0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    MOVEQ   #34,D2
    SUB.L   D1,D2
    TST.L   D2
    BPL.S   .center_final_text_y

    ADDQ.L  #1,D2

.center_final_text_y:
    ASR.L   #1,D2
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    ADD.L   D1,D2
    SUBQ.L  #1,D2
    MOVE.L  D2,D1
    JSR     _LVOMove(A6)

    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    MOVEQ   #3,D0
    JSR     _LVOSetAPen(A6)

    LEA     -89(A5),A0
    MOVEA.L A0,A1

.draw_final_text_loop:
    TST.B   (A1)+
    BNE.S   .draw_final_text_loop

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    JSR     _LVOText(A6)

    MOVEM.L -120(A5),D2-D3/D5-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CLEANUP_DrawClockFormatFrame   (DrawClockFormatFrame??)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D3/A0
; CALLS:
;   LAB_026C
; READS:
;   LAB_232A, GLOB_REF_GRID_RASTPORT_MAYBE_1
; WRITES:
;   (none)
; DESC:
;   Draws the frame/box for the clock format list area.
; NOTES:
;   - Uses LAB_232A as a layout offset.
;------------------------------------------------------------------------------
CLEANUP_DrawClockFormatFrame:
LAB_01FD:
    MOVEM.L D2-D3,-(A7)
    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVE.L  D0,D1
    MOVEQ   #36,D2
    ADD.L   D2,D1
    MOVEQ   #0,D3
    MOVE.W  D0,D3
    ADD.L   D2,D3
    MOVEQ   #0,D2
    MOVE.W  D0,D2
    MOVE.L  #660,D0
    SUB.L   D2,D0
    PEA     192.W
    MOVEQ   #34,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  GLOB_REF_GRID_RASTPORT_MAYBE_1,-(A7)
    CLR.L   -(A7)
    MOVE.L  D1,-(A7)
    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A0
    MOVE.L  4(A0),-(A7)
    JSR     LAB_026C(PC)

    LEA     36(A7),A7
    MOVEM.L (A7)+,D2-D3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CLEANUP_DrawGridTimeBanner   (DrawGridTimeBanner??)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A1/A5-A6
; CALLS:
;   ESQ_FormatTimeStamp, _LVOSetAPen, _LVOSetDrMd, _LVORectFill, _LVOTextLength,
;   _LVOMove, _LVOText, JMP_TBL_ADJUST_HOURS_TO_24_HR_FMT, GROUPA_JMP_TBL_WDISP_SPrintf,
;   LAB_026C
; READS:
;   LAB_2274, GLOB_REF_RASTPORT_1, GLOB_REF_GRAPHICS_LIBRARY,
;   GLOB_REF_STR_USE_24_HR_CLOCK, GLOB_WORD_CURRENT_HOUR, GLOB_WORD_USE_24_HR_FMT,
;   GLOB_WORD_CURRENT_MINUTE, GLOB_WORD_CURRENT_SECOND,
;   GLOB_STR_GRID_TIME_FORMAT_DUPLICATE, GLOB_STR_12_44_44_SINGLE_SPACE,
;   GLOB_STR_12_44_44_PM
; WRITES:
;   Stack buffers at -32(A5) and -23(A5)
; DESC:
;   Formats and renders the time banner into the main rastport, centered
;   based on measured text widths.
; NOTES:
;   - Draws an extra AM/PM suffix when using 12-hour format.
;------------------------------------------------------------------------------
CLEANUP_DrawGridTimeBanner:
LAB_01FE:
    LINK.W  A5,#-40
    MOVEM.L D2-D7,-(A7)
    MOVEQ   #0,D5
    PEA     LAB_2274
    PEA     -32(A5)
    JSR     ESQ_FormatTimeStamp(PC)

    ADDQ.W  #8,A7
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.W  32(A0),D0
    ANDI.W  #$fff7,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.W  D0,32(A0)
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.W  58(A0),D0
    SUBQ.L  #1,D0
    MOVEA.L A0,A1
    MOVE.L  D0,D3
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    MOVEQ   #40,D2
    NOT.B   D2
    JSR     _LVORectFill(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #3,D0
    JSR     _LVOSetAPen(A6)

    MOVE.B  -23(A5),D4
    CLR.B   -23(A5)
    MOVE.B  GLOB_REF_STR_USE_24_HR_CLOCK,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .measure_sample_width

    MOVE.W  GLOB_WORD_CURRENT_HOUR,D0
    EXT.L   D0
    MOVE.W  GLOB_WORD_USE_24_HR_FMT,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     JMP_TBL_ADJUST_HOURS_TO_24_HR_FMT(PC)

    MOVE.W  GLOB_WORD_CURRENT_MINUTE,D1
    EXT.L   D1
    MOVE.W  GLOB_WORD_CURRENT_SECOND,D2
    EXT.L   D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     GLOB_STR_GRID_TIME_FORMAT_DUPLICATE
    PEA     -32(A5)
    JSR     GROUPA_JMP_TBL_WDISP_SPrintf(PC)

    LEA     24(A7),A7

.measure_sample_width:
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    LEA     GLOB_STR_12_44_44_SINGLE_SPACE,A0
    MOVEQ   #9,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,D6

    MOVE.B  GLOB_REF_STR_USE_24_HR_CLOCK,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BNE.S   .no_ampm_suffix

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    LEA     GLOB_STR_12_44_44_PM,A0
    MOVEQ   #11,D0
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,D5

    BRA.S   .center_time_text

.no_ampm_suffix:
    MOVE.L  D6,D5

.center_time_text:
    MOVEQ   #108,D0
    ADD.L   D0,D0
    SUB.L   D5,D0
    TST.L   D0
    BPL.S   .center_time_x

    ADDQ.L  #1,D0

.center_time_x:
    ASR.L   #1,D0
    MOVE.L  D0,D7
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.W  62(A0),D0
    MOVE.L  D0,24(A7)
    MOVEA.L A0,A1
    MOVE.L  D7,D0
    MOVE.L  24(A7),D1
    JSR     _LVOMove(A6)

    LEA     -32(A5),A0
    MOVEA.L A0,A1

.time_text_len_loop:
    TST.B   (A1)+
    BNE.S   .time_text_len_loop

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    JSR     _LVOText(A6)

    MOVE.B  GLOB_REF_STR_USE_24_HR_CLOCK,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BNE.S   .done

    MOVE.B  D4,-23(A5)
    MOVE.L  D7,D0
    ADD.L   D6,D0
    MOVEQ   #0,D1
    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.W  62(A0),D1
    MOVEA.L A0,A1
    JSR     _LVOMove(A6)

    LEA     -23(A5),A0
    MOVEA.L A0,A1

.ampm_text_len_loop:
    TST.B   (A1)+
    BNE.S   .ampm_text_len_loop

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    JSR     _LVOText(A6)

.done:
    MOVE.L  D7,D0
    ADDI.L  #448,D0
    MOVEQ   #0,D1
    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.W  58(A0),D1
    SUBQ.L  #2,D1
    PEA     192.W
    MOVE.L  D1,-(A7)
    MOVE.L  D5,-(A7)
    PEA     40.W
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    CLR.L   -(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  4(A0),-(A7)
    JSR     LAB_026C(PC)

    MOVEM.L -64(A5),D2-D7
    UNLK    A5
    RTS

;!======

RENDER_SHORT_MONTH_SHORT_DAY_OF_WEEK_DAY:
;------------------------------------------------------------------------------
; FUNC: RENDER_SHORT_MONTH_SHORT_DAY_OF_WEEK_DAY   (RenderShortMonthShortDowDay)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A1/A5-A6
; CALLS:
;   GROUPA_JMP_TBL_WDISP_SPrintf, _LVOSetAPen, _LVOSetDrMd, _LVORectFill,
;   _LVOTextLength, _LVOMove, _LVOText, LAB_026C
; READS:
;   LAB_2274, LAB_2275, LAB_2276, GLOB_JMP_TBL_SHORT_DAYS_OF_WEEK,
;   GLOB_JMP_TBL_SHORT_MONTHS, GLOB_STR_SHORT_MONTH_SHORT_DAY_OF_WEEK_FORMATTED,
;   GLOB_REF_RASTPORT_1, GLOB_REF_GRAPHICS_LIBRARY
; WRITES:
;   Stack buffer at -32(A5)
; DESC:
;   Formats and renders "Mon Jan 1" style text in the banner area.
; NOTES:
;   - Centers the string based on measured text width.
;------------------------------------------------------------------------------
    LINK.W  A5,#-36
    MOVEM.L D2-D3/D5-D7,-(A7)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  #GLOB_REF_696_400_BITMAP,4(A0)

    MOVE.W  LAB_2274,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     GLOB_JMP_TBL_SHORT_DAYS_OF_WEEK,A0
    ADDA.L  D0,A0

    MOVE.W  LAB_2275,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     GLOB_JMP_TBL_SHORT_MONTHS,A1
    ADDA.L  D0,A1

    MOVE.W  LAB_2276,D0
    EXT.L   D0

    MOVE.L  D0,-(A7)
    MOVE.L  (A1),-(A7)
    MOVE.L  (A0),-(A7)
    PEA     GLOB_STR_SHORT_MONTH_SHORT_DAY_OF_WEEK_FORMATTED
    PEA     -32(A5)
    JSR     GROUPA_JMP_TBL_WDISP_SPrintf(PC)

    LEA     20(A7),A7

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.W  32(A0),D0
    ANDI.W  #$fff7,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.W  D0,32(A0)
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.W  58(A0),D0
    SUBQ.L  #1,D0
    MOVEA.L A0,A1
    MOVE.L  D0,D3
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    MOVEQ   #40,D2
    NOT.B   D2
    JSR     _LVORectFill(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #3,D0
    JSR     _LVOSetAPen(A6)

    LEA     -32(A5),A0
    MOVEA.L A0,A1

.date_text_len_loop:
    TST.B   (A1)+
    BNE.S   .date_text_len_loop

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D6
    MOVE.L  D6,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,D5
    MOVEQ   #108,D0
    ADD.L   D0,D0
    SUB.L   D5,D0
    TST.L   D0
    BPL.S   .center_date_text_x

    ADDQ.L  #1,D0

.center_date_text_x:
    ASR.L   #1,D0
    MOVE.L  D0,D7
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.W  62(A0),D0
    MOVE.L  D0,20(A7)
    MOVEA.L A0,A1
    MOVE.L  D7,D0
    MOVE.L  20(A7),D1
    JSR     _LVOMove(A6)

    MOVE.L  D6,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    LEA     -32(A5),A0
    JSR     _LVOText(A6)

    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.W  58(A0),D0
    SUBQ.L  #2,D0
    PEA     192.W
    MOVE.L  D0,-(A7)
    PEA     208.W
    PEA     40.W
    PEA     44.W
    MOVE.L  A0,-(A7)
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  4(A0),-(A7)
    JSR     LAB_026C(PC)

    MOVEM.L -56(A5),D2-D3/D5-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CLEANUP_DrawDateBannerSegment   (DrawDateBannerSegment??)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D3/A0-A1/A5-A6
; CALLS:
;   _LVOSetAPen, _LVORectFill, RENDER_SHORT_MONTH_SHORT_DAY_OF_WEEK_DAY,
;   BEVEL_DrawBevelFrameWithTopRight
; READS:
;   GLOB_REF_RASTPORT_1, GLOB_REF_GRAPHICS_LIBRARY, GLOB_REF_696_400_BITMAP
; WRITES:
;   RastPort BitMap (temporary swap)
; DESC:
;   Draws the left banner segment containing the short date (day/month).
; NOTES:
;   - Temporarily swaps the rastport bitmap to GLOB_REF_696_400_BITMAP.
;------------------------------------------------------------------------------
CLEANUP_DrawDateBannerSegment:
LAB_0209:
    LINK.W  A5,#-4
    MOVEM.L D2-D3,-(A7)

.rastPortBitmap = -4

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  Struct_RastPort__BitMap(A0),.rastPortBitmap(A5)
    MOVE.L  #GLOB_REF_696_400_BITMAP,Struct_RastPort__BitMap(A0)
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.W  Struct_RastPort__Flags(A0),D0
    ANDI.W  #$fff7,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.W  D0,Struct_RastPort__Flags(A0)
    MOVEA.L A0,A1
    MOVEQ   #40,D0
    MOVEQ   #34,D1
    MOVEQ   #0,D2
    NOT.B   D2
    MOVEQ   #67,D3
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVORectFill(A6)

    BSR.W   RENDER_SHORT_MONTH_SHORT_DAY_OF_WEEK_DAY

    PEA     67.W
    PEA     255.W
    PEA     34.W
    CLR.L   -(A7)
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     BEVEL_DrawBevelFrameWithTopRight(PC)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  .rastPortBitmap(A5),Struct_RastPort__BitMap(A0)

    MOVEM.L -12(A5),D2-D3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CLEANUP_DrawBannerSpacerSegment   (DrawBannerSpacerSegment??)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D3/A0-A1/A5-A6
; CALLS:
;   _LVOSetAPen, _LVORectFill, BEVEL_DrawBevelFrameWithTopRight
; READS:
;   GLOB_REF_RASTPORT_1, GLOB_REF_GRAPHICS_LIBRARY, GLOB_REF_696_400_BITMAP
; WRITES:
;   RastPort BitMap (temporary swap)
; DESC:
;   Clears/draws the middle banner segment (no text).
;------------------------------------------------------------------------------
CLEANUP_DrawBannerSpacerSegment:
LAB_020A:
    LINK.W  A5,#-4
    MOVEM.L D2-D3,-(A7)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  4(A0),-4(A5)
    MOVE.L  #GLOB_REF_696_400_BITMAP,4(A0)
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.W  32(A0),D0
    ANDI.W  #$fff7,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.W  D0,32(A0)
    MOVEA.L A0,A1
    MOVE.L  #256,D0
    MOVEQ   #34,D1
    MOVE.L  #447,D2
    MOVEQ   #67,D3
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVORectFill(A6)

    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    PEA     34.W
    PEA     256.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     BEVEL_DrawBevelFrameWithTopRight(PC)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  -4(A5),4(A0)
    MOVEM.L -12(A5),D2-D3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CLEANUP_DrawTimeBannerSegment   (DrawTimeBannerSegment??)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D3/A0-A1/A5-A6
; CALLS:
;   _LVOSetAPen, _LVORectFill, CLEANUP_DrawGridTimeBanner, BEVEL_DrawBevelFrameWithTopRight
; READS:
;   GLOB_REF_RASTPORT_1, GLOB_REF_GRAPHICS_LIBRARY, GLOB_REF_696_400_BITMAP
; WRITES:
;   RastPort BitMap (temporary swap)
; DESC:
;   Draws the right banner segment containing the time string.
;------------------------------------------------------------------------------
CLEANUP_DrawTimeBannerSegment:
LAB_020B:
    LINK.W  A5,#-4
    MOVEM.L D2-D3,-(A7)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  4(A0),-4(A5)
    MOVE.L  #GLOB_REF_696_400_BITMAP,4(A0)
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.W  32(A0),D0
    ANDI.W  #$fff7,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.W  D0,32(A0)
    MOVEA.L A0,A1
    MOVE.L  #448,D0
    MOVEQ   #34,D1
    MOVE.L  #663,D2
    MOVEQ   #67,D3
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVORectFill(A6)

    BSR.W   CLEANUP_DrawGridTimeBanner

    PEA     67.W
    PEA     695.W
    PEA     34.W
    PEA     448.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     BEVEL_DrawBevelFrameWithTopRight(PC)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  -4(A5),4(A0)
    MOVEM.L -12(A5),D2-D3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CLEANUP_DrawDateTimeBannerRow   (DrawDateTimeBannerRow??)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D3/A0-A1/A5-A6
; CALLS:
;   _LVOSetAPen, _LVORectFill, CLEANUP_DrawDateBannerSegment,
;   CLEANUP_DrawBannerSpacerSegment, CLEANUP_DrawTimeBannerSegment
; READS:
;   GLOB_REF_RASTPORT_1, GLOB_REF_GRAPHICS_LIBRARY, GLOB_REF_696_400_BITMAP
; WRITES:
;   RastPort BitMap (temporary swap)
; DESC:
;   Clears the banner row and draws left date, middle spacer, and right time.
;------------------------------------------------------------------------------
CLEANUP_DrawDateTimeBannerRow:
LAB_020C:
    LINK.W  A5,#-4
    MOVEM.L D2-D3,-(A7)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  4(A0),-4(A5)
    MOVE.L  #GLOB_REF_696_400_BITMAP,4(A0)
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.W  32(A0),D0
    ANDI.W  #$fff7,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.W  D0,32(A0)
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    MOVEQ   #34,D1
    MOVE.L  #695,D2
    MOVEQ   #67,D3
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVORectFill(A6)

    BSR.W   CLEANUP_DrawDateBannerSegment

    BSR.W   CLEANUP_DrawBannerSpacerSegment

    BSR.W   CLEANUP_DrawTimeBannerSegment

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  -4(A5),4(A0)

    MOVEM.L (A7)+,D2-D3
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

CLEANUP_JMP_TBL_PARSEINI_UpdateClockFromRtc:
LAB_020D:
    JMP     PARSEINI_UpdateClockFromRtc

CLEANUP_JMP_TBL_ESQFUNC_DrawDiagnosticsScreen:
LAB_020E:
    JMP     ESQFUNC_DrawDiagnosticsScreen

CLEANUP_JMP_TBL_ESQFUNC_DrawMemoryStatusScreen:
LAB_020F:
    JMP     ESQFUNC_DrawMemoryStatusScreen

CLEANUP_JMP_TBL_SCRIPT_UpdateCtrlStateMachine:
LAB_0210:
    JMP     SCRIPT_UpdateCtrlStateMachine

CLEANUP_JMP_TBL_GCOMMAND_UpdateBannerBounds:
LAB_0211:
    JMP     GCOMMAND_UpdateBannerBounds

CLEANUP_JMP_TBL_SCRIPT_UpdateCtrlLineTimeout:
LAB_0212:
    JMP     SCRIPT_UpdateCtrlLineTimeout

CLEANUP_JMP_TBL_SCRIPT_ClearCtrlLineIfEnabled:
LAB_0213:
    JMP     SCRIPT_ClearCtrlLineIfEnabled

CLEANUP_JMP_TBL_ESQFUNC_PruneEntryTextPointers:
LAB_0214:
    JMP     ESQFUNC_PruneEntryTextPointers

CLEANUP_JMP_TBL_ESQDISP_DrawStatusBanner:
LAB_0215:
    JMP     ESQDISP_DrawStatusBanner

CLEANUP_JMP_TBL_DST_UpdateBannerQueue:
LAB_0216:
    JMP     DST_UpdateBannerQueue

CLEANUP_JMP_TBL_DST_RefreshBannerBuffer:
LAB_0217:
    JMP     DST_RefreshBannerBuffer

CLEANUP_JMP_TBL_DRAW_ESC_MENU_VERSION_SCREEN:
LAB_0218:
    JMP     DRAW_ESC_MENU_VERSION_SCREEN

JMP_TBL_ADJUST_HOURS_TO_24_HR_FMT:
    JMP     ADJUST_HOURS_TO_24_HR_FMT

;!======

    ; Alignment
    MOVEQ   #97,D0
