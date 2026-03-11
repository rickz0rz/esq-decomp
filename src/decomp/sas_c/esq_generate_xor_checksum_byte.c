typedef unsigned long ULONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern UBYTE ESQIFF_RecordChecksumByte;
extern UBYTE ESQIFF_UseCachedChecksumFlag;

ULONG ESQ_GenerateXorChecksumByte(ULONG seed, UBYTE *src, ULONG length)
{
    ULONG checksum;
    UWORD count;

    checksum = (ULONG)ESQIFF_RecordChecksumByte;
    if (ESQIFF_UseCachedChecksumFlag != 0) {
        return checksum;
    }

    checksum = seed;
    checksum ^= 0xFFUL;
    count = (UWORD)length;

    do {
        checksum ^= (ULONG)(*src++);
        count--;
    } while (count != 0xFFFFU);

    return checksum & 0xFFUL;
}
