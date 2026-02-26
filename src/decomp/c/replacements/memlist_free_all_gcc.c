#include "esq_types.h"

/*
 * Target 073 GCC trial function.
 * Free all tracked memlist nodes and clear head/tail globals.
 */
typedef struct MemListNode {
    struct MemListNode *next;
    struct MemListNode *prev;
    u32 size;
} MemListNode;

extern MemListNode *Global_MemListHead;
extern MemListNode *Global_MemListTail;

void MEMLIST_FreeAll(void) __attribute__((noinline, used));

static void exec_free_mem(void *ptr, u32 size)
{
    register void *a1_in __asm__("a1") = ptr;
    register u32 d0_in __asm__("d0") = size;

    __asm__ volatile(
        "movea.l AbsExecBase,%%a6\n\t"
        "jsr _LVOFreeMem(%%a6)\n\t"
        : "+r"(a1_in), "+r"(d0_in)
        :
        : "a6", "cc", "memory");
}

void MEMLIST_FreeAll(void)
{
    MemListNode *node = Global_MemListHead;

    while (node != (MemListNode *)0) {
        MemListNode *next = node->next;
        exec_free_mem((void *)node, node->size);
        node = next;
    }

    Global_MemListTail = (MemListNode *)0;
    Global_MemListHead = (MemListNode *)0;
}
