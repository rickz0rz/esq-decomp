#include "esq_types.h"

/*
 * Target 219 GCC trial function.
 * Jump-table stub forwarding to ESQFUNC_DrawDiagnosticsScreen.
 */
void ESQFUNC_DrawDiagnosticsScreen(void) __attribute__((noinline));

void GROUP_AC_JMPTBL_ESQFUNC_DrawDiagnosticsScreen(void) __attribute__((noinline, used));

void GROUP_AC_JMPTBL_ESQFUNC_DrawDiagnosticsScreen(void)
{
    ESQFUNC_DrawDiagnosticsScreen();
}
