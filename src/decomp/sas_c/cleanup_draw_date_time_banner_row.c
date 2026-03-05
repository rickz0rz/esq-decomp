typedef unsigned short UWORD;
typedef long LONG;

extern LONG Global_REF_RASTPORT_1;
extern LONG Global_REF_696_400_BITMAP;

void _LVOSetAPen(void);
void _LVORectFill(void);
void CLEANUP_DrawDateBannerSegment(void);
void CLEANUP_DrawBannerSpacerSegment(void);
void CLEANUP_DrawTimeBannerSegment(void);

void CLEANUP_DrawDateTimeBannerRow(void)
{
    LONG old_bitmap;

    old_bitmap = *(LONG *)(Global_REF_RASTPORT_1 + 4);
    *(LONG *)(Global_REF_RASTPORT_1 + 4) = (LONG)&Global_REF_696_400_BITMAP;

    _LVOSetAPen();

    *(UWORD *)(Global_REF_RASTPORT_1 + 32) = (UWORD)(*(UWORD *)(Global_REF_RASTPORT_1 + 32) & 0xFFF7);

    _LVORectFill();

    CLEANUP_DrawDateBannerSegment();
    CLEANUP_DrawBannerSpacerSegment();
    CLEANUP_DrawTimeBannerSegment();

    *(LONG *)(Global_REF_RASTPORT_1 + 4) = old_bitmap;
}
