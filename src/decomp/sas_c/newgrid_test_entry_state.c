typedef signed long LONG;
typedef signed short WORD;

extern const char *NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(LONG index, LONG mode);
extern const char *NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(LONG index, LONG mode);
extern LONG NEWGRID_GetEntryStateCode(const void *entryPtr, const void *entryAuxPtr, WORD selector);

LONG NEWGRID_TestEntryState(LONG mode, LONG primaryIndex, LONG secondaryIndex, WORD selector)
{
    const LONG MODE_PRIMARY = 1;
    const LONG MODE_SECONDARY = 2;
    const WORD SLOT_WRAP = 48;
    const WORD SLOT_PRIMARY_FIRST = 1;
    const LONG RESULT_FALSE = 0;
    const LONG RESULT_TRUE = 1;
    const LONG RESULT_MATCH = -1;
    const LONG TEST_MODE_UNSET = 0;
    const LONG TEST_MODE_PRESENT = 1;
    const LONG TEST_MODE_BLOCKED_A = 2;
    const LONG TEST_MODE_BLOCKED_B = 3;
    const LONG STATE_UNSET = 0;
    const LONG STATE_PRESENT = 1;
    const LONG STATE_BLOCKED = 3;
    const char *entryPtr;
    const char *entryAuxPtr;
    LONG state;
    LONG result;

    result = RESULT_FALSE;

    if (selector > SLOT_WRAP || selector == SLOT_PRIMARY_FIRST) {
        entryPtr = NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(secondaryIndex, MODE_SECONDARY);
        entryAuxPtr = NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(secondaryIndex, MODE_SECONDARY);

        while (selector > SLOT_WRAP) {
            selector -= SLOT_WRAP;
        }
    } else {
        entryPtr = NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(primaryIndex, MODE_PRIMARY);
        entryAuxPtr = NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(primaryIndex, MODE_PRIMARY);
    }

    state = NEWGRID_GetEntryStateCode(entryPtr, entryAuxPtr, selector);

    if (mode == TEST_MODE_UNSET) {
        if (state == STATE_UNSET) {
            result = RESULT_MATCH;
        } else {
            result = RESULT_FALSE;
        }
    } else if (mode == TEST_MODE_PRESENT) {
        if (state == STATE_PRESENT || state == STATE_BLOCKED) {
            result = RESULT_TRUE;
        } else {
            result = RESULT_FALSE;
        }
    } else if (mode == TEST_MODE_BLOCKED_A || mode == TEST_MODE_BLOCKED_B) {
        if (state == STATE_BLOCKED) {
            result = RESULT_MATCH;
        } else {
            result = RESULT_FALSE;
        }
    }

    return result;
}
