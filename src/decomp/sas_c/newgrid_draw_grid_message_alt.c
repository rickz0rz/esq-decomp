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

extern LONG GCOMMAND_PpvMessageTextPen;
extern LONG GCOMMAND_PpvMessageFramePen;
extern char *GCOMMAND_PPVPeriodTemplatePtr;
extern UWORD NEWGRID_ColumnStartXPx;
extern UWORD NEWGRID_ColumnWidthPx;

extern LONG NEWGRID_DrawGridFrame(char *rastPort, LONG style, LONG penA, LONG penB, LONG rowHeight);
extern void NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(char *rastPort, LONG x1, LONG y1, LONG x2, LONG y2);
extern void _LVOSetAPen(char *rastPort, LONG pen);
extern void _LVOSetDrMd(char *rastPort, LONG mode);
extern LONG _LVOTextLength(char *rastPort, const char *text, LONG len);
extern void _LVOMove(char *rastPort, LONG x, LONG y);
extern void _LVOText(char *rastPort, const char *text, LONG len);
extern void NEWGRID_ValidateSelectionCode(char *rastPort, LONG code);

void NEWGRID_DrawGridMessageAlt(char *gridCtx)
{
    NEWGRID_Context *ctx;
    NEWGRID_RastPort *rastPort;
    const char *msg;
    const char *scan;
    LONG len;
    LONG width;
    LONG x;
    LONG y;
    LONG fh;

    ctx = (NEWGRID_Context *)gridCtx;
    rastPort = &ctx->rastPort;

    NEWGRID_DrawGridFrame(gridCtx, 7, GCOMMAND_PpvMessageFramePen, GCOMMAND_PpvMessageFramePen, 33);

    NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(
        (char *)rastPort, 0, 0, (LONG)(UWORD)NEWGRID_ColumnStartXPx + 35, 33
    );
    NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(
        (char *)rastPort, 0, 695, (LONG)(UWORD)NEWGRID_ColumnStartXPx + 36, 33
    );

    _LVOSetAPen((char *)rastPort, GCOMMAND_PpvMessageTextPen);
    _LVOSetDrMd((char *)rastPort, 0);

    msg = GCOMMAND_PPVPeriodTemplatePtr;
    scan = msg;
    len = 0;
    while (*scan++ != 0) {
        ++len;
    }

    while (len > 0) {
        width = _LVOTextLength((char *)rastPort, msg, len);
        if (width <= ((LONG)(UWORD)NEWGRID_ColumnWidthPx * 3) - 12) {
            break;
        }
        --len;
    }

    width = _LVOTextLength((char *)rastPort, msg, len);
    x = ((LONG)(UWORD)NEWGRID_ColumnWidthPx * 3) - width;
    if (x < 0) {
        ++x;
    }
    x = ((LONG)(UWORD)NEWGRID_ColumnStartXPx) + (x >> 1) + 36;

    fh = (LONG)(UWORD)rastPort->font->ySize;
    y = 34 - fh;
    if (y < 0) {
        ++y;
    }
    y = (y >> 1) + fh - 1;

    _LVOMove((char *)rastPort, x, y);
    _LVOText((char *)rastPort, msg, len);

    ctx->selectionCode = 17;
    ctx->selectedState = 17;
    NEWGRID_ValidateSelectionCode(gridCtx, 66);
}
