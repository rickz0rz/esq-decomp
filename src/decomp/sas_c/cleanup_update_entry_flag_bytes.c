typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef long LONG;

#define ENTRY_MODE_FLAGS 7
#define ENTRY_FLAGS_HEX_PRIMARY_INDEX 6
#define ENTRY_FLAGS_HEX_SECONDARY_INDEX 7
#define CHARCLASS_HEX_MASK 0x80
#define INSET_NIBBLE_INVALID 0xFF
#define LOCAL_FALLBACK_COPY_OFFSET 1

extern const char CLOCK_STR_FALLBACK_ENTRY_FLAGS_PRIMARY[];
extern const UBYTE WDISP_CharClassTable[];
extern UBYTE DISPTEXT_InsetNibblePrimary;
extern UBYTE DISPTEXT_InsetNibbleSecondary;

const char *COI_GetAnimFieldPointerByMode(const void *entry, LONG slot, LONG mode);
LONG GROUP_AE_JMPTBL_LADFUNC_ParseHexDigit(LONG c);

void CLEANUP_UpdateEntryFlagBytes(void *entry, UWORD slot)
{
    UBYTE local[16];
    const char *flagText;
    LONG parsedNibble;

    flagText = COI_GetAnimFieldPointerByMode(entry, (LONG)slot, ENTRY_MODE_FLAGS);
    if (flagText == 0) {
        const char *s = CLOCK_STR_FALLBACK_ENTRY_FLAGS_PRIMARY;
        UBYTE *d = &local[LOCAL_FALLBACK_COPY_OFFSET];
        do {
            *d = (UBYTE)*s;
            d++;
            s++;
        } while (d[-1] != 0);
        flagText = (const char *)&local[LOCAL_FALLBACK_COPY_OFFSET];
    }

    if ((WDISP_CharClassTable[(UBYTE)flagText[ENTRY_FLAGS_HEX_PRIMARY_INDEX]] & CHARCLASS_HEX_MASK) != 0) {
        parsedNibble = GROUP_AE_JMPTBL_LADFUNC_ParseHexDigit((LONG)(UBYTE)flagText[ENTRY_FLAGS_HEX_PRIMARY_INDEX]);
        DISPTEXT_InsetNibblePrimary = (UBYTE)parsedNibble;
    } else {
        DISPTEXT_InsetNibblePrimary = INSET_NIBBLE_INVALID;
    }

    if ((WDISP_CharClassTable[(UBYTE)flagText[ENTRY_FLAGS_HEX_SECONDARY_INDEX]] & CHARCLASS_HEX_MASK) != 0) {
        parsedNibble = GROUP_AE_JMPTBL_LADFUNC_ParseHexDigit((LONG)(UBYTE)flagText[ENTRY_FLAGS_HEX_SECONDARY_INDEX]);
        DISPTEXT_InsetNibbleSecondary = (UBYTE)parsedNibble;
    } else {
        DISPTEXT_InsetNibbleSecondary = INSET_NIBBLE_INVALID;
    }
}
