#include <graphics/rastport.h>

enum {
    RASTPORT_BITMAP_PTR_OFFSET = 4,
    CLOCK_FORMAT_FRAME_X_OFFSET = 36,
    CLOCK_FORMAT_FRAME_RIGHT_EDGE = 660,
    CLOCK_FORMAT_FRAME_Y = 34,
    CLOCK_FORMAT_FRAME_MINTERM = 192,
    SRC_Y_ZERO = 0
};

extern UWORD NEWGRID_ColumnStartXPx;
extern LONG NEWGRID_MainRastPortPtr;

void GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort(
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

void CLEANUP_DrawClockFormatFrame(void)
{
    struct RastPort *srcRp;
    char *dstRp;
    void *srcBitmap;
    LONG baseX;
    LONG frameX;
    LONG frameWidth;

    srcRp = (struct RastPort *)NEWGRID_MainRastPortPtr;
    dstRp = (char *)NEWGRID_MainRastPortPtr;
    srcBitmap = srcRp->BitMap;
    baseX = (LONG)NEWGRID_ColumnStartXPx;
    frameX = baseX + CLOCK_FORMAT_FRAME_X_OFFSET;
    frameWidth = CLOCK_FORMAT_FRAME_RIGHT_EDGE - baseX;

    GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort(
        srcBitmap,
        frameX,
        SRC_Y_ZERO,
        dstRp,
        frameX,
        CLOCK_FORMAT_FRAME_Y,
        frameWidth,
        34,
        CLOCK_FORMAT_FRAME_MINTERM
    );
}
