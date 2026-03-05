typedef signed long LONG;
typedef signed short WORD;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern UWORD NEWGRID_RowHeightPx;
extern UBYTE *Global_PTR_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION;
extern void *Global_REF_GRAPHICS_LIBRARY;

extern void NEWGRID_DrawGridFrame(void *gridCtx, LONG mode, LONG firstPen, LONG secondPen, LONG yMax);
extern void _LVOSetAPen(void *rastPort, LONG pen);
extern LONG _LVOTextLength(void *rastPort, UBYTE *text, LONG len);
extern void NEWGRID_DrawWrappedText(void *rastPort, LONG x, LONG y, LONG width, UBYTE *text, LONG centered);
extern void NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(void *rastPort, LONG x1, LONG y1, LONG x2, LONG y2);

LONG NEWGRID_DrawAwaitingListingsMessage(void *gridCtx)
{
    UBYTE *rast;
    LONG rowH;
    LONG yMax;
    UBYTE *msg;
    UBYTE *p;
    LONG msgLen;
    LONG textW;
    LONG x;
    LONG y;
    UWORD fontH;
    WORD mid;

    (void)Global_REF_GRAPHICS_LIBRARY;

    rast = (UBYTE *)gridCtx + 60;
    rowH = (LONG)(UWORD)NEWGRID_RowHeightPx;
    yMax = rowH - 1;
    msg = Global_PTR_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION;
    p = msg;
    msgLen = 0;

    NEWGRID_DrawGridFrame(gridCtx, 7, 4, 4, yMax);
    _LVOSetAPen(rast, 1);

    while (*p != 0) {
        ++p;
    }
    msgLen = (LONG)(p - msg);

    textW = _LVOTextLength(rast, msg, msgLen);
    x = 624 - textW;
    if (x < 0) {
        x += 1;
    }
    x = (x >> 1) + 36;

    fontH = *(UWORD *)(*(UBYTE **)((UBYTE *)gridCtx + 112) + 26);
    y = rowH - (LONG)fontH;
    if (y < 0) {
        y += 1;
    }
    y = (y >> 1) + (LONG)fontH - 1;

    NEWGRID_DrawWrappedText(rast, x, y, 612, msg, 1);
    NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(rast, 0, 0, 695, yMax);

    mid = (WORD)((UWORD)NEWGRID_RowHeightPx >> 1);
    *(UWORD *)((UBYTE *)gridCtx + 52) = (UWORD)mid;
    *(LONG *)((UBYTE *)gridCtx + 32) = (LONG)(UWORD)mid;

    return 0;
}
