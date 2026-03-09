typedef signed long LONG;

extern char *Global_REF_RASTPORT_1;
extern void *Global_REF_GRAPHICS_LIBRARY;
extern LONG ED_EditCursorOffset;

extern const char Global_STR_PUSH_ESC_TO_RESUME[];
extern const char Global_STR_PUSH_RETURN_TO_ENTER_SELECTION_1[];
extern const char Global_STR_PUSH_ANY_KEY_TO_SELECT_1[];

extern void ED_DrawHelpPanels(LONG mode);
extern LONG _LVOSetDrMd(void *gfxBase, char *rastPort, LONG mode);
extern LONG _LVOSetAPen(void *gfxBase, char *rastPort, LONG pen);
extern LONG DISPLIB_DisplayTextAtPosition(char *rastPort, LONG y, LONG x, const char *text);
extern void ED_DrawEscMainMenuText(void);

void ED_DrawESCMenuHelpText(void)
{
    const LONG HELP_PANEL_MODE_ESC = 6;
    const LONG DRAWMODE_JAM1 = 0;
    const LONG DRAWMODE_JAM2 = 1;
    const LONG PEN_PRIMARY = 1;
    const LONG TEXT_X = 40;
    const LONG ROW0_Y = 330;
    const LONG ROW_STEP_Y = 30;

    ED_DrawHelpPanels(HELP_PANEL_MODE_ESC);

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, DRAWMODE_JAM1);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, PEN_PRIMARY);

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, ROW0_Y + (ROW_STEP_Y * 0), TEXT_X, Global_STR_PUSH_ESC_TO_RESUME);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, ROW0_Y + (ROW_STEP_Y * 1), TEXT_X, Global_STR_PUSH_RETURN_TO_ENTER_SELECTION_1);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, ROW0_Y + (ROW_STEP_Y * 2), TEXT_X, Global_STR_PUSH_ANY_KEY_TO_SELECT_1);

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, DRAWMODE_JAM2);
    ED_EditCursorOffset = 0;
    ED_DrawEscMainMenuText();
}
