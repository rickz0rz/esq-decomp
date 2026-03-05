typedef unsigned long ULONG;
typedef signed long LONG;

extern ULONG ESQDISP_StatusIndicatorMask;
extern void ESQDISP_ApplyStatusMaskToIndicators(void);

void ESQDISP_UpdateStatusMaskAndRefresh(ULONG mask, LONG setMode)
{
    ULONG oldMask;

    oldMask = ESQDISP_StatusIndicatorMask;

    if (setMode != 0) {
        ESQDISP_StatusIndicatorMask |= mask;
    } else {
        ESQDISP_StatusIndicatorMask &= ~mask;
    }

    ESQDISP_StatusIndicatorMask &= 0x0FFFUL;

    if (ESQDISP_StatusIndicatorMask == oldMask) {
        return;
    }

    ESQDISP_ApplyStatusMaskToIndicators(ESQDISP_StatusIndicatorMask);
}
