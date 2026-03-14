#include <exec/lists.h>

void Test_ListInit(struct MinList *list)
{
    list->mlh_Head = (struct MinNode *)&list->mlh_Tail;
    list->mlh_Tail = 0;
    list->mlh_TailPred = (struct MinNode *)&list->mlh_Head;
}
