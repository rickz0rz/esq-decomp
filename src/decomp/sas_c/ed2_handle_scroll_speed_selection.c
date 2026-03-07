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
    LONG ringOff = (ED_StateRingIndex << 2) + ED_StateRingIndex;
    UBYTE key = ED_StateRingTable[ringOff];

    ED_LastKeyCode = key;
    ED_LastMenuInputChar = ED_StateRingTable[ringOff + 1];

    if (key == 13 || key == 27) {
        ED_SavedScrollSpeedIndex = ED_EditCursorOffset;

        if (ED_EditCursorOffset == 0) {
            ESQPARS2_StateIndex = (WORD)((LONG)ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED - 48);
        } else {
            ESQPARS2_StateIndex = (WORD)(ED_EditCursorOffset - 1);
        }

        ED_DrawESCMenuBottomHelp();
        return;
    }

    if (key == 0x9b) {
        if (ED_LastMenuInputChar == 65) {
            --ED_EditCursorOffset;
            if (ED_EditCursorOffset < 0) {
                ED_EditCursorOffset = 8;
            }
        } else {
            ++ED_EditCursorOffset;
            if (ED_EditCursorOffset == 1) {
                ED_EditCursorOffset = 3;
            } else if (ED_EditCursorOffset == 9) {
                ED_EditCursorOffset = 0;
            }
        }

        ED_DrawMenuSelectionHighlight(9);
        ED_DrawScrollSpeedMenuText();
        return;
    }

    ++ED_EditCursorOffset;
    if (ED_EditCursorOffset == 1) {
        ED_EditCursorOffset = 3;
    } else if (ED_EditCursorOffset == 9) {
        ED_EditCursorOffset = 0;
    }

    ED_DrawMenuSelectionHighlight(9);
    ED_DrawScrollSpeedMenuText();
}
