#include "esq_types.h"

void DISPTEXT_FreeBuffers(void) __attribute__((noinline));

void NEWGRID_JMPTBL_DISPTEXT_FreeBuffers(void) __attribute__((noinline, used));

void NEWGRID_JMPTBL_DISPTEXT_FreeBuffers(void)
{
    DISPTEXT_FreeBuffers();
}
