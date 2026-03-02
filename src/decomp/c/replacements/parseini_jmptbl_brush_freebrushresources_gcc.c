#include "esq_types.h"

void BRUSH_FreeBrushResources(void) __attribute__((noinline));

void PARSEINI_JMPTBL_BRUSH_FreeBrushResources(void) __attribute__((noinline, used));

void PARSEINI_JMPTBL_BRUSH_FreeBrushResources(void)
{
    BRUSH_FreeBrushResources();
}
