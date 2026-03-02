#include "esq_types.h"

/*
 * Target 249 GCC trial function.
 * Jump-table stub forwarding to ESQ_WildcardMatch.
 */
void ESQ_WildcardMatch(void) __attribute__((noinline));

void GROUP_AH_JMPTBL_ESQ_WildcardMatch(void) __attribute__((noinline, used));

void GROUP_AH_JMPTBL_ESQ_WildcardMatch(void)
{
    ESQ_WildcardMatch();
}
