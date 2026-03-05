typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef short WORD;
typedef long LONG;

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
extern LONG DST_BannerWindowPrimary;
extern LONG Global_REF_RASTPORT_1;

LONG ESQ_TickClockAndFlagEvents(void *clock_ref);
void GROUP_AC_JMPTBL_ESQFUNC_DrawDiagnosticsScreen(void);
void GROUP_AG_JMPTBL_TEXTDISP_ResetSelectionAndRefresh(void);
void GROUP_AC_JMPTBL_SCRIPT_ClearCtrlLineIfEnabled(void);
void GROUP_AC_JMPTBL_SCRIPT_UpdateCtrlLineTimeout(void);
void GROUP_AH_JMPTBL_ESQIFF2_ShowAttentionOverlay(LONG code);
LONG GROUP_AC_JMPTBL_DST_UpdateBannerQueue(void *banner_window);
void GROUP_AC_JMPTBL_ESQDISP_DrawStatusBanner(LONG code);
void GROUP_AC_JMPTBL_PARSEINI_UpdateClockFromRtc(void);
void GROUP_AC_JMPTBL_DST_RefreshBannerBuffer(void);
LONG DISPLIB_NormalizeValueByStep(LONG value, LONG step, LONG modulo);
void _LVOSetAPen(void);
void CLEANUP_DrawGridTimeBanner(void);
void CLEANUP_DrawClockBanner(void);
LONG GROUP_AG_JMPTBL_MATH_DivS32(LONG value, LONG divisor);
void GROUP_AC_JMPTBL_ESQFUNC_FreeExtraTitleTextPointers(LONG idx);
void GROUP_AC_JMPTBL_SCRIPT_UpdateCtrlStateMachine(void);
void GROUP_AC_JMPTBL_ESQFUNC_DrawEscMenuVersion(void);
void GROUP_AC_JMPTBL_ESQFUNC_DrawMemoryStatusScreen(void);

void CLEANUP_ProcessAlerts(void)
{
    LONG tick_code;

    if (CLEANUP_PendingAlertFlag == 0) return;
    if (CLEANUP_AlertProcessingFlag != 0) return;
    CLEANUP_AlertProcessingFlag = 1;

    if (CLEANUP_DiagOverlayAutoRefreshFlag != 0 && Global_UIBusyFlag == 0) {
        CLEANUP_AlertCooldownTicks--;
        if (CLEANUP_AlertCooldownTicks <= 0) {
            GROUP_AC_JMPTBL_ESQFUNC_DrawDiagnosticsScreen();
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
            GROUP_AG_JMPTBL_TEXTDISP_ResetSelectionAndRefresh();
        }
    }

    CLEANUP_PendingAlertFlag = 0;
    tick_code = ESQ_TickClockAndFlagEvents(&CLOCK_DaySlotIndex);
    tick_code = ESQ_TickClockAndFlagEvents(&CLOCK_CurrentDayOfWeekIndex);

    if (TEXTDISP_DeferredActionDelayTicks >= 0 && TEXTDISP_DeferredActionDelayTicks < 11) {
        GROUP_AC_JMPTBL_SCRIPT_ClearCtrlLineIfEnabled();
        if (TEXTDISP_DeferredActionDelayTicks == 0) {
            TEXTDISP_DeferredActionDelayTicks = -1;
        }
    }

    GROUP_AC_JMPTBL_SCRIPT_UpdateCtrlLineTimeout();

    if (BRUSH_PendingAlertCode == 1) {
        GROUP_AH_JMPTBL_ESQIFF2_ShowAttentionOverlay(3);
        BRUSH_PendingAlertCode = 4;
    } else if (BRUSH_PendingAlertCode == 2) {
        GROUP_AH_JMPTBL_ESQIFF2_ShowAttentionOverlay(4);
        BRUSH_PendingAlertCode = 4;
    } else if (BRUSH_PendingAlertCode == 3) {
        GROUP_AH_JMPTBL_ESQIFF2_ShowAttentionOverlay(5);
        BRUSH_PendingAlertCode = 4;
    }

    if (tick_code != 0) {
        if (WDISP_WeatherStatusCountdown > 0) {
            WDISP_WeatherStatusCountdown--;
        }
        CLEANUP_BannerTickCounter--;
        if (CLEANUP_BannerTickCounter == 0) {
            CLEANUP_BannerTickCounter = 60;
            if (TLIBA1_DayEntryModeCounter > 0) {
                TLIBA1_DayEntryModeCounter--;
            }
        }
        if (GROUP_AC_JMPTBL_DST_UpdateBannerQueue(&DST_BannerWindowPrimary) != 0) {
            GROUP_AC_JMPTBL_ESQDISP_DrawStatusBanner(1);
        }
    }

    if (ESQ_AlertType235ModeFlagChar == 'Y' && tick_code == 2) {
        ESQDISP_StatusBannerClampGateFlag = 0;
        GROUP_AC_JMPTBL_ESQDISP_DrawStatusBanner(0);
        ESQDISP_StatusBannerClampGateFlag = 1;
    }

    if ((ESQ_AlertType235ModeFlagChar == 'Y' && tick_code == 5) ||
        (ESQ_AlertType235ModeFlagChar != 'Y' && tick_code == 2)) {
        GROUP_AC_JMPTBL_PARSEINI_UpdateClockFromRtc();
        GROUP_AC_JMPTBL_DST_RefreshBannerBuffer();
        GROUP_AC_JMPTBL_ESQDISP_DrawStatusBanner(0);
    }

    if (ESQ_AlertType235ModeFlagChar == 'Y' && tick_code == 3) {
        BANNER_ResetPendingFlag = 1;
        WDISP_BannerCharRangeStart = (WORD)DISPLIB_NormalizeValueByStep((LONG)CLOCK_HalfHourSlotIndex + 1, 1, 48);
        WDISP_BannerCharRangeEnd = (WORD)DISPLIB_NormalizeValueByStep((LONG)CLOCK_HalfHourSlotIndex + 2, 1, 48);
    }

    if (ESQ_AlertType4ModeFlagChar == 'Y' && tick_code == 4) {
        WDISP_BannerCharRangeStart = (WORD)DISPLIB_NormalizeValueByStep((LONG)WDISP_BannerCharRangeStart + 1, 1, 48);
        WDISP_BannerCharRangeEnd = (WORD)DISPLIB_NormalizeValueByStep((LONG)WDISP_BannerCharRangeEnd + 1, 1, 48);
    }

    _LVOSetAPen();
    if (Global_UIBusyFlag != 0) {
        CLEANUP_DrawGridTimeBanner();
    } else {
        CLEANUP_DrawClockBanner();
    }

    if (tick_code == 2) {
        if ((GROUP_AG_JMPTBL_MATH_DivS32((LONG)CLOCK_HalfHourSlotIndex, 2) - 1) == 0) {
            BRUSH_PendingAlertCode = 0;
        }
        GROUP_AC_JMPTBL_ESQFUNC_FreeExtraTitleTextPointers((LONG)WDISP_BannerCharRangeStart);
    }

    GROUP_AC_JMPTBL_SCRIPT_UpdateCtrlStateMachine();
    if ((UBYTE)(ED_MenuStateId - 8) == 0) {
        GROUP_AC_JMPTBL_ESQFUNC_DrawEscMenuVersion();
    } else if ((UBYTE)(ED_MenuStateId - 7) == 0) {
        GROUP_AC_JMPTBL_ESQFUNC_DrawMemoryStatusScreen();
    }

    CLEANUP_AlertProcessingFlag = 0;
}
