typedef unsigned short UWORD;
typedef long LONG;

enum {
    RASTPORT_BITMAP_OFFSET = 4,
    RASTPORT_FLAGS_OFFSET = 32,
    RASTPORT_FLAGMASK_CLEAR_BIT3 = 0xFFF7
};

extern LONG Global_REF_RASTPORT_1;
extern LONG Global_REF_696_400_BITMAP;

void _LVOSetAPen(void);
void _LVORectFill(void);
void RENDER_SHORT_MONTH_SHORT_DAY_OF_WEEK_DAY(void);
void BEVEL_DrawBevelFrameWithTopRight(void *rp, LONG x, LONG y, LONG w, LONG h);

void CLEANUP_DrawDateBannerSegment(void)
{
    LONG previousBitmap;

    previousBitmap = *(LONG *)(Global_REF_RASTPORT_1 + RASTPORT_BITMAP_OFFSET);
    *(LONG *)(Global_REF_RASTPORT_1 + RASTPORT_BITMAP_OFFSET) = (LONG)&Global_REF_696_400_BITMAP;

    _LVOSetAPen();

    *(UWORD *)(Global_REF_RASTPORT_1 + RASTPORT_FLAGS_OFFSET) =
        (UWORD)(*(UWORD *)(Global_REF_RASTPORT_1 + RASTPORT_FLAGS_OFFSET) & RASTPORT_FLAGMASK_CLEAR_BIT3);

    _LVORectFill();

    RENDER_SHORT_MONTH_SHORT_DAY_OF_WEEK_DAY();

    BEVEL_DrawBevelFrameWithTopRight((void *)Global_REF_RASTPORT_1, 0, 34, 255, 67);

    *(LONG *)(Global_REF_RASTPORT_1 + RASTPORT_BITMAP_OFFSET) = previousBitmap;
}
