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

void SCRIPT_SaveCtrlContextSnapshot(u8 *ctx) __attribute__((noinline, used));

void SCRIPT_SaveCtrlContextSnapshot(u8 *ctx)
{
    s32 i;
    u8 *src;
    u8 *dst;

    *(u8 *)(ctx + 436) = SCRIPT_Type20SubtypeCache;
    *(u8 *)(ctx + 437) = SCRIPT_PendingWeatherCommandChar;
    *(u8 *)(ctx + 438) = SCRIPT_PendingTextdispCmdChar;
    *(u8 *)(ctx + 439) = SCRIPT_PendingTextdispCmdArg;
    *(u8 **)(ctx + 440) = ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(
        SCRIPT_CommandTextPtr,
        *(u8 **)(ctx + 440)
    );

    *(s16 *)(ctx + 2) = SCRIPT_PrimarySearchFirstFlag;
    *(s16 *)(ctx + 4) = TEXTDISP_PrimaryChannelCode;
    *(s16 *)(ctx + 6) = TEXTDISP_SecondaryChannelCode;

    src = TEXTDISP_PrimarySearchText;
    dst = (u8 *)(ctx + 26);
    do {
        *dst = *src;
        dst++;
        src++;
    } while (*(dst - 1) != 0);

    src = TEXTDISP_SecondarySearchText;
    dst = (u8 *)(ctx + 226);
    do {
        *dst = *src;
        dst++;
        src++;
    } while (*(dst - 1) != 0);

    *(s16 *)(ctx + 8) = TEXTDISP_CurrentMatchIndex;
    *(s16 *)(ctx + 10) = SCRIPT_ChannelRangeArmedFlag;
    *(s16 *)(ctx + 12) = TEXTDISP_ChannelSourceMode;
    *(s16 *)(ctx + 14) = SCRIPT_ChannelRangeDigitChar;
    *(s32 *)(ctx + 16) = SCRIPT_SearchMatchCountOrIndex;
    *(s32 *)(ctx + 20) = SCRIPT_PlaybackCursor;
    *(s16 *)(ctx + 24) = SCRIPT_RuntimeMode;
    *(s16 *)(ctx + 426) = TEXTDISP_ActiveGroupId;

    for (i = 0; i < 4; i++) {
        *(u8 *)(ctx + 0x1ac + i) = TEXTDISP_BannerFallbackEntryIndex[i];
        *(u8 *)(ctx + 0x1b0 + i) = TEXTDISP_BannerSelectedEntryIndex[i];
    }
}
