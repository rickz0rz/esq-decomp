/* RESTORES: ESQ_SetCopperEffect_Default
 * MODULE:   modules/groups/a/a/app2.s
 * STATUS:   behavioural
 * LINKABLE SINCE 2026-08-04. This file is a CALLER of a register-argument
 *   function, not a register-argument function itself: it takes nothing and
 *   only PUTS two bytes in D0 and D1. The `__asm` prototype in esq-copper.h
 *   does that. See esq_set_copper_effect_custom.c for the full note on why the
 *   old blanket DO-NOT-LINK was wrong for this half of the family.
 *
 *   The body it guarded was a bare call that passed no arguments at all, so
 *   linking it as written would have left both effect bytes undefined.
 *
 * SASC-MISMATCH: immediate-load-idiom
 *   ref:     103c0000123c003f6100008a4e75   (14)
 *   summary: the original loads each argument register with its own
 *            MOVE.B #imm. SAS/C materialises the pair with a MOVEQ where the
 *            values allow it, and reaches the callee with BSR.W where the
 *            original had room for a shorter displacement.
 *   scope:   every caller in this family; the same two items are itemised in
 *            esq_set_copper_effect_all_on.c.
 *   retest:  a compiler that loads each argument register separately matches.
 */
#include "esq-copper.h"

void ESQ_SetCopperEffect_Default(void)
{
    ESQ_SetCopperEffectParams(0x00, 0x3f);
}
