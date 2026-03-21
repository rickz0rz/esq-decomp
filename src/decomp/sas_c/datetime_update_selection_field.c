#include <exec/types.h>

#define W(ptr, off) (*(WORD *)((UBYTE *)(ptr) + (off)))

extern LONG DATETIME_BuildFromGlobals(void *outStruct);
extern LONG DATETIME_ClassifyValueInRange(void *rangePtr, LONG value);

LONG DATETIME_UpdateSelectionField(void *entry)
{
    UBYTE scratch[22];
    LONG currentValue;
    LONG nextValue;
    LONG changed;

    changed = 0;
    if (entry == 0) {
        return changed;
    }

    currentValue = DATETIME_BuildFromGlobals(scratch);
    nextValue = DATETIME_ClassifyValueInRange(entry, currentValue);
    if (W(entry, 16) != (WORD)nextValue) {
        W(entry, 16) = (WORD)nextValue;
        changed = 1;
    }

    return changed;
}
