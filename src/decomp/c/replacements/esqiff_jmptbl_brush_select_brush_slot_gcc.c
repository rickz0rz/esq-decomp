#include "esq_types.h"

/*
 * Target 141 GCC trial function.
 * Jump-table stub forwarding to BRUSH_SelectBrushSlot.
 */
s32 BRUSH_SelectBrushSlot(s32 arg_1, s32 arg_2, s32 arg_3, s32 arg_4, s32 arg_5, s32 arg_6, s32 arg_7) __attribute__((noinline));

s32 ESQIFF_JMPTBL_BRUSH_SelectBrushSlot(s32 arg_1, s32 arg_2, s32 arg_3, s32 arg_4, s32 arg_5, s32 arg_6, s32 arg_7) __attribute__((noinline, used));

s32 ESQIFF_JMPTBL_BRUSH_SelectBrushSlot(s32 arg_1, s32 arg_2, s32 arg_3, s32 arg_4, s32 arg_5, s32 arg_6, s32 arg_7)
{
    return BRUSH_SelectBrushSlot(arg_1, arg_2, arg_3, arg_4, arg_5, arg_6, arg_7);
}
