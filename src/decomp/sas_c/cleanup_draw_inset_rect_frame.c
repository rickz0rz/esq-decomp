typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef long LONG;

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

    old_pen = (LONG)rp[25];
    x0 = (LONG)*(UWORD *)(rp + 36) - 2;
    y0 = (LONG)(*(UWORD *)(rp + 38) + 2 - *(UWORD *)(rp + 62) - 1);
    x1 = x0 + (LONG)w + 2;
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
    _LVOMove();

    (void)old_pen;
    _LVOSetAPen();
}
