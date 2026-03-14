#include <exec/types.h>
extern WORD GCOMMAND_BannerQueueSlotCurrent;
extern UBYTE ESQPARS2_BannerQueueBuffer[];
extern WORD ESQPARS2_BannerQueueAttentionDelayTicks;
extern WORD ESQPARS2_BannerQueueAttentionCountdown;
extern WORD ESQPARS2_ReadModeFlags;
extern UBYTE ESQDISP_StatusIndicatorDeferredApplyFlag;
extern UBYTE GCOMMAND_HighlightHoldoffTickCount;
extern UBYTE ESQDISP_StatusRefreshPendingFlag;

void GCOMMAND_ConsumeBannerQueueEntry(void)
{
    WORD slot = GCOMMAND_BannerQueueSlotCurrent;
    UBYTE value = ESQPARS2_BannerQueueBuffer[slot];

    if (value != 0) {
        if (value == 0xFF) {
            WORD d = ESQPARS2_BannerQueueAttentionDelayTicks;
            d -= 1;
            ESQPARS2_BannerQueueAttentionCountdown = d;
            ESQDISP_StatusIndicatorDeferredApplyFlag = 1;
        } else if (value == 0xFE) {
            ESQPARS2_ReadModeFlags = 0x0101;
        } else {
            ESQPARS2_ReadModeFlags = (WORD)value;
        }
    }

    ESQPARS2_BannerQueueBuffer[slot] = 0;

    if (ESQPARS2_BannerQueueAttentionCountdown >= 0) {
        WORD d = ESQPARS2_BannerQueueAttentionCountdown;
        d -= 1;
        ESQPARS2_BannerQueueAttentionCountdown = d;
        GCOMMAND_HighlightHoldoffTickCount = 2;
        if (d < 0) {
            ESQDISP_StatusIndicatorDeferredApplyFlag = 0;
            ESQDISP_StatusRefreshPendingFlag = 1;
        }
    }
}
