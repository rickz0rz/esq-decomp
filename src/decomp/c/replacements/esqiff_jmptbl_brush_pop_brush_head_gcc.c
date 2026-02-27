#include "esq_types.h"

/*
 * Target 130 GCC trial function.
 * Jump-table stub forwarding to BRUSH_PopBrushHead.
 */
s32 BRUSH_PopBrushHead(s32 arg_1) __attribute__((noinline));

s32 ESQIFF_JMPTBL_BRUSH_PopBrushHead(s32 arg_1) __attribute__((noinline, used));

s32 ESQIFF_JMPTBL_BRUSH_PopBrushHead(s32 arg_1)
{
    return BRUSH_PopBrushHead(arg_1);
}
