#include "esq_types.h"

/*
 * Target 123 GCC trial function.
 * Jump-table stub forwarding to ESQ_DecCopperListsPrimary.
 */
void ESQ_DecCopperListsPrimary(void) __attribute__((noinline));

void ESQIFF_JMPTBL_ESQ_DecCopperListsPrimary(void) __attribute__((noinline, used));

void ESQIFF_JMPTBL_ESQ_DecCopperListsPrimary(void)
{
    ESQ_DecCopperListsPrimary();
}
