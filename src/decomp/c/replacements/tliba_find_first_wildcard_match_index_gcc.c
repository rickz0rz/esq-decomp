#include "esq_types.h"

/*
 * Target 629 GCC trial function.
 * Return first secondary-title index that wildcard-matches the given pattern.
 */
extern s16 TEXTDISP_SecondaryGroupEntryCount;
extern const char *TEXTDISP_SecondaryTitlePtrTable[];

s16 UNKNOWN_JMPTBL_ESQ_WildcardMatch(const char *pattern, const char *text) __attribute__((noinline));

s32 TLIBA_FindFirstWildcardMatchIndex(const char *pattern) __attribute__((noinline, used));

s32 TLIBA_FindFirstWildcardMatchIndex(const char *pattern)
{
    s32 found = -1;
    s32 i = 0;

    while (i < (s32)TEXTDISP_SecondaryGroupEntryCount) {
        if (UNKNOWN_JMPTBL_ESQ_WildcardMatch(pattern, TEXTDISP_SecondaryTitlePtrTable[i]) == 0) {
            found = i;
            break;
        }
        i++;
    }

    return found;
}
