typedef signed long LONG;

extern void *Global_GraphicsLibraryBase_A4;
extern LONG _LVOBltBitMapRastPort(void *gfxBase, void *bitMap, LONG sx, LONG sy, void *rastPort, LONG dx, LONG dy, LONG width, LONG height, LONG minterm, LONG mask);

LONG GRAPHICS_BltBitMapRastPort(void *bitMap, LONG sx, LONG sy, void *rastPort, LONG dx, LONG dy, LONG width, LONG height, LONG minterm, LONG mask)
{
    return _LVOBltBitMapRastPort(Global_GraphicsLibraryBase_A4, bitMap, sx, sy, rastPort, dx, dy, width, height, minterm, mask);
}
