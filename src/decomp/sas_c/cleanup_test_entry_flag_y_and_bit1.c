typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef long LONG;

enum {
    ENTRY_MODE_FLAGS = 7,
    ENTRY_FLAG_Y_MAX_INDEX = 5,
    ENTRY_FLAG_Y_CHAR = 'Y',
    ENTRY_FLAGS_BYTE_OFFSET = 40,
    ENTRY_FLAGS_BIT1_MASK = 2
};

LONG COI_GetAnimFieldPointerByMode(void *entry, LONG slot, LONG mode);

LONG CLEANUP_TestEntryFlagYAndBit1(void *entry, UWORD slot, LONG idx)
{
    UBYTE *p;

    p = (UBYTE *)COI_GetAnimFieldPointerByMode(entry, (LONG)slot, ENTRY_MODE_FLAGS);
    if (p == (UBYTE *)0) {
        return 0;
    }

    if (idx < 0 || idx > ENTRY_FLAG_Y_MAX_INDEX) {
        return 0;
    }

    if (p[idx] != ENTRY_FLAG_Y_CHAR) {
        return 0;
    }

    if ((*(UBYTE *)((UBYTE *)entry + ENTRY_FLAGS_BYTE_OFFSET) & ENTRY_FLAGS_BIT1_MASK) == 0) {
        return 0;
    }

    return 1;
}
