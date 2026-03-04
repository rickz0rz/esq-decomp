typedef unsigned char UBYTE;
typedef unsigned long ULONG;

UBYTE *STRING_AppendN(UBYTE *dst, const UBYTE *src, ULONG maxBytes)
{
    ULONG srcLen;
    ULONG dstLen;
    ULONG n;
    UBYTE *out;

    srcLen = 0;
    while (src[srcLen] != 0) {
        srcLen++;
    }

    dstLen = 0;
    while (dst[dstLen] != 0) {
        dstLen++;
    }

    out = dst + dstLen;

    n = srcLen;
    if (n > maxBytes) {
        n = maxBytes;
    }

    while (n != 0) {
        *out++ = *src++;
        n--;
    }

    *out = 0;
    return dst;
}
