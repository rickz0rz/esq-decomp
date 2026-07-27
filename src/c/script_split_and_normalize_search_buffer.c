/* RESTORES: SCRIPT_SplitAndNormalizeSearchBuffer
 * MODULE:   modules/groups/b/a/script2.s
 * STATUS:   behavioural
 *
 * 202 bytes in the original, 188 emitted, 7 differing regions.
 *
 * Reproduces: the three-way split on where the 0x12 delimiter sits -- immediately
 * after the leading byte (secondary only), at the very end (primary only), or
 * somewhere in the middle (both) -- the bounded search that gives up at offset
 * 200, the delimiter overwritten with a NUL before either half is copied, the
 * empty-string written into whichever half was not populated, and the two
 * filter calls each guarded by a non-empty test.
 *
 * The two guards are written through a pointer local:
 *
 *     p = TEXTDISP_PrimarySearchText;
 *     if (p && *p) ...
 *
 * rather than testing the array directly, because the original emits the null
 * check (MOVE.L A0,D0 / BEQ) even though the address of a static array can never
 * be null. Testing the array directly lets the compiler drop that dead branch and
 * costs the match. This is a small example of a general point: where the original
 * contains a provably-dead test, the source almost certainly went through a
 * pointer, and reproducing the indirection is what reproduces the code.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   summary: The A5-frame class in its mildest form -- the original has no frame
 *            either, so only the parameter addressing differs.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the two cross-unit filter calls.
 */
#include <string.h>

extern void SCRIPT3_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters(char *s, long max);
extern char TEXTDISP_PrimarySearchText[];
extern char TEXTDISP_SecondarySearchText[];

void SCRIPT_SplitAndNormalizeSearchBuffer(char *buf, long len)
{
    register short i;
    char *p;

    if (buf[1] == 18) {
        strcpy(TEXTDISP_SecondarySearchText, buf + 2);
        TEXTDISP_PrimarySearchText[0] = 0;
    } else if (buf[len - 1] == 18) {
        buf[len - 1] = 0;
        strcpy(TEXTDISP_PrimarySearchText, buf + 1);
        TEXTDISP_SecondarySearchText[0] = 0;
    } else {
        for (i = 1; buf[i] != 18 && i < 200; i++)
            ;
        buf[i] = 0;
        strcpy(TEXTDISP_SecondarySearchText, &buf[i] + 1);
        strcpy(TEXTDISP_PrimarySearchText, buf + 1);
    }

    p = TEXTDISP_PrimarySearchText;
    if (p && *p)
        SCRIPT3_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters(p, 128);

    p = TEXTDISP_SecondarySearchText;
    if (p && *p)
        SCRIPT3_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters(p, 128);
}
