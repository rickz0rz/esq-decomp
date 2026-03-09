typedef signed long LONG;

extern void *Global_REF_GRAPHICS_LIBRARY;
extern char *Global_REF_RASTPORT_1;

extern const char Global_STR_EDIT_ADS[];
extern const char Global_STR_EDIT_ATTRIBUTES[];
extern const char Global_STR_CHANGE_SCROLL_SPEED[];
extern const char Global_STR_DIAGNOSTIC_MODE[];
extern const char Global_STR_SPECIAL_FUNCTIONS[];
extern const char Global_STR_VERSIONS_SCREEN[];

extern void ED_DrawMenuSelectionHighlight(LONG menuIndex);
extern LONG _LVOSetAPen(void *gfxBase, char *rastPort, LONG pen);
extern LONG _LVOSetDrMd(void *gfxBase, char *rastPort, LONG mode);
extern LONG DISPLIB_DisplayTextAtPosition(char *rastPort, LONG y, LONG x, const char *text);

void ED_DrawEscMainMenuText(void)
{
    const LONG MENU_ITEM_COUNT = 6;
    const LONG PEN_PRIMARY = 1;
    const LONG DRAWMODE_JAM1 = 0;
    const LONG DRAWMODE_JAM2 = 1;
    const LONG TEXT_X = 40;
    const LONG ROW0_Y = 90;
    const LONG ROW_STEP_Y = 30;

    ED_DrawMenuSelectionHighlight(MENU_ITEM_COUNT);

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, PEN_PRIMARY);
    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, DRAWMODE_JAM1);

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, ROW0_Y + (ROW_STEP_Y * 0), TEXT_X, Global_STR_EDIT_ADS);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, ROW0_Y + (ROW_STEP_Y * 1), TEXT_X, Global_STR_EDIT_ATTRIBUTES);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, ROW0_Y + (ROW_STEP_Y * 2), TEXT_X, Global_STR_CHANGE_SCROLL_SPEED);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, ROW0_Y + (ROW_STEP_Y * 3), TEXT_X, Global_STR_DIAGNOSTIC_MODE);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, ROW0_Y + (ROW_STEP_Y * 4), TEXT_X, Global_STR_SPECIAL_FUNCTIONS);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, ROW0_Y + (ROW_STEP_Y * 5), TEXT_X, Global_STR_VERSIONS_SCREEN);

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, DRAWMODE_JAM2);
}
