typedef signed long LONG;

extern void *Global_REF_GRAPHICS_LIBRARY;
extern char *Global_REF_RASTPORT_1;

extern const char Global_STR_PUSH_RETURN_TO_ENTER_SELECTION_3[];
extern const char Global_STR_PUSH_ANY_KEY_TO_SELECT_2[];

extern void _LVOSetAPen(void *gfxBase, char *rastPort, LONG pen);
extern void _LVOSetDrMd(void *gfxBase, char *rastPort, LONG mode);
extern void _LVORectFill(void *gfxBase, char *rastPort, LONG minX, LONG minY, LONG maxX, LONG maxY);
extern void DISPLIB_DisplayTextAtPosition(char *rastPort, LONG y, LONG x, const char *text);

void ED_DrawDiagnosticModeHelpText(void)
{
    const LONG PEN_BACKGROUND = 2;
    const LONG PEN_HIGHLIGHT = 6;
    const LONG PEN_TEXT = 1;
    const LONG DRAWMODE_JAM1 = 0;
    const LONG MIN_X = 40;
    const LONG MAX_X = 640;
    const LONG TOP_MIN_Y = 68;
    const LONG TOP_MAX_Y = 327;
    const LONG BOTTOM_MIN_Y = 328;
    const LONG BOTTOM_MAX_Y = 429;
    const LONG HELP_ROW_1_Y = 390;
    const LONG HELP_ROW_2_Y = 420;

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, PEN_BACKGROUND);
    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, MIN_X, TOP_MIN_Y, MAX_X, TOP_MAX_Y);

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, PEN_HIGHLIGHT);
    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, MIN_X, BOTTOM_MIN_Y, MAX_X, BOTTOM_MAX_Y);

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, DRAWMODE_JAM1);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, PEN_TEXT);

    DISPLIB_DisplayTextAtPosition(
        Global_REF_RASTPORT_1,
        HELP_ROW_1_Y,
        MIN_X,
        Global_STR_PUSH_RETURN_TO_ENTER_SELECTION_3);

    DISPLIB_DisplayTextAtPosition(
        Global_REF_RASTPORT_1,
        HELP_ROW_2_Y,
        MIN_X,
        Global_STR_PUSH_ANY_KEY_TO_SELECT_2);
}
