#include "esq_types.h"

/*
 * Target 128 GCC trial function.
 * Jump-table stub forwarding to BRUSH_CloneBrushRecord.
 */
s32 BRUSH_CloneBrushRecord(s32 arg_1) __attribute__((noinline));

s32 ESQIFF_JMPTBL_BRUSH_CloneBrushRecord(s32 arg_1) __attribute__((noinline, used));

s32 ESQIFF_JMPTBL_BRUSH_CloneBrushRecord(s32 arg_1)
{
    return BRUSH_CloneBrushRecord(arg_1);
}
