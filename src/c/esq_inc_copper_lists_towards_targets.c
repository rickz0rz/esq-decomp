/* RESTORES: ESQ_IncCopperListsTowardsTargets
 * MODULE:   modules/groups/a/a/app2_p4.s
 * STATUS:   behavioural
 * DO-NOT-LINK: _ESQ_BumpColorTowardTargets clobbers D2 and D3 and does not
 *   restore them. SAS/C treats both as callee-saved, so it neither keeps a
 *   value there across the call nor saves them in the prologue, and they leak
 *   out to whoever called this function. The original's MOVEM.L D2-D6/A2-A3
 *   covers exactly that.
 *
 * SASC-MISMATCH: register-threaded-pointer
 *   ref:     43f90000a356 ... 6160 ... 614a       LEA targets,A1 once, then
 *                                                 32 calls that each advance A1
 *   got:     the A1 load is repeated at every call site, and the advance is
 *            an explicit ADDQ in the caller
 *   summary: the helper reads three bytes through A1 and leaves A1 advanced by
 *            3. The original loads A1 once, before the first loop, and lets 32
 *            calls walk it the length of the target stream. C has no way to
 *            say "the callee advanced my pointer": SAS/C treats A1 as scratch
 *            across a call, so the value cannot survive. The C below keeps the
 *            cursor in a local and adds 3 after each call, which reaches the
 *            same bytes of the same stream in the same order, and costs the
 *            reload plus the ADDQ per site.
 *   tried:   declaring the helper's A1 argument with `register __a1` is what
 *            gets the pointer IN. There is no form that gets the advanced
 *            value back OUT, because SAS/C models the call as clobbering A1.
 *   scope:   this function and its dead sibling. _ESQ_BumpColorTowardTargets
 *            is the only helper in the program that threads a register this
 *            way.
 *   retest:  no compiler setting reaches this. It would need a callee that
 *            returns the cursor, which is a different assembly routine.
 *
 * 86 bytes against 72, and every byte is accounted for. The two loops cost
 * +8 each, from four items of 2 bytes apiece:
 *   +2  MOVEA.L A2,A1 -- the cursor put back in A1 for the call, which the
 *       original never has to do because A1 already holds it.
 *   +2  ADDQ.L #3,A2 -- the advance the original gets for free from the
 *       helper. Both items are the register-threaded-pointer class above.
 *   +2  MOVEQ #0,D0, the zero-extension into the D0 argument register.
 *   +2  BSR.W where the original has BSR.S.
 * Against that, -2 in the prologue: the original loads a word zero with
 * MOVE.W #0,D5 where SAS/C uses MOVEQ. 8 + 8 - 2 = +14.
 *
 * Note the two extra items are per CALL SITE, not per iteration -- the loops
 * run 8 and 24 times and the code is written once.
 */
extern char ESQ_CopperStatusDigitsA[];
extern char ESQ_CopperStatusDigitsB[];
extern char WDISP_PaletteTriplesRBase[];

/* Register-argument helper: the colour arrives in D0 and comes back in D0,
 * and the target triple is read through A1. It also destroys D1, D2 and D3 --
 * see DO-NOT-LINK above. */
unsigned short __asm ESQ_BumpColorTowardTargets(register __d0 unsigned short c,
                                                register __a1 char *targets);

void ESQ_IncCopperListsTowardsTargets(void)
{
    char *a = ESQ_CopperStatusDigitsA;
    char *b = ESQ_CopperStatusDigitsB;
    char *t = WDISP_PaletteTriplesRBase;
    short off = 0;
    short k = 8;

    do {
        *(unsigned short *)(b + off) = *(unsigned short *)(a + off) =
            ESQ_BumpColorTowardTargets(*(unsigned short *)(a + off), t);
        t += 3;
        off += 4;
    } while (--k);

    k = 24;
    do {
        *(unsigned short *)(a + off) =
            ESQ_BumpColorTowardTargets(*(unsigned short *)(a + off), t);
        t += 3;
        off += 4;
    } while (--k);
}
