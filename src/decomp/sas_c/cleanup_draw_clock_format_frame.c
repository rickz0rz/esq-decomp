typedef unsigned short UWORD;
typedef long LONG;

enum {
    CLOCK_FORMAT_FRAME_X_OFFSET = 36,
    CLOCK_FORMAT_FRAME_RIGHT_EDGE = 660,
    CLOCK_FORMAT_FRAME_Y = 34,
    CLOCK_FORMAT_FRAME_MINTERM = 192
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
    LONG width;

    baseX = (LONG)NEWGRID_ColumnStartXPx;
    frameX = baseX + CLOCK_FORMAT_FRAME_X_OFFSET;
    width = CLOCK_FORMAT_FRAME_RIGHT_EDGE - baseX;

    GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort(
        *(void **)(NEWGRID_MainRastPortPtr + 4),
        frameX,
        0,
        (void *)NEWGRID_MainRastPortPtr,
        frameX,
        CLOCK_FORMAT_FRAME_Y,
        width,
        CLOCK_FORMAT_FRAME_Y,
        CLOCK_FORMAT_FRAME_MINTERM
    );
}
