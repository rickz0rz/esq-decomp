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
void CLEANUP_DrawDateBannerSegment(void);
void CLEANUP_DrawBannerSpacerSegment(void);
void CLEANUP_DrawTimeBannerSegment(void);

void CLEANUP_DrawDateTimeBannerRow(void)
{
    LONG savedBitmap;

    savedBitmap = *(LONG *)(Global_REF_RASTPORT_1 + RASTPORT_BITMAP_OFFSET);
    *(LONG *)(Global_REF_RASTPORT_1 + RASTPORT_BITMAP_OFFSET) = (LONG)&Global_REF_696_400_BITMAP;

    _LVOSetAPen();

    *(UWORD *)(Global_REF_RASTPORT_1 + RASTPORT_FLAGS_OFFSET) =
        (UWORD)(*(UWORD *)(Global_REF_RASTPORT_1 + RASTPORT_FLAGS_OFFSET) & RASTPORT_FLAGMASK_CLEAR_BIT3);

    _LVORectFill();

    CLEANUP_DrawDateBannerSegment();
    CLEANUP_DrawBannerSpacerSegment();
    CLEANUP_DrawTimeBannerSegment();

    *(LONG *)(Global_REF_RASTPORT_1 + RASTPORT_BITMAP_OFFSET) = savedBitmap;
}
