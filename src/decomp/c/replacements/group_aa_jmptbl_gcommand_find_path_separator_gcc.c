#include "esq_types.h"

/*
 * Target 198 GCC trial function.
 * Jump-table stub forwarding to GCOMMAND_FindPathSeparator.
 */
void GCOMMAND_FindPathSeparator(void) __attribute__((noinline));

void GROUP_AA_JMPTBL_GCOMMAND_FindPathSeparator(void) __attribute__((noinline, used));

void GROUP_AA_JMPTBL_GCOMMAND_FindPathSeparator(void)
{
    GCOMMAND_FindPathSeparator();
}
