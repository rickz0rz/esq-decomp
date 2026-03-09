typedef unsigned short UWORD;
typedef signed long LONG;
typedef unsigned char UBYTE;

typedef struct LadfuncEntry {
    UWORD startSlot;
    UWORD endSlot;
    UWORD isHighlighted;
    char *textPtr;
} LadfuncEntry;

extern UBYTE ED_DiagTextModeChar;
extern UWORD WDISP_HighlightActive;
extern UWORD WDISP_HighlightIndex;
extern UWORD CLOCK_HalfHourSlotIndex;
extern LadfuncEntry *LADFUNC_EntryPtrTable[];

void LADFUNC_UpdateHighlightState(void)
{
    const UWORD FLAG_FALSE = 0;
    const UWORD FLAG_TRUE = 1;
    const UBYTE DIAG_MODE_NONE = 'N';
    const LONG ENTRY_COUNT = 47;
    LONG i;

    WDISP_HighlightActive = FLAG_FALSE;
    WDISP_HighlightIndex = FLAG_FALSE;

    if (ED_DiagTextModeChar == DIAG_MODE_NONE) {
        return;
    }

    for (i = 0; i < ENTRY_COUNT; ++i) {
        LadfuncEntry *entry = LADFUNC_EntryPtrTable[i];
        UWORD slot = CLOCK_HalfHourSlotIndex;

        entry->isHighlighted = FLAG_FALSE;
        if (entry->startSlot > slot) {
            continue;
        }
        if (entry->endSlot < slot) {
            continue;
        }
        if (entry->textPtr == (char *)0) {
            continue;
        }

        entry->isHighlighted = FLAG_TRUE;
        WDISP_HighlightActive = FLAG_TRUE;
    }
}
