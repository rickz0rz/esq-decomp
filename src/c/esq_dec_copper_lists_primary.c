/* RESTORES: ESQ_DecCopperListsPrimary
 * MODULE:   modules/groups/a/a/app2_p3.s
 * STATUS:   behavioural
 * LINKABLE SINCE 2026-08-01. The marker that used to sit here said
 *   _ESQ_DecColorStep clobbers D2 and does not restore it, so SAS/C's assumption
 *   that D2 survives a call was false and this caller would leak a corrupted D2
 *   to whoever called IT. That was true of the ASSEMBLY callee.
 *
 *   That callee is now C, declared `__asm register __d0` so the assembly callers
 *   it also has keep working. A C function that uses D2 SAVES D2, so the
 *   assumption became true and the hazard went away by itself. Verified in the
 *   emitted object: the restoration saves D4-D7, which it uses as scratch, and
 *   never touches D2 or D3.
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
 * The ASSEMBLY callee destroyed D1 and D2; the C one does not -- see above. */
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
