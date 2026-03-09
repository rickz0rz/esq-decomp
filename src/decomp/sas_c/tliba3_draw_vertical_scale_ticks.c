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

#define TICK_ZERO 0
#define LABEL_X_OFFSET 25
#define MAX_Y_MINUS_ONE 1
#define LABEL_BUFFER_LEN 84
#define MAJOR_TICK_INTERVAL 10
#define MINOR_TICK_INTERVAL 5
#define MAJOR_TICK_WIDTH 20
#define MINOR_TICK_WIDTH 10
#define CHAR_ADVANCE 1

extern void *Global_REF_GRAPHICS_LIBRARY;
extern char TLIBA1_FMT_PCT_03LD_VerticalScaleTick[];

extern LONG _LVOMove(void *gfxBase, char *rastPort, LONG x, LONG y);
extern LONG _LVODraw(void *gfxBase, char *rastPort, LONG x, LONG y);
extern LONG _LVOText(void *gfxBase, char *rastPort, char *text, LONG len);
extern void WDISP_SPrintf(char *dst, const char *fmt, LONG value);

void TLIBA3_DrawVerticalScaleTicks(TLIBA3_RastPortWrap *rp, LONG x)
{
    LONG labelX;
    LONG maxY;
    LONG y;
    char buf[LABEL_BUFFER_LEN];

    labelX = x + LABEL_X_OFFSET;

    _LVOMove(Global_REF_GRAPHICS_LIBRARY, (char *)rp, x, TICK_ZERO);
    maxY = (LONG)rp->dims->height - MAX_Y_MINUS_ONE;
    _LVODraw(Global_REF_GRAPHICS_LIBRARY, (char *)rp, x, maxY);

    for (y = TICK_ZERO; y < maxY; ++y) {
        if ((y % MAJOR_TICK_INTERVAL) == TICK_ZERO && y != TICK_ZERO) {
            char *p;
            LONG len;

            _LVOMove(Global_REF_GRAPHICS_LIBRARY, (char *)rp, x, y);
            _LVODraw(Global_REF_GRAPHICS_LIBRARY, (char *)rp, x + MAJOR_TICK_WIDTH, y);
            _LVOMove(Global_REF_GRAPHICS_LIBRARY, (char *)rp, labelX, y);

            WDISP_SPrintf(buf, TLIBA1_FMT_PCT_03LD_VerticalScaleTick, y);

            p = buf;
            while (*p != TICK_ZERO) {
                p += CHAR_ADVANCE;
            }
            len = (LONG)(p - buf);
            _LVOText(Global_REF_GRAPHICS_LIBRARY, (char *)rp, buf, len);
        } else if ((y % MINOR_TICK_INTERVAL) == TICK_ZERO) {
            _LVOMove(Global_REF_GRAPHICS_LIBRARY, (char *)rp, x, y);
            _LVODraw(Global_REF_GRAPHICS_LIBRARY, (char *)rp, x + MINOR_TICK_WIDTH, y);
        }
    }
}
