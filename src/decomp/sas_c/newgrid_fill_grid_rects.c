typedef signed long LONG;
typedef signed short WORD;

extern WORD NEWGRID_ColumnStartXPx;
extern void *Global_REF_GRAPHICS_LIBRARY;

extern void _LVOSetAPen(void *rastPort, LONG pen);
extern void _LVORectFill(void *rastPort, LONG xMin, LONG yMin, LONG xMax, LONG yMax);

void NEWGRID_FillGridRects(char *rastPort, LONG firstPen, LONG secondPen, LONG yMax)
{
    LONG xSplit;

    (void)Global_REF_GRAPHICS_LIBRARY;

    _LVOSetAPen(rastPort, firstPen);

    xSplit = (LONG)NEWGRID_ColumnStartXPx + 35;
    _LVORectFill(rastPort, 0, 0, xSplit, yMax);

    _LVOSetAPen(rastPort, secondPen);

    xSplit = (LONG)NEWGRID_ColumnStartXPx + 36;
    _LVORectFill(rastPort, xSplit, 0, 695, yMax);
}
