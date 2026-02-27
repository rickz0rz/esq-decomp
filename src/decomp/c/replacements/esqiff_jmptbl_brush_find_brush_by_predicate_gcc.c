#include "esq_types.h"

/*
 * Target 132 GCC trial function.
 * Jump-table stub forwarding to BRUSH_FindBrushByPredicate.
 */
s32 BRUSH_FindBrushByPredicate(s32 arg_1, s32 arg_2) __attribute__((noinline));

s32 ESQIFF_JMPTBL_BRUSH_FindBrushByPredicate(s32 arg_1, s32 arg_2) __attribute__((noinline, used));

s32 ESQIFF_JMPTBL_BRUSH_FindBrushByPredicate(s32 arg_1, s32 arg_2)
{
    return BRUSH_FindBrushByPredicate(arg_1, arg_2);
}
