typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef long LONG;

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

    p = (UBYTE *)COI_GetAnimFieldPointerByMode(entry, (LONG)slot, 7);
    if (p == (UBYTE *)0) {
        UBYTE *s = CLOCK_STR_FALLBACK_ENTRY_FLAGS_PRIMARY;
        UBYTE *d = &local[1];
        do {
            *d = *s;
            d++;
            s++;
        } while (d[-1] != 0);
        p = &local[1];
    }

    if ((WDISP_CharClassTable[p[6]] & 0x80) != 0) {
        v = GROUP_AE_JMPTBL_LADFUNC_ParseHexDigit((LONG)p[6]);
        DISPTEXT_InsetNibblePrimary = (UBYTE)v;
    } else {
        DISPTEXT_InsetNibblePrimary = 0xFF;
    }

    if ((WDISP_CharClassTable[p[7]] & 0x80) != 0) {
        v = GROUP_AE_JMPTBL_LADFUNC_ParseHexDigit((LONG)p[7]);
        DISPTEXT_InsetNibbleSecondary = (UBYTE)v;
    } else {
        DISPTEXT_InsetNibbleSecondary = 0xFF;
    }
}
