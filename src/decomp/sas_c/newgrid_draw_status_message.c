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

extern LONG GCOMMAND_MplexMessageFramePen;
extern LONG GCOMMAND_MplexMessageTextPen;
extern char *GCOMMAND_MplexAtTemplatePtr;
extern UWORD NEWGRID_ColumnStartXPx;
extern UWORD NEWGRID_ColumnWidthPx;

extern void NEWGRID_DrawGridFrame(void *gridCtx, LONG mode, LONG firstPen, LONG secondPen, LONG yMax);
extern void NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry(LONG slot, char *out_text);
extern char *NEWGRID2_JMPTBL_STR_SkipClass3Chars(char *s);
extern void PARSEINI_JMPTBL_WDISP_SPrintf(char *dst, char *fmt, char *arg);
extern void NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(void *rastPort, LONG x1, LONG y1, LONG x2, LONG y2);
extern void _LVOSetAPen(void *rastPort, LONG pen);
extern void _LVOSetDrMd(void *rastPort, LONG mode);
extern LONG _LVOTextLength(void *rastPort, char *text, LONG len);
extern void _LVOMove(void *rastPort, LONG x, LONG y);
extern void _LVOText(void *rastPort, char *text, LONG len);
extern void NEWGRID_ValidateSelectionCode(void *gridCtx, LONG code);

void NEWGRID_DrawStatusMessage(char *gridCtx, UWORD slot)
{
    NEWGRID_Context *ctx;
    char text_buf[132];
    char slot_text[31];
    char *msg;
    NEWGRID_RastPort *rast;
    LONG len;
    LONG width;
    LONG x;
    LONG y;

    ctx = (NEWGRID_Context *)gridCtx;
    NEWGRID_DrawGridFrame(gridCtx, 7, GCOMMAND_MplexMessageFramePen, GCOMMAND_MplexMessageFramePen, 33);

    NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry((LONG)slot, slot_text);
    msg = NEWGRID2_JMPTBL_STR_SkipClass3Chars(slot_text);
    PARSEINI_JMPTBL_WDISP_SPrintf(text_buf, GCOMMAND_MplexAtTemplatePtr, msg);

    rast = &ctx->rastPort;
    NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(
        rast, 0, 0, (LONG)(UWORD)NEWGRID_ColumnStartXPx + 35, 33
    );
    NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(
        rast, (LONG)(UWORD)NEWGRID_ColumnStartXPx + 36, 0, 695, 33
    );

    _LVOSetAPen(rast, GCOMMAND_MplexMessageTextPen);
    _LVOSetDrMd(rast, 0);

    len = 0;
    while (text_buf[len] != 0) {
        ++len;
    }

    while (len > 0) {
        width = _LVOTextLength(rast, text_buf, len);
        if (width <= ((LONG)(UWORD)NEWGRID_ColumnWidthPx * 3) - 12) {
            break;
        }
        --len;
    }

    width = _LVOTextLength(rast, text_buf, len);
    x = ((LONG)(UWORD)NEWGRID_ColumnWidthPx * 3) - width;
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
    _LVOText(rast, text_buf, len);

    ctx->selectionCode = 17;
    ctx->selectedState = 17;
    NEWGRID_ValidateSelectionCode(gridCtx, 66);
}
