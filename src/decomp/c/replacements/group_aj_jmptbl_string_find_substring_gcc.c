#include "esq_types.h"

/*
 * Target 259 GCC trial function.
 * Jump-table stub forwarding to STRING_FindSubstring.
 */
void STRING_FindSubstring(void) __attribute__((noinline));

void GROUP_AJ_JMPTBL_STRING_FindSubstring(void) __attribute__((noinline, used));

void GROUP_AJ_JMPTBL_STRING_FindSubstring(void)
{
    STRING_FindSubstring();
}
