/* RESTORES: ESQSHARED4_BlitBannerRowsForActiveField,
 *           ESQSHARED4_CopyInterleavedRowWordsFromOffset,
 *           ESQSHARED4_CopyBannerRowsWithByteOffset,
 *           ESQSHARED4_LoadCopperColorWordsFromNibbleTable
 * MODULE:   modules/groups/a/q/esqshared4_p4.s
 * STATUS:   behavioural
 *
 * DO-NOT-LINK: corrupts the grid time banner. The slot labels "7:30 PM",
 * "8:00 PM" and "8:30 PM" render with horizontal colour streaks through the
 * glyphs, while the live clock beside them, the date row and the standby banner
 * all stay clean. Bisected on 2026-08-03 against the 795-entry manifest:
 *
 *     795 entries                              STREAKED
 *     794, this file removed                   CLEAN
 *     794, esqshared4_bind_and_clear removed   STREAKED
 *     793, both removed                        CLEAN
 *     pure assembly with ESQ_FARCALLS=1        CLEAN
 *     ESQ.known-good-36cf56ed                  CLEAN
 *
 * So it is this file, it is not the far-call rewrite, and it is not a defect in
 * the original. The last two controls matter: the ESC-menu grey turned out to be
 * original behaviour, and this one was checked the same way before being blamed
 * on the reconstruction.
 *
 * THE CAUSE IS NOT YET FOUND, and the obvious candidates were checked and
 * cleared. Read this before re-deriving it:
 *
 *   - Both copy loops match the original's STRUCTURE exactly, counted from the
 *     encoding rather than by eye. CopyInterleavedRowWordsFromOffset: 51 MOVE.W
 *     = 17 groups of 3, 16 A1 steps, 15 A2 steps, tail source reloaded from the
 *     base. CopyBannerRowsWithByteOffset: 17 MOVE.W and 289 MOVE.L = 17 rows of
 *     one word plus 17 longs, 16 A1 steps, 15 A2 steps. The C reproduces all of
 *     those counts.
 *   - Source and destination are the right way round: the original writes
 *     `MOVE.W 6(A2),6(A1)` with A1 the destination, and copy_row_words(dst,src)
 *     is called as copy_row_words(dst, src).
 *   - The three scratch rasters are POINTERS and are read as pointers, matching
 *     `LEA sym,A1 / MOVEA.L (A1),A0`. The copper lists are arrays and are passed
 *     as addresses, matching `LEA sym,A0`.
 *   - LoadCopperColorWordsFromNibbleTable really IS dead. Its only caller is the
 *     unlabelled block at the head of esqshared4_p5.s, reachable only by
 *     fall-through from _ESQSHARED4_LoadDefaultPaletteToCopper_NoOp, which is a
 *     bare RTS. Verified in the source, not assumed.
 *   - The caller, _ESQSHARED4_TickCopperAndBannerTransitions, restores
 *     D0-D3/A0-A6 from its own entry MOVEM immediately after the call, so the
 *     dropped `MOVEM.L D0/A0-A1` is not the cause either.
 *
 * The streaks are horizontal COLOUR bands, which is a copper-list symptom rather
 * than a bitmap one. That points at CopyInterleavedRowWordsFromOffset, whose
 * whole job is writing copper colour words. Next step: dump
 * ESQ_CopperListBannerA before and after one call under both builds and diff.
 *
 * The whole module in one file, because a C replacement substitutes for a whole
 * module and these four labels share it.
 *
 * WHY THE REGISTER-ARGUMENT BLOCKER DOES NOT APPLY HERE.
 * coverage.py screens the first three as `register-args`, and that screen is
 * about the ORIGINAL's convention, not about C. The base pointer arrives in A0
 * and the two copy helpers are called from BlitBannerRowsForActiveField and
 * from nowhere else in the program -- checked with a whole-tree grep. Both
 * caller and callee land in this file, so the convention between them is ours
 * to choose and an ordinary C parameter carries it.
 *
 * The one EXTERNAL entry is ESQSHARED4_BlitBannerRowsForActiveField, called
 * once from esqshared4_p3_p0.s. It takes no arguments. Its `MOVEM.L D0/A0-A1`
 * is callee-save for an assembly caller, and that caller restores D0-D3/A0-A6
 * from its own entry MOVEM immediately after the call, so nothing depends on
 * this function preserving them. A plain C signature is safe while that caller
 * is still assembly.
 *
 * LoadCopperColorWordsFromNibbleTable IS still register-argument, so it keeps
 * the convention through __asm. Its only caller is the unlabelled block at the
 * head of esqshared4_p5.s, and that block is UNREACHABLE: the function before
 * it, _ESQSHARED4_LoadDefaultPaletteToCopper_NoOp, is a bare RTS, and no label
 * points into the block. So this function is dead code in the shipped program.
 * It is restored anyway, and with the original's register convention, so that
 * the dead caller stays correct rather than merely unexecuted.
 *
 * The decode of an RGB nibble triplet is INLINED rather than called.
 * _ESQSHARED4_DecodeRgbNibbleTriplet clobbers D2 and does not restore it, and
 * SAS/C assumes D2 survives a call, so calling it from C would leak a damaged
 * D2 to whoever called us. Inlining removes the hazard and the dependency.
 *
 * Loop counts are taken from the encoding, not by eye. The two copy routines
 * are fully unrolled in the original:
 *   CopyInterleavedRowWordsFromOffset  17 three-word groups, 16 A1 steps,
 *                                      16 A2 steps
 *   CopyBannerRowsWithByteOffset       17 rows of 1 word + 17 longs (70 bytes),
 *                                      16 A1 steps, 15 A2 steps
 * Both are a first group, then 15 stepped groups, then a tail group whose
 * source restarts from the base plus a separate offset.
 *
 * SASC-MISMATCH: unrolled-copy-written-as-a-loop
 *   summary: the original emits every iteration in line. A C `for` emits one
 *            body and a DBF, so this is far smaller and not byte-comparable.
 *            The original is hand-written assembly -- 89 and 341 instructions
 *            with no loop -- which AGENTS.md records as the sign of a routine
 *            that was never compiled from C.
 *   retest:  nothing to retest. A compiler will not unroll to this shape.
 */
