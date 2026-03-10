typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef short WORD;
typedef long LONG;

enum {
    ALIGNED_STATUS_MODE_PRIMARY = 1,
    ALIGNED_STATUS_MODE_SECONDARY = 2,
    ALIGNED_STATUS_WRAP_PREFIX_WIDTH = 19,
    ALIGNED_STATUS_WRAP_SUFFIX_WIDTH = 20,
    ALIGNED_STATUS_FIELD_TEXT6 = 6,
    ALIGNED_STATUS_FIELD_TEXT7 = 7,
    CHARCLASS_HEX_DIGIT_MASK = 0x80,
    ALIGNED_INSET_NIBBLE_INVALID = 0xFF
};

extern const char CLOCK_FMT_WRAP_CHAR_STRING_CHAR[];
extern const char TEXTDISP_CenterAlignToken[];
extern const char CLOCK_STR_DOUBLE_SPACE[];
extern const char CLOCK_STR_FALLBACK_ENTRY_FLAGS_SECONDARY[];
extern const UBYTE WDISP_CharClassTable[];
extern UBYTE CLEANUP_AlignedInsetNibblePrimary;
extern UBYTE CLEANUP_AlignedInsetNibbleSecondary;
extern UBYTE CLOCK_AlignedInsetRenderGateFlag;

const char *GROUP_AE_JMPTBL_ESQDISP_GetEntryPointerByMode(LONG slot, LONG mode);
LONG CLEANUP_TestEntryFlagYAndBit1(void *entry, LONG slot, LONG mode);
LONG COI_GetAnimFieldPointerByMode(const void *entry, LONG slot, LONG mode);
LONG GROUP_AE_JMPTBL_WDISP_SPrintf(char *out, const char *fmt, LONG a, LONG b, LONG c);
char *GROUP_AI_JMPTBL_STRING_AppendAtNull(char *dst, const char *src);
LONG GROUP_AE_JMPTBL_LADFUNC_ParseHexDigit(LONG c);

void CLEANUP_BuildAlignedStatusLine(char *out, UWORD isPrimary, UWORD modeSel, UWORD slot, LONG alignToken)
{
    const char *entry;
    char wrappedText[12];
    const char *fieldText6;
    const char *fieldText7;

    entry = GROUP_AE_JMPTBL_ESQDISP_GetEntryPointerByMode(
        (LONG)modeSel,
        isPrimary ? ALIGNED_STATUS_MODE_PRIMARY : ALIGNED_STATUS_MODE_SECONDARY
    );
    if (CLEANUP_TestEntryFlagYAndBit1((void *)entry, (LONG)slot, alignToken) != 0) {
        fieldText6 = (const char *)COI_GetAnimFieldPointerByMode(entry, (LONG)slot, ALIGNED_STATUS_FIELD_TEXT6);
    } else {
        fieldText6 = (const char *)0;
    }

    if (fieldText6 == (const char *)0) {
        CLOCK_AlignedInsetRenderGateFlag = 0;
        return;
    }

    GROUP_AE_JMPTBL_WDISP_SPrintf(
        wrappedText,
        CLOCK_FMT_WRAP_CHAR_STRING_CHAR,
        ALIGNED_STATUS_WRAP_PREFIX_WIDTH,
        (LONG)fieldText6,
        ALIGNED_STATUS_WRAP_SUFFIX_WIDTH
    );
    if (alignToken != 0) {
        GROUP_AI_JMPTBL_STRING_AppendAtNull(out, TEXTDISP_CenterAlignToken);
    } else {
        GROUP_AI_JMPTBL_STRING_AppendAtNull(out, CLOCK_STR_DOUBLE_SPACE);
    }
    GROUP_AI_JMPTBL_STRING_AppendAtNull(out, wrappedText);

    fieldText7 = (const char *)COI_GetAnimFieldPointerByMode(entry, (LONG)slot, ALIGNED_STATUS_FIELD_TEXT7);
    if (fieldText7 == (const char *)0) {
        fieldText7 = CLOCK_STR_FALLBACK_ENTRY_FLAGS_SECONDARY;
    }

    if ((WDISP_CharClassTable[fieldText7[ALIGNED_STATUS_FIELD_TEXT6]] & CHARCLASS_HEX_DIGIT_MASK) != 0) {
        CLEANUP_AlignedInsetNibblePrimary =
            (UBYTE)GROUP_AE_JMPTBL_LADFUNC_ParseHexDigit((LONG)fieldText7[ALIGNED_STATUS_FIELD_TEXT6]);
    } else {
        CLEANUP_AlignedInsetNibblePrimary = ALIGNED_INSET_NIBBLE_INVALID;
    }

    if ((WDISP_CharClassTable[fieldText7[ALIGNED_STATUS_FIELD_TEXT7]] & CHARCLASS_HEX_DIGIT_MASK) != 0) {
        CLEANUP_AlignedInsetNibbleSecondary =
            (UBYTE)GROUP_AE_JMPTBL_LADFUNC_ParseHexDigit((LONG)fieldText7[ALIGNED_STATUS_FIELD_TEXT7]);
    } else {
        CLEANUP_AlignedInsetNibbleSecondary = ALIGNED_INSET_NIBBLE_INVALID;
    }

    CLOCK_AlignedInsetRenderGateFlag = 1;
}
