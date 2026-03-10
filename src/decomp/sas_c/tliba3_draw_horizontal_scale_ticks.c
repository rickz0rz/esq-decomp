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
#define LABEL_BASE_Y_OFFSET 25
#define WIDTH_TO_PIXEL_SHIFT 3
#define MAX_X_MINUS_ONE 1
#define LABEL_BUFFER_LEN 84
#define MAJOR_TICK_INTERVAL 25
#define MINOR_TICK_INTERVAL 5
#define MAJOR_TICK_HEIGHT 20
#define MINOR_TICK_HEIGHT 10
#define TEXTWIDTH_NEG_ADJUST 1
#define HALF_DIVISOR 2
#define LABEL_Y_SCALE 10

extern void *Global_REF_GRAPHICS_LIBRARY;
extern const char TLIBA1_FMT_PCT_03LD_HorizontalScaleTick[];

extern LONG _LVOMove(void *gfxBase, char *rastPort, LONG x, LONG y);
extern LONG _LVODraw(void *gfxBase, char *rastPort, LONG x, LONG y);
extern LONG _LVOTextLength(void *gfxBase, char *rastPort, const char *text, LONG len);
extern LONG _LVOText(void *gfxBase, char *rastPort, const char *text, LONG len);
extern LONG WDISP_SPrintf(char *dst, const char *fmt, LONG value);
extern LONG MATH_Mulu32(LONG left, LONG right);

void TLIBA3_DrawHorizontalScaleTicks(TLIBA3_RastPortWrap *rp, LONG y)
{
    LONG labelBaseY;
    LONG maxX;
    LONG x;
    char buf[LABEL_BUFFER_LEN];

    labelBaseY = y + LABEL_BASE_Y_OFFSET;

    _LVOMove(Global_REF_GRAPHICS_LIBRARY, (char *)rp, TICK_ZERO, y);
    maxX = (((LONG)rp->dims->width) << WIDTH_TO_PIXEL_SHIFT) - MAX_X_MINUS_ONE;
    _LVODraw(Global_REF_GRAPHICS_LIBRARY, (char *)rp, maxX, y);

    for (x = TICK_ZERO; x < maxX; ++x) {
        if ((x % MAJOR_TICK_INTERVAL) == TICK_ZERO && x != TICK_ZERO) {
            LONG len;
            LONG textWidth;
            LONG textX;
            LONG textY;
            char *p;

            _LVOMove(Global_REF_GRAPHICS_LIBRARY, (char *)rp, x, y);
            _LVODraw(Global_REF_GRAPHICS_LIBRARY, (char *)rp, x, y + MAJOR_TICK_HEIGHT);

            WDISP_SPrintf(buf, TLIBA1_FMT_PCT_03LD_HorizontalScaleTick, x);

            p = buf;
            while (*p != TICK_ZERO) {
                p += TEXTWIDTH_NEG_ADJUST;
            }
            len = (LONG)(p - buf);

            textWidth = _LVOTextLength(Global_REF_GRAPHICS_LIBRARY, (char *)rp, buf, len);
            if (textWidth < TICK_ZERO) {
                textWidth += TEXTWIDTH_NEG_ADJUST;
            }
            textX = x - (textWidth >> MAX_X_MINUS_ONE);
            textY = labelBaseY + MATH_Mulu32((x / HALF_DIVISOR), LABEL_Y_SCALE);

            _LVOMove(Global_REF_GRAPHICS_LIBRARY, (char *)rp, textX, textY);
            _LVOText(Global_REF_GRAPHICS_LIBRARY, (char *)rp, buf, len);
        } else if ((x % MINOR_TICK_INTERVAL) == TICK_ZERO) {
            _LVOMove(Global_REF_GRAPHICS_LIBRARY, (char *)rp, x, y);
            _LVODraw(Global_REF_GRAPHICS_LIBRARY, (char *)rp, x, y + MINOR_TICK_HEIGHT);
        }
    }
}
