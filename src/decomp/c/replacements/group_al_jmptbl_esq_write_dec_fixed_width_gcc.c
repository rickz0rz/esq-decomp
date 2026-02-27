#include "esq_types.h"

/*
 * Target 170 GCC trial function.
 * Jump-table stub forwarding to ESQ_WriteDecFixedWidth.
 */
void ESQ_WriteDecFixedWidth(void) __attribute__((noinline));

void GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth(void) __attribute__((noinline, used));

void GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth(void)
{
    ESQ_WriteDecFixedWidth();
}
