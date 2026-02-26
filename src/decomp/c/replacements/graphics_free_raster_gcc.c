#include "esq_types.h"

/*
 * Target 082 GCC trial function.
 * Direct graphics.library FreeRaster(raster, width, height) wrapper.
 */
extern u32 Global_REF_GRAPHICS_LIBRARY;

s32 GRAPHICS_FreeRaster(void *raster, s32 width, s32 height) __attribute__((noinline, used));

static s32 graphics_lvo_free_raster(void *raster, s32 width, s32 height)
{
    register void *a0_in __asm__("a0") = raster;
    register u32 d0_in __asm__("d0") = (u32)width;
    register s32 d1_in __asm__("d1") = height;

    __asm__ volatile(
        "movea.l %3,%%a6\n\t"
        "jsr _LVOFreeRaster(%%a6)\n\t"
        : "+a"(a0_in), "+d"(d0_in), "+d"(d1_in)
        : "g"(Global_REF_GRAPHICS_LIBRARY)
        : "a6", "cc", "memory");

    return (s32)d0_in;
}

s32 GRAPHICS_FreeRaster(void *raster, s32 width, s32 height)
{
    return graphics_lvo_free_raster(raster, width, height);
}
