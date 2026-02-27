#include "esq_types.h"

/*
 * Target 173 GCC trial function.
 * Jump-table stub forwarding to DISKIO_ConsumeCStringFromWorkBuffer.
 */
void DISKIO_ConsumeCStringFromWorkBuffer(void) __attribute__((noinline));

void GROUP_AY_JMPTBL_DISKIO_ConsumeCStringFromWorkBuffer(void) __attribute__((noinline, used));

void GROUP_AY_JMPTBL_DISKIO_ConsumeCStringFromWorkBuffer(void)
{
    DISKIO_ConsumeCStringFromWorkBuffer();
}
