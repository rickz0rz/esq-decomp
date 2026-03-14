#include <graphics/rastport.h>
#include <graphics/text.h>

typedef struct NEWGRID_Context {
    UBYTE pad0[32];
    LONG selectedState;
    UBYTE pad1[18];
    UWORD selectionCode;
    UBYTE pad2[6];
    struct RastPort rastPort;
} NEWGRID_Context;

extern const char *SCRIPT_PtrMovieSummaryForPrefix;
extern UWORD NEWGRID_ColumnStartXPx;
extern UWORD NEWGRID_ColumnWidthPx;

extern void NEWGRID_DrawGridFrame(char *gridCtx, LONG mode, LONG firstPen, LONG secondPen, LONG yMax);
extern void CLEANUP_FormatClockFormatEntry(LONG slot, char *out_text);
extern char *STRING_AppendAtNull(char *dst, const char *src);
extern void BEVEL_DrawBevelFrameWithTopRight(char *rastPort, LONG x1, LONG y1, LONG x2, LONG y2);
extern void _LVOSetAPen(char *rastPort, LONG pen);
extern void _LVOSetDrMd(char *rastPort, LONG mode);
extern LONG _LVOTextLength(char *rastPort, const char *text, LONG len);
extern void _LVOMove(char *rastPort, LONG x, LONG y);
extern void _LVOText(char *rastPort, const char *text, LONG len);
extern void NEWGRID_ValidateSelectionCode(char *gridCtx, LONG code);

void NEWGRID_DrawEmptyGridMessage(char *gridCtx, UWORD slot)
{
    NEWGRID_Context *ctx;
    char banner[128];
    char slot_text[31];
    const char *src;
    const char *scan;
    char *dst;
    struct RastPort *rast;
    LONG len;
    LONG text_w;
    LONG x;
    LONG y;

    ctx = (NEWGRID_Context *)gridCtx;
    NEWGRID_DrawGridFrame(gridCtx, 7, 6, 6, 33);

    src = SCRIPT_PtrMovieSummaryForPrefix;
    dst = banner;
    while ((*dst++ = *src++) != 0) {
    }

    CLEANUP_FormatClockFormatEntry((LONG)slot, slot_text);
    STRING_AppendAtNull(banner, slot_text);

    rast = &ctx->rastPort;
    BEVEL_DrawBevelFrameWithTopRight(
        (char *)rast, 0, 0, (LONG)(UWORD)NEWGRID_ColumnStartXPx + 35, 33
    );
    BEVEL_DrawBevelFrameWithTopRight(
        (char *)rast, (LONG)(UWORD)NEWGRID_ColumnStartXPx + 36, 0, 695, 33
    );

    _LVOSetAPen((char *)rast, 3);
    _LVOSetDrMd((char *)rast, 0);

    scan = banner;
    len = 0;
    while (*scan++ != 0) {
        ++len;
    }

    text_w = _LVOTextLength((char *)rast, banner, len);
    x = ((LONG)(UWORD)NEWGRID_ColumnWidthPx * 3) - text_w;
    if (x < 0) {
        ++x;
    }
    x = ((LONG)(UWORD)NEWGRID_ColumnStartXPx) + (x >> 1) + 36;

    y = 34 - (LONG)rast->Font->tf_YSize;
    if (y < 0) {
        ++y;
    }
    y = (y >> 1) + (LONG)rast->Font->tf_YSize - 1;

    _LVOMove((char *)rast, x, y);
    _LVOText((char *)rast, banner, len);

    ctx->selectionCode = 17;
    ctx->selectedState = 17;
    NEWGRID_ValidateSelectionCode(gridCtx, 65);
}
