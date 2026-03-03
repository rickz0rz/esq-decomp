#include "esq_types.h"

/*
 * Target 698 GCC trial function.
 * Normalize each brush name by copying basename (after path separator) back to node start.
 */
u8 *GROUP_AA_JMPTBL_GCOMMAND_FindPathSeparator(u8 *path) __attribute__((noinline));

void BRUSH_NormalizeBrushNames(void **head_ptr) __attribute__((noinline, used));

void BRUSH_NormalizeBrushNames(void **head_ptr)
{
    u8 *node;

    node = (u8 *)*head_ptr;
    while (node != 0) {
        u8 scratch[40];
        u8 *src;
        u8 *dst;

        src = node;
        dst = scratch;
        do {
            *dst++ = *src;
        } while (*src++ != 0);

        src = GROUP_AA_JMPTBL_GCOMMAND_FindPathSeparator(scratch);
        dst = node;
        do {
            *dst++ = *src;
        } while (*src++ != 0);

        node = *(u8 **)(node + 368);
    }
}
