#include <exec/types.h>

/* Overlay struct: exact hard offsets matching the original ASM (Flags@32,
   TxHeight@58, TxBaseline@62). */
typedef struct CLEANUP_RastPort {
    LONG   layer0;        /* 0  */
    LONG   bitmap4;       /* 4  BitMap */
    UWORD  pad8[12];      /* 8..31 */
    UWORD  flags32;       /* 32 Flags */
    UWORD  pad34[12];     /* 34..57 */
    UWORD  txHeight58;    /* 58 TxHeight */
    UWORD  txWidth60;     /* 60 TxWidth */
    UWORD  txBaseline62;  /* 62 TxBaseline */
} CLEANUP_RastPort;

enum {
    RASTPORT_FLAGMASK_CLEAR_BIT3 = 0xFFF7,
    GRID_TIME_BANNER_WIDTH = 216,   /* 108*2 centering span */
    GRID_TIME_SUFFIX_INDEX = 9,
    GRID_TIME_SAMPLE_LEN = 9,       /* "12:44:44 " */
    GRID_TIME_PM_LEN = 11           /* "12:44:44 PM" */
};

extern LONG Global_REF_RASTPORT_1;
extern UBYTE Global_REF_STR_USE_24_HR_CLOCK;
extern WORD Global_WORD_CURRENT_HOUR;
extern WORD CLOCK_CurrentAmPmFlag;
extern WORD Global_WORD_CURRENT_MINUTE;
extern WORD Global_WORD_CURRENT_SECOND;
extern WORD CLOCK_CurrentDayOfWeekIndex;
extern const char Global_STR_GRID_TIME_FORMAT_DUPLICATE[];
extern const char Global_STR_12_44_44_SINGLE_SPACE[];
extern const char Global_STR_12_44_44_PM[];
extern void *Global_REF_GRAPHICS_LIBRARY;

/* base-first _LVO ABI (gfxBase). SetAPen(A1=rp,D0=pen); SetDrMd(A1=rp,D0=mode);
   RectFill(A1=rp,D0=xMin,D1=yMin,D2=xMax,D3=yMax); TextLength(A1=rp,A0=str,D0=n)->D0
   pixel width; Move(A1=rp,D0=x,D1=y); Text(A1=rp,A0=str,D0=n). */
void _LVOSetAPen(void *gfxBase, CLEANUP_RastPort *rp, LONG pen);
void _LVOSetDrMd(void *gfxBase, CLEANUP_RastPort *rp, LONG mode);
void _LVORectFill(void *gfxBase, CLEANUP_RastPort *rp, LONG xMin, LONG yMin, LONG xMax, LONG yMax);
LONG _LVOTextLength(void *gfxBase, CLEANUP_RastPort *rp, const char *string, LONG count);
void _LVOMove(void *gfxBase, CLEANUP_RastPort *rp, LONG x, LONG y);
void _LVOText(void *gfxBase, CLEANUP_RastPort *rp, const char *string, LONG count);
void ESQ_FormatTimeStamp(char *dst, void *clock_ref);
LONG PARSEINI_AdjustHoursTo24HrFormat(WORD hour, WORD amPmFlag);
LONG WDISP_SPrintf(char *dst, const char *fmt, LONG a, LONG b, LONG c);
/* 9-arg call (the OS BltBitMapRastPort ignores the vestigial mask slot); the
   original pushes exactly these 9 args with minterm=192. */
LONG GRAPHICS_BltBitMapRastPort(void *bitMap, LONG sx, LONG sy, void *rastPort,
                                LONG dx, LONG dy, LONG width, LONG height, LONG minterm);

void CLEANUP_DrawGridTimeBanner(void)
{
    CLEANUP_RastPort *rp;
    char timeBuffer[32];
    char ampm_suffix;
    LONG sampleWidth;
    LONG textWidth;
    LONG x;
    const char *cur;

    rp = (CLEANUP_RastPort *)Global_REF_RASTPORT_1;
    ESQ_FormatTimeStamp(timeBuffer, &CLOCK_CurrentDayOfWeekIndex);

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rp, 7);
    rp->flags32 = (UWORD)(rp->flags32 & RASTPORT_FLAGMASK_CLEAR_BIT3);
    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, rp, 0);
    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, rp, 0, 0, 215, (LONG)rp->txHeight58 - 1);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rp, 3);

    ampm_suffix = timeBuffer[GRID_TIME_SUFFIX_INDEX];
    timeBuffer[GRID_TIME_SUFFIX_INDEX] = 0;

    if (Global_REF_STR_USE_24_HR_CLOCK == 'Y') {
        LONG hour = PARSEINI_AdjustHoursTo24HrFormat(Global_WORD_CURRENT_HOUR, CLOCK_CurrentAmPmFlag);
        WDISP_SPrintf(timeBuffer, Global_STR_GRID_TIME_FORMAT_DUPLICATE,
                      hour, (LONG)Global_WORD_CURRENT_MINUTE, (LONG)Global_WORD_CURRENT_SECOND);
    }

    /* Center on measured PIXEL widths of fixed sample strings (TextLength return). */
    sampleWidth = _LVOTextLength(Global_REF_GRAPHICS_LIBRARY, rp,
                                 Global_STR_12_44_44_SINGLE_SPACE, GRID_TIME_SAMPLE_LEN);
    if (Global_REF_STR_USE_24_HR_CLOCK == 'N') {
        textWidth = _LVOTextLength(Global_REF_GRAPHICS_LIBRARY, rp,
                                   Global_STR_12_44_44_PM, GRID_TIME_PM_LEN);
    } else {
        textWidth = sampleWidth;
    }

    x = (GRID_TIME_BANNER_WIDTH - textWidth);
    if (x < 0) {
        x++;
    }
    x >>= 1;

    _LVOMove(Global_REF_GRAPHICS_LIBRARY, rp, x, (LONG)rp->txBaseline62);
    cur = timeBuffer;
    while (*cur != 0) {
        cur++;
    }
    _LVOText(Global_REF_GRAPHICS_LIBRARY, rp, timeBuffer, (LONG)(cur - timeBuffer));

    if (Global_REF_STR_USE_24_HR_CLOCK == 'N') {
        const char *suffix = &timeBuffer[GRID_TIME_SUFFIX_INDEX];

        timeBuffer[GRID_TIME_SUFFIX_INDEX] = ampm_suffix;   /* restore in place */
        _LVOMove(Global_REF_GRAPHICS_LIBRARY, rp, x + sampleWidth, (LONG)rp->txBaseline62);
        cur = suffix;
        while (*cur != 0) {
            cur++;
        }
        _LVOText(Global_REF_GRAPHICS_LIBRARY, rp, suffix, (LONG)(cur - suffix));
    }

    /* ASM push order: (bitmap, sx=x, sy=0, rp, dx=x+448, dy=40, width=textWidth,
       height=TxHeight-2, minterm=192). */
    GRAPHICS_BltBitMapRastPort((void *)rp->bitmap4, x, 0, rp, x + 448, 40,
                               textWidth, (LONG)rp->txHeight58 - 2, 192);
}
