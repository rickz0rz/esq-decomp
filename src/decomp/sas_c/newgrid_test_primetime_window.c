typedef signed long LONG;
typedef unsigned char UBYTE;

LONG NEWGRID_TestPrimeTimeWindow(LONG rowSlot, UBYTE *entry)
{
    UBYTE *modePtr;
    UBYTE c;

    if (entry == 0) {
        return 0;
    }

    modePtr = *(UBYTE **)(entry + 48);
    if (modePtr == 0) {
        return 0;
    }

    c = modePtr[1];
    if (c == 'N' || c == 'n') {
        return 0;
    }

    if (c == 'P' || c == 'p') {
        if (rowSlot <= 18) {
            return 0;
        }
        if (rowSlot >= 22) {
            return 0;
        }
        return 1;
    }

    return 1;
}
