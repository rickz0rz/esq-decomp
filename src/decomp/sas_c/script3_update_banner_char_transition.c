typedef signed long LONG;
typedef short WORD;
typedef unsigned char UBYTE;

extern WORD SCRIPT_BannerTransitionActive;
extern WORD SCRIPT_BannerTransitionStepCursor;
extern WORD SCRIPT_BannerTransitionStepDelta;
extern WORD SCRIPT_BannerTransitionStepBudget;
extern WORD SCRIPT_BannerTransitionStepSign;
extern UBYTE SCRIPT_BannerTransitionTargetChar;

extern LONG SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar(void);
extern void SCRIPT3_JMPTBL_GCOMMAND_AdjustBannerCopperOffset(LONG delta);

void SCRIPT_UpdateBannerCharTransition(void)
{
    LONG current;
    LONG target;
    WORD delta;
    WORD budget;
    WORD sign;
    LONG candidate;

    if (SCRIPT_BannerTransitionActive == 0) {
        return;
    }

    current = SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar();
    target = (LONG)SCRIPT_BannerTransitionTargetChar;

    if ((LONG)(WORD)current == target) {
        SCRIPT_BannerTransitionActive = 0;
        SCRIPT_BannerTransitionStepCursor = 0;
        return;
    }

    delta = SCRIPT_BannerTransitionStepDelta;
    budget = SCRIPT_BannerTransitionStepBudget;
    if (budget > 0) {
        SCRIPT_BannerTransitionStepCursor = (WORD)(SCRIPT_BannerTransitionStepCursor + 1);
        if (SCRIPT_BannerTransitionStepCursor >= budget) {
            delta = (WORD)(delta + SCRIPT_BannerTransitionStepSign);
            SCRIPT_BannerTransitionStepCursor = 0;
        }
    }

    candidate = (LONG)(WORD)delta + (LONG)(WORD)current;
    sign = SCRIPT_BannerTransitionStepSign;
    if (sign < 0 && candidate < target) {
        delta = (WORD)(target - (LONG)(WORD)current);
    } else if (sign > 0 && candidate > target) {
        delta = (WORD)(target - (LONG)(WORD)current);
    } else if (SCRIPT_BannerTransitionStepDelta == 0 && SCRIPT_BannerTransitionStepBudget == 0) {
        delta = (WORD)(target - (LONG)(WORD)current);
    }

    SCRIPT3_JMPTBL_GCOMMAND_AdjustBannerCopperOffset((LONG)(WORD)delta);
}
