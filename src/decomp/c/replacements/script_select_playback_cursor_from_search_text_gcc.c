#include "esq_types.h"

extern s32 SCRIPT_SearchMatchCountOrIndex;
extern s16 SCRIPT_ChannelRangeArmedFlag;
extern s16 SCRIPT_PrimarySearchFirstFlag;
extern s16 TEXTDISP_SecondaryChannelCode;
extern u8 TEXTDISP_SecondarySearchText[];
extern s16 TEXTDISP_PrimaryChannelCode;
extern u8 TEXTDISP_PrimarySearchText[];
extern s32 SCRIPT_PlaybackCursor;

s32 TEXTDISP_SelectGroupAndEntry(u8 *parse_ptr, u8 *search_text, s32 channel_code) __attribute__((noinline));

s32 SCRIPT_SelectPlaybackCursorFromSearchText(s32 match_count_or_index, u8 *parse_buffer) __attribute__((noinline, used));

s32 SCRIPT_SelectPlaybackCursorFromSearchText(s32 match_count_or_index, u8 *parse_buffer)
{
    s16 split_idx;
    s32 found;

    found = 1;
    SCRIPT_SearchMatchCountOrIndex = match_count_or_index;
    SCRIPT_ChannelRangeArmedFlag = 1;
    split_idx = 3;

    while (1) {
        if (parse_buffer[split_idx] == 18) {
            break;
        }
        if (split_idx >= 30) {
            break;
        }
        split_idx++;
    }

    parse_buffer[split_idx] = 0;

    if (SCRIPT_PrimarySearchFirstFlag == 0) {
        if (TEXTDISP_SelectGroupAndEntry(parse_buffer + split_idx + 1, TEXTDISP_SecondarySearchText, (s32)TEXTDISP_SecondaryChannelCode) == 1) {
            SCRIPT_PlaybackCursor = 7;
            return found;
        }
    }

    if (TEXTDISP_SelectGroupAndEntry(parse_buffer + 2, TEXTDISP_PrimarySearchText, (s32)TEXTDISP_PrimaryChannelCode) == 1) {
        SCRIPT_PlaybackCursor = 6;
        return found;
    }

    if (SCRIPT_PrimarySearchFirstFlag != 0) {
        if (TEXTDISP_SelectGroupAndEntry(parse_buffer + split_idx + 1, TEXTDISP_SecondarySearchText, (s32)TEXTDISP_SecondaryChannelCode) == 1) {
            SCRIPT_PlaybackCursor = 7;
            return found;
        }
    }

    found = 0;
    SCRIPT_ChannelRangeArmedFlag = 0;
    SCRIPT_PlaybackCursor = 1;
    return found;
}
