/* RESTORES: TLIBA_FindFirstWildcardMatchIndex
 * MODULE:   modules/groups/b/a/tliba.s
 * STATUS:   behavioural
 *
 * Reproduces: the -1 sentinel, the scan over the secondary group, and the early
 * exit on the first title the pattern matches -- ESQ_WildcardMatch returns zero
 * on a match, so the loop continues while it is non-zero.
 *
 * The entry count is `unsigned short`: the original widens it with MOVEQ #0
 * followed by MOVE.W rather than MOVE.W/EXT.L, which is a zero-extension.
 */
extern unsigned short TEXTDISP_SecondaryGroupEntryCount;
extern char *TEXTDISP_SecondaryTitlePtrTable[];
extern char  ESQ_WildcardMatch(char *pat, char *s);

long TLIBA_FindFirstWildcardMatchIndex(char *pattern)
{
    register long found;
    register long i;

    found = -1;
    for (i = 0; i < TEXTDISP_SecondaryGroupEntryCount; i++) {
        if (ESQ_WildcardMatch(pattern,
                                             TEXTDISP_SecondaryTitlePtrTable[i]) == 0) {
            found = i;
            break;
        }
    }
    return found;
}
