typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

typedef struct NEWGRID_SelectionWindow {
    void *entry;
    void *aux;
    LONG index;
    LONG start;
    LONG end;
    WORD row;
    WORD initialRow;
    WORD rowLimit;
} NEWGRID_SelectionWindow;

extern UBYTE CLOCK_DaySlotIndex;
extern UBYTE CONFIG_NewgridWindowSpanHalfHoursPrimary;
extern UBYTE CONFIG_NewgridWindowSpanHalfHoursAlt;

extern LONG NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(UBYTE *slotPtr);

void NEWGRID_InitSelectionWindowAlt(char *ctx, WORD row, LONG useAltSpan)
{
    NEWGRID_SelectionWindow *window;
    LONG span;
    LONG end;

    if (ctx == 0) {
        return;
    }

    window = (NEWGRID_SelectionWindow *)ctx;
    window->entry = 0;
    window->aux = 0;
    window->index = 0;
    window->row = row;

    if (row < 48) {
        if (row == 1 || (NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(&CLOCK_DaySlotIndex) - 1) == 0) {
            window->row = (WORD)(window->row + 48);
        }
    }

    window->initialRow = window->row;

    if (useAltSpan == 0) {
        span = (LONG)(signed char)CONFIG_NewgridWindowSpanHalfHoursPrimary;
    } else {
        span = (LONG)(signed char)CONFIG_NewgridWindowSpanHalfHoursAlt;
    }

    end = (LONG)window->row + span;
    window->rowLimit = (WORD)end;
    if (window->rowLimit > 96) {
        window->rowLimit = 96;
    }
    window->rowLimit = (WORD)(window->rowLimit + 1);
}
