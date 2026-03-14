#include <graphics/rastport.h>

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
    struct RastPort *rp;
    LONG savedBitmap;

    rp = (struct RastPort *)Global_REF_RASTPORT_1;
    savedBitmap = (LONG)rp->BitMap;
    rp->BitMap = (struct BitMap *)&Global_REF_696_400_BITMAP;

    _LVOSetAPen();

    rp->Flags = (UWORD)(rp->Flags & RASTPORT_FLAGMASK_CLEAR_BIT3);

    _LVORectFill();

    CLEANUP_DrawDateBannerSegment();
    CLEANUP_DrawBannerSpacerSegment();
    CLEANUP_DrawTimeBannerSegment();

    rp->BitMap = (struct BitMap *)savedBitmap;
}
