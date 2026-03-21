#include <exec/types.h>

extern void *Global_REF_GRAPHICS_LIBRARY;
#pragma libcall Global_REF_GRAPHICS_LIBRARY FreeRaster 1f2 10803
extern void FreeRaster(void *raster, ULONG width, ULONG height);

LONG GRAPHICS_FreeRaster(void *raster, LONG width, LONG height)
{
    FreeRaster(raster, (ULONG)width, (ULONG)height);
    return 0;
}
