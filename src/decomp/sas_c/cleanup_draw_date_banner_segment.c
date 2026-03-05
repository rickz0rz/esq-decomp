typedef unsigned short UWORD;
typedef long LONG;

extern LONG Global_REF_RASTPORT_1;
extern LONG Global_REF_696_400_BITMAP;

void _LVOSetAPen(void);
void _LVORectFill(void);
void RENDER_SHORT_MONTH_SHORT_DAY_OF_WEEK_DAY(void);
void BEVEL_DrawBevelFrameWithTopRight(void *rp, LONG x, LONG y, LONG w, LONG h);

void CLEANUP_DrawDateBannerSegment(void)
{
    LONG old_bitmap;

    old_bitmap = *(LONG *)(Global_REF_RASTPORT_1 + 4);
    *(LONG *)(Global_REF_RASTPORT_1 + 4) = (LONG)&Global_REF_696_400_BITMAP;

    _LVOSetAPen();

    *(UWORD *)(Global_REF_RASTPORT_1 + 32) = (UWORD)(*(UWORD *)(Global_REF_RASTPORT_1 + 32) & 0xFFF7);

    _LVORectFill();

    RENDER_SHORT_MONTH_SHORT_DAY_OF_WEEK_DAY();

    BEVEL_DrawBevelFrameWithTopRight((void *)Global_REF_RASTPORT_1, 0, 34, 255, 67);

    *(LONG *)(Global_REF_RASTPORT_1 + 4) = old_bitmap;
}
