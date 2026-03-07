typedef signed long LONG;

extern void *Global_REF_GRAPHICS_LIBRARY;
extern void *Global_REF_RASTPORT_1;

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
extern LONG _LVOSetAPen(void *gfxBase, void *rastPort, LONG pen);
extern LONG _LVOSetDrMd(void *gfxBase, void *rastPort, LONG mode);
extern LONG _LVORectFill(void *gfxBase, void *rastPort, LONG minX, LONG minY, LONG maxX, LONG maxY);
extern LONG DISPLIB_DisplayTextAtPosition(void *rastPort, LONG y, LONG x, const char *text);

void ED_DrawEditHelpText(void)
{
    ED_DrawBottomHelpBarBackground();

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 2);
    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 40, 68, 640, 357);

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 6);
    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 40, 358, 640, 429);

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 0);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 390, 40, ED2_STR_PUSH_ANY_KEY_TO_CONTINUE_DOT);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 90, 40, ED2_STR_STAR_STAR_LINE_SLASH_PAGE_COMMANDS_S);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 120, 40, ED2_STR_F1_COLON_HOME_F6_COLON_CLEAR);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 150, 40, ED2_STR_F2_COLON_LINE_SLASH_PAGE_MODE_F7_COL);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 180, 40, ED2_CMD_F3_COLON_CENTER_F8_COLON_DELETE_LINE);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 210, 40, ED2_STR_F4_COLON_LEFT_JUSTIFY_F9_COLON_APPLY);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 240, 40, ED2_STR_F5_COLON_RIGHT_JUSTIFY_F10_COLON_INS);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 270, 40, Global_STR_SHIFT_RIGHT_NEXT_AD_DEL_DELETE_CHAR);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 300, 40, Global_STR_SHIFT_LEFT_PREV_AD_CTRLC_COLOR_MODE);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 330, 40, Global_STR_CTRLF_FOREGROUND_CTRLB_BACKGROUND);

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
}
