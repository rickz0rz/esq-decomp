typedef unsigned short UWORD;
typedef unsigned long ULONG;
typedef signed long LONG;

typedef struct BitMap {
    UWORD BytesPerRow;
    UWORD Rows;
    UWORD Flags;
    UWORD Depth;
    void *Planes[8];
} BitMap;

extern UWORD WDISP_HighlightRasterHeightPx;
extern void *Global_REF_GRAPHICS_LIBRARY;
extern const char Global_STR_ESQDISP_C[];

extern void _LVOInitBitMap(void);
extern void *_LVOBltClear(void);
extern void *ESQDISP_JMPTBL_GRAPHICS_AllocRaster(void);

void ESQDISP_AllocateHighlightBitmaps(BitMap *bm)
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
