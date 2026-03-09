typedef unsigned char UBYTE;
typedef unsigned short UWORD;

typedef struct DISPLIB_Entry {
    UBYTE pad0[27];
    UBYTE flags27;
} DISPLIB_Entry;

typedef struct DISPLIB_AuxData {
    UBYTE pad0[56];
    const char *titleTable[49];
} DISPLIB_AuxData;

enum {
    ENTRY_FLAG_WIDE_RANGE = 0x20,
    SEARCH_STEP_WIDE = 48,
    SEARCH_STEP_NARROW = 7,
    SEARCH_WRAP_FLAG_CLEAR = 0,
    SEARCH_WRAP_FLAG_SET = 1
};

extern volatile UWORD DISPLIB_PreviousSearchWrappedFlag;

long DISPLIB_FindPreviousValidEntryIndex(const char *entry, const char *title, long index)
{
    const DISPLIB_Entry *entryView;
    const DISPLIB_AuxData *auxView;
    long step;
    long floorIndex;
    long isWideRange;

    entryView = (const DISPLIB_Entry *)entry;
    auxView = (const DISPLIB_AuxData *)title;

    isWideRange = ((entryView->flags27 & ENTRY_FLAG_WIDE_RANGE) != 0U) ? 1 : 0;
    if (isWideRange != 0) {
        step = SEARCH_STEP_WIDE;
    } else {
        step = SEARCH_STEP_NARROW;
    }

    floorIndex = index - step;
    if (floorIndex < 1) {
        floorIndex = 1;
    }

    while (auxView->titleTable[index] == 0) {
        index--;
        if (index < floorIndex) {
            index = 0;
            DISPLIB_PreviousSearchWrappedFlag = SEARCH_WRAP_FLAG_CLEAR;
            break;
        }
        if (isWideRange == 0) {
            DISPLIB_PreviousSearchWrappedFlag = SEARCH_WRAP_FLAG_SET;
        }
    }

    return index;
}
