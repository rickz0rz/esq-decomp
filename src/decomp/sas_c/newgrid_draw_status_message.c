typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern LONG GCOMMAND_MplexMessageFramePen;
extern LONG GCOMMAND_MplexMessageTextPen;
extern UBYTE *GCOMMAND_MplexAtTemplatePtr;
extern UWORD NEWGRID_ColumnStartXPx;
extern UWORD NEWGRID_ColumnWidthPx;

extern void NEWGRID_DrawGridFrame(void *gridCtx, LONG mode, LONG firstPen, LONG secondPen, LONG yMax);
extern void NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry(LONG slot, UBYTE *out_text);
extern UBYTE *NEWGRID2_JMPTBL_STR_SkipClass3Chars(UBYTE *s);
extern void PARSEINI_JMPTBL_WDISP_SPrintf(UBYTE *dst, UBYTE *fmt, UBYTE *arg);
extern void NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(void *rastPort, LONG x1, LONG y1, LONG x2, LONG y2);
extern void _LVOSetAPen(void *rastPort, LONG pen);
extern void _LVOSetDrMd(void *rastPort, LONG mode);
extern LONG _LVOTextLength(void *rastPort, UBYTE *text, LONG len);
extern void _LVOMove(void *rastPort, LONG x, LONG y);
extern void _LVOText(void *rastPort, UBYTE *text, LONG len);
extern void NEWGRID_ValidateSelectionCode(void *gridCtx, LONG code);

void NEWGRID_DrawStatusMessage(UBYTE *gridCtx, UWORD slot)
{
    UBYTE text_buf[132];
    UBYTE slot_text[31];
    UBYTE *msg;
    UBYTE *rast;
    UBYTE *font;
    LONG len;
    LONG width;
    LONG x;
    LONG y;

    NEWGRID_DrawGridFrame(gridCtx, 7, GCOMMAND_MplexMessageFramePen, GCOMMAND_MplexMessageFramePen, 33);

    NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry((LONG)slot, slot_text);
    msg = NEWGRID2_JMPTBL_STR_SkipClass3Chars(slot_text);
    PARSEINI_JMPTBL_WDISP_SPrintf(text_buf, GCOMMAND_MplexAtTemplatePtr, msg);

    rast = gridCtx + 60;
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

    font = *(UBYTE **)(gridCtx + 112);
    y = 34 - (LONG)(UWORD)(*(UWORD *)(font + 26));
    if (y < 0) {
        ++y;
    }
    y = (y >> 1) + (LONG)(UWORD)(*(UWORD *)(font + 26)) - 1;

    _LVOMove(rast, x, y);
    _LVOText(rast, text_buf, len);

    *(UWORD *)(gridCtx + 52) = 17;
    *(LONG *)(gridCtx + 32) = 17;
    NEWGRID_ValidateSelectionCode(gridCtx, 66);
}
