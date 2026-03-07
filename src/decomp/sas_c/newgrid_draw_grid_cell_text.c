typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct RastPortLike {
    UBYTE pad[52];
    UWORD txHeight;
} RastPortLike;

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

static LONG trim_len(const char *s)
{
    LONG n = 0;
    while (s[n] != 0) n++;
    while (n > 0 && s[n - 1] == ' ') n--;
    return n;
}

void NEWGRID_DrawGridCellText(RastPortLike *rp, const char *primary, const char *secondary, LONG alignMode)
{
    char mergedSecondary[26];
    LONG baseX;
    LONG centerX;
    LONG yPrimary;
    LONG ySecondary;
    LONG w;
    LONG n;

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

    baseX = ((LONG)NEWGRID_SampleTimeTextWidthPx + 1) >> 1;
    baseX += 42;

    centerX = ((LONG)NEWGRID_RowHeightPx + 1) >> 1;
    centerX -= ((LONG)rp->txHeight + 1) >> 1;
    centerX -= 4;
    centerX = (centerX + 1) >> 1;
    centerX += rp->txHeight;

    yPrimary = centerX + 3;
    ySecondary = yPrimary + (((LONG)NEWGRID_RowHeightPx + 1) >> 1);

    if (NEWGRID_GridOperationId == 5) {
        _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rp, GCOMMAND_NicheTextPen);
    } else {
        _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rp, 3);
    }
    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, rp, 0);

    n = trim_len(primary);
    if (n > 0) {
        w = _LVOTextLength(Global_REF_GRAPHICS_LIBRARY, rp, primary, n);
        w = (w + 1) >> 1;
        if (CTASKS_STR_C == 'S') {
            _LVOMove(Global_REF_GRAPHICS_LIBRARY, rp, yPrimary, baseX - w);
        } else {
            _LVOMove(Global_REF_GRAPHICS_LIBRARY, rp, centerX, baseX - w);
        }
        _LVOText(Global_REF_GRAPHICS_LIBRARY, rp, primary, n);
    }

    n = trim_len(secondary);
    if (n > 0) {
        w = _LVOTextLength(Global_REF_GRAPHICS_LIBRARY, rp, secondary, n);
        w = (w + 1) >> 1;
        if (CTASKS_STR_C == 'S') {
            _LVOMove(Global_REF_GRAPHICS_LIBRARY, rp, centerX, baseX - w);
        } else {
            _LVOMove(Global_REF_GRAPHICS_LIBRARY, rp, ySecondary, baseX - w);
        }
        _LVOText(Global_REF_GRAPHICS_LIBRARY, rp, secondary, n);
    }

    (void)alignMode;
}
