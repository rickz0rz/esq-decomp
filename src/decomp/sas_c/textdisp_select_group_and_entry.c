typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern UWORD TEXTDISP_PrimaryFirstMatchIndex;
extern UWORD TEXTDISP_SecondaryFirstMatchIndex;
extern UWORD TEXTDISP_SbeFilterActiveFlag;
extern UWORD TEXTDISP_ActiveGroupId;
extern UWORD TEXTDISP_SecondaryGroupRecordLength;
extern UWORD TEXTDISP_CurrentMatchIndex;

extern UBYTE TEXTDISP_CandidateIndexList[];
extern UBYTE TEXTDISP_BannerCharSelected;
extern UBYTE TEXTDISP_BannerFallbackEntryIndex;
extern UBYTE TEXTDISP_BannerSelectedEntryIndex;

extern LONG TEXTDISP_BuildMatchIndexList(UBYTE *patternPtr, UWORD cmdChar);
extern LONG TEXTDISP_SelectBestMatchFromList(void *statePtr, LONG matchCount, LONG cmdChar, UBYTE *patternPtr);

LONG TEXTDISP_SelectGroupAndEntry(UBYTE *patternPtr, void *statePtr, UWORD cmdChar)
{
    LONG matchCount;
    LONG selectResult;

    TEXTDISP_PrimaryFirstMatchIndex = (UWORD)-1;
    TEXTDISP_SecondaryFirstMatchIndex = (UWORD)-1;
    TEXTDISP_SbeFilterActiveFlag = 0;

    TEXTDISP_ActiveGroupId = 1;
    matchCount = TEXTDISP_BuildMatchIndexList(patternPtr, cmdChar);
    selectResult = 0;

    if (matchCount != 0) {
        selectResult = TEXTDISP_SelectBestMatchFromList(statePtr, matchCount, cmdChar, patternPtr);
        TEXTDISP_PrimaryFirstMatchIndex = (UWORD)TEXTDISP_CandidateIndexList[0];
    }

    if (matchCount == 0 || selectResult == 0) {
        if (TEXTDISP_SecondaryGroupRecordLength > 0) {
            TEXTDISP_ActiveGroupId = 0;
            matchCount = TEXTDISP_BuildMatchIndexList(patternPtr, cmdChar);
            if (matchCount != 0) {
                selectResult = TEXTDISP_SelectBestMatchFromList(statePtr, matchCount, cmdChar, patternPtr);
                TEXTDISP_SecondaryFirstMatchIndex = (UWORD)TEXTDISP_CandidateIndexList[0];
            }
        }
    }

    if (matchCount == 0 || selectResult == 0) {
        TEXTDISP_ActiveGroupId = 1;
        return 0;
    }

    if (selectResult == 2) {
        if (TEXTDISP_BannerCharSelected == 100) {
            TEXTDISP_CurrentMatchIndex = (UWORD)TEXTDISP_BannerFallbackEntryIndex;
        } else {
            TEXTDISP_CurrentMatchIndex = (UWORD)TEXTDISP_BannerSelectedEntryIndex;
        }
    } else {
        TEXTDISP_CurrentMatchIndex = (UWORD)TEXTDISP_CandidateIndexList[0];
    }

    return 1;
}
