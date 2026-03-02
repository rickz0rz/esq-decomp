#include "esq_types.h"

/*
 * Target 273 GCC trial function.
 * Jump-table stub forwarding to ESQ_SetCopperEffect_Default.
 */
void ESQ_SetCopperEffect_Default(void) __attribute__((noinline));

void GROUP_AK_JMPTBL_ESQ_SetCopperEffect_Default(void) __attribute__((noinline, used));

void GROUP_AK_JMPTBL_ESQ_SetCopperEffect_Default(void)
{
    ESQ_SetCopperEffect_Default();
}
