#include "esq_types.h"

/*
 * Target 129 GCC trial function.
 * Jump-table stub forwarding to BRUSH_FindType3Brush.
 */
s32 BRUSH_FindType3Brush(s32 arg_1) __attribute__((noinline));

s32 ESQIFF_JMPTBL_BRUSH_FindType3Brush(s32 arg_1) __attribute__((noinline, used));

s32 ESQIFF_JMPTBL_BRUSH_FindType3Brush(s32 arg_1)
{
    return BRUSH_FindType3Brush(arg_1);
}
