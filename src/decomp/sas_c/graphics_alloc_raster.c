#include <exec/types.h>
extern void *Global_REF_GRAPHICS_LIBRARY;
extern void *_LVOAllocRaster(void *graphicsBase, ULONG width, LONG height);

void *GRAPHICS_AllocRaster(LONG width, LONG height)
{
    return _LVOAllocRaster(Global_REF_GRAPHICS_LIBRARY, (ULONG)width, height);
}
