typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern UWORD NEWGRID_ColumnStartXPx;
extern UWORD NEWGRID_ColumnWidthPx;
extern void *Global_REF_GRAPHICS_LIBRARY;

extern void NEWGRID_JMPTBL_GENERATE_GRID_DATE_STRING(UBYTE *outText);
extern void _LVOSetDrMd(void *rastPort, LONG mode);
extern LONG NEWGRID_SetRowColor(void *gridCtx, LONG mode, LONG pen);
extern void _LVOSetAPen(void *rastPort, LONG pen);
extern void _LVORectFill(void *rastPort, LONG x1, LONG y1, LONG x2, LONG y2);
extern void NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(void *rastPort, LONG x1, LONG y1, LONG x2, LONG y2);
extern LONG _LVOTextLength(void *rastPort, UBYTE *text, LONG len);
extern void _LVOMove(void *rastPort, LONG x, LONG y);
extern void _LVOText(void *rastPort, UBYTE *text, LONG len);

void NEWGRID_DrawDateBanner(void *gridCtx)
{
    UBYTE dateText[100];
    UBYTE *rast;
    UBYTE *p;
    LONG dateLen;
    LONG xBase;
    LONG x;
    LONG y;
    UWORD fontH;

    (void)Global_REF_GRAPHICS_LIBRARY;

    rast = (UBYTE *)gridCtx + 60;
    NEWGRID_JMPTBL_GENERATE_GRID_DATE_STRING(dateText);

    _LVOSetDrMd(rast, 0);
    _LVOSetAPen(rast, NEWGRID_SetRowColor(gridCtx, 0, 7));

    _LVORectFill(rast, 0, 0, 695, 33);

    xBase = (LONG)(UWORD)NEWGRID_ColumnStartXPx;
    NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(rast, 0, 0, xBase + 35, 33);
    NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(rast, xBase + 36, 0, 695, 33);

    _LVOSetAPen(rast, 3);

    p = dateText;
    while (*p != 0) {
        ++p;
    }
    dateLen = (LONG)(p - dateText);

    x = ((LONG)(UWORD)NEWGRID_ColumnWidthPx * 3) - _LVOTextLength(rast, dateText, dateLen);
    if (x < 0) {
        x += 1;
    }
    x = xBase + (x >> 1) + 36;

    fontH = *(UWORD *)(*(UBYTE **)(rast + 52) + 26);
    y = 34 - (LONG)fontH;
    if (y < 0) {
        y += 1;
    }
    y = (y >> 1) + (LONG)fontH - 1;

    _LVOMove(rast, x, y);
    _LVOText(rast, dateText, dateLen);

    *(UWORD *)((UBYTE *)gridCtx + 52) = 17;
    *(LONG *)((UBYTE *)gridCtx + 32) = 17;
}
