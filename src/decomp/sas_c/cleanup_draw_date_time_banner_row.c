#include <graphics/rastport.h>

enum {
    RASTPORT_BITMAP_OFFSET = 4,
    RASTPORT_FLAGS_OFFSET = 32,
    RASTPORT_FLAGMASK_CLEAR_BIT3 = 0xFFF7
};

extern LONG Global_REF_RASTPORT_1;
extern LONG Global_REF_696_400_BITMAP;
extern void *Global_REF_GRAPHICS_LIBRARY;

/* base-first _LVO ABI. SetAPen(gfxBase; A1=rp, D0=pen).
   RectFill(gfxBase; A1=rp, D0=xMin, D1=yMin, D2=xMax, D3=yMax). */
void _LVOSetAPen(void *gfxBase, struct RastPort *rp, LONG pen);
void _LVORectFill(void *gfxBase, struct RastPort *rp, LONG xMin, LONG yMin, LONG xMax, LONG yMax);
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

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rp, 7);

    rp->Flags = (UWORD)(rp->Flags & RASTPORT_FLAGMASK_CLEAR_BIT3);

    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, rp, 0, 34, 695, 67);

    CLEANUP_DrawDateBannerSegment();
    CLEANUP_DrawBannerSpacerSegment();
    CLEANUP_DrawTimeBannerSegment();

    rp->BitMap = (struct BitMap *)savedBitmap;
}
