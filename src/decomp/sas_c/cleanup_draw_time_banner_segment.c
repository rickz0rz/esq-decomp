typedef unsigned short UWORD;
typedef long LONG;

extern LONG Global_REF_RASTPORT_1;
extern LONG Global_REF_696_400_BITMAP;

void _LVOSetAPen(void);
void _LVORectFill(void);
void CLEANUP_DrawGridTimeBanner(void);
void BEVEL_DrawBevelFrameWithTopRight(void *rp, LONG x, LONG y, LONG w, LONG h);

void CLEANUP_DrawTimeBannerSegment(void)
{
    LONG old_bitmap;

    old_bitmap = *(LONG *)(Global_REF_RASTPORT_1 + 4);
    *(LONG *)(Global_REF_RASTPORT_1 + 4) = (LONG)&Global_REF_696_400_BITMAP;

    _LVOSetAPen();

    *(UWORD *)(Global_REF_RASTPORT_1 + 32) = (UWORD)(*(UWORD *)(Global_REF_RASTPORT_1 + 32) & 0xFFF7);

    _LVORectFill();

    CLEANUP_DrawGridTimeBanner();

    BEVEL_DrawBevelFrameWithTopRight((void *)Global_REF_RASTPORT_1, 448, 34, 695, 67);

    *(LONG *)(Global_REF_RASTPORT_1 + 4) = old_bitmap;
}
