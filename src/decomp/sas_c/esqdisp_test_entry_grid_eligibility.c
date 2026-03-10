typedef unsigned char UBYTE;
typedef short WORD;
typedef signed long LONG;

LONG ESQDISP_TestEntryGridEligibility(const UBYTE *entry, WORD index)
{
    if (index <= 0) {
        return 0;
    }

    if (index >= 49) {
        return 0;
    }

    if (entry == 0) {
        return 0;
    }

    if ((entry[7 + index] & 0x10) != 0) {
        return 1;
    }

    if (entry[(WORD)(index - 4)] < 5) {
        return 0;
    }

    if (entry[(WORD)(index - 4)] <= 10) {
        return 1;
    }

    return 0;
}
