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
void _LVOSetAPen(void);
void _LVORectFill(void);
void _LVOMove(void);
void _LVOText(void);

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

    _LVOSetAPen();
    _LVORectFill();
    _LVOSetAPen();
    _LVORectFill();

    BEVEL_DrawBevelFrameWithTopRight(
        (char *)rp,
        (LONG)NEWGRID_ColumnStartXPx + 35,
        0,
        CLOCK_BANNER_FRAME_WIDTH,
        CLOCK_BANNER_FRAME_HEIGHT
    );

    fontHeight = (LONG)rp->Font->tf_YSize;
    y = (((34 - fontHeight) + 1) >> 1) + fontHeight - 1;
    (void)y;

    _LVOMove();
    _LVOSetAPen();
    _LVOText();

    GRAPHICS_BltBitMapRastPort(
        rp->BitMap,
        0,
        0,
        (char *)rp,
        (LONG)NEWGRID_ColumnStartXPx + CLOCK_BANNER_INNER_X_OFFSET,
        CLOCK_BANNER_BLIT_SIZE,
        CLOCK_BANNER_BLIT_SIZE,
        CLOCK_BANNER_BLIT_SIZE,
        192,
        -1
    );
}
