#include <exec/types.h>
extern UBYTE ESQIFF_RecordChecksumByte;
extern UBYTE ESQIFF_UseCachedChecksumFlag;

ULONG ESQ_GenerateXorChecksumByte(ULONG seed, const UBYTE *src, ULONG length)
{
    UBYTE checksum;
    UWORD count;

    checksum = ESQIFF_RecordChecksumByte;
    if (ESQIFF_UseCachedChecksumFlag != 0) {
        return (ULONG)checksum;
    }

    checksum = (UBYTE)seed;
    checksum ^= 0xFF;
    count = (UWORD)length;

    do {
        checksum ^= *src++;
        count--;
    } while (count != 0xFFFFU);

    return ((ULONG)checksum) & 0xFFUL;
}
