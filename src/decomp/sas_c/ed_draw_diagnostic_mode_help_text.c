typedef signed long LONG;

extern void *Global_REF_GRAPHICS_LIBRARY;
extern void *Global_REF_RASTPORT_1;

extern const char Global_STR_PUSH_RETURN_TO_ENTER_SELECTION_3[];
extern const char Global_STR_PUSH_ANY_KEY_TO_SELECT_2[];

extern LONG _LVOSetAPen(void *gfxBase, void *rastPort, LONG pen);
extern LONG _LVOSetDrMd(void *gfxBase, void *rastPort, LONG mode);
extern LONG _LVORectFill(void *gfxBase, void *rastPort, LONG minX, LONG minY, LONG maxX, LONG maxY);
extern LONG DISPLIB_DisplayTextAtPosition(void *rastPort, LONG y, LONG x, const char *text);

void ED_DrawDiagnosticModeHelpText(void)
{
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 2);
    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 40, 68, 640, 327);

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 6);
    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 40, 328, 640, 429);

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 0);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);

    DISPLIB_DisplayTextAtPosition(
        Global_REF_RASTPORT_1,
        390,
        40,
        Global_STR_PUSH_RETURN_TO_ENTER_SELECTION_3);

    DISPLIB_DisplayTextAtPosition(
        Global_REF_RASTPORT_1,
        420,
        40,
        Global_STR_PUSH_ANY_KEY_TO_SELECT_2);
}
