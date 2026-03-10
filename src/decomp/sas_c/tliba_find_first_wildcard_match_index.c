typedef signed long LONG;
typedef unsigned short UWORD;

extern UWORD TEXTDISP_SecondaryGroupEntryCount;
extern const char *TEXTDISP_SecondaryTitlePtrTable[];

extern LONG UNKNOWN_JMPTBL_ESQ_WildcardMatch(const char *pattern, const char *text);

LONG TLIBA_FindFirstWildcardMatchIndex(const char *wildcardPattern)
{
    LONG i;
    LONG matchIndex;

    matchIndex = -1;
    for (i = 0; i < (LONG)TEXTDISP_SecondaryGroupEntryCount; ++i) {
        if (UNKNOWN_JMPTBL_ESQ_WildcardMatch(wildcardPattern, TEXTDISP_SecondaryTitlePtrTable[i]) == 0) {
            matchIndex = i;
            break;
        }
    }

    return matchIndex;
}
