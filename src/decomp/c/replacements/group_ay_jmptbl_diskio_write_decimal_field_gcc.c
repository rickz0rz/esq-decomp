#include "esq_types.h"

/*
 * Target 175 GCC trial function.
 * Jump-table stub forwarding to DISKIO_WriteDecimalField.
 */
void DISKIO_WriteDecimalField(void) __attribute__((noinline));

void GROUP_AY_JMPTBL_DISKIO_WriteDecimalField(void) __attribute__((noinline, used));

void GROUP_AY_JMPTBL_DISKIO_WriteDecimalField(void)
{
    DISKIO_WriteDecimalField();
}
