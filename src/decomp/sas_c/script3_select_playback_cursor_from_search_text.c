typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern LONG SCRIPT_SearchMatchCountOrIndex;
extern UWORD SCRIPT_ChannelRangeArmedFlag;
extern UWORD SCRIPT_PrimarySearchFirstFlag;
extern UWORD TEXTDISP_SecondaryChannelCode;
extern UBYTE TEXTDISP_SecondarySearchText;
extern UWORD TEXTDISP_PrimaryChannelCode;
extern UBYTE TEXTDISP_PrimarySearchText;
extern LONG SCRIPT_PlaybackCursor;

extern LONG TEXTDISP_SelectGroupAndEntry(char *arg, char *searchText, LONG channelCode);

LONG SCRIPT_SelectPlaybackCursorFromSearchText(LONG matchIndex, char *text)
{
    LONG ok;
    UWORD split;

    ok = 1;
    SCRIPT_SearchMatchCountOrIndex = matchIndex;
    SCRIPT_ChannelRangeArmedFlag = 1;

    split = 3;
    while (text[split] != 18 && split < 30) {
        split++;
    }
    text[split] = 0;

    if (SCRIPT_PrimarySearchFirstFlag == 0) {
        if (TEXTDISP_SelectGroupAndEntry(text + split + 1, (char *)&TEXTDISP_SecondarySearchText, (LONG)TEXTDISP_SecondaryChannelCode) == 1) {
            SCRIPT_PlaybackCursor = 7;
            return ok;
        }
    }

    if (TEXTDISP_SelectGroupAndEntry(text + 2, (char *)&TEXTDISP_PrimarySearchText, (LONG)TEXTDISP_PrimaryChannelCode) == 1) {
        SCRIPT_PlaybackCursor = 6;
        return ok;
    }

    if (SCRIPT_PrimarySearchFirstFlag != 0) {
        if (TEXTDISP_SelectGroupAndEntry(text + split + 1, (char *)&TEXTDISP_SecondarySearchText, (LONG)TEXTDISP_SecondaryChannelCode) == 1) {
            SCRIPT_PlaybackCursor = 7;
            return ok;
        }
    }

    ok = 0;
    SCRIPT_ChannelRangeArmedFlag = 0;
    SCRIPT_PlaybackCursor = 1;
    return ok;
}
