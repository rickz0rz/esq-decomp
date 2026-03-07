typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern UBYTE *NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(LONG index, LONG mode);
extern UBYTE *NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(LONG index, LONG mode);
extern LONG NEWGRID_GetEntryStateCode(UBYTE *entryPtr, UBYTE *entryAuxPtr, WORD selector);

LONG NEWGRID_TestEntryState(LONG mode, LONG primaryIndex, LONG secondaryIndex, WORD selector)
{
    UBYTE *entryPtr;
    UBYTE *entryAuxPtr;
    LONG state;
    LONG result;

    result = 0;

    if (selector > 48 || selector == 1) {
        entryPtr = NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(secondaryIndex, 2);
        entryAuxPtr = NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(secondaryIndex, 2);

        while (selector > 48) {
            selector -= 48;
        }
    } else {
        entryPtr = NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(primaryIndex, 1);
        entryAuxPtr = NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(primaryIndex, 1);
    }

    state = NEWGRID_GetEntryStateCode(entryPtr, entryAuxPtr, selector);

    if (mode == 0) {
        if (state == 0) {
            result = -1;
        } else {
            result = 0;
        }
    } else if (mode == 1) {
        if (state == 1 || state == 3) {
            result = 1;
        } else {
            result = 0;
        }
    } else if (mode == 2 || mode == 3) {
        if (state == 3) {
            result = -1;
        } else {
            result = 0;
        }
    }

    return result;
}
