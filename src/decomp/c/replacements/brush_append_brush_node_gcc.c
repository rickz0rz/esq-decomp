#include "esq_types.h"

/*
 * Target 690 GCC trial function.
 * Append a brush node to list tail via next pointer at +368; return list head.
 */
void *BRUSH_AppendBrushNode(void *head, void *node) __attribute__((noinline, used));

void *BRUSH_AppendBrushNode(void *head, void *node)
{
    u8 *cur;

    if (head == 0) {
        return node;
    }

    cur = (u8 *)head;
    while (*(void **)(cur + 368) != 0) {
        cur = *(u8 **)(cur + 368);
    }

    *(void **)(cur + 368) = node;
    return head;
}
