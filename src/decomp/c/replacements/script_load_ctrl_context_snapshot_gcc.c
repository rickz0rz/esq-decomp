#include "esq_types.h"

extern u8 SCRIPT_Type20SubtypeCache;
extern u8 SCRIPT_PendingWeatherCommandChar;
extern u8 SCRIPT_PendingTextdispCmdChar;
extern u8 SCRIPT_PendingTextdispCmdArg;
extern u8 *SCRIPT_CommandTextPtr;
extern s16 SCRIPT_PrimarySearchFirstFlag;
extern s16 TEXTDISP_PrimaryChannelCode;
extern s16 TEXTDISP_SecondaryChannelCode;
extern u8 TEXTDISP_PrimarySearchText[];
extern u8 TEXTDISP_SecondarySearchText[];
extern s16 TEXTDISP_CurrentMatchIndex;
extern s16 SCRIPT_ChannelRangeArmedFlag;
extern s16 TEXTDISP_ChannelSourceMode;
extern s16 SCRIPT_ChannelRangeDigitChar;
extern s32 SCRIPT_SearchMatchCountOrIndex;
extern s32 SCRIPT_PlaybackCursor;
extern s16 SCRIPT_RuntimeMode;
extern s16 TEXTDISP_ActiveGroupId;
extern u8 TEXTDISP_BannerFallbackEntryIndex[];
extern u8 TEXTDISP_BannerSelectedEntryIndex[];

u8 *ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(u8 *new_value, u8 *old_value) __attribute__((noinline));

void SCRIPT_LoadCtrlContextSnapshot(u8 *ctx) __attribute__((noinline, used));

void SCRIPT_LoadCtrlContextSnapshot(u8 *ctx)
{
    s32 i;
    u8 *src;
    u8 *dst;
    s16 saved_mode;

    SCRIPT_Type20SubtypeCache = *(u8 *)(ctx + 436);
    SCRIPT_PendingWeatherCommandChar = *(u8 *)(ctx + 437);
    SCRIPT_PendingTextdispCmdChar = *(u8 *)(ctx + 438);
    SCRIPT_PendingTextdispCmdArg = *(u8 *)(ctx + 439);

    SCRIPT_CommandTextPtr = ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(
        *(u8 **)(ctx + 440),
        SCRIPT_CommandTextPtr
    );

    SCRIPT_PrimarySearchFirstFlag = *(s16 *)(ctx + 2);
    TEXTDISP_PrimaryChannelCode = *(s16 *)(ctx + 4);
    TEXTDISP_SecondaryChannelCode = *(s16 *)(ctx + 6);

    src = (u8 *)(ctx + 26);
    dst = TEXTDISP_PrimarySearchText;
    do {
        *dst = *src;
        dst++;
        src++;
    } while (*(dst - 1) != 0);

    src = (u8 *)(ctx + 226);
    dst = TEXTDISP_SecondarySearchText;
    do {
        *dst = *src;
        dst++;
        src++;
    } while (*(dst - 1) != 0);

    TEXTDISP_CurrentMatchIndex = *(s16 *)(ctx + 8);
    SCRIPT_ChannelRangeArmedFlag = *(s16 *)(ctx + 10);
    TEXTDISP_ChannelSourceMode = *(s16 *)(ctx + 12);
    SCRIPT_ChannelRangeDigitChar = *(s16 *)(ctx + 14);
    SCRIPT_SearchMatchCountOrIndex = *(s32 *)(ctx + 16);
    SCRIPT_PlaybackCursor = *(s32 *)(ctx + 20);

    saved_mode = *(s16 *)(ctx + 24);
    if (SCRIPT_RuntimeMode == 2) {
        if (saved_mode == 3) {
            SCRIPT_RuntimeMode = saved_mode;
        }
    } else if (SCRIPT_RuntimeMode == 0) {
        if (saved_mode == 1) {
            SCRIPT_RuntimeMode = saved_mode;
        }
    }

    TEXTDISP_ActiveGroupId = *(s16 *)(ctx + 426);
    for (i = 0; i < 4; i++) {
        TEXTDISP_BannerFallbackEntryIndex[i] = *(u8 *)(ctx + 0x1ac + i);
        TEXTDISP_BannerSelectedEntryIndex[i] = *(u8 *)(ctx + 0x1b0 + i);
    }
}
