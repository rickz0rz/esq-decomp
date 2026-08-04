/* RESTORES: ESQ_SetCopperEffect_AllOn
 * MODULE:   modules/groups/a/a/app2_p0.s
 * STATUS:   behavioural
 *
 * The rest of this copper family is DO-NOT-LINK, because each one takes its
 * own arguments in registers. This one does not: it takes nothing and only
 * PASSES two bytes in D0/D1. An __asm prototype on the callee puts them
 * there, so this file is safe to link. See the __asm note below.
 *
 * SASC-MISMATCH: scratch-register-allocation
 *   ref:     227c00bfd000121108810006088100071281103c003f123c003f614a4e75   (30)
 *   got:     48e701044bf9000000001e150207003f1a87703f2200610000004cdf20804e75   (32)
 *   summary: +2 bytes, and every byte of it is accounted for:
 *              +8  MOVEM.L D7/A5,-(A7) and MOVEM.L (A7)+,D7/A5. The original
 *                  holds the pointer in A1 and the byte in D1, both scratch,
 *                  and saves nothing. SAS/C 6.51 allocates locals to
 *                  callee-saved registers whenever the function makes a call,
 *                  even when no local is live across that call.
 *              -4  one ANDI.B #$3f,D7 where the original clears bit 6 and bit 7
 *                  with two BCLRs.
 *              -4  MOVEQ #$3f,D0 / MOVE.L D0,D1 where the original writes two
 *                  MOVE.B #$3f immediates.
 *              +2  BSR.W where the original reaches its neighbour with BSR.S.
 *            The structure agrees: address into an address register, byte into
 *            a data register, mask in the register, one store back.
 *   tried:   `*p = *p & 0x3f;` gives 24 bytes but does the mask straight to
 *            memory (AND.B D0,(A5)), which is not what the original does.
 *            `c &= ~0x40; c &= ~0x80;` reaches 44: the first clear becomes
 *            BCLR #6 as wanted, then the second widens the value to a word
 *            (MOVEQ #0 / MOVE.B / ANDI.W #$ff7f) and costs more than it saves.
 *            `c &= 0xbf; c &= 0x7f;` is the same 44 for the same reason.
 *            `register` on both locals changes nothing; nor does dropping
 *            `volatile` from CIAB_PRA.
 *   scope:   the MOVEM pair is program-wide, on every restoration that holds a
 *            local across any call. The two MOVE.B immediates are the more
 *            interesting half: the original loaded each argument register
 *            separately, so it was not fed by an __asm prototype.
 *   retest:  a compiler that keeps short-lived locals in D0/D1/A0/A1 would
 *            drop the MOVEM pair and land within the remaining 6 bytes.
 */
/* ESQ_SetCopperEffectParams reads its two bytes from D0 and D1. A plain
 * prototype makes SAS/C push them on the stack, and the callee then reads
 * whatever is there. The __asm register form in esq-copper.h puts them where
 * the callee looks. That prototype used to live in this file; it moved to the
 * header on 2026-08-04, when the other four callers in the family were
 * unblocked and needed the same declaration. */
#include "esq-copper.h"

extern unsigned char CIAB_PRA;

void ESQ_SetCopperEffect_AllOn(void)
{
    unsigned char *p = &CIAB_PRA;
    unsigned char c;

    c = *p;
    c &= 0x3f;
    *p = c;
    ESQ_SetCopperEffectParams(0x3f, 0x3f);
}
