typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef long LONG;

enum {
    ENTRY_MODE_FLAGS = 7,
    ENTRY_FLAGS_HEX_PRIMARY_INDEX = 6,
    ENTRY_FLAGS_HEX_SECONDARY_INDEX = 7,
    CHARCLASS_HEX_MASK = 0x80,
    INSET_NIBBLE_INVALID = 0xFF,
    LOCAL_FALLBACK_COPY_OFFSET = 1
};

extern UBYTE CLOCK_STR_FALLBACK_ENTRY_FLAGS_PRIMARY[];
extern UBYTE WDISP_CharClassTable[];
extern UBYTE DISPTEXT_InsetNibblePrimary;
extern UBYTE DISPTEXT_InsetNibbleSecondary;

LONG COI_GetAnimFieldPointerByMode(void *entry, LONG slot, LONG mode);
LONG GROUP_AE_JMPTBL_LADFUNC_ParseHexDigit(LONG c);

void CLEANUP_UpdateEntryFlagBytes(void *entry, UWORD slot)
{
    UBYTE local[16];
    UBYTE *p;
    LONG v;

    p = (UBYTE *)COI_GetAnimFieldPointerByMode(entry, (LONG)slot, ENTRY_MODE_FLAGS);
    if (p == (UBYTE *)0) {
        UBYTE *s = CLOCK_STR_FALLBACK_ENTRY_FLAGS_PRIMARY;
        UBYTE *d = &local[LOCAL_FALLBACK_COPY_OFFSET];
        do {
            *d = *s;
            d++;
            s++;
        } while (d[-1] != 0);
        p = &local[LOCAL_FALLBACK_COPY_OFFSET];
    }

    if ((WDISP_CharClassTable[p[ENTRY_FLAGS_HEX_PRIMARY_INDEX]] & CHARCLASS_HEX_MASK) != 0) {
        v = GROUP_AE_JMPTBL_LADFUNC_ParseHexDigit((LONG)p[ENTRY_FLAGS_HEX_PRIMARY_INDEX]);
        DISPTEXT_InsetNibblePrimary = (UBYTE)v;
    } else {
        DISPTEXT_InsetNibblePrimary = INSET_NIBBLE_INVALID;
    }

    if ((WDISP_CharClassTable[p[ENTRY_FLAGS_HEX_SECONDARY_INDEX]] & CHARCLASS_HEX_MASK) != 0) {
        v = GROUP_AE_JMPTBL_LADFUNC_ParseHexDigit((LONG)p[ENTRY_FLAGS_HEX_SECONDARY_INDEX]);
        DISPTEXT_InsetNibbleSecondary = (UBYTE)v;
    } else {
        DISPTEXT_InsetNibbleSecondary = INSET_NIBBLE_INVALID;
    }
}
