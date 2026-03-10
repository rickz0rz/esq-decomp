typedef signed long LONG;
typedef unsigned char UBYTE;

typedef struct NEWGRID_ModeInfo {
    UBYTE pad0[1];
    UBYTE modeChar;
} NEWGRID_ModeInfo;

typedef struct NEWGRID_Entry {
    UBYTE pad0[48];
    NEWGRID_ModeInfo *modeInfo;
} NEWGRID_Entry;

LONG NEWGRID_TestPrimeTimeWindow(LONG rowSlot, const void *entry)
{
    const NEWGRID_Entry *entryView;
    const NEWGRID_ModeInfo *modePtr;
    UBYTE c;

    if (entry == 0) {
        return 0;
    }

    entryView = (const NEWGRID_Entry *)entry;
    modePtr = entryView->modeInfo;
    if (modePtr == 0) {
        return 0;
    }

    c = modePtr->modeChar;
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
