#include "esq_types.h"

extern s16 SCRIPT_BannerTransitionActive;
extern s16 SCRIPT_BannerTransitionStepCursor;
extern s16 SCRIPT_BannerTransitionStepDelta;
extern s16 SCRIPT_BannerTransitionStepBudget;
extern s16 SCRIPT_BannerTransitionStepSign;
extern u8 SCRIPT_BannerTransitionTargetChar;

s32 SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar(void) __attribute__((noinline));
void SCRIPT3_JMPTBL_GCOMMAND_AdjustBannerCopperOffset(s32 delta) __attribute__((noinline));

void SCRIPT_UpdateBannerCharTransition(void) __attribute__((noinline, used));

void SCRIPT_UpdateBannerCharTransition(void)
{
    s32 current;
    s32 target;
    s16 delta;
    s16 budget;
    s16 sign;
    s32 candidate;

    if (SCRIPT_BannerTransitionActive == 0) {
        return;
    }

    current = SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar();
    target = (s32)SCRIPT_BannerTransitionTargetChar;

    if ((s32)(s16)current == target) {
        SCRIPT_BannerTransitionActive = 0;
        SCRIPT_BannerTransitionStepCursor = 0;
        return;
    }

    delta = SCRIPT_BannerTransitionStepDelta;
    budget = SCRIPT_BannerTransitionStepBudget;
    if (budget > 0) {
        SCRIPT_BannerTransitionStepCursor = (s16)(SCRIPT_BannerTransitionStepCursor + 1);
        if (SCRIPT_BannerTransitionStepCursor >= budget) {
            delta = (s16)(delta + SCRIPT_BannerTransitionStepSign);
            SCRIPT_BannerTransitionStepCursor = 0;
        }
    }

    candidate = (s32)(s16)delta + (s32)(s16)current;
    sign = SCRIPT_BannerTransitionStepSign;
    if (sign < 0 && candidate < target) {
        delta = (s16)(target - (s32)(s16)current);
    } else if (sign > 0 && candidate > target) {
        delta = (s16)(target - (s32)(s16)current);
    } else if (SCRIPT_BannerTransitionStepDelta == 0 && SCRIPT_BannerTransitionStepBudget == 0) {
        delta = (s16)(target - (s32)(s16)current);
    }

    SCRIPT3_JMPTBL_GCOMMAND_AdjustBannerCopperOffset((s32)(s16)delta);
}
