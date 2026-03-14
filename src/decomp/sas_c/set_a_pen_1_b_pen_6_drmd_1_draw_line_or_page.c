#include <exec/types.h>
extern char *Global_REF_RASTPORT_1;
extern void *Global_REF_GRAPHICS_LIBRARY;
extern LONG Global_REF_BOOL_IS_LINE_OR_PAGE;
extern const char Global_STR_LINE[];
extern const char Global_STR_PAGE[];

extern void _LVOSetAPen(void *gfxBase, char *rastPort, LONG pen);
extern void _LVOSetBPen(void *gfxBase, char *rastPort, LONG pen);
extern void _LVOSetDrMd(void *gfxBase, char *rastPort, LONG mode);
extern void DISPLIB_DisplayTextAtPosition(char *rastPort, LONG x, LONG y, const char *text);

void SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_LINE_OR_PAGE(void)
{
    const char *label;

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
    _LVOSetBPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 6);
    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);

    if (Global_REF_BOOL_IS_LINE_OR_PAGE == 0) {
        label = Global_STR_LINE;
    } else {
        label = Global_STR_PAGE;
    }

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 390, label);

    _LVOSetBPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 2);
    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 0);
}
