typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct LadfuncEntry {
    UWORD startSlot;
    UWORD endSlot;
    UWORD isHighlighted;
    UBYTE *textPtr;
    UBYTE *attrPtr;
} LadfuncEntry;

extern LadfuncEntry *LADFUNC_EntryPtrTable[];
extern UWORD LADFUNC_HighlightCycleCountdown;
extern UWORD LADFUNC_EntryCount;
extern UWORD LADFUNC_ParsedEntryCount;
extern UWORD WDISP_HighlightActive;
extern UWORD WDISP_HighlightIndex;
extern UBYTE ED_DiagScrollSpeedChar;
extern LONG ED_TextLimit;

void LADFUNC_ClearBannerRectEntries(void)
{
    UWORD i;

    for (i = 0; i <= 46; ++i) {
        LadfuncEntry *entry = LADFUNC_EntryPtrTable[i];
        entry->startSlot = 0;
        entry->endSlot = 0;
        entry->isHighlighted = 0;
        entry->textPtr = (UBYTE *)0;
        entry->attrPtr = (UBYTE *)0;
    }

    LADFUNC_HighlightCycleCountdown = 0;
    LADFUNC_EntryCount = 0;
    LADFUNC_ParsedEntryCount = 0;
    WDISP_HighlightActive = 0;
    WDISP_HighlightIndex = 0;

    ED_TextLimit = (LONG)ED_DiagScrollSpeedChar - 48;
}
