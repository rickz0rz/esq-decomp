#include "esq_types.h"

/*
 * Target 232 GCC trial function.
 * Jump-table stub forwarding to SCRIPT_BuildTokenIndexMap.
 */
void SCRIPT_BuildTokenIndexMap(void) __attribute__((noinline));

void GROUP_AE_JMPTBL_SCRIPT_BuildTokenIndexMap(void) __attribute__((noinline, used));

void GROUP_AE_JMPTBL_SCRIPT_BuildTokenIndexMap(void)
{
    SCRIPT_BuildTokenIndexMap();
}
