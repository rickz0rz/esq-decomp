typedef unsigned long ULONG;

typedef struct MemNode {
    struct MemNode *next;
    struct MemNode *prev;
    ULONG size;
} MemNode;

extern MemNode *Global_MemListHead;
extern MemNode *Global_MemListTail;
extern MemNode *Global_MemListFirstAllocNode;

struct ExecBase;
extern struct ExecBase *AbsExecBase;
#pragma libcall AbsExecBase AllocMem c6 1002
#pragma libcall AbsExecBase FreeMem d2 902
extern void *AllocMem(ULONG byteSize, ULONG requirements);
extern void FreeMem(void *memoryBlock, ULONG byteSize);

void MEMLIST_FreeAll(void)
{
    MemNode *node = Global_MemListHead;
    MemNode *next;

    while (node) {
        next = node->next;
        FreeMem(node, node->size);
        node = next;
    }

    Global_MemListTail = (MemNode *)0;
    Global_MemListHead = (MemNode *)0;
}

void *MEMLIST_AllocTracked(ULONG requestedSize)
{
    ULONG allocSize = requestedSize + 12UL;
    MemNode *node = (MemNode *)AllocMem(allocSize, 0UL);

    if (!node) {
        return (void *)0;
    }

    node->size = allocSize;
    node->prev = Global_MemListTail;
    node->next = (MemNode *)0;

    if (!Global_MemListHead) {
        Global_MemListHead = node;
    }

    if (Global_MemListTail) {
        Global_MemListTail->next = node;
    }

    Global_MemListTail = node;

    if (!Global_MemListFirstAllocNode) {
        Global_MemListFirstAllocNode = node;
    }

    return (void *)((char *)node + 12);
}
