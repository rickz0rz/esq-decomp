typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef long LONG;

enum {
    RASTPORT_PEN_OFFSET = 25,
    RASTPORT_CP_X_OFFSET = 36,
    RASTPORT_CP_Y_OFFSET = 38,
    RASTPORT_TX_BASELINE_OFFSET = 62,
    INSET_LEFT_MARGIN = 2,
    INSET_RIGHT_MARGIN = 2,
    INSET_TOP_ADJUST = 2,
    INSET_BASELINE_ADJUST = 1,
    ZERO = 0
};

extern LONG Global_REF_GRAPHICS_LIBRARY;

void _LVOSetAPen(void);
void _LVORectFill(void);
void _LVOMove(void);
void _LVODraw(void);

void CLEANUP_DrawInsetRectFrame(UBYTE *rp, UBYTE pen, UWORD w, UWORD h)
{
    LONG x0, y0;
    LONG x1, y1;
    LONG old_pen;

    old_pen = (LONG)rp[RASTPORT_PEN_OFFSET];
    x0 = (LONG)*(UWORD *)(rp + RASTPORT_CP_X_OFFSET) - INSET_LEFT_MARGIN;
    y0 = (LONG)(*(UWORD *)(rp + RASTPORT_CP_Y_OFFSET) + INSET_TOP_ADJUST -
                *(UWORD *)(rp + RASTPORT_TX_BASELINE_OFFSET) - INSET_BASELINE_ADJUST);
    x1 = x0 + (LONG)w + INSET_RIGHT_MARGIN;
    y1 = y0 + (LONG)h;

    _LVOSetAPen();
    _LVORectFill();

    _LVOSetAPen();
    _LVOMove();
    _LVODraw();
    _LVODraw();
    _LVOMove();
    _LVODraw();
    _LVODraw();

    _LVOSetAPen();
    _LVOMove();
    _LVODraw();
    _LVODraw();
    _LVOMove();
    _LVODraw();
    _LVODraw();

    (void)x1;
    (void)y1;
    (void)ZERO;
    _LVOMove();

    (void)old_pen;
    _LVOSetAPen();
}
