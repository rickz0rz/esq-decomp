typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef long LONG;

LONG COI_GetAnimFieldPointerByMode(void *entry, LONG slot, LONG mode);

LONG CLEANUP_TestEntryFlagYAndBit1(void *entry, UWORD slot, LONG idx)
{
    UBYTE *p;

    p = (UBYTE *)COI_GetAnimFieldPointerByMode(entry, (LONG)slot, 7);
    if (p == (UBYTE *)0) {
        return 0;
    }

    if (idx < 0 || idx > 5) {
        return 0;
    }

    if (p[idx] != 89) {
        return 0;
    }

    if ((*(UBYTE *)((UBYTE *)entry + 40) & 2) == 0) {
        return 0;
    }

    return 1;
}
