#include <exec/types.h>

typedef struct TEXTDISP_PrimaryEntry {
    UBYTE pad0[27];
    UBYTE flags27;
} TEXTDISP_PrimaryEntry;

extern UWORD TEXTDISP_CurrentMatchIndex;
extern UWORD TEXTDISP_CurrentMatchIndexSaved;
extern UWORD TEXTDISP_PrimaryGroupEntryCount;

extern const char *TEXTDISP_PrimaryTitlePtrTable[];
extern TEXTDISP_PrimaryEntry *TEXTDISP_PrimaryEntryPtrTable[];

extern UBYTE UNKNOWN_JMPTBL_ESQ_WildcardMatch(const char *text, const char *pattern);

LONG TEXTDISP_FindEntryIndexByWildcard(char *patternPtr)
{
    LONG index;

    TEXTDISP_CurrentMatchIndexSaved = TEXTDISP_CurrentMatchIndex;

    for (index = 0; index < (LONG)(UWORD)TEXTDISP_PrimaryGroupEntryCount; ++index) {
        TEXTDISP_PrimaryEntry *entry;
        const char *title;

        title = TEXTDISP_PrimaryTitlePtrTable[index];
        entry = TEXTDISP_PrimaryEntryPtrTable[index];
        if ((entry->flags27 & (1u << 3)) != 0) {
            continue;
        }

        if ((UBYTE)UNKNOWN_JMPTBL_ESQ_WildcardMatch(title, patternPtr) == 0) {
            TEXTDISP_CurrentMatchIndex = (UWORD)index;
            return 1;
        }
    }

    return 0;
}
