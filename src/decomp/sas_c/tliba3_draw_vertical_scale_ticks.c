typedef signed long LONG;
typedef unsigned short UWORD;

typedef struct TLIBA3_DimBlock {
    UWORD width;
    UWORD height;
} TLIBA3_DimBlock;

typedef struct TLIBA3_RastPortWrap {
    void *unused0;
    TLIBA3_DimBlock *dims;
} TLIBA3_RastPortWrap;

extern void *Global_REF_GRAPHICS_LIBRARY;
extern char TLIBA1_FMT_PCT_03LD_VerticalScaleTick[];

extern LONG _LVOMove(void *gfxBase, void *rastPort, LONG x, LONG y);
extern LONG _LVODraw(void *gfxBase, void *rastPort, LONG x, LONG y);
extern LONG _LVOText(void *gfxBase, void *rastPort, char *text, LONG len);
extern void WDISP_SPrintf(char *dst, const char *fmt, LONG value);

void TLIBA3_DrawVerticalScaleTicks(TLIBA3_RastPortWrap *rp, LONG x)
{
    LONG labelX;
    LONG maxY;
    LONG y;
    char buf[84];

    labelX = x + 25;

    _LVOMove(Global_REF_GRAPHICS_LIBRARY, rp, x, 0);
    maxY = (LONG)rp->dims->height - 1;
    _LVODraw(Global_REF_GRAPHICS_LIBRARY, rp, x, maxY);

    for (y = 0; y < maxY; ++y) {
        if ((y % 10) == 0 && y != 0) {
            char *p;
            LONG len;

            _LVOMove(Global_REF_GRAPHICS_LIBRARY, rp, x, y);
            _LVODraw(Global_REF_GRAPHICS_LIBRARY, rp, x + 20, y);
            _LVOMove(Global_REF_GRAPHICS_LIBRARY, rp, labelX, y);

            WDISP_SPrintf(buf, TLIBA1_FMT_PCT_03LD_VerticalScaleTick, y);

            p = buf;
            while (*p != 0) {
                p += 1;
            }
            len = (LONG)(p - buf);
            _LVOText(Global_REF_GRAPHICS_LIBRARY, rp, buf, len);
        } else if ((y % 5) == 0) {
            _LVOMove(Global_REF_GRAPHICS_LIBRARY, rp, x, y);
            _LVODraw(Global_REF_GRAPHICS_LIBRARY, rp, x + 10, y);
        }
    }
}
