typedef unsigned short UWORD;
typedef long LONG;

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
void BEVEL_DrawBevelFrameWithTopRight(void *rp, LONG x, LONG y, LONG w, LONG h);

void CLEANUP_DrawBannerSpacerSegment(void)
{
    LONG savedBitmap;

    savedBitmap = *(LONG *)(Global_REF_RASTPORT_1 + RASTPORT_BITMAP_OFFSET);
    *(LONG *)(Global_REF_RASTPORT_1 + RASTPORT_BITMAP_OFFSET) = (LONG)&Global_REF_696_400_BITMAP;

    _LVOSetAPen();

    *(UWORD *)(Global_REF_RASTPORT_1 + RASTPORT_FLAGS_OFFSET) =
        (UWORD)(*(UWORD *)(Global_REF_RASTPORT_1 + RASTPORT_FLAGS_OFFSET) & RASTPORT_FLAGMASK_CLEAR_BIT3);

    _LVORectFill();

    BEVEL_DrawBevelFrameWithTopRight((void *)Global_REF_RASTPORT_1,
                                     BANNER_SPACER_LEFT,
                                     BANNER_SPACER_TOP,
                                     BANNER_SPACER_RIGHT,
                                     BANNER_SPACER_BOTTOM);

    *(LONG *)(Global_REF_RASTPORT_1 + RASTPORT_BITMAP_OFFSET) = savedBitmap;
}
