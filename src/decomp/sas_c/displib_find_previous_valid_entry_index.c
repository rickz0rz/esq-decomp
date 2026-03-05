typedef unsigned char UBYTE;
typedef unsigned short UWORD;

extern volatile UWORD DISPLIB_PreviousSearchWrappedFlag;

long DISPLIB_FindPreviousValidEntryIndex(const UBYTE *entry, const UBYTE *title, long index)
{
    long step;
    long floorIndex;

    if ((entry[27] & 0x20U) != 0U) {
        step = 48;
    } else {
        step = 7;
    }

    floorIndex = index - step;
    if (floorIndex < 1) {
        floorIndex = 1;
    }

    while (((const long *)(title + 56))[index] == 0) {
        index--;
        if (index < floorIndex) {
            index = 0;
            DISPLIB_PreviousSearchWrappedFlag = 0;
            break;
        }
        if ((entry[27] & 0x20U) == 0U) {
            DISPLIB_PreviousSearchWrappedFlag = 1;
        }
    }

    return index;
}
