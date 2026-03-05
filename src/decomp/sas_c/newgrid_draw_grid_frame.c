typedef signed long LONG;
typedef unsigned long ULONG;
typedef unsigned char UBYTE;

extern LONG NEWGRID_SetRowColor(void *gridCtx, LONG mode, LONG pen, void *rowState);
extern void NEWGRID_FillGridRects(void *rastPort, LONG firstPen, LONG secondPen, LONG yMax);

void NEWGRID_DrawGridFrame(void *gridCtx, LONG unused1, LONG firstPen, LONG secondPen, LONG yMax)
{
    LONG fillPenLeft;
    LONG fillPenRight;

    (void)unused1;

    fillPenLeft = NEWGRID_SetRowColor(gridCtx, -1, firstPen, (void *)((UBYTE *)gridCtx + 60));
    fillPenRight = NEWGRID_SetRowColor(gridCtx, 0, secondPen, (void *)(ULONG)fillPenLeft);
    NEWGRID_FillGridRects(gridCtx, fillPenLeft, fillPenRight, yMax);
}
