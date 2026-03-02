#include "esq_types.h"

extern s16 SCRIPT_RuntimeMode;
extern s16 SCRIPT_CtrlHandshakeRetryCount;
extern s16 TEXTDISP_CurrentMatchIndex;
extern s16 SCRIPT_RuntimeModeDispatchLatch;
extern u8 CONFIG_RuntimeMode12BannerJumpEnabledFlag;
extern s16 CONFIG_BannerCopperHeadByte;
extern u8 CONFIG_MSN_FlagChar;
extern u8 CONFIG_MsnRuntimeModeSelectorChar_LRBN;

void SCRIPT_BeginBannerCharTransition(s32 target_char, s32 budget) __attribute__((noinline));
void WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(void) __attribute__((noinline));
void TEXTDISP_SetRastForMode(s32 mode) __attribute__((noinline));
void SCRIPT_UpdateSerialShadowFromCtrlByte(u8 value) __attribute__((noinline));
void SCRIPT_ClearSearchTextsAndChannels(void) __attribute__((noinline));
void SCRIPT_DeassertCtrlLineNow(void) __attribute__((noinline));

s32 SCRIPT_UpdateRuntimeModeForPlaybackCursor(void) __attribute__((noinline, used));

s32 SCRIPT_UpdateRuntimeModeForPlaybackCursor(void)
{
    s32 shadow;

    if (SCRIPT_RuntimeMode == 1) {
        if (CONFIG_RuntimeMode12BannerJumpEnabledFlag == 'Y') {
            SCRIPT_BeginBannerCharTransition((s32)CONFIG_BannerCopperHeadByte + 28, 1000);
        }

        SCRIPT_CtrlHandshakeRetryCount = 0;
        TEXTDISP_CurrentMatchIndex = -1;
        SCRIPT_RuntimeMode = 2;
        SCRIPT_RuntimeModeDispatchLatch = 1;
        WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight();
        TEXTDISP_SetRastForMode(0);

        if (CONFIG_MSN_FlagChar == 'M' || CONFIG_MSN_FlagChar == 'S') {
            s16 mode_sel;

            mode_sel = (s16)CONFIG_MsnRuntimeModeSelectorChar_LRBN - (s16)'B';
            if (mode_sel == 0) {
                shadow = 3;
            } else {
                mode_sel -= 10;
                if (mode_sel == 0) {
                    shadow = 1;
                } else {
                    mode_sel -= 2;
                    if (mode_sel == 0) {
                        shadow = 0;
                    } else {
                        mode_sel -= 4;
                        if (mode_sel == 0) {
                            shadow = 2;
                        } else {
                            shadow = 0;
                        }
                    }
                }
            }
        } else {
            shadow = 0;
        }

        SCRIPT_UpdateSerialShadowFromCtrlByte((u8)shadow);
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
