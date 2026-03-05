typedef signed long LONG;
typedef signed short WORD;

extern WORD TEXTDISP_PrimaryGroupEntryCount;
extern WORD TEXTDISP_SecondaryGroupEntryCount;

LONG TEXTDISP_GetGroupEntryCount(LONG groupIndex)
{
    LONG count;

    if (groupIndex == 1) {
        count = (LONG)TEXTDISP_PrimaryGroupEntryCount;
    } else if (groupIndex == 2) {
        count = (LONG)TEXTDISP_SecondaryGroupEntryCount;
    } else {
        count = 0;
    }

    return count;
}
