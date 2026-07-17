#include <exec/types.h>

enum {
    RASTPORT_AOLPEN_OFFSET = 30,
    RASTPORT_FLAGS1_OFFSET = 33,
    RASTPORT_LINPAT_OFFSET = 34,
    BEVEL_LINE_PATTERN_SOLID = -1,
    BEVEL_STYLE_PEN = 15,
    BEVEL_DRAW_MODE_FLAG = 1
};

/* base-first _LVO ABI. Entry regs: A3=rastPort, D7=leftX, D6=topY, D5=rightX,
   D4=bottomY. Left edge draws top->bottom at pen 1; right edge bottom->top at
   pen 2; 4 parallel lines each (x stepping in/out). */
extern void *Global_REF_GRAPHICS_LIBRARY;
extern void _LVOSetDrMd(void *gfxBase, char *rp, LONG mode);
extern void _LVOSetAPen(void *gfxBase, char *rp, LONG pen);
extern void _LVOMove(void *gfxBase, char *rp, LONG x, LONG y);
extern void _LVODraw(void *gfxBase, char *rp, LONG x, LONG y);

void BEVEL_DrawVerticalBevelPair(char *rastPort, LONG leftX, LONG topY, LONG rightX, LONG bottomY)
{
    LONG rastPortAddr;

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, rastPort, 0);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rastPort, 1);
    *(short *)((LONG)rastPort + RASTPORT_LINPAT_OFFSET) = BEVEL_LINE_PATTERN_SOLID;
    *(unsigned char *)((LONG)rastPort + RASTPORT_FLAGS1_OFFSET) |= BEVEL_DRAW_MODE_FLAG;
    *(unsigned char *)((LONG)rastPort + RASTPORT_AOLPEN_OFFSET) = BEVEL_STYLE_PEN;

    _LVOMove(Global_REF_GRAPHICS_LIBRARY, rastPort, leftX, topY);
    _LVODraw(Global_REF_GRAPHICS_LIBRARY, rastPort, leftX, bottomY);

    leftX++;
    _LVOMove(Global_REF_GRAPHICS_LIBRARY, rastPort, leftX, topY);
    _LVODraw(Global_REF_GRAPHICS_LIBRARY, rastPort, leftX, bottomY);

    leftX++;
    _LVOMove(Global_REF_GRAPHICS_LIBRARY, rastPort, leftX, topY);
    _LVODraw(Global_REF_GRAPHICS_LIBRARY, rastPort, leftX, bottomY);

    leftX++;
    _LVOMove(Global_REF_GRAPHICS_LIBRARY, rastPort, leftX, topY);
    _LVODraw(Global_REF_GRAPHICS_LIBRARY, rastPort, leftX, bottomY);

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rastPort, 2);
    rastPortAddr = (LONG)rastPort;
    *(short *)(rastPortAddr + RASTPORT_LINPAT_OFFSET) = BEVEL_LINE_PATTERN_SOLID;
    *(unsigned char *)(rastPortAddr + RASTPORT_FLAGS1_OFFSET) =
        *(unsigned char *)(rastPortAddr + RASTPORT_FLAGS1_OFFSET) | BEVEL_DRAW_MODE_FLAG;
    *(unsigned char *)(rastPortAddr + RASTPORT_AOLPEN_OFFSET) = BEVEL_STYLE_PEN;

    _LVOMove(Global_REF_GRAPHICS_LIBRARY, rastPort, rightX, bottomY);
    _LVODraw(Global_REF_GRAPHICS_LIBRARY, rastPort, rightX, topY);

    rightX--;
    _LVOMove(Global_REF_GRAPHICS_LIBRARY, rastPort, rightX, bottomY);
    _LVODraw(Global_REF_GRAPHICS_LIBRARY, rastPort, rightX, topY);

    rightX--;
    _LVOMove(Global_REF_GRAPHICS_LIBRARY, rastPort, rightX, bottomY);
    _LVODraw(Global_REF_GRAPHICS_LIBRARY, rastPort, rightX, topY);

    rightX--;
    _LVOMove(Global_REF_GRAPHICS_LIBRARY, rastPort, rightX, bottomY);
    _LVODraw(Global_REF_GRAPHICS_LIBRARY, rastPort, rightX, topY);
}
