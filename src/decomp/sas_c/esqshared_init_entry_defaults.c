#include <exec/types.h>
typedef struct ESQSHARED_Entry {
    UBYTE pad0[40];
    UBYTE editMode40;
    UBYTE overridePen41;
    UBYTE overrideLayoutPen42;
    UBYTE codeText43[3];
    UWORD flags46;
} ESQSHARED_Entry;

extern UBYTE ESQPARS_DefaultEntryCodeString[];

void ESQSHARED_InitEntryDefaults(UBYTE *entry)
{
    ESQSHARED_Entry *entryView;
    UBYTE *dst;
    UBYTE *src;

    entryView = (ESQSHARED_Entry *)entry;

    entryView->editMode40 = 2;
    entryView->overridePen41 = (UBYTE)(BYTE)-1;
    entryView->overrideLayoutPen42 = (UBYTE)(BYTE)-1;

    dst = entryView->codeText43;
    src = ESQPARS_DefaultEntryCodeString;
    do {
        *dst++ = *src;
    } while (*src++ != 0);

    entryView->flags46 = 3;
}
