#include "esq_types.h"

extern s16 CONFIG_BannerCopperHeadByte;
extern s16 SCRIPT_BannerTransitionActive;
extern s16 SCRIPT_BannerTransitionStepBudget;
extern s16 SCRIPT_BannerTransitionStepDelta;
extern s16 SCRIPT_BannerTransitionStepSign;
extern u8 SCRIPT_BannerTransitionTargetChar;

s32 SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar(void) __attribute__((noinline));

void SCRIPT_PrimeBannerTransitionFromHexCode(void) __attribute__((noinline, used));

void SCRIPT_PrimeBannerTransitionFromHexCode(void)
{
    s32 current = SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar();
    s16 target_word = CONFIG_BannerCopperHeadByte;
    u8 target = (u8)target_word;
    s16 delta = (s16)((s32)target - (s32)(s16)current);

    SCRIPT_BannerTransitionActive = 0;
    SCRIPT_BannerTransitionTargetChar = target;
    SCRIPT_BannerTransitionStepDelta = delta;
    SCRIPT_BannerTransitionStepBudget = 0;
    SCRIPT_BannerTransitionStepSign = (delta < 0) ? -1 : 1;

    if (delta != 0) {
        SCRIPT_BannerTransitionActive = 1;
    } else {
        SCRIPT_BannerTransitionActive = 0;
    }
}
