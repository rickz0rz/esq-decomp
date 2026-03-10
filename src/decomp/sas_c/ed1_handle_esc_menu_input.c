typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern void *Global_REF_GRAPHICS_LIBRARY;
extern char *Global_REF_RASTPORT_1;

extern UBYTE ED_DiagTextModeChar;
extern LONG ED_SavedScrollSpeedIndex;
extern LONG ED_EditCursorOffset;
extern UBYTE ED_MenuStateId;
extern WORD ESQ_ShutdownRequestedFlag;

extern const char ED2_STR_LOCAL_EDIT_NOT_AVAILABLE[];

extern LONG ED_GetEscMenuActionCode(void);
extern void ED1_EnterEscMenu_AfterVersionText(void);
extern void ED_DrawAdNumberPrompt(void);
extern void ED_DrawDiagnosticModeHelpText(void);
extern void ED_DrawMenuSelectionHighlight(LONG menuBase);
extern void ED_DrawScrollSpeedMenuText(void);
extern void ED1_DrawDiagnosticsScreen(void);
extern void ED_DrawSpecialFunctionsMenu(void);
extern void ED_DrawBottomHelpBarBackground(void);
extern void ED_DrawEscMainMenuText(void);
extern LONG ESQIFF_JMPTBL_MATH_DivS32(LONG a, LONG b);
extern void DISPLIB_DisplayTextAtPosition(char *rastPort, LONG y, LONG x, const char *text);
extern LONG _LVOSetAPen(void *gfxBase, char *rastPort, LONG pen);

void ED1_HandleEscMenuInput(void)
{
    LONG action = (LONG)(UBYTE)ED_GetEscMenuActionCode();
    LONG errorCode = 0;

    if (action < 9) {
        switch (action) {
            case 0:
                ED1_EnterEscMenu_AfterVersionText();
                break;

            case 1:
                if (ED_DiagTextModeChar == 76) {
                    ED_DrawAdNumberPrompt();
                    ED_MenuStateId = 2;
                } else {
                    errorCode = 1;
                }
                break;

            case 2:
                if (ED_DiagTextModeChar == 76) {
                    ED_DrawAdNumberPrompt();
                    ED_MenuStateId = 3;
                } else {
                    errorCode = 1;
                }
                break;

            case 3:
                ED_MenuStateId = 6;
                ED_DrawDiagnosticModeHelpText();
                ED_EditCursorOffset = ED_SavedScrollSpeedIndex;
                ED_DrawMenuSelectionHighlight(9);
                ED_DrawScrollSpeedMenuText();
                break;

            case 4:
                ED1_DrawDiagnosticsScreen();
                break;

            case 5:
                ED_MenuStateId = 0x0a;
                ED_DrawDiagnosticModeHelpText();
                ED_EditCursorOffset = 0;
                ED_DrawMenuSelectionHighlight(4);
                ED_DrawSpecialFunctionsMenu();
                break;

            case 6:
                ED_MenuStateId = 8;
                ED_DrawBottomHelpBarBackground();
                break;

            case 8:
                ESQ_ShutdownRequestedFlag = 1;
                break;

            default:
                break;
        }
    }

    if (action == 7 || action >= 9) {
        LONG step = (action == 9) ? 5 : 1;
        ED_EditCursorOffset += step;
        ED_EditCursorOffset = ED_EditCursorOffset % 6;
        ED_DrawEscMainMenuText();
    }

    if (errorCode != 0) {
        _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 4);

        if (errorCode == 1) {
            DISPLIB_DisplayTextAtPosition(
                Global_REF_RASTPORT_1,
                270,
                145,
                ED2_STR_LOCAL_EDIT_NOT_AVAILABLE);
        }

        _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
    }
}
