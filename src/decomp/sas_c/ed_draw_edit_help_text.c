typedef signed long LONG;

extern void *Global_REF_GRAPHICS_LIBRARY;
extern char *Global_REF_RASTPORT_1;

extern const char ED2_STR_PUSH_ANY_KEY_TO_CONTINUE_DOT[];
extern const char ED2_STR_STAR_STAR_LINE_SLASH_PAGE_COMMANDS_S[];
extern const char ED2_STR_F1_COLON_HOME_F6_COLON_CLEAR[];
extern const char ED2_STR_F2_COLON_LINE_SLASH_PAGE_MODE_F7_COL[];
extern const char ED2_CMD_F3_COLON_CENTER_F8_COLON_DELETE_LINE[];
extern const char ED2_STR_F4_COLON_LEFT_JUSTIFY_F9_COLON_APPLY[];
extern const char ED2_STR_F5_COLON_RIGHT_JUSTIFY_F10_COLON_INS[];
extern const char Global_STR_SHIFT_RIGHT_NEXT_AD_DEL_DELETE_CHAR[];
extern const char Global_STR_SHIFT_LEFT_PREV_AD_CTRLC_COLOR_MODE[];
extern const char Global_STR_CTRLF_FOREGROUND_CTRLB_BACKGROUND[];

extern void ED_DrawBottomHelpBarBackground(void);
extern void _LVOSetAPen(void *gfxBase, char *rastPort, LONG pen);
extern void _LVOSetDrMd(void *gfxBase, char *rastPort, LONG mode);
extern void _LVORectFill(void *gfxBase, char *rastPort, LONG minX, LONG minY, LONG maxX, LONG maxY);
extern void DISPLIB_DisplayTextAtPosition(char *rastPort, LONG y, LONG x, const char *text);

void ED_DrawEditHelpText(void)
{
    const LONG PEN_BG_DARK = 2;
    const LONG PEN_BG_LIGHT = 6;
    const LONG PEN_TEXT = 1;
    const LONG DRAWMODE_JAM1 = 0;
    const LONG DRAWMODE_COMPLEMENT = 1;
    const LONG X_LEFT = 40;
    const LONG X_RIGHT = 640;
    const LONG Y_TOP = 68;
    const LONG Y_SPLIT_TOP = 357;
    const LONG Y_SPLIT_BOTTOM = 358;
    const LONG Y_BOTTOM = 429;
    const LONG Y_FOOTER = 390;
    const LONG Y_LINE_1 = 90;
    const LONG Y_LINE_2 = 120;
    const LONG Y_LINE_3 = 150;
    const LONG Y_LINE_4 = 180;
    const LONG Y_LINE_5 = 210;
    const LONG Y_LINE_6 = 240;
    const LONG Y_LINE_7 = 270;
    const LONG Y_LINE_8 = 300;
    const LONG Y_LINE_9 = 330;
    ED_DrawBottomHelpBarBackground();

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, PEN_BG_DARK);
    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, X_LEFT, Y_TOP, X_RIGHT, Y_SPLIT_TOP);

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, PEN_BG_LIGHT);
    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, X_LEFT, Y_SPLIT_BOTTOM, X_RIGHT, Y_BOTTOM);

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, DRAWMODE_JAM1);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, PEN_TEXT);

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, Y_FOOTER, X_LEFT, ED2_STR_PUSH_ANY_KEY_TO_CONTINUE_DOT);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, Y_LINE_1, X_LEFT, ED2_STR_STAR_STAR_LINE_SLASH_PAGE_COMMANDS_S);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, Y_LINE_2, X_LEFT, ED2_STR_F1_COLON_HOME_F6_COLON_CLEAR);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, Y_LINE_3, X_LEFT, ED2_STR_F2_COLON_LINE_SLASH_PAGE_MODE_F7_COL);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, Y_LINE_4, X_LEFT, ED2_CMD_F3_COLON_CENTER_F8_COLON_DELETE_LINE);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, Y_LINE_5, X_LEFT, ED2_STR_F4_COLON_LEFT_JUSTIFY_F9_COLON_APPLY);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, Y_LINE_6, X_LEFT, ED2_STR_F5_COLON_RIGHT_JUSTIFY_F10_COLON_INS);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, Y_LINE_7, X_LEFT, Global_STR_SHIFT_RIGHT_NEXT_AD_DEL_DELETE_CHAR);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, Y_LINE_8, X_LEFT, Global_STR_SHIFT_LEFT_PREV_AD_CTRLC_COLOR_MODE);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, Y_LINE_9, X_LEFT, Global_STR_CTRLF_FOREGROUND_CTRLB_BACKGROUND);

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, DRAWMODE_COMPLEMENT);
}
