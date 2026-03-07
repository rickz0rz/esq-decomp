typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern UWORD TEXTDISP_ActiveGroupId;
extern UWORD TEXTDISP_PrimaryGroupEntryCount;
extern UWORD TEXTDISP_SecondaryGroupEntryCount;
extern UWORD TEXTDISP_SbeFilterActiveFlag;
extern UWORD TEXTDISP_FindModeActiveFlag;
extern UBYTE TEXTDISP_CandidateIndexList[];

extern UBYTE *TEXTDISP_PrimaryTitlePtrTable[];
extern UBYTE *TEXTDISP_PrimaryEntryPtrTable[];
extern UBYTE *TEXTDISP_SecondaryTitlePtrTable[];
extern UBYTE *TEXTDISP_SecondaryEntryPtrTable[];

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
    LONG matchCount;
    LONG idx;
    LONG entryCount;
    LONG ppvOrSbeFlag;
    LONG sportsFilterFlag;
    UBYTE *title;
    UBYTE *entry;

    matchCount = 0;
    if (patternPtr == (UBYTE *)0) {
        return 0;
    }

    if (UNKNOWN_JMPTBL_ESQ_WildcardMatch((const char *)patternPtr, TEXTDISP_Tag_PPV) == 0) {
        ppvOrSbeFlag = 1;
    } else if (UNKNOWN_JMPTBL_ESQ_WildcardMatch((const char *)patternPtr, TEXTDISP_Tag_SBE) == 0) {
        TEXTDISP_SbeFilterActiveFlag = 1;
        ppvOrSbeFlag = 1;
    } else {
        ppvOrSbeFlag = 0;
    }

    sportsFilterFlag = (UNKNOWN_JMPTBL_ESQ_WildcardMatch((const char *)patternPtr, TEXTDISP_Tag_SPORTS) == 0) ? -1 : 0;
    if (UNKNOWN_JMPTBL_ESQ_WildcardMatch((const char *)patternPtr, TEXTDISP_Tag_SPT_Filter) == 0) {
        patternPtr = (UBYTE *)Global_STR_ASTERISK_2;
    }

    if (UNKNOWN_JMPTBL_ESQ_WildcardMatch((const char *)TEXTDISP_Tag_FIND1, (const char *)patternPtr) == 0) {
        TEXTDISP_FindModeActiveFlag = 1;
        patternPtr = (UBYTE *)Global_STR_ASTERISK_3;
    } else {
        TEXTDISP_FindModeActiveFlag = 0;
    }

    entryCount = (TEXTDISP_ActiveGroupId == 1) ? (LONG)TEXTDISP_PrimaryGroupEntryCount : (LONG)TEXTDISP_SecondaryGroupEntryCount;
    idx = 0;
    while (idx < entryCount) {
        if (TEXTDISP_ActiveGroupId == 1) {
            title = TEXTDISP_PrimaryTitlePtrTable[idx];
            entry = TEXTDISP_PrimaryEntryPtrTable[idx];
        } else {
            title = TEXTDISP_SecondaryTitlePtrTable[idx];
            entry = TEXTDISP_SecondaryEntryPtrTable[idx];
        }

        if ((entry[27] & (1u << 3)) != 0) {
            idx += 1;
            continue;
        }
        if (cmdChar == (UWORD)69 && (entry[40] & (1u << 7)) == 0) {
            idx += 1;
            continue;
        }

        if (ppvOrSbeFlag != 0 && (entry[27] & (1u << 4)) != 0) {
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
