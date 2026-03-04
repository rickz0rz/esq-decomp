typedef unsigned long ULONG;
typedef unsigned char UBYTE;

UBYTE *STRING_CopyPadNul(UBYTE *dst, const UBYTE *src, ULONG maxLen)
{
    UBYTE *ret;

    ret = dst;

    while (maxLen-- != 0) {
        *dst = *src;
        if (*src++ == 0) {
            while (maxLen-- != 0) {
                *++dst = 0;
            }
            return ret;
        }
        dst++;
    }

    return ret;
}
