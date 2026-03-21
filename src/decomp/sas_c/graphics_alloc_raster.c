#include <exec/types.h>

extern void *Global_REF_GRAPHICS_LIBRARY;
#pragma libcall Global_REF_GRAPHICS_LIBRARY AllocRaster 1ec 1002
extern void *AllocRaster(ULONG width, ULONG height);

void *GRAPHICS_AllocRaster(LONG width, LONG height)
{
    return AllocRaster((ULONG)width, (ULONG)height);
}
