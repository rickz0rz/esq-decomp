typedef signed long LONG;
typedef signed short WORD;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct NEWGRID_Font {
    UBYTE pad0[26];
    UWORD ySize;
} NEWGRID_Font;

typedef struct NEWGRID_RastPort {
    UBYTE pad0[52];
    NEWGRID_Font *font;
} NEWGRID_RastPort;

typedef struct NEWGRID_Context {
    UBYTE pad0[32];
    LONG selectedState;
    UBYTE pad1[18];
    UWORD selectionCode;
    UBYTE pad2[6];
    NEWGRID_RastPort rastPort;
} NEWGRID_Context;

extern UWORD NEWGRID_RowHeightPx;
extern const char *Global_PTR_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION;
extern void *Global_REF_GRAPHICS_LIBRARY;

extern void NEWGRID_DrawGridFrame(char *gridCtx, LONG mode, LONG firstPen, LONG secondPen, LONG yMax);
extern void _LVOSetAPen(char *rastPort, LONG pen);
extern LONG _LVOTextLength(char *rastPort, const char *text, LONG len);
extern char *NEWGRID_DrawWrappedText(char *rastPort, LONG x, LONG y, LONG width, const char *text, LONG centered);
extern void BEVEL_DrawBevelFrameWithTopRight(char *rastPort, LONG x1, LONG y1, LONG x2, LONG y2);

LONG NEWGRID_DrawAwaitingListingsMessage(char *gridCtx)
{
    NEWGRID_Context *ctx;
    NEWGRID_RastPort *rast;
    LONG rowH;
    LONG yMax;
    const char *msg;
    const char *p;
    LONG msgLen;
    LONG textW;
    LONG x;
    LONG y;
    UWORD fontH;
    WORD mid;

    (void)Global_REF_GRAPHICS_LIBRARY;

    ctx = (NEWGRID_Context *)gridCtx;
    rast = &ctx->rastPort;
    rowH = (LONG)(UWORD)NEWGRID_RowHeightPx;
    yMax = rowH - 1;
    msg = Global_PTR_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION;
    p = msg;
    msgLen = 0;

    NEWGRID_DrawGridFrame(gridCtx, 7, 4, 4, yMax);
    _LVOSetAPen((char *)rast, 1);

    while (*p != 0) {
        ++p;
    }
    msgLen = (LONG)(p - msg);

    textW = _LVOTextLength((char *)rast, msg, msgLen);
    x = 624 - textW;
    if (x < 0) {
        x += 1;
    }
    x = (x >> 1) + 36;

    fontH = rast->font->ySize;
    y = rowH - (LONG)fontH;
    if (y < 0) {
        y += 1;
    }
    y = (y >> 1) + (LONG)fontH - 1;

    NEWGRID_DrawWrappedText((char *)rast, x, y, 612, msg, 1);
    BEVEL_DrawBevelFrameWithTopRight((char *)rast, 0, 0, 695, yMax);

    mid = (WORD)((UWORD)NEWGRID_RowHeightPx >> 1);
    ctx->selectionCode = (UWORD)mid;
    ctx->selectedState = (LONG)(UWORD)mid;

    return 0;
}
