/* RESTORES: CLEANUP_ProcessAlerts
 * MODULE:   modules/groups/a/c/cleanup2_cleanup_processalerts.s
 * STATUS:   behavioural
 *
 * The once-per-tick alert and banner state machine, 782 bytes. It runs only when
 * the pending-alert flag is set and a re-entry guard is clear, and it sets that
 * guard for its whole body -- so it cannot nest even though almost everything it
 * calls can raise another alert.
 *
 * NO STACK FRAME. The original opens with a bare `MOVEM.L D2/D7,-(A7)` and no
 * `LINK`, so the usual A5-frame divergence does not apply to this restoration and
 * there is no frame class in the mismatch list below.
 *
 * D7 IS THE CLOCK EVENT CODE and it drives five separate decisions further down:
 * 2 means the half-hour rolled, 3 and 4 advance the banner character range, and 5
 * forces a clock re-read. It comes from the FIRST of the two
 * ESQ_TickClockAndFlagEvents calls; the second one's result is discarded, which is
 * why the two calls are not interchangeable.
 *
 * TWO OF THE ALERT ARMS SHARE A BODY THROUGH AN INVERTED TEST. The clock-re-read
 * arm fires when the mode flag is 'Y' AND the event is 5, or when the flag is NOT
 * 'Y' and the event is 2. The original reaches it from two branches into one label,
 * and writing it as a single `||` is what keeps that one body shared.
 *
 * The three brush alert codes 1, 2 and 3 map to overlays 3, 4 and 5 and all three
 * then set the code to 4. They are tested in sequence, not as a switch, so a code
 * of 1 shows overlay 3 and is immediately retested against 2 and 3 -- it cannot
 * match, but the tests are emitted.
 *
 * MEASURED: 780 emitted against 782 in the original, -2 over 20 regions.
 *
 * SASC-MISMATCH: register-argument-divide
 *   ref:     7202 4eba....         MOVEQ #2,D1 / JSR MATH_DivS32
 *   got:     the remainder computed inline
 *   summary: the half-hour parity test takes MATH_DivS32's REMAINDER from D1,
 *            which no C return value carries, so it is written as `% 2`.
 *   scope:   program-wide wherever MATH_DivS32's remainder is used.
 *   retest:  a compiler whose divide helper IS this routine.
 *
 * SASC-MISMATCH: cross-unit-call
 *   ref:     4eba....              JSR (d16,PC)
 *   got:     61000000              BSR.W
 *   summary: same size, different opcode; costs nothing.
 *   scope:   the whole cross-unit bucket.
 *   retest:  a compiler that picks the encoding per callee.
 *
 * SASC-MISMATCH: unattributed-body-delta
 *   summary: NOT itemised. Recorded as a known-unknown per AGENTS.md rule 3.
 *   retest:  re-run casm.py once the call-encoding class is gone.
 */
#include <exec/types.h>
#include <graphics/gfx.h>
#include <graphics/rastport.h>
#include <graphics/gfxbase.h>

#include "esq-graphics.h"

extern short CLEANUP_PendingAlertFlag;
extern long  CLEANUP_AlertProcessingFlag;
extern long  CLEANUP_AlertCooldownTicks;
extern long  CLEANUP_BannerTickCounter;
extern unsigned char CLEANUP_DiagOverlayAutoRefreshFlag;
extern short Global_UIBusyFlag;
extern long  LOCAVAIL_FilterStep;
extern short LOCAVAIL_FilterCooldownTicks;
extern short TEXTDISP_DeferredActionDelayTicks;
extern long  BRUSH_PendingAlertCode;
extern unsigned char WDISP_WeatherStatusCountdown;
extern unsigned char TLIBA1_DayEntryModeCounter;
extern void *DST_BannerWindowPrimary;
extern unsigned char ESQ_AlertType235ModeFlagChar;
extern unsigned char ESQ_AlertType4ModeFlagChar;
extern short ESQDISP_StatusBannerClampGateFlag;
extern short BANNER_ResetPendingFlag;
extern short CLOCK_HalfHourSlotIndex;
extern short WDISP_BannerCharRangeStart;
extern short WDISP_BannerCharRangeEnd;
extern short CLOCK_DaySlotIndex;
extern short CLOCK_CurrentDayOfWeekIndex;
extern unsigned char ED_MenuStateId;
extern struct RastPort *Global_REF_RASTPORT_1;

extern void ESQFUNC_DrawDiagnosticsScreen(void);
extern void TEXTDISP_ResetSelectionAndRefresh(void);
extern short ESQ_TickClockAndFlagEvents(short *slot);
extern void SCRIPT_ClearCtrlLineIfEnabled(void);
extern void SCRIPT_PollHandshakeAndApplyTimeout(void);
extern void ESQIFF2_ShowAttentionOverlay(long kind);
extern long DST_UpdateBannerQueue(void *pair);
extern void ESQDISP_DrawStatusBanner(long mode);
extern void PARSEINI_UpdateClockFromRtc(void);
extern void DST_RefreshBannerBuffer(void);
extern long DISPLIB_NormalizeValueByStep(long v, long lo, long hi);
extern void CLEANUP_DrawGridTimeBanner(void);
extern void CLEANUP_DrawClockBanner(void);
extern void ESQFUNC_FreeExtraTitleTextPointers(long v);
extern void SCRIPT_UpdateCtrlStateMachine(void);
extern void ESQFUNC_DrawEscMenuVersion(void);
extern void ESQFUNC_DrawMemoryStatusScreen(void);

