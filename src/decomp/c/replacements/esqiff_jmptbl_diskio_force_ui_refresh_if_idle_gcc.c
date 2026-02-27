#include "esq_types.h"

/*
 * Target 121 GCC trial function.
 * Jump-table stub forwarding to DISKIO_ForceUiRefreshIfIdle.
 */
void DISKIO_ForceUiRefreshIfIdle(void) __attribute__((noinline));

void ESQIFF_JMPTBL_DISKIO_ForceUiRefreshIfIdle(void) __attribute__((noinline, used));

void ESQIFF_JMPTBL_DISKIO_ForceUiRefreshIfIdle(void)
{
    DISKIO_ForceUiRefreshIfIdle();
}
