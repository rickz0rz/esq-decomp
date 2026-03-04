struct MinNode {
    struct MinNode *mln_Succ;
    struct MinNode *mln_Pred;
};

struct MinList {
    struct MinNode *mlh_Head;
    struct MinNode *mlh_Tail;
    struct MinNode *mlh_TailPred;
};

void Test_ListInit(struct MinList *list)
{
    list->mlh_Head = (struct MinNode *)&list->mlh_Tail;
    list->mlh_Tail = 0;
    list->mlh_TailPred = (struct MinNode *)&list->mlh_Head;
}
