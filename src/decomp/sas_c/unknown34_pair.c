typedef unsigned long ULONG;
typedef signed long LONG;
typedef unsigned char UBYTE;

void LIST_InitHeader(void *header)
{
    ULONG *p = (ULONG *)header;

    p[0] = (ULONG)header;
    p[0] += 4;
    p[1] = 0;
    p[2] = (ULONG)header;
}

LONG MEM_Move(UBYTE *src, UBYTE *dst, LONG length)
{
    if (length <= 0) {
        return length;
    }

    if (dst < src) {
        while (length != 0) {
            *dst++ = *src++;
            length -= 1;
        }
        return length;
    }

    src += length;
    dst += length;
    while (length != 0) {
        *--dst = *--src;
        length -= 1;
    }

    return length;
}
