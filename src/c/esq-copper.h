/* esq-copper.h -- register-argument prototypes for the copper/highlight family.
 *
 * Five routines in this family read their arguments out of REGISTERS rather
 * than off the stack. SAS/C spells that convention `__asm` plus a `register`
 * class on each parameter, and it is exact: the argument arrives in the named
 * register with no stack traffic.
 *
 * One header rather than a copy per file, for two reasons. A prototype that
 * disagrees with the definition is invisible to the linker, so it can only be
 * caught by the compiler, and only when both land in one translation unit --
 * see AGENTS.md, "Merging beats splitting". And AGENTS.md records that the
 * commonest merge clash is exactly this: file A declares what file B defines,
 * with a different parameter list.
 *
 * A caller must include this header. Without it the call gets an implicit
 * declaration, SAS/C pushes the arguments on the stack, and the callee reads
 * registers that hold something else. That compiles clean and computes
 * garbage, which is the same failure family as the missing esq-dos.h.
 */
#ifndef ESQ_COPPER_H
#define ESQ_COPPER_H

/* Two effect bytes in D0 and D1. */
void __asm ESQ_SetCopperEffectParams(register __d0 unsigned char a,
                                     register __d1 unsigned char b);

/* Colour in D0, back in D0. Also reads three target bytes through A1.
 * The ORIGINAL leaves A1 advanced by 3 and its callers rely on that; C cannot
 * return a register, so each caller threads the cursor itself. */
unsigned short __asm ESQ_BumpColorTowardTargets(register __d0 unsigned short c,
                                                register __a1 char *targets);

/* Colour in D0, back in D0. Takes nothing else. */
unsigned short __asm ESQ_DecColorStep(register __d0 unsigned short colour);

#endif /* ESQ_COPPER_H */
