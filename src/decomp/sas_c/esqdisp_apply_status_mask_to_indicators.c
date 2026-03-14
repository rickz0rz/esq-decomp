#include <exec/types.h>
extern void ESQDISP_SetStatusIndicatorColorSlot(void);

void ESQDISP_ApplyStatusMaskToIndicators(LONG statusMask)
{
    if (statusMask == -1) {
        ESQDISP_SetStatusIndicatorColorSlot(-1, 1);
    } else if ((statusMask & (1L << 4)) != 0) {
        if ((statusMask & (1L << 5)) != 0) {
            ESQDISP_SetStatusIndicatorColorSlot(4, 1);
        } else {
            ESQDISP_SetStatusIndicatorColorSlot(2, 1);
        }
    } else {
        ESQDISP_SetStatusIndicatorColorSlot(7, 1);
    }

    if (statusMask == -1) {
        ESQDISP_SetStatusIndicatorColorSlot(-1, 0);
        return;
    }

    if ((statusMask & (1L << 8)) != 0) {
        ESQDISP_SetStatusIndicatorColorSlot(4, 0);
        return;
    }

    if ((statusMask & (1L << 0)) != 0) {
        if ((statusMask & (1L << 2)) != 0) {
            ESQDISP_SetStatusIndicatorColorSlot(4, 0);
            return;
        }

        if ((statusMask & (1L << 1)) != 0) {
            ESQDISP_SetStatusIndicatorColorSlot(2, 0);
            return;
        }

        ESQDISP_SetStatusIndicatorColorSlot(1, 0);
        return;
    }

    if ((statusMask & (1L << 2)) != 0) {
        ESQDISP_SetStatusIndicatorColorSlot(3, 0);
        return;
    }

    if ((statusMask & (1L << 1)) != 0) {
        ESQDISP_SetStatusIndicatorColorSlot(3, 0);
        return;
    }

    ESQDISP_SetStatusIndicatorColorSlot(7, 0);
}
