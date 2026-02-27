#include "esq_types.h"

/*
 * Target 174 GCC trial function.
 * Jump-table stub forwarding to DISKIO_ParseLongFromWorkBuffer.
 */
void DISKIO_ParseLongFromWorkBuffer(void) __attribute__((noinline));

void GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer(void) __attribute__((noinline, used));

void GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer(void)
{
    DISKIO_ParseLongFromWorkBuffer();
}
