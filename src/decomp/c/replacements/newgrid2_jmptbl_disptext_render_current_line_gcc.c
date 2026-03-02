#include "esq_types.h"

void DISPTEXT_RenderCurrentLine(void) __attribute__((noinline));

void NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine(void) __attribute__((noinline, used));

void NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine(void)
{
    DISPTEXT_RenderCurrentLine();
}
