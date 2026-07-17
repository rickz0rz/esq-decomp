#include <graphics/rastport.h>
#include <graphics/text.h>

enum {
    CLOCK_BANNER_FRAME_WIDTH = 35,
    CLOCK_BANNER_FRAME_HEIGHT = 33,
    CLOCK_BANNER_BLIT_SIZE = 34,
    RASTPORT_FONT_PTR_OFFSET = 52,
    FONT_HEIGHT_OFFSET = 26,
    CLOCK_BANNER_INNER_X_OFFSET = 36
};

extern WORD Global_UIBusyFlag;
extern UBYTE Global_REF_STR_USE_24_HR_CLOCK;
extern WORD Global_WORD_CURRENT_HOUR;
extern WORD CLOCK_CurrentAmPmFlag;
extern WORD Global_WORD_CURRENT_MINUTE;
extern WORD Global_WORD_CURRENT_SECOND;
extern const char Global_STR_EXTRA_TIME_FORMAT[];
extern const char Global_STR_GRID_TIME_FORMAT[];
extern LONG NEWGRID_MainRastPortPtr;
extern UWORD NEWGRID_ColumnStartXPx;
extern void *Global_REF_GRAPHICS_LIBRARY;

LONG PARSEINI_AdjustHoursTo24HrFormat(WORD hour, WORD amPmFlag);
LONG WDISP_SPrintf(char *dst, const char *fmt, LONG a, LONG b, LONG c);
void BEVEL_DrawBevelFrameWithTopRight(char *rp, LONG x, LONG y, LONG w, LONG h);
LONG GRAPHICS_BltBitMapRastPort(
    void *src_bitmap,
    LONG src_x,
    LONG src_y,
    char *dst_rp,
    LONG dst_x,
    LONG dst_y,
    LONG width,
    LONG height,
    LONG minterm
);
/* base-first _LVO ABI (gfxBase). SetAPen(A1=rp, D0=pen);
   RectFill(A1=rp, D0=xMin, D1=yMin, D2=xMax, D3=yMax); Move(A1=rp, D0=x, D1=y);
   Text(A1=rp, A0=string, D0=count). */
void _LVOSetAPen(void *gfxBase, struct RastPort *rp, LONG pen);
void _LVORectFill(void *gfxBase, struct RastPort *rp, LONG xMin, LONG yMin, LONG xMax, LONG yMax);
void _LVOMove(void *gfxBase, struct RastPort *rp, LONG x, LONG y);
void _LVOText(void *gfxBase, struct RastPort *rp, const char *string, LONG count);

void CLEANUP_DrawClockBanner(void)
{
    struct RastPort *rp;
    char timeText[10];
    LONG y;
    LONG fontHeight;

    if (Global_UIBusyFlag != 0) {
        return;
    }

    rp = (struct RastPort *)NEWGRID_MainRastPortPtr;

    if (Global_REF_STR_USE_24_HR_CLOCK == 'Y') {
        LONG hour = PARSEINI_AdjustHoursTo24HrFormat(Global_WORD_CURRENT_HOUR, CLOCK_CurrentAmPmFlag);
        WDISP_SPrintf(
            timeText,
            Global_STR_EXTRA_TIME_FORMAT,
            hour,
            (LONG)Global_WORD_CURRENT_MINUTE,
            (LONG)Global_WORD_CURRENT_SECOND
        );
    } else {
        WDISP_SPrintf(
            timeText,
            Global_STR_GRID_TIME_FORMAT,
            (LONG)Global_WORD_CURRENT_HOUR,
            (LONG)Global_WORD_CURRENT_MINUTE,
            (LONG)Global_WORD_CURRENT_SECOND
        );
    }

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rp, 7);
    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, rp, 0, 0, CLOCK_BANNER_FRAME_WIDTH, CLOCK_BANNER_FRAME_HEIGHT);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rp, 7);
    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, rp,
                 CLOCK_BANNER_INNER_X_OFFSET, 0,
                 (LONG)NEWGRID_ColumnStartXPx + CLOCK_BANNER_FRAME_WIDTH, CLOCK_BANNER_FRAME_HEIGHT);

    BEVEL_DrawBevelFrameWithTopRight(
        (char *)rp,
        0,
        0,
        (LONG)NEWGRID_ColumnStartXPx + CLOCK_BANNER_FRAME_WIDTH,
        CLOCK_BANNER_FRAME_HEIGHT
    );

    fontHeight = (LONG)rp->Font->tf_YSize;
    y = ((CLOCK_BANNER_BLIT_SIZE - fontHeight) / 2) + fontHeight - 1;

    {
        const char *tc = timeText;
        while (*tc != 0) {
            tc++;
        }
        _LVOMove(Global_REF_GRAPHICS_LIBRARY, rp, 44, y);
        _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rp, 1);
        _LVOText(Global_REF_GRAPHICS_LIBRARY, rp, timeText, (LONG)(tc - timeText));
    }

    /* ASM push order: src=(rp->BitMap,0,0), dst_rp=rp, dst_x=0, dst_y=34,
       width=ColumnStartXPx+36, height=34, minterm=192. */
    GRAPHICS_BltBitMapRastPort(
        rp->BitMap,
        0,
        0,
        (char *)rp,
        0,
        CLOCK_BANNER_BLIT_SIZE,
        (LONG)NEWGRID_ColumnStartXPx + CLOCK_BANNER_INNER_X_OFFSET,
        CLOCK_BANNER_BLIT_SIZE,
        192
    );
}
