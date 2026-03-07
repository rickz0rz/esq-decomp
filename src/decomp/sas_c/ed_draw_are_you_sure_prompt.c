typedef signed long LONG;

extern void *Global_REF_GRAPHICS_LIBRARY;
extern void *Global_REF_RASTPORT_1;
extern const char Global_STR_ARE_YOU_SURE[];

extern void ED_DrawHelpPanels(LONG panelMode);
extern LONG _LVOSetDrMd(void *gfxBase, void *rastPort, LONG mode);
extern LONG _LVOSetAPen(void *gfxBase, void *rastPort, LONG pen);
extern LONG DISPLIB_DisplayTextAtPosition(void *rastPort, LONG y, LONG x, const char *text);

void ED_DrawAreYouSurePrompt(void)
{
    const LONG HELP_PANEL_MODE_ESC = 6;
    const LONG DRAWMODE_JAM1 = 0;
    const LONG DRAWMODE_JAM2 = 1;
    const LONG PEN_PRIMARY = 1;
    const LONG TEXT_Y = 330;
    const LONG TEXT_X = 40;

    ED_DrawHelpPanels(HELP_PANEL_MODE_ESC);

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, DRAWMODE_JAM1);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, PEN_PRIMARY);

    DISPLIB_DisplayTextAtPosition(
        Global_REF_RASTPORT_1,
        TEXT_Y,
        TEXT_X,
        Global_STR_ARE_YOU_SURE);

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, DRAWMODE_JAM2);
}
