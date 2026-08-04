/* RESTORES: ESQ_IncCopperListsAltSkipIndex4
 * MODULE:   modules/groups/a/a/app2_p4_p1.s
 * STATUS:   behavioural
 * LINKABLE SINCE 2026-08-04. The DO-NOT-LINK was about the CALLEE, and the
 *   callee changed: ESQ_BumpColorTowardTargets is now compiled C, so it saves
 *   D2 and D3 like every other C function and the clobber this file guarded
 *   against no longer exists. Nothing in this file had to change to fix that.
 *
 * IT IS ENTERED WITH A1 ALREADY LOADED, and that is faithful, not an oversight.
 * The original never sets A1: it runs on whatever its caller left there, and
 * hands it to a helper that walks it three bytes per call. `register __a1`
 * states that convention rather than hiding it, so the shape survives in the
 * type instead of in a comment.
 *
 * THE BLOCK IS DEAD. A grep over src/modules, src/data and src/c finds no
 * caller at all -- no BSR, no JSR, no jump-table thunk, no C call. It reads as
 * a copy of the ...Dec... sibling that was never wired up. It is restored and
 * linked so that no assembly is left behind, and it keeps its entry convention
 * so that a future caller gets the original's behaviour.
 *
 * This block carried no label until 2026-07-30, which made the preceding
 * 2-byte ESQ_NoOp_0074 read as 58 bytes.
 *
 * SASC-MISMATCH: register-threaded-pointer
 *   summary: the helper leaves A1 advanced by 3 and the original relies on
 *            that. C cannot return a register, so the cursor is a local here
 *            and the advance is an explicit ADDQ, at +2 bytes for the reload
 *            and +2 for the add, once per call site. Identical treatment and
 *            full accounting in esq_inc_copper_lists_towards_targets.c.
 *   retest:  needs a callee that returns the cursor, which is a different
 *            assembly routine.
 *
 * Byte accounting is otherwise the same four classes as
 * esq_dec_copper_lists_alt_skip_index4.c; see that file for the write-ups.
 */
#include "esq-copper.h"

extern char ESQ_BannerPaletteWordsA[];
extern char ESQ_BannerPaletteWordsB[];

void __asm ESQ_IncCopperListsAltSkipIndex4(register __a1 char *targets)
{
    char *a = ESQ_BannerPaletteWordsA;
    char *b = ESQ_BannerPaletteWordsB;
    char *t = targets;
    short off = 0;
    short k = 8;

    do {
        if (off != 4) {
            *(unsigned short *)(b + off) = *(unsigned short *)(a + off) =
                ESQ_BumpColorTowardTargets(*(unsigned short *)(a + off), t);
            t += 3;
        }
        off += 4;
    } while (--k);
}
