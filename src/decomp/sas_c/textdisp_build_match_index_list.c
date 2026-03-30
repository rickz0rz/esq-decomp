#include <exec/types.h>

typedef struct TEXTDISP_CandidateEntry {
    char shortName[10];
    char longName[2];
    char tagText[15];
    UBYTE flags27;
    UBYTE pad28[12];
    UBYTE editFlags40;
} TEXTDISP_CandidateEntry;

extern UWORD TEXTDISP_ActiveGroupId;
extern UWORD TEXTDISP_PrimaryGroupEntryCount;
extern UWORD TEXTDISP_SecondaryGroupEntryCount;
extern UWORD TEXTDISP_SbeFilterActiveFlag;
extern UWORD TEXTDISP_FindModeActiveFlag;
extern UBYTE TEXTDISP_CandidateIndexList[];

extern const char *TEXTDISP_PrimaryTitlePtrTable[];
extern TEXTDISP_CandidateEntry *TEXTDISP_PrimaryEntryPtrTable[];
extern const char *TEXTDISP_SecondaryTitlePtrTable[];
extern TEXTDISP_CandidateEntry *TEXTDISP_SecondaryEntryPtrTable[];

extern const char TEXTDISP_Tag_PPV[];
extern const char TEXTDISP_Tag_SBE[];
extern const char TEXTDISP_Tag_SPORTS[];
extern const char TEXTDISP_Tag_SPT_Filter[];
extern const char TEXTDISP_Tag_FIND1[];
extern const char Global_STR_ASTERISK_2[];
extern const char Global_STR_ASTERISK_3[];

extern LONG ESQ_WildcardMatch(const char *a, const char *b);
extern LONG TEXTDISP_ShouldOpenEditorForEntry(const TEXTDISP_CandidateEntry *entry);

#define TEXTDISP_GROUP_PRIMARY 1
#define TEXTDISP_MATCH_FALSE 0
#define TEXTDISP_MATCH_TRUE 1
#define TEXTDISP_SPORTS_MATCH_TRUE -1
#define TEXTDISP_BIT_SHIFT_HIDDEN 3
#define TEXTDISP_BIT_SHIFT_PPV_SBE 4
#define TEXTDISP_BIT_SHIFT_EDITABLE 7
#define TEXTDISP_CMD_EDIT 69

LONG TEXTDISP_BuildMatchIndexList(const char *patternPtr, UWORD cmdChar)
{
    LONG matchCount;
    LONG idx;
    LONG entryCount;
    LONG ppvOrSbeFlag;
    LONG sportsFilterFlag;
    const char *title;
    TEXTDISP_CandidateEntry *entry;
    const char *findPtr;
    const char *scanPtr;

    matchCount = 0;
    if (patternPtr == 0) {
        return TEXTDISP_MATCH_FALSE;
    }

    if (ESQ_WildcardMatch(patternPtr, TEXTDISP_Tag_PPV) == 0) {
        ppvOrSbeFlag = TEXTDISP_MATCH_TRUE;
    } else if (ESQ_WildcardMatch(patternPtr, TEXTDISP_Tag_SBE) == 0) {
        TEXTDISP_SbeFilterActiveFlag = TEXTDISP_MATCH_TRUE;
        ppvOrSbeFlag = TEXTDISP_MATCH_TRUE;
    } else {
        ppvOrSbeFlag = TEXTDISP_MATCH_FALSE;
    }

    sportsFilterFlag =
        (ESQ_WildcardMatch(patternPtr, TEXTDISP_Tag_SPORTS) == 0)
            ? TEXTDISP_SPORTS_MATCH_TRUE
            : TEXTDISP_MATCH_FALSE;
    if (ESQ_WildcardMatch(patternPtr, TEXTDISP_Tag_SPT_Filter) == 0) {
        patternPtr = Global_STR_ASTERISK_2;
    }

    findPtr = TEXTDISP_Tag_FIND1;
    scanPtr = patternPtr;
    while (*findPtr == *scanPtr) {
        if (*findPtr == 0) {
            TEXTDISP_FindModeActiveFlag = TEXTDISP_MATCH_TRUE;
            patternPtr = Global_STR_ASTERISK_3;
            break;
        }

        ++findPtr;
        ++scanPtr;
    }
    if (*findPtr != *scanPtr) {
        TEXTDISP_FindModeActiveFlag = TEXTDISP_MATCH_FALSE;
    }

    if (TEXTDISP_ActiveGroupId == TEXTDISP_GROUP_PRIMARY) {
        entryCount = (LONG)TEXTDISP_PrimaryGroupEntryCount;
    } else {
        entryCount = (LONG)TEXTDISP_SecondaryGroupEntryCount;
    }

    idx = 0;
    while (idx < entryCount) {
        if (TEXTDISP_ActiveGroupId == TEXTDISP_GROUP_PRIMARY) {
            title = TEXTDISP_PrimaryTitlePtrTable[idx];
            entry = TEXTDISP_PrimaryEntryPtrTable[idx];
        } else {
            title = TEXTDISP_SecondaryTitlePtrTable[idx];
            entry = TEXTDISP_SecondaryEntryPtrTable[idx];
        }

        if ((entry->flags27 & (1u << TEXTDISP_BIT_SHIFT_HIDDEN)) != 0) {
            idx += 1;
            continue;
        }
        if (cmdChar == TEXTDISP_CMD_EDIT &&
            (entry->editFlags40 & (1u << TEXTDISP_BIT_SHIFT_EDITABLE)) == 0) {
            idx += 1;
            continue;
        }

        if (ppvOrSbeFlag != 0 &&
            (entry->flags27 & (1u << TEXTDISP_BIT_SHIFT_PPV_SBE)) != 0) {
            TEXTDISP_CandidateIndexList[matchCount++] = (UBYTE)idx;
            idx += 1;
            continue;
        }

        if (sportsFilterFlag != 0) {
            if (TEXTDISP_ShouldOpenEditorForEntry(entry) != 0) {
                TEXTDISP_CandidateIndexList[matchCount++] = (UBYTE)idx;
            }
            idx += 1;
            continue;
        }

        if (ESQ_WildcardMatch(patternPtr, title) == 0) {
            TEXTDISP_CandidateIndexList[matchCount++] = (UBYTE)idx;
        }
        idx += 1;
    }

    return matchCount;
}
