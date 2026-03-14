#include <exec/types.h>
extern WORD GCOMMAND_DriveProbeRequestedFlag;
extern LONG ESQDISP_DisplayActiveFlag;
extern WORD Global_UIBusyFlag;
extern WORD CLEANUP_PendingAlertFlag;
extern LONG ESQDISP_SecondaryPersistRequestFlag;
extern WORD CTASKS_IffTaskDoneFlag;
extern UBYTE ESQFUNC_IffTaskGateFlags;
extern LONG Global_REF_LONG_DF0_LOGO_LST_DATA;
extern BYTE ED_DiagGraphModeChar;
extern LONG Global_REF_LONG_GFX_G_ADS_DATA;
extern void *WDISP_WeatherStatusBrushListHead;
extern void *PARSEINI_BannerBrushResourceHead;
extern LONG ESQIFF_LogoBrushListCount;
extern LONG ESQIFF_GAdsBrushListCount;
extern UWORD ESQIFF_ExternalAssetFlags;
extern UBYTE ESQDISP_StatusRefreshPendingFlag;
extern UBYTE GCOMMAND_HighlightHoldoffTickCount;

extern void DISKIO_ProbeDrivesAndAssignPaths(void);
extern void ESQDISP_PollInputModeAndRefreshSelection(void);
extern void ESQDISP_ProcessGridMessagesIfIdle(void);
extern void ED_DispatchEscMenuState(void);
extern void SCRIPT_HandleSerialCtrlCmd(void);
extern void CLEANUP_ProcessAlerts(void);
extern void ESQFUNC_CommitSecondaryStateAndPersist(void);
extern void TEXTDISP_ResetSelectionAndRefresh(void);
extern void ESQIFF_PlayNextExternalAssetFrame(WORD refreshMode);
extern void ESQIFF_QueueIffBrushLoad(WORD mode);
extern void ESQIFF_ServiceExternalAssetSourceState(WORD mode);
extern void TEXTDISP_TickDisplayState(void);
extern void ESQDISP_RefreshStatusIndicatorsFromCurrentMask(void);

void ESQFUNC_ProcessUiFrameTick(void)
{
    if (GCOMMAND_DriveProbeRequestedFlag != 0) {
        DISKIO_ProbeDrivesAndAssignPaths();
    }

    if (ESQDISP_DisplayActiveFlag == 1) {
        ESQDISP_PollInputModeAndRefreshSelection();
    }

    if (Global_UIBusyFlag == 0) {
        ESQDISP_ProcessGridMessagesIfIdle();
    }

    ED_DispatchEscMenuState();

    if (Global_UIBusyFlag == 0) {
        SCRIPT_HandleSerialCtrlCmd();
    }

    if (CLEANUP_PendingAlertFlag != 0) {
        CLEANUP_ProcessAlerts();

        if (ESQDISP_SecondaryPersistRequestFlag != 0) {
            ESQDISP_SecondaryPersistRequestFlag = 0;
            ESQFUNC_CommitSecondaryStateAndPersist();
        }

        if (CTASKS_IffTaskDoneFlag != 0) {
            if ((ESQFUNC_IffTaskGateFlags & (1u << 1)) != 0 && Global_UIBusyFlag == 0) {
                ESQFUNC_IffTaskGateFlags &= (UBYTE)~(1u << 1);
                TEXTDISP_ResetSelectionAndRefresh();
            } else if ((ESQFUNC_IffTaskGateFlags & (1u << 0)) != 0 && Global_UIBusyFlag == 0) {
                ESQFUNC_IffTaskGateFlags &= (UBYTE)~(1u << 0);
                ESQIFF_PlayNextExternalAssetFrame(1);
            }

            if (Global_REF_LONG_DF0_LOGO_LST_DATA == 0 && Global_UIBusyFlag == 0) {
                ESQIFF_ExternalAssetFlags &= (UWORD)0xFFFD;
            }

            if (ED_DiagGraphModeChar != 'N' &&
                Global_REF_LONG_GFX_G_ADS_DATA == 0 &&
                Global_UIBusyFlag == 0) {
                ESQIFF_ExternalAssetFlags &= (UWORD)0xFFFE;
            }

            if (WDISP_WeatherStatusBrushListHead == 0 &&
                PARSEINI_BannerBrushResourceHead != 0) {
                ESQIFF_QueueIffBrushLoad(0);
            }

            if (ESQIFF_LogoBrushListCount < 1) {
                ESQIFF_ServiceExternalAssetSourceState(0);
            } else if (ED_DiagGraphModeChar != 'N' &&
                       ESQIFF_GAdsBrushListCount < 2 &&
                       Global_UIBusyFlag == 0) {
                ESQIFF_ServiceExternalAssetSourceState(1);
            }
        }
    }

    TEXTDISP_TickDisplayState();

    if (ESQDISP_StatusRefreshPendingFlag != 0 &&
        GCOMMAND_HighlightHoldoffTickCount == 0) {
        ESQDISP_StatusRefreshPendingFlag = 0;
        ESQDISP_RefreshStatusIndicatorsFromCurrentMask();
    }
}
