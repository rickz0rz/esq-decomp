/* RESTORES: ESQ_DecCopperListsPrimary
 * MODULE:   modules/groups/a/a/app2_p3.s
 * STATUS:   behavioural
 * DO-NOT-LINK: _ESQ_DecColorStep clobbers D2 and does not restore it. SAS/C
 *   treats D2 as callee-saved, so it neither keeps a value there across the
 *   call nor saves it in the prologue -- and D2 then leaks out to whoever
 *   called this function. The original's MOVEM.L D2-D5/A2-A3 covers exactly
 *   that: it saves D2 and D3, which its own body never touches.
 *
 * Same shape as esq_dec_copper_lists_alt_skip_index4.c, with two loops
 * instead of one and no skip test. The second loop continues from where the
 * first left off: the byte offset is one variable across both, which is why
 * it is written as one `off` rather than reset per loop.
 *
 * 72 bytes against 66, and every byte is accounted for:
 *   -2  the original loads a word zero with MOVE.W #0,D5 where we use MOVEQ.
 *   +4  two MOVEQ #0,D0 zero-extensions, one per call site, because the __asm
 *       prototype declares the argument in D0.
 *   +4  two BSR.W where the original has BSR.S. SAS/C 6.51 has no 8-bit call.
 * There is no BEQ.W here, so the fourth class in the sibling does not apply.
 *
 * See esq_dec_copper_lists_alt_skip_index4.c for the full write-ups.
 */
extern char ESQ_CopperStatusDigitsA[];
extern char ESQ_CopperStatusDigitsB[];

/* Register-argument helper: the colour arrives in D0 and comes back in D0.
 * It also destroys D1 and D2 -- see DO-NOT-LINK above. */
unsigned short __asm ESQ_DecColorStep(register __d0 unsigned short colour);

void ESQ_DecCopperListsPrimary(void)
{
    char *a = ESQ_CopperStatusDigitsA;
    char *b = ESQ_CopperStatusDigitsB;
    short off = 0;
    short k = 8;

    do {
        *(unsigned short *)(b + off) = *(unsigned short *)(a + off) =
            ESQ_DecColorStep(*(unsigned short *)(a + off));
        off += 4;
    } while (--k);

    k = 24;
    do {
        *(unsigned short *)(a + off) =
            ESQ_DecColorStep(*(unsigned short *)(a + off));
        off += 4;
    } while (--k);
}
