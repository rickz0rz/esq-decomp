/* RESTORES: ED_UpdateActiveInactiveIndicator
 * MODULE:   modules/groups/a/l/ed3bb.s
 * STATUS:   behavioural
 *
 * 222 bytes in the original, 216 emitted, 7 differing regions.
 *
 * Reproduces: the cached-state early return that skips the whole redraw when the
 * flag has not changed, the swap of the four rectangle bounds between the active
 * and inactive cases, both RectFill calls sharing the same top and bottom edges,
 * the draw-mode and pen save/restore bracketing, and the cache update placed
 * AFTER the text is drawn rather than before.
 *
 * FOURTH sighting of the MOVEQ + NOT.B constant form, and the third distinct
 * value: here 145 is built as ~110 (7E6E 4607). Previous sightings were 215 as
 * ~40 (twice) and 255 as ~0. Alongside the doubling form (130 as 65x2, also
 * present in this function) that makes the original's constant repertoire
 * clear:
 *
 *     MOVEQ #n / ADD.L Dn,Dn    for 2n
 *     MOVEQ #n / NOT.B Dn       for ~n
 *     MOVE.L #imm               otherwise
 *
 * and SAS/C uses neither, preferring MOVEQ + ASL.L #k. See
 * docs/compiler-version.md -- the constant test recorded there can now be stated
 * with two positive forms rather than one.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the cross-unit text call.
 *
 * SASC-MISMATCH: a6-preserved-across-libcall
 *   summary: SAS/C hoists the GfxBase load above the pen argument setup where the
 *            original does it after, and adjusts the MOVEM mask accordingly.
 */
#include "esq-graphics.h"

extern void DISPLIB_DisplayTextAtPosition(void *rp, long x, long y, char *s);
extern struct RastPort *Global_REF_RASTPORT_1;
extern long ED_AdActiveFlag;
extern long ED_ActiveIndicatorCachedState;
extern char Global_STR_ACTIVE_INACTIVE[];

void ED_UpdateActiveInactiveIndicator(void)
{
    register long dimLeft;
    register long dimRight;
    register long litLeft;
    register long litRight;

    if (ED_ActiveIndicatorCachedState == ED_AdActiveFlag)
        return;

    if (ED_AdActiveFlag == 1) {
        dimLeft  = 145;
        dimRight = 265;
        litLeft  = 40;
        litRight = 130;
    } else {
        dimLeft  = 40;
        dimRight = 130;
        litLeft  = 145;
        litRight = 265;
    }

    SetAPen(Global_REF_RASTPORT_1, 2L);
    RectFill(Global_REF_RASTPORT_1, dimLeft, 68L, dimRight, 98L);
    SetAPen(Global_REF_RASTPORT_1, 6L);
    RectFill(Global_REF_RASTPORT_1, litLeft, 68L, litRight, 98L);

    SetDrMd(Global_REF_RASTPORT_1, 0L);
    SetAPen(Global_REF_RASTPORT_1, 1L);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 90,
                                  Global_STR_ACTIVE_INACTIVE);

    ED_ActiveIndicatorCachedState = ED_AdActiveFlag;

    SetAPen(Global_REF_RASTPORT_1, 1L);
    SetDrMd(Global_REF_RASTPORT_1, 1L);
}
