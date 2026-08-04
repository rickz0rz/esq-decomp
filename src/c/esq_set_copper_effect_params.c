/* RESTORES: ESQ_SetCopperEffectParams
 * MODULE:   modules/groups/a/a/app2.s
 * STATUS:   behavioural
 * LINKABLE SINCE 2026-08-04, AS AN `__asm` REGISTER FUNCTION. It is the same
 *   move that made esq_dec_color_step.c linkable, and it works for the same
 *   two reasons.
 *
 *   The original reads its two effect bytes out of D0 and D1, so a plain C
 *   definition read the stack and stored garbage. `register __d0` and
 *   `register __d1` put the parameters where the five assembly callers already
 *   leave them, so every caller agrees, whether it is assembly or C.
 *
 *   The clobber direction is safe as well. The original destroys D0 and D1 and
 *   nothing else, and both are scratch under the standard convention. A
 *   compiled C body saves every callee-saved register it touches, so it
 *   destroys a SUBSET of what the original destroyed. No caller can tell.
 *
 * SASC-MISMATCH: register-argument-convention
 *   ref:     13c0000000ea13c1000000eb33fc0005000000e861024e75
 *   got:     48e703001c2f00131e2f000f13c70000000013c60000000033fc000500000000610000004cdf00c04e75
 *   summary: SAS/C copies both argument registers into callee-saved registers
 *            of its own before using them, where the original stores straight
 *            out of D0 and D1. That costs the MOVEM pair and two
 *            register-to-register moves. The stores, the seed word and the
 *            tail call are the same instructions in the same order.
 *   tried:   `register` on locals changes nothing, because the parameters are
 *            already in registers. The copy is what `__asm` does by design --
 *            see AGENTS.md, "SAS/C still copies the arguments into its own
 *            callee-saved registers".
 *   scope:   every `__asm` register function in the program.
 *   retest:  a compiler that works in the argument registers directly drops
 *            the MOVEM pair and both copies, and lands on the reference.
 */
/* The two effect bytes arrive in D0 and D1. */
extern unsigned char HIGHLIGHT_CopperEffectParamA, HIGHLIGHT_CopperEffectParamB;
extern short HIGHLIGHT_CopperEffectSeed;
extern void  ESQ_UpdateCopperListsFromParams(void);

void __asm ESQ_SetCopperEffectParams(register __d0 unsigned char a,
                                     register __d1 unsigned char b)
{
    HIGHLIGHT_CopperEffectParamA = a;
    HIGHLIGHT_CopperEffectParamB = b;
    HIGHLIGHT_CopperEffectSeed = 5;
    ESQ_UpdateCopperListsFromParams();
}
