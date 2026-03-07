typedef signed long LONG;
typedef unsigned char UBYTE;

extern LONG NEWGRID2_JMPTBL_ESQDISP_TestEntryBits0And2(UBYTE *entry);

LONG NEWGRID_TestEntrySelectable(UBYTE *entry, UBYTE *aux, LONG mode)
{
    if (mode != 0 && mode != 1) {
        return 0;
    }

    if (entry == 0 || aux == 0) {
        return 0;
    }

    if ((entry[40] & (UBYTE)0x80) == 0) {
        return 0;
    }

    if (mode == 0) {
        if ((entry[27] & (UBYTE)0x04) != 0) {
            return 1;
        }
        return 0;
    }

    if (NEWGRID2_JMPTBL_ESQDISP_TestEntryBits0And2(entry) == 0) {
        return 0;
    }

    return 1;
}
