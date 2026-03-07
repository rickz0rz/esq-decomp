typedef signed long LONG;
typedef signed short WORD;

extern WORD TEXTDISP_PrimaryGroupEntryCount;
extern WORD TEXTDISP_SecondaryGroupEntryCount;

LONG TEXTDISP_GetGroupEntryCount(LONG groupIndex)
{
    const LONG GROUP_PRIMARY = 1;
    const LONG GROUP_SECONDARY = 2;
    const LONG GROUP_INVALID_COUNT = 0;
    LONG count;

    if (groupIndex == GROUP_PRIMARY) {
        count = (LONG)TEXTDISP_PrimaryGroupEntryCount;
    } else if (groupIndex == GROUP_SECONDARY) {
        count = (LONG)TEXTDISP_SecondaryGroupEntryCount;
    } else {
        count = GROUP_INVALID_COUNT;
    }

    return count;
}
