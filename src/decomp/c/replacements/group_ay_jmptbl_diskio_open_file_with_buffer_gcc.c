#include "esq_types.h"

/*
 * Target 182 GCC trial function.
 * Jump-table stub forwarding to DISKIO_OpenFileWithBuffer.
 */
void DISKIO_OpenFileWithBuffer(void) __attribute__((noinline));

void GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer(void) __attribute__((noinline, used));

void GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer(void)
{
    DISKIO_OpenFileWithBuffer();
}
