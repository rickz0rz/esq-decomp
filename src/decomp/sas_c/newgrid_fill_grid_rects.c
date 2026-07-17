#include <exec/types.h>

extern WORD NEWGRID_ColumnStartXPx;
extern void *Global_REF_GRAPHICS_LIBRARY;

extern void _LVOSetAPen(void *base, char *rastPort, LONG pen);
extern void _LVORectFill(void *base, char *rastPort, LONG xMin, LONG yMin, LONG xMax, LONG yMax);

void NEWGRID_FillGridRects(char *rastPort, LONG firstPen, LONG secondPen, LONG yMax)
{
    LONG xSplit;

    (void)Global_REF_GRAPHICS_LIBRARY;

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rastPort, firstPen);

    xSplit = (LONG)NEWGRID_ColumnStartXPx + 35;
    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, rastPort, 0, 0, xSplit, yMax);

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rastPort, secondPen);

    xSplit = (LONG)NEWGRID_ColumnStartXPx + 36;
    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, rastPort, xSplit, 0, 695, yMax);
}
