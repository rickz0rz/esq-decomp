typedef signed long LONG;
typedef short WORD;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern char CONFIG_LRBN_FlagChar;
extern char CONFIG_MSN_FlagChar;
extern WORD Global_WORD_SELECT_CODE_IS_RAVESC;

extern WORD SCRIPT_BannerTransitionActive;
extern UBYTE SCRIPT_BannerTransitionTargetChar;
extern WORD SCRIPT_BannerTransitionStepDelta;
extern WORD SCRIPT_BannerTransitionStepBudget;
extern WORD SCRIPT_BannerTransitionStepSign;
extern WORD SCRIPT_PendingBannerSpeedMs;

extern LONG GCOMMAND_GetBannerChar(void);
extern LONG SCRIPT3_JMPTBL_MATH_DivS32(LONG dividend, LONG divisor);
extern LONG SCRIPT3_JMPTBL_MATH_Mulu32(LONG left, LONG right);

WORD SCRIPT_BeginBannerCharTransition(LONG targetChar, LONG speedMs)
{
    LONG current;
    LONG delta;
    LONG ticks;
    LONG absDelta;
    LONG remainder;
    LONG stepDelta;
    WORD started;

    started = 0;

    if (CONFIG_LRBN_FlagChar != 'Y') {
        return started;
    }

    if (targetChar < 130) {
        targetChar = 130;
    } else if (targetChar > 226) {
        targetChar = 226;
    }

    if (speedMs < 0) {
        speedMs = 0;
    } else if (speedMs > 0x1d4c) {
        speedMs = 0x1d4c;
    }

    current = GCOMMAND_GetBannerChar();
    if (SCRIPT_BannerTransitionActive != 0) {
        return started;
    }
    if ((WORD)current == (WORD)targetChar) {
        return started;
    }

    delta = (LONG)(WORD)targetChar - (LONG)(WORD)current;
    SCRIPT_BannerTransitionTargetChar = (UBYTE)targetChar;

    if (Global_WORD_SELECT_CODE_IS_RAVESC != 0 || CONFIG_MSN_FlagChar == 'M') {
        if (delta < 0) {
            speedMs = 7500;
        } else {
            speedMs = 0;
        }
    }

    ticks = SCRIPT3_JMPTBL_MATH_DivS32(speedMs * 60, 1000);
    if (ticks <= 0) {
        SCRIPT_BannerTransitionStepDelta = (WORD)delta;
    } else {
        if (delta < 0) {
            SCRIPT_BannerTransitionStepSign = -1;
            absDelta = -delta;
        } else {
            SCRIPT_BannerTransitionStepSign = 1;
            absDelta = delta;
        }

        stepDelta = SCRIPT3_JMPTBL_MATH_DivS32(absDelta, ticks);
        SCRIPT_BannerTransitionStepDelta = (WORD)stepDelta;

        remainder = absDelta - SCRIPT3_JMPTBL_MATH_Mulu32(stepDelta, ticks);
        if (remainder > 0) {
            SCRIPT_BannerTransitionStepBudget = (WORD)SCRIPT3_JMPTBL_MATH_DivS32(ticks, remainder);
        } else {
            SCRIPT_BannerTransitionStepBudget = 0;
        }

        SCRIPT_BannerTransitionStepDelta =
            (WORD)((LONG)SCRIPT_BannerTransitionStepDelta * (LONG)SCRIPT_BannerTransitionStepSign);
    }

    started = 1;
    SCRIPT_BannerTransitionActive = started;
    SCRIPT_PendingBannerSpeedMs = (WORD)speedMs;
    return started;
}
