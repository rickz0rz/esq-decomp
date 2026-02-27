#include "esq_types.h"

/*
 * Target 202 GCC trial function.
 * Jump-table stub forwarding to STR_FindCharPtr.
 */
void STR_FindCharPtr(void) __attribute__((noinline));

void GROUP_AI_JMPTBL_STR_FindCharPtr(void) __attribute__((noinline, used));

void GROUP_AI_JMPTBL_STR_FindCharPtr(void)
{
    STR_FindCharPtr();
}
