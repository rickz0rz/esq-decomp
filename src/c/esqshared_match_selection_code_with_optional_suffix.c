/* RESTORES: ESQSHARED_MatchSelectionCodeWithOptionalSuffix
 * MODULE:   modules/groups/a/q/esqshared.s
 * STATUS:   behavioural
 *
 * 246 bytes in the original, 256 emitted, 13 differing regions.
 *
 * Reproduces: the character scanner splitting the selection code on '.' into a
 * main pattern and an optional suffix, the ':' handler that records the previous
 * character as the last segment unless it was a wildcard or the segment was empty
 * (in which case it falls back to ESQ_STR_A), the index reset on both separators,
 * the terminating NUL written into whichever buffer is active, the empty-main
 * shortcut that forces a non-match with -1, and the three-way final test
 * requiring both wildcard matches to succeed AND the last segment to equal
 * ESQ_STR_A.
 *
 * The dispatch on the separator characters reproduces as the original's chained
 * subtract: SUBI.W #$2e then SUBI.W #12, testing '.' and ':' in sequence off one
 * running difference rather than two independent compares.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55ffe0                   LINK.W A5,#-32
 *   got:     9efc0018                   SUBA.W #24,A7
 *   summary: The A5-frame class. Both scratch buffers and the three flag bytes
 *            move to A7-relative addressing, which is most of the 13 regions.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the two cross-unit calls.
 */
#include <string.h>

extern char ESQSHARED_JMPTBL_ESQ_WildcardMatch(char *pat, char *s);
extern char ESQ_STR_A[];
extern char ESQ_SelectCodeBuffer[];
extern char ESQPARS_SelectionSuffixBuffer[];

long ESQSHARED_MatchSelectionCodeWithOptionalSuffix(char *s)
{
    char suffixBuf[4];
    char mainBuf[16];
    char suffixFlag;
    char lastSegment;
    char prev;
    register short i;
    register char c;
    register short mainMatch;
    register short suffixMatch;

    suffixFlag = 0;
    lastSegment = prev = ESQ_STR_A[0];
    i = 0;

    for (;;) {
        c = *s++;
        if (c == 0)
            break;

        if (c == '.') {
            mainBuf[i] = 0;
            suffixFlag = 1;
            i = 0;
            continue;
        }

        if (c == ':') {
            if (prev == '?' || prev == '*' || i == 0)
                lastSegment = ESQ_STR_A[0];
            else
                lastSegment = prev;
            i = 0;
            continue;
        }

        prev = c;
        if (suffixFlag)
            suffixBuf[i] = c;
        else
            mainBuf[i] = c;
        i++;
    }

    if (suffixFlag)
        suffixBuf[i] = 0;
    else
        mainBuf[i] = 0;

    if (strlen(mainBuf) == 0)
        mainMatch = -1;
    else
        mainMatch = ESQSHARED_JMPTBL_ESQ_WildcardMatch(ESQ_SelectCodeBuffer, mainBuf);

    suffixMatch = 0;
    if (suffixFlag == 1)
        suffixMatch = ESQSHARED_JMPTBL_ESQ_WildcardMatch(ESQPARS_SelectionSuffixBuffer,
                                                         suffixBuf);

    if (mainMatch == 0 && suffixMatch == 0 && lastSegment == ESQ_STR_A[0])
        return 1;
    return 0;
}
