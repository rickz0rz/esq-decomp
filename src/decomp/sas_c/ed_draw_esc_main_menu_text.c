typedef signed long LONG;

extern void *Global_REF_GRAPHICS_LIBRARY;
extern void *Global_REF_RASTPORT_1;

extern const char Global_STR_EDIT_ADS[];
extern const char Global_STR_EDIT_ATTRIBUTES[];
extern const char Global_STR_CHANGE_SCROLL_SPEED[];
extern const char Global_STR_DIAGNOSTIC_MODE[];
extern const char Global_STR_SPECIAL_FUNCTIONS[];
extern const char Global_STR_VERSIONS_SCREEN[];

extern void ED_DrawMenuSelectionHighlight(LONG menuIndex);
extern LONG _LVOSetAPen(void *gfxBase, void *rastPort, LONG pen);
extern LONG _LVOSetDrMd(void *gfxBase, void *rastPort, LONG mode);
extern LONG DISPLIB_DisplayTextAtPosition(void *rastPort, LONG y, LONG x, const char *text);

void ED_DrawEscMainMenuText(void)
{
    ED_DrawMenuSelectionHighlight(6);

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 0);

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 90, 40, Global_STR_EDIT_ADS);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 120, 40, Global_STR_EDIT_ATTRIBUTES);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 150, 40, Global_STR_CHANGE_SCROLL_SPEED);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 180, 40, Global_STR_DIAGNOSTIC_MODE);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 210, 40, Global_STR_SPECIAL_FUNCTIONS);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 240, 40, Global_STR_VERSIONS_SCREEN);

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
}
