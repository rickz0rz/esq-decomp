#include "esq_types.h"

void BRUSH_FreeBrushList(void) __attribute__((noinline));

void PARSEINI_JMPTBL_BRUSH_FreeBrushList(void) __attribute__((noinline, used));

void PARSEINI_JMPTBL_BRUSH_FreeBrushList(void)
{
    BRUSH_FreeBrushList();
}
