/* RESTORES: COI_AppendAnimFieldWithTrailingSpace
 * MODULE:   modules/groups/a/e/coi_p4_p0.s   (its only block)
 * STATUS:   behavioural
 *
 * Looks up one animation field by mode, and if it exists appends it to the end
 * of a text buffer with a trailing space. Returns the buffer.
 *
 * ITS HEAD CARRIED NO LABEL UNTIL 2026-08-04, and the giveaway was that its
 * EPILOGUE did: the module exported COI_AppendAnimFieldWithTrailingSpace_Return
 * and nothing else. A `_Return` label with no function in front of it is a
 * labelling gap, not a stray fragment -- the disassembly names an epilogue
 * `<name>_Return` only when `<name>` exists. Adding the head label is
 * byte-neutral; test-hash.sh and build-split.sh pass across the change.
 *
 * THE APPEND POINT IS FOUND BY SCANNING TO THE NUL, and the original's scan is
 * the ordinary `TST.B (A0)+ / BNE` walk that strlen inlines to. It then
 * subtracts one for the post-increment overshoot and adds the length back to
 * the base, which is the same address strlen gives directly.
 *
 * THE MODE ARGUMENT IS SIGN-EXTENDED FROM A WORD. The original does
 * `MOVE.L 12(A5),D7` then `EXT.L D0` on a copy, so the long slot is narrowed to
 * its low word and widened again before the call. Written as `(short)` so the
 * narrowing is visible; COI_GetAnimFieldPointerByMode declares that parameter
 * `short` anyway.
 *
 * SASC-MISMATCH: strlen-inline-shape
 *   ref:     a scan loop, then SUBQ.L #1,A0 / SUBA.L A2,A0 / MOVE.L A0,D0 and
 *            the base added back
 *   got:     the inlined strlen and one add
 *   summary: SAS/C inlines strlen to the same scan loop, but computes the end
 *            pointer in one step where the original goes via the length. Same
 *            address; a few bytes fewer.
 *   scope:   any restoration that appends at a buffer's NUL.
 *   retest:  a compiler that keeps the length as an intermediate.
 */
#include <string.h>

#ifndef ANIMENTRY_DEFINED
struct AnimEntry;
#endif

extern char *COI_GetAnimFieldPointerByMode(struct AnimEntry *entry, short key,
                                           short mode);
extern long  WDISP_SPrintf(char *buf, char *fmt, ...);
extern char  COI_FMT_WIDE_STR_WITH_TRAILING_SPACE[];

char *COI_AppendAnimFieldWithTrailingSpace(struct AnimEntry *entry, long mode,
                                           char *buf)
{
    char *field;

    field = COI_GetAnimFieldPointerByMode(entry, (short)mode, 0);
    if (field == 0)
        return buf;

    WDISP_SPrintf(buf + strlen(buf), COI_FMT_WIDE_STR_WITH_TRAILING_SPACE,
                  field);
    return buf;
}
