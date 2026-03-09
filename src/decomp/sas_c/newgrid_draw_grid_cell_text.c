typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct NEWGRID_Font {
    UBYTE pad[26];
    UWORD ySize;
} NEWGRID_Font;

typedef struct NEWGRID_RastPort {
    UBYTE pad[52];
    NEWGRID_Font *font;
} NEWGRID_RastPort;

extern UWORD Global_WORD_SELECT_CODE_IS_RAVESC;
extern UWORD NEWGRID_SampleTimeTextWidthPx;
extern UWORD NEWGRID_RowHeightPx;
extern LONG NEWGRID_GridOperationId;
extern LONG GCOMMAND_NicheTextPen;
extern UBYTE CTASKS_STR_C;
extern void *Global_REF_GRAPHICS_LIBRARY;

extern char *PARSEINI_JMPTBL_STRING_AppendAtNull(char *dst, const char *src);
extern LONG _LVOSetAPen(void *gfx, void *rp, LONG pen);
extern LONG _LVOSetDrMd(void *gfx, void *rp, LONG mode);
extern LONG _LVOTextLength(void *gfx, void *rp, const char *text, LONG len);
extern LONG _LVOMove(void *gfx, void *rp, LONG x, LONG y);
extern LONG _LVOText(void *gfx, void *rp, const char *text, LONG len);

void NEWGRID_DrawGridCellText(NEWGRID_RastPort *rp, const char *primary, const char *secondary, LONG alignMode)
{
    char mergedSecondary[26];
    LONG baselineX;
    LONG rowHalfY;
    LONG primaryY;
    LONG secondaryY;
    LONG w;
    LONG n;
    LONG fontY;

    if (Global_WORD_SELECT_CODE_IS_RAVESC) {
        n = 0;
        while (secondary[n] != 0 && n < 23) {
            mergedSecondary[n] = secondary[n];
            n++;
        }
        mergedSecondary[n++] = '-';
        mergedSecondary[n] = 0;
        PARSEINI_JMPTBL_STRING_AppendAtNull(mergedSecondary, secondary + 2);
        secondary = mergedSecondary;
    }

    baselineX = ((LONG)NEWGRID_SampleTimeTextWidthPx + 1) >> 1;
    baselineX += 42;

    fontY = (LONG)rp->font->ySize;
    rowHalfY = ((LONG)NEWGRID_RowHeightPx + 1) >> 1;
    rowHalfY -= ((fontY + 1) >> 1);
    rowHalfY -= 4;
    rowHalfY = (rowHalfY + 1) >> 1;
    rowHalfY += fontY;

    primaryY = rowHalfY + 3;
    secondaryY = ((LONG)NEWGRID_RowHeightPx + 1) >> 1;
    if (alignMode == 0) {
        secondaryY -= fontY;
        secondaryY = (secondaryY + 1) >> 1;
        secondaryY += fontY;
        secondaryY -= 1;
    } else {
        secondaryY -= fontY;
        secondaryY -= 4;
        secondaryY = (secondaryY + 1) >> 1;
        secondaryY += fontY;
        secondaryY -= 1;
    }
    secondaryY += primaryY;

    if (NEWGRID_GridOperationId == 5) {
        _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rp, GCOMMAND_NicheTextPen);
    } else {
        _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rp, 3);
    }
    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, rp, 0);

    n = 0;
    while (primary[n] != 0) n++;
    while (n > 0 && primary[n - 1] == ' ') n--;
    if (n > 0) {
        w = _LVOTextLength(Global_REF_GRAPHICS_LIBRARY, rp, primary, n);
        w = (w + 1) >> 1;
        if (CTASKS_STR_C == 'S') {
            _LVOMove(Global_REF_GRAPHICS_LIBRARY, rp, primaryY, baselineX - w);
        } else {
            _LVOMove(Global_REF_GRAPHICS_LIBRARY, rp, secondaryY, baselineX - w);
        }
        _LVOText(Global_REF_GRAPHICS_LIBRARY, rp, primary, n);
    }

    n = 0;
    while (secondary[n] != 0) n++;
    while (n > 0 && secondary[n - 1] == ' ') n--;
    if (n > 0) {
        w = _LVOTextLength(Global_REF_GRAPHICS_LIBRARY, rp, secondary, n);
        w = (w + 1) >> 1;
        if (CTASKS_STR_C == 'S') {
            _LVOMove(Global_REF_GRAPHICS_LIBRARY, rp, secondaryY, baselineX - w);
        } else {
            _LVOMove(Global_REF_GRAPHICS_LIBRARY, rp, primaryY, baselineX - w);
        }
        _LVOText(Global_REF_GRAPHICS_LIBRARY, rp, secondary, n);
    }
}
