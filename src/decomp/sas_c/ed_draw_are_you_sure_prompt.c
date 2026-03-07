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
    ED_DrawHelpPanels(6);

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 0);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);

    DISPLIB_DisplayTextAtPosition(
        Global_REF_RASTPORT_1,
        330,
        40,
        Global_STR_ARE_YOU_SURE);

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
}
