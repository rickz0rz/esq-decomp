typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern UBYTE *SCRIPT_PtrMovieSummaryForPrefix;
extern UWORD NEWGRID_ColumnStartXPx;
extern UWORD NEWGRID_ColumnWidthPx;

extern void NEWGRID_DrawGridFrame(void *gridCtx, LONG mode, LONG firstPen, LONG secondPen, LONG yMax);
extern void NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry(LONG slot, UBYTE *out_text);
extern void PARSEINI_JMPTBL_STRING_AppendAtNull(UBYTE *dst, UBYTE *src);
extern void NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(void *rastPort, LONG x1, LONG y1, LONG x2, LONG y2);
extern void _LVOSetAPen(void *rastPort, LONG pen);
extern void _LVOSetDrMd(void *rastPort, LONG mode);
extern LONG _LVOTextLength(void *rastPort, UBYTE *text, LONG len);
extern void _LVOMove(void *rastPort, LONG x, LONG y);
extern void _LVOText(void *rastPort, UBYTE *text, LONG len);
extern void NEWGRID_ValidateSelectionCode(void *gridCtx, LONG code);

void NEWGRID_DrawEmptyGridMessage(UBYTE *gridCtx, UWORD slot)
{
    UBYTE banner[128];
    UBYTE slot_text[31];
    UBYTE *src;
    UBYTE *dst;
    UBYTE *rast;
    UBYTE *font;
    LONG len;
    LONG text_w;
    LONG x;
    LONG y;

    NEWGRID_DrawGridFrame(gridCtx, 7, 6, 6, 33);

    src = SCRIPT_PtrMovieSummaryForPrefix;
    dst = banner;
    while ((*dst++ = *src++) != 0) {
    }

    NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry((LONG)slot, slot_text);
    PARSEINI_JMPTBL_STRING_AppendAtNull(banner, slot_text);

    rast = gridCtx + 60;
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

    font = *(UBYTE **)(gridCtx + 112);
    y = 34 - (LONG)(UWORD)(*(UWORD *)(font + 26));
    if (y < 0) {
        ++y;
    }
    y = (y >> 1) + (LONG)(UWORD)(*(UWORD *)(font + 26)) - 1;

    _LVOMove(rast, x, y);
    _LVOText(rast, banner, len);

    *(UWORD *)(gridCtx + 52) = 17;
    *(LONG *)(gridCtx + 32) = 17;
    NEWGRID_ValidateSelectionCode(gridCtx, 65);
}
