#include "esq_types.h"

void BRUSH_SelectBrushSlot(void) __attribute__((noinline));

void WDISP_JMPTBL_BRUSH_SelectBrushSlot(void) __attribute__((noinline, used));

void WDISP_JMPTBL_BRUSH_SelectBrushSlot(void)
{
    BRUSH_SelectBrushSlot();
}
