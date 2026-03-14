#include <graphics/gfx.h>

extern UWORD WDISP_HighlightRasterHeightPx;
extern void *Global_REF_GRAPHICS_LIBRARY;
extern const char Global_STR_ESQDISP_C[];

extern void _LVOInitBitMap(void *bitmap, LONG depth, LONG width, LONG height);
extern void *_LVOBltClear(void *dst, ULONG byteSize, LONG flags);
extern void *ESQDISP_JMPTBL_GRAPHICS_AllocRaster(const char *tag, LONG line, LONG width, LONG height);

void ESQDISP_AllocateHighlightBitmaps(struct BitMap *bm)
{
    LONG plane;
    ULONG height;

    height = (ULONG)WDISP_HighlightRasterHeightPx;
    _LVOInitBitMap(bm, 3, 696, height);

    for (plane = 0; plane < 3; ++plane) {
        bm->Planes[plane] = ESQDISP_JMPTBL_GRAPHICS_AllocRaster(
            Global_STR_ESQDISP_C,
            79,
            696,
            (LONG)WDISP_HighlightRasterHeightPx);

        _LVOBltClear(
            bm->Planes[plane],
            ((ULONG)WDISP_HighlightRasterHeightPx) * 0x58UL,
            0);
    }
}
