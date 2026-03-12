typedef unsigned short UWORD;
typedef long LONG;

typedef struct CLEANUP_RastPort {
    LONG pad0;
    LONG bitmap4;
    UWORD pad8[12];
    UWORD flags32;
} CLEANUP_RastPort;

enum {
    RASTPORT_BITMAP_OFFSET = 4,
    RASTPORT_FLAGS_OFFSET = 32,
    RASTPORT_FLAGMASK_CLEAR_BIT3 = 0xFFF7,
    TIME_FILL_LEFT = 448,
    TIME_FILL_TOP = 34,
    TIME_FILL_RIGHT = 663,
    TIME_FILL_BOTTOM = 67,
    TIME_BEVEL_RIGHT = 695
};

extern LONG Global_REF_RASTPORT_1;
extern LONG Global_REF_GRAPHICS_LIBRARY;
extern LONG Global_REF_696_400_BITMAP;

void _LVOSetAPen(void *gfxBase, char *rastPort, LONG pen);
void _LVORectFill(void *gfxBase, char *rastPort, LONG minX, LONG minY, LONG maxX, LONG maxY);
void CLEANUP_DrawGridTimeBanner(void);
void BEVEL_DrawBevelFrameWithTopRight(char *rp, LONG x, LONG y, LONG w, LONG h);

void CLEANUP_DrawTimeBannerSegment(void)
{
    CLEANUP_RastPort *rp;
    LONG savedBitmap;
    LONG flags;

    rp = (CLEANUP_RastPort *)Global_REF_RASTPORT_1;
    savedBitmap = rp->bitmap4;
    rp->bitmap4 = (LONG)&Global_REF_696_400_BITMAP;

    _LVOSetAPen((void *)Global_REF_GRAPHICS_LIBRARY, (char *)rp, 7);

    flags = (LONG)(UWORD)rp->flags32;
    flags &= RASTPORT_FLAGMASK_CLEAR_BIT3;
    rp->flags32 = (UWORD)flags;

    _LVORectFill((void *)Global_REF_GRAPHICS_LIBRARY,
                 (char *)rp,
                 TIME_FILL_LEFT,
                 TIME_FILL_TOP,
                 TIME_FILL_RIGHT,
                 TIME_FILL_BOTTOM);

    CLEANUP_DrawGridTimeBanner();

    BEVEL_DrawBevelFrameWithTopRight((char *)Global_REF_RASTPORT_1,
                                     TIME_FILL_LEFT,
                                     TIME_FILL_TOP,
                                     TIME_BEVEL_RIGHT,
                                     TIME_FILL_BOTTOM);

    rp = (CLEANUP_RastPort *)Global_REF_RASTPORT_1;
    rp->bitmap4 = savedBitmap;
}
