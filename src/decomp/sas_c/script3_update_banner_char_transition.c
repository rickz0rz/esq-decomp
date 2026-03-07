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
    const WORD FLAG_FALSE = 0;
    const WORD FLAG_TRUE = 1;
    const WORD CURSOR_RESET = 0;
    LONG current;
    LONG target;
    WORD delta;
    WORD budget;
    WORD sign;
    LONG candidate;

    if (SCRIPT_BannerTransitionActive == FLAG_FALSE) {
        return;
    }

    current = SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar();
    target = (LONG)SCRIPT_BannerTransitionTargetChar;

    if ((LONG)(WORD)current == target) {
        SCRIPT_BannerTransitionActive = FLAG_FALSE;
        SCRIPT_BannerTransitionStepCursor = CURSOR_RESET;
        return;
    }

    delta = SCRIPT_BannerTransitionStepDelta;
    budget = SCRIPT_BannerTransitionStepBudget;
    if (budget > FLAG_FALSE) {
        SCRIPT_BannerTransitionStepCursor = (WORD)(SCRIPT_BannerTransitionStepCursor + FLAG_TRUE);
        if (SCRIPT_BannerTransitionStepCursor >= budget) {
            delta = (WORD)(delta + SCRIPT_BannerTransitionStepSign);
            SCRIPT_BannerTransitionStepCursor = CURSOR_RESET;
        }
    }

    candidate = (LONG)(WORD)delta + (LONG)(WORD)current;
    sign = SCRIPT_BannerTransitionStepSign;
    if (sign < 0 && candidate < target) {
        delta = (WORD)(target - (LONG)(WORD)current);
    } else if (sign > FLAG_FALSE && candidate > target) {
        delta = (WORD)(target - (LONG)(WORD)current);
    } else if (SCRIPT_BannerTransitionStepDelta == FLAG_FALSE &&
               SCRIPT_BannerTransitionStepBudget == FLAG_FALSE) {
        delta = (WORD)(target - (LONG)(WORD)current);
    }

    SCRIPT3_JMPTBL_GCOMMAND_AdjustBannerCopperOffset((LONG)(WORD)delta);
}
