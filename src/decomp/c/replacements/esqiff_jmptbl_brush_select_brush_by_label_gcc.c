#include "esq_types.h"

/*
 * Target 134 GCC trial function.
 * Jump-table stub forwarding to BRUSH_SelectBrushByLabel.
 */
void BRUSH_SelectBrushByLabel(s32 arg_1) __attribute__((noinline));

void ESQIFF_JMPTBL_BRUSH_SelectBrushByLabel(s32 arg_1) __attribute__((noinline, used));

void ESQIFF_JMPTBL_BRUSH_SelectBrushByLabel(s32 arg_1)
{
    BRUSH_SelectBrushByLabel(arg_1);
}
