typedef signed long LONG;
typedef unsigned long ULONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

enum {
    TEXTDISP_NULL = 0,
    MODE_KIND_PRIMARY = 1,
    MODE_KIND_SECONDARY = 2,
    CHANNEL_CODE_DEFAULT = 48,
    CHANNEL_RANGE_A_MIN = 48,
    CHANNEL_RANGE_A_MAX = 67,
    CHANNEL_RANGE_B_MIN = 72,
    CHANNEL_RANGE_B_MAX = 77,
    STATUS_LINE_BUFFER_LEN = 137,
    STATUS_SCRATCH_BUFFER_LEN = 188,
    ENTRY_INDEX_MIN = 0,
    ENTRY_INDEX_MAX_EXCLUSIVE = 49,
    MINUTES_PER_DAY = 1440,
    BANNER_SELECTED_SENTINEL = 100,
    BANNER_KIND_NOW_SHOWING = 1
};

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
    char line[STATUS_LINE_BUFFER_LEN];
    char scratch[STATUS_SCRATCH_BUFFER_LEN];
    char *title;
    char *timeToken;

    idx = (LONG)groupIndex;
    modeKind = modeFlag ? MODE_KIND_PRIMARY : MODE_KIND_SECONDARY;
    aux = TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(idx, modeKind);
    entry = (UBYTE *)TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(idx, modeKind);

    line[0] = TEXTDISP_NULL;
    timeToken = (char *)TEXTDISP_NULL;
    bannerKind = BANNER_KIND_NOW_SHOWING;

    if (entry != (UBYTE *)TEXTDISP_NULL && aux != (void *)TEXTDISP_NULL) {
        if (TEXTDISP_PrimaryChannelCode == TEXTDISP_NULL) {
            TEXTDISP_PrimaryChannelCode = CHANNEL_CODE_DEFAULT;
        }

        channelEnabled = TEXTDISP_NULL;
        if ((TEXTDISP_PrimaryChannelCode >= CHANNEL_RANGE_A_MIN &&
             TEXTDISP_PrimaryChannelCode <= CHANNEL_RANGE_A_MAX) ||
            (TEXTDISP_PrimaryChannelCode >= CHANNEL_RANGE_B_MIN &&
             TEXTDISP_PrimaryChannelCode <= CHANNEL_RANGE_B_MAX)) {
            ULONG mask;
            ULONG value;
            LONG day;

            day = (LONG)CLOCK_CurrentDayOfWeekIndex;
            mask = ((ULONG)1U) << day;
            value = (ULONG)Global_STR_TEXTDISP_C_3[(LONG)TEXTDISP_PrimaryChannelCode];
            if ((value & mask) != TEXTDISP_NULL) {
                channelEnabled = MODE_KIND_PRIMARY;
            }
        }

        if (channelEnabled != TEXTDISP_NULL && entryIndex > ENTRY_INDEX_MIN && entryIndex < ENTRY_INDEX_MAX_EXCLUSIVE &&
            TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow(
                entry,
                aux,
                (LONG)entryIndex,
                MINUTES_PER_DAY,
                CONFIG_TimeWindowMinutes) != TEXTDISP_NULL) {
            if ((LONG)TEXTDISP_BannerCharSelected == BANNER_SELECTED_SENTINEL) {
                bannerDigit = (LONG)TEXTDISP_BannerFallbackIsSpecialFlag;
            } else {
                bannerDigit = (LONG)TEXTDISP_BannerSelectedIsSpecialFlag;
            }

            bannerKind = bannerDigit;
            if ((bannerKind - BANNER_KIND_NOW_SHOWING) == TEXTDISP_NULL) {
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
            if ((TEXTDISP_PrimaryChannelCode > CHANNEL_RANGE_A_MIN &&
                 TEXTDISP_PrimaryChannelCode <= CHANNEL_RANGE_A_MAX) ||
                (TEXTDISP_PrimaryChannelCode >= CHANNEL_RANGE_B_MIN &&
                 TEXTDISP_PrimaryChannelCode <= CHANNEL_RANGE_B_MAX)) {
                STRING_AppendAtNull(line, SCRIPT_AlignedPrefixEmptyB);
                STRING_AppendAtNull(line, SCRIPT_StrChannelLabel_TuesdaysFridays[(LONG)TEXTDISP_PrimaryChannelCode]);
                timeToken = TEXTDISP_FindControlToken(TEXTDISP_PrimarySearchText);
            }
        }

        if (bannerKind == TEXTDISP_NULL) {
            out = TEXTDISP_NULL;
            for (i = TEXTDISP_NULL; entry[i + 1] != TEXTDISP_NULL; i++) {
                if (entry[i + 1] != ' ') {
                    scratch[out++] = (char)entry[i + 1];
                }
            }
            scratch[out] = TEXTDISP_NULL;

            if (scratch[0] != TEXTDISP_NULL) {
                if (line[0] != TEXTDISP_NULL) {
                    STRING_AppendAtNull(line, SCRIPT_SpacerTripleA);
                }
                STRING_AppendAtNull(line, SCRIPT_AlignedChannelAbbrevPrefix);
                STRING_AppendAtNull(line, scratch);
            }
        }

        if (timeToken != (char *)TEXTDISP_NULL) {
            if (line[0] != TEXTDISP_NULL) {
                STRING_AppendAtNull(line, SCRIPT_SpacerTripleB);
            }
            WDISP_SPrintf(scratch, SCRIPT_AlignedCharFormat, (LONG)(UBYTE)timeToken[0]);
            STRING_AppendAtNull(line, scratch);
        }

        TEXTDISP_JMPTBL_CLEANUP_BuildAlignedStatusLine(
            line,
            (LONG)modeFlag,
            (LONG)groupIndex,
            (LONG)entryIndex,
            TEXTDISP_NULL,
            TEXTDISP_NULL);
    } else {
        if (P_TYPE_WeatherBottomLineMsgPtr != (const char *)TEXTDISP_NULL &&
            P_TYPE_WeatherBottomLineMsgPtr[0] != TEXTDISP_NULL) {
            STRING_AppendAtNull(line, SCRIPT_AlignedPrefixEmptyC);
            STRING_AppendAtNull(line, P_TYPE_WeatherBottomLineMsgPtr);
        } else {
            line[0] = TEXTDISP_NULL;
        }
    }

    SCRIPT_SetupHighlightEffect(line);
}
