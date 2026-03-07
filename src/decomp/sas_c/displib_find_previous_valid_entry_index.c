typedef unsigned char UBYTE;
typedef unsigned short UWORD;

enum {
    ENTRY_FLAGS_OFFSET = 27,
    ENTRY_FLAG_WIDE_RANGE = 0x20,
    TITLE_INDEX_TABLE_OFFSET = 56,
    SEARCH_STEP_WIDE = 48,
    SEARCH_STEP_NARROW = 7,
    SEARCH_WRAP_FLAG_CLEAR = 0,
    SEARCH_WRAP_FLAG_SET = 1
};

extern volatile UWORD DISPLIB_PreviousSearchWrappedFlag;

long DISPLIB_FindPreviousValidEntryIndex(const UBYTE *entry, const UBYTE *title, long index)
{
    long step;
    long floorIndex;
    long isWideRange;

    isWideRange = ((entry[ENTRY_FLAGS_OFFSET] & ENTRY_FLAG_WIDE_RANGE) != 0U) ? 1 : 0;
    if (isWideRange != 0) {
        step = SEARCH_STEP_WIDE;
    } else {
        step = SEARCH_STEP_NARROW;
    }

    floorIndex = index - step;
    if (floorIndex < 1) {
        floorIndex = 1;
    }

    while (((const long *)(title + TITLE_INDEX_TABLE_OFFSET))[index] == 0) {
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
