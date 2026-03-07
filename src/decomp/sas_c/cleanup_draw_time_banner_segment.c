typedef unsigned short UWORD;
typedef long LONG;

enum {
    RASTPORT_BITMAP_OFFSET = 4,
    RASTPORT_FLAGS_OFFSET = 32,
    RASTPORT_FLAGMASK_CLEAR_BIT3 = 0xFFF7,
    TIME_BEVEL_Y = 34,
    TIME_BEVEL_HEIGHT = 67
};

extern LONG Global_REF_RASTPORT_1;
extern LONG Global_REF_696_400_BITMAP;

void _LVOSetAPen(void);
void _LVORectFill(void);
void CLEANUP_DrawGridTimeBanner(void);
void BEVEL_DrawBevelFrameWithTopRight(void *rp, LONG x, LONG y, LONG w, LONG h);

void CLEANUP_DrawTimeBannerSegment(void)
{
    LONG savedBitmap;

    savedBitmap = *(LONG *)(Global_REF_RASTPORT_1 + RASTPORT_BITMAP_OFFSET);
    *(LONG *)(Global_REF_RASTPORT_1 + RASTPORT_BITMAP_OFFSET) = (LONG)&Global_REF_696_400_BITMAP;

    _LVOSetAPen();

    *(UWORD *)(Global_REF_RASTPORT_1 + RASTPORT_FLAGS_OFFSET) =
        (UWORD)(*(UWORD *)(Global_REF_RASTPORT_1 + RASTPORT_FLAGS_OFFSET) & RASTPORT_FLAGMASK_CLEAR_BIT3);

    _LVORectFill();

    CLEANUP_DrawGridTimeBanner();

    BEVEL_DrawBevelFrameWithTopRight((void *)Global_REF_RASTPORT_1, 448, TIME_BEVEL_Y, 695, TIME_BEVEL_HEIGHT);

    *(LONG *)(Global_REF_RASTPORT_1 + RASTPORT_BITMAP_OFFSET) = savedBitmap;
}
