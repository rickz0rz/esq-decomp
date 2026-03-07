typedef unsigned short UWORD;
typedef signed long LONG;
typedef unsigned char UBYTE;

typedef struct LadfuncEntry {
    UWORD startSlot;
    UWORD endSlot;
    UWORD isHighlighted;
    UBYTE *textPtr;
} LadfuncEntry;

extern UBYTE ED_DiagTextModeChar;
extern UWORD WDISP_HighlightActive;
extern UWORD WDISP_HighlightIndex;
extern UWORD CLOCK_HalfHourSlotIndex;
extern LadfuncEntry *LADFUNC_EntryPtrTable[];

void LADFUNC_UpdateHighlightState(void)
{
    LONG i;

    WDISP_HighlightActive = 0;
    WDISP_HighlightIndex = 0;

    if (ED_DiagTextModeChar == 78) {
        return;
    }

    for (i = 0; i < 47; ++i) {
        LadfuncEntry *entry = LADFUNC_EntryPtrTable[i];
        UWORD slot = CLOCK_HalfHourSlotIndex;

        entry->isHighlighted = 0;
        if (entry->startSlot > slot) {
            continue;
        }
        if (entry->endSlot < slot) {
            continue;
        }
        if (entry->textPtr == 0) {
            continue;
        }

        entry->isHighlighted = 1;
        WDISP_HighlightActive = 1;
    }
}
