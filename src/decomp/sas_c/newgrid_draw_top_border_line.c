typedef signed long LONG;

typedef struct NEWGRID_RastPort {
    char unused;
} NEWGRID_RastPort;

extern NEWGRID_RastPort *NEWGRID_HeaderRastPortPtr;
extern void *Global_REF_GRAPHICS_LIBRARY;

extern void _LVOSetAPen(char *rastPort, LONG pen);
extern void _LVORectFill(char *rastPort, LONG xMin, LONG yMin, LONG xMax, LONG yMax);

void NEWGRID_DrawTopBorderLine(void)
{
    (void)Global_REF_GRAPHICS_LIBRARY;
    _LVOSetAPen((char *)NEWGRID_HeaderRastPortPtr, 7);
    _LVORectFill((char *)NEWGRID_HeaderRastPortPtr, 0, 0, 695, 1);
}
