typedef signed long LONG;
typedef short WORD;
typedef unsigned char UBYTE;

extern WORD SCRIPT_ReadModeActiveLatch;
extern WORD ESQPARS2_ReadModeFlags;
extern WORD TEXTDISP_CurrentMatchIndex;
extern WORD CONFIG_BannerCopperHeadByte;
extern WORD SCRIPT_PendingBannerSpeedMs;
extern WORD SCRIPT_PendingBannerTargetChar;
extern char CONFIG_MSN_FlagChar;
extern WORD TEXTDISP_DeferredActionCountdown;
extern WORD TEXTDISP_DeferredActionArmed;
extern WORD TEXTDISP_ChannelSourceMode;
extern WORD SCRIPT_ChannelRangeDigitChar;
extern LONG SCRIPT_SearchMatchCountOrIndex;
extern UBYTE SCRIPT_PendingWeatherCommandChar;
extern UBYTE SCRIPT_PendingTextdispCmdChar;
extern UBYTE SCRIPT_PendingTextdispCmdArg;
extern char *SCRIPT_CommandTextPtr;
extern WORD SCRIPT_RuntimeMode;
extern WORD SCRIPT_PlaybackFallbackCounter;

extern void WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(void);
extern void TEXTDISP_SetRastForMode(LONG mode);
extern void SCRIPT_UpdateSerialShadowFromCtrlByte(UBYTE value);
extern void SCRIPT3_JMPTBL_ESQ_SetCopperEffect_Custom(void);
extern void TEXTDISP_ResetSelectionAndRefresh(void);
extern void SCRIPT3_JMPTBL_CLEANUP_RenderAlignedStatusScreen(LONG mode, LONG arg, LONG flags);
extern void WDISP_HandleWeatherStatusCommand(LONG command);
extern LONG TEXTDISP_HandleScriptCommand(UBYTE scriptType, UBYTE command, char *arg);
extern void SCRIPT_AssertCtrlLineNow(void);
extern void SCRIPT_ClearSearchTextsAndChannels(void);

void SCRIPT_DispatchPlaybackCursorCommand(LONG *cursorPtr)
{
    LONG idx;

    idx = *cursorPtr - 1;
    if (idx < 0 || idx >= 0x0f) {
        TEXTDISP_CurrentMatchIndex = -1;
        SCRIPT_PlaybackFallbackCounter = (WORD)(SCRIPT_PlaybackFallbackCounter + 1);
        SCRIPT_ClearSearchTextsAndChannels();
        *cursorPtr = 0;
        return;
    }

    switch (idx) {
    case 0:
        TEXTDISP_ResetSelectionAndRefresh();
        break;
    case 1:
        TEXTDISP_CurrentMatchIndex = -1;
        WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight();
        TEXTDISP_SetRastForMode(0);
        if (CONFIG_MSN_FlagChar == 'M') {
            SCRIPT_UpdateSerialShadowFromCtrlByte(3);
        } else {
            SCRIPT_UpdateSerialShadowFromCtrlByte(1);
        }
        break;
    case 2:
        TEXTDISP_CurrentMatchIndex = -1;
        WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight();
        TEXTDISP_SetRastForMode(0);
        SCRIPT_UpdateSerialShadowFromCtrlByte(1);
        break;
    case 3:
        TEXTDISP_CurrentMatchIndex = -1;
        if (TEXTDISP_DeferredActionCountdown == 0) {
            SCRIPT_UpdateSerialShadowFromCtrlByte(3);
            TEXTDISP_DeferredActionCountdown = 3;
            TEXTDISP_DeferredActionArmed = 1;
        }
        break;
    case 4:
        SCRIPT3_JMPTBL_CLEANUP_RenderAlignedStatusScreen((LONG)TEXTDISP_ChannelSourceMode, (LONG)SCRIPT_ChannelRangeDigitChar, 0);
        break;
    case 5:
        SCRIPT3_JMPTBL_CLEANUP_RenderAlignedStatusScreen(1, 53, SCRIPT_SearchMatchCountOrIndex);
        break;
    case 6:
        SCRIPT3_JMPTBL_CLEANUP_RenderAlignedStatusScreen(0, 53, SCRIPT_SearchMatchCountOrIndex);
        break;
    case 7:
        TEXTDISP_CurrentMatchIndex = -1;
        WDISP_HandleWeatherStatusCommand((LONG)SCRIPT_PendingWeatherCommandChar);
        break;
    case 8:
        TEXTDISP_CurrentMatchIndex = -1;
        TEXTDISP_HandleScriptCommand(SCRIPT_PendingTextdispCmdChar, SCRIPT_PendingTextdispCmdArg, SCRIPT_CommandTextPtr);
        break;
    case 9:
        SCRIPT_AssertCtrlLineNow();
        SCRIPT_RuntimeMode = 1;
        break;
    case 10:
        WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight();
        TEXTDISP_SetRastForMode(0);
        SCRIPT_PendingBannerTargetChar = (WORD)(CONFIG_BannerCopperHeadByte + 28);
        SCRIPT_PendingBannerSpeedMs = 1000;
        break;
    case 11:
        SCRIPT_PendingBannerTargetChar = CONFIG_BannerCopperHeadByte;
        SCRIPT_PendingBannerSpeedMs = 1000;
        break;
    case 12:
        SCRIPT3_JMPTBL_ESQ_SetCopperEffect_Custom();
        break;
    case 13:
        SCRIPT_ReadModeActiveLatch = 1;
        ESQPARS2_ReadModeFlags = 256;
        break;
    case 14:
        SCRIPT_ReadModeActiveLatch = 0;
        ESQPARS2_ReadModeFlags = 0;
        break;
    default:
        break;
    }

    SCRIPT_ClearSearchTextsAndChannels();
    *cursorPtr = 0;
}
