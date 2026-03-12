typedef signed long LONG;
typedef unsigned char UBYTE;

typedef struct NEWGRID_Entry {
    UBYTE pad0[27];
    UBYTE flags27;
    UBYTE pad1[12];
    UBYTE flags40;
} NEWGRID_Entry;

extern LONG NEWGRID2_JMPTBL_ESQDISP_TestEntryBits0And2(const char *entry);

LONG NEWGRID_TestEntrySelectable(const void *entry, const void *aux, LONG mode)
{
    if (mode != 0 && mode != 1) {
        return 0;
    }

    if (entry == 0 || aux == 0) {
        return 0;
    }

    if ((((const NEWGRID_Entry *)entry)->flags40 & (UBYTE)0x80) == 0) {
        return 0;
    }

    if (mode == 0) {
        if ((((const NEWGRID_Entry *)entry)->flags27 & (UBYTE)0x04) != 0) {
            return 1;
        }
        return 0;
    }

    if (NEWGRID2_JMPTBL_ESQDISP_TestEntryBits0And2(entry) == 0) {
        return 0;
    }

    return 1;
}
