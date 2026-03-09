typedef signed long LONG;

extern void *NEWGRID_HeaderRastPortPtr;
extern void NEWGRID_FillGridRects(char *rastPort, LONG fillA, LONG fillB, LONG yMax);

void NEWGRID_DrawGridTopBars(void)
{
    NEWGRID_FillGridRects((char *)NEWGRID_HeaderRastPortPtr, 6, 6, 1);
}
