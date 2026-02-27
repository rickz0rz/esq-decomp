#include "esq_types.h"

/*
 * Target 199 GCC trial function.
 * Jump-table stub forwarding to GRAPHICS_AllocRaster.
 */
void GRAPHICS_AllocRaster(void) __attribute__((noinline));

void GROUP_AA_JMPTBL_GRAPHICS_AllocRaster(void) __attribute__((noinline, used));

void GROUP_AA_JMPTBL_GRAPHICS_AllocRaster(void)
{
    GRAPHICS_AllocRaster();
}
