#include "esq_types.h"

/*
 * Target 180 GCC trial function.
 * Jump-table stub forwarding to DISKIO_LoadFileToWorkBuffer.
 */
void DISKIO_LoadFileToWorkBuffer(void) __attribute__((noinline));

void GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer(void) __attribute__((noinline, used));

void GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer(void)
{
    DISKIO_LoadFileToWorkBuffer();
}
