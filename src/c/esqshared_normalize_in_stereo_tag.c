/* RESTORES: ESQSHARED_NormalizeInStereoTag
 * MODULE:   modules/groups/a/q/esqshared.s
 * STATUS:   behavioural
 *
 * 184 bytes in the original, 156 emitted, only FOUR differing regions.
 *
 * Reproduces: the case-folded search for the "IN STEREO" marker, the marker's
 * first byte overwritten with 0x91, the three-way outcome selected by bit 7 of
 * the flags and by whether anything follows the nine-character tag, both CopyMem
 * closures that shift the remainder down over the tag, and the backward trim loop
 * that erases trailing control characters when the tag ran to the end of the
 * string.
 *
 * The trim is a do/while, not a while: the original unconditionally clears the
 * first byte and steps back before testing the class table, so a tag at the very
 * end always loses at least one character. Written as a leading-test loop it
 * would leave that byte in place on a string whose preceding character is not a
 * control code.
 *
 * The class-table index is signed-extended (EXT.W then EXT.L), the same detail
 * recorded in textdisp_find_quoted_span.c -- bytes >= 0x80 index backwards from
 * the table base.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55fff8                   LINK.W A5,#-8
 *   got:     594f                       SUBQ.W #4,A7
 *   summary: The A5-frame class. Both pointers stay in registers for SAS/C and
 *            the original reloads them from the frame before every use, which is
 *            the whole -28.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the two cross-unit calls.
 */
#include "esq-exec.h"
#include <string.h>

extern char *GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold(char *hay, char *needle);
extern char *ESQSHARED_JMPTBL_STR_SkipClass3Chars(char *s);
extern unsigned char WDISP_CharClassTable[];
extern char Global_STR_IN_STEREO[];

void ESQSHARED_NormalizeInStereoTag(char *s, long flags)
{
    char *hit;
    char *after;
    char *p;

    hit = GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold(s, Global_STR_IN_STEREO);
    if (hit == 0)
        return;

    *hit = 0x91;
    after = hit + 9;

    if (flags & 0x80) {
        hit++;
        CopyMem(after, hit, (long)strlen(after) + 1);
        return;
    }

    if (*after) {
        p = ESQSHARED_JMPTBL_STR_SkipClass3Chars(after);
        after = p;
        CopyMem(p, hit, (long)strlen(p) + 1);
        return;
    }

    do {
        *hit = 0;
        hit--;
    } while (WDISP_CharClassTable[*hit] & 8);
}
