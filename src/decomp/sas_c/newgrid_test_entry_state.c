#include <exec/types.h>
extern const char *ESQDISP_GetEntryPointerByMode(LONG index, LONG mode);
extern const char *ESQDISP_GetEntryAuxPointerByMode(LONG index, LONG mode);
extern LONG NEWGRID_GetEntryStateCode(const void *entryPtr, const void *entryAuxPtr, WORD selector);

LONG NEWGRID_TestEntryState(LONG mode, LONG primaryIndex, LONG secondaryIndex, WORD selector)
{
    const void *entryPtr;
    const void *entryAuxPtr;
    LONG state;
    LONG result = 0;

    if (selector > 48 || selector == 1) {
        entryPtr = ESQDISP_GetEntryPointerByMode(secondaryIndex, 2);
        entryAuxPtr = ESQDISP_GetEntryAuxPointerByMode(secondaryIndex, 2);

        while (selector > 48) {
            selector -= 48;
        }
    } else {
        entryPtr = ESQDISP_GetEntryPointerByMode(primaryIndex, 1);
        entryAuxPtr = ESQDISP_GetEntryAuxPointerByMode(primaryIndex, 1);
    }

    state = NEWGRID_GetEntryStateCode(entryPtr, entryAuxPtr, selector);

    if (mode == 0) {
        if (state == 0) {
            result = -1;
        }
    } else if (mode == 1) {
        if (state == 1 || state == 3) {
            result = 1;
        }
    } else if (mode == 2 || mode == 3) {
        if (state == 3) {
            result = -1;
        }
    }

    return result;
}
