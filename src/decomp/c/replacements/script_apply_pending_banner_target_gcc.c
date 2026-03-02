#include "esq_types.h"

extern s16 SCRIPT_PendingBannerTargetChar;
extern s16 SCRIPT_PendingBannerSpeedMs;
extern s16 CONFIG_BannerCopperHeadByte;
extern s16 SCRIPT_ReadModeActiveLatch;
extern s16 ESQPARS2_ReadModeFlags;

s32 SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar(void) __attribute__((noinline));
void SCRIPT_BeginBannerCharTransition(s32 target_char, s32 speed_ms) __attribute__((noinline));

void SCRIPT_ApplyPendingBannerTarget(void) __attribute__((noinline, used));

void SCRIPT_ApplyPendingBannerTarget(void)
{
    s32 current_char;

    current_char = SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar();

    if (SCRIPT_PendingBannerTargetChar == -2) {
        SCRIPT_PendingBannerTargetChar = -1;
    } else if (SCRIPT_PendingBannerTargetChar != -1) {
        SCRIPT_BeginBannerCharTransition((s32)SCRIPT_PendingBannerTargetChar, (s32)(u16)SCRIPT_PendingBannerSpeedMs);
        SCRIPT_PendingBannerTargetChar = -1;
    } else if ((s16)current_char != CONFIG_BannerCopperHeadByte) {
        SCRIPT_BeginBannerCharTransition((s32)CONFIG_BannerCopperHeadByte, (s32)(u16)SCRIPT_PendingBannerSpeedMs);
        SCRIPT_PendingBannerTargetChar = -1;
    }

    if (SCRIPT_ReadModeActiveLatch != 0) {
        ESQPARS2_ReadModeFlags = 0;
        SCRIPT_ReadModeActiveLatch = 0;
    }
}
