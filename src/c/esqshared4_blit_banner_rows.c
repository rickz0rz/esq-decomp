/* RESTORES: ESQSHARED4_BlitBannerRowsForActiveField,
 *           ESQSHARED4_CopyInterleavedRowWordsFromOffset,
 *           ESQSHARED4_CopyBannerRowsWithByteOffset,
 *           ESQSHARED4_LoadCopperColorWordsFromNibbleTable
 * MODULE:   modules/groups/a/q/esqshared4_p4.s
 * STATUS:   behavioural
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
