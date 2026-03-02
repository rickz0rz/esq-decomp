#include "esq_types.h"

/*
 * Target 247 GCC trial function.
 * Jump-table stub forwarding to LOCAVAIL_SaveAvailabilityDataFile.
 */
void LOCAVAIL_SaveAvailabilityDataFile(void) __attribute__((noinline));

void GROUP_AH_JMPTBL_LOCAVAIL_SaveAvailabilityDataFile(void) __attribute__((noinline, used));

void GROUP_AH_JMPTBL_LOCAVAIL_SaveAvailabilityDataFile(void)
{
    LOCAVAIL_SaveAvailabilityDataFile();
}
