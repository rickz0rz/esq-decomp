#include <exec/types.h>

typedef struct TLIBA3_DimBlock {
    UWORD width;
    UWORD height;
} TLIBA3_DimBlock;

typedef struct TLIBA3_RastPortWrap {
    void *unused0;
    TLIBA3_DimBlock *dims;
} TLIBA3_RastPortWrap;

extern void *Global_REF_GRAPHICS_LIBRARY;
extern void *Global_HANDLE_PREVUEC_FONT;
extern void *Global_HANDLE_TOPAZ_FONT;

extern void _LVOSetFont(void *gfxBase, char *rastPort, void *font);
extern void _LVOSetAPen(void *gfxBase, char *rastPort, LONG pen);
extern void _LVOSetDrMd(void *gfxBase, char *rastPort, LONG mode);
extern void TLIBA3_DrawVerticalScaleTicks(TLIBA3_RastPortWrap *rp, LONG x);
extern void TLIBA3_DrawHorizontalScaleTicks(TLIBA3_RastPortWrap *rp, LONG y);
extern void TLIBA3_DrawOuterFrameBorder(TLIBA3_RastPortWrap *rp);
extern void TLIBA3_DrawInnerFrameBorder(TLIBA3_RastPortWrap *rp);

void TLIBA3_DrawViewModeGuides(TLIBA3_RastPortWrap *rp)
{
    LONG halfWidthPixels;
    LONG halfHeight;

    _LVOSetFont(Global_REF_GRAPHICS_LIBRARY, (char *)rp, Global_HANDLE_TOPAZ_FONT);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, (char *)rp, 1);
    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, (char *)rp, 0);

    halfWidthPixels = ((LONG)rp->dims->width) << 3;
    if (halfWidthPixels < 0) {
        halfWidthPixels++;
    }
    halfWidthPixels >>= 1;
    TLIBA3_DrawVerticalScaleTicks(rp, halfWidthPixels);

    halfHeight = (LONG)rp->dims->height;
    if (halfHeight < 0) {
        halfHeight++;
    }
    halfHeight >>= 1;
    TLIBA3_DrawHorizontalScaleTicks(rp, halfHeight);

    TLIBA3_DrawOuterFrameBorder(rp);
    TLIBA3_DrawInnerFrameBorder(rp);

    _LVOSetFont(Global_REF_GRAPHICS_LIBRARY, (char *)rp, Global_HANDLE_PREVUEC_FONT);
}
