typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef long LONG;

typedef struct CLEANUP_RastPort {
    UBYTE pad0[4];
    void *bitmap4;
} CLEANUP_RastPort;

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
    void *dst_rp,
    LONG dst_x,
    LONG dst_y,
    LONG width,
    LONG height,
    LONG minterm
);

void CLEANUP_DrawClockFormatFrame(void)
{
    CLEANUP_RastPort *rp;
    LONG baseX;
    LONG frameX;
    LONG frameWidth;

    rp = (CLEANUP_RastPort *)NEWGRID_MainRastPortPtr;
    baseX = (LONG)NEWGRID_ColumnStartXPx;
    frameX = baseX + CLOCK_FORMAT_FRAME_X_OFFSET;
    frameWidth = CLOCK_FORMAT_FRAME_RIGHT_EDGE - baseX;

    GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort(
        rp->bitmap4,
        frameX,
        SRC_Y_ZERO,
        rp,
        frameX,
        CLOCK_FORMAT_FRAME_Y,
        frameWidth,
        34,
        CLOCK_FORMAT_FRAME_MINTERM
    );
}
