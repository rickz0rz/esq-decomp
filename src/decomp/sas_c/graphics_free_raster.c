typedef signed long LONG;
typedef unsigned long ULONG;

extern void *Global_REF_GRAPHICS_LIBRARY;
extern void _LVOFreeRaster(void *graphicsBase, void *raster, ULONG width, LONG height);

LONG GRAPHICS_FreeRaster(void *raster, LONG width, LONG height)
{
    _LVOFreeRaster(Global_REF_GRAPHICS_LIBRARY, raster, (ULONG)width, height);
    return 0;
}
