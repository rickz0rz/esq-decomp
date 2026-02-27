#include "esq_types.h"

/*
 * Target 131 GCC trial function.
 * Jump-table stub forwarding to BRUSH_AllocBrushNode.
 */
s32 BRUSH_AllocBrushNode(void) __attribute__((noinline));

s32 ESQIFF_JMPTBL_BRUSH_AllocBrushNode(void) __attribute__((noinline, used));

s32 ESQIFF_JMPTBL_BRUSH_AllocBrushNode(void)
{
    return BRUSH_AllocBrushNode();
}
