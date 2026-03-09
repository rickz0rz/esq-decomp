typedef signed long LONG;
typedef unsigned long ULONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern WORD TEXTDISP_ChannelSourceMode;
extern UBYTE TEXTDISP_PrimarySearchText[];
extern UBYTE TEXTDISP_SecondarySearchText[];
extern WORD TEXTDISP_PrimaryChannelCode;
extern WORD TEXTDISP_SecondaryChannelCode;
extern WORD CLOCK_CurrentDayOfWeekIndex;
extern UBYTE Global_STR_TEXTDISP_C_3[];
extern UBYTE TEXTDISP_BannerCharSelected;
extern UBYTE TEXTDISP_BannerCharFallback;

extern LONG TEXTDISP_FindEntryMatchIndex(char *searchText, LONG mode, LONG flags);

void TEXTDISP_UpdateChannelRangeFlags(void)
{
    const WORD SOURCE_PRIMARY = 1;
    const WORD CHANNEL_DEFAULT = 48;
    const WORD CHANNEL_RANGE_A_MIN = 48;
    const WORD CHANNEL_RANGE_A_MAX = 67;
    const WORD CHANNEL_RANGE_B_MIN = 72;
    const WORD CHANNEL_RANGE_B_MAX = 77;
    const UBYTE BANNER_CHAR_INVALID = 0x64;
    const UBYTE BANNER_CHAR_FALLBACK = 0x31;
    const LONG MATCH_MODE_PRIMARY = 1;
    const LONG MATCH_FLAGS_NONE = 0;
    char *searchText;
    WORD channel;

    if ((WORD)(TEXTDISP_ChannelSourceMode - SOURCE_PRIMARY) == 0) {
        searchText = TEXTDISP_PrimarySearchText;
        channel = TEXTDISP_PrimaryChannelCode;
    } else {
        searchText = TEXTDISP_SecondarySearchText;
        channel = TEXTDISP_SecondaryChannelCode;
    }

    if (channel == 0) {
        channel = CHANNEL_DEFAULT;
    }

    if (!((channel >= CHANNEL_RANGE_A_MIN && channel <= CHANNEL_RANGE_A_MAX) ||
          (channel >= CHANNEL_RANGE_B_MIN && channel <= CHANNEL_RANGE_B_MAX))) {
        TEXTDISP_BannerCharSelected = BANNER_CHAR_INVALID;
        TEXTDISP_BannerCharFallback = BANNER_CHAR_FALLBACK;
        return;
    }

    {
        ULONG mask;
        ULONG weekday;
        ULONG enabled;

        weekday = (ULONG)(WORD)CLOCK_CurrentDayOfWeekIndex;
        mask = 1UL << weekday;
        enabled = (ULONG)Global_STR_TEXTDISP_C_3[(UBYTE)channel] & mask;
        if (enabled == 0) {
            TEXTDISP_BannerCharSelected = BANNER_CHAR_INVALID;
            TEXTDISP_BannerCharFallback = BANNER_CHAR_FALLBACK;
            return;
        }
    }

    TEXTDISP_BannerCharFallback =
        (UBYTE)TEXTDISP_FindEntryMatchIndex(searchText, MATCH_MODE_PRIMARY, MATCH_FLAGS_NONE);
}
