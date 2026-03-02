#include "esq_types.h"

void DISKIO_ConsumeLineFromWorkBuffer(void) __attribute__((noinline));

void PARSEINI_JMPTBL_DISKIO_ConsumeLineFromWorkBuffer(void) __attribute__((noinline, used));

void PARSEINI_JMPTBL_DISKIO_ConsumeLineFromWorkBuffer(void)
{
    DISKIO_ConsumeLineFromWorkBuffer();
}
