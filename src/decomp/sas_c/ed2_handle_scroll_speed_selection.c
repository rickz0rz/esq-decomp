typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern LONG ED_StateRingIndex;
extern UBYTE ED_StateRingTable[];
extern UBYTE ED_LastKeyCode;
extern UBYTE ED_LastMenuInputChar;
extern LONG ED_EditCursorOffset;
extern LONG ED_SavedScrollSpeedIndex;
extern UBYTE ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED;
extern WORD ESQPARS2_StateIndex;

extern void ED_DrawESCMenuBottomHelp(void);
extern void ED_DrawMenuSelectionHighlight(LONG menuBase);
extern void ED_DrawScrollSpeedMenuText(void);

void ED2_HandleScrollSpeedSelection(void)
{
    const LONG RING_STRIDE_SHIFT = 2;
    const LONG RING_NEXT_OFFSET = 1;
    const UBYTE KEY_RETURN = 13;
    const UBYTE KEY_ESCAPE = 27;
    const UBYTE KEY_CSI = 0x9b;
    const UBYTE CSI_UP = 65;
    const LONG CURSOR_WRAP_UP = 8;
    const LONG CURSOR_SKIP = 1;
    const LONG CURSOR_MIN_AFTER_SKIP = 3;
    const LONG CURSOR_RESET = 0;
    const LONG MENU_BASE = 9;
    const LONG SCROLL_ASCII_ZERO = 48;
    LONG ringOff = (ED_StateRingIndex << RING_STRIDE_SHIFT) + ED_StateRingIndex;
    UBYTE key = ED_StateRingTable[ringOff];

    ED_LastKeyCode = key;
    ED_LastMenuInputChar = ED_StateRingTable[ringOff + RING_NEXT_OFFSET];

    if (key == KEY_RETURN || key == KEY_ESCAPE) {
        ED_SavedScrollSpeedIndex = ED_EditCursorOffset;

        if (ED_EditCursorOffset == CURSOR_RESET) {
            ESQPARS2_StateIndex = (WORD)((LONG)ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED - SCROLL_ASCII_ZERO);
        } else {
            ESQPARS2_StateIndex = (WORD)(ED_EditCursorOffset - RING_NEXT_OFFSET);
        }

        ED_DrawESCMenuBottomHelp();
        return;
    }

    if (key == KEY_CSI) {
        if (ED_LastMenuInputChar == CSI_UP) {
            --ED_EditCursorOffset;
            if (ED_EditCursorOffset < 0) {
                ED_EditCursorOffset = CURSOR_WRAP_UP;
            }
        } else {
            ++ED_EditCursorOffset;
            if (ED_EditCursorOffset == CURSOR_SKIP) {
                ED_EditCursorOffset = CURSOR_MIN_AFTER_SKIP;
            } else if (ED_EditCursorOffset == 9) {
                ED_EditCursorOffset = 0;
            }
        }

        ED_DrawMenuSelectionHighlight(MENU_BASE);
        ED_DrawScrollSpeedMenuText();
        return;
    }

    ++ED_EditCursorOffset;
    if (ED_EditCursorOffset == CURSOR_SKIP) {
        ED_EditCursorOffset = CURSOR_MIN_AFTER_SKIP;
    } else if (ED_EditCursorOffset == 9) {
        ED_EditCursorOffset = 0;
    }

    ED_DrawMenuSelectionHighlight(MENU_BASE);
    ED_DrawScrollSpeedMenuText();
}