#include <exec/types.h>

extern long ESQSHARED4_InterleaveCopyBaseOffset;
extern long ESQSHARED4_InterleaveCopyTailOffsetCurrent;
extern long ESQPARS2_BannerCopySourceOffset;
extern long ESQPARS2_BannerCopyTailOffset;
extern long ESQSHARED_BlitAddressOffset;
extern long GCOMMAND_BannerRowByteOffsetCurrent;
extern long ESQPARS2_BannerRowCopySpanBytes;
extern long ESQPARS2_BannerRowCopyStrideBytes;
extern long ESQPARS2_ActiveCopperListSelectFlag;

extern UBYTE ESQ_CopperListBannerA[];
extern UBYTE ESQ_CopperListBannerB[];

/* Each holds a POINTER to a scratch raster. The original reads it as
 * LEA sym,A1 / MOVEA.L (A1),A0, which is the value at sym, not sym itself. */
extern UBYTE *ESQSHARED_BannerRowScratchRasterBase0;
extern UBYTE *ESQSHARED_BannerRowScratchRasterBase1;
extern UBYTE *ESQSHARED_BannerRowScratchRasterBase2;

extern UWORD ESQ_BannerColorSweepProgramA;
extern UWORD ESQ_BannerColorSweepProgramB;
extern UWORD ESQ_BannerColorSweepProgramA_AnchorColorWord;
extern UWORD ESQ_BannerColorSweepProgramB_AnchorColorWord;
extern UWORD ESQ_BannerColorSweepProgramA_TailColorWord;
extern UWORD ESQ_BannerColorSweepProgramB_TailColorWord;

#define ROW_STEP        0x20        /* interleaved row stride */
#define FIRST_SRC_STEP  0x20        /* source starts one row past the destination */
#define BANNER_SRC_STEP 0xb0        /* banner source starts 0xb0 past the destination */
#define STEPPED_GROUPS  15          /* groups between the first one and the tail */

/* Copy the three words a copper row carries, at +6, +10 and +14. */
static void copy_row_words(UBYTE *dst, UBYTE *src)
{
    *(UWORD *)(dst + 6)  = *(UWORD *)(src + 6);
    *(UWORD *)(dst + 10) = *(UWORD *)(src + 10);
    *(UWORD *)(dst + 14) = *(UWORD *)(src + 14);
}

