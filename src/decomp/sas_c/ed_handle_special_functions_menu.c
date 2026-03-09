typedef signed long LONG;
typedef unsigned char UBYTE;

extern void *Global_REF_GRAPHICS_LIBRARY;
extern char *Global_REF_RASTPORT_1;

extern LONG ED_EditCursorOffset;
extern LONG ED_TempCopyOffset;
extern UBYTE ED_MenuStateId;

extern const char ED2_STR_ALL_DATA_IS_TO_BE_SAVED_DOT[];
extern const char ED2_STR_TV_GUIDE_DATA_IS_TO_BE_SAVED_DOT[];
extern const char ED2_STR_TEXT_ADS_WILL_BE_LOADED_FROM_DH2_COL[];
extern const char Global_STR_COMPUTER_WILL_RESET[];
extern const char Global_STR_GO_OFF_AIR_FOR_1_2_MINS[];

extern LONG ED_GetEscMenuActionCode(void);
extern void ED_DrawAreYouSurePrompt(void);
extern void ED_DrawMenuSelectionHighlight(LONG menuBase);
extern void ED_DrawDiagnosticRegisterValues(void);
extern void ED_DrawESCMenuBottomHelp(void);
extern void ED_DrawSpecialFunctionsMenu(void);
extern LONG DISPLIB_DisplayTextAtPosition(char *rastPort, LONG y, LONG x, const char *text);
extern LONG _LVOSetAPen(void *gfxBase, char *rastPort, LONG pen);
extern LONG _LVORectFill(void *gfxBase, char *rastPort, LONG minX, LONG minY, LONG maxX, LONG maxY);

static void ED_DrawSpecialMenuSelection(void)
{
    ED_DrawMenuSelectionHighlight(4);
    ED_DrawSpecialFunctionsMenu();
}

static void ED_DrawColorBars(void)
{
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 0);
    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 40, 328, 115, 399);

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 115, 328, 190, 399);

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 2);
    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 190, 328, 265, 399);

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 3);
    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 265, 328, 340, 399);

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 4);
    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 340, 328, 415, 399);

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 5);
    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 415, 328, 490, 399);

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 6);
    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 490, 328, 565, 399);

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 7);
    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 565, 328, 640, 399);
}

void ED_HandleSpecialFunctionsMenu(void)
{
    LONG actionCode = (LONG)(UBYTE)ED_GetEscMenuActionCode();

    switch (actionCode) {
        case 0:
            ED_DrawESCMenuBottomHelp();
            return;

        case 1:
            ED_DrawAreYouSurePrompt();
            DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 90, 40, ED2_STR_ALL_DATA_IS_TO_BE_SAVED_DOT);
            ED_MenuStateId = 0x0b;
            return;

        case 2:
            ED_DrawAreYouSurePrompt();
            DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 90, 40, ED2_STR_TV_GUIDE_DATA_IS_TO_BE_SAVED_DOT);
            ED_MenuStateId = 0x0c;
            return;

        case 3:
            ED_DrawAreYouSurePrompt();
            DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 90, 40, ED2_STR_TEXT_ADS_WILL_BE_LOADED_FROM_DH2_COL);
            ED_MenuStateId = 0x0d;
            return;

        case 4:
            ED_DrawAreYouSurePrompt();
            DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 90, 40, Global_STR_COMPUTER_WILL_RESET);
            DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 120, 40, Global_STR_GO_OFF_AIR_FOR_1_2_MINS);
            ED_MenuStateId = 0x0e;
            return;

        case 7:
            --ED_EditCursorOffset;
            if (ED_EditCursorOffset < 0) {
                ED_EditCursorOffset = 3;
            }
            ED_DrawSpecialMenuSelection();
            return;

        case 6:
            if (ED_EditCursorOffset == 2) {
                ED_MenuStateId = 0x0f;
                ED_DrawColorBars();
                ED_TempCopyOffset = 0;
                ED_DrawDiagnosticRegisterValues();
                return;
            }
            /* fallthrough */

        case 5:
        default:
            ++ED_EditCursorOffset;
            if (ED_EditCursorOffset == 4) {
                ED_EditCursorOffset = 0;
            }
            ED_DrawSpecialMenuSelection();
            return;
    }
}
