typedef signed long LONG;
typedef signed short WORD;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct NEWGRID_Entry {
    UBYTE pad0[47];
    UBYTE flags47;
} NEWGRID_Entry;

typedef struct NEWGRID_SelectionWindow {
    void *entry;
    void *aux;
    LONG index;
    LONG start;
    LONG end;
    UWORD row;
    UWORD initialRow;
    UWORD rowLimit;
} NEWGRID_SelectionWindow;

extern UWORD TEXTDISP_PrimaryGroupEntryCount;
extern UBYTE CLOCK_DaySlotIndex;
extern LONG GCOMMAND_PpvSelectionWindowMinutes;

extern const char *NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(LONG index, LONG mode);
extern LONG NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(UBYTE *slotPtr);
extern LONG SCRIPT3_JMPTBL_MATH_DivS32(LONG num, LONG den);

void NEWGRID_InitSelectionWindow(NEWGRID_SelectionWindow *ctx, WORD row)
{
    NEWGRID_SelectionWindow *window;
    LONG i;
    LONG q;

    if (ctx == 0) {
        return;
    }

    window = ctx;
    window->entry = 0;
    window->aux = 0;
    window->index = 0;

    if (row != 0) {
        window->start = (LONG)(UWORD)TEXTDISP_PrimaryGroupEntryCount;
        i = 0;
        while (i < window->start) {
            const NEWGRID_Entry *entry = (const NEWGRID_Entry *)NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(i, 1);
            if ((entry->flags47 & 0x10) != 0) {
                window->start = i;
            }
            ++i;
        }

        window->end = window->start;
        i = (LONG)(UWORD)TEXTDISP_PrimaryGroupEntryCount;
        while (i > window->end) {
            const NEWGRID_Entry *entry = (const NEWGRID_Entry *)NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(i - 1, 1);
            if ((entry->flags47 & 0x10) != 0) {
                window->end = i;
            }
            --i;
        }
    } else {
        window->start = 0;
        window->end = 0;
    }

    window->row = (UWORD)row;
    if (row < 48) {
        if (row == 1 || (NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(&CLOCK_DaySlotIndex) - 1) == 0) {
            window->row = (UWORD)(window->row + 48);
        }
    }

    window->initialRow = window->row;

    q = SCRIPT3_JMPTBL_MATH_DivS32(29 + GCOMMAND_PpvSelectionWindowMinutes, 30);
    window->rowLimit = (UWORD)((LONG)window->row + q);
    if (window->rowLimit > 96) {
        window->rowLimit = 96;
    }
    window->rowLimit = (UWORD)(window->rowLimit + 1);
}
