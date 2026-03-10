typedef signed long LONG;
typedef unsigned short UWORD;

typedef struct TLIBA3_DimBlock {
    UWORD width;
    UWORD height;
} TLIBA3_DimBlock;

typedef struct TLIBA3_RastPortWrap {
    void *unused0;
    TLIBA3_DimBlock *dims;
} TLIBA3_RastPortWrap;

enum {
    BORDER_ZERO = 0,
    WIDTH_TO_PIXEL_SHIFT = 3,
    BORDER_MINUS_ONE = 1
};

extern void *Global_REF_GRAPHICS_LIBRARY;
extern void _LVOMove(void *gfxBase, char *rastPort, LONG x, LONG y);
extern LONG _LVODraw(void *gfxBase, char *rastPort, LONG x, LONG y);

void TLIBA3_DrawOuterFrameBorder(TLIBA3_RastPortWrap *rp)
{
    LONG maxX;
    LONG maxY;

    _LVOMove(Global_REF_GRAPHICS_LIBRARY, (char *)rp, BORDER_ZERO, BORDER_ZERO);

    maxX = (((LONG)rp->dims->width) << WIDTH_TO_PIXEL_SHIFT) - BORDER_MINUS_ONE;
    _LVODraw(Global_REF_GRAPHICS_LIBRARY, (char *)rp, maxX, BORDER_ZERO);

    maxX = (((LONG)rp->dims->width) << WIDTH_TO_PIXEL_SHIFT) - BORDER_MINUS_ONE;
    maxY = ((LONG)rp->dims->height) - BORDER_MINUS_ONE;
    _LVODraw(Global_REF_GRAPHICS_LIBRARY, (char *)rp, maxX, maxY);

    maxY = ((LONG)rp->dims->height) - BORDER_MINUS_ONE;
    _LVODraw(Global_REF_GRAPHICS_LIBRARY, (char *)rp, BORDER_ZERO, maxY);

    _LVODraw(Global_REF_GRAPHICS_LIBRARY, (char *)rp, BORDER_ZERO, BORDER_ZERO);
}
