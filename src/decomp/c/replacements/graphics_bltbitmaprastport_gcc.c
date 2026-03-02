#include "esq_types.h"

/*
 * Target 602 GCC trial function.
 * Direct wrapper around graphics.library _LVOBltBitMapRastPort.
 */
extern u8 *Global_GraphicsLibraryBase_A4;

s32 GRAPHICS_BltBitMapRastPort(void) __attribute__((noinline, used));

s32 GRAPHICS_BltBitMapRastPort(void)
{
    __asm__ volatile(
        "movem.l %d2-%d6/%a6,-(%sp)\n\t"
        "movea.l _Global_GraphicsLibraryBase_A4,%a6\n\t"
        "movea.l 28(%sp),%a0\n\t"
        "movem.l 32(%sp),%d0-%d1\n\t"
        "movea.l 40(%sp),%a1\n\t"
        "movem.l 44(%sp),%d2-%d6\n\t"
        "jsr _LVOBltBitMapRastPort(%a6)\n\t"
        "movem.l (%sp)+,%d2-%d6/%a6\n\t"
        "rts\n\t");
    __builtin_unreachable();
}
