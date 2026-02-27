#include "esq_types.h"

/*
 * Target 220 GCC trial function.
 * Jump-table stub forwarding to ESQFUNC_DrawMemoryStatusScreen.
 */
void ESQFUNC_DrawMemoryStatusScreen(void) __attribute__((noinline));

void GROUP_AC_JMPTBL_ESQFUNC_DrawMemoryStatusScreen(void) __attribute__((noinline, used));

void GROUP_AC_JMPTBL_ESQFUNC_DrawMemoryStatusScreen(void)
{
    ESQFUNC_DrawMemoryStatusScreen();
}
