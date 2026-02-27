#include "esq_types.h"

/*
 * Target 145 GCC trial function.
 * Jump-table stub forwarding to STRING_CopyPadNul.
 */
void STRING_CopyPadNul(void) __attribute__((noinline));

void GROUP_AW_JMPTBL_STRING_CopyPadNul(void) __attribute__((noinline, used));

void GROUP_AW_JMPTBL_STRING_CopyPadNul(void)
{
    STRING_CopyPadNul();
}
