#include "esq_types.h"

/*
 * Target 076 GCC trial function.
 * Allocate size+12 bytes, append node to memlist, return payload pointer.
 */
typedef struct MemListNode {
    struct MemListNode *next;
    struct MemListNode *prev;
    u32 size;
} MemListNode;

extern MemListNode *Global_MemListHead;
extern MemListNode *Global_MemListTail;
extern MemListNode *Global_MemListFirstAllocNode;
extern u32 AbsExecBase;

void *MEMLIST_AllocTracked(u32 size) __attribute__((noinline, used));

static MemListNode *exec_alloc_mem(u32 size, u32 flags)
{
    register u32 d0_in __asm__("d0") = size;
    register u32 d1_in __asm__("d1") = flags;

    __asm__ volatile(
        "movea.l %3,%%a6\n\t"
        "jsr _LVOAllocMem(%%a6)\n\t"
        : "+r"(d0_in), "+r"(d1_in)
        : "0"(d0_in), "g"(AbsExecBase)
        : "a6", "cc", "memory");

    return (MemListNode *)d0_in;
}

void *MEMLIST_AllocTracked(u32 size)
{
    u32 total = size + 12u;
    MemListNode *node = exec_alloc_mem(total, 0u);

    if (node == (MemListNode *)0) {
        return (void *)0;
    }

    node->size = total;
    node->prev = Global_MemListTail;
    node->next = (MemListNode *)0;

    if (Global_MemListHead == (MemListNode *)0) {
        Global_MemListHead = node;
    }

    if (Global_MemListTail != (MemListNode *)0) {
        Global_MemListTail->next = node;
    }

    Global_MemListTail = node;

    if (Global_MemListFirstAllocNode == (MemListNode *)0) {
        Global_MemListFirstAllocNode = node;
    }

    return (void *)((u8 *)node + 12);
}
