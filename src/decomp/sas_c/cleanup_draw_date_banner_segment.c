#include <graphics/rastport.h>

enum {
    RASTPORT_BITMAP_OFFSET = 4,
    RASTPORT_FLAGS_OFFSET = 32,
    RASTPORT_FLAGMASK_CLEAR_BIT3 = 0xFFF7,
    DATE_BEVEL_Y = 34,
    DATE_BEVEL_HEIGHT = 67
};

extern LONG Global_REF_RASTPORT_1;
extern LONG Global_REF_GRAPHICS_LIBRARY;
extern LONG Global_REF_696_400_BITMAP;

void _LVOSetAPen(void *gfxBase, char *rastPort, LONG pen);
void _LVORectFill(void *gfxBase, char *rastPort, LONG minX, LONG minY, LONG maxX, LONG maxY);
void RENDER_SHORT_MONTH_SHORT_DAY_OF_WEEK_DAY(void);
void BEVEL_DrawBevelFrameWithTopRight(char *rp, LONG x, LONG y, LONG w, LONG h);

void CLEANUP_DrawDateBannerSegment(void)
{
    struct RastPort *rp;
    struct BitMap **bitmapSlot;
    LONG savedBitmap;
    LONG flags;

    rp = (struct RastPort *)Global_REF_RASTPORT_1;
    bitmapSlot = &rp->BitMap;
    savedBitmap = (LONG)*bitmapSlot;
    *bitmapSlot = (struct BitMap *)&Global_REF_696_400_BITMAP;

    _LVOSetAPen((void *)Global_REF_GRAPHICS_LIBRARY, (char *)rp, 7);

    flags = (LONG)(UWORD)rp->Flags;
    flags &= RASTPORT_FLAGMASK_CLEAR_BIT3;
    rp->Flags = (UWORD)flags;

    _LVORectFill((void *)Global_REF_GRAPHICS_LIBRARY, (char *)rp, 0, DATE_BEVEL_Y, 255, DATE_BEVEL_HEIGHT);

    RENDER_SHORT_MONTH_SHORT_DAY_OF_WEEK_DAY();

    BEVEL_DrawBevelFrameWithTopRight((char *)Global_REF_RASTPORT_1, 0, DATE_BEVEL_Y, 255, DATE_BEVEL_HEIGHT);

    *bitmapSlot = (struct BitMap *)savedBitmap;
}
