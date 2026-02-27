#include "esq_types.h"

/*
 * Target 200 GCC trial function.
 * Jump-table stub forwarding to GCOMMAND_SaveBrushResult.
 */
void GCOMMAND_SaveBrushResult(void) __attribute__((noinline));

void GROUP_AF_JMPTBL_GCOMMAND_SaveBrushResult(void) __attribute__((noinline, used));

void GROUP_AF_JMPTBL_GCOMMAND_SaveBrushResult(void)
{
    GCOMMAND_SaveBrushResult();
}
