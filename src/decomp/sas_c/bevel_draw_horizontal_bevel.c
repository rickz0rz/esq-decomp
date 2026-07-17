#include <exec/types.h>

enum {
    BEVEL_STROKE_INDEX_START = 0,
    RASTPORT_AOLPEN_OFFSET = 30,
    RASTPORT_FLAGS1_OFFSET = 33,
    RASTPORT_LINPAT_OFFSET = 34,
    BEVEL_LINE_PATTERN_SOLID = -1,
    BEVEL_STYLE_PEN = 15,
    BEVEL_DRAW_MODE_FLAG = 1,
    BEVEL_STROKE_COUNT = 4
};

/* base-first _LVO ABI. Entry regs: A3=rastPort, D7=leftX, D6=rightX, D5=bottomY
   (topY is unused). Each stroke i: Move(rightX, bottomY-i) -> Draw(leftX+i,
   bottomY-i); then a pen-6 finishing stroke Move(rightX,bottomY)->Draw(rightX-3,
   bottomY-3). */
extern void *Global_REF_GRAPHICS_LIBRARY;
extern void _LVOSetDrMd(void *gfxBase, char *rp, LONG mode);
extern void _LVOSetAPen(void *gfxBase, char *rp, LONG pen);
extern void _LVOMove(void *gfxBase, char *rp, LONG x, LONG y);
extern void _LVODraw(void *gfxBase, char *rp, LONG x, LONG y);

void BEVEL_DrawHorizontalBevel(char *rastPort, LONG leftX, LONG topY, LONG rightX, LONG bottomY)
{
    LONG i;

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, rastPort, 0);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rastPort, 2);

    for (i = BEVEL_STROKE_INDEX_START; i < BEVEL_STROKE_COUNT; i++) {
        *(short *)((LONG)rastPort + RASTPORT_LINPAT_OFFSET) = BEVEL_LINE_PATTERN_SOLID;
        *(unsigned char *)((LONG)rastPort + RASTPORT_FLAGS1_OFFSET) |= BEVEL_DRAW_MODE_FLAG;
        *(unsigned char *)((LONG)rastPort + RASTPORT_AOLPEN_OFFSET) = BEVEL_STYLE_PEN;

        _LVOMove(Global_REF_GRAPHICS_LIBRARY, rastPort, rightX, bottomY - i);
        _LVODraw(Global_REF_GRAPHICS_LIBRARY, rastPort, leftX + i, bottomY - i);
    }

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rastPort, 6);
    _LVOMove(Global_REF_GRAPHICS_LIBRARY, rastPort, rightX, bottomY);
    _LVODraw(Global_REF_GRAPHICS_LIBRARY, rastPort, rightX - 3, bottomY - 3);
}

