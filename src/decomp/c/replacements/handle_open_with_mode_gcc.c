#include "esq_types.h"

/*
 * Target 068 GCC trial function.
 * Find/allocate prealloc handle node, then dispatch mode-based open helper.
 */
extern u8 Global_PreallocHandleNode0[];

void *ALLOC_AllocFromFreeList(u32 size);
void *HANDLE_OpenFromModeString(void *arg1, void *arg2, void *node);

typedef struct PreallocHandleNode {
    struct PreallocHandleNode *next;
    u8 pad0[20];
    u32 open_flags;
    u8 pad1[6];
} PreallocHandleNode;

void *HANDLE_OpenWithMode(void *arg1, void *arg2, void *arg3) __attribute__((noinline, used));

void *HANDLE_OpenWithMode(void *arg1, void *arg2, void *arg3)
{
    PreallocHandleNode *prev = (PreallocHandleNode *)0;
    PreallocHandleNode *node = (PreallocHandleNode *)Global_PreallocHandleNode0;
    u8 *p;
    u32 i;

    while (node != (PreallocHandleNode *)0 && node->open_flags != 0) {
        prev = node;
        node = node->next;
    }

    if (node == (PreallocHandleNode *)0) {
        node = (PreallocHandleNode *)ALLOC_AllocFromFreeList(34);
        if (node == (PreallocHandleNode *)0) {
            return (void *)0;
        }
        prev->next = node;

        p = (u8 *)node;
        for (i = 0; i < 34; ++i) {
            p[i] = 0;
        }
    }

    (void)arg3;
    return HANDLE_OpenFromModeString(arg1, arg2, node);
}
