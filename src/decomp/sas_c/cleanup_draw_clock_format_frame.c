typedef unsigned short UWORD;
typedef long LONG;

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
    LONG x;
    LONG src_x;
    LONG dst_x;
    LONG width;

    x = (LONG)NEWGRID_ColumnStartXPx;
    src_x = x + 36;
    dst_x = x + 36;
    width = 660 - x;

    GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort(
        *(void **)(NEWGRID_MainRastPortPtr + 4),
        src_x,
        0,
        (void *)NEWGRID_MainRastPortPtr,
        dst_x,
        34,
        width,
        34,
        192
    );
}
