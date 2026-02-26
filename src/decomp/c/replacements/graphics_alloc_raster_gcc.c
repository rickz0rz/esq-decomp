#include "esq_types.h"

/*
 * Target 081 GCC trial function.
 * Direct graphics.library AllocRaster(width, height) wrapper.
 */
extern u32 Global_REF_GRAPHICS_LIBRARY;

void *GRAPHICS_AllocRaster(s32 width, s32 height) __attribute__((noinline, used));

static void *graphics_lvo_alloc_raster(s32 width, s32 height)
{
    register u32 d0_in __asm__("d0") = (u32)width;
    register s32 d1_in __asm__("d1") = height;

    __asm__ volatile(
        "movea.l %3,%%a6\n\t"
        "jsr _LVOAllocRaster(%%a6)\n\t"
        : "+r"(d0_in), "+r"(d1_in)
        : "0"(d0_in), "g"(Global_REF_GRAPHICS_LIBRARY)
        : "a6", "cc", "memory");

    return (void *)d0_in;
}

void *GRAPHICS_AllocRaster(s32 width, s32 height)
{
    return graphics_lvo_alloc_raster(width, height);
}
