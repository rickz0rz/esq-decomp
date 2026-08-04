/* RESTORES: DISKIO2_CopyAndSanitizeSlotString
 * MODULE:   modules/groups/a/h/diskio2.s
 * STATUS:   behavioural
 *
 * 220 bytes in the original, 240 emitted, 17 differing regions.
 *
 * Reproduces: the six-way validation cascade, the visibility test that accepts
 * either bit 1 of the context byte at 7+slot or bit 4 of the entry byte at 27,
 * the inlined strcpy, the paired quote search where the second search starts one
 * past the first hit, the delimiter-set scan that overrides the trim point when
 * it finds one, the trailing scan to the first space or NUL, and the truncation.
 *
 * TWO BEHAVIOURS PRESERVED DELIBERATELY, both of which a rewrite would be
 * tempted to "fix":
 *
 *   - The source pointer is read out of the context BEFORE the context is checked
 *     for null. If ctx is ever null this dereferences it. Reproduced as written;
 *     the ordering is visible in the original and is not ours to correct.
 *
 *   - The early exits return the SOURCE pointer, not null and not the
 *     destination. Only the success path returns the destination buffer. So a
 *     caller that skips sanitisation still gets a usable string, just the
 *     original one. Collapsing the two exits to a single `return dst` would
 *     compile and would be wrong.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55fff4                   LINK.W A5,#-12
 *   got:     9efc000c                   SUBA.W #12,A7
 *   summary: The A5-frame class. The three pointer locals are live across calls
 *            so SAS/C keeps the frame, and the +20 comes from it reloading them
 *            around each call where the original addressed them off A5.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the three cross-unit calls.
 */
#include <string.h>

extern char *STR_FindCharPtr(char *s, long ch);
extern char *STR_FindAnyCharPtr(char *s, char *set);
extern char NEWGRID_EntrySplitDelimiterMask[];

char *DISKIO2_CopyAndSanitizeSlotString(char *dst, unsigned char *entry,
                                        unsigned char *ctx, short slot)
{
    char *p;
    char *q;
    char *result;

    result = ((char **)(ctx + 56))[slot];

    if (entry == 0)     return result;
    if (ctx == 0)       return result;
    if (slot <= 0)      return result;
    if (slot >= 49)     return result;
    if (result == 0)    return result;
    if (*result == 0)   return result;

    if (!(ctx[7 + slot] & 2) && !(entry[27] & 0x10))
        return result;

    strcpy(dst, result);

    p = STR_FindCharPtr(dst, '"');
    if (p) {
        p++;
        p = STR_FindCharPtr(p, '"');
        if (p) {
            q = STR_FindAnyCharPtr(p, NEWGRID_EntrySplitDelimiterMask);
            if (q)
                p = q;
            while (*p && *p != ' ')
                p++;
            *p = 0;
        }
    }

    result = dst;
    return result;
}
