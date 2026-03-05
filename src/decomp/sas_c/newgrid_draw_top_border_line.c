typedef signed long LONG;

extern void *NEWGRID_HeaderRastPortPtr;
extern void *Global_REF_GRAPHICS_LIBRARY;

extern void _LVOSetAPen(void *rastPort, LONG pen);
extern void _LVORectFill(void *rastPort, LONG xMin, LONG yMin, LONG xMax, LONG yMax);

void NEWGRID_DrawTopBorderLine(void)
{
    (void)Global_REF_GRAPHICS_LIBRARY;
    _LVOSetAPen(NEWGRID_HeaderRastPortPtr, 7);
    _LVORectFill(NEWGRID_HeaderRastPortPtr, 0, 0, 695, 1);
}
