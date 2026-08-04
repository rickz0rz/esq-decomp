/* RESTORES: ESQ_SetCopperEffect_Custom
 * MODULE:   modules/groups/a/a/app2.s
 * STATUS:   behavioural
 * LINKABLE SINCE 2026-08-04. This file is a CALLER of a register-argument
 *   function, not a register-argument function itself. It takes nothing, and
 *   it only PUTS two bytes in D0 and D1 before the call. The `__asm` prototype
 *   in esq-copper.h does that, exactly as esq_set_copper_effect_all_on.c has
 *   done since 2026-08-01.
 *
 *   The DO-NOT-LINK this file used to carry was copied across the whole copper
 *   family from the routines that really do read registers, and it was wrong
 *   here. Worse, the body it guarded was a bare call: it dropped the CIAB_PRA
 *   bits and both argument bytes, so linking it as written would have done
 *   none of the work. The body below is the whole routine.
 *
 * SASC-MISMATCH: scratch-register-allocation
 *   ref:     227c00bfd000121108c1000608c100071281103c003f1239000000f661684e75   (32)
 *   summary: same shape as esq_set_copper_effect_all_on.c -- SAS/C allocates
 *            the CIA pointer and the byte to callee-saved registers because
 *            the function makes a call, so it pays a MOVEM pair the original
 *            does not. The original sets the two bits with two BSETs where
 *            `|= 0xc0` is one ORI.
 *   scope:   program-wide; every restoration that holds a local across a call.
 *   retest:  a compiler that keeps short-lived locals in D0/D1/A0/A1 drops the
 *            MOVEM pair.
 */
#include "esq-copper.h"

extern volatile unsigned char CIAB_PRA;
extern unsigned char HIGHLIGHT_CustomValue;

void ESQ_SetCopperEffect_Custom(void)
{
    volatile unsigned char *p = &CIAB_PRA;

    *p = (unsigned char)(*p | 0xc0);
    ESQ_SetCopperEffectParams(0x3f, HIGHLIGHT_CustomValue);
}
