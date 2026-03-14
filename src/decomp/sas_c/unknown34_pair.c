#include <exec/lists.h>

typedef signed long LONG;
typedef unsigned char UBYTE;

void LIST_InitHeader(struct MinList *header)
{
    header->mlh_Head = (struct MinNode *)&header->mlh_Tail;
    header->mlh_Tail = (struct MinNode *)0;
    header->mlh_TailPred = (struct MinNode *)&header->mlh_Head;
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
