typedef signed long LONG;
typedef short WORD;
typedef unsigned char UBYTE;

extern WORD SCRIPT_BannerTransitionActive;
extern UBYTE CONFIG_BannerCopperHeadByte;
extern UBYTE SCRIPT_BannerTransitionTargetChar;
extern WORD SCRIPT_BannerTransitionStepDelta;
extern WORD SCRIPT_BannerTransitionStepBudget;
extern WORD SCRIPT_BannerTransitionStepSign;

extern LONG SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar(void);

void SCRIPT_PrimeBannerTransitionFromHexCode(void)
{
    LONG current;
    LONG delta;

    current = SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar();
    SCRIPT_BannerTransitionActive = 0;

    delta = (LONG)(UBYTE)CONFIG_BannerCopperHeadByte - current;
    SCRIPT_BannerTransitionTargetChar = CONFIG_BannerCopperHeadByte;
    SCRIPT_BannerTransitionStepDelta = (WORD)delta;

    if (delta < 0) {
        SCRIPT_BannerTransitionStepSign = -1;
    } else {
        SCRIPT_BannerTransitionStepSign = 1;
    }

    SCRIPT_BannerTransitionStepBudget = 0;
    SCRIPT_BannerTransitionActive = (delta != 0) ? 1 : 0;
}
