typedef signed long LONG;

extern char *Global_REF_RASTPORT_1;
extern void *Global_REF_GRAPHICS_LIBRARY;

extern void _LVOSetAPen(void *gfxBase, char *rastPort, LONG pen);
extern void _LVOSetDrMd(void *gfxBase, char *rastPort, LONG mode);
extern void _LVORectFill(char *rastPort, LONG x1, LONG y1, LONG x2, LONG y2);

void ED_DrawHelpPanels(LONG penIndex)
{
    const LONG PEN_DARK_BACKGROUND = 2;
    const LONG RECT_MIN_X = 40;
    const LONG RECT_MAX_X = 640;
    const LONG TOP_MIN_Y = 68;
    const LONG TOP_MAX_Y = 297;
    const LONG BOTTOM_MIN_Y = 298;
    const LONG BOTTOM_MAX_Y = 429;
    const LONG DRAWMODE_JAM1 = 0;

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, PEN_DARK_BACKGROUND);
    _LVORectFill(Global_REF_RASTPORT_1, RECT_MIN_X, TOP_MIN_Y, RECT_MAX_X, TOP_MAX_Y);

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, penIndex);
    _LVORectFill(Global_REF_RASTPORT_1, RECT_MIN_X, BOTTOM_MIN_Y, RECT_MAX_X, BOTTOM_MAX_Y);

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, DRAWMODE_JAM1);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
}
