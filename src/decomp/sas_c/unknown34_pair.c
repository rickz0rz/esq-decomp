typedef unsigned long ULONG;
typedef signed long LONG;
typedef unsigned char UBYTE;

typedef struct ListHeader {
    ULONG head;
    ULONG zero;
    ULONG tail;
} ListHeader;

void LIST_InitHeader(ListHeader *header)
{
    header->head = (ULONG)header;
    header->head += 4;
    header->zero = 0;
    header->tail = (ULONG)header;
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
