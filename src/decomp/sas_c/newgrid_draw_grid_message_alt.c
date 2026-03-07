typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern LONG GCOMMAND_PpvMessageTextPen;
extern LONG GCOMMAND_PpvMessageFramePen;
extern UBYTE *GCOMMAND_PPVPeriodTemplatePtr;
extern UWORD NEWGRID_ColumnStartXPx;
extern UWORD NEWGRID_ColumnWidthPx;

extern LONG NEWGRID_DrawGridFrame();
extern void NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight();
extern void _LVOSetAPen(void *rastPort, LONG pen);
extern void _LVOSetDrMd(void *rastPort, LONG mode);
extern LONG _LVOTextLength(void *rastPort, UBYTE *text, LONG len);
extern void _LVOMove(void *rastPort, LONG x, LONG y);
extern void _LVOText(void *rastPort, UBYTE *text, LONG len);
extern void NEWGRID_ValidateSelectionCode(void *rastPort, LONG code);

void NEWGRID_DrawGridMessageAlt(UBYTE *rastPort)
{
    UBYTE *msg;
    LONG len;
    LONG width;
    LONG x;
    LONG y;
    UBYTE *font;
    LONG fh;

    NEWGRID_DrawGridFrame(rastPort, 7, GCOMMAND_PpvMessageFramePen, GCOMMAND_PpvMessageFramePen, 33);

    NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(
        rastPort + 60, 0, 0, (LONG)(UWORD)NEWGRID_ColumnStartXPx + 35, 33
    );
    NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(
        rastPort + 60, 0, 695, (LONG)(UWORD)NEWGRID_ColumnStartXPx + 36, 33
    );

    _LVOSetAPen(rastPort + 60, GCOMMAND_PpvMessageTextPen);
    _LVOSetDrMd(rastPort + 60, 0);

    msg = GCOMMAND_PPVPeriodTemplatePtr;
    len = 0;
    while (msg[len] != 0) {
        ++len;
    }

    while (len > 0) {
        width = _LVOTextLength(rastPort + 60, msg, len);
        if (width <= ((LONG)(UWORD)NEWGRID_ColumnWidthPx * 3) - 12) {
            break;
        }
        --len;
    }

    width = _LVOTextLength(rastPort + 60, msg, len);
    x = ((LONG)(UWORD)NEWGRID_ColumnWidthPx * 3) - width;
    if (x < 0) {
        ++x;
    }
    x = ((LONG)(UWORD)NEWGRID_ColumnStartXPx) + (x >> 1) + 36;

    font = *(UBYTE **)(rastPort + 112);
    fh = (LONG)(UWORD)(*(UWORD *)(font + 26));
    y = 34 - fh;
    if (y < 0) {
        ++y;
    }
    y = (y >> 1) + fh - 1;

    _LVOMove(rastPort + 60, x, y);
    _LVOText(rastPort + 60, msg, len);

    *(UWORD *)(rastPort + 52) = 17;
    *(LONG *)(rastPort + 32) = 17;
    NEWGRID_ValidateSelectionCode(rastPort, 66);
}
