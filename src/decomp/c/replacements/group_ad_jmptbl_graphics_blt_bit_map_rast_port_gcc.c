#include "esq_types.h"

/*
 * Target 155 GCC trial function.
 * Jump-table stub forwarding to GRAPHICS_BltBitMapRastPort.
 */
void GRAPHICS_BltBitMapRastPort(void) __attribute__((noinline));

void GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort(void) __attribute__((noinline, used));

void GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort(void)
{
    GRAPHICS_BltBitMapRastPort();
}
