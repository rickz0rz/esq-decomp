#include "esq_types.h"

/*
 * Target 691 GCC trial function.
 * Pop list head: return head->next (offset +368), free old head via BRUSH_FreeBrushList.
 */
void BRUSH_FreeBrushList(void **head_ptr, s32 free_one) __attribute__((noinline));

void *BRUSH_PopBrushHead(void *head) __attribute__((noinline, used));

void *BRUSH_PopBrushHead(void *head)
{
    void *next;
    void *local_head;

    if (head == 0) {
        next = 0;
    } else {
        next = *(void **)((u8 *)head + 368);
        local_head = head;
        BRUSH_FreeBrushList(&local_head, 1);
    }

    return next;
}
