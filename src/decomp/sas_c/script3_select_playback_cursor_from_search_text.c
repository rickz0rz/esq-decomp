#include <exec/types.h>
extern LONG SCRIPT_SearchMatchCountOrIndex;
extern UWORD SCRIPT_ChannelRangeArmedFlag;
extern UWORD SCRIPT_PrimarySearchFirstFlag;
extern UWORD TEXTDISP_SecondaryChannelCode;
extern char TEXTDISP_SecondarySearchText[];
extern UWORD TEXTDISP_PrimaryChannelCode;
extern char TEXTDISP_PrimarySearchText[];
extern LONG SCRIPT_PlaybackCursor;

extern LONG TEXTDISP_SelectGroupAndEntry(const char *arg, char *searchText, LONG channelCode);

LONG SCRIPT_SelectPlaybackCursorFromSearchText(LONG matchIndex, char *text)
{
    const LONG FLAG_TRUE = 1;
    const LONG FLAG_FALSE = 0;
    const UWORD SPLIT_START = 3;
    const UWORD SPLIT_LIMIT = 30;
    const char SPLIT_TOKEN = 18;
    const char CH_NUL = 0;
    const LONG PRIMARY_TEXT_OFFSET = 2;
    const LONG SECONDARY_TEXT_STEP = 1;
    const LONG CURSOR_PRIMARY_MATCH = 6;
    const LONG CURSOR_SECONDARY_MATCH = 7;
    const LONG CURSOR_FALLBACK = 1;
    LONG ok;
    UWORD split;

    ok = FLAG_TRUE;
    SCRIPT_SearchMatchCountOrIndex = matchIndex;
    SCRIPT_ChannelRangeArmedFlag = FLAG_TRUE;

    split = SPLIT_START;
    while (text[split] != SPLIT_TOKEN && split < SPLIT_LIMIT) {
        split++;
    }
    text[split] = CH_NUL;

    if (SCRIPT_PrimarySearchFirstFlag == FLAG_FALSE) {
        if (TEXTDISP_SelectGroupAndEntry(
                text + split + SECONDARY_TEXT_STEP,
                TEXTDISP_SecondarySearchText,
                (LONG)TEXTDISP_SecondaryChannelCode) == FLAG_TRUE) {
            SCRIPT_PlaybackCursor = CURSOR_SECONDARY_MATCH;
            return ok;
        }
    }

    if (TEXTDISP_SelectGroupAndEntry(
            text + PRIMARY_TEXT_OFFSET,
            TEXTDISP_PrimarySearchText,
            (LONG)TEXTDISP_PrimaryChannelCode) == FLAG_TRUE) {
        SCRIPT_PlaybackCursor = CURSOR_PRIMARY_MATCH;
        return ok;
    }

    if (SCRIPT_PrimarySearchFirstFlag != FLAG_FALSE) {
        if (TEXTDISP_SelectGroupAndEntry(
                text + split + SECONDARY_TEXT_STEP,
                TEXTDISP_SecondarySearchText,
                (LONG)TEXTDISP_SecondaryChannelCode) == FLAG_TRUE) {
            SCRIPT_PlaybackCursor = CURSOR_SECONDARY_MATCH;
            return ok;
        }
    }

    ok = FLAG_FALSE;
    SCRIPT_ChannelRangeArmedFlag = FLAG_FALSE;
    SCRIPT_PlaybackCursor = CURSOR_FALLBACK;
    return ok;
}
