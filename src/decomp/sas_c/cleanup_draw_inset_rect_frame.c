#include <exec/types.h>

enum {
    RASTPORT_PEN_OFFSET = 25,          /* FgPen (restored at end) */
    RASTPORT_CP_X_OFFSET = 36,         /* cp_x */
    RASTPORT_CP_Y_OFFSET = 38,         /* cp_y */
    RASTPORT_TX_BASELINE_OFFSET = 62,  /* TxBaseline */
    INSET_LEFT_MARGIN = 2,
    INSET_RIGHT_MARGIN = 2,
    INSET_TOP_ADJUST = 2,
    INSET_BASELINE_ADJUST = 1
};

extern void *Global_REF_GRAPHICS_LIBRARY;

/* base-first _LVO ABI (gfxBase). SetAPen(A1=rp,D0=pen); RectFill(A1=rp,
   D0=xMin,D1=yMin,D2=xMax,D3=yMax); Move(A1=rp,D0=x,D1=y); Draw(A1=rp,D0=x,D1=y). */
void _LVOSetAPen(void *gfxBase, UBYTE *rp, LONG pen);
void _LVORectFill(void *gfxBase, UBYTE *rp, LONG xMin, LONG yMin, LONG xMax, LONG yMax);
void _LVOMove(void *gfxBase, UBYTE *rp, LONG x, LONG y);
void _LVODraw(void *gfxBase, UBYTE *rp, LONG x, LONG y);

void CLEANUP_DrawInsetRectFrame(UBYTE *rp, UBYTE pen, UWORD w, UWORD h)
{
    LONG cpX, cpY2;
    LONG x0, y0, x1, y1;
    LONG savedPen;

    savedPen = (LONG)rp[RASTPORT_PEN_OFFSET];
    cpX  = (LONG)*(UWORD *)(rp + RASTPORT_CP_X_OFFSET);
    cpY2 = (LONG)*(UWORD *)(rp + RASTPORT_CP_Y_OFFSET) + INSET_TOP_ADJUST;
    x0 = cpX - INSET_LEFT_MARGIN;
    y0 = cpY2 - (LONG)*(UWORD *)(rp + RASTPORT_TX_BASELINE_OFFSET) - INSET_BASELINE_ADJUST;
    x1 = x0 + (LONG)w + INSET_RIGHT_MARGIN;
    y1 = y0 + (LONG)h;

    /* Fill interior with the requested pen. */
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rp, (LONG)pen);
    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, rp, x0, y0, x1, y1);

    /* Outer bevel (pen 1): top + left highlight, two parallel strokes each. */
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rp, 1);
    _LVOMove(Global_REF_GRAPHICS_LIBRARY, rp, x0 - 2, y1 + 2);
    _LVODraw(Global_REF_GRAPHICS_LIBRARY, rp, x0 - 2, y0 - 2);
    _LVODraw(Global_REF_GRAPHICS_LIBRARY, rp, x1 + 2, y0 - 2);
    _LVOMove(Global_REF_GRAPHICS_LIBRARY, rp, x0 - 1, y1 + 1);
    _LVODraw(Global_REF_GRAPHICS_LIBRARY, rp, x0 - 1, y0 - 1);
    _LVODraw(Global_REF_GRAPHICS_LIBRARY, rp, x1 + 1, y0 - 1);

    /* Inner bevel (pen 2): bottom + right shadow, two parallel strokes each. */
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rp, 2);
    _LVOMove(Global_REF_GRAPHICS_LIBRARY, rp, x1 + 2, y0 - 1);
    _LVODraw(Global_REF_GRAPHICS_LIBRARY, rp, x1 + 2, y1 + 2);
    _LVODraw(Global_REF_GRAPHICS_LIBRARY, rp, x0 - 1, y1 + 2);
    _LVOMove(Global_REF_GRAPHICS_LIBRARY, rp, x1 + 1, y0);
    _LVODraw(Global_REF_GRAPHICS_LIBRARY, rp, x1 + 1, y1 + 1);
    _LVODraw(Global_REF_GRAPHICS_LIBRARY, rp, x0, y1 + 1);

    /* Restore the cursor position and pen the caller had set. */
    _LVOMove(Global_REF_GRAPHICS_LIBRARY, rp, cpX, cpY2);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rp, savedPen);
}
