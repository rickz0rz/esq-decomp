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

extern UBYTE *SCRIPT_PtrMovieSummaryForPrefix;
extern UWORD NEWGRID_ColumnStartXPx;
extern UWORD NEWGRID_ColumnWidthPx;

extern void NEWGRID_DrawGridFrame(void *gridCtx, LONG mode, LONG firstPen, LONG secondPen, LONG yMax);
extern void NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry(LONG slot, char *out_text);
extern void PARSEINI_JMPTBL_STRING_AppendAtNull(char *dst, char *src);
extern void NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(void *rastPort, LONG x1, LONG y1, LONG x2, LONG y2);
extern void _LVOSetAPen(void *rastPort, LONG pen);
extern void _LVOSetDrMd(void *rastPort, LONG mode);
extern LONG _LVOTextLength(void *rastPort, char *text, LONG len);
extern void _LVOMove(void *rastPort, LONG x, LONG y);
extern void _LVOText(void *rastPort, char *text, LONG len);
extern void NEWGRID_ValidateSelectionCode(void *gridCtx, LONG code);

void NEWGRID_DrawEmptyGridMessage(UBYTE *gridCtx, UWORD slot)
{
    NEWGRID_Context *ctx;
    char banner[128];
    char slot_text[31];
    char *src;
    char *dst;
    NEWGRID_RastPort *rast;
    LONG len;
    LONG text_w;
    LONG x;
    LONG y;

    ctx = (NEWGRID_Context *)gridCtx;
    NEWGRID_DrawGridFrame(gridCtx, 7, 6, 6, 33);

    src = (char *)SCRIPT_PtrMovieSummaryForPrefix;
    dst = banner;
    while ((*dst++ = *src++) != 0) {
    }

    NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry((LONG)slot, slot_text);
    PARSEINI_JMPTBL_STRING_AppendAtNull(banner, slot_text);

    rast = &ctx->rastPort;
    NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(
        rast, 0, 0, (LONG)(UWORD)NEWGRID_ColumnStartXPx + 35, 33
    );
    NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(
        rast, (LONG)(UWORD)NEWGRID_ColumnStartXPx + 36, 0, 695, 33
    );

    _LVOSetAPen(rast, 3);
    _LVOSetDrMd(rast, 0);

    len = 0;
    while (banner[len] != 0) {
        ++len;
    }

    text_w = _LVOTextLength(rast, banner, len);
    x = ((LONG)(UWORD)NEWGRID_ColumnWidthPx * 3) - text_w;
    if (x < 0) {
        ++x;
    }
    x = ((LONG)(UWORD)NEWGRID_ColumnStartXPx) + (x >> 1) + 36;

    y = 34 - (LONG)rast->font->ySize;
    if (y < 0) {
        ++y;
    }
    y = (y >> 1) + (LONG)rast->font->ySize - 1;

    _LVOMove(rast, x, y);
    _LVOText(rast, banner, len);

    ctx->selectionCode = 17;
    ctx->selectedState = 17;
    NEWGRID_ValidateSelectionCode(gridCtx, 65);
}
