#include "esq_types.h"

void DISKIO_CloseBufferedFileAndFlush(void) __attribute__((noinline));

void SCRIPT_JMPTBL_DISKIO_CloseBufferedFileAndFlush(void) __attribute__((noinline, used));

void SCRIPT_JMPTBL_DISKIO_CloseBufferedFileAndFlush(void)
{
    DISKIO_CloseBufferedFileAndFlush();
}
