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

extern LONG TEXTDISP_FindEntryMatchIndex(UBYTE *searchText, LONG mode, LONG flags);

void TEXTDISP_UpdateChannelRangeFlags(void)
{
    UBYTE *searchText;
    WORD channel;

    if ((WORD)(TEXTDISP_ChannelSourceMode - 1) == 0) {
        searchText = TEXTDISP_PrimarySearchText;
        channel = TEXTDISP_PrimaryChannelCode;
    } else {
        searchText = TEXTDISP_SecondarySearchText;
        channel = TEXTDISP_SecondaryChannelCode;
    }

    if (channel == 0) {
        channel = 48;
    }

    if (!((channel >= 48 && channel <= 67) || (channel >= 72 && channel <= 77))) {
        TEXTDISP_BannerCharSelected = 0x64;
        TEXTDISP_BannerCharFallback = 0x31;
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
            TEXTDISP_BannerCharSelected = 0x64;
            TEXTDISP_BannerCharFallback = 0x31;
            return;
        }
    }

    TEXTDISP_BannerCharFallback = (UBYTE)TEXTDISP_FindEntryMatchIndex(searchText, 1, 0);
}
