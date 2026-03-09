typedef signed long LONG;

extern void *Global_REF_GRAPHICS_LIBRARY;
extern char *Global_REF_RASTPORT_1;

extern LONG Global_REF_BOOL_IS_LINE_OR_PAGE;
extern LONG Global_REF_BOOL_IS_TEXT_OR_CURSOR;
extern LONG Global_REF_LONG_CURRENT_EDITING_AD_NUMBER;
extern LONG ED_TextLimit;

extern const char Global_STR_PUSH_ESC_TO_MAKE_ANOTHER_SELECTION[];
extern const char Global_STR_PUSH_HELP_FOR_OTHER_EDIT_FUNCTIONS[];
extern const char Global_STR_LINE_MODE_ON_TEXT_COLOR_MODE[];
extern const char Global_STR_EDITING_AD_NUMBER_FORMATTED_1[];

extern void ED_DrawHelpPanels(LONG panelMode);
extern void SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_LINE_OR_PAGE(LONG isLineMode);
extern void SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR(LONG isTextMode);
extern LONG GROUP_AM_JMPTBL_WDISP_SPrintf(char *dst, const char *fmt, ...);
extern LONG DISPLIB_DisplayTextAtPosition(char *rastPort, LONG y, LONG x, const char *text);
extern LONG ESQIFF_JMPTBL_MATH_Mulu32(LONG a, LONG b);
extern LONG _LVOSetAPen(void *gfxBase, char *rastPort, LONG pen);
extern LONG _LVOSetBPen(void *gfxBase, char *rastPort, LONG pen);
extern LONG _LVOSetDrMd(void *gfxBase, char *rastPort, LONG mode);
extern LONG _LVORectFill(void *gfxBase, char *rastPort, LONG minX, LONG minY, LONG maxX, LONG maxY);

void ED_DrawAdEditingScreen(void)
{
    const LONG PANEL_MODE_EDIT_AD = 6;
    const LONG DRAWMODE_JAM1 = 0;
    const LONG DRAWMODE_COMPLEMENT = 1;
    const LONG PEN_TEXT = 1;
    const LONG PEN_HILITE = 7;
    const LONG PEN_DIM = 2;
    const LONG X_LEFT = 40;
    const LONG X_RIGHT = 640;
    const LONG Y_MSG1 = 330;
    const LONG Y_MSG2 = 360;
    const LONG Y_MSG3 = 390;
    const LONG Y_ADNUM = 300;
    const LONG X_ADNUM = 190;
    const LONG Y_TOP_BASE = 302;
    const LONG Y_BOTTOM = 308;
    const LONG TEXT_ROWS_MAX = 8;
    const LONG TEXT_ROW_PX = 30;
    char printfResult[41];
    LONG topY;

    ED_DrawHelpPanels(PANEL_MODE_EDIT_AD);

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, DRAWMODE_JAM1);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, PEN_TEXT);

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, Y_MSG1, X_LEFT, Global_STR_PUSH_ESC_TO_MAKE_ANOTHER_SELECTION);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, Y_MSG2, X_LEFT, Global_STR_PUSH_HELP_FOR_OTHER_EDIT_FUNCTIONS);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, Y_MSG3, X_LEFT, Global_STR_LINE_MODE_ON_TEXT_COLOR_MODE);

    SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_LINE_OR_PAGE(Global_REF_BOOL_IS_LINE_OR_PAGE);
    SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR(Global_REF_BOOL_IS_TEXT_OR_CURSOR);

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, PEN_HILITE);

    topY = Y_TOP_BASE - ESQIFF_JMPTBL_MATH_Mulu32(TEXT_ROWS_MAX - ED_TextLimit, TEXT_ROW_PX);
    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, X_LEFT, topY, X_RIGHT, Y_BOTTOM);

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, PEN_TEXT);
    _LVOSetBPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, PEN_HILITE);

    GROUP_AM_JMPTBL_WDISP_SPrintf(
        printfResult,
        Global_STR_EDITING_AD_NUMBER_FORMATTED_1,
        Global_REF_LONG_CURRENT_EDITING_AD_NUMBER);

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, Y_ADNUM, X_ADNUM, printfResult);

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, DRAWMODE_COMPLEMENT);
    _LVOSetBPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, PEN_DIM);
}
