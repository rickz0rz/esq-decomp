typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern UBYTE TEXTDISP_PrimaryGroupPresentFlag;
extern UWORD TEXTDISP_PrimaryGroupEntryCount;

extern void *NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(LONG index, LONG mode);

LONG NEWGRID_FindNextEntryWithFlags(LONG scanMode, LONG startIndex)
{
    const LONG SCANMODE_RESET = 0;
    const LONG SCANMODE_NEXT = 4;
    const LONG MODE_PRIMARY = 1;
    const LONG INDEX_INVALID = -1;
    const LONG FLAG_FALSE = 0;
    const LONG FLAG_TRUE = 1;
    const LONG ENTRY_FLAGS_A_OFFSET = 47;
    const LONG ENTRY_FLAGS_B_OFFSET = 40;
    const UBYTE ENTRY_FLAG_A_MASK = 0x04;
    const UBYTE ENTRY_FLAG_B_MASK = 0x80;
    LONG idx;
    LONG found;

    idx = startIndex;
    found = FLAG_FALSE;

    if (scanMode == SCANMODE_RESET) {
        idx = FLAG_FALSE;
    } else if (scanMode == SCANMODE_NEXT) {
        idx = idx + 1;
    } else {
        found = FLAG_TRUE;
    }

    if (found != 0) {
        return idx;
    }

    while (found == FLAG_FALSE) {
        if (idx >= (LONG)(UWORD)TEXTDISP_PrimaryGroupEntryCount) {
            break;
        }

        if (TEXTDISP_PrimaryGroupPresentFlag == FLAG_FALSE) {
            break;
        }

        {
            UBYTE *entry = (UBYTE *)NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(idx, MODE_PRIMARY);
            if (entry != 0) {
                if (((entry[ENTRY_FLAGS_A_OFFSET] & ENTRY_FLAG_A_MASK) != 0) &&
                    ((entry[ENTRY_FLAGS_B_OFFSET] & ENTRY_FLAG_B_MASK) != 0)) {
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
