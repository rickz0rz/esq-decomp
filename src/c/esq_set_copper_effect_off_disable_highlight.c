/* RESTORES: ESQ_SetCopperEffect_OffDisableHighlight
 * MODULE:   modules/groups/a/a/app2.s
 * STATUS:   behavioural
 * LINKABLE SINCE 2026-08-04. This file is a CALLER of a register-argument
 *   function, not a register-argument function itself: it takes nothing and
 *   only PUTS two bytes in D0 and D1. The `__asm` prototype in esq-copper.h
 *   does that. See esq_set_copper_effect_custom.c for the full note.
 *
 *   The body it guarded called ESQ_SetCopperEffectParams with NO arguments, so
 *   the two effect bytes were whatever happened to be in D0 and D1. The
 *   CIAB_PRA update was already correct and is unchanged.
 *
 * SASC-MISMATCH: scratch-register-allocation
 *   ref:     227c00bfd00012110881000608c100071281103c0000123c0000612c4eb90001ba164e75   (36)
 *   summary: SAS/C allocates the CIA pointer and the byte to callee-saved
 *            registers because the function makes a call, so it pays a MOVEM
 *            pair the original does not. The original clears bit 6 and sets
 *            bit 7 with a BCLR and a BSET where `(x & 0xbf) | 0x80` is an ANDI
 *            and an ORI, and loads each argument register with its own MOVE.B.
 *   scope:   program-wide; itemised in esq_set_copper_effect_all_on.c.
 *   retest:  a compiler that keeps short-lived locals in D0/D1/A0/A1 drops the
 *            MOVEM pair.
 */
#include "esq-copper.h"

extern volatile unsigned char CIAB_PRA;
extern void GCOMMAND_DisableHighlight(void);

void ESQ_SetCopperEffect_OffDisableHighlight(void)
{
    volatile unsigned char *p = &CIAB_PRA;

    *p = (unsigned char)((*p & 0xbf) | 0x80);
    ESQ_SetCopperEffectParams(0x00, 0x00);
    GCOMMAND_DisableHighlight();
}
