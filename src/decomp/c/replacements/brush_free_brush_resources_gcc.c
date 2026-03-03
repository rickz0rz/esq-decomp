#include "esq_types.h"

/*
 * Target 700 GCC trial function.
 * Release brush resource-descriptor chain via +234 link and clear list head.
 */
extern u8 Global_STR_BRUSH_C_9[];

void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const void *tag, s32 line, void *ptr, s32 bytes) __attribute__((noinline));

void BRUSH_FreeBrushResources(void **head_ptr) __attribute__((noinline, used));

void BRUSH_FreeBrushResources(void **head_ptr)
{
    u8 *node;

    node = (u8 *)*head_ptr;
    while (node != 0) {
        u8 *next;

        next = *(u8 **)(node + 234);
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_BRUSH_C_9, 887, node, 238);
        node = next;
    }

    *head_ptr = 0;
}
