#include "esq_types.h"

void BRUSH_FreeBrushList(void) __attribute__((noinline));

void WDISP_JMPTBL_BRUSH_FreeBrushList(void) __attribute__((noinline, used));

void WDISP_JMPTBL_BRUSH_FreeBrushList(void)
{
    BRUSH_FreeBrushList();
}
