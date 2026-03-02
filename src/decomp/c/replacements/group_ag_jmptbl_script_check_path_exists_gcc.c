#include "esq_types.h"

/*
 * Target 287 GCC trial function.
 * Jump-table stub forwarding to SCRIPT_CheckPathExists.
 */
void SCRIPT_CheckPathExists(void) __attribute__((noinline));

void GROUP_AG_JMPTBL_SCRIPT_CheckPathExists(void) __attribute__((noinline, used));

void GROUP_AG_JMPTBL_SCRIPT_CheckPathExists(void)
{
    SCRIPT_CheckPathExists();
}
