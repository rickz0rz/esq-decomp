#include "esq_types.h"

/*
 * Target 176 GCC trial function.
 * Jump-table stub forwarding to DISKIO_WriteBufferedBytes.
 */
void DISKIO_WriteBufferedBytes(void) __attribute__((noinline));

void GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(void) __attribute__((noinline, used));

void GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(void)
{
    DISKIO_WriteBufferedBytes();
}
