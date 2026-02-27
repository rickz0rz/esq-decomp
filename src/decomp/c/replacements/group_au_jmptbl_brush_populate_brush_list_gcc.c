#include "esq_types.h"

/*
 * Target 195 GCC trial function.
 * Jump-table stub forwarding to BRUSH_PopulateBrushList.
 */
void BRUSH_PopulateBrushList(void) __attribute__((noinline));

void GROUP_AU_JMPTBL_BRUSH_PopulateBrushList(void) __attribute__((noinline, used));

void GROUP_AU_JMPTBL_BRUSH_PopulateBrushList(void)
{
    BRUSH_PopulateBrushList();
}
