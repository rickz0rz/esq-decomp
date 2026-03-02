#include "esq_types.h"

void DISKIO_WriteBufferedBytes(void) __attribute__((noinline));

void SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes(void) __attribute__((noinline, used));

void SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes(void)
{
    DISKIO_WriteBufferedBytes();
}
