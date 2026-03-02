#include "esq_types.h"

/*
 * Target 280 GCC trial function.
 * Jump-table stub forwarding to EXEC_CallVector_48.
 */
void EXEC_CallVector_48(void) __attribute__((noinline));

void GROUP_AV_JMPTBL_EXEC_CallVector_48(void) __attribute__((noinline, used));

void GROUP_AV_JMPTBL_EXEC_CallVector_48(void)
{
    EXEC_CallVector_48();
}
