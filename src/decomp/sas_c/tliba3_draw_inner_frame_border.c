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

extern void *Global_REF_GRAPHICS_LIBRARY;
extern LONG _LVOMove(void *gfxBase, void *rastPort, LONG x, LONG y);
extern LONG _LVODraw(void *gfxBase, void *rastPort, LONG x, LONG y);

void TLIBA3_DrawInnerFrameBorder(TLIBA3_RastPortWrap *rp)
{
    LONG maxX;
    LONG maxY;

    _LVOMove(Global_REF_GRAPHICS_LIBRARY, rp, 0, 0);

    maxX = (((LONG)rp->dims->width) << 3) - 1;
    maxY = ((LONG)rp->dims->height) - 1;
    _LVODraw(Global_REF_GRAPHICS_LIBRARY, rp, maxX, maxY);

    maxX = (((LONG)rp->dims->width) << 3) - 1;
    _LVOMove(Global_REF_GRAPHICS_LIBRARY, rp, maxX, 0);

    maxY = ((LONG)rp->dims->height) - 1;
    _LVODraw(Global_REF_GRAPHICS_LIBRARY, rp, 0, maxY);
}
