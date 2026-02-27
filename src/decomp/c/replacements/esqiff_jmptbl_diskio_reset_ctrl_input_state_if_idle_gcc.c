#include "esq_types.h"

/*
 * Target 119 GCC trial function.
 * Jump-table stub forwarding to DISKIO_ResetCtrlInputStateIfIdle.
 */
void DISKIO_ResetCtrlInputStateIfIdle(void) __attribute__((noinline));

void ESQIFF_JMPTBL_DISKIO_ResetCtrlInputStateIfIdle(void) __attribute__((noinline, used));

void ESQIFF_JMPTBL_DISKIO_ResetCtrlInputStateIfIdle(void)
{
    DISKIO_ResetCtrlInputStateIfIdle();
}
