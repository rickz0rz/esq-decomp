#include "esq_types.h"

void WDISP_SPrintf(void) __attribute__((noinline));

void PARSEINI_JMPTBL_WDISP_SPrintf(void) __attribute__((noinline, used));

void PARSEINI_JMPTBL_WDISP_SPrintf(void)
{
    WDISP_SPrintf();
}
