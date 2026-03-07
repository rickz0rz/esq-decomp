typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef short WORD;
typedef long LONG;

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

LONG GROUP_AC_JMPTBL_PARSEINI_AdjustHoursTo24HrFormat(LONG hour, LONG ampm);
void GROUP_AE_JMPTBL_WDISP_SPrintf(char *dst, const char *fmt, LONG a, LONG b, LONG c);
void BEVEL_DrawBevelFrameWithTopRight(void *rp, LONG x, LONG y, LONG w, LONG h);
void GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort(
    void *src_bitmap,
    LONG src_x,
    LONG src_y,
    void *dst_rp,
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
    char text[10];
    LONG y;
    LONG font_h;

    if (Global_UIBusyFlag != 0) {
        return;
    }

    if (Global_REF_STR_USE_24_HR_CLOCK == 'Y') {
        LONG hour = GROUP_AC_JMPTBL_PARSEINI_AdjustHoursTo24HrFormat((LONG)Global_WORD_CURRENT_HOUR, (LONG)CLOCK_CurrentAmPmFlag);
        GROUP_AE_JMPTBL_WDISP_SPrintf(
            text,
            Global_STR_EXTRA_TIME_FORMAT,
            hour,
            (LONG)Global_WORD_CURRENT_MINUTE,
            (LONG)Global_WORD_CURRENT_SECOND
        );
    } else {
        GROUP_AE_JMPTBL_WDISP_SPrintf(
            text,
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
        (void *)NEWGRID_MainRastPortPtr,
        (LONG)NEWGRID_ColumnStartXPx + 35,
        0,
        CLOCK_BANNER_FRAME_WIDTH,
        CLOCK_BANNER_FRAME_HEIGHT
    );

    font_h = (LONG)(*(UWORD *)(*(LONG *)(NEWGRID_MainRastPortPtr + RASTPORT_FONT_PTR_OFFSET) + FONT_HEIGHT_OFFSET));
    y = (((34 - font_h) + 1) >> 1) + font_h - 1;
    (void)y;

    _LVOMove();
    _LVOSetAPen();
    _LVOText();

    GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort(
        *(void **)(NEWGRID_MainRastPortPtr + 4),
        0,
        0,
        (void *)NEWGRID_MainRastPortPtr,
        (LONG)NEWGRID_ColumnStartXPx + CLOCK_BANNER_INNER_X_OFFSET,
        CLOCK_BANNER_BLIT_SIZE,
        CLOCK_BANNER_BLIT_SIZE,
        CLOCK_BANNER_BLIT_SIZE,
        192
    );
}
