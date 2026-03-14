#include <exec/types.h>
typedef struct LadfuncEntry {
    UWORD startSlot;
    UWORD endSlot;
    UWORD isHighlighted;
    char *textPtr;
    UBYTE *attrPtr;
} LadfuncEntry;

extern UWORD LADFUNC_EntryCount;
extern LadfuncEntry *LADFUNC_EntryPtrTable[];

extern LONG MATH_DivS32(LONG a, LONG b);
extern void LADFUNC_DrawEntryPreview(LONG entryIndex);

void TEXTDISP_DrawNextEntryPreview(void)
{
    for (;;) {
        if (LADFUNC_EntryPtrTable[(LONG)(UWORD)LADFUNC_EntryCount]->isHighlighted == 1) {
            break;
        }

        LADFUNC_EntryCount = (UWORD)MATH_DivS32((LONG)(UWORD)LADFUNC_EntryCount + 1, 46);
    }

    LADFUNC_DrawEntryPreview((LONG)(UWORD)LADFUNC_EntryCount);
    LADFUNC_EntryCount = (UWORD)((UWORD)LADFUNC_EntryCount + 1);
}