void CLEANUP_ProcessAlerts(void)
{
    long event;

    if (CLEANUP_PendingAlertFlag == 0)
        return;
    if (CLEANUP_AlertProcessingFlag != 0)
        return;

    CLEANUP_AlertProcessingFlag = 1;

    if (CLEANUP_DiagOverlayAutoRefreshFlag != 0 && Global_UIBusyFlag == 0) {
        CLEANUP_AlertCooldownTicks = CLEANUP_AlertCooldownTicks - 1;
        if (CLEANUP_AlertCooldownTicks <= 0) {
            ESQFUNC_DrawDiagnosticsScreen();
            CLEANUP_AlertCooldownTicks = 1;
        }
    }

    if (LOCAVAIL_FilterStep == 2) {
        if (LOCAVAIL_FilterCooldownTicks <= 0) {
            LOCAVAIL_FilterCooldownTicks = LOCAVAIL_FilterCooldownTicks + 10;
            LOCAVAIL_FilterStep = 3;
        }
    } else if (LOCAVAIL_FilterStep == 3) {
        if (LOCAVAIL_FilterCooldownTicks <= 0) {
            LOCAVAIL_FilterStep = 4;
            TEXTDISP_ResetSelectionAndRefresh();
        }
    }

    CLEANUP_PendingAlertFlag = 0;

    event = ESQ_TickClockAndFlagEvents(&CLOCK_DaySlotIndex);
    ESQ_TickClockAndFlagEvents(&CLOCK_CurrentDayOfWeekIndex);

    if (TEXTDISP_DeferredActionDelayTicks >= 0 &&
        TEXTDISP_DeferredActionDelayTicks < 11) {
        SCRIPT_ClearCtrlLineIfEnabled();
        if (TEXTDISP_DeferredActionDelayTicks == 0)
            TEXTDISP_DeferredActionDelayTicks = -1;
    }

    SCRIPT_PollHandshakeAndApplyTimeout();

    if (BRUSH_PendingAlertCode == 1) {
        ESQIFF2_ShowAttentionOverlay(3L);
        BRUSH_PendingAlertCode = 4;
    }
    if (BRUSH_PendingAlertCode == 2) {
        ESQIFF2_ShowAttentionOverlay(4L);
        BRUSH_PendingAlertCode = 4;
    }
    if (BRUSH_PendingAlertCode == 3) {
        ESQIFF2_ShowAttentionOverlay(5L);
        BRUSH_PendingAlertCode = 4;
    }

    if (event != 0) {
        if (WDISP_WeatherStatusCountdown > 0)
            WDISP_WeatherStatusCountdown = WDISP_WeatherStatusCountdown - 1;

        CLEANUP_BannerTickCounter = CLEANUP_BannerTickCounter - 1;
        if (CLEANUP_BannerTickCounter == 0) {
            CLEANUP_BannerTickCounter = 60;
            if (TLIBA1_DayEntryModeCounter > 0)
                TLIBA1_DayEntryModeCounter = TLIBA1_DayEntryModeCounter - 1;
        }

        if (DST_UpdateBannerQueue(&DST_BannerWindowPrimary) != 0)
            ESQDISP_DrawStatusBanner(1L);
    }

    if (ESQ_AlertType235ModeFlagChar == 'Y' && event == 2) {
        ESQDISP_StatusBannerClampGateFlag = 0;
        ESQDISP_DrawStatusBanner(0L);
        ESQDISP_StatusBannerClampGateFlag = 1;
    }

    if ((ESQ_AlertType235ModeFlagChar == 'Y' && event == 5) ||
        (ESQ_AlertType235ModeFlagChar != 'Y' && event == 2)) {
        PARSEINI_UpdateClockFromRtc();
        DST_RefreshBannerBuffer();
        ESQDISP_DrawStatusBanner(0L);
    }

    if (ESQ_AlertType235ModeFlagChar == 'Y' && event == 3) {
        BANNER_ResetPendingFlag = 1;
        WDISP_BannerCharRangeStart = (short)DISPLIB_NormalizeValueByStep(
            (long)(CLOCK_HalfHourSlotIndex + 1), 1L, 48L);
        WDISP_BannerCharRangeEnd = (short)DISPLIB_NormalizeValueByStep(
            (long)(CLOCK_HalfHourSlotIndex + 2), 1L, 48L);
    }

    if (ESQ_AlertType4ModeFlagChar == 'Y' && event == 4) {
        WDISP_BannerCharRangeStart = WDISP_BannerCharRangeStart + 1;
        WDISP_BannerCharRangeStart = (short)DISPLIB_NormalizeValueByStep(
            (long)WDISP_BannerCharRangeStart, 1L, 48L);
        WDISP_BannerCharRangeEnd = WDISP_BannerCharRangeEnd + 1;
        WDISP_BannerCharRangeEnd = (short)DISPLIB_NormalizeValueByStep(
            (long)WDISP_BannerCharRangeEnd, 1L, 48L);
    }

    SetAPen(Global_REF_RASTPORT_1, 1L);
    if (Global_UIBusyFlag != 0)
        CLEANUP_DrawGridTimeBanner();
    else
        CLEANUP_DrawClockBanner();

    if (event == 2) {
        if (((long)CLOCK_HalfHourSlotIndex - ((long)CLOCK_HalfHourSlotIndex / 2) * 2) == 1)
            BRUSH_PendingAlertCode = 0;
        ESQFUNC_FreeExtraTitleTextPointers(
            (long)WDISP_BannerCharRangeStart);
    }

    SCRIPT_UpdateCtrlStateMachine();

    if (ED_MenuStateId == 8)
        ESQFUNC_DrawEscMenuVersion();
    else if (ED_MenuStateId == 7)
        ESQFUNC_DrawMemoryStatusScreen();

    CLEANUP_AlertProcessingFlag = 0;
}
