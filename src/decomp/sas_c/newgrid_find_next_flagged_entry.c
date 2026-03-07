typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern UBYTE TEXTDISP_PrimaryGroupPresentFlag;
extern UWORD TEXTDISP_PrimaryGroupEntryCount;

extern void *NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(LONG index, LONG mode);

LONG NEWGRID_FindNextFlaggedEntry(LONG modeSelector, LONG startIndex)
{
    LONG idx;
    LONG found;

    idx = startIndex;
    found = 0;

    if (modeSelector == 3) {
        idx = 0;
    } else if (modeSelector == 4) {
        idx = idx + 1;
    } else {
        found = 1;
    }

    if (found != 0) {
        return idx;
    }

    if (TEXTDISP_PrimaryGroupPresentFlag == 0) {
        return idx;
    }

    while (found == 0) {
        if (idx >= (LONG)(UWORD)TEXTDISP_PrimaryGroupEntryCount) {
            break;
        }

        {
            UBYTE *entry = (UBYTE *)NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(idx, 1);
            if (entry != 0) {
                if (((entry[47] & 0x01) != 0) && ((entry[40] & 0x80) != 0)) {
                    found = 1;
                    continue;
                }
            }
        }

        idx = idx + 1;
    }

    if (found == 0) {
        idx = -1;
    }

    return idx;
}
