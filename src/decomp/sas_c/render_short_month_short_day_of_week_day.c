#include <exec/types.h>

/* Overlay struct: exact hard offsets matching the original ASM (Flags@32,
   TxHeight@58, TxBaseline@62) so field access can never drift from the target. */
typedef struct RENDER_RastPort {
    LONG   layer0;        /* 0  */
    LONG   bitmap4;       /* 4  BitMap */
    UWORD  pad8[12];      /* 8..31 */
    UWORD  flags32;       /* 32 Flags */
    UWORD  pad34[12];     /* 34..57 */
    UWORD  txHeight58;    /* 58 TxHeight */
    UWORD  txWidth60;     /* 60 TxWidth */
    UWORD  txBaseline62;  /* 62 TxBaseline */
} RENDER_RastPort;

extern LONG Global_REF_RASTPORT_1;
extern LONG Global_REF_696_400_BITMAP;
extern const char *Global_JMPTBL_SHORT_DAYS_OF_WEEK[];
extern const char *Global_JMPTBL_SHORT_MONTHS[];
extern const char Global_STR_SHORT_MONTH_SHORT_DAY_OF_WEEK_FORMATTED[];
extern WORD CLOCK_CurrentDayOfWeekIndex;
extern WORD CLOCK_CurrentMonthIndex;
extern WORD CLOCK_CurrentDayOfMonth;
extern void *Global_REF_GRAPHICS_LIBRARY;

/* base-first _LVO ABI (gfxBase). SetAPen(A1=rp,D0=pen); SetDrMd(A1=rp,D0=mode);
   RectFill(A1=rp,D0=xMin,D1=yMin,D2=xMax,D3=yMax); TextLength(A1=rp,A0=str,D0=n)->D0
   pixel width; Move(A1=rp,D0=x,D1=y); Text(A1=rp,A0=str,D0=n). */
void _LVOSetAPen(void *gfxBase, RENDER_RastPort *rp, LONG pen);
void _LVOSetDrMd(void *gfxBase, RENDER_RastPort *rp, LONG mode);
void _LVORectFill(void *gfxBase, RENDER_RastPort *rp, LONG xMin, LONG yMin, LONG xMax, LONG yMax);
LONG _LVOTextLength(void *gfxBase, RENDER_RastPort *rp, const char *string, LONG count);
void _LVOMove(void *gfxBase, RENDER_RastPort *rp, LONG x, LONG y);
void _LVOText(void *gfxBase, RENDER_RastPort *rp, const char *string, LONG count);
LONG GROUP_AE_JMPTBL_WDISP_SPrintf(char *dst, const char *fmt, const char *a, const char *b, LONG c);
void GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort(
    void *src_bitmap, LONG src_x, LONG src_y, RENDER_RastPort *dst_rp,
    LONG dst_x, LONG dst_y, LONG width, LONG height, LONG minterm);

void RENDER_SHORT_MONTH_SHORT_DAY_OF_WEEK_DAY(void)
{
    RENDER_RastPort *rp;
    char text[32];
    const char *dow;
    const char *mon;
    const char *textEnd;
    LONG textWidthPx;
    LONG x;

    rp = (RENDER_RastPort *)Global_REF_RASTPORT_1;
    rp->bitmap4 = (LONG)&Global_REF_696_400_BITMAP;

    dow = Global_JMPTBL_SHORT_DAYS_OF_WEEK[(LONG)CLOCK_CurrentDayOfWeekIndex];
    mon = Global_JMPTBL_SHORT_MONTHS[(LONG)CLOCK_CurrentMonthIndex];
    GROUP_AE_JMPTBL_WDISP_SPrintf(text, Global_STR_SHORT_MONTH_SHORT_DAY_OF_WEEK_FORMATTED,
                                  dow, mon, (LONG)CLOCK_CurrentDayOfMonth);

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rp, 7);
    rp->flags32 = (UWORD)(rp->flags32 & 0xFFF7);
    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, rp, 0);
    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, rp, 0, 0, 215, (LONG)rp->txHeight58 - 1);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rp, 3);

    textEnd = text;
    while (*textEnd != 0) {
        textEnd++;
    }

    /* Center on measured PIXEL width (TextLength return), round toward zero. */
    textWidthPx = _LVOTextLength(Global_REF_GRAPHICS_LIBRARY, rp, text, (LONG)(textEnd - text));
    x = (216 - textWidthPx);
    if (x < 0) {
        x++;
    }
    x >>= 1;

    _LVOMove(Global_REF_GRAPHICS_LIBRARY, rp, x, (LONG)rp->txBaseline62);
    _LVOText(Global_REF_GRAPHICS_LIBRARY, rp, text, (LONG)(textEnd - text));

    /* ASM push order: src=(bitmap,0,0), dst_rp=rp, dst_x=44, dst_y=40,
       width=208, height=TxHeight-2, minterm=192. */
    GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort(
        (void *)rp->bitmap4, 0, 0, rp, 44, 40, 208, (LONG)rp->txHeight58 - 2, 192);
}
