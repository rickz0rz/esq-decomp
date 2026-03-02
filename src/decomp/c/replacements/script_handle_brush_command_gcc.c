#include "esq_types.h"

extern s16 SCRIPT_RuntimeMode;
extern s32 SCRIPT_PlaybackCursor;
extern s16 SCRIPT_PrimarySearchFirstFlag;
extern s16 TEXTDISP_PrimaryChannelCode;
extern s16 TEXTDISP_SecondaryChannelCode;
extern s16 TEXTDISP_CurrentMatchIndex;
extern s16 SCRIPT_ChannelRangeArmedFlag;
extern s16 SCRIPT_ChannelRangeDigitChar;
extern s32 SCRIPT_SearchMatchCountOrIndex;
extern s16 SCRIPT_PendingBannerTargetChar;
extern s16 SCRIPT_PendingBannerSpeedMs;
extern u8 SCRIPT_PendingWeatherCommandChar;
extern u8 SCRIPT_PendingTextdispCmdChar;
extern u8 SCRIPT_PendingTextdispCmdArg;
extern u8 *SCRIPT_CommandTextPtr;
extern s16 SCRIPT_ReadModeActiveLatch;
extern s16 ESQPARS2_ReadModeFlags;
extern s16 CONFIG_BannerCopperHeadByte;
extern s16 SCRIPT_PlaybackFallbackCounter;

void SCRIPT_LoadCtrlContextSnapshot(u8 *ctx) __attribute__((noinline));
void SCRIPT_SaveCtrlContextSnapshot(u8 *ctx) __attribute__((noinline));
s32 SCRIPT_SelectPlaybackCursorFromSearchText(s32 match_count_or_index, u8 *parse_buffer) __attribute__((noinline));
void SCRIPT_SplitAndNormalizeSearchBuffer(u8 *parse_buffer, s32 parse_len) __attribute__((noinline));
void WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(void) __attribute__((noinline));
void TEXTDISP_SetRastForMode(s32 mode) __attribute__((noinline));
void SCRIPT3_JMPTBL_ESQ_SetCopperEffect_Custom(void) __attribute__((noinline));
void TEXTDISP_ResetSelectionAndRefresh(void) __attribute__((noinline));
void WDISP_HandleWeatherStatusCommand(s32 command) __attribute__((noinline));
void TEXTDISP_HandleScriptCommand(s32 command, s32 arg, u8 *text) __attribute__((noinline));
u8 *ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(u8 *new_value, u8 *old_value) __attribute__((noinline));

s32 SCRIPT_HandleBrushCommand(u8 *ctx, u8 *cmd, s32 cmd_len) __attribute__((noinline, used));

s32 SCRIPT_HandleBrushCommand(u8 *ctx, u8 *cmd, s32 cmd_len)
{
    s32 ok;
    s16 saved_runtime_mode;
    s32 sub;

    ok = 1;
    saved_runtime_mode = SCRIPT_RuntimeMode;
    SCRIPT_LoadCtrlContextSnapshot(ctx);

    SCRIPT_PlaybackCursor = 0;
    cmd[cmd_len] = 0;

    sub = (s32)cmd[0] - 1;
    if (sub >= 0 && sub < 22) {
        switch (sub) {
        case 0:
            if (SCRIPT_SelectPlaybackCursorFromSearchText(0, cmd) == 0) {
                ok = 0;
            }
            break;
        case 3:
            if (cmd[1] == 'L') {
                SCRIPT_PrimarySearchFirstFlag = 1;
            } else if (cmd[1] == 'R') {
                SCRIPT_PrimarySearchFirstFlag = 0;
            } else {
                SCRIPT_PrimarySearchFirstFlag = (s16)(SCRIPT_PrimarySearchFirstFlag == 0);
            }
            break;
        case 4:
            TEXTDISP_PrimaryChannelCode = (s16)cmd[1];
            TEXTDISP_SecondaryChannelCode = (s16)cmd[2];
            break;
        case 6:
            SCRIPT_PlaybackCursor = 15;
            break;
        case 10:
            SCRIPT_PlaybackCursor = 2;
            TEXTDISP_CurrentMatchIndex = -1;
            break;
        case 11:
            SCRIPT_PlaybackCursor = 2;
            break;
        case 14:
            SCRIPT_PlaybackCursor = 14;
            break;
        case 15:
            SCRIPT_SplitAndNormalizeSearchBuffer(cmd, cmd_len);
            break;
        case 20:
            SCRIPT_PendingTextdispCmdChar = cmd[1];
            SCRIPT_PendingTextdispCmdArg = cmd[2];
            SCRIPT_CommandTextPtr = ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(cmd + 3, SCRIPT_CommandTextPtr);
            SCRIPT_PendingBannerTargetChar = -2;
            SCRIPT_PlaybackCursor = 9;
            break;
        case 21:
            if (cmd[1] == '9') {
                SCRIPT_ReadModeActiveLatch = 1;
                ESQPARS2_ReadModeFlags = 256;
            } else if (cmd[1] == '8') {
                SCRIPT_PendingTextdispCmdChar = cmd[1];
                SCRIPT_PendingTextdispCmdArg = cmd[2];
                SCRIPT_PlaybackCursor = 8;
            } else {
                SCRIPT_PlaybackFallbackCounter = (s16)(SCRIPT_PlaybackFallbackCounter + 1);
            }
            break;
        default:
            break;
        }
    }

    SCRIPT_SaveCtrlContextSnapshot(ctx);

    if (SCRIPT_PlaybackCursor != 0) {
        TEXTDISP_HandleScriptCommand(-1, -1, (u8 *)0);
    }

    SCRIPT_RuntimeMode = saved_runtime_mode;
    return ok;
}
