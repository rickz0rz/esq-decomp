#include "esq_types.h"

/*
 * Target 133 GCC trial function.
 * Jump-table stub forwarding to BRUSH_FreeBrushList.
 */
s32 BRUSH_FreeBrushList(s32 arg_1, s32 arg_2, s32 arg_3, s32 arg_4) __attribute__((noinline));

s32 ESQIFF_JMPTBL_BRUSH_FreeBrushList(s32 arg_1, s32 arg_2, s32 arg_3, s32 arg_4) __attribute__((noinline, used));

s32 ESQIFF_JMPTBL_BRUSH_FreeBrushList(s32 arg_1, s32 arg_2, s32 arg_3, s32 arg_4)
{
    return BRUSH_FreeBrushList(arg_1, arg_2, arg_3, arg_4);
}
