#include "esq_types.h"

/*
 * Target 692 GCC trial function.
 * Walk list head at *(arg) and return first node with type byte (offset +32) == 3.
 */
void *BRUSH_FindType3Brush(void *list_head_ptr) __attribute__((noinline, used));

void *BRUSH_FindType3Brush(void *list_head_ptr)
{
    u8 *cur;
    s32 found;

    cur = *(u8 **)list_head_ptr;
    found = 0;

    while (cur != 0 && found == 0) {
        if (cur[32] == 3) {
            found = 1;
        }
        if (found == 0) {
            cur = *(u8 **)(cur + 368);
        }
    }

    if (found != 0) {
        return cur;
    }
    return 0;
}
