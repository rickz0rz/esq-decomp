typedef unsigned short UWORD;
typedef long LONG;

enum {
    RASTPORT_BITMAP_PTR_OFFSET = 4,
    CLOCK_FORMAT_FRAME_X_OFFSET = 36,
    CLOCK_FORMAT_FRAME_RIGHT_EDGE = 660,
    CLOCK_FORMAT_FRAME_Y = 34,
    CLOCK_FORMAT_FRAME_HEIGHT = 34,
    CLOCK_FORMAT_FRAME_MINTERM = 192,
    SRC_Y_ZERO = 0
};

extern UWORD NEWGRID_ColumnStartXPx;
extern LONG NEWGRID_MainRastPortPtr;

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

void CLEANUP_DrawClockFormatFrame(void)
{
    LONG baseX;
    LONG frameX;
    LONG frameWidth;

    baseX = (LONG)NEWGRID_ColumnStartXPx;
    frameX = baseX + CLOCK_FORMAT_FRAME_X_OFFSET;
    frameWidth = CLOCK_FORMAT_FRAME_RIGHT_EDGE - baseX;

    GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort(
        *(void **)(NEWGRID_MainRastPortPtr + RASTPORT_BITMAP_PTR_OFFSET),
        frameX,
        SRC_Y_ZERO,
        (void *)NEWGRID_MainRastPortPtr,
        frameX,
        CLOCK_FORMAT_FRAME_Y,
        frameWidth,
        CLOCK_FORMAT_FRAME_HEIGHT,
        CLOCK_FORMAT_FRAME_MINTERM
    );
}
