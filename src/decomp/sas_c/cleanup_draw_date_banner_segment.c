typedef unsigned short UWORD;
typedef long LONG;

typedef struct CLEANUP_RastPort {
    LONG pad0;
    LONG bitmap4;
    UWORD pad8[12];
    UWORD flags32;
} CLEANUP_RastPort;

enum {
    RASTPORT_BITMAP_OFFSET = 4,
    RASTPORT_FLAGS_OFFSET = 32,
    RASTPORT_FLAGMASK_CLEAR_BIT3 = 0xFFF7,
    DATE_BEVEL_Y = 34,
    DATE_BEVEL_HEIGHT = 67
};

extern LONG Global_REF_RASTPORT_1;
extern LONG Global_REF_696_400_BITMAP;

void _LVOSetAPen(void);
void _LVORectFill(void);
void RENDER_SHORT_MONTH_SHORT_DAY_OF_WEEK_DAY(void);
void BEVEL_DrawBevelFrameWithTopRight(char *rp, LONG x, LONG y, LONG w, LONG h);

void CLEANUP_DrawDateBannerSegment(void)
{
    CLEANUP_RastPort *rp;
    LONG savedBitmap;

    rp = (CLEANUP_RastPort *)Global_REF_RASTPORT_1;
    savedBitmap = rp->bitmap4;
    rp->bitmap4 = (LONG)&Global_REF_696_400_BITMAP;

    _LVOSetAPen();

    rp->flags32 = (UWORD)(rp->flags32 & RASTPORT_FLAGMASK_CLEAR_BIT3);

    _LVORectFill();

    RENDER_SHORT_MONTH_SHORT_DAY_OF_WEEK_DAY();

    BEVEL_DrawBevelFrameWithTopRight((char *)Global_REF_RASTPORT_1, 0, DATE_BEVEL_Y, 255, DATE_BEVEL_HEIGHT);

    rp->bitmap4 = savedBitmap;
}
