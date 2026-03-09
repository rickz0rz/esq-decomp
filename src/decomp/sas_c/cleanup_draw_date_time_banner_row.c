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
    CLEANUP_RastPort *rp;
    LONG savedBitmap;

    rp = (CLEANUP_RastPort *)Global_REF_RASTPORT_1;
    savedBitmap = rp->bitmap4;
    rp->bitmap4 = (LONG)&Global_REF_696_400_BITMAP;

    _LVOSetAPen();

    rp->flags32 = (UWORD)(rp->flags32 & RASTPORT_FLAGMASK_CLEAR_BIT3);

    _LVORectFill();

    CLEANUP_DrawDateBannerSegment();
    CLEANUP_DrawBannerSpacerSegment();
    CLEANUP_DrawTimeBannerSegment();

    rp->bitmap4 = savedBitmap;
}
