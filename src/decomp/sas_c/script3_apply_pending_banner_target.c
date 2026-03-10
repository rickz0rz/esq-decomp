typedef signed long LONG;
typedef short WORD;

extern WORD SCRIPT_PendingBannerTargetChar;
extern WORD SCRIPT_PendingBannerSpeedMs;
extern WORD CONFIG_BannerCopperHeadByte;
extern WORD SCRIPT_ReadModeActiveLatch;
extern WORD ESQPARS2_ReadModeFlags;

extern LONG SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar(void);
extern WORD SCRIPT_BeginBannerCharTransition(LONG targetChar, LONG speedMs);

void SCRIPT_ApplyPendingBannerTarget(void)
{
    LONG current;

    current = SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar();

    if (SCRIPT_PendingBannerTargetChar == -2) {
        SCRIPT_PendingBannerTargetChar = -1;
    } else if (SCRIPT_PendingBannerTargetChar != -1) {
        SCRIPT_BeginBannerCharTransition((LONG)SCRIPT_PendingBannerTargetChar, (LONG)SCRIPT_PendingBannerSpeedMs);
        SCRIPT_PendingBannerTargetChar = -1;
    } else if ((LONG)CONFIG_BannerCopperHeadByte != current) {
        SCRIPT_BeginBannerCharTransition((LONG)CONFIG_BannerCopperHeadByte, (LONG)SCRIPT_PendingBannerSpeedMs);
        SCRIPT_PendingBannerTargetChar = -1;
    }

    if (SCRIPT_ReadModeActiveLatch != 0) {
        ESQPARS2_ReadModeFlags = 0;
        SCRIPT_ReadModeActiveLatch = 0;
    }
}
