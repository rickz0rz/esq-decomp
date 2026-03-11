typedef unsigned long ULONG;

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
