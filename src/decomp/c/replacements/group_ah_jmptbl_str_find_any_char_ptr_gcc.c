#include "esq_types.h"

/*
 * Target 254 GCC trial function.
 * Jump-table stub forwarding to STR_FindAnyCharPtr.
 */
void STR_FindAnyCharPtr(void) __attribute__((noinline));

void GROUP_AH_JMPTBL_STR_FindAnyCharPtr(void) __attribute__((noinline, used));

void GROUP_AH_JMPTBL_STR_FindAnyCharPtr(void)
{
    STR_FindAnyCharPtr();
}
