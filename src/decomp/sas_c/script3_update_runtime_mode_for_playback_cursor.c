typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern UWORD SCRIPT_RuntimeMode;
extern UBYTE CONFIG_RuntimeMode12BannerJumpEnabledFlag;
extern UWORD CONFIG_BannerCopperHeadByte;
extern UWORD SCRIPT_CtrlHandshakeRetryCount;
extern UWORD TEXTDISP_CurrentMatchIndex;
extern UWORD SCRIPT_RuntimeModeDispatchLatch;
extern UBYTE CONFIG_MSN_FlagChar;
extern UBYTE CONFIG_MsnRuntimeModeSelectorChar_LRBN;

extern void SCRIPT_BeginBannerCharTransition(LONG bannerChar, LONG speedMs);
extern void WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(void);
extern void TEXTDISP_SetRastForMode(LONG mode);
extern void SCRIPT_UpdateSerialShadowFromCtrlByte(LONG value);
extern void SCRIPT_ClearSearchTextsAndChannels(void);
extern void SCRIPT_DeassertCtrlLineNow(void);

UWORD SCRIPT_UpdateRuntimeModeForPlaybackCursor(void)
{
    LONG shadowByte;

    if (SCRIPT_RuntimeMode == 1) {
        if (CONFIG_RuntimeMode12BannerJumpEnabledFlag == 'Y') {
            SCRIPT_BeginBannerCharTransition((LONG)CONFIG_BannerCopperHeadByte + 28, 1000);
        }

        SCRIPT_CtrlHandshakeRetryCount = 0;
        TEXTDISP_CurrentMatchIndex = (UWORD)-1;
        SCRIPT_RuntimeMode = 2;
        SCRIPT_RuntimeModeDispatchLatch = 1;

        WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight();
        TEXTDISP_SetRastForMode(0);

        shadowByte = 0;
        if (CONFIG_MSN_FlagChar == 'M' || CONFIG_MSN_FlagChar == 'S') {
            switch ((UBYTE)CONFIG_MsnRuntimeModeSelectorChar_LRBN) {
            case 'B':
                shadowByte = 3;
                break;
            case 'L':
                shadowByte = 1;
                break;
            case 'N':
                shadowByte = 0;
                break;
            case 'R':
                shadowByte = 2;
                break;
            default:
                shadowByte = 0;
                break;
            }
        }

        SCRIPT_UpdateSerialShadowFromCtrlByte(shadowByte);
        SCRIPT_ClearSearchTextsAndChannels();
        return 1;
    }

    if (SCRIPT_RuntimeMode == 3) {
        SCRIPT_DeassertCtrlLineNow();
        SCRIPT_RuntimeModeDispatchLatch = 0;
    }

    SCRIPT_RuntimeMode = 0;
    return 0;
}
