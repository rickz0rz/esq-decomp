#include "esq_types.h"

/*
 * Target 007 GCC trial function.
 * Initialize a list header so it is empty and self-linked.
 */
void LIST_InitHeader(void *header) __attribute__((noinline, used));

void LIST_InitHeader(void *header)
{
    u8 *base = (u8 *)header;
    *(void **)base = header;
    *(u32 *)base += 4;
    *(u32 *)(base + 4) = 0;
    *(void **)(base + 8) = header;
}
