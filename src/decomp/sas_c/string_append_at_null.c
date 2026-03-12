typedef unsigned char UBYTE;

UBYTE *STRING_AppendAtNull(UBYTE *dst, const UBYTE *src)
{
    UBYTE *ret;

    ret = dst;

    while (*dst++ != 0) {}
    dst--;

    do {
        *dst++ = *src++;
    } while (dst[-1] != 0);

    return ret;
}
