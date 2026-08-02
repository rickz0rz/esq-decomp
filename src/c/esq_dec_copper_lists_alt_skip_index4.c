/* RESTORES: ESQ_DecCopperListsAltSkipIndex4
 * MODULE:   modules/groups/a/a/app2_p3_p1.s   (the header said app2_p3.s and was wrong)
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
 * This block is dead code: nothing calls it. It also carried no label until
 * 2026-07-30, which made the preceding 2-byte ESQ_NoOp_006A read as 58 bytes.
 *
 * 56 bytes against 56, in FOUR regions, and the four cancel exactly. Two are
 * the original spending bytes we cannot spend, two are us spending bytes it
 * did not.
 *
 * SASC-MISMATCH: unoptimised-immediate-and-branch
 *   ref:     3a3c0000 ... 67000010      MOVE.W #0,D5 / BEQ.W (+16)
 *   got:     7e00     ... 6712          MOVEQ #0,D7  / BEQ.S (+18)
 *   summary: -4 bytes to us. The original loads a word zero with a 4-byte
 *            immediate move where MOVEQ would do, and takes a 4-byte BEQ.W
 *            for a forward jump of 16 bytes that fits an 8-bit displacement.
 *            Both are the same operation. Together with the MOVE.B #0,D0 in
 *            esq_clear_copper_list_flags.c and the two registers saved for
 *            the callee's benefit, this reads as a code generator that does
 *            not run the peephole pass 6.51 runs.
 *   tried:   nothing in the source reaches either choice.
 *   scope:   the whole copper-list family, and the MOVE.W #0 form appears
 *            wherever the original zeroes a word.
 *   retest:  worth re-running the moment another SAS/C or Lattice version is
 *            available. This is one of the sharper version fingerprints in
 *            the program.
 *
 * SASC-MISMATCH: register-argument-widening
 *   ref:     30325000                MOVE.W 0(A2,D5.W),D0
 *   got:     7000 30357000           MOVEQ #0,D0 / MOVE.W 0(A5,D7.W),D0
 *   summary: +2 bytes. SAS/C zero-extends the value into the full D0 before
 *            the call, because the __asm prototype declares the argument in
 *            D0 and it will not leave the upper half undefined. The callee
 *            reads the low word only, so the extra MOVEQ changes nothing.
 *   tried:   a signed `short` argument gives EXT.L instead, the same 2 bytes.
 *
 * SASC-MISMATCH: external-call-width
 *   ref:     6114        BSR.S
 *   got:     61000000    BSR.W
 *   summary: +2 bytes. SAS/C 6.51 has no 8-bit call form.
 */
extern char ESQ_BannerPaletteWordsA[];
extern char ESQ_BannerPaletteWordsB[];

/* Register-argument helper: the colour arrives in D0 and comes back in D0.
 * The ASSEMBLY callee destroyed D1 and D2; the C one does not -- see above. */
unsigned short __asm ESQ_DecColorStep(register __d0 unsigned short colour);

void ESQ_DecCopperListsAltSkipIndex4(void)
{
    char *a = ESQ_BannerPaletteWordsA;
    char *b = ESQ_BannerPaletteWordsB;
    short off = 0;
    short k = 8;

    do {
        if (off != 4)
            *(unsigned short *)(b + off) = *(unsigned short *)(a + off) =
                ESQ_DecColorStep(*(unsigned short *)(a + off));
        off += 4;
    } while (--k);
}
