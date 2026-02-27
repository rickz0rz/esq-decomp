#include "esq_types.h"

/*
 * Target 215 GCC trial function.
 * Jump-table stub forwarding to GRAPHICS_FreeRaster.
 */
void GRAPHICS_FreeRaster(void) __attribute__((noinline));

void GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(void) __attribute__((noinline, used));

void GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(void)
{
    GRAPHICS_FreeRaster();
}
