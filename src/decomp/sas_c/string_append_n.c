#include <exec/types.h>
char *STRING_AppendN(char *dst, const char *src, ULONG maxBytes)
{
    const char *srcEnd;
    char *dstEnd;
    char *out;
    ULONG copyLen;
    ULONG count;

    srcEnd = src;
    while (*srcEnd++ != 0) {
    }
    srcEnd--;
    copyLen = (ULONG)(srcEnd - src);

    dstEnd = dst;
    while (*dstEnd++ != 0) {
    }
    dstEnd--;
    out = dstEnd;

    if (copyLen > maxBytes) {
        copyLen = maxBytes;
    }

    count = copyLen;
    while (count != 0) {
        *dstEnd++ = *src++;
        count--;
    }

    out[copyLen] = 0;
    return dst;
}
