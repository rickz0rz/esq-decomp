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
extern char TLIBA1_FMT_PCT_03LD_HorizontalScaleTick[];

extern LONG _LVOMove(void *gfxBase, void *rastPort, LONG x, LONG y);
extern LONG _LVODraw(void *gfxBase, void *rastPort, LONG x, LONG y);
extern LONG _LVOTextLength(void *gfxBase, void *rastPort, char *text, LONG len);
extern LONG _LVOText(void *gfxBase, void *rastPort, char *text, LONG len);
extern void WDISP_SPrintf(char *dst, const char *fmt, LONG value);
extern LONG MATH_Mulu32(LONG left, LONG right);

void TLIBA3_DrawHorizontalScaleTicks(TLIBA3_RastPortWrap *rp, LONG y)
{
    LONG labelBaseY;
    LONG maxX;
    LONG x;
    char buf[84];

    labelBaseY = y + 25;

    _LVOMove(Global_REF_GRAPHICS_LIBRARY, rp, 0, y);
    maxX = (((LONG)rp->dims->width) << 3) - 1;
    _LVODraw(Global_REF_GRAPHICS_LIBRARY, rp, maxX, y);

    for (x = 0; x < maxX; ++x) {
        if ((x % 25) == 0 && x != 0) {
            LONG len;
            LONG textWidth;
            LONG textX;
            LONG textY;
            char *p;

            _LVOMove(Global_REF_GRAPHICS_LIBRARY, rp, x, y);
            _LVODraw(Global_REF_GRAPHICS_LIBRARY, rp, x, y + 20);

            WDISP_SPrintf(buf, TLIBA1_FMT_PCT_03LD_HorizontalScaleTick, x);

            p = buf;
            while (*p != 0) {
                p += 1;
            }
            len = (LONG)(p - buf);

            textWidth = _LVOTextLength(Global_REF_GRAPHICS_LIBRARY, rp, buf, len);
            if (textWidth < 0) {
                textWidth += 1;
            }
            textX = x - (textWidth >> 1);
            textY = labelBaseY + MATH_Mulu32((x / 2), 10);

            _LVOMove(Global_REF_GRAPHICS_LIBRARY, rp, textX, textY);
            _LVOText(Global_REF_GRAPHICS_LIBRARY, rp, buf, len);
        } else if ((x % 5) == 0) {
            _LVOMove(Global_REF_GRAPHICS_LIBRARY, rp, x, y);
            _LVODraw(Global_REF_GRAPHICS_LIBRARY, rp, x, y + 10);
        }
    }
}
