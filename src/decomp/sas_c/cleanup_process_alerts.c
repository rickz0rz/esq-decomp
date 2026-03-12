typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef short WORD;
typedef long LONG;

#define CLEANUP_FLAG_CLEAR 0
#define CLEANUP_FLAG_SET 1
#define CLEANUP_ALERT_Y_CHAR 'Y'
#define CLEANUP_TICK_CODE_2 2
#define CLEANUP_TICK_CODE_3 3
#define CLEANUP_TICK_CODE_4 4
#define CLEANUP_TICK_CODE_5 5
#define CLEANUP_BANNER_WRAP_MODULO 48
#define CLEANUP_BANNER_WRAP_STEP 1
#define CLEANUP_BANNER_TICK_RESET 60

extern WORD CLEANUP_PendingAlertFlag;
extern LONG CLEANUP_AlertProcessingFlag;
extern UBYTE CLEANUP_DiagOverlayAutoRefreshFlag;
extern WORD Global_UIBusyFlag;
extern LONG CLEANUP_AlertCooldownTicks;
extern LONG LOCAVAIL_FilterStep;
extern WORD LOCAVAIL_FilterCooldownTicks;
extern WORD TEXTDISP_DeferredActionDelayTicks;
extern LONG BRUSH_PendingAlertCode;
extern UBYTE WDISP_WeatherStatusCountdown;
extern LONG CLEANUP_BannerTickCounter;
extern UBYTE TLIBA1_DayEntryModeCounter;
extern UBYTE ESQ_AlertType235ModeFlagChar;
extern UBYTE ESQ_AlertType4ModeFlagChar;
extern WORD ESQDISP_StatusBannerClampGateFlag;
extern WORD BANNER_ResetPendingFlag;
extern WORD CLOCK_HalfHourSlotIndex;
extern WORD WDISP_BannerCharRangeStart;
extern WORD WDISP_BannerCharRangeEnd;
extern UBYTE ED_MenuStateId;
extern WORD CLOCK_DaySlotIndex;
extern WORD CLOCK_CurrentDayOfWeekIndex;
extern void *DST_BannerWindowPrimary;
extern LONG Global_REF_RASTPORT_1;

LONG ESQ_TickClockAndFlagEvents(void *clock_ref);
void ESQFUNC_DrawDiagnosticsScreen(void);
void TEXTDISP_ResetSelectionAndRefresh(void);
void SCRIPT_ClearCtrlLineIfEnabled(void);
void SCRIPT_PollHandshakeAndApplyTimeout(void);
void ESQIFF2_ShowAttentionOverlay(UBYTE code);
LONG DST_UpdateBannerQueue(void *banner_window);
void ESQDISP_DrawStatusBanner(WORD code);
void PARSEINI_UpdateClockFromRtc(void);
void DST_RefreshBannerBuffer(void);
LONG DISPLIB_NormalizeValueByStep(LONG value, LONG step, LONG modulo);
void _LVOSetAPen(void);
void CLEANUP_DrawGridTimeBanner(void);
void CLEANUP_DrawClockBanner(void);
LONG MATH_DivS32(LONG value, LONG divisor);
void ESQFUNC_FreeExtraTitleTextPointers(WORD idx);
void SCRIPT_UpdateCtrlStateMachine(void);
void ESQFUNC_DrawEscMenuVersion(void);
void ESQFUNC_DrawMemoryStatusScreen(void);

