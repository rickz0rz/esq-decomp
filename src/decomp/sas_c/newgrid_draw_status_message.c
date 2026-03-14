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

extern LONG GCOMMAND_MplexMessageFramePen;
extern LONG GCOMMAND_MplexMessageTextPen;
extern char *GCOMMAND_MplexAtTemplatePtr;
extern UWORD NEWGRID_ColumnStartXPx;
extern UWORD NEWGRID_ColumnWidthPx;

extern void NEWGRID_DrawGridFrame(char *gridCtx, LONG mode, LONG firstPen, LONG secondPen, LONG yMax);
extern void CLEANUP_FormatClockFormatEntry(LONG slot, char *out_text);
extern char *NEWGRID2_JMPTBL_STR_SkipClass3Chars(const char *s);
extern LONG PARSEINI_JMPTBL_WDISP_SPrintf(char *dst, const char *fmt, const char *arg);
extern void BEVEL_DrawBevelFrameWithTopRight(char *rastPort, LONG x1, LONG y1, LONG x2, LONG y2);
extern void _LVOSetAPen(char *rastPort, LONG pen);
extern void _LVOSetDrMd(char *rastPort, LONG mode);
extern LONG _LVOTextLength(char *rastPort, const char *text, LONG len);
extern void _LVOMove(char *rastPort, LONG x, LONG y);
extern void _LVOText(char *rastPort, const char *text, LONG len);
extern void NEWGRID_ValidateSelectionCode(char *gridCtx, LONG code);

void NEWGRID_DrawStatusMessage(char *gridCtx, UWORD slot)
{
    NEWGRID_Context *ctx;
    char text_buf[132];
    char slot_text[31];
    const char *msg;
    struct RastPort *rast;
    const char *scan;
    LONG len;
    LONG width;
    LONG x;
    LONG y;

    ctx = (NEWGRID_Context *)gridCtx;
    NEWGRID_DrawGridFrame(gridCtx, 7, GCOMMAND_MplexMessageFramePen, GCOMMAND_MplexMessageFramePen, 33);

    CLEANUP_FormatClockFormatEntry((LONG)slot, slot_text);
    msg = NEWGRID2_JMPTBL_STR_SkipClass3Chars(slot_text);
    PARSEINI_JMPTBL_WDISP_SPrintf(text_buf, GCOMMAND_MplexAtTemplatePtr, msg);

    rast = &ctx->rastPort;
    BEVEL_DrawBevelFrameWithTopRight(
        (char *)rast, 0, 0, (LONG)(UWORD)NEWGRID_ColumnStartXPx + 35, 33
    );
    BEVEL_DrawBevelFrameWithTopRight(
        (char *)rast, (LONG)(UWORD)NEWGRID_ColumnStartXPx + 36, 0, 695, 33
    );

    _LVOSetAPen((char *)rast, GCOMMAND_MplexMessageTextPen);
    _LVOSetDrMd((char *)rast, 0);

    scan = text_buf;
    len = 0;
    while (*scan++ != 0) {
        ++len;
    }

    while (len > 0) {
        width = _LVOTextLength((char *)rast, text_buf, len);
        if (width <= ((LONG)(UWORD)NEWGRID_ColumnWidthPx * 3) - 12) {
            break;
        }
        --len;
    }

    width = _LVOTextLength((char *)rast, text_buf, len);
    x = ((LONG)(UWORD)NEWGRID_ColumnWidthPx * 3) - width;
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
    _LVOText((char *)rast, text_buf, len);

    ctx->selectionCode = 17;
    ctx->selectedState = 17;
    NEWGRID_ValidateSelectionCode(gridCtx, 66);
}
