typedef signed long LONG;

extern void *Global_REF_GRAPHICS_LIBRARY;
extern void *Global_REF_RASTPORT_1;

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
extern LONG DISPLIB_DisplayTextAtPosition(void *rastPort, LONG y, LONG x, const char *text);
extern LONG ESQIFF_JMPTBL_MATH_Mulu32(LONG a, LONG b);
extern LONG _LVOSetAPen(void *gfxBase, void *rastPort, LONG pen);
extern LONG _LVOSetBPen(void *gfxBase, void *rastPort, LONG pen);
extern LONG _LVOSetDrMd(void *gfxBase, void *rastPort, LONG mode);
extern LONG _LVORectFill(void *gfxBase, void *rastPort, LONG minX, LONG minY, LONG maxX, LONG maxY);

void ED_DrawAdEditingScreen(void)
{
    char printfResult[41];
    LONG topY;

    ED_DrawHelpPanels(6);

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 0);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 330, 40, Global_STR_PUSH_ESC_TO_MAKE_ANOTHER_SELECTION);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 360, 40, Global_STR_PUSH_HELP_FOR_OTHER_EDIT_FUNCTIONS);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 390, 40, Global_STR_LINE_MODE_ON_TEXT_COLOR_MODE);

    SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_LINE_OR_PAGE(Global_REF_BOOL_IS_LINE_OR_PAGE);
    SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR(Global_REF_BOOL_IS_TEXT_OR_CURSOR);

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 7);

    topY = 302 - ESQIFF_JMPTBL_MATH_Mulu32(8 - ED_TextLimit, 30);
    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 40, topY, 640, 308);

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
    _LVOSetBPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 7);

    GROUP_AM_JMPTBL_WDISP_SPrintf(
        printfResult,
        Global_STR_EDITING_AD_NUMBER_FORMATTED_1,
        Global_REF_LONG_CURRENT_EDITING_AD_NUMBER);

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 300, 190, printfResult);

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
    _LVOSetBPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 2);
}