void CLEANUP_ProcessAlerts(void)
{
    LONG tickCode;

    if (CLEANUP_PendingAlertFlag == CLEANUP_FLAG_CLEAR) return;
    if (CLEANUP_AlertProcessingFlag != CLEANUP_FLAG_CLEAR) return;
    CLEANUP_AlertProcessingFlag = CLEANUP_FLAG_SET;

    if (CLEANUP_DiagOverlayAutoRefreshFlag != 0 && Global_UIBusyFlag == 0) {
        CLEANUP_AlertCooldownTicks--;
        if (CLEANUP_AlertCooldownTicks <= 0) {
            ESQFUNC_DrawDiagnosticsScreen();
            CLEANUP_AlertCooldownTicks = 1;
        }
    }

    if (LOCAVAIL_FilterStep == 2) {
        if (LOCAVAIL_FilterCooldownTicks <= 0) {
            LOCAVAIL_FilterCooldownTicks += 10;
            LOCAVAIL_FilterStep = 3;
        }
    } else if (LOCAVAIL_FilterStep == 3) {
        if (LOCAVAIL_FilterCooldownTicks <= 0) {
            LOCAVAIL_FilterStep = 4;
            TEXTDISP_ResetSelectionAndRefresh();
        }
    }

    CLEANUP_PendingAlertFlag = CLEANUP_FLAG_CLEAR;
    tickCode = ESQ_TickClockAndFlagEvents(&CLOCK_DaySlotIndex);
    tickCode = ESQ_TickClockAndFlagEvents(&CLOCK_CurrentDayOfWeekIndex);

    if (TEXTDISP_DeferredActionDelayTicks >= 0 && TEXTDISP_DeferredActionDelayTicks < 11) {
        SCRIPT_ClearCtrlLineIfEnabled();
        if (TEXTDISP_DeferredActionDelayTicks == 0) {
            TEXTDISP_DeferredActionDelayTicks = -1;
        }
    }

    SCRIPT_PollHandshakeAndApplyTimeout();

    if (BRUSH_PendingAlertCode == 1) {
        ESQIFF2_ShowAttentionOverlay(3);
        BRUSH_PendingAlertCode = 4;
    } else if (BRUSH_PendingAlertCode == 2) {
        ESQIFF2_ShowAttentionOverlay(4);
        BRUSH_PendingAlertCode = 4;
    } else if (BRUSH_PendingAlertCode == 3) {
        ESQIFF2_ShowAttentionOverlay(5);
        BRUSH_PendingAlertCode = 4;
    }

    if (tickCode != 0) {
        if (WDISP_WeatherStatusCountdown > 0) {
            WDISP_WeatherStatusCountdown--;
        }
        CLEANUP_BannerTickCounter--;
        if (CLEANUP_BannerTickCounter == CLEANUP_FLAG_CLEAR) {
            CLEANUP_BannerTickCounter = CLEANUP_BANNER_TICK_RESET;
            if (TLIBA1_DayEntryModeCounter > 0) {
                TLIBA1_DayEntryModeCounter--;
            }
        }
        if (DST_UpdateBannerQueue(&DST_BannerWindowPrimary) != 0) {
            ESQDISP_DrawStatusBanner(1);
        }
    }

    if (ESQ_AlertType235ModeFlagChar == CLEANUP_ALERT_Y_CHAR && tickCode == CLEANUP_TICK_CODE_2) {
        ESQDISP_StatusBannerClampGateFlag = CLEANUP_FLAG_CLEAR;
        ESQDISP_DrawStatusBanner(CLEANUP_FLAG_CLEAR);
        ESQDISP_StatusBannerClampGateFlag = CLEANUP_FLAG_SET;
    }

    if ((ESQ_AlertType235ModeFlagChar == CLEANUP_ALERT_Y_CHAR && tickCode == CLEANUP_TICK_CODE_5) ||
        (ESQ_AlertType235ModeFlagChar != CLEANUP_ALERT_Y_CHAR && tickCode == CLEANUP_TICK_CODE_2)) {
        PARSEINI_UpdateClockFromRtc();
        DST_RefreshBannerBuffer();
        ESQDISP_DrawStatusBanner(CLEANUP_FLAG_CLEAR);
    }

    if (ESQ_AlertType235ModeFlagChar == CLEANUP_ALERT_Y_CHAR && tickCode == CLEANUP_TICK_CODE_3) {
        BANNER_ResetPendingFlag = CLEANUP_FLAG_SET;
        WDISP_BannerCharRangeStart = (WORD)DISPLIB_NormalizeValueByStep(
            (LONG)CLOCK_HalfHourSlotIndex + CLEANUP_BANNER_WRAP_STEP,
            CLEANUP_BANNER_WRAP_STEP,
            CLEANUP_BANNER_WRAP_MODULO);
        WDISP_BannerCharRangeEnd = (WORD)DISPLIB_NormalizeValueByStep(
            (LONG)CLOCK_HalfHourSlotIndex + CLEANUP_TICK_CODE_2,
            CLEANUP_BANNER_WRAP_STEP,
            CLEANUP_BANNER_WRAP_MODULO);
    }

    if (ESQ_AlertType4ModeFlagChar == CLEANUP_ALERT_Y_CHAR && tickCode == CLEANUP_TICK_CODE_4) {
        WDISP_BannerCharRangeStart = (WORD)DISPLIB_NormalizeValueByStep(
            (LONG)WDISP_BannerCharRangeStart + CLEANUP_BANNER_WRAP_STEP,
            CLEANUP_BANNER_WRAP_STEP,
            CLEANUP_BANNER_WRAP_MODULO);
        WDISP_BannerCharRangeEnd = (WORD)DISPLIB_NormalizeValueByStep(
            (LONG)WDISP_BannerCharRangeEnd + CLEANUP_BANNER_WRAP_STEP,
            CLEANUP_BANNER_WRAP_STEP,
            CLEANUP_BANNER_WRAP_MODULO);
    }

    _LVOSetAPen();
    if (Global_UIBusyFlag != 0) {
        CLEANUP_DrawGridTimeBanner();
    } else {
        CLEANUP_DrawClockBanner();
    }

    if (tickCode == CLEANUP_TICK_CODE_2) {
        if ((MATH_DivS32((LONG)CLOCK_HalfHourSlotIndex, CLEANUP_TICK_CODE_2) - CLEANUP_BANNER_WRAP_STEP) ==
            CLEANUP_FLAG_CLEAR) {
            BRUSH_PendingAlertCode = CLEANUP_FLAG_CLEAR;
        }
        ESQFUNC_FreeExtraTitleTextPointers(WDISP_BannerCharRangeStart);
    }

    SCRIPT_UpdateCtrlStateMachine();
    if ((UBYTE)(ED_MenuStateId - 8) == 0) {
        ESQFUNC_DrawEscMenuVersion();
    } else if ((UBYTE)(ED_MenuStateId - 7) == 0) {
        ESQFUNC_DrawMemoryStatusScreen();
    }

    CLEANUP_AlertProcessingFlag = CLEANUP_FLAG_CLEAR;
}
