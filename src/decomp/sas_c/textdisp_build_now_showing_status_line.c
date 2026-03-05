typedef signed long LONG;
typedef unsigned long ULONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern UWORD TEXTDISP_PrimaryChannelCode;
extern UWORD CLOCK_CurrentDayOfWeekIndex;
extern LONG CONFIG_TimeWindowMinutes;
extern UBYTE TEXTDISP_BannerCharSelected;
extern UBYTE TEXTDISP_BannerSelectedIsSpecialFlag;
extern UBYTE TEXTDISP_BannerFallbackIsSpecialFlag;
extern const UBYTE Global_STR_TEXTDISP_C_3[];
extern const char Global_STR_ALIGNED_NOW_SHOWING[];
extern const char SCRIPT_AlignedPrefixEmptyA[];
extern const char SCRIPT_AlignedPrefixEmptyB[];
extern const char SCRIPT_AlignedPrefixEmptyC[];
extern const char SCRIPT_AlignedChannelAbbrevPrefix[];
extern const char SCRIPT_SpacerTripleA[];
extern const char SCRIPT_SpacerTripleB[];
extern const char SCRIPT_AlignedCharFormat[];
extern const char *SCRIPT_StrChannelLabel_TuesdaysFridays[];
extern const char *TEXTDISP_PrimarySearchText;
extern const char *P_TYPE_WeatherBottomLineMsgPtr;

extern void *TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(LONG index, LONG mode);
extern void *TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(LONG index, LONG mode);
extern LONG TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow(void *entry, void *aux, LONG index, LONG window, LONG minutes);
extern void TEXTDISP_FormatEntryTimeForIndex(char *dst, LONG index, void *aux);
extern char *STR_SkipClass3Chars(char *src);
extern void STRING_AppendAtNull(char *dst, const char *src);
extern char *TEXTDISP_FindControlToken(const char *src);
extern void WDISP_SPrintf(char *dst, const char *fmt, LONG value);
extern void TEXTDISP_JMPTBL_CLEANUP_BuildAlignedStatusLine(char *line, LONG mode, LONG groupIndex, LONG entryIndex, LONG a, LONG b);
extern void SCRIPT_SetupHighlightEffect(char *line);

void TEXTDISP_BuildNowShowingStatusLine(UWORD modeFlag, UWORD groupIndex, UWORD entryIndex)
{
    void *aux;
    UBYTE *entry;
    LONG modeKind;
    LONG channelEnabled;
    LONG bannerKind;
    LONG bannerDigit;
    LONG idx;
    ULONG *titleTable;
    LONG i;
    LONG out;
    char line[137];
    char scratch[188];
    char *title;
    char *timeToken;

    idx = (LONG)groupIndex;
    modeKind = modeFlag ? 1 : 2;
    aux = TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(idx, modeKind);
    entry = (UBYTE *)TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(idx, modeKind);

    line[0] = 0;
    timeToken = (char *)0;
    bannerKind = 1;

    if (entry != (UBYTE *)0 && aux != (void *)0) {
        if (TEXTDISP_PrimaryChannelCode == 0) {
            TEXTDISP_PrimaryChannelCode = 48;
        }

        channelEnabled = 0;
        if ((TEXTDISP_PrimaryChannelCode >= 48 && TEXTDISP_PrimaryChannelCode <= 67) ||
            (TEXTDISP_PrimaryChannelCode >= 72 && TEXTDISP_PrimaryChannelCode <= 77)) {
            ULONG mask;
            ULONG value;
            LONG day;

            day = (LONG)CLOCK_CurrentDayOfWeekIndex;
            mask = ((ULONG)1U) << day;
            value = (ULONG)Global_STR_TEXTDISP_C_3[(LONG)TEXTDISP_PrimaryChannelCode];
            if ((value & mask) != 0) {
                channelEnabled = 1;
            }
        }

        if (channelEnabled != 0 && entryIndex > 0 && entryIndex < 49 &&
            TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow(entry, aux, (LONG)entryIndex, 1440, CONFIG_TimeWindowMinutes) != 0) {
            if ((LONG)TEXTDISP_BannerCharSelected == 100) {
                bannerDigit = (LONG)TEXTDISP_BannerFallbackIsSpecialFlag;
            } else {
                bannerDigit = (LONG)TEXTDISP_BannerSelectedIsSpecialFlag;
            }

            bannerKind = bannerDigit;
            if ((bannerKind - 1) == 0) {
                title = (char *)Global_STR_ALIGNED_NOW_SHOWING;
            } else {
                TEXTDISP_FormatEntryTimeForIndex(scratch, (LONG)entryIndex, aux);
                title = STR_SkipClass3Chars(scratch);
            }

            STRING_AppendAtNull(line, SCRIPT_AlignedPrefixEmptyA);
            STRING_AppendAtNull(line, title);

            titleTable = (ULONG *)((UBYTE *)aux + 56);
            timeToken = TEXTDISP_FindControlToken((const char *)titleTable[(LONG)entryIndex]);
        } else {
            if ((TEXTDISP_PrimaryChannelCode > 48 && TEXTDISP_PrimaryChannelCode <= 67) ||
                (TEXTDISP_PrimaryChannelCode >= 72 && TEXTDISP_PrimaryChannelCode <= 77)) {
                STRING_AppendAtNull(line, SCRIPT_AlignedPrefixEmptyB);
                STRING_AppendAtNull(line, SCRIPT_StrChannelLabel_TuesdaysFridays[(LONG)TEXTDISP_PrimaryChannelCode]);
                timeToken = TEXTDISP_FindControlToken(TEXTDISP_PrimarySearchText);
            }
        }

        if (bannerKind == 0) {
            out = 0;
            for (i = 0; entry[i + 1] != 0; i++) {
                if (entry[i + 1] != ' ') {
                    scratch[out++] = (char)entry[i + 1];
                }
            }
            scratch[out] = 0;

            if (scratch[0] != 0) {
                if (line[0] != 0) {
                    STRING_AppendAtNull(line, SCRIPT_SpacerTripleA);
                }
                STRING_AppendAtNull(line, SCRIPT_AlignedChannelAbbrevPrefix);
                STRING_AppendAtNull(line, scratch);
            }
        }

        if (timeToken != (char *)0) {
            if (line[0] != 0) {
                STRING_AppendAtNull(line, SCRIPT_SpacerTripleB);
            }
            WDISP_SPrintf(scratch, SCRIPT_AlignedCharFormat, (LONG)(UBYTE)timeToken[0]);
            STRING_AppendAtNull(line, scratch);
        }

        TEXTDISP_JMPTBL_CLEANUP_BuildAlignedStatusLine(line, (LONG)modeFlag, (LONG)groupIndex, (LONG)entryIndex, 0, 0);
    } else {
        if (P_TYPE_WeatherBottomLineMsgPtr != (const char *)0 && P_TYPE_WeatherBottomLineMsgPtr[0] != 0) {
            STRING_AppendAtNull(line, SCRIPT_AlignedPrefixEmptyC);
            STRING_AppendAtNull(line, P_TYPE_WeatherBottomLineMsgPtr);
        } else {
            line[0] = 0;
        }
    }

    SCRIPT_SetupHighlightEffect(line);
}
