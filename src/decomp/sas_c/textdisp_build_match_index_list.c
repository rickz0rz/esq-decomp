typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct TEXTDISP_CandidateEntry {
    UBYTE shortName[10];
    UBYTE longName[2];
    UBYTE tagText[15];
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

extern char *TEXTDISP_PrimaryTitlePtrTable[];
extern TEXTDISP_CandidateEntry *TEXTDISP_PrimaryEntryPtrTable[];
extern char *TEXTDISP_SecondaryTitlePtrTable[];
extern TEXTDISP_CandidateEntry *TEXTDISP_SecondaryEntryPtrTable[];

extern const char TEXTDISP_Tag_PPV[];
extern const char TEXTDISP_Tag_SBE[];
extern const char TEXTDISP_Tag_SPORTS[];
extern const char TEXTDISP_Tag_SPT_Filter[];
extern const char TEXTDISP_Tag_FIND1[];
extern const char Global_STR_ASTERISK_2[];
extern const char Global_STR_ASTERISK_3[];

extern LONG UNKNOWN_JMPTBL_ESQ_WildcardMatch(const char *a, const char *b);
extern LONG TEXTDISP_ShouldOpenEditorForEntry(void *entry);

LONG TEXTDISP_BuildMatchIndexList(UBYTE *patternPtr, UWORD cmdChar)
{
    const LONG GROUP_PRIMARY = 1;
    const LONG MATCH_FALSE = 0;
    const LONG MATCH_TRUE = 1;
    const LONG SPORTS_MATCH_TRUE = -1;
    const LONG BIT_SHIFT_HIDDEN = 3;
    const LONG BIT_SHIFT_PPV_SBE = 4;
    const LONG BIT_SHIFT_EDITABLE = 7;
    const UWORD CMD_EDIT = 69;
    LONG matchCount;
    LONG idx;
    LONG entryCount;
    LONG ppvOrSbeFlag;
    LONG sportsFilterFlag;
    char *title;
    TEXTDISP_CandidateEntry *entry;

    matchCount = 0;
    if (patternPtr == (UBYTE *)0) {
        return MATCH_FALSE;
    }

    if (UNKNOWN_JMPTBL_ESQ_WildcardMatch((const char *)patternPtr, TEXTDISP_Tag_PPV) == 0) {
        ppvOrSbeFlag = MATCH_TRUE;
    } else if (UNKNOWN_JMPTBL_ESQ_WildcardMatch((const char *)patternPtr, TEXTDISP_Tag_SBE) == 0) {
        TEXTDISP_SbeFilterActiveFlag = MATCH_TRUE;
        ppvOrSbeFlag = MATCH_TRUE;
    } else {
        ppvOrSbeFlag = MATCH_FALSE;
    }

    sportsFilterFlag =
        (UNKNOWN_JMPTBL_ESQ_WildcardMatch((const char *)patternPtr, TEXTDISP_Tag_SPORTS) == 0)
            ? SPORTS_MATCH_TRUE
            : MATCH_FALSE;
    if (UNKNOWN_JMPTBL_ESQ_WildcardMatch((const char *)patternPtr, TEXTDISP_Tag_SPT_Filter) == 0) {
        patternPtr = (UBYTE *)Global_STR_ASTERISK_2;
    }

    {
        const UBYTE *prefix = TEXTDISP_Tag_FIND1;
        const UBYTE *scan = patternPtr;

        while (*prefix == *scan) {
            if (*prefix == 0) {
                TEXTDISP_FindModeActiveFlag = MATCH_TRUE;
                patternPtr = (UBYTE *)Global_STR_ASTERISK_3;
                break;
            }
            ++prefix;
            ++scan;
        }

        if (*prefix != *scan) {
            TEXTDISP_FindModeActiveFlag = MATCH_FALSE;
        }
    }

    if (TEXTDISP_ActiveGroupId == GROUP_PRIMARY) {
        entryCount = (LONG)TEXTDISP_PrimaryGroupEntryCount;
    } else {
        entryCount = (LONG)TEXTDISP_SecondaryGroupEntryCount;
    }

    idx = 0;
    while (idx < entryCount) {
        if (TEXTDISP_ActiveGroupId == GROUP_PRIMARY) {
            title = TEXTDISP_PrimaryTitlePtrTable[idx];
            entry = TEXTDISP_PrimaryEntryPtrTable[idx];
        } else {
            title = TEXTDISP_SecondaryTitlePtrTable[idx];
            entry = TEXTDISP_SecondaryEntryPtrTable[idx];
        }

        if ((entry->flags27 & (1u << BIT_SHIFT_HIDDEN)) != 0) {
            idx += 1;
            continue;
        }
        if (cmdChar == CMD_EDIT && (entry->editFlags40 & (1u << BIT_SHIFT_EDITABLE)) == 0) {
            idx += 1;
            continue;
        }

        if (ppvOrSbeFlag != 0 && (entry->flags27 & (1u << BIT_SHIFT_PPV_SBE)) != 0) {
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

        if (UNKNOWN_JMPTBL_ESQ_WildcardMatch((const char *)patternPtr, (const char *)title) == 0) {
            TEXTDISP_CandidateIndexList[matchCount++] = (UBYTE)idx;
        }
        idx += 1;
    }

    return matchCount;
}
