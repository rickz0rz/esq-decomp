typedef signed long LONG;

extern void *Global_REF_RASTPORT_1;
extern void *Global_REF_GRAPHICS_LIBRARY;
extern LONG ED_EditCursorOffset;

extern const char Global_STR_PUSH_ESC_TO_RESUME[];
extern const char Global_STR_PUSH_RETURN_TO_ENTER_SELECTION_1[];
extern const char Global_STR_PUSH_ANY_KEY_TO_SELECT_1[];

extern void ED_DrawHelpPanels(LONG mode);
extern LONG _LVOSetDrMd(void *gfxBase, void *rastPort, LONG mode);
extern LONG _LVOSetAPen(void *gfxBase, void *rastPort, LONG pen);
extern LONG DISPLIB_DisplayTextAtPosition(void *rastPort, LONG y, LONG x, const char *text);
extern void ED_DrawEscMainMenuText(void);

void ED_DrawESCMenuHelpText(void)
{
    ED_DrawHelpPanels(6);

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 0);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 330, 40, Global_STR_PUSH_ESC_TO_RESUME);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 360, 40, Global_STR_PUSH_RETURN_TO_ENTER_SELECTION_1);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 390, 40, Global_STR_PUSH_ANY_KEY_TO_SELECT_1);

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
    ED_EditCursorOffset = 0;
    ED_DrawEscMainMenuText();
}
