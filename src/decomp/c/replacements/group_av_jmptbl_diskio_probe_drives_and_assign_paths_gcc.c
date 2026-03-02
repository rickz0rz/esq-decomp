#include "esq_types.h"

/*
 * Target 278 GCC trial function.
 * Jump-table stub forwarding to DISKIO_ProbeDrivesAndAssignPaths.
 */
void DISKIO_ProbeDrivesAndAssignPaths(void) __attribute__((noinline));

void GROUP_AV_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths(void) __attribute__((noinline, used));

void GROUP_AV_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths(void)
{
    DISKIO_ProbeDrivesAndAssignPaths();
}
