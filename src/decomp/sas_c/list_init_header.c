#include <exec/lists.h>

void LIST_InitHeader(struct MinList *header)
{
    header->mlh_Head = (struct MinNode *)&header->mlh_Tail;
    header->mlh_Tail = (struct MinNode *)0;
    header->mlh_TailPred = (struct MinNode *)&header->mlh_Head;
}
