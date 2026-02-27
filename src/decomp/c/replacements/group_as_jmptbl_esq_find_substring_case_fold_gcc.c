#include "esq_types.h"

/*
 * Target 190 GCC trial function.
 * Jump-table stub forwarding to ESQ_FindSubstringCaseFold.
 */
void ESQ_FindSubstringCaseFold(void) __attribute__((noinline));

void GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold(void) __attribute__((noinline, used));

void GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold(void)
{
    ESQ_FindSubstringCaseFold();
}
