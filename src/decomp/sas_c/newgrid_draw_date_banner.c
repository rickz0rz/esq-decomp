typedef signed long LONG;
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

extern UWORD NEWGRID_ColumnStartXPx;
extern UWORD NEWGRID_ColumnWidthPx;
extern void *Global_REF_GRAPHICS_LIBRARY;

extern void NEWGRID_JMPTBL_GENERATE_GRID_DATE_STRING(char *outText);
extern void _LVOSetDrMd(char *rastPort, LONG mode);
extern LONG NEWGRID_SetRowColor(char *gridCtx, LONG mode, LONG pen);
extern void _LVOSetAPen(char *rastPort, LONG pen);
extern void _LVORectFill(char *rastPort, LONG x1, LONG y1, LONG x2, LONG y2);
extern void NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(char *rastPort, LONG x1, LONG y1, LONG x2, LONG y2);
extern LONG _LVOTextLength(char *rastPort, const char *text, LONG len);
extern void _LVOMove(char *rastPort, LONG x, LONG y);
extern void _LVOText(char *rastPort, const char *text, LONG len);

void NEWGRID_DrawDateBanner(char *gridCtx)
{
    char dateText[100];
    NEWGRID_Context *ctx;
    NEWGRID_RastPort *rast;
    const char *p;
    LONG dateLen;
    LONG xBase;
    LONG x;
    LONG y;
    UWORD fontH;

    (void)Global_REF_GRAPHICS_LIBRARY;

    ctx = (NEWGRID_Context *)gridCtx;
    rast = &ctx->rastPort;
    NEWGRID_JMPTBL_GENERATE_GRID_DATE_STRING(dateText);

    _LVOSetDrMd((char *)rast, 0);
    _LVOSetAPen((char *)rast, NEWGRID_SetRowColor(gridCtx, 0, 7));

    _LVORectFill((char *)rast, 0, 0, 695, 33);

    xBase = (LONG)(UWORD)NEWGRID_ColumnStartXPx;
    NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight((char *)rast, 0, 0, xBase + 35, 33);
    NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight((char *)rast, xBase + 36, 0, 695, 33);

    _LVOSetAPen((char *)rast, 3);

    p = dateText;
    while (*p != 0) {
        ++p;
    }
    dateLen = (LONG)(p - dateText);

    x = ((LONG)(UWORD)NEWGRID_ColumnWidthPx * 3) - _LVOTextLength((char *)rast, dateText, dateLen);
    if (x < 0) {
        x += 1;
    }
    x = xBase + (x >> 1) + 36;

    fontH = rast->font->ySize;
    y = 34 - (LONG)fontH;
    if (y < 0) {
        y += 1;
    }
    y = (y >> 1) + (LONG)fontH - 1;

    _LVOMove((char *)rast, x, y);
    _LVOText((char *)rast, dateText, dateLen);

    ctx->selectionCode = 17;
    ctx->selectedState = 17;
}
