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

enum {
    TICK_ZERO = 0,
    LABEL_X_OFFSET = 25,
    MAX_Y_MINUS_ONE = 1,
    LABEL_BUFFER_LEN = 84,
    MAJOR_TICK_INTERVAL = 10,
    MINOR_TICK_INTERVAL = 5,
    MAJOR_TICK_WIDTH = 20,
    MINOR_TICK_WIDTH = 10,
    CHAR_ADVANCE = 1
};

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
    char buf[LABEL_BUFFER_LEN];

    labelX = x + LABEL_X_OFFSET;

    _LVOMove(Global_REF_GRAPHICS_LIBRARY, rp, x, TICK_ZERO);
    maxY = (LONG)rp->dims->height - MAX_Y_MINUS_ONE;
    _LVODraw(Global_REF_GRAPHICS_LIBRARY, rp, x, maxY);

    for (y = TICK_ZERO; y < maxY; ++y) {
        if ((y % MAJOR_TICK_INTERVAL) == TICK_ZERO && y != TICK_ZERO) {
            char *p;
            LONG len;

            _LVOMove(Global_REF_GRAPHICS_LIBRARY, rp, x, y);
            _LVODraw(Global_REF_GRAPHICS_LIBRARY, rp, x + MAJOR_TICK_WIDTH, y);
            _LVOMove(Global_REF_GRAPHICS_LIBRARY, rp, labelX, y);

            WDISP_SPrintf(buf, TLIBA1_FMT_PCT_03LD_VerticalScaleTick, y);

            p = buf;
            while (*p != TICK_ZERO) {
                p += CHAR_ADVANCE;
            }
            len = (LONG)(p - buf);
            _LVOText(Global_REF_GRAPHICS_LIBRARY, rp, buf, len);
        } else if ((y % MINOR_TICK_INTERVAL) == TICK_ZERO) {
            _LVOMove(Global_REF_GRAPHICS_LIBRARY, rp, x, y);
            _LVODraw(Global_REF_GRAPHICS_LIBRARY, rp, x + MINOR_TICK_WIDTH, y);
        }
    }
}
