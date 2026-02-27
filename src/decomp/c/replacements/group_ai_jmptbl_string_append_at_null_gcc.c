#include "esq_types.h"

/*
 * Target 206 GCC trial function.
 * Jump-table stub forwarding to STRING_AppendAtNull.
 */
void STRING_AppendAtNull(void) __attribute__((noinline));

void GROUP_AI_JMPTBL_STRING_AppendAtNull(void) __attribute__((noinline, used));

void GROUP_AI_JMPTBL_STRING_AppendAtNull(void)
{
    STRING_AppendAtNull();
}
