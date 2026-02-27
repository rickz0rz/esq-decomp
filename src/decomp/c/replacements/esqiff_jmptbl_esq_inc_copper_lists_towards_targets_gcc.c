#include "esq_types.h"

/*
 * Target 122 GCC trial function.
 * Jump-table stub forwarding to ESQ_IncCopperListsTowardsTargets.
 */
void ESQ_IncCopperListsTowardsTargets(void) __attribute__((noinline));

void ESQIFF_JMPTBL_ESQ_IncCopperListsTowardsTargets(void) __attribute__((noinline, used));

void ESQIFF_JMPTBL_ESQ_IncCopperListsTowardsTargets(void)
{
    ESQ_IncCopperListsTowardsTargets();
}
