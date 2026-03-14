#include <exec/types.h>
extern UBYTE TEXTDISP_PrimaryGroupPresentFlag;
extern UWORD TEXTDISP_PrimaryGroupEntryCount;

extern const char *ESQDISP_GetEntryPointerByMode(LONG index, LONG mode);

LONG NEWGRID_FindNextFlaggedEntry(LONG modeSelector, LONG startIndex)
{
    const LONG MODE_RESET = 3;
    const LONG MODE_NEXT = 4;
    const LONG MODE_PRIMARY = 1;
    const LONG INDEX_INVALID = -1;
    const LONG FLAG_FALSE = 0;
    const LONG FLAG_TRUE = 1;
    LONG idx;
    LONG found;

    idx = startIndex;
    found = FLAG_FALSE;

    if (modeSelector == MODE_RESET) {
        idx = FLAG_FALSE;
    } else if (modeSelector == MODE_NEXT) {
        idx = idx + 1;
    } else {
        found = FLAG_TRUE;
    }

    if (found != 0) {
        return idx;
    }

    if (TEXTDISP_PrimaryGroupPresentFlag == FLAG_FALSE) {
        return idx;
    }

    while (found == FLAG_FALSE) {
        if (idx >= (LONG)(UWORD)TEXTDISP_PrimaryGroupEntryCount) {
            break;
        }

        {
            const UBYTE *entry = (const UBYTE *)ESQDISP_GetEntryPointerByMode(idx, MODE_PRIMARY);
            if (entry != 0) {
                if (((entry[47] & 0x01) != 0) &&
                    ((entry[40] & 0x80) != 0)) {
                    found = FLAG_TRUE;
                    continue;
                }
            }
        }

        idx = idx + 1;
    }

    if (found == FLAG_FALSE) {
        idx = INDEX_INVALID;
    }

    return idx;
}
