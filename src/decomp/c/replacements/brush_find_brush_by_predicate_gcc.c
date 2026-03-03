#include "esq_types.h"

/*
 * Target 693 GCC trial function.
 * Walk list *(list_head_ptr) and return first node where compare(node, key) == 0.
 */
s32 GROUP_AA_JMPTBL_STRING_CompareNoCase(const void *a, const void *b) __attribute__((noinline));

void *BRUSH_FindBrushByPredicate(void *key, void *list_head_ptr) __attribute__((noinline, used));

void *BRUSH_FindBrushByPredicate(void *key, void *list_head_ptr)
{
    u8 *cur;

    cur = *(u8 **)list_head_ptr;
    while (cur != 0) {
        if (GROUP_AA_JMPTBL_STRING_CompareNoCase(cur, key) == 0) {
            return cur;
        }
        cur = *(u8 **)(cur + 368);
    }
    return 0;
}
