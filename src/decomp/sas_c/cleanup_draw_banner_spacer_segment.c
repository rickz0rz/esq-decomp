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
    BANNER_SPACER_LEFT = 256,
    BANNER_SPACER_TOP = 34,
    BANNER_SPACER_RIGHT = 447,
    BANNER_SPACER_BOTTOM = 67
};

extern LONG Global_REF_RASTPORT_1;
extern LONG Global_REF_GRAPHICS_LIBRARY;
extern LONG Global_REF_696_400_BITMAP;

void _LVOSetAPen(void);
void _LVORectFill(void);
void BEVEL_DrawBevelFrameWithTopRight(char *rp, LONG x, LONG y, LONG w, LONG h);

void CLEANUP_DrawBannerSpacerSegment(void)
{
    CLEANUP_RastPort *rp;
    LONG savedBitmap;

    rp = (CLEANUP_RastPort *)Global_REF_RASTPORT_1;
    savedBitmap = rp->bitmap4;
    rp->bitmap4 = (LONG)&Global_REF_696_400_BITMAP;

    _LVOSetAPen();

    rp->flags32 = (UWORD)(rp->flags32 & RASTPORT_FLAGMASK_CLEAR_BIT3);

    _LVORectFill();

    BEVEL_DrawBevelFrameWithTopRight((char *)Global_REF_RASTPORT_1,
                                     BANNER_SPACER_LEFT,
                                     BANNER_SPACER_TOP,
                                     BANNER_SPACER_RIGHT,
                                     BANNER_SPACER_BOTTOM);

    rp->bitmap4 = savedBitmap;
}
