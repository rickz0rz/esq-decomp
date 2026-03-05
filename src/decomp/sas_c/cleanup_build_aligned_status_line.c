typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef short WORD;
typedef long LONG;

extern UBYTE CLOCK_FMT_WRAP_CHAR_STRING_CHAR[];
extern UBYTE TEXTDISP_CenterAlignToken[];
extern UBYTE CLOCK_STR_DOUBLE_SPACE[];
extern UBYTE CLOCK_STR_FALLBACK_ENTRY_FLAGS_SECONDARY[];
extern UBYTE WDISP_CharClassTable[];
extern UBYTE CLEANUP_AlignedInsetNibblePrimary;
extern UBYTE CLEANUP_AlignedInsetNibbleSecondary;
extern UBYTE CLOCK_AlignedInsetRenderGateFlag;

LONG GROUP_AE_JMPTBL_ESQDISP_GetEntryPointerByMode(LONG slot, LONG mode);
LONG CLEANUP_TestEntryFlagYAndBit1(void *entry, LONG slot, LONG mode);
LONG COI_GetAnimFieldPointerByMode(void *entry, LONG slot, LONG mode);
LONG GROUP_AE_JMPTBL_WDISP_SPrintf(UBYTE *out, const UBYTE *fmt, LONG a, LONG b, LONG c);
LONG GROUP_AI_JMPTBL_STRING_AppendAtNull(UBYTE *dst, const UBYTE *src);
LONG GROUP_AE_JMPTBL_LADFUNC_ParseHexDigit(LONG c);

void CLEANUP_BuildAlignedStatusLine(UBYTE *out, UWORD is_primary, UWORD mode_sel, UWORD slot, LONG align_token)
{
    void *entry;
    UBYTE wrap[12];
    UBYTE *text6;
    UBYTE *text7;

    entry = (void *)GROUP_AE_JMPTBL_ESQDISP_GetEntryPointerByMode((LONG)mode_sel, is_primary ? 1 : 2);
    if (CLEANUP_TestEntryFlagYAndBit1(entry, (LONG)slot, align_token) != 0) {
        text6 = (UBYTE *)COI_GetAnimFieldPointerByMode(entry, (LONG)slot, 6);
    } else {
        text6 = (UBYTE *)0;
    }

    if (text6 == (UBYTE *)0) {
        CLOCK_AlignedInsetRenderGateFlag = 0;
        return;
    }

    GROUP_AE_JMPTBL_WDISP_SPrintf(wrap, CLOCK_FMT_WRAP_CHAR_STRING_CHAR, 19, (LONG)text6, 20);
    if (align_token != 0) {
        GROUP_AI_JMPTBL_STRING_AppendAtNull(out, TEXTDISP_CenterAlignToken);
    } else {
        GROUP_AI_JMPTBL_STRING_AppendAtNull(out, CLOCK_STR_DOUBLE_SPACE);
    }
    GROUP_AI_JMPTBL_STRING_AppendAtNull(out, wrap);

    text7 = (UBYTE *)COI_GetAnimFieldPointerByMode(entry, (LONG)slot, 7);
    if (text7 == (UBYTE *)0) {
        text7 = CLOCK_STR_FALLBACK_ENTRY_FLAGS_SECONDARY;
    }

    if ((WDISP_CharClassTable[text7[6]] & 0x80) != 0) {
        CLEANUP_AlignedInsetNibblePrimary = (UBYTE)GROUP_AE_JMPTBL_LADFUNC_ParseHexDigit((LONG)text7[6]);
    } else {
        CLEANUP_AlignedInsetNibblePrimary = 0xFF;
    }

    if ((WDISP_CharClassTable[text7[7]] & 0x80) != 0) {
        CLEANUP_AlignedInsetNibbleSecondary = (UBYTE)GROUP_AE_JMPTBL_LADFUNC_ParseHexDigit((LONG)text7[7]);
    } else {
        CLEANUP_AlignedInsetNibbleSecondary = 0xFF;
    }

    CLOCK_AlignedInsetRenderGateFlag = 1;
}
