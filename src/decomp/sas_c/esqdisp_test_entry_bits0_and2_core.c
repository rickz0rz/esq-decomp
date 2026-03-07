typedef signed long LONG;
typedef unsigned char UBYTE;

LONG ESQDISP_TestEntryBits0And2_Core(UBYTE *entry)
{
    if (!entry) {
        return 0;
    }

    if ((entry[40] & 1) == 0) {
        return 0;
    }

    if ((entry[40] & 4) == 0) {
        return 0;
    }

    return 1;
}
