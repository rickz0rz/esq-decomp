typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef short WORD;
typedef long LONG;

enum {
    ALIGNED_STATUS_WRAP_PREFIX_WIDTH = 19,
    ALIGNED_STATUS_WRAP_SUFFIX_WIDTH = 20,
    ALIGNED_STATUS_FIELD_TEXT6 = 6,
    ALIGNED_STATUS_FIELD_TEXT7 = 7,
    CHARCLASS_HEX_DIGIT_MASK = 0x80,
    ALIGNED_INSET_NIBBLE_INVALID = 0xFF
};

extern const UBYTE CLOCK_FMT_WRAP_CHAR_STRING_CHAR[];
extern const UBYTE TEXTDISP_CenterAlignToken[];
extern const UBYTE CLOCK_STR_DOUBLE_SPACE[];
extern const UBYTE CLOCK_STR_FALLBACK_ENTRY_FLAGS_SECONDARY[];
extern const UBYTE WDISP_CharClassTable[];
extern UBYTE CLEANUP_AlignedInsetNibblePrimary;
extern UBYTE CLEANUP_AlignedInsetNibbleSecondary;
extern UBYTE CLOCK_AlignedInsetRenderGateFlag;

LONG GROUP_AE_JMPTBL_ESQDISP_GetEntryPointerByMode(LONG slot, LONG mode);
LONG CLEANUP_TestEntryFlagYAndBit1(void *entry, LONG slot, LONG mode);
LONG COI_GetAnimFieldPointerByMode(void *entry, LONG slot, LONG mode);
LONG GROUP_AE_JMPTBL_WDISP_SPrintf(UBYTE *out, const UBYTE *fmt, LONG a, LONG b, LONG c);
LONG GROUP_AI_JMPTBL_STRING_AppendAtNull(UBYTE *dst, const UBYTE *src);
LONG GROUP_AE_JMPTBL_LADFUNC_ParseHexDigit(LONG c);

void CLEANUP_BuildAlignedStatusLine(UBYTE *out, UWORD isPrimary, UWORD modeSel, UWORD slot, LONG alignToken)
{
    void *entry;
    UBYTE wrap[12];
    UBYTE *text6;
    UBYTE *text7;

    entry = (void *)GROUP_AE_JMPTBL_ESQDISP_GetEntryPointerByMode((LONG)modeSel, isPrimary ? 1 : 2);
    if (CLEANUP_TestEntryFlagYAndBit1(entry, (LONG)slot, alignToken) != 0) {
        text6 = (UBYTE *)COI_GetAnimFieldPointerByMode(entry, (LONG)slot, ALIGNED_STATUS_FIELD_TEXT6);
    } else {
        text6 = (UBYTE *)0;
    }

    if (text6 == (UBYTE *)0) {
        CLOCK_AlignedInsetRenderGateFlag = 0;
        return;
    }

    GROUP_AE_JMPTBL_WDISP_SPrintf(
        wrap,
        CLOCK_FMT_WRAP_CHAR_STRING_CHAR,
        ALIGNED_STATUS_WRAP_PREFIX_WIDTH,
        (LONG)text6,
        ALIGNED_STATUS_WRAP_SUFFIX_WIDTH
    );
    if (alignToken != 0) {
        GROUP_AI_JMPTBL_STRING_AppendAtNull(out, TEXTDISP_CenterAlignToken);
    } else {
        GROUP_AI_JMPTBL_STRING_AppendAtNull(out, CLOCK_STR_DOUBLE_SPACE);
    }
    GROUP_AI_JMPTBL_STRING_AppendAtNull(out, wrap);

    text7 = (UBYTE *)COI_GetAnimFieldPointerByMode(entry, (LONG)slot, ALIGNED_STATUS_FIELD_TEXT7);
    if (text7 == (UBYTE *)0) {
        text7 = (UBYTE *)CLOCK_STR_FALLBACK_ENTRY_FLAGS_SECONDARY;
    }

    if ((WDISP_CharClassTable[text7[ALIGNED_STATUS_FIELD_TEXT6]] & CHARCLASS_HEX_DIGIT_MASK) != 0) {
        CLEANUP_AlignedInsetNibblePrimary =
            (UBYTE)GROUP_AE_JMPTBL_LADFUNC_ParseHexDigit((LONG)text7[ALIGNED_STATUS_FIELD_TEXT6]);
    } else {
        CLEANUP_AlignedInsetNibblePrimary = ALIGNED_INSET_NIBBLE_INVALID;
    }

    if ((WDISP_CharClassTable[text7[ALIGNED_STATUS_FIELD_TEXT7]] & CHARCLASS_HEX_DIGIT_MASK) != 0) {
        CLEANUP_AlignedInsetNibbleSecondary =
            (UBYTE)GROUP_AE_JMPTBL_LADFUNC_ParseHexDigit((LONG)text7[ALIGNED_STATUS_FIELD_TEXT7]);
    } else {
        CLEANUP_AlignedInsetNibbleSecondary = ALIGNED_INSET_NIBBLE_INVALID;
    }

    CLOCK_AlignedInsetRenderGateFlag = 1;
}
