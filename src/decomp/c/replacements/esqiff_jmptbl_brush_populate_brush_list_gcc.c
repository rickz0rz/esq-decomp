#include "esq_types.h"

/*
 * Target 138 GCC trial function.
 * Jump-table stub forwarding to BRUSH_PopulateBrushList.
 */
s32 BRUSH_PopulateBrushList(s32 arg_1, s32 arg_2, s32 arg_3) __attribute__((noinline));

s32 ESQIFF_JMPTBL_BRUSH_PopulateBrushList(s32 arg_1, s32 arg_2, s32 arg_3) __attribute__((noinline, used));

s32 ESQIFF_JMPTBL_BRUSH_PopulateBrushList(s32 arg_1, s32 arg_2, s32 arg_3)
{
    return BRUSH_PopulateBrushList(arg_1, arg_2, arg_3);
}
