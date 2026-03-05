extern unsigned char ESQIFF_RecordChecksumByte;
extern unsigned char ESQIFF_UseCachedChecksumFlag;

unsigned long ESQ_GenerateXorChecksumByte(unsigned long seed, unsigned char *src, unsigned long length)
{
    unsigned long d0;
    unsigned short n;

    d0 = (unsigned long)ESQIFF_RecordChecksumByte;
    if (ESQIFF_UseCachedChecksumFlag) {
        return d0;
    }

    d0 = seed;
    n = (unsigned short)length;
    d0 ^= 0xFFUL;

    while (n != 0) {
        d0 ^= (unsigned long)(*src++);
        n--;
    }

    return d0 & 0xFFUL;
}
