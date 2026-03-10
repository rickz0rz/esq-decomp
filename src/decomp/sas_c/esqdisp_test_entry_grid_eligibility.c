typedef unsigned char UBYTE;
typedef short WORD;
typedef signed long LONG;

LONG ESQDISP_TestEntryGridEligibility(const void *entry, WORD index)
{
    const UBYTE *bytes;

    if (index <= 0) {
        return 0;
    }

    if (index >= 49) {
        return 0;
    }

    if (entry == 0) {
        return 0;
    }

    bytes = entry;

    if ((bytes[7 + index] & 0x10) != 0) {
        return 1;
    }

    if (bytes[(WORD)(index - 4)] < 5) {
        return 0;
    }

    if (bytes[(WORD)(index - 4)] <= 10) {
        return 1;
    }

    return 0;
}
