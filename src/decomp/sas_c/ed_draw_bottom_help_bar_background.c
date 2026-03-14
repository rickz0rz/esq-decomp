#include <exec/types.h>
extern char *Global_REF_RASTPORT_1;
extern void *Global_REF_GRAPHICS_LIBRARY;

extern void _LVOSetAPen(void *gfxBase, char *rastPort, LONG pen);
extern void _LVOSetDrMd(void *gfxBase, char *rastPort, LONG mode);
extern void _LVORectFill(char *rastPort, LONG x1, LONG y1, LONG x2, LONG y2);

void ED_DrawBottomHelpBarBackground(void)
{
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 2);
    _LVORectFill(Global_REF_RASTPORT_1, 40, 68, 680, 429);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
}
