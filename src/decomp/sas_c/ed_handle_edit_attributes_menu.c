typedef signed long LONG;
typedef unsigned char UBYTE;

extern void *Global_REF_GRAPHICS_LIBRARY;
extern char *Global_REF_RASTPORT_1;

extern UBYTE ED_LastKeyCode;
extern LONG ED_EditCursorOffset;
extern char ED_EditBufferScratch[];
extern UBYTE ED_MenuStateId;
extern UBYTE ED_AdNumberInputDigitTens;
extern UBYTE ED_AdNumberInputDigitOnes;
extern LONG ED_MaxAdNumber;
extern LONG Global_REF_LONG_CURRENT_EDITING_AD_NUMBER;
extern LONG ED_SaveTextAdsOnExitFlag;
extern LONG ED_StateRingIndex;
extern UBYTE ED_StateRingTable[];
extern UBYTE ED_LastMenuInputChar;

extern const char ED2_STR_NUMBER_TOO_BIG[];
extern const char ED2_STR_NUMBER_TOO_SMALL[];
extern const char ED2_STR_PUSH_ESC_TO_EXIT_ATTRIBUTE_EDIT_DOT[];
extern const char ED2_STR_PUSH_RETURN_TO_ENTER_SELECTION[];
extern const char ED2_STR_PUSH_ANY_KEY_TO_SELECT[];

extern void ED_DrawCursorChar(void);
extern void ED_RedrawCursorChar(void);
extern void ED_DrawAdEditingScreen(void);
extern void ED_LoadCurrentAdIntoBuffers(void);
extern void ED_DrawHelpPanels(LONG panelMode);
extern void ED_UpdateAdNumberDisplay(void);
extern void DISPLIB_DisplayTextAtPosition(char *rastPort, LONG y, LONG x, const char *text);
extern void _LVOSetAPen(void *gfxBase, char *rastPort, LONG pen);
extern void _LVOSetDrMd(void *gfxBase, char *rastPort, LONG mode);

static LONG ED_ParseAdNumberFromDigits(void)
{
    UBYTE tens = ED_AdNumberInputDigitTens;
    UBYTE ones = ED_AdNumberInputDigitOnes;

    if (tens == ' ') {
        if (ones == ' ') {
            return 1;
        }
        return (LONG)(ones - '0');
    }

    if (ones == ' ') {
        return (LONG)(tens - '0');
    }

    return ((LONG)(tens - '0') * 10) + (LONG)(ones - '0');
}

void ED_HandleEditAttributesMenu(void)
{
    UBYTE key;

    ED_DrawCursorChar();
    key = ED_LastKeyCode;

    if (key == 8) {
        if (ED_EditCursorOffset > 12) {
            --ED_EditCursorOffset;
            ED_EditBufferScratch[ED_EditCursorOffset] = ' ';
        }
        ED_DrawCursorChar();
        ED_RedrawCursorChar();
        return;
    }

    if (key == 0x8E) {
        LONG ringOff = (ED_StateRingIndex << 2) + ED_StateRingIndex;
        UBYTE menuKey = ED_StateRingTable[ringOff + 1];
        ED_LastMenuInputChar = menuKey;

        if (menuKey == 67) {
            ED_EditCursorOffset = 13;
        } else if (menuKey == 68) {
            ED_EditCursorOffset = 12;
        }

        ED_RedrawCursorChar();
        return;
    }

    if (key == 13) {
        LONG adNum = ED_ParseAdNumberFromDigits();
        Global_REF_LONG_CURRENT_EDITING_AD_NUMBER = adNum;

        if (adNum > ED_MaxAdNumber) {
            _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 4);
            DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 150, 40, ED2_STR_NUMBER_TOO_BIG);
            _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
            return;
        }

        if (adNum == 0) {
            _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 4);
            DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 150, 40, ED2_STR_NUMBER_TOO_SMALL);
            _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
            return;
        }

        if (ED_MenuStateId == 2) {
            ED_MenuStateId = 4;
            ED_DrawAdEditingScreen();
            ED_LoadCurrentAdIntoBuffers();
            ED_SaveTextAdsOnExitFlag = 1;
            return;
        }

        ED_MenuStateId = 5;
        ED_DrawHelpPanels(6);
        ED_UpdateAdNumberDisplay();

        _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 0);
        _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 330, 40, ED2_STR_PUSH_ESC_TO_EXIT_ATTRIBUTE_EDIT_DOT);
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 360, 40, ED2_STR_PUSH_RETURN_TO_ENTER_SELECTION);
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 390, 40, ED2_STR_PUSH_ANY_KEY_TO_SELECT);
        _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
        return;
    }

    if (key >= '0' && key <= '9') {
        ED_DrawCursorChar();
        ED_EditBufferScratch[ED_EditCursorOffset] = key;

        if (ED_EditCursorOffset < 13) {
            ED_DrawCursorChar();
            ++ED_EditCursorOffset;
            ED_EditBufferScratch[ED_EditCursorOffset] = key;
        }
    }

    ED_RedrawCursorChar();
}
