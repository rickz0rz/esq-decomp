#include "esq_types.h"

/*
 * Target 271 GCC trial function.
 * Jump-table stub forwarding to PARSEINI_ScanLogoDirectory.
 */
void PARSEINI_ScanLogoDirectory(void) __attribute__((noinline));

void GROUP_AK_JMPTBL_PARSEINI_ScanLogoDirectory(void) __attribute__((noinline, used));

void GROUP_AK_JMPTBL_PARSEINI_ScanLogoDirectory(void)
{
    PARSEINI_ScanLogoDirectory();
}