void ESQSHARED4_CopyInterleavedRowWordsFromOffset(UBYTE *base)
{
    UBYTE *dst = base + ESQSHARED4_InterleaveCopyBaseOffset;
    UBYTE *src = dst + FIRST_SRC_STEP;
    short i;

    copy_row_words(dst, src);
    for (i = 0; i < STEPPED_GROUPS; i++) {
        dst += ROW_STEP;
        src += ROW_STEP;
        copy_row_words(dst, src);
    }

    dst += ROW_STEP;
    src = base + ESQSHARED4_InterleaveCopyTailOffsetCurrent;
    copy_row_words(dst, src);
}

/* One banner row: a word then 17 longs, both pointers post-incrementing. */
static void copy_banner_row(UBYTE **dstp, UBYTE **srcp)
{
    UWORD *d = (UWORD *)*dstp;
    UWORD *s = (UWORD *)*srcp;
    ULONG *dl;
    ULONG *sl;
    short i;

    *d++ = *s++;
    dl = (ULONG *)d;
    sl = (ULONG *)s;
    for (i = 0; i < 17; i++)
        *dl++ = *sl++;

    *dstp = (UBYTE *)dl;
    *srcp = (UBYTE *)sl;
}

void ESQSHARED4_CopyBannerRowsWithByteOffset(UBYTE *base)
{
    UBYTE *dst = base + ESQPARS2_BannerCopySourceOffset;
    UBYTE *src = dst + BANNER_SRC_STEP;
    short i;

    copy_banner_row(&dst, &src);
    for (i = 0; i < STEPPED_GROUPS; i++) {
        dst += ESQSHARED_BlitAddressOffset;
        src += ESQSHARED_BlitAddressOffset;
        copy_banner_row(&dst, &src);
    }

    dst += ESQSHARED_BlitAddressOffset;
    src = base + (GCOMMAND_BannerRowByteOffsetCurrent + ESQPARS2_BannerCopyTailOffset);
    copy_banner_row(&dst, &src);
}

void ESQSHARED4_BlitBannerRowsForActiveField(void)
{
    long span = ESQPARS2_BannerRowCopySpanBytes;
    long stride = ESQPARS2_BannerRowCopyStrideBytes;
    UBYTE *list;

    if (ESQPARS2_ActiveCopperListSelectFlag == 0) {
        stride += 0x58;
        list = ESQ_CopperListBannerA;
    } else {
        list = ESQ_CopperListBannerB;
    }

    ESQPARS2_BannerCopyTailOffset = stride;
    ESQPARS2_BannerCopySourceOffset = span + stride;

    ESQSHARED4_CopyInterleavedRowWordsFromOffset(list);
    ESQSHARED4_CopyBannerRowsWithByteOffset(ESQSHARED_BannerRowScratchRasterBase0);
    ESQSHARED4_CopyBannerRowsWithByteOffset(ESQSHARED_BannerRowScratchRasterBase1);
    ESQSHARED4_CopyBannerRowsWithByteOffset(ESQSHARED_BannerRowScratchRasterBase2);
}

/* Dead in the shipped program -- see the header. Keeps the original's register
 * convention so the unreachable caller in esqshared4_p5.s stays correct.
 * slot steps 0, 4, 8 ... 28 and selects where each decoded colour word goes. */
void __asm ESQSHARED4_LoadCopperColorWordsFromNibbleTable(
        register __d3 short slot,
        register __a1 UBYTE *nibbles,
        register __a2 UBYTE *listA,
        register __a3 UBYTE *listB)
{
    short i;

    for (i = 0; i < 8; i++) {
        UWORD r = (UWORD)(nibbles[0] & 15);
        UWORD g = (UWORD)(nibbles[1] & 15);
        UWORD b = (UWORD)(nibbles[2] & 15);
        UWORD colour = (UWORD)(b + (g << 4) + (r << 8));

        nibbles += 3;

        if (slot == 4) {
            ESQ_BannerColorSweepProgramA = colour;
            ESQ_BannerColorSweepProgramB = colour;
            ESQ_BannerColorSweepProgramA_AnchorColorWord = colour;
            ESQ_BannerColorSweepProgramB_AnchorColorWord = colour;
        } else if (slot == 0x1c) {
            ESQ_BannerColorSweepProgramA_TailColorWord = colour;
            ESQ_BannerColorSweepProgramB_TailColorWord = colour;
        } else {
            *(UWORD *)(listA + slot) = colour;
            *(UWORD *)(listB + slot) = colour;
        }

        slot += 4;
    }
}
