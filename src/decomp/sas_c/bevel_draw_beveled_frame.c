#include <exec/types.h>

/* OS graphics calls restored from bevel.s (base-first _LVO ABI):
   SetAPen A1=rp,D0=pen ; Move A1=rp,D0=x,D1=y ; Draw A1=rp,D0=x,D1=y.
   Entry regs: A3=rastPort, D7=leftX, D6=topY, D5=rightX, D4=bottomY. */
extern void *Global_REF_GRAPHICS_LIBRARY;
extern void _LVOSetAPen(void *gfxBase, char *rp, LONG pen);
extern void _LVOMove(void *gfxBase, char *rp, LONG x, LONG y);
extern void _LVODraw(void *gfxBase, char *rp, LONG x, LONG y);

void BEVEL_DrawVerticalBevelPair(char *rastPort, LONG leftX, LONG topY, LONG rightX, LONG bottomY);
void BEVEL_DrawVerticalBevel(char *rastPort, LONG x, LONG topY, LONG bottomY);

void BEVEL_DrawBeveledFrame(char *rastPort, LONG leftX, LONG topY, LONG rightX, LONG bottomY)
{
    BEVEL_DrawVerticalBevelPair(rastPort, leftX, topY, rightX, bottomY);
    BEVEL_DrawVerticalBevel(rastPort, leftX, topY, bottomY);

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rastPort, 2);
    _LVOMove(Global_REF_GRAPHICS_LIBRARY, rastPort, leftX, topY);
    _LVODraw(Global_REF_GRAPHICS_LIBRARY, rastPort, leftX + 3, topY + 3);
}
