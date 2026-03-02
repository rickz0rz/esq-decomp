#include "esq_types.h"

extern s16 SCRIPT_ReadModeActiveLatch;
extern s16 ESQPARS2_ReadModeFlags;
extern s16 TEXTDISP_CurrentMatchIndex;
extern s16 CONFIG_BannerCopperHeadByte;
extern s16 SCRIPT_PendingBannerSpeedMs;
extern s16 SCRIPT_PendingBannerTargetChar;
extern u8 CONFIG_MSN_FlagChar;
extern s16 TEXTDISP_DeferredActionCountdown;
extern s16 TEXTDISP_DeferredActionArmed;
extern s16 TEXTDISP_ChannelSourceMode;
extern s16 SCRIPT_ChannelRangeDigitChar;
extern s32 SCRIPT_SearchMatchCountOrIndex;
extern u8 SCRIPT_PendingWeatherCommandChar;
extern u8 SCRIPT_PendingTextdispCmdChar;
extern u8 SCRIPT_PendingTextdispCmdArg;
extern u8 *SCRIPT_CommandTextPtr;
extern s16 SCRIPT_RuntimeMode;
extern s16 SCRIPT_PlaybackFallbackCounter;

void WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(void) __attribute__((noinline));
void TEXTDISP_SetRastForMode(s32 mode) __attribute__((noinline));
void SCRIPT_UpdateSerialShadowFromCtrlByte(u8 value) __attribute__((noinline));
void SCRIPT3_JMPTBL_ESQ_SetCopperEffect_Custom(void) __attribute__((noinline));
void TEXTDISP_ResetSelectionAndRefresh(void) __attribute__((noinline));
void SCRIPT3_JMPTBL_CLEANUP_RenderAlignedStatusScreen(s32 mode, s32 arg, s32 flags) __attribute__((noinline));
void WDISP_HandleWeatherStatusCommand(s32 command) __attribute__((noinline));
void TEXTDISP_HandleScriptCommand(s32 command, s32 arg, u8 *text) __attribute__((noinline));
void SCRIPT_AssertCtrlLineNow(void) __attribute__((noinline));
void SCRIPT_ClearSearchTextsAndChannels(void) __attribute__((noinline));

void SCRIPT_DispatchPlaybackCursorCommand(s32 *cursor_ptr) __attribute__((noinline, used));

void SCRIPT_DispatchPlaybackCursorCommand(s32 *cursor_ptr)
{
    s32 idx;

    idx = *cursor_ptr - 1;
    if (idx < 0 || idx >= 0x0f) {
        TEXTDISP_CurrentMatchIndex = -1;
        SCRIPT_PlaybackFallbackCounter = (s16)(SCRIPT_PlaybackFallbackCounter + 1);
        SCRIPT_ClearSearchTextsAndChannels();
        *cursor_ptr = 0;
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
        SCRIPT3_JMPTBL_CLEANUP_RenderAlignedStatusScreen((s32)TEXTDISP_ChannelSourceMode, (s32)SCRIPT_ChannelRangeDigitChar, 0);
        break;
    case 5:
        SCRIPT3_JMPTBL_CLEANUP_RenderAlignedStatusScreen(1, 53, SCRIPT_SearchMatchCountOrIndex);
        break;
    case 6:
        SCRIPT3_JMPTBL_CLEANUP_RenderAlignedStatusScreen(0, 53, SCRIPT_SearchMatchCountOrIndex);
        break;
    case 7:
        TEXTDISP_CurrentMatchIndex = -1;
        WDISP_HandleWeatherStatusCommand((s32)SCRIPT_PendingWeatherCommandChar);
        break;
    case 8:
        TEXTDISP_CurrentMatchIndex = -1;
        TEXTDISP_HandleScriptCommand((s32)SCRIPT_PendingTextdispCmdChar, (s32)SCRIPT_PendingTextdispCmdArg, SCRIPT_CommandTextPtr);
        break;
    case 9:
        SCRIPT_AssertCtrlLineNow();
        SCRIPT_RuntimeMode = 1;
        break;
    case 10:
        WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight();
        TEXTDISP_SetRastForMode(0);
        SCRIPT_PendingBannerTargetChar = (s16)(CONFIG_BannerCopperHeadByte + 28);
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
    *cursor_ptr = 0;
}
