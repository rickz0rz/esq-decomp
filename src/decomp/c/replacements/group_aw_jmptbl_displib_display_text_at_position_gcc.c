#include "esq_types.h"

/*
 * Target 186 GCC trial function.
 * Jump-table stub forwarding to DISPLIB_DisplayTextAtPosition.
 */
void DISPLIB_DisplayTextAtPosition(void) __attribute__((noinline));

void GROUP_AW_JMPTBL_DISPLIB_DisplayTextAtPosition(void) __attribute__((noinline, used));

void GROUP_AW_JMPTBL_DISPLIB_DisplayTextAtPosition(void)
{
    DISPLIB_DisplayTextAtPosition();
}
