#include "esq_types.h"

/*
 * Target 177 GCC trial function.
 * Jump-table stub forwarding to DISKIO_CloseBufferedFileAndFlush.
 */
void DISKIO_CloseBufferedFileAndFlush(void) __attribute__((noinline));

void GROUP_AY_JMPTBL_DISKIO_CloseBufferedFileAndFlush(void) __attribute__((noinline, used));

void GROUP_AY_JMPTBL_DISKIO_CloseBufferedFileAndFlush(void)
{
    DISKIO_CloseBufferedFileAndFlush();
}
