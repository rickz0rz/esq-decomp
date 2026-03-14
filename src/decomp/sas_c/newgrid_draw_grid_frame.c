#include <exec/types.h>
typedef struct NEWGRID_Context {
    UBYTE pad0[60];
    UBYTE rastPort[1];
} NEWGRID_Context;

extern LONG NEWGRID_SetRowColor(char *gridCtx, LONG mode, LONG pen, void *rowState);
extern void NEWGRID_FillGridRects(char *rastPort, LONG firstPen, LONG secondPen, LONG yMax);

void NEWGRID_DrawGridFrame(char *gridCtx, LONG unused1, LONG firstPen, LONG secondPen, LONG yMax)
{
    NEWGRID_Context *ctxView;
    LONG fillPenLeft;
    LONG fillPenRight;

    (void)unused1;

    ctxView = (NEWGRID_Context *)gridCtx;
    fillPenLeft = NEWGRID_SetRowColor(gridCtx, -1, firstPen, ctxView->rastPort);
    fillPenRight = NEWGRID_SetRowColor(gridCtx, 0, secondPen, (void *)(ULONG)fillPenLeft);
    NEWGRID_FillGridRects(gridCtx, fillPenLeft, fillPenRight, yMax);
}
