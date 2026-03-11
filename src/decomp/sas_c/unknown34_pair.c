typedef unsigned long ULONG;
typedef signed long LONG;
typedef unsigned char UBYTE;

typedef struct ListHeader {
    struct ListHeader *head;
    ULONG count;
    struct ListHeader *tail;
} ListHeader;

void LIST_InitHeader(ListHeader *header)
{
    header->head = (ListHeader *)((UBYTE *)header + 4);
    header->count = 0;
    header->tail = header;
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
